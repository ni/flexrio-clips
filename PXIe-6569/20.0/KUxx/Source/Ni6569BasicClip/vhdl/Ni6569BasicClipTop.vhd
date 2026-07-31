-------------------------------------------------------------------------------
--
-- File: Ni6569BasicClipTop.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 11 June 2019
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

entity Ni6569BasicClipTop is
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
    DeviceClkTxLV       : out std_logic;
    DeviceClkRxLV       : out std_logic;
    aClkOutInversion    : in std_logic;

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
    rLvdsInput          : out std_logic_vector(31 downto 0);

    -- LVDS Data Output
    tLvdsOutput         : in std_logic_vector(31 downto 0);

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
    tTxClkDelayEn31     : in std_logic
    );
end entity Ni6569BasicClipTop;

architecture rtl of Ni6569BasicClipTop is

  component Ni6569BasicClipFl
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
      aClkOutInversion                : in  std_logic;
      DeviceClkTxLV                   : out std_logic;
      DeviceClkRxLV                   : out std_logic;
      TxLmkClk                        : out std_logic;
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
      rLvdsInput                      : out std_logic_vector(31 downto 0);
      tLvdsOutput                     : in  std_logic_vector(31 downto 0);
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
  signal TxLmkClk: std_logic;
  --vhook_sigend

begin

  -- This CLIP supports IFIFO_RPC
  stIoModuleSupportsFRAGLs <= '1';

  -- Unused signals
  aReservedFromClip        <= (others => '0');
  dtDevClkEn               <= '1';

  TdcAssert: process (aDiagramResetSL, TxLmkClk)
  begin
    if (aDiagramResetSL = '1') then
      dvTdcAssert <= '0';
    elsif rising_edge(TxLmkClk) then
      dvTdcAssert <= dtTdcAssert;
    end if;
  end process TdcAssert;

  --vhook_nowarn aReservedToClip
  --vhook_nowarn xIo*
  --vhook_nowarn aGpio*
  --vhook_nowarn xClipAxi4LiteInterrupt

  --vhook Ni6569BasicClipFl
  Ni6569BasicClipFlx: Ni6569BasicClipFl
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
      aClkOutInversion                => aClkOutInversion,                 --in  std_logic
      DeviceClkTxLV                   => DeviceClkTxLV,                    --out std_logic
      DeviceClkRxLV                   => DeviceClkRxLV,                    --out std_logic
      TxLmkClk                        => TxLmkClk,                         --out std_logic
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
      rLvdsInput                      => rLvdsInput,                       --out std_logic_vector(31:0)
      tLvdsOutput                     => tLvdsOutput,                      --in  std_logic_vector(31:0)
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
      aLvdsPfiDir0                    => aLvdsPfiDir0,                     --in  std_logic
      aLvdsPfiDir1                    => aLvdsPfiDir1,                     --in  std_logic
      aLvdsPfiInput0                  => aLvdsPfiInput0,                   --out std_logic
      aLvdsPfiInput1                  => aLvdsPfiInput1,                   --out std_logic
      aLvdsPfiOutput0                 => aLvdsPfiOutput0,                  --in  std_logic
      aLvdsPfiOutput1                 => aLvdsPfiOutput1,                  --in  std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode);              --out std_logic_vector(31:0)

  end rtl;
