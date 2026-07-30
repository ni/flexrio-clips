-------------------------------------------------------------------------------
--
-- File: Ni6569BasicClipAllInTop.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 14 June 2019
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
--  Top level CLIP file for LabVIEW FPGA.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity Ni6569BasicClipAllInTop is
  port (
    ---------------------------------------------------------------------------
    --                     FlexRIOIoSocketType3_v1                           --
    ---------------------------------------------------------------------------
    ------------
    -- FAM IO --
    ------------
    aDiffGpio_p                        : inout std_logic_vector(69 downto 0);
    aDiffGpio_n                        : inout std_logic_vector(69 downto 0);
    aSeGpio                            : inout std_logic_vector(29 downto 0);
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
    -- Diagram Data Clocks
    DeviceClkRxLV       : out std_logic;

    -- This is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.
    --vhook_nowarn TopLevelClk80
    TopLevelClk80                      : in  std_logic;
    xIoModuleReady                     : out std_logic;
    xIoModuleErrorCode                 : out std_logic_vector(31 downto 0);

    -- Single-ended lines
    aSeDir0             : in std_logic;
    aSeDir1             : in std_logic;
    aSeDir2             : in std_logic;
    aSeDir3             : in std_logic;
    aSeDir4             : in std_logic;
    aSeDir5             : in std_logic;
    aSeDir6             : in std_logic;
    aSeDir7             : in std_logic;
    aSeInput0           : out std_logic;
    aSeInput1           : out std_logic;
    aSeInput2           : out std_logic;
    aSeInput3           : out std_logic;
    aSeInput4           : out std_logic;
    aSeInput5           : out std_logic;
    aSeInput6           : out std_logic;
    aSeInput7           : out std_logic;
    aSeOutput0          : in std_logic;
    aSeOutput1          : in std_logic;
    aSeOutput2          : in std_logic;
    aSeOutput3          : in std_logic;
    aSeOutput4          : in std_logic;
    aSeOutput5          : in std_logic;
    aSeOutput6          : in std_logic;
    aSeOutput7          : in std_logic;

    -- LVDS Data Input
    rLvdsInput          : out std_logic_vector(63 downto 0);

    -- LVDS PFI Lines
    aLvdsPfiDir0        : in std_logic;
    aLvdsPfiDir1        : in std_logic;
    aLvdsPfiInput0      : out std_logic;
    aLvdsPfiInput1      : out std_logic;
    aLvdsPfiOutput0     : in std_logic;
    aLvdsPfiOutput1     : in std_logic;

    -- LVDS Data IDELAY
    rRxCntValOut0       : out std_logic_vector(15 downto 0);
    rRxCntValOut1       : out std_logic_vector(15 downto 0);
    rRxCntValOut2       : out std_logic_vector(15 downto 0);
    rRxCntValOut3       : out std_logic_vector(15 downto 0);
    rRxCntValOut4       : out std_logic_vector(15 downto 0);
    rRxCntValOut5       : out std_logic_vector(15 downto 0);
    rRxCntValOut6       : out std_logic_vector(15 downto 0);
    rRxCntValOut7       : out std_logic_vector(15 downto 0);
    rRxCntValOut8       : out std_logic_vector(15 downto 0);
    rRxCntValOut9       : out std_logic_vector(15 downto 0);
    rRxCntValOut10      : out std_logic_vector(15 downto 0);
    rRxCntValOut11      : out std_logic_vector(15 downto 0);
    rRxCntValOut12      : out std_logic_vector(15 downto 0);
    rRxCntValOut13      : out std_logic_vector(15 downto 0);
    rRxCntValOut14      : out std_logic_vector(15 downto 0);
    rRxCntValOut15      : out std_logic_vector(15 downto 0);
    rRxCntValOut16      : out std_logic_vector(15 downto 0);
    rRxCntValOut17      : out std_logic_vector(15 downto 0);
    rRxCntValOut18      : out std_logic_vector(15 downto 0);
    rRxCntValOut19      : out std_logic_vector(15 downto 0);
    rRxCntValOut20      : out std_logic_vector(15 downto 0);
    rRxCntValOut21      : out std_logic_vector(15 downto 0);
    rRxCntValOut22      : out std_logic_vector(15 downto 0);
    rRxCntValOut23      : out std_logic_vector(15 downto 0);
    rRxCntValOut24      : out std_logic_vector(15 downto 0);
    rRxCntValOut25      : out std_logic_vector(15 downto 0);
    rRxCntValOut26      : out std_logic_vector(15 downto 0);
    rRxCntValOut27      : out std_logic_vector(15 downto 0);
    rRxCntValOut28      : out std_logic_vector(15 downto 0);
    rRxCntValOut29      : out std_logic_vector(15 downto 0);
    rRxCntValOut30      : out std_logic_vector(15 downto 0);
    rRxCntValOut31      : out std_logic_vector(15 downto 0);
    rRxCntValOut32      : out std_logic_vector(15 downto 0);
    rRxCntValOut33      : out std_logic_vector(15 downto 0);
    rRxCntValOut34      : out std_logic_vector(15 downto 0);
    rRxCntValOut35      : out std_logic_vector(15 downto 0);
    rRxCntValOut36      : out std_logic_vector(15 downto 0);
    rRxCntValOut37      : out std_logic_vector(15 downto 0);
    rRxCntValOut38      : out std_logic_vector(15 downto 0);
    rRxCntValOut39      : out std_logic_vector(15 downto 0);
    rRxCntValOut40      : out std_logic_vector(15 downto 0);
    rRxCntValOut41      : out std_logic_vector(15 downto 0);
    rRxCntValOut42      : out std_logic_vector(15 downto 0);
    rRxCntValOut43      : out std_logic_vector(15 downto 0);
    rRxCntValOut44      : out std_logic_vector(15 downto 0);
    rRxCntValOut45      : out std_logic_vector(15 downto 0);
    rRxCntValOut46      : out std_logic_vector(15 downto 0);
    rRxCntValOut47      : out std_logic_vector(15 downto 0);
    rRxCntValOut48      : out std_logic_vector(15 downto 0);
    rRxCntValOut49      : out std_logic_vector(15 downto 0);
    rRxCntValOut50      : out std_logic_vector(15 downto 0);
    rRxCntValOut51      : out std_logic_vector(15 downto 0);
    rRxCntValOut52      : out std_logic_vector(15 downto 0);
    rRxCntValOut53      : out std_logic_vector(15 downto 0);
    rRxCntValOut54      : out std_logic_vector(15 downto 0);
    rRxCntValOut55      : out std_logic_vector(15 downto 0);
    rRxCntValOut56      : out std_logic_vector(15 downto 0);
    rRxCntValOut57      : out std_logic_vector(15 downto 0);
    rRxCntValOut58      : out std_logic_vector(15 downto 0);
    rRxCntValOut59      : out std_logic_vector(15 downto 0);
    rRxCntValOut60      : out std_logic_vector(15 downto 0);
    rRxCntValOut61      : out std_logic_vector(15 downto 0);
    rRxCntValOut62      : out std_logic_vector(15 downto 0);
    rRxCntValOut63      : out std_logic_vector(15 downto 0);
    rRxInc0             : in std_logic;
    rRxInc1             : in std_logic;
    rRxInc2             : in std_logic;
    rRxInc3             : in std_logic;
    rRxInc4             : in std_logic;
    rRxInc5             : in std_logic;
    rRxInc6             : in std_logic;
    rRxInc7             : in std_logic;
    rRxInc8             : in std_logic;
    rRxInc9             : in std_logic;
    rRxInc10            : in std_logic;
    rRxInc11            : in std_logic;
    rRxInc12            : in std_logic;
    rRxInc13            : in std_logic;
    rRxInc14            : in std_logic;
    rRxInc15            : in std_logic;
    rRxInc16            : in std_logic;
    rRxInc17            : in std_logic;
    rRxInc18            : in std_logic;
    rRxInc19            : in std_logic;
    rRxInc20            : in std_logic;
    rRxInc21            : in std_logic;
    rRxInc22            : in std_logic;
    rRxInc23            : in std_logic;
    rRxInc24            : in std_logic;
    rRxInc25            : in std_logic;
    rRxInc26            : in std_logic;
    rRxInc27            : in std_logic;
    rRxInc28            : in std_logic;
    rRxInc29            : in std_logic;
    rRxInc30            : in std_logic;
    rRxInc31            : in std_logic;
    rRxInc32            : in std_logic;
    rRxInc33            : in std_logic;
    rRxInc34            : in std_logic;
    rRxInc35            : in std_logic;
    rRxInc36            : in std_logic;
    rRxInc37            : in std_logic;
    rRxInc38            : in std_logic;
    rRxInc39            : in std_logic;
    rRxInc40            : in std_logic;
    rRxInc41            : in std_logic;
    rRxInc42            : in std_logic;
    rRxInc43            : in std_logic;
    rRxInc44            : in std_logic;
    rRxInc45            : in std_logic;
    rRxInc46            : in std_logic;
    rRxInc47            : in std_logic;
    rRxInc48            : in std_logic;
    rRxInc49            : in std_logic;
    rRxInc50            : in std_logic;
    rRxInc51            : in std_logic;
    rRxInc52            : in std_logic;
    rRxInc53            : in std_logic;
    rRxInc54            : in std_logic;
    rRxInc55            : in std_logic;
    rRxInc56            : in std_logic;
    rRxInc57            : in std_logic;
    rRxInc58            : in std_logic;
    rRxInc59            : in std_logic;
    rRxInc60            : in std_logic;
    rRxInc61            : in std_logic;
    rRxInc62            : in std_logic;
    rRxInc63            : in std_logic;
    rRxClkDelayEn0      : in std_logic;
    rRxClkDelayEn1      : in std_logic;
    rRxClkDelayEn2      : in std_logic;
    rRxClkDelayEn3      : in std_logic;
    rRxClkDelayEn4      : in std_logic;
    rRxClkDelayEn5      : in std_logic;
    rRxClkDelayEn6      : in std_logic;
    rRxClkDelayEn7      : in std_logic;
    rRxClkDelayEn8      : in std_logic;
    rRxClkDelayEn9      : in std_logic;
    rRxClkDelayEn10     : in std_logic;
    rRxClkDelayEn11     : in std_logic;
    rRxClkDelayEn12     : in std_logic;
    rRxClkDelayEn13     : in std_logic;
    rRxClkDelayEn14     : in std_logic;
    rRxClkDelayEn15     : in std_logic;
    rRxClkDelayEn16     : in std_logic;
    rRxClkDelayEn17     : in std_logic;
    rRxClkDelayEn18     : in std_logic;
    rRxClkDelayEn19     : in std_logic;
    rRxClkDelayEn20     : in std_logic;
    rRxClkDelayEn21     : in std_logic;
    rRxClkDelayEn22     : in std_logic;
    rRxClkDelayEn23     : in std_logic;
    rRxClkDelayEn24     : in std_logic;
    rRxClkDelayEn25     : in std_logic;
    rRxClkDelayEn26     : in std_logic;
    rRxClkDelayEn27     : in std_logic;
    rRxClkDelayEn28     : in std_logic;
    rRxClkDelayEn29     : in std_logic;
    rRxClkDelayEn30     : in std_logic;
    rRxClkDelayEn31     : in std_logic;
    rRxClkDelayEn32     : in std_logic;
    rRxClkDelayEn33     : in std_logic;
    rRxClkDelayEn34     : in std_logic;
    rRxClkDelayEn35     : in std_logic;
    rRxClkDelayEn36     : in std_logic;
    rRxClkDelayEn37     : in std_logic;
    rRxClkDelayEn38     : in std_logic;
    rRxClkDelayEn39     : in std_logic;
    rRxClkDelayEn40     : in std_logic;
    rRxClkDelayEn41     : in std_logic;
    rRxClkDelayEn42     : in std_logic;
    rRxClkDelayEn43     : in std_logic;
    rRxClkDelayEn44     : in std_logic;
    rRxClkDelayEn45     : in std_logic;
    rRxClkDelayEn46     : in std_logic;
    rRxClkDelayEn47     : in std_logic;
    rRxClkDelayEn48     : in std_logic;
    rRxClkDelayEn49     : in std_logic;
    rRxClkDelayEn50     : in std_logic;
    rRxClkDelayEn51     : in std_logic;
    rRxClkDelayEn52     : in std_logic;
    rRxClkDelayEn53     : in std_logic;
    rRxClkDelayEn54     : in std_logic;
    rRxClkDelayEn55     : in std_logic;
    rRxClkDelayEn56     : in std_logic;
    rRxClkDelayEn57     : in std_logic;
    rRxClkDelayEn58     : in std_logic;
    rRxClkDelayEn59     : in std_logic;
    rRxClkDelayEn60     : in std_logic;
    rRxClkDelayEn61     : in std_logic;
    rRxClkDelayEn62     : in std_logic;
    rRxClkDelayEn63     : in std_logic;
    rRxDlyCount0        : in std_logic_vector(15 downto 0);
    rRxDlyCount1        : in std_logic_vector(15 downto 0);
    rRxDlyCount2        : in std_logic_vector(15 downto 0);
    rRxDlyCount3        : in std_logic_vector(15 downto 0);
    rRxDlyCount4        : in std_logic_vector(15 downto 0);
    rRxDlyCount5        : in std_logic_vector(15 downto 0);
    rRxDlyCount6        : in std_logic_vector(15 downto 0);
    rRxDlyCount7        : in std_logic_vector(15 downto 0);
    rRxDlyCount8        : in std_logic_vector(15 downto 0);
    rRxDlyCount9        : in std_logic_vector(15 downto 0);
    rRxDlyCount10       : in std_logic_vector(15 downto 0);
    rRxDlyCount11       : in std_logic_vector(15 downto 0);
    rRxDlyCount12       : in std_logic_vector(15 downto 0);
    rRxDlyCount13       : in std_logic_vector(15 downto 0);
    rRxDlyCount14       : in std_logic_vector(15 downto 0);
    rRxDlyCount15       : in std_logic_vector(15 downto 0);
    rRxDlyCount16       : in std_logic_vector(15 downto 0);
    rRxDlyCount17       : in std_logic_vector(15 downto 0);
    rRxDlyCount18       : in std_logic_vector(15 downto 0);
    rRxDlyCount19       : in std_logic_vector(15 downto 0);
    rRxDlyCount20       : in std_logic_vector(15 downto 0);
    rRxDlyCount21       : in std_logic_vector(15 downto 0);
    rRxDlyCount22       : in std_logic_vector(15 downto 0);
    rRxDlyCount23       : in std_logic_vector(15 downto 0);
    rRxDlyCount24       : in std_logic_vector(15 downto 0);
    rRxDlyCount25       : in std_logic_vector(15 downto 0);
    rRxDlyCount26       : in std_logic_vector(15 downto 0);
    rRxDlyCount27       : in std_logic_vector(15 downto 0);
    rRxDlyCount28       : in std_logic_vector(15 downto 0);
    rRxDlyCount29       : in std_logic_vector(15 downto 0);
    rRxDlyCount30       : in std_logic_vector(15 downto 0);
    rRxDlyCount31       : in std_logic_vector(15 downto 0);
    rRxDlyCount32       : in std_logic_vector(15 downto 0);
    rRxDlyCount33       : in std_logic_vector(15 downto 0);
    rRxDlyCount34       : in std_logic_vector(15 downto 0);
    rRxDlyCount35       : in std_logic_vector(15 downto 0);
    rRxDlyCount36       : in std_logic_vector(15 downto 0);
    rRxDlyCount37       : in std_logic_vector(15 downto 0);
    rRxDlyCount38       : in std_logic_vector(15 downto 0);
    rRxDlyCount39       : in std_logic_vector(15 downto 0);
    rRxDlyCount40       : in std_logic_vector(15 downto 0);
    rRxDlyCount41       : in std_logic_vector(15 downto 0);
    rRxDlyCount42       : in std_logic_vector(15 downto 0);
    rRxDlyCount43       : in std_logic_vector(15 downto 0);
    rRxDlyCount44       : in std_logic_vector(15 downto 0);
    rRxDlyCount45       : in std_logic_vector(15 downto 0);
    rRxDlyCount46       : in std_logic_vector(15 downto 0);
    rRxDlyCount47       : in std_logic_vector(15 downto 0);
    rRxDlyCount48       : in std_logic_vector(15 downto 0);
    rRxDlyCount49       : in std_logic_vector(15 downto 0);
    rRxDlyCount50       : in std_logic_vector(15 downto 0);
    rRxDlyCount51       : in std_logic_vector(15 downto 0);
    rRxDlyCount52       : in std_logic_vector(15 downto 0);
    rRxDlyCount53       : in std_logic_vector(15 downto 0);
    rRxDlyCount54       : in std_logic_vector(15 downto 0);
    rRxDlyCount55       : in std_logic_vector(15 downto 0);
    rRxDlyCount56       : in std_logic_vector(15 downto 0);
    rRxDlyCount57       : in std_logic_vector(15 downto 0);
    rRxDlyCount58       : in std_logic_vector(15 downto 0);
    rRxDlyCount59       : in std_logic_vector(15 downto 0);
    rRxDlyCount60       : in std_logic_vector(15 downto 0);
    rRxDlyCount61       : in std_logic_vector(15 downto 0);
    rRxDlyCount62       : in std_logic_vector(15 downto 0);
    rRxDlyCount63       : in std_logic_vector(15 downto 0);
    rRxIncDecReady0     : out std_logic;
    rRxIncDecReady1     : out std_logic;
    rRxIncDecReady2     : out std_logic;
    rRxIncDecReady3     : out std_logic;
    rRxIncDecReady4     : out std_logic;
    rRxIncDecReady5     : out std_logic;
    rRxIncDecReady6     : out std_logic;
    rRxIncDecReady7     : out std_logic;
    rRxIncDecReady8     : out std_logic;
    rRxIncDecReady9     : out std_logic;
    rRxIncDecReady10    : out std_logic;
    rRxIncDecReady11    : out std_logic;
    rRxIncDecReady12    : out std_logic;
    rRxIncDecReady13    : out std_logic;
    rRxIncDecReady14    : out std_logic;
    rRxIncDecReady15    : out std_logic;
    rRxIncDecReady16    : out std_logic;
    rRxIncDecReady17    : out std_logic;
    rRxIncDecReady18    : out std_logic;
    rRxIncDecReady19    : out std_logic;
    rRxIncDecReady20    : out std_logic;
    rRxIncDecReady21    : out std_logic;
    rRxIncDecReady22    : out std_logic;
    rRxIncDecReady23    : out std_logic;
    rRxIncDecReady24    : out std_logic;
    rRxIncDecReady25    : out std_logic;
    rRxIncDecReady26    : out std_logic;
    rRxIncDecReady27    : out std_logic;
    rRxIncDecReady28    : out std_logic;
    rRxIncDecReady29    : out std_logic;
    rRxIncDecReady30    : out std_logic;
    rRxIncDecReady31    : out std_logic;
    rRxIncDecReady32    : out std_logic;
    rRxIncDecReady33    : out std_logic;
    rRxIncDecReady34    : out std_logic;
    rRxIncDecReady35    : out std_logic;
    rRxIncDecReady36    : out std_logic;
    rRxIncDecReady37    : out std_logic;
    rRxIncDecReady38    : out std_logic;
    rRxIncDecReady39    : out std_logic;
    rRxIncDecReady40    : out std_logic;
    rRxIncDecReady41    : out std_logic;
    rRxIncDecReady42    : out std_logic;
    rRxIncDecReady43    : out std_logic;
    rRxIncDecReady44    : out std_logic;
    rRxIncDecReady45    : out std_logic;
    rRxIncDecReady46    : out std_logic;
    rRxIncDecReady47    : out std_logic;
    rRxIncDecReady48    : out std_logic;
    rRxIncDecReady49    : out std_logic;
    rRxIncDecReady50    : out std_logic;
    rRxIncDecReady51    : out std_logic;
    rRxIncDecReady52    : out std_logic;
    rRxIncDecReady53    : out std_logic;
    rRxIncDecReady54    : out std_logic;
    rRxIncDecReady55    : out std_logic;
    rRxIncDecReady56    : out std_logic;
    rRxIncDecReady57    : out std_logic;
    rRxIncDecReady58    : out std_logic;
    rRxIncDecReady59    : out std_logic;
    rRxIncDecReady60    : out std_logic;
    rRxIncDecReady61    : out std_logic;
    rRxIncDecReady62    : out std_logic;
    rRxIncDecReady63    : out std_logic
    );
end entity Ni6569BasicClipAllInTop;

architecture rtl of Ni6569BasicClipAllInTop is

  component Ni6569BasicClipAllInFl
    port (
      aDiffGpio_p                     : inout std_logic_vector(69 downto 0);
      aDiffGpio_n                     : inout std_logic_vector(69 downto 0);
      aSeGpio                         : inout std_logic_vector(29 downto 0);
      xIoOutputEnable                 : in  std_logic;
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
      DeviceClkRxLV                   : out std_logic;
      aSeDir0                         : in  std_logic;
      aSeDir1                         : in  std_logic;
      aSeDir2                         : in  std_logic;
      aSeDir3                         : in  std_logic;
      aSeDir4                         : in  std_logic;
      aSeDir5                         : in  std_logic;
      aSeDir6                         : in  std_logic;
      aSeDir7                         : in  std_logic;
      aSeInput0                       : out std_logic;
      aSeInput1                       : out std_logic;
      aSeInput2                       : out std_logic;
      aSeInput3                       : out std_logic;
      aSeInput4                       : out std_logic;
      aSeInput5                       : out std_logic;
      aSeInput6                       : out std_logic;
      aSeInput7                       : out std_logic;
      aSeOutput0                      : in  std_logic;
      aSeOutput1                      : in  std_logic;
      aSeOutput2                      : in  std_logic;
      aSeOutput3                      : in  std_logic;
      aSeOutput4                      : in  std_logic;
      aSeOutput5                      : in  std_logic;
      aSeOutput6                      : in  std_logic;
      aSeOutput7                      : in  std_logic;
      rLvdsInput                      : out std_logic_vector(63 downto 0);
      rRxCntValOut0                   : out std_logic_vector(15 downto 0);
      rRxCntValOut1                   : out std_logic_vector(15 downto 0);
      rRxCntValOut2                   : out std_logic_vector(15 downto 0);
      rRxCntValOut3                   : out std_logic_vector(15 downto 0);
      rRxCntValOut4                   : out std_logic_vector(15 downto 0);
      rRxCntValOut5                   : out std_logic_vector(15 downto 0);
      rRxCntValOut6                   : out std_logic_vector(15 downto 0);
      rRxCntValOut7                   : out std_logic_vector(15 downto 0);
      rRxCntValOut8                   : out std_logic_vector(15 downto 0);
      rRxCntValOut9                   : out std_logic_vector(15 downto 0);
      rRxCntValOut10                  : out std_logic_vector(15 downto 0);
      rRxCntValOut11                  : out std_logic_vector(15 downto 0);
      rRxCntValOut12                  : out std_logic_vector(15 downto 0);
      rRxCntValOut13                  : out std_logic_vector(15 downto 0);
      rRxCntValOut14                  : out std_logic_vector(15 downto 0);
      rRxCntValOut15                  : out std_logic_vector(15 downto 0);
      rRxCntValOut16                  : out std_logic_vector(15 downto 0);
      rRxCntValOut17                  : out std_logic_vector(15 downto 0);
      rRxCntValOut18                  : out std_logic_vector(15 downto 0);
      rRxCntValOut19                  : out std_logic_vector(15 downto 0);
      rRxCntValOut20                  : out std_logic_vector(15 downto 0);
      rRxCntValOut21                  : out std_logic_vector(15 downto 0);
      rRxCntValOut22                  : out std_logic_vector(15 downto 0);
      rRxCntValOut23                  : out std_logic_vector(15 downto 0);
      rRxCntValOut24                  : out std_logic_vector(15 downto 0);
      rRxCntValOut25                  : out std_logic_vector(15 downto 0);
      rRxCntValOut26                  : out std_logic_vector(15 downto 0);
      rRxCntValOut27                  : out std_logic_vector(15 downto 0);
      rRxCntValOut28                  : out std_logic_vector(15 downto 0);
      rRxCntValOut29                  : out std_logic_vector(15 downto 0);
      rRxCntValOut30                  : out std_logic_vector(15 downto 0);
      rRxCntValOut31                  : out std_logic_vector(15 downto 0);
      rRxCntValOut32                  : out std_logic_vector(15 downto 0);
      rRxCntValOut33                  : out std_logic_vector(15 downto 0);
      rRxCntValOut34                  : out std_logic_vector(15 downto 0);
      rRxCntValOut35                  : out std_logic_vector(15 downto 0);
      rRxCntValOut36                  : out std_logic_vector(15 downto 0);
      rRxCntValOut37                  : out std_logic_vector(15 downto 0);
      rRxCntValOut38                  : out std_logic_vector(15 downto 0);
      rRxCntValOut39                  : out std_logic_vector(15 downto 0);
      rRxCntValOut40                  : out std_logic_vector(15 downto 0);
      rRxCntValOut41                  : out std_logic_vector(15 downto 0);
      rRxCntValOut42                  : out std_logic_vector(15 downto 0);
      rRxCntValOut43                  : out std_logic_vector(15 downto 0);
      rRxCntValOut44                  : out std_logic_vector(15 downto 0);
      rRxCntValOut45                  : out std_logic_vector(15 downto 0);
      rRxCntValOut46                  : out std_logic_vector(15 downto 0);
      rRxCntValOut47                  : out std_logic_vector(15 downto 0);
      rRxCntValOut48                  : out std_logic_vector(15 downto 0);
      rRxCntValOut49                  : out std_logic_vector(15 downto 0);
      rRxCntValOut50                  : out std_logic_vector(15 downto 0);
      rRxCntValOut51                  : out std_logic_vector(15 downto 0);
      rRxCntValOut52                  : out std_logic_vector(15 downto 0);
      rRxCntValOut53                  : out std_logic_vector(15 downto 0);
      rRxCntValOut54                  : out std_logic_vector(15 downto 0);
      rRxCntValOut55                  : out std_logic_vector(15 downto 0);
      rRxCntValOut56                  : out std_logic_vector(15 downto 0);
      rRxCntValOut57                  : out std_logic_vector(15 downto 0);
      rRxCntValOut58                  : out std_logic_vector(15 downto 0);
      rRxCntValOut59                  : out std_logic_vector(15 downto 0);
      rRxCntValOut60                  : out std_logic_vector(15 downto 0);
      rRxCntValOut61                  : out std_logic_vector(15 downto 0);
      rRxCntValOut62                  : out std_logic_vector(15 downto 0);
      rRxCntValOut63                  : out std_logic_vector(15 downto 0);
      rRxInc0                         : in  std_logic;
      rRxInc1                         : in  std_logic;
      rRxInc2                         : in  std_logic;
      rRxInc3                         : in  std_logic;
      rRxInc4                         : in  std_logic;
      rRxInc5                         : in  std_logic;
      rRxInc6                         : in  std_logic;
      rRxInc7                         : in  std_logic;
      rRxInc8                         : in  std_logic;
      rRxInc9                         : in  std_logic;
      rRxInc10                        : in  std_logic;
      rRxInc11                        : in  std_logic;
      rRxInc12                        : in  std_logic;
      rRxInc13                        : in  std_logic;
      rRxInc14                        : in  std_logic;
      rRxInc15                        : in  std_logic;
      rRxInc16                        : in  std_logic;
      rRxInc17                        : in  std_logic;
      rRxInc18                        : in  std_logic;
      rRxInc19                        : in  std_logic;
      rRxInc20                        : in  std_logic;
      rRxInc21                        : in  std_logic;
      rRxInc22                        : in  std_logic;
      rRxInc23                        : in  std_logic;
      rRxInc24                        : in  std_logic;
      rRxInc25                        : in  std_logic;
      rRxInc26                        : in  std_logic;
      rRxInc27                        : in  std_logic;
      rRxInc28                        : in  std_logic;
      rRxInc29                        : in  std_logic;
      rRxInc30                        : in  std_logic;
      rRxInc31                        : in  std_logic;
      rRxInc32                        : in  std_logic;
      rRxInc33                        : in  std_logic;
      rRxInc34                        : in  std_logic;
      rRxInc35                        : in  std_logic;
      rRxInc36                        : in  std_logic;
      rRxInc37                        : in  std_logic;
      rRxInc38                        : in  std_logic;
      rRxInc39                        : in  std_logic;
      rRxInc40                        : in  std_logic;
      rRxInc41                        : in  std_logic;
      rRxInc42                        : in  std_logic;
      rRxInc43                        : in  std_logic;
      rRxInc44                        : in  std_logic;
      rRxInc45                        : in  std_logic;
      rRxInc46                        : in  std_logic;
      rRxInc47                        : in  std_logic;
      rRxInc48                        : in  std_logic;
      rRxInc49                        : in  std_logic;
      rRxInc50                        : in  std_logic;
      rRxInc51                        : in  std_logic;
      rRxInc52                        : in  std_logic;
      rRxInc53                        : in  std_logic;
      rRxInc54                        : in  std_logic;
      rRxInc55                        : in  std_logic;
      rRxInc56                        : in  std_logic;
      rRxInc57                        : in  std_logic;
      rRxInc58                        : in  std_logic;
      rRxInc59                        : in  std_logic;
      rRxInc60                        : in  std_logic;
      rRxInc61                        : in  std_logic;
      rRxInc62                        : in  std_logic;
      rRxInc63                        : in  std_logic;
      rRxClkDelayEn0                  : in  std_logic;
      rRxClkDelayEn1                  : in  std_logic;
      rRxClkDelayEn2                  : in  std_logic;
      rRxClkDelayEn3                  : in  std_logic;
      rRxClkDelayEn4                  : in  std_logic;
      rRxClkDelayEn5                  : in  std_logic;
      rRxClkDelayEn6                  : in  std_logic;
      rRxClkDelayEn7                  : in  std_logic;
      rRxClkDelayEn8                  : in  std_logic;
      rRxClkDelayEn9                  : in  std_logic;
      rRxClkDelayEn10                 : in  std_logic;
      rRxClkDelayEn11                 : in  std_logic;
      rRxClkDelayEn12                 : in  std_logic;
      rRxClkDelayEn13                 : in  std_logic;
      rRxClkDelayEn14                 : in  std_logic;
      rRxClkDelayEn15                 : in  std_logic;
      rRxClkDelayEn16                 : in  std_logic;
      rRxClkDelayEn17                 : in  std_logic;
      rRxClkDelayEn18                 : in  std_logic;
      rRxClkDelayEn19                 : in  std_logic;
      rRxClkDelayEn20                 : in  std_logic;
      rRxClkDelayEn21                 : in  std_logic;
      rRxClkDelayEn22                 : in  std_logic;
      rRxClkDelayEn23                 : in  std_logic;
      rRxClkDelayEn24                 : in  std_logic;
      rRxClkDelayEn25                 : in  std_logic;
      rRxClkDelayEn26                 : in  std_logic;
      rRxClkDelayEn27                 : in  std_logic;
      rRxClkDelayEn28                 : in  std_logic;
      rRxClkDelayEn29                 : in  std_logic;
      rRxClkDelayEn30                 : in  std_logic;
      rRxClkDelayEn31                 : in  std_logic;
      rRxClkDelayEn32                 : in  std_logic;
      rRxClkDelayEn33                 : in  std_logic;
      rRxClkDelayEn34                 : in  std_logic;
      rRxClkDelayEn35                 : in  std_logic;
      rRxClkDelayEn36                 : in  std_logic;
      rRxClkDelayEn37                 : in  std_logic;
      rRxClkDelayEn38                 : in  std_logic;
      rRxClkDelayEn39                 : in  std_logic;
      rRxClkDelayEn40                 : in  std_logic;
      rRxClkDelayEn41                 : in  std_logic;
      rRxClkDelayEn42                 : in  std_logic;
      rRxClkDelayEn43                 : in  std_logic;
      rRxClkDelayEn44                 : in  std_logic;
      rRxClkDelayEn45                 : in  std_logic;
      rRxClkDelayEn46                 : in  std_logic;
      rRxClkDelayEn47                 : in  std_logic;
      rRxClkDelayEn48                 : in  std_logic;
      rRxClkDelayEn49                 : in  std_logic;
      rRxClkDelayEn50                 : in  std_logic;
      rRxClkDelayEn51                 : in  std_logic;
      rRxClkDelayEn52                 : in  std_logic;
      rRxClkDelayEn53                 : in  std_logic;
      rRxClkDelayEn54                 : in  std_logic;
      rRxClkDelayEn55                 : in  std_logic;
      rRxClkDelayEn56                 : in  std_logic;
      rRxClkDelayEn57                 : in  std_logic;
      rRxClkDelayEn58                 : in  std_logic;
      rRxClkDelayEn59                 : in  std_logic;
      rRxClkDelayEn60                 : in  std_logic;
      rRxClkDelayEn61                 : in  std_logic;
      rRxClkDelayEn62                 : in  std_logic;
      rRxClkDelayEn63                 : in  std_logic;
      rRxDlyCount0                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount1                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount2                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount3                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount4                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount5                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount6                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount7                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount8                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount9                    : in  std_logic_vector(15 downto 0);
      rRxDlyCount10                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount11                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount12                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount13                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount14                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount15                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount16                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount17                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount18                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount19                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount20                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount21                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount22                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount23                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount24                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount25                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount26                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount27                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount28                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount29                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount30                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount31                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount32                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount33                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount34                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount35                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount36                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount37                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount38                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount39                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount40                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount41                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount42                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount43                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount44                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount45                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount46                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount47                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount48                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount49                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount50                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount51                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount52                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount53                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount54                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount55                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount56                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount57                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount58                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount59                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount60                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount61                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount62                   : in  std_logic_vector(15 downto 0);
      rRxDlyCount63                   : in  std_logic_vector(15 downto 0);
      rRxIncDecReady0                 : out std_logic;
      rRxIncDecReady1                 : out std_logic;
      rRxIncDecReady2                 : out std_logic;
      rRxIncDecReady3                 : out std_logic;
      rRxIncDecReady4                 : out std_logic;
      rRxIncDecReady5                 : out std_logic;
      rRxIncDecReady6                 : out std_logic;
      rRxIncDecReady7                 : out std_logic;
      rRxIncDecReady8                 : out std_logic;
      rRxIncDecReady9                 : out std_logic;
      rRxIncDecReady10                : out std_logic;
      rRxIncDecReady11                : out std_logic;
      rRxIncDecReady12                : out std_logic;
      rRxIncDecReady13                : out std_logic;
      rRxIncDecReady14                : out std_logic;
      rRxIncDecReady15                : out std_logic;
      rRxIncDecReady16                : out std_logic;
      rRxIncDecReady17                : out std_logic;
      rRxIncDecReady18                : out std_logic;
      rRxIncDecReady19                : out std_logic;
      rRxIncDecReady20                : out std_logic;
      rRxIncDecReady21                : out std_logic;
      rRxIncDecReady22                : out std_logic;
      rRxIncDecReady23                : out std_logic;
      rRxIncDecReady24                : out std_logic;
      rRxIncDecReady25                : out std_logic;
      rRxIncDecReady26                : out std_logic;
      rRxIncDecReady27                : out std_logic;
      rRxIncDecReady28                : out std_logic;
      rRxIncDecReady29                : out std_logic;
      rRxIncDecReady30                : out std_logic;
      rRxIncDecReady31                : out std_logic;
      rRxIncDecReady32                : out std_logic;
      rRxIncDecReady33                : out std_logic;
      rRxIncDecReady34                : out std_logic;
      rRxIncDecReady35                : out std_logic;
      rRxIncDecReady36                : out std_logic;
      rRxIncDecReady37                : out std_logic;
      rRxIncDecReady38                : out std_logic;
      rRxIncDecReady39                : out std_logic;
      rRxIncDecReady40                : out std_logic;
      rRxIncDecReady41                : out std_logic;
      rRxIncDecReady42                : out std_logic;
      rRxIncDecReady43                : out std_logic;
      rRxIncDecReady44                : out std_logic;
      rRxIncDecReady45                : out std_logic;
      rRxIncDecReady46                : out std_logic;
      rRxIncDecReady47                : out std_logic;
      rRxIncDecReady48                : out std_logic;
      rRxIncDecReady49                : out std_logic;
      rRxIncDecReady50                : out std_logic;
      rRxIncDecReady51                : out std_logic;
      rRxIncDecReady52                : out std_logic;
      rRxIncDecReady53                : out std_logic;
      rRxIncDecReady54                : out std_logic;
      rRxIncDecReady55                : out std_logic;
      rRxIncDecReady56                : out std_logic;
      rRxIncDecReady57                : out std_logic;
      rRxIncDecReady58                : out std_logic;
      rRxIncDecReady59                : out std_logic;
      rRxIncDecReady60                : out std_logic;
      rRxIncDecReady61                : out std_logic;
      rRxIncDecReady62                : out std_logic;
      rRxIncDecReady63                : out std_logic;
      aLvdsPfiDir0                    : in  std_logic;
      aLvdsPfiDir1                    : in  std_logic;
      aLvdsPfiInput0                  : out std_logic;
      aLvdsPfiInput1                  : out std_logic;
      aLvdsPfiOutput0                 : in  std_logic;
      aLvdsPfiOutput1                 : in  std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0));
  end component;

  --vhook_sigstart
  --vhook_sigend

begin

  --vhook_nowarn aReservedToClip
  --vhook_nowarn xIo*
  --vhook_nowarn aGpio*
  --vhook_nowarn xClipAxi4LiteInterrupt

  -- TClk is not supported in ALL IN module
  --vhook_nowarn dvTdcAssert
  --vhook_nowarn dtTdcAssert
  dvTdcAssert <= '0';

  -- This CLIP supports IFIFO_RPC
  stIoModuleSupportsFRAGLs <= '1';

  -- Unused signals
  aReservedFromClip        <= (others => '0');
  dtDevClkEn               <= '0';

  --vhook Ni6569BasicClipAllInFl
  Ni6569BasicClipAllInFlx: Ni6569BasicClipAllInFl
    port map (
      aDiffGpio_p                     => aDiffGpio_p,                      --inout std_logic_vector(69:0)
      aDiffGpio_n                     => aDiffGpio_n,                      --inout std_logic_vector(69:0)
      aSeGpio                         => aSeGpio,                          --inout std_logic_vector(29:0)
      xIoOutputEnable                 => xIoOutputEnable,                  --in  std_logic
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
      DeviceClkRxLV                   => DeviceClkRxLV,                    --out std_logic
      aSeDir0                         => aSeDir0,                          --in  std_logic
      aSeDir1                         => aSeDir1,                          --in  std_logic
      aSeDir2                         => aSeDir2,                          --in  std_logic
      aSeDir3                         => aSeDir3,                          --in  std_logic
      aSeDir4                         => aSeDir4,                          --in  std_logic
      aSeDir5                         => aSeDir5,                          --in  std_logic
      aSeDir6                         => aSeDir6,                          --in  std_logic
      aSeDir7                         => aSeDir7,                          --in  std_logic
      aSeInput0                       => aSeInput0,                        --out std_logic
      aSeInput1                       => aSeInput1,                        --out std_logic
      aSeInput2                       => aSeInput2,                        --out std_logic
      aSeInput3                       => aSeInput3,                        --out std_logic
      aSeInput4                       => aSeInput4,                        --out std_logic
      aSeInput5                       => aSeInput5,                        --out std_logic
      aSeInput6                       => aSeInput6,                        --out std_logic
      aSeInput7                       => aSeInput7,                        --out std_logic
      aSeOutput0                      => aSeOutput0,                       --in  std_logic
      aSeOutput1                      => aSeOutput1,                       --in  std_logic
      aSeOutput2                      => aSeOutput2,                       --in  std_logic
      aSeOutput3                      => aSeOutput3,                       --in  std_logic
      aSeOutput4                      => aSeOutput4,                       --in  std_logic
      aSeOutput5                      => aSeOutput5,                       --in  std_logic
      aSeOutput6                      => aSeOutput6,                       --in  std_logic
      aSeOutput7                      => aSeOutput7,                       --in  std_logic
      rLvdsInput                      => rLvdsInput,                       --out std_logic_vector(63:0)
      rRxCntValOut0                   => rRxCntValOut0,                    --out std_logic_vector(15:0)
      rRxCntValOut1                   => rRxCntValOut1,                    --out std_logic_vector(15:0)
      rRxCntValOut2                   => rRxCntValOut2,                    --out std_logic_vector(15:0)
      rRxCntValOut3                   => rRxCntValOut3,                    --out std_logic_vector(15:0)
      rRxCntValOut4                   => rRxCntValOut4,                    --out std_logic_vector(15:0)
      rRxCntValOut5                   => rRxCntValOut5,                    --out std_logic_vector(15:0)
      rRxCntValOut6                   => rRxCntValOut6,                    --out std_logic_vector(15:0)
      rRxCntValOut7                   => rRxCntValOut7,                    --out std_logic_vector(15:0)
      rRxCntValOut8                   => rRxCntValOut8,                    --out std_logic_vector(15:0)
      rRxCntValOut9                   => rRxCntValOut9,                    --out std_logic_vector(15:0)
      rRxCntValOut10                  => rRxCntValOut10,                   --out std_logic_vector(15:0)
      rRxCntValOut11                  => rRxCntValOut11,                   --out std_logic_vector(15:0)
      rRxCntValOut12                  => rRxCntValOut12,                   --out std_logic_vector(15:0)
      rRxCntValOut13                  => rRxCntValOut13,                   --out std_logic_vector(15:0)
      rRxCntValOut14                  => rRxCntValOut14,                   --out std_logic_vector(15:0)
      rRxCntValOut15                  => rRxCntValOut15,                   --out std_logic_vector(15:0)
      rRxCntValOut16                  => rRxCntValOut16,                   --out std_logic_vector(15:0)
      rRxCntValOut17                  => rRxCntValOut17,                   --out std_logic_vector(15:0)
      rRxCntValOut18                  => rRxCntValOut18,                   --out std_logic_vector(15:0)
      rRxCntValOut19                  => rRxCntValOut19,                   --out std_logic_vector(15:0)
      rRxCntValOut20                  => rRxCntValOut20,                   --out std_logic_vector(15:0)
      rRxCntValOut21                  => rRxCntValOut21,                   --out std_logic_vector(15:0)
      rRxCntValOut22                  => rRxCntValOut22,                   --out std_logic_vector(15:0)
      rRxCntValOut23                  => rRxCntValOut23,                   --out std_logic_vector(15:0)
      rRxCntValOut24                  => rRxCntValOut24,                   --out std_logic_vector(15:0)
      rRxCntValOut25                  => rRxCntValOut25,                   --out std_logic_vector(15:0)
      rRxCntValOut26                  => rRxCntValOut26,                   --out std_logic_vector(15:0)
      rRxCntValOut27                  => rRxCntValOut27,                   --out std_logic_vector(15:0)
      rRxCntValOut28                  => rRxCntValOut28,                   --out std_logic_vector(15:0)
      rRxCntValOut29                  => rRxCntValOut29,                   --out std_logic_vector(15:0)
      rRxCntValOut30                  => rRxCntValOut30,                   --out std_logic_vector(15:0)
      rRxCntValOut31                  => rRxCntValOut31,                   --out std_logic_vector(15:0)
      rRxCntValOut32                  => rRxCntValOut32,                   --out std_logic_vector(15:0)
      rRxCntValOut33                  => rRxCntValOut33,                   --out std_logic_vector(15:0)
      rRxCntValOut34                  => rRxCntValOut34,                   --out std_logic_vector(15:0)
      rRxCntValOut35                  => rRxCntValOut35,                   --out std_logic_vector(15:0)
      rRxCntValOut36                  => rRxCntValOut36,                   --out std_logic_vector(15:0)
      rRxCntValOut37                  => rRxCntValOut37,                   --out std_logic_vector(15:0)
      rRxCntValOut38                  => rRxCntValOut38,                   --out std_logic_vector(15:0)
      rRxCntValOut39                  => rRxCntValOut39,                   --out std_logic_vector(15:0)
      rRxCntValOut40                  => rRxCntValOut40,                   --out std_logic_vector(15:0)
      rRxCntValOut41                  => rRxCntValOut41,                   --out std_logic_vector(15:0)
      rRxCntValOut42                  => rRxCntValOut42,                   --out std_logic_vector(15:0)
      rRxCntValOut43                  => rRxCntValOut43,                   --out std_logic_vector(15:0)
      rRxCntValOut44                  => rRxCntValOut44,                   --out std_logic_vector(15:0)
      rRxCntValOut45                  => rRxCntValOut45,                   --out std_logic_vector(15:0)
      rRxCntValOut46                  => rRxCntValOut46,                   --out std_logic_vector(15:0)
      rRxCntValOut47                  => rRxCntValOut47,                   --out std_logic_vector(15:0)
      rRxCntValOut48                  => rRxCntValOut48,                   --out std_logic_vector(15:0)
      rRxCntValOut49                  => rRxCntValOut49,                   --out std_logic_vector(15:0)
      rRxCntValOut50                  => rRxCntValOut50,                   --out std_logic_vector(15:0)
      rRxCntValOut51                  => rRxCntValOut51,                   --out std_logic_vector(15:0)
      rRxCntValOut52                  => rRxCntValOut52,                   --out std_logic_vector(15:0)
      rRxCntValOut53                  => rRxCntValOut53,                   --out std_logic_vector(15:0)
      rRxCntValOut54                  => rRxCntValOut54,                   --out std_logic_vector(15:0)
      rRxCntValOut55                  => rRxCntValOut55,                   --out std_logic_vector(15:0)
      rRxCntValOut56                  => rRxCntValOut56,                   --out std_logic_vector(15:0)
      rRxCntValOut57                  => rRxCntValOut57,                   --out std_logic_vector(15:0)
      rRxCntValOut58                  => rRxCntValOut58,                   --out std_logic_vector(15:0)
      rRxCntValOut59                  => rRxCntValOut59,                   --out std_logic_vector(15:0)
      rRxCntValOut60                  => rRxCntValOut60,                   --out std_logic_vector(15:0)
      rRxCntValOut61                  => rRxCntValOut61,                   --out std_logic_vector(15:0)
      rRxCntValOut62                  => rRxCntValOut62,                   --out std_logic_vector(15:0)
      rRxCntValOut63                  => rRxCntValOut63,                   --out std_logic_vector(15:0)
      rRxInc0                         => rRxInc0,                          --in  std_logic
      rRxInc1                         => rRxInc1,                          --in  std_logic
      rRxInc2                         => rRxInc2,                          --in  std_logic
      rRxInc3                         => rRxInc3,                          --in  std_logic
      rRxInc4                         => rRxInc4,                          --in  std_logic
      rRxInc5                         => rRxInc5,                          --in  std_logic
      rRxInc6                         => rRxInc6,                          --in  std_logic
      rRxInc7                         => rRxInc7,                          --in  std_logic
      rRxInc8                         => rRxInc8,                          --in  std_logic
      rRxInc9                         => rRxInc9,                          --in  std_logic
      rRxInc10                        => rRxInc10,                         --in  std_logic
      rRxInc11                        => rRxInc11,                         --in  std_logic
      rRxInc12                        => rRxInc12,                         --in  std_logic
      rRxInc13                        => rRxInc13,                         --in  std_logic
      rRxInc14                        => rRxInc14,                         --in  std_logic
      rRxInc15                        => rRxInc15,                         --in  std_logic
      rRxInc16                        => rRxInc16,                         --in  std_logic
      rRxInc17                        => rRxInc17,                         --in  std_logic
      rRxInc18                        => rRxInc18,                         --in  std_logic
      rRxInc19                        => rRxInc19,                         --in  std_logic
      rRxInc20                        => rRxInc20,                         --in  std_logic
      rRxInc21                        => rRxInc21,                         --in  std_logic
      rRxInc22                        => rRxInc22,                         --in  std_logic
      rRxInc23                        => rRxInc23,                         --in  std_logic
      rRxInc24                        => rRxInc24,                         --in  std_logic
      rRxInc25                        => rRxInc25,                         --in  std_logic
      rRxInc26                        => rRxInc26,                         --in  std_logic
      rRxInc27                        => rRxInc27,                         --in  std_logic
      rRxInc28                        => rRxInc28,                         --in  std_logic
      rRxInc29                        => rRxInc29,                         --in  std_logic
      rRxInc30                        => rRxInc30,                         --in  std_logic
      rRxInc31                        => rRxInc31,                         --in  std_logic
      rRxInc32                        => rRxInc32,                         --in  std_logic
      rRxInc33                        => rRxInc33,                         --in  std_logic
      rRxInc34                        => rRxInc34,                         --in  std_logic
      rRxInc35                        => rRxInc35,                         --in  std_logic
      rRxInc36                        => rRxInc36,                         --in  std_logic
      rRxInc37                        => rRxInc37,                         --in  std_logic
      rRxInc38                        => rRxInc38,                         --in  std_logic
      rRxInc39                        => rRxInc39,                         --in  std_logic
      rRxInc40                        => rRxInc40,                         --in  std_logic
      rRxInc41                        => rRxInc41,                         --in  std_logic
      rRxInc42                        => rRxInc42,                         --in  std_logic
      rRxInc43                        => rRxInc43,                         --in  std_logic
      rRxInc44                        => rRxInc44,                         --in  std_logic
      rRxInc45                        => rRxInc45,                         --in  std_logic
      rRxInc46                        => rRxInc46,                         --in  std_logic
      rRxInc47                        => rRxInc47,                         --in  std_logic
      rRxInc48                        => rRxInc48,                         --in  std_logic
      rRxInc49                        => rRxInc49,                         --in  std_logic
      rRxInc50                        => rRxInc50,                         --in  std_logic
      rRxInc51                        => rRxInc51,                         --in  std_logic
      rRxInc52                        => rRxInc52,                         --in  std_logic
      rRxInc53                        => rRxInc53,                         --in  std_logic
      rRxInc54                        => rRxInc54,                         --in  std_logic
      rRxInc55                        => rRxInc55,                         --in  std_logic
      rRxInc56                        => rRxInc56,                         --in  std_logic
      rRxInc57                        => rRxInc57,                         --in  std_logic
      rRxInc58                        => rRxInc58,                         --in  std_logic
      rRxInc59                        => rRxInc59,                         --in  std_logic
      rRxInc60                        => rRxInc60,                         --in  std_logic
      rRxInc61                        => rRxInc61,                         --in  std_logic
      rRxInc62                        => rRxInc62,                         --in  std_logic
      rRxInc63                        => rRxInc63,                         --in  std_logic
      rRxClkDelayEn0                  => rRxClkDelayEn0,                   --in  std_logic
      rRxClkDelayEn1                  => rRxClkDelayEn1,                   --in  std_logic
      rRxClkDelayEn2                  => rRxClkDelayEn2,                   --in  std_logic
      rRxClkDelayEn3                  => rRxClkDelayEn3,                   --in  std_logic
      rRxClkDelayEn4                  => rRxClkDelayEn4,                   --in  std_logic
      rRxClkDelayEn5                  => rRxClkDelayEn5,                   --in  std_logic
      rRxClkDelayEn6                  => rRxClkDelayEn6,                   --in  std_logic
      rRxClkDelayEn7                  => rRxClkDelayEn7,                   --in  std_logic
      rRxClkDelayEn8                  => rRxClkDelayEn8,                   --in  std_logic
      rRxClkDelayEn9                  => rRxClkDelayEn9,                   --in  std_logic
      rRxClkDelayEn10                 => rRxClkDelayEn10,                  --in  std_logic
      rRxClkDelayEn11                 => rRxClkDelayEn11,                  --in  std_logic
      rRxClkDelayEn12                 => rRxClkDelayEn12,                  --in  std_logic
      rRxClkDelayEn13                 => rRxClkDelayEn13,                  --in  std_logic
      rRxClkDelayEn14                 => rRxClkDelayEn14,                  --in  std_logic
      rRxClkDelayEn15                 => rRxClkDelayEn15,                  --in  std_logic
      rRxClkDelayEn16                 => rRxClkDelayEn16,                  --in  std_logic
      rRxClkDelayEn17                 => rRxClkDelayEn17,                  --in  std_logic
      rRxClkDelayEn18                 => rRxClkDelayEn18,                  --in  std_logic
      rRxClkDelayEn19                 => rRxClkDelayEn19,                  --in  std_logic
      rRxClkDelayEn20                 => rRxClkDelayEn20,                  --in  std_logic
      rRxClkDelayEn21                 => rRxClkDelayEn21,                  --in  std_logic
      rRxClkDelayEn22                 => rRxClkDelayEn22,                  --in  std_logic
      rRxClkDelayEn23                 => rRxClkDelayEn23,                  --in  std_logic
      rRxClkDelayEn24                 => rRxClkDelayEn24,                  --in  std_logic
      rRxClkDelayEn25                 => rRxClkDelayEn25,                  --in  std_logic
      rRxClkDelayEn26                 => rRxClkDelayEn26,                  --in  std_logic
      rRxClkDelayEn27                 => rRxClkDelayEn27,                  --in  std_logic
      rRxClkDelayEn28                 => rRxClkDelayEn28,                  --in  std_logic
      rRxClkDelayEn29                 => rRxClkDelayEn29,                  --in  std_logic
      rRxClkDelayEn30                 => rRxClkDelayEn30,                  --in  std_logic
      rRxClkDelayEn31                 => rRxClkDelayEn31,                  --in  std_logic
      rRxClkDelayEn32                 => rRxClkDelayEn32,                  --in  std_logic
      rRxClkDelayEn33                 => rRxClkDelayEn33,                  --in  std_logic
      rRxClkDelayEn34                 => rRxClkDelayEn34,                  --in  std_logic
      rRxClkDelayEn35                 => rRxClkDelayEn35,                  --in  std_logic
      rRxClkDelayEn36                 => rRxClkDelayEn36,                  --in  std_logic
      rRxClkDelayEn37                 => rRxClkDelayEn37,                  --in  std_logic
      rRxClkDelayEn38                 => rRxClkDelayEn38,                  --in  std_logic
      rRxClkDelayEn39                 => rRxClkDelayEn39,                  --in  std_logic
      rRxClkDelayEn40                 => rRxClkDelayEn40,                  --in  std_logic
      rRxClkDelayEn41                 => rRxClkDelayEn41,                  --in  std_logic
      rRxClkDelayEn42                 => rRxClkDelayEn42,                  --in  std_logic
      rRxClkDelayEn43                 => rRxClkDelayEn43,                  --in  std_logic
      rRxClkDelayEn44                 => rRxClkDelayEn44,                  --in  std_logic
      rRxClkDelayEn45                 => rRxClkDelayEn45,                  --in  std_logic
      rRxClkDelayEn46                 => rRxClkDelayEn46,                  --in  std_logic
      rRxClkDelayEn47                 => rRxClkDelayEn47,                  --in  std_logic
      rRxClkDelayEn48                 => rRxClkDelayEn48,                  --in  std_logic
      rRxClkDelayEn49                 => rRxClkDelayEn49,                  --in  std_logic
      rRxClkDelayEn50                 => rRxClkDelayEn50,                  --in  std_logic
      rRxClkDelayEn51                 => rRxClkDelayEn51,                  --in  std_logic
      rRxClkDelayEn52                 => rRxClkDelayEn52,                  --in  std_logic
      rRxClkDelayEn53                 => rRxClkDelayEn53,                  --in  std_logic
      rRxClkDelayEn54                 => rRxClkDelayEn54,                  --in  std_logic
      rRxClkDelayEn55                 => rRxClkDelayEn55,                  --in  std_logic
      rRxClkDelayEn56                 => rRxClkDelayEn56,                  --in  std_logic
      rRxClkDelayEn57                 => rRxClkDelayEn57,                  --in  std_logic
      rRxClkDelayEn58                 => rRxClkDelayEn58,                  --in  std_logic
      rRxClkDelayEn59                 => rRxClkDelayEn59,                  --in  std_logic
      rRxClkDelayEn60                 => rRxClkDelayEn60,                  --in  std_logic
      rRxClkDelayEn61                 => rRxClkDelayEn61,                  --in  std_logic
      rRxClkDelayEn62                 => rRxClkDelayEn62,                  --in  std_logic
      rRxClkDelayEn63                 => rRxClkDelayEn63,                  --in  std_logic
      rRxDlyCount0                    => rRxDlyCount0,                     --in  std_logic_vector(15:0)
      rRxDlyCount1                    => rRxDlyCount1,                     --in  std_logic_vector(15:0)
      rRxDlyCount2                    => rRxDlyCount2,                     --in  std_logic_vector(15:0)
      rRxDlyCount3                    => rRxDlyCount3,                     --in  std_logic_vector(15:0)
      rRxDlyCount4                    => rRxDlyCount4,                     --in  std_logic_vector(15:0)
      rRxDlyCount5                    => rRxDlyCount5,                     --in  std_logic_vector(15:0)
      rRxDlyCount6                    => rRxDlyCount6,                     --in  std_logic_vector(15:0)
      rRxDlyCount7                    => rRxDlyCount7,                     --in  std_logic_vector(15:0)
      rRxDlyCount8                    => rRxDlyCount8,                     --in  std_logic_vector(15:0)
      rRxDlyCount9                    => rRxDlyCount9,                     --in  std_logic_vector(15:0)
      rRxDlyCount10                   => rRxDlyCount10,                    --in  std_logic_vector(15:0)
      rRxDlyCount11                   => rRxDlyCount11,                    --in  std_logic_vector(15:0)
      rRxDlyCount12                   => rRxDlyCount12,                    --in  std_logic_vector(15:0)
      rRxDlyCount13                   => rRxDlyCount13,                    --in  std_logic_vector(15:0)
      rRxDlyCount14                   => rRxDlyCount14,                    --in  std_logic_vector(15:0)
      rRxDlyCount15                   => rRxDlyCount15,                    --in  std_logic_vector(15:0)
      rRxDlyCount16                   => rRxDlyCount16,                    --in  std_logic_vector(15:0)
      rRxDlyCount17                   => rRxDlyCount17,                    --in  std_logic_vector(15:0)
      rRxDlyCount18                   => rRxDlyCount18,                    --in  std_logic_vector(15:0)
      rRxDlyCount19                   => rRxDlyCount19,                    --in  std_logic_vector(15:0)
      rRxDlyCount20                   => rRxDlyCount20,                    --in  std_logic_vector(15:0)
      rRxDlyCount21                   => rRxDlyCount21,                    --in  std_logic_vector(15:0)
      rRxDlyCount22                   => rRxDlyCount22,                    --in  std_logic_vector(15:0)
      rRxDlyCount23                   => rRxDlyCount23,                    --in  std_logic_vector(15:0)
      rRxDlyCount24                   => rRxDlyCount24,                    --in  std_logic_vector(15:0)
      rRxDlyCount25                   => rRxDlyCount25,                    --in  std_logic_vector(15:0)
      rRxDlyCount26                   => rRxDlyCount26,                    --in  std_logic_vector(15:0)
      rRxDlyCount27                   => rRxDlyCount27,                    --in  std_logic_vector(15:0)
      rRxDlyCount28                   => rRxDlyCount28,                    --in  std_logic_vector(15:0)
      rRxDlyCount29                   => rRxDlyCount29,                    --in  std_logic_vector(15:0)
      rRxDlyCount30                   => rRxDlyCount30,                    --in  std_logic_vector(15:0)
      rRxDlyCount31                   => rRxDlyCount31,                    --in  std_logic_vector(15:0)
      rRxDlyCount32                   => rRxDlyCount32,                    --in  std_logic_vector(15:0)
      rRxDlyCount33                   => rRxDlyCount33,                    --in  std_logic_vector(15:0)
      rRxDlyCount34                   => rRxDlyCount34,                    --in  std_logic_vector(15:0)
      rRxDlyCount35                   => rRxDlyCount35,                    --in  std_logic_vector(15:0)
      rRxDlyCount36                   => rRxDlyCount36,                    --in  std_logic_vector(15:0)
      rRxDlyCount37                   => rRxDlyCount37,                    --in  std_logic_vector(15:0)
      rRxDlyCount38                   => rRxDlyCount38,                    --in  std_logic_vector(15:0)
      rRxDlyCount39                   => rRxDlyCount39,                    --in  std_logic_vector(15:0)
      rRxDlyCount40                   => rRxDlyCount40,                    --in  std_logic_vector(15:0)
      rRxDlyCount41                   => rRxDlyCount41,                    --in  std_logic_vector(15:0)
      rRxDlyCount42                   => rRxDlyCount42,                    --in  std_logic_vector(15:0)
      rRxDlyCount43                   => rRxDlyCount43,                    --in  std_logic_vector(15:0)
      rRxDlyCount44                   => rRxDlyCount44,                    --in  std_logic_vector(15:0)
      rRxDlyCount45                   => rRxDlyCount45,                    --in  std_logic_vector(15:0)
      rRxDlyCount46                   => rRxDlyCount46,                    --in  std_logic_vector(15:0)
      rRxDlyCount47                   => rRxDlyCount47,                    --in  std_logic_vector(15:0)
      rRxDlyCount48                   => rRxDlyCount48,                    --in  std_logic_vector(15:0)
      rRxDlyCount49                   => rRxDlyCount49,                    --in  std_logic_vector(15:0)
      rRxDlyCount50                   => rRxDlyCount50,                    --in  std_logic_vector(15:0)
      rRxDlyCount51                   => rRxDlyCount51,                    --in  std_logic_vector(15:0)
      rRxDlyCount52                   => rRxDlyCount52,                    --in  std_logic_vector(15:0)
      rRxDlyCount53                   => rRxDlyCount53,                    --in  std_logic_vector(15:0)
      rRxDlyCount54                   => rRxDlyCount54,                    --in  std_logic_vector(15:0)
      rRxDlyCount55                   => rRxDlyCount55,                    --in  std_logic_vector(15:0)
      rRxDlyCount56                   => rRxDlyCount56,                    --in  std_logic_vector(15:0)
      rRxDlyCount57                   => rRxDlyCount57,                    --in  std_logic_vector(15:0)
      rRxDlyCount58                   => rRxDlyCount58,                    --in  std_logic_vector(15:0)
      rRxDlyCount59                   => rRxDlyCount59,                    --in  std_logic_vector(15:0)
      rRxDlyCount60                   => rRxDlyCount60,                    --in  std_logic_vector(15:0)
      rRxDlyCount61                   => rRxDlyCount61,                    --in  std_logic_vector(15:0)
      rRxDlyCount62                   => rRxDlyCount62,                    --in  std_logic_vector(15:0)
      rRxDlyCount63                   => rRxDlyCount63,                    --in  std_logic_vector(15:0)
      rRxIncDecReady0                 => rRxIncDecReady0,                  --out std_logic
      rRxIncDecReady1                 => rRxIncDecReady1,                  --out std_logic
      rRxIncDecReady2                 => rRxIncDecReady2,                  --out std_logic
      rRxIncDecReady3                 => rRxIncDecReady3,                  --out std_logic
      rRxIncDecReady4                 => rRxIncDecReady4,                  --out std_logic
      rRxIncDecReady5                 => rRxIncDecReady5,                  --out std_logic
      rRxIncDecReady6                 => rRxIncDecReady6,                  --out std_logic
      rRxIncDecReady7                 => rRxIncDecReady7,                  --out std_logic
      rRxIncDecReady8                 => rRxIncDecReady8,                  --out std_logic
      rRxIncDecReady9                 => rRxIncDecReady9,                  --out std_logic
      rRxIncDecReady10                => rRxIncDecReady10,                 --out std_logic
      rRxIncDecReady11                => rRxIncDecReady11,                 --out std_logic
      rRxIncDecReady12                => rRxIncDecReady12,                 --out std_logic
      rRxIncDecReady13                => rRxIncDecReady13,                 --out std_logic
      rRxIncDecReady14                => rRxIncDecReady14,                 --out std_logic
      rRxIncDecReady15                => rRxIncDecReady15,                 --out std_logic
      rRxIncDecReady16                => rRxIncDecReady16,                 --out std_logic
      rRxIncDecReady17                => rRxIncDecReady17,                 --out std_logic
      rRxIncDecReady18                => rRxIncDecReady18,                 --out std_logic
      rRxIncDecReady19                => rRxIncDecReady19,                 --out std_logic
      rRxIncDecReady20                => rRxIncDecReady20,                 --out std_logic
      rRxIncDecReady21                => rRxIncDecReady21,                 --out std_logic
      rRxIncDecReady22                => rRxIncDecReady22,                 --out std_logic
      rRxIncDecReady23                => rRxIncDecReady23,                 --out std_logic
      rRxIncDecReady24                => rRxIncDecReady24,                 --out std_logic
      rRxIncDecReady25                => rRxIncDecReady25,                 --out std_logic
      rRxIncDecReady26                => rRxIncDecReady26,                 --out std_logic
      rRxIncDecReady27                => rRxIncDecReady27,                 --out std_logic
      rRxIncDecReady28                => rRxIncDecReady28,                 --out std_logic
      rRxIncDecReady29                => rRxIncDecReady29,                 --out std_logic
      rRxIncDecReady30                => rRxIncDecReady30,                 --out std_logic
      rRxIncDecReady31                => rRxIncDecReady31,                 --out std_logic
      rRxIncDecReady32                => rRxIncDecReady32,                 --out std_logic
      rRxIncDecReady33                => rRxIncDecReady33,                 --out std_logic
      rRxIncDecReady34                => rRxIncDecReady34,                 --out std_logic
      rRxIncDecReady35                => rRxIncDecReady35,                 --out std_logic
      rRxIncDecReady36                => rRxIncDecReady36,                 --out std_logic
      rRxIncDecReady37                => rRxIncDecReady37,                 --out std_logic
      rRxIncDecReady38                => rRxIncDecReady38,                 --out std_logic
      rRxIncDecReady39                => rRxIncDecReady39,                 --out std_logic
      rRxIncDecReady40                => rRxIncDecReady40,                 --out std_logic
      rRxIncDecReady41                => rRxIncDecReady41,                 --out std_logic
      rRxIncDecReady42                => rRxIncDecReady42,                 --out std_logic
      rRxIncDecReady43                => rRxIncDecReady43,                 --out std_logic
      rRxIncDecReady44                => rRxIncDecReady44,                 --out std_logic
      rRxIncDecReady45                => rRxIncDecReady45,                 --out std_logic
      rRxIncDecReady46                => rRxIncDecReady46,                 --out std_logic
      rRxIncDecReady47                => rRxIncDecReady47,                 --out std_logic
      rRxIncDecReady48                => rRxIncDecReady48,                 --out std_logic
      rRxIncDecReady49                => rRxIncDecReady49,                 --out std_logic
      rRxIncDecReady50                => rRxIncDecReady50,                 --out std_logic
      rRxIncDecReady51                => rRxIncDecReady51,                 --out std_logic
      rRxIncDecReady52                => rRxIncDecReady52,                 --out std_logic
      rRxIncDecReady53                => rRxIncDecReady53,                 --out std_logic
      rRxIncDecReady54                => rRxIncDecReady54,                 --out std_logic
      rRxIncDecReady55                => rRxIncDecReady55,                 --out std_logic
      rRxIncDecReady56                => rRxIncDecReady56,                 --out std_logic
      rRxIncDecReady57                => rRxIncDecReady57,                 --out std_logic
      rRxIncDecReady58                => rRxIncDecReady58,                 --out std_logic
      rRxIncDecReady59                => rRxIncDecReady59,                 --out std_logic
      rRxIncDecReady60                => rRxIncDecReady60,                 --out std_logic
      rRxIncDecReady61                => rRxIncDecReady61,                 --out std_logic
      rRxIncDecReady62                => rRxIncDecReady62,                 --out std_logic
      rRxIncDecReady63                => rRxIncDecReady63,                 --out std_logic
      aLvdsPfiDir0                    => aLvdsPfiDir0,                     --in  std_logic
      aLvdsPfiDir1                    => aLvdsPfiDir1,                     --in  std_logic
      aLvdsPfiInput0                  => aLvdsPfiInput0,                   --out std_logic
      aLvdsPfiInput1                  => aLvdsPfiInput1,                   --out std_logic
      aLvdsPfiOutput0                 => aLvdsPfiOutput0,                  --in  std_logic
      aLvdsPfiOutput1                 => aLvdsPfiOutput1,                  --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode);              --out std_logic_vector(31:0)


end rtl;
