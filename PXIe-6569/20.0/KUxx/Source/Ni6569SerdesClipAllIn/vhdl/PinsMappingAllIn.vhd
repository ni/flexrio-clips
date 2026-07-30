-------------------------------------------------------------------------------
--
-- File: PinsMappingAllIn.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 26th April 2020
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
--  Define pins mapping direction and numbering based on Cerberus ALL IN front panel.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use work.PkgNiUtilities.all;
  use unisim.vcomponents.all;

entity PinsMappingAllIn is
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
    aLvdsInput           : out std_logic_vector(63 downto 0);
    -- PFI Data
    aLvdsPfiDir          : in std_logic_vector(1 downto 0);
    aLvdsPfiOutput       : in std_logic_vector(1 downto 0);
    aLvdsPfiInput        : out std_logic_vector(1 downto 0)
  );
end entity PinsMappingAllIn;

architecture rtl of PinsMappingAllIn is

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
  aDiffFpgaBufOe  <= ( 55 => aPfiFpgaBufOe(0),
                       52 => aPfiFpgaBufOe(1),
                       others => '0');

  aPfiFpgaBufOe(0) <= '1' when aLvdsPfiDir(0) = '1' and aIoOutputEnable = '1' else '0';
  aPfiFpgaBufOe(1) <= '1' when aLvdsPfiDir(1) = '1' and aIoOutputEnable = '1' else '0';

  -- LVDS Input data to IOBUF
  aDiffOutputToFpgaBuf <= ( 55 => aLvdsPfiOutput(0),
                            52 => aLvdsPfiOutput(1),
                            others => '0');

  -- LVDS Output data from IOBUF
  aLvdsInput <= ( 0  => aDiffInputFromFpgaBuf(28),
                  1  => aDiffInputFromFpgaBuf(23),
                  2  => aDiffInputFromFpgaBuf(29),
                  3  => aDiffInputFromFpgaBuf(33),
                  4  => aDiffInputFromFpgaBuf(41),
                  5  => aDiffInputFromFpgaBuf(38),
                  6  => aDiffInputFromFpgaBuf(34),
                  7  => aDiffInputFromFpgaBuf(42),
                  8  => aDiffInputFromFpgaBuf(30),
                  9  => aDiffInputFromFpgaBuf(43),
                  10 => aDiffInputFromFpgaBuf(22),
                  11 => aDiffInputFromFpgaBuf(26),
                  12 => aDiffInputFromFpgaBuf(24),
                  13 => aDiffInputFromFpgaBuf(25),
                  14 => aDiffInputFromFpgaBuf(27),
                  15 => aDiffInputFromFpgaBuf(31),
                  16 => aDiffInputFromFpgaBuf(32),
                  17 => aDiffInputFromFpgaBuf(40),
                  18 => aDiffInputFromFpgaBuf(36),
                  19 => aDiffInputFromFpgaBuf(45),
                  20 => aDiffInputFromFpgaBuf(39),
                  21 => aDiffInputFromFpgaBuf(4),
                  22 => aDiffInputFromFpgaBuf(8),
                  23 => aDiffInputFromFpgaBuf(12),
                  24 => aDiffInputFromFpgaBuf(11),
                  25 => aDiffInputFromFpgaBuf(16),
                  26 => aDiffInputFromFpgaBuf(14),
                  27 => aDiffInputFromFpgaBuf(19),
                  28 => aDiffInputFromFpgaBuf(17),
                  29 => aDiffInputFromFpgaBuf(21),
                  30 => aDiffInputFromFpgaBuf(20),
                  31 => aDiffInputFromFpgaBuf(18),
                  32 => aDiffInputFromFpgaBuf(0),
                  33 => aDiffInputFromFpgaBuf(1),
                  34 => aDiffInputFromFpgaBuf(3),
                  35 => aDiffInputFromFpgaBuf(5),
                  36 => aDiffInputFromFpgaBuf(9),
                  37 => aDiffInputFromFpgaBuf(7),
                  38 => aDiffInputFromFpgaBuf(2),
                  39 => aDiffInputFromFpgaBuf(10),
                  40 => aDiffInputFromFpgaBuf(15),
                  41 => aDiffInputFromFpgaBuf(13),
                  42 => aDiffInputFromFpgaBuf(6),
                  43 => aDiffInputFromFpgaBuf(58),
                  44 => aDiffInputFromFpgaBuf(50),
                  45 => aDiffInputFromFpgaBuf(49),
                  46 => aDiffInputFromFpgaBuf(53),
                  47 => aDiffInputFromFpgaBuf(67),
                  48 => aDiffInputFromFpgaBuf(65),
                  49 => aDiffInputFromFpgaBuf(59),
                  50 => aDiffInputFromFpgaBuf(57),
                  51 => aDiffInputFromFpgaBuf(60),
                  52 => aDiffInputFromFpgaBuf(62),
                  53 => aDiffInputFromFpgaBuf(68),
                  54 => aDiffInputFromFpgaBuf(46),
                  55 => aDiffInputFromFpgaBuf(48),
                  56 => aDiffInputFromFpgaBuf(47),
                  57 => aDiffInputFromFpgaBuf(51),
                  58 => aDiffInputFromFpgaBuf(69),
                  59 => aDiffInputFromFpgaBuf(63),
                  60 => aDiffInputFromFpgaBuf(56),
                  61 => aDiffInputFromFpgaBuf(61),
                  62 => aDiffInputFromFpgaBuf(64),
                  63 => aDiffInputFromFpgaBuf(66));

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