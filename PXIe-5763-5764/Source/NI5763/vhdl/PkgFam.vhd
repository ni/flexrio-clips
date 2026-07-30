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
-- vreview_group Nessie_Top
-- vreview_closed http://review-board.natinst.com/r/224521/
-- vreview_closed http://review-board.natinst.com/r/218646/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFlexRioTargetConfig.all;

package PkgFam is

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#10937989#, 32));
  
  constant kAdcLaneCount : integer := 4;
  
  constant kFamMgtRxPolarity : std_logic_vector(7 downto 0) := "00110011";
  constant kRxPolarity : std_logic_vector(7 downto 0) := kRxIoModRxMgtPolarity(7 downto 0) XOR kFamMgtRxPolarity;
  function kNessieRxPolarity return std_logic_vector;
  
  type MapArray_t is array(natural range <>) of natural;
  constant kMgtLaneMap : MapArray_t(0 to kAdcLaneCount-1) := (6, 5, 2, 1);

end PkgFam;

package body PkgFam is

  function kNessieRxPolarity return std_logic_vector is
    variable retval : std_logic_vector(kAdcLaneCount-1 downto 0) := (others => '0');
  begin

    for i in retval'range loop
      retval(i) := kRxPolarity(kMgtLaneMap(i));
    end loop;

    return retval;

  end function kNessieRxPolarity;

end package body;
