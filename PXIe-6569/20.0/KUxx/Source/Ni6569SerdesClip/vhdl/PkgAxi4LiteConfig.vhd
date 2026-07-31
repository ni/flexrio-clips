-------------------------------------------------------------------------------
--
-- File: PkgAxiConfig.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 27 August 2010
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
-- This package is used by the NiAxiBfm but could also be useful within
-- synthesizable code.
--
-- These constants have been set for running the AXI Common tests, but they
-- will likely be useful for synthesizing the AXI InChWORM netlists as well.
--
-- The Macallan is using these packages to facilitate the instantiation and
-- creation of AXI4Lite peripherals to be used with the Microblaze.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package PkgAxi4LiteConfig is

  -- Width of the data bus for the AXI Data port.
  constant kAxi4LiteDataWidth : integer := 32;

  -- Width of the data bus for the AXI Data port.
  constant kAxi4LiteAddrWidth : integer := 32;

end package PkgAxi4LiteConfig;

package body PkgAxi4LiteConfig is

end PkgAxi4LiteConfig;
