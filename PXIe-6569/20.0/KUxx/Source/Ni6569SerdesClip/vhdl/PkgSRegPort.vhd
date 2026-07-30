------------------------------------------------------------------------------------------
--
-- File: PkgSRegPort.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 13 February 2018
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
-- Purpose: Definition and supporting functions for a SimpleRegPort (SRegPort), which is
-- the output of PkgAxi4LiteCore.
--
-----------------------------------------------------------------------------------------
-- Protocol:
--
-- The SRegPort's design is driven by a desire to have a low-overhead conversion from
-- Axi4Lite and an easier interface to design around.
--
-- SRegPort purposefully lacks a holding/acknowledge mechanism, to prevent accidental
-- hanging or crashing of the Microblaze. This requires slaves to always be ready to
-- capture write data and respond to read requests.
--
-- Write: The write data (RegPortIn.WtData) and address (RegPortIn.WtAddress) are valid
-- for exactly one clock cycle, and the RegPortIn.WtEn signal is true for this one clock
-- cycle. Data needs to be latched on every clock rising edge in which WtEn is asserted.
--
-- Clk        __/¯¯¯\___/¯¯¯\___/¯¯¯\___
-- WtAddress  XXXXXXXXXXX<-Addr-->XXXXXX
-- WtData     XXXXXXXXXXX<-Data-->XXXXXX
-- WtEn       ___________/¯¯¯¯¯¯¯\______
--                              ^ Latch Data into register indicated by WtAddress.
--
-- Read: The interface will present the Read Address on the RegPortIn.RdAddress signal and
-- will latch the read data (RegPortOut) after two clock cycles. There is no "RdEn" signal
-- to qualify the read. This enforces an unconditional, combinatiorial response to reads
-- based solely on address decodes, but does give the user the option of providing one
-- stage of pipelining/FFs. The assumption is that Microblaze-domain clocks are
-- sufficiently slow that this is sufficient. In fact, completely combinatiorial read
-- responses are allowed, to simplify the slave implementation.
--
-- Clk                      __/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\___/¯¯¯\___
-- RdAddress                XXXXXXXXXXX<-Addr---------->XXXXXXXXXXXXXX
-- RdData (Combinatiorial)  XXXXXXXXXXX<-Data---------->XXXXXXXXXXXXXX
-- RdData (Pipelined)       XXXXXXXXXXXXXXXXXXX<-Data---------->XXXXXX
--                                                    ^ Data is latched on this edge.
--
-- RdAddress could have any value at any time. Registers need to respond with data of "all
-- 0's" whenever they're not being addressed (after the optional pipelining allowance).
-- Because there is no Rd strobe to indicate when a read is "really" happening, slaves are
-- *not* allowed to implement read side-effects.
--
-- The read and write are completely independent from each other, and the protocol makes
-- no attempt to guarantee any amount of time between one and the other. Technically, a
-- read and a write could both occur on the exact same clock cycle. If there is a
-- simultaneous read and write on the same clock cycle, the expected behavior would be to
-- latch the newly Written value and return the old, stored value as the Read response.
--
-- Practically speaking, however, we expect higher-level protocols to enforce read/write
-- ordering, so this situation is not expected to occur.
--
-- If this is not enough for you:
--
-- Generally speaking, if you need more/better functionality than is provided here, you
-- should look into using an Axi4Lite-to-BaRegPort converter instead.
--
-----------------------------------------------------------------------------------------
-- Use model for the functions in this Package.
--
-- These functions try to emulate one of the use models found in PkgBaRegPort, and make
-- use of XReg2_t. Note that only a subset of the PkgBaRegPort functions have been
-- replicated here, and note too that the use model is simpler because SRegPort has fixed
-- width and no acknowledge.
--
-- The use models for the main functions are documented below, above the public
-- declarations for said functions.
--
-- vreview_group Axi4Lite_Core
-- vreview_closed http://review-board.natinst.com/r/223241/
-- vreview_reviewers kygreen dhearn rortega privera jgorman
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgAxi4Lite.all;
use work.PkgXReg.all;

package PkgSRegPort is

  ---------------------------------------------------------------------------------------
  -- Types
  ---------------------------------------------------------------------------------------

  type SRegPortIn_t is record
    WtAddress : Axi4LiteAddr_t;
    WtData    : Axi4LiteData_t;
    WtEn      : boolean;
    RdAddress : Axi4LiteAddr_t;
  end record SRegPortIn_t;

  constant kSRegPortInZero : SRegPortIn_t := (
    WtAddress => (others => '0'),
    WtData    => (others => '0'),
    WtEn      => false,
    RdAddress => (others => '0'));

  -- It's obnoxious to create a record for a single signal. But to make things more
  -- symmetrical (and in case we add elements to this and create a record in the future)
  -- we'll still create a type.
  subtype SRegPortOut_t is Axi4LiteData_t;

  constant kSRegPortOutZero : SRegPortOut_t := (others => '0');

  ---------------------------------------------------------------------------------------
  -- Use Model - Read
  ---------------------------------------------------------------------------------------
  -- This function returns the provided RegReadValue (as masked by the register read mask)
  -- if the address corresponds to the provided register, and all-0s otherwise.
  --
  -- The intent is to be able to create register reads as a (concurrent) and-or tree of
  -- the form:
  --
  -- xRdData <= SRegReadData(kReg1Rec, xReg1Data, xSRegPortIn) or
  --            SRegReadData(kReg2Rec, xReg2Data, xSRegPortIn) or
  --            ...
  --
  -- The intent is to avoid priority-encoding of register decodes, while making it very
  -- easy to implement the register accesses. Note that because the registers are
  -- constant-masked with the read mask, logic should only be implemented for the bits
  -- that actually implement a readable bitfield.
  --
  -- Another valid implementation is to use an un-clocked process that declares a
  -- temporary variable ReadData of type Axi4LiteData_t. Then you could write the above
  -- as:
  --
  -- ReadData := (others => '0');
  -- ReadData := ReadData or SRegReadData(kReg1Rec, xReg1Data, xSRegPortIn);
  -- ReadData := ReadData or SRegReadData(kReg2Rec, xReg2Data, xSRegPortIn);
  -- xRdData <= ReadData;
  --
  -- The above is more verbose, but can span more vertical space, making it easier to
  -- write long register chains without getting too lost.

  function SRegReadData (
    RegInfo      : XReg2_t;
    RegReadValue : Axi4LiteData_t;
    SRegPortIn   : SRegPortIn_t;
    BaseAddr     : natural := 0)
    return Axi4LiteData_t;

  ---------------------------------------------------------------------------------------
  -- Use Model - Write
  ---------------------------------------------------------------------------------------
  -- The objective for this function is to be able to create registers of the form (inside
  -- a clocked process, of course):
  --
  -- xMyRegister <= SRegWriteData(kRegRec, xMyRegister, xSRegPortIn);
  --
  -- In order to achieve this, the function returns the data from the register write when
  -- the register is being accessed, with the following modifications:
  --
  -- 1. The data received is masked to the Write Mask for the register, i.e. it's only
  --    non-zero for defined bitfields. If no bitfields are defined on a register XReg2_t
  --    treats the entire register as writable.
  -- 2. If the register is not marked as writable, the function just returns OldData.
  --
  -- The fact that the data is masked based on XmlParse configurations means that
  -- MyRegister above will only synthesize to have the FFs that actually contain writable
  -- bitfields. The rest of the bits will synthesize out because they are constant 0's.
  --
  -- When the register is *not* being accessed, this function will return the value of
  -- OldData, so that the underlying FFs can retain their previous values. One exception
  -- to this is strobes, which will be reset to '0'. This automatically implements the
  -- corresponding bits in MyRegister/OldData as strobes.

  function SRegWriteData (
    RegInfo    : XReg2_t;
    OldData    : Axi4LiteData_t;
    SRegPortIn : SRegPortIn_t;
    BaseAddr   : natural := 0)
    return Axi4LiteData_t;

end package PkgSRegPort;

package body PkgSRegPort is

  -- Read

  -- Returns the provided Data (as masked by the register read mask) if the address
  -- corresponds to the provided register, and all-0s otherwise.
  function SRegReadData (
    RegInfo      : XReg2_t;
    RegReadValue : Axi4LiteData_t;
    SRegPortIn   : SRegPortIn_t;
    BaseAddr     : natural := 0)
    return Axi4LiteData_t
  is
    variable TempData : Axi4LiteData_t := (others => '0');
  begin  -- function SRegReadData

    --synthesis translate_off
    assert RegInfo.size = Axi4LiteAddr_t'length
      report "RegInfo.size must match data length"
      severity failure;
    --synthesis translate_on

    -- Default to returning 0's for easy Or'ing.
    TempData := (others => '0');

    if SRegPortIn.RdAddress = (RegInfo.offset + BaseAddr ) then
      TempData := RegReadValue and GetRdMask(RegInfo);
    end if;

    return TempData;

  end function SRegReadData;

  -- Write
  function SRegWriteData (
    RegInfo  : XReg2_t;
    OldData  : Axi4LiteData_t;
    SRegPortIn : SRegPortIn_t;
    BaseAddr : natural := 0)
  return Axi4LiteData_t is
    variable TempData : Axi4LiteData_t;
  begin  -- function SRegWriteData

    --synthesis translate_off
    assert RegInfo.size = Axi4LiteAddr_t'length
      report "RegInfo.size must match data length"
      severity failure;
    --synthesis translate_on

    -- Default to returning the old data, with strobes masked out.
    TempData := OldData and not GetStrobeMask(RegInfo);

    if RegInfo.writable
      and SRegPortIn.WtAddress = (RegInfo.offset + BaseAddr)
      and SRegPortIn.WtEn then
      TempData := SRegPortIn.WtData and GetWtMask(RegInfo);
    end if;

    return TempData;

  end function SRegWriteData;

end package body PkgSRegPort;
