-------------------------------------------------------------------------------
--
-- File: PkgFam.vhd
-- Author: Larbi Boughaleb
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
-- vreview_group Sphinx_Common
-- vreview_closed http://review-board.natinst.com/r/264928/
-- vreview_closed http://review-board.natinst.com/r/224518/
-- vreview_closed http://review-board.natinst.com/r/218649/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgFam is

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#109379A3#, 32));
    
end PkgFam;

package body PkgFam is

end package body;
