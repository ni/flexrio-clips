-------------------------------------------------------------------------------
--
-- File: Ni6569BasicClipAllInFl.vhd
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

entity Ni6569BasicClipAllInFl is
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
    DeviceClkRxLV       : out std_logic;

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

    -- LVDS PFI Lines
    aLvdsPfiDir0        : in std_logic;
    aLvdsPfiDir1        : in std_logic;
    aLvdsPfiInput0      : out std_logic;
    aLvdsPfiInput1      : out std_logic;
    aLvdsPfiOutput0     : in std_logic;
    aLvdsPfiOutput1     : in std_logic;

    xIoModuleReady                     : out std_logic;
    xIoModuleErrorCode                 : out std_logic_vector(31 downto 0)
    );
end entity Ni6569BasicClipAllInFl;

architecture rtl of Ni6569BasicClipAllInFl is

  component IDelayBasic
    generic (
      kNumRxChannels    : natural := 32;
      kIoDelayGroupName : string := "IOdelayGroup");
    port (
      aResetDelay   : in  std_logic;
      aDelayCtrlRdy : in  std_logic;
      RxDataClk     : in  std_logic;
      aLvdsInput    : in  std_logic_vector(kNumRxChannels-1 downto 0);
      rRxInc        : in  std_logic_vector(kNumRxChannels-1 downto 0);
      rRxClkDelayEn : in  std_logic_vector(kNumRxChannels-1 downto 0);
      rDlyCount     : in  DelayArray_t(kNumRxChannels-1 downto 0);
      rRxCntValOut  : out DelayArray_t(kNumRxChannels-1 downto 0);
      rIncDecReady  : out std_logic_vector(kNumRxChannels-1 downto 0);
      aLvdsAcqData  : out std_logic_vector(kNumRxChannels-1 downto 0));
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
  component TimingEngineBasicAllIn
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
      RxSSClk                  : in  std_logic;
      SiClk                    : in  std_logic;
      LmkClk                   : in  std_logic;
      RxDataClk                : out std_logic;
      DelayRefClk              : out std_logic;
      SeRegisterClk            : out std_logic;
      aDiagramClkEnable        : in  std_logic);
  end component;
  component FixedLogicBasicCommon
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
      aConfigReset_n                  : out std_logic;
      aConfigInterrupt                : in  std_logic;
      aPllStatus0                     : in  std_logic;
      aPllStatus1                     : in  std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      xResetDelay                     : out std_logic;
      xResetDelayCtrl                 : out std_logic);
  end component;

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#10937A9D#, 32));

  --vhook_sigstart
  signal aConfigInterrupt: std_logic;
  signal aConfigReset_n: std_logic;
  signal aDelayCtrlRdy: std_ulogic;
  signal aLvdsAcqData: std_logic_vector(kNumRxDataChannel-1 downto 0);
  signal aLvdsInputFromIBuf: std_logic_vector(63 downto 0);
  signal aPllStatus0: std_logic;
  signal aPllStatus1: std_logic;
  signal arDiagramResetSL: boolean;
  signal aSeDir: std_logic_vector(7 downto 0);
  signal aSeInput: std_logic_vector(7 downto 0);
  signal aSeOutput: std_logic_vector(7 downto 0);
  signal aSpiCs_n: std_logic;
  signal aSpiMiso: std_logic;
  signal aSpiMosi: std_logic;
  signal aSpiSck: std_logic;
  signal DelayRefClk: std_ulogic;
  signal rDlyCount: DelayArray_t(kNumRxDataChannel-1 downto 0);
  signal rIncDecReady: std_logic_vector(kNumRxDataChannel-1 downto 0);
  signal rRxClkDelayEn: std_logic_vector(kNumRxDataChannel-1 downto 0);
  signal rRxCntValOut: DelayArray_t(kNumRxDataChannel-1 downto 0);
  signal rRxInc: std_logic_vector(kNumRxDataChannel-1 downto 0);
  signal RxDataClk: std_logic;
  signal SeRegisterClk: std_logic;
  signal xAxiPeriphReset_n: std_logic;
  signal xResetDelay: std_logic;
  signal xResetDelayCtrl: std_ulogic;
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
  constant kIoDelayGroupName : string := "IdelayGroup";
  attribute IODELAY_GROUP         : string;
  attribute IODELAY_GROUP of DataIDelayCtrl : label is kIoDelayGroupName;

  signal RxDataClkInternal : std_logic;

begin

  --vhook_nowarn rRxInc40
  --vhook_nowarn rRxClkDelayEn40
  --vhook_nowarn rRxDlyCount40

  --vhook FixedLogicBasicCommon
  FixedLogicBasicCommonx: FixedLogicBasicCommon
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
      aConfigReset_n                  => aConfigReset_n,                   --out std_logic
      aConfigInterrupt                => aConfigInterrupt,                 --in  std_logic
      aPllStatus0                     => aPllStatus0,                      --in  std_logic
      aPllStatus1                     => aPllStatus1,                      --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      xResetDelay                     => xResetDelay,                      --out std_logic
      xResetDelayCtrl                 => xResetDelayCtrl);                 --out std_logic

  --vhook TimingEngineBasicAllIn
  --vhook_a BusClk                AxiClk
  --vhook_a bAxiPeriphReset_n     xAxiPeriphReset_n
  --vhook_a {bAxi(.*)}            xTimingAxi$1
  --vhook_a RxSSClk               aLvdsInputFromIBuf(40)
  --vhook_a SiClk                 SampleClk
  --vhook_a LmkClk                DeviceClk
  TimingEngineBasicAllInx: TimingEngineBasicAllIn
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
      RxSSClk                  => aLvdsInputFromIBuf(40),          --in  std_logic
      SiClk                    => SampleClk,                       --in  std_logic
      LmkClk                   => DeviceClk,                       --in  std_logic
      RxDataClk                => RxDataClk,                       --out std_logic
      DelayRefClk              => DelayRefClk,                     --out std_logic
      SeRegisterClk            => SeRegisterClk,                   --out std_logic
      aDiagramClkEnable        => aDiagramClkEnable);              --in  std_logic

  RxDataClkInternal <= RxDataClk;
  DeviceClkRxLV <= RxDataClk;

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

  --vhook IDelayBasic
  --vhook_g kNumRxChannels          kNumRxDataChannel
  --vhook_a aResetDelay             xResetDelay
  --vhook_a aLvdsInput              aLvdsInputFromIBuf(63 downto 41) & aLvdsInputFromIBuf(39 downto 0)
  --vhook_a RxDataClk               RxDataClkInternal
  IDelayBasicx: IDelayBasic
    generic map (
      kNumRxChannels    => kNumRxDataChannel,  --natural:=32
      kIoDelayGroupName => kIoDelayGroupName)  --string:="IOdelayGroup"
    port map (
      aResetDelay   => xResetDelay,                                                         --in  std_logic
      aDelayCtrlRdy => aDelayCtrlRdy,                                                       --in  std_logic
      RxDataClk     => RxDataClkInternal,                                                   --in  std_logic
      aLvdsInput    => aLvdsInputFromIBuf(63 downto 41) & aLvdsInputFromIBuf(39 downto 0),  --in  std_logic_vector(kNumRxChannels-1:0)
      rRxInc        => rRxInc,                                                              --in  std_logic_vector(kNumRxChannels-1:0)
      rRxClkDelayEn => rRxClkDelayEn,                                                       --in  std_logic_vector(kNumRxChannels-1:0)
      rDlyCount     => rDlyCount,                                                           --in  DelayArray_t(kNumRxChannels-1:0)
      rRxCntValOut  => rRxCntValOut,                                                        --out DelayArray_t(kNumRxChannels-1:0)
      rIncDecReady  => rIncDecReady,                                                        --out std_logic_vector(kNumRxChannels-1:0)
      aLvdsAcqData  => aLvdsAcqData);                                                       --out std_logic_vector(kNumRxChannels-1:0)

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
  -- Map bits for acquisition data sent back to LVFPGA
  ------------------------------------------------------------------------------

  --vhook_e ResetSyncDeassert   DiagramResetRSD
  --vhook_a Clk                 RxDataClkInternal
  --vhook_a aReset              to_Boolean(aDiagramResetSL)
  --vhook_a acReset             arDiagramResetSL
  DiagramResetRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => RxDataClkInternal,            --in  std_logic
      aReset  => to_Boolean(aDiagramResetSL),  --in  boolean
      acReset => arDiagramResetSL);            --out boolean

  RxDataFF: process (RxDataClkInternal, arDiagramResetSL)
  begin
    if (arDiagramResetSL) then
      rLvdsInput(63 downto 0) <= (others => '0');
    elsif rising_edge(RxDataClkInternal) then
      rLvdsInput(39 downto 0)   <= aLvdsAcqData(39 downto 0);
      rLvdsInput(40)  <= '0'; -- Rev B RX Clk Signal
      rLvdsInput(63 downto 41)  <= aLvdsAcqData(62 downto 40);
    end if;
  end process RxDataFF;

  ------------------------------------------------------------------------------
  -- Map bits for IDELAY controls data sent back to LVFPGA
  ------------------------------------------------------------------------------
  rRxCntValOut0  <= zeros(7) & rRxCntValOut(0);
  rRxCntValOut1  <= zeros(7) & rRxCntValOut(1);
  rRxCntValOut2  <= zeros(7) & rRxCntValOut(2);
  rRxCntValOut3  <= zeros(7) & rRxCntValOut(3);
  rRxCntValOut4  <= zeros(7) & rRxCntValOut(4);
  rRxCntValOut5  <= zeros(7) & rRxCntValOut(5);
  rRxCntValOut6  <= zeros(7) & rRxCntValOut(6);
  rRxCntValOut7  <= zeros(7) & rRxCntValOut(7);
  rRxCntValOut8  <= zeros(7) & rRxCntValOut(8);
  rRxCntValOut9  <= zeros(7) & rRxCntValOut(9);
  rRxCntValOut10 <= zeros(7) & rRxCntValOut(10);
  rRxCntValOut11 <= zeros(7) & rRxCntValOut(11);
  rRxCntValOut12 <= zeros(7) & rRxCntValOut(12);
  rRxCntValOut13 <= zeros(7) & rRxCntValOut(13);
  rRxCntValOut14 <= zeros(7) & rRxCntValOut(14);
  rRxCntValOut15 <= zeros(7) & rRxCntValOut(15);
  rRxCntValOut16 <= zeros(7) & rRxCntValOut(16);
  rRxCntValOut17 <= zeros(7) & rRxCntValOut(17);
  rRxCntValOut18 <= zeros(7) & rRxCntValOut(18);
  rRxCntValOut19 <= zeros(7) & rRxCntValOut(19);
  rRxCntValOut20 <= zeros(7) & rRxCntValOut(20);
  rRxCntValOut21 <= zeros(7) & rRxCntValOut(21);
  rRxCntValOut22 <= zeros(7) & rRxCntValOut(22);
  rRxCntValOut23 <= zeros(7) & rRxCntValOut(23);
  rRxCntValOut24 <= zeros(7) & rRxCntValOut(24);
  rRxCntValOut25 <= zeros(7) & rRxCntValOut(25);
  rRxCntValOut26 <= zeros(7) & rRxCntValOut(26);
  rRxCntValOut27 <= zeros(7) & rRxCntValOut(27);
  rRxCntValOut28 <= zeros(7) & rRxCntValOut(28);
  rRxCntValOut29 <= zeros(7) & rRxCntValOut(29);
  rRxCntValOut30 <= zeros(7) & rRxCntValOut(30);
  rRxCntValOut31 <= zeros(7) & rRxCntValOut(31);
  rRxCntValOut32 <= zeros(7) & rRxCntValOut(32);
  rRxCntValOut33 <= zeros(7) & rRxCntValOut(33);
  rRxCntValOut34 <= zeros(7) & rRxCntValOut(34);
  rRxCntValOut35 <= zeros(7) & rRxCntValOut(35);
  rRxCntValOut36 <= zeros(7) & rRxCntValOut(36);
  rRxCntValOut37 <= zeros(7) & rRxCntValOut(37);
  rRxCntValOut38 <= zeros(7) & rRxCntValOut(38);
  rRxCntValOut39 <= zeros(7) & rRxCntValOut(39);
  rRxCntValOut40 <= (others => '0'); -- Rev B RX Clk Signal
  rRxCntValOut41 <= zeros(7) & rRxCntValOut(40);
  rRxCntValOut42 <= zeros(7) & rRxCntValOut(41);
  rRxCntValOut43 <= zeros(7) & rRxCntValOut(42);
  rRxCntValOut44 <= zeros(7) & rRxCntValOut(43);
  rRxCntValOut45 <= zeros(7) & rRxCntValOut(44);
  rRxCntValOut46 <= zeros(7) & rRxCntValOut(45);
  rRxCntValOut47 <= zeros(7) & rRxCntValOut(46);
  rRxCntValOut48 <= zeros(7) & rRxCntValOut(47);
  rRxCntValOut49 <= zeros(7) & rRxCntValOut(48);
  rRxCntValOut50 <= zeros(7) & rRxCntValOut(49);
  rRxCntValOut51 <= zeros(7) & rRxCntValOut(50);
  rRxCntValOut52 <= zeros(7) & rRxCntValOut(51);
  rRxCntValOut53 <= zeros(7) & rRxCntValOut(52);
  rRxCntValOut54 <= zeros(7) & rRxCntValOut(53);
  rRxCntValOut55 <= zeros(7) & rRxCntValOut(54);
  rRxCntValOut56 <= zeros(7) & rRxCntValOut(55);
  rRxCntValOut57 <= zeros(7) & rRxCntValOut(56);
  rRxCntValOut58 <= zeros(7) & rRxCntValOut(57);
  rRxCntValOut59 <= zeros(7) & rRxCntValOut(58);
  rRxCntValOut60 <= zeros(7) & rRxCntValOut(59);
  rRxCntValOut61 <= zeros(7) & rRxCntValOut(60);
  rRxCntValOut62 <= zeros(7) & rRxCntValOut(61);
  rRxCntValOut63 <= zeros(7) & rRxCntValOut(62);
  rRxInc(0) <= rRxInc0;
  rRxInc(1) <= rRxInc1;
  rRxInc(2) <= rRxInc2;
  rRxInc(3) <= rRxInc3;
  rRxInc(4) <= rRxInc4;
  rRxInc(5) <= rRxInc5;
  rRxInc(6) <= rRxInc6;
  rRxInc(7) <= rRxInc7;
  rRxInc(8) <= rRxInc8;
  rRxInc(9) <= rRxInc9;
  rRxInc(10) <= rRxInc10;
  rRxInc(11) <= rRxInc11;
  rRxInc(12) <= rRxInc12;
  rRxInc(13) <= rRxInc13;
  rRxInc(14) <= rRxInc14;
  rRxInc(15) <= rRxInc15;
  rRxInc(16) <= rRxInc16;
  rRxInc(17) <= rRxInc17;
  rRxInc(18) <= rRxInc18;
  rRxInc(19) <= rRxInc19;
  rRxInc(20) <= rRxInc20;
  rRxInc(21) <= rRxInc21;
  rRxInc(22) <= rRxInc22;
  rRxInc(23) <= rRxInc23;
  rRxInc(24) <= rRxInc24;
  rRxInc(25) <= rRxInc25;
  rRxInc(26) <= rRxInc26;
  rRxInc(27) <= rRxInc27;
  rRxInc(28) <= rRxInc28;
  rRxInc(29) <= rRxInc29;
  rRxInc(30) <= rRxInc30;
  rRxInc(31) <= rRxInc31;
  rRxInc(32) <= rRxInc32;
  rRxInc(33) <= rRxInc33;
  rRxInc(34) <= rRxInc34;
  rRxInc(35) <= rRxInc35;
  rRxInc(36) <= rRxInc36;
  rRxInc(37) <= rRxInc37;
  rRxInc(38) <= rRxInc38;
  rRxInc(39) <= rRxInc39;
  rRxInc(40) <= rRxInc41;
  rRxInc(41) <= rRxInc42;
  rRxInc(42) <= rRxInc43;
  rRxInc(43) <= rRxInc44;
  rRxInc(44) <= rRxInc45;
  rRxInc(45) <= rRxInc46;
  rRxInc(46) <= rRxInc47;
  rRxInc(47) <= rRxInc48;
  rRxInc(48) <= rRxInc49;
  rRxInc(49) <= rRxInc50;
  rRxInc(50) <= rRxInc51;
  rRxInc(51) <= rRxInc52;
  rRxInc(52) <= rRxInc53;
  rRxInc(53) <= rRxInc54;
  rRxInc(54) <= rRxInc55;
  rRxInc(55) <= rRxInc56;
  rRxInc(56) <= rRxInc57;
  rRxInc(57) <= rRxInc58;
  rRxInc(58) <= rRxInc59;
  rRxInc(59) <= rRxInc60;
  rRxInc(60) <= rRxInc61;
  rRxInc(61) <= rRxInc62;
  rRxInc(62) <= rRxInc63;
  rRxClkDelayEn(0) <= rRxClkDelayEn0;
  rRxClkDelayEn(1) <= rRxClkDelayEn1;
  rRxClkDelayEn(2) <= rRxClkDelayEn2;
  rRxClkDelayEn(3) <= rRxClkDelayEn3;
  rRxClkDelayEn(4) <= rRxClkDelayEn4;
  rRxClkDelayEn(5) <= rRxClkDelayEn5;
  rRxClkDelayEn(6) <= rRxClkDelayEn6;
  rRxClkDelayEn(7) <= rRxClkDelayEn7;
  rRxClkDelayEn(8) <= rRxClkDelayEn8;
  rRxClkDelayEn(9) <= rRxClkDelayEn9;
  rRxClkDelayEn(10) <= rRxClkDelayEn10;
  rRxClkDelayEn(11) <= rRxClkDelayEn11;
  rRxClkDelayEn(12) <= rRxClkDelayEn12;
  rRxClkDelayEn(13) <= rRxClkDelayEn13;
  rRxClkDelayEn(14) <= rRxClkDelayEn14;
  rRxClkDelayEn(15) <= rRxClkDelayEn15;
  rRxClkDelayEn(16) <= rRxClkDelayEn16;
  rRxClkDelayEn(17) <= rRxClkDelayEn17;
  rRxClkDelayEn(18) <= rRxClkDelayEn18;
  rRxClkDelayEn(19) <= rRxClkDelayEn19;
  rRxClkDelayEn(20) <= rRxClkDelayEn20;
  rRxClkDelayEn(21) <= rRxClkDelayEn21;
  rRxClkDelayEn(22) <= rRxClkDelayEn22;
  rRxClkDelayEn(23) <= rRxClkDelayEn23;
  rRxClkDelayEn(24) <= rRxClkDelayEn24;
  rRxClkDelayEn(25) <= rRxClkDelayEn25;
  rRxClkDelayEn(26) <= rRxClkDelayEn26;
  rRxClkDelayEn(27) <= rRxClkDelayEn27;
  rRxClkDelayEn(28) <= rRxClkDelayEn28;
  rRxClkDelayEn(29) <= rRxClkDelayEn29;
  rRxClkDelayEn(30) <= rRxClkDelayEn30;
  rRxClkDelayEn(31) <= rRxClkDelayEn31;
  rRxClkDelayEn(32) <= rRxClkDelayEn32;
  rRxClkDelayEn(33) <= rRxClkDelayEn33;
  rRxClkDelayEn(34) <= rRxClkDelayEn34;
  rRxClkDelayEn(35) <= rRxClkDelayEn35;
  rRxClkDelayEn(36) <= rRxClkDelayEn36;
  rRxClkDelayEn(37) <= rRxClkDelayEn37;
  rRxClkDelayEn(38) <= rRxClkDelayEn38;
  rRxClkDelayEn(39) <= rRxClkDelayEn39;
  rRxClkDelayEn(40) <= rRxClkDelayEn41;
  rRxClkDelayEn(41) <= rRxClkDelayEn42;
  rRxClkDelayEn(42) <= rRxClkDelayEn43;
  rRxClkDelayEn(43) <= rRxClkDelayEn44;
  rRxClkDelayEn(44) <= rRxClkDelayEn45;
  rRxClkDelayEn(45) <= rRxClkDelayEn46;
  rRxClkDelayEn(46) <= rRxClkDelayEn47;
  rRxClkDelayEn(47) <= rRxClkDelayEn48;
  rRxClkDelayEn(48) <= rRxClkDelayEn49;
  rRxClkDelayEn(49) <= rRxClkDelayEn50;
  rRxClkDelayEn(50) <= rRxClkDelayEn51;
  rRxClkDelayEn(51) <= rRxClkDelayEn52;
  rRxClkDelayEn(52) <= rRxClkDelayEn53;
  rRxClkDelayEn(53) <= rRxClkDelayEn54;
  rRxClkDelayEn(54) <= rRxClkDelayEn55;
  rRxClkDelayEn(55) <= rRxClkDelayEn56;
  rRxClkDelayEn(56) <= rRxClkDelayEn57;
  rRxClkDelayEn(57) <= rRxClkDelayEn58;
  rRxClkDelayEn(58) <= rRxClkDelayEn59;
  rRxClkDelayEn(59) <= rRxClkDelayEn60;
  rRxClkDelayEn(60) <= rRxClkDelayEn61;
  rRxClkDelayEn(61) <= rRxClkDelayEn62;
  rRxClkDelayEn(62) <= rRxClkDelayEn63;
  rDlyCount(0) <= rRxDlyCount0(kDelayCntValSize-1 downto 0);
  rDlyCount(1) <= rRxDlyCount1(kDelayCntValSize-1 downto 0);
  rDlyCount(2) <= rRxDlyCount2(kDelayCntValSize-1 downto 0);
  rDlyCount(3) <= rRxDlyCount3(kDelayCntValSize-1 downto 0);
  rDlyCount(4) <= rRxDlyCount4(kDelayCntValSize-1 downto 0);
  rDlyCount(5) <= rRxDlyCount5(kDelayCntValSize-1 downto 0);
  rDlyCount(6) <= rRxDlyCount6(kDelayCntValSize-1 downto 0);
  rDlyCount(7) <= rRxDlyCount7(kDelayCntValSize-1 downto 0);
  rDlyCount(8) <= rRxDlyCount8(kDelayCntValSize-1 downto 0);
  rDlyCount(9) <= rRxDlyCount9(kDelayCntValSize-1 downto 0);
  rDlyCount(10) <= rRxDlyCount10(kDelayCntValSize-1 downto 0);
  rDlyCount(11) <= rRxDlyCount11(kDelayCntValSize-1 downto 0);
  rDlyCount(12) <= rRxDlyCount12(kDelayCntValSize-1 downto 0);
  rDlyCount(13) <= rRxDlyCount13(kDelayCntValSize-1 downto 0);
  rDlyCount(14) <= rRxDlyCount14(kDelayCntValSize-1 downto 0);
  rDlyCount(15) <= rRxDlyCount15(kDelayCntValSize-1 downto 0);
  rDlyCount(16) <= rRxDlyCount16(kDelayCntValSize-1 downto 0);
  rDlyCount(17) <= rRxDlyCount17(kDelayCntValSize-1 downto 0);
  rDlyCount(18) <= rRxDlyCount18(kDelayCntValSize-1 downto 0);
  rDlyCount(19) <= rRxDlyCount19(kDelayCntValSize-1 downto 0);
  rDlyCount(20) <= rRxDlyCount20(kDelayCntValSize-1 downto 0);
  rDlyCount(21) <= rRxDlyCount21(kDelayCntValSize-1 downto 0);
  rDlyCount(22) <= rRxDlyCount22(kDelayCntValSize-1 downto 0);
  rDlyCount(23) <= rRxDlyCount23(kDelayCntValSize-1 downto 0);
  rDlyCount(24) <= rRxDlyCount24(kDelayCntValSize-1 downto 0);
  rDlyCount(25) <= rRxDlyCount25(kDelayCntValSize-1 downto 0);
  rDlyCount(26) <= rRxDlyCount26(kDelayCntValSize-1 downto 0);
  rDlyCount(27) <= rRxDlyCount27(kDelayCntValSize-1 downto 0);
  rDlyCount(28) <= rRxDlyCount28(kDelayCntValSize-1 downto 0);
  rDlyCount(29) <= rRxDlyCount29(kDelayCntValSize-1 downto 0);
  rDlyCount(30) <= rRxDlyCount30(kDelayCntValSize-1 downto 0);
  rDlyCount(31) <= rRxDlyCount31(kDelayCntValSize-1 downto 0);
  rDlyCount(32) <= rRxDlyCount32(kDelayCntValSize-1 downto 0);
  rDlyCount(33) <= rRxDlyCount33(kDelayCntValSize-1 downto 0);
  rDlyCount(34) <= rRxDlyCount34(kDelayCntValSize-1 downto 0);
  rDlyCount(35) <= rRxDlyCount35(kDelayCntValSize-1 downto 0);
  rDlyCount(36) <= rRxDlyCount36(kDelayCntValSize-1 downto 0);
  rDlyCount(37) <= rRxDlyCount37(kDelayCntValSize-1 downto 0);
  rDlyCount(38) <= rRxDlyCount38(kDelayCntValSize-1 downto 0);
  rDlyCount(39) <= rRxDlyCount39(kDelayCntValSize-1 downto 0);
  rDlyCount(40) <= rRxDlyCount41(kDelayCntValSize-1 downto 0);
  rDlyCount(41) <= rRxDlyCount42(kDelayCntValSize-1 downto 0);
  rDlyCount(42) <= rRxDlyCount43(kDelayCntValSize-1 downto 0);
  rDlyCount(43) <= rRxDlyCount44(kDelayCntValSize-1 downto 0);
  rDlyCount(44) <= rRxDlyCount45(kDelayCntValSize-1 downto 0);
  rDlyCount(45) <= rRxDlyCount46(kDelayCntValSize-1 downto 0);
  rDlyCount(46) <= rRxDlyCount47(kDelayCntValSize-1 downto 0);
  rDlyCount(47) <= rRxDlyCount48(kDelayCntValSize-1 downto 0);
  rDlyCount(48) <= rRxDlyCount49(kDelayCntValSize-1 downto 0);
  rDlyCount(49) <= rRxDlyCount50(kDelayCntValSize-1 downto 0);
  rDlyCount(50) <= rRxDlyCount51(kDelayCntValSize-1 downto 0);
  rDlyCount(51) <= rRxDlyCount52(kDelayCntValSize-1 downto 0);
  rDlyCount(52) <= rRxDlyCount53(kDelayCntValSize-1 downto 0);
  rDlyCount(53) <= rRxDlyCount54(kDelayCntValSize-1 downto 0);
  rDlyCount(54) <= rRxDlyCount55(kDelayCntValSize-1 downto 0);
  rDlyCount(55) <= rRxDlyCount56(kDelayCntValSize-1 downto 0);
  rDlyCount(56) <= rRxDlyCount57(kDelayCntValSize-1 downto 0);
  rDlyCount(57) <= rRxDlyCount58(kDelayCntValSize-1 downto 0);
  rDlyCount(58) <= rRxDlyCount59(kDelayCntValSize-1 downto 0);
  rDlyCount(59) <= rRxDlyCount60(kDelayCntValSize-1 downto 0);
  rDlyCount(60) <= rRxDlyCount61(kDelayCntValSize-1 downto 0);
  rDlyCount(61) <= rRxDlyCount62(kDelayCntValSize-1 downto 0);
  rDlyCount(62) <= rRxDlyCount63(kDelayCntValSize-1 downto 0);
  rRxIncDecReady0  <= rIncDecReady(0);
  rRxIncDecReady1  <= rIncDecReady(1);
  rRxIncDecReady2  <= rIncDecReady(2);
  rRxIncDecReady3  <= rIncDecReady(3);
  rRxIncDecReady4  <= rIncDecReady(4);
  rRxIncDecReady5  <= rIncDecReady(5);
  rRxIncDecReady6  <= rIncDecReady(6);
  rRxIncDecReady7  <= rIncDecReady(7);
  rRxIncDecReady8  <= rIncDecReady(8);
  rRxIncDecReady9  <= rIncDecReady(9);
  rRxIncDecReady10 <= rIncDecReady(10);
  rRxIncDecReady11 <= rIncDecReady(11);
  rRxIncDecReady12 <= rIncDecReady(12);
  rRxIncDecReady13 <= rIncDecReady(13);
  rRxIncDecReady14 <= rIncDecReady(14);
  rRxIncDecReady15 <= rIncDecReady(15);
  rRxIncDecReady16 <= rIncDecReady(16);
  rRxIncDecReady17 <= rIncDecReady(17);
  rRxIncDecReady18 <= rIncDecReady(18);
  rRxIncDecReady19 <= rIncDecReady(19);
  rRxIncDecReady20 <= rIncDecReady(20);
  rRxIncDecReady21 <= rIncDecReady(21);
  rRxIncDecReady22 <= rIncDecReady(22);
  rRxIncDecReady23 <= rIncDecReady(23);
  rRxIncDecReady24 <= rIncDecReady(24);
  rRxIncDecReady25 <= rIncDecReady(25);
  rRxIncDecReady26 <= rIncDecReady(26);
  rRxIncDecReady27 <= rIncDecReady(27);
  rRxIncDecReady28 <= rIncDecReady(28);
  rRxIncDecReady29 <= rIncDecReady(29);
  rRxIncDecReady30 <= rIncDecReady(30);
  rRxIncDecReady31 <= rIncDecReady(31);
  rRxIncDecReady32 <= rIncDecReady(32);
  rRxIncDecReady33 <= rIncDecReady(33);
  rRxIncDecReady34 <= rIncDecReady(34);
  rRxIncDecReady35 <= rIncDecReady(35);
  rRxIncDecReady36 <= rIncDecReady(36);
  rRxIncDecReady37 <= rIncDecReady(37);
  rRxIncDecReady38 <= rIncDecReady(38);
  rRxIncDecReady39 <= rIncDecReady(39);
  rRxIncDecReady40 <= '0'; -- Rev B RX Clk Signal
  rRxIncDecReady41 <= rIncDecReady(40);
  rRxIncDecReady42 <= rIncDecReady(41);
  rRxIncDecReady43 <= rIncDecReady(42);
  rRxIncDecReady44 <= rIncDecReady(43);
  rRxIncDecReady45 <= rIncDecReady(44);
  rRxIncDecReady46 <= rIncDecReady(45);
  rRxIncDecReady47 <= rIncDecReady(46);
  rRxIncDecReady48 <= rIncDecReady(47);
  rRxIncDecReady49 <= rIncDecReady(48);
  rRxIncDecReady50 <= rIncDecReady(49);
  rRxIncDecReady51 <= rIncDecReady(50);
  rRxIncDecReady52 <= rIncDecReady(51);
  rRxIncDecReady53 <= rIncDecReady(52);
  rRxIncDecReady54 <= rIncDecReady(53);
  rRxIncDecReady55 <= rIncDecReady(54);
  rRxIncDecReady56 <= rIncDecReady(55);
  rRxIncDecReady57 <= rIncDecReady(56);
  rRxIncDecReady58 <= rIncDecReady(57);
  rRxIncDecReady59 <= rIncDecReady(58);
  rRxIncDecReady60 <= rIncDecReady(59);
  rRxIncDecReady61 <= rIncDecReady(60);
  rRxIncDecReady62 <= rIncDecReady(61);
  rRxIncDecReady63 <= rIncDecReady(62);

end rtl;
