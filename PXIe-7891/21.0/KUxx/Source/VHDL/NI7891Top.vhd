-------------------------------------------------------------------------------
--
-- File: NI7891Top.vhd
-- Author: Minghui Zhang / Ming Zhi Lim
-- Original Project: HIL
-- Date: 21 May 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   NI7891 Socket Clip Top Level Module
--
-- vreview_reviewers kyiew milim mizhang
-- vreview_group HIL_NI7891Top
-- vreview_closed https://review-board.natinst.com/r/362799/
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;

library unisim;
  use unisim.vcomponents.all;

entity NI7891Top is
  port (
    ---------------------------------------------------------------------------
    --                     Base Board Interface                              --
    ---------------------------------------------------------------------------
    -------------------------------
    -- Base Configure Reset      --
    -------------------------------
    aBaseConfigReset                : out std_logic;
    -------------------------------
    -- Base I2C                  --
    -------------------------------
    aBaseI2cSclIn                   : in  std_logic;
    aBaseI2cSclOut                  : out std_logic;
    aBaseI2cSclTri                  : out std_logic;
    aBaseI2cSdaIn                   : in  std_logic;
    aBaseI2cSdaOut                  : out std_logic;
    aBaseI2cSdaTri                  : out std_logic;
    -------------------------------
    -- Base DIO                  --
    -------------------------------
    aBaseDioIn                      : in  std_logic_vector(31 downto 0);
    aBaseDioOut                     : out std_logic_vector(31 downto 0);
    aBaseDioOutEn                   : out std_logic_vector(31 downto 0);
    aBaseExClk                      : in  std_logic;
    ---------------------------------------------------------------------------
    --                     FlexRIOIoSocketType3_v1                           --
    ---------------------------------------------------------------------------
    ------------
    -- FAM IO --
    ------------
    aDiffGpio_p                     : inout std_logic_vector(69 downto 0);
    aDiffGpio_n                     : inout std_logic_vector(69 downto 0);
    aSeGpio                         : inout std_logic_vector(29 downto 0);
    -------------
    -- Support --
    -------------
    stIoModuleSupportsFRAGLs        : out std_logic;

    xIoPresent                      : in std_logic;
    xIoReady                        : in std_logic;
    xIoOutputEnable                 : in std_logic;

    aReservedToClip                 : in  std_logic_vector(15 downto 0);
    aReservedFromClip               : out std_logic_vector(15 downto 0);
    --vhook_nowarn aReservedToClip
    -------------------------------
    -- FAM Synchronization Plane --
    -------------------------------
    DeviceClk                       : in  std_logic;
    SampleClk                       : in  std_logic;

    dtTdcAssert                     : in  std_logic;
    dvTdcAssert                     : out std_logic;
    dtDevClkEn                      : out std_logic;
    ----------------------------------
    -- AXI Communication Interfaces --
    ----------------------------------
    AxiClk                          : in  std_logic;

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
    xClipAxi4LiteInterrupt          : in  std_logic;
    ---------------------------------------------------------------------------
    --                     Fabric Interface                                  --
    ---------------------------------------------------------------------------
    aDiagramResetSL                 : in  std_logic;
    aDiagramClkEnable               : in  std_logic;
    ---------------------------------------------------------------------------
    --                     LabVIEW Interface                                 --
    ---------------------------------------------------------------------------
    -------------------------
    -- Diagram Data Clocks --
    -------------------------
    -- Request PxieClk100 as socket clip's main clock
    PxieClk100                      : in  std_logic;
    -- Clk100ToLv for DAC, ADC
    Clk100ToLv                      : out std_logic;
    -- DIO External Clock
    aBaseExClkToLv                  : out std_logic;
    aFam2ExClkToLv                  : out std_logic;

    -------------------------
    -- Status to Diagram   --
    -------------------------
    xIoModuleReady                  : out std_logic;
    xIoModuleErrorCode              : out std_logic_vector(31 downto 0);

    -------------------------
    -- Base DIO            --
    -------------------------
    aBaseDioInCh00                  : out std_logic;
    aBaseDioInCh01                  : out std_logic;
    aBaseDioInCh02                  : out std_logic;
    aBaseDioInCh03                  : out std_logic;
    aBaseDioInCh04                  : out std_logic;
    aBaseDioInCh05                  : out std_logic;
    aBaseDioInCh06                  : out std_logic;
    aBaseDioInCh07                  : out std_logic;
    aBaseDioInCh08                  : out std_logic;
    aBaseDioInCh09                  : out std_logic;
    aBaseDioInCh10                  : out std_logic;
    aBaseDioInCh11                  : out std_logic;
    aBaseDioInCh12                  : out std_logic;
    aBaseDioInCh13                  : out std_logic;
    aBaseDioInCh14                  : out std_logic;
    aBaseDioInCh15                  : out std_logic;
    aBaseDioInCh16                  : out std_logic;
    aBaseDioInCh17                  : out std_logic;
    aBaseDioInCh18                  : out std_logic;
    aBaseDioInCh19                  : out std_logic;
    aBaseDioInCh20                  : out std_logic;
    aBaseDioInCh21                  : out std_logic;
    aBaseDioInCh22                  : out std_logic;
    aBaseDioInCh23                  : out std_logic;
    aBaseDioInCh24                  : out std_logic;
    aBaseDioInCh25                  : out std_logic;
    aBaseDioInCh26                  : out std_logic;
    aBaseDioInCh27                  : out std_logic;
    aBaseDioInCh28                  : out std_logic;
    aBaseDioInCh29                  : out std_logic;
    aBaseDioInCh30                  : out std_logic;
    aBaseDioInCh31                  : out std_logic;
    aBaseDioOutCh00                 : in  std_logic;
    aBaseDioOutCh01                 : in  std_logic;
    aBaseDioOutCh02                 : in  std_logic;
    aBaseDioOutCh03                 : in  std_logic;
    aBaseDioOutCh04                 : in  std_logic;
    aBaseDioOutCh05                 : in  std_logic;
    aBaseDioOutCh06                 : in  std_logic;
    aBaseDioOutCh07                 : in  std_logic;
    aBaseDioOutCh08                 : in  std_logic;
    aBaseDioOutCh09                 : in  std_logic;
    aBaseDioOutCh10                 : in  std_logic;
    aBaseDioOutCh11                 : in  std_logic;
    aBaseDioOutCh12                 : in  std_logic;
    aBaseDioOutCh13                 : in  std_logic;
    aBaseDioOutCh14                 : in  std_logic;
    aBaseDioOutCh15                 : in  std_logic;
    aBaseDioOutCh16                 : in  std_logic;
    aBaseDioOutCh17                 : in  std_logic;
    aBaseDioOutCh18                 : in  std_logic;
    aBaseDioOutCh19                 : in  std_logic;
    aBaseDioOutCh20                 : in  std_logic;
    aBaseDioOutCh21                 : in  std_logic;
    aBaseDioOutCh22                 : in  std_logic;
    aBaseDioOutCh23                 : in  std_logic;
    aBaseDioOutCh24                 : in  std_logic;
    aBaseDioOutCh25                 : in  std_logic;
    aBaseDioOutCh26                 : in  std_logic;
    aBaseDioOutCh27                 : in  std_logic;
    aBaseDioOutCh28                 : in  std_logic;
    aBaseDioOutCh29                 : in  std_logic;
    aBaseDioOutCh30                 : in  std_logic;
    aBaseDioOutCh31                 : in  std_logic;

    -------------------------
    -- Fam1 SlowAdc      --
    -------------------------
    sFam1SlowAdcFxpReady            : out std_logic;
    sFam1SlowAdcFxpStart            : in  std_logic;
    sFam1SlowAdcFxpValid            : out std_logic;
    sFam1SlowAdcFxpDataCh00         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh01         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh02         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh03         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh04         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh05         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh06         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh07         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh08         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh09         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh10         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh11         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh12         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh13         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh14         : out std_logic_vector(27 downto 0);
    sFam1SlowAdcFxpDataCh15         : out std_logic_vector(27 downto 0);

    sFam1SlowAdcRawReady            : out std_logic;
    sFam1SlowAdcRawStart            : in  std_logic;
    sFam1SlowAdcRawValid            : out std_logic;
    sFam1SlowAdcRawDataCh00         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh01         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh02         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh03         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh04         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh05         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh06         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh07         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh08         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh09         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh10         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh11         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh12         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh13         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh14         : out std_logic_vector(15 downto 0);
    sFam1SlowAdcRawDataCh15         : out std_logic_vector(15 downto 0);

    -------------------------
    -- Fam1 SlowDac      --
    -------------------------
    sFam1SlowDacFxpReady            : out std_logic;
    sFam1SlowDacFxpStart            : in  std_logic;
    sFam1SlowDacFxpValidCh00        : in  std_logic;
    sFam1SlowDacFxpValidCh01        : in  std_logic;
    sFam1SlowDacFxpValidCh02        : in  std_logic;
    sFam1SlowDacFxpValidCh03        : in  std_logic;
    sFam1SlowDacFxpValidCh04        : in  std_logic;
    sFam1SlowDacFxpValidCh05        : in  std_logic;
    sFam1SlowDacFxpValidCh06        : in  std_logic;
    sFam1SlowDacFxpValidCh07        : in  std_logic;
    sFam1SlowDacFxpValidCh08        : in  std_logic;
    sFam1SlowDacFxpValidCh09        : in  std_logic;
    sFam1SlowDacFxpValidCh10        : in  std_logic;
    sFam1SlowDacFxpValidCh11        : in  std_logic;
    sFam1SlowDacFxpValidCh12        : in  std_logic;
    sFam1SlowDacFxpValidCh13        : in  std_logic;
    sFam1SlowDacFxpValidCh14        : in  std_logic;
    sFam1SlowDacFxpValidCh15        : in  std_logic;
    sFam1SlowDacFxpValidCh16        : in  std_logic;
    sFam1SlowDacFxpValidCh17        : in  std_logic;
    sFam1SlowDacFxpValidCh18        : in  std_logic;
    sFam1SlowDacFxpValidCh19        : in  std_logic;
    sFam1SlowDacFxpValidCh20        : in  std_logic;
    sFam1SlowDacFxpValidCh21        : in  std_logic;
    sFam1SlowDacFxpValidCh22        : in  std_logic;
    sFam1SlowDacFxpValidCh23        : in  std_logic;
    sFam1SlowDacFxpValidCh24        : in  std_logic;
    sFam1SlowDacFxpValidCh25        : in  std_logic;
    sFam1SlowDacFxpValidCh26        : in  std_logic;
    sFam1SlowDacFxpValidCh27        : in  std_logic;
    sFam1SlowDacFxpValidCh28        : in  std_logic;
    sFam1SlowDacFxpValidCh29        : in  std_logic;
    sFam1SlowDacFxpValidCh30        : in  std_logic;
    sFam1SlowDacFxpValidCh31        : in  std_logic;
    sFam1SlowDacFxpDataCh00         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh01         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh02         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh03         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh04         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh05         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh06         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh07         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh08         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh09         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh10         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh11         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh12         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh13         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh14         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh15         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh16         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh17         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh18         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh19         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh20         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh21         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh22         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh23         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh24         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh25         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh26         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh27         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh28         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh29         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh30         : in  std_logic_vector(19 downto 0);
    sFam1SlowDacFxpDataCh31         : in  std_logic_vector(19 downto 0);

    sFam1SlowDacRawReady            : out std_logic;
    sFam1SlowDacRawStart            : in  std_logic;
    sFam1SlowDacRawValidCh00        : in  std_logic;
    sFam1SlowDacRawValidCh01        : in  std_logic;
    sFam1SlowDacRawValidCh02        : in  std_logic;
    sFam1SlowDacRawValidCh03        : in  std_logic;
    sFam1SlowDacRawValidCh04        : in  std_logic;
    sFam1SlowDacRawValidCh05        : in  std_logic;
    sFam1SlowDacRawValidCh06        : in  std_logic;
    sFam1SlowDacRawValidCh07        : in  std_logic;
    sFam1SlowDacRawValidCh08        : in  std_logic;
    sFam1SlowDacRawValidCh09        : in  std_logic;
    sFam1SlowDacRawValidCh10        : in  std_logic;
    sFam1SlowDacRawValidCh11        : in  std_logic;
    sFam1SlowDacRawValidCh12        : in  std_logic;
    sFam1SlowDacRawValidCh13        : in  std_logic;
    sFam1SlowDacRawValidCh14        : in  std_logic;
    sFam1SlowDacRawValidCh15        : in  std_logic;
    sFam1SlowDacRawValidCh16        : in  std_logic;
    sFam1SlowDacRawValidCh17        : in  std_logic;
    sFam1SlowDacRawValidCh18        : in  std_logic;
    sFam1SlowDacRawValidCh19        : in  std_logic;
    sFam1SlowDacRawValidCh20        : in  std_logic;
    sFam1SlowDacRawValidCh21        : in  std_logic;
    sFam1SlowDacRawValidCh22        : in  std_logic;
    sFam1SlowDacRawValidCh23        : in  std_logic;
    sFam1SlowDacRawValidCh24        : in  std_logic;
    sFam1SlowDacRawValidCh25        : in  std_logic;
    sFam1SlowDacRawValidCh26        : in  std_logic;
    sFam1SlowDacRawValidCh27        : in  std_logic;
    sFam1SlowDacRawValidCh28        : in  std_logic;
    sFam1SlowDacRawValidCh29        : in  std_logic;
    sFam1SlowDacRawValidCh30        : in  std_logic;
    sFam1SlowDacRawValidCh31        : in  std_logic;
    sFam1SlowDacRawDataCh00         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh01         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh02         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh03         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh04         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh05         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh06         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh07         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh08         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh09         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh10         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh11         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh12         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh13         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh14         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh15         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh16         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh17         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh18         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh19         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh20         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh21         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh22         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh23         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh24         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh25         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh26         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh27         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh28         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh29         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh30         : in  std_logic_vector(15 downto 0);
    sFam1SlowDacRawDataCh31         : in  std_logic_vector(15 downto 0);

    -------------------------
    -- Fam2 DIO          --
    -------------------------
    aFam2DioInCh00                  : out std_logic;
    aFam2DioInCh01                  : out std_logic;
    aFam2DioInCh02                  : out std_logic;
    aFam2DioInCh03                  : out std_logic;
    aFam2DioInCh04                  : out std_logic;
    aFam2DioInCh05                  : out std_logic;
    aFam2DioInCh06                  : out std_logic;
    aFam2DioInCh07                  : out std_logic;
    aFam2DioInCh08                  : out std_logic;
    aFam2DioInCh09                  : out std_logic;
    aFam2DioInCh10                  : out std_logic;
    aFam2DioInCh11                  : out std_logic;
    aFam2DioInCh12                  : out std_logic;
    aFam2DioInCh13                  : out std_logic;
    aFam2DioInCh14                  : out std_logic;
    aFam2DioInCh15                  : out std_logic;
    aFam2DioInCh16                  : out std_logic;
    aFam2DioInCh17                  : out std_logic;
    aFam2DioInCh18                  : out std_logic;
    aFam2DioInCh19                  : out std_logic;
    aFam2DioInCh20                  : out std_logic;
    aFam2DioInCh21                  : out std_logic;
    aFam2DioInCh22                  : out std_logic;
    aFam2DioInCh23                  : out std_logic;
    aFam2DioInCh24                  : out std_logic;
    aFam2DioInCh25                  : out std_logic;
    aFam2DioInCh26                  : out std_logic;
    aFam2DioInCh27                  : out std_logic;
    aFam2DioInCh28                  : out std_logic;
    aFam2DioInCh29                  : out std_logic;
    aFam2DioInCh30                  : out std_logic;
    aFam2DioInCh31                  : out std_logic;
    aFam2DioOutCh00                 : in  std_logic;
    aFam2DioOutCh01                 : in  std_logic;
    aFam2DioOutCh02                 : in  std_logic;
    aFam2DioOutCh03                 : in  std_logic;
    aFam2DioOutCh04                 : in  std_logic;
    aFam2DioOutCh05                 : in  std_logic;
    aFam2DioOutCh06                 : in  std_logic;
    aFam2DioOutCh07                 : in  std_logic;
    aFam2DioOutCh08                 : in  std_logic;
    aFam2DioOutCh09                 : in  std_logic;
    aFam2DioOutCh10                 : in  std_logic;
    aFam2DioOutCh11                 : in  std_logic;
    aFam2DioOutCh12                 : in  std_logic;
    aFam2DioOutCh13                 : in  std_logic;
    aFam2DioOutCh14                 : in  std_logic;
    aFam2DioOutCh15                 : in  std_logic;
    aFam2DioOutCh16                 : in  std_logic;
    aFam2DioOutCh17                 : in  std_logic;
    aFam2DioOutCh18                 : in  std_logic;
    aFam2DioOutCh19                 : in  std_logic;
    aFam2DioOutCh20                 : in  std_logic;
    aFam2DioOutCh21                 : in  std_logic;
    aFam2DioOutCh22                 : in  std_logic;
    aFam2DioOutCh23                 : in  std_logic;
    aFam2DioOutCh24                 : in  std_logic;
    aFam2DioOutCh25                 : in  std_logic;
    aFam2DioOutCh26                 : in  std_logic;
    aFam2DioOutCh27                 : in  std_logic;
    aFam2DioOutCh28                 : in  std_logic;
    aFam2DioOutCh29                 : in  std_logic;
    aFam2DioOutCh30                 : in  std_logic;
    aFam2DioOutCh31                 : in  std_logic;

    -------------------------
    -- Fam2 FastDac      --
    -------------------------
    sFam2FastDacFxpReady            : out std_logic;
    sFam2FastDacFxpStart            : in  std_logic;
    sFam2FastDacFxpValidCh00        : in  std_logic;
    sFam2FastDacFxpValidCh01        : in  std_logic;
    sFam2FastDacFxpValidCh02        : in  std_logic;
    sFam2FastDacFxpValidCh03        : in  std_logic;
    sFam2FastDacFxpValidCh04        : in  std_logic;
    sFam2FastDacFxpValidCh05        : in  std_logic;
    sFam2FastDacFxpValidCh06        : in  std_logic;
    sFam2FastDacFxpValidCh07        : in  std_logic;
    sFam2FastDacFxpValidCh08        : in  std_logic;
    sFam2FastDacFxpValidCh09        : in  std_logic;
    sFam2FastDacFxpValidCh10        : in  std_logic;
    sFam2FastDacFxpValidCh11        : in  std_logic;
    sFam2FastDacFxpValidCh12        : in  std_logic;
    sFam2FastDacFxpValidCh13        : in  std_logic;
    sFam2FastDacFxpValidCh14        : in  std_logic;
    sFam2FastDacFxpValidCh15        : in  std_logic;
    sFam2FastDacFxpValidCh16        : in  std_logic;
    sFam2FastDacFxpValidCh17        : in  std_logic;
    sFam2FastDacFxpValidCh18        : in  std_logic;
    sFam2FastDacFxpValidCh19        : in  std_logic;
    sFam2FastDacFxpValidCh20        : in  std_logic;
    sFam2FastDacFxpValidCh21        : in  std_logic;
    sFam2FastDacFxpValidCh22        : in  std_logic;
    sFam2FastDacFxpValidCh23        : in  std_logic;
    sFam2FastDacFxpValidCh24        : in  std_logic;
    sFam2FastDacFxpValidCh25        : in  std_logic;
    sFam2FastDacFxpValidCh26        : in  std_logic;
    sFam2FastDacFxpValidCh27        : in  std_logic;
    sFam2FastDacFxpValidCh28        : in  std_logic;
    sFam2FastDacFxpValidCh29        : in  std_logic;
    sFam2FastDacFxpValidCh30        : in  std_logic;
    sFam2FastDacFxpValidCh31        : in  std_logic;
    sFam2FastDacFxpDataCh00         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh01         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh02         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh03         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh04         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh05         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh06         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh07         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh08         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh09         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh10         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh11         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh12         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh13         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh14         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh15         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh16         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh17         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh18         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh19         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh20         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh21         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh22         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh23         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh24         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh25         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh26         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh27         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh28         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh29         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh30         : in  std_logic_vector(19 downto 0);
    sFam2FastDacFxpDataCh31         : in  std_logic_vector(19 downto 0);

    sFam2FastDacRawReady            : out std_logic;
    sFam2FastDacRawStart            : in  std_logic;
    sFam2FastDacRawValidCh00        : in  std_logic;
    sFam2FastDacRawValidCh01        : in  std_logic;
    sFam2FastDacRawValidCh02        : in  std_logic;
    sFam2FastDacRawValidCh03        : in  std_logic;
    sFam2FastDacRawValidCh04        : in  std_logic;
    sFam2FastDacRawValidCh05        : in  std_logic;
    sFam2FastDacRawValidCh06        : in  std_logic;
    sFam2FastDacRawValidCh07        : in  std_logic;
    sFam2FastDacRawValidCh08        : in  std_logic;
    sFam2FastDacRawValidCh09        : in  std_logic;
    sFam2FastDacRawValidCh10        : in  std_logic;
    sFam2FastDacRawValidCh11        : in  std_logic;
    sFam2FastDacRawValidCh12        : in  std_logic;
    sFam2FastDacRawValidCh13        : in  std_logic;
    sFam2FastDacRawValidCh14        : in  std_logic;
    sFam2FastDacRawValidCh15        : in  std_logic;
    sFam2FastDacRawValidCh16        : in  std_logic;
    sFam2FastDacRawValidCh17        : in  std_logic;
    sFam2FastDacRawValidCh18        : in  std_logic;
    sFam2FastDacRawValidCh19        : in  std_logic;
    sFam2FastDacRawValidCh20        : in  std_logic;
    sFam2FastDacRawValidCh21        : in  std_logic;
    sFam2FastDacRawValidCh22        : in  std_logic;
    sFam2FastDacRawValidCh23        : in  std_logic;
    sFam2FastDacRawValidCh24        : in  std_logic;
    sFam2FastDacRawValidCh25        : in  std_logic;
    sFam2FastDacRawValidCh26        : in  std_logic;
    sFam2FastDacRawValidCh27        : in  std_logic;
    sFam2FastDacRawValidCh28        : in  std_logic;
    sFam2FastDacRawValidCh29        : in  std_logic;
    sFam2FastDacRawValidCh30        : in  std_logic;
    sFam2FastDacRawValidCh31        : in  std_logic;
    sFam2FastDacRawDataCh00         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh01         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh02         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh03         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh04         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh05         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh06         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh07         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh08         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh09         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh10         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh11         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh12         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh13         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh14         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh15         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh16         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh17         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh18         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh19         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh20         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh21         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh22         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh23         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh24         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh25         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh26         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh27         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh28         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh29         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh30         : in  std_logic_vector(15 downto 0);
    sFam2FastDacRawDataCh31         : in  std_logic_vector(15 downto 0)
  );
end entity NI7891Top;

architecture rtl of NI7891Top is

  --vhook_sigstart
  --vhook_sigend

  --vhook_d NI7891FixedLogic
  component NI7891FixedLogic
    port (
      aBaseConfigReset                : out std_logic;
      aBaseI2cSclIn                   : in  std_logic;
      aBaseI2cSclOut                  : out std_logic;
      aBaseI2cSclTri                  : out std_logic;
      aBaseI2cSdaIn                   : in  std_logic;
      aBaseI2cSdaOut                  : out std_logic;
      aBaseI2cSdaTri                  : out std_logic;
      aBaseDioIn                      : in  std_logic_vector(31 downto 0);
      aBaseDioOut                     : out std_logic_vector(31 downto 0);
      aBaseDioOutEn                   : out std_logic_vector(31 downto 0);
      aBaseExClk                      : in  std_logic;
      aDiffGpio_p                     : inout std_logic_vector(69 downto 0);
      aDiffGpio_n                     : inout std_logic_vector(69 downto 0);
      aSeGpio                         : inout std_logic_vector(29 downto 0);
      xIoPresent                      : in  std_logic;
      xIoReady                        : in  std_logic;
      xIoOutputEnable                 : in  std_logic;
      aReservedToClip                 : in  std_logic_vector(15 downto 0);
      aReservedFromClip               : out std_logic_vector(15 downto 0);
      DeviceClk                       : in  std_logic;
      SampleClk                       : in  std_logic;
      AxiClk                          : in  std_logic;
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
      PxieClk100                      : in  std_logic;
      Clk100ToLv                      : out std_logic;
      aBaseExClkToLv                  : out std_logic;
      aFam2ExClkToLv                  : out std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      aBaseDioInCh00                  : out std_logic;
      aBaseDioInCh01                  : out std_logic;
      aBaseDioInCh02                  : out std_logic;
      aBaseDioInCh03                  : out std_logic;
      aBaseDioInCh04                  : out std_logic;
      aBaseDioInCh05                  : out std_logic;
      aBaseDioInCh06                  : out std_logic;
      aBaseDioInCh07                  : out std_logic;
      aBaseDioInCh08                  : out std_logic;
      aBaseDioInCh09                  : out std_logic;
      aBaseDioInCh10                  : out std_logic;
      aBaseDioInCh11                  : out std_logic;
      aBaseDioInCh12                  : out std_logic;
      aBaseDioInCh13                  : out std_logic;
      aBaseDioInCh14                  : out std_logic;
      aBaseDioInCh15                  : out std_logic;
      aBaseDioInCh16                  : out std_logic;
      aBaseDioInCh17                  : out std_logic;
      aBaseDioInCh18                  : out std_logic;
      aBaseDioInCh19                  : out std_logic;
      aBaseDioInCh20                  : out std_logic;
      aBaseDioInCh21                  : out std_logic;
      aBaseDioInCh22                  : out std_logic;
      aBaseDioInCh23                  : out std_logic;
      aBaseDioInCh24                  : out std_logic;
      aBaseDioInCh25                  : out std_logic;
      aBaseDioInCh26                  : out std_logic;
      aBaseDioInCh27                  : out std_logic;
      aBaseDioInCh28                  : out std_logic;
      aBaseDioInCh29                  : out std_logic;
      aBaseDioInCh30                  : out std_logic;
      aBaseDioInCh31                  : out std_logic;
      aBaseDioOutCh00                 : in  std_logic;
      aBaseDioOutCh01                 : in  std_logic;
      aBaseDioOutCh02                 : in  std_logic;
      aBaseDioOutCh03                 : in  std_logic;
      aBaseDioOutCh04                 : in  std_logic;
      aBaseDioOutCh05                 : in  std_logic;
      aBaseDioOutCh06                 : in  std_logic;
      aBaseDioOutCh07                 : in  std_logic;
      aBaseDioOutCh08                 : in  std_logic;
      aBaseDioOutCh09                 : in  std_logic;
      aBaseDioOutCh10                 : in  std_logic;
      aBaseDioOutCh11                 : in  std_logic;
      aBaseDioOutCh12                 : in  std_logic;
      aBaseDioOutCh13                 : in  std_logic;
      aBaseDioOutCh14                 : in  std_logic;
      aBaseDioOutCh15                 : in  std_logic;
      aBaseDioOutCh16                 : in  std_logic;
      aBaseDioOutCh17                 : in  std_logic;
      aBaseDioOutCh18                 : in  std_logic;
      aBaseDioOutCh19                 : in  std_logic;
      aBaseDioOutCh20                 : in  std_logic;
      aBaseDioOutCh21                 : in  std_logic;
      aBaseDioOutCh22                 : in  std_logic;
      aBaseDioOutCh23                 : in  std_logic;
      aBaseDioOutCh24                 : in  std_logic;
      aBaseDioOutCh25                 : in  std_logic;
      aBaseDioOutCh26                 : in  std_logic;
      aBaseDioOutCh27                 : in  std_logic;
      aBaseDioOutCh28                 : in  std_logic;
      aBaseDioOutCh29                 : in  std_logic;
      aBaseDioOutCh30                 : in  std_logic;
      aBaseDioOutCh31                 : in  std_logic;
      sFam1SlowAdcFxpReady            : out std_logic;
      sFam1SlowAdcFxpStart            : in  std_logic;
      sFam1SlowAdcFxpValid            : out std_logic;
      sFam1SlowAdcFxpDataCh00         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh01         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh02         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh03         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh04         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh05         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh06         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh07         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh08         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh09         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh10         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh11         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh12         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh13         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh14         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcFxpDataCh15         : out std_logic_vector(27 downto 0);
      sFam1SlowAdcRawReady            : out std_logic;
      sFam1SlowAdcRawStart            : in  std_logic;
      sFam1SlowAdcRawValid            : out std_logic;
      sFam1SlowAdcRawDataCh00         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh01         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh02         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh03         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh04         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh05         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh06         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh07         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh08         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh09         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh10         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh11         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh12         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh13         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh14         : out std_logic_vector(15 downto 0);
      sFam1SlowAdcRawDataCh15         : out std_logic_vector(15 downto 0);
      sFam1SlowDacFxpReady            : out std_logic;
      sFam1SlowDacFxpStart            : in  std_logic;
      sFam1SlowDacFxpValidCh00        : in  std_logic;
      sFam1SlowDacFxpValidCh01        : in  std_logic;
      sFam1SlowDacFxpValidCh02        : in  std_logic;
      sFam1SlowDacFxpValidCh03        : in  std_logic;
      sFam1SlowDacFxpValidCh04        : in  std_logic;
      sFam1SlowDacFxpValidCh05        : in  std_logic;
      sFam1SlowDacFxpValidCh06        : in  std_logic;
      sFam1SlowDacFxpValidCh07        : in  std_logic;
      sFam1SlowDacFxpValidCh08        : in  std_logic;
      sFam1SlowDacFxpValidCh09        : in  std_logic;
      sFam1SlowDacFxpValidCh10        : in  std_logic;
      sFam1SlowDacFxpValidCh11        : in  std_logic;
      sFam1SlowDacFxpValidCh12        : in  std_logic;
      sFam1SlowDacFxpValidCh13        : in  std_logic;
      sFam1SlowDacFxpValidCh14        : in  std_logic;
      sFam1SlowDacFxpValidCh15        : in  std_logic;
      sFam1SlowDacFxpValidCh16        : in  std_logic;
      sFam1SlowDacFxpValidCh17        : in  std_logic;
      sFam1SlowDacFxpValidCh18        : in  std_logic;
      sFam1SlowDacFxpValidCh19        : in  std_logic;
      sFam1SlowDacFxpValidCh20        : in  std_logic;
      sFam1SlowDacFxpValidCh21        : in  std_logic;
      sFam1SlowDacFxpValidCh22        : in  std_logic;
      sFam1SlowDacFxpValidCh23        : in  std_logic;
      sFam1SlowDacFxpValidCh24        : in  std_logic;
      sFam1SlowDacFxpValidCh25        : in  std_logic;
      sFam1SlowDacFxpValidCh26        : in  std_logic;
      sFam1SlowDacFxpValidCh27        : in  std_logic;
      sFam1SlowDacFxpValidCh28        : in  std_logic;
      sFam1SlowDacFxpValidCh29        : in  std_logic;
      sFam1SlowDacFxpValidCh30        : in  std_logic;
      sFam1SlowDacFxpValidCh31        : in  std_logic;
      sFam1SlowDacFxpDataCh00         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh01         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh02         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh03         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh04         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh05         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh06         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh07         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh08         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh09         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh10         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh11         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh12         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh13         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh14         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh15         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh16         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh17         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh18         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh19         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh20         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh21         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh22         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh23         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh24         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh25         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh26         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh27         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh28         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh29         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh30         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacFxpDataCh31         : in  std_logic_vector(19 downto 0);
      sFam1SlowDacRawReady            : out std_logic;
      sFam1SlowDacRawStart            : in  std_logic;
      sFam1SlowDacRawValidCh00        : in  std_logic;
      sFam1SlowDacRawValidCh01        : in  std_logic;
      sFam1SlowDacRawValidCh02        : in  std_logic;
      sFam1SlowDacRawValidCh03        : in  std_logic;
      sFam1SlowDacRawValidCh04        : in  std_logic;
      sFam1SlowDacRawValidCh05        : in  std_logic;
      sFam1SlowDacRawValidCh06        : in  std_logic;
      sFam1SlowDacRawValidCh07        : in  std_logic;
      sFam1SlowDacRawValidCh08        : in  std_logic;
      sFam1SlowDacRawValidCh09        : in  std_logic;
      sFam1SlowDacRawValidCh10        : in  std_logic;
      sFam1SlowDacRawValidCh11        : in  std_logic;
      sFam1SlowDacRawValidCh12        : in  std_logic;
      sFam1SlowDacRawValidCh13        : in  std_logic;
      sFam1SlowDacRawValidCh14        : in  std_logic;
      sFam1SlowDacRawValidCh15        : in  std_logic;
      sFam1SlowDacRawValidCh16        : in  std_logic;
      sFam1SlowDacRawValidCh17        : in  std_logic;
      sFam1SlowDacRawValidCh18        : in  std_logic;
      sFam1SlowDacRawValidCh19        : in  std_logic;
      sFam1SlowDacRawValidCh20        : in  std_logic;
      sFam1SlowDacRawValidCh21        : in  std_logic;
      sFam1SlowDacRawValidCh22        : in  std_logic;
      sFam1SlowDacRawValidCh23        : in  std_logic;
      sFam1SlowDacRawValidCh24        : in  std_logic;
      sFam1SlowDacRawValidCh25        : in  std_logic;
      sFam1SlowDacRawValidCh26        : in  std_logic;
      sFam1SlowDacRawValidCh27        : in  std_logic;
      sFam1SlowDacRawValidCh28        : in  std_logic;
      sFam1SlowDacRawValidCh29        : in  std_logic;
      sFam1SlowDacRawValidCh30        : in  std_logic;
      sFam1SlowDacRawValidCh31        : in  std_logic;
      sFam1SlowDacRawDataCh00         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh01         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh02         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh03         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh04         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh05         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh06         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh07         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh08         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh09         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh10         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh11         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh12         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh13         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh14         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh15         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh16         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh17         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh18         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh19         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh20         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh21         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh22         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh23         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh24         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh25         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh26         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh27         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh28         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh29         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh30         : in  std_logic_vector(15 downto 0);
      sFam1SlowDacRawDataCh31         : in  std_logic_vector(15 downto 0);
      aFam2DioInCh00                  : out std_logic;
      aFam2DioInCh01                  : out std_logic;
      aFam2DioInCh02                  : out std_logic;
      aFam2DioInCh03                  : out std_logic;
      aFam2DioInCh04                  : out std_logic;
      aFam2DioInCh05                  : out std_logic;
      aFam2DioInCh06                  : out std_logic;
      aFam2DioInCh07                  : out std_logic;
      aFam2DioInCh08                  : out std_logic;
      aFam2DioInCh09                  : out std_logic;
      aFam2DioInCh10                  : out std_logic;
      aFam2DioInCh11                  : out std_logic;
      aFam2DioInCh12                  : out std_logic;
      aFam2DioInCh13                  : out std_logic;
      aFam2DioInCh14                  : out std_logic;
      aFam2DioInCh15                  : out std_logic;
      aFam2DioInCh16                  : out std_logic;
      aFam2DioInCh17                  : out std_logic;
      aFam2DioInCh18                  : out std_logic;
      aFam2DioInCh19                  : out std_logic;
      aFam2DioInCh20                  : out std_logic;
      aFam2DioInCh21                  : out std_logic;
      aFam2DioInCh22                  : out std_logic;
      aFam2DioInCh23                  : out std_logic;
      aFam2DioInCh24                  : out std_logic;
      aFam2DioInCh25                  : out std_logic;
      aFam2DioInCh26                  : out std_logic;
      aFam2DioInCh27                  : out std_logic;
      aFam2DioInCh28                  : out std_logic;
      aFam2DioInCh29                  : out std_logic;
      aFam2DioInCh30                  : out std_logic;
      aFam2DioInCh31                  : out std_logic;
      aFam2DioOutCh00                 : in  std_logic;
      aFam2DioOutCh01                 : in  std_logic;
      aFam2DioOutCh02                 : in  std_logic;
      aFam2DioOutCh03                 : in  std_logic;
      aFam2DioOutCh04                 : in  std_logic;
      aFam2DioOutCh05                 : in  std_logic;
      aFam2DioOutCh06                 : in  std_logic;
      aFam2DioOutCh07                 : in  std_logic;
      aFam2DioOutCh08                 : in  std_logic;
      aFam2DioOutCh09                 : in  std_logic;
      aFam2DioOutCh10                 : in  std_logic;
      aFam2DioOutCh11                 : in  std_logic;
      aFam2DioOutCh12                 : in  std_logic;
      aFam2DioOutCh13                 : in  std_logic;
      aFam2DioOutCh14                 : in  std_logic;
      aFam2DioOutCh15                 : in  std_logic;
      aFam2DioOutCh16                 : in  std_logic;
      aFam2DioOutCh17                 : in  std_logic;
      aFam2DioOutCh18                 : in  std_logic;
      aFam2DioOutCh19                 : in  std_logic;
      aFam2DioOutCh20                 : in  std_logic;
      aFam2DioOutCh21                 : in  std_logic;
      aFam2DioOutCh22                 : in  std_logic;
      aFam2DioOutCh23                 : in  std_logic;
      aFam2DioOutCh24                 : in  std_logic;
      aFam2DioOutCh25                 : in  std_logic;
      aFam2DioOutCh26                 : in  std_logic;
      aFam2DioOutCh27                 : in  std_logic;
      aFam2DioOutCh28                 : in  std_logic;
      aFam2DioOutCh29                 : in  std_logic;
      aFam2DioOutCh30                 : in  std_logic;
      aFam2DioOutCh31                 : in  std_logic;
      sFam2FastDacFxpReady            : out std_logic;
      sFam2FastDacFxpStart            : in  std_logic;
      sFam2FastDacFxpValidCh00        : in  std_logic;
      sFam2FastDacFxpValidCh01        : in  std_logic;
      sFam2FastDacFxpValidCh02        : in  std_logic;
      sFam2FastDacFxpValidCh03        : in  std_logic;
      sFam2FastDacFxpValidCh04        : in  std_logic;
      sFam2FastDacFxpValidCh05        : in  std_logic;
      sFam2FastDacFxpValidCh06        : in  std_logic;
      sFam2FastDacFxpValidCh07        : in  std_logic;
      sFam2FastDacFxpValidCh08        : in  std_logic;
      sFam2FastDacFxpValidCh09        : in  std_logic;
      sFam2FastDacFxpValidCh10        : in  std_logic;
      sFam2FastDacFxpValidCh11        : in  std_logic;
      sFam2FastDacFxpValidCh12        : in  std_logic;
      sFam2FastDacFxpValidCh13        : in  std_logic;
      sFam2FastDacFxpValidCh14        : in  std_logic;
      sFam2FastDacFxpValidCh15        : in  std_logic;
      sFam2FastDacFxpValidCh16        : in  std_logic;
      sFam2FastDacFxpValidCh17        : in  std_logic;
      sFam2FastDacFxpValidCh18        : in  std_logic;
      sFam2FastDacFxpValidCh19        : in  std_logic;
      sFam2FastDacFxpValidCh20        : in  std_logic;
      sFam2FastDacFxpValidCh21        : in  std_logic;
      sFam2FastDacFxpValidCh22        : in  std_logic;
      sFam2FastDacFxpValidCh23        : in  std_logic;
      sFam2FastDacFxpValidCh24        : in  std_logic;
      sFam2FastDacFxpValidCh25        : in  std_logic;
      sFam2FastDacFxpValidCh26        : in  std_logic;
      sFam2FastDacFxpValidCh27        : in  std_logic;
      sFam2FastDacFxpValidCh28        : in  std_logic;
      sFam2FastDacFxpValidCh29        : in  std_logic;
      sFam2FastDacFxpValidCh30        : in  std_logic;
      sFam2FastDacFxpValidCh31        : in  std_logic;
      sFam2FastDacFxpDataCh00         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh01         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh02         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh03         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh04         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh05         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh06         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh07         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh08         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh09         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh10         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh11         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh12         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh13         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh14         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh15         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh16         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh17         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh18         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh19         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh20         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh21         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh22         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh23         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh24         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh25         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh26         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh27         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh28         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh29         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh30         : in  std_logic_vector(19 downto 0);
      sFam2FastDacFxpDataCh31         : in  std_logic_vector(19 downto 0);
      sFam2FastDacRawReady            : out std_logic;
      sFam2FastDacRawStart            : in  std_logic;
      sFam2FastDacRawValidCh00        : in  std_logic;
      sFam2FastDacRawValidCh01        : in  std_logic;
      sFam2FastDacRawValidCh02        : in  std_logic;
      sFam2FastDacRawValidCh03        : in  std_logic;
      sFam2FastDacRawValidCh04        : in  std_logic;
      sFam2FastDacRawValidCh05        : in  std_logic;
      sFam2FastDacRawValidCh06        : in  std_logic;
      sFam2FastDacRawValidCh07        : in  std_logic;
      sFam2FastDacRawValidCh08        : in  std_logic;
      sFam2FastDacRawValidCh09        : in  std_logic;
      sFam2FastDacRawValidCh10        : in  std_logic;
      sFam2FastDacRawValidCh11        : in  std_logic;
      sFam2FastDacRawValidCh12        : in  std_logic;
      sFam2FastDacRawValidCh13        : in  std_logic;
      sFam2FastDacRawValidCh14        : in  std_logic;
      sFam2FastDacRawValidCh15        : in  std_logic;
      sFam2FastDacRawValidCh16        : in  std_logic;
      sFam2FastDacRawValidCh17        : in  std_logic;
      sFam2FastDacRawValidCh18        : in  std_logic;
      sFam2FastDacRawValidCh19        : in  std_logic;
      sFam2FastDacRawValidCh20        : in  std_logic;
      sFam2FastDacRawValidCh21        : in  std_logic;
      sFam2FastDacRawValidCh22        : in  std_logic;
      sFam2FastDacRawValidCh23        : in  std_logic;
      sFam2FastDacRawValidCh24        : in  std_logic;
      sFam2FastDacRawValidCh25        : in  std_logic;
      sFam2FastDacRawValidCh26        : in  std_logic;
      sFam2FastDacRawValidCh27        : in  std_logic;
      sFam2FastDacRawValidCh28        : in  std_logic;
      sFam2FastDacRawValidCh29        : in  std_logic;
      sFam2FastDacRawValidCh30        : in  std_logic;
      sFam2FastDacRawValidCh31        : in  std_logic;
      sFam2FastDacRawDataCh00         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh01         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh02         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh03         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh04         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh05         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh06         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh07         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh08         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh09         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh10         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh11         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh12         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh13         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh14         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh15         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh16         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh17         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh18         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh19         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh20         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh21         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh22         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh23         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh24         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh25         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh26         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh27         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh28         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh29         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh30         : in  std_logic_vector(15 downto 0);
      sFam2FastDacRawDataCh31         : in  std_logic_vector(15 downto 0));
  end component;

begin

  ---------------------------------------------------------------------------------------
  -- TO USERS : DO NOT TOUCH BELOW CODES
  ---------------------------------------------------------------------------------------
  -- Set '1' for MDK modules using FlexRIO drivers
  stIoModuleSupportsFRAGLs <= '1';

  -- Unused signals
  dvTdcAssert              <= '0';
  dtDevClkEn               <= '0';
  --vhook_nowarn dtTdcAssert
  --vhook_nowarn SampleClk
  --vhook_nowarn DeviceClk
  --vhook_nowarn xIo*
  --vhook_nowarn aGpio*
  --vhook_nowarn xClipAxi4LiteInterrupt

  --vhook_i NI7891FixedLogic
  NI7891FixedLogicx: NI7891FixedLogic
    port map (
      aBaseConfigReset                => aBaseConfigReset,                 --out std_logic
      aBaseI2cSclIn                   => aBaseI2cSclIn,                    --in  std_logic
      aBaseI2cSclOut                  => aBaseI2cSclOut,                   --out std_logic
      aBaseI2cSclTri                  => aBaseI2cSclTri,                   --out std_logic
      aBaseI2cSdaIn                   => aBaseI2cSdaIn,                    --in  std_logic
      aBaseI2cSdaOut                  => aBaseI2cSdaOut,                   --out std_logic
      aBaseI2cSdaTri                  => aBaseI2cSdaTri,                   --out std_logic
      aBaseDioIn                      => aBaseDioIn,                       --in  std_logic_vector(31:0)
      aBaseDioOut                     => aBaseDioOut,                      --out std_logic_vector(31:0)
      aBaseDioOutEn                   => aBaseDioOutEn,                    --out std_logic_vector(31:0)
      aBaseExClk                      => aBaseExClk,                       --in  std_logic
      aDiffGpio_p                     => aDiffGpio_p,                      --inout std_logic_vector(69:0)
      aDiffGpio_n                     => aDiffGpio_n,                      --inout std_logic_vector(69:0)
      aSeGpio                         => aSeGpio,                          --inout std_logic_vector(29:0)
      xIoPresent                      => xIoPresent,                       --in  std_logic
      xIoReady                        => xIoReady,                         --in  std_logic
      xIoOutputEnable                 => xIoOutputEnable,                  --in  std_logic
      aReservedToClip                 => aReservedToClip,                  --in  std_logic_vector(15:0)
      aReservedFromClip               => aReservedFromClip,                --out std_logic_vector(15:0)
      DeviceClk                       => DeviceClk,                        --in  std_logic
      SampleClk                       => SampleClk,                        --in  std_logic
      AxiClk                          => AxiClk,                           --in  std_logic
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
      PxieClk100                      => PxieClk100,                       --in  std_logic
      Clk100ToLv                      => Clk100ToLv,                       --out std_logic
      aBaseExClkToLv                  => aBaseExClkToLv,                   --out std_logic
      aFam2ExClkToLv                  => aFam2ExClkToLv,                   --out std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      aBaseDioInCh00                  => aBaseDioInCh00,                   --out std_logic
      aBaseDioInCh01                  => aBaseDioInCh01,                   --out std_logic
      aBaseDioInCh02                  => aBaseDioInCh02,                   --out std_logic
      aBaseDioInCh03                  => aBaseDioInCh03,                   --out std_logic
      aBaseDioInCh04                  => aBaseDioInCh04,                   --out std_logic
      aBaseDioInCh05                  => aBaseDioInCh05,                   --out std_logic
      aBaseDioInCh06                  => aBaseDioInCh06,                   --out std_logic
      aBaseDioInCh07                  => aBaseDioInCh07,                   --out std_logic
      aBaseDioInCh08                  => aBaseDioInCh08,                   --out std_logic
      aBaseDioInCh09                  => aBaseDioInCh09,                   --out std_logic
      aBaseDioInCh10                  => aBaseDioInCh10,                   --out std_logic
      aBaseDioInCh11                  => aBaseDioInCh11,                   --out std_logic
      aBaseDioInCh12                  => aBaseDioInCh12,                   --out std_logic
      aBaseDioInCh13                  => aBaseDioInCh13,                   --out std_logic
      aBaseDioInCh14                  => aBaseDioInCh14,                   --out std_logic
      aBaseDioInCh15                  => aBaseDioInCh15,                   --out std_logic
      aBaseDioInCh16                  => aBaseDioInCh16,                   --out std_logic
      aBaseDioInCh17                  => aBaseDioInCh17,                   --out std_logic
      aBaseDioInCh18                  => aBaseDioInCh18,                   --out std_logic
      aBaseDioInCh19                  => aBaseDioInCh19,                   --out std_logic
      aBaseDioInCh20                  => aBaseDioInCh20,                   --out std_logic
      aBaseDioInCh21                  => aBaseDioInCh21,                   --out std_logic
      aBaseDioInCh22                  => aBaseDioInCh22,                   --out std_logic
      aBaseDioInCh23                  => aBaseDioInCh23,                   --out std_logic
      aBaseDioInCh24                  => aBaseDioInCh24,                   --out std_logic
      aBaseDioInCh25                  => aBaseDioInCh25,                   --out std_logic
      aBaseDioInCh26                  => aBaseDioInCh26,                   --out std_logic
      aBaseDioInCh27                  => aBaseDioInCh27,                   --out std_logic
      aBaseDioInCh28                  => aBaseDioInCh28,                   --out std_logic
      aBaseDioInCh29                  => aBaseDioInCh29,                   --out std_logic
      aBaseDioInCh30                  => aBaseDioInCh30,                   --out std_logic
      aBaseDioInCh31                  => aBaseDioInCh31,                   --out std_logic
      aBaseDioOutCh00                 => aBaseDioOutCh00,                  --in  std_logic
      aBaseDioOutCh01                 => aBaseDioOutCh01,                  --in  std_logic
      aBaseDioOutCh02                 => aBaseDioOutCh02,                  --in  std_logic
      aBaseDioOutCh03                 => aBaseDioOutCh03,                  --in  std_logic
      aBaseDioOutCh04                 => aBaseDioOutCh04,                  --in  std_logic
      aBaseDioOutCh05                 => aBaseDioOutCh05,                  --in  std_logic
      aBaseDioOutCh06                 => aBaseDioOutCh06,                  --in  std_logic
      aBaseDioOutCh07                 => aBaseDioOutCh07,                  --in  std_logic
      aBaseDioOutCh08                 => aBaseDioOutCh08,                  --in  std_logic
      aBaseDioOutCh09                 => aBaseDioOutCh09,                  --in  std_logic
      aBaseDioOutCh10                 => aBaseDioOutCh10,                  --in  std_logic
      aBaseDioOutCh11                 => aBaseDioOutCh11,                  --in  std_logic
      aBaseDioOutCh12                 => aBaseDioOutCh12,                  --in  std_logic
      aBaseDioOutCh13                 => aBaseDioOutCh13,                  --in  std_logic
      aBaseDioOutCh14                 => aBaseDioOutCh14,                  --in  std_logic
      aBaseDioOutCh15                 => aBaseDioOutCh15,                  --in  std_logic
      aBaseDioOutCh16                 => aBaseDioOutCh16,                  --in  std_logic
      aBaseDioOutCh17                 => aBaseDioOutCh17,                  --in  std_logic
      aBaseDioOutCh18                 => aBaseDioOutCh18,                  --in  std_logic
      aBaseDioOutCh19                 => aBaseDioOutCh19,                  --in  std_logic
      aBaseDioOutCh20                 => aBaseDioOutCh20,                  --in  std_logic
      aBaseDioOutCh21                 => aBaseDioOutCh21,                  --in  std_logic
      aBaseDioOutCh22                 => aBaseDioOutCh22,                  --in  std_logic
      aBaseDioOutCh23                 => aBaseDioOutCh23,                  --in  std_logic
      aBaseDioOutCh24                 => aBaseDioOutCh24,                  --in  std_logic
      aBaseDioOutCh25                 => aBaseDioOutCh25,                  --in  std_logic
      aBaseDioOutCh26                 => aBaseDioOutCh26,                  --in  std_logic
      aBaseDioOutCh27                 => aBaseDioOutCh27,                  --in  std_logic
      aBaseDioOutCh28                 => aBaseDioOutCh28,                  --in  std_logic
      aBaseDioOutCh29                 => aBaseDioOutCh29,                  --in  std_logic
      aBaseDioOutCh30                 => aBaseDioOutCh30,                  --in  std_logic
      aBaseDioOutCh31                 => aBaseDioOutCh31,                  --in  std_logic
      sFam1SlowAdcFxpReady            => sFam1SlowAdcFxpReady,             --out std_logic
      sFam1SlowAdcFxpStart            => sFam1SlowAdcFxpStart,             --in  std_logic
      sFam1SlowAdcFxpValid            => sFam1SlowAdcFxpValid,             --out std_logic
      sFam1SlowAdcFxpDataCh00         => sFam1SlowAdcFxpDataCh00,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh01         => sFam1SlowAdcFxpDataCh01,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh02         => sFam1SlowAdcFxpDataCh02,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh03         => sFam1SlowAdcFxpDataCh03,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh04         => sFam1SlowAdcFxpDataCh04,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh05         => sFam1SlowAdcFxpDataCh05,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh06         => sFam1SlowAdcFxpDataCh06,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh07         => sFam1SlowAdcFxpDataCh07,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh08         => sFam1SlowAdcFxpDataCh08,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh09         => sFam1SlowAdcFxpDataCh09,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh10         => sFam1SlowAdcFxpDataCh10,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh11         => sFam1SlowAdcFxpDataCh11,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh12         => sFam1SlowAdcFxpDataCh12,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh13         => sFam1SlowAdcFxpDataCh13,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh14         => sFam1SlowAdcFxpDataCh14,          --out std_logic_vector(27:0)
      sFam1SlowAdcFxpDataCh15         => sFam1SlowAdcFxpDataCh15,          --out std_logic_vector(27:0)
      sFam1SlowAdcRawReady            => sFam1SlowAdcRawReady,             --out std_logic
      sFam1SlowAdcRawStart            => sFam1SlowAdcRawStart,             --in  std_logic
      sFam1SlowAdcRawValid            => sFam1SlowAdcRawValid,             --out std_logic
      sFam1SlowAdcRawDataCh00         => sFam1SlowAdcRawDataCh00,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh01         => sFam1SlowAdcRawDataCh01,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh02         => sFam1SlowAdcRawDataCh02,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh03         => sFam1SlowAdcRawDataCh03,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh04         => sFam1SlowAdcRawDataCh04,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh05         => sFam1SlowAdcRawDataCh05,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh06         => sFam1SlowAdcRawDataCh06,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh07         => sFam1SlowAdcRawDataCh07,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh08         => sFam1SlowAdcRawDataCh08,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh09         => sFam1SlowAdcRawDataCh09,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh10         => sFam1SlowAdcRawDataCh10,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh11         => sFam1SlowAdcRawDataCh11,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh12         => sFam1SlowAdcRawDataCh12,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh13         => sFam1SlowAdcRawDataCh13,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh14         => sFam1SlowAdcRawDataCh14,          --out std_logic_vector(15:0)
      sFam1SlowAdcRawDataCh15         => sFam1SlowAdcRawDataCh15,          --out std_logic_vector(15:0)
      sFam1SlowDacFxpReady            => sFam1SlowDacFxpReady,             --out std_logic
      sFam1SlowDacFxpStart            => sFam1SlowDacFxpStart,             --in  std_logic
      sFam1SlowDacFxpValidCh00        => sFam1SlowDacFxpValidCh00,         --in  std_logic
      sFam1SlowDacFxpValidCh01        => sFam1SlowDacFxpValidCh01,         --in  std_logic
      sFam1SlowDacFxpValidCh02        => sFam1SlowDacFxpValidCh02,         --in  std_logic
      sFam1SlowDacFxpValidCh03        => sFam1SlowDacFxpValidCh03,         --in  std_logic
      sFam1SlowDacFxpValidCh04        => sFam1SlowDacFxpValidCh04,         --in  std_logic
      sFam1SlowDacFxpValidCh05        => sFam1SlowDacFxpValidCh05,         --in  std_logic
      sFam1SlowDacFxpValidCh06        => sFam1SlowDacFxpValidCh06,         --in  std_logic
      sFam1SlowDacFxpValidCh07        => sFam1SlowDacFxpValidCh07,         --in  std_logic
      sFam1SlowDacFxpValidCh08        => sFam1SlowDacFxpValidCh08,         --in  std_logic
      sFam1SlowDacFxpValidCh09        => sFam1SlowDacFxpValidCh09,         --in  std_logic
      sFam1SlowDacFxpValidCh10        => sFam1SlowDacFxpValidCh10,         --in  std_logic
      sFam1SlowDacFxpValidCh11        => sFam1SlowDacFxpValidCh11,         --in  std_logic
      sFam1SlowDacFxpValidCh12        => sFam1SlowDacFxpValidCh12,         --in  std_logic
      sFam1SlowDacFxpValidCh13        => sFam1SlowDacFxpValidCh13,         --in  std_logic
      sFam1SlowDacFxpValidCh14        => sFam1SlowDacFxpValidCh14,         --in  std_logic
      sFam1SlowDacFxpValidCh15        => sFam1SlowDacFxpValidCh15,         --in  std_logic
      sFam1SlowDacFxpValidCh16        => sFam1SlowDacFxpValidCh16,         --in  std_logic
      sFam1SlowDacFxpValidCh17        => sFam1SlowDacFxpValidCh17,         --in  std_logic
      sFam1SlowDacFxpValidCh18        => sFam1SlowDacFxpValidCh18,         --in  std_logic
      sFam1SlowDacFxpValidCh19        => sFam1SlowDacFxpValidCh19,         --in  std_logic
      sFam1SlowDacFxpValidCh20        => sFam1SlowDacFxpValidCh20,         --in  std_logic
      sFam1SlowDacFxpValidCh21        => sFam1SlowDacFxpValidCh21,         --in  std_logic
      sFam1SlowDacFxpValidCh22        => sFam1SlowDacFxpValidCh22,         --in  std_logic
      sFam1SlowDacFxpValidCh23        => sFam1SlowDacFxpValidCh23,         --in  std_logic
      sFam1SlowDacFxpValidCh24        => sFam1SlowDacFxpValidCh24,         --in  std_logic
      sFam1SlowDacFxpValidCh25        => sFam1SlowDacFxpValidCh25,         --in  std_logic
      sFam1SlowDacFxpValidCh26        => sFam1SlowDacFxpValidCh26,         --in  std_logic
      sFam1SlowDacFxpValidCh27        => sFam1SlowDacFxpValidCh27,         --in  std_logic
      sFam1SlowDacFxpValidCh28        => sFam1SlowDacFxpValidCh28,         --in  std_logic
      sFam1SlowDacFxpValidCh29        => sFam1SlowDacFxpValidCh29,         --in  std_logic
      sFam1SlowDacFxpValidCh30        => sFam1SlowDacFxpValidCh30,         --in  std_logic
      sFam1SlowDacFxpValidCh31        => sFam1SlowDacFxpValidCh31,         --in  std_logic
      sFam1SlowDacFxpDataCh00         => sFam1SlowDacFxpDataCh00,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh01         => sFam1SlowDacFxpDataCh01,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh02         => sFam1SlowDacFxpDataCh02,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh03         => sFam1SlowDacFxpDataCh03,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh04         => sFam1SlowDacFxpDataCh04,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh05         => sFam1SlowDacFxpDataCh05,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh06         => sFam1SlowDacFxpDataCh06,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh07         => sFam1SlowDacFxpDataCh07,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh08         => sFam1SlowDacFxpDataCh08,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh09         => sFam1SlowDacFxpDataCh09,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh10         => sFam1SlowDacFxpDataCh10,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh11         => sFam1SlowDacFxpDataCh11,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh12         => sFam1SlowDacFxpDataCh12,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh13         => sFam1SlowDacFxpDataCh13,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh14         => sFam1SlowDacFxpDataCh14,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh15         => sFam1SlowDacFxpDataCh15,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh16         => sFam1SlowDacFxpDataCh16,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh17         => sFam1SlowDacFxpDataCh17,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh18         => sFam1SlowDacFxpDataCh18,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh19         => sFam1SlowDacFxpDataCh19,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh20         => sFam1SlowDacFxpDataCh20,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh21         => sFam1SlowDacFxpDataCh21,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh22         => sFam1SlowDacFxpDataCh22,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh23         => sFam1SlowDacFxpDataCh23,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh24         => sFam1SlowDacFxpDataCh24,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh25         => sFam1SlowDacFxpDataCh25,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh26         => sFam1SlowDacFxpDataCh26,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh27         => sFam1SlowDacFxpDataCh27,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh28         => sFam1SlowDacFxpDataCh28,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh29         => sFam1SlowDacFxpDataCh29,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh30         => sFam1SlowDacFxpDataCh30,          --in  std_logic_vector(19:0)
      sFam1SlowDacFxpDataCh31         => sFam1SlowDacFxpDataCh31,          --in  std_logic_vector(19:0)
      sFam1SlowDacRawReady            => sFam1SlowDacRawReady,             --out std_logic
      sFam1SlowDacRawStart            => sFam1SlowDacRawStart,             --in  std_logic
      sFam1SlowDacRawValidCh00        => sFam1SlowDacRawValidCh00,         --in  std_logic
      sFam1SlowDacRawValidCh01        => sFam1SlowDacRawValidCh01,         --in  std_logic
      sFam1SlowDacRawValidCh02        => sFam1SlowDacRawValidCh02,         --in  std_logic
      sFam1SlowDacRawValidCh03        => sFam1SlowDacRawValidCh03,         --in  std_logic
      sFam1SlowDacRawValidCh04        => sFam1SlowDacRawValidCh04,         --in  std_logic
      sFam1SlowDacRawValidCh05        => sFam1SlowDacRawValidCh05,         --in  std_logic
      sFam1SlowDacRawValidCh06        => sFam1SlowDacRawValidCh06,         --in  std_logic
      sFam1SlowDacRawValidCh07        => sFam1SlowDacRawValidCh07,         --in  std_logic
      sFam1SlowDacRawValidCh08        => sFam1SlowDacRawValidCh08,         --in  std_logic
      sFam1SlowDacRawValidCh09        => sFam1SlowDacRawValidCh09,         --in  std_logic
      sFam1SlowDacRawValidCh10        => sFam1SlowDacRawValidCh10,         --in  std_logic
      sFam1SlowDacRawValidCh11        => sFam1SlowDacRawValidCh11,         --in  std_logic
      sFam1SlowDacRawValidCh12        => sFam1SlowDacRawValidCh12,         --in  std_logic
      sFam1SlowDacRawValidCh13        => sFam1SlowDacRawValidCh13,         --in  std_logic
      sFam1SlowDacRawValidCh14        => sFam1SlowDacRawValidCh14,         --in  std_logic
      sFam1SlowDacRawValidCh15        => sFam1SlowDacRawValidCh15,         --in  std_logic
      sFam1SlowDacRawValidCh16        => sFam1SlowDacRawValidCh16,         --in  std_logic
      sFam1SlowDacRawValidCh17        => sFam1SlowDacRawValidCh17,         --in  std_logic
      sFam1SlowDacRawValidCh18        => sFam1SlowDacRawValidCh18,         --in  std_logic
      sFam1SlowDacRawValidCh19        => sFam1SlowDacRawValidCh19,         --in  std_logic
      sFam1SlowDacRawValidCh20        => sFam1SlowDacRawValidCh20,         --in  std_logic
      sFam1SlowDacRawValidCh21        => sFam1SlowDacRawValidCh21,         --in  std_logic
      sFam1SlowDacRawValidCh22        => sFam1SlowDacRawValidCh22,         --in  std_logic
      sFam1SlowDacRawValidCh23        => sFam1SlowDacRawValidCh23,         --in  std_logic
      sFam1SlowDacRawValidCh24        => sFam1SlowDacRawValidCh24,         --in  std_logic
      sFam1SlowDacRawValidCh25        => sFam1SlowDacRawValidCh25,         --in  std_logic
      sFam1SlowDacRawValidCh26        => sFam1SlowDacRawValidCh26,         --in  std_logic
      sFam1SlowDacRawValidCh27        => sFam1SlowDacRawValidCh27,         --in  std_logic
      sFam1SlowDacRawValidCh28        => sFam1SlowDacRawValidCh28,         --in  std_logic
      sFam1SlowDacRawValidCh29        => sFam1SlowDacRawValidCh29,         --in  std_logic
      sFam1SlowDacRawValidCh30        => sFam1SlowDacRawValidCh30,         --in  std_logic
      sFam1SlowDacRawValidCh31        => sFam1SlowDacRawValidCh31,         --in  std_logic
      sFam1SlowDacRawDataCh00         => sFam1SlowDacRawDataCh00,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh01         => sFam1SlowDacRawDataCh01,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh02         => sFam1SlowDacRawDataCh02,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh03         => sFam1SlowDacRawDataCh03,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh04         => sFam1SlowDacRawDataCh04,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh05         => sFam1SlowDacRawDataCh05,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh06         => sFam1SlowDacRawDataCh06,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh07         => sFam1SlowDacRawDataCh07,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh08         => sFam1SlowDacRawDataCh08,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh09         => sFam1SlowDacRawDataCh09,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh10         => sFam1SlowDacRawDataCh10,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh11         => sFam1SlowDacRawDataCh11,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh12         => sFam1SlowDacRawDataCh12,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh13         => sFam1SlowDacRawDataCh13,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh14         => sFam1SlowDacRawDataCh14,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh15         => sFam1SlowDacRawDataCh15,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh16         => sFam1SlowDacRawDataCh16,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh17         => sFam1SlowDacRawDataCh17,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh18         => sFam1SlowDacRawDataCh18,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh19         => sFam1SlowDacRawDataCh19,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh20         => sFam1SlowDacRawDataCh20,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh21         => sFam1SlowDacRawDataCh21,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh22         => sFam1SlowDacRawDataCh22,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh23         => sFam1SlowDacRawDataCh23,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh24         => sFam1SlowDacRawDataCh24,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh25         => sFam1SlowDacRawDataCh25,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh26         => sFam1SlowDacRawDataCh26,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh27         => sFam1SlowDacRawDataCh27,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh28         => sFam1SlowDacRawDataCh28,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh29         => sFam1SlowDacRawDataCh29,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh30         => sFam1SlowDacRawDataCh30,          --in  std_logic_vector(15:0)
      sFam1SlowDacRawDataCh31         => sFam1SlowDacRawDataCh31,          --in  std_logic_vector(15:0)
      aFam2DioInCh00                  => aFam2DioInCh00,                   --out std_logic
      aFam2DioInCh01                  => aFam2DioInCh01,                   --out std_logic
      aFam2DioInCh02                  => aFam2DioInCh02,                   --out std_logic
      aFam2DioInCh03                  => aFam2DioInCh03,                   --out std_logic
      aFam2DioInCh04                  => aFam2DioInCh04,                   --out std_logic
      aFam2DioInCh05                  => aFam2DioInCh05,                   --out std_logic
      aFam2DioInCh06                  => aFam2DioInCh06,                   --out std_logic
      aFam2DioInCh07                  => aFam2DioInCh07,                   --out std_logic
      aFam2DioInCh08                  => aFam2DioInCh08,                   --out std_logic
      aFam2DioInCh09                  => aFam2DioInCh09,                   --out std_logic
      aFam2DioInCh10                  => aFam2DioInCh10,                   --out std_logic
      aFam2DioInCh11                  => aFam2DioInCh11,                   --out std_logic
      aFam2DioInCh12                  => aFam2DioInCh12,                   --out std_logic
      aFam2DioInCh13                  => aFam2DioInCh13,                   --out std_logic
      aFam2DioInCh14                  => aFam2DioInCh14,                   --out std_logic
      aFam2DioInCh15                  => aFam2DioInCh15,                   --out std_logic
      aFam2DioInCh16                  => aFam2DioInCh16,                   --out std_logic
      aFam2DioInCh17                  => aFam2DioInCh17,                   --out std_logic
      aFam2DioInCh18                  => aFam2DioInCh18,                   --out std_logic
      aFam2DioInCh19                  => aFam2DioInCh19,                   --out std_logic
      aFam2DioInCh20                  => aFam2DioInCh20,                   --out std_logic
      aFam2DioInCh21                  => aFam2DioInCh21,                   --out std_logic
      aFam2DioInCh22                  => aFam2DioInCh22,                   --out std_logic
      aFam2DioInCh23                  => aFam2DioInCh23,                   --out std_logic
      aFam2DioInCh24                  => aFam2DioInCh24,                   --out std_logic
      aFam2DioInCh25                  => aFam2DioInCh25,                   --out std_logic
      aFam2DioInCh26                  => aFam2DioInCh26,                   --out std_logic
      aFam2DioInCh27                  => aFam2DioInCh27,                   --out std_logic
      aFam2DioInCh28                  => aFam2DioInCh28,                   --out std_logic
      aFam2DioInCh29                  => aFam2DioInCh29,                   --out std_logic
      aFam2DioInCh30                  => aFam2DioInCh30,                   --out std_logic
      aFam2DioInCh31                  => aFam2DioInCh31,                   --out std_logic
      aFam2DioOutCh00                 => aFam2DioOutCh00,                  --in  std_logic
      aFam2DioOutCh01                 => aFam2DioOutCh01,                  --in  std_logic
      aFam2DioOutCh02                 => aFam2DioOutCh02,                  --in  std_logic
      aFam2DioOutCh03                 => aFam2DioOutCh03,                  --in  std_logic
      aFam2DioOutCh04                 => aFam2DioOutCh04,                  --in  std_logic
      aFam2DioOutCh05                 => aFam2DioOutCh05,                  --in  std_logic
      aFam2DioOutCh06                 => aFam2DioOutCh06,                  --in  std_logic
      aFam2DioOutCh07                 => aFam2DioOutCh07,                  --in  std_logic
      aFam2DioOutCh08                 => aFam2DioOutCh08,                  --in  std_logic
      aFam2DioOutCh09                 => aFam2DioOutCh09,                  --in  std_logic
      aFam2DioOutCh10                 => aFam2DioOutCh10,                  --in  std_logic
      aFam2DioOutCh11                 => aFam2DioOutCh11,                  --in  std_logic
      aFam2DioOutCh12                 => aFam2DioOutCh12,                  --in  std_logic
      aFam2DioOutCh13                 => aFam2DioOutCh13,                  --in  std_logic
      aFam2DioOutCh14                 => aFam2DioOutCh14,                  --in  std_logic
      aFam2DioOutCh15                 => aFam2DioOutCh15,                  --in  std_logic
      aFam2DioOutCh16                 => aFam2DioOutCh16,                  --in  std_logic
      aFam2DioOutCh17                 => aFam2DioOutCh17,                  --in  std_logic
      aFam2DioOutCh18                 => aFam2DioOutCh18,                  --in  std_logic
      aFam2DioOutCh19                 => aFam2DioOutCh19,                  --in  std_logic
      aFam2DioOutCh20                 => aFam2DioOutCh20,                  --in  std_logic
      aFam2DioOutCh21                 => aFam2DioOutCh21,                  --in  std_logic
      aFam2DioOutCh22                 => aFam2DioOutCh22,                  --in  std_logic
      aFam2DioOutCh23                 => aFam2DioOutCh23,                  --in  std_logic
      aFam2DioOutCh24                 => aFam2DioOutCh24,                  --in  std_logic
      aFam2DioOutCh25                 => aFam2DioOutCh25,                  --in  std_logic
      aFam2DioOutCh26                 => aFam2DioOutCh26,                  --in  std_logic
      aFam2DioOutCh27                 => aFam2DioOutCh27,                  --in  std_logic
      aFam2DioOutCh28                 => aFam2DioOutCh28,                  --in  std_logic
      aFam2DioOutCh29                 => aFam2DioOutCh29,                  --in  std_logic
      aFam2DioOutCh30                 => aFam2DioOutCh30,                  --in  std_logic
      aFam2DioOutCh31                 => aFam2DioOutCh31,                  --in  std_logic
      sFam2FastDacFxpReady            => sFam2FastDacFxpReady,             --out std_logic
      sFam2FastDacFxpStart            => sFam2FastDacFxpStart,             --in  std_logic
      sFam2FastDacFxpValidCh00        => sFam2FastDacFxpValidCh00,         --in  std_logic
      sFam2FastDacFxpValidCh01        => sFam2FastDacFxpValidCh01,         --in  std_logic
      sFam2FastDacFxpValidCh02        => sFam2FastDacFxpValidCh02,         --in  std_logic
      sFam2FastDacFxpValidCh03        => sFam2FastDacFxpValidCh03,         --in  std_logic
      sFam2FastDacFxpValidCh04        => sFam2FastDacFxpValidCh04,         --in  std_logic
      sFam2FastDacFxpValidCh05        => sFam2FastDacFxpValidCh05,         --in  std_logic
      sFam2FastDacFxpValidCh06        => sFam2FastDacFxpValidCh06,         --in  std_logic
      sFam2FastDacFxpValidCh07        => sFam2FastDacFxpValidCh07,         --in  std_logic
      sFam2FastDacFxpValidCh08        => sFam2FastDacFxpValidCh08,         --in  std_logic
      sFam2FastDacFxpValidCh09        => sFam2FastDacFxpValidCh09,         --in  std_logic
      sFam2FastDacFxpValidCh10        => sFam2FastDacFxpValidCh10,         --in  std_logic
      sFam2FastDacFxpValidCh11        => sFam2FastDacFxpValidCh11,         --in  std_logic
      sFam2FastDacFxpValidCh12        => sFam2FastDacFxpValidCh12,         --in  std_logic
      sFam2FastDacFxpValidCh13        => sFam2FastDacFxpValidCh13,         --in  std_logic
      sFam2FastDacFxpValidCh14        => sFam2FastDacFxpValidCh14,         --in  std_logic
      sFam2FastDacFxpValidCh15        => sFam2FastDacFxpValidCh15,         --in  std_logic
      sFam2FastDacFxpValidCh16        => sFam2FastDacFxpValidCh16,         --in  std_logic
      sFam2FastDacFxpValidCh17        => sFam2FastDacFxpValidCh17,         --in  std_logic
      sFam2FastDacFxpValidCh18        => sFam2FastDacFxpValidCh18,         --in  std_logic
      sFam2FastDacFxpValidCh19        => sFam2FastDacFxpValidCh19,         --in  std_logic
      sFam2FastDacFxpValidCh20        => sFam2FastDacFxpValidCh20,         --in  std_logic
      sFam2FastDacFxpValidCh21        => sFam2FastDacFxpValidCh21,         --in  std_logic
      sFam2FastDacFxpValidCh22        => sFam2FastDacFxpValidCh22,         --in  std_logic
      sFam2FastDacFxpValidCh23        => sFam2FastDacFxpValidCh23,         --in  std_logic
      sFam2FastDacFxpValidCh24        => sFam2FastDacFxpValidCh24,         --in  std_logic
      sFam2FastDacFxpValidCh25        => sFam2FastDacFxpValidCh25,         --in  std_logic
      sFam2FastDacFxpValidCh26        => sFam2FastDacFxpValidCh26,         --in  std_logic
      sFam2FastDacFxpValidCh27        => sFam2FastDacFxpValidCh27,         --in  std_logic
      sFam2FastDacFxpValidCh28        => sFam2FastDacFxpValidCh28,         --in  std_logic
      sFam2FastDacFxpValidCh29        => sFam2FastDacFxpValidCh29,         --in  std_logic
      sFam2FastDacFxpValidCh30        => sFam2FastDacFxpValidCh30,         --in  std_logic
      sFam2FastDacFxpValidCh31        => sFam2FastDacFxpValidCh31,         --in  std_logic
      sFam2FastDacFxpDataCh00         => sFam2FastDacFxpDataCh00,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh01         => sFam2FastDacFxpDataCh01,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh02         => sFam2FastDacFxpDataCh02,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh03         => sFam2FastDacFxpDataCh03,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh04         => sFam2FastDacFxpDataCh04,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh05         => sFam2FastDacFxpDataCh05,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh06         => sFam2FastDacFxpDataCh06,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh07         => sFam2FastDacFxpDataCh07,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh08         => sFam2FastDacFxpDataCh08,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh09         => sFam2FastDacFxpDataCh09,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh10         => sFam2FastDacFxpDataCh10,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh11         => sFam2FastDacFxpDataCh11,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh12         => sFam2FastDacFxpDataCh12,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh13         => sFam2FastDacFxpDataCh13,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh14         => sFam2FastDacFxpDataCh14,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh15         => sFam2FastDacFxpDataCh15,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh16         => sFam2FastDacFxpDataCh16,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh17         => sFam2FastDacFxpDataCh17,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh18         => sFam2FastDacFxpDataCh18,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh19         => sFam2FastDacFxpDataCh19,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh20         => sFam2FastDacFxpDataCh20,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh21         => sFam2FastDacFxpDataCh21,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh22         => sFam2FastDacFxpDataCh22,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh23         => sFam2FastDacFxpDataCh23,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh24         => sFam2FastDacFxpDataCh24,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh25         => sFam2FastDacFxpDataCh25,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh26         => sFam2FastDacFxpDataCh26,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh27         => sFam2FastDacFxpDataCh27,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh28         => sFam2FastDacFxpDataCh28,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh29         => sFam2FastDacFxpDataCh29,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh30         => sFam2FastDacFxpDataCh30,          --in  std_logic_vector(19:0)
      sFam2FastDacFxpDataCh31         => sFam2FastDacFxpDataCh31,          --in  std_logic_vector(19:0)
      sFam2FastDacRawReady            => sFam2FastDacRawReady,             --out std_logic
      sFam2FastDacRawStart            => sFam2FastDacRawStart,             --in  std_logic
      sFam2FastDacRawValidCh00        => sFam2FastDacRawValidCh00,         --in  std_logic
      sFam2FastDacRawValidCh01        => sFam2FastDacRawValidCh01,         --in  std_logic
      sFam2FastDacRawValidCh02        => sFam2FastDacRawValidCh02,         --in  std_logic
      sFam2FastDacRawValidCh03        => sFam2FastDacRawValidCh03,         --in  std_logic
      sFam2FastDacRawValidCh04        => sFam2FastDacRawValidCh04,         --in  std_logic
      sFam2FastDacRawValidCh05        => sFam2FastDacRawValidCh05,         --in  std_logic
      sFam2FastDacRawValidCh06        => sFam2FastDacRawValidCh06,         --in  std_logic
      sFam2FastDacRawValidCh07        => sFam2FastDacRawValidCh07,         --in  std_logic
      sFam2FastDacRawValidCh08        => sFam2FastDacRawValidCh08,         --in  std_logic
      sFam2FastDacRawValidCh09        => sFam2FastDacRawValidCh09,         --in  std_logic
      sFam2FastDacRawValidCh10        => sFam2FastDacRawValidCh10,         --in  std_logic
      sFam2FastDacRawValidCh11        => sFam2FastDacRawValidCh11,         --in  std_logic
      sFam2FastDacRawValidCh12        => sFam2FastDacRawValidCh12,         --in  std_logic
      sFam2FastDacRawValidCh13        => sFam2FastDacRawValidCh13,         --in  std_logic
      sFam2FastDacRawValidCh14        => sFam2FastDacRawValidCh14,         --in  std_logic
      sFam2FastDacRawValidCh15        => sFam2FastDacRawValidCh15,         --in  std_logic
      sFam2FastDacRawValidCh16        => sFam2FastDacRawValidCh16,         --in  std_logic
      sFam2FastDacRawValidCh17        => sFam2FastDacRawValidCh17,         --in  std_logic
      sFam2FastDacRawValidCh18        => sFam2FastDacRawValidCh18,         --in  std_logic
      sFam2FastDacRawValidCh19        => sFam2FastDacRawValidCh19,         --in  std_logic
      sFam2FastDacRawValidCh20        => sFam2FastDacRawValidCh20,         --in  std_logic
      sFam2FastDacRawValidCh21        => sFam2FastDacRawValidCh21,         --in  std_logic
      sFam2FastDacRawValidCh22        => sFam2FastDacRawValidCh22,         --in  std_logic
      sFam2FastDacRawValidCh23        => sFam2FastDacRawValidCh23,         --in  std_logic
      sFam2FastDacRawValidCh24        => sFam2FastDacRawValidCh24,         --in  std_logic
      sFam2FastDacRawValidCh25        => sFam2FastDacRawValidCh25,         --in  std_logic
      sFam2FastDacRawValidCh26        => sFam2FastDacRawValidCh26,         --in  std_logic
      sFam2FastDacRawValidCh27        => sFam2FastDacRawValidCh27,         --in  std_logic
      sFam2FastDacRawValidCh28        => sFam2FastDacRawValidCh28,         --in  std_logic
      sFam2FastDacRawValidCh29        => sFam2FastDacRawValidCh29,         --in  std_logic
      sFam2FastDacRawValidCh30        => sFam2FastDacRawValidCh30,         --in  std_logic
      sFam2FastDacRawValidCh31        => sFam2FastDacRawValidCh31,         --in  std_logic
      sFam2FastDacRawDataCh00         => sFam2FastDacRawDataCh00,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh01         => sFam2FastDacRawDataCh01,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh02         => sFam2FastDacRawDataCh02,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh03         => sFam2FastDacRawDataCh03,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh04         => sFam2FastDacRawDataCh04,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh05         => sFam2FastDacRawDataCh05,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh06         => sFam2FastDacRawDataCh06,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh07         => sFam2FastDacRawDataCh07,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh08         => sFam2FastDacRawDataCh08,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh09         => sFam2FastDacRawDataCh09,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh10         => sFam2FastDacRawDataCh10,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh11         => sFam2FastDacRawDataCh11,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh12         => sFam2FastDacRawDataCh12,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh13         => sFam2FastDacRawDataCh13,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh14         => sFam2FastDacRawDataCh14,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh15         => sFam2FastDacRawDataCh15,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh16         => sFam2FastDacRawDataCh16,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh17         => sFam2FastDacRawDataCh17,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh18         => sFam2FastDacRawDataCh18,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh19         => sFam2FastDacRawDataCh19,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh20         => sFam2FastDacRawDataCh20,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh21         => sFam2FastDacRawDataCh21,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh22         => sFam2FastDacRawDataCh22,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh23         => sFam2FastDacRawDataCh23,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh24         => sFam2FastDacRawDataCh24,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh25         => sFam2FastDacRawDataCh25,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh26         => sFam2FastDacRawDataCh26,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh27         => sFam2FastDacRawDataCh27,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh28         => sFam2FastDacRawDataCh28,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh29         => sFam2FastDacRawDataCh29,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh30         => sFam2FastDacRawDataCh30,          --in  std_logic_vector(15:0)
      sFam2FastDacRawDataCh31         => sFam2FastDacRawDataCh31);         --in  std_logic_vector(15:0)

end rtl;
