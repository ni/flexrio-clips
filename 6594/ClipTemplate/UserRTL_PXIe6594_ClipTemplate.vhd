-------------------------------------------------------------------------------
--
-- File: UserRTL_PXIe6594_ClipTemplate.vhd
-- Author: National Instruments
-- Original Project: PXIe-6594 HSS
-- Date: 22 August 2016
--
-------------------------------------------------------------------------------
-- (c) 2018 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This template is intended to be used as an example to create a custom 6594
-- I/O module CLIP. It includes the logic that is required for the 6594 to operate.
-- For this example, the MGT reference clocks are buffered and exported to LabVIEW
-- to be used as clocks.
-- 
-- The port map of this CLIP consists of 5 parts: reset, required socket signals,
-- MGT socket signals, required diagram signals, and user diagram signals.
--
-- An asynchronous reset is provided which should be used to reset the user's logic.
-- 
-- The required socket signals, consist of signals that connect directly to the
-- I/O module. It includes configuration signals that are connected to the
-- configuration netlist and should not be touched.
-- 
-- The socket also includes the MGT signals to be connected to MGT ports.
--
-- The required diagram signals are status signals that are common to any 6594
-- CLIP. These are exposed in the LabVIEW FPGA diagram and should be connected
-- to an indicator for use by the driver. See the 6594 LabVIEW examples for
-- more information on how to do this.
-- 
-- The user diagram signals are signals specific to the CLIP's IP. When you
-- change these signals, the CLIP XML must be updated to reflect these changes.
-- 
-------------------------------------------------------------------------------
--
-- vreview_group Ni6594TemplateClipVhdl
-- vreview_closed http://review-board.natinst.com/r/332217/
-- vreview_reviewers kygreen dhearn amoch
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFlexRioTargetConfig.all;

library unisim;
  use unisim.vcomponents.all;


entity UserRTL_PXIe6594_ClipTemplate is
  port (
    ------------------------------
    -- Reset                    --
    ------------------------------
    -- Asynchronous reset signal from the LabVIEW FPGA environment.
    -- This signal *must* be present in the port interface for all IO Socket CLIPs.
    -- You should reset your CLIP logic whenever this signal is logic high.
    aResetSl : in  std_logic;

    ------------------------------
    -- REQUIRED Socket Signals --
    ------------------------------
    -- These signals are used for the configuration of the device, and should
    -- not be touched by the user.
    -- I/O Module Configuration Interface
    aConfigTxClkLvds : out std_logic;
    aConfigTxClkSe   : out std_logic;
    aConfigTxDataSe  : out std_logic_vector(6 downto 0);
    aConfigRxClkLvds : in  std_logic;
    aConfigRxClkSe   : in  std_logic;
    aConfigRxDataSe  : in  std_logic_vector(6 downto 0);

    -- Reserved Interfaces
    aRsrvGpio_p : inout std_logic_vector(4 downto 0);
    aRsrvGpio_n : inout std_logic_vector(4 downto 0);

    aReservedToClip   : in  std_logic_vector(15 downto 0);
    aReservedFromClip : out std_logic_vector(15 downto 0);
    stIoModuleSupportsFRAGLs : out std_logic;

    -- Timing & Sync
    DeviceClk       : in  std_logic;
    dtDevClkEn      : out std_logic;
    dvJesd204SysRef : in  std_logic;
    aJesd204SyncReqOut_n : out std_logic;
    aJesd204SyncReqIn_n  : in  std_logic;
    aGpoSync    : out std_logic_vector(1 downto 0);
    aTriggerIn  : in  std_logic;
    aTriggerOut : out std_logic;
    dtTdcAssert : in  std_logic;
    dvTdcAssert : out std_logic;

    -- AXI4 Stream interfaces
    AxiClk : in  std_logic;
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

    -- AXI4 Lite interfaces
    xClipAxi4LiteMasterARAddr  : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterARProt  : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterARReady : in  std_logic;
    xClipAxi4LiteMasterARValid : out std_logic;
    xClipAxi4LiteMasterAWAddr  : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterAWProt  : out std_logic_vector(2 downto 0);
    xClipAxi4LiteMasterAWReady : in  std_logic;
    xClipAxi4LiteMasterAWValid : out std_logic;
    xClipAxi4LiteMasterBReady  : out std_logic;
    xClipAxi4LiteMasterBResp   : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterBValid  : in  std_logic;
    xClipAxi4LiteMasterRData   : in  std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterRReady  : out std_logic;
    xClipAxi4LiteMasterRResp   : in  std_logic_vector(1 downto 0);
    xClipAxi4LiteMasterRValid  : in  std_logic;
    xClipAxi4LiteMasterWData   : out std_logic_vector(31 downto 0);
    xClipAxi4LiteMasterWReady  : in  std_logic;
    xClipAxi4LiteMasterWStrb   : out std_logic_vector(3 downto 0);
    xClipAxi4LiteMasterWValid  : out std_logic;

    xClipAxi4LiteInterrupt     : in  std_logic;
    --vhook_nowarn xClipAxi4LiteInterrupt

    ------------------------------
    -- MGT Socket Interface     --
    ------------------------------
    -- These signals connect directly to the MGT pins, and should be connected to the
    -- user's IP.
    -- Port 0 connects to MgtPortRx/Tx(7 downto 4), along with MgtRefClk(1) and MgtRefClk(2)
    -- Port 1 connects to MgtPortRx/Tx(3 downto 0), along with MgtRefClk(0)
    -- MgtPortRx/Tx(15 downto 8) are unused and should be left disconnected.
    -- MgtPortRx/Tx have some lanes which have their polarities reversed.
    -- PkgFlexRioTargetConfig includes the constants kRxIoModRxMgtPolarity and
    -- kTxIoModTxMgtPolarity to provide these polarities. A bit of '1' indicates
    -- that the polarity is inverted.
    -- The reference clocks have a configurable frequency via the software APIs. For
    -- more information on setting the frequency, see the 6594 LabVIEW examples.
    MgtRefClk_p : in  std_logic_vector(3 downto 0);
    MgtRefClk_n : in  std_logic_vector(3 downto 0);
    MgtPortRx_p : in  std_logic_vector(15 downto 0);
    MgtPortRx_n : in  std_logic_vector(15 downto 0);
    MgtPortTx_p : out std_logic_vector(15 downto 0);
    MgtPortTx_n : out std_logic_vector(15 downto 0);
    -- ExportedMgtRefClk can be connected to one of the MGT reference clocks
    -- and to be exported to the DIO MGT CLIP.
    ExportedMgtRefClk : out std_logic;

    -------------------------------------------------------------------------------------
    -- Diagram facing signals
    -- This is the collection of signals that appears in LabVIEW FPGA.
    -- LabVIEW FPGA signals must use one of the following signal directions:  {in, out}
    -- LabVIEW FPGA signals must use one of the following data types:
    --          std_logic
    --          std_logic_vector(7 downto 0)
    --          std_logic_vector(15 downto 0)
    --          std_logic_vector(31 downto 0)
    --          std_logic_vector(63 downto 0)
    -------------------------------------------------------------------------------------

    ------------------------------
    -- REQUIRED Diagram Signals --
    ------------------------------
    -- This is the exact same clock as AxiClk, but we need to bring it in so LVFPGA can enforce its use.
    --vhook_nowarn TopLevelClk80
    TopLevelClk80      : in  std_logic;
    -- Status signals to the diagram
    xIoModuleReady     : out std_logic;
    xIoModuleErrorCode : out std_logic_vector(31 downto 0);
    xIoPort0ModPresent : out std_logic;
    xIoPort1ModPresent : out std_logic;

    ------------------------------
    -- USER Diagram Signals     --
    ------------------------------
    -- These signals may be modified to meet the requirements of the CLIP.
    -- If the ports are modified, the CLIP XML file must be updated to
    -- reflect the port map.
    MgtRefClk0 : out std_logic;
    MgtRefClk1 : out std_logic;
    MgtRefClk2 : out std_logic;
    MgtRefClk3 : out std_logic
  );
end UserRTL_PXIe6594_ClipTemplate;

architecture rtl of UserRTL_PXIe6594_ClipTemplate is

  --vhook_sigstart
  --vhook_sigend

  --vhook_d Ni6593FixedLogic
  component Ni6593FixedLogic
    port (
      AxiClk                          : in  std_logic;
      aDiagramReset                   : in  std_logic;
      aConfigTxClkLvds                : out std_logic;
      aConfigTxClkSe                  : out std_logic;
      aConfigTxDataSe                 : out std_logic_vector(6 downto 0);
      aConfigRxClkLvds                : in  std_logic;
      aConfigRxClkSe                  : in  std_logic;
      aConfigRxDataSe                 : in  std_logic_vector(6 downto 0);
      aRsrvGpio_p                     : inout std_logic_vector(4 downto 0);
      aRsrvGpio_n                     : inout std_logic_vector(4 downto 0);
      aReservedToClip                 : in  std_logic_vector(15 downto 0);
      aReservedFromClip               : out std_logic_vector(15 downto 0);
      stIoModuleSupportsFRAGLs        : out std_logic;
      DeviceClk                       : in  std_logic;
      dtDevClkEn                      : out std_logic;
      dvJesd204SysRef                 : in  std_logic;
      aJesd204SyncReqOut_n            : out std_logic;
      aJesd204SyncReqIn_n             : in  std_logic;
      aGpoSync                        : out std_logic_vector(1 downto 0);
      aTriggerIn                      : in  std_logic;
      aTriggerOut                     : out std_logic;
      dtTdcAssert                     : in  std_logic;
      dvTdcAssert                     : out std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      xIoPort0ModPresent              : out std_logic;
      xIoPort1ModPresent              : out std_logic;
      xMgtRefClkEnabled               : out std_logic_vector(3 downto 0);
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
      xClipAxi4LiteMasterWValid       : out std_logic);
  end component;

  -------------------------------------------------------------
  -- REQUIRED CLIP signals                                   --
  -------------------------------------------------------------
  signal xIoModuleReadyLcl : std_logic;
  signal xMgtRefClkEnabled : std_logic_vector(3 downto 0);
  signal IoModMgtRefclk    : std_logic_vector(MgtRefClk_p'range);
  signal IoModMgtRefclkDiv : std_logic_vector(MgtRefClk_p'range);

  -------------------------------------------------------------
  -- USER CLIP signals                                       --
  -------------------------------------------------------------
  signal MgtRefClkArray : std_logic_vector(MgtRefClk_p'range);

begin
  -----------------------------
  -- 6594 Required Logic     --
  -----------------------------
  -- !!! WARNING !!!
  -- Do not change this logic. Doing so may cause the CLIP to stop functioning.

  -- Configuration Netlist --
  -- Note: The 6593 and 6594 share the same fixed logic netlist
  --vhook Ni6593FixedLogic
  --vhook_a xIoModuleReady xIoModuleReadyLcl
  --vhook_a aDiagramReset  aResetSl
  Ni6593FixedLogicx: Ni6593FixedLogic
    port map (
      AxiClk                          => AxiClk,                           --in  std_logic
      aDiagramReset                   => aResetSl,                         --in  std_logic
      aConfigTxClkLvds                => aConfigTxClkLvds,                 --out std_logic
      aConfigTxClkSe                  => aConfigTxClkSe,                   --out std_logic
      aConfigTxDataSe                 => aConfigTxDataSe,                  --out std_logic_vector(6:0)
      aConfigRxClkLvds                => aConfigRxClkLvds,                 --in  std_logic
      aConfigRxClkSe                  => aConfigRxClkSe,                   --in  std_logic
      aConfigRxDataSe                 => aConfigRxDataSe,                  --in  std_logic_vector(6:0)
      aRsrvGpio_p                     => aRsrvGpio_p,                      --inout std_logic_vector(4:0)
      aRsrvGpio_n                     => aRsrvGpio_n,                      --inout std_logic_vector(4:0)
      aReservedToClip                 => aReservedToClip,                  --in  std_logic_vector(15:0)
      aReservedFromClip               => aReservedFromClip,                --out std_logic_vector(15:0)
      stIoModuleSupportsFRAGLs        => stIoModuleSupportsFRAGLs,         --out std_logic
      DeviceClk                       => DeviceClk,                        --in  std_logic
      dtDevClkEn                      => dtDevClkEn,                       --out std_logic
      dvJesd204SysRef                 => dvJesd204SysRef,                  --in  std_logic
      aJesd204SyncReqOut_n            => aJesd204SyncReqOut_n,             --out std_logic
      aJesd204SyncReqIn_n             => aJesd204SyncReqIn_n,              --in  std_logic
      aGpoSync                        => aGpoSync,                         --out std_logic_vector(1:0)
      aTriggerIn                      => aTriggerIn,                       --in  std_logic
      aTriggerOut                     => aTriggerOut,                      --out std_logic
      dtTdcAssert                     => dtTdcAssert,                      --in  std_logic
      dvTdcAssert                     => dvTdcAssert,                      --out std_logic
      xIoModuleReady                  => xIoModuleReadyLcl,                --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      xIoPort0ModPresent              => xIoPort0ModPresent,               --out std_logic
      xIoPort1ModPresent              => xIoPort1ModPresent,               --out std_logic
      xMgtRefClkEnabled               => xMgtRefClkEnabled,                --out std_logic_vector(3:0)
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
      xClipAxi4LiteMasterWValid       => xClipAxi4LiteMasterWValid);       --out std_logic

  xIoModuleReady <= xIoModuleReadyLcl;

  -----------------------------------------------------------------------------
  -- MGT Reference Clocks
  -----------------------------------------------------------------------------
  -- Instantiate IBUFDS_GTE4 buffers on the reference clock pins.
  -- Depending on the application, the IP may already instantiate a buffer, so
  -- these buffers may be removed in this case.

  IbufdsGen: for i in MgtRefClk_p'range generate

    --vhook_i IBUFDS_GTE4 IBUFDS_GTE4x
    --vhook_gh {.*}
    --vhook_a I     MgtRefClk_p(i)
    --vhook_a IB    MgtRefClk_n(i)
    --vhook_a CEB   '0'
    --vhook_a O     IoModMgtRefclk(i)
    --vhook_a ODIV2 IoModMgtRefclkDiv(i)
    IBUFDS_GTE4x: IBUFDS_GTE4
      port map (
        O     => IoModMgtRefclk(i),     --out std_ulogic
        ODIV2 => IoModMgtRefclkDiv(i),  --out std_ulogic
        CEB   => '0',                   --in  std_ulogic
        I     => MgtRefClk_p(i),        --in  std_ulogic
        IB    => MgtRefClk_n(i));       --in  std_ulogic

  end generate;

  -- ExportedMgtRefClk exports a reference clock from here to the DIO MGT CLIP
  ExportedMgtRefClk <= IoModMgtRefclk(2);

  -----------------------------------------------------------------------------
  -- User Logic
  -----------------------------------------------------------------------------
  -- ADD YOUR LOGIC HERE

  -- Instantiate BUFG_GTs to pass the reference clocks back to LabVIEW. To prevent
  -- glitchy clocks from passing back through to LabVIEW while clocks are getting
  -- reconfigured, gate this clock using xMgtRefClkEnabled.
  BufgGen: for i in MgtRefClk_p'range generate

    --vhook_i BUFG_GT BUFGx
    --vhook_a O       MgtRefClkArray(i)
    --vhook_a CE      xMgtRefClkEnabled(i)
    --vhook_a CEMASK  '0'
    --vhook_a CLR     '0'
    --vhook_a CLRMASK '1'
    --vhook_a DIV     "000"
    --vhook_a I       IoModMgtRefclkDiv(i)
    BUFGx: BUFG_GT
      port map (
        O       => MgtRefClkArray(i),     --out std_ulogic
        CE      => xMgtRefClkEnabled(i),  --in  std_ulogic
        CEMASK  => '0',                   --in  std_ulogic
        CLR     => '0',                   --in  std_ulogic
        CLRMASK => '1',                   --in  std_ulogic
        DIV     => "000",                 --in  std_logic_vector(2:0)
        I       => IoModMgtRefclkDiv(i)); --in  std_ulogic

  end generate;

  MgtRefClk0 <= MgtRefClkArray(0);
  MgtRefClk1 <= MgtRefClkArray(1);
  MgtRefClk2 <= MgtRefClkArray(2);
  MgtRefClk3 <= MgtRefClkArray(3);

end rtl;
