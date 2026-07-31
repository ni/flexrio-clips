-------------------------------------------------------------------------------
--
-- File: Ni6569SerdesClipAllOutTop.vhd
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

entity Ni6569SerdesClipAllOutTop is
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
    aDiagramResetSL                    : in  std_logic;
    aDiagramClkEnable                  : in  std_logic;
    ---------------------------------------------------------------------------
    --                     LabVIEW Interface                                 --
    ---------------------------------------------------------------------------
    -- Diagram Data Clocks
    DeviceClkTxLV       : out std_logic;
    aClkOutInversionB44 : in std_logic;
    aClkOutInversionB45 : in std_logic;
    aClkOutInversionB46 : in std_logic;

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

    -- LVDS Data Output
    tLvdsOutput0        : in std_logic_vector(7 downto 0);
    tLvdsOutput1        : in std_logic_vector(7 downto 0);
    tLvdsOutput2        : in std_logic_vector(7 downto 0);
    tLvdsOutput3        : in std_logic_vector(7 downto 0);
    tLvdsOutput4        : in std_logic_vector(7 downto 0);
    tLvdsOutput5        : in std_logic_vector(7 downto 0);
    tLvdsOutput6        : in std_logic_vector(7 downto 0);
    tLvdsOutput7        : in std_logic_vector(7 downto 0);
    tLvdsOutput8        : in std_logic_vector(7 downto 0);
    tLvdsOutput9        : in std_logic_vector(7 downto 0);
    tLvdsOutput10       : in std_logic_vector(7 downto 0);
    tLvdsOutput11       : in std_logic_vector(7 downto 0);
    tLvdsOutput12       : in std_logic_vector(7 downto 0);
    tLvdsOutput13       : in std_logic_vector(7 downto 0);
    tLvdsOutput14       : in std_logic_vector(7 downto 0);
    tLvdsOutput15       : in std_logic_vector(7 downto 0);
    tLvdsOutput16       : in std_logic_vector(7 downto 0);
    tLvdsOutput17       : in std_logic_vector(7 downto 0);
    tLvdsOutput18       : in std_logic_vector(7 downto 0);
    tLvdsOutput19       : in std_logic_vector(7 downto 0);
    tLvdsOutput20       : in std_logic_vector(7 downto 0);
    tLvdsOutput21       : in std_logic_vector(7 downto 0);
    tLvdsOutput22       : in std_logic_vector(7 downto 0);
    tLvdsOutput23       : in std_logic_vector(7 downto 0);
    tLvdsOutput24       : in std_logic_vector(7 downto 0);
    tLvdsOutput25       : in std_logic_vector(7 downto 0);
    tLvdsOutput26       : in std_logic_vector(7 downto 0);
    tLvdsOutput27       : in std_logic_vector(7 downto 0);
    tLvdsOutput28       : in std_logic_vector(7 downto 0);
    tLvdsOutput29       : in std_logic_vector(7 downto 0);
    tLvdsOutput30       : in std_logic_vector(7 downto 0);
    tLvdsOutput31       : in std_logic_vector(7 downto 0);
    tLvdsOutput32       : in std_logic_vector(7 downto 0);
    tLvdsOutput33       : in std_logic_vector(7 downto 0);
    tLvdsOutput34       : in std_logic_vector(7 downto 0);
    tLvdsOutput35       : in std_logic_vector(7 downto 0);
    tLvdsOutput36       : in std_logic_vector(7 downto 0);
    tLvdsOutput37       : in std_logic_vector(7 downto 0);
    tLvdsOutput38       : in std_logic_vector(7 downto 0);
    tLvdsOutput39       : in std_logic_vector(7 downto 0);
    tLvdsOutput40       : in std_logic_vector(7 downto 0);
    tLvdsOutput41       : in std_logic_vector(7 downto 0);
    tLvdsOutput42       : in std_logic_vector(7 downto 0);
    tLvdsOutput43       : in std_logic_vector(7 downto 0);
    tLvdsOutput44       : in std_logic_vector(7 downto 0);
    tLvdsOutput45       : in std_logic_vector(7 downto 0);
    tLvdsOutput46       : in std_logic_vector(7 downto 0);
    tLvdsOutput47       : in std_logic_vector(7 downto 0);
    tLvdsOutput48       : in std_logic_vector(7 downto 0);
    tLvdsOutput49       : in std_logic_vector(7 downto 0);
    tLvdsOutput50       : in std_logic_vector(7 downto 0);
    tLvdsOutput51       : in std_logic_vector(7 downto 0);
    tLvdsOutput52       : in std_logic_vector(7 downto 0);
    tLvdsOutput53       : in std_logic_vector(7 downto 0);
    tLvdsOutput54       : in std_logic_vector(7 downto 0);
    tLvdsOutput55       : in std_logic_vector(7 downto 0);
    tLvdsOutput56       : in std_logic_vector(7 downto 0);
    tLvdsOutput57       : in std_logic_vector(7 downto 0);
    tLvdsOutput58       : in std_logic_vector(7 downto 0);
    tLvdsOutput59       : in std_logic_vector(7 downto 0);
    tLvdsOutput60       : in std_logic_vector(7 downto 0);
    tLvdsOutput61       : in std_logic_vector(7 downto 0);
    tLvdsOutput62       : in std_logic_vector(7 downto 0);
    tLvdsOutput63       : in std_logic_vector(7 downto 0);

    -- LVDS Data ODELAY
    tTxCntValOut0       : out std_logic_vector(15 downto 0);
    tTxCntValOut1       : out std_logic_vector(15 downto 0);
    tTxCntValOut2       : out std_logic_vector(15 downto 0);
    tTxCntValOut3       : out std_logic_vector(15 downto 0);
    tTxCntValOut4       : out std_logic_vector(15 downto 0);
    tTxCntValOut5       : out std_logic_vector(15 downto 0);
    tTxCntValOut6       : out std_logic_vector(15 downto 0);
    tTxCntValOut7       : out std_logic_vector(15 downto 0);
    tTxCntValOut8       : out std_logic_vector(15 downto 0);
    tTxCntValOut9       : out std_logic_vector(15 downto 0);
    tTxCntValOut10      : out std_logic_vector(15 downto 0);
    tTxCntValOut11      : out std_logic_vector(15 downto 0);
    tTxCntValOut12      : out std_logic_vector(15 downto 0);
    tTxCntValOut13      : out std_logic_vector(15 downto 0);
    tTxCntValOut14      : out std_logic_vector(15 downto 0);
    tTxCntValOut15      : out std_logic_vector(15 downto 0);
    tTxCntValOut16      : out std_logic_vector(15 downto 0);
    tTxCntValOut17      : out std_logic_vector(15 downto 0);
    tTxCntValOut18      : out std_logic_vector(15 downto 0);
    tTxCntValOut19      : out std_logic_vector(15 downto 0);
    tTxCntValOut20      : out std_logic_vector(15 downto 0);
    tTxCntValOut21      : out std_logic_vector(15 downto 0);
    tTxCntValOut22      : out std_logic_vector(15 downto 0);
    tTxCntValOut23      : out std_logic_vector(15 downto 0);
    tTxCntValOut24      : out std_logic_vector(15 downto 0);
    tTxCntValOut25      : out std_logic_vector(15 downto 0);
    tTxCntValOut26      : out std_logic_vector(15 downto 0);
    tTxCntValOut27      : out std_logic_vector(15 downto 0);
    tTxCntValOut28      : out std_logic_vector(15 downto 0);
    tTxCntValOut29      : out std_logic_vector(15 downto 0);
    tTxCntValOut30      : out std_logic_vector(15 downto 0);
    tTxCntValOut31      : out std_logic_vector(15 downto 0);
    tTxCntValOut32      : out std_logic_vector(15 downto 0);
    tTxCntValOut33      : out std_logic_vector(15 downto 0);
    tTxCntValOut34      : out std_logic_vector(15 downto 0);
    tTxCntValOut35      : out std_logic_vector(15 downto 0);
    tTxCntValOut36      : out std_logic_vector(15 downto 0);
    tTxCntValOut37      : out std_logic_vector(15 downto 0);
    tTxCntValOut38      : out std_logic_vector(15 downto 0);
    tTxCntValOut39      : out std_logic_vector(15 downto 0);
    tTxCntValOut40      : out std_logic_vector(15 downto 0);
    tTxCntValOut41      : out std_logic_vector(15 downto 0);
    tTxCntValOut42      : out std_logic_vector(15 downto 0);
    tTxCntValOut43      : out std_logic_vector(15 downto 0);
    tTxCntValOut44      : out std_logic_vector(15 downto 0);
    tTxCntValOut45      : out std_logic_vector(15 downto 0);
    tTxCntValOut46      : out std_logic_vector(15 downto 0);
    tTxCntValOut47      : out std_logic_vector(15 downto 0);
    tTxCntValOut48      : out std_logic_vector(15 downto 0);
    tTxCntValOut49      : out std_logic_vector(15 downto 0);
    tTxCntValOut50      : out std_logic_vector(15 downto 0);
    tTxCntValOut51      : out std_logic_vector(15 downto 0);
    tTxCntValOut52      : out std_logic_vector(15 downto 0);
    tTxCntValOut53      : out std_logic_vector(15 downto 0);
    tTxCntValOut54      : out std_logic_vector(15 downto 0);
    tTxCntValOut55      : out std_logic_vector(15 downto 0);
    tTxCntValOut56      : out std_logic_vector(15 downto 0);
    tTxCntValOut57      : out std_logic_vector(15 downto 0);
    tTxCntValOut58      : out std_logic_vector(15 downto 0);
    tTxCntValOut59      : out std_logic_vector(15 downto 0);
    tTxCntValOut60      : out std_logic_vector(15 downto 0);
    tTxCntValOut61      : out std_logic_vector(15 downto 0);
    tTxCntValOut62      : out std_logic_vector(15 downto 0);
    tTxCntValOut63      : out std_logic_vector(15 downto 0);
    tTxInc0             : in std_logic;
    tTxInc1             : in std_logic;
    tTxInc2             : in std_logic;
    tTxInc3             : in std_logic;
    tTxInc4             : in std_logic;
    tTxInc5             : in std_logic;
    tTxInc6             : in std_logic;
    tTxInc7             : in std_logic;
    tTxInc8             : in std_logic;
    tTxInc9             : in std_logic;
    tTxInc10            : in std_logic;
    tTxInc11            : in std_logic;
    tTxInc12            : in std_logic;
    tTxInc13            : in std_logic;
    tTxInc14            : in std_logic;
    tTxInc15            : in std_logic;
    tTxInc16            : in std_logic;
    tTxInc17            : in std_logic;
    tTxInc18            : in std_logic;
    tTxInc19            : in std_logic;
    tTxInc20            : in std_logic;
    tTxInc21            : in std_logic;
    tTxInc22            : in std_logic;
    tTxInc23            : in std_logic;
    tTxInc24            : in std_logic;
    tTxInc25            : in std_logic;
    tTxInc26            : in std_logic;
    tTxInc27            : in std_logic;
    tTxInc28            : in std_logic;
    tTxInc29            : in std_logic;
    tTxInc30            : in std_logic;
    tTxInc31            : in std_logic;
    tTxInc32            : in std_logic;
    tTxInc33            : in std_logic;
    tTxInc34            : in std_logic;
    tTxInc35            : in std_logic;
    tTxInc36            : in std_logic;
    tTxInc37            : in std_logic;
    tTxInc38            : in std_logic;
    tTxInc39            : in std_logic;
    tTxInc40            : in std_logic;
    tTxInc41            : in std_logic;
    tTxInc42            : in std_logic;
    tTxInc43            : in std_logic;
    tTxInc44            : in std_logic;
    tTxInc45            : in std_logic;
    tTxInc46            : in std_logic;
    tTxInc47            : in std_logic;
    tTxInc48            : in std_logic;
    tTxInc49            : in std_logic;
    tTxInc50            : in std_logic;
    tTxInc51            : in std_logic;
    tTxInc52            : in std_logic;
    tTxInc53            : in std_logic;
    tTxInc54            : in std_logic;
    tTxInc55            : in std_logic;
    tTxInc56            : in std_logic;
    tTxInc57            : in std_logic;
    tTxInc58            : in std_logic;
    tTxInc59            : in std_logic;
    tTxInc60            : in std_logic;
    tTxInc61            : in std_logic;
    tTxInc62            : in std_logic;
    tTxInc63            : in std_logic;
    tTxClkDelayEn0      : in std_logic;
    tTxClkDelayEn1      : in std_logic;
    tTxClkDelayEn2      : in std_logic;
    tTxClkDelayEn3      : in std_logic;
    tTxClkDelayEn4      : in std_logic;
    tTxClkDelayEn5      : in std_logic;
    tTxClkDelayEn6      : in std_logic;
    tTxClkDelayEn7      : in std_logic;
    tTxClkDelayEn8      : in std_logic;
    tTxClkDelayEn9      : in std_logic;
    tTxClkDelayEn10     : in std_logic;
    tTxClkDelayEn11     : in std_logic;
    tTxClkDelayEn12     : in std_logic;
    tTxClkDelayEn13     : in std_logic;
    tTxClkDelayEn14     : in std_logic;
    tTxClkDelayEn15     : in std_logic;
    tTxClkDelayEn16     : in std_logic;
    tTxClkDelayEn17     : in std_logic;
    tTxClkDelayEn18     : in std_logic;
    tTxClkDelayEn19     : in std_logic;
    tTxClkDelayEn20     : in std_logic;
    tTxClkDelayEn21     : in std_logic;
    tTxClkDelayEn22     : in std_logic;
    tTxClkDelayEn23     : in std_logic;
    tTxClkDelayEn24     : in std_logic;
    tTxClkDelayEn25     : in std_logic;
    tTxClkDelayEn26     : in std_logic;
    tTxClkDelayEn27     : in std_logic;
    tTxClkDelayEn28     : in std_logic;
    tTxClkDelayEn29     : in std_logic;
    tTxClkDelayEn30     : in std_logic;
    tTxClkDelayEn31     : in std_logic;
    tTxClkDelayEn32     : in std_logic;
    tTxClkDelayEn33     : in std_logic;
    tTxClkDelayEn34     : in std_logic;
    tTxClkDelayEn35     : in std_logic;
    tTxClkDelayEn36     : in std_logic;
    tTxClkDelayEn37     : in std_logic;
    tTxClkDelayEn38     : in std_logic;
    tTxClkDelayEn39     : in std_logic;
    tTxClkDelayEn40     : in std_logic;
    tTxClkDelayEn41     : in std_logic;
    tTxClkDelayEn42     : in std_logic;
    tTxClkDelayEn43     : in std_logic;
    tTxClkDelayEn44     : in std_logic;
    tTxClkDelayEn45     : in std_logic;
    tTxClkDelayEn46     : in std_logic;
    tTxClkDelayEn47     : in std_logic;
    tTxClkDelayEn48     : in std_logic;
    tTxClkDelayEn49     : in std_logic;
    tTxClkDelayEn50     : in std_logic;
    tTxClkDelayEn51     : in std_logic;
    tTxClkDelayEn52     : in std_logic;
    tTxClkDelayEn53     : in std_logic;
    tTxClkDelayEn54     : in std_logic;
    tTxClkDelayEn55     : in std_logic;
    tTxClkDelayEn56     : in std_logic;
    tTxClkDelayEn57     : in std_logic;
    tTxClkDelayEn58     : in std_logic;
    tTxClkDelayEn59     : in std_logic;
    tTxClkDelayEn60     : in std_logic;
    tTxClkDelayEn61     : in std_logic;
    tTxClkDelayEn62     : in std_logic;
    tTxClkDelayEn63     : in std_logic;
    tTxDlyCount0        : in std_logic_vector(15 downto 0);
    tTxDlyCount1        : in std_logic_vector(15 downto 0);
    tTxDlyCount2        : in std_logic_vector(15 downto 0);
    tTxDlyCount3        : in std_logic_vector(15 downto 0);
    tTxDlyCount4        : in std_logic_vector(15 downto 0);
    tTxDlyCount5        : in std_logic_vector(15 downto 0);
    tTxDlyCount6        : in std_logic_vector(15 downto 0);
    tTxDlyCount7        : in std_logic_vector(15 downto 0);
    tTxDlyCount8        : in std_logic_vector(15 downto 0);
    tTxDlyCount9        : in std_logic_vector(15 downto 0);
    tTxDlyCount10       : in std_logic_vector(15 downto 0);
    tTxDlyCount11       : in std_logic_vector(15 downto 0);
    tTxDlyCount12       : in std_logic_vector(15 downto 0);
    tTxDlyCount13       : in std_logic_vector(15 downto 0);
    tTxDlyCount14       : in std_logic_vector(15 downto 0);
    tTxDlyCount15       : in std_logic_vector(15 downto 0);
    tTxDlyCount16       : in std_logic_vector(15 downto 0);
    tTxDlyCount17       : in std_logic_vector(15 downto 0);
    tTxDlyCount18       : in std_logic_vector(15 downto 0);
    tTxDlyCount19       : in std_logic_vector(15 downto 0);
    tTxDlyCount20       : in std_logic_vector(15 downto 0);
    tTxDlyCount21       : in std_logic_vector(15 downto 0);
    tTxDlyCount22       : in std_logic_vector(15 downto 0);
    tTxDlyCount23       : in std_logic_vector(15 downto 0);
    tTxDlyCount24       : in std_logic_vector(15 downto 0);
    tTxDlyCount25       : in std_logic_vector(15 downto 0);
    tTxDlyCount26       : in std_logic_vector(15 downto 0);
    tTxDlyCount27       : in std_logic_vector(15 downto 0);
    tTxDlyCount28       : in std_logic_vector(15 downto 0);
    tTxDlyCount29       : in std_logic_vector(15 downto 0);
    tTxDlyCount30       : in std_logic_vector(15 downto 0);
    tTxDlyCount31       : in std_logic_vector(15 downto 0);
    tTxDlyCount32       : in std_logic_vector(15 downto 0);
    tTxDlyCount33       : in std_logic_vector(15 downto 0);
    tTxDlyCount34       : in std_logic_vector(15 downto 0);
    tTxDlyCount35       : in std_logic_vector(15 downto 0);
    tTxDlyCount36       : in std_logic_vector(15 downto 0);
    tTxDlyCount37       : in std_logic_vector(15 downto 0);
    tTxDlyCount38       : in std_logic_vector(15 downto 0);
    tTxDlyCount39       : in std_logic_vector(15 downto 0);
    tTxDlyCount40       : in std_logic_vector(15 downto 0);
    tTxDlyCount41       : in std_logic_vector(15 downto 0);
    tTxDlyCount42       : in std_logic_vector(15 downto 0);
    tTxDlyCount43       : in std_logic_vector(15 downto 0);
    tTxDlyCount44       : in std_logic_vector(15 downto 0);
    tTxDlyCount45       : in std_logic_vector(15 downto 0);
    tTxDlyCount46       : in std_logic_vector(15 downto 0);
    tTxDlyCount47       : in std_logic_vector(15 downto 0);
    tTxDlyCount48       : in std_logic_vector(15 downto 0);
    tTxDlyCount49       : in std_logic_vector(15 downto 0);
    tTxDlyCount50       : in std_logic_vector(15 downto 0);
    tTxDlyCount51       : in std_logic_vector(15 downto 0);
    tTxDlyCount52       : in std_logic_vector(15 downto 0);
    tTxDlyCount53       : in std_logic_vector(15 downto 0);
    tTxDlyCount54       : in std_logic_vector(15 downto 0);
    tTxDlyCount55       : in std_logic_vector(15 downto 0);
    tTxDlyCount56       : in std_logic_vector(15 downto 0);
    tTxDlyCount57       : in std_logic_vector(15 downto 0);
    tTxDlyCount58       : in std_logic_vector(15 downto 0);
    tTxDlyCount59       : in std_logic_vector(15 downto 0);
    tTxDlyCount60       : in std_logic_vector(15 downto 0);
    tTxDlyCount61       : in std_logic_vector(15 downto 0);
    tTxDlyCount62       : in std_logic_vector(15 downto 0);
    tTxDlyCount63       : in std_logic_vector(15 downto 0);
    tTxIncDecReady0     : out std_logic;
    tTxIncDecReady1     : out std_logic;
    tTxIncDecReady2     : out std_logic;
    tTxIncDecReady3     : out std_logic;
    tTxIncDecReady4     : out std_logic;
    tTxIncDecReady5     : out std_logic;
    tTxIncDecReady6     : out std_logic;
    tTxIncDecReady7     : out std_logic;
    tTxIncDecReady8     : out std_logic;
    tTxIncDecReady9     : out std_logic;
    tTxIncDecReady10    : out std_logic;
    tTxIncDecReady11    : out std_logic;
    tTxIncDecReady12    : out std_logic;
    tTxIncDecReady13    : out std_logic;
    tTxIncDecReady14    : out std_logic;
    tTxIncDecReady15    : out std_logic;
    tTxIncDecReady16    : out std_logic;
    tTxIncDecReady17    : out std_logic;
    tTxIncDecReady18    : out std_logic;
    tTxIncDecReady19    : out std_logic;
    tTxIncDecReady20    : out std_logic;
    tTxIncDecReady21    : out std_logic;
    tTxIncDecReady22    : out std_logic;
    tTxIncDecReady23    : out std_logic;
    tTxIncDecReady24    : out std_logic;
    tTxIncDecReady25    : out std_logic;
    tTxIncDecReady26    : out std_logic;
    tTxIncDecReady27    : out std_logic;
    tTxIncDecReady28    : out std_logic;
    tTxIncDecReady29    : out std_logic;
    tTxIncDecReady30    : out std_logic;
    tTxIncDecReady31    : out std_logic;
    tTxIncDecReady32    : out std_logic;
    tTxIncDecReady33    : out std_logic;
    tTxIncDecReady34    : out std_logic;
    tTxIncDecReady35    : out std_logic;
    tTxIncDecReady36    : out std_logic;
    tTxIncDecReady37    : out std_logic;
    tTxIncDecReady38    : out std_logic;
    tTxIncDecReady39    : out std_logic;
    tTxIncDecReady40    : out std_logic;
    tTxIncDecReady41    : out std_logic;
    tTxIncDecReady42    : out std_logic;
    tTxIncDecReady43    : out std_logic;
    tTxIncDecReady44    : out std_logic;
    tTxIncDecReady45    : out std_logic;
    tTxIncDecReady46    : out std_logic;
    tTxIncDecReady47    : out std_logic;
    tTxIncDecReady48    : out std_logic;
    tTxIncDecReady49    : out std_logic;
    tTxIncDecReady50    : out std_logic;
    tTxIncDecReady51    : out std_logic;
    tTxIncDecReady52    : out std_logic;
    tTxIncDecReady53    : out std_logic;
    tTxIncDecReady54    : out std_logic;
    tTxIncDecReady55    : out std_logic;
    tTxIncDecReady56    : out std_logic;
    tTxIncDecReady57    : out std_logic;
    tTxIncDecReady58    : out std_logic;
    tTxIncDecReady59    : out std_logic;
    tTxIncDecReady60    : out std_logic;
    tTxIncDecReady61    : out std_logic;
    tTxIncDecReady62    : out std_logic;
    tTxIncDecReady63    : out std_logic;

    -- AXI4-Lite Interface for Channel DRP
    mmcm_drp_s_aclk        : in  std_logic;
    mmcm_drp_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    mmcm_drp_s_axi_awvalid : in  std_logic;
    mmcm_drp_s_axi_awready : out std_logic;
    mmcm_drp_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    mmcm_drp_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    mmcm_drp_s_axi_wvalid  : in  std_logic;
    mmcm_drp_s_axi_wready  : out std_logic;
    mmcm_drp_s_axi_bresp   : out std_logic_vector(1 downto 0);
    mmcm_drp_s_axi_bvalid  : out std_logic;
    mmcm_drp_s_axi_bready  : in  std_logic;
    mmcm_drp_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    mmcm_drp_s_axi_arvalid : in  std_logic;
    mmcm_drp_s_axi_arready : out std_logic;
    mmcm_drp_s_axi_rdata   : out std_logic_vector(31 downto 0);
    mmcm_drp_s_axi_rresp   : out std_logic_vector(1 downto 0);
    mmcm_drp_s_axi_rvalid  : out std_logic;
    mmcm_drp_s_axi_rready  : in  std_logic;

    -------------------------------------------------------
    -- For Debug Purpose Only (Measure phase difference) --
    -------------------------------------------------------
    -- This is to measure the phase difference of TxDataClk and OSerdesClkDiv
    -- under TimingEngine to make sure both are in phase.

    -- bTxDataClkCopyCount        : out std_logic_vector(7 downto 0);
    -- bOSerdesClkDivCopyCount    : out std_logic_vector(7 downto 0);

    -- LVDS PFI Lines
    aLvdsPfiDir0        : in std_logic;
    aLvdsPfiDir1        : in std_logic;
    aLvdsPfiInput0      : out std_logic;
    aLvdsPfiInput1      : out std_logic;
    aLvdsPfiOutput0     : in std_logic;
    aLvdsPfiOutput1     : in std_logic
    );
end entity Ni6569SerdesClipAllOutTop;

architecture rtl of Ni6569SerdesClipAllOutTop is

  component Ni6569SerdesClipAllOutFl
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
      TxDataClkToTopLevel             : out std_logic;
      aClkOutInversionB44             : in  std_logic;
      aClkOutInversionB45             : in  std_logic;
      aClkOutInversionB46             : in  std_logic;
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
      tLvdsOutput0                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput1                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput2                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput3                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput4                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput5                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput6                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput7                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput8                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput9                    : in  std_logic_vector(7 downto 0);
      tLvdsOutput10                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput11                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput12                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput13                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput14                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput15                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput16                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput17                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput18                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput19                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput20                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput21                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput22                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput23                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput24                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput25                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput26                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput27                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput28                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput29                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput30                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput31                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput32                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput33                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput34                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput35                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput36                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput37                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput38                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput39                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput40                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput41                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput42                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput43                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput44                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput45                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput46                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput47                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput48                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput49                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput50                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput51                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput52                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput53                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput54                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput55                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput56                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput57                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput58                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput59                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput60                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput61                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput62                   : in  std_logic_vector(7 downto 0);
      tLvdsOutput63                   : in  std_logic_vector(7 downto 0);
      tTxCntValOut0                   : out std_logic_vector(15 downto 0);
      tTxCntValOut1                   : out std_logic_vector(15 downto 0);
      tTxCntValOut2                   : out std_logic_vector(15 downto 0);
      tTxCntValOut3                   : out std_logic_vector(15 downto 0);
      tTxCntValOut4                   : out std_logic_vector(15 downto 0);
      tTxCntValOut5                   : out std_logic_vector(15 downto 0);
      tTxCntValOut6                   : out std_logic_vector(15 downto 0);
      tTxCntValOut7                   : out std_logic_vector(15 downto 0);
      tTxCntValOut8                   : out std_logic_vector(15 downto 0);
      tTxCntValOut9                   : out std_logic_vector(15 downto 0);
      tTxCntValOut10                  : out std_logic_vector(15 downto 0);
      tTxCntValOut11                  : out std_logic_vector(15 downto 0);
      tTxCntValOut12                  : out std_logic_vector(15 downto 0);
      tTxCntValOut13                  : out std_logic_vector(15 downto 0);
      tTxCntValOut14                  : out std_logic_vector(15 downto 0);
      tTxCntValOut15                  : out std_logic_vector(15 downto 0);
      tTxCntValOut16                  : out std_logic_vector(15 downto 0);
      tTxCntValOut17                  : out std_logic_vector(15 downto 0);
      tTxCntValOut18                  : out std_logic_vector(15 downto 0);
      tTxCntValOut19                  : out std_logic_vector(15 downto 0);
      tTxCntValOut20                  : out std_logic_vector(15 downto 0);
      tTxCntValOut21                  : out std_logic_vector(15 downto 0);
      tTxCntValOut22                  : out std_logic_vector(15 downto 0);
      tTxCntValOut23                  : out std_logic_vector(15 downto 0);
      tTxCntValOut24                  : out std_logic_vector(15 downto 0);
      tTxCntValOut25                  : out std_logic_vector(15 downto 0);
      tTxCntValOut26                  : out std_logic_vector(15 downto 0);
      tTxCntValOut27                  : out std_logic_vector(15 downto 0);
      tTxCntValOut28                  : out std_logic_vector(15 downto 0);
      tTxCntValOut29                  : out std_logic_vector(15 downto 0);
      tTxCntValOut30                  : out std_logic_vector(15 downto 0);
      tTxCntValOut31                  : out std_logic_vector(15 downto 0);
      tTxCntValOut32                  : out std_logic_vector(15 downto 0);
      tTxCntValOut33                  : out std_logic_vector(15 downto 0);
      tTxCntValOut34                  : out std_logic_vector(15 downto 0);
      tTxCntValOut35                  : out std_logic_vector(15 downto 0);
      tTxCntValOut36                  : out std_logic_vector(15 downto 0);
      tTxCntValOut37                  : out std_logic_vector(15 downto 0);
      tTxCntValOut38                  : out std_logic_vector(15 downto 0);
      tTxCntValOut39                  : out std_logic_vector(15 downto 0);
      tTxCntValOut40                  : out std_logic_vector(15 downto 0);
      tTxCntValOut41                  : out std_logic_vector(15 downto 0);
      tTxCntValOut42                  : out std_logic_vector(15 downto 0);
      tTxCntValOut43                  : out std_logic_vector(15 downto 0);
      tTxCntValOut44                  : out std_logic_vector(15 downto 0);
      tTxCntValOut45                  : out std_logic_vector(15 downto 0);
      tTxCntValOut46                  : out std_logic_vector(15 downto 0);
      tTxCntValOut47                  : out std_logic_vector(15 downto 0);
      tTxCntValOut48                  : out std_logic_vector(15 downto 0);
      tTxCntValOut49                  : out std_logic_vector(15 downto 0);
      tTxCntValOut50                  : out std_logic_vector(15 downto 0);
      tTxCntValOut51                  : out std_logic_vector(15 downto 0);
      tTxCntValOut52                  : out std_logic_vector(15 downto 0);
      tTxCntValOut53                  : out std_logic_vector(15 downto 0);
      tTxCntValOut54                  : out std_logic_vector(15 downto 0);
      tTxCntValOut55                  : out std_logic_vector(15 downto 0);
      tTxCntValOut56                  : out std_logic_vector(15 downto 0);
      tTxCntValOut57                  : out std_logic_vector(15 downto 0);
      tTxCntValOut58                  : out std_logic_vector(15 downto 0);
      tTxCntValOut59                  : out std_logic_vector(15 downto 0);
      tTxCntValOut60                  : out std_logic_vector(15 downto 0);
      tTxCntValOut61                  : out std_logic_vector(15 downto 0);
      tTxCntValOut62                  : out std_logic_vector(15 downto 0);
      tTxCntValOut63                  : out std_logic_vector(15 downto 0);
      tTxInc0                         : in  std_logic;
      tTxInc1                         : in  std_logic;
      tTxInc2                         : in  std_logic;
      tTxInc3                         : in  std_logic;
      tTxInc4                         : in  std_logic;
      tTxInc5                         : in  std_logic;
      tTxInc6                         : in  std_logic;
      tTxInc7                         : in  std_logic;
      tTxInc8                         : in  std_logic;
      tTxInc9                         : in  std_logic;
      tTxInc10                        : in  std_logic;
      tTxInc11                        : in  std_logic;
      tTxInc12                        : in  std_logic;
      tTxInc13                        : in  std_logic;
      tTxInc14                        : in  std_logic;
      tTxInc15                        : in  std_logic;
      tTxInc16                        : in  std_logic;
      tTxInc17                        : in  std_logic;
      tTxInc18                        : in  std_logic;
      tTxInc19                        : in  std_logic;
      tTxInc20                        : in  std_logic;
      tTxInc21                        : in  std_logic;
      tTxInc22                        : in  std_logic;
      tTxInc23                        : in  std_logic;
      tTxInc24                        : in  std_logic;
      tTxInc25                        : in  std_logic;
      tTxInc26                        : in  std_logic;
      tTxInc27                        : in  std_logic;
      tTxInc28                        : in  std_logic;
      tTxInc29                        : in  std_logic;
      tTxInc30                        : in  std_logic;
      tTxInc31                        : in  std_logic;
      tTxInc32                        : in  std_logic;
      tTxInc33                        : in  std_logic;
      tTxInc34                        : in  std_logic;
      tTxInc35                        : in  std_logic;
      tTxInc36                        : in  std_logic;
      tTxInc37                        : in  std_logic;
      tTxInc38                        : in  std_logic;
      tTxInc39                        : in  std_logic;
      tTxInc40                        : in  std_logic;
      tTxInc41                        : in  std_logic;
      tTxInc42                        : in  std_logic;
      tTxInc43                        : in  std_logic;
      tTxInc44                        : in  std_logic;
      tTxInc45                        : in  std_logic;
      tTxInc46                        : in  std_logic;
      tTxInc47                        : in  std_logic;
      tTxInc48                        : in  std_logic;
      tTxInc49                        : in  std_logic;
      tTxInc50                        : in  std_logic;
      tTxInc51                        : in  std_logic;
      tTxInc52                        : in  std_logic;
      tTxInc53                        : in  std_logic;
      tTxInc54                        : in  std_logic;
      tTxInc55                        : in  std_logic;
      tTxInc56                        : in  std_logic;
      tTxInc57                        : in  std_logic;
      tTxInc58                        : in  std_logic;
      tTxInc59                        : in  std_logic;
      tTxInc60                        : in  std_logic;
      tTxInc61                        : in  std_logic;
      tTxInc62                        : in  std_logic;
      tTxInc63                        : in  std_logic;
      tTxClkDelayEn0                  : in  std_logic;
      tTxClkDelayEn1                  : in  std_logic;
      tTxClkDelayEn2                  : in  std_logic;
      tTxClkDelayEn3                  : in  std_logic;
      tTxClkDelayEn4                  : in  std_logic;
      tTxClkDelayEn5                  : in  std_logic;
      tTxClkDelayEn6                  : in  std_logic;
      tTxClkDelayEn7                  : in  std_logic;
      tTxClkDelayEn8                  : in  std_logic;
      tTxClkDelayEn9                  : in  std_logic;
      tTxClkDelayEn10                 : in  std_logic;
      tTxClkDelayEn11                 : in  std_logic;
      tTxClkDelayEn12                 : in  std_logic;
      tTxClkDelayEn13                 : in  std_logic;
      tTxClkDelayEn14                 : in  std_logic;
      tTxClkDelayEn15                 : in  std_logic;
      tTxClkDelayEn16                 : in  std_logic;
      tTxClkDelayEn17                 : in  std_logic;
      tTxClkDelayEn18                 : in  std_logic;
      tTxClkDelayEn19                 : in  std_logic;
      tTxClkDelayEn20                 : in  std_logic;
      tTxClkDelayEn21                 : in  std_logic;
      tTxClkDelayEn22                 : in  std_logic;
      tTxClkDelayEn23                 : in  std_logic;
      tTxClkDelayEn24                 : in  std_logic;
      tTxClkDelayEn25                 : in  std_logic;
      tTxClkDelayEn26                 : in  std_logic;
      tTxClkDelayEn27                 : in  std_logic;
      tTxClkDelayEn28                 : in  std_logic;
      tTxClkDelayEn29                 : in  std_logic;
      tTxClkDelayEn30                 : in  std_logic;
      tTxClkDelayEn31                 : in  std_logic;
      tTxClkDelayEn32                 : in  std_logic;
      tTxClkDelayEn33                 : in  std_logic;
      tTxClkDelayEn34                 : in  std_logic;
      tTxClkDelayEn35                 : in  std_logic;
      tTxClkDelayEn36                 : in  std_logic;
      tTxClkDelayEn37                 : in  std_logic;
      tTxClkDelayEn38                 : in  std_logic;
      tTxClkDelayEn39                 : in  std_logic;
      tTxClkDelayEn40                 : in  std_logic;
      tTxClkDelayEn41                 : in  std_logic;
      tTxClkDelayEn42                 : in  std_logic;
      tTxClkDelayEn43                 : in  std_logic;
      tTxClkDelayEn44                 : in  std_logic;
      tTxClkDelayEn45                 : in  std_logic;
      tTxClkDelayEn46                 : in  std_logic;
      tTxClkDelayEn47                 : in  std_logic;
      tTxClkDelayEn48                 : in  std_logic;
      tTxClkDelayEn49                 : in  std_logic;
      tTxClkDelayEn50                 : in  std_logic;
      tTxClkDelayEn51                 : in  std_logic;
      tTxClkDelayEn52                 : in  std_logic;
      tTxClkDelayEn53                 : in  std_logic;
      tTxClkDelayEn54                 : in  std_logic;
      tTxClkDelayEn55                 : in  std_logic;
      tTxClkDelayEn56                 : in  std_logic;
      tTxClkDelayEn57                 : in  std_logic;
      tTxClkDelayEn58                 : in  std_logic;
      tTxClkDelayEn59                 : in  std_logic;
      tTxClkDelayEn60                 : in  std_logic;
      tTxClkDelayEn61                 : in  std_logic;
      tTxClkDelayEn62                 : in  std_logic;
      tTxClkDelayEn63                 : in  std_logic;
      tTxDlyCount0                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount1                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount2                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount3                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount4                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount5                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount6                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount7                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount8                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount9                    : in  std_logic_vector(15 downto 0);
      tTxDlyCount10                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount11                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount12                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount13                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount14                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount15                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount16                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount17                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount18                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount19                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount20                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount21                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount22                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount23                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount24                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount25                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount26                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount27                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount28                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount29                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount30                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount31                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount32                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount33                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount34                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount35                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount36                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount37                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount38                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount39                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount40                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount41                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount42                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount43                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount44                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount45                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount46                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount47                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount48                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount49                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount50                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount51                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount52                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount53                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount54                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount55                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount56                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount57                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount58                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount59                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount60                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount61                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount62                   : in  std_logic_vector(15 downto 0);
      tTxDlyCount63                   : in  std_logic_vector(15 downto 0);
      tTxIncDecReady0                 : out std_logic;
      tTxIncDecReady1                 : out std_logic;
      tTxIncDecReady2                 : out std_logic;
      tTxIncDecReady3                 : out std_logic;
      tTxIncDecReady4                 : out std_logic;
      tTxIncDecReady5                 : out std_logic;
      tTxIncDecReady6                 : out std_logic;
      tTxIncDecReady7                 : out std_logic;
      tTxIncDecReady8                 : out std_logic;
      tTxIncDecReady9                 : out std_logic;
      tTxIncDecReady10                : out std_logic;
      tTxIncDecReady11                : out std_logic;
      tTxIncDecReady12                : out std_logic;
      tTxIncDecReady13                : out std_logic;
      tTxIncDecReady14                : out std_logic;
      tTxIncDecReady15                : out std_logic;
      tTxIncDecReady16                : out std_logic;
      tTxIncDecReady17                : out std_logic;
      tTxIncDecReady18                : out std_logic;
      tTxIncDecReady19                : out std_logic;
      tTxIncDecReady20                : out std_logic;
      tTxIncDecReady21                : out std_logic;
      tTxIncDecReady22                : out std_logic;
      tTxIncDecReady23                : out std_logic;
      tTxIncDecReady24                : out std_logic;
      tTxIncDecReady25                : out std_logic;
      tTxIncDecReady26                : out std_logic;
      tTxIncDecReady27                : out std_logic;
      tTxIncDecReady28                : out std_logic;
      tTxIncDecReady29                : out std_logic;
      tTxIncDecReady30                : out std_logic;
      tTxIncDecReady31                : out std_logic;
      tTxIncDecReady32                : out std_logic;
      tTxIncDecReady33                : out std_logic;
      tTxIncDecReady34                : out std_logic;
      tTxIncDecReady35                : out std_logic;
      tTxIncDecReady36                : out std_logic;
      tTxIncDecReady37                : out std_logic;
      tTxIncDecReady38                : out std_logic;
      tTxIncDecReady39                : out std_logic;
      tTxIncDecReady40                : out std_logic;
      tTxIncDecReady41                : out std_logic;
      tTxIncDecReady42                : out std_logic;
      tTxIncDecReady43                : out std_logic;
      tTxIncDecReady44                : out std_logic;
      tTxIncDecReady45                : out std_logic;
      tTxIncDecReady46                : out std_logic;
      tTxIncDecReady47                : out std_logic;
      tTxIncDecReady48                : out std_logic;
      tTxIncDecReady49                : out std_logic;
      tTxIncDecReady50                : out std_logic;
      tTxIncDecReady51                : out std_logic;
      tTxIncDecReady52                : out std_logic;
      tTxIncDecReady53                : out std_logic;
      tTxIncDecReady54                : out std_logic;
      tTxIncDecReady55                : out std_logic;
      tTxIncDecReady56                : out std_logic;
      tTxIncDecReady57                : out std_logic;
      tTxIncDecReady58                : out std_logic;
      tTxIncDecReady59                : out std_logic;
      tTxIncDecReady60                : out std_logic;
      tTxIncDecReady61                : out std_logic;
      tTxIncDecReady62                : out std_logic;
      tTxIncDecReady63                : out std_logic;
      mmcm_drp_s_aclk                 : in  std_logic;
      mmcm_drp_s_axi_awaddr           : in  std_logic_vector(31 downto 0);
      mmcm_drp_s_axi_awvalid          : in  std_logic;
      mmcm_drp_s_axi_awready          : out std_logic;
      mmcm_drp_s_axi_wdata            : in  std_logic_vector(31 downto 0);
      mmcm_drp_s_axi_wstrb            : in  std_logic_vector(3 downto 0);
      mmcm_drp_s_axi_wvalid           : in  std_logic;
      mmcm_drp_s_axi_wready           : out std_logic;
      mmcm_drp_s_axi_bresp            : out std_logic_vector(1 downto 0);
      mmcm_drp_s_axi_bvalid           : out std_logic;
      mmcm_drp_s_axi_bready           : in  std_logic;
      mmcm_drp_s_axi_araddr           : in  std_logic_vector(31 downto 0);
      mmcm_drp_s_axi_arvalid          : in  std_logic;
      mmcm_drp_s_axi_arready          : out std_logic;
      mmcm_drp_s_axi_rdata            : out std_logic_vector(31 downto 0);
      mmcm_drp_s_axi_rresp            : out std_logic_vector(1 downto 0);
      mmcm_drp_s_axi_rvalid           : out std_logic;
      mmcm_drp_s_axi_rready           : in  std_logic;
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
  signal TxDataClkToTopLevel: std_logic;
  --vhook_sigend

  signal TxDataClk: std_logic;

begin

  -- This CLIP supports IFIFO_RPC
  stIoModuleSupportsFRAGLs <= '1';

  -- Unused signals
  aReservedFromClip        <= (others => '0');
  dtDevClkEn               <= '1';

  TxDataClk <= TxDataClkToTopLevel;

  TdcAssert: process (aDiagramResetSL, TxDataClk)
  begin
    if (aDiagramResetSL = '1') then
      dvTdcAssert <= '0';
    elsif rising_edge(TxDataClk) then
      dvTdcAssert <= dtTdcAssert;
    end if;
  end process TdcAssert;

  DeviceClkTxLV <= TxDataClkToTopLevel;

  --vhook_nowarn aReservedToClip
  --vhook_nowarn xIo*
  --vhook_nowarn aGpio*
  --vhook_nowarn xClipAxi4LiteInterrupt

  --vhook Ni6569SerdesClipAllOutFl
  Ni6569SerdesClipAllOutFlx: Ni6569SerdesClipAllOutFl
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
      TxDataClkToTopLevel             => TxDataClkToTopLevel,              --out std_logic
      aClkOutInversionB44             => aClkOutInversionB44,              --in  std_logic
      aClkOutInversionB45             => aClkOutInversionB45,              --in  std_logic
      aClkOutInversionB46             => aClkOutInversionB46,              --in  std_logic
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
      tLvdsOutput0                    => tLvdsOutput0,                     --in  std_logic_vector(7:0)
      tLvdsOutput1                    => tLvdsOutput1,                     --in  std_logic_vector(7:0)
      tLvdsOutput2                    => tLvdsOutput2,                     --in  std_logic_vector(7:0)
      tLvdsOutput3                    => tLvdsOutput3,                     --in  std_logic_vector(7:0)
      tLvdsOutput4                    => tLvdsOutput4,                     --in  std_logic_vector(7:0)
      tLvdsOutput5                    => tLvdsOutput5,                     --in  std_logic_vector(7:0)
      tLvdsOutput6                    => tLvdsOutput6,                     --in  std_logic_vector(7:0)
      tLvdsOutput7                    => tLvdsOutput7,                     --in  std_logic_vector(7:0)
      tLvdsOutput8                    => tLvdsOutput8,                     --in  std_logic_vector(7:0)
      tLvdsOutput9                    => tLvdsOutput9,                     --in  std_logic_vector(7:0)
      tLvdsOutput10                   => tLvdsOutput10,                    --in  std_logic_vector(7:0)
      tLvdsOutput11                   => tLvdsOutput11,                    --in  std_logic_vector(7:0)
      tLvdsOutput12                   => tLvdsOutput12,                    --in  std_logic_vector(7:0)
      tLvdsOutput13                   => tLvdsOutput13,                    --in  std_logic_vector(7:0)
      tLvdsOutput14                   => tLvdsOutput14,                    --in  std_logic_vector(7:0)
      tLvdsOutput15                   => tLvdsOutput15,                    --in  std_logic_vector(7:0)
      tLvdsOutput16                   => tLvdsOutput16,                    --in  std_logic_vector(7:0)
      tLvdsOutput17                   => tLvdsOutput17,                    --in  std_logic_vector(7:0)
      tLvdsOutput18                   => tLvdsOutput18,                    --in  std_logic_vector(7:0)
      tLvdsOutput19                   => tLvdsOutput19,                    --in  std_logic_vector(7:0)
      tLvdsOutput20                   => tLvdsOutput20,                    --in  std_logic_vector(7:0)
      tLvdsOutput21                   => tLvdsOutput21,                    --in  std_logic_vector(7:0)
      tLvdsOutput22                   => tLvdsOutput22,                    --in  std_logic_vector(7:0)
      tLvdsOutput23                   => tLvdsOutput23,                    --in  std_logic_vector(7:0)
      tLvdsOutput24                   => tLvdsOutput24,                    --in  std_logic_vector(7:0)
      tLvdsOutput25                   => tLvdsOutput25,                    --in  std_logic_vector(7:0)
      tLvdsOutput26                   => tLvdsOutput26,                    --in  std_logic_vector(7:0)
      tLvdsOutput27                   => tLvdsOutput27,                    --in  std_logic_vector(7:0)
      tLvdsOutput28                   => tLvdsOutput28,                    --in  std_logic_vector(7:0)
      tLvdsOutput29                   => tLvdsOutput29,                    --in  std_logic_vector(7:0)
      tLvdsOutput30                   => tLvdsOutput30,                    --in  std_logic_vector(7:0)
      tLvdsOutput31                   => tLvdsOutput31,                    --in  std_logic_vector(7:0)
      tLvdsOutput32                   => tLvdsOutput32,                    --in  std_logic_vector(7:0)
      tLvdsOutput33                   => tLvdsOutput33,                    --in  std_logic_vector(7:0)
      tLvdsOutput34                   => tLvdsOutput34,                    --in  std_logic_vector(7:0)
      tLvdsOutput35                   => tLvdsOutput35,                    --in  std_logic_vector(7:0)
      tLvdsOutput36                   => tLvdsOutput36,                    --in  std_logic_vector(7:0)
      tLvdsOutput37                   => tLvdsOutput37,                    --in  std_logic_vector(7:0)
      tLvdsOutput38                   => tLvdsOutput38,                    --in  std_logic_vector(7:0)
      tLvdsOutput39                   => tLvdsOutput39,                    --in  std_logic_vector(7:0)
      tLvdsOutput40                   => tLvdsOutput40,                    --in  std_logic_vector(7:0)
      tLvdsOutput41                   => tLvdsOutput41,                    --in  std_logic_vector(7:0)
      tLvdsOutput42                   => tLvdsOutput42,                    --in  std_logic_vector(7:0)
      tLvdsOutput43                   => tLvdsOutput43,                    --in  std_logic_vector(7:0)
      tLvdsOutput44                   => tLvdsOutput44,                    --in  std_logic_vector(7:0)
      tLvdsOutput45                   => tLvdsOutput45,                    --in  std_logic_vector(7:0)
      tLvdsOutput46                   => tLvdsOutput46,                    --in  std_logic_vector(7:0)
      tLvdsOutput47                   => tLvdsOutput47,                    --in  std_logic_vector(7:0)
      tLvdsOutput48                   => tLvdsOutput48,                    --in  std_logic_vector(7:0)
      tLvdsOutput49                   => tLvdsOutput49,                    --in  std_logic_vector(7:0)
      tLvdsOutput50                   => tLvdsOutput50,                    --in  std_logic_vector(7:0)
      tLvdsOutput51                   => tLvdsOutput51,                    --in  std_logic_vector(7:0)
      tLvdsOutput52                   => tLvdsOutput52,                    --in  std_logic_vector(7:0)
      tLvdsOutput53                   => tLvdsOutput53,                    --in  std_logic_vector(7:0)
      tLvdsOutput54                   => tLvdsOutput54,                    --in  std_logic_vector(7:0)
      tLvdsOutput55                   => tLvdsOutput55,                    --in  std_logic_vector(7:0)
      tLvdsOutput56                   => tLvdsOutput56,                    --in  std_logic_vector(7:0)
      tLvdsOutput57                   => tLvdsOutput57,                    --in  std_logic_vector(7:0)
      tLvdsOutput58                   => tLvdsOutput58,                    --in  std_logic_vector(7:0)
      tLvdsOutput59                   => tLvdsOutput59,                    --in  std_logic_vector(7:0)
      tLvdsOutput60                   => tLvdsOutput60,                    --in  std_logic_vector(7:0)
      tLvdsOutput61                   => tLvdsOutput61,                    --in  std_logic_vector(7:0)
      tLvdsOutput62                   => tLvdsOutput62,                    --in  std_logic_vector(7:0)
      tLvdsOutput63                   => tLvdsOutput63,                    --in  std_logic_vector(7:0)
      tTxCntValOut0                   => tTxCntValOut0,                    --out std_logic_vector(15:0)
      tTxCntValOut1                   => tTxCntValOut1,                    --out std_logic_vector(15:0)
      tTxCntValOut2                   => tTxCntValOut2,                    --out std_logic_vector(15:0)
      tTxCntValOut3                   => tTxCntValOut3,                    --out std_logic_vector(15:0)
      tTxCntValOut4                   => tTxCntValOut4,                    --out std_logic_vector(15:0)
      tTxCntValOut5                   => tTxCntValOut5,                    --out std_logic_vector(15:0)
      tTxCntValOut6                   => tTxCntValOut6,                    --out std_logic_vector(15:0)
      tTxCntValOut7                   => tTxCntValOut7,                    --out std_logic_vector(15:0)
      tTxCntValOut8                   => tTxCntValOut8,                    --out std_logic_vector(15:0)
      tTxCntValOut9                   => tTxCntValOut9,                    --out std_logic_vector(15:0)
      tTxCntValOut10                  => tTxCntValOut10,                   --out std_logic_vector(15:0)
      tTxCntValOut11                  => tTxCntValOut11,                   --out std_logic_vector(15:0)
      tTxCntValOut12                  => tTxCntValOut12,                   --out std_logic_vector(15:0)
      tTxCntValOut13                  => tTxCntValOut13,                   --out std_logic_vector(15:0)
      tTxCntValOut14                  => tTxCntValOut14,                   --out std_logic_vector(15:0)
      tTxCntValOut15                  => tTxCntValOut15,                   --out std_logic_vector(15:0)
      tTxCntValOut16                  => tTxCntValOut16,                   --out std_logic_vector(15:0)
      tTxCntValOut17                  => tTxCntValOut17,                   --out std_logic_vector(15:0)
      tTxCntValOut18                  => tTxCntValOut18,                   --out std_logic_vector(15:0)
      tTxCntValOut19                  => tTxCntValOut19,                   --out std_logic_vector(15:0)
      tTxCntValOut20                  => tTxCntValOut20,                   --out std_logic_vector(15:0)
      tTxCntValOut21                  => tTxCntValOut21,                   --out std_logic_vector(15:0)
      tTxCntValOut22                  => tTxCntValOut22,                   --out std_logic_vector(15:0)
      tTxCntValOut23                  => tTxCntValOut23,                   --out std_logic_vector(15:0)
      tTxCntValOut24                  => tTxCntValOut24,                   --out std_logic_vector(15:0)
      tTxCntValOut25                  => tTxCntValOut25,                   --out std_logic_vector(15:0)
      tTxCntValOut26                  => tTxCntValOut26,                   --out std_logic_vector(15:0)
      tTxCntValOut27                  => tTxCntValOut27,                   --out std_logic_vector(15:0)
      tTxCntValOut28                  => tTxCntValOut28,                   --out std_logic_vector(15:0)
      tTxCntValOut29                  => tTxCntValOut29,                   --out std_logic_vector(15:0)
      tTxCntValOut30                  => tTxCntValOut30,                   --out std_logic_vector(15:0)
      tTxCntValOut31                  => tTxCntValOut31,                   --out std_logic_vector(15:0)
      tTxCntValOut32                  => tTxCntValOut32,                   --out std_logic_vector(15:0)
      tTxCntValOut33                  => tTxCntValOut33,                   --out std_logic_vector(15:0)
      tTxCntValOut34                  => tTxCntValOut34,                   --out std_logic_vector(15:0)
      tTxCntValOut35                  => tTxCntValOut35,                   --out std_logic_vector(15:0)
      tTxCntValOut36                  => tTxCntValOut36,                   --out std_logic_vector(15:0)
      tTxCntValOut37                  => tTxCntValOut37,                   --out std_logic_vector(15:0)
      tTxCntValOut38                  => tTxCntValOut38,                   --out std_logic_vector(15:0)
      tTxCntValOut39                  => tTxCntValOut39,                   --out std_logic_vector(15:0)
      tTxCntValOut40                  => tTxCntValOut40,                   --out std_logic_vector(15:0)
      tTxCntValOut41                  => tTxCntValOut41,                   --out std_logic_vector(15:0)
      tTxCntValOut42                  => tTxCntValOut42,                   --out std_logic_vector(15:0)
      tTxCntValOut43                  => tTxCntValOut43,                   --out std_logic_vector(15:0)
      tTxCntValOut44                  => tTxCntValOut44,                   --out std_logic_vector(15:0)
      tTxCntValOut45                  => tTxCntValOut45,                   --out std_logic_vector(15:0)
      tTxCntValOut46                  => tTxCntValOut46,                   --out std_logic_vector(15:0)
      tTxCntValOut47                  => tTxCntValOut47,                   --out std_logic_vector(15:0)
      tTxCntValOut48                  => tTxCntValOut48,                   --out std_logic_vector(15:0)
      tTxCntValOut49                  => tTxCntValOut49,                   --out std_logic_vector(15:0)
      tTxCntValOut50                  => tTxCntValOut50,                   --out std_logic_vector(15:0)
      tTxCntValOut51                  => tTxCntValOut51,                   --out std_logic_vector(15:0)
      tTxCntValOut52                  => tTxCntValOut52,                   --out std_logic_vector(15:0)
      tTxCntValOut53                  => tTxCntValOut53,                   --out std_logic_vector(15:0)
      tTxCntValOut54                  => tTxCntValOut54,                   --out std_logic_vector(15:0)
      tTxCntValOut55                  => tTxCntValOut55,                   --out std_logic_vector(15:0)
      tTxCntValOut56                  => tTxCntValOut56,                   --out std_logic_vector(15:0)
      tTxCntValOut57                  => tTxCntValOut57,                   --out std_logic_vector(15:0)
      tTxCntValOut58                  => tTxCntValOut58,                   --out std_logic_vector(15:0)
      tTxCntValOut59                  => tTxCntValOut59,                   --out std_logic_vector(15:0)
      tTxCntValOut60                  => tTxCntValOut60,                   --out std_logic_vector(15:0)
      tTxCntValOut61                  => tTxCntValOut61,                   --out std_logic_vector(15:0)
      tTxCntValOut62                  => tTxCntValOut62,                   --out std_logic_vector(15:0)
      tTxCntValOut63                  => tTxCntValOut63,                   --out std_logic_vector(15:0)
      tTxInc0                         => tTxInc0,                          --in  std_logic
      tTxInc1                         => tTxInc1,                          --in  std_logic
      tTxInc2                         => tTxInc2,                          --in  std_logic
      tTxInc3                         => tTxInc3,                          --in  std_logic
      tTxInc4                         => tTxInc4,                          --in  std_logic
      tTxInc5                         => tTxInc5,                          --in  std_logic
      tTxInc6                         => tTxInc6,                          --in  std_logic
      tTxInc7                         => tTxInc7,                          --in  std_logic
      tTxInc8                         => tTxInc8,                          --in  std_logic
      tTxInc9                         => tTxInc9,                          --in  std_logic
      tTxInc10                        => tTxInc10,                         --in  std_logic
      tTxInc11                        => tTxInc11,                         --in  std_logic
      tTxInc12                        => tTxInc12,                         --in  std_logic
      tTxInc13                        => tTxInc13,                         --in  std_logic
      tTxInc14                        => tTxInc14,                         --in  std_logic
      tTxInc15                        => tTxInc15,                         --in  std_logic
      tTxInc16                        => tTxInc16,                         --in  std_logic
      tTxInc17                        => tTxInc17,                         --in  std_logic
      tTxInc18                        => tTxInc18,                         --in  std_logic
      tTxInc19                        => tTxInc19,                         --in  std_logic
      tTxInc20                        => tTxInc20,                         --in  std_logic
      tTxInc21                        => tTxInc21,                         --in  std_logic
      tTxInc22                        => tTxInc22,                         --in  std_logic
      tTxInc23                        => tTxInc23,                         --in  std_logic
      tTxInc24                        => tTxInc24,                         --in  std_logic
      tTxInc25                        => tTxInc25,                         --in  std_logic
      tTxInc26                        => tTxInc26,                         --in  std_logic
      tTxInc27                        => tTxInc27,                         --in  std_logic
      tTxInc28                        => tTxInc28,                         --in  std_logic
      tTxInc29                        => tTxInc29,                         --in  std_logic
      tTxInc30                        => tTxInc30,                         --in  std_logic
      tTxInc31                        => tTxInc31,                         --in  std_logic
      tTxInc32                        => tTxInc32,                         --in  std_logic
      tTxInc33                        => tTxInc33,                         --in  std_logic
      tTxInc34                        => tTxInc34,                         --in  std_logic
      tTxInc35                        => tTxInc35,                         --in  std_logic
      tTxInc36                        => tTxInc36,                         --in  std_logic
      tTxInc37                        => tTxInc37,                         --in  std_logic
      tTxInc38                        => tTxInc38,                         --in  std_logic
      tTxInc39                        => tTxInc39,                         --in  std_logic
      tTxInc40                        => tTxInc40,                         --in  std_logic
      tTxInc41                        => tTxInc41,                         --in  std_logic
      tTxInc42                        => tTxInc42,                         --in  std_logic
      tTxInc43                        => tTxInc43,                         --in  std_logic
      tTxInc44                        => tTxInc44,                         --in  std_logic
      tTxInc45                        => tTxInc45,                         --in  std_logic
      tTxInc46                        => tTxInc46,                         --in  std_logic
      tTxInc47                        => tTxInc47,                         --in  std_logic
      tTxInc48                        => tTxInc48,                         --in  std_logic
      tTxInc49                        => tTxInc49,                         --in  std_logic
      tTxInc50                        => tTxInc50,                         --in  std_logic
      tTxInc51                        => tTxInc51,                         --in  std_logic
      tTxInc52                        => tTxInc52,                         --in  std_logic
      tTxInc53                        => tTxInc53,                         --in  std_logic
      tTxInc54                        => tTxInc54,                         --in  std_logic
      tTxInc55                        => tTxInc55,                         --in  std_logic
      tTxInc56                        => tTxInc56,                         --in  std_logic
      tTxInc57                        => tTxInc57,                         --in  std_logic
      tTxInc58                        => tTxInc58,                         --in  std_logic
      tTxInc59                        => tTxInc59,                         --in  std_logic
      tTxInc60                        => tTxInc60,                         --in  std_logic
      tTxInc61                        => tTxInc61,                         --in  std_logic
      tTxInc62                        => tTxInc62,                         --in  std_logic
      tTxInc63                        => tTxInc63,                         --in  std_logic
      tTxClkDelayEn0                  => tTxClkDelayEn0,                   --in  std_logic
      tTxClkDelayEn1                  => tTxClkDelayEn1,                   --in  std_logic
      tTxClkDelayEn2                  => tTxClkDelayEn2,                   --in  std_logic
      tTxClkDelayEn3                  => tTxClkDelayEn3,                   --in  std_logic
      tTxClkDelayEn4                  => tTxClkDelayEn4,                   --in  std_logic
      tTxClkDelayEn5                  => tTxClkDelayEn5,                   --in  std_logic
      tTxClkDelayEn6                  => tTxClkDelayEn6,                   --in  std_logic
      tTxClkDelayEn7                  => tTxClkDelayEn7,                   --in  std_logic
      tTxClkDelayEn8                  => tTxClkDelayEn8,                   --in  std_logic
      tTxClkDelayEn9                  => tTxClkDelayEn9,                   --in  std_logic
      tTxClkDelayEn10                 => tTxClkDelayEn10,                  --in  std_logic
      tTxClkDelayEn11                 => tTxClkDelayEn11,                  --in  std_logic
      tTxClkDelayEn12                 => tTxClkDelayEn12,                  --in  std_logic
      tTxClkDelayEn13                 => tTxClkDelayEn13,                  --in  std_logic
      tTxClkDelayEn14                 => tTxClkDelayEn14,                  --in  std_logic
      tTxClkDelayEn15                 => tTxClkDelayEn15,                  --in  std_logic
      tTxClkDelayEn16                 => tTxClkDelayEn16,                  --in  std_logic
      tTxClkDelayEn17                 => tTxClkDelayEn17,                  --in  std_logic
      tTxClkDelayEn18                 => tTxClkDelayEn18,                  --in  std_logic
      tTxClkDelayEn19                 => tTxClkDelayEn19,                  --in  std_logic
      tTxClkDelayEn20                 => tTxClkDelayEn20,                  --in  std_logic
      tTxClkDelayEn21                 => tTxClkDelayEn21,                  --in  std_logic
      tTxClkDelayEn22                 => tTxClkDelayEn22,                  --in  std_logic
      tTxClkDelayEn23                 => tTxClkDelayEn23,                  --in  std_logic
      tTxClkDelayEn24                 => tTxClkDelayEn24,                  --in  std_logic
      tTxClkDelayEn25                 => tTxClkDelayEn25,                  --in  std_logic
      tTxClkDelayEn26                 => tTxClkDelayEn26,                  --in  std_logic
      tTxClkDelayEn27                 => tTxClkDelayEn27,                  --in  std_logic
      tTxClkDelayEn28                 => tTxClkDelayEn28,                  --in  std_logic
      tTxClkDelayEn29                 => tTxClkDelayEn29,                  --in  std_logic
      tTxClkDelayEn30                 => tTxClkDelayEn30,                  --in  std_logic
      tTxClkDelayEn31                 => tTxClkDelayEn31,                  --in  std_logic
      tTxClkDelayEn32                 => tTxClkDelayEn32,                  --in  std_logic
      tTxClkDelayEn33                 => tTxClkDelayEn33,                  --in  std_logic
      tTxClkDelayEn34                 => tTxClkDelayEn34,                  --in  std_logic
      tTxClkDelayEn35                 => tTxClkDelayEn35,                  --in  std_logic
      tTxClkDelayEn36                 => tTxClkDelayEn36,                  --in  std_logic
      tTxClkDelayEn37                 => tTxClkDelayEn37,                  --in  std_logic
      tTxClkDelayEn38                 => tTxClkDelayEn38,                  --in  std_logic
      tTxClkDelayEn39                 => tTxClkDelayEn39,                  --in  std_logic
      tTxClkDelayEn40                 => tTxClkDelayEn40,                  --in  std_logic
      tTxClkDelayEn41                 => tTxClkDelayEn41,                  --in  std_logic
      tTxClkDelayEn42                 => tTxClkDelayEn42,                  --in  std_logic
      tTxClkDelayEn43                 => tTxClkDelayEn43,                  --in  std_logic
      tTxClkDelayEn44                 => tTxClkDelayEn44,                  --in  std_logic
      tTxClkDelayEn45                 => tTxClkDelayEn45,                  --in  std_logic
      tTxClkDelayEn46                 => tTxClkDelayEn46,                  --in  std_logic
      tTxClkDelayEn47                 => tTxClkDelayEn47,                  --in  std_logic
      tTxClkDelayEn48                 => tTxClkDelayEn48,                  --in  std_logic
      tTxClkDelayEn49                 => tTxClkDelayEn49,                  --in  std_logic
      tTxClkDelayEn50                 => tTxClkDelayEn50,                  --in  std_logic
      tTxClkDelayEn51                 => tTxClkDelayEn51,                  --in  std_logic
      tTxClkDelayEn52                 => tTxClkDelayEn52,                  --in  std_logic
      tTxClkDelayEn53                 => tTxClkDelayEn53,                  --in  std_logic
      tTxClkDelayEn54                 => tTxClkDelayEn54,                  --in  std_logic
      tTxClkDelayEn55                 => tTxClkDelayEn55,                  --in  std_logic
      tTxClkDelayEn56                 => tTxClkDelayEn56,                  --in  std_logic
      tTxClkDelayEn57                 => tTxClkDelayEn57,                  --in  std_logic
      tTxClkDelayEn58                 => tTxClkDelayEn58,                  --in  std_logic
      tTxClkDelayEn59                 => tTxClkDelayEn59,                  --in  std_logic
      tTxClkDelayEn60                 => tTxClkDelayEn60,                  --in  std_logic
      tTxClkDelayEn61                 => tTxClkDelayEn61,                  --in  std_logic
      tTxClkDelayEn62                 => tTxClkDelayEn62,                  --in  std_logic
      tTxClkDelayEn63                 => tTxClkDelayEn63,                  --in  std_logic
      tTxDlyCount0                    => tTxDlyCount0,                     --in  std_logic_vector(15:0)
      tTxDlyCount1                    => tTxDlyCount1,                     --in  std_logic_vector(15:0)
      tTxDlyCount2                    => tTxDlyCount2,                     --in  std_logic_vector(15:0)
      tTxDlyCount3                    => tTxDlyCount3,                     --in  std_logic_vector(15:0)
      tTxDlyCount4                    => tTxDlyCount4,                     --in  std_logic_vector(15:0)
      tTxDlyCount5                    => tTxDlyCount5,                     --in  std_logic_vector(15:0)
      tTxDlyCount6                    => tTxDlyCount6,                     --in  std_logic_vector(15:0)
      tTxDlyCount7                    => tTxDlyCount7,                     --in  std_logic_vector(15:0)
      tTxDlyCount8                    => tTxDlyCount8,                     --in  std_logic_vector(15:0)
      tTxDlyCount9                    => tTxDlyCount9,                     --in  std_logic_vector(15:0)
      tTxDlyCount10                   => tTxDlyCount10,                    --in  std_logic_vector(15:0)
      tTxDlyCount11                   => tTxDlyCount11,                    --in  std_logic_vector(15:0)
      tTxDlyCount12                   => tTxDlyCount12,                    --in  std_logic_vector(15:0)
      tTxDlyCount13                   => tTxDlyCount13,                    --in  std_logic_vector(15:0)
      tTxDlyCount14                   => tTxDlyCount14,                    --in  std_logic_vector(15:0)
      tTxDlyCount15                   => tTxDlyCount15,                    --in  std_logic_vector(15:0)
      tTxDlyCount16                   => tTxDlyCount16,                    --in  std_logic_vector(15:0)
      tTxDlyCount17                   => tTxDlyCount17,                    --in  std_logic_vector(15:0)
      tTxDlyCount18                   => tTxDlyCount18,                    --in  std_logic_vector(15:0)
      tTxDlyCount19                   => tTxDlyCount19,                    --in  std_logic_vector(15:0)
      tTxDlyCount20                   => tTxDlyCount20,                    --in  std_logic_vector(15:0)
      tTxDlyCount21                   => tTxDlyCount21,                    --in  std_logic_vector(15:0)
      tTxDlyCount22                   => tTxDlyCount22,                    --in  std_logic_vector(15:0)
      tTxDlyCount23                   => tTxDlyCount23,                    --in  std_logic_vector(15:0)
      tTxDlyCount24                   => tTxDlyCount24,                    --in  std_logic_vector(15:0)
      tTxDlyCount25                   => tTxDlyCount25,                    --in  std_logic_vector(15:0)
      tTxDlyCount26                   => tTxDlyCount26,                    --in  std_logic_vector(15:0)
      tTxDlyCount27                   => tTxDlyCount27,                    --in  std_logic_vector(15:0)
      tTxDlyCount28                   => tTxDlyCount28,                    --in  std_logic_vector(15:0)
      tTxDlyCount29                   => tTxDlyCount29,                    --in  std_logic_vector(15:0)
      tTxDlyCount30                   => tTxDlyCount30,                    --in  std_logic_vector(15:0)
      tTxDlyCount31                   => tTxDlyCount31,                    --in  std_logic_vector(15:0)
      tTxDlyCount32                   => tTxDlyCount32,                    --in  std_logic_vector(15:0)
      tTxDlyCount33                   => tTxDlyCount33,                    --in  std_logic_vector(15:0)
      tTxDlyCount34                   => tTxDlyCount34,                    --in  std_logic_vector(15:0)
      tTxDlyCount35                   => tTxDlyCount35,                    --in  std_logic_vector(15:0)
      tTxDlyCount36                   => tTxDlyCount36,                    --in  std_logic_vector(15:0)
      tTxDlyCount37                   => tTxDlyCount37,                    --in  std_logic_vector(15:0)
      tTxDlyCount38                   => tTxDlyCount38,                    --in  std_logic_vector(15:0)
      tTxDlyCount39                   => tTxDlyCount39,                    --in  std_logic_vector(15:0)
      tTxDlyCount40                   => tTxDlyCount40,                    --in  std_logic_vector(15:0)
      tTxDlyCount41                   => tTxDlyCount41,                    --in  std_logic_vector(15:0)
      tTxDlyCount42                   => tTxDlyCount42,                    --in  std_logic_vector(15:0)
      tTxDlyCount43                   => tTxDlyCount43,                    --in  std_logic_vector(15:0)
      tTxDlyCount44                   => tTxDlyCount44,                    --in  std_logic_vector(15:0)
      tTxDlyCount45                   => tTxDlyCount45,                    --in  std_logic_vector(15:0)
      tTxDlyCount46                   => tTxDlyCount46,                    --in  std_logic_vector(15:0)
      tTxDlyCount47                   => tTxDlyCount47,                    --in  std_logic_vector(15:0)
      tTxDlyCount48                   => tTxDlyCount48,                    --in  std_logic_vector(15:0)
      tTxDlyCount49                   => tTxDlyCount49,                    --in  std_logic_vector(15:0)
      tTxDlyCount50                   => tTxDlyCount50,                    --in  std_logic_vector(15:0)
      tTxDlyCount51                   => tTxDlyCount51,                    --in  std_logic_vector(15:0)
      tTxDlyCount52                   => tTxDlyCount52,                    --in  std_logic_vector(15:0)
      tTxDlyCount53                   => tTxDlyCount53,                    --in  std_logic_vector(15:0)
      tTxDlyCount54                   => tTxDlyCount54,                    --in  std_logic_vector(15:0)
      tTxDlyCount55                   => tTxDlyCount55,                    --in  std_logic_vector(15:0)
      tTxDlyCount56                   => tTxDlyCount56,                    --in  std_logic_vector(15:0)
      tTxDlyCount57                   => tTxDlyCount57,                    --in  std_logic_vector(15:0)
      tTxDlyCount58                   => tTxDlyCount58,                    --in  std_logic_vector(15:0)
      tTxDlyCount59                   => tTxDlyCount59,                    --in  std_logic_vector(15:0)
      tTxDlyCount60                   => tTxDlyCount60,                    --in  std_logic_vector(15:0)
      tTxDlyCount61                   => tTxDlyCount61,                    --in  std_logic_vector(15:0)
      tTxDlyCount62                   => tTxDlyCount62,                    --in  std_logic_vector(15:0)
      tTxDlyCount63                   => tTxDlyCount63,                    --in  std_logic_vector(15:0)
      tTxIncDecReady0                 => tTxIncDecReady0,                  --out std_logic
      tTxIncDecReady1                 => tTxIncDecReady1,                  --out std_logic
      tTxIncDecReady2                 => tTxIncDecReady2,                  --out std_logic
      tTxIncDecReady3                 => tTxIncDecReady3,                  --out std_logic
      tTxIncDecReady4                 => tTxIncDecReady4,                  --out std_logic
      tTxIncDecReady5                 => tTxIncDecReady5,                  --out std_logic
      tTxIncDecReady6                 => tTxIncDecReady6,                  --out std_logic
      tTxIncDecReady7                 => tTxIncDecReady7,                  --out std_logic
      tTxIncDecReady8                 => tTxIncDecReady8,                  --out std_logic
      tTxIncDecReady9                 => tTxIncDecReady9,                  --out std_logic
      tTxIncDecReady10                => tTxIncDecReady10,                 --out std_logic
      tTxIncDecReady11                => tTxIncDecReady11,                 --out std_logic
      tTxIncDecReady12                => tTxIncDecReady12,                 --out std_logic
      tTxIncDecReady13                => tTxIncDecReady13,                 --out std_logic
      tTxIncDecReady14                => tTxIncDecReady14,                 --out std_logic
      tTxIncDecReady15                => tTxIncDecReady15,                 --out std_logic
      tTxIncDecReady16                => tTxIncDecReady16,                 --out std_logic
      tTxIncDecReady17                => tTxIncDecReady17,                 --out std_logic
      tTxIncDecReady18                => tTxIncDecReady18,                 --out std_logic
      tTxIncDecReady19                => tTxIncDecReady19,                 --out std_logic
      tTxIncDecReady20                => tTxIncDecReady20,                 --out std_logic
      tTxIncDecReady21                => tTxIncDecReady21,                 --out std_logic
      tTxIncDecReady22                => tTxIncDecReady22,                 --out std_logic
      tTxIncDecReady23                => tTxIncDecReady23,                 --out std_logic
      tTxIncDecReady24                => tTxIncDecReady24,                 --out std_logic
      tTxIncDecReady25                => tTxIncDecReady25,                 --out std_logic
      tTxIncDecReady26                => tTxIncDecReady26,                 --out std_logic
      tTxIncDecReady27                => tTxIncDecReady27,                 --out std_logic
      tTxIncDecReady28                => tTxIncDecReady28,                 --out std_logic
      tTxIncDecReady29                => tTxIncDecReady29,                 --out std_logic
      tTxIncDecReady30                => tTxIncDecReady30,                 --out std_logic
      tTxIncDecReady31                => tTxIncDecReady31,                 --out std_logic
      tTxIncDecReady32                => tTxIncDecReady32,                 --out std_logic
      tTxIncDecReady33                => tTxIncDecReady33,                 --out std_logic
      tTxIncDecReady34                => tTxIncDecReady34,                 --out std_logic
      tTxIncDecReady35                => tTxIncDecReady35,                 --out std_logic
      tTxIncDecReady36                => tTxIncDecReady36,                 --out std_logic
      tTxIncDecReady37                => tTxIncDecReady37,                 --out std_logic
      tTxIncDecReady38                => tTxIncDecReady38,                 --out std_logic
      tTxIncDecReady39                => tTxIncDecReady39,                 --out std_logic
      tTxIncDecReady40                => tTxIncDecReady40,                 --out std_logic
      tTxIncDecReady41                => tTxIncDecReady41,                 --out std_logic
      tTxIncDecReady42                => tTxIncDecReady42,                 --out std_logic
      tTxIncDecReady43                => tTxIncDecReady43,                 --out std_logic
      tTxIncDecReady44                => tTxIncDecReady44,                 --out std_logic
      tTxIncDecReady45                => tTxIncDecReady45,                 --out std_logic
      tTxIncDecReady46                => tTxIncDecReady46,                 --out std_logic
      tTxIncDecReady47                => tTxIncDecReady47,                 --out std_logic
      tTxIncDecReady48                => tTxIncDecReady48,                 --out std_logic
      tTxIncDecReady49                => tTxIncDecReady49,                 --out std_logic
      tTxIncDecReady50                => tTxIncDecReady50,                 --out std_logic
      tTxIncDecReady51                => tTxIncDecReady51,                 --out std_logic
      tTxIncDecReady52                => tTxIncDecReady52,                 --out std_logic
      tTxIncDecReady53                => tTxIncDecReady53,                 --out std_logic
      tTxIncDecReady54                => tTxIncDecReady54,                 --out std_logic
      tTxIncDecReady55                => tTxIncDecReady55,                 --out std_logic
      tTxIncDecReady56                => tTxIncDecReady56,                 --out std_logic
      tTxIncDecReady57                => tTxIncDecReady57,                 --out std_logic
      tTxIncDecReady58                => tTxIncDecReady58,                 --out std_logic
      tTxIncDecReady59                => tTxIncDecReady59,                 --out std_logic
      tTxIncDecReady60                => tTxIncDecReady60,                 --out std_logic
      tTxIncDecReady61                => tTxIncDecReady61,                 --out std_logic
      tTxIncDecReady62                => tTxIncDecReady62,                 --out std_logic
      tTxIncDecReady63                => tTxIncDecReady63,                 --out std_logic
      mmcm_drp_s_aclk                 => mmcm_drp_s_aclk,                  --in  std_logic
      mmcm_drp_s_axi_awaddr           => mmcm_drp_s_axi_awaddr,            --in  std_logic_vector(31:0)
      mmcm_drp_s_axi_awvalid          => mmcm_drp_s_axi_awvalid,           --in  std_logic
      mmcm_drp_s_axi_awready          => mmcm_drp_s_axi_awready,           --out std_logic
      mmcm_drp_s_axi_wdata            => mmcm_drp_s_axi_wdata,             --in  std_logic_vector(31:0)
      mmcm_drp_s_axi_wstrb            => mmcm_drp_s_axi_wstrb,             --in  std_logic_vector(3:0)
      mmcm_drp_s_axi_wvalid           => mmcm_drp_s_axi_wvalid,            --in  std_logic
      mmcm_drp_s_axi_wready           => mmcm_drp_s_axi_wready,            --out std_logic
      mmcm_drp_s_axi_bresp            => mmcm_drp_s_axi_bresp,             --out std_logic_vector(1:0)
      mmcm_drp_s_axi_bvalid           => mmcm_drp_s_axi_bvalid,            --out std_logic
      mmcm_drp_s_axi_bready           => mmcm_drp_s_axi_bready,            --in  std_logic
      mmcm_drp_s_axi_araddr           => mmcm_drp_s_axi_araddr,            --in  std_logic_vector(31:0)
      mmcm_drp_s_axi_arvalid          => mmcm_drp_s_axi_arvalid,           --in  std_logic
      mmcm_drp_s_axi_arready          => mmcm_drp_s_axi_arready,           --out std_logic
      mmcm_drp_s_axi_rdata            => mmcm_drp_s_axi_rdata,             --out std_logic_vector(31:0)
      mmcm_drp_s_axi_rresp            => mmcm_drp_s_axi_rresp,             --out std_logic_vector(1:0)
      mmcm_drp_s_axi_rvalid           => mmcm_drp_s_axi_rvalid,            --out std_logic
      mmcm_drp_s_axi_rready           => mmcm_drp_s_axi_rready,            --in  std_logic
      aLvdsPfiDir0                    => aLvdsPfiDir0,                     --in  std_logic
      aLvdsPfiDir1                    => aLvdsPfiDir1,                     --in  std_logic
      aLvdsPfiInput0                  => aLvdsPfiInput0,                   --out std_logic
      aLvdsPfiInput1                  => aLvdsPfiInput1,                   --out std_logic
      aLvdsPfiOutput0                 => aLvdsPfiOutput0,                  --in  std_logic
      aLvdsPfiOutput1                 => aLvdsPfiOutput1,                  --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode);              --out std_logic_vector(31:0)

end rtl;
