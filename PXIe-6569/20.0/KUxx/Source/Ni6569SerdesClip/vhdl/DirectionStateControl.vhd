-------------------------------------------------------------------------------
--
-- File: DirectionStateControl.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 11 November 2020
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
-- Purpose: This is a simple state machine intended to delay the output
-- enables of the se buffer io after the direction changes to output to
-- prevent double driving.
--
-------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_Logic_1164.all;


entity DirectionStateControl is
  port(
    aReset          : in std_logic;
    RegisterClk     : in std_logic;  -- 200mhz for 5ns clock cycles
    aSeDir          : in std_logic;  -- SeDir input
    aSeOutputEn     : out std_logic  -- To SE output FPGA buffer enables
  );
end DirectionStateControl;


architecture rtl of DirectionStateControl is
  signal rgOutputEn_ms, rgOutputEnD1, rgOutputEnD2, rgOutputEnD3 : std_logic;

  -- DONT_TOUCH attribute is applied here to prevent merging of manually replicated logic

  attribute DONT_TOUCH: string;
  attribute DONT_TOUCH of rgOutputEn_ms: signal is "TRUE";
  attribute DONT_TOUCH of rgOutputEnD1 : signal is "TRUE";
  attribute DONT_TOUCH of rgOutputEnD2: signal is "TRUE";
  attribute DONT_TOUCH of rgOutputEnD3 : signal is "TRUE";

begin

  -- Double sync SeDir
  -- signals to allow for safe crossing of clock domains.
  -- Delay between SeDir and SeOutputEn ranges from 15 to 20ns
  -- (3 to 4 cycles of RegisterClk).
  DirectionStateControl: process (aReset, RegisterClk) is
  begin
    if aReset = '1' then
        rgOutputEn_ms <= '0';
        rgOutputEnD1 <= '0';
        rgOutputEnD2 <= '0';
        rgOutputEnD3 <= '0';
    elsif rising_edge(RegisterClk) then
        rgOutputEn_ms <= aSeDir;
        rgOutputEnD1 <= rgOutputEn_ms;
        rgOutputEnD2 <= rgOutputEnD1;
        rgOutputEnD3 <= rgOutputEnD2;
    end if;
  end process;

  -- Since the output enable is asynchronous, the output may glitch
  -- if aSeDir is changed from '1' to '0' around the same time aSeOutputEn
  -- goes to '1'. To be safe, aSeDir should stay high for 25 ns (or 5 cycles
  -- of RegisterClk).
  aSeOutputEn <= '1' when rgOutputEnD3='1' and aSeDir='1' else '0';

end rtl;

