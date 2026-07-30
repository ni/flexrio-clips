-------------------------------------------------------------------------------
--
-- File: PinsMapping.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 24th April 2020
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
--  Define pins mapping direction and numbering based on Cerberus HIHO front panel.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use work.PkgNiUtilities.all;
  use unisim.vcomponents.all;

entity PinsMapping is
  port (
    -- Reset and clock
    aDiagramResetSL      : in std_logic;
    SeRegisterClk        : in std_logic;
    aIoOutputEnable      : in std_logic;
    -- Adapter Module I/O
    aDiffGpio_p          : inout std_logic_vector(69 downto 0);
    aDiffGpio_n          : inout std_logic_vector(69 downto 0);
    aSeGpio              : inout std_logic_vector(15 downto 0);
    -- SE Data
    aSeDir               : in std_logic_vector(7 downto 0);
    aSeOutput            : in std_logic_vector(7 downto 0);
    aSeInput             : out std_logic_vector(7 downto 0);
    -- LVDS Data
    aGenDataTristate     : in std_logic_vector(31 downto 0);
    aLvdsOutput          : in std_logic_vector(31 downto 0);
    aLvdsInput           : out std_logic_vector(31 downto 0);
    -- PFI Data
    aLvdsPfiDir          : in std_logic_vector(1 downto 0);
    aLvdsPfiOutput       : in std_logic_vector(1 downto 0);
    aLvdsPfiInput        : out std_logic_vector(1 downto 0)
  );
end entity PinsMapping;

architecture rtl of PinsMapping is

  component IoLogic
    generic (kDataWidth : integer := 32);
    port (
      aGpio_p               : inout std_logic_vector(kDataWidth-1 downto 0);
      aGpio_n               : inout std_logic_vector(kDataWidth-1 downto 0);
      aGpioFpgaBufOe        : in  std_logic_vector(kDataWidth-1 downto 0);
      aSeGpio               : inout std_logic_vector(15 downto 0);
      aSeFpgaBufOe          : in  std_logic_vector(7 downto 0);
      aDiffInputFromFpgaBuf : out std_logic_vector(kDataWidth-1 downto 0);
      aDiffOutputToFpgaBuf  : in  std_logic_vector(kDataWidth-1 downto 0);
      aSeInputFromFpgaBuf   : out std_logic_vector(7 downto 0);
      aSeOutputToFpgaBuf    : in  std_logic_vector(7 downto 0);
      aExtSeBufDir          : in  std_logic_vector(7 downto 0));
  end component;

  --vhook_sigstart
  signal aDiffFpgaBufOe: std_logic_vector(69 downto 0);
  signal aDiffInputFromFpgaBuf: std_logic_vector(69 downto 0);
  signal aDiffOutputToFpgaBuf: std_logic_vector(69 downto 0);
  signal aExtSeBufDirVec: std_logic_vector(7 downto 0);
  signal asDiagramReset: boolean;
  --vhook_sigend
  signal aSeFpgaBufOeVec    : std_logic_vector(7 downto 0);
  signal aSeFpgaBufOeVecLcl : std_logic_vector(7 downto 0);
  signal aPfiFpgaBufOe      : std_logic_vector(1 downto 0);

begin

  --vhook_e ResetSyncDeassert SeRegisterClkRSD
  --vhook_a Clk               SeRegisterClk
  --vhook_a aReset            to_Boolean(aDiagramResetSL)
  --vhook_a acReset           asDiagramReset
  SeRegisterClkRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => SeRegisterClk,                --in  std_logic
      aReset  => to_Boolean(aDiagramResetSL),  --in  boolean
      acReset => asDiagramReset);              --out boolean

 --vhook IoLogic
 --vhook_a kDataWidth             70
 --vhook_a aGpio_p                aDiffGpio_p
 --vhook_a aGpio_n                aDiffGpio_n
 --vhook_a aGpioFpgaBufOe         aDiffFpgaBufOe
 --vhook_a aSeFpgaBufOe           aSeFpgaBufOeVec
 --vhook_a aSeInputFromFpgaBuf    aSeInput
 --vhook_a aSeOutputToFpgaBuf     aSeOutput
 --vhook_a aExtSeBufDir           aExtSeBufDirVec
 IoLogicx: IoLogic
   generic map (kDataWidth => 70)  --integer:=32
   port map (
     aGpio_p               => aDiffGpio_p,            --inout std_logic_vector(kDataWidth-1:0)
     aGpio_n               => aDiffGpio_n,            --inout std_logic_vector(kDataWidth-1:0)
     aGpioFpgaBufOe        => aDiffFpgaBufOe,         --in  std_logic_vector(kDataWidth-1:0)
     aSeGpio               => aSeGpio,                --inout std_logic_vector(15:0)
     aSeFpgaBufOe          => aSeFpgaBufOeVec,        --in  std_logic_vector(7:0)
     aDiffInputFromFpgaBuf => aDiffInputFromFpgaBuf,  --out std_logic_vector(kDataWidth-1:0)
     aDiffOutputToFpgaBuf  => aDiffOutputToFpgaBuf,   --in  std_logic_vector(kDataWidth-1:0)
     aSeInputFromFpgaBuf   => aSeInput,               --out std_logic_vector(7:0)
     aSeOutputToFpgaBuf    => aSeOutput,              --in  std_logic_vector(7:0)
     aExtSeBufDir          => aExtSeBufDirVec);       --in  std_logic_vector(7:0)


  -- LVDS Output Enable signal to IOBUF
  aDiffFpgaBufOe  <= ( 28 => not aGenDataTristate(0),
                       23 => not aGenDataTristate(1),
                       29 => not aGenDataTristate(2),
                       33 => not aGenDataTristate(3),
                       41 => not aGenDataTristate(4),
                       38 => not aGenDataTristate(5),
                       34 => not aGenDataTristate(6),
                       42 => not aGenDataTristate(7),
                       30 => not aGenDataTristate(8),
                       43 => not aGenDataTristate(9),
                       22 => not aGenDataTristate(10),
                       26 => not aGenDataTristate(11),
                       24 => not aGenDataTristate(12),
                       25 => not aGenDataTristate(13),
                       27 => not aGenDataTristate(14),
                       31 => not aGenDataTristate(15),
                       32 => not aGenDataTristate(16),
                       40 => not aGenDataTristate(17),
                       36 => not aGenDataTristate(18),
                       45 => not aGenDataTristate(19),
                       39 => not aGenDataTristate(20),
                       4  => not aGenDataTristate(21),
                       8  => not aGenDataTristate(22),
                       12 => not aGenDataTristate(23),
                       11 => not aGenDataTristate(24),
                       16 => not aGenDataTristate(25),
                       14 => not aGenDataTristate(26),
                       19 => not aGenDataTristate(27),
                       17 => not aGenDataTristate(28),
                       21 => not aGenDataTristate(29),
                       20 => not aGenDataTristate(30),
                       18 => not aGenDataTristate(31),
                       55 => aPfiFpgaBufOe(0),
                       52 => aPfiFpgaBufOe(1),
                       others => '0');

  aPfiFpgaBufOe(0) <= '1' when aLvdsPfiDir(0) = '1' and aIoOutputEnable = '1' else '0';
  aPfiFpgaBufOe(1) <= '1' when aLvdsPfiDir(1) = '1' and aIoOutputEnable = '1' else '0';

  -- LVDS Input data to IOBUF
  aDiffOutputToFpgaBuf <= ( 28 => aLvdsOutput(0),
                            23 => aLvdsOutput(1),
                            29 => aLvdsOutput(2),
                            33 => aLvdsOutput(3),
                            41 => aLvdsOutput(4),
                            38 => aLvdsOutput(5),
                            34 => aLvdsOutput(6),
                            42 => aLvdsOutput(7),
                            30 => aLvdsOutput(8),
                            43 => aLvdsOutput(9),
                            22 => aLvdsOutput(10),
                            26 => aLvdsOutput(11),
                            24 => aLvdsOutput(12),
                            25 => aLvdsOutput(13),
                            27 => aLvdsOutput(14),
                            31 => aLvdsOutput(15),
                            32 => aLvdsOutput(16),
                            40 => aLvdsOutput(17),
                            36 => aLvdsOutput(18),
                            45 => aLvdsOutput(19),
                            39 => aLvdsOutput(20),
                            4  => aLvdsOutput(21),
                            8  => aLvdsOutput(22),
                            12 => aLvdsOutput(23),
                            11 => aLvdsOutput(24),
                            16 => aLvdsOutput(25),
                            14 => aLvdsOutput(26),
                            19 => aLvdsOutput(27),
                            17 => aLvdsOutput(28),
                            21 => aLvdsOutput(29),
                            20 => aLvdsOutput(30),
                            18 => aLvdsOutput(31),
                            -- PFI start here
                            55 => aLvdsPfiOutput(0),
                            52 => aLvdsPfiOutput(1),
                            others => '0');

  -- LVDS Output data from IOBUF
  aLvdsInput <= ( 0 => aDiffInputFromFpgaBuf(46),
                  1 => aDiffInputFromFpgaBuf(48),
                  2 => aDiffInputFromFpgaBuf(47),
                  3 => aDiffInputFromFpgaBuf(51),
                  4 => aDiffInputFromFpgaBuf(69),
                  5 => aDiffInputFromFpgaBuf(63),
                  6 => aDiffInputFromFpgaBuf(56),
                  7 => aDiffInputFromFpgaBuf(61),
                  8 => aDiffInputFromFpgaBuf(64),
                  9 => aDiffInputFromFpgaBuf(66),
                  10 => aDiffInputFromFpgaBuf(58),
                  11 => aDiffInputFromFpgaBuf(50),
                  12 => aDiffInputFromFpgaBuf(49),
                  13 => aDiffInputFromFpgaBuf(53),
                  14 => aDiffInputFromFpgaBuf(67),
                  15 => aDiffInputFromFpgaBuf(65),
                  16 => aDiffInputFromFpgaBuf(59),
                  17 => aDiffInputFromFpgaBuf(57),
                  18 => aDiffInputFromFpgaBuf(60),
                  19 => aDiffInputFromFpgaBuf(62),
                  20 => aDiffInputFromFpgaBuf(68),
                  21 => aDiffInputFromFpgaBuf(0),
                  22 => aDiffInputFromFpgaBuf(1),
                  23 => aDiffInputFromFpgaBuf(3),
                  24 => aDiffInputFromFpgaBuf(5),
                  25 => aDiffInputFromFpgaBuf(9),
                  26 => aDiffInputFromFpgaBuf(7),
                  27 => aDiffInputFromFpgaBuf(2),
                  28 => aDiffInputFromFpgaBuf(10),
                  29 => aDiffInputFromFpgaBuf(15),
                  30 => aDiffInputFromFpgaBuf(13),
                  31 => aDiffInputFromFpgaBuf(6));

  aLvdsPfiInput <= ( 0 => aDiffInputFromFpgaBuf(55),
                     1 => aDiffInputFromFpgaBuf(52));

  -- When SE_DIR is HIGH, generation mode.
  -- When SE_DIR is LOW, acquisition mode.

  SeDirectionControl: for i in 0 to 7 generate
    --vhook_e DirectionStateControl SeDataDirCtrl
    --vhook_a aReset                to_StdLogic(asDiagramReset)
    --vhook_a RegisterClk           SeRegisterClk
    --vhook_a aSeDir                aSeDir(i)
    --vhook_a aSeOutputEn           aSeFpgaBufOeVecLcl(i)
    SeDataDirCtrl: entity work.DirectionStateControl (rtl)
      port map (
        aReset      => to_StdLogic(asDiagramReset),  --in  std_logic
        RegisterClk => SeRegisterClk,                --in  std_logic
        aSeDir      => aSeDir(i),                    --in  std_logic
        aSeOutputEn => aSeFpgaBufOeVecLcl(i));       --out std_logic

    aSeFpgaBufOeVec(i) <= '1' when aSeFpgaBufOeVecLcl(i) = '1' and aIoOutputEnable = '1' else '0';
    aExtSeBufDirVec(i) <= '1' when aSeDir(i) = '1' and aIoOutputEnable = '1' else '0';

  end generate SeDirectionControl;

end rtl;