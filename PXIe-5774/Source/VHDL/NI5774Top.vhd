-------------------------------------------------------------------------------
--
-- File: NI5774Top.vhd
-- Author: Larbi Boughaleb
-- Original Project: Daniel Hearn's Nessie Clip Reference Design
-- Date: 07 April 2017
--
-------------------------------------------------------------------------------
-- (c) 2017 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--  NI5774 Clip TopLevel File.
--
-- vreview_group Sphinx_Common
-- vreview_closed http://review-board.natinst.com/r/264928/
-- vreview_closed http://review-board.natinst.com/r/224518/
-- vreview_closed http://review-board.natinst.com/r/218649/
-- vreview_reviewers kygreen dhearn rortega privera lboughal
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

entity NI5774Top is
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
    -- JESD204B Signals
    DeviceClk                       : in  std_logic;
    dvJesd204SysRef                 : in  std_logic;
    aJesd204SyncReqOut_n            : out std_logic;
    aJesd204SyncReqIn_n             : in  std_logic;

    -- TDC Signals
    dtTdcAssert                     : in  std_logic;
    dvTdcAssert                     : out std_logic;
    dtDevClkEn                      : out std_logic;

    -- Optional Sync Signals
    aGpoSync                        : out std_logic_vector(1 downto 0);

    -- NI-5774 dedicated trigger signals
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
    -- TopLevelClk80 is the exact same clock as AxiClk.
    -- We need it here so that LVFPGA can enforce its use.
    DataClkToLV                     : out std_logic; --160MHz
    DataClk2xToLv                   : out std_logic; --320MHz
    TopLevelClk80                   : in  std_logic;

    -- Status to Diagram
    xIoModuleReady                  : out std_logic;
    xIoModuleErrorCode              : out std_logic_vector(31 downto 0);

    --ADC Data Channel 0
    --N-15 is the oldest data, N is the newest
    dtAdcChan0SampleNminus15        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus14        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus13        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus12        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus11        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus10        : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus9         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus8         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus7         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus6         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus5         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus4         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus3         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus2         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleNminus1         : out std_logic_vector(11 downto 0);
    dtAdcChan0SampleN               : out std_logic_vector(11 downto 0);

    --ADC Data Channel 1
    --N-15 is the oldest data, N is the newest
    dtAdcChan1SampleNminus15        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus14        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus13        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus12        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus11        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus10        : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus9         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus8         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus7         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus6         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus5         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus4         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus3         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus2         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleNminus1         : out std_logic_vector(11 downto 0);
    dtAdcChan1SampleN               : out std_logic_vector(11 downto 0);

    -- ADC Data Valid Flag
    -- ADC data is zeroed out when this flag is clear
    dtAdcDataValid                  : out std_logic;

    -- LV Trigger Input/Output Signals
    dTriggerIn                      : out std_logic;
    dTriggerOut                     : in std_logic;
    
    -- TDC Expanded pulse sampled signal
    -- The TDC expanded pulse is sampled using a DDR flop clocked off
    -- DataClk2x. The DDR flop outputs are dTdcExpandedPulseSample1/2.
    -- The effective expanded pulse sampling resolution is therefore
    -- 4x the DataClk resolution
    dTdcExpandedPulseSample1        : out std_logic;
    dTdcExpandedPulseSample2        : out std_logic

  );
end entity NI5774Top;

architecture rtl of NI5774Top is

  --vhook_sigstart
  signal aLvTriggerOut: std_logic;
  signal DataClkToLvLcl: std_logic;
  signal dTdcExpandedPulse: std_logic_vector(1 downto 0);
  signal GtRefClk: std_logic;
  signal GtRefClkLcl: std_ulogic;
  --vhook_sigend

  --vhook_d NI5774FixedLogic
  component NI5774FixedLogic
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
      aGpoSync                        : out std_logic_vector(1 downto 0);
      aTriggerIn                      : in  std_logic;
      aTriggerOut                     : out std_logic := '0';
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
      DataClk2xToLV                   : out std_logic;
      dtAdcChan0SampleNminus15        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus14        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus13        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus12        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus11        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus10        : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus9         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus8         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus7         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus6         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus5         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus4         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus3         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus2         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleNminus1         : out std_logic_vector(11 downto 0);
      dtAdcChan0SampleN               : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus15        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus14        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus13        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus12        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus11        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus10        : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus9         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus8         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus7         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus6         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus5         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus4         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus3         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus2         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleNminus1         : out std_logic_vector(11 downto 0);
      dtAdcChan1SampleN               : out std_logic_vector(11 downto 0);
      dtAdcDataValid                  : out std_logic;
      dTriggerIn                      : out std_logic;
      dTriggerOut                     : in  std_logic;
      dTdcExpandedPulse               : out std_logic_vector(1 downto 0);
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0));
  end component;

begin

  aTriggerOut <= aLvTriggerOut;

  --We aren't using the Reserved GPIO so tristate them
  --vhook_nowarn aRsrvGpio*
  aRsrvGpio_n <= (others => 'Z');
  aRsrvGpio_p <= (others => 'Z');

  stIoModuleSupportsFRAGLs <= '1';

  --vhook_nowarn aJesd204SyncReqIn_n
  --vhook_nowarn xClipAxi4LiteInterrupt
  --vhook_nowarn TopLevelClk80
  --vhook_nodgv GtRefclk

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

  -- Export MgtRefClk for possible use with NanoPitch
  ExportedMgtRefClk <= GtRefClkLcl;
  GtRefClk <= GtRefClkLcl;

  -- Synchronization Section
  -- Device Clock Frequency = LV Data Clock Frequency
  dtDevClkEn <= '1';

  process(aDiagramResetSL, DataClkToLvLcl)
  begin
    if aDiagramResetSL = '1' then
      dvTdcAssert <= '0';
    elsif rising_edge(DataClkToLvLcl) then
      dvTdcAssert <= dtTdcAssert;
    end if;
  end process;

  DataClkToLV <= DataClkToLvLcl;

  dTdcExpandedPulseSample1 <= dTdcExpandedPulse(0);
  dTdcExpandedPulseSample2 <= dTdcExpandedPulse(1);

  --vhook_i NI5774FixedLogic
  --vhook_a aAdcRx MgtPortRx_p
  --vhook_a aAdcRx_n MgtPortRx_n
  --vhook_a aDacTx MgtPortTx_p
  --vhook_a aDacTx_n MgtPortTx_n
  --vhook_a aTriggerOut aLvTriggerOut
  --vhook_a DataClkToLV DataClkToLvLcl
  NI5774FixedLogicx: NI5774FixedLogic
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
      aGpoSync                        => aGpoSync,                         --out std_logic_vector(1:0)
      aTriggerIn                      => aTriggerIn,                       --in  std_logic
      aTriggerOut                     => aLvTriggerOut,                    --out std_logic:='0'
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
      DataClk2xToLV                   => DataClk2xToLV,                    --out std_logic
      dtAdcChan0SampleNminus15        => dtAdcChan0SampleNminus15,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus14        => dtAdcChan0SampleNminus14,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus13        => dtAdcChan0SampleNminus13,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus12        => dtAdcChan0SampleNminus12,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus11        => dtAdcChan0SampleNminus11,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus10        => dtAdcChan0SampleNminus10,         --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus9         => dtAdcChan0SampleNminus9,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus8         => dtAdcChan0SampleNminus8,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus7         => dtAdcChan0SampleNminus7,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus6         => dtAdcChan0SampleNminus6,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus5         => dtAdcChan0SampleNminus5,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus4         => dtAdcChan0SampleNminus4,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus3         => dtAdcChan0SampleNminus3,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus2         => dtAdcChan0SampleNminus2,          --out std_logic_vector(11:0)
      dtAdcChan0SampleNminus1         => dtAdcChan0SampleNminus1,          --out std_logic_vector(11:0)
      dtAdcChan0SampleN               => dtAdcChan0SampleN,                --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus15        => dtAdcChan1SampleNminus15,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus14        => dtAdcChan1SampleNminus14,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus13        => dtAdcChan1SampleNminus13,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus12        => dtAdcChan1SampleNminus12,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus11        => dtAdcChan1SampleNminus11,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus10        => dtAdcChan1SampleNminus10,         --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus9         => dtAdcChan1SampleNminus9,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus8         => dtAdcChan1SampleNminus8,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus7         => dtAdcChan1SampleNminus7,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus6         => dtAdcChan1SampleNminus6,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus5         => dtAdcChan1SampleNminus5,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus4         => dtAdcChan1SampleNminus4,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus3         => dtAdcChan1SampleNminus3,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus2         => dtAdcChan1SampleNminus2,          --out std_logic_vector(11:0)
      dtAdcChan1SampleNminus1         => dtAdcChan1SampleNminus1,          --out std_logic_vector(11:0)
      dtAdcChan1SampleN               => dtAdcChan1SampleN,                --out std_logic_vector(11:0)
      dtAdcDataValid                  => dtAdcDataValid,                   --out std_logic
      dTriggerIn                      => dTriggerIn,                       --out std_logic
      dTriggerOut                     => dTriggerOut,                      --in  std_logic
      dTdcExpandedPulse               => dTdcExpandedPulse,                --out std_logic_vector(1:0)
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode);              --out std_logic_vector(31:0)



end rtl;
