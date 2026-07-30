-----------------------------------------------------------------------------------------
--
-- File: PkgAxi4Lite.vhd
-- Author: Glen Sescila / Updated in 2018 by Rolando Ortega
-- Original Project: NI DMA IP
-- Date: 27 August 2010
--
-----------------------------------------------------------------------------------------
-- (c) 2010 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-----------------------------------------------------------------------------------------
--
-- Purpose:
--
-- This package defines types and subtypes that are used for Axi4Lite interfaces. It was
-- derived from Glen's PkgAxi.
--
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
  subtype Axi4LiteAddr_t is unsigned(kAxi4LiteAddrWidth-1 downto 0);
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

  -- Default Ready constants.
  -- Taken from AMBA AXI and ACE Protocol Specification document.
  -- Write address channel, page A3-38.
  -- The default state of AWREADY can be either HIGH or LOW. This specification recommends a default state of HIGH.
  -- When AWREADY is HIGH the slave must be able to accept any valid address that is presented to it.
  -- This specification does not recommend a default AWREADY state of LOW, because it forces
  -- the transfer to take at least two cycles, one to assert AWVALID and another to assert AWREADY.
  constant kAxi4LiteWriteAddressChannelReadyZero  : std_logic := '1';
  -- Write data channel, page A3-39.
  -- The default state of WREADY can be HIGH, but only if the slave can always accept write data in a single cycle.
  -- Default this to False for safety as we shouldn't assume single cycle accepts. Slaves should override this as needed.
  constant kAxi4LiteWriteDataChannelReadyZero     : std_logic := '0';
  -- Write response channel, page A3-39.
  -- The default state of BVALID can be HIGH, but only if the master can always accept a write response in a single cycle.
  -- Default this to False for safety as we shouldn't assume single cycle accepts. Slaves should override this as needed.
  constant kAxi4LiteWriteResponseChannelReadyZero : std_logic := '0';
  -- Read address channel, page A3-39.
  -- The default state of ARREADY can be either HIGH or LOW. This specification recommends a default state of HIGH.
  -- If ARREADY is HIGH then the slave must be able to accept any valid address that is presented to it.
  -- This specification does not recommend a default ARREADY value of LOW, because it forces
  -- the transfer to take at least two cycles, one to assert ARVALID and another to assert ARREADY.
  constant kAxi4LiteReadAddressChannelReadyZero   : std_logic := '1';
  -- Read data channel, page A3-39.
  -- The default state of RREADY can be HIGH, but only if the master is able to accept read data immediately,
  -- whenever it starts a read transaction.
  -- Default this to False for safety as we shouldn't assume immediate reads. Masters should override this as needed.
  constant kAxi4LiteReadDataChannelReadyZero      : std_logic := '0';

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Common
  ---------------------------------------------------------------------------------------
  -- Address Channel is the same for both reads and Writes
  type Axi4LiteAddressChannel_t is record
    Addr  : Axi4LiteAddr_t;
    Prot  : Axi4LiteProt_t;
    Valid : std_logic;
  end record;

  constant kAxi4LiteAddressChannelZero : Axi4LiteAddressChannel_t := (
    Addr  => (others => '0'),
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Prot  => kAxi4LiteProtZero,
    Valid => '0'
    );

  -- Subtype and functions for un/Flattening Axi4LiteAddressChannel_t
  subtype Axi4LiteAddressChannelFlat_t is std_logic_vector(Axi4LiteAddr_t'length + Axi4LiteProt_t'length + 1 - 1 downto 0);
  function Flatten (rec : Axi4LiteAddressChannel_t) return Axi4LiteAddressChannelFlat_t;
  function Unflatten (rec : Axi4LiteAddressChannelFlat_t) return Axi4LiteAddressChannel_t;

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Write
  ---------------------------------------------------------------------------------------
  type Axi4LiteWriteDataChannel_t is record
    Data  : Axi4LiteData_t;
    Strb  : Axi4LiteStrb_t;
    Valid : std_logic;
  end record;

  constant kAxi4LiteWriteDataChannelZero : Axi4LiteWriteDataChannel_t := (
    Data  => (others => '0'),
    Strb  => (others => '0'),
    Valid => '0'
    );

  -- Subtype and functions for un/Flattening Axi4LiteWriteDataChannel_t
  subtype Axi4LiteWriteDataChannelFlat_t is std_logic_vector(Axi4LiteAddr_t'length + Axi4LiteStrb_t'length + 1 - 1 downto 0);
  function Flatten (rec : Axi4LiteWriteDataChannel_t) return Axi4LiteWriteDataChannelFlat_t;
  function Unflatten (rec : Axi4LiteWriteDataChannelFlat_t) return Axi4LiteWriteDataChannel_t;

  type Axi4LiteWriteResponseChannel_t is record
    Resp  : Axi4LiteResp_t;
    Valid : std_logic;
  end record;

  constant kAxi4LiteWriteResponseChannelZero : Axi4LiteWriteResponseChannel_t := (
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Resp  => kAxi4LiteRespOkay,
    Valid => '0'
    );

  -- Subtype and functions for un/Flattening Axi4LiteWriteResponseChannel_t
  subtype Axi4LiteWriteResponseChannelFlat_t is std_logic_vector(Axi4LiteResp_t'length + 1 - 1 downto 0);
  function Flatten (rec : Axi4LiteWriteResponseChannel_t) return Axi4LiteWriteResponseChannelFlat_t;
  function Unflatten (rec : Axi4LiteWriteResponseChannelFlat_t ) return Axi4LiteWriteResponseChannel_t;

  ---------------------------------------------------------------------------------------
  -- Port Record Types - Read
  ---------------------------------------------------------------------------------------

  type Axi4LiteReadDataChannel_t is record
    Data  : Axi4LiteData_t;
    Resp  : Axi4LiteResp_t;
    Valid : std_logic;
  end record;

  constant kAxi4LiteReadDataChannelZero : Axi4LiteReadDataChannel_t := (
    Data  => (others => '0'),
    -- This is the equivalent of "all-0's", but it's also the default for Axi4Lite.
    Resp  => kAxi4LiteRespOkay,
    Valid => '0'
    );

  -- Subtype and functions for un/Flattening Axi4LiteReadDataChannel_t
  subtype Axi4LiteReadDataChannelFlat_t is std_logic_vector(Axi4LiteAddr_t'length + Axi4LiteResp_t'length + 1 - 1 downto 0);
  function Flatten (rec : Axi4LiteReadDataChannel_t) return Axi4LiteReadDataChannelFlat_t;
  function Unflatten (rec : Axi4LiteReadDataChannelFlat_t) return Axi4LiteReadDataChannel_t;

  --------------------------------------------------------------------------------
  --Axi4Lite record in and out of channels and ready signals
  --------------------------------------------------------------------------------
  --This allows a single in/out record for the entire AXI4Lite interface.
  type Axi4LiteToSlave_t is record
    WriteAddressChannel       : Axi4LiteAddressChannel_t;
    WriteDataChannel          : Axi4LiteWriteDataChannel_t;
    WriteResponseChannelReady : std_logic;

    ReadAddressChannel        : Axi4LiteAddressChannel_t;
    ReadDataChannelReady      : std_logic;
  end record Axi4LiteToSlave_t;

  constant kAxi4LiteToSlaveZero : Axi4LiteToSlave_t := (
    WriteAddressChannel       => kAxi4LiteAddressChannelZero,
    WriteDataChannel          => kAxi4LiteWriteDataChannelZero,
    WriteResponseChannelReady => kAxi4LiteWriteResponseChannelReadyZero,
    ReadAddressChannel        => kAxi4LiteAddressChannelZero,
    ReadDataChannelReady      => kAxi4LiteReadDataChannelReadyZero
  );

  -- Subtype and functions for un/Flattening Axi4LiteToSlave_t
  subtype Axi4LiteToSlaveFlat_t is std_logic_vector(
    Axi4LiteAddressChannelFlat_t'length + Axi4LiteWriteDataChannelFlat_t'length + 1 + Axi4LiteAddressChannelFlat_t'length + 1 - 1 downto 0
  );
  function Flatten (rec : Axi4LiteToSlave_t) return Axi4LiteToSlaveFlat_t;
  function Unflatten (rec : Axi4LiteToSlaveFlat_t) return Axi4LiteToSlave_t;

  type Axi4LiteToMaster_t is record
    WriteAddressChannelReady   : std_logic;
    WriteDataChannelReady      : std_logic;
    WriteResponseChannel       : Axi4LiteWriteResponseChannel_t;

    ReadAddressChannelReady    : std_logic;
    ReadDataChannel            : Axi4LiteReadDataChannel_t;
  end record Axi4LiteToMaster_t;

  constant kAxi4LiteToMasterZero : Axi4LiteToMaster_t := (
    WriteAddressChannelReady  => kAxi4LiteWriteAddressChannelReadyZero,
    WriteDataChannelReady     => kAxi4LiteWriteDataChannelReadyZero,
    WriteResponseChannel      => kAxi4LiteWriteResponseChannelZero,
    ReadAddressChannelReady   => kAxi4LiteReadAddressChannelReadyZero,
    ReadDataChannel           => kAxi4LiteReadDataChannelZero
  );

  -- Subtype and functions for un/Flattening Axi4LiteToMaster_t
  subtype Axi4LiteToMasterFlat_t is std_logic_vector(
    1 + 1 + Axi4LiteWriteResponseChannelFlat_t'length + 1 + Axi4LiteReadDataChannelFlat_t'length - 1 downto 0
  );
  function Flatten (rec : Axi4LiteToMaster_t) return Axi4LiteToMasterFlat_t;
  function Unflatten (rec : Axi4LiteToMasterFlat_t) return Axi4LiteToMaster_t;

  type Axi4LiteToSlaveAry_t is array (integer range <>) of Axi4LiteToSlave_t;
  type Axi4LiteToMasterAry_t is array (integer range <>) of Axi4LiteToMaster_t;

  -- Functions for un/Flattening Axi4LiteToSlaveAry_t.
  -- Note, no subtype is directly provided for Axi4LiteToSlaveAry_t. It is up to the user to constrain the length
  -- of the Flattened record.
  type Axi4LiteToSlaveFlatAry_t is array (integer range <>) of Axi4LiteToSlaveFlat_t;
  function Flatten (recs : Axi4LiteToSlaveAry_t) return Axi4LiteToSlaveFlatAry_t;
  function Unflatten (recs : Axi4LiteToSlaveFlatAry_t) return Axi4LiteToSlaveAry_t;
  function Flatten (recs : Axi4LiteToSlaveAry_t) return std_logic_vector;
  function Unflatten (recs : std_logic_vector) return Axi4LiteToSlaveAry_t;

  -- Functions for un/Flattening Axi4LiteToMasterAry_t.
  -- Note, no subtype is directly provided for Axi4LiteToMasterAry_t. It is up to the user to constrain the length
  -- of the Flattened record.
  type Axi4LiteToMasterFlatAry_t is array (integer range <>) of Axi4LiteToMasterFlat_t;
  function Flatten (recs : Axi4LiteToMasterAry_t) return Axi4LiteToMasterFlatAry_t;
  function Unflatten(recs : Axi4LiteToMasterFlatAry_t) return Axi4LiteToMasterAry_t;
  function Flatten (recs : Axi4LiteToMasterAry_t) return std_logic_vector;
  function Unflatten (recs : std_logic_vector) return Axi4LiteToMasterAry_t;

end package PkgAxi4Lite;

package body PkgAxi4Lite is

  --------------------------------------------------------------------------------
  -- Support functions for un/Flattening Axi4Lite records
  --------------------------------------------------------------------------------
  function Flatten (rec : Axi4LiteAddressChannel_t) return Axi4LiteAddressChannelFlat_t is
    variable ToRet : Axi4LiteAddressChannelFlat_t := (others => '0');
  begin
    ToRet := std_logic_vector(rec.Addr) & std_logic_vector(rec.Prot) & rec.Valid;
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteAddressChannelFlat_t) return Axi4LiteAddressChannel_t is
    variable ToRet : Axi4LiteAddressChannel_t := kAxi4LiteAddressChannelZero;
  begin
    ToRet.Valid := rec(0);
    ToRet.Prot := Axi4LiteProt_t(rec(Axi4LiteProt_t'length downto 1));
    ToRet.Addr := Axi4LiteAddr_t(rec(rec'left downto Axi4LiteProt_t'length + 1));
    return ToRet;
  end function Unflatten;

  function Flatten (rec : Axi4LiteWriteDataChannel_t) return Axi4LiteWriteDataChannelFlat_t is
    variable ToRet : Axi4LiteWriteDataChannelFlat_t := (others => '0');
  begin
    ToRet := rec.Data & rec.Strb & rec.Valid;
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteWriteDataChannelFlat_t) return Axi4LiteWriteDataChannel_t is
    variable ToRet : Axi4LiteWriteDataChannel_t := kAxi4LiteWriteDataChannelZero;
  begin
    ToRet.Valid := rec(0);
    ToRet.Strb := Axi4LiteStrb_t(rec(Axi4LiteStrb_t'length downto 1));
    ToRet.Data := Axi4LiteData_t(rec(rec'left downto Axi4LiteStrb_t'length + 1));
    return ToRet;
  end function Unflatten;

  function Flatten (rec : Axi4LiteReadDataChannel_t) return Axi4LiteReadDataChannelFlat_t is
    variable ToRet : Axi4LiteReadDataChannelFlat_t := (others => '0');
  begin
    ToRet := rec.Data & rec.Resp & rec.Valid;
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteReadDataChannelFlat_t) return Axi4LiteReadDataChannel_t is
    variable ToRet : Axi4LiteReadDataChannel_t := kAxi4LiteReadDataChannelZero;
  begin
    ToRet.Valid := rec(0);
    ToRet.Resp := Axi4LiteResp_t(rec(Axi4LiteResp_t'length downto 1));
    ToRet.Data := Axi4LiteData_t(rec(rec'left downto Axi4LiteResp_t'length + 1));
    return ToRet;
  end function Unflatten;

  function Flatten (rec : Axi4LiteWriteResponseChannel_t) return Axi4LiteWriteResponseChannelFlat_t is
    variable ToRet : Axi4LiteWriteResponseChannelFlat_t := (others => '0');
  begin
    ToRet := rec.Resp & rec.Valid;
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteWriteResponseChannelFlat_t) return Axi4LiteWriteResponseChannel_t is
    variable ToRet : Axi4LiteWriteResponseChannel_t := kAxi4LiteWriteResponseChannelZero;
  begin
    ToRet.Valid := rec(0);
    ToRet.Resp := Axi4LiteResp_t(rec(rec'left downto 1));
    return ToRet;
  end function Unflatten;

  --------------------------------------------------------------------------------
  -- Functions for un/Flattening Axi4Lite master/slave records
  --------------------------------------------------------------------------------
  function Flatten (rec : Axi4LiteToSlave_t) return Axi4LiteToSlaveFlat_t is
    variable ToRet : Axi4LiteToSlaveFlat_t := (others => '0');
  begin
    ToRet :=
      Flatten(rec.WriteAddressChannel) &
      Flatten(rec.WriteDataChannel) &
      rec.WriteResponseChannelReady &
      Flatten(rec.ReadAddressChannel) &
      rec.ReadDataChannelReady;
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteToSlaveFlat_t) return Axi4LiteToSlave_t is
    variable lsb : natural := 0;
    variable len : natural := 0;
    variable ToRet : Axi4LiteToSlave_t := kAxi4LiteToSlaveZero;
  begin
    lsb := 0;
    len := 1;
    ToRet.ReadDataChannelReady := rec(lsb);

    lsb := lsb + len;
    len := Axi4LiteAddressChannelFlat_t'length;
    ToRet.ReadAddressChannel := Unflatten(Axi4LiteAddressChannelFlat_t(rec(len + lsb - 1 downto lsb)));

    lsb := lsb + len;
    len := 1;
    ToRet.WriteResponseChannelReady := rec(lsb);

    lsb := lsb + len;
    len := Axi4LiteWriteDataChannelFlat_t'length;
    ToRet.WriteDataChannel := Unflatten(Axi4LiteWriteDataChannelFlat_t(rec(len + lsb - 1 downto lsb)));

    lsb := lsb + len;
    len := Axi4LiteAddressChannelFlat_t'length;
    ToRet.WriteAddressChannel := Unflatten(Axi4LiteAddressChannelFlat_t(rec(len + lsb - 1 downto lsb)));
    return ToRet;
  end function Unflatten;

  function Flatten (rec : Axi4LiteToMaster_t) return Axi4LiteToMasterFlat_t is
    variable ToRet : Axi4LiteToMasterFlat_t := (others => '0');
  begin
    ToRet :=
      rec.WriteAddressChannelReady &
      rec.WriteDataChannelReady &
      Flatten(rec.WriteResponseChannel) &
      rec.ReadAddressChannelReady &
      Flatten(rec.ReadDataChannel);
    return ToRet;
  end function Flatten;

  function Unflatten (rec : Axi4LiteToMasterFlat_t) return Axi4LiteToMaster_t is
    variable lsb : natural := 0;
    variable len : natural := 0;
    variable ToRet : Axi4LiteToMaster_t := kAxi4LiteToMasterZero;
  begin
    lsb := 0;
    len := Axi4LiteReadDataChannelFlat_t'length;
    ToRet.ReadDataChannel := Unflatten(Axi4LiteReadDataChannelFlat_t(rec(len + lsb - 1 downto lsb)));

    lsb := lsb + len;
    len := 1;
    ToRet.ReadAddressChannelReady := rec(lsb);

    lsb := lsb + len;
    len := Axi4LiteWriteResponseChannelFlat_t'length;
    ToRet.WriteResponseChannel := Unflatten(Axi4LiteWriteResponseChannelFlat_t(rec(len + lsb - 1 downto lsb)));

    lsb := lsb + len;
    len := 1;
    ToRet.WriteDataChannelReady := rec(lsb);

    lsb := lsb + len;
    len := 1;
    ToRet.WriteAddressChannelReady := rec(lsb);
    return ToRet;
  end function Unflatten;

  --------------------------------------------------------------------------------
  -- Functions for un/Flattening Axi4Lite master/slave Ary of records
  --------------------------------------------------------------------------------
  function Flatten (recs : Axi4LiteToSlaveAry_t) return Axi4LiteToSlaveFlatAry_t is
    variable ToRet : Axi4LiteToSlaveFlatAry_t(recs'length - 1 downto 0);
  begin
    for i in 0 to recs'length - 1 loop
      ToRet(i) := Flatten(recs(i));
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten (recs : Axi4LiteToSlaveFlatAry_t) return Axi4LiteToSlaveAry_t is
    variable ToRet : Axi4LiteToSlaveAry_t(recs'length - 1 downto 0);
  begin
    for i in 0 to recs'length - 1 loop
      ToRet(i) := Unflatten(recs(i));
    end loop;
    return ToRet;
  end function Unflatten;

  function Flatten (recs : Axi4LiteToSlaveAry_t) return std_logic_vector is
    variable Inter : Axi4LiteToSlaveFlatAry_t(recs'length - 1 downto 0);
    variable ToRet : std_logic_vector(Axi4LiteToSlaveFlat_t'length * recs'length - 1 downto 0);
  begin
    Inter := Flatten(recs);
    for i in 0 to recs'length - 1 loop
      ToRet(Axi4LiteToSlaveFlat_t'length * (i + 1) - 1 downto Axi4LiteToSlaveFlat_t'length * i) := Inter(i);
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten (recs : std_logic_vector) return Axi4LiteToSlaveAry_t is
    constant kArySize : natural := recs'length / Axi4LiteToSlaveFlat_t'length;
    variable Inter : Axi4LiteToSlaveFlatAry_t(kArySize - 1 downto 0);
    variable ToRet : Axi4LiteToSlaveAry_t(kArySize - 1 downto 0);
  begin
    --synopsys translate_off
    assert (recs'length rem Axi4LiteToSlaveFlat_t'length) = 0
      report "The Flattened SLV length for Axi4LiteToSlaveAry_t must be a multiple of Axi4LiteToSlaveFlat_t'length"
      severity failure;
    --synopsys translate_on
    for i in 0 to kArySize - 1 loop
      Inter(i) := Axi4LiteToSlaveFlat_t(recs(Axi4LiteToSlaveFlat_t'length * (i + 1) - 1 downto Axi4LiteToSlaveFlat_t'length * i));
    end loop;
    ToRet := Unflatten(Inter);
    return ToRet;
  end function Unflatten;

  function Flatten (recs : Axi4LiteToMasterAry_t) return Axi4LiteToMasterFlatAry_t is
    variable ToRet : Axi4LiteToMasterFlatAry_t(recs'length - 1 downto 0);
  begin
    for i in 0 to recs'length - 1 loop
      ToRet(i) := Flatten(recs(i));
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten (recs : Axi4LiteToMasterFlatAry_t) return Axi4LiteToMasterAry_t is
    variable ToRet : Axi4LiteToMasterAry_t(recs'length - 1 downto 0);
  begin
    for i in 0 to recs'length - 1 loop
      ToRet(i) := Unflatten(recs(i));
    end loop;
    return ToRet;
  end function Unflatten;

  function Flatten (recs : Axi4LiteToMasterAry_t) return std_logic_vector is
    variable Inter : Axi4LiteToMasterFlatAry_t(recs'length - 1 downto 0);
    variable ToRet : std_logic_vector(Axi4LiteToMasterFlat_t'length * recs'length - 1 downto 0);
  begin
    Inter := Flatten(recs);
    for i in 0 to recs'length - 1 loop
      ToRet(Axi4LiteToMasterFlat_t'length * (i + 1) - 1 downto Axi4LiteToMasterFlat_t'length * i) := Inter(i);
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten (recs : std_logic_vector) return Axi4LiteToMasterAry_t is
    constant kArySize : natural := recs'length / Axi4LiteToMasterFlat_t'length;
    variable Inter : Axi4LiteToMasterFlatAry_t(kArySize - 1 downto 0);
    variable ToRet : Axi4LiteToMasterAry_t(kArySize - 1 downto 0);
  begin
    --synopsys translate_off
    assert (recs'length rem Axi4LiteToMasterFlat_t'length) = 0
      report "The Flattened SLV length for Axi4LiteToMasterAry_t must be a multiple of Axi4LiteToMasterFlat_t'length"
      severity failure;
    --synopsys translate_on
    for i in 0 to kArySize - 1 loop
      Inter(i) := Axi4LiteToMasterFlat_t(recs(Axi4LiteToMasterFlat_t'length * (i + 1) - 1 downto Axi4LiteToMasterFlat_t'length * i));
    end loop;
    ToRet := Unflatten(Inter);
    return ToRet;
  end function Unflatten;

end package body PkgAxi4Lite;
