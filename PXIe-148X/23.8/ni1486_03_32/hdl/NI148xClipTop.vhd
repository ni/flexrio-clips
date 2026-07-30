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

    sDiagramDes0Gp0In                  : out std_logic;
    sDiagramDes0Gp0Out                 : in  std_logic;
    sDiagramDes0Gp0Oe                  : in  std_logic;
    sDiagramDes0Gp1In                  : out std_logic;
    sDiagramDes0Gp1Out                 : in  std_logic;
    sDiagramDes0Gp1Oe                  : in  std_logic;
    sDiagramDes0Gp2In                  : out std_logic;
    sDiagramDes0Gp2Out                 : in  std_logic;
    sDiagramDes0Gp2Oe                  : in  std_logic;
    sDiagramDes0Gp3In                  : out std_logic;
    sDiagramDes0Gp3Out                 : in  std_logic;
    sDiagramDes0Gp3Oe                  : in  std_logic;
    sDiagramDes0Gp4In                  : out std_logic;
    sDiagramDes0Gp4Out                 : in  std_logic;
    sDiagramDes0Gp4Oe                  : in  std_logic;
    sDiagramDes0Gp5In                  : out std_logic;
    sDiagramDes0Gp5Out                 : in  std_logic;
    sDiagramDes0Gp5Oe                  : in  std_logic;
    sDiagramDes0Gp6In                  : out std_logic;
    sDiagramDes0Gp6Out                 : in  std_logic;
    sDiagramDes0Gp6Oe                  : in  std_logic;
    sDiagramDes1Gp0In                  : out std_logic;
    sDiagramDes1Gp0Out                 : in  std_logic;
    sDiagramDes1Gp0Oe                  : in  std_logic;
    sDiagramDes1Gp1In                  : out std_logic;
    sDiagramDes1Gp1Out                 : in  std_logic;
    sDiagramDes1Gp1Oe                  : in  std_logic;
    sDiagramDes1Gp2In                  : out std_logic;
    sDiagramDes1Gp2Out                 : in  std_logic;
    sDiagramDes1Gp2Oe                  : in  std_logic;
    sDiagramDes1Gp3In                  : out std_logic;
    sDiagramDes1Gp3Out                 : in  std_logic;
    sDiagramDes1Gp3Oe                  : in  std_logic;
    sDiagramDes1Gp4In                  : out std_logic;
    sDiagramDes1Gp4Out                 : in  std_logic;
    sDiagramDes1Gp4Oe                  : in  std_logic;
    sDiagramDes1Gp5In                  : out std_logic;
    sDiagramDes1Gp5Out                 : in  std_logic;
    sDiagramDes1Gp5Oe                  : in  std_logic;
    sDiagramDes1Gp6In                  : out std_logic;
    sDiagramDes1Gp6Out                 : in  std_logic;
    sDiagramDes1Gp6Oe                  : in  std_logic;
    sDiagramDes2Gp0In                  : out std_logic;
    sDiagramDes2Gp0Out                 : in  std_logic;
    sDiagramDes2Gp0Oe                  : in  std_logic;
    sDiagramDes2Gp1In                  : out std_logic;
    sDiagramDes2Gp1Out                 : in  std_logic;
    sDiagramDes2Gp1Oe                  : in  std_logic;
    sDiagramDes2Gp2In                  : out std_logic;
    sDiagramDes2Gp2Out                 : in  std_logic;
    sDiagramDes2Gp2Oe                  : in  std_logic;
    sDiagramDes2Gp3In                  : out std_logic;
    sDiagramDes2Gp3Out                 : in  std_logic;
    sDiagramDes2Gp3Oe                  : in  std_logic;
    sDiagramDes2Gp4In                  : out std_logic;
    sDiagramDes2Gp4Out                 : in  std_logic;
    sDiagramDes2Gp4Oe                  : in  std_logic;
    sDiagramDes2Gp5In                  : out std_logic;
    sDiagramDes2Gp5Out                 : in  std_logic;
    sDiagramDes2Gp5Oe                  : in  std_logic;
    sDiagramDes2Gp6In                  : out std_logic;
    sDiagramDes2Gp6Out                 : in  std_logic;
    sDiagramDes2Gp6Oe                  : in  std_logic;
    sDiagramDes3Gp0In                  : out std_logic;
    sDiagramDes3Gp0Out                 : in  std_logic;
    sDiagramDes3Gp0Oe                  : in  std_logic;
    sDiagramDes3Gp1In                  : out std_logic;
    sDiagramDes3Gp1Out                 : in  std_logic;
    sDiagramDes3Gp1Oe                  : in  std_logic;
    sDiagramDes3Gp2In                  : out std_logic;
    sDiagramDes3Gp2Out                 : in  std_logic;
    sDiagramDes3Gp2Oe                  : in  std_logic;
    sDiagramDes3Gp3In                  : out std_logic;
    sDiagramDes3Gp3Out                 : in  std_logic;
    sDiagramDes3Gp3Oe                  : in  std_logic;
    sDiagramDes3Gp4In                  : out std_logic;
    sDiagramDes3Gp4Out                 : in  std_logic;
    sDiagramDes3Gp4Oe                  : in  std_logic;
    sDiagramDes3Gp5In                  : out std_logic;
    sDiagramDes3Gp5Out                 : in  std_logic;
    sDiagramDes3Gp5Oe                  : in  std_logic;
    sDiagramDes3Gp6In                  : out std_logic;
    sDiagramDes3Gp6Out                 : in  std_logic;
    sDiagramDes3Gp6Oe                  : in  std_logic;
    sDiagramSer0Gp0In                  : out std_logic;
    sDiagramSer0Gp0Out                 : in  std_logic;
    sDiagramSer0Gp0Oe                  : in  std_logic;
    sDiagramSer0Gp1In                  : out std_logic;
    sDiagramSer0Gp1Out                 : in  std_logic;
    sDiagramSer0Gp1Oe                  : in  std_logic;
    sDiagramSer0Gp2In                  : out std_logic;
    sDiagramSer0Gp2Out                 : in  std_logic;
    sDiagramSer0Gp2Oe                  : in  std_logic;
    sDiagramSer0Gp3In                  : out std_logic;
    sDiagramSer0Gp3Out                 : in  std_logic;
    sDiagramSer0Gp3Oe                  : in  std_logic;
    sDiagramSer1Gp0In                  : out std_logic;
    sDiagramSer1Gp0Out                 : in  std_logic;
    sDiagramSer1Gp0Oe                  : in  std_logic;
    sDiagramSer1Gp1In                  : out std_logic;
    sDiagramSer1Gp1Out                 : in  std_logic;
    sDiagramSer1Gp1Oe                  : in  std_logic;
    sDiagramSer1Gp2In                  : out std_logic;
    sDiagramSer1Gp2Out                 : in  std_logic;
    sDiagramSer1Gp2Oe                  : in  std_logic;
    sDiagramSer1Gp3In                  : out std_logic;
    sDiagramSer1Gp3Out                 : in  std_logic;
    sDiagramSer1Gp3Oe                  : in  std_logic;
    sDiagramSer2Gp0In                  : out std_logic;
    sDiagramSer2Gp0Out                 : in  std_logic;
    sDiagramSer2Gp0Oe                  : in  std_logic;
    sDiagramSer2Gp1In                  : out std_logic;
    sDiagramSer2Gp1Out                 : in  std_logic;
    sDiagramSer2Gp1Oe                  : in  std_logic;
    sDiagramSer2Gp2In                  : out std_logic;
    sDiagramSer2Gp2Out                 : in  std_logic;
    sDiagramSer2Gp2Oe                  : in  std_logic;
    sDiagramSer2Gp3In                  : out std_logic;
    sDiagramSer2Gp3Out                 : in  std_logic;
    sDiagramSer2Gp3Oe                  : in  std_logic;
    sDiagramSer3Gp0In                  : out std_logic;
    sDiagramSer3Gp0Out                 : in  std_logic;
    sDiagramSer3Gp0Oe                  : in  std_logic;
    sDiagramSer3Gp1In                  : out std_logic;
    sDiagramSer3Gp1Out                 : in  std_logic;
    sDiagramSer3Gp1Oe                  : in  std_logic;
    sDiagramSer3Gp2In                  : out std_logic;
    sDiagramSer3Gp2Out                 : in  std_logic;
    sDiagramSer3Gp2Oe                  : in  std_logic;
    sDiagramSer3Gp3In                  : out std_logic;
    sDiagramSer3Gp3Out                 : in  std_logic;
    sDiagramSer3Gp3Oe                  : in  std_logic;

    sDiagramDes0Lock                   : out std_logic;
    sDiagramDes0Pass                   : out std_logic;
    sDiagramDes1Lock                   : out std_logic;
    sDiagramDes1Pass                   : out std_logic;
    sDiagramDes2Lock                   : out std_logic;
    sDiagramDes2Pass                   : out std_logic;
    sDiagramDes3Lock                   : out std_logic;
    sDiagramDes3Pass                   : out std_logic;

    sDiagramCh0PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh0PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh0PocExtEn                : out std_logic;
    sDiagramCh0ExtPgood                : out std_logic;
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
    sDiagramCh7PocCurrent              : out std_logic_vector(11 downto 0);
    sDiagramCh7PocVoltage              : out std_logic_vector(11 downto 0);
    sDiagramCh7PocExtEn                : out std_logic;
    sDiagramCh7ExtPgood                : out std_logic;
    sDiagramCh7PocIntEn                : out std_logic;
    sDiagramCh7IntPgood                : out std_logic;

    sDiagramCh0Pwrdn                   : out std_logic;
    sDiagramCh0I2cSdaIn                : out std_logic;
    sDiagramCh0I2cSdaOe                : in  std_logic;
    sDiagramCh0I2cSclIn                : out std_logic;
    sDiagramCh0I2cSclOe                : in  std_logic;
    sDiagramCh1Pwrdn                   : out std_logic;
    sDiagramCh1I2cSdaIn                : out std_logic;
    sDiagramCh1I2cSdaOe                : in  std_logic;
    sDiagramCh1I2cSclIn                : out std_logic;
    sDiagramCh1I2cSclOe                : in  std_logic;
    sDiagramCh2Pwrdn                   : out std_logic;
    sDiagramCh2I2cSdaIn                : out std_logic;
    sDiagramCh2I2cSdaOe                : in  std_logic;
    sDiagramCh2I2cSclIn                : out std_logic;
    sDiagramCh2I2cSclOe                : in  std_logic;
    sDiagramCh3Pwrdn                   : out std_logic;
    sDiagramCh3I2cSdaIn                : out std_logic;
    sDiagramCh3I2cSdaOe                : in  std_logic;
    sDiagramCh3I2cSclIn                : out std_logic;
    sDiagramCh3I2cSclOe                : in  std_logic;
    sDiagramCh4Pwrdn                   : out std_logic;
    sDiagramCh4I2cSdaIn                : out std_logic;
    sDiagramCh4I2cSdaOe                : in  std_logic;
    sDiagramCh4I2cSclIn                : out std_logic;
    sDiagramCh4I2cSclOe                : in  std_logic;
    sDiagramCh5Pwrdn                   : out std_logic;
    sDiagramCh5I2cSdaIn                : out std_logic;
    sDiagramCh5I2cSdaOe                : in  std_logic;
    sDiagramCh5I2cSclIn                : out std_logic;
    sDiagramCh5I2cSclOe                : in  std_logic;
    sDiagramCh6Pwrdn                   : out std_logic;
    sDiagramCh6I2cSdaIn                : out std_logic;
    sDiagramCh6I2cSdaOe                : in  std_logic;
    sDiagramCh6I2cSclIn                : out std_logic;
    sDiagramCh6I2cSclOe                : in  std_logic;
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

    vSO0VideoAxiStreamTData            : in    std_logic_vector(31 downto 0);
    vSO0VideoAxiStreamTUser            : in    std_logic_vector(31 downto 0);
    vSO0VideoAxiStreamTLast            : in    std_logic;
    vSO0VideoAxiStreamTReady           : out   std_logic;
    vSO0VideoAxiStreamTValid           : in    std_logic;

    vSO1VideoAxiStreamTData            : in    std_logic_vector(31 downto 0);
    vSO1VideoAxiStreamTUser            : in    std_logic_vector(31 downto 0);
    vSO1VideoAxiStreamTLast            : in    std_logic;
    vSO1VideoAxiStreamTReady           : out   std_logic;
    vSO1VideoAxiStreamTValid           : in    std_logic;

    vSO2VideoAxiStreamTData            : in    std_logic_vector(31 downto 0);
    vSO2VideoAxiStreamTUser            : in    std_logic_vector(31 downto 0);
    vSO2VideoAxiStreamTLast            : in    std_logic;
    vSO2VideoAxiStreamTReady           : out   std_logic;
    vSO2VideoAxiStreamTValid           : in    std_logic;

    vSO3VideoAxiStreamTData            : in    std_logic_vector(31 downto 0);
    vSO3VideoAxiStreamTUser            : in    std_logic_vector(31 downto 0);
    vSO3VideoAxiStreamTLast            : in    std_logic;
    vSO3VideoAxiStreamTReady           : out   std_logic;
    vSO3VideoAxiStreamTValid           : in    std_logic;

    -- Generation Control and Status
    vSO0PacketsInFifoCount             : out   std_logic_vector(13 downto 0);
    vSO1PacketsInFifoCount             : out   std_logic_vector(13 downto 0);
    vSO2PacketsInFifoCount             : out   std_logic_vector(13 downto 0);
    vSO3PacketsInFifoCount             : out   std_logic_vector(13 downto 0);

    vSO0TransmitPacketRdy              : out   std_logic;
    vSO1TransmitPacketRdy              : out   std_logic;
    vSO2TransmitPacketRdy              : out   std_logic;
    vSO3TransmitPacketRdy              : out   std_logic;

    vSO0TransmitPacketDone             : out   std_logic;
    vSO1TransmitPacketDone             : out   std_logic;
    vSO2TransmitPacketDone             : out   std_logic;
    vSO3TransmitPacketDone             : out   std_logic;

    vSO0TransmitPacket                 : in    std_logic := '1';
    vSO1TransmitPacket                 : in    std_logic := '1';
    vSO2TransmitPacket                 : in    std_logic := '1';
    vSO3TransmitPacket                 : in    std_logic := '1';

    vSO0ClearTxFifo                    : in    std_logic := '0';
    vSO1ClearTxFifo                    : in    std_logic := '0';
    vSO2ClearTxFifo                    : in    std_logic := '0';
    vSO3ClearTxFifo                    : in    std_logic := '0'
    );
end entity NI148xClipTop;

architecture rtl of NI148xClipTop is

  component Mipi4Tx4RxTop
    port (
      CoreClk                    : in  std_logic;
      VideoClk                   : in  std_logic;
      FastVideoClk               : in  std_logic;
      BusClk                     : in  std_logic;
      cReset                     : in  std_logic;
      vReset                     : in  std_logic;
      fReset                     : in  std_logic;
      bAxiIcReset_n              : in  std_logic;
      bAxiPeriphReset_n          : in  std_logic;
      bAxiToSlaveFlat            : in  Axi4LiteToSlaveFlat_t;
      bAxiToMasterFlat           : out Axi4LiteToMasterFlat_t;
      vTxChan0AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan1AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan4AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan5AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan0AxiStreamReady     : out std_logic;
      vTxChan1AxiStreamReady     : out std_logic;
      vTxChan4AxiStreamReady     : out std_logic;
      vTxChan5AxiStreamReady     : out std_logic;
      vRxChan2AxiStreamFlat      : out AxiVideoStreamFlat_t;
      vRxChan3AxiStreamFlat      : out AxiVideoStreamFlat_t;
      vRxChan6AxiStreamFlat      : out AxiVideoStreamFlat_t;
      vRxChan7AxiStreamFlat      : out AxiVideoStreamFlat_t;
      vTxChan0PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan1PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan4PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan5PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan0TransmitPacketRdy  : out std_logic;
      vTxChan1TransmitPacketRdy  : out std_logic;
      vTxChan4TransmitPacketRdy  : out std_logic;
      vTxChan5TransmitPacketRdy  : out std_logic;
      vTxChan0TransmitPacketDone : out std_logic;
      vTxChan1TransmitPacketDone : out std_logic;
      vTxChan4TransmitPacketDone : out std_logic;
      vTxChan5TransmitPacketDone : out std_logic;
      vTxChan0TransmitPacket     : in  std_logic;
      vTxChan1TransmitPacket     : in  std_logic;
      vTxChan4TransmitPacket     : in  std_logic;
      vTxChan5TransmitPacket     : in  std_logic;
      vTxChan0ClearTxFifo        : in  std_logic;
      vTxChan1ClearTxFifo        : in  std_logic;
      vTxChan4ClearTxFifo        : in  std_logic;
      vTxChan5ClearTxFifo        : in  std_logic;
      xTxChan0PinsFlat           : out MipiPinsFlat_t;
      xTxChan1PinsFlat           : out MipiPinsFlat_t;
      xTxChan4PinsFlat           : out MipiPinsFlat_t;
      xTxChan5PinsFlat           : out MipiPinsFlat_t;
      xRxChan2PinsFlat           : in  MipiPinsFlat_t;
      xRxChan3PinsFlat           : in  MipiPinsFlat_t;
      xRxChan6PinsFlat           : in  MipiPinsFlat_t;
      xRxChan7PinsFlat           : in  MipiPinsFlat_t);
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
  signal vSO0PacketsInFifoCountUns: unsigned(13 downto 0);
  signal vSO1PacketsInFifoCountUns: unsigned(13 downto 0);
  signal vSO2PacketsInFifoCountUns: unsigned(13 downto 0);
  signal vSO3PacketsInFifoCountUns: unsigned(13 downto 0);
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

  --vhook_nowarn sDiagramCh0IntPgood
  --vhook_nowarn sDiagramCh0PocIntEn
  --vhook_nowarn sDiagramCh2IntPgood
  --vhook_nowarn sDiagramCh2PocIntEn
  --vhook_nowarn sDiagramCh4IntPgood
  --vhook_nowarn sDiagramCh4PocIntEn
  --vhook_nowarn sDiagramCh6IntPgood
  --vhook_nowarn sDiagramCh6PocIntEn
  signal sDiagramCh0IntPgood: std_logic;
  signal sDiagramCh0PocIntEn: std_logic;
  signal sDiagramCh2IntPgood: std_logic;
  signal sDiagramCh2PocIntEn: std_logic;
  signal sDiagramCh4IntPgood: std_logic;
  signal sDiagramCh4PocIntEn: std_logic;
  signal sDiagramCh6IntPgood: std_logic;
  signal sDiagramCh6PocIntEn: std_logic;

  --0x7A87  PXIe-TBD FlexRIO GMSL XCVR    (Chimera-M)
  --0x7A86  PXIe-TBD FlexRIO GMSL Output  (Chimera-M)
  --0x7A85  PXIe-TBD FlexRIO GMSL Input   (Chimera-M)
  --0x7A84  PXIe-TBD FlexRIO FPD-Link III XCVR    (Chimera-T)
  --0x7A83  PXIe-TBD FlexRIO FPD-Link III Output  (Chimera-T)
  --0x7A82  PXIe-TBD FlexRIO FPD-Link III Input   (Chimera-T)
  constant kDeviceSignature : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#1093_7A84#, 32));
  signal xIoOutputEnableLcl : std_logic;

  type InnerFamConfigDataMap_t is array (0 to 7) of integer;
  constant kInnerFamConfigDataMap : InnerFamConfigDataMap_t := (1, 4, 6, 9, 11, 15, 19, 23);

  type OuterFamConfigDataMap_t is array (0 to 7) of integer;
  constant kOuterFamConfigDataMap : OuterFamConfigDataMap_t := (0, 3, 5, 8, 10, 14, 18, 22);

  signal xSiChanPinsArray : MipiPinsAry_t(3 downto 0);
  signal xSoChanPinsArray : MipiPinsAry_t(3 downto 0);
  signal xSoChanPinsFlatArray : MipiPinsFlatAry_t(3 downto 0);

  signal vSiChanAxiStreamArray : AxiVideoStreamAry_t(3 downto 0);
  signal vSiChanAxiStreamFlatArray : AxiVideoStreamFlatAry_t(3 downto 0);

  signal vSoChanAxiStreamArray : AxiVideoStreamAry_t(3 downto 0);
  signal vSoVideoAxiStreamTReady : std_logic_vector(3 downto 0);

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

  xSoChanPinsArray <= Unflatten(xSoChanPinsFlatArray);
  --Map D-PHY IO to CLIP Names
  aDiffGpio_p <= MapTxToGpio(aDiffGpio_p, True, xSoChanPinsArray, kNI148x03DphyPinMapSO);
  aDiffGpio_n <= MapTxToGpio(aDiffGpio_n, False, xSoChanPinsArray, kNI148x03DphyPinMapSO);
  xSiChanPinsArray <= MapGpioToRx(aDiffGpio_p, aDiffGpio_n, kNI148x03DphyPinMapSI);

  --
  -- Axi Stream
  vSoChanAxiStreamArray(0).TDataUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(0).TRawDataUpperDWord <= (others=>'0');
  vSoChanAxiStreamArray(0).TStrbUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(0).TKeepUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(0).TData              <= vSO0VideoAxiStreamTData;
  vSoChanAxiStreamArray(0).TRawData           <= vSO0VideoAxiStreamTData;
  vSoChanAxiStreamArray(0).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(0).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(0).TID                <= std_logic_vector(To_Unsigned(0, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(0).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(0).TUser(31 downto 0) <= vSO0VideoAxiStreamTUser;
  vSoChanAxiStreamArray(0).TValid             <= vSO0VideoAxiStreamTValid;
  vSoChanAxiStreamArray(0).TLast              <= vSO0VideoAxiStreamTLast;
  vSO0VideoAxiStreamTReady                    <= vSoVideoAxiStreamTReady(0);

  vSoChanAxiStreamArray(1).TDataUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(1).TRawDataUpperDWord <= (others=>'0');
  vSoChanAxiStreamArray(1).TStrbUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(1).TKeepUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(1).TData              <= vSO1VideoAxiStreamTData;
  vSoChanAxiStreamArray(1).TRawData           <= vSO1VideoAxiStreamTData;
  vSoChanAxiStreamArray(1).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(1).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(1).TID                <= std_logic_vector(To_Unsigned(1, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(1).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(1).TUser(31 downto 0) <= vSO1VideoAxiStreamTUser;
  vSoChanAxiStreamArray(1).TValid             <= vSO1VideoAxiStreamTValid;
  vSoChanAxiStreamArray(1).TLast              <= vSO1VideoAxiStreamTLast;
  vSO1VideoAxiStreamTReady                    <= vSoVideoAxiStreamTReady(1);

  vSoChanAxiStreamArray(2).TDataUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(2).TRawDataUpperDWord <= (others=>'0');
  vSoChanAxiStreamArray(2).TStrbUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(2).TKeepUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(2).TData              <= vSO2VideoAxiStreamTData;
  vSoChanAxiStreamArray(2).TRawData           <= vSO2VideoAxiStreamTData;
  vSoChanAxiStreamArray(2).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(2).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(2).TID                <= std_logic_vector(To_Unsigned(2, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(2).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(2).TUser(31 downto 0) <= vSO2VideoAxiStreamTUser;
  vSoChanAxiStreamArray(2).TValid             <= vSO2VideoAxiStreamTValid;
  vSoChanAxiStreamArray(2).TLast              <= vSO2VideoAxiStreamTLast;
  vSO2VideoAxiStreamTReady                    <= vSoVideoAxiStreamTReady(2);

  vSoChanAxiStreamArray(3).TDataUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(3).TRawDataUpperDWord <= (others=>'0');
  vSoChanAxiStreamArray(3).TStrbUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(3).TKeepUpperDWord    <= (others=>'0');
  vSoChanAxiStreamArray(3).TData              <= vSO3VideoAxiStreamTData;
  vSoChanAxiStreamArray(3).TRawData           <= vSO3VideoAxiStreamTData;
  vSoChanAxiStreamArray(3).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(3).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(3).TID                <= std_logic_vector(To_Unsigned(3, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(3).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(3).TUser(31 downto 0) <= vSO3VideoAxiStreamTUser;
  vSoChanAxiStreamArray(3).TValid             <= vSO3VideoAxiStreamTValid;
  vSoChanAxiStreamArray(3).TLast              <= vSO3VideoAxiStreamTLast;
  vSO3VideoAxiStreamTReady                    <= vSoVideoAxiStreamTReady(3);

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

  --vhook   Mipi4Tx4RxTop
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
  --vhook_# TxCh0:SO0, TxCh1:SO2, RxCh2:SI0, RxCh3:SI2, TxCh4:SO1, TxCh5:SO3, RxCh6:SI1, RxCh7:SI3
  --vhook_p vTxChan0AxiStreamFlat    Flatten(vSoChanAxiStreamArray(0))
  --vhook_p vTxChan1AxiStreamFlat    Flatten(vSoChanAxiStreamArray(2))
  --vhook_p vTxChan4AxiStreamFlat    Flatten(vSoChanAxiStreamArray(1))
  --vhook_p vTxChan5AxiStreamFlat    Flatten(vSoChanAxiStreamArray(3))
  --vhook_p {vTxChan0(.*)Ready}      {vSoVideo$1TReady(0)}
  --vhook_p {vTxChan1(.*)Ready}      {vSoVideo$1TReady(2)}
  --vhook_p {vTxChan4(.*)Ready}      {vSoVideo$1TReady(1)}
  --vhook_p {vTxChan5(.*)Ready}      {vSoVideo$1TReady(3)}
  --vhook_p {xTxChan0(.*)}           {xSoChan$1Array(0)}
  --vhook_p {xTxChan1(.*)}           {xSoChan$1Array(2)}
  --vhook_p {xTxChan4(.*)}           {xSoChan$1Array(1)}
  --vhook_p {xTxChan5(.*)}           {xSoChan$1Array(3)}
  --vhook_p {vTxChan0(.*)Packet(.*)} {vSO0$1Packet$2} type=std_logic
  --vhook_p {vTxChan0(.*)Packet(.*)} {vSO0$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan0(.*)(.*)}       {vSO0$1$2} type=std_logic
  --vhook_p {vTxChan1(.*)Packet(.*)} {vSO2$1Packet$2} type=std_logic
  --vhook_p {vTxChan1(.*)Packet(.*)} {vSO2$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan1(.*)(.*)}       {vSO2$1$2} type=std_logic
  --vhook_p {vTxChan4(.*)Packet(.*)} {vSO1$1Packet$2} type=std_logic
  --vhook_p {vTxChan4(.*)Packet(.*)} {vSO1$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan4(.*)(.*)}       {vSO1$1$2} type=std_logic
  --vhook_p {vTxChan5(.*)Packet(.*)} {vSO3$1Packet$2} type=std_logic
  --vhook_p {vTxChan5(.*)Packet(.*)} {vSO3$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan5(.*)(.*)}       {vSO3$1$2} type=std_logic
  --vhook_p {vRxChan2(.*)}           {vSiChan$1Array(0)}
  --vhook_p {vRxChan3(.*)}           {vSiChan$1Array(2)}
  --vhook_p {vRxChan6(.*)}           {vSiChan$1Array(1)}
  --vhook_p {vRxChan7(.*)}           {vSiChan$1Array(3)}
  --vhook_p {xRxChan2(.*)}           {Flatten(xSiChanPinsArray(0))}
  --vhook_p {xRxChan3(.*)}           {Flatten(xSiChanPinsArray(2))}
  --vhook_p {xRxChan6(.*)}           {Flatten(xSiChanPinsArray(1))}
  --vhook_p {xRxChan7(.*)}           {Flatten(xSiChanPinsArray(3))}
  Mipi4Tx4RxTopx: Mipi4Tx4RxTop
    port map (
      CoreClk                    => VideoClkLcl,                        --in  std_logic
      VideoClk                   => VideoClkLcl,                        --in  std_logic
      FastVideoClk               => FastVideoClk,                       --in  std_logic
      BusClk                     => AxiClk,                             --in  std_logic
      cReset                     => (NOT cCorePeripheralReset_n),       --in  std_logic
      vReset                     => (NOT vAxiPeripheralReset_n),        --in  std_logic
      fReset                     => (NOT fAxiPeripheralReset_n),        --in  std_logic
      bAxiIcReset_n              => xAxiInterconnectReset_n,            --in  std_logic
      bAxiPeriphReset_n          => xAxiPeripheralReset_n,              --in  std_logic
      bAxiToSlaveFlat            => xCsiIpAxi4LiteToSlaveFlat,          --in  Axi4LiteToSlaveFlat_t
      bAxiToMasterFlat           => xCsiIpAxi4LiteToMasterFlat,         --out Axi4LiteToMasterFlat_t
      vTxChan0AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(0)),  --in  AxiVideoStreamFlat_t
      vTxChan1AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(2)),  --in  AxiVideoStreamFlat_t
      vTxChan4AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(1)),  --in  AxiVideoStreamFlat_t
      vTxChan5AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(3)),  --in  AxiVideoStreamFlat_t
      vTxChan0AxiStreamReady     => vSoVideoAxiStreamTReady(0),         --out std_logic
      vTxChan1AxiStreamReady     => vSoVideoAxiStreamTReady(2),         --out std_logic
      vTxChan4AxiStreamReady     => vSoVideoAxiStreamTReady(1),         --out std_logic
      vTxChan5AxiStreamReady     => vSoVideoAxiStreamTReady(3),         --out std_logic
      vRxChan2AxiStreamFlat      => vSiChanAxiStreamFlatArray(0),       --out AxiVideoStreamFlat_t
      vRxChan3AxiStreamFlat      => vSiChanAxiStreamFlatArray(2),       --out AxiVideoStreamFlat_t
      vRxChan6AxiStreamFlat      => vSiChanAxiStreamFlatArray(1),       --out AxiVideoStreamFlat_t
      vRxChan7AxiStreamFlat      => vSiChanAxiStreamFlatArray(3),       --out AxiVideoStreamFlat_t
      vTxChan0PacketsInFifoCount => vSO0PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan1PacketsInFifoCount => vSO2PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan4PacketsInFifoCount => vSO1PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan5PacketsInFifoCount => vSO3PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan0TransmitPacketRdy  => vSO0TransmitPacketRdy,              --out std_logic
      vTxChan1TransmitPacketRdy  => vSO2TransmitPacketRdy,              --out std_logic
      vTxChan4TransmitPacketRdy  => vSO1TransmitPacketRdy,              --out std_logic
      vTxChan5TransmitPacketRdy  => vSO3TransmitPacketRdy,              --out std_logic
      vTxChan0TransmitPacketDone => vSO0TransmitPacketDone,             --out std_logic
      vTxChan1TransmitPacketDone => vSO2TransmitPacketDone,             --out std_logic
      vTxChan4TransmitPacketDone => vSO1TransmitPacketDone,             --out std_logic
      vTxChan5TransmitPacketDone => vSO3TransmitPacketDone,             --out std_logic
      vTxChan0TransmitPacket     => vSO0TransmitPacket,                 --in  std_logic
      vTxChan1TransmitPacket     => vSO2TransmitPacket,                 --in  std_logic
      vTxChan4TransmitPacket     => vSO1TransmitPacket,                 --in  std_logic
      vTxChan5TransmitPacket     => vSO3TransmitPacket,                 --in  std_logic
      vTxChan0ClearTxFifo        => vSO0ClearTxFifo,                    --in  std_logic
      vTxChan1ClearTxFifo        => vSO2ClearTxFifo,                    --in  std_logic
      vTxChan4ClearTxFifo        => vSO1ClearTxFifo,                    --in  std_logic
      vTxChan5ClearTxFifo        => vSO3ClearTxFifo,                    --in  std_logic
      xTxChan0PinsFlat           => xSoChanPinsFlatArray(0),            --out MipiPinsFlat_t
      xTxChan1PinsFlat           => xSoChanPinsFlatArray(2),            --out MipiPinsFlat_t
      xTxChan4PinsFlat           => xSoChanPinsFlatArray(1),            --out MipiPinsFlat_t
      xTxChan5PinsFlat           => xSoChanPinsFlatArray(3),            --out MipiPinsFlat_t
      xRxChan2PinsFlat           => Flatten(xSiChanPinsArray(0)),       --in  MipiPinsFlat_t
      xRxChan3PinsFlat           => Flatten(xSiChanPinsArray(2)),       --in  MipiPinsFlat_t
      xRxChan6PinsFlat           => Flatten(xSiChanPinsArray(1)),       --in  MipiPinsFlat_t
      xRxChan7PinsFlat           => Flatten(xSiChanPinsArray(3)));      --in  MipiPinsFlat_t

  vSiChanAxiStreamArray     <= Unflatten(vSiChanAxiStreamFlatArray);

  vSO0PacketsInFifoCount <= std_logic_vector(vSO0PacketsInFifoCountUns);
  vSO1PacketsInFifoCount <= std_logic_vector(vSO1PacketsInFifoCountUns);
  vSO2PacketsInFifoCount <= std_logic_vector(vSO2PacketsInFifoCountUns);
  vSO3PacketsInFifoCount <= std_logic_vector(vSO3PacketsInFifoCountUns);

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

  --vhook_e NormalizeSerdesGpio
  NormalizeSerdesGpiox: entity work.NormalizeSerdesGpio (rtl)
    port map (
      sDiagramCh0GpIn    => sDiagramCh0GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh0GpOut   => sDiagramCh0GpOut,    --out std_logic_vector(7:0)
      sDiagramCh0GpOe    => sDiagramCh0GpOe,     --out std_logic_vector(7:0)
      sDiagramCh1GpIn    => sDiagramCh1GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh1GpOut   => sDiagramCh1GpOut,    --out std_logic_vector(7:0)
      sDiagramCh1GpOe    => sDiagramCh1GpOe,     --out std_logic_vector(7:0)
      sDiagramCh2GpIn    => sDiagramCh2GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh2GpOut   => sDiagramCh2GpOut,    --out std_logic_vector(7:0)
      sDiagramCh2GpOe    => sDiagramCh2GpOe,     --out std_logic_vector(7:0)
      sDiagramCh3GpIn    => sDiagramCh3GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh3GpOut   => sDiagramCh3GpOut,    --out std_logic_vector(7:0)
      sDiagramCh3GpOe    => sDiagramCh3GpOe,     --out std_logic_vector(7:0)
      sDiagramCh4GpIn    => sDiagramCh4GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh4GpOut   => sDiagramCh4GpOut,    --out std_logic_vector(7:0)
      sDiagramCh4GpOe    => sDiagramCh4GpOe,     --out std_logic_vector(7:0)
      sDiagramCh5GpIn    => sDiagramCh5GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh5GpOut   => sDiagramCh5GpOut,    --out std_logic_vector(7:0)
      sDiagramCh5GpOe    => sDiagramCh5GpOe,     --out std_logic_vector(7:0)
      sDiagramCh6GpIn    => sDiagramCh6GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh6GpOut   => sDiagramCh6GpOut,    --out std_logic_vector(7:0)
      sDiagramCh6GpOe    => sDiagramCh6GpOe,     --out std_logic_vector(7:0)
      sDiagramCh7GpIn    => sDiagramCh7GpIn,     --in  std_logic_vector(7:0)
      sDiagramCh7GpOut   => sDiagramCh7GpOut,    --out std_logic_vector(7:0)
      sDiagramCh7GpOe    => sDiagramCh7GpOe,     --out std_logic_vector(7:0)
      sDiagramMiscGpIn   => sDiagramMiscGpIn,    --in  std_logic_vector(15:0)
      sDiagramMiscGpOut  => sDiagramMiscGpOut,   --out std_logic_vector(15:0)
      sDiagramMiscGpOe   => sDiagramMiscGpOe,    --out std_logic_vector(15:0)
      sDiagramDes0Gp0In  => sDiagramDes0Gp0In,   --out std_logic
      sDiagramDes0Gp0Out => sDiagramDes0Gp0Out,  --in  std_logic
      sDiagramDes0Gp0Oe  => sDiagramDes0Gp0Oe,   --in  std_logic
      sDiagramDes0Gp1In  => sDiagramDes0Gp1In,   --out std_logic
      sDiagramDes0Gp1Out => sDiagramDes0Gp1Out,  --in  std_logic
      sDiagramDes0Gp1Oe  => sDiagramDes0Gp1Oe,   --in  std_logic
      sDiagramDes0Gp2In  => sDiagramDes0Gp2In,   --out std_logic
      sDiagramDes0Gp2Out => sDiagramDes0Gp2Out,  --in  std_logic
      sDiagramDes0Gp2Oe  => sDiagramDes0Gp2Oe,   --in  std_logic
      sDiagramDes0Gp3In  => sDiagramDes0Gp3In,   --out std_logic
      sDiagramDes0Gp3Out => sDiagramDes0Gp3Out,  --in  std_logic
      sDiagramDes0Gp3Oe  => sDiagramDes0Gp3Oe,   --in  std_logic
      sDiagramDes0Gp4In  => sDiagramDes0Gp4In,   --out std_logic
      sDiagramDes0Gp4Out => sDiagramDes0Gp4Out,  --in  std_logic
      sDiagramDes0Gp4Oe  => sDiagramDes0Gp4Oe,   --in  std_logic
      sDiagramDes0Gp5In  => sDiagramDes0Gp5In,   --out std_logic
      sDiagramDes0Gp5Out => sDiagramDes0Gp5Out,  --in  std_logic
      sDiagramDes0Gp5Oe  => sDiagramDes0Gp5Oe,   --in  std_logic
      sDiagramDes0Gp6In  => sDiagramDes0Gp6In,   --out std_logic
      sDiagramDes0Gp6Out => sDiagramDes0Gp6Out,  --in  std_logic
      sDiagramDes0Gp6Oe  => sDiagramDes0Gp6Oe,   --in  std_logic
      sDiagramDes1Gp0In  => sDiagramDes1Gp0In,   --out std_logic
      sDiagramDes1Gp0Out => sDiagramDes1Gp0Out,  --in  std_logic
      sDiagramDes1Gp0Oe  => sDiagramDes1Gp0Oe,   --in  std_logic
      sDiagramDes1Gp1In  => sDiagramDes1Gp1In,   --out std_logic
      sDiagramDes1Gp1Out => sDiagramDes1Gp1Out,  --in  std_logic
      sDiagramDes1Gp1Oe  => sDiagramDes1Gp1Oe,   --in  std_logic
      sDiagramDes1Gp2In  => sDiagramDes1Gp2In,   --out std_logic
      sDiagramDes1Gp2Out => sDiagramDes1Gp2Out,  --in  std_logic
      sDiagramDes1Gp2Oe  => sDiagramDes1Gp2Oe,   --in  std_logic
      sDiagramDes1Gp3In  => sDiagramDes1Gp3In,   --out std_logic
      sDiagramDes1Gp3Out => sDiagramDes1Gp3Out,  --in  std_logic
      sDiagramDes1Gp3Oe  => sDiagramDes1Gp3Oe,   --in  std_logic
      sDiagramDes1Gp4In  => sDiagramDes1Gp4In,   --out std_logic
      sDiagramDes1Gp4Out => sDiagramDes1Gp4Out,  --in  std_logic
      sDiagramDes1Gp4Oe  => sDiagramDes1Gp4Oe,   --in  std_logic
      sDiagramDes1Gp5In  => sDiagramDes1Gp5In,   --out std_logic
      sDiagramDes1Gp5Out => sDiagramDes1Gp5Out,  --in  std_logic
      sDiagramDes1Gp5Oe  => sDiagramDes1Gp5Oe,   --in  std_logic
      sDiagramDes1Gp6In  => sDiagramDes1Gp6In,   --out std_logic
      sDiagramDes1Gp6Out => sDiagramDes1Gp6Out,  --in  std_logic
      sDiagramDes1Gp6Oe  => sDiagramDes1Gp6Oe,   --in  std_logic
      sDiagramDes2Gp0In  => sDiagramDes2Gp0In,   --out std_logic
      sDiagramDes2Gp0Out => sDiagramDes2Gp0Out,  --in  std_logic
      sDiagramDes2Gp0Oe  => sDiagramDes2Gp0Oe,   --in  std_logic
      sDiagramDes2Gp1In  => sDiagramDes2Gp1In,   --out std_logic
      sDiagramDes2Gp1Out => sDiagramDes2Gp1Out,  --in  std_logic
      sDiagramDes2Gp1Oe  => sDiagramDes2Gp1Oe,   --in  std_logic
      sDiagramDes2Gp2In  => sDiagramDes2Gp2In,   --out std_logic
      sDiagramDes2Gp2Out => sDiagramDes2Gp2Out,  --in  std_logic
      sDiagramDes2Gp2Oe  => sDiagramDes2Gp2Oe,   --in  std_logic
      sDiagramDes2Gp3In  => sDiagramDes2Gp3In,   --out std_logic
      sDiagramDes2Gp3Out => sDiagramDes2Gp3Out,  --in  std_logic
      sDiagramDes2Gp3Oe  => sDiagramDes2Gp3Oe,   --in  std_logic
      sDiagramDes2Gp4In  => sDiagramDes2Gp4In,   --out std_logic
      sDiagramDes2Gp4Out => sDiagramDes2Gp4Out,  --in  std_logic
      sDiagramDes2Gp4Oe  => sDiagramDes2Gp4Oe,   --in  std_logic
      sDiagramDes2Gp5In  => sDiagramDes2Gp5In,   --out std_logic
      sDiagramDes2Gp5Out => sDiagramDes2Gp5Out,  --in  std_logic
      sDiagramDes2Gp5Oe  => sDiagramDes2Gp5Oe,   --in  std_logic
      sDiagramDes2Gp6In  => sDiagramDes2Gp6In,   --out std_logic
      sDiagramDes2Gp6Out => sDiagramDes2Gp6Out,  --in  std_logic
      sDiagramDes2Gp6Oe  => sDiagramDes2Gp6Oe,   --in  std_logic
      sDiagramDes3Gp0In  => sDiagramDes3Gp0In,   --out std_logic
      sDiagramDes3Gp0Out => sDiagramDes3Gp0Out,  --in  std_logic
      sDiagramDes3Gp0Oe  => sDiagramDes3Gp0Oe,   --in  std_logic
      sDiagramDes3Gp1In  => sDiagramDes3Gp1In,   --out std_logic
      sDiagramDes3Gp1Out => sDiagramDes3Gp1Out,  --in  std_logic
      sDiagramDes3Gp1Oe  => sDiagramDes3Gp1Oe,   --in  std_logic
      sDiagramDes3Gp2In  => sDiagramDes3Gp2In,   --out std_logic
      sDiagramDes3Gp2Out => sDiagramDes3Gp2Out,  --in  std_logic
      sDiagramDes3Gp2Oe  => sDiagramDes3Gp2Oe,   --in  std_logic
      sDiagramDes3Gp3In  => sDiagramDes3Gp3In,   --out std_logic
      sDiagramDes3Gp3Out => sDiagramDes3Gp3Out,  --in  std_logic
      sDiagramDes3Gp3Oe  => sDiagramDes3Gp3Oe,   --in  std_logic
      sDiagramDes3Gp4In  => sDiagramDes3Gp4In,   --out std_logic
      sDiagramDes3Gp4Out => sDiagramDes3Gp4Out,  --in  std_logic
      sDiagramDes3Gp4Oe  => sDiagramDes3Gp4Oe,   --in  std_logic
      sDiagramDes3Gp5In  => sDiagramDes3Gp5In,   --out std_logic
      sDiagramDes3Gp5Out => sDiagramDes3Gp5Out,  --in  std_logic
      sDiagramDes3Gp5Oe  => sDiagramDes3Gp5Oe,   --in  std_logic
      sDiagramDes3Gp6In  => sDiagramDes3Gp6In,   --out std_logic
      sDiagramDes3Gp6Out => sDiagramDes3Gp6Out,  --in  std_logic
      sDiagramDes3Gp6Oe  => sDiagramDes3Gp6Oe,   --in  std_logic
      sDiagramSer0Gp0In  => sDiagramSer0Gp0In,   --out std_logic
      sDiagramSer0Gp0Out => sDiagramSer0Gp0Out,  --in  std_logic
      sDiagramSer0Gp0Oe  => sDiagramSer0Gp0Oe,   --in  std_logic
      sDiagramSer0Gp1In  => sDiagramSer0Gp1In,   --out std_logic
      sDiagramSer0Gp1Out => sDiagramSer0Gp1Out,  --in  std_logic
      sDiagramSer0Gp1Oe  => sDiagramSer0Gp1Oe,   --in  std_logic
      sDiagramSer0Gp2In  => sDiagramSer0Gp2In,   --out std_logic
      sDiagramSer0Gp2Out => sDiagramSer0Gp2Out,  --in  std_logic
      sDiagramSer0Gp2Oe  => sDiagramSer0Gp2Oe,   --in  std_logic
      sDiagramSer0Gp3In  => sDiagramSer0Gp3In,   --out std_logic
      sDiagramSer0Gp3Out => sDiagramSer0Gp3Out,  --in  std_logic
      sDiagramSer0Gp3Oe  => sDiagramSer0Gp3Oe,   --in  std_logic
      sDiagramSer1Gp0In  => sDiagramSer1Gp0In,   --out std_logic
      sDiagramSer1Gp0Out => sDiagramSer1Gp0Out,  --in  std_logic
      sDiagramSer1Gp0Oe  => sDiagramSer1Gp0Oe,   --in  std_logic
      sDiagramSer1Gp1In  => sDiagramSer1Gp1In,   --out std_logic
      sDiagramSer1Gp1Out => sDiagramSer1Gp1Out,  --in  std_logic
      sDiagramSer1Gp1Oe  => sDiagramSer1Gp1Oe,   --in  std_logic
      sDiagramSer1Gp2In  => sDiagramSer1Gp2In,   --out std_logic
      sDiagramSer1Gp2Out => sDiagramSer1Gp2Out,  --in  std_logic
      sDiagramSer1Gp2Oe  => sDiagramSer1Gp2Oe,   --in  std_logic
      sDiagramSer1Gp3In  => sDiagramSer1Gp3In,   --out std_logic
      sDiagramSer1Gp3Out => sDiagramSer1Gp3Out,  --in  std_logic
      sDiagramSer1Gp3Oe  => sDiagramSer1Gp3Oe,   --in  std_logic
      sDiagramSer2Gp0In  => sDiagramSer2Gp0In,   --out std_logic
      sDiagramSer2Gp0Out => sDiagramSer2Gp0Out,  --in  std_logic
      sDiagramSer2Gp0Oe  => sDiagramSer2Gp0Oe,   --in  std_logic
      sDiagramSer2Gp1In  => sDiagramSer2Gp1In,   --out std_logic
      sDiagramSer2Gp1Out => sDiagramSer2Gp1Out,  --in  std_logic
      sDiagramSer2Gp1Oe  => sDiagramSer2Gp1Oe,   --in  std_logic
      sDiagramSer2Gp2In  => sDiagramSer2Gp2In,   --out std_logic
      sDiagramSer2Gp2Out => sDiagramSer2Gp2Out,  --in  std_logic
      sDiagramSer2Gp2Oe  => sDiagramSer2Gp2Oe,   --in  std_logic
      sDiagramSer2Gp3In  => sDiagramSer2Gp3In,   --out std_logic
      sDiagramSer2Gp3Out => sDiagramSer2Gp3Out,  --in  std_logic
      sDiagramSer2Gp3Oe  => sDiagramSer2Gp3Oe,   --in  std_logic
      sDiagramSer3Gp0In  => sDiagramSer3Gp0In,   --out std_logic
      sDiagramSer3Gp0Out => sDiagramSer3Gp0Out,  --in  std_logic
      sDiagramSer3Gp0Oe  => sDiagramSer3Gp0Oe,   --in  std_logic
      sDiagramSer3Gp1In  => sDiagramSer3Gp1In,   --out std_logic
      sDiagramSer3Gp1Out => sDiagramSer3Gp1Out,  --in  std_logic
      sDiagramSer3Gp1Oe  => sDiagramSer3Gp1Oe,   --in  std_logic
      sDiagramSer3Gp2In  => sDiagramSer3Gp2In,   --out std_logic
      sDiagramSer3Gp2Out => sDiagramSer3Gp2Out,  --in  std_logic
      sDiagramSer3Gp2Oe  => sDiagramSer3Gp2Oe,   --in  std_logic
      sDiagramSer3Gp3In  => sDiagramSer3Gp3In,   --out std_logic
      sDiagramSer3Gp3Out => sDiagramSer3Gp3Out,  --in  std_logic
      sDiagramSer3Gp3Oe  => sDiagramSer3Gp3Oe,   --in  std_logic
      sDiagramDes0Lock   => sDiagramDes0Lock,    --out std_logic
      sDiagramDes0Pass   => sDiagramDes0Pass,    --out std_logic
      sDiagramDes1Lock   => sDiagramDes1Lock,    --out std_logic
      sDiagramDes1Pass   => sDiagramDes1Pass,    --out std_logic
      sDiagramDes2Lock   => sDiagramDes2Lock,    --out std_logic
      sDiagramDes2Pass   => sDiagramDes2Pass,    --out std_logic
      sDiagramDes3Lock   => sDiagramDes3Lock,    --out std_logic
      sDiagramDes3Pass   => sDiagramDes3Pass);   --out std_logic
end rtl;
