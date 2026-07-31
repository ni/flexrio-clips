-------------------------------------------------------------------------------
--
-- File: Ni6569BasicClipFl.vhd
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

entity Ni6569BasicClipFl is
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
    aClkOutInversion    : in  std_logic;
    DeviceClkTxLV       : out std_logic;
    DeviceClkRxLV       : out std_logic;
    TxLmkClk            : out std_logic;

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
    rLvdsInput          : out std_logic_vector(31 downto 0);

    -- LVDS Data Output
    tLvdsOutput         : in std_logic_vector(31 downto 0);

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
    tTxClkDelayEn0    : in std_logic;
    tTxClkDelayEn1    : in std_logic;
    tTxClkDelayEn2    : in std_logic;
    tTxClkDelayEn3    : in std_logic;
    tTxClkDelayEn4    : in std_logic;
    tTxClkDelayEn5    : in std_logic;
    tTxClkDelayEn6    : in std_logic;
    tTxClkDelayEn7    : in std_logic;
    tTxClkDelayEn8    : in std_logic;
    tTxClkDelayEn9    : in std_logic;
    tTxClkDelayEn10   : in std_logic;
    tTxClkDelayEn11   : in std_logic;
    tTxClkDelayEn12   : in std_logic;
    tTxClkDelayEn13   : in std_logic;
    tTxClkDelayEn14   : in std_logic;
    tTxClkDelayEn15   : in std_logic;
    tTxClkDelayEn16   : in std_logic;
    tTxClkDelayEn17   : in std_logic;
    tTxClkDelayEn18   : in std_logic;
    tTxClkDelayEn19   : in std_logic;
    tTxClkDelayEn20   : in std_logic;
    tTxClkDelayEn21   : in std_logic;
    tTxClkDelayEn22   : in std_logic;
    tTxClkDelayEn23   : in std_logic;
    tTxClkDelayEn24   : in std_logic;
    tTxClkDelayEn25   : in std_logic;
    tTxClkDelayEn26   : in std_logic;
    tTxClkDelayEn27   : in std_logic;
    tTxClkDelayEn28   : in std_logic;
    tTxClkDelayEn29   : in std_logic;
    tTxClkDelayEn30   : in std_logic;
    tTxClkDelayEn31   : in std_logic;
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
end entity Ni6569BasicClipFl;

architecture rtl of Ni6569BasicClipFl is

  component ODelayBasic
    generic (
      kNumTxChannels    : natural := 32;
      kIoDelayGroupName : string := "IOdelayGroup");
    port (
      aResetDelay       : in  std_logic;
      TxDataClk         : in  std_logic;
      aDelayCtrlRdy     : in  std_logic;
      tTxInc            : in  std_logic_vector(kNumTxChannels-1 downto 0);
      tTxClkDelayEn     : in  std_logic_vector(kNumTxChannels-1 downto 0);
      tDlyCount         : in  DelayArray_t(kNumTxChannels-1 downto 0);
      tTxCntValOut      : out DelayArray_t(kNumTxChannels-1 downto 0);
      tIncDecReady      : out std_logic_vector(kNumTxChannels-1 downto 0);
      tLvdsOutput       : in  std_logic_vector(kNumTxChannels-1 downto 0);
      aLvdsOutputToOBuf : out std_logic_vector(kNumTxChannels-1 downto 0));
  end component;
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
  component PinsMapping
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
      aGenDataTristate : in  std_logic_vector(31 downto 0);
      aLvdsOutput      : in  std_logic_vector(31 downto 0);
      aLvdsInput       : out std_logic_vector(31 downto 0);
      aLvdsPfiDir      : in  std_logic_vector(1 downto 0);
      aLvdsPfiOutput   : in  std_logic_vector(1 downto 0);
      aLvdsPfiInput    : out std_logic_vector(1 downto 0));
  end component;
  component TimingEngineBasic
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
      TxLmkClk                 : out std_logic;
      TxDataClk                : out std_logic;
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

  constant kFamId : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#10937A9C#, 32));

  --vhook_sigstart
  signal aConfigInterrupt: std_logic;
  signal aConfigReset_n: std_logic;
  signal aDelayCtrlRdy: std_ulogic;
  signal aGenDataTristate: std_logic_vector(31 downto 0);
  signal aLvdsAcqData: std_logic_vector(kNumRxDataChannel-1 downto 0);
  signal aLvdsInputFromIBuf: std_logic_vector(31 downto 0);
  signal aLvdsOutputToOBuf: std_logic_vector(kNumTxDataChannel-1 downto 0);
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
  signal tClkOutInversion: std_logic;
  signal tDlyCount: DelayArray_t(kNumTxDataChannel-1 downto 0);
  signal tIncDecReady: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal tTxClkDelayEn: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal tTxCntValOut: DelayArray_t(kNumTxDataChannel-1 downto 0);
  signal tTxInc: std_logic_vector(kNumTxDataChannel-1 downto 0);
  signal TxDataClk: std_logic;
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
  signal tLvdsDataOut: std_logic_vector(31 downto 0);
  constant kIoDelayGroupName : string := "IOdelayGroup";
  attribute IODELAY_GROUP         : string;
  attribute IODELAY_GROUP of DataIDelayCtrl : label is kIoDelayGroupName;

  signal RxDataClkInternal : std_logic;
  signal TxDataClkInternal : std_logic;

begin

  --vhook_nowarn rRxInc13
  --vhook_nowarn rRxClkDelayEn13
  --vhook_nowarn rRxDlyCount13

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

  --vhook TimingEngineBasic
  --vhook_a BusClk                AxiClk
  --vhook_a bAxiPeriphReset_n     xAxiPeriphReset_n
  --vhook_a {bAxi(.*)}            xTimingAxi$1
  --vhook_a RxSSClk               aLvdsInputFromIBuf(13)
  --vhook_a SiClk                 SampleClk
  --vhook_a LmkClk                DeviceClk
  TimingEngineBasicx: TimingEngineBasic
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
      RxSSClk                  => aLvdsInputFromIBuf(13),          --in  std_logic
      SiClk                    => SampleClk,                       --in  std_logic
      LmkClk                   => DeviceClk,                       --in  std_logic
      TxLmkClk                 => TxLmkClk,                        --out std_logic
      TxDataClk                => TxDataClk,                       --out std_logic
      RxDataClk                => RxDataClk,                       --out std_logic
      DelayRefClk              => DelayRefClk,                     --out std_logic
      SeRegisterClk            => SeRegisterClk,                   --out std_logic
      aDiagramClkEnable        => aDiagramClkEnable);              --in  std_logic

  TxDataClkInternal <= TxDataClk;
  RxDataClkInternal <= RxDataClk;
  DeviceClkTxLV <= TxDataClk;
  DeviceClkRxLV <= RxDataClk;

  --vhook PinsMapping
  --vhook_a aIoOutputEnable        xIoOutputEnable
  --vhook_a aSeGpio                aSeGpio(15 downto 0)
  --vhook_a aLvdsInput             aLvdsInputFromIBuf
  --vhook_a aLvdsOutput            aLvdsOutputToOBuf
  --vhook_a aLvdsPfiInput          aLvdsPfiInputFromIbuf
  --vhook_a aLvdsPfiOutput         aLvdsPfiOutputLcl
  --vhook_a aLvdsPfiDir            aLvdsPfiDirLcl
  PinsMappingx: PinsMapping
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
      aGenDataTristate => aGenDataTristate,       --in  std_logic_vector(31:0)
      aLvdsOutput      => aLvdsOutputToOBuf,      --in  std_logic_vector(31:0)
      aLvdsInput       => aLvdsInputFromIBuf,     --out std_logic_vector(31:0)
      aLvdsPfiDir      => aLvdsPfiDirLcl,         --in  std_logic_vector(1:0)
      aLvdsPfiOutput   => aLvdsPfiOutputLcl,      --in  std_logic_vector(1:0)
      aLvdsPfiInput    => aLvdsPfiInputFromIbuf); --out std_logic_vector(1:0)

  aGenDataTristate <= (others=>'0') when xIoOutputEnable='1' else (others=>'1');

  --vhook IDelayBasic
  --vhook_g kNumRxChannels          kNumRxDataChannel
  --vhook_a aResetDelay             xResetDelay
  --vhook_a aLvdsInput              aLvdsInputFromIBuf(31 downto 14) & aLvdsInputFromIBuf(12 downto 0)
  --vhook_a RxDataClk               RxDataClkInternal
  IDelayBasicx: IDelayBasic
    generic map (
      kNumRxChannels    => kNumRxDataChannel,  --natural:=32
      kIoDelayGroupName => kIoDelayGroupName)  --string:="IOdelayGroup"
    port map (
      aResetDelay   => xResetDelay,                                                         --in  std_logic
      aDelayCtrlRdy => aDelayCtrlRdy,                                                       --in  std_logic
      RxDataClk     => RxDataClkInternal,                                                   --in  std_logic
      aLvdsInput    => aLvdsInputFromIBuf(31 downto 14) & aLvdsInputFromIBuf(12 downto 0),  --in  std_logic_vector(kNumRxChannels-1:0)
      rRxInc        => rRxInc,                                                              --in  std_logic_vector(kNumRxChannels-1:0)
      rRxClkDelayEn => rRxClkDelayEn,                                                       --in  std_logic_vector(kNumRxChannels-1:0)
      rDlyCount     => rDlyCount,                                                           --in  DelayArray_t(kNumRxChannels-1:0)
      rRxCntValOut  => rRxCntValOut,                                                        --out DelayArray_t(kNumRxChannels-1:0)
      rIncDecReady  => rIncDecReady,                                                        --out std_logic_vector(kNumRxChannels-1:0)
      aLvdsAcqData  => aLvdsAcqData);                                                       --out std_logic_vector(kNumRxChannels-1:0)

  --vhook ODelayBasic
  --vhook_g kNumTxChannels          kNumTxDataChannel
  --vhook_g kIoDelayGroupName       "IOdelayGroup"
  --vhook_a aResetDelay             xResetDelay
  --vhook_a tLvdsOutput             tLvdsDataOut
  --vhook_a TxDataClk               TxDataClkInternal
  ODelayBasicx: ODelayBasic
    generic map (
      kNumTxChannels    => kNumTxDataChannel,  --natural:=32
      kIoDelayGroupName => "IOdelayGroup")     --string:="IOdelayGroup"
    port map (
      aResetDelay       => xResetDelay,        --in  std_logic
      TxDataClk         => TxDataClkInternal,  --in  std_logic
      aDelayCtrlRdy     => aDelayCtrlRdy,      --in  std_logic
      tTxInc            => tTxInc,             --in  std_logic_vector(kNumTxChannels-1:0)
      tTxClkDelayEn     => tTxClkDelayEn,      --in  std_logic_vector(kNumTxChannels-1:0)
      tDlyCount         => tDlyCount,          --in  DelayArray_t(kNumTxChannels-1:0)
      tTxCntValOut      => tTxCntValOut,       --out DelayArray_t(kNumTxChannels-1:0)
      tIncDecReady      => tIncDecReady,       --out std_logic_vector(kNumTxChannels-1:0)
      tLvdsOutput       => tLvdsDataOut,       --in  std_logic_vector(kNumTxChannels-1:0)
      aLvdsOutputToOBuf => aLvdsOutputToOBuf); --out std_logic_vector(kNumTxChannels-1:0)

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
      rLvdsInput(31 downto 0) <= (others => '0');
    elsif rising_edge(RxDataClkInternal) then
      rLvdsInput(12 downto 0)  <= aLvdsAcqData(12 downto 0);
      rLvdsInput(13)  <= '0'; -- Rev B RX Clk Signal
      rLvdsInput(31 downto 14)  <= aLvdsAcqData(30 downto 13);
    end if;
  end process RxDataFF;

  ------------------------------------------------------------------------------
  -- Map bits for generation data sent back to LVFPGA
  ------------------------------------------------------------------------------
  TxDataFF: process (TxDataClkInternal, aDiagramResetSL)
  begin
    if (aDiagramResetSL = '1') then
      tLvdsDataOut(31 downto 0) <= (others => '0');
    elsif rising_edge(TxDataClkInternal) then
      tLvdsDataOut(31 downto 14) <= tLvdsOutput(31 downto 14);
      tLvdsDataOut(13) <= tLvdsOutput(13) xor tClkOutInversion;
      tLvdsDataOut(12 downto 0) <= tLvdsOutput(12 downto 0);
    end if;
  end process TxDataFF;

  --vhook_e DoubleSyncSlAsyncIn ClkOutInversionDS
  --vhook_g kResetVal           '0'
  --vhook_a aoReset             false
  --vhook_a OClk                TxDataClkInternal
  --vhook_a aSig                aClkOutInversion
  --vhook_a oSig                tClkOutInversion
  ClkOutInversionDS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aClkOutInversion,   --in  std_logic
      aoReset => false,              --in  boolean
      OClk    => TxDataClkInternal,  --in  std_logic
      oSig    => tClkOutInversion);  --out std_logic

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
  rRxCntValOut13 <= (others => '0'); -- Rev B RX Clk Signal
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
  rRxClkDelayEn(0)  <= rRxClkDelayEn0;
  rRxClkDelayEn(1)  <= rRxClkDelayEn1;
  rRxClkDelayEn(2)  <= rRxClkDelayEn2;
  rRxClkDelayEn(3)  <= rRxClkDelayEn3;
  rRxClkDelayEn(4)  <= rRxClkDelayEn4;
  rRxClkDelayEn(5)  <= rRxClkDelayEn5;
  rRxClkDelayEn(6)  <= rRxClkDelayEn6;
  rRxClkDelayEn(7)  <= rRxClkDelayEn7;
  rRxClkDelayEn(8)  <= rRxClkDelayEn8;
  rRxClkDelayEn(9)  <= rRxClkDelayEn9;
  rRxClkDelayEn(10) <= rRxClkDelayEn10;
  rRxClkDelayEn(11) <= rRxClkDelayEn11;
  rRxClkDelayEn(12) <= rRxClkDelayEn12;
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
  rRxIncDecReady13 <= '0'; -- Rev B RX Clk Signal
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

end rtl;
