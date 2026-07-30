-------------------------------------------------------------------------------
--
-- File: Ni6569SerdesClipAllInTop.vhd
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

entity Ni6569SerdesClipAllInTop is
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
    DeviceClkRxLV0      : out std_logic;
    DeviceClkRxLV1      : out std_logic;
    DeviceClkRxLV2      : out std_logic;

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
    rLvdsInput0         : out std_logic_vector(7 downto 0);
    rLvdsInput1         : out std_logic_vector(7 downto 0);
    rLvdsInput2         : out std_logic_vector(7 downto 0);
    rLvdsInput3         : out std_logic_vector(7 downto 0);
    rLvdsInput4         : out std_logic_vector(7 downto 0);
    rLvdsInput5         : out std_logic_vector(7 downto 0);
    rLvdsInput6         : out std_logic_vector(7 downto 0);
    rLvdsInput7         : out std_logic_vector(7 downto 0);
    rLvdsInput8         : out std_logic_vector(7 downto 0);
    rLvdsInput9         : out std_logic_vector(7 downto 0);
    rLvdsInput10        : out std_logic_vector(7 downto 0);
    rLvdsInput11        : out std_logic_vector(7 downto 0);
    rLvdsInput12        : out std_logic_vector(7 downto 0);
    rLvdsInput13        : out std_logic_vector(7 downto 0);
    rLvdsInput14        : out std_logic_vector(7 downto 0);
    rLvdsInput15        : out std_logic_vector(7 downto 0);
    rLvdsInput16        : out std_logic_vector(7 downto 0);
    rLvdsInput17        : out std_logic_vector(7 downto 0);
    rLvdsInput18        : out std_logic_vector(7 downto 0);
    rLvdsInput19        : out std_logic_vector(7 downto 0);
    rLvdsInput20        : out std_logic_vector(7 downto 0);
    rLvdsInput21        : out std_logic_vector(7 downto 0);
    rLvdsInput22        : out std_logic_vector(7 downto 0);
    rLvdsInput23        : out std_logic_vector(7 downto 0);
    rLvdsInput24        : out std_logic_vector(7 downto 0);
    rLvdsInput25        : out std_logic_vector(7 downto 0);
    rLvdsInput26        : out std_logic_vector(7 downto 0);
    rLvdsInput27        : out std_logic_vector(7 downto 0);
    rLvdsInput28        : out std_logic_vector(7 downto 0);
    rLvdsInput29        : out std_logic_vector(7 downto 0);
    rLvdsInput30        : out std_logic_vector(7 downto 0);
    rLvdsInput31        : out std_logic_vector(7 downto 0);
    rLvdsInput32        : out std_logic_vector(7 downto 0);
    rLvdsInput33        : out std_logic_vector(7 downto 0);
    rLvdsInput34        : out std_logic_vector(7 downto 0);
    rLvdsInput35        : out std_logic_vector(7 downto 0);
    rLvdsInput36        : out std_logic_vector(7 downto 0);
    rLvdsInput37        : out std_logic_vector(7 downto 0);
    rLvdsInput38        : out std_logic_vector(7 downto 0);
    rLvdsInput39        : out std_logic_vector(7 downto 0);
    rLvdsInput40        : out std_logic_vector(7 downto 0);
    rLvdsInput41        : out std_logic_vector(7 downto 0);
    rLvdsInput42        : out std_logic_vector(7 downto 0);
    rLvdsInput43        : out std_logic_vector(7 downto 0);
    rLvdsInput44        : out std_logic_vector(7 downto 0);
    rLvdsInput45        : out std_logic_vector(7 downto 0);
    rLvdsInput46        : out std_logic_vector(7 downto 0);
    rLvdsInput47        : out std_logic_vector(7 downto 0);
    rLvdsInput48        : out std_logic_vector(7 downto 0);
    rLvdsInput49        : out std_logic_vector(7 downto 0);
    rLvdsInput50        : out std_logic_vector(7 downto 0);
    rLvdsInput51        : out std_logic_vector(7 downto 0);
    rLvdsInput52        : out std_logic_vector(7 downto 0);
    rLvdsInput53        : out std_logic_vector(7 downto 0);
    rLvdsInput54        : out std_logic_vector(7 downto 0);
    rLvdsInput55        : out std_logic_vector(7 downto 0);
    rLvdsInput56        : out std_logic_vector(7 downto 0);
    rLvdsInput57        : out std_logic_vector(7 downto 0);
    rLvdsInput58        : out std_logic_vector(7 downto 0);
    rLvdsInput59        : out std_logic_vector(7 downto 0);
    rLvdsInput60        : out std_logic_vector(7 downto 0);
    rLvdsInput61        : out std_logic_vector(7 downto 0);
    rLvdsInput62        : out std_logic_vector(7 downto 0);
    rLvdsInput63        : out std_logic_vector(7 downto 0);

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
    rRxIncDecReady63    : out std_logic;

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

    -- LVDS Data Bitslip Lines
    rBitslip0           : in std_logic;
    rBitslip1           : in std_logic;
    rBitslip2           : in std_logic;
    rBitslip3           : in std_logic;
    rBitslip4           : in std_logic;
    rBitslip5           : in std_logic;
    rBitslip6           : in std_logic;
    rBitslip7           : in std_logic;
    rBitslip8           : in std_logic;
    rBitslip9           : in std_logic;
    rBitslip10          : in std_logic;
    rBitslip11          : in std_logic;
    rBitslip12          : in std_logic;
    rBitslip13          : in std_logic;
    rBitslip14          : in std_logic;
    rBitslip15          : in std_logic;
    rBitslip16          : in std_logic;
    rBitslip17          : in std_logic;
    rBitslip18          : in std_logic;
    rBitslip19          : in std_logic;
    rBitslip20          : in std_logic;
    rBitslip21          : in std_logic;
    rBitslip22          : in std_logic;
    rBitslip23          : in std_logic;
    rBitslip24          : in std_logic;
    rBitslip25          : in std_logic;
    rBitslip26          : in std_logic;
    rBitslip27          : in std_logic;
    rBitslip28          : in std_logic;
    rBitslip29          : in std_logic;
    rBitslip30          : in std_logic;
    rBitslip31          : in std_logic;
    rBitslip32          : in std_logic;
    rBitslip33          : in std_logic;
    rBitslip34          : in std_logic;
    rBitslip35          : in std_logic;
    rBitslip36          : in std_logic;
    rBitslip37          : in std_logic;
    rBitslip38          : in std_logic;
    rBitslip39          : in std_logic;
    rBitslip40          : in std_logic;
    rBitslip41          : in std_logic;
    rBitslip42          : in std_logic;
    rBitslip43          : in std_logic;
    rBitslip44          : in std_logic;
    rBitslip45          : in std_logic;
    rBitslip46          : in std_logic;
    rBitslip47          : in std_logic;
    rBitslip48          : in std_logic;
    rBitslip49          : in std_logic;
    rBitslip50          : in std_logic;
    rBitslip51          : in std_logic;
    rBitslip52          : in std_logic;
    rBitslip53          : in std_logic;
    rBitslip54          : in std_logic;
    rBitslip55          : in std_logic;
    rBitslip56          : in std_logic;
    rBitslip57          : in std_logic;
    rBitslip58          : in std_logic;
    rBitslip59          : in std_logic;
    rBitslip60          : in std_logic;
    rBitslip61          : in std_logic;
    rBitslip62          : in std_logic;
    rBitslip63          : in std_logic;

    -- LVDS PFI Lines
    aLvdsPfiDir0        : in std_logic;
    aLvdsPfiDir1        : in std_logic;
    aLvdsPfiInput0      : out std_logic;
    aLvdsPfiInput1      : out std_logic;
    aLvdsPfiOutput0     : in std_logic;
    aLvdsPfiOutput1     : in std_logic
    );
end entity Ni6569SerdesClipAllInTop;

architecture rtl of Ni6569SerdesClipAllInTop is

  component Ni6569SerdesClipAllInFl
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
      RxDataClkToTopLevel0            : out std_logic;
      RxDataClkToTopLevel1            : out std_logic;
      RxDataClkToTopLevel2            : out std_logic;
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
      rLvdsInput0                     : out std_logic_vector(7 downto 0);
      rLvdsInput1                     : out std_logic_vector(7 downto 0);
      rLvdsInput2                     : out std_logic_vector(7 downto 0);
      rLvdsInput3                     : out std_logic_vector(7 downto 0);
      rLvdsInput4                     : out std_logic_vector(7 downto 0);
      rLvdsInput5                     : out std_logic_vector(7 downto 0);
      rLvdsInput6                     : out std_logic_vector(7 downto 0);
      rLvdsInput7                     : out std_logic_vector(7 downto 0);
      rLvdsInput8                     : out std_logic_vector(7 downto 0);
      rLvdsInput9                     : out std_logic_vector(7 downto 0);
      rLvdsInput10                    : out std_logic_vector(7 downto 0);
      rLvdsInput11                    : out std_logic_vector(7 downto 0);
      rLvdsInput12                    : out std_logic_vector(7 downto 0);
      rLvdsInput13                    : out std_logic_vector(7 downto 0);
      rLvdsInput14                    : out std_logic_vector(7 downto 0);
      rLvdsInput15                    : out std_logic_vector(7 downto 0);
      rLvdsInput16                    : out std_logic_vector(7 downto 0);
      rLvdsInput17                    : out std_logic_vector(7 downto 0);
      rLvdsInput18                    : out std_logic_vector(7 downto 0);
      rLvdsInput19                    : out std_logic_vector(7 downto 0);
      rLvdsInput20                    : out std_logic_vector(7 downto 0);
      rLvdsInput21                    : out std_logic_vector(7 downto 0);
      rLvdsInput22                    : out std_logic_vector(7 downto 0);
      rLvdsInput23                    : out std_logic_vector(7 downto 0);
      rLvdsInput24                    : out std_logic_vector(7 downto 0);
      rLvdsInput25                    : out std_logic_vector(7 downto 0);
      rLvdsInput26                    : out std_logic_vector(7 downto 0);
      rLvdsInput27                    : out std_logic_vector(7 downto 0);
      rLvdsInput28                    : out std_logic_vector(7 downto 0);
      rLvdsInput29                    : out std_logic_vector(7 downto 0);
      rLvdsInput30                    : out std_logic_vector(7 downto 0);
      rLvdsInput31                    : out std_logic_vector(7 downto 0);
      rLvdsInput32                    : out std_logic_vector(7 downto 0);
      rLvdsInput33                    : out std_logic_vector(7 downto 0);
      rLvdsInput34                    : out std_logic_vector(7 downto 0);
      rLvdsInput35                    : out std_logic_vector(7 downto 0);
      rLvdsInput36                    : out std_logic_vector(7 downto 0);
      rLvdsInput37                    : out std_logic_vector(7 downto 0);
      rLvdsInput38                    : out std_logic_vector(7 downto 0);
      rLvdsInput39                    : out std_logic_vector(7 downto 0);
      rLvdsInput40                    : out std_logic_vector(7 downto 0);
      rLvdsInput41                    : out std_logic_vector(7 downto 0);
      rLvdsInput42                    : out std_logic_vector(7 downto 0);
      rLvdsInput43                    : out std_logic_vector(7 downto 0);
      rLvdsInput44                    : out std_logic_vector(7 downto 0);
      rLvdsInput45                    : out std_logic_vector(7 downto 0);
      rLvdsInput46                    : out std_logic_vector(7 downto 0);
      rLvdsInput47                    : out std_logic_vector(7 downto 0);
      rLvdsInput48                    : out std_logic_vector(7 downto 0);
      rLvdsInput49                    : out std_logic_vector(7 downto 0);
      rLvdsInput50                    : out std_logic_vector(7 downto 0);
      rLvdsInput51                    : out std_logic_vector(7 downto 0);
      rLvdsInput52                    : out std_logic_vector(7 downto 0);
      rLvdsInput53                    : out std_logic_vector(7 downto 0);
      rLvdsInput54                    : out std_logic_vector(7 downto 0);
      rLvdsInput55                    : out std_logic_vector(7 downto 0);
      rLvdsInput56                    : out std_logic_vector(7 downto 0);
      rLvdsInput57                    : out std_logic_vector(7 downto 0);
      rLvdsInput58                    : out std_logic_vector(7 downto 0);
      rLvdsInput59                    : out std_logic_vector(7 downto 0);
      rLvdsInput60                    : out std_logic_vector(7 downto 0);
      rLvdsInput61                    : out std_logic_vector(7 downto 0);
      rLvdsInput62                    : out std_logic_vector(7 downto 0);
      rLvdsInput63                    : out std_logic_vector(7 downto 0);
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
      rBitslip0                       : in  std_logic;
      rBitslip1                       : in  std_logic;
      rBitslip2                       : in  std_logic;
      rBitslip3                       : in  std_logic;
      rBitslip4                       : in  std_logic;
      rBitslip5                       : in  std_logic;
      rBitslip6                       : in  std_logic;
      rBitslip7                       : in  std_logic;
      rBitslip8                       : in  std_logic;
      rBitslip9                       : in  std_logic;
      rBitslip10                      : in  std_logic;
      rBitslip11                      : in  std_logic;
      rBitslip12                      : in  std_logic;
      rBitslip13                      : in  std_logic;
      rBitslip14                      : in  std_logic;
      rBitslip15                      : in  std_logic;
      rBitslip16                      : in  std_logic;
      rBitslip17                      : in  std_logic;
      rBitslip18                      : in  std_logic;
      rBitslip19                      : in  std_logic;
      rBitslip20                      : in  std_logic;
      rBitslip21                      : in  std_logic;
      rBitslip22                      : in  std_logic;
      rBitslip23                      : in  std_logic;
      rBitslip24                      : in  std_logic;
      rBitslip25                      : in  std_logic;
      rBitslip26                      : in  std_logic;
      rBitslip27                      : in  std_logic;
      rBitslip28                      : in  std_logic;
      rBitslip29                      : in  std_logic;
      rBitslip30                      : in  std_logic;
      rBitslip31                      : in  std_logic;
      rBitslip32                      : in  std_logic;
      rBitslip33                      : in  std_logic;
      rBitslip34                      : in  std_logic;
      rBitslip35                      : in  std_logic;
      rBitslip36                      : in  std_logic;
      rBitslip37                      : in  std_logic;
      rBitslip38                      : in  std_logic;
      rBitslip39                      : in  std_logic;
      rBitslip40                      : in  std_logic;
      rBitslip41                      : in  std_logic;
      rBitslip42                      : in  std_logic;
      rBitslip43                      : in  std_logic;
      rBitslip44                      : in  std_logic;
      rBitslip45                      : in  std_logic;
      rBitslip46                      : in  std_logic;
      rBitslip47                      : in  std_logic;
      rBitslip48                      : in  std_logic;
      rBitslip49                      : in  std_logic;
      rBitslip50                      : in  std_logic;
      rBitslip51                      : in  std_logic;
      rBitslip52                      : in  std_logic;
      rBitslip53                      : in  std_logic;
      rBitslip54                      : in  std_logic;
      rBitslip55                      : in  std_logic;
      rBitslip56                      : in  std_logic;
      rBitslip57                      : in  std_logic;
      rBitslip58                      : in  std_logic;
      rBitslip59                      : in  std_logic;
      rBitslip60                      : in  std_logic;
      rBitslip61                      : in  std_logic;
      rBitslip62                      : in  std_logic;
      rBitslip63                      : in  std_logic;
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
  signal RxDataClkToTopLevel0: std_logic;
  signal RxDataClkToTopLevel1: std_logic;
  signal RxDataClkToTopLevel2: std_logic;
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

  DeviceClkRxLV0 <= RxDataClkToTopLevel0;
  DeviceClkRxLV1 <= RxDataClkToTopLevel1;
  DeviceClkRxLV2 <= RxDataClkToTopLevel2;


  --vhook Ni6569SerdesClipAllInFl
  Ni6569SerdesClipAllInFlx: Ni6569SerdesClipAllInFl
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
      RxDataClkToTopLevel0            => RxDataClkToTopLevel0,             --out std_logic
      RxDataClkToTopLevel1            => RxDataClkToTopLevel1,             --out std_logic
      RxDataClkToTopLevel2            => RxDataClkToTopLevel2,             --out std_logic
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
      rLvdsInput0                     => rLvdsInput0,                      --out std_logic_vector(7:0)
      rLvdsInput1                     => rLvdsInput1,                      --out std_logic_vector(7:0)
      rLvdsInput2                     => rLvdsInput2,                      --out std_logic_vector(7:0)
      rLvdsInput3                     => rLvdsInput3,                      --out std_logic_vector(7:0)
      rLvdsInput4                     => rLvdsInput4,                      --out std_logic_vector(7:0)
      rLvdsInput5                     => rLvdsInput5,                      --out std_logic_vector(7:0)
      rLvdsInput6                     => rLvdsInput6,                      --out std_logic_vector(7:0)
      rLvdsInput7                     => rLvdsInput7,                      --out std_logic_vector(7:0)
      rLvdsInput8                     => rLvdsInput8,                      --out std_logic_vector(7:0)
      rLvdsInput9                     => rLvdsInput9,                      --out std_logic_vector(7:0)
      rLvdsInput10                    => rLvdsInput10,                     --out std_logic_vector(7:0)
      rLvdsInput11                    => rLvdsInput11,                     --out std_logic_vector(7:0)
      rLvdsInput12                    => rLvdsInput12,                     --out std_logic_vector(7:0)
      rLvdsInput13                    => rLvdsInput13,                     --out std_logic_vector(7:0)
      rLvdsInput14                    => rLvdsInput14,                     --out std_logic_vector(7:0)
      rLvdsInput15                    => rLvdsInput15,                     --out std_logic_vector(7:0)
      rLvdsInput16                    => rLvdsInput16,                     --out std_logic_vector(7:0)
      rLvdsInput17                    => rLvdsInput17,                     --out std_logic_vector(7:0)
      rLvdsInput18                    => rLvdsInput18,                     --out std_logic_vector(7:0)
      rLvdsInput19                    => rLvdsInput19,                     --out std_logic_vector(7:0)
      rLvdsInput20                    => rLvdsInput20,                     --out std_logic_vector(7:0)
      rLvdsInput21                    => rLvdsInput21,                     --out std_logic_vector(7:0)
      rLvdsInput22                    => rLvdsInput22,                     --out std_logic_vector(7:0)
      rLvdsInput23                    => rLvdsInput23,                     --out std_logic_vector(7:0)
      rLvdsInput24                    => rLvdsInput24,                     --out std_logic_vector(7:0)
      rLvdsInput25                    => rLvdsInput25,                     --out std_logic_vector(7:0)
      rLvdsInput26                    => rLvdsInput26,                     --out std_logic_vector(7:0)
      rLvdsInput27                    => rLvdsInput27,                     --out std_logic_vector(7:0)
      rLvdsInput28                    => rLvdsInput28,                     --out std_logic_vector(7:0)
      rLvdsInput29                    => rLvdsInput29,                     --out std_logic_vector(7:0)
      rLvdsInput30                    => rLvdsInput30,                     --out std_logic_vector(7:0)
      rLvdsInput31                    => rLvdsInput31,                     --out std_logic_vector(7:0)
      rLvdsInput32                    => rLvdsInput32,                     --out std_logic_vector(7:0)
      rLvdsInput33                    => rLvdsInput33,                     --out std_logic_vector(7:0)
      rLvdsInput34                    => rLvdsInput34,                     --out std_logic_vector(7:0)
      rLvdsInput35                    => rLvdsInput35,                     --out std_logic_vector(7:0)
      rLvdsInput36                    => rLvdsInput36,                     --out std_logic_vector(7:0)
      rLvdsInput37                    => rLvdsInput37,                     --out std_logic_vector(7:0)
      rLvdsInput38                    => rLvdsInput38,                     --out std_logic_vector(7:0)
      rLvdsInput39                    => rLvdsInput39,                     --out std_logic_vector(7:0)
      rLvdsInput40                    => rLvdsInput40,                     --out std_logic_vector(7:0)
      rLvdsInput41                    => rLvdsInput41,                     --out std_logic_vector(7:0)
      rLvdsInput42                    => rLvdsInput42,                     --out std_logic_vector(7:0)
      rLvdsInput43                    => rLvdsInput43,                     --out std_logic_vector(7:0)
      rLvdsInput44                    => rLvdsInput44,                     --out std_logic_vector(7:0)
      rLvdsInput45                    => rLvdsInput45,                     --out std_logic_vector(7:0)
      rLvdsInput46                    => rLvdsInput46,                     --out std_logic_vector(7:0)
      rLvdsInput47                    => rLvdsInput47,                     --out std_logic_vector(7:0)
      rLvdsInput48                    => rLvdsInput48,                     --out std_logic_vector(7:0)
      rLvdsInput49                    => rLvdsInput49,                     --out std_logic_vector(7:0)
      rLvdsInput50                    => rLvdsInput50,                     --out std_logic_vector(7:0)
      rLvdsInput51                    => rLvdsInput51,                     --out std_logic_vector(7:0)
      rLvdsInput52                    => rLvdsInput52,                     --out std_logic_vector(7:0)
      rLvdsInput53                    => rLvdsInput53,                     --out std_logic_vector(7:0)
      rLvdsInput54                    => rLvdsInput54,                     --out std_logic_vector(7:0)
      rLvdsInput55                    => rLvdsInput55,                     --out std_logic_vector(7:0)
      rLvdsInput56                    => rLvdsInput56,                     --out std_logic_vector(7:0)
      rLvdsInput57                    => rLvdsInput57,                     --out std_logic_vector(7:0)
      rLvdsInput58                    => rLvdsInput58,                     --out std_logic_vector(7:0)
      rLvdsInput59                    => rLvdsInput59,                     --out std_logic_vector(7:0)
      rLvdsInput60                    => rLvdsInput60,                     --out std_logic_vector(7:0)
      rLvdsInput61                    => rLvdsInput61,                     --out std_logic_vector(7:0)
      rLvdsInput62                    => rLvdsInput62,                     --out std_logic_vector(7:0)
      rLvdsInput63                    => rLvdsInput63,                     --out std_logic_vector(7:0)
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
      rBitslip0                       => rBitslip0,                        --in  std_logic
      rBitslip1                       => rBitslip1,                        --in  std_logic
      rBitslip2                       => rBitslip2,                        --in  std_logic
      rBitslip3                       => rBitslip3,                        --in  std_logic
      rBitslip4                       => rBitslip4,                        --in  std_logic
      rBitslip5                       => rBitslip5,                        --in  std_logic
      rBitslip6                       => rBitslip6,                        --in  std_logic
      rBitslip7                       => rBitslip7,                        --in  std_logic
      rBitslip8                       => rBitslip8,                        --in  std_logic
      rBitslip9                       => rBitslip9,                        --in  std_logic
      rBitslip10                      => rBitslip10,                       --in  std_logic
      rBitslip11                      => rBitslip11,                       --in  std_logic
      rBitslip12                      => rBitslip12,                       --in  std_logic
      rBitslip13                      => rBitslip13,                       --in  std_logic
      rBitslip14                      => rBitslip14,                       --in  std_logic
      rBitslip15                      => rBitslip15,                       --in  std_logic
      rBitslip16                      => rBitslip16,                       --in  std_logic
      rBitslip17                      => rBitslip17,                       --in  std_logic
      rBitslip18                      => rBitslip18,                       --in  std_logic
      rBitslip19                      => rBitslip19,                       --in  std_logic
      rBitslip20                      => rBitslip20,                       --in  std_logic
      rBitslip21                      => rBitslip21,                       --in  std_logic
      rBitslip22                      => rBitslip22,                       --in  std_logic
      rBitslip23                      => rBitslip23,                       --in  std_logic
      rBitslip24                      => rBitslip24,                       --in  std_logic
      rBitslip25                      => rBitslip25,                       --in  std_logic
      rBitslip26                      => rBitslip26,                       --in  std_logic
      rBitslip27                      => rBitslip27,                       --in  std_logic
      rBitslip28                      => rBitslip28,                       --in  std_logic
      rBitslip29                      => rBitslip29,                       --in  std_logic
      rBitslip30                      => rBitslip30,                       --in  std_logic
      rBitslip31                      => rBitslip31,                       --in  std_logic
      rBitslip32                      => rBitslip32,                       --in  std_logic
      rBitslip33                      => rBitslip33,                       --in  std_logic
      rBitslip34                      => rBitslip34,                       --in  std_logic
      rBitslip35                      => rBitslip35,                       --in  std_logic
      rBitslip36                      => rBitslip36,                       --in  std_logic
      rBitslip37                      => rBitslip37,                       --in  std_logic
      rBitslip38                      => rBitslip38,                       --in  std_logic
      rBitslip39                      => rBitslip39,                       --in  std_logic
      rBitslip40                      => rBitslip40,                       --in  std_logic
      rBitslip41                      => rBitslip41,                       --in  std_logic
      rBitslip42                      => rBitslip42,                       --in  std_logic
      rBitslip43                      => rBitslip43,                       --in  std_logic
      rBitslip44                      => rBitslip44,                       --in  std_logic
      rBitslip45                      => rBitslip45,                       --in  std_logic
      rBitslip46                      => rBitslip46,                       --in  std_logic
      rBitslip47                      => rBitslip47,                       --in  std_logic
      rBitslip48                      => rBitslip48,                       --in  std_logic
      rBitslip49                      => rBitslip49,                       --in  std_logic
      rBitslip50                      => rBitslip50,                       --in  std_logic
      rBitslip51                      => rBitslip51,                       --in  std_logic
      rBitslip52                      => rBitslip52,                       --in  std_logic
      rBitslip53                      => rBitslip53,                       --in  std_logic
      rBitslip54                      => rBitslip54,                       --in  std_logic
      rBitslip55                      => rBitslip55,                       --in  std_logic
      rBitslip56                      => rBitslip56,                       --in  std_logic
      rBitslip57                      => rBitslip57,                       --in  std_logic
      rBitslip58                      => rBitslip58,                       --in  std_logic
      rBitslip59                      => rBitslip59,                       --in  std_logic
      rBitslip60                      => rBitslip60,                       --in  std_logic
      rBitslip61                      => rBitslip61,                       --in  std_logic
      rBitslip62                      => rBitslip62,                       --in  std_logic
      rBitslip63                      => rBitslip63,                       --in  std_logic
      aLvdsPfiDir0                    => aLvdsPfiDir0,                     --in  std_logic
      aLvdsPfiDir1                    => aLvdsPfiDir1,                     --in  std_logic
      aLvdsPfiInput0                  => aLvdsPfiInput0,                   --out std_logic
      aLvdsPfiInput1                  => aLvdsPfiInput1,                   --out std_logic
      aLvdsPfiOutput0                 => aLvdsPfiOutput0,                  --in  std_logic
      aLvdsPfiOutput1                 => aLvdsPfiOutput1,                  --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode);              --out std_logic_vector(31:0)

  end rtl;
