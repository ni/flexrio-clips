-------------------------------------------------------------------------------
--
-- File: NI5775Top.vhd
-- Author: Pedro Rivera
-- Original Project: Jackalope CLIP
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
-- vreview_group JackalopeTop
-- vreview_closed http://review-board.natinst.com/r/254898/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

entity NI5775Top is
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
    xIoModuleReady : out std_logic;
    xIoModuleErrorCode : out std_logic_vector(31 downto 0);

    -- Diagram Data Clocks
    DataClkToLV                     : out std_logic;
    DataClk2xToLv                   : out std_logic;
    -- This is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.
    TopLevelClk80                   : in  std_logic;

    --ADC Channel 0 data
    dAdc0Sample0  : out std_logic_vector(11 downto 0);
    dAdc0Sample1  : out std_logic_vector(11 downto 0);
    dAdc0Sample2  : out std_logic_vector(11 downto 0);
    dAdc0Sample3  : out std_logic_vector(11 downto 0);
    dAdc0Sample4  : out std_logic_vector(11 downto 0);
    dAdc0Sample5  : out std_logic_vector(11 downto 0);
    dAdc0Sample6  : out std_logic_vector(11 downto 0);
    dAdc0Sample7  : out std_logic_vector(11 downto 0);
    dAdc0Sample8  : out std_logic_vector(11 downto 0);
    dAdc0Sample9  : out std_logic_vector(11 downto 0);
    dAdc0Sample10 : out std_logic_vector(11 downto 0);
    dAdc0Sample11 : out std_logic_vector(11 downto 0);
    dAdc0Sample12 : out std_logic_vector(11 downto 0);
    dAdc0Sample13 : out std_logic_vector(11 downto 0);
    dAdc0Sample14 : out std_logic_vector(11 downto 0);
    dAdc0Sample15 : out std_logic_vector(11 downto 0);
    -- ADC Channel 1 data
    dAdc1Sample0  : out std_logic_vector(11 downto 0);
    dAdc1Sample1  : out std_logic_vector(11 downto 0);
    dAdc1Sample2  : out std_logic_vector(11 downto 0);
    dAdc1Sample3  : out std_logic_vector(11 downto 0);
    dAdc1Sample4  : out std_logic_vector(11 downto 0);
    dAdc1Sample5  : out std_logic_vector(11 downto 0);
    dAdc1Sample6  : out std_logic_vector(11 downto 0);
    dAdc1Sample7  : out std_logic_vector(11 downto 0);
    dAdc1Sample8  : out std_logic_vector(11 downto 0);
    dAdc1Sample9  : out std_logic_vector(11 downto 0);
    dAdc1Sample10 : out std_logic_vector(11 downto 0);
    dAdc1Sample11 : out std_logic_vector(11 downto 0);
    dAdc1Sample12 : out std_logic_vector(11 downto 0);
    dAdc1Sample13 : out std_logic_vector(11 downto 0);
    dAdc1Sample14 : out std_logic_vector(11 downto 0);
    dAdc1Sample15 : out std_logic_vector(11 downto 0);
    dRxDataValid  : out std_logic
  );
end entity NI5775Top;

architecture rtl of NI5775Top is

  --vhook_sigstart
  signal GtRefClk: std_logic;
  signal GtRefClkLcl: std_ulogic;
  --vhook_sigend
  signal DataClkLcl :std_logic;

  --vhook_nowarn msg={generic 'kIsReceiver' not found}
  --vhook_nowarn msg={generic 'kIsTransmitter' not found}

  --vhook_d CommonFixedLogic hidegeneric=true
  component CommonFixedLogic
    port (
      aConfigTxClkLvds                : out std_logic;
      aConfigTxClkSe                  : out std_logic;
      aConfigTxDataSe                 : out std_logic_vector(6 downto 0);
      aConfigRxClkLvds                : in  std_logic;
      aConfigRxClkSe                  : in  std_logic;
      aConfigRxDataSe                 : in  std_logic_vector(6 downto 0);
      GtRefClk                        : in  std_logic;
      aAdcRx                          : in  std_logic_vector(7 downto 0);
      aAdcRx_n                        : in  std_logic_vector(7 downto 0);
      aDacTx                          : out std_logic_vector(7 downto 0);
      aDacTx_n                        : out std_logic_vector(7 downto 0);
      DeviceClk                       : in  std_logic;
      dvJesd204SysRef                 : in  std_logic;
      aJesd204SyncReqOut_n            : out std_logic;
      aJesd204SyncReqIn_n             : in  std_logic;
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
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      DataClkToLV                     : out std_logic;
      DataClk2xToLv                   : out std_logic;
      dAdc0Sample0                    : out std_logic_vector(11 downto 0);
      dAdc0Sample1                    : out std_logic_vector(11 downto 0);
      dAdc0Sample2                    : out std_logic_vector(11 downto 0);
      dAdc0Sample3                    : out std_logic_vector(11 downto 0);
      dAdc0Sample4                    : out std_logic_vector(11 downto 0);
      dAdc0Sample5                    : out std_logic_vector(11 downto 0);
      dAdc0Sample6                    : out std_logic_vector(11 downto 0);
      dAdc0Sample7                    : out std_logic_vector(11 downto 0);
      dAdc0Sample8                    : out std_logic_vector(11 downto 0);
      dAdc0Sample9                    : out std_logic_vector(11 downto 0);
      dAdc0Sample10                   : out std_logic_vector(11 downto 0);
      dAdc0Sample11                   : out std_logic_vector(11 downto 0);
      dAdc0Sample12                   : out std_logic_vector(11 downto 0);
      dAdc0Sample13                   : out std_logic_vector(11 downto 0);
      dAdc0Sample14                   : out std_logic_vector(11 downto 0);
      dAdc0Sample15                   : out std_logic_vector(11 downto 0);
      dAdc1Sample0                    : out std_logic_vector(11 downto 0);
      dAdc1Sample1                    : out std_logic_vector(11 downto 0);
      dAdc1Sample2                    : out std_logic_vector(11 downto 0);
      dAdc1Sample3                    : out std_logic_vector(11 downto 0);
      dAdc1Sample4                    : out std_logic_vector(11 downto 0);
      dAdc1Sample5                    : out std_logic_vector(11 downto 0);
      dAdc1Sample6                    : out std_logic_vector(11 downto 0);
      dAdc1Sample7                    : out std_logic_vector(11 downto 0);
      dAdc1Sample8                    : out std_logic_vector(11 downto 0);
      dAdc1Sample9                    : out std_logic_vector(11 downto 0);
      dAdc1Sample10                   : out std_logic_vector(11 downto 0);
      dAdc1Sample11                   : out std_logic_vector(11 downto 0);
      dAdc1Sample12                   : out std_logic_vector(11 downto 0);
      dAdc1Sample13                   : out std_logic_vector(11 downto 0);
      dAdc1Sample14                   : out std_logic_vector(11 downto 0);
      dAdc1Sample15                   : out std_logic_vector(11 downto 0);
      dRxDataValid                    : out std_logic;
      dDac0Sample0                    : in  std_logic_vector(11 downto 0);
      dDac0Sample1                    : in  std_logic_vector(11 downto 0);
      dDac0Sample2                    : in  std_logic_vector(11 downto 0);
      dDac0Sample3                    : in  std_logic_vector(11 downto 0);
      dDac0Sample4                    : in  std_logic_vector(11 downto 0);
      dDac0Sample5                    : in  std_logic_vector(11 downto 0);
      dDac0Sample6                    : in  std_logic_vector(11 downto 0);
      dDac0Sample7                    : in  std_logic_vector(11 downto 0);
      dDac0Sample8                    : in  std_logic_vector(11 downto 0);
      dDac0Sample9                    : in  std_logic_vector(11 downto 0);
      dDac0Sample10                   : in  std_logic_vector(11 downto 0);
      dDac0Sample11                   : in  std_logic_vector(11 downto 0);
      dDac0Sample12                   : in  std_logic_vector(11 downto 0);
      dDac0Sample13                   : in  std_logic_vector(11 downto 0);
      dDac0Sample14                   : in  std_logic_vector(11 downto 0);
      dDac0Sample15                   : in  std_logic_vector(11 downto 0);
      dDac1Sample0                    : in  std_logic_vector(11 downto 0);
      dDac1Sample1                    : in  std_logic_vector(11 downto 0);
      dDac1Sample2                    : in  std_logic_vector(11 downto 0);
      dDac1Sample3                    : in  std_logic_vector(11 downto 0);
      dDac1Sample4                    : in  std_logic_vector(11 downto 0);
      dDac1Sample5                    : in  std_logic_vector(11 downto 0);
      dDac1Sample6                    : in  std_logic_vector(11 downto 0);
      dDac1Sample7                    : in  std_logic_vector(11 downto 0);
      dDac1Sample8                    : in  std_logic_vector(11 downto 0);
      dDac1Sample9                    : in  std_logic_vector(11 downto 0);
      dDac1Sample10                   : in  std_logic_vector(11 downto 0);
      dDac1Sample11                   : in  std_logic_vector(11 downto 0);
      dDac1Sample12                   : in  std_logic_vector(11 downto 0);
      dDac1Sample13                   : in  std_logic_vector(11 downto 0);
      dDac1Sample14                   : in  std_logic_vector(11 downto 0);
      dDac1Sample15                   : in  std_logic_vector(11 downto 0);
      dTxReadyForInput                : out std_logic);
  end component;

begin
  --vhook_nowarn aTriggerIn
  --vhook_nowarn aJesd204SyncReqIn_n
  --vhook_nowarn xClipAxi4LiteInterrupt
  --vhook_nowarn TopLevelClk80
  --vhook_nowarn aRsrvGpio*

  stIoModuleSupportsFRAGLs <= '1';

  --We aren't using the Reserved GPIO so tristate them
  aRsrvGpio_n <= (others => 'Z');
  aRsrvGpio_p <= (others => 'Z');

  aTriggerOut <= '0';
  dtDevClkEn  <= '1';
  DataClkToLv <=  DataClkLcl;

  -- Clocking the TdcAssert on the DeviceClk domain struggles meeting
  -- the setup requirement accross FPGA variants. The phase of DataClk
  -- conveniently satisfies the timing requirements.
  process(aDiagramResetSL, DataClkLcl)
  begin
    if aDiagramResetSL = '1' then
      dvTdcAssert <= '0';
    elsif rising_edge(DataClkLcl) then
      dvTdcAssert <= dtTdcAssert;
    end if;
  end process;

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

  --vhook_i CommonFixedLogic hidegeneric=true
  --vhook_a aAdcRx     MgtPortRx_p
  --vhook_a aAdcRx_n   MgtPortRx_n
  --vhook_a aDacTx     MgtPortTx_p
  --vhook_a aDacTx_n   MgtPortTx_n
  --vhook_a dDac*      (others => '0')
  --vhook_a DataClkToLv      DataClkLcl
  --vhook_a dTxReadyForInput open
  --vhook_a dTxDataValid     '0'
  CommonFixedLogicx: CommonFixedLogic
    port map (
      aConfigTxClkLvds                => aConfigTxClkLvds,                 --out std_logic
      aConfigTxClkSe                  => aConfigTxClkSe,                   --out std_logic
      aConfigTxDataSe                 => aConfigTxDataSe,                  --out std_logic_vector(6:0)
      aConfigRxClkLvds                => aConfigRxClkLvds,                 --in  std_logic
      aConfigRxClkSe                  => aConfigRxClkSe,                   --in  std_logic
      aConfigRxDataSe                 => aConfigRxDataSe,                  --in  std_logic_vector(6:0)
      GtRefClk                        => GtRefClk,                         --in  std_logic
      aAdcRx                          => MgtPortRx_p,                      --in  std_logic_vector(7:0)
      aAdcRx_n                        => MgtPortRx_n,                      --in  std_logic_vector(7:0)
      aDacTx                          => MgtPortTx_p,                      --out std_logic_vector(7:0)
      aDacTx_n                        => MgtPortTx_n,                      --out std_logic_vector(7:0)
      DeviceClk                       => DeviceClk,                        --in  std_logic
      dvJesd204SysRef                 => dvJesd204SysRef,                  --in  std_logic
      aJesd204SyncReqOut_n            => aJesd204SyncReqOut_n,             --out std_logic
      aJesd204SyncReqIn_n             => aJesd204SyncReqIn_n,              --in  std_logic
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
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      DataClkToLV                     => DataClkLcl,                       --out std_logic
      DataClk2xToLv                   => DataClk2xToLv,                    --out std_logic
      dAdc0Sample0                    => dAdc0Sample0,                     --out std_logic_vector(11:0)
      dAdc0Sample1                    => dAdc0Sample1,                     --out std_logic_vector(11:0)
      dAdc0Sample2                    => dAdc0Sample2,                     --out std_logic_vector(11:0)
      dAdc0Sample3                    => dAdc0Sample3,                     --out std_logic_vector(11:0)
      dAdc0Sample4                    => dAdc0Sample4,                     --out std_logic_vector(11:0)
      dAdc0Sample5                    => dAdc0Sample5,                     --out std_logic_vector(11:0)
      dAdc0Sample6                    => dAdc0Sample6,                     --out std_logic_vector(11:0)
      dAdc0Sample7                    => dAdc0Sample7,                     --out std_logic_vector(11:0)
      dAdc0Sample8                    => dAdc0Sample8,                     --out std_logic_vector(11:0)
      dAdc0Sample9                    => dAdc0Sample9,                     --out std_logic_vector(11:0)
      dAdc0Sample10                   => dAdc0Sample10,                    --out std_logic_vector(11:0)
      dAdc0Sample11                   => dAdc0Sample11,                    --out std_logic_vector(11:0)
      dAdc0Sample12                   => dAdc0Sample12,                    --out std_logic_vector(11:0)
      dAdc0Sample13                   => dAdc0Sample13,                    --out std_logic_vector(11:0)
      dAdc0Sample14                   => dAdc0Sample14,                    --out std_logic_vector(11:0)
      dAdc0Sample15                   => dAdc0Sample15,                    --out std_logic_vector(11:0)
      dAdc1Sample0                    => dAdc1Sample0,                     --out std_logic_vector(11:0)
      dAdc1Sample1                    => dAdc1Sample1,                     --out std_logic_vector(11:0)
      dAdc1Sample2                    => dAdc1Sample2,                     --out std_logic_vector(11:0)
      dAdc1Sample3                    => dAdc1Sample3,                     --out std_logic_vector(11:0)
      dAdc1Sample4                    => dAdc1Sample4,                     --out std_logic_vector(11:0)
      dAdc1Sample5                    => dAdc1Sample5,                     --out std_logic_vector(11:0)
      dAdc1Sample6                    => dAdc1Sample6,                     --out std_logic_vector(11:0)
      dAdc1Sample7                    => dAdc1Sample7,                     --out std_logic_vector(11:0)
      dAdc1Sample8                    => dAdc1Sample8,                     --out std_logic_vector(11:0)
      dAdc1Sample9                    => dAdc1Sample9,                     --out std_logic_vector(11:0)
      dAdc1Sample10                   => dAdc1Sample10,                    --out std_logic_vector(11:0)
      dAdc1Sample11                   => dAdc1Sample11,                    --out std_logic_vector(11:0)
      dAdc1Sample12                   => dAdc1Sample12,                    --out std_logic_vector(11:0)
      dAdc1Sample13                   => dAdc1Sample13,                    --out std_logic_vector(11:0)
      dAdc1Sample14                   => dAdc1Sample14,                    --out std_logic_vector(11:0)
      dAdc1Sample15                   => dAdc1Sample15,                    --out std_logic_vector(11:0)
      dRxDataValid                    => dRxDataValid,                     --out std_logic
      dDac0Sample0                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample1                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample2                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample3                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample4                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample5                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample6                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample7                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample8                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample9                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample10                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample11                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample12                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample13                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample14                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac0Sample15                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample0                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample1                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample2                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample3                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample4                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample5                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample6                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample7                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample8                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample9                    => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample10                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample11                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample12                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample13                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample14                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dDac1Sample15                   => (others => '0'),                  --in  std_logic_vector(11:0)
      dTxReadyForInput                => open);                            --out std_logic

end rtl;