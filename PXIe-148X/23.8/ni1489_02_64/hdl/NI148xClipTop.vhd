-------------------------------------------------------------------------------
--
-- File: NI148xClipTop.vhd
-- Author: Ming Zhi Lim
-- Original Project: NI 148X
-- Date: 6 Jan 2023
--
-------------------------------------------------------------------------------
-- (c) 2023 Copyright National Instruments.
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

    sDiagramSer0Mfp0In                 : out std_logic;
    sDiagramSer0Mfp0Out                : in  std_logic;
    sDiagramSer0Mfp0Oe                 : in  std_logic;
    sDiagramSer0Mfp1In                 : out std_logic;
    sDiagramSer0Mfp2In                 : out std_logic;
    sDiagramSer0Mfp3In                 : out std_logic;
    sDiagramSer0Mfp3Out                : in  std_logic;
    sDiagramSer0Mfp3Oe                 : in  std_logic;
    sDiagramSer0Mfp4In                 : out std_logic;
    sDiagramSer0Mfp4Out                : in  std_logic;
    sDiagramSer0Mfp4Oe                 : in  std_logic;
    sDiagramSer0Mfp6In                 : out std_logic;
    sDiagramSer0Mfp6Out                : in  std_logic;
    sDiagramSer0Mfp6Oe                 : in  std_logic;
    sDiagramSer0Mfp7In                 : out std_logic;
    sDiagramSer0Mfp7Out                : in  std_logic;
    sDiagramSer0Mfp7Oe                 : in  std_logic;
    sDiagramSer0Mfp8In                 : out std_logic;
    sDiagramSer0Mfp8Out                : in  std_logic;
    sDiagramSer0Mfp8Oe                 : in  std_logic;
    sDiagramSer1Mfp0In                 : out std_logic;
    sDiagramSer1Mfp0Out                : in  std_logic;
    sDiagramSer1Mfp0Oe                 : in  std_logic;
    sDiagramSer1Mfp1In                 : out std_logic;
    sDiagramSer1Mfp2In                 : out std_logic;
    sDiagramSer1Mfp3In                 : out std_logic;
    sDiagramSer1Mfp3Out                : in  std_logic;
    sDiagramSer1Mfp3Oe                 : in  std_logic;
    sDiagramSer1Mfp4In                 : out std_logic;
    sDiagramSer1Mfp4Out                : in  std_logic;
    sDiagramSer1Mfp4Oe                 : in  std_logic;
    sDiagramSer1Mfp6In                 : out std_logic;
    sDiagramSer1Mfp6Out                : in  std_logic;
    sDiagramSer1Mfp6Oe                 : in  std_logic;
    sDiagramSer1Mfp7In                 : out std_logic;
    sDiagramSer1Mfp7Out                : in  std_logic;
    sDiagramSer1Mfp7Oe                 : in  std_logic;
    sDiagramSer1Mfp8In                 : out std_logic;
    sDiagramSer1Mfp8Out                : in  std_logic;
    sDiagramSer1Mfp8Oe                 : in  std_logic;
    sDiagramSer2Mfp0In                 : out std_logic;
    sDiagramSer2Mfp0Out                : in  std_logic;
    sDiagramSer2Mfp0Oe                 : in  std_logic;
    sDiagramSer2Mfp1In                 : out std_logic;
    sDiagramSer2Mfp2In                 : out std_logic;
    sDiagramSer2Mfp3In                 : out std_logic;
    sDiagramSer2Mfp3Out                : in  std_logic;
    sDiagramSer2Mfp3Oe                 : in  std_logic;
    sDiagramSer2Mfp4In                 : out std_logic;
    sDiagramSer2Mfp4Out                : in  std_logic;
    sDiagramSer2Mfp4Oe                 : in  std_logic;
    sDiagramSer2Mfp6In                 : out std_logic;
    sDiagramSer2Mfp6Out                : in  std_logic;
    sDiagramSer2Mfp6Oe                 : in  std_logic;
    sDiagramSer2Mfp7In                 : out std_logic;
    sDiagramSer2Mfp7Out                : in  std_logic;
    sDiagramSer2Mfp7Oe                 : in  std_logic;
    sDiagramSer2Mfp8In                 : out std_logic;
    sDiagramSer2Mfp8Out                : in  std_logic;
    sDiagramSer2Mfp8Oe                 : in  std_logic;
    sDiagramSer3Mfp0In                 : out std_logic;
    sDiagramSer3Mfp0Out                : in  std_logic;
    sDiagramSer3Mfp0Oe                 : in  std_logic;
    sDiagramSer3Mfp1In                 : out std_logic;
    sDiagramSer3Mfp2In                 : out std_logic;
    sDiagramSer3Mfp3In                 : out std_logic;
    sDiagramSer3Mfp3Out                : in  std_logic;
    sDiagramSer3Mfp3Oe                 : in  std_logic;
    sDiagramSer3Mfp4In                 : out std_logic;
    sDiagramSer3Mfp4Out                : in  std_logic;
    sDiagramSer3Mfp4Oe                 : in  std_logic;
    sDiagramSer3Mfp6In                 : out std_logic;
    sDiagramSer3Mfp6Out                : in  std_logic;
    sDiagramSer3Mfp6Oe                 : in  std_logic;
    sDiagramSer3Mfp7In                 : out std_logic;
    sDiagramSer3Mfp7Out                : in  std_logic;
    sDiagramSer3Mfp7Oe                 : in  std_logic;
    sDiagramSer3Mfp8In                 : out std_logic;
    sDiagramSer3Mfp8Out                : in  std_logic;
    sDiagramSer3Mfp8Oe                 : in  std_logic;

    sDiagramCh0PocCurrent              : out std_logic_vector(19 downto 0);
    sDiagramCh0PocVoltage              : out std_logic_vector(19 downto 0);
    sDiagramCh0PocExtEn                : out std_logic;
    sDiagramCh0ExtPgood                : out std_logic;
    sDiagramCh1PocCurrent              : out std_logic_vector(19 downto 0);
    sDiagramCh1PocVoltage              : out std_logic_vector(19 downto 0);
    sDiagramCh1PocExtEn                : out std_logic;
    sDiagramCh1ExtPgood                : out std_logic;
    sDiagramCh2PocCurrent              : out std_logic_vector(19 downto 0);
    sDiagramCh2PocVoltage              : out std_logic_vector(19 downto 0);
    sDiagramCh2PocExtEn                : out std_logic;
    sDiagramCh2ExtPgood                : out std_logic;
    sDiagramCh3PocCurrent              : out std_logic_vector(19 downto 0);
    sDiagramCh3PocVoltage              : out std_logic_vector(19 downto 0);
    sDiagramCh3PocExtEn                : out std_logic;
    sDiagramCh3ExtPgood                : out std_logic;

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

    --Serdes Image Data
    VideoClk                           : out    std_logic;

    vSO0VideoAxiStreamTData64          : in    std_logic_vector(63 downto 0);
    vSO0VideoAxiStreamTUser64          : in    std_logic_vector(63 downto 0);
    vSO0VideoAxiStreamTLast            : in    std_logic;
    vSO0VideoAxiStreamTReady           : out   std_logic;
    vSO0VideoAxiStreamTValid           : in    std_logic;

    vSO1VideoAxiStreamTData64          : in    std_logic_vector(63 downto 0);
    vSO1VideoAxiStreamTUser64          : in    std_logic_vector(63 downto 0);
    vSO1VideoAxiStreamTLast            : in    std_logic;
    vSO1VideoAxiStreamTReady           : out   std_logic;
    vSO1VideoAxiStreamTValid           : in    std_logic;

    vSO2VideoAxiStreamTData64          : in    std_logic_vector(63 downto 0);
    vSO2VideoAxiStreamTUser64          : in    std_logic_vector(63 downto 0);
    vSO2VideoAxiStreamTLast            : in    std_logic;
    vSO2VideoAxiStreamTReady           : out   std_logic;
    vSO2VideoAxiStreamTValid           : in    std_logic;

    vSO3VideoAxiStreamTData64          : in    std_logic_vector(63 downto 0);
    vSO3VideoAxiStreamTUser64          : in    std_logic_vector(63 downto 0);
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

  component Mipi4TxTop64
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
      vTxChan2AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan4AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan6AxiStreamFlat      : in  AxiVideoStreamFlat_t;
      vTxChan0AxiStreamReady     : out std_logic;
      vTxChan2AxiStreamReady     : out std_logic;
      vTxChan4AxiStreamReady     : out std_logic;
      vTxChan6AxiStreamReady     : out std_logic;
      vTxChan0PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan2PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan4PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan6PacketsInFifoCount : out unsigned(13 downto 0);
      vTxChan0TransmitPacketRdy  : out std_logic;
      vTxChan2TransmitPacketRdy  : out std_logic;
      vTxChan4TransmitPacketRdy  : out std_logic;
      vTxChan6TransmitPacketRdy  : out std_logic;
      vTxChan0TransmitPacketDone : out std_logic;
      vTxChan2TransmitPacketDone : out std_logic;
      vTxChan4TransmitPacketDone : out std_logic;
      vTxChan6TransmitPacketDone : out std_logic;
      vTxChan0TransmitPacket     : in  std_logic;
      vTxChan2TransmitPacket     : in  std_logic;
      vTxChan4TransmitPacket     : in  std_logic;
      vTxChan6TransmitPacket     : in  std_logic;
      vTxChan0ClearTxFifo        : in  std_logic;
      vTxChan2ClearTxFifo        : in  std_logic;
      vTxChan4ClearTxFifo        : in  std_logic;
      vTxChan6ClearTxFifo        : in  std_logic;
      xTxChan0PinsFlat           : out MipiPinsFlat_t;
      xTxChan2PinsFlat           : out MipiPinsFlat_t;
      xTxChan4PinsFlat           : out MipiPinsFlat_t;
      xTxChan6PinsFlat           : out MipiPinsFlat_t);
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
  signal sDiagramCh1GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh1GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh1GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh2GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh2GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh2GpOut: std_logic_vector(7 downto 0);
  signal sDiagramCh3GpIn: std_logic_vector(7 downto 0);
  signal sDiagramCh3GpOe: std_logic_vector(7 downto 0);
  signal sDiagramCh3GpOut: std_logic_vector(7 downto 0);
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

    -- These signals are not connected. However they are generated from vhook_af in NI148xFixedLogicx
    -- and we are keeping them to prevent the vhook from breaking. These signals are not connected.
    --vhook_nowarn {sDiagramCh(4|5|6|7)I2c.*}
    --vhook_nowarn {sDiagramCh(4|5|6|7)Pwrdn}
    signal sDiagramCh4I2cSclIn: std_logic;
    signal sDiagramCh4I2cSclOe: std_logic := '0';
    signal sDiagramCh4I2cSdaIn: std_logic;
    signal sDiagramCh4I2cSdaOe: std_logic := '0';
    signal sDiagramCh5I2cSclIn: std_logic;
    signal sDiagramCh5I2cSclOe: std_logic := '0';
    signal sDiagramCh5I2cSdaIn: std_logic;
    signal sDiagramCh5I2cSdaOe: std_logic := '0';
    signal sDiagramCh6I2cSclIn: std_logic;
    signal sDiagramCh6I2cSclOe: std_logic := '0';
    signal sDiagramCh6I2cSdaIn: std_logic;
    signal sDiagramCh6I2cSdaOe: std_logic := '0';
    signal sDiagramCh7I2cSclIn: std_logic;
    signal sDiagramCh7I2cSclOe: std_logic := '0';
    signal sDiagramCh7I2cSdaIn: std_logic;
    signal sDiagramCh7I2cSdaOe: std_logic := '0';

    signal sDiagramCh4Pwrdn: std_logic;
    signal sDiagramCh5Pwrdn: std_logic;
    signal sDiagramCh6Pwrdn: std_logic;
    signal sDiagramCh7Pwrdn: std_logic;
    --vhook_nowarn {sDiagramCh(4|5|6|7)(Ext|Int)Pgood}
    --vhook_nowarn {sDiagramCh(4|5|6|7)Poc(Ext|Int)En}
    signal sDiagramCh4ExtPgood: std_logic;
    signal sDiagramCh4PocExtEn: std_logic;
    signal sDiagramCh5ExtPgood: std_logic;
    signal sDiagramCh5PocExtEn: std_logic;
    signal sDiagramCh6ExtPgood: std_logic;
    signal sDiagramCh6PocExtEn: std_logic;
    signal sDiagramCh7ExtPgood: std_logic;
    signal sDiagramCh7PocExtEn: std_logic;

  --0x7AE9  PXIe-1489 FlexRIO GMSL3 XCVR    (Manticore-M)
  --0x7AE8  PXIe-1489 FlexRIO GMSL3 Output  (Manticore-M)
  --0x7AE7  PXIe-1489 FlexRIO GMSL3 Input   (Manticore-M)
  constant kDeviceSignature : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#1093_7AE8#, 32));
  signal xIoOutputEnableLcl : std_logic;

  type InnerFamConfigDataMap_t is array (0 to 7) of integer;
  constant kInnerFamConfigDataMap : InnerFamConfigDataMap_t := (1, 4, 6, 9, 11, 15, 19, 23);

  type OuterFamConfigDataMap_t is array (0 to 7) of integer;
  constant kOuterFamConfigDataMap : OuterFamConfigDataMap_t := (0, 3, 5, 8, 10, 14, 18, 22);

  signal xSoChanPinsArray : MipiPinsAry_t(7 downto 0);
  signal xSoChanPinsFlatArray : MipiPinsFlatAry_t(7 downto 0);

  signal vSoChanAxiStreamArray : AxiVideoStreamAry_t(3 downto 0);

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
  aDiffGpio_p <= MapTxToGpio(aDiffGpio_p, True, xSoChanPinsArray, kNI148x02DphyPinMapSO);
  aDiffGpio_n <= MapTxToGpio(aDiffGpio_n, False, xSoChanPinsArray, kNI148x02DphyPinMapSO);

  VideoClk <= VideoClkLcl;

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
  --vhook_a PxieClk100                              PxieClk100
  --vhook_a InnerFamCfgReadClk                      aSeGpio(17)
  --vhook_a OuterFamCfgReadClk                      aSeGpio(20)
  --vhook_a woOuterFamConfigReset*                  open
  --vhook_a cCoreInterconnectReset_n                open
  --vhook_a vAxiInterconnectReset_n                 open
  --vhook_a fAxiInterconnectReset_n                 open
  --vhook_a sDiagramCh(4|5|6|7)GpIn                 open
  --vhook_a sDiagramCh(4|5|6|7)Gp(Out|Oe)           (others => '0')
  --vhook_a sDiagramCh(4|5|6|7)Poc(Voltage|Current) open
  --vhook_a stDeviceSignature                       kDeviceSignature
  --vhook_p VideoClk         VideoClkLcl
  --vhook_a CoreClk          VideoClkLcl
  --vhook_a sDiagramPocIntEn open
  --vhook_a sDiagramIntPgood open
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(0) {sDiagramCh0I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(1) {sDiagramCh1I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(2) {sDiagramCh2I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(3) {sDiagramCh3I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(4) {sDiagramCh4I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(5) {sDiagramCh5I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(6) {sDiagramCh6I2c$1$2} continue=true
  --vhook_af {sDiagramChI2c(Scl|Sda)(In|Oe)}(7) {sDiagramCh7I2c$1$2}
  --vhook_af {sDiagramPocExtEn}(0)              {sDiagramCh0PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(1)              {sDiagramCh1PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(2)              {sDiagramCh2PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(3)              {sDiagramCh3PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(4)              {sDiagramCh4PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(5)              {sDiagramCh5PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(6)              {sDiagramCh6PocExtEn} continue=true
  --vhook_af {sDiagramPocExtEn}(7)              {sDiagramCh7PocExtEn}
  --vhook_af {sDiagramExtPgood}(0)              {sDiagramCh0ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(1)              {sDiagramCh1ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(2)              {sDiagramCh2ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(3)              {sDiagramCh3ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(4)              {sDiagramCh4ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(5)              {sDiagramCh5ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(6)              {sDiagramCh6ExtPgood} continue=true
  --vhook_af {sDiagramExtPgood}(7)              {sDiagramCh7ExtPgood}
  --vhook_af {sDiagramChanPwrdn}(0)             {sDiagramCh0Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(1)             {sDiagramCh1Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(2)             {sDiagramCh2Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(3)             {sDiagramCh3Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(4)             {sDiagramCh4Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(5)             {sDiagramCh5Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(6)             {sDiagramCh6Pwrdn} continue=true
  --vhook_af {sDiagramChanPwrdn}(7)             {sDiagramCh7Pwrdn}
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
      fAxiInterconnectReset_n         => open,                             --out std_logic
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
      sDiagramCh4GpIn                 => open,                             --out std_logic_vector(7:0)
      sDiagramCh4GpOut                => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh4GpOe                 => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh5GpIn                 => open,                             --out std_logic_vector(7:0)
      sDiagramCh5GpOut                => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh5GpOe                 => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh6GpIn                 => open,                             --out std_logic_vector(7:0)
      sDiagramCh6GpOut                => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh6GpOe                 => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh7GpIn                 => open,                             --out std_logic_vector(7:0)
      sDiagramCh7GpOut                => (others => '0'),                  --in  std_logic_vector(7:0)
      sDiagramCh7GpOe                 => (others => '0'),                  --in  std_logic_vector(7:0)
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
      sDiagramCh0PocVoltage           => sDiagramCh0PocVoltage,            --out std_logic_vector(19:0)
      sDiagramCh0PocCurrent           => sDiagramCh0PocCurrent,            --out std_logic_vector(19:0)
      sDiagramCh1PocVoltage           => sDiagramCh1PocVoltage,            --out std_logic_vector(19:0)
      sDiagramCh1PocCurrent           => sDiagramCh1PocCurrent,            --out std_logic_vector(19:0)
      sDiagramCh2PocVoltage           => sDiagramCh2PocVoltage,            --out std_logic_vector(19:0)
      sDiagramCh2PocCurrent           => sDiagramCh2PocCurrent,            --out std_logic_vector(19:0)
      sDiagramCh3PocVoltage           => sDiagramCh3PocVoltage,            --out std_logic_vector(19:0)
      sDiagramCh3PocCurrent           => sDiagramCh3PocCurrent,            --out std_logic_vector(19:0)
      sDiagramCh4PocVoltage           => open,                             --out std_logic_vector(19:0)
      sDiagramCh4PocCurrent           => open,                             --out std_logic_vector(19:0)
      sDiagramCh5PocVoltage           => open,                             --out std_logic_vector(19:0)
      sDiagramCh5PocCurrent           => open,                             --out std_logic_vector(19:0)
      sDiagramCh6PocVoltage           => open,                             --out std_logic_vector(19:0)
      sDiagramCh6PocCurrent           => open,                             --out std_logic_vector(19:0)
      sDiagramCh7PocVoltage           => open,                             --out std_logic_vector(19:0)
      sDiagramCh7PocCurrent           => open,                             --out std_logic_vector(19:0)
      sDiagramPocIntEn                => open,                             --out std_logic_vector(7:0)
      sDiagramPocExtEn(0)             => sDiagramCh0PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(1)             => sDiagramCh1PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(2)             => sDiagramCh2PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(3)             => sDiagramCh3PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(4)             => sDiagramCh4PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(5)             => sDiagramCh5PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(6)             => sDiagramCh6PocExtEn,              --out std_logic_vector(7:0)
      sDiagramPocExtEn(7)             => sDiagramCh7PocExtEn,              --out std_logic_vector(7:0)
      sDiagramIntPgood                => open,                             --out std_logic_vector(7:0)
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

  --vhook   Mipi4TxTop64            Mipi4TxTopx
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
  --vhook_# TxCh0:SO0, TxCh1:SO4, TxCh2:SO1, TxCh3:SO5, TxCh4:SO2, TxCh5:SO6, TxCh6:SO3, TxCh7:SO7
  --vhook_p {xTxChan0(.*)}           {xSoChanPinsFlatArray(0)}
  --vhook_p {vTxChan0(.*)Flat}       {Flatten(vSoChan$1Array(0))}
  --vhook_p {vTxChan0(.*)Ready}      {vSO0Video$1TReady}
  --vhook_p {vTxChan0(.*)Packet(.*)} {vSO0$1Packet$2} type=std_logic
  --vhook_p {vTxChan0(.*)Packet(.*)} {vSO0$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan0(.*)(.*)}       {vSO0$1$2} type=std_logic
  --vhook_#
  --vhook_p {xTxChan2(.*)}           {xSoChanPinsFlatArray(1)}
  --vhook_p {vTxChan2(.*)Flat}       {Flatten(vSoChan$1Array(1))}
  --vhook_p {vTxChan2(.*)Ready}      {vSO1Video$1TReady}
  --vhook_p {vTxChan2(.*)Packet(.*)} {vSO1$1Packet$2} type=std_logic
  --vhook_p {vTxChan2(.*)Packet(.*)} {vSO1$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan2(.*)(.*)}       {vSO1$1$2} type=std_logic
  --vhook_#
  --vhook_p {xTxChan4(.*)}           {xSoChanPinsFlatArray(2)}
  --vhook_p {vTxChan4(.*)Flat}       {Flatten(vSoChan$1Array(2))}
  --vhook_p {vTxChan4(.*)Ready}      {vSO2Video$1TReady}
  --vhook_p {vTxChan4(.*)Packet(.*)} {vSO2$1Packet$2} type=std_logic
  --vhook_p {vTxChan4(.*)Packet(.*)} {vSO2$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan4(.*)(.*)}       {vSO2$1$2} type=std_logic
  --vhook_#
  --vhook_p {xTxChan6(.*)}           {xSoChanPinsFlatArray(3)}
  --vhook_p {vTxChan6(.*)Flat}       {Flatten(vSoChan$1Array(3))}
  --vhook_p {vTxChan6(.*)Ready}      {vSO3Video$1TReady}
  --vhook_p {vTxChan6(.*)Packet(.*)} {vSO3$1Packet$2} type=std_logic
  --vhook_p {vTxChan6(.*)Packet(.*)} {vSO3$1Packet$2Uns} type=unsigned
  --vhook_p {vTxChan6(.*)(.*)}       {vSO3$1$2} type=std_logic
  Mipi4TxTopx: Mipi4TxTop64
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
      vTxChan2AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(1)),  --in  AxiVideoStreamFlat_t
      vTxChan4AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(2)),  --in  AxiVideoStreamFlat_t
      vTxChan6AxiStreamFlat      => Flatten(vSoChanAxiStreamArray(3)),  --in  AxiVideoStreamFlat_t
      vTxChan0AxiStreamReady     => vSO0VideoAxiStreamTReady,           --out std_logic
      vTxChan2AxiStreamReady     => vSO1VideoAxiStreamTReady,           --out std_logic
      vTxChan4AxiStreamReady     => vSO2VideoAxiStreamTReady,           --out std_logic
      vTxChan6AxiStreamReady     => vSO3VideoAxiStreamTReady,           --out std_logic
      vTxChan0PacketsInFifoCount => vSO0PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan2PacketsInFifoCount => vSO1PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan4PacketsInFifoCount => vSO2PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan6PacketsInFifoCount => vSO3PacketsInFifoCountUns,          --out unsigned(13:0)
      vTxChan0TransmitPacketRdy  => vSO0TransmitPacketRdy,              --out std_logic
      vTxChan2TransmitPacketRdy  => vSO1TransmitPacketRdy,              --out std_logic
      vTxChan4TransmitPacketRdy  => vSO2TransmitPacketRdy,              --out std_logic
      vTxChan6TransmitPacketRdy  => vSO3TransmitPacketRdy,              --out std_logic
      vTxChan0TransmitPacketDone => vSO0TransmitPacketDone,             --out std_logic
      vTxChan2TransmitPacketDone => vSO1TransmitPacketDone,             --out std_logic
      vTxChan4TransmitPacketDone => vSO2TransmitPacketDone,             --out std_logic
      vTxChan6TransmitPacketDone => vSO3TransmitPacketDone,             --out std_logic
      vTxChan0TransmitPacket     => vSO0TransmitPacket,                 --in  std_logic
      vTxChan2TransmitPacket     => vSO1TransmitPacket,                 --in  std_logic
      vTxChan4TransmitPacket     => vSO2TransmitPacket,                 --in  std_logic
      vTxChan6TransmitPacket     => vSO3TransmitPacket,                 --in  std_logic
      vTxChan0ClearTxFifo        => vSO0ClearTxFifo,                    --in  std_logic
      vTxChan2ClearTxFifo        => vSO1ClearTxFifo,                    --in  std_logic
      vTxChan4ClearTxFifo        => vSO2ClearTxFifo,                    --in  std_logic
      vTxChan6ClearTxFifo        => vSO3ClearTxFifo,                    --in  std_logic
      xTxChan0PinsFlat           => xSoChanPinsFlatArray(0),            --out MipiPinsFlat_t
      xTxChan2PinsFlat           => xSoChanPinsFlatArray(1),            --out MipiPinsFlat_t
      xTxChan4PinsFlat           => xSoChanPinsFlatArray(2),            --out MipiPinsFlat_t
      xTxChan6PinsFlat           => xSoChanPinsFlatArray(3));           --out MipiPinsFlat_t

  --
  -- LVFPGA to Axi Stream
  vSoChanAxiStreamArray(0).TDataUpperDWord    <= vSO0VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(0).TRawDataUpperDWord <= vSO0VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(0).TStrbUpperDWord    <= "1111";
  vSoChanAxiStreamArray(0).TKeepUpperDWord    <= "1111";
  vSoChanAxiStreamArray(0).TData              <= vSO0VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(0).TRawData           <= vSO0VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(0).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(0).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(0).TID                <= std_logic_vector(To_Unsigned(0, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(0).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(0).TUser              <= vSO0VideoAxiStreamTUser64;
  vSoChanAxiStreamArray(0).TValid             <= vSO0VideoAxiStreamTValid;
  vSoChanAxiStreamArray(0).TLast              <= vSO0VideoAxiStreamTLast;

  vSoChanAxiStreamArray(1).TDataUpperDWord    <= vSO1VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(1).TRawDataUpperDWord <= vSO1VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(1).TStrbUpperDWord    <= "1111";
  vSoChanAxiStreamArray(1).TKeepUpperDWord    <= "1111";
  vSoChanAxiStreamArray(1).TData              <= vSO1VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(1).TRawData           <= vSO1VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(1).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(1).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(1).TID                <= std_logic_vector(To_Unsigned(1, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(1).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(1).TUser              <= vSO1VideoAxiStreamTUser64;
  vSoChanAxiStreamArray(1).TValid             <= vSO1VideoAxiStreamTValid;
  vSoChanAxiStreamArray(1).TLast              <= vSO1VideoAxiStreamTLast;

  vSoChanAxiStreamArray(2).TDataUpperDWord    <= vSO2VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(2).TRawDataUpperDWord <= vSO2VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(2).TStrbUpperDWord    <= "1111";
  vSoChanAxiStreamArray(2).TKeepUpperDWord    <= "1111";
  vSoChanAxiStreamArray(2).TData              <= vSO2VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(2).TRawData           <= vSO2VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(2).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(2).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(2).TID                <= std_logic_vector(To_Unsigned(2, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(2).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(2).TUser              <= vSO2VideoAxiStreamTUser64;
  vSoChanAxiStreamArray(2).TValid             <= vSO2VideoAxiStreamTValid;
  vSoChanAxiStreamArray(2).TLast              <= vSO2VideoAxiStreamTLast;

  vSoChanAxiStreamArray(3).TDataUpperDWord    <= vSO3VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(3).TRawDataUpperDWord <= vSO3VideoAxiStreamTData64(63 downto 32);
  vSoChanAxiStreamArray(3).TStrbUpperDWord    <= "1111";
  vSoChanAxiStreamArray(3).TKeepUpperDWord    <= "1111";
  vSoChanAxiStreamArray(3).TData              <= vSO3VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(3).TRawData           <= vSO3VideoAxiStreamTData64(31 downto 0);
  vSoChanAxiStreamArray(3).TStrb              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(3).TKeep              <= "1111"; -- all bytes are good at this level
  vSoChanAxiStreamArray(3).TID                <= std_logic_vector(To_Unsigned(3, 4)); -- just setting this to the channel right now.
  vSoChanAxiStreamArray(3).TDest              <= "0000"; -- only one destination
  vSoChanAxiStreamArray(3).TUser              <= vSO3VideoAxiStreamTUser64;
  vSoChanAxiStreamArray(3).TValid             <= vSO3VideoAxiStreamTValid;
  vSoChanAxiStreamArray(3).TLast              <= vSO3VideoAxiStreamTLast;

  vSO0PacketsInFifoCount <= std_logic_vector(vSO0PacketsInFifoCountUns);
  vSO1PacketsInFifoCount <= std_logic_vector(vSO1PacketsInFifoCountUns);
  vSO2PacketsInFifoCount <= std_logic_vector(vSO2PacketsInFifoCountUns);
  vSO3PacketsInFifoCount <= std_logic_vector(vSO3PacketsInFifoCountUns);

  --vhook_e NormalizeSerdesGpio
  NormalizeSerdesGpiox: entity work.NormalizeSerdesGpio (rtl)
    port map (
      sDiagramCh0GpIn     => sDiagramCh0GpIn,      --in  std_logic_vector(7:0)
      sDiagramCh0GpOut    => sDiagramCh0GpOut,     --out std_logic_vector(7:0)
      sDiagramCh0GpOe     => sDiagramCh0GpOe,      --out std_logic_vector(7:0)
      sDiagramCh1GpIn     => sDiagramCh1GpIn,      --in  std_logic_vector(7:0)
      sDiagramCh1GpOut    => sDiagramCh1GpOut,     --out std_logic_vector(7:0)
      sDiagramCh1GpOe     => sDiagramCh1GpOe,      --out std_logic_vector(7:0)
      sDiagramCh2GpIn     => sDiagramCh2GpIn,      --in  std_logic_vector(7:0)
      sDiagramCh2GpOut    => sDiagramCh2GpOut,     --out std_logic_vector(7:0)
      sDiagramCh2GpOe     => sDiagramCh2GpOe,      --out std_logic_vector(7:0)
      sDiagramCh3GpIn     => sDiagramCh3GpIn,      --in  std_logic_vector(7:0)
      sDiagramCh3GpOut    => sDiagramCh3GpOut,     --out std_logic_vector(7:0)
      sDiagramCh3GpOe     => sDiagramCh3GpOe,      --out std_logic_vector(7:0)
      sDiagramMiscGpIn    => sDiagramMiscGpIn,     --in  std_logic_vector(15:0)
      sDiagramMiscGpOut   => sDiagramMiscGpOut,    --out std_logic_vector(15:0)
      sDiagramMiscGpOe    => sDiagramMiscGpOe,     --out std_logic_vector(15:0)
      sDiagramSer0Mfp0In  => sDiagramSer0Mfp0In,   --out std_logic
      sDiagramSer0Mfp0Out => sDiagramSer0Mfp0Out,  --in  std_logic
      sDiagramSer0Mfp0Oe  => sDiagramSer0Mfp0Oe,   --in  std_logic
      sDiagramSer0Mfp1In  => sDiagramSer0Mfp1In,   --out std_logic
      sDiagramSer0Mfp2In  => sDiagramSer0Mfp2In,   --out std_logic
      sDiagramSer0Mfp3In  => sDiagramSer0Mfp3In,   --out std_logic
      sDiagramSer0Mfp3Out => sDiagramSer0Mfp3Out,  --in  std_logic
      sDiagramSer0Mfp3Oe  => sDiagramSer0Mfp3Oe,   --in  std_logic
      sDiagramSer0Mfp4In  => sDiagramSer0Mfp4In,   --out std_logic
      sDiagramSer0Mfp4Out => sDiagramSer0Mfp4Out,  --in  std_logic
      sDiagramSer0Mfp4Oe  => sDiagramSer0Mfp4Oe,   --in  std_logic
      sDiagramSer0Mfp6In  => sDiagramSer0Mfp6In,   --out std_logic
      sDiagramSer0Mfp6Out => sDiagramSer0Mfp6Out,  --in  std_logic
      sDiagramSer0Mfp6Oe  => sDiagramSer0Mfp6Oe,   --in  std_logic
      sDiagramSer0Mfp7In  => sDiagramSer0Mfp7In,   --out std_logic
      sDiagramSer0Mfp7Out => sDiagramSer0Mfp7Out,  --in  std_logic
      sDiagramSer0Mfp7Oe  => sDiagramSer0Mfp7Oe,   --in  std_logic
      sDiagramSer0Mfp8In  => sDiagramSer0Mfp8In,   --out std_logic
      sDiagramSer0Mfp8Out => sDiagramSer0Mfp8Out,  --in  std_logic
      sDiagramSer0Mfp8Oe  => sDiagramSer0Mfp8Oe,   --in  std_logic
      sDiagramSer1Mfp0In  => sDiagramSer1Mfp0In,   --out std_logic
      sDiagramSer1Mfp0Out => sDiagramSer1Mfp0Out,  --in  std_logic
      sDiagramSer1Mfp0Oe  => sDiagramSer1Mfp0Oe,   --in  std_logic
      sDiagramSer1Mfp1In  => sDiagramSer1Mfp1In,   --out std_logic
      sDiagramSer1Mfp2In  => sDiagramSer1Mfp2In,   --out std_logic
      sDiagramSer1Mfp3In  => sDiagramSer1Mfp3In,   --out std_logic
      sDiagramSer1Mfp3Out => sDiagramSer1Mfp3Out,  --in  std_logic
      sDiagramSer1Mfp3Oe  => sDiagramSer1Mfp3Oe,   --in  std_logic
      sDiagramSer1Mfp4In  => sDiagramSer1Mfp4In,   --out std_logic
      sDiagramSer1Mfp4Out => sDiagramSer1Mfp4Out,  --in  std_logic
      sDiagramSer1Mfp4Oe  => sDiagramSer1Mfp4Oe,   --in  std_logic
      sDiagramSer1Mfp6In  => sDiagramSer1Mfp6In,   --out std_logic
      sDiagramSer1Mfp6Out => sDiagramSer1Mfp6Out,  --in  std_logic
      sDiagramSer1Mfp6Oe  => sDiagramSer1Mfp6Oe,   --in  std_logic
      sDiagramSer1Mfp7In  => sDiagramSer1Mfp7In,   --out std_logic
      sDiagramSer1Mfp7Out => sDiagramSer1Mfp7Out,  --in  std_logic
      sDiagramSer1Mfp7Oe  => sDiagramSer1Mfp7Oe,   --in  std_logic
      sDiagramSer1Mfp8In  => sDiagramSer1Mfp8In,   --out std_logic
      sDiagramSer1Mfp8Out => sDiagramSer1Mfp8Out,  --in  std_logic
      sDiagramSer1Mfp8Oe  => sDiagramSer1Mfp8Oe,   --in  std_logic
      sDiagramSer2Mfp0In  => sDiagramSer2Mfp0In,   --out std_logic
      sDiagramSer2Mfp0Out => sDiagramSer2Mfp0Out,  --in  std_logic
      sDiagramSer2Mfp0Oe  => sDiagramSer2Mfp0Oe,   --in  std_logic
      sDiagramSer2Mfp1In  => sDiagramSer2Mfp1In,   --out std_logic
      sDiagramSer2Mfp2In  => sDiagramSer2Mfp2In,   --out std_logic
      sDiagramSer2Mfp3In  => sDiagramSer2Mfp3In,   --out std_logic
      sDiagramSer2Mfp3Out => sDiagramSer2Mfp3Out,  --in  std_logic
      sDiagramSer2Mfp3Oe  => sDiagramSer2Mfp3Oe,   --in  std_logic
      sDiagramSer2Mfp4In  => sDiagramSer2Mfp4In,   --out std_logic
      sDiagramSer2Mfp4Out => sDiagramSer2Mfp4Out,  --in  std_logic
      sDiagramSer2Mfp4Oe  => sDiagramSer2Mfp4Oe,   --in  std_logic
      sDiagramSer2Mfp6In  => sDiagramSer2Mfp6In,   --out std_logic
      sDiagramSer2Mfp6Out => sDiagramSer2Mfp6Out,  --in  std_logic
      sDiagramSer2Mfp6Oe  => sDiagramSer2Mfp6Oe,   --in  std_logic
      sDiagramSer2Mfp7In  => sDiagramSer2Mfp7In,   --out std_logic
      sDiagramSer2Mfp7Out => sDiagramSer2Mfp7Out,  --in  std_logic
      sDiagramSer2Mfp7Oe  => sDiagramSer2Mfp7Oe,   --in  std_logic
      sDiagramSer2Mfp8In  => sDiagramSer2Mfp8In,   --out std_logic
      sDiagramSer2Mfp8Out => sDiagramSer2Mfp8Out,  --in  std_logic
      sDiagramSer2Mfp8Oe  => sDiagramSer2Mfp8Oe,   --in  std_logic
      sDiagramSer3Mfp0In  => sDiagramSer3Mfp0In,   --out std_logic
      sDiagramSer3Mfp0Out => sDiagramSer3Mfp0Out,  --in  std_logic
      sDiagramSer3Mfp0Oe  => sDiagramSer3Mfp0Oe,   --in  std_logic
      sDiagramSer3Mfp1In  => sDiagramSer3Mfp1In,   --out std_logic
      sDiagramSer3Mfp2In  => sDiagramSer3Mfp2In,   --out std_logic
      sDiagramSer3Mfp3In  => sDiagramSer3Mfp3In,   --out std_logic
      sDiagramSer3Mfp3Out => sDiagramSer3Mfp3Out,  --in  std_logic
      sDiagramSer3Mfp3Oe  => sDiagramSer3Mfp3Oe,   --in  std_logic
      sDiagramSer3Mfp4In  => sDiagramSer3Mfp4In,   --out std_logic
      sDiagramSer3Mfp4Out => sDiagramSer3Mfp4Out,  --in  std_logic
      sDiagramSer3Mfp4Oe  => sDiagramSer3Mfp4Oe,   --in  std_logic
      sDiagramSer3Mfp6In  => sDiagramSer3Mfp6In,   --out std_logic
      sDiagramSer3Mfp6Out => sDiagramSer3Mfp6Out,  --in  std_logic
      sDiagramSer3Mfp6Oe  => sDiagramSer3Mfp6Oe,   --in  std_logic
      sDiagramSer3Mfp7In  => sDiagramSer3Mfp7In,   --out std_logic
      sDiagramSer3Mfp7Out => sDiagramSer3Mfp7Out,  --in  std_logic
      sDiagramSer3Mfp7Oe  => sDiagramSer3Mfp7Oe,   --in  std_logic
      sDiagramSer3Mfp8In  => sDiagramSer3Mfp8In,   --out std_logic
      sDiagramSer3Mfp8Out => sDiagramSer3Mfp8Out,  --in  std_logic
      sDiagramSer3Mfp8Oe  => sDiagramSer3Mfp8Oe);  --in  std_logic
end rtl;
