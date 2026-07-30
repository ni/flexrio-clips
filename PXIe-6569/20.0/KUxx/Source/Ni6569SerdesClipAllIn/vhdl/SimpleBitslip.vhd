-------------------------------------------------------------------------------
--
-- File: SimpleBitSlip.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 23 Dec 2020
--
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
--
-- Purpose: Xilinx Ultrascale SERDES devices do not provide the means of
--          natively bitslipping the incoming data in the hard SERDES IP as
--          was the case for Virtex-5 FPGAs. This file creates simple logic
--          in the FPGA fabric to provide the bitslipping capability in
--          Ultrascale FPGA devices.
--
--  cDataIn   : The raw data from the SERDES block.
--
--  cDataOut  : Result of the bitslipped data.
--
--  cBitslip  : Assert to start shifting the data by one bit per clock cycle.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;

entity SimpleBitSlip is
    generic (
    kDataWidth : integer := 8
  );
  port (
    -- Clocks and Reset
    aReset  : in std_logic;
    Clk     : in std_logic;

    --Data from the SERDES hard IP block
    cDataIn  : in std_logic_vector(kDataWidth-1 downto 0);

    --Deserialized bitslipped output data
    cDataOut : out std_logic_vector(kDataWidth-1 downto 0);

    cBitslip : in boolean

  );
end SimpleBitSlip;

architecture RTL of SimpleBitSlip is

  --vhook_sigstart
  signal acReset: boolean;
  --vhook_sigend

  signal cDataReg   : std_logic_vector(2*kDataWidth-1 downto 0);
  signal cPointer   : unsigned(Log2(kDataWidth) downto 0);
  signal cDataOutLcl: std_logic_vector(2*kDataWidth-1 downto 0);

begin  -- RTL

  cDataOut         <= cDataOutLcl(kDataWidth-1 downto 0);

  --vhook_e ResetSyncDeassert ClkRSD
  --vhook_a aReset            to_Boolean(aReset)
  --vhook_a acReset           acReset
  ClkRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => Clk,                 --in  std_logic
      aReset  => to_Boolean(aReset),  --in  boolean
      acReset => acReset);            --out boolean

  -- Storing 2 succesive bytes of raw data into a shift register.
  IncomingData : process (acReset, Clk)
  begin
    if acReset then
      cDataReg          <= (others => '0');
    elsif rising_edge(Clk) then
      cDataReg(2*kDataWidth-1 downto kDataWidth) <= cDataIn;
      cDataReg(kDataWidth-1 downto 0) <= cDataReg(2*kDataWidth-1 downto kDataWidth);
    end if;
  end process;

  OutgoingData : process (acReset, Clk)
  begin
    if acReset then
      cDataOutLcl    <= (others => '0');
      cPointer <= (others => '0');
    elsif rising_edge(Clk) then
      -- Output shifted data from the shift register according to the current bitslip position.
      cDataOutLcl   <= std_logic_vector(shift_right(unsigned(cDataReg), to_integer(cPointer)));

      -- The bitslip pointer keeps track of the bitslip position.
      if cBitslip then
        if cPointer >= kDataWidth-1 then
          cPointer <= (others => '0');
        else
          cPointer <= cPointer + 1;
        end if;
      end if;
    end if;
  end process;


end RTL;

