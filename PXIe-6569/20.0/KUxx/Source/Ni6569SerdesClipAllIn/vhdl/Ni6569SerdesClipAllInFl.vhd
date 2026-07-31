-------------------------------------------------------------------------------
--
-- File: Ni6569SerdesClipAllInFl.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 13 June 2019
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
--  Top level file for NI 6569 Fixed Logic.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgAxi4Lite.all;
  use work.PkgSRegPort.all;
  use work.PkgNi6569.all;

entity Ni6569SerdesClipAllInFl is
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
    xIoOutputEnable                    : in std_logic;

    -------------------------------
    -- FAM Synchronization Plane --
    -------------------------------
    DeviceClk                          : in  std_logic;
    SampleClk                          : in  std_logic;

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
    ---------------------------------------------------------------------------
    --                     Fabric Interface                                  --
    ---------------------------------------------------------------------------
    aDiagramResetSL                    : in  std_logic;
    aDiagramClkEnable                  : in  std_logic;

    ---------------------------------------------------------------------------
    --                     LabVIEW Interface                                 --
    ---------------------------------------------------------------------------
    -- LabVIEW clock interface
    RxDataClkToTopLevel0: out std_logic;
    RxDataClkToTopLevel1: out std_logic;
    RxDataClkToTopLevel2: out std_logic;

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
    aLvdsPfiOutput1     : in std_logic;

    -- Misc
    xIoModuleReady      : out std_logic;
    xIoModuleErrorCode  : out std_logic_vector(31 downto 0)
    );
end entity Ni6569SerdesClipAllInFl;

architecture rtl of Ni6569SerdesClipAllInFl is

  component AcquisitionEngine
    generic (
      kNumChannels      : natural := 31;
      kIoDelayGroupName : string := "IdelayGroup");
    port (
      aDiagramResetSL : in  std_logic;
      aResetDelay     : in  std_logic;
      aResetSerdes    : in  std_logic;
      AcqClk          : in  std_logic;
      AcqClkDiv       : in  std_logic;
      RxDataClk       : in  std_logic;
      aLvdsInput      : in  std_logic_vector(kNumChannels-1 downto 0);
      qLvdsAcqData    : out DeserArray_t(kNumChannels-1 downto 0);
      qLvdsBitslip    : in  std_logic_vector(kNumChannels-1 downto 0);
      rRxInc          : in  std_logic_vector(kNumChannels-1 downto 0);
      rRxClkDelayEn   : in  std_logic_vector(kNumChannels-1 downto 0);
      rDlyCount       : in  DelayArray_t(kNumChannels-1 downto 0);
      rRxCntValOut    : out DelayArray_t(kNumChannels-1 downto 0);
      aDelayCtrlRdy   : in  std_logic;
      rIncDecReady    : out std_logic_vector(kNumChannels-1 downto 0));
  end component;
  component PinsMappingAllIn
    port (
      aDiagramResetSL : in  std_logic;
      SeRegisterClk   : in  std_logic;
      aIoOutputEnable : in  std_logic;
      aDiffGpio_p     : inout std_logic_vector(69 downto 0);
      aDiffGpio_n     : inout std_logic_vector(69 downto 0);
      aSeGpio         : inout std_logic_vector(15 downto 0);
      aSeDir          : in  std_logic_vector(7 downto 0);
      aSeOutput       : in  std_logic_vector(7 downto 0);
      aSeInput        : out std_logic_vector(7 downto 0);
      aLvdsInput      : out std_logic_vector(63 downto 0);
      aLvdsPfiDir     : in  std_logic_vector(1 downto 0);
      aLvdsPfiOutput  : in  std_logic_vector(1 downto 0);
      aLvdsPfiInput   : out std_logic_vector(1 downto 0));
  end component;
  component TimingEngineAllIn
    port (
      BusClk                   : in  std_logic;
      bAxiPeriphReset_n        : in  std_logic;
      aDelayCtrlRdy0           : in  std_logic;
      aDelayCtrlRdy1           : in  std_logic;
      aDelayCtrlRdy2           : in  std_logic;
      bAxiWriteAddressChannel  : in  Axi4LiteAddressChannel_t;
      bAxiWriteAddressReady    : out boolean;
      bAxiWriteDataChannel     : in  Axi4LiteWriteDataChannel_t;
      bAxiWriteDataReady       : out boolean;
      bAxiWriteResponseChannel : out Axi4LiteWriteResponseChannel_t;
      bAxiWriteResponseReady   : in  boolean;
      bAxiReadAddressChannel   : in  Axi4LiteAddressChannel_t;
      bAxiReadAddressReady     : out boolean;
      bAxiReadDataChannel      : out Axi4LiteReadDataChannel_t;
      bAxiReadDataReady        : in  boolean;
      RxSSClk0                 : in  std_logic;
      RxSSClk1                 : in  std_logic;
      RxSSClk2                 : in  std_logic;
      SiClk                    : in  std_logic;
      LmkClk                   : in  std_logic;
      RxDataClk0               : out std_logic;
      RxDataClk1               : out std_logic;
      RxDataClk2               : out std_logic;
      ISerdesClkDiv0           : out std_logic;
      ISerdesClkDiv1           : out std_logic;
      ISerdesClkDiv2           : out std_logic;
      ISerdesClk0              : out std_logic;
      ISerdesClk1              : out std_logic;
      ISerdesClk2              : out std_logic;
      DelayRefClk              : out std_logic;
      SeRegisterClk            : out std_logic;
      DrpClk                   : in  std_logic;
      dDrpAddr                 : in  std_logic_vector(6 downto 0);
      dDrpDataIn               : in  std_logic_vector(15 downto 0);
      dDrpDataOut              : out std_logic_vector(15 downto 0);
      dDrpEn                   : in  std_logic;
      dDrpWe                   : in  std_logic;
      dDrpRdy                  : out std_logic;
      aDiagramClkEnable        : in  std_logic);
  end component;
  component FixedLogicSerdesCommon
    generic (kFamId : std_logic_vector(31 downto 0) := (others=>'0'));
    port (
      AxiClk                          : in  std_logic;
      aDiagramResetSL                 : in  std_logic;
      aSpiCs_n                        : out std_logic;
      aSpiMiso                        : in  std_logic;
      aSpiMosi                        : out std_logic;
      aSpiSck                         : out std_logic;
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
      xAxiPeriphReset_n               : out std_logic;
      xTimingAxiWriteAddressChannel   : out Axi4LiteAddressChannel_t;
      xTimingAxiWriteAddressReady     : in  boolean;
      xTimingAxiWriteDataChannel      : out Axi4LiteWriteDataChannel_t;
      xTimingAxiWriteDataReady        : in  boolean;
      xTimingAxiWriteResponseChannel  : in  Axi4LiteWriteResponseChannel_t;
      xTimingAxiWriteResponseReady    : out boolean;
      xTimingAxiReadAddressChannel    : out Axi4LiteAddressChannel_t;
      xTimingAxiReadAddressReady      : in  boolean;
      xTimingAxiReadDataChannel       : in  Axi4LiteReadDataChannel_t;
      xTimingAxiReadDataReady         : out boolean;
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
      DrpClk                          : out std_logic;
      dDrpAddr                        : out std_logic_vector(6 downto 0);
      dDrpDataIn                      : out std_logic_vector(15 downto 0);
      dDrpDataOut                     : in  std_logic_vector(15 downto 0);
      dDrpEn                          : out std_logic;
      dDrpWe                          : out std_logic;
      dDrpRdy                         : in  std_logic;
      aConfigReset_n                  : out std_logic;
      aConfigInterrupt                : in  std_logic;
      aPllStatus0                     : in  std_logic;
      aPllStatus1                     : in  std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      xResetDelay                     : out std_logic;
      xResetSerdes                    : out std_logic;
      xResetDelayCtrl                 : out std_logic);
  end component;

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#10937A9D#, 32));

  --vhook_sigstart
  signal aConfigInterrupt: std_logic;
  signal aConfigReset_n: std_logic;
  signal aDelayCtrlRdy0: std_ulogic;
  signal aDelayCtrlRdy1: std_ulogic;
  signal aDelayCtrlRdy2: std_ulogic;
  signal aLvdsInputFromIBuf: std_logic_vector(63 downto 0);
  signal aPllStatus0: std_logic;
  signal aPllStatus1: std_logic;
  signal aSeDir: std_logic_vector(7 downto 0);
  signal aSeInput: std_logic_vector(7 downto 0);
  signal aSeOutput: std_logic_vector(7 downto 0);
  signal aSpiCs_n: std_logic;
  signal aSpiMiso: std_logic;
  signal aSpiMosi: std_logic;
  signal aSpiSck: std_logic;
  signal dDrpAddr: std_logic_vector(6 downto 0);
  signal dDrpDataIn: std_logic_vector(15 downto 0);
  signal dDrpDataOut: std_logic_vector(15 downto 0);
  signal dDrpEn: std_logic;
  signal dDrpRdy: std_logic;
  signal dDrpWe: std_logic;
  signal DelayRefClk: std_ulogic;
  signal DrpClk: std_logic;
  signal ISerdesClk0: std_logic;
  signal ISerdesClk1: std_logic;
  signal ISerdesClk2: std_logic;
  signal ISerdesClkDiv0: std_logic;
  signal ISerdesClkDiv1: std_logic;
  signal ISerdesClkDiv2: std_logic;
  signal RxDataClk0: std_logic;
  signal RxDataClk1: std_logic;
  signal RxDataClk2: std_logic;
  signal RxDataClkInternal0: std_logic;
  signal RxDataClkInternal1: std_logic;
  signal RxDataClkInternal2: std_logic;
  signal SeRegisterClk: std_logic;
  signal xAxiPeriphReset_n: std_logic;
  signal xResetDelay: std_logic;
  signal xResetDelayCtrl: std_ulogic;
  signal xResetSerdes: std_logic;
  signal xTimingAxiReadAddressChannel: Axi4LiteAddressChannel_t;
  signal xTimingAxiReadAddressReady: boolean;
  signal xTimingAxiReadDataChannel: Axi4LiteReadDataChannel_t;
  signal xTimingAxiReadDataReady: boolean;
  signal xTimingAxiWriteAddressChannel: Axi4LiteAddressChannel_t;
  signal xTimingAxiWriteAddressReady: boolean;
  signal xTimingAxiWriteDataChannel: Axi4LiteWriteDataChannel_t;
  signal xTimingAxiWriteDataReady: boolean;
  signal xTimingAxiWriteResponseChannel: Axi4LiteWriteResponseChannel_t;
  signal xTimingAxiWriteResponseReady: boolean;
  --vhook_sigend

  signal aLvdsPfiInputFromIbuf : std_logic_vector(1 downto 0);
  signal aLvdsPfiDirLcl        : std_logic_vector(1 downto 0);
  signal aLvdsPfiOutputLcl     : std_logic_vector(1 downto 0);
  signal rRxInc                : std_logic_vector(60 downto 0);
  signal rRxClkDelayEn         : std_logic_vector(60 downto 0);
  signal rIncDecReady          : std_logic_vector(60 downto 0);
  signal rDlyCount             : DelayArray_t(60 downto 0);
  signal rRxCntValOut          : DelayArray_t(60 downto 0);
  signal qLvdsAcqData          : DeserArray_t(60 downto 0);
  signal qLvdsBitslip          : std_logic_vector(60 downto 0);
  constant kIoDelayGroupNameBank44 : string := "IdelayGroupBank44";
  constant kIoDelayGroupNameBank45 : string := "IdelayGroupBank45";
  constant kIoDelayGroupNameBank46 : string := "IdelayGroupBank46";
  attribute IODELAY_GROUP         : string;
  attribute IODELAY_GROUP of DataIDelayCtrlBank44 : label is kIoDelayGroupNameBank44;
  attribute IODELAY_GROUP of DataIDelayCtrlBank45 : label is kIoDelayGroupNameBank45;
  attribute IODELAY_GROUP of DataIDelayCtrlBank46 : label is kIoDelayGroupNameBank46;

begin

  --vhook_nowarn rRxDlyCount0
  --vhook_nowarn rRxInc0
  --vhook_nowarn rRxClkDelayEn0
  --vhook_nowarn rRxDlyCount40
  --vhook_nowarn rRxInc40
  --vhook_nowarn rRxClkDelayEn40
  --vhook_nowarn rRxDlyCount46
  --vhook_nowarn rRxInc46
  --vhook_nowarn rRxClkDelayEn46
  --vhook_nowarn drp_* gtwiz_* mmcm_*

  --vhook FixedLogicSerdesCommon
  FixedLogicSerdesCommonx: FixedLogicSerdesCommon
    generic map (kFamId => kFamId)  --std_logic_vector(31:0):=(others=>'0')
    port map (
      AxiClk                          => AxiClk,                           --in  std_logic
      aDiagramResetSL                 => aDiagramResetSL,                  --in  std_logic
      aSpiCs_n                        => aSpiCs_n,                         --out std_logic
      aSpiMiso                        => aSpiMiso,                         --in  std_logic
      aSpiMosi                        => aSpiMosi,                         --out std_logic
      aSpiSck                         => aSpiSck,                          --out std_logic
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
      xAxiPeriphReset_n               => xAxiPeriphReset_n,                --out std_logic
      xTimingAxiWriteAddressChannel   => xTimingAxiWriteAddressChannel,    --out Axi4LiteAddressChannel_t
      xTimingAxiWriteAddressReady     => xTimingAxiWriteAddressReady,      --in  boolean
      xTimingAxiWriteDataChannel      => xTimingAxiWriteDataChannel,       --out Axi4LiteWriteDataChannel_t
      xTimingAxiWriteDataReady        => xTimingAxiWriteDataReady,         --in  boolean
      xTimingAxiWriteResponseChannel  => xTimingAxiWriteResponseChannel,   --in  Axi4LiteWriteResponseChannel_t
      xTimingAxiWriteResponseReady    => xTimingAxiWriteResponseReady,     --out boolean
      xTimingAxiReadAddressChannel    => xTimingAxiReadAddressChannel,     --out Axi4LiteAddressChannel_t
      xTimingAxiReadAddressReady      => xTimingAxiReadAddressReady,       --in  boolean
      xTimingAxiReadDataChannel       => xTimingAxiReadDataChannel,        --in  Axi4LiteReadDataChannel_t
      xTimingAxiReadDataReady         => xTimingAxiReadDataReady,          --out boolean
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
      DrpClk                          => DrpClk,                           --out std_logic
      dDrpAddr                        => dDrpAddr,                         --out std_logic_vector(6:0)
      dDrpDataIn                      => dDrpDataIn,                       --out std_logic_vector(15:0)
      dDrpDataOut                     => dDrpDataOut,                      --in  std_logic_vector(15:0)
      dDrpEn                          => dDrpEn,                           --out std_logic
      dDrpWe                          => dDrpWe,                           --out std_logic
      dDrpRdy                         => dDrpRdy,                          --in  std_logic
      aConfigReset_n                  => aConfigReset_n,                   --out std_logic
      aConfigInterrupt                => aConfigInterrupt,                 --in  std_logic
      aPllStatus0                     => aPllStatus0,                      --in  std_logic
      aPllStatus1                     => aPllStatus1,                      --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      xResetDelay                     => xResetDelay,                      --out std_logic
      xResetSerdes                    => xResetSerdes,                     --out std_logic
      xResetDelayCtrl                 => xResetDelayCtrl);                 --out std_logic

  --vhook TimingEngineAllIn
  --vhook_a BusClk                AxiClk
  --vhook_a bAxiPeriphReset_n     xAxiPeriphReset_n
  --vhook_a {bAxi(.*)}            xTimingAxi$1
  --vhook_a RxSSClk0              aLvdsInputFromIBuf(0)
  --vhook_a RxSSClk1              aLvdsInputFromIBuf(40)
  --vhook_a RxSSClk2              aLvdsInputFromIBuf(46)
  --vhook_a SiClk                 SampleClk
  --vhook_a LmkClk                DeviceClk
  TimingEngineAllInx: TimingEngineAllIn
    port map (
      BusClk                   => AxiClk,                          --in  std_logic
      bAxiPeriphReset_n        => xAxiPeriphReset_n,               --in  std_logic
      aDelayCtrlRdy0           => aDelayCtrlRdy0,                  --in  std_logic
      aDelayCtrlRdy1           => aDelayCtrlRdy1,                  --in  std_logic
      aDelayCtrlRdy2           => aDelayCtrlRdy2,                  --in  std_logic
      bAxiWriteAddressChannel  => xTimingAxiWriteAddressChannel,   --in  Axi4LiteAddressChannel_t
      bAxiWriteAddressReady    => xTimingAxiWriteAddressReady,     --out boolean
      bAxiWriteDataChannel     => xTimingAxiWriteDataChannel,      --in  Axi4LiteWriteDataChannel_t
      bAxiWriteDataReady       => xTimingAxiWriteDataReady,        --out boolean
      bAxiWriteResponseChannel => xTimingAxiWriteResponseChannel,  --out Axi4LiteWriteResponseChannel_t
      bAxiWriteResponseReady   => xTimingAxiWriteResponseReady,    --in  boolean
      bAxiReadAddressChannel   => xTimingAxiReadAddressChannel,    --in  Axi4LiteAddressChannel_t
      bAxiReadAddressReady     => xTimingAxiReadAddressReady,      --out boolean
      bAxiReadDataChannel      => xTimingAxiReadDataChannel,       --out Axi4LiteReadDataChannel_t
      bAxiReadDataReady        => xTimingAxiReadDataReady,         --in  boolean
      RxSSClk0                 => aLvdsInputFromIBuf(0),           --in  std_logic
      RxSSClk1                 => aLvdsInputFromIBuf(40),          --in  std_logic
      RxSSClk2                 => aLvdsInputFromIBuf(46),          --in  std_logic
      SiClk                    => SampleClk,                       --in  std_logic
      LmkClk                   => DeviceClk,                       --in  std_logic
      RxDataClk0               => RxDataClk0,                      --out std_logic
      RxDataClk1               => RxDataClk1,                      --out std_logic
      RxDataClk2               => RxDataClk2,                      --out std_logic
      ISerdesClkDiv0           => ISerdesClkDiv0,                  --out std_logic
      ISerdesClkDiv1           => ISerdesClkDiv1,                  --out std_logic
      ISerdesClkDiv2           => ISerdesClkDiv2,                  --out std_logic
      ISerdesClk0              => ISerdesClk0,                     --out std_logic
      ISerdesClk1              => ISerdesClk1,                     --out std_logic
      ISerdesClk2              => ISerdesClk2,                     --out std_logic
      DelayRefClk              => DelayRefClk,                     --out std_logic
      SeRegisterClk            => SeRegisterClk,                   --out std_logic
      DrpClk                   => DrpClk,                          --in  std_logic
      dDrpAddr                 => dDrpAddr,                        --in  std_logic_vector(6:0)
      dDrpDataIn               => dDrpDataIn,                      --in  std_logic_vector(15:0)
      dDrpDataOut              => dDrpDataOut,                     --out std_logic_vector(15:0)
      dDrpEn                   => dDrpEn,                          --in  std_logic
      dDrpWe                   => dDrpWe,                          --in  std_logic
      dDrpRdy                  => dDrpRdy,                         --out std_logic
      aDiagramClkEnable        => aDiagramClkEnable);              --in  std_logic


  RxDataClkInternal0 <= RxDataClk0;
  RxDataClkInternal1 <= RxDataClk1;
  RxDataClkInternal2 <= RxDataClk2;
  RxDataClkToTopLevel0 <= RxDataClk0;
  RxDataClkToTopLevel1 <= RxDataClk1;
  RxDataClkToTopLevel2 <= RxDataClk2;

  --vhook PinsMappingAllIn
  --vhook_a aIoOutputEnable        xIoOutputEnable
  --vhook_a aSeGpio                aSeGpio(15 downto 0)
  --vhook_a aLvdsInput             aLvdsInputFromIBuf
  --vhook_a aLvdsPfiInput          aLvdsPfiInputFromIbuf
  --vhook_a aLvdsPfiOutput         aLvdsPfiOutputLcl
  --vhook_a aLvdsPfiDir            aLvdsPfiDirLcl
  PinsMappingAllInx: PinsMappingAllIn
    port map (
      aDiagramResetSL => aDiagramResetSL,        --in  std_logic
      SeRegisterClk   => SeRegisterClk,          --in  std_logic
      aIoOutputEnable => xIoOutputEnable,        --in  std_logic
      aDiffGpio_p     => aDiffGpio_p,            --inout std_logic_vector(69:0)
      aDiffGpio_n     => aDiffGpio_n,            --inout std_logic_vector(69:0)
      aSeGpio         => aSeGpio(15 downto 0),   --inout std_logic_vector(15:0)
      aSeDir          => aSeDir,                 --in  std_logic_vector(7:0)
      aSeOutput       => aSeOutput,              --in  std_logic_vector(7:0)
      aSeInput        => aSeInput,               --out std_logic_vector(7:0)
      aLvdsInput      => aLvdsInputFromIBuf,     --out std_logic_vector(63:0)
      aLvdsPfiDir     => aLvdsPfiDirLcl,         --in  std_logic_vector(1:0)
      aLvdsPfiOutput  => aLvdsPfiOutputLcl,      --in  std_logic_vector(1:0)
      aLvdsPfiInput   => aLvdsPfiInputFromIbuf); --out std_logic_vector(1:0)

  --vhook AcquisitionEngine        AcqEngineBank44
  --vhook_g kNumChannels           kNumRxDataChannelBank44
  --vhook_g kIoDelayGroupName      kIoDelayGroupNameBank44
  --vhook_a aResetDelay            xResetDelay
  --vhook_a aResetSerdes           xResetSerdes
  --vhook_a AcqClk                 ISerdesClk0
  --vhook_a AcqClkDiv              ISerdesClkDiv0
  --vhook_a RxDataClk              RxDataClkInternal0
  --vhook_a aLvdsInput             aLvdsInputFromIBuf(20 downto 1)
  --vhook_a qLvdsAcqData           qLvdsAcqData(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a qLvdsBitslip           qLvdsBitslip(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a rRxInc                 rRxInc(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a rRxClkDelayEn          rRxClkDelayEn(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a rDlyCount              rDlyCount(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a rRxCntValOut           rRxCntValOut(kNumRxDataChannelBank44-1 downto 0)
  --vhook_a aDelayCtrlRdy          aDelayCtrlRdy0
  --vhook_a rIncDecReady           rIncDecReady(kNumRxDataChannelBank44-1 downto 0)
  AcqEngineBank44: AcquisitionEngine
    generic map (
      kNumChannels      => kNumRxDataChannelBank44,  --natural:=31
      kIoDelayGroupName => kIoDelayGroupNameBank44)  --string:="IdelayGroup"
    port map (
      aDiagramResetSL => aDiagramResetSL,                                    --in  std_logic
      aResetDelay     => xResetDelay,                                        --in  std_logic
      aResetSerdes    => xResetSerdes,                                       --in  std_logic
      AcqClk          => ISerdesClk0,                                        --in  std_logic
      AcqClkDiv       => ISerdesClkDiv0,                                     --in  std_logic
      RxDataClk       => RxDataClkInternal0,                                 --in  std_logic
      aLvdsInput      => aLvdsInputFromIBuf(20 downto 1),                    --in  std_logic_vector(kNumChannels-1:0)
      qLvdsAcqData    => qLvdsAcqData(kNumRxDataChannelBank44-1 downto 0),   --out DeserArray_t(kNumChannels-1:0)
      qLvdsBitslip    => qLvdsBitslip(kNumRxDataChannelBank44-1 downto 0),   --in  std_logic_vector(kNumChannels-1:0)
      rRxInc          => rRxInc(kNumRxDataChannelBank44-1 downto 0),         --in  std_logic_vector(kNumChannels-1:0)
      rRxClkDelayEn   => rRxClkDelayEn(kNumRxDataChannelBank44-1 downto 0),  --in  std_logic_vector(kNumChannels-1:0)
      rDlyCount       => rDlyCount(kNumRxDataChannelBank44-1 downto 0),      --in  DelayArray_t(kNumChannels-1:0)
      rRxCntValOut    => rRxCntValOut(kNumRxDataChannelBank44-1 downto 0),   --out DelayArray_t(kNumChannels-1:0)
      aDelayCtrlRdy   => aDelayCtrlRdy0,                                     --in  std_logic
      rIncDecReady    => rIncDecReady(kNumRxDataChannelBank44-1 downto 0));  --out std_logic_vector(kNumChannels-1:0)

  --vhook AcquisitionEngine        AcqEngineBank45
  --vhook_g kNumChannels           kNumRxDataChannelBank45
  --vhook_g kIoDelayGroupName      kIoDelayGroupNameBank45
  --vhook_a aResetDelay            xResetDelay
  --vhook_a aResetSerdes           xResetSerdes
  --vhook_a AcqClk                 ISerdesClk1
  --vhook_a AcqClkDiv              ISerdesClkDiv1
  --vhook_a RxDataClk              RxDataClkInternal1
  --vhook_a aLvdsInput             aLvdsInputFromIBuf(42 downto 41) & aLvdsInputFromIBuf(39 downto 21)
  --vhook_a qLvdsAcqData           qLvdsAcqData(40 downto 20)
  --vhook_a qLvdsBitslip           qLvdsBitslip(40 downto 20)
  --vhook_a rRxInc                 rRxInc(40 downto 20)
  --vhook_a rRxClkDelayEn          rRxClkDelayEn(40 downto 20)
  --vhook_a rDlyCount              rDlyCount(40 downto 20)
  --vhook_a rRxCntValOut           rRxCntValOut(40 downto 20)
  --vhook_a aDelayCtrlRdy          aDelayCtrlRdy1
  --vhook_a rIncDecReady           rIncDecReady(40 downto 20)
  AcqEngineBank45: AcquisitionEngine
    generic map (
      kNumChannels      => kNumRxDataChannelBank45,  --natural:=31
      kIoDelayGroupName => kIoDelayGroupNameBank45)  --string:="IdelayGroup"
    port map (
      aDiagramResetSL => aDiagramResetSL,                                                      --in  std_logic
      aResetDelay     => xResetDelay,                                                          --in  std_logic
      aResetSerdes    => xResetSerdes,                                                         --in  std_logic
      AcqClk          => ISerdesClk1,                                                          --in  std_logic
      AcqClkDiv       => ISerdesClkDiv1,                                                       --in  std_logic
      RxDataClk       => RxDataClkInternal1,                                                   --in  std_logic
      aLvdsInput      => aLvdsInputFromIBuf(42 downto 41) & aLvdsInputFromIBuf(39 downto 21),  --in  std_logic_vector(kNumChannels-1:0)
      qLvdsAcqData    => qLvdsAcqData(40 downto 20),                                           --out DeserArray_t(kNumChannels-1:0)
      qLvdsBitslip    => qLvdsBitslip(40 downto 20),                                           --in  std_logic_vector(kNumChannels-1:0)
      rRxInc          => rRxInc(40 downto 20),                                                 --in  std_logic_vector(kNumChannels-1:0)
      rRxClkDelayEn   => rRxClkDelayEn(40 downto 20),                                          --in  std_logic_vector(kNumChannels-1:0)
      rDlyCount       => rDlyCount(40 downto 20),                                              --in  DelayArray_t(kNumChannels-1:0)
      rRxCntValOut    => rRxCntValOut(40 downto 20),                                           --out DelayArray_t(kNumChannels-1:0)
      aDelayCtrlRdy   => aDelayCtrlRdy1,                                                       --in  std_logic
      rIncDecReady    => rIncDecReady(40 downto 20));                                          --out std_logic_vector(kNumChannels-1:0)

  --vhook AcquisitionEngine        AcqEngineBank46
  --vhook_g kNumChannels           kNumRxDataChannelBank46
  --vhook_g kIoDelayGroupName      kIoDelayGroupNameBank46
  --vhook_a aResetDelay            xResetDelay
  --vhook_a aResetSerdes           xResetSerdes
  --vhook_a AcqClk                 ISerdesClk2
  --vhook_a AcqClkDiv              ISerdesClkDiv2
  --vhook_a RxDataClk              RxDataClkInternal2
  --vhook_a aLvdsInput             aLvdsInputFromIBuf(63 downto 47) & aLvdsInputFromIBuf(45 downto 43)
  --vhook_a qLvdsAcqData           qLvdsAcqData(60 downto 41)
  --vhook_a qLvdsBitslip           qLvdsBitslip(60 downto 41)
  --vhook_a rRxInc                 rRxInc(60 downto 41)
  --vhook_a rRxClkDelayEn          rRxClkDelayEn(60 downto 41)
  --vhook_a rDlyCount              rDlyCount(60 downto 41)
  --vhook_a rRxCntValOut           rRxCntValOut(60 downto 41)
  --vhook_a aDelayCtrlRdy          aDelayCtrlRdy2
  --vhook_a rIncDecReady           rIncDecReady(60 downto 41)
  AcqEngineBank46: AcquisitionEngine
    generic map (
      kNumChannels      => kNumRxDataChannelBank46,  --natural:=31
      kIoDelayGroupName => kIoDelayGroupNameBank46)  --string:="IdelayGroup"
    port map (
      aDiagramResetSL => aDiagramResetSL,                                                      --in  std_logic
      aResetDelay     => xResetDelay,                                                          --in  std_logic
      aResetSerdes    => xResetSerdes,                                                         --in  std_logic
      AcqClk          => ISerdesClk2,                                                          --in  std_logic
      AcqClkDiv       => ISerdesClkDiv2,                                                       --in  std_logic
      RxDataClk       => RxDataClkInternal2,                                                   --in  std_logic
      aLvdsInput      => aLvdsInputFromIBuf(63 downto 47) & aLvdsInputFromIBuf(45 downto 43),  --in  std_logic_vector(kNumChannels-1:0)
      qLvdsAcqData    => qLvdsAcqData(60 downto 41),                                           --out DeserArray_t(kNumChannels-1:0)
      qLvdsBitslip    => qLvdsBitslip(60 downto 41),                                           --in  std_logic_vector(kNumChannels-1:0)
      rRxInc          => rRxInc(60 downto 41),                                                 --in  std_logic_vector(kNumChannels-1:0)
      rRxClkDelayEn   => rRxClkDelayEn(60 downto 41),                                          --in  std_logic_vector(kNumChannels-1:0)
      rDlyCount       => rDlyCount(60 downto 41),                                              --in  DelayArray_t(kNumChannels-1:0)
      rRxCntValOut    => rRxCntValOut(60 downto 41),                                           --out DelayArray_t(kNumChannels-1:0)
      aDelayCtrlRdy   => aDelayCtrlRdy2,                                                       --in  std_logic
      rIncDecReady    => rIncDecReady(60 downto 41));                                          --out std_logic_vector(kNumChannels-1:0)

  -----------------------------------------------------------
  -- Instantiate an IDELAYCTRL which is required when IODELAY
  -- is instantiated.
  -----------------------------------------------------------

  --vhook_i IDELAYCTRL  DataIDelayCtrlBank44
  --vhook_g SIM_DEVICE  "ULTRASCALE"
  --vhook_a RST         xResetDelayCtrl
  --vhook_a RefClk      DelayRefClk
  --vhook_a RDY         aDelayCtrlRdy0
  DataIDelayCtrlBank44: IDELAYCTRL
    generic map (SIM_DEVICE => "ULTRASCALE")  --string:="7SERIES"
    port map (
      RDY    => aDelayCtrlRdy0,   --out std_ulogic
      REFCLK => DelayRefClk,      --in  std_ulogic
      RST    => xResetDelayCtrl); --in  std_ulogic

  --vhook_i IDELAYCTRL  DataIDelayCtrlBank45
  --vhook_g SIM_DEVICE  "ULTRASCALE"
  --vhook_a RST         xResetDelayCtrl
  --vhook_a RefClk      DelayRefClk
  --vhook_a RDY         aDelayCtrlRdy1
  DataIDelayCtrlBank45: IDELAYCTRL
    generic map (SIM_DEVICE => "ULTRASCALE")  --string:="7SERIES"
    port map (
      RDY    => aDelayCtrlRdy1,   --out std_ulogic
      REFCLK => DelayRefClk,      --in  std_ulogic
      RST    => xResetDelayCtrl); --in  std_ulogic

  --vhook_i IDELAYCTRL  DataIDelayCtrlBank46
  --vhook_g SIM_DEVICE  "ULTRASCALE"
  --vhook_a RST         xResetDelayCtrl
  --vhook_a RefClk      DelayRefClk
  --vhook_a RDY         aDelayCtrlRdy2
  DataIDelayCtrlBank46: IDELAYCTRL
    generic map (SIM_DEVICE => "ULTRASCALE")  --string:="7SERIES"
    port map (
      RDY    => aDelayCtrlRdy2,   --out std_ulogic
      REFCLK => DelayRefClk,      --in  std_ulogic
      RST    => xResetDelayCtrl); --in  std_ulogic

  ------------------------------------------------------------------------------
  -- Map Xmega microcontroller config signal to CLIP names
  ------------------------------------------------------------------------------
  aSeGpio(23) <= aSpiMosi when xIoOutputEnable = '1' else 'Z';
  aSpiMiso <= aSeGpio(22);
  aSeGpio(27) <= aSpiSck when xIoOutputEnable = '1' else 'Z';
  aSeGpio(26) <= aSpiCs_n when xIoOutputEnable = '1' else 'Z';
  aConfigInterrupt <= aSeGpio(19);
  aSeGpio(25) <= aConfigReset_n when xIoOutputEnable = '1' else 'Z';
  aSeGpio(28) <= '0'; --aPdiDataInEn_n
  aSeGpio(29) <= '0'; --aPdiDataIn
  -- aPdiDataOut is unused
  -- aPdiDataOut <= aSeGpio(24);

  ------------------------------------------------------------------------------
  -- Map PLL config signal to CLIP names
  ------------------------------------------------------------------------------
  aPllStatus0 <= aSeGpio(20);
  aPllStatus1 <= aSeGpio(21);

  ------------------------------------------------------------------------------
  -- Map bits for SE data sent back to LVFPGA
  ------------------------------------------------------------------------------
  aSeDir(0) <= aSeDir0;
  aSeDir(1) <= aSeDir1;
  aSeDir(2) <= aSeDir2;
  aSeDir(3) <= aSeDir3;
  aSeDir(4) <= aSeDir4;
  aSeDir(5) <= aSeDir5;
  aSeDir(6) <= aSeDir6;
  aSeDir(7) <= aSeDir7;

  aSeInput0 <= aSeInput(0);
  aSeInput1 <= aSeInput(1);
  aSeInput2 <= aSeInput(2);
  aSeInput3 <= aSeInput(3);
  aSeInput4 <= aSeInput(4);
  aSeInput5 <= aSeInput(5);
  aSeInput6 <= aSeInput(6);
  aSeInput7 <= aSeInput(7);

  aSeOutput(0) <= aSeOutput0;
  aSeOutput(1) <= aSeOutput1;
  aSeOutput(2) <= aSeOutput2;
  aSeOutput(3) <= aSeOutput3;
  aSeOutput(4) <= aSeOutput4;
  aSeOutput(5) <= aSeOutput5;
  aSeOutput(6) <= aSeOutput6;
  aSeOutput(7) <= aSeOutput7;

  ------------------------------------------------------------------------------
  -- Map PFI signals to CLIP names
  ------------------------------------------------------------------------------
  -- When PFI_DIR is LOW, acquisition mode.
  -- When PFI_DIR is HIGH, generation mode.
  aSeGpio(16) <= aLvdsPfiDir0 when xIoOutputEnable = '1' else 'Z';
  aSeGpio(17) <= aLvdsPfiDir1 when xIoOutputEnable = '1' else 'Z';
  aLvdsPfiDirLcl(0) <= aLvdsPfiDir0;
  aLvdsPfiDirLcl(1) <= aLvdsPfiDir1;

  ------------------------------------------------------------------------------
  -- Map bits for PFI data sent back to LVFPGA
  ------------------------------------------------------------------------------
  aLvdsPfiInput0 <= aLvdsPfiInputFromIbuf(0);
  aLvdsPfiInput1 <= aLvdsPfiInputFromIbuf(1);

  aLvdsPfiOutputLcl(0) <= aLvdsPfiOutput0;
  aLvdsPfiOutputLcl(1) <= aLvdsPfiOutput1;

  ------------------------------------------------------------------------------
  -- Map bits for acquisition data sent back to LVFPGA
  ------------------------------------------------------------------------------
  RxDataFF0: process (RxDataClkInternal0, aDiagramResetSL)
  begin
    if (aDiagramResetSL = '1') then
      rLvdsInput0  <= (others => '0');
      rLvdsInput1  <= (others => '0');
      rLvdsInput2  <= (others => '0');
      rLvdsInput3  <= (others => '0');
      rLvdsInput4  <= (others => '0');
      rLvdsInput5  <= (others => '0');
      rLvdsInput6  <= (others => '0');
      rLvdsInput7  <= (others => '0');
      rLvdsInput8  <= (others => '0');
      rLvdsInput9  <= (others => '0');
      rLvdsInput10  <= (others => '0');
      rLvdsInput11  <= (others => '0');
      rLvdsInput12  <= (others => '0');
      rLvdsInput13  <= (others => '0');
      rLvdsInput14  <= (others => '0');
      rLvdsInput15  <= (others => '0');
      rLvdsInput16  <= (others => '0');
      rLvdsInput17  <= (others => '0');
      rLvdsInput18  <= (others => '0');
      rLvdsInput19  <= (others => '0');
      rLvdsInput20  <= (others => '0');
    elsif rising_edge(RxDataClkInternal0) then
      rLvdsInput0  <= (others => '0');  -- Rev B Bank 44 RX Clk Signal
      rLvdsInput1  <= qLvdsAcqData(0);
      rLvdsInput2  <= qLvdsAcqData(1);
      rLvdsInput3  <= qLvdsAcqData(2);
      rLvdsInput4  <= qLvdsAcqData(3);
      rLvdsInput5  <= qLvdsAcqData(4);
      rLvdsInput6  <= qLvdsAcqData(5);
      rLvdsInput7  <= qLvdsAcqData(6);
      rLvdsInput8  <= qLvdsAcqData(7);
      rLvdsInput9  <= qLvdsAcqData(8);
      rLvdsInput10  <= qLvdsAcqData(9);
      rLvdsInput11  <= qLvdsAcqData(10);
      rLvdsInput12  <= qLvdsAcqData(11);
      rLvdsInput13  <= qLvdsAcqData(12);
      rLvdsInput14  <= qLvdsAcqData(13);
      rLvdsInput15  <= qLvdsAcqData(14);
      rLvdsInput16  <= qLvdsAcqData(15);
      rLvdsInput17  <= qLvdsAcqData(16);
      rLvdsInput18  <= qLvdsAcqData(17);
      rLvdsInput19  <= qLvdsAcqData(18);
      rLvdsInput20  <= qLvdsAcqData(19);
    end if;
  end process RxDataFF0;

  RxDataFF1: process (RxDataClkInternal1, aDiagramResetSL)
  begin
    if (aDiagramResetSL = '1') then
      rLvdsInput21  <= (others => '0');
      rLvdsInput22  <= (others => '0');
      rLvdsInput23  <= (others => '0');
      rLvdsInput24  <= (others => '0');
      rLvdsInput25  <= (others => '0');
      rLvdsInput26  <= (others => '0');
      rLvdsInput27  <= (others => '0');
      rLvdsInput28  <= (others => '0');
      rLvdsInput29  <= (others => '0');
      rLvdsInput30  <= (others => '0');
      rLvdsInput31  <= (others => '0');
      rLvdsInput32  <= (others => '0');
      rLvdsInput33  <= (others => '0');
      rLvdsInput34  <= (others => '0');
      rLvdsInput35  <= (others => '0');
      rLvdsInput36  <= (others => '0');
      rLvdsInput37  <= (others => '0');
      rLvdsInput38  <= (others => '0');
      rLvdsInput39  <= (others => '0');
      rLvdsInput40  <= (others => '0');
      rLvdsInput41  <= (others => '0');
      rLvdsInput42  <= (others => '0');
    elsif rising_edge(RxDataClkInternal1) then
      rLvdsInput21  <= qLvdsAcqData(20);
      rLvdsInput22  <= qLvdsAcqData(21);
      rLvdsInput23  <= qLvdsAcqData(22);
      rLvdsInput24  <= qLvdsAcqData(23);
      rLvdsInput25  <= qLvdsAcqData(24);
      rLvdsInput26  <= qLvdsAcqData(25);
      rLvdsInput27  <= qLvdsAcqData(26);
      rLvdsInput28  <= qLvdsAcqData(27);
      rLvdsInput29  <= qLvdsAcqData(28);
      rLvdsInput30  <= qLvdsAcqData(29);
      rLvdsInput31  <= qLvdsAcqData(30);
      rLvdsInput32  <= qLvdsAcqData(31);
      rLvdsInput33  <= qLvdsAcqData(32);
      rLvdsInput34  <= qLvdsAcqData(33);
      rLvdsInput35  <= qLvdsAcqData(34);
      rLvdsInput36  <= qLvdsAcqData(35);
      rLvdsInput37  <= qLvdsAcqData(36);
      rLvdsInput38  <= qLvdsAcqData(37);
      rLvdsInput39  <= qLvdsAcqData(38);
      rLvdsInput40  <= (others => '0');  -- Rev B Bank 45 RX Clk Signal
      rLvdsInput41  <= qLvdsAcqData(39);
      rLvdsInput42  <= qLvdsAcqData(40);
    end if;
  end process RxDataFF1;


  RxDataFF2: process (RxDataClkInternal2, aDiagramResetSL)
  begin
    if (aDiagramResetSL = '1') then
      rLvdsInput43  <= (others => '0');
      rLvdsInput44  <= (others => '0');
      rLvdsInput45  <= (others => '0');
      rLvdsInput46  <= (others => '0');
      rLvdsInput47  <= (others => '0');
      rLvdsInput48  <= (others => '0');
      rLvdsInput49  <= (others => '0');
      rLvdsInput50  <= (others => '0');
      rLvdsInput51  <= (others => '0');
      rLvdsInput52  <= (others => '0');
      rLvdsInput53  <= (others => '0');
      rLvdsInput54  <= (others => '0');
      rLvdsInput55  <= (others => '0');
      rLvdsInput56  <= (others => '0');
      rLvdsInput57  <= (others => '0');
      rLvdsInput58  <= (others => '0');
      rLvdsInput59  <= (others => '0');
      rLvdsInput60  <= (others => '0');
      rLvdsInput61  <= (others => '0');
      rLvdsInput62  <= (others => '0');
      rLvdsInput63  <= (others => '0');
    elsif rising_edge(RxDataClkInternal2) then
      rLvdsInput43  <= qLvdsAcqData(41);
      rLvdsInput44  <= qLvdsAcqData(42);
      rLvdsInput45  <= qLvdsAcqData(43);
      rLvdsInput46  <= (others => '0');  -- Rev B Bank 46 RX Clk Signal
      rLvdsInput47  <= qLvdsAcqData(44);
      rLvdsInput48  <= qLvdsAcqData(45);
      rLvdsInput49  <= qLvdsAcqData(46);
      rLvdsInput50  <= qLvdsAcqData(47);
      rLvdsInput51  <= qLvdsAcqData(48);
      rLvdsInput52  <= qLvdsAcqData(49);
      rLvdsInput53  <= qLvdsAcqData(50);
      rLvdsInput54  <= qLvdsAcqData(51);
      rLvdsInput55  <= qLvdsAcqData(52);
      rLvdsInput56  <= qLvdsAcqData(53);
      rLvdsInput57  <= qLvdsAcqData(54);
      rLvdsInput58  <= qLvdsAcqData(55);
      rLvdsInput59  <= qLvdsAcqData(56);
      rLvdsInput60  <= qLvdsAcqData(57);
      rLvdsInput61  <= qLvdsAcqData(58);
      rLvdsInput62  <= qLvdsAcqData(59);
      rLvdsInput63  <= qLvdsAcqData(60);
    end if;
  end process RxDataFF2;
  ------------------------------------------------------------------------------
  -- Map bits for IDELAY controls data sent back to LVFPGA
  ------------------------------------------------------------------------------
  rRxCntValOut0  <= (others => '0'); -- Rev B Bank 44 RX Clk Signal
  rRxCntValOut1  <= zeros(7) & rRxCntValOut(0);
  rRxCntValOut2  <= zeros(7) & rRxCntValOut(1);
  rRxCntValOut3  <= zeros(7) & rRxCntValOut(2);
  rRxCntValOut4  <= zeros(7) & rRxCntValOut(3);
  rRxCntValOut5  <= zeros(7) & rRxCntValOut(4);
  rRxCntValOut6  <= zeros(7) & rRxCntValOut(5);
  rRxCntValOut7  <= zeros(7) & rRxCntValOut(6);
  rRxCntValOut8  <= zeros(7) & rRxCntValOut(7);
  rRxCntValOut9  <= zeros(7) & rRxCntValOut(8);
  rRxCntValOut10 <= zeros(7) & rRxCntValOut(9);
  rRxCntValOut11 <= zeros(7) & rRxCntValOut(10);
  rRxCntValOut12 <= zeros(7) & rRxCntValOut(11);
  rRxCntValOut13 <= zeros(7) & rRxCntValOut(12);
  rRxCntValOut14 <= zeros(7) & rRxCntValOut(13);
  rRxCntValOut15 <= zeros(7) & rRxCntValOut(14);
  rRxCntValOut16 <= zeros(7) & rRxCntValOut(15);
  rRxCntValOut17 <= zeros(7) & rRxCntValOut(16);
  rRxCntValOut18 <= zeros(7) & rRxCntValOut(17);
  rRxCntValOut19 <= zeros(7) & rRxCntValOut(18);
  rRxCntValOut20 <= zeros(7) & rRxCntValOut(19);
  rRxCntValOut21 <= zeros(7) & rRxCntValOut(20);
  rRxCntValOut22 <= zeros(7) & rRxCntValOut(21);
  rRxCntValOut23 <= zeros(7) & rRxCntValOut(22);
  rRxCntValOut24 <= zeros(7) & rRxCntValOut(23);
  rRxCntValOut25 <= zeros(7) & rRxCntValOut(24);
  rRxCntValOut26 <= zeros(7) & rRxCntValOut(25);
  rRxCntValOut27 <= zeros(7) & rRxCntValOut(26);
  rRxCntValOut28 <= zeros(7) & rRxCntValOut(27);
  rRxCntValOut29 <= zeros(7) & rRxCntValOut(28);
  rRxCntValOut30 <= zeros(7) & rRxCntValOut(29);
  rRxCntValOut31 <= zeros(7) & rRxCntValOut(30);
  rRxCntValOut32 <= zeros(7) & rRxCntValOut(31);
  rRxCntValOut33 <= zeros(7) & rRxCntValOut(32);
  rRxCntValOut34 <= zeros(7) & rRxCntValOut(33);
  rRxCntValOut35 <= zeros(7) & rRxCntValOut(34);
  rRxCntValOut36 <= zeros(7) & rRxCntValOut(35);
  rRxCntValOut37 <= zeros(7) & rRxCntValOut(36);
  rRxCntValOut38 <= zeros(7) & rRxCntValOut(37);
  rRxCntValOut39 <= zeros(7) & rRxCntValOut(38);
  rRxCntValOut40 <= (others => '0'); -- Rev B Bank 45 RX Clk Signal
  rRxCntValOut41 <= zeros(7) & rRxCntValOut(39);
  rRxCntValOut42 <= zeros(7) & rRxCntValOut(40);
  rRxCntValOut43 <= zeros(7) & rRxCntValOut(41);
  rRxCntValOut44 <= zeros(7) & rRxCntValOut(42);
  rRxCntValOut45 <= zeros(7) & rRxCntValOut(43);
  rRxCntValOut46 <= (others => '0'); -- Rev B Bank 46 RX Clk Signal
  rRxCntValOut47 <= zeros(7) & rRxCntValOut(44);
  rRxCntValOut48 <= zeros(7) & rRxCntValOut(45);
  rRxCntValOut49 <= zeros(7) & rRxCntValOut(46);
  rRxCntValOut50 <= zeros(7) & rRxCntValOut(47);
  rRxCntValOut51 <= zeros(7) & rRxCntValOut(48);
  rRxCntValOut52 <= zeros(7) & rRxCntValOut(49);
  rRxCntValOut53 <= zeros(7) & rRxCntValOut(50);
  rRxCntValOut54 <= zeros(7) & rRxCntValOut(51);
  rRxCntValOut55 <= zeros(7) & rRxCntValOut(52);
  rRxCntValOut56 <= zeros(7) & rRxCntValOut(53);
  rRxCntValOut57 <= zeros(7) & rRxCntValOut(54);
  rRxCntValOut58 <= zeros(7) & rRxCntValOut(55);
  rRxCntValOut59 <= zeros(7) & rRxCntValOut(56);
  rRxCntValOut60 <= zeros(7) & rRxCntValOut(57);
  rRxCntValOut61 <= zeros(7) & rRxCntValOut(58);
  rRxCntValOut62 <= zeros(7) & rRxCntValOut(59);
  rRxCntValOut63 <= zeros(7) & rRxCntValOut(60);
  rRxInc(0) <= rRxInc1;
  rRxInc(1) <= rRxInc2;
  rRxInc(2) <= rRxInc3;
  rRxInc(3) <= rRxInc4;
  rRxInc(4) <= rRxInc5;
  rRxInc(5) <= rRxInc6;
  rRxInc(6) <= rRxInc7;
  rRxInc(7) <= rRxInc8;
  rRxInc(8) <= rRxInc9;
  rRxInc(9) <= rRxInc10;
  rRxInc(10) <= rRxInc11;
  rRxInc(11) <= rRxInc12;
  rRxInc(12) <= rRxInc13;
  rRxInc(13) <= rRxInc14;
  rRxInc(14) <= rRxInc15;
  rRxInc(15) <= rRxInc16;
  rRxInc(16) <= rRxInc17;
  rRxInc(17) <= rRxInc18;
  rRxInc(18) <= rRxInc19;
  rRxInc(19) <= rRxInc20;
  rRxInc(20) <= rRxInc21;
  rRxInc(21) <= rRxInc22;
  rRxInc(22) <= rRxInc23;
  rRxInc(23) <= rRxInc24;
  rRxInc(24) <= rRxInc25;
  rRxInc(25) <= rRxInc26;
  rRxInc(26) <= rRxInc27;
  rRxInc(27) <= rRxInc28;
  rRxInc(28) <= rRxInc29;
  rRxInc(29) <= rRxInc30;
  rRxInc(30) <= rRxInc31;
  rRxInc(31) <= rRxInc32;
  rRxInc(32) <= rRxInc33;
  rRxInc(33) <= rRxInc34;
  rRxInc(34) <= rRxInc35;
  rRxInc(35) <= rRxInc36;
  rRxInc(36) <= rRxInc37;
  rRxInc(37) <= rRxInc38;
  rRxInc(38) <= rRxInc39;
  rRxInc(39) <= rRxInc41;
  rRxInc(40) <= rRxInc42;
  rRxInc(41) <= rRxInc43;
  rRxInc(42) <= rRxInc44;
  rRxInc(43) <= rRxInc45;
  rRxInc(44) <= rRxInc47;
  rRxInc(45) <= rRxInc48;
  rRxInc(46) <= rRxInc49;
  rRxInc(47) <= rRxInc50;
  rRxInc(48) <= rRxInc51;
  rRxInc(49) <= rRxInc52;
  rRxInc(50) <= rRxInc53;
  rRxInc(51) <= rRxInc54;
  rRxInc(52) <= rRxInc55;
  rRxInc(53) <= rRxInc56;
  rRxInc(54) <= rRxInc57;
  rRxInc(55) <= rRxInc58;
  rRxInc(56) <= rRxInc59;
  rRxInc(57) <= rRxInc60;
  rRxInc(58) <= rRxInc61;
  rRxInc(59) <= rRxInc62;
  rRxInc(60) <= rRxInc63;
  rRxClkDelayEn(0)  <= rRxClkDelayEn1;
  rRxClkDelayEn(1)  <= rRxClkDelayEn2;
  rRxClkDelayEn(2)  <= rRxClkDelayEn3;
  rRxClkDelayEn(3)  <= rRxClkDelayEn4;
  rRxClkDelayEn(4)  <= rRxClkDelayEn5;
  rRxClkDelayEn(5)  <= rRxClkDelayEn6;
  rRxClkDelayEn(6)  <= rRxClkDelayEn7;
  rRxClkDelayEn(7)  <= rRxClkDelayEn8;
  rRxClkDelayEn(8)  <= rRxClkDelayEn9;
  rRxClkDelayEn(9)  <= rRxClkDelayEn10;
  rRxClkDelayEn(10) <= rRxClkDelayEn11;
  rRxClkDelayEn(11) <= rRxClkDelayEn12;
  rRxClkDelayEn(12) <= rRxClkDelayEn13;
  rRxClkDelayEn(13) <= rRxClkDelayEn14;
  rRxClkDelayEn(14) <= rRxClkDelayEn15;
  rRxClkDelayEn(15) <= rRxClkDelayEn16;
  rRxClkDelayEn(16) <= rRxClkDelayEn17;
  rRxClkDelayEn(17) <= rRxClkDelayEn18;
  rRxClkDelayEn(18) <= rRxClkDelayEn19;
  rRxClkDelayEn(19) <= rRxClkDelayEn20;
  rRxClkDelayEn(20) <= rRxClkDelayEn21;
  rRxClkDelayEn(21) <= rRxClkDelayEn22;
  rRxClkDelayEn(22) <= rRxClkDelayEn23;
  rRxClkDelayEn(23) <= rRxClkDelayEn24;
  rRxClkDelayEn(24) <= rRxClkDelayEn25;
  rRxClkDelayEn(25) <= rRxClkDelayEn26;
  rRxClkDelayEn(26) <= rRxClkDelayEn27;
  rRxClkDelayEn(27) <= rRxClkDelayEn28;
  rRxClkDelayEn(28) <= rRxClkDelayEn29;
  rRxClkDelayEn(29) <= rRxClkDelayEn30;
  rRxClkDelayEn(30) <= rRxClkDelayEn31;
  rRxClkDelayEn(31) <= rRxClkDelayEn32;
  rRxClkDelayEn(32) <= rRxClkDelayEn33;
  rRxClkDelayEn(33) <= rRxClkDelayEn34;
  rRxClkDelayEn(34) <= rRxClkDelayEn35;
  rRxClkDelayEn(35) <= rRxClkDelayEn36;
  rRxClkDelayEn(36) <= rRxClkDelayEn37;
  rRxClkDelayEn(37) <= rRxClkDelayEn38;
  rRxClkDelayEn(38) <= rRxClkDelayEn39;
  rRxClkDelayEn(39) <= rRxClkDelayEn41;
  rRxClkDelayEn(40) <= rRxClkDelayEn42;
  rRxClkDelayEn(41) <= rRxClkDelayEn43;
  rRxClkDelayEn(42) <= rRxClkDelayEn44;
  rRxClkDelayEn(43) <= rRxClkDelayEn45;
  rRxClkDelayEn(44) <= rRxClkDelayEn47;
  rRxClkDelayEn(45) <= rRxClkDelayEn48;
  rRxClkDelayEn(46) <= rRxClkDelayEn49;
  rRxClkDelayEn(47) <= rRxClkDelayEn50;
  rRxClkDelayEn(48) <= rRxClkDelayEn51;
  rRxClkDelayEn(49) <= rRxClkDelayEn52;
  rRxClkDelayEn(50) <= rRxClkDelayEn53;
  rRxClkDelayEn(51) <= rRxClkDelayEn54;
  rRxClkDelayEn(52) <= rRxClkDelayEn55;
  rRxClkDelayEn(53) <= rRxClkDelayEn56;
  rRxClkDelayEn(54) <= rRxClkDelayEn57;
  rRxClkDelayEn(55) <= rRxClkDelayEn58;
  rRxClkDelayEn(56) <= rRxClkDelayEn59;
  rRxClkDelayEn(57) <= rRxClkDelayEn60;
  rRxClkDelayEn(58) <= rRxClkDelayEn61;
  rRxClkDelayEn(59) <= rRxClkDelayEn62;
  rRxClkDelayEn(60) <= rRxClkDelayEn63;
  rDlyCount(0)  <= rRxDlyCount1(kDelayCntValSize-1 downto 0);
  rDlyCount(1)  <= rRxDlyCount2(kDelayCntValSize-1 downto 0);
  rDlyCount(2)  <= rRxDlyCount3(kDelayCntValSize-1 downto 0);
  rDlyCount(3)  <= rRxDlyCount4(kDelayCntValSize-1 downto 0);
  rDlyCount(4)  <= rRxDlyCount5(kDelayCntValSize-1 downto 0);
  rDlyCount(5)  <= rRxDlyCount6(kDelayCntValSize-1 downto 0);
  rDlyCount(6)  <= rRxDlyCount7(kDelayCntValSize-1 downto 0);
  rDlyCount(7)  <= rRxDlyCount8(kDelayCntValSize-1 downto 0);
  rDlyCount(8)  <= rRxDlyCount9(kDelayCntValSize-1 downto 0);
  rDlyCount(9)  <= rRxDlyCount10(kDelayCntValSize-1 downto 0);
  rDlyCount(10) <= rRxDlyCount11(kDelayCntValSize-1 downto 0);
  rDlyCount(11) <= rRxDlyCount12(kDelayCntValSize-1 downto 0);
  rDlyCount(12) <= rRxDlyCount13(kDelayCntValSize-1 downto 0);
  rDlyCount(13) <= rRxDlyCount14(kDelayCntValSize-1 downto 0);
  rDlyCount(14) <= rRxDlyCount15(kDelayCntValSize-1 downto 0);
  rDlyCount(15) <= rRxDlyCount16(kDelayCntValSize-1 downto 0);
  rDlyCount(16) <= rRxDlyCount17(kDelayCntValSize-1 downto 0);
  rDlyCount(17) <= rRxDlyCount18(kDelayCntValSize-1 downto 0);
  rDlyCount(18) <= rRxDlyCount19(kDelayCntValSize-1 downto 0);
  rDlyCount(19) <= rRxDlyCount20(kDelayCntValSize-1 downto 0);
  rDlyCount(20) <= rRxDlyCount21(kDelayCntValSize-1 downto 0);
  rDlyCount(21) <= rRxDlyCount22(kDelayCntValSize-1 downto 0);
  rDlyCount(22) <= rRxDlyCount23(kDelayCntValSize-1 downto 0);
  rDlyCount(23) <= rRxDlyCount24(kDelayCntValSize-1 downto 0);
  rDlyCount(24) <= rRxDlyCount25(kDelayCntValSize-1 downto 0);
  rDlyCount(25) <= rRxDlyCount26(kDelayCntValSize-1 downto 0);
  rDlyCount(26) <= rRxDlyCount27(kDelayCntValSize-1 downto 0);
  rDlyCount(27) <= rRxDlyCount28(kDelayCntValSize-1 downto 0);
  rDlyCount(28) <= rRxDlyCount29(kDelayCntValSize-1 downto 0);
  rDlyCount(29) <= rRxDlyCount30(kDelayCntValSize-1 downto 0);
  rDlyCount(30) <= rRxDlyCount31(kDelayCntValSize-1 downto 0);
  rDlyCount(31) <= rRxDlyCount32(kDelayCntValSize-1 downto 0);
  rDlyCount(32) <= rRxDlyCount33(kDelayCntValSize-1 downto 0);
  rDlyCount(33) <= rRxDlyCount34(kDelayCntValSize-1 downto 0);
  rDlyCount(34) <= rRxDlyCount35(kDelayCntValSize-1 downto 0);
  rDlyCount(35) <= rRxDlyCount36(kDelayCntValSize-1 downto 0);
  rDlyCount(36) <= rRxDlyCount37(kDelayCntValSize-1 downto 0);
  rDlyCount(37) <= rRxDlyCount38(kDelayCntValSize-1 downto 0);
  rDlyCount(38) <= rRxDlyCount39(kDelayCntValSize-1 downto 0);
  rDlyCount(39) <= rRxDlyCount41(kDelayCntValSize-1 downto 0);
  rDlyCount(40) <= rRxDlyCount42(kDelayCntValSize-1 downto 0);
  rDlyCount(41) <= rRxDlyCount43(kDelayCntValSize-1 downto 0);
  rDlyCount(42) <= rRxDlyCount44(kDelayCntValSize-1 downto 0);
  rDlyCount(43) <= rRxDlyCount45(kDelayCntValSize-1 downto 0);
  rDlyCount(44) <= rRxDlyCount47(kDelayCntValSize-1 downto 0);
  rDlyCount(45) <= rRxDlyCount48(kDelayCntValSize-1 downto 0);
  rDlyCount(46) <= rRxDlyCount49(kDelayCntValSize-1 downto 0);
  rDlyCount(47) <= rRxDlyCount50(kDelayCntValSize-1 downto 0);
  rDlyCount(48) <= rRxDlyCount51(kDelayCntValSize-1 downto 0);
  rDlyCount(49) <= rRxDlyCount52(kDelayCntValSize-1 downto 0);
  rDlyCount(50) <= rRxDlyCount53(kDelayCntValSize-1 downto 0);
  rDlyCount(51) <= rRxDlyCount54(kDelayCntValSize-1 downto 0);
  rDlyCount(52) <= rRxDlyCount55(kDelayCntValSize-1 downto 0);
  rDlyCount(53) <= rRxDlyCount56(kDelayCntValSize-1 downto 0);
  rDlyCount(54) <= rRxDlyCount57(kDelayCntValSize-1 downto 0);
  rDlyCount(55) <= rRxDlyCount58(kDelayCntValSize-1 downto 0);
  rDlyCount(56) <= rRxDlyCount59(kDelayCntValSize-1 downto 0);
  rDlyCount(57) <= rRxDlyCount60(kDelayCntValSize-1 downto 0);
  rDlyCount(58) <= rRxDlyCount61(kDelayCntValSize-1 downto 0);
  rDlyCount(59) <= rRxDlyCount62(kDelayCntValSize-1 downto 0);
  rDlyCount(60) <= rRxDlyCount63(kDelayCntValSize-1 downto 0);
  rRxIncDecReady0  <= '0'; -- Rev B Bank 44 RX Clk Signal
  rRxIncDecReady1  <= rIncDecReady(0);
  rRxIncDecReady2  <= rIncDecReady(1);
  rRxIncDecReady3  <= rIncDecReady(2);
  rRxIncDecReady4  <= rIncDecReady(3);
  rRxIncDecReady5  <= rIncDecReady(4);
  rRxIncDecReady6  <= rIncDecReady(5);
  rRxIncDecReady7  <= rIncDecReady(6);
  rRxIncDecReady8  <= rIncDecReady(7);
  rRxIncDecReady9  <= rIncDecReady(8);
  rRxIncDecReady10 <= rIncDecReady(9);
  rRxIncDecReady11 <= rIncDecReady(10);
  rRxIncDecReady12 <= rIncDecReady(11);
  rRxIncDecReady13 <= rIncDecReady(12);
  rRxIncDecReady14 <= rIncDecReady(13);
  rRxIncDecReady15 <= rIncDecReady(14);
  rRxIncDecReady16 <= rIncDecReady(15);
  rRxIncDecReady17 <= rIncDecReady(16);
  rRxIncDecReady18 <= rIncDecReady(17);
  rRxIncDecReady19 <= rIncDecReady(18);
  rRxIncDecReady20 <= rIncDecReady(19);
  rRxIncDecReady21 <= rIncDecReady(20);
  rRxIncDecReady22 <= rIncDecReady(21);
  rRxIncDecReady23 <= rIncDecReady(22);
  rRxIncDecReady24 <= rIncDecReady(23);
  rRxIncDecReady25 <= rIncDecReady(24);
  rRxIncDecReady26 <= rIncDecReady(25);
  rRxIncDecReady27 <= rIncDecReady(26);
  rRxIncDecReady28 <= rIncDecReady(27);
  rRxIncDecReady29 <= rIncDecReady(28);
  rRxIncDecReady30 <= rIncDecReady(29);
  rRxIncDecReady31 <= rIncDecReady(30);
  rRxIncDecReady32 <= rIncDecReady(31);
  rRxIncDecReady33 <= rIncDecReady(32);
  rRxIncDecReady34 <= rIncDecReady(33);
  rRxIncDecReady35 <= rIncDecReady(34);
  rRxIncDecReady36 <= rIncDecReady(35);
  rRxIncDecReady37 <= rIncDecReady(36);
  rRxIncDecReady38 <= rIncDecReady(37);
  rRxIncDecReady39 <= rIncDecReady(38);
  rRxIncDecReady40 <= '0'; -- Rev B Bank 45 RX Clk Signal
  rRxIncDecReady41 <= rIncDecReady(39);
  rRxIncDecReady42 <= rIncDecReady(40);
  rRxIncDecReady43 <= rIncDecReady(41);
  rRxIncDecReady44 <= rIncDecReady(42);
  rRxIncDecReady45 <= rIncDecReady(43);
  rRxIncDecReady46 <= '0'; -- Rev B Bank 46 RX Clk Signal
  rRxIncDecReady47 <= rIncDecReady(44);
  rRxIncDecReady48 <= rIncDecReady(45);
  rRxIncDecReady49 <= rIncDecReady(46);
  rRxIncDecReady50 <= rIncDecReady(47);
  rRxIncDecReady51 <= rIncDecReady(48);
  rRxIncDecReady52 <= rIncDecReady(49);
  rRxIncDecReady53 <= rIncDecReady(50);
  rRxIncDecReady54 <= rIncDecReady(51);
  rRxIncDecReady55 <= rIncDecReady(52);
  rRxIncDecReady56 <= rIncDecReady(53);
  rRxIncDecReady57 <= rIncDecReady(54);
  rRxIncDecReady58 <= rIncDecReady(55);
  rRxIncDecReady59 <= rIncDecReady(56);
  rRxIncDecReady60 <= rIncDecReady(57);
  rRxIncDecReady61 <= rIncDecReady(58);
  rRxIncDecReady62 <= rIncDecReady(59);
  rRxIncDecReady63 <= rIncDecReady(60);


  ------------------------------------------------------------------------------
  -- Map bits for BITSLIP controls sent back to LVFPGA
  ------------------------------------------------------------------------------

  --vhook_nowarn rBitslip0
  qLvdsBitSlip(0)  <= rBitslip1;
  qLvdsBitSlip(1)  <= rBitslip2;
  qLvdsBitSlip(2)  <= rBitslip3;
  qLvdsBitSlip(3)  <= rBitslip4;
  qLvdsBitSlip(4)  <= rBitslip5;
  qLvdsBitSlip(5)  <= rBitslip6;
  qLvdsBitSlip(6)  <= rBitslip7;
  qLvdsBitSlip(7)  <= rBitslip8;
  qLvdsBitSlip(8)  <= rBitslip9;
  qLvdsBitSlip(9)  <= rBitslip10;
  qLvdsBitSlip(10) <= rBitslip11;
  qLvdsBitSlip(11) <= rBitslip12;
  qLvdsBitSlip(12) <= rBitslip13;
  qLvdsBitSlip(13) <= rBitslip14;
  qLvdsBitSlip(14) <= rBitslip15;
  qLvdsBitSlip(15) <= rBitslip16;
  qLvdsBitSlip(16) <= rBitslip17;
  qLvdsBitSlip(17) <= rBitslip18;
  qLvdsBitSlip(18) <= rBitslip19;
  qLvdsBitSlip(19) <= rBitslip20;
  qLvdsBitSlip(20) <= rBitslip21;
  qLvdsBitSlip(21) <= rBitslip22;
  qLvdsBitSlip(22) <= rBitslip23;
  qLvdsBitSlip(23) <= rBitslip24;
  qLvdsBitSlip(24) <= rBitslip25;
  qLvdsBitSlip(25) <= rBitslip26;
  qLvdsBitSlip(26) <= rBitslip27;
  qLvdsBitSlip(27) <= rBitslip28;
  qLvdsBitSlip(28) <= rBitslip29;
  qLvdsBitSlip(29) <= rBitslip30;
  qLvdsBitSlip(30) <= rBitslip31;
  qLvdsBitSlip(31) <= rBitslip32;
  qLvdsBitSlip(32) <= rBitslip33;
  qLvdsBitSlip(33) <= rBitslip34;
  qLvdsBitSlip(34) <= rBitslip35;
  qLvdsBitSlip(35) <= rBitslip36;
  qLvdsBitSlip(36) <= rBitslip37;
  qLvdsBitSlip(37) <= rBitslip38;
  qLvdsBitSlip(38) <= rBitslip39;
  --vhook_nowarn rBitslip40
  qLvdsBitSlip(39) <= rBitslip41;
  qLvdsBitSlip(40) <= rBitslip42;
  qLvdsBitSlip(41) <= rBitslip43;
  qLvdsBitSlip(42) <= rBitslip44;
  qLvdsBitSlip(43) <= rBitslip45;
  --vhook_nowarn rBitslip46
  qLvdsBitSlip(44) <= rBitslip47;
  qLvdsBitSlip(45) <= rBitslip48;
  qLvdsBitSlip(46) <= rBitslip49;
  qLvdsBitSlip(47) <= rBitslip50;
  qLvdsBitSlip(48) <= rBitslip51;
  qLvdsBitSlip(49) <= rBitslip52;
  qLvdsBitSlip(50) <= rBitslip53;
  qLvdsBitSlip(51) <= rBitslip54;
  qLvdsBitSlip(52) <= rBitslip55;
  qLvdsBitSlip(53) <= rBitslip56;
  qLvdsBitSlip(54) <= rBitslip57;
  qLvdsBitSlip(55) <= rBitslip58;
  qLvdsBitSlip(56) <= rBitslip59;
  qLvdsBitSlip(57) <= rBitslip60;
  qLvdsBitSlip(58) <= rBitslip61;
  qLvdsBitSlip(59) <= rBitslip62;
  qLvdsBitSlip(60) <= rBitslip63;

end rtl;
