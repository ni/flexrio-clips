-------------------------------------------------------------------------------
--
-- File: AcquisitionEngine.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 11 December 2019
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
-- Purpose: The Acquisition engine contains all the components to capture
-- LVDS, SE and PFI channels data. It instantiates the deserializer and the
-- BitSlip modules
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgNi6569.all;

entity AcquisitionEngine is
  generic (
    kNumChannels          : natural := 31;
    kIoDelayGroupName     : string := "IdelayGroup"
  );
  port (
    -- Clocks and Reset
    aDiagramResetSL        : in std_logic;
    aResetDelay            : in std_logic;
    aResetSerdes           : in std_logic;
    AcqClk                 : in std_logic;
    AcqClkDiv              : in std_logic;
    RxDataClk              : in std_logic;

    --Data from the input buffers
    aLvdsInput             : in std_logic_vector(kNumChannels-1 downto 0);

    --Deserialized output data
    qLvdsAcqData           : out DeserArray_t(kNumChannels-1 downto 0);

    --Bitslip control
    qLvdsBitslip             : in std_logic_vector(kNumChannels-1 downto 0);

    --ISERDES and IDELAY control
    rRxInc                 : in std_logic_vector(kNumChannels-1 downto 0);
    rRxClkDelayEn          : in std_logic_vector(kNumChannels-1 downto 0);
    rDlyCount              : in DelayArray_t(kNumChannels-1 downto 0);
    rRxCntValOut           : out DelayArray_t(kNumChannels-1 downto 0);
    aDelayCtrlRdy          : in std_logic;
    rIncDecReady           : out std_logic_vector(kNumChannels-1 downto 0)
  );
end AcquisitionEngine;

architecture RTL of AcquisitionEngine is

  component SimpleBitSlip
    generic (kDataWidth : integer := 8);
    port (
      aReset   : in  std_logic;
      Clk      : in  std_logic;
      cDataIn  : in  std_logic_vector(kDataWidth-1 downto 0);
      cDataOut : out std_logic_vector(kDataWidth-1 downto 0);
      cBitslip : in  boolean);
  end component;

  --vhook_sigstart
  signal qLvdsAcqDataRaw: DeserArray_t(kNumChannels-1 downto 0);
  --vhook_sigend

begin  -- RTL

  ------------------------------------------------------------------------------
  -- Instantiate the data channels deserialization blocks
  ------------------------------------------------------------------------------
  --
  -- User can duplicate these Deserializer blocks to create additional
  -- channels by modifying the kNumChannels generics. By default, all channels
  -- deserialize by a factor of 8.
  ------------------------------------------------------------------------------

  --vhook_e Deserializer DataDeser
  --vhook_a qLvdsAcqData       qLvdsAcqDataRaw
  DataDeser: entity work.Deserializer (RTL)
    generic map (
      kNumChannels      => kNumChannels,       --natural:=32
      kIoDelayGroupName => kIoDelayGroupName)  --string:="IdelayGroup"
    port map (
      aResetDelay   => aResetDelay,      --in  std_logic
      aResetSerdes  => aResetSerdes,     --in  std_logic
      aDelayCtrlRdy => aDelayCtrlRdy,    --in  std_logic
      RxDataClk     => RxDataClk,        --in  std_logic
      AcqClkDiv     => AcqClkDiv,        --in  std_logic
      AcqClk        => AcqClk,           --in  std_logic
      aLvdsInput    => aLvdsInput,       --in  std_logic_vector(kNumChannels-1:0)
      rRxInc        => rRxInc,           --in  std_logic_vector(kNumChannels-1:0)
      rRxClkDelayEn => rRxClkDelayEn,    --in  std_logic_vector(kNumChannels-1:0)
      rDlyCount     => rDlyCount,        --in  DelayArray_t(kNumChannels-1:0)
      rRxCntValOut  => rRxCntValOut,     --out DelayArray_t(kNumChannels-1:0)
      rIncDecReady  => rIncDecReady,     --out std_logic_vector(kNumChannels-1:0)
      qLvdsAcqData  => qLvdsAcqDataRaw); --out DeserArray_t(kNumChannels-1:0)


  BitSlipGen : for i in 0 to kNumChannels-1 generate
  begin
  --vhook SimpleBitSlip
  --vhook_a kDataWidth        kDeserFactor
  --vhook_a aReset            aDiagramResetSL
  --vhook_a Clk               AcqClkDiv
  --vhook_a cDataIn           qLvdsAcqDataRaw(i)
  --vhook_a cDataOut          qLvdsAcqData(i)
  --vhook_a cBitslip          to_Boolean(qLvdsBitslip(i))
  SimpleBitSlipx: SimpleBitSlip
    generic map (kDataWidth => kDeserFactor)  --integer:=8
    port map (
      aReset   => aDiagramResetSL,              --in  std_logic
      Clk      => AcqClkDiv,                    --in  std_logic
      cDataIn  => qLvdsAcqDataRaw(i),           --in  std_logic_vector(kDataWidth-1:0)
      cDataOut => qLvdsAcqData(i),              --out std_logic_vector(kDataWidth-1:0)
      cBitslip => to_Boolean(qLvdsBitslip(i))); --in  boolean

  end generate;

end RTL;
