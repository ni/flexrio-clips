------------------------------------------------------------------------------------------
--
-- File: Axi4LiteCore
-- Author: NI
-- Original Project: NI6569
-- Date: 14 December 2017
--
------------------------------------------------------------------------------------------
-- Copyright © 2021 National Instruments Corporation.
--
-- You may only modify and distribute this file as expressly permitted in the
-- Software License Agreement provided with this software.  Without limiting
-- any of the provisions in that license agreement, you may only distribute
-- modified versions of this file to end-users who you have verified have a
-- valid license to the NI FlexRIO software, and you restrict from using the
-- file for any purpose other than the customization of the FPGA functionality
-- of NI FPGA-enabled hardware or hardware targets specifically designated by
-- NI in writing.
------------------------------------------------------------------------------------------
--
-- Purpose:
--
-- This file contains an AXI 4 lite state machine to make generating AXI
-- registers easier. The output is an "SRegPort" interface. More information on this
-- interface is provided in PkgSRegPort.
--
-- Considerations :
--
-- 1. This module does not accept multiple outstanding transactions. What this means is
--    that the host needs to wait until a given transaction (whether write or read) has
--    been responded to before issuing a new transaction. This is a requirement that is
--    satisfied by the Microblaze, but may not be satisfied by other bus masters. UG984
--    (v2015.4, pg 131) says "The MicroBlaze AXI4 memory mapped peripheral interfaces are
--    implemented as 32-bit masters. Each of these interfaces only have a single
--    outstanding transaction at any time, and all transactions are completed in order."
--
-- 2. It's assumed that all bytes in a data word are valid in a given write, so the WSTRB
--    signal is completely ignored.
--
-- 3. The PROT signals are also ignored.
--
-- 4. This module will always return a RESP value of "OK" (i.e. 0x0), for both reads and
--    writes. Because the output interface has no acknowledge, we can't know if an access
--    failed or succeeded, so all accesses are treated as successful.
--
-- 5. The module downstream from this one will not implement any read side-effects, which
--    are prohibited by the SRegPort protocol.
--
--
------------------------------------------------------------------------------------------
--
-- vreview_group Axi4Lite_Core
-- vreview_closed http://review-board.natinst.com/r/223241/
-- vreview_reviewers kygreen dhearn rortega privera jgorman
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgAxi4Lite.all;
use work.PkgSRegPort.all;

entity Axi4LiteCore is
  generic (
    -- Microblaze masters usually assign 4k (12 bits) of address space per Axi4Lite
    -- interface, despite the address signal being nominally 32 bits. This generic can be
    -- used to cut down on resources by ignoring everything but the lower
    -- kAddressSpaceLog2 bits. You need to ensure that the master will not issue accesses
    -- outside the kAddressSpaceLog2 window, or aliasing will occur.
    kAddressSpaceLog2 : positive := 12);
  port (
    -------------------------------------------------------------------------------------
    -- BusClk and Resets
    -------------------------------------------------------------------------------------
    -- Both asynchronous and synchronous resets are provided, but the only supported use
    -- case is using one of the two resets and setting the other one to a constant. Also
    -- note the difference in polarity.
    aAxiPeriphReset          : in  std_logic;
    bAxiPeriphReset_n        : in  std_logic;
    BusClk                   : in  std_logic;
    -------------------------------------------------------------------------------------
    -- Axi Write Channels
    -------------------------------------------------------------------------------------
    --Axi Write Address Channel
    bAxiWriteAddressChannel  : in  Axi4LiteAddressChannel_t;
    bAxiWriteAddressReady    : out boolean;
    --Axi Write Data Channel
    bAxiWriteDataChannel     : in  Axi4LiteWriteDataChannel_t;
    bAxiWriteDataReady       : out boolean;
    --Axi Response Channel
    bAxiWriteResponseChannel : out Axi4LiteWriteResponseChannel_t;
    bAxiWriteResponseReady   : in  boolean;
    -------------------------------------------------------------------------------------
    -- Axi Read Channels
    -------------------------------------------------------------------------------------
    --Axi Read Address Channel
    bAxiReadAddressChannel   : in  Axi4LiteAddressChannel_t;
    bAxiReadAddressReady     : out boolean;
    --Axi Read Data Channel
    bAxiReadDataChannel      : out Axi4LiteReadDataChannel_t;
    bAxiReadDataReady        : in  boolean;
    -------------------------------------------------------------------------------------
    -- SRegPort
    -------------------------------------------------------------------------------------
    bSRegPortIn              : out SRegPortIn_t;
    bSRegPortOut             : in  SRegPortOut_t
    );
end entity Axi4LiteCore;


architecture rtl of Axi4LiteCore is

  -- Boolean Resets
  signal bAxiReset, aAxiReset : boolean := false;

  --Generate a mask based on the address space of the slave.
  constant kMbAddressMask : Axi4LiteAddr_t :=
    unsigned(Zeros(Axi4LiteAddr_t'length - kAddressSpaceLog2))
    & unsigned(Ones(kAddressSpaceLog2));

  -- Local Ready / Control signals
  signal bWtReadyLcl, bNxWtReadyLcl         : boolean := false;
  signal bWtRespValidLcl, bNxWtRespValidLcl : boolean := false;

  signal bRdReadyLcl, bNxRdReadyLcl         : boolean := false;
  signal bRdDataValidLcl, bNxRdDataValidLcl : boolean := false;


begin

  -- Boolean Resets
  bAxiReset <= to_BooleanActiveLow(bAxiPeriphReset_n);
  aAxiReset <= to_Boolean(aAxiPeriphReset);

  ---------------------------------------------------------------------------------------
  -- Write
  ---------------------------------------------------------------------------------------
  -- This slave is ready to accept data for the first clock cycle in which there is a
  -- valid write address and valid write data on the Write Address and Write Data buses,
  -- respectively. This Ready signal is effectively a rising-edge detector on both channel
  -- valid signals, which will only work if (as required) there are no back-to-back
  -- transactions.
  bNxWtReadyLcl <= not bWtReadyLcl and
                   (bAxiWriteDataChannel.Valid and bAxiWriteAddressChannel.Valid);

  -- The following diagram illustrates how we go from an Axi4Lite write to a SRegPort
  -- write. The worst case is actually when both the Address Channel and Data Channel
  -- become valid at the same time, so that's what we illustrate.
  --
  --  0. Clk                            __/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\____
  --  1. bAxiWriteAddressChannel.Addr   XXXXXXXXXXX<-Addr---------->XXXXXXXXXXXXXXX
  --  2. bAxiWriteAddressChannel.Valid  ___________/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\_______________
  --  3. bAxiWriteDataChannel.Data      XXXXXXXXXXX<-Data---------->XXXXXXXXXXXXXXX
  --  4. bAxiWriteDataChannel.Valid     ___________/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\_______________
  --  5. bNxWtReadyLcl                  ___________/¯¯¯¯¯¯¯\_______________________
  --  6. bWtReadyLcl                    ___________________/¯¯¯¯¯¯¯\_______________
  --  7. bSRegPortIn.WtAddress          XXXXXXXXXXX<-Addr---------->XXXXXXXXXXXXXXX
  --  8. bSRegPortIn.WtData             XXXXXXXXXXX<-Data---------->XXXXXXXXXXXXXXX
  --  9. bSRegPortIn.WtEn               ___________________/¯¯¯¯¯¯¯\_______________
  --                                                            ^ Downstream module
  --                                                            latches data.
  -- 10. bAxiWriteResponseChannel.Valid ___________________________/¯¯¯¯¯¯¯\_______

  -- We will use bWtReadyLcl (6) as both bAxiWriteAddressReady and bAxiWriteDataReady.
  -- Note that we can do this even in the case where the two signals don't arrive at the
  -- same time, because bNxWtReadyLcl (5) is an edge-detector on the "and" of both
  -- signals.
  bAxiWriteAddressReady <= bWtReadyLcl;
  bAxiWriteDataReady    <= bWtReadyLcl;

  -- Because the address and data valids (2 and 3) must stay asserted, and their
  -- corresponding payloads valid, until bWtReadyLcl (6) asserts, we can directly pass
  -- both Data and Address through to bSRegPortIn.
  bSRegPortIn.WtData <= bAxiWriteDataChannel.Data;
  -- We will mask off the top bits of the address, though.
  bSRegPortIn.WtAddress <= bAxiWriteAddressChannel.Addr and kMbAddressMask;

  -- We also note that bWtReadyLcl can further be used as the WtEn signal. We could've
  -- saved a clock cycle of latency by using bNxWtReadyLcl directly to drive WtEn and the
  -- address/data readys. But we want our outputs to be the outputs of FFs. We assume that
  -- the signals we pass straight through are themselves the outputs of FFs.
  bSRegPortIn.WtEn <= bWtReadyLcl;

  -- We always respond with a value of RespOk, so we can assign that unconditionally.
  bAxiWriteResponseChannel.Resp <= kAxi4LiteRespOkay;

  -- The diagram shows bAxiWriteResponseChannel.Valid asserting the next clock cycle after
  -- bWtReadyLcl. We spend the extra clock cycle to allow the address/data Valids to
  -- deassert before finishing the write. This keeps an over-zealous Master from giving us
  -- back-to-back accesses.
  --
  -- We need to keep the Valid asserted until our response is acknowledged by the master
  -- via bAxiWriteResponseReady.
  bNxWtRespValidLcl <= (bWtRespValidLcl and not bAxiWriteResponseReady)
                       or bWtReadyLcl;
  bAxiWriteResponseChannel.Valid <= bWtRespValidLcl;

  WtFFs : process (BusClk, aAxiReset)
  begin  -- process WtFFs
    if aAxiReset then
      bWtReadyLcl     <= false;
      bWtRespValidLcl <= false;
    elsif rising_edge(BusClk) then

      if bAxiReset then
        bWtReadyLcl     <= false;
        bWtRespValidLcl <= false;
      else
        bWtReadyLcl     <= bNxWtReadyLcl;
        bWtRespValidLcl <= bNxWtRespValidLcl;
      end if;

    end if;
  end process WtFFs;

  ---------------------------------------------------------------------------------------
  -- Read
  ---------------------------------------------------------------------------------------
  -- This slave is ready to accept the read address for the first clock cycle in which
  -- there is a valid read address. This Ready signal is effectively a rising-edge
  -- detector on the valid signal, which will only work if (as required) there are no
  -- back-to-back read transactions.
  bNxRdReadyLcl <= not bRdReadyLcl and bAxiReadAddressChannel.Valid;

  -- The following diagram illustrates how we go from an Axi4Lite read to a SRegPort read.

  -- 0. Clk                           __/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\____
  -- 1. bAxiReadAddressChannel.Addr  XXXXXXXXXXXX<-Addr---------->XXXXXXXXXXXXXXX
  -- 2. bAxiReadAddressChannel.Valid ____________/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\_______________
  -- 3. bNxRdReadyLcl                ____________/¯¯¯¯¯¯¯\_______________________
  -- 4. bRdReadyLcl                  ____________________/¯¯¯¯¯¯¯\_______________
  -- 5. bAxiReadAddressReady         ____________________/¯¯¯¯¯¯¯\_______________
  --               bAxiReadAddressReady causes Valid to go low. ^
  -- 6. bSRegPortIn.WtAddress        XXXXXXXXXXXX<-Addr---------->XXXXXXXXXXXXXXX
  -- 7. bSRegPortOut                 XXXXXXXXXXXX<-Data---------->XXXXXXXXXXXXXXX
  --                                                            ^ Latch Data from slave.
  -- 8. bAxiReadDataChannel.Data     XXXXXXXXXXXXXXXXXXXXXXXXXXXX<-Data-->XXXXXXX
  -- 9. bAxiReadDataChannel.Valid    ____________________________/¯¯¯¯¯¯¯\_______

  -- We can use bRdReadyLcl (4) to acknowledge the Read Address by using it as the
  -- bAxiReadAddressReady (5) signal.
  bAxiReadAddressReady <= bRdReadyLcl;

  -- The Read Address (1) will not always be valid, but we can still pass it through
  -- directly to bSRegPortIn.WtAddress(6), since the SRegPort disallows read side-effects
  -- [Consideration 5]. All that matters is that it be valid for the two clock cycles
  -- preceding our latching of the downstream module's data, which is the clock cycle on
  -- which bRdReadyLcl (4) is true.
  --
  -- Because we use bRdReadyLcl to acknowledge the Address Valid (2), the master has to
  -- keep the address valid until the first clock edge in which bRdReadyLcl is true. And
  -- because we built bRdReadyLcl as a delayed rising-edge detector on the Address Valid,
  -- we know that the address will be kept valid by the master for the required two clock
  -- cycles. Before passing the address through, we'll lop off the top address bits.
  bSRegPortIn.RdAddress <= bAxiReadAddressChannel.Addr and kMbAddressMask;

  -- We always respond with a value of RespOk, so we can assign that unconditionally.
  bAxiReadDataChannel.Resp <= kAxi4LiteRespOkay;

  -- The diagram also shows that bAxiReadDataChannel.Valid needs to assert the next clock
  -- cycle after bRdReadyLcl. We need to keep the Valid (and the Data) asserted until our
  -- response is acknowledged by the master via bAxiReadDataReady.
  bNxRdDataValidLcl         <= (bRdDataValidLcl and not bAxiReadDataReady) or bRdReadyLcl;
  bAxiReadDataChannel.Valid <= bRdDataValidLcl;

  ReadFFs : process (BusClk, aAxiReset)
  begin  -- process ReadFFs
    if aAxiReset then
      bRdReadyLcl              <= false;
      bRdDataValidLcl          <= false;
      bAxiReadDataChannel.Data <= (others => '0');
    elsif rising_edge(BusClk) then

      if bAxiReset then
        bRdReadyLcl              <= false;
        bRdDataValidLcl          <= false;
        bAxiReadDataChannel.Data <= (others => '0');
      else
        bRdReadyLcl     <= bNxRdReadyLcl;
        bRdDataValidLcl <= bNxRdDataValidLcl;
        -- Only latch the data on the cycle in which bRdReadyLcl (4) is asserted. Keep old
        -- value otherwise.
        if bRdReadyLcl then
          bAxiReadDataChannel.Data <= bSRegPortOut;
        end if;

      end if;

    end if;
  end process ReadFFs;

end architecture rtl;
