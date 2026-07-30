-------------------------------------------------------------------------------
--
-- File: NI148xClipTop.vhd
-- Author: Eduardo Salinas
-- Original Project: NI 148X
-- Date: 19 Aug 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--  Top level CLIP file for LabVIEW FPGA.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

library work;
  use work.PkgMipiTypes.all;
  use work.PkgDphyPinMapping.all;
  use work.PkgAxi4Lite.all;
  use work.PkgAxiVideoStream.all;

entity NI148xClipTop is
  port (
    ---------------------------------------------------------------------------
    --                     FlexRIOIoSocketType4_v1                           --
    ---------------------------------------------------------------------------

    ------------
    -- FAM IO --
    ------------
    aDiffGpio_p                            : inout std_logic_vector(45 downto 0);
    aDiffGpio_n                            : inout std_logic_vector(45 downto 0);
    aSeGpio                                : inout std_logic_vector(29 downto 0);
    -------------
    -- Support --
    -------------
    stIoModuleSupportsFRAGLs           : out std_logic;

    xIoPresent                         : in std_logic;
    xIoReady                           : in std_logic;
    xIoOutputEnable                    : in std_logic;

    aReservedToClip                    : in  std_logic_vector(15 downto 0);
    aReservedFromClip                  : out std_logic_vector(15 downto 0);
    --vhook_nowarn aReservedToClip
    -------------------------------
    -- FAM Synchronization Plane --
    -------------------------------
    DeviceClk                          : in  std_logic;
    SampleClk                          : in  std_logic;

    dtTdcAssert                        : in  std_logic;
    dvTdcAssert                        : out std_logic;
    dtDevClkEn                         : out std_logic;
    ----------------------------------
    -- AXI Communication Interfaces --
    ----------------------------------
    AxiClk                             : in  std_logic;

    --Axi4Stream to/from host
    xHostAxiStreamToClipTData          : in  std_logic_vector(31 downto 0);
    xHostAxiStreamToClipTLast          : in  std_logic;
    xHostAxiStreamFromClipTReady       : out std_logic;
    xHostAxiStreamToClipTValid         : in  std_logic;

    xHostAxiStreamFromClipTData        : out std_logic_vector(31 downto 0);
    xHostAxiStreamFromClipTLast        : out std_logic;
    xHostAxiStreamToClipTReady         : in  std_logic;
    xHostAxiStreamFromClipTValid       : out std_logic;

    --Axi4Stream to/from diagram
    xDiagramAxiStreamToClipTData       : in  std_logic_vector(31 downto 0);
    xDiagramAxiStreamToClipTLast       : in  std_logic;
    xDiagramAxiStreamFromClipTReady    : out std_logic;
    xDiagramAxiStreamToClipTValid      : in  std_logic;

    xDiagramAxiStreamFromClipTData     : out std_logic_vector(31 downto 0);
    xDiagramAxiStreamFromClipTLast     : out std_logic;
    xDiagramAxiStreamToClipTReady      : in  std_logic;
    xDiagramAxiStreamFromClipTValid    : out std_logic;

    --AXI4Lite interface To Fixed Logic
    xClipAxi4LiteMasterARAddr          : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterARProt          : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterARReady         : in  std_logic;
    xClipAxi4LiteMasterARValid         : out std_logic;

    xClipAxi4LiteMasterAWAddr          : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterAWProt          : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterAWReady         : in  std_logic;
    xClipAxi4LiteMasterAWValid         : out std_logic;

    xClipAxi4LiteMasterBReady          : out std_logic;
    xClipAxi4LiteMasterBResp           : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterBValid          : in  std_logic;

    xClipAxi4LiteMasterRData           : in  std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterRReady          : out std_logic;
    xClipAxi4LiteMasterRResp           : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterRValid          : in  std_logic;

    xClipAxi4LiteMasterWData           : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterWReady          : in  std_logic;
    xClipAxi4LiteMasterWStrb           : out std_logic_vector(3 downto 0);
    xClipAxi4LiteMasterWValid          : out std_logic;
    xClipAxi4LiteInterrupt             : in  std_logic;
    ---------------------------------------------------------------------------
    --                     Fabric Interface                                  --
    ---------------------------------------------------------------------------
    --vhook_nowarn aDiagramClkEnable
    aDiagramResetSL                    : in  std_logic;
    aDiagramClkEnable                  : in  std_logic;
    ---------------------------------------------------------------------------
    --                     LabVIEW Interface                                 --
    ---------------------------------------------------------------------------
    -- CLIP Status
    -- TopLevelClk80 is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.
    --vhook_nowarn TopLevelClk80
    TopLevelClk80                      : in  std_logic;
    xIoModuleReady                     : out std_logic;
    xIoModuleErrorCode                 : out std_logic_vector(31 downto 0);

    --Serdes GPIO
    PxieClk100                         : in  std_logic;
    IoClock                            : out std_logic;

    sDiagramDes0Mfp0In                 : out std_logic;
    sDiagramDes0Mfp0Out                : in  std_logic;
    sDiagramDes0Mfp0Oe                 : in  std_logic;
    sDiagramDes0Mfp1In                 : out std_logic;
    sDiagramDes0Mfp1Out                : in  std_logic;
    sDiagramDes0Mfp1Oe                 : in  std_logic;
    sDiagramDes0Mfp2In                 : out std_logic;
    sDiagramDes0Mfp3In                 : out std_logic;
    sDiagramDes0Mfp4In                 : out std_logic;
    sDiagramDes0Mfp4Out                : in  std_logic;
    sDiagramDes0Mfp4Oe                 : in  std_logic;
    sDiagramDes0Mfp5In                 : out std_logic;
    sDiagramDes0Mfp5Out                : in  std_logic;
    sDiagramDes0Mfp5Oe                 : in  std_logic;
    sDiagramDes0Mfp6In                 : out std_logic;
    sDiagramDes0Mfp6Out                : in  std_logic;
    sDiagramDes0Mfp6Oe                 : in  std_logic;
    sDiagramDes0Mfp7In                 : out std_logic;
    sDiagramDes0Mfp7Out                : in  std_logic;
    sDiagramDes0Mfp7Oe                 : in  std_logic;
    sDiagramDes1Mfp0In                 : out std_logic;
    sDiagramDes1Mfp0Out                : in  std_logic;
    sDiagramDes1Mfp0Oe                 : in  std_logic;
    sDiagramDes1Mfp1In                 : out std_logic;
    sDiagramDes1Mfp1Out                : in  std_logic;
    sDiagramDes1Mfp1Oe                 : in  std_logic;
    sDiagramDes1Mfp2In                 : out std_logic;
    sDiagramDes1Mfp3In                 : out std_logic;
    sDiagramDes1Mfp4In                 : out std_logic;
    sDiagramDes1Mfp4Out                : in  std_logic;
    sDiagramDes1Mfp4Oe                 : in  std_logic;
    sDiagramDes1Mfp5In                 : out std_logic;
    sDiagramDes1Mfp5Out                : in  std_logic;
    sDiagramDes1Mfp5Oe                 : in  std_logic;
    sDiagramDes1Mfp6In                 : out std_logic;
    sDiagramDes1Mfp6Out                : in  std_logic;
    sDiagramDes1Mfp6Oe                 : in  std_logic;
    sDiagramDes1Mfp7In                 : out std_logic;
    sDiagramDes1Mfp7Out                : in  std_logic;
    sDiagramDes1Mfp7Oe                 : in  std_logic;
    sDiagramDes2Mfp0In                 : out std_logic;
    sDiagramDes2Mfp0Out                : in  std_logic;
    sDiagramDes2Mfp0Oe                 : in  std_logic;
    sDiagramDes2Mfp1In                 : out std_logic;
    sDiagramDes2Mfp1Out                : in  std_logic;
    sDiagramDes2Mfp1Oe                 : in  std_logic;
    sDiagramDes2Mfp2In                 : out std_logic;
    sDiagramDes2Mfp3In                 : out std_logic;
    sDiagramDes2Mfp4In                 : out std_logic;
    sDiagramDes2Mfp4Out                : in  std_logic;
    sDiagramDes2Mfp4Oe                 : in  std_logic;
    sDiagramDes2Mfp5In                 : out std_logic;
    sDiagramDes2Mfp5Out                : in  std_logic;
    sDiagramDes2Mfp5Oe                 : in  std_logic;
    sDiagramDes2Mfp6In                 : out std_logic;
    sDiagramDes2Mfp6Out                : in  std_logic;
    sDiagramDes2Mfp6Oe                 : in  std_logic;
    sDiagramDes2Mfp7In                 : out std_logic;
    sDiagramDes2Mfp7Out                : in  std_logic;
    sDiagramDes2Mfp7Oe                 : in  std_logic;
    sDiagramDes3Mfp0In                 : out std_logic;
    sDiagramDes3Mfp0Out                : in  std_logic;
    sDiagramDes3Mfp0Oe                 : in  std_logic;
    sDiagramDes3Mfp1In                 : out std_logic;
    sDiagramDes3Mfp1Out                : in  std_logic;
    sDiagramDes3Mfp1Oe                 : in  std_logic;
    sDiagramDes3Mfp2In                 : out std_logic;
    sDiagramDes3Mfp3In                 : out std_logic;
    sDiagramDes3Mfp4In                 : out std_logic;
    sDiagramDes3Mfp4Out                : in  std_logic;
    sDiagramDes3Mfp4Oe                 : in  std_logic;
    sDiagramDes3Mfp5In                 : out std_logic;
    sDiagramDes3Mfp5Out                : in  std_logic;
    sDiagramDes3Mfp5Oe                 : in  std_logic;
    sDiagramDes3Mfp6In                 : out std_logic;
    sDiagramDes3Mfp6Out                : in  std_logic;
    sDiagramDes3Mfp6Oe                 : in  std_logic;
    sDiagramDes3Mfp7In                 : out std_logic;
    sDiagramDes3Mfp7Out                : in  std_logic;
    sDiagramDes3Mfp7Oe                 : in  std_logic;

    sDiagramDes0Mfp8In                 : out std_logic;
    sDiagramDes0Mfp8Out                : in  std_logic;
    sDiagramDes0Mfp8Oe                 : in  std_logic;
    sDiagramDes0Mfp9In                 : out std_logic;
    sDiagramDes0Mfp9Out                : in  std_logic;
    sDiagramDes0Mfp9Oe                 : in  std_logic;
    sDiagramDes0Mfp10In                : out std_logic;
    sDiagramDes0Mfp10Out               : in  std_logic;
    sDiagramDes0Mfp10Oe                : in  std_logic;
    sDiagramDes1Mfp8In                 : out std_logic;
    sDiagramDes1Mfp8Out                : in  std_logic;
    sDiagramDes1Mfp8Oe                 : in  std_logic;
    sDiagramDes1Mfp9In                 : out std_logic;
    sDiagramDes1Mfp9Out                : in  std_logic;
    sDiagramDes1Mfp9Oe                 : in  std_logic;
    sDiagramDes1Mfp10In                : out std_logic;
    sDiagramDes1Mfp10Out               : in  std_logic;
    sDiagramDes1Mfp10Oe                : in  std_logic;
    sDiagramDes2Mfp8In                 : out std_logic;
    sDiagramDes2Mfp8Out                : in  std_logic;
    sDiagramDes2Mfp8Oe                 : in  std_logic;
    sDiagramDes2Mfp9In                 : out std_logic;
    sDiagramDes2Mfp9Out                : in  std_logic;
    sDiagramDes2Mfp9Oe                 : in  std_logic;
    sDiagramDes2Mfp10In                : out std_logic;
    sDiagramDes2Mfp10Out               : in  std_logic;
    sDiagramDes2Mfp10Oe                : in  std_logic;
    sDiagramDes3Mfp8In                 : out std_logic;
    sDiagramDes3Mfp8Out                : in  std_logic;
    sDiagramDes3Mfp8Oe                 : in  std_logic;
    sDiagramDes3Mfp9In                 : out std_logic;
    sDiagramDes3Mfp9Out                : in  std_logic;
    sDiagramDes3Mfp9Oe                 : in  std_logic;
    sDiagramDes3Mfp10In                : out std_logic;
    sDiagramDes3Mfp10Out               : in  std_logic;
    sDiagramDes3Mfp10Oe                : in  std_logic;

    sDiagramCh0PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh0PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh0PocExtEn                : out std_logic;
    sDiagramCh0ExtPgood                : out std_logic;
    sDiagramCh0PocIntEn                : out std_logic;
    sDiagramCh0IntPgood                : out std_logic;
    sDiagramCh1PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh1PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh1PocExtEn                : out std_logic;
    sDiagramCh1ExtPgood                : out std_logic;
    sDiagramCh1PocIntEn                : out std_logic;
    sDiagramCh1IntPgood                : out std_logic;
    sDiagramCh2PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh2PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh2PocExtEn                : out std_logic;
    sDiagramCh2ExtPgood                : out std_logic;
    sDiagramCh2PocIntEn                : out std_logic;
    sDiagramCh2IntPgood                : out std_logic;
    sDiagramCh3PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh3PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh3PocExtEn                : out std_logic;
    sDiagramCh3ExtPgood                : out std_logic;
    sDiagramCh3PocIntEn                : out std_logic;
    sDiagramCh3IntPgood                : out std_logic;
    sDiagramCh4PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh4PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh4PocExtEn                : out std_logic;
    sDiagramCh4ExtPgood                : out std_logic;
    sDiagramCh4PocIntEn                : out std_logic;
    sDiagramCh4IntPgood                : out std_logic;
    sDiagramCh5PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh5PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh5PocExtEn                : out std_logic;
    sDiagramCh5ExtPgood                : out std_logic;
    sDiagramCh5PocIntEn                : out std_logic;
    sDiagramCh5IntPgood                : out std_logic;
    sDiagramCh6PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh6PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh6PocExtEn                : out std_logic;
    sDiagramCh6ExtPgood                : out std_logic;
    sDiagramCh6PocIntEn                : out std_logic;
    sDiagramCh6IntPgood                : out std_logic;
    sDiagramCh7PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh7PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh7PocExtEn                : out std_logic;
    sDiagramCh7ExtPgood                : out std_logic;
    sDiagramCh7PocIntEn                : out std_logic;
    sDiagramCh7IntPgood                : out std_logic;

    sDiagramCh1Pwrdn                   : out std_logic;
    sDiagramCh1I2cSdaIn                : out std_logic;
    sDiagramCh1I2cSdaOe                : in  std_logic;
    sDiagramCh1I2cSclIn                : out std_logic;
    sDiagramCh1I2cSclOe                : in  std_logic;
    sDiagramCh3Pwrdn                   : out std_logic;
    sDiagramCh3I2cSdaIn                : out std_logic;
    sDiagramCh3I2cSdaOe                : in  std_logic;
    sDiagramCh3I2cSclIn                : out std_logic;
    sDiagramCh3I2cSclOe                : in  std_logic;
    sDiagramCh5Pwrdn                   : out std_logic;
    sDiagramCh5I2cSdaIn                : out std_logic;
    sDiagramCh5I2cSdaOe                : in  std_logic;
    sDiagramCh5I2cSclIn                : out std_logic;
    sDiagramCh5I2cSclOe                : in  std_logic;
    sDiagramCh7Pwrdn                   : out std_logic;
    sDiagramCh7I2cSdaIn                : out std_logic;
    sDiagramCh7I2cSdaOe                : in  std_logic;
    sDiagramCh7I2cSclIn                : out std_logic;
    sDiagramCh7I2cSclOe                : in  std_logic;

    --Serdes Image Data
    VideoClk                           : out   std_logic;

    vSI0VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI0VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI0VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI0VideoAxiStreamTLast            : out   std_logic;
    vSI0VideoAxiStreamTValid           : out   std_logic;

    vSI1VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI1VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI1VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI1VideoAxiStreamTLast            : out   std_logic;
    vSI1VideoAxiStreamTValid           : out   std_logic;

    vSI2VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI2VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI2VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI2VideoAxiStreamTLast            : out   std_logic;
    vSI2VideoAxiStreamTValid           : out   std_logic;

    vSI3VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI3VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI3VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI3VideoAxiStreamTLast            : out   std_logic;
    vSI3VideoAxiStreamTValid           : out   std_logic;

    vSI4VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI4VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI4VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI4VideoAxiStreamTLast            : out   std_logic;
    vSI4VideoAxiStreamTValid           : out   std_logic;

    vSI5VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI5VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI5VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI5VideoAxiStreamTLast            : out   std_logic;
    vSI5VideoAxiStreamTValid           : out   std_logic;

    vSI6VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI6VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI6VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI6VideoAxiStreamTLast            : out   std_logic;
    vSI6VideoAxiStreamTValid           : out   std_logic;

    vSI7VideoRawAxiStreamTData         : out   std_logic_vector(31 downto 0);
    vSI7VideoAxiStreamTData            : out   std_logic_vector(31 downto 0);
    vSI7VideoAxiStreamTUser            : out   std_logic_vector(31 downto 0);
    vSI7VideoAxiStreamTLast            : out   std_logic;
    vSI7VideoAxiStreamTValid           : out   std_logic
    );
end entity NI148xClipTop;

architecture rtl of NI148xClipTop is

  component Mipi8RxTop
    port (
      CoreClk               : in  std_logic;
      VideoClk              : in  std_logic;
      FastVideoClk          : in  std_logic;
      BusClk                : in  std_logic;
      cReset                : in  std_logic;
      vReset                : in  std_logic;
      fReset                : in  std_logic;
      bAxiIcReset_n         : in  std_logic;
      bAxiPeriphReset_n     : in  std_logic;
      bAxiToSlaveFlat       : in  Axi4LiteToSlaveFlat_t;
      bAxiToMasterFlat      : out Axi4LiteToMasterFlat_t;
      vRxChan0AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan1AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan2AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan3AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan4AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan5AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan6AxiStreamFlat : out AxiVideoStreamFlat_t;
      vRxChan7AxiStreamFlat : out AxiVideoStreamFlat_t;
      xRxChan0PinsFlat      : in  MipiPinsFlat_t;
      xRxChan1PinsFlat      : in  MipiPinsFlat_t;
      xRxChan2PinsFlat      : in  MipiPinsFlat_t;
      xRxChan3PinsFlat      : in  MipiPinsFlat_t;
      xRxChan4PinsFlat      : in  MipiPinsFlat_t;
      xRxChan5PinsFlat      : in  MipiPinsFlat_t;
      xRxChan6PinsFlat      : in  MipiPinsFlat_t;
      xRxChan7PinsFlat      : in  MipiPinsFlat_t);
  end component;
  component NI148xFixedLogic
    port (
      AxiClk                          : in  std_logic;
      xAxiInterconnectReset_n         : out std_logic;
      xAxiPeripheralReset_n           : out std_logic;
      xHostAxiStreamToClipTData       : in  std_logic_vector(31 downto 0);
      xHostAxiStreamToClipTLast       : in  std_logic;
      xHostAxiStreamFromClipTReady    : out std_logic;
      xHostAxiStreamToClipTValid      : in  std_logic;
      xHostAxiStreamFromClipTData     : out std_logic_vector(31 downto 0);
      xHostAxiStreamFromClipTLast     : out std_logic;
      xHostAxiStreamToClipTReady      : in  std_logic;
      xHostAxiStreamFromClipTValid    : out std_logic;
      xDiagramAxiStreamToClipTData    : in  std_logic_vector(31 downto 0);
      xDiagramAxiStreamToClipTLast    : in  std_logic;
      xDiagramAxiStreamFromClipTReady : out std_logic;
      xDiagramAxiStreamToClipTValid   : in  std_logic;
      xDiagramAxiStreamFromClipTData  : out std_logic_vector(31 downto 0);
      xDiagramAxiStreamFromClipTLast  : out std_logic;
      xDiagramAxiStreamToClipTReady   : in  std_logic;
      xDiagramAxiStreamFromClipTValid : out std_logic;
      xClipAxi4LiteMasterARAddr       : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterARProt       : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterARReady      : in  std_logic;
      xClipAxi4LiteMasterARValid      : out std_logic;
      xClipAxi4LiteMasterAWAddr       : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterAWProt       : out std_logic_vector(2 downto 0);
      xClipAxi4LiteMasterAWReady      : in  std_logic;
      xClipAxi4LiteMasterAWValid      : out std_logic;
      xClipAxi4LiteMasterBReady       : out std_logic;
      xClipAxi4LiteMasterBResp        : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterBValid       : in  std_logic;
      xClipAxi4LiteMasterRData        : in  std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterRReady       : out std_logic;
      xClipAxi4LiteMasterRResp        : in  std_logic_vector(1 downto 0);
      xClipAxi4LiteMasterRValid       : in  std_logic;
      xClipAxi4LiteMasterWData        : out std_logic_vector(31 downto 0);
      xClipAxi4LiteMasterWReady       : in  std_logic;
      xClipAxi4LiteMasterWStrb        : out std_logic_vector(3 downto 0);
      xClipAxi4LiteMasterWValid       : out std_logic;
      aDiagramResetSL                 : in  std_logic;
      aDiagramClkEnable               : in  std_logic;
      CoreClk                         : in  std_logic;
      cCorePeripheralReset_n          : out std_logic;
      cCoreInterconnectReset_n        : out std_logic;
      VideoClk                        : out std_logic;
      vAxiPeripheralReset_n           : out std_logic;
      vAxiInterconnectReset_n         : out std_logic;
      FastVideoClk                    : out std_logic;
      fAxiPeripheralReset_n           : out std_logic;
      fAxiInterconnectReset_n         : out std_logic;
      xCsiIpAxi4LiteToMasterFlat      : in  Axi4LiteToMasterFlat_t;
      xCsiIpAxi4LiteToSlaveFlat       : out Axi4LiteToSlaveFlat_t;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      stDeviceSignature               : in  std_logic_vector(31 downto 0);
      PxieClk100                      : in  std_logic;
      IoClock                         : out std_logic;
      sDiagramCh0GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh0GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh0GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh1GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh1GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh1GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh2GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh2GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh2GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh3GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh3GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh3GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh4GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh4GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh4GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh5GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh5GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh5GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh6GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh6GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh6GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramCh7GpIn                 : out std_logic_vector(7 downto 0);
      sDiagramCh7GpOut                : in  std_logic_vector(7 downto 0);
      sDiagramCh7GpOe                 : in  std_logic_vector(7 downto 0);
      sDiagramMiscGpIn                : out std_logic_vector(15 downto 0);
      sDiagramMiscGpOut               : in  std_logic_vector(15 downto 0);
      sDiagramMiscGpOe                : in  std_logic_vector(15 downto 0);
      sDiagramChI2cSdaIn              : out std_logic_vector(7 downto 0);
      sDiagramChI2cSclIn              : out std_logic_vector(7 downto 0);
      sDiagramChI2cSdaOe              : in  std_logic_vector(7 downto 0);
      sDiagramChI2cSclOe              : in  std_logic_vector(7 downto 0);
      sDiagramCh0PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh0PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh1PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh1PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh2PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh2PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh3PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh3PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh4PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh4PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh5PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh5PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh6PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh6PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramCh7PocVoltage           : out std_logic_vector(19 downto 0);
      sDiagramCh7PocCurrent           : out std_logic_vector(19 downto 0);
      sDiagramPocIntEn                : out std_logic_vector(7 downto 0);
      sDiagramPocExtEn                : out std_logic_vector(7 downto 0);
      sDiagramIntPgood                : out std_logic_vector(7 downto 0);
      sDiagramExtPgood                : out std_logic_vector(7 downto 0);
      sDiagramChanPwrdn               : out std_logic_vector(7 downto 0);
      InnerFamCfgReadClk              : in  std_logic;
      InnerFamCfgWriteClk             : out std_logic;
      wiInnerFamCfgWriteClkTri        : out std_logic;
      riInnerFamConfigData            : in  std_logic_vector(7 downto 0);
      wiInnerFamConfigData            : out std_logic_vector(7 downto 0);
      wiInnerFamConfigTri             : out std_logic_vector(8 downto 0);
      riInnerFamConfigFrame           : in  std_logic;
      wiInnerFamConfigFrame           : out std_logic;
      wiInnerFamConfigReset           : out std_logic;
      wiInnerFamConfigResetTri        : out std_logic;
      OuterFamCfgReadClk              : in  std_logic;
      OuterFamCfgWriteClk             : out std_logic;
      woOuterFamCfgWriteClkTri        : out std_logic;
      roOuterFamConfigData            : in  std_logic_vector(7 downto 0);
      woOuterFamConfigData            : out std_logic_vector(7 downto 0);
      woOuterFamConfigTri             : out std_logic_vector(8 downto 0);
      roOuterFamConfigFrame           : in  std_logic;
      woOuterFamConfigFrame           : out std_logic;
      woOuterFamConfigReset           : out std_logic;
      woOuterFamConfigResetTri        : out std_logic;
      aInnerFldUpdJtagSelIn           : in  std_logic;
      aInnerFldUpdJtagSelOut          : out std_logic;
      aOuterFldUpdJtagSel             : out std_logic;
      aFldUpdJtagTck                  : out std_logic;
      aFldUpdJtagTdi                  : out std_logic;
      aFldUpdJtagTdo                  : in  std_logic;
      aFldUpdJtagTms                  : out std_logic);
  end component;

  --vhook_sigstart
  signal aFldUpdJtagTck: std_logic;
  signal aFldUpdJtagTdi: std_logic;
  signal aFldUpdJtagTdo: std_logic;
  signal aFldUpdJtagTms: std_logic;
  signal aInnerFldUpdJtagSelIn: std_logic;
  signal aInnerFldUpdJtagSelOut: std_logic;
  signal aOuterFldUpdJtagSel: std_logic;
  signal cCorePeripheralReset_n: std_logic;
  signal FastVideoClk: std_logic;
  signal fAxiInterconnectReset_n: std_logic;
  signal fAxiPeripheralReset_n: std_logic;
  signal InnerFamCfgWriteClk: std_ulogic;
  signal OuterFamCfgWriteClk: std_ulogic;
  signal riInnerFamConfigData: std_logic_vector(7 downto 0);
  signal riInnerFamConfigFrame: std_ulogic;
  signal roOuterFamConfigData: std_logic_vector(7 downto 0);
  signal roOuterFamConfigFrame: std_ulogic;
  signal sDiagramCh0GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh0GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh0GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh0PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh0PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh1GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh1GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh1GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh1PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh1PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh2GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh2GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh2GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh2PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh2PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh3GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh3GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh3GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh3PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh3PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh4GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh4GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh4GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh4PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh4PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh5GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh5GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh5GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh5PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh5PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh6GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh6GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh6GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh6PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh6PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh7GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh7GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh7GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh7PocCurrentLcl: std_logic_vector(19 downto 0);
  signal sDiagramCh7PocVoltageLcl: std_logic_vector(19 downto 0);
  signal sDiagramMiscGpIn: std_logic_vector(15 downto 0);
  signal sDiagramMiscGpOe: std_logic_vector(15 downto 0);
  signal sDiagramMiscGpOut: std_logic_vector(15 downto 0);
  signal vAxiPeripheralReset_n: std_logic;
  signal VideoClkLcl: std_logic;
  signal wiInnerFamCfgWriteClkTri: std_ulogic;
  signal wiInnerFamConfigData: std_logic_vector(7 downto 0);
  signal wiInnerFamConfigFrame: std_ulogic;
  signal wiInnerFamConfigReset: std_ulogic;
  signal wiInnerFamConfigResetTri: std_ulogic;
  signal wiInnerFamConfigTri: std_logic_vector(8 downto 0);
  signal woOuterFamCfgWriteClkTri: std_ulogic;
  signal woOuterFamConfigData: std_logic_vector(7 downto 0);
  signal woOuterFamConfigFrame: std_ulogic;
  signal woOuterFamConfigTri: std_logic_vector(8 downto 0);
  signal xAxiInterconnectReset_n: std_logic;
  signal xAxiPeripheralReset_n: std_logic;
  signal xCsiIpAxi4LiteToMasterFlat: Axi4LiteToMasterFlat_t;
  signal xCsiIpAxi4LiteToSlaveFlat: Axi4LiteToSlaveFlat_t;
  --vhook_sigend

    --vhook_nowarn {sDiagramCh(0|2|4|6)I2c.*}
    --vhook_nowarn {sDiagramCh(0|2|4|6)Pwrdn}
    signal sDiagramCh0I2cSclIn: std_logic;
    signal sDiagramCh0I2cSclOe: std_logic := '0';
    signal sDiagramCh0I2cSdaIn: std_logic;
    signal sDiagramCh0I2cSdaOe: std_logic := '0';
    signal sDiagramCh2I2cSclIn: std_logic;
    signal sDiagramCh2I2cSclOe: std_logic := '0';
    signal sDiagramCh2I2cSdaIn: std_logic;
    signal sDiagramCh2I2cSdaOe: std_logic := '0';
    signal sDiagramCh4I2cSclIn: std_logic;
    signal sDiagramCh4I2cSclOe: std_logic := '0';
    signal sDiagramCh4I2cSdaIn: std_logic;
    signal sDiagramCh4I2cSdaOe: std_logic := '0';
    signal sDiagramCh6I2cSclIn: std_logic;
    signal sDiagramCh6I2cSclOe: std_logic := '0';
    signal sDiagramCh6I2cSdaIn: std_logic;
    signal sDiagramCh6I2cSdaOe: std_logic := '0';
    signal sDiagramCh0Pwrdn: std_logic;
    signal sDiagramCh2Pwrdn: std_logic;
    signal sDiagramCh4Pwrdn: std_logic;
    signal sDiagramCh6Pwrdn: std_logic;

  --0x7A87  PXIe-TBD FlexRIO GMSL XCVR    (Chimera-M)
  --0x7A86  PXIe-TBD FlexRIO GMSL Output  (Chimera-M)
  --0x7A85  PXIe-TBD FlexRIO GMSL Input   (Chimera-M)
  --0x7A84  PXIe-TBD FlexRIO FPD-Link III XCVR    (Chimera-T)
  --0x7A83  PXIe-TBD FlexRIO FPD-Link III Output  (Chimera-T)
  --0x7A82  PXIe-TBD FlexRIO FPD-Link III Input   (Chimera-T)
  constant kDeviceSignature : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#1093_7A85#, 32));
  signal xIoOutputEnableLcl : std_logic;

  type InnerFamConfigDataMap_t is array (0 to 7) of integer;
  constant kInnerFamConfigDataMap : InnerFamConfigDataMap_t := (1, 4, 6, 9, 11, 15, 19, 23);

  type OuterFamConfigDataMap_t is array (0 to 7) of integer;
  constant kOuterFamConfigDataMap : OuterFamConfigDataMap_t := (0, 3, 5, 8, 10, 14, 18, 22);

  signal xSiChanPinsArray : MipiPinsAry_t(7 downto 0);

  signal vSiChanAxiStreamArray : AxiVideoStreamAry_t(7 downto 0);
  signal vSiChanAxiStreamFlatArray : AxiVideoStreamFlatAry_t(7 downto 0);

begin

  -- This CLIP supports IFIFO_RPC
  stIoModuleSupportsFRAGLs <= '1';

  -- Unused signals
  aReservedFromClip        <= (others => '0');
  dvTdcAssert              <= '0';
  dtDevClkEn               <= '0';
  --vhook_nowarn dtTdcAssert
  --vhook_nowarn SampleClk
  --vhook_nowarn DeviceClk
  --vhook_nowarn aReservedToClip
  --vhook_nowarn xClipAxi4LiteInterrupt
  --vhook_nowarn xIo*
  --vhook_nowarn aDiffGpio*

  --Map D-PHY IO to CLIP Names
  xSiChanPinsArray <= MapGpioToRx(aDiffGpio_p, aDiffGpio_n, kNI148x01DphyPinMapSI);

  GenInnerDataIOBUFs: for i in InnerFamConfigDataMap_t'range generate
    --vhook_i IOBUF InnerDataIOBUFx
    --vhook_gh   *
    --vhook_a    I  wiInnerFamConfigData(i)
    --vhook_a    O  riInnerFamConfigData(i)
    --vhook_a    T  wiInnerFamConfigTri(i)
    --vhook_a    IO aSeGpio(kInnerFamConfigDataMap(i))
    InnerDataIOBUFx: IOBUF
      port map (
        O  => riInnerFamConfigData(i),             --out std_ulogic
        IO => aSeGpio(kInnerFamConfigDataMap(i)),  --inout std_ulogic
        I  => wiInnerFamConfigData(i),             --in  std_ulogic
        T  => wiInnerFamConfigTri(i));             --in  std_ulogic
  end generate;

  GenOuterDataIOBUFs: for i in OuterFamConfigDataMap_t'range generate
    --vhook_i IOBUF OuterDataIOBUFx
    --vhook_gh   *
    --vhook_a    I  woOuterFamConfigData(i)
    --vhook_a    O  roOuterFamConfigData(i)
    --vhook_a    T  woOuterFamConfigTri(i)
    --vhook_a    IO aSeGpio(kOuterFamConfigDataMap(i))
    OuterDataIOBUFx: IOBUF
      port map (
        O  => roOuterFamConfigData(i),             --out std_ulogic
        IO => aSeGpio(kOuterFamConfigDataMap(i)),  --inout std_ulogic
        I  => woOuterFamConfigData(i),             --in  std_ulogic
        T  => woOuterFamConfigTri(i));             --in  std_ulogic
  end generate;

  --vhook_i IOBUF InnerFrameIOBUFx
  --vhook_gh   *
  --vhook_a    I  wiInnerFamConfigFrame
  --vhook_a    O  riInnerFamConfigFrame
  --vhook_a    T  wiInnerFamConfigTri(8)
  --vhook_a    IO aSeGpio(21)
  InnerFrameIOBUFx: IOBUF
    port map (
      O  => riInnerFamConfigFrame,   --out std_ulogic
      IO => aSeGpio(21),             --inout std_ulogic
      I  => wiInnerFamConfigFrame,   --in  std_ulogic
      T  => wiInnerFamConfigTri(8)); --in  std_ulogic

  --vhook_i IOBUF OuterFrameIOBUFx
  --vhook_gh   *
  --vhook_a    I  woOuterFamConfigFrame
  --vhook_a    O  roOuterFamConfigFrame
  --vhook_a    T  woOuterFamConfigTri(8)
  --vhook_a    IO aSeGpio(16)
  OuterFrameIOBUFx: IOBUF
    port map (
      O  => roOuterFamConfigFrame,   --out std_ulogic
      IO => aSeGpio(16),             --inout std_ulogic
      I  => woOuterFamConfigFrame,   --in  std_ulogic
      T  => woOuterFamConfigTri(8)); --in  std_ulogic

  --vhook_i IOBUF InnerFamCfgWriteClkIOBUFx
  --vhook_gh   *
  --vhook_a    I  InnerFamCfgWriteClk
  --vhook_a    O  open
  --vhook_a    T  wiInnerFamCfgWriteClkTri
  --vhook_a    IO aSeGpio(13)
  InnerFamCfgWriteClkIOBUFx: IOBUF
    port map (
      O  => open,                      --out std_ulogic
      IO => aSeGpio(13),               --inout std_ulogic
      I  => InnerFamCfgWriteClk,       --in  std_ulogic
      T  => wiInnerFamCfgWriteClkTri); --in  std_ulogic

  --vhook_i IOBUF OuterFamCfgWriteClkIOBUFx
  --vhook_gh   *
  --vhook_a    I  OuterFamCfgWriteClk
  --vhook_a    O  open
  --vhook_a    T  woOuterFamCfgWriteClkTri
  --vhook_a    IO aSeGpio(12)
  OuterFamCfgWriteClkIOBUFx: IOBUF
    port map (
      O  => open,                      --out std_ulogic
      IO => aSeGpio(12),               --inout std_ulogic
      I  => OuterFamCfgWriteClk,       --in  std_ulogic
      T  => woOuterFamCfgWriteClkTri); --in  std_ulogic

  --vhook_i IOBUF InnerFamConfigResetIOBUFx
  --vhook_gh   *
  --vhook_a    I  wiInnerFamConfigReset
  --vhook_a    O  open
  --vhook_a    T  wiInnerFamConfigResetTri
  --vhook_a    IO aSeGpio(25)
  InnerFamConfigResetIOBUFx: IOBUF
    port map (
      O  => open,                      --out std_ulogic
      IO => aSeGpio(25),               --inout std_ulogic
      I  => wiInnerFamConfigReset,     --in  std_ulogic
      T  => wiInnerFamConfigResetTri); --in  std_ulogic

  -- Create a registered copy of this signal within the CLIP that we can use as
  -- a start point for our false path constraint.
  process(AxiClk, aDiagramResetSL)
  begin
    if aDiagramResetSL = '1' then
      xIoOutputEnableLcl <= '0';
    elsif rising_edge(AxiClk) then
      xIoOutputEnableLcl <= xIoOutputEnable;
    end if;
  end process;

  aSeGpio(24) <= aInnerFldUpdJtagSelOut  when xIoOutputEnableLcl = '1' else 'Z';
  aInnerFldUpdJtagSelIn <= aSeGpio(24);
  aSeGpio(7)  <= aOuterFldUpdJtagSel  when xIoOutputEnableLcl = '1' else 'Z';
  aSeGpio(26) <= aFldUpdJtagTck  when xIoOutputEnableLcl = '1' else 'Z';
  aSeGpio(28) <= aFldUpdJtagTdi  when xIoOutputEnableLcl = '1' else 'Z';
  aSeGpio(27) <= aFldUpdJtagTms  when xIoOutputEnableLcl = '1' else 'Z';
  aFldUpdJtagTdo <= aSeGpio(29);

  --vhook NI148xFixedLogic
  --vhook_a PxieClk100                PxieClk100
  --vhook_a InnerFamCfgReadClk        aSeGpio(17)
  --vhook_a OuterFamCfgReadClk        aSeGpio(20)
  --vhook_a woOuterFamConfigReset*    open
  --vhook_a cCoreInterconnectReset_n  open
  --vhook_a vAxiInterconnectReset_n   open
  --vhook_a stDeviceSignature          kDeviceSignature
  --vhook_a VideoClk   VideoClkLcl
  --vhook_a CoreClk    VideoClkLcl
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(0) {sDiagramCh0I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(1) {sDiagramCh1I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(2) {sDiagramCh2I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(3) {sDiagramCh3I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(4) {sDiagramCh4I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(5) {sDiagramCh5I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(6) {sDiagramCh6I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(7) {sDiagramCh7I2c$1$2}
  --vhook_af {sDiagramPoc(Ext|Int)En}(0)        {sDiagramCh0Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(1)        {sDiagramCh1Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(2)        {sDiagramCh2Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(3)        {sDiagramCh3Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(4)        {sDiagramCh4Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(5)        {sDiagramCh5Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(6)        {sDiagramCh6Poc$1En} continue=true
  --vhook_af {sDiagramPoc(Ext|Int)En}(7)        {sDiagramCh7Poc$1En}
  --vhook_af {sDiagram(Ext|Int)Pgood}(0)        {sDiagramCh0$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(1)        {sDiagramCh1$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(2)        {sDiagramCh2$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(3)        {sDiagramCh3$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(4)        {sDiagramCh4$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(5)        {sDiagramCh5$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(6)        {sDiagramCh6$1Pgood} continue=true
  --vhook_af {sDiagram(Ext|Int)Pgood}(7)        {sDiagramCh7$1Pgood}
  --vhook_af {sDiagramChanPwrdn}(0)             {sDiagramCh0Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(1)             {sDiagramCh1Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(2)             {sDiagramCh2Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(3)             {sDiagramCh3Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(4)             {sDiagramCh4Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(5)             {sDiagramCh5Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(6)             {sDiagramCh6Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(7)             {sDiagramCh7Pwrdn}
  --vhook_a  sDiagramCh(*)PocCurrent            sDiagramCh$1PocCurrentLcl
  --vhook_a  sDiagramCh(*)PocVoltage            sDiagramCh$1PocVoltageLcl
  NI148xFixedLogicx: NI148xFixedLogic
    port map (
      AxiClk                          => AxiClk,                           --in  std_logic
      xAxiInterconnectReset_n         => xAxiInterconnectReset_n,          --out std_logic
      xAxiPeripheralReset_n           => xAxiPeripheralReset_n,            --out std_logic
      xHostAxiStreamToClipTData       => xHostAxiStreamToClipTData,        --in  std_logic_vector(31:0)
      xHostAxiStreamToClipTLast       => xHostAxiStreamToClipTLast,        --in  std_logic
      xHostAxiStreamFromClipTReady    => xHostAxiStreamFromClipTReady,     --out std_logic
      xHostAxiStreamToClipTValid      => xHostAxiStreamToClipTValid,       --in  std_logic
      xHostAxiStreamFromClipTData     => xHostAxiStreamFromClipTData,      --out std_logic_vector(31:0)
      xHostAxiStreamFromClipTLast     => xHostAxiStreamFromClipTLast,      --out std_logic
      xHostAxiStreamToClipTReady      => xHostAxiStreamToClipTReady,       --in  std_logic
      xHostAxiStreamFromClipTValid    => xHostAxiStreamFromClipTValid,     --out std_logic
      xDiagramAxiStreamToClipTData    => xDiagramAxiStreamToClipTData,     --in  std_logic_vector(31:0)
      xDiagramAxiStreamToClipTLast    => xDiagramAxiStreamToClipTLast,     --in  std_logic
      xDiagramAxiStreamFromClipTReady => xDiagramAxiStreamFromClipTReady,  --out std_logic
      xDiagramAxiStreamToClipTValid   => xDiagramAxiStreamToClipTValid,    --in  std_logic
      xDiagramAxiStreamFromClipTData  => xDiagramAxiStreamFromClipTData,   --out std_logic_vector(31:0)
      xDiagramAxiStreamFromClipTLast  => xDiagramAxiStreamFromClipTLast,   --out std_logic
      xDiagramAxiStreamToClipTReady   => xDiagramAxiStreamToClipTReady,    --in  std_logic
      xDiagramAxiStreamFromClipTValid => xDiagramAxiStreamFromClipTValid,  --out std_logic
      xClipAxi4LiteMasterARAddr       => xClipAxi4LiteMasterARAddr,        --out std_logic_vector(31:0)
      xClipAxi4LiteMasterARProt       => xClipAxi4LiteMasterARProt,        --out std_logic_vector(2:0)
      xClipAxi4LiteMasterARReady      => xClipAxi4LiteMasterARReady,       --in  std_logic
      xClipAxi4LiteMasterARValid      => xClipAxi4LiteMasterARValid,       --out std_logic
      xClipAxi4LiteMasterAWAddr       => xClipAxi4LiteMasterAWAddr,        --out std_logic_vector(31:0)
      xClipAxi4LiteMasterAWProt       => xClipAxi4LiteMasterAWProt,        --out std_logic_vector(2:0)
      xClipAxi4LiteMasterAWReady      => xClipAxi4LiteMasterAWReady,       --in  std_logic
      xClipAxi4LiteMasterAWValid      => xClipAxi4LiteMasterAWValid,       --out std_logic
      xClipAxi4LiteMasterBReady       => xClipAxi4LiteMasterBReady,        --out std_logic
      xClipAxi4LiteMasterBResp        => xClipAxi4LiteMasterBResp,         --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterBValid       => xClipAxi4LiteMasterBValid,        --in  std_logic
      xClipAxi4LiteMasterRData        => xClipAxi4LiteMasterRData,         --in  std_logic_vector(31:0)
      xClipAxi4LiteMasterRReady       => xClipAxi4LiteMasterRReady,        --out std_logic
      xClipAxi4LiteMasterRResp        => xClipAxi4LiteMasterRResp,         --in  std_logic_vector(1:0)
      xClipAxi4LiteMasterRValid       => xClipAxi4LiteMasterRValid,        --in  std_logic
      xClipAxi4LiteMasterWData        => xClipAxi4LiteMasterWData,         --out std_logic_vector(31:0)
      xClipAxi4LiteMasterWReady       => xClipAxi4LiteMasterWReady,        --in  std_logic
      xClipAxi4LiteMasterWStrb        => xClipAxi4LiteMasterWStrb,         --out std_logic_vector(3:0)
      xClipAxi4LiteMasterWValid       => xClipAxi4LiteMasterWValid,        --out std_logic
      aDiagramResetSL                 => aDiagramResetSL,                  --in  std_logic
      aDiagramClkEnable               => aDiagramClkEnable,                --in  std_logic
      CoreClk                         => VideoClkLcl,                      --in  std_logic
      cCorePeripheralReset_n          => cCorePeripheralReset_n,           --out std_logic
      cCoreInterconnectReset_n        => open,                             --out std_logic
      VideoClk                        => VideoClkLcl,                      --out std_logic
      vAxiPeripheralReset_n           => vAxiPeripheralReset_n,            --out std_logic
      vAxiInterconnectReset_n         => open,                             --out std_logic
      FastVideoClk                    => FastVideoClk,                     --out std_logic
      fAxiPeripheralReset_n           => fAxiPeripheralReset_n,            --out std_logic
      fAxiInterconnectReset_n         => fAxiInterconnectReset_n,          --out std_logic
      xCsiIpAxi4LiteToMasterFlat      => xCsiIpAxi4LiteToMasterFlat,       --in  Axi4LiteToMasterFlat_t
      xCsiIpAxi4LiteToSlaveFlat       => xCsiIpAxi4LiteToSlaveFlat,        --out Axi4LiteToSlaveFlat_t
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      stDeviceSignature               => kDeviceSignature,                 --in  std_logic_vector(31:0)
      PxieClk100                      => PxieClk100,                       --in  std_logic
      IoClock                         => IoClock,                          --out std_logic
      sDiagramCh0GpIn                 => sDiagramCh0GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh0GpOut                => sDiagramCh0GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh0GpOe                 => sDiagramCh0GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh1GpIn                 => sDiagramCh1GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh1GpOut                => sDiagramCh1GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh1GpOe                 => sDiagramCh1GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh2GpIn                 => sDiagramCh2GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh2GpOut                => sDiagramCh2GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh2GpOe                 => sDiagramCh2GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh3GpIn                 => sDiagramCh3GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh3GpOut                => sDiagramCh3GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh3GpOe                 => sDiagramCh3GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh4GpIn                 => sDiagramCh4GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh4GpOut                => sDiagramCh4GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh4GpOe                 => sDiagramCh4GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh5GpIn                 => sDiagramCh5GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh5GpOut                => sDiagramCh5GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh5GpOe                 => sDiagramCh5GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh6GpIn                 => sDiagramCh6GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh6GpOut                => sDiagramCh6GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh6GpOe                 => sDiagramCh6GpOe,                  --in  std_logic_vector(7:0)
      sDiagramCh7GpIn                 => sDiagramCh7GpIn,                  --out std_logic_vector(7:0)
      sDiagramCh7GpOut                => sDiagramCh7GpOut,                 --in  std_logic_vector(7:0)
      sDiagramCh7GpOe                 => sDiagramCh7GpOe,                  --in  std_logic_vector(7:0)
      sDiagramMiscGpIn                => sDiagramMiscGpIn,                 --out std_logic_vector(15:0)
      sDiagramMiscGpOut               => sDiagramMiscGpOut,                --in  std_logic_vector(15:0)
      sDiagramMiscGpOe                => sDiagramMiscGpOe,                 --in  std_logic_vector(15:0)
      sDiagramChI2cSdaIn(0)           => sDiagramCh0I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(1)           => sDiagramCh1I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(2)           => sDiagramCh2I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(3)           => sDiagramCh3I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(4)           => sDiagramCh4I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(5)           => sDiagramCh5I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(6)           => sDiagramCh6I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaIn(7)           => sDiagramCh7I2cSdaIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(0)           => sDiagramCh0I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(1)           => sDiagramCh1I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(2)           => sDiagramCh2I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(3)           => sDiagramCh3I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(4)           => sDiagramCh4I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(5)           => sDiagramCh5I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(6)           => sDiagramCh6I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSclIn(7)           => sDiagramCh7I2cSclIn,              --out std_logic_vector(7:0)
      sDiagramChI2cSdaOe(0)           => sDiagramCh0I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(1)           => sDiagramCh1I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(2)           => sDiagramCh2I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(3)           => sDiagramCh3I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(4)           => sDiagramCh4I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(5)           => sDiagramCh5I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(6)           => sDiagramCh6I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSdaOe(7)           => sDiagramCh7I2cSdaOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(0)           => sDiagramCh0I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(1)           => sDiagramCh1I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(2)           => sDiagramCh2I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(3)           => sDiagramCh3I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(4)           => sDiagramCh4I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(5)           => sDiagramCh5I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(6)           => sDiagramCh6I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramChI2cSclOe(7)           => sDiagramCh7I2cSclOe,              --in  std_logic_vector(7:0)
      sDiagramCh0PocVoltage           => sDiagramCh0PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh0PocCurrent           => sDiagramCh0PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh1PocVoltage           => sDiagramCh1PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh1PocCurrent           => sDiagramCh1PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh2PocVoltage           => sDiagramCh2PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh2PocCurrent           => sDiagramCh2PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh3PocVoltage           => sDiagramCh3PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh3PocCurrent           => sDiagramCh3PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh4PocVoltage           => sDiagramCh4PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh4PocCurrent           => sDiagramCh4PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh5PocVoltage           => sDiagramCh5PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh5PocCurrent           => sDiagramCh5PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh6PocVoltage           => sDiagramCh6PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh6PocCurrent           => sDiagramCh6PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramCh7PocVoltage           => sDiagramCh7PocVoltageLcl,         --out std_logic_vector(19:0)
      sDiagramCh7PocCurrent           => sDiagramCh7PocCurrentLcl,         --out std_logic_vector(19:0)
      sDiagramPocIntEn(0)             => sDiagramCh0PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(1)             => sDiagramCh1PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(2)             => sDiagramCh2PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(3)             => sDiagramCh3PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(4)             => sDiagramCh4PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(5)             => sDiagramCh5PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(6)             => sDiagramCh6PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocIntEn(7)             => sDiagramCh7PocIntEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(0)             => sDiagramCh0PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(1)             => sDiagramCh1PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(2)             => sDiagramCh2PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(3)             => sDiagramCh3PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(4)             => sDiagramCh4PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(5)             => sDiagramCh5PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(6)             => sDiagramCh6PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(7)             => sDiagramCh7PocExtEn,              --out std_logic_vector(7:0)
      sDiagramIntPgood(0)             => sDiagramCh0IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(1)             => sDiagramCh1IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(2)             => sDiagramCh2IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(3)             => sDiagramCh3IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(4)             => sDiagramCh4IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(5)             => sDiagramCh5IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(6)             => sDiagramCh6IntPgood,              --out std_logic_vector(7:0)
      sDiagramIntPgood(7)             => sDiagramCh7IntPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(0)             => sDiagramCh0ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(1)             => sDiagramCh1ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(2)             => sDiagramCh2ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(3)             => sDiagramCh3ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(4)             => sDiagramCh4ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(5)             => sDiagramCh5ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(6)             => sDiagramCh6ExtPgood,              --out std_logic_vector(7:0)
      sDiagramExtPgood(7)             => sDiagramCh7ExtPgood,              --out std_logic_vector(7:0)
      sDiagramChanPwrdn(0)            => sDiagramCh0Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(1)            => sDiagramCh1Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(2)            => sDiagramCh2Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(3)            => sDiagramCh3Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(4)            => sDiagramCh4Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(5)            => sDiagramCh5Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(6)            => sDiagramCh6Pwrdn,                 --out std_logic_vector(7:0)
      sDiagramChanPwrdn(7)            => sDiagramCh7Pwrdn,                 --out std_logic_vector(7:0)
      InnerFamCfgReadClk              => aSeGpio(17),                      --in  std_logic
      InnerFamCfgWriteClk             => InnerFamCfgWriteClk,              --out std_logic
      wiInnerFamCfgWriteClkTri        => wiInnerFamCfgWriteClkTri,         --out std_logic
      riInnerFamConfigData            => riInnerFamConfigData,             --in  std_logic_vector(7:0)
      wiInnerFamConfigData            => wiInnerFamConfigData,             --out std_logic_vector(7:0)
      wiInnerFamConfigTri             => wiInnerFamConfigTri,              --out std_logic_vector(8:0)
      riInnerFamConfigFrame           => riInnerFamConfigFrame,            --in  std_logic
      wiInnerFamConfigFrame           => wiInnerFamConfigFrame,            --out std_logic
      wiInnerFamConfigReset           => wiInnerFamConfigReset,            --out std_logic
      wiInnerFamConfigResetTri        => wiInnerFamConfigResetTri,         --out std_logic
      OuterFamCfgReadClk              => aSeGpio(20),                      --in  std_logic
      OuterFamCfgWriteClk             => OuterFamCfgWriteClk,              --out std_logic
      woOuterFamCfgWriteClkTri        => woOuterFamCfgWriteClkTri,         --out std_logic
      roOuterFamConfigData            => roOuterFamConfigData,             --in  std_logic_vector(7:0)
      woOuterFamConfigData            => woOuterFamConfigData,             --out std_logic_vector(7:0)
      woOuterFamConfigTri             => woOuterFamConfigTri,              --out std_logic_vector(8:0)
      roOuterFamConfigFrame           => roOuterFamConfigFrame,            --in  std_logic
      woOuterFamConfigFrame           => woOuterFamConfigFrame,            --out std_logic
      woOuterFamConfigReset           => open,                             --out std_logic
      woOuterFamConfigResetTri        => open,                             --out std_logic
      aInnerFldUpdJtagSelIn           => aInnerFldUpdJtagSelIn,            --in  std_logic
      aInnerFldUpdJtagSelOut          => aInnerFldUpdJtagSelOut,           --out std_logic
      aOuterFldUpdJtagSel             => aOuterFldUpdJtagSel,              --out std_logic
      aFldUpdJtagTck                  => aFldUpdJtagTck,                   --out std_logic
      aFldUpdJtagTdi                  => aFldUpdJtagTdi,                   --out std_logic
      aFldUpdJtagTdo                  => aFldUpdJtagTdo,                   --in  std_logic
      aFldUpdJtagTms                  => aFldUpdJtagTms);                  --out std_logic

      sDiagramCh0PocVoltage <= sDiagramCh0PocVoltageLcl(19 downto 8);
      sDiagramCh0PocCurrent <= sDiagramCh0PocCurrentLcl(19 downto 8);
      sDiagramCh1PocVoltage <= sDiagramCh1PocVoltageLcl(19 downto 8);
      sDiagramCh1PocCurrent <= sDiagramCh1PocCurrentLcl(19 downto 8);
      sDiagramCh2PocVoltage <= sDiagramCh2PocVoltageLcl(19 downto 8);
      sDiagramCh2PocCurrent <= sDiagramCh2PocCurrentLcl(19 downto 8);
      sDiagramCh3PocVoltage <= sDiagramCh3PocVoltageLcl(19 downto 8);
      sDiagramCh3PocCurrent <= sDiagramCh3PocCurrentLcl(19 downto 8);
      sDiagramCh4PocVoltage <= sDiagramCh4PocVoltageLcl(19 downto 8);
      sDiagramCh4PocCurrent <= sDiagramCh4PocCurrentLcl(19 downto 8);
      sDiagramCh5PocVoltage <= sDiagramCh5PocVoltageLcl(19 downto 8);
      sDiagramCh5PocCurrent <= sDiagramCh5PocCurrentLcl(19 downto 8);
      sDiagramCh6PocVoltage <= sDiagramCh6PocVoltageLcl(19 downto 8);
      sDiagramCh6PocCurrent <= sDiagramCh6PocCurrentLcl(19 downto 8);
      sDiagramCh7PocVoltage <= sDiagramCh7PocVoltageLcl(19 downto 8);
      sDiagramCh7PocCurrent <= sDiagramCh7PocCurrentLcl(19 downto 8);

  --vhook   Mipi8RxTop
  --vhook_p cReset                  (NOT cCorePeripheralReset_n)
  --vhook_p vReset                  (NOT vAxiPeripheralReset_n)
  --vhook_p fReset                  (NOT fAxiPeripheralReset_n)
  --vhook_p BusClk                  AxiClk
  --vhook_p VideoClk                VideoClkLcl
  --vhook_p CoreClk                 VideoClkLcl
  --vhook_p bAxiIcReset_n           xAxiInterconnectReset_n
  --vhook_p bAxiPeriphReset_n       xAxiPeripheralReset_n
  --vhook_p bAxiToSlaveFlat         xCsiIpAxi4LiteToSlaveFlat
  --vhook_p bAxiToMasterFlat        xCsiIpAxi4LiteToMasterFlat
  --vhook_# RxCh0:SI0, RxCh1:SI4, RxCh2:SI1, RxCh3:SI5, RxCh4:SI2, RxCh5:SI6, RxCh6:SI3, RxCh7:SI7
  --vhook_p {xRxChan0(.*)}          {Flatten(xSiChanPinsArray(0))}
  --vhook_p {vRxChan0(.*)}                    {vSiChan$1Array(0)}
  --vhook_#
  --vhook_p {xRxChan1(.*)}          {Flatten(xSiChanPinsArray(4))}
  --vhook_p {vRxChan1(.*)}                    {vSiChan$1Array(4)}
  --vhook_#
  --vhook_p {xRxChan2(.*)}          {Flatten(xSiChanPinsArray(1))}
  --vhook_p {vRxChan2(.*)}                    {vSiChan$1Array(1)}
  --vhook_#
  --vhook_p {xRxChan3(.*)}          {Flatten(xSiChanPinsArray(5))}
  --vhook_p {vRxChan3(.*)}                    {vSiChan$1Array(5)}
  --vhook_#
  --vhook_p {xRxChan4(.*)}          {Flatten(xSiChanPinsArray(2))}
  --vhook_p {vRxChan4(.*)}                    {vSiChan$1Array(2)}
  --vhook_#
  --vhook_p {xRxChan5(.*)}          {Flatten(xSiChanPinsArray(6))}
  --vhook_p {vRxChan5(.*)}                    {vSiChan$1Array(6)}
  --vhook_#
  --vhook_p {xRxChan6(.*)}          {Flatten(xSiChanPinsArray(3))}
  --vhook_p {vRxChan6(.*)}                    {vSiChan$1Array(3)}
  --vhook_#
  --vhook_p {xRxChan7(.*)}          {Flatten(xSiChanPinsArray(7))}
  --vhook_p {vRxChan7(.*)}                    {vSiChan$1Array(7)}
  Mipi8RxTopx: Mipi8RxTop
    port map (
      CoreClk               => VideoClkLcl,                   --in  std_logic
      VideoClk              => VideoClkLcl,                   --in  std_logic
      FastVideoClk          => FastVideoClk,                  --in  std_logic
      BusClk                => AxiClk,                        --in  std_logic
      cReset                => (NOT cCorePeripheralReset_n),  --in  std_logic
      vReset                => (NOT vAxiPeripheralReset_n),   --in  std_logic
      fReset                => (NOT fAxiPeripheralReset_n),   --in  std_logic
      bAxiIcReset_n         => xAxiInterconnectReset_n,       --in  std_logic
      bAxiPeriphReset_n     => xAxiPeripheralReset_n,         --in  std_logic
      bAxiToSlaveFlat       => xCsiIpAxi4LiteToSlaveFlat,     --in  Axi4LiteToSlaveFlat_t
      bAxiToMasterFlat      => xCsiIpAxi4LiteToMasterFlat,    --out Axi4LiteToMasterFlat_t
      vRxChan0AxiStreamFlat => vSiChanAxiStreamFlatArray(0),  --out AxiVideoStreamFlat_t
      vRxChan1AxiStreamFlat => vSiChanAxiStreamFlatArray(4),  --out AxiVideoStreamFlat_t
      vRxChan2AxiStreamFlat => vSiChanAxiStreamFlatArray(1),  --out AxiVideoStreamFlat_t
      vRxChan3AxiStreamFlat => vSiChanAxiStreamFlatArray(5),  --out AxiVideoStreamFlat_t
      vRxChan4AxiStreamFlat => vSiChanAxiStreamFlatArray(2),  --out AxiVideoStreamFlat_t
      vRxChan5AxiStreamFlat => vSiChanAxiStreamFlatArray(6),  --out AxiVideoStreamFlat_t
      vRxChan6AxiStreamFlat => vSiChanAxiStreamFlatArray(3),  --out AxiVideoStreamFlat_t
      vRxChan7AxiStreamFlat => vSiChanAxiStreamFlatArray(7),  --out AxiVideoStreamFlat_t
      xRxChan0PinsFlat      => Flatten(xSiChanPinsArray(0)),  --in  MipiPinsFlat_t
      xRxChan1PinsFlat      => Flatten(xSiChanPinsArray(4)),  --in  MipiPinsFlat_t
      xRxChan2PinsFlat      => Flatten(xSiChanPinsArray(1)),  --in  MipiPinsFlat_t
      xRxChan3PinsFlat      => Flatten(xSiChanPinsArray(5)),  --in  MipiPinsFlat_t
      xRxChan4PinsFlat      => Flatten(xSiChanPinsArray(2)),  --in  MipiPinsFlat_t
      xRxChan5PinsFlat      => Flatten(xSiChanPinsArray(6)),  --in  MipiPinsFlat_t
      xRxChan6PinsFlat      => Flatten(xSiChanPinsArray(3)),  --in  MipiPinsFlat_t
      xRxChan7PinsFlat      => Flatten(xSiChanPinsArray(7))); --in  MipiPinsFlat_t

  vSiChanAxiStreamArray     <= Unflatten(vSiChanAxiStreamFlatArray);

  VideoClk <= VideoClkLcl;

  --
  -- Axi Stream to LVFPGA
  vSI0VideoAxiStreamTData     <= vSiChanAxiStreamArray(0).TData;
  vSI0VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(0).TRawData;
  vSI0VideoAxiStreamTUser     <= vSiChanAxiStreamArray(0).TUser(31 downto 0);
  vSI0VideoAxiStreamTValid    <= vSiChanAxiStreamArray(0).TValid;
  vSI0VideoAxiStreamTLast     <= vSiChanAxiStreamArray(0).TLast;

  vSI1VideoAxiStreamTData     <= vSiChanAxiStreamArray(1).TData;
  vSI1VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(1).TRawData;
  vSI1VideoAxiStreamTUser     <= vSiChanAxiStreamArray(1).TUser(31 downto 0);
  vSI1VideoAxiStreamTValid    <= vSiChanAxiStreamArray(1).TValid;
  vSI1VideoAxiStreamTLast     <= vSiChanAxiStreamArray(1).TLast;

  vSI2VideoAxiStreamTData     <= vSiChanAxiStreamArray(2).TData;
  vSI2VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(2).TRawData;
  vSI2VideoAxiStreamTUser     <= vSiChanAxiStreamArray(2).TUser(31 downto 0);
  vSI2VideoAxiStreamTValid    <= vSiChanAxiStreamArray(2).TValid;
  vSI2VideoAxiStreamTLast     <= vSiChanAxiStreamArray(2).TLast;

  vSI3VideoAxiStreamTData     <= vSiChanAxiStreamArray(3).TData;
  vSI3VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(3).TRawData;
  vSI3VideoAxiStreamTUser     <= vSiChanAxiStreamArray(3).TUser(31 downto 0);
  vSI3VideoAxiStreamTValid    <= vSiChanAxiStreamArray(3).TValid;
  vSI3VideoAxiStreamTLast     <= vSiChanAxiStreamArray(3).TLast;

  vSI4VideoAxiStreamTData     <= vSiChanAxiStreamArray(4).TData;
  vSI4VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(4).TRawData;
  vSI4VideoAxiStreamTUser     <= vSiChanAxiStreamArray(4).TUser(31 downto 0);
  vSI4VideoAxiStreamTValid    <= vSiChanAxiStreamArray(4).TValid;
  vSI4VideoAxiStreamTLast     <= vSiChanAxiStreamArray(4).TLast;

  vSI5VideoAxiStreamTData     <= vSiChanAxiStreamArray(5).TData;
  vSI5VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(5).TRawData;
  vSI5VideoAxiStreamTUser     <= vSiChanAxiStreamArray(5).TUser(31 downto 0);
  vSI5VideoAxiStreamTValid    <= vSiChanAxiStreamArray(5).TValid;
  vSI5VideoAxiStreamTLast     <= vSiChanAxiStreamArray(5).TLast;

  vSI6VideoAxiStreamTData     <= vSiChanAxiStreamArray(6).TData;
  vSI6VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(6).TRawData;
  vSI6VideoAxiStreamTUser     <= vSiChanAxiStreamArray(6).TUser(31 downto 0);
  vSI6VideoAxiStreamTValid    <= vSiChanAxiStreamArray(6).TValid;
  vSI6VideoAxiStreamTLast     <= vSiChanAxiStreamArray(6).TLast;

  vSI7VideoAxiStreamTData     <= vSiChanAxiStreamArray(7).TData;
  vSI7VideoRawAxiStreamTData  <= vSiChanAxiStreamArray(7).TRawData;
  vSI7VideoAxiStreamTUser     <= vSiChanAxiStreamArray(7).TUser(31 downto 0);
  vSI7VideoAxiStreamTValid    <= vSiChanAxiStreamArray(7).TValid;
  vSI7VideoAxiStreamTLast     <= vSiChanAxiStreamArray(7).TLast;

  --vhook_e NormalizeSerdesGpio
  NormalizeSerdesGpiox: entity work.NormalizeSerdesGpio (rtl)
    port map (
      sDiagramCh0GpIn      => sDiagramCh0GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh0GpOut     => sDiagramCh0GpOut,      --out std_logic_vector(7:0)
      sDiagramCh0GpOe      => sDiagramCh0GpOe,       --out std_logic_vector(7:0)
      sDiagramCh1GpIn      => sDiagramCh1GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh1GpOut     => sDiagramCh1GpOut,      --out std_logic_vector(7:0)
      sDiagramCh1GpOe      => sDiagramCh1GpOe,       --out std_logic_vector(7:0)
      sDiagramCh2GpIn      => sDiagramCh2GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh2GpOut     => sDiagramCh2GpOut,      --out std_logic_vector(7:0)
      sDiagramCh2GpOe      => sDiagramCh2GpOe,       --out std_logic_vector(7:0)
      sDiagramCh3GpIn      => sDiagramCh3GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh3GpOut     => sDiagramCh3GpOut,      --out std_logic_vector(7:0)
      sDiagramCh3GpOe      => sDiagramCh3GpOe,       --out std_logic_vector(7:0)
      sDiagramCh4GpIn      => sDiagramCh4GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh4GpOut     => sDiagramCh4GpOut,      --out std_logic_vector(7:0)
      sDiagramCh4GpOe      => sDiagramCh4GpOe,       --out std_logic_vector(7:0)
      sDiagramCh5GpIn      => sDiagramCh5GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh5GpOut     => sDiagramCh5GpOut,      --out std_logic_vector(7:0)
      sDiagramCh5GpOe      => sDiagramCh5GpOe,       --out std_logic_vector(7:0)
      sDiagramCh6GpIn      => sDiagramCh6GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh6GpOut     => sDiagramCh6GpOut,      --out std_logic_vector(7:0)
      sDiagramCh6GpOe      => sDiagramCh6GpOe,       --out std_logic_vector(7:0)
      sDiagramCh7GpIn      => sDiagramCh7GpIn,       --in  std_logic_vector(7:0)
      sDiagramCh7GpOut     => sDiagramCh7GpOut,      --out std_logic_vector(7:0)
      sDiagramCh7GpOe      => sDiagramCh7GpOe,       --out std_logic_vector(7:0)
      sDiagramMiscGpIn     => sDiagramMiscGpIn,      --in  std_logic_vector(15:0)
      sDiagramMiscGpOut    => sDiagramMiscGpOut,     --out std_logic_vector(15:0)
      sDiagramMiscGpOe     => sDiagramMiscGpOe,      --out std_logic_vector(15:0)
      sDiagramDes0Mfp0In   => sDiagramDes0Mfp0In,    --out std_logic
      sDiagramDes0Mfp0Out  => sDiagramDes0Mfp0Out,   --in  std_logic
      sDiagramDes0Mfp0Oe   => sDiagramDes0Mfp0Oe,    --in  std_logic
      sDiagramDes0Mfp1In   => sDiagramDes0Mfp1In,    --out std_logic
      sDiagramDes0Mfp1Out  => sDiagramDes0Mfp1Out,   --in  std_logic
      sDiagramDes0Mfp1Oe   => sDiagramDes0Mfp1Oe,    --in  std_logic
      sDiagramDes0Mfp2In   => sDiagramDes0Mfp2In,    --out std_logic
      sDiagramDes0Mfp3In   => sDiagramDes0Mfp3In,    --out std_logic
      sDiagramDes0Mfp4In   => sDiagramDes0Mfp4In,    --out std_logic
      sDiagramDes0Mfp4Out  => sDiagramDes0Mfp4Out,   --in  std_logic
      sDiagramDes0Mfp4Oe   => sDiagramDes0Mfp4Oe,    --in  std_logic
      sDiagramDes0Mfp5In   => sDiagramDes0Mfp5In,    --out std_logic
      sDiagramDes0Mfp5Out  => sDiagramDes0Mfp5Out,   --in  std_logic
      sDiagramDes0Mfp5Oe   => sDiagramDes0Mfp5Oe,    --in  std_logic
      sDiagramDes0Mfp6In   => sDiagramDes0Mfp6In,    --out std_logic
      sDiagramDes0Mfp6Out  => sDiagramDes0Mfp6Out,   --in  std_logic
      sDiagramDes0Mfp6Oe   => sDiagramDes0Mfp6Oe,    --in  std_logic
      sDiagramDes0Mfp7In   => sDiagramDes0Mfp7In,    --out std_logic
      sDiagramDes0Mfp7Out  => sDiagramDes0Mfp7Out,   --in  std_logic
      sDiagramDes0Mfp7Oe   => sDiagramDes0Mfp7Oe,    --in  std_logic
      sDiagramDes1Mfp0In   => sDiagramDes1Mfp0In,    --out std_logic
      sDiagramDes1Mfp0Out  => sDiagramDes1Mfp0Out,   --in  std_logic
      sDiagramDes1Mfp0Oe   => sDiagramDes1Mfp0Oe,    --in  std_logic
      sDiagramDes1Mfp1In   => sDiagramDes1Mfp1In,    --out std_logic
      sDiagramDes1Mfp1Out  => sDiagramDes1Mfp1Out,   --in  std_logic
      sDiagramDes1Mfp1Oe   => sDiagramDes1Mfp1Oe,    --in  std_logic
      sDiagramDes1Mfp2In   => sDiagramDes1Mfp2In,    --out std_logic
      sDiagramDes1Mfp3In   => sDiagramDes1Mfp3In,    --out std_logic
      sDiagramDes1Mfp4In   => sDiagramDes1Mfp4In,    --out std_logic
      sDiagramDes1Mfp4Out  => sDiagramDes1Mfp4Out,   --in  std_logic
      sDiagramDes1Mfp4Oe   => sDiagramDes1Mfp4Oe,    --in  std_logic
      sDiagramDes1Mfp5In   => sDiagramDes1Mfp5In,    --out std_logic
      sDiagramDes1Mfp5Out  => sDiagramDes1Mfp5Out,   --in  std_logic
      sDiagramDes1Mfp5Oe   => sDiagramDes1Mfp5Oe,    --in  std_logic
      sDiagramDes1Mfp6In   => sDiagramDes1Mfp6In,    --out std_logic
      sDiagramDes1Mfp6Out  => sDiagramDes1Mfp6Out,   --in  std_logic
      sDiagramDes1Mfp6Oe   => sDiagramDes1Mfp6Oe,    --in  std_logic
      sDiagramDes1Mfp7In   => sDiagramDes1Mfp7In,    --out std_logic
      sDiagramDes1Mfp7Out  => sDiagramDes1Mfp7Out,   --in  std_logic
      sDiagramDes1Mfp7Oe   => sDiagramDes1Mfp7Oe,    --in  std_logic
      sDiagramDes2Mfp0In   => sDiagramDes2Mfp0In,    --out std_logic
      sDiagramDes2Mfp0Out  => sDiagramDes2Mfp0Out,   --in  std_logic
      sDiagramDes2Mfp0Oe   => sDiagramDes2Mfp0Oe,    --in  std_logic
      sDiagramDes2Mfp1In   => sDiagramDes2Mfp1In,    --out std_logic
      sDiagramDes2Mfp1Out  => sDiagramDes2Mfp1Out,   --in  std_logic
      sDiagramDes2Mfp1Oe   => sDiagramDes2Mfp1Oe,    --in  std_logic
      sDiagramDes2Mfp2In   => sDiagramDes2Mfp2In,    --out std_logic
      sDiagramDes2Mfp3In   => sDiagramDes2Mfp3In,    --out std_logic
      sDiagramDes2Mfp4In   => sDiagramDes2Mfp4In,    --out std_logic
      sDiagramDes2Mfp4Out  => sDiagramDes2Mfp4Out,   --in  std_logic
      sDiagramDes2Mfp4Oe   => sDiagramDes2Mfp4Oe,    --in  std_logic
      sDiagramDes2Mfp5In   => sDiagramDes2Mfp5In,    --out std_logic
      sDiagramDes2Mfp5Out  => sDiagramDes2Mfp5Out,   --in  std_logic
      sDiagramDes2Mfp5Oe   => sDiagramDes2Mfp5Oe,    --in  std_logic
      sDiagramDes2Mfp6In   => sDiagramDes2Mfp6In,    --out std_logic
      sDiagramDes2Mfp6Out  => sDiagramDes2Mfp6Out,   --in  std_logic
      sDiagramDes2Mfp6Oe   => sDiagramDes2Mfp6Oe,    --in  std_logic
      sDiagramDes2Mfp7In   => sDiagramDes2Mfp7In,    --out std_logic
      sDiagramDes2Mfp7Out  => sDiagramDes2Mfp7Out,   --in  std_logic
      sDiagramDes2Mfp7Oe   => sDiagramDes2Mfp7Oe,    --in  std_logic
      sDiagramDes3Mfp0In   => sDiagramDes3Mfp0In,    --out std_logic
      sDiagramDes3Mfp0Out  => sDiagramDes3Mfp0Out,   --in  std_logic
      sDiagramDes3Mfp0Oe   => sDiagramDes3Mfp0Oe,    --in  std_logic
      sDiagramDes3Mfp1In   => sDiagramDes3Mfp1In,    --out std_logic
      sDiagramDes3Mfp1Out  => sDiagramDes3Mfp1Out,   --in  std_logic
      sDiagramDes3Mfp1Oe   => sDiagramDes3Mfp1Oe,    --in  std_logic
      sDiagramDes3Mfp2In   => sDiagramDes3Mfp2In,    --out std_logic
      sDiagramDes3Mfp3In   => sDiagramDes3Mfp3In,    --out std_logic
      sDiagramDes3Mfp4In   => sDiagramDes3Mfp4In,    --out std_logic
      sDiagramDes3Mfp4Out  => sDiagramDes3Mfp4Out,   --in  std_logic
      sDiagramDes3Mfp4Oe   => sDiagramDes3Mfp4Oe,    --in  std_logic
      sDiagramDes3Mfp5In   => sDiagramDes3Mfp5In,    --out std_logic
      sDiagramDes3Mfp5Out  => sDiagramDes3Mfp5Out,   --in  std_logic
      sDiagramDes3Mfp5Oe   => sDiagramDes3Mfp5Oe,    --in  std_logic
      sDiagramDes3Mfp6In   => sDiagramDes3Mfp6In,    --out std_logic
      sDiagramDes3Mfp6Out  => sDiagramDes3Mfp6Out,   --in  std_logic
      sDiagramDes3Mfp6Oe   => sDiagramDes3Mfp6Oe,    --in  std_logic
      sDiagramDes3Mfp7In   => sDiagramDes3Mfp7In,    --out std_logic
      sDiagramDes3Mfp7Out  => sDiagramDes3Mfp7Out,   --in  std_logic
      sDiagramDes3Mfp7Oe   => sDiagramDes3Mfp7Oe,    --in  std_logic
      sDiagramDes0Mfp8In   => sDiagramDes0Mfp8In,    --out std_logic
      sDiagramDes0Mfp8Out  => sDiagramDes0Mfp8Out,   --in  std_logic
      sDiagramDes0Mfp8Oe   => sDiagramDes0Mfp8Oe,    --in  std_logic
      sDiagramDes0Mfp9In   => sDiagramDes0Mfp9In,    --out std_logic
      sDiagramDes0Mfp9Out  => sDiagramDes0Mfp9Out,   --in  std_logic
      sDiagramDes0Mfp9Oe   => sDiagramDes0Mfp9Oe,    --in  std_logic
      sDiagramDes0Mfp10In  => sDiagramDes0Mfp10In,   --out std_logic
      sDiagramDes0Mfp10Out => sDiagramDes0Mfp10Out,  --in  std_logic
      sDiagramDes0Mfp10Oe  => sDiagramDes0Mfp10Oe,   --in  std_logic
      sDiagramDes1Mfp8In   => sDiagramDes1Mfp8In,    --out std_logic
      sDiagramDes1Mfp8Out  => sDiagramDes1Mfp8Out,   --in  std_logic
      sDiagramDes1Mfp8Oe   => sDiagramDes1Mfp8Oe,    --in  std_logic
      sDiagramDes1Mfp9In   => sDiagramDes1Mfp9In,    --out std_logic
      sDiagramDes1Mfp9Out  => sDiagramDes1Mfp9Out,   --in  std_logic
      sDiagramDes1Mfp9Oe   => sDiagramDes1Mfp9Oe,    --in  std_logic
      sDiagramDes1Mfp10In  => sDiagramDes1Mfp10In,   --out std_logic
      sDiagramDes1Mfp10Out => sDiagramDes1Mfp10Out,  --in  std_logic
      sDiagramDes1Mfp10Oe  => sDiagramDes1Mfp10Oe,   --in  std_logic
      sDiagramDes2Mfp8In   => sDiagramDes2Mfp8In,    --out std_logic
      sDiagramDes2Mfp8Out  => sDiagramDes2Mfp8Out,   --in  std_logic
      sDiagramDes2Mfp8Oe   => sDiagramDes2Mfp8Oe,    --in  std_logic
      sDiagramDes2Mfp9In   => sDiagramDes2Mfp9In,    --out std_logic
      sDiagramDes2Mfp9Out  => sDiagramDes2Mfp9Out,   --in  std_logic
      sDiagramDes2Mfp9Oe   => sDiagramDes2Mfp9Oe,    --in  std_logic
      sDiagramDes2Mfp10In  => sDiagramDes2Mfp10In,   --out std_logic
      sDiagramDes2Mfp10Out => sDiagramDes2Mfp10Out,  --in  std_logic
      sDiagramDes2Mfp10Oe  => sDiagramDes2Mfp10Oe,   --in  std_logic
      sDiagramDes3Mfp8In   => sDiagramDes3Mfp8In,    --out std_logic
      sDiagramDes3Mfp8Out  => sDiagramDes3Mfp8Out,   --in  std_logic
      sDiagramDes3Mfp8Oe   => sDiagramDes3Mfp8Oe,    --in  std_logic
      sDiagramDes3Mfp9In   => sDiagramDes3Mfp9In,    --out std_logic
      sDiagramDes3Mfp9Out  => sDiagramDes3Mfp9Out,   --in  std_logic
      sDiagramDes3Mfp9Oe   => sDiagramDes3Mfp9Oe,    --in  std_logic
      sDiagramDes3Mfp10In  => sDiagramDes3Mfp10In,   --out std_logic
      sDiagramDes3Mfp10Out => sDiagramDes3Mfp10Out,  --in  std_logic
      sDiagramDes3Mfp10Oe  => sDiagramDes3Mfp10Oe);  --in  std_logic
end rtl;
