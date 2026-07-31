-------------------------------------------------------------------------------
--
-- File: PkgDphyPinMapping.vhd
-- Author: Neil Klug
-- Original Project: Chimera
-- Date: 27 March 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--    Map the DPhy pins for both TX and RX to the CLIP GPIO top level pins.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgMipiTypes.all;

package PkgDphyPinMapping is

  --
  -- Expected layout for DphyPinMap_t is (Data0, Data1, Data2, Data3, Clk).
  type DphyPinMap_t is array (0 to 4) of natural;
  type DphyPinMapAry_t is array (natural range <>) of DphyPinMap_t;

  --
  -- NI148x_01 is 8 Rx.
  constant kNI148x01DphyPinMapSI : DphyPinMapAry_t(7 downto 0) := (
    0 => (19,  8, 18, 20, 11),
    1 => ( 5,  7, 13,  3, 15),
    2 => (25, 22, 34, 31, 24),
    3 => (33, 26, 23, 36, 28),
    4 => (12,  4, 16, 21, 14),
    5 => ( 0, 10,  2,  6,  9),
    6 => (35, 39, 44, 41, 43),
    7 => (32, 38, 30, 42, 29)
  );

  --
  -- NI148x_02 is 8 Tx.
  constant kNI148x02DphyPinMapSO : DphyPinMapAry_t(7 downto 0) := (
    0 => (19,  8, 18, 20, 11),
    1 => ( 5,  7, 13,  3, 15),
    2 => (25, 22, 34, 31, 24),
    3 => (33, 26, 23, 36, 28),
    4 => (12,  4, 16, 21, 14),
    5 => ( 0, 10,  2,  6,  9),
    6 => (35, 39, 44, 41, 43),
    7 => (32, 38, 30, 42, 29)
  );

  --
  -- NI148x_03 is 4Rx/4Tx, therefore, we need two constants for Rx and Tx.
  constant kNI148x03DphyPinMapSO : DphyPinMapAry_t(3 downto 0) := (
    0 => (19,  8, 18, 20, 11),
    1 => (25, 22, 34, 31, 24),
    2 => (12,  4, 16, 21, 14),
    3 => (35, 39, 44, 41, 43)
  );
  constant kNI148x03DphyPinMapSI : DphyPinMapAry_t(3 downto 0) := (
    0 => ( 5,  7, 13,  3, 15),
    1 => (33, 26, 23, 36, 28),
    2 => ( 0, 10,  2,  6,  9),
    3 => (32, 38, 30, 42, 29)
  );

  function MapGpioToRx(DiffGpio_p, DiffGpio_n : std_logic_vector; PinMap : DphyPinMapAry_t) return MipiPinsAry_t;
  function MapTxToGpio(DiffGpio : std_logic_vector; PosNotNeg : boolean; MipiPins : MipiPinsAry_t; PinMap : DphyPinMapAry_t) return std_logic_vector;
end package PkgDphyPinMapping;

package body PkgDphyPinMapping is

  --
  -- Constants for accessing the pins in the DphyPinMap_t.
  constant kDphyPinMapData0 : natural := 0;
  constant kDphyPinMapClk   : natural := 4;

  function MapGpioToRx(DiffGpio_p, DiffGpio_n : std_logic_vector; PinMap : DphyPinMapAry_t) return MipiPinsAry_t is
    variable ToRet : MipiPinsAry_t(PinMap'length - 1 downto 0);
  begin
    for i in 0 to PinMap'length - 1 loop
      ToRet(i).Clk_p := DiffGpio_p(PinMap(i)(kDphyPinMapClk));
      ToRet(i).Clk_n := DiffGpio_n(PinMap(i)(kDphyPinMapClk));
      for j in 0 to 3 loop
        ToRet(i).cData_p(j) := DiffGpio_p(PinMap(i)(kDphyPinMapData0 + j));
        ToRet(i).cData_n(j) := DiffGpio_n(PinMap(i)(kDphyPinMapData0 + j));
      end loop;
    end loop;
    return ToRet;
  end function MapGpioToRx;

  function MapTxToGpio(DiffGpio : std_logic_vector; PosNotNeg : boolean; MipiPins : MipiPinsAry_t; PinMap : DphyPinMapAry_t) return std_logic_vector is
    variable ToRet : std_logic_vector(DiffGpio'range) := (others => 'Z');
  begin
    for i in 0 to PinMap'length - 1 loop
      if PosNotNeg then
        ToRet(PinMap(i)(kDphyPinMapClk)) := MipiPins(i).Clk_p ;
      else
        ToRet(PinMap(i)(kDphyPinMapClk)) := MipiPins(i).Clk_n;
      end if;
      for j in 0 to 3 loop
        if PosNotNeg then
          ToRet(PinMap(i)(kDphyPinMapData0 + j)) := MipiPins(i).cData_p(j);
        else
          ToRet(PinMap(i)(kDphyPinMapData0 + j)) := MipiPins(i).cData_n(j);
        end if;
      end loop;
    end loop;
    return ToRet;
  end function MapTxToGpio;

end package body PkgDphyPinMapping;
