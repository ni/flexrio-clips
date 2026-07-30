-------------------------------------------------------------------------------
--
-- File: Ni6569SerdesClipAllOutFl.vhd
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

entity Ni6569SerdesClipAllOutFl is
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
    TxDataClkToTopLevel : out std_logic;
    aClkOutInversionB44 : in std_logic;
    aClkOutInversionB45 : in std_logic;
    aClkOutInversionB46 : in std_logic;

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
end entity Ni6569SerdesClipAllOutFl;

architecture rtl of Ni6569SerdesClipAllOutFl is

  component GenerationEngine
    generic (
      kNumChannels      : natural := 32;
      kIoDelayGroupName : string := "OdelayGroup");
    port (
      aResetDelay      : in  std_logic;
      aResetSerdes     : in  std_logic;
      GenClkDiv        : in  std_logic;
      GenClk           : in  std_logic;
      TxDataClk        : in  std_logic;
      aIoOutputEnable  : in  std_logic;
      aDelayCtrlRdy    : in  std_logic;
      tLvdsGenData     : in  SerArray_t(kNumChannels-1 downto 0);
      gLvdsOutput      : out std_logic_vector(kNumChannels-1 downto 0);
      gGenDataTristate : out std_logic_vector(kNumChannels-1 downto 0);
      tTxInc           : in  std_logic_vector(kNumChannels-1 downto 0);
      tTxClkDelayEn    : in  std_logic_vector(kNumChannels-1 downto 0);
      tDlyCount        : in  DelayArray_t(kNumChannels-1 downto 0);
      tTxCntValOut     : out DelayArray_t(kNumChannels-1 downto 0);
      tIncDecReady     : out std_logic_vector(kNumChannels-1 downto 0));
  end component;
  component PinsMappingAllOut
    port (
      aDiagramResetSL  : in  std_logic;
      SeRegisterClk    : in  std_logic;
      aIoOutputEnable  : in  std_logic;
      aDiffGpio_p      : inout std_logic_vector(69 downto 0);
      aDiffGpio_n      : inout std_logic_vector(69 downto 0);
      aSeGpio          : inout std_logic_vector(15 downto 0);
      aSeDir           : in  std_logic_vector(7 downto 0);
      aSeOutput        : in  std_logic_vector(7 downto 0);
      aSeInput         : out std_logic_vector(7 downto 0);
      aGenDataTristate : in  std_logic_vector(63 downto 0);
      aLvdsOutput      : in  std_logic_vector(63 downto 0);
      aLvdsPfiDir      : in  std_logic_vector(1 downto 0);
      aLvdsPfiOutput   : in  std_logic_vector(1 downto 0);
      aLvdsPfiInput    : out std_logic_vector(1 downto 0));
  end component;
  component TimingEngineAllOut
    port (
      BusClk                   : in  std_logic;
      bAxiPeriphReset_n        : in  std_logic;
      aDelayCtrlRdy            : in  std_logic;
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
      SiClk                    : in  std_logic;
      LmkClk                   : in  std_logic;
      TxDataClk                : out std_logic;
      OSerdesClkDiv            : out std_logic;
      OSerdesClk               : out std_logic;
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

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#10937A9E#, 32));

  --vhook_sigstart
  signal aConfigInterrupt: std_logic;
  signal aConfigReset_n: std_logic;
  signal aDelayCtrlRdy: std_ulogic;
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
  signal gGenDataTristate: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal gLvdsSerData: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal OSerdesClk: std_logic;
  signal OSerdesClkDiv: std_logic;
  signal SeRegisterClk: std_logic;
  signal tClkOutInversionB44Lcl: std_logic;
  signal tClkOutInversionB45Lcl: std_logic;
  signal tClkOutInversionB46Lcl: std_logic;
  signal tDlyCount: DelayArray_t(kNumTxDataChannel-1 downto 0);
  signal tIncDecReady: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal tLvdsDataOut: SerArray_t(kNumTxDataChannel-1 downto 0);
  signal tTxClkDelayEn: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal tTxCntValOut: DelayArray_t(kNumTxDataChannel-1 downto 0);
  signal tTxInc: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal TxDataClk: std_logic;
  signal TxDataClkInternal: std_logic;
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

  signal aLvdsPfiInputFromIbuf: std_logic_vector(1 downto 0);
  signal aLvdsPfiDirLcl: std_logic_vector(1 downto 0);
  signal aLvdsPfiOutputLcl: std_logic_vector(1 downto 0);
  signal tClkOutInversionB44 : std_logic_vector(7 downto 0);
  signal tClkOutInversionB45 : std_logic_vector(7 downto 0);
  signal tClkOutInversionB46 : std_logic_vector(7 downto 0);
  constant kIoDelayGroupName : string := "OdelayGroup";
  attribute IODELAY_GROUP         : string;
  attribute IODELAY_GROUP of DataIDelayCtrl : label is kIoDelayGroupName;

begin

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

  --vhook TimingEngineAllOut
  --vhook_a BusClk                  AxiClk
  --vhook_a bAxiPeriphReset_n       xAxiPeriphReset_n
  --vhook_a {bAxi(.*)}              xTimingAxi$1
  --vhook_a SiClk                   SampleClk
  --vhook_a LmkClk                  DeviceClk
  TimingEngineAllOutx: TimingEngineAllOut
    port map (
      BusClk                   => AxiClk,                          --in  std_logic
      bAxiPeriphReset_n        => xAxiPeriphReset_n,               --in  std_logic
      aDelayCtrlRdy            => aDelayCtrlRdy,                   --in  std_logic
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
      SiClk                    => SampleClk,                       --in  std_logic
      LmkClk                   => DeviceClk,                       --in  std_logic
      TxDataClk                => TxDataClk,                       --out std_logic
      OSerdesClkDiv            => OSerdesClkDiv,                   --out std_logic
      OSerdesClk               => OSerdesClk,                      --out std_logic
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


  TxDataClkInternal <= TxDataClk;
  TxDataClkToTopLevel <= TxDataClk;

  --vhook PinsMappingAllOut
  --vhook_a aIoOutputEnable        xIoOutputEnable
  --vhook_a aSeGpio                aSeGpio(15 downto 0)
  --vhook_a aLvdsOutput            gLvdsSerData
  --vhook_a aLvdsPfiInput          aLvdsPfiInputFromIbuf
  --vhook_a aLvdsPfiOutput         aLvdsPfiOutputLcl
  --vhook_a aLvdsPfiDir            aLvdsPfiDirLcl
  --vhook_a aGenDataTristate       gGenDataTristate
  PinsMappingAllOutx: PinsMappingAllOut
    port map (
      aDiagramResetSL  => aDiagramResetSL,        --in  std_logic
      SeRegisterClk    => SeRegisterClk,          --in  std_logic
      aIoOutputEnable  => xIoOutputEnable,        --in  std_logic
      aDiffGpio_p      => aDiffGpio_p,            --inout std_logic_vector(69:0)
      aDiffGpio_n      => aDiffGpio_n,            --inout std_logic_vector(69:0)
      aSeGpio          => aSeGpio(15 downto 0),   --inout std_logic_vector(15:0)
      aSeDir           => aSeDir,                 --in  std_logic_vector(7:0)
      aSeOutput        => aSeOutput,              --in  std_logic_vector(7:0)
      aSeInput         => aSeInput,               --out std_logic_vector(7:0)
      aGenDataTristate => gGenDataTristate,       --in  std_logic_vector(63:0)
      aLvdsOutput      => gLvdsSerData,           --in  std_logic_vector(63:0)
      aLvdsPfiDir      => aLvdsPfiDirLcl,         --in  std_logic_vector(1:0)
      aLvdsPfiOutput   => aLvdsPfiOutputLcl,      --in  std_logic_vector(1:0)
      aLvdsPfiInput    => aLvdsPfiInputFromIbuf); --out std_logic_vector(1:0)

  --vhook GenerationEngine
  --vhook_g kNumChannels            kNumTxDataChannel
  --vhook_a aIoOutputEnable         xIoOutputEnable
  --vhook_a aResetDelay             xResetDelay
  --vhook_a aResetSerdes            xResetSerdes
  --vhook_a GenClkDiv               OSerdesClkDiv
  --vhook_a GenClk                  OSerdesClk
  --vhook_a tLvdsGenData            tLvdsDataOut
  --vhook_a gLvdsOutput             gLvdsSerData
  --vhook_a TxDataClk               TxDataClkInternal
  GenerationEnginex: GenerationEngine
    generic map (
      kNumChannels      => kNumTxDataChannel,  --natural:=32
      kIoDelayGroupName => kIoDelayGroupName)  --string:="OdelayGroup"
    port map (
      aResetDelay      => xResetDelay,        --in  std_logic
      aResetSerdes     => xResetSerdes,       --in  std_logic
      GenClkDiv        => OSerdesClkDiv,      --in  std_logic
      GenClk           => OSerdesClk,         --in  std_logic
      TxDataClk        => TxDataClkInternal,  --in  std_logic
      aIoOutputEnable  => xIoOutputEnable,    --in  std_logic
      aDelayCtrlRdy    => aDelayCtrlRdy,      --in  std_logic
      tLvdsGenData     => tLvdsDataOut,       --in  SerArray_t(kNumChannels-1:0)
      gLvdsOutput      => gLvdsSerData,       --out std_logic_vector(kNumChannels-1:0)
      gGenDataTristate => gGenDataTristate,   --out std_logic_vector(kNumChannels-1:0)
      tTxInc           => tTxInc,             --in  std_logic_vector(kNumChannels-1:0)
      tTxClkDelayEn    => tTxClkDelayEn,      --in  std_logic_vector(kNumChannels-1:0)
      tDlyCount        => tDlyCount,          --in  DelayArray_t(kNumChannels-1:0)
      tTxCntValOut     => tTxCntValOut,       --out DelayArray_t(kNumChannels-1:0)
      tIncDecReady     => tIncDecReady);      --out std_logic_vector(kNumChannels-1:0)

  -----------------------------------------------------------
  -- Instantiate an IDELAYCTRL which is required when IODELAY
  -- is instantiated.
  -----------------------------------------------------------

  --vhook_i IDELAYCTRL  DataIDelayCtrl
  --vhook_g SIM_DEVICE  "ULTRASCALE"
  --vhook_a RST         xResetDelayCtrl
  --vhook_a RefClk      DelayRefClk
  --vhook_a RDY         aDelayCtrlRdy
  DataIDelayCtrl: IDELAYCTRL
    generic map (SIM_DEVICE => "ULTRASCALE")  --string:="7SERIES"
    port map (
      RDY    => aDelayCtrlRdy,    --out std_ulogic
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
  -- Map bits for generation data sent back to LVFPGA
  -- Reverse bit is no longer needed for OSERDESE3.  This is because unlike
  -- previous libraries, ISERDESE3 will receive the first serial bit in Q0.
  -- Refer UG571 ISERDES section: "TIP: The first serial bit received in a word is Q0"
  ------------------------------------------------------------------------------
  TxDataFF: process (TxDataClkInternal, aDiagramResetSL)
  begin
    if (aDiagramResetSL = '1') then
      tLvdsDataOut(63 downto 0)   <= (others => (others => '0'));
    elsif rising_edge(TxDataClkInternal) then
      tLvdsDataOut(0)   <= tLvdsOutput0;
      tLvdsDataOut(1)   <= tLvdsOutput1;
      tLvdsDataOut(2)   <= tLvdsOutput2;
      tLvdsDataOut(3)   <= tLvdsOutput3;
      tLvdsDataOut(4)   <= tLvdsOutput4;
      tLvdsDataOut(5)   <= tLvdsOutput5;
      tLvdsDataOut(6)   <= tLvdsOutput6;
      tLvdsDataOut(7)   <= tLvdsOutput7;
      tLvdsDataOut(8)   <= tLvdsOutput8;
      tLvdsDataOut(9)   <= tLvdsOutput9;
      tLvdsDataOut(10)  <= tLvdsOutput10;
      tLvdsDataOut(11)  <= tLvdsOutput11;
      tLvdsDataOut(12)  <= tLvdsOutput12;
      tLvdsDataOut(13)  <= tLvdsOutput13 xor tClkOutInversionB44;
      tLvdsDataOut(14)  <= tLvdsOutput14;
      tLvdsDataOut(15)  <= tLvdsOutput15;
      tLvdsDataOut(16)  <= tLvdsOutput16;
      tLvdsDataOut(17)  <= tLvdsOutput17;
      tLvdsDataOut(18)  <= tLvdsOutput18;
      tLvdsDataOut(19)  <= tLvdsOutput19;
      tLvdsDataOut(20)  <= tLvdsOutput20;
      tLvdsDataOut(21)  <= tLvdsOutput21;
      tLvdsDataOut(22)  <= tLvdsOutput22;
      tLvdsDataOut(23)  <= tLvdsOutput23;
      tLvdsDataOut(24)  <= tLvdsOutput24;
      tLvdsDataOut(25)  <= tLvdsOutput25;
      tLvdsDataOut(26)  <= tLvdsOutput26;
      tLvdsDataOut(27)  <= tLvdsOutput27;
      tLvdsDataOut(28)  <= tLvdsOutput28;
      tLvdsDataOut(29)  <= tLvdsOutput29 xor tClkOutInversionB45;
      tLvdsDataOut(30)  <= tLvdsOutput30;
      tLvdsDataOut(31)  <= tLvdsOutput31;
      tLvdsDataOut(32)  <= tLvdsOutput32;
      tLvdsDataOut(33)  <= tLvdsOutput33;
      tLvdsDataOut(34)  <= tLvdsOutput34;
      tLvdsDataOut(35)  <= tLvdsOutput35;
      tLvdsDataOut(36)  <= tLvdsOutput36;
      tLvdsDataOut(37)  <= tLvdsOutput37;
      tLvdsDataOut(38)  <= tLvdsOutput38;
      tLvdsDataOut(39)  <= tLvdsOutput39;
      tLvdsDataOut(40)  <= tLvdsOutput40;
      tLvdsDataOut(41)  <= tLvdsOutput41;
      tLvdsDataOut(42)  <= tLvdsOutput42;
      tLvdsDataOut(43)  <= tLvdsOutput43;
      tLvdsDataOut(44)  <= tLvdsOutput44;
      tLvdsDataOut(45)  <= tLvdsOutput45;
      tLvdsDataOut(46)  <= tLvdsOutput46;
      tLvdsDataOut(47)  <= tLvdsOutput47;
      tLvdsDataOut(48)  <= tLvdsOutput48;
      tLvdsDataOut(49)  <= tLvdsOutput49;
      tLvdsDataOut(50)  <= tLvdsOutput50;
      tLvdsDataOut(51)  <= tLvdsOutput51;
      tLvdsDataOut(52)  <= tLvdsOutput52;
      tLvdsDataOut(53)  <= tLvdsOutput53;
      tLvdsDataOut(54)  <= tLvdsOutput54 xor tClkOutInversionB46;
      tLvdsDataOut(55)  <= tLvdsOutput55;
      tLvdsDataOut(56)  <= tLvdsOutput56;
      tLvdsDataOut(57)  <= tLvdsOutput57;
      tLvdsDataOut(58)  <= tLvdsOutput58;
      tLvdsDataOut(59)  <= tLvdsOutput59;
      tLvdsDataOut(60)  <= tLvdsOutput60;
      tLvdsDataOut(61)  <= tLvdsOutput61;
      tLvdsDataOut(62)  <= tLvdsOutput62;
      tLvdsDataOut(63)  <= tLvdsOutput63;
    end if;
  end process TxDataFF;

  --vhook_e DoubleSyncSlAsyncIn ClkOutInversionBank44DS
  --vhook_g kResetVal           '0'
  --vhook_a aoReset             false
  --vhook_a OClk                TxDataClkInternal
  --vhook_a aSig                aClkOutInversionB44
  --vhook_a oSig                tClkOutInversionB44Lcl
  ClkOutInversionBank44DS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aClkOutInversionB44,     --in  std_logic
      aoReset => false,                   --in  boolean
      OClk    => TxDataClkInternal,       --in  std_logic
      oSig    => tClkOutInversionB44Lcl); --out std_logic

  tClkOutInversionB44 <= (others => tClkOutInversionB44Lcl);

  --vhook_e DoubleSyncSlAsyncIn ClkOutInversionBank45DS
  --vhook_g kResetVal           '0'
  --vhook_a aoReset             false
  --vhook_a OClk                TxDataClkInternal
  --vhook_a aSig                aClkOutInversionB45
  --vhook_a oSig                tClkOutInversionB45Lcl
  ClkOutInversionBank45DS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aClkOutInversionB45,     --in  std_logic
      aoReset => false,                   --in  boolean
      OClk    => TxDataClkInternal,       --in  std_logic
      oSig    => tClkOutInversionB45Lcl); --out std_logic

  tClkOutInversionB45 <= (others => tClkOutInversionB45Lcl);

  --vhook_e DoubleSyncSlAsyncIn ClkOutInversionBank46DS
  --vhook_g kResetVal           '0'
  --vhook_a aoReset             false
  --vhook_a OClk                TxDataClkInternal
  --vhook_a aSig                aClkOutInversionB46
  --vhook_a oSig                tClkOutInversionB46Lcl
  ClkOutInversionBank46DS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aClkOutInversionB46,     --in  std_logic
      aoReset => false,                   --in  boolean
      OClk    => TxDataClkInternal,       --in  std_logic
      oSig    => tClkOutInversionB46Lcl); --out std_logic

  tClkOutInversionB46 <= (others => tClkOutInversionB46Lcl);

  ------------------------------------------------------------------------------
  -- Map bits for ODELAY controls data sent back to LVFPGA
  ------------------------------------------------------------------------------
  tTxCntValOut0  <= zeros(7) & tTxCntValOut(0);
  tTxCntValOut1  <= zeros(7) & tTxCntValOut(1);
  tTxCntValOut2  <= zeros(7) & tTxCntValOut(2);
  tTxCntValOut3  <= zeros(7) & tTxCntValOut(3);
  tTxCntValOut4  <= zeros(7) & tTxCntValOut(4);
  tTxCntValOut5  <= zeros(7) & tTxCntValOut(5);
  tTxCntValOut6  <= zeros(7) & tTxCntValOut(6);
  tTxCntValOut7  <= zeros(7) & tTxCntValOut(7);
  tTxCntValOut8  <= zeros(7) & tTxCntValOut(8);
  tTxCntValOut9  <= zeros(7) & tTxCntValOut(9);
  tTxCntValOut10 <= zeros(7) & tTxCntValOut(10);
  tTxCntValOut11 <= zeros(7) & tTxCntValOut(11);
  tTxCntValOut12 <= zeros(7) & tTxCntValOut(12);
  tTxCntValOut13 <= zeros(7) & tTxCntValOut(13);
  tTxCntValOut14 <= zeros(7) & tTxCntValOut(14);
  tTxCntValOut15 <= zeros(7) & tTxCntValOut(15);
  tTxCntValOut16 <= zeros(7) & tTxCntValOut(16);
  tTxCntValOut17 <= zeros(7) & tTxCntValOut(17);
  tTxCntValOut18 <= zeros(7) & tTxCntValOut(18);
  tTxCntValOut19 <= zeros(7) & tTxCntValOut(19);
  tTxCntValOut20 <= zeros(7) & tTxCntValOut(20);
  tTxCntValOut21 <= zeros(7) & tTxCntValOut(21);
  tTxCntValOut22 <= zeros(7) & tTxCntValOut(22);
  tTxCntValOut23 <= zeros(7) & tTxCntValOut(23);
  tTxCntValOut24 <= zeros(7) & tTxCntValOut(24);
  tTxCntValOut25 <= zeros(7) & tTxCntValOut(25);
  tTxCntValOut26 <= zeros(7) & tTxCntValOut(26);
  tTxCntValOut27 <= zeros(7) & tTxCntValOut(27);
  tTxCntValOut28 <= zeros(7) & tTxCntValOut(28);
  tTxCntValOut29 <= zeros(7) & tTxCntValOut(29);
  tTxCntValOut30 <= zeros(7) & tTxCntValOut(30);
  tTxCntValOut31 <= zeros(7) & tTxCntValOut(31);
  tTxCntValOut32 <= zeros(7) & tTxCntValOut(32);
  tTxCntValOut33 <= zeros(7) & tTxCntValOut(33);
  tTxCntValOut34 <= zeros(7) & tTxCntValOut(34);
  tTxCntValOut35 <= zeros(7) & tTxCntValOut(35);
  tTxCntValOut36 <= zeros(7) & tTxCntValOut(36);
  tTxCntValOut37 <= zeros(7) & tTxCntValOut(37);
  tTxCntValOut38 <= zeros(7) & tTxCntValOut(38);
  tTxCntValOut39 <= zeros(7) & tTxCntValOut(39);
  tTxCntValOut40 <= zeros(7) & tTxCntValOut(40);
  tTxCntValOut41 <= zeros(7) & tTxCntValOut(41);
  tTxCntValOut42 <= zeros(7) & tTxCntValOut(42);
  tTxCntValOut43 <= zeros(7) & tTxCntValOut(43);
  tTxCntValOut44 <= zeros(7) & tTxCntValOut(44);
  tTxCntValOut45 <= zeros(7) & tTxCntValOut(45);
  tTxCntValOut46 <= zeros(7) & tTxCntValOut(46);
  tTxCntValOut47 <= zeros(7) & tTxCntValOut(47);
  tTxCntValOut48 <= zeros(7) & tTxCntValOut(48);
  tTxCntValOut49 <= zeros(7) & tTxCntValOut(49);
  tTxCntValOut50 <= zeros(7) & tTxCntValOut(50);
  tTxCntValOut51 <= zeros(7) & tTxCntValOut(51);
  tTxCntValOut52 <= zeros(7) & tTxCntValOut(52);
  tTxCntValOut53 <= zeros(7) & tTxCntValOut(53);
  tTxCntValOut54 <= zeros(7) & tTxCntValOut(54);
  tTxCntValOut55 <= zeros(7) & tTxCntValOut(55);
  tTxCntValOut56 <= zeros(7) & tTxCntValOut(56);
  tTxCntValOut57 <= zeros(7) & tTxCntValOut(57);
  tTxCntValOut58 <= zeros(7) & tTxCntValOut(58);
  tTxCntValOut59 <= zeros(7) & tTxCntValOut(59);
  tTxCntValOut60 <= zeros(7) & tTxCntValOut(60);
  tTxCntValOut61 <= zeros(7) & tTxCntValOut(61);
  tTxCntValOut62 <= zeros(7) & tTxCntValOut(62);
  tTxCntValOut63 <= zeros(7) & tTxCntValOut(63);
  tTxInc(0) <= tTxInc0;
  tTxInc(1) <= tTxInc1;
  tTxInc(2) <= tTxInc2;
  tTxInc(3) <= tTxInc3;
  tTxInc(4) <= tTxInc4;
  tTxInc(5) <= tTxInc5;
  tTxInc(6) <= tTxInc6;
  tTxInc(7) <= tTxInc7;
  tTxInc(8) <= tTxInc8;
  tTxInc(9) <= tTxInc9;
  tTxInc(10) <= tTxInc10;
  tTxInc(11) <= tTxInc11;
  tTxInc(12) <= tTxInc12;
  tTxInc(13) <= tTxInc13;
  tTxInc(14) <= tTxInc14;
  tTxInc(15) <= tTxInc15;
  tTxInc(16) <= tTxInc16;
  tTxInc(17) <= tTxInc17;
  tTxInc(18) <= tTxInc18;
  tTxInc(19) <= tTxInc19;
  tTxInc(20) <= tTxInc20;
  tTxInc(21) <= tTxInc21;
  tTxInc(22) <= tTxInc22;
  tTxInc(23) <= tTxInc23;
  tTxInc(24) <= tTxInc24;
  tTxInc(25) <= tTxInc25;
  tTxInc(26) <= tTxInc26;
  tTxInc(27) <= tTxInc27;
  tTxInc(28) <= tTxInc28;
  tTxInc(29) <= tTxInc29;
  tTxInc(30) <= tTxInc30;
  tTxInc(31) <= tTxInc31;
  tTxInc(32) <= tTxInc32;
  tTxInc(33) <= tTxInc33;
  tTxInc(34) <= tTxInc34;
  tTxInc(35) <= tTxInc35;
  tTxInc(36) <= tTxInc36;
  tTxInc(37) <= tTxInc37;
  tTxInc(38) <= tTxInc38;
  tTxInc(39) <= tTxInc39;
  tTxInc(40) <= tTxInc40;
  tTxInc(41) <= tTxInc41;
  tTxInc(42) <= tTxInc42;
  tTxInc(43) <= tTxInc43;
  tTxInc(44) <= tTxInc44;
  tTxInc(45) <= tTxInc45;
  tTxInc(46) <= tTxInc46;
  tTxInc(47) <= tTxInc47;
  tTxInc(48) <= tTxInc48;
  tTxInc(49) <= tTxInc49;
  tTxInc(50) <= tTxInc50;
  tTxInc(51) <= tTxInc51;
  tTxInc(52) <= tTxInc52;
  tTxInc(53) <= tTxInc53;
  tTxInc(54) <= tTxInc54;
  tTxInc(55) <= tTxInc55;
  tTxInc(56) <= tTxInc56;
  tTxInc(57) <= tTxInc57;
  tTxInc(58) <= tTxInc58;
  tTxInc(59) <= tTxInc59;
  tTxInc(60) <= tTxInc60;
  tTxInc(61) <= tTxInc61;
  tTxInc(62) <= tTxInc62;
  tTxInc(63) <= tTxInc63;
  tTxClkDelayEn(0)  <= tTxClkDelayEn0;
  tTxClkDelayEn(1)  <= tTxClkDelayEn1;
  tTxClkDelayEn(2)  <= tTxClkDelayEn2;
  tTxClkDelayEn(3)  <= tTxClkDelayEn3;
  tTxClkDelayEn(4)  <= tTxClkDelayEn4;
  tTxClkDelayEn(5)  <= tTxClkDelayEn5;
  tTxClkDelayEn(6)  <= tTxClkDelayEn6;
  tTxClkDelayEn(7)  <= tTxClkDelayEn7;
  tTxClkDelayEn(8)  <= tTxClkDelayEn8;
  tTxClkDelayEn(9)  <= tTxClkDelayEn9;
  tTxClkDelayEn(10) <= tTxClkDelayEn10;
  tTxClkDelayEn(11) <= tTxClkDelayEn11;
  tTxClkDelayEn(12) <= tTxClkDelayEn12;
  tTxClkDelayEn(13) <= tTxClkDelayEn13;
  tTxClkDelayEn(14) <= tTxClkDelayEn14;
  tTxClkDelayEn(15) <= tTxClkDelayEn15;
  tTxClkDelayEn(16) <= tTxClkDelayEn16;
  tTxClkDelayEn(17) <= tTxClkDelayEn17;
  tTxClkDelayEn(18) <= tTxClkDelayEn18;
  tTxClkDelayEn(19) <= tTxClkDelayEn19;
  tTxClkDelayEn(20) <= tTxClkDelayEn20;
  tTxClkDelayEn(21) <= tTxClkDelayEn21;
  tTxClkDelayEn(22) <= tTxClkDelayEn22;
  tTxClkDelayEn(23) <= tTxClkDelayEn23;
  tTxClkDelayEn(24) <= tTxClkDelayEn24;
  tTxClkDelayEn(25) <= tTxClkDelayEn25;
  tTxClkDelayEn(26) <= tTxClkDelayEn26;
  tTxClkDelayEn(27) <= tTxClkDelayEn27;
  tTxClkDelayEn(28) <= tTxClkDelayEn28;
  tTxClkDelayEn(29) <= tTxClkDelayEn29;
  tTxClkDelayEn(30) <= tTxClkDelayEn30;
  tTxClkDelayEn(31) <= tTxClkDelayEn31;
  tTxClkDelayEn(32) <= tTxClkDelayEn32;
  tTxClkDelayEn(33) <= tTxClkDelayEn33;
  tTxClkDelayEn(34) <= tTxClkDelayEn34;
  tTxClkDelayEn(35) <= tTxClkDelayEn35;
  tTxClkDelayEn(36) <= tTxClkDelayEn36;
  tTxClkDelayEn(37) <= tTxClkDelayEn37;
  tTxClkDelayEn(38) <= tTxClkDelayEn38;
  tTxClkDelayEn(39) <= tTxClkDelayEn39;
  tTxClkDelayEn(40) <= tTxClkDelayEn40;
  tTxClkDelayEn(41) <= tTxClkDelayEn41;
  tTxClkDelayEn(42) <= tTxClkDelayEn42;
  tTxClkDelayEn(43) <= tTxClkDelayEn43;
  tTxClkDelayEn(44) <= tTxClkDelayEn44;
  tTxClkDelayEn(45) <= tTxClkDelayEn45;
  tTxClkDelayEn(46) <= tTxClkDelayEn46;
  tTxClkDelayEn(47) <= tTxClkDelayEn47;
  tTxClkDelayEn(48) <= tTxClkDelayEn48;
  tTxClkDelayEn(49) <= tTxClkDelayEn49;
  tTxClkDelayEn(50) <= tTxClkDelayEn50;
  tTxClkDelayEn(51) <= tTxClkDelayEn51;
  tTxClkDelayEn(52) <= tTxClkDelayEn52;
  tTxClkDelayEn(53) <= tTxClkDelayEn53;
  tTxClkDelayEn(54) <= tTxClkDelayEn54;
  tTxClkDelayEn(55) <= tTxClkDelayEn55;
  tTxClkDelayEn(56) <= tTxClkDelayEn56;
  tTxClkDelayEn(57) <= tTxClkDelayEn57;
  tTxClkDelayEn(58) <= tTxClkDelayEn58;
  tTxClkDelayEn(59) <= tTxClkDelayEn59;
  tTxClkDelayEn(60) <= tTxClkDelayEn60;
  tTxClkDelayEn(61) <= tTxClkDelayEn61;
  tTxClkDelayEn(62) <= tTxClkDelayEn62;
  tTxClkDelayEn(63) <= tTxClkDelayEn63;
  tDlyCount(0) <= tTxDlyCount0(kDelayCntValSize-1 downto 0);
  tDlyCount(1) <= tTxDlyCount1(kDelayCntValSize-1 downto 0);
  tDlyCount(2) <= tTxDlyCount2(kDelayCntValSize-1 downto 0);
  tDlyCount(3) <= tTxDlyCount3(kDelayCntValSize-1 downto 0);
  tDlyCount(4) <= tTxDlyCount4(kDelayCntValSize-1 downto 0);
  tDlyCount(5) <= tTxDlyCount5(kDelayCntValSize-1 downto 0);
  tDlyCount(6) <= tTxDlyCount6(kDelayCntValSize-1 downto 0);
  tDlyCount(7) <= tTxDlyCount7(kDelayCntValSize-1 downto 0);
  tDlyCount(8) <= tTxDlyCount8(kDelayCntValSize-1 downto 0);
  tDlyCount(9) <= tTxDlyCount9(kDelayCntValSize-1 downto 0);
  tDlyCount(10) <= tTxDlyCount10(kDelayCntValSize-1 downto 0);
  tDlyCount(11) <= tTxDlyCount11(kDelayCntValSize-1 downto 0);
  tDlyCount(12) <= tTxDlyCount12(kDelayCntValSize-1 downto 0);
  tDlyCount(13) <= tTxDlyCount13(kDelayCntValSize-1 downto 0);
  tDlyCount(14) <= tTxDlyCount14(kDelayCntValSize-1 downto 0);
  tDlyCount(15) <= tTxDlyCount15(kDelayCntValSize-1 downto 0);
  tDlyCount(16) <= tTxDlyCount16(kDelayCntValSize-1 downto 0);
  tDlyCount(17) <= tTxDlyCount17(kDelayCntValSize-1 downto 0);
  tDlyCount(18) <= tTxDlyCount18(kDelayCntValSize-1 downto 0);
  tDlyCount(19) <= tTxDlyCount19(kDelayCntValSize-1 downto 0);
  tDlyCount(20) <= tTxDlyCount20(kDelayCntValSize-1 downto 0);
  tDlyCount(21) <= tTxDlyCount21(kDelayCntValSize-1 downto 0);
  tDlyCount(22) <= tTxDlyCount22(kDelayCntValSize-1 downto 0);
  tDlyCount(23) <= tTxDlyCount23(kDelayCntValSize-1 downto 0);
  tDlyCount(24) <= tTxDlyCount24(kDelayCntValSize-1 downto 0);
  tDlyCount(25) <= tTxDlyCount25(kDelayCntValSize-1 downto 0);
  tDlyCount(26) <= tTxDlyCount26(kDelayCntValSize-1 downto 0);
  tDlyCount(27) <= tTxDlyCount27(kDelayCntValSize-1 downto 0);
  tDlyCount(28) <= tTxDlyCount28(kDelayCntValSize-1 downto 0);
  tDlyCount(29) <= tTxDlyCount29(kDelayCntValSize-1 downto 0);
  tDlyCount(30) <= tTxDlyCount30(kDelayCntValSize-1 downto 0);
  tDlyCount(31) <= tTxDlyCount31(kDelayCntValSize-1 downto 0);
  tDlyCount(32) <= tTxDlyCount32(kDelayCntValSize-1 downto 0);
  tDlyCount(33) <= tTxDlyCount33(kDelayCntValSize-1 downto 0);
  tDlyCount(34) <= tTxDlyCount34(kDelayCntValSize-1 downto 0);
  tDlyCount(35) <= tTxDlyCount35(kDelayCntValSize-1 downto 0);
  tDlyCount(36) <= tTxDlyCount36(kDelayCntValSize-1 downto 0);
  tDlyCount(37) <= tTxDlyCount37(kDelayCntValSize-1 downto 0);
  tDlyCount(38) <= tTxDlyCount38(kDelayCntValSize-1 downto 0);
  tDlyCount(39) <= tTxDlyCount39(kDelayCntValSize-1 downto 0);
  tDlyCount(40) <= tTxDlyCount40(kDelayCntValSize-1 downto 0);
  tDlyCount(41) <= tTxDlyCount41(kDelayCntValSize-1 downto 0);
  tDlyCount(42) <= tTxDlyCount42(kDelayCntValSize-1 downto 0);
  tDlyCount(43) <= tTxDlyCount43(kDelayCntValSize-1 downto 0);
  tDlyCount(44) <= tTxDlyCount44(kDelayCntValSize-1 downto 0);
  tDlyCount(45) <= tTxDlyCount45(kDelayCntValSize-1 downto 0);
  tDlyCount(46) <= tTxDlyCount46(kDelayCntValSize-1 downto 0);
  tDlyCount(47) <= tTxDlyCount47(kDelayCntValSize-1 downto 0);
  tDlyCount(48) <= tTxDlyCount48(kDelayCntValSize-1 downto 0);
  tDlyCount(49) <= tTxDlyCount49(kDelayCntValSize-1 downto 0);
  tDlyCount(50) <= tTxDlyCount50(kDelayCntValSize-1 downto 0);
  tDlyCount(51) <= tTxDlyCount51(kDelayCntValSize-1 downto 0);
  tDlyCount(52) <= tTxDlyCount52(kDelayCntValSize-1 downto 0);
  tDlyCount(53) <= tTxDlyCount53(kDelayCntValSize-1 downto 0);
  tDlyCount(54) <= tTxDlyCount54(kDelayCntValSize-1 downto 0);
  tDlyCount(55) <= tTxDlyCount55(kDelayCntValSize-1 downto 0);
  tDlyCount(56) <= tTxDlyCount56(kDelayCntValSize-1 downto 0);
  tDlyCount(57) <= tTxDlyCount57(kDelayCntValSize-1 downto 0);
  tDlyCount(58) <= tTxDlyCount58(kDelayCntValSize-1 downto 0);
  tDlyCount(59) <= tTxDlyCount59(kDelayCntValSize-1 downto 0);
  tDlyCount(60) <= tTxDlyCount60(kDelayCntValSize-1 downto 0);
  tDlyCount(61) <= tTxDlyCount61(kDelayCntValSize-1 downto 0);
  tDlyCount(62) <= tTxDlyCount62(kDelayCntValSize-1 downto 0);
  tDlyCount(63) <= tTxDlyCount63(kDelayCntValSize-1 downto 0);
  tTxIncDecReady0  <= tIncDecReady(0);
  tTxIncDecReady1  <= tIncDecReady(1);
  tTxIncDecReady2  <= tIncDecReady(2);
  tTxIncDecReady3  <= tIncDecReady(3);
  tTxIncDecReady4  <= tIncDecReady(4);
  tTxIncDecReady5  <= tIncDecReady(5);
  tTxIncDecReady6  <= tIncDecReady(6);
  tTxIncDecReady7  <= tIncDecReady(7);
  tTxIncDecReady8  <= tIncDecReady(8);
  tTxIncDecReady9  <= tIncDecReady(9);
  tTxIncDecReady10 <= tIncDecReady(10);
  tTxIncDecReady11 <= tIncDecReady(11);
  tTxIncDecReady12 <= tIncDecReady(12);
  tTxIncDecReady13 <= tIncDecReady(13);
  tTxIncDecReady14 <= tIncDecReady(14);
  tTxIncDecReady15 <= tIncDecReady(15);
  tTxIncDecReady16 <= tIncDecReady(16);
  tTxIncDecReady17 <= tIncDecReady(17);
  tTxIncDecReady18 <= tIncDecReady(18);
  tTxIncDecReady19 <= tIncDecReady(19);
  tTxIncDecReady20 <= tIncDecReady(10);
  tTxIncDecReady21 <= tIncDecReady(21);
  tTxIncDecReady22 <= tIncDecReady(22);
  tTxIncDecReady23 <= tIncDecReady(23);
  tTxIncDecReady24 <= tIncDecReady(24);
  tTxIncDecReady25 <= tIncDecReady(25);
  tTxIncDecReady26 <= tIncDecReady(26);
  tTxIncDecReady27 <= tIncDecReady(27);
  tTxIncDecReady28 <= tIncDecReady(28);
  tTxIncDecReady29 <= tIncDecReady(29);
  tTxIncDecReady30 <= tIncDecReady(30);
  tTxIncDecReady31 <= tIncDecReady(31);
  tTxIncDecReady32  <= tIncDecReady(32);
  tTxIncDecReady33  <= tIncDecReady(33);
  tTxIncDecReady34  <= tIncDecReady(34);
  tTxIncDecReady35  <= tIncDecReady(35);
  tTxIncDecReady36  <= tIncDecReady(36);
  tTxIncDecReady37  <= tIncDecReady(37);
  tTxIncDecReady38  <= tIncDecReady(38);
  tTxIncDecReady39  <= tIncDecReady(39);
  tTxIncDecReady40  <= tIncDecReady(40);
  tTxIncDecReady41  <= tIncDecReady(41);
  tTxIncDecReady42  <= tIncDecReady(42);
  tTxIncDecReady43  <= tIncDecReady(43);
  tTxIncDecReady44  <= tIncDecReady(44);
  tTxIncDecReady45  <= tIncDecReady(45);
  tTxIncDecReady46  <= tIncDecReady(46);
  tTxIncDecReady47  <= tIncDecReady(47);
  tTxIncDecReady48  <= tIncDecReady(48);
  tTxIncDecReady49  <= tIncDecReady(49);
  tTxIncDecReady50  <= tIncDecReady(50);
  tTxIncDecReady51  <= tIncDecReady(51);
  tTxIncDecReady52  <= tIncDecReady(52);
  tTxIncDecReady53  <= tIncDecReady(53);
  tTxIncDecReady54  <= tIncDecReady(54);
  tTxIncDecReady55  <= tIncDecReady(55);
  tTxIncDecReady56  <= tIncDecReady(56);
  tTxIncDecReady57  <= tIncDecReady(57);
  tTxIncDecReady58  <= tIncDecReady(58);
  tTxIncDecReady59  <= tIncDecReady(59);
  tTxIncDecReady60  <= tIncDecReady(60);
  tTxIncDecReady61  <= tIncDecReady(61);
  tTxIncDecReady62  <= tIncDecReady(62);
  tTxIncDecReady63  <= tIncDecReady(63);

end rtl;
