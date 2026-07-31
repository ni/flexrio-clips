-------------------------------------------------------------------------------
--
-- File: FilterStdLogic.vhd
-- Date: 9 November 2010
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
-- Purpose:
--
-- This is a digital pulse filter that includes a double synchronizer. It requires that
-- the input be stable for kFilterLength+1 before the output will assert. If the input
-- ever reverts to its inactive (i.e. "not kFilterActiveValue") value, the output will
-- deassert and the count will start over again.
--
-- Said another way, this filter has a long reaction time to the Active value, but reacts
-- very quickly to the inactive value. This makes it very useful for filtering signals
-- that may glitch active, such as PllLocked signals.
--
-- Besides the minimum pulse length requirements, there's a latency element to this
-- module. The output may take up to 3 clocks to change after a pulse with sufficient
-- length has been provided.
--
---- Generics:
--
-- kFilterLength
-- The number of clock cycles that the input signal (aISig) must remain active in order
-- for the output (cOSig) to change to the active value. If aISig is not synchronous to
-- Clk, it may take a pulse of length kFilterLength+1 to propagate to the output.
--
-- kFilterActiveValue
-- The logic value that is considered "Active". If kFilterActiveValue is set to '1', cOSig
-- will reset to '0' and require aISig to be '1' for at least kFilterLength+1 cycles in
-- order for cOSig to output '1'.
--
---- Inputs:
--
-- aReset
-- (Optional) Asynchronous reset. All internal logic (including the double-synchronizer at
-- the input) asynchronously reverts to its initial state when aReset is set to '1'. cOSig
-- will reset to "not kFilterActiveValue". Tie to '0' if unused.
--
-- cReset
-- (Optional) Synchronous Reset. All internal logic (except for the double-synchrnoizer at
-- the input) will revert to its initial state upon cReset='1' being captured by Clk.
-- cOsig will reset to "not kFilterActiveValue". Tie to '0' if unused.
--
-- Clk
-- cReset and the output (cOSig) are synchronous to Clk. kFilterLength is given interms of
-- Clk's period.
--
-- aISig
-- Signal to be filtered. Does not need to be synchronous to Clk.
--
---- Outputs:
--
-- cOSig
-- Output filtered signal.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PkgNiUtilities.all;

entity FilterStdLogic is

  generic (
    kFilterLength      : natural;
    kFilterActiveValue : std_logic := '0'
    );
  port (
    aReset : in  std_logic;
    cReset : in  std_logic;
    Clk    : in  std_logic;
    aISig  : in  std_logic;
    cOSig  : out std_logic
    );

end FilterStdLogic;

architecture rtl of FilterStdLogic is

  -- Default value for most situations (including cReset='1') is for cOSigLcl to be set
  -- to the opposite of kFilterActiveValue.
  constant kResetVal        : std_logic := not kFilterActiveValue;
  signal cISigInt, cOSigLcl : std_logic := kResetVal;

  signal cFilterCount : natural range 0 to kFilterLength := kFilterLength;

  --vhook_sigstart
  --vhook_sigend

begin

  -- Always double sync the input. This ensures safe counter startup even if the input is
  -- Active coming out of reset.
  --vhook_e DoubleSyncSlAsyncIn
  --vhook_a aoReset     to_Boolean(aReset)
  --vhook_a OClk        Clk
  --vhook_a aSig        aISig
  --vhook_a oSig        cISigInt
  DoubleSyncSlAsyncInx: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => kResetVal)  --std_logic:='0'
    port map (
      aSig    => aISig,               --in  std_logic
      aoReset => to_Boolean(aReset),  --in  boolean
      OClk    => Clk,                 --in  std_logic
      oSig    => cISigInt);           --out std_logic

--Filter process
  process(aReset, Clk) is
  begin
    if aReset = '1' then
      cOSigLcl     <= kResetVal;
      cFilterCount <= kFilterLength;
    elsif rising_edge(Clk) then
      -- Default value for most situations (including cReset='1') is for cOSigLcl to be set
      -- to the opposite of kFilterActiveValue.
      cOSigLcl <= not kFilterActiveValue;

      if cReset = '1' then
        cFilterCount <= kFilterLength;
      else
        if cISigInt = kFilterActiveValue then
          if cFilterCount = 0 then
            cOSigLcl <= kFilterActiveValue;
          else
            cFilterCount <= cFilterCount-1;
          end if;
        else
          cFilterCount <= kFilterLength;
        end if;
      end if;
    end if;
  end process;

  cOSig <= cOSigLcl;
end rtl;
