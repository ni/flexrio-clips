-----------------------------------------------------------------------------------------
--
-- File: PkgAxi4Lite.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 27 August 2010
--
-----------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package defines types and subtypes that are used for Axi4Lite interfaces. It was
-- derived from Glen's PkgAxi.
--
-- vreview_group Axi4Lite_Core
-- vreview_closed http://review-board.natinst.com/r/223241/
-- vreview_reviewers kygreen dhearn rortega privera jgorman
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgAxi4LiteConfig.all;

package PkgAxi4Lite is

  -- Derived Constant
  constant kAxi4LiteDataWidthInBytes : positive := kAxi4LiteDataWidth / 8;

  -- AXI Address Channel signal types
  subtype Axi4LiteAddr_t is unsigned (kAxi4LiteAddrWidth-1 downto 0);
  subtype Axi4LiteProt_t is std_logic_vector(2 downto 0);

  -- The prot vector is made up of 3 flags, whose indexes are provided by the following
  -- constants. These are defined by the Axi spec, but are not generally used in
  -- Axi4Lite.

  -- Privileged - '0' = Unprivileged Access, '1' = Privileged Access
  constant kAxi4LiteProtPrivileged  : natural := 0;
  -- NonSecure - '0' = Secure Access, '1' = Non-Secure Access
  constant kAxi4LiteProtNonSecure   : natural := 1;
  -- Instruction - '0' = Data Access, '1' = Instruction Access
  constant kAxi4LiteProtInstruction : natural := 2;

  -- The default value for Prot in Axi4Lite is for all flags to be cleared, i.e. all 0's
  constant kAxi4LiteProtZero : Axi4LiteProt_t :=
    (kAxi4LiteProtPrivileged  => '0',
     kAxi4LiteProtNonSecure   => '0',
     kAxi4LiteProtInstruction => '0');

  -- AXI Data and Response Channel signal types
  subtype Axi4LiteData_t is std_logic_vector(kAxi4LiteDataWidth - 1 downto 0);
  subtype Axi4LiteStrb_t is std_logic_vector(kAxi4LiteDataWidth / 8 - 1 downto 0);
  subtype Axi4LiteResp_t is std_logic_vector(1 downto 0);

  -- Responses are defined by the Axi4 Spec.
  constant kAxi4LiteRespOkay   : Axi4LiteResp_t := "00";
  constant kAxi4LiteRespExOkay : Axi4LiteResp_t := "01";
  constant kAxi4LiteRespSlvErr : Axi4LiteResp_t := "10";
  constant kAxi4LiteRespDecErr : Axi4LiteResp_t := "11";

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Common
  ---------------------------------------------------------------------------------------
  -- Address Channel is the same for both reads and Writes
  type Axi4LiteAddressChannel_t is record
    Addr  : Axi4LiteAddr_t;
    Prot  : Axi4LiteProt_t;
    Valid : boolean;
  end record;

  constant kAxi4LiteAddressChannelZero : Axi4LiteAddressChannel_t := (
    Addr  => (others => '0'),
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Prot  => kAxi4LiteProtZero,
    Valid => false
    );

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Write
  ---------------------------------------------------------------------------------------
  type Axi4LiteWriteDataChannel_t is record
    Data  : Axi4LiteData_t;
    Strb  : Axi4LiteStrb_t;
    Valid : boolean;
  end record;

  constant kAxi4LiteWriteDataChannelZero : Axi4LiteWriteDataChannel_t := (
    Data  => (others => '0'),
    Strb  => (others => '0'),
    Valid => false
    );

  type Axi4LiteWriteResponseChannel_t is record
    Resp  : Axi4LiteResp_t;
    Valid : boolean;
  end record;

  constant kAxi4LiteWriteResponseChannelZero : Axi4LiteWriteResponseChannel_t := (
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Resp  => kAxi4LiteRespOkay,
    Valid => false
    );

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Read
  ---------------------------------------------------------------------------------------

  type Axi4LiteReadDataChannel_t is record
    Data  : Axi4LiteData_t;
    Resp  : Axi4LiteResp_t;
    Valid : boolean;
  end record;

  constant kAxi4LiteReadDataChannelZero : Axi4LiteReadDataChannel_t := (
    Data  => (others => '0'),
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Resp  => kAxi4LiteRespOkay,
    Valid => false
    );

end package PkgAxi4Lite;
