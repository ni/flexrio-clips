-------------------------------------------------------------------------------
--
-- File: PkgAxiVideoStream.vhd
-- Author: Craig Conway
-- Original Project: Chimera
-- Date: 4 March 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This file contains constants, records, and types for an AXI
-- video stream.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

package PkgAxiVideoStream is

  -- These constants control the width of the fields of the AxiVideoStream_t record
  constant kAxiVideoStreamDataWidth : integer := 32;
  constant kAxiVideoStreamStrbWidth : natural := kAxiVideoStreamDataWidth/8;
  constant kAxiVideoStreamKeepWidth : natural := kAxiVideoStreamDataWidth/8;
  constant kAxiVideoStreamDestWidth  : integer := 4;
  constant kAxiVideoStreamUserWidth  : integer := 64;
  constant kAxiVideoStreamIDWidth  : integer := 4;
  constant kAxiVideoStreamValidWidth  : integer := 1;
  constant kAxiVideoStreamLastWidth  : integer := 1;

  -- These vectors make flattening and unflattening easier
  subtype TDataVec_t is std_logic_vector(kAxiVideoStreamDataWidth-1 downto 0);
  subtype TDataUpperDwordVec_t is std_logic_vector(TDataVec_t'high+kAxiVideoStreamDataWidth downto TDataVec_t'high+1);
  subtype TRawDataVec_t is std_logic_vector(TDataUpperDwordVec_t'high+kAxiVideoStreamDataWidth downto TDataUpperDwordVec_t'high+1);
  subtype TRawDataUpperDwordVec_t is std_logic_vector(TRawDataVec_t'high+kAxiVideoStreamDataWidth downto TRawDataVec_t'high+1);
  subtype TStrbVec_t is std_logic_vector(TRawDataUpperDwordVec_t'high+kAxiVideoStreamStrbWidth downto TRawDataUpperDwordVec_t'high+1);
  subtype TStrbUpperDwordVec_t is std_logic_vector(TStrbVec_t'high+kAxiVideoStreamStrbWidth downto TStrbVec_t'high+1);
  subtype TKeepVec_t is std_logic_vector(TStrbUpperDwordVec_t'high+kAxiVideoStreamKeepWidth downto TStrbUpperDwordVec_t'high+1);
  subtype TKeepUpperDwordVec_t is std_logic_vector(TKeepVec_t'high+kAxiVideoStreamKeepWidth downto TKeepVec_t'high+1);
  subtype TIDVec_t is std_logic_vector(TKeepUpperDwordVec_t'high+kAxiVideoStreamIDWidth downto TKeepUpperDwordVec_t'high+1);
  subtype TDestVec_t is std_logic_vector(TIDVec_t'high+kAxiVideoStreamDestWidth downto TIDVec_t'high+1);
  subtype TUserVec_t is std_logic_vector(TDestVec_t'high+kAxiVideoStreamUserWidth downto TDestVec_t'high+1);
  subtype TValidVec_t is std_logic_vector(TUserVec_t'high+kAxiVideoStreamValidWidth downto TUserVec_t'high+1);
  subtype TLastVec_t is std_logic_vector(TValidVec_t'high+kAxiVideoStreamLastWidth downto TValidVec_t'high+1);

  -- Width of the entire flattened vector
  constant kAxiVideoStreamWidth : natural := TDataVec_t'length + TDataUpperDwordVec_t'length +
                                             TRawDataVec_t'length + TRawDataUpperDwordVec_t'length +
                                             TStrbVec_t'length + TStrbUpperDwordVec_t'length + 
                                             TKeepVec_t'length + TKeepUpperDwordVec_t'length +
                                             TIDVec_t'length + TDestVec_t'length + TUserVec_t'length +
                                             TValidVec_t'length + TLastVec_t'length;

  -- Note that this type includes two data streams. Normally, TRawData is not used; however,
  -- in the case of the Rx, the ECC circuit may correct header information. The TRawData
  -- shows the uncorrected information so that the user has the ability to see both.
  type AxiVideoStream_t is record
    TData, TRawData  : std_logic_vector(TDataVec_t'length-1 downto 0);
    TDataUpperDword, TRawDataUpperDword  : std_logic_vector(TDataVec_t'length-1 downto 0);
    TStrb, TStrbUpperDWord : std_logic_vector(TStrbVec_t'length-1 downto 0);
    TKeep, TKeepUpperDWord : std_logic_vector(TKeepVec_t'length-1 downto 0);
    TID    : std_logic_vector(TIDVec_t'length-1 downto 0);
    TDest  : std_logic_vector(TDestVec_t'length-1 downto 0);
    TUser  : std_logic_vector(TUserVec_t'length-1 downto 0); -- bit positions defined in register map
    TValid : std_logic;
    TLast  : std_logic;
  end record;

  constant kAxiVideoStreamZero : AxiVideoStream_t := (
    TData => (others=>'0'),
    TDataUpperDWord => (others=>'0'),
    TRawData => (others=>'0'),
    TRawDataUpperDWord => (others=>'0'),
    TStrb => (others=>'0'),
    TStrbUpperDWord => (others=>'0'),
    TKeep => (others=>'0'),
    TKeepUpperDWord => (others=>'0'),
    TID => (others=>'0'),
    TDest => (others=>'0'),
    TUser => (others=>'0'),
    others=>'0'
  );

  -- Types, subtypes, and functions for converting between flat and unflat records
  type AxiVideoStreamAry_t is array (natural range <>) of AxiVideoStream_t;
  subtype AxiVideoStreamFlat_t is std_logic_vector(kAxiVideoStreamWidth-1 downto 0);

  function Flatten(Rec : AxiVideoStream_t) return AxiVideoStreamFlat_t;
  function Unflatten(Vec : AxiVideoStreamFlat_t) return AxiVideoStream_t;

  type AxiVideoStreamFlatAry_t is array (natural range <>) of AxiVideoStreamFlat_t;
  function Flatten(Arr : AxiVideoStreamAry_t) return AxiVideoStreamFlatAry_t;
  function Unflatten(Arr : AxiVideoStreamFlatAry_t) return AxiVideoStreamAry_t;

end PkgAxiVideoStream;

package body PkgAxiVideoStream is

  function Flatten(Rec : AxiVideoStream_t) return AxiVideoStreamFlat_t is
    variable Vec : AxiVideoStreamFlat_t;
  begin
    Vec(TDataVec_t'range)              := Rec.TData;
    Vec(TDataUpperDwordVec_t'range)    := Rec.TDataUpperDWord;
    Vec(TRawDataVec_t'range)           := Rec.TRawData;
    Vec(TRawDataUpperDwordVec_t'range) := Rec.TRawDataUpperDword;
    Vec(TStrbVec_t'range)              := Rec.TStrb;
    Vec(TStrbUpperDwordVec_t'range)    := Rec.TStrbUpperDword;
    Vec(TKeepVec_t'range)              := Rec.TKeep;
    Vec(TKeepUpperDwordVec_t'range)    := Rec.TKeepUpperDword;
    Vec(TIDVec_t'range)                := Rec.TID;
    Vec(TDestVec_t'range)              := Rec.TDest;
    Vec(TUserVec_t'range)              := Rec.TUser;
    Vec(TValidVec_t'low)               := Rec.TValid;
    Vec(TLastVec_t'low)                := Rec.TLast;
    return Vec;
  end function Flatten;

  function Unflatten(Vec : AxiVideoStreamFlat_t) return AxiVideoStream_t is
    variable Rec : AxiVideoStream_t;
  begin
    Rec := (
      TData              => Vec(TDataVec_t'range),
      TDataUpperDWord    => Vec(TDataUpperDwordVec_t'range),
      TRawData           => Vec(TRawDataVec_t'range),
      TRawDataUpperDword => Vec(TRawDataUpperDwordVec_t'range),
      TStrb              => Vec(TStrbVec_t'range),
      TStrbUpperDword    => Vec(TStrbUpperDwordVec_t'range),
      TKeep              => Vec(TKeepVec_t'range),
      TKeepUpperDword    => Vec(TKeepUpperDwordVec_t'range),
      TID                => Vec(TIDVec_t'range),
      TDest              => Vec(TDestVec_t'range),
      TUser              => Vec(TUserVec_t'range),
      TValid             => Vec(TValidVec_t'low),
      TLast              => Vec(TLastVec_t'low)
    ); return Rec;
  end function Unflatten;

  function Flatten(Arr : AxiVideoStreamAry_t) return AxiVideoStreamFlatAry_t is
    variable ToRet : AxiVideoStreamFlatAry_t(Arr'length - 1 downto 0);
  begin
    for i in 0 to Arr'length - 1 loop
      ToRet(i) := Flatten(Arr(i));
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten(Arr : AxiVideoStreamFlatAry_t) return AxiVideoStreamAry_t is
    variable ToRet : AxiVideoStreamAry_t(Arr'length - 1 downto 0);
  begin
    for i in 0 to Arr'length - 1 loop
      ToRet(i) := Unflatten(Arr(i));
    end loop;
    return ToRet;
  end function Unflatten;
end package body;

--shameful_comment 12
