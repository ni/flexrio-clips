-------------------------------------------------------------------------------
--
-- File: GetMinDelayLimit.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 11 Aug 2020
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
--   To set the upper and lower limit values of the IODELAY component.
--
--   In Ultrascale, the IODELAY is a wraparound delay element.
--   When the maximum of the delay element is reached (tap 511), a subsequent
--   increment function will return to tap 0.  The same applies to the decrement
--   function that decrementing below zero will move to tap 511.
--
--   This module overrides the Ultrascale FPGA IODELAY wrap around behavior.
--   It sets the minimum delay value to Align_Delay (Refer to XILINX documentation
--   for details) and the maximum delay value to 511.
--
-- Procedure:
--    The procedure to update delay line is as per Xilinx documentation UG571
--    recommendation.
--    1. Wait for IDELAYCTRL.RDY to go High. (Be done in UpperLowerDelayLimit.vhd)
--    2. Make EN_VTC Low to modify the delay line. (Be done in UpperLowerDelayLimit.vhd)
--    3. Wait for at least 10 clock cycles.
--    4. Read CNTVALUEOUT[8:0] and load the value into a register.
--    5. Wait a minimum of 10 clock cycles.
--    6. Assert the EN_VTC pin.
--
-------------------------------------------------------------------------------


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNi6569.all;

entity GetMinDelayLimit is
  port (
    Clk                      : in std_logic;
    aReset                   : in boolean;
    cGetMinimumDelayLimit    : in boolean;
    cCntValFromIdelay        : in std_logic_vector(kDelayCntValSize-1 downto 0);
    cSetLowLimitDone         : out std_logic;
    cAlignDelayValue         : out std_logic_vector(kDelayCntValSize-1 downto 0)
  );
end GetMinDelayLimit;

architecture rtl of GetMinDelayLimit is
  type SetMinimumCountState_t is (Idle, SetMinCntValue, EnVtcWaitCycles1, EnVtcWaitCycles2, SetLowLimitComplete);
  signal cCurrentSetMinimumCountState  : SetMinimumCountState_t;
  constant kWait                       : natural := 15;
  signal cWaitCount                    : natural range 0 to kWait := kWait;
begin
  process (aReset, Clk)
  begin
    if (aReset) then
      cCurrentSetMinimumCountState <= Idle;
      cWaitCount <= kWait;
      cSetLowLimitDone <= '0';
      cAlignDelayValue <= (others => '0');
    elsif (rising_edge(Clk)) then
      case cCurrentSetMinimumCountState is
        -- !STATE MACHINE STARTUP! This state machine cannot start immediately after
        -- aReset deasserts because cGetMinimumDelayLimit won't be asserted.
        when Idle =>
          -- The Idle state waits on cGetMinimumDelayLimit to assert from the from the
          -- UpperLowerDelayLimit module. The assertion of cGetMinimumDelayLimit only
          -- takes place after EN_VTC is de-asserted.
          if cGetMinimumDelayLimit then
            cWaitCount <= kWait;
            cCurrentSetMinimumCountState <= EnVtcWaitCycles1;
          end if;
        when EnVtcWaitCycles1 =>
          -- This EnVtcWaitCycles1 state waits for more than 10 clock cycles
          -- before reading CNTVALUEOUT as required by the XILINX documentation
          if cWaitCount = 0 then
            cCurrentSetMinimumCountState <= SetMinCntValue;
          else
            cWaitCount <= cWaitCount - 1;
          end if;
        when SetMinCntValue =>
          -- This SetMinCntValue state reads the CNTVALUEOUT to set the minimum
          -- delay limit (ALIGN_DELAY) of the IODLEAY element
          cAlignDelayValue <= cCntValFromIdelay;
          cWaitCount <= kWait;
          cCurrentSetMinimumCountState <= EnVtcWaitCycles2;
        when EnVtcWaitCycles2 =>
          -- The  EnVtcWaitCycles2 state waits for more than 10 clock cycles before
          -- signaling cSetLowLimitDone to the UpperLowerDelayLimit module so that
          -- this latter can assert EN_VTC.
          if cWaitCount = 0 then
            cCurrentSetMinimumCountState <= SetLowLimitComplete;
          else
            cWaitCount <= cWaitCount - 1;
          end if;
        when SetLowLimitComplete =>
          -- This state asserts cSetLowLimitDone to the UpperLowerDelayLimit module
          -- signaling that the minimum delay limit (ALIGN_DELAY) has been set.
          cSetLowLimitDone <= '1';
        end case;
      end if;
  end process;
end rtl;

