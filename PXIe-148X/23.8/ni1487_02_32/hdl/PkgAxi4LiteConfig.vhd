-------------------------------------------------------------------------------
--
-- File: PkgAxiConfig.vhd
-- Author: Glen Sescila
-- Original Project: NI DMA IP
-- Date: 27 August 2010
--
-------------------------------------------------------------------------------
-- (c) 2010 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
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
