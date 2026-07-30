----------------------------------------------------------------------------
--
-- File: ResetSyncDeassert.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 21 December 2011
--
----------------------------------------------------------------------------
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
----------------------------------------------------------------------------
--
-- Purpose:
--   This generates a Synchronous Deassert Reset that can be used to drive the
--   reset pin of all flops on the associated clock domain.  This reset can
--   then be checked with STA using Reset Recovery/Removal checks.
--
--   This reset holds for 2 to 3 clocks after reset is removed.
--
--   Reset duration can be extended externally, but it can't be shortened.  Hence
--   this component has the minimum duration.
--
--   Clk                  ____|----|____|----|____|----|____|----|___
--   aReset               ---------\_________________________________
--   cReset_ms            --------------\____________________________
--   acResetSrc           ------------------------\__________________
--   acReset              ----------------------------------\________
--                            | 0 to 1  |    1    |    1    |
--
--   ASSUMPTIONS:
--       aReset is driven asserted any time when Clk is potentially misbehaving.
--       Examples of this would be during PLL locking, glitchy muxing, power
--       up.
--
--       This circuit assumes metastability will settle adequately in 1 clock
--       cycle.  Note that MTBF receives a huge benefit from the fact that this
--       should only toggle once per power cycle. Nonetheless, the path from
--       the metastable FF to the output FF should be overconstrained.
--
--   Resets generally have a fairly high fanout, meaning that the output FF
--   is likely to be replicated. If the skew on the aReset arriving at the
--   output FFs approaches one Clk period, then the output FF can go
--   metastable. niWriteClkXingConstraints will write a skew constraint for
--   the asynchronous reset, but it could become hard to meet. Therefore this
--   component instantiates a third FF that is not reset by aReset, but rather
--   by the output of the second FF. This is a synchronous path that will
--   be checked with recovery and removal analysis, and also is decoupled
--   from aReset going to other RSD instances.
--
--   Note that there had previously been a separate component FpgaInitReset,
--   which generated a reset based on signal initialization and the ability
--   of FPGAs (not ASICs) to initialize every FF at configuration time. That
--   component has been depricated because ResetSyncDeassert does the same
--   thing. FpgaInitReset also included an aSwReset input, but this was tied
--   to the D input of the DoubleSync, and this is not likely the desired
--   behavior anyway.
--
-- vreview_group reset
-- vreview_closed http://review-board.natinst.com/r/232112/
-- vreview_closed http://review-board.natinst.com/r/112169/
-- vreview_closed http://review-board.natinst.com/r/111457/
-- vreview_closed http://review-board.natinst.com/r/90256/
-- vreview_closed http://review-board.natinst.com/r/90004/
-- vreview_closed http://review-board.natinst.com/r/79823/
--
----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity ResetSyncDeassert is
  port (
    Clk     : in  std_logic;
    aReset  : in  boolean;
    acReset : out boolean
  );
end ResetSyncDeassert;

architecture rtl of ResetSyncDeassert is

  --vhook_sigstart
  signal acResetSrc: boolean;
  --vhook_sigend

begin

  -- This module instantiates DoubleSyncBoolAsyncIn instead of inferring flops because
  -- the DFlopAsync component has attributes for Vivado that relate to metastability.

  --vhook_e DoubleSyncBoolAsyncIn
  --vhook_a kResetVal true
  --vhook_a aSig false
  --vhook_a aoReset aReset
  --vhook_a OClk Clk
  --vhook_a oSig acResetSrc
  DoubleSyncBoolAsyncInx: entity work.DoubleSyncBoolAsyncIn (rtl)
    generic map (kResetVal => true)  --boolean:=false
    port map (
      aSig    => false,       --in  boolean
      aoReset => aReset,      --in  boolean
      OClk    => Clk,         --in  std_logic
      oSig    => acResetSrc); --out boolean

  -- This flop can be inferred. Its data path is completely synchronous and it doesn't
  -- need a clock enable. By inferring it (and not instantiating DFlop) we have more
  -- flexibility with some synthesizers (Vivado) that would not be able to replicate
  -- the flop at synthesis time otherwise.
  acResetProc: process(Clk, acResetSrc)
  begin
    if acResetSrc then
      acReset <= true;
    elsif rising_edge(Clk) then
      acReset <= false;
    end if;
  end process; -- acResetProc

end rtl;
