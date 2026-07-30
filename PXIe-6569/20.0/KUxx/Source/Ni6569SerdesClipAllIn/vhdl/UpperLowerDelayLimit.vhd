-------------------------------------------------------------------------------
--
-- File: UpperLowerDelayLimit.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 10 Aug 2020
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
--   To set the upper and lower limits of the IODELAY delay values.
--
--   In Ultrascale FPGAs, the IODELAY is a wraparound delay element.
--   When the maximum value of the delay element is reached (tap 511), a subsequent
--   increment function will wrap the delay to tap 0.  Similarly, when the tap delay
--   value is at tap 0, a decrement operation will wrap the delay tap value to 511.
--
--   This entity prevents the warp around operation by setting the minimum
--   tap delay value to Align_Delay and preventing a decrement operation from
--   decrementing the delay any lower than Align_delay. Similarly, this entity will
--   prevent the delay from incrementing if the delay tap value has reached 511.
--
-- Procedure:
--    The procedure to update delay line is as per Xilinx documentation UG571
--    recommendation.  We are using TIME mode with VAR_LOAD to be able to read
--    the current count value CNTVALUEOUT, and INC/DEC method to update the
--    delay line.
--    1. Wait for IDELAYCTRL.RDY to go High.
--    2. Make EN_VTC Low to modify the delay line.
--    3. Wait for at least 10 clock cycles.
--    4. Read CNTVALUEOUT[8:0] and load the value into a register. (Input from GetMinDelayLimit.vhd)
--    5. Check if updating the delay line is necessary.
--    6. Use the CE and INC ports to increment or decrement the delay line.
--    7. Wait a minimum of 5 clock cycles.
--    8. (Option for multiple updates) Increment or decrement of the delay line needs to be
--    performed. Go to step 6, or else proceed to step 9.
--    9. Wait a minimum of 10 clock cycles.
--    10. Flag a ready signal (cIncDecReady) and display final adjusted delay value (cDisplayCountValue)
--        to user
--    11. Assert the EN_VTC pin.
--
-------------------------------------------------------------------------------


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNi6569.all;

entity UpperLowerDelayLimit is
  port (
    Clk                      : in std_logic;
    aReset                   : in boolean;
    cDelayCtrlRdy            : in boolean;
    cSetLowLimitDone         : in boolean;
    cMinDecTap               : in std_logic_vector(kDelayCntValSize-1 downto 0);
    cRequestDelay            : in boolean;
    cInc                     : in std_logic;
    cCntValFromIdelay        : in std_logic_vector(kDelayCntValSize-1 downto 0);
    cDlyCount                : in std_logic_vector(kDelayCntValSize-1 downto 0);
    cGetMinimumDelayLimit    : out boolean;
    cEnVtc                   : out std_logic;
    cDelayEn                 : out std_logic;
    cIncDecReady             : out std_logic;
    cDisplayCountValue       : out std_logic_vector(kDelayCntValSize-1 downto 0)
  );
end UpperLowerDelayLimit;

architecture rtl of UpperLowerDelayLimit is
  type SetCountState_t is (Idle, WaitSetLowLimit, WaitDelayReq, ReadInitialCnt, CountDelay, CheckLimit, WaitCycles, DelayEnable, DelayDisable, ReadCntValue);
  signal cCurrentSetCountState         : SetCountState_t;
  signal cCurrentCntValOut             : natural;
  constant kMaxDelayTap                : natural := 511;
  constant kWaitLong                   : natural := 15;
  constant kWaitShort                  : natural := 10;
  signal cWaitCount                    : natural range 0 to kWaitLong := kWaitLong;
  signal cRemainingDelayCount          : natural;
  signal cReadInitialCnt               : boolean;
  signal cDelayCountDone               : boolean;
  signal cMinDecTapLcl                 : natural;
begin
  process (aReset, Clk)
  begin
    if (aReset) then
      cCurrentSetCountState <= Idle;
      cCurrentCntValOut <= 0;
      cDelayEn <= '0';
      cRemainingDelayCount  <= 0;
      cMinDecTapLcl <= 0;
      cEnVtc <= '1';
      cGetMinimumDelayLimit <= false;
      cReadInitialCnt <= false;
      cDelayCountDone <= true;
      cWaitCount <= kWaitLong;
      cIncDecReady <= '0';
      cDisplayCountValue <= (others => '0');
    elsif (rising_edge(Clk)) then
      cMinDecTapLcl <= to_integer(unsigned(cMinDecTap));
      case cCurrentSetCountState is
        -- !STATE MACHINE STARTUP! This state machine cannot start immediately after
        -- aReset deasserts because cDelayCtrlRdy won't be immediately release.
        when Idle =>
          -- If cDelayCtrlRdy is true, will ask GetMinDelayLimit and wait for
          -- its done signal in next state (WaitSetLowLimit)
          if cDelayCtrlRdy then
            cCurrentSetCountState <= WaitSetLowLimit;
            cGetMinimumDelayLimit <= true;
            cEnVtc <= '0';
          else
            cEnVtc <= '1';
          end if;
        when WaitSetLowLimit =>
          -- If SetLowLimit is done, send the MinDecTap to LabVIEW to display the
          -- initial count.
          if cSetLowLimitDone then
            cIncDecReady <= '1';
            cDisplayCountValue <= cMinDecTap;
            cCurrentSetCountState <= WaitDelayReq;
          end if;
        when WaitDelayReq =>
          -- If there is delay request (cRequestDelay is TRUE), will disable EN_VTC
          -- for 10 cycles (next state), before reading initial CNTVALUEOUT value
          if cRequestDelay then
            cEnVtc <= '0';
            cIncDecReady <= '0';
            cWaitCount <= kWaitLong;
            cCurrentSetCountState <= WaitCycles;
            cReadInitialCnt <= true;
          else
            cEnVtc <= '1';
            cDelayEn <= '0';
          end if;
        when ReadInitialCnt =>
          -- Read current CNTVALUEOUT and start to count for requested delay taps (cDlyCount)
          cCurrentCntValOut <= to_integer(unsigned(cCntValFromIdelay));
          cReadInitialCnt <= false;
          cCurrentSetCountState <= CountDelay;
          cRemainingDelayCount  <= to_integer(unsigned(cDlyCount));
        when CountDelay =>
          if cRemainingDelayCount  = 0 then
            -- When finished the delay taps, will wait for at least 10 cycles before asserting EN_VTC
            cDelayCountDone <= true;
            cWaitCount <= kWaitLong;
            cCurrentSetCountState <= WaitCycles;
          else
            -- If there is delay taps, will reduce by 1 and go the next state to check whether
            -- the incremented/decremented delay value is in the allowable range
            cRemainingDelayCount  <= cRemainingDelayCount  - 1;
            cDelayCountDone <= false;
            cCurrentCntValOut <= to_integer(unsigned(cCntValFromIdelay));
            cCurrentSetCountState <= CheckLimit;
          end if;
        when CheckLimit =>
          -- To check if when the increment/decrement request is
          -- initiated, the incremented/decremented delay value
          -- is in an allowable range.
          -- If it is, go to the DelayEnable state to enable the delay
          -- If it is not, disable the delay and go to WaitCycles
          -- state to wait for 10 cycles before asserting EN_VTC high.
          if (cCurrentCntValOut >= cMinDecTapLcl and cCurrentCntValOut <= kMaxDelayTap) then
            if ((cCurrentCntValOut = cMinDecTapLcl) and (cInc = '0')) or ((cCurrentCntValOut = kMaxDelayTap) and (cInc = '1')) then
              cDelayEn <= '0';
              cWaitCount <= kWaitLong;
              cDelayCountDone <= true;
              cCurrentSetCountState <= WaitCycles;
            else
              cCurrentSetCountState <= DelayEnable;
            end if;
          else
            -- This else-statement is just for safety purpose if cCurrentCntValOut falls out of the allowable range
            cDelayEn <= '0';
            cWaitCount <= kWaitLong;
            cDelayCountDone <= true;
            cCurrentSetCountState <= WaitCycles;
          end if;
        when WaitCycles =>
          if cWaitCount = 0 then
            if cReadInitialCnt then
              -- Read CNTVALUEOUT when there is delay request
              cCurrentSetCountState <= ReadInitialCnt;
            elsif not cDelayCountDone then
              -- This condition is met when the inc/dec request is successful in previous states.
              -- If there is still balance in requested delay tap value after inc/dec,
              -- will proceed to CountDelay state to reduce by 1.
              cCurrentSetCountState <= CountDelay;
            else
              -- This condition is met under two conditions:
              -- (1) if we just applied the last delay step (cDelayCountDone = true),
              -- then we need to signal that we are done with the delay operation.
              -- (2) when the inc/dec is not allowed as it exceed the upper/lower delay limits.
              cCurrentSetCountState <= ReadCntValue;
            end if;
          else
            cWaitCount <= cWaitCount - 1;
          end if;
        when DelayEnable =>
          -- Enable the delay when inc/dec is allowed.
          cDelayEn <= '1';
          cCurrentSetCountState <= DelayDisable;
        when DelayDisable =>
          -- To create a pulse for cDelayEn signal
          cDelayEn <= '0';
          cWaitCount <= kWaitShort;
          cCurrentSetCountState <= WaitCycles;
        when ReadCntValue =>
          -- Read delay value out and indicates INC/DEC operation is done.
          cDisplayCountValue <= cCntValFromIdelay;
          cIncDecReady <= '1';
          cCurrentSetCountState <= WaitDelayReq;
        end case;
      end if;
  end process;
end rtl;