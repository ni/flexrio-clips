-------------------------------------------------------------------------------
--
-- File: PkgFam.vhd
-- Author: Daniel Hearn
-- Original Project: Nessie and Jessie CLIP
-- Date: 2 Feb 2018
--
-------------------------------------------------------------------------------
-- (c) 2018 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
-- FAM specific constants
--
-- vreview_group Jessie_Top
-- vreview_closed http://review-board.natinst.com/r/224518/
-- vreview_closed http://review-board.natinst.com/r/218649/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFlexRioTargetConfig.all;

package PkgFam is

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#1093798B#, 32));

  constant kAdcLaneCount : integer := 8;

  constant kFamMgtRxPolarity : std_logic_vector(7 downto 0) := "00110011";
  constant kRxPolarity : std_logic_vector(7 downto 0) := kRxIoModRxMgtPolarity(7 downto 0) XOR kFamMgtRxPolarity;
  constant kJessieRxPolarity : std_logic_vector(kAdcLaneCount-1 downto 0) := kRxPolarity(kAdcLaneCount-1 downto 0);

end PkgFam;

package body PkgFam is

end package body;
