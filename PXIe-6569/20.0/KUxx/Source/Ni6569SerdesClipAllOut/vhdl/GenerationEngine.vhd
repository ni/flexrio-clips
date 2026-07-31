-------------------------------------------------------------------------------
--
-- File: GenerationEngine.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 10 December 2019
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
-- Purpose: The Generation engine instantiates all the components needed
-- to generate LVDS, SE and PFI channels data.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PkgNi6569.all;

entity GenerationEngine is
  generic (
    kNumChannels      : natural := 32;
    kIoDelayGroupName : string  := "OdelayGroup"
  );
  port (
    -- Clocks, Reset & Control
    aResetDelay            : in std_logic;
    aResetSerdes           : in std_logic;
    GenClkDiv              : in std_logic;
    GenClk                 : in std_logic;
    TxDataClk              : in std_logic;
    aIoOutputEnable        : in std_logic;
    aDelayCtrlRdy          : in std_logic;

    -- Slow Generation Data
    tLvdsGenData      : in  SerArray_t(kNumChannels-1 downto 0);

    -- Serialized data
    gLvdsOutput       : out std_logic_vector(kNumChannels-1 downto 0);

    -- Channel Tristate signals
    gGenDataTristate   : out std_logic_vector(kNumChannels-1 downto 0);

    --OSERDES and ODELAY control
    tTxInc            : in std_logic_vector(kNumChannels-1 downto 0);
    tTxClkDelayEn     : in std_logic_vector(kNumChannels-1 downto 0);
    tDlyCount         : in DelayArray_t(kNumChannels-1 downto 0);
    tTxCntValOut      : out DelayArray_t(kNumChannels-1 downto 0);
    tIncDecReady      : out std_logic_vector(kNumChannels-1 downto 0)
  );
end GenerationEngine;

architecture RTL of GenerationEngine is

  --vhook_sigstart
  --vhook_sigend

begin

  ------------------------------------------------------------------------
  -- Instantiate the data channels serialization blocks
  ------------------------------------------------------------------------
  --
  -- User can duplicate these Serializer blocks to create additional
  -- channels by modifying the kNumChannels generics. By default, all channels
  -- serialize by a factor of 8.
  ------------------------------------------------------------------------

  --vhook_e Serializer         DataSer
  --vhook_a gTristateOut       gGenDataTristate
  DataSer: entity work.Serializer (RTL)
    generic map (
      kNumChannels      => kNumChannels,       --natural:=32
      kIoDelayGroupName => kIoDelayGroupName)  --string:="OdelayGroup"
    port map (
      aResetDelay     => aResetDelay,       --in  std_logic
      aResetSerdes    => aResetSerdes,      --in  std_logic
      GenClkDiv       => GenClkDiv,         --in  std_logic
      GenClk          => GenClk,            --in  std_logic
      TxDataClk       => TxDataClk,         --in  std_logic
      aIoOutputEnable => aIoOutputEnable,   --in  std_logic
      aDelayCtrlRdy   => aDelayCtrlRdy,     --in  std_logic
      tTxInc          => tTxInc,            --in  std_logic_vector(kNumChannels-1:0)
      tTxClkDelayEn   => tTxClkDelayEn,     --in  std_logic_vector(kNumChannels-1:0)
      tDlyCount       => tDlyCount,         --in  DelayArray_t(kNumChannels-1:0)
      tTxCntValOut    => tTxCntValOut,      --out DelayArray_t(kNumChannels-1:0)
      tIncDecReady    => tIncDecReady,      --out std_logic_vector(kNumChannels-1:0)
      tLvdsGenData    => tLvdsGenData,      --in  SerArray_t(kNumChannels-1:0)
      gLvdsOutput     => gLvdsOutput,       --out std_logic_vector(kNumChannels-1:0)
      gTristateOut    => gGenDataTristate); --out std_logic_vector(kNumChannels-1:0)

end RTL;
