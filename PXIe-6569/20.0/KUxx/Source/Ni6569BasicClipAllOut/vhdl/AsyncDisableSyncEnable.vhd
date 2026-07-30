----------------------------------------------------------------------------
--
-- File: AsyncDisableSyncEnable.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 21 April 2021
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
--   This module can be used to asynchronously disable / synchronously enable
--   a clock buffer. The enable can be checked with Static Timing Analysis using
--   Reset Recovery/Removal checks to allow for glitch-free clock enabling.
--
--   ASSUMPTIONS:
--       aDisable is driven asserted any time when Clk is potentially misbehaving.
--       Examples of this would be during PLL locking, glitchy muxing, power
--       up.
--
----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity AsyncDisableSyncEnable is
  port (
    Clk      : in  std_logic;
    aDisable : in  boolean;
    acEnable : out boolean
  );
end AsyncDisableSyncEnable;

architecture rtl of AsyncDisableSyncEnable is

  --vhook_sigstart
  signal acDisableSrc: boolean;
  --vhook_sigend

begin

  -- This module instantiates DoubleSyncBoolAsyncIn instead of inferring flops because
  -- the DFlopAsync component has attributes for Vivado that relate to metastability.

  --vhook_e DoubleSyncBoolAsyncIn
  --vhook_a kResetVal true
  --vhook_a aSig false
  --vhook_a aoReset aDisable
  --vhook_a OClk Clk
  --vhook_a oSig acDisableSrc
  DoubleSyncBoolAsyncInx: entity work.DoubleSyncBoolAsyncIn (rtl)
    generic map (kResetVal => true)  --boolean:=false
    port map (
      aSig    => false,         --in  boolean
      aoReset => aDisable,      --in  boolean
      OClk    => Clk,           --in  std_logic
      oSig    => acDisableSrc); --out boolean

  -- This flop can be inferred. Its data path is completely synchronous and it doesn't
  -- need a clock enable. By inferring it (and not instantiating DFlop) we have more
  -- flexibility with some synthesizers (Vivado) that would not be able to replicate
  -- the flop at synthesis time otherwise.
  acResetProc: process(Clk, acDisableSrc)
  begin
    if acDisableSrc then
      acEnable <= false;
    elsif rising_edge(Clk) then
      acEnable <= true;
    end if;
  end process; -- acResetProc

end rtl;
