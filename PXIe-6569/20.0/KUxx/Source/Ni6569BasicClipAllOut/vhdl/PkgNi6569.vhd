------------------------------------------------------------------------------------------
--
-- File: PkgNi6569.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 21 March 2020
--
------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------
--
-- Purpose: This package file holds all the constants.  These constants should
-- not be changed for proper operation of this CLIP.
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PkgNi6569 is

  constant kNumTxDataChannel : positive := 64;

  -- Serialization factor for the OSerdes.
  constant kSerFactor : natural := 8;

  -- PFI lines constants
  constant kNumPfiChannel : positive := 2;

  -- There is a maximum serialization and deserialization of 8 in the CLIPs,
  -- therefore SerArray_t have widths of 8.
  type SerArray_t is array (natural range<>) of
    std_logic_vector(7 downto 0);

  -- Delay constant and array type
  constant kDelayCntValSize : natural := 9;

  type DelayArray_t is array (natural range<>) of
    std_logic_vector(8 downto 0);

end PkgNi6569;

