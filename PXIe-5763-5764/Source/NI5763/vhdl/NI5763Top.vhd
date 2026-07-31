-------------------------------------------------------------------------------
--
-- File: NI5763Top.vhd
-- Author: Daniel Hearn
-- Original Project: Nessie And Jessie CLIP
-- Date: 10 January 2017
--
-------------------------------------------------------------------------------
-- (c) 2017 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--  Top level file for LVFPGA.
--
-- vreview_group Nessie_Top
-- vreview_closed http://review-board.natinst.com/r/224521/
-- vreview_closed http://review-board.natinst.com/r/218646/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFam.all;

library unisim;
  use unisim.vcomponents.all;

entity NI5763Top is
  port (
    ---------------------------------------------------------------------------
    --                     FlexRIOIoSocketType1_v1                           --
    ---------------------------------------------------------------------------
    -------------------------
    -- Configuration Plane --
    -------------------------
    aConfigTxClkLvds                : out std_logic;
    aConfigTxClkSe                  : out std_logic;
    aConfigTxDataSe                 : out std_logic_vector(6 downto 0);

    aConfigRxClkLvds                : in  std_logic;
    aConfigRxClkSe                  : in  std_logic;
    aConfigRxDataSe                 : in  std_logic_vector(6 downto 0);

    aRsrvGpio_p                     : inout std_logic_vector(4 downto 0);
    aRsrvGpio_n                     : inout std_logic_vector(4 downto 0);
    ---------------
    -- MGT Plane --
    ---------------
    MgtRefClk_p                     : in  std_logic_vector(2 downto 0);
    MgtRefClk_n                     : in  std_logic_vector(2 downto 0);

    --vhook_nodgv MgtPort*
    MgtPortRx_p                     : in  std_logic_vector(7 downto 0);
    MgtPortRx_n                     : in  std_logic_vector(7 downto 0);
    MgtPortTx_p                     : out std_logic_vector(7 downto 0);
    MgtPortTx_n                     : out std_logic_vector(7 downto 0);

    ExportedMgtRefClk               : out std_logic;
    ---------------------------
    -- Synchronization Plane --
    ---------------------------
    DeviceClk                       : in  std_logic;
    dvJesd204SysRef                 : in  std_logic;
    aJesd204SyncReqOut_n            : out std_logic;
    aJesd204SyncReqIn_n             : in  std_logic;

    dtTdcAssert                     : in  std_logic;
    dvTdcAssert                     : out std_logic;
    dtDevClkEn                      : out std_logic;

    aGpoSync                        : out std_logic_vector(1 downto 0);

    aTriggerIn                      : in  std_logic;
    aTriggerOut                     : out std_logic;
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
    aReservedToClip                 : in  std_logic_vector(15 downto 0);
    aReservedFromClip               : out std_logic_vector(15 downto 0);
    stIoModuleSupportsFRAGLs        : out std_logic;
    ---------------------------------------------------------------------------
    --                     Fabric Interface                                  --
    ---------------------------------------------------------------------------
    aDiagramResetSL                 : in  std_logic;
    aDiagramClkEnable               : in  std_logic;
    ---------------------------------------------------------------------------
    --                     LabVIEW Interface                                 --
    ---------------------------------------------------------------------------
    -- Diagram Data Clocks
    DataClkToLV                     : out std_logic; --125MHz
    DataClk2xToLv                   : out std_logic; --250MHz
    TopLevelClk80                   : in  std_logic; -- this is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.

    -- Status to Diagram
    xIoModuleReady                  : out std_logic;
    xIoModuleErrorCode              : out std_logic_vector(31 downto 0);

    --ADC Data
    dtAdcChan0SampleN0              : out std_logic_vector(15 downto 0);
    dtAdcChan0SampleN1              : out std_logic_vector(15 downto 0);
    dtAdcChan0SampleN2              : out std_logic_vector(15 downto 0);
    dtAdcChan0SampleN3              : out std_logic_vector(15 downto 0);

    dtAdcChan1SampleN0              : out std_logic_vector(15 downto 0);
    dtAdcChan1SampleN1              : out std_logic_vector(15 downto 0);
    dtAdcChan1SampleN2              : out std_logic_vector(15 downto 0);
    dtAdcChan1SampleN3              : out std_logic_vector(15 downto 0);

    dtAdcChan2SampleN0              : out std_logic_vector(15 downto 0);
    dtAdcChan2SampleN1              : out std_logic_vector(15 downto 0);
    dtAdcChan2SampleN2              : out std_logic_vector(15 downto 0);
    dtAdcChan2SampleN3              : out std_logic_vector(15 downto 0);

    dtAdcChan3SampleN0              : out std_logic_vector(15 downto 0);
    dtAdcChan3SampleN1              : out std_logic_vector(15 downto 0);
    dtAdcChan3SampleN2              : out std_logic_vector(15 downto 0);
    dtAdcChan3SampleN3              : out std_logic_vector(15 downto 0);

    dtAdcDataValid                  : out std_logic
  );
end entity NI5763Top;

architecture rtl of NI5763Top is

  --vhook_sigstart
  signal aAdcRx: std_logic_vector(3 downto 0);
  signal aAdcRx_n: std_logic_vector(3 downto 0);
  signal aDacTx: std_logic_vector(3 downto 0);
  signal aDacTx_n: std_logic_vector(3 downto 0);
  signal DataClkToLvLcl: std_logic;
  signal GtRefClk: std_logic;
  signal GtRefClkLcl: std_ulogic;
  --vhook_sigend

  --vhook_d NI5763FixedLogic
  component NI5763FixedLogic
    port (
      aConfigTxClkLvds                : out std_logic;
      aConfigTxClkSe                  : out std_logic;
      aConfigTxDataSe                 : out std_logic_vector(6 downto 0);
      aConfigRxClkLvds                : in  std_logic;
      aConfigRxClkSe                  : in  std_logic;
      aConfigRxDataSe                 : in  std_logic_vector(6 downto 0);
      GtRefClk                        : in  std_logic;
      aAdcRx                          : in  std_logic_vector(3 downto 0);
      aAdcRx_n                        : in  std_logic_vector(3 downto 0);
      aDacTx                          : out std_logic_vector(3 downto 0);
      aDacTx_n                        : out std_logic_vector(3 downto 0);
      DeviceClk                       : in  std_logic;
      dvJesd204SysRef                 : in  std_logic;
      aJesd204SyncReqOut_n            : out std_logic;
      aGpoSync                        : out std_logic_vector(1 downto 0);
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
      aReservedFromClip               : out std_logic_vector(15 downto 0);
      aReservedToClip                 : in  std_logic_vector(15 downto 0);
      aDiagramResetSL                 : in  std_logic;
      aDiagramClkEnable               : in  std_logic;
      DataClkToLV                     : out std_logic;
      DataClk2xToLv                   : out std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      dtAdcChan0SampleN0              : out std_logic_vector(15 downto 0);
      dtAdcChan0SampleN1              : out std_logic_vector(15 downto 0);
      dtAdcChan0SampleN2              : out std_logic_vector(15 downto 0);
      dtAdcChan0SampleN3              : out std_logic_vector(15 downto 0);
      dtAdcChan1SampleN0              : out std_logic_vector(15 downto 0);
      dtAdcChan1SampleN1              : out std_logic_vector(15 downto 0);
      dtAdcChan1SampleN2              : out std_logic_vector(15 downto 0);
      dtAdcChan1SampleN3              : out std_logic_vector(15 downto 0);
      dtAdcChan2SampleN0              : out std_logic_vector(15 downto 0);
      dtAdcChan2SampleN1              : out std_logic_vector(15 downto 0);
      dtAdcChan2SampleN2              : out std_logic_vector(15 downto 0);
      dtAdcChan2SampleN3              : out std_logic_vector(15 downto 0);
      dtAdcChan3SampleN0              : out std_logic_vector(15 downto 0);
      dtAdcChan3SampleN1              : out std_logic_vector(15 downto 0);
      dtAdcChan3SampleN2              : out std_logic_vector(15 downto 0);
      dtAdcChan3SampleN3              : out std_logic_vector(15 downto 0);
      dtAdcDataValid                  : out std_logic;
      dtRxPolarity                    : in  std_logic_vector(3 downto 0));
  end component;

begin

  --We aren't using the Reserved GPIO so tristate them
  --vhook_nowarn aRsrvGpio*
  aRsrvGpio_n <= (others => 'Z');
  aRsrvGpio_p <= (others => 'Z');

  stIoModuleSupportsFRAGLs <= '1';

  aTriggerOut <= '0';
  --vhook_nowarn aTriggerIn
  --vhook_nowarn aJesd204SyncReqIn_n
  --vhook_nowarn xClipAxi4LiteInterrupt
  --vhook_nowarn TopLevelClk80
  dtDevClkEn <= '1';

  process(aDiagramResetSL, DataClkToLvLcl)
  begin
    if aDiagramResetSL = '1' then
      dvTdcAssert <= '0';
    elsif rising_edge(DataClkToLvLcl) then
      dvTdcAssert <= dtTdcAssert;
    end if;
  end process;

  --Map the ADC lane vector to the incoming MGT lanes from the socket
  MapLanes: for i in 0 to kAdcLaneCount-1 generate
    aAdcRx(i) <= MgtPortRx_p(kMgtLaneMap(i));
    aAdcRx_n(i) <= MgtPortRx_n(kMgtLaneMap(i));
    MgtPortTx_p(kMgtLaneMap(i)) <= aDacTx(i);
    MgtPortTx_n(kMgtLaneMap(i)) <= aDacTx_n(i);
  end generate;

  --vhook_i IBUFDS_GTE3 GtRefClkBuf hidegeneric=true
  --vhook_a CEB '0'
  --vhook_a I  MgtRefClk_p(0)
  --vhook_a IB MgtRefClk_n(0)
  --vhook_a O  GtRefClkLcl
  --vhook_a ODIV2 open
  GtRefClkBuf: IBUFDS_GTE3
    port map (
      O     => GtRefClkLcl,     --out std_ulogic
      ODIV2 => open,            --out std_ulogic
      CEB   => '0',             --in  std_ulogic
      I     => MgtRefClk_p(0),  --in  std_ulogic
      IB    => MgtRefClk_n(0)); --in  std_ulogic

  ExportedMgtRefClk <= GtRefClkLcl;
  GtRefClk <= GtRefClkLcl;

  DataClkToLV <= DataClkToLvLcl;

  --vhook_i NI5763FixedLogic
  --vhook_a dtRxPolarity kNessieRxPolarity
  --vhook_a DataClkToLV  DataClkToLvLcl
  NI5763FixedLogicx: NI5763FixedLogic
    port map (
      aConfigTxClkLvds                => aConfigTxClkLvds,                 --out std_logic
      aConfigTxClkSe                  => aConfigTxClkSe,                   --out std_logic
      aConfigTxDataSe                 => aConfigTxDataSe,                  --out std_logic_vector(6:0)
      aConfigRxClkLvds                => aConfigRxClkLvds,                 --in  std_logic
      aConfigRxClkSe                  => aConfigRxClkSe,                   --in  std_logic
      aConfigRxDataSe                 => aConfigRxDataSe,                  --in  std_logic_vector(6:0)
      GtRefClk                        => GtRefClk,                         --in  std_logic
      aAdcRx                          => aAdcRx,                           --in  std_logic_vector(3:0)
      aAdcRx_n                        => aAdcRx_n,                         --in  std_logic_vector(3:0)
      aDacTx                          => aDacTx,                           --out std_logic_vector(3:0)
      aDacTx_n                        => aDacTx_n,                         --out std_logic_vector(3:0)
      DeviceClk                       => DeviceClk,                        --in  std_logic
      dvJesd204SysRef                 => dvJesd204SysRef,                  --in  std_logic
      aJesd204SyncReqOut_n            => aJesd204SyncReqOut_n,             --out std_logic
      aGpoSync                        => aGpoSync,                         --out std_logic_vector(1:0)
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
      aReservedFromClip               => aReservedFromClip,                --out std_logic_vector(15:0)
      aReservedToClip                 => aReservedToClip,                  --in  std_logic_vector(15:0)
      aDiagramResetSL                 => aDiagramResetSL,                  --in  std_logic
      aDiagramClkEnable               => aDiagramClkEnable,                --in  std_logic
      DataClkToLV                     => DataClkToLvLcl,                   --out std_logic
      DataClk2xToLv                   => DataClk2xToLv,                    --out std_logic
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      dtAdcChan0SampleN0              => dtAdcChan0SampleN0,               --out std_logic_vector(15:0)
      dtAdcChan0SampleN1              => dtAdcChan0SampleN1,               --out std_logic_vector(15:0)
      dtAdcChan0SampleN2              => dtAdcChan0SampleN2,               --out std_logic_vector(15:0)
      dtAdcChan0SampleN3              => dtAdcChan0SampleN3,               --out std_logic_vector(15:0)
      dtAdcChan1SampleN0              => dtAdcChan1SampleN0,               --out std_logic_vector(15:0)
      dtAdcChan1SampleN1              => dtAdcChan1SampleN1,               --out std_logic_vector(15:0)
      dtAdcChan1SampleN2              => dtAdcChan1SampleN2,               --out std_logic_vector(15:0)
      dtAdcChan1SampleN3              => dtAdcChan1SampleN3,               --out std_logic_vector(15:0)
      dtAdcChan2SampleN0              => dtAdcChan2SampleN0,               --out std_logic_vector(15:0)
      dtAdcChan2SampleN1              => dtAdcChan2SampleN1,               --out std_logic_vector(15:0)
      dtAdcChan2SampleN2              => dtAdcChan2SampleN2,               --out std_logic_vector(15:0)
      dtAdcChan2SampleN3              => dtAdcChan2SampleN3,               --out std_logic_vector(15:0)
      dtAdcChan3SampleN0              => dtAdcChan3SampleN0,               --out std_logic_vector(15:0)
      dtAdcChan3SampleN1              => dtAdcChan3SampleN1,               --out std_logic_vector(15:0)
      dtAdcChan3SampleN2              => dtAdcChan3SampleN2,               --out std_logic_vector(15:0)
      dtAdcChan3SampleN3              => dtAdcChan3SampleN3,               --out std_logic_vector(15:0)
      dtAdcDataValid                  => dtAdcDataValid,                   --out std_logic
      dtRxPolarity                    => kNessieRxPolarity);               --in  std_logic_vector(3:0)

end rtl;