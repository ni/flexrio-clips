-------------------------------------------------------------------------------
--
-- File: UserRTL_PXIe6593_Aurora64b66b_Framing.vhd
-- Author: National Instruments
-- Original Project: PXIe-6593 HSS
-- Date: 22 August 2016
--
-------------------------------------------------------------------------------
-- (c) 2018 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This CLIP instantiates an Aurora 64b66b core for the PXIe-6593. This core
-- is configured with the following settings:
--
-- 4 Lanes
-- Line rate: 16.25Gbps
-- Reference Clock: 156.25MHz
-- Interface: Framing
-- CRC: None
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgAXI4Lite_GTHE3_Control.all;

library unisim;
  use unisim.vcomponents.all;

entity UserRTL_PXIe6593_Aurora64b66b_Framing is
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
    -- more information on setting the frequency, see the 6593 LabVIEW examples.
    MgtRefClk_p : in  std_logic_vector(2 downto 0);
    MgtRefClk_n : in  std_logic_vector(2 downto 0);
    MgtPortRx_p : in  std_logic_vector(7 downto 0);
    MgtPortRx_n : in  std_logic_vector(7 downto 0);
    MgtPortTx_p : out std_logic_vector(7 downto 0);
    MgtPortTx_n : out std_logic_vector(7 downto 0);
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

    -------------------------------------------------------------------------------
    -- AXI4 Framing interfaces - Aurora
    -------------------------------------------------------------------------------
    -- These signals may be modified to meet the requirements of the CLIP.
    -- If the ports are modified, the CLIP XML file must be updated to
    -- reflect the port map.
    -- On-board 80 MHz clock for use with CLIP interfacing signals
    InitClk              : in  std_logic;

    -- AXI Streaming User Clock Outputs (to LabVIEW FPGA diagram from I/O Socket)
    -- These clocks run at the line rate/64. By default, at 16.375Gbps, these
    -- clocks run at 255.86MHz.
    Port0_UserClk               : out std_logic;
    Port1_UserClk               : out std_logic;

    -- Initialization reset signals to the Aurora cores
    cPort0_PMA_Init             : in  std_logic;
    cPort1_PMA_Init             : in  std_logic;
    cPort0_reset_pb             : in  std_logic;
    cPort1_reset_pb             : in  std_logic;

    -- AXI Streaming TX Interface
    -- The following signals are REQUIRED to be in the Port0_UserClk domain:
    uPort0_s_axi_tx_tdata0      : in  std_logic_vector(63 downto 0);
    uPort0_s_axi_tx_tdata1      : in  std_logic_vector(63 downto 0);
    uPort0_s_axi_tx_tdata2      : in  std_logic_vector(63 downto 0);
    uPort0_s_axi_tx_tdata3      : in  std_logic_vector(63 downto 0);
    uPort0_s_axi_tx_tkeep       : in  std_logic_vector(31 downto 0);
    uPort0_s_axi_tx_tlast       : in  std_logic;
    uPort0_s_axi_tx_tvalid      : in  std_logic;
    uPort0_s_axi_tx_tready      : out std_logic;

    -- The following signals are REQUIRED to be in the Port1_UserClk domain:
    uPort1_s_axi_tx_tdata0      : in  std_logic_vector(63 downto 0);
    uPort1_s_axi_tx_tdata1      : in  std_logic_vector(63 downto 0);
    uPort1_s_axi_tx_tdata2      : in  std_logic_vector(63 downto 0);
    uPort1_s_axi_tx_tdata3      : in  std_logic_vector(63 downto 0);
    uPort1_s_axi_tx_tkeep       : in  std_logic_vector(31 downto 0);
    uPort1_s_axi_tx_tlast       : in  std_logic;
    uPort1_s_axi_tx_tvalid      : in  std_logic;
    uPort1_s_axi_tx_tready      : out std_logic;

    -- AXI Streaming RX Interface
    -- The following signals are REQUIRED to be in the Port0_UserClk domain:
    uPort0_m_axi_rx_tdata0      : out std_logic_vector(63 downto 0);
    uPort0_m_axi_rx_tdata1      : out std_logic_vector(63 downto 0);
    uPort0_m_axi_rx_tdata2      : out std_logic_vector(63 downto 0);
    uPort0_m_axi_rx_tdata3      : out std_logic_vector(63 downto 0);
    uPort0_m_axi_rx_tkeep       : out std_logic_vector(31 downto 0);
    uPort0_m_axi_rx_tlast       : out std_logic;
    uPort0_m_axi_rx_tvalid      : out std_logic;

    -- The following signals are REQUIRED to be in the Port1_UserClk domain:
    uPort1_m_axi_rx_tdata0      : out std_logic_vector(63 downto 0);
    uPort1_m_axi_rx_tdata1      : out std_logic_vector(63 downto 0);
    uPort1_m_axi_rx_tdata2      : out std_logic_vector(63 downto 0);
    uPort1_m_axi_rx_tdata3      : out std_logic_vector(63 downto 0);
    uPort1_m_axi_rx_tkeep       : out std_logic_vector(31 downto 0);
    uPort1_m_axi_rx_tlast       : out std_logic;
    uPort1_m_axi_rx_tvalid      : out std_logic;

    -- Link Errors
    -- The following signals are REQUIRED to be in the Port0_UserClk domain:
    uPort0_HardError            : out std_logic;
    uPort0_SoftError            : out std_logic;
    uPort0_LaneUp               : out std_logic_vector(3 downto 0);
    uPort0_ChannelUp            : out std_logic;
    uPort0_sys_reset_out        : out std_logic;
    cPort0_mmcm_not_lock_out    : out std_logic;

    -- The following signals are REQUIRED to be in the Port1_UserClk domain:
    uPort1_HardError            : out std_logic;
    uPort1_SoftError            : out std_logic;
    uPort1_LaneUp               : out std_logic_vector(3 downto 0);
    uPort1_ChannelUp            : out std_logic;
    uPort1_sys_reset_out        : out std_logic;
    cPort1_mmcm_not_lock_out    : out std_logic;

    -- The following signals are REQUIRED to be in the init_clk domain:
    cPort0_link_reset_out       : out std_logic;  -- Driven High if hot-plug count expires
    cPort1_link_reset_out       : out std_logic;  -- Driven High if hot-plug count expires

    -------------------------------------------------------------------------------
    -- AXI4-Lite interfaces - Aurora Port 0
    -------------------------------------------------------------------------------
    s_aclk : in  std_logic;
    -- AXI4-Lite Interface for MGT registers
    gtwiz0_ctrl_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    gtwiz0_ctrl_s_axi_awvalid : in  std_logic;
    gtwiz0_ctrl_s_axi_awready : out std_logic;
    gtwiz0_ctrl_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    gtwiz0_ctrl_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    gtwiz0_ctrl_s_axi_wvalid  : in  std_logic;
    gtwiz0_ctrl_s_axi_wready  : out std_logic;
    gtwiz0_ctrl_s_axi_bresp   : out std_logic_vector(1 downto 0);
    gtwiz0_ctrl_s_axi_bvalid  : out std_logic;
    gtwiz0_ctrl_s_axi_bready  : in  std_logic;
    gtwiz0_ctrl_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    gtwiz0_ctrl_s_axi_arvalid : in  std_logic;
    gtwiz0_ctrl_s_axi_arready : out std_logic;
    gtwiz0_ctrl_s_axi_rdata   : out std_logic_vector(31 downto 0);
    gtwiz0_ctrl_s_axi_rresp   : out std_logic_vector(1 downto 0);
    gtwiz0_ctrl_s_axi_rvalid  : out std_logic;
    gtwiz0_ctrl_s_axi_rready  : in  std_logic;

    -- AXI4-Lite Interface for Channel DRP
    gtwiz0_drp_ch_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    gtwiz0_drp_ch_s_axi_awvalid : in  std_logic;
    gtwiz0_drp_ch_s_axi_awready : out std_logic;
    gtwiz0_drp_ch_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    gtwiz0_drp_ch_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    gtwiz0_drp_ch_s_axi_wvalid  : in  std_logic;
    gtwiz0_drp_ch_s_axi_wready  : out std_logic;
    gtwiz0_drp_ch_s_axi_bresp   : out std_logic_vector(1 downto 0);
    gtwiz0_drp_ch_s_axi_bvalid  : out std_logic;
    gtwiz0_drp_ch_s_axi_bready  : in  std_logic;
    gtwiz0_drp_ch_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    gtwiz0_drp_ch_s_axi_arvalid : in  std_logic;
    gtwiz0_drp_ch_s_axi_arready : out std_logic;
    gtwiz0_drp_ch_s_axi_rdata   : out std_logic_vector(31 downto 0);
    gtwiz0_drp_ch_s_axi_rresp   : out std_logic_vector(1 downto 0);
    gtwiz0_drp_ch_s_axi_rvalid  : out std_logic;
    gtwiz0_drp_ch_s_axi_rready  : in  std_logic;

    -------------------------------------------------------------------------------
    -- AXI4-Lite interfaces - Aurora Port 1
    -------------------------------------------------------------------------------
    -- AXI4-Lite Interface for MGT registers
    gtwiz1_ctrl_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    gtwiz1_ctrl_s_axi_awvalid : in  std_logic;
    gtwiz1_ctrl_s_axi_awready : out std_logic;
    gtwiz1_ctrl_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    gtwiz1_ctrl_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    gtwiz1_ctrl_s_axi_wvalid  : in  std_logic;
    gtwiz1_ctrl_s_axi_wready  : out std_logic;
    gtwiz1_ctrl_s_axi_bresp   : out std_logic_vector(1 downto 0);
    gtwiz1_ctrl_s_axi_bvalid  : out std_logic;
    gtwiz1_ctrl_s_axi_bready  : in  std_logic;
    gtwiz1_ctrl_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    gtwiz1_ctrl_s_axi_arvalid : in  std_logic;
    gtwiz1_ctrl_s_axi_arready : out std_logic;
    gtwiz1_ctrl_s_axi_rdata   : out std_logic_vector(31 downto 0);
    gtwiz1_ctrl_s_axi_rresp   : out std_logic_vector(1 downto 0);
    gtwiz1_ctrl_s_axi_rvalid  : out std_logic;
    gtwiz1_ctrl_s_axi_rready  : in  std_logic;

    -- AXI4-Lite Interface for Channel DRP
    gtwiz1_drp_ch_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    gtwiz1_drp_ch_s_axi_awvalid : in  std_logic;
    gtwiz1_drp_ch_s_axi_awready : out std_logic;
    gtwiz1_drp_ch_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    gtwiz1_drp_ch_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    gtwiz1_drp_ch_s_axi_wvalid  : in  std_logic;
    gtwiz1_drp_ch_s_axi_wready  : out std_logic;
    gtwiz1_drp_ch_s_axi_bresp   : out std_logic_vector(1 downto 0);
    gtwiz1_drp_ch_s_axi_bvalid  : out std_logic;
    gtwiz1_drp_ch_s_axi_bready  : in  std_logic;
    gtwiz1_drp_ch_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    gtwiz1_drp_ch_s_axi_arvalid : in  std_logic;
    gtwiz1_drp_ch_s_axi_arready : out std_logic;
    gtwiz1_drp_ch_s_axi_rdata   : out std_logic_vector(31 downto 0);
    gtwiz1_drp_ch_s_axi_rresp   : out std_logic_vector(1 downto 0);
    gtwiz1_drp_ch_s_axi_rvalid  : out std_logic;
    gtwiz1_drp_ch_s_axi_rready  : in  std_logic
  );
end UserRTL_PXIe6593_Aurora64b66b_Framing;

architecture rtl of UserRTL_PXIe6593_Aurora64b66b_Framing is

  --vhook_sigstart
  --vhook_sigend

  constant kNumLanes : integer := 4;  -- lanes per port
  constant kAddrSize : integer := 9;  -- DRP address width
  constant kNumPorts : integer := 2;  -- number of ports

  --vhook_d AXI4Lite_GTHE3_Control_Regs4
  component AXI4Lite_GTHE3_Control_Regs4
    port (
      LiteClk                     : in  std_logic;
      aReset_n                    : in  std_logic;
      lAxiMasterWritePort         : in  Axi4LiteWritePortIn_t;
      lAxiSlaveWritePort          : out Axi4LiteWritePortOut_t;
      lAxiMasterReadPort          : in  Axi4LiteReadPortIn_t;
      lAxiSlaveReadPort           : out Axi4LiteReadPortOut_t;
      RxUsrClk2                   : in  std_logic_vector(4-1 downto 0);
      TxUsrClk2                   : in  std_logic_vector(4-1 downto 0);
      aGtWiz_ResetAll_in          : out std_logic;
      aGtWiz_RxCdr_stable_out     : in  std_logic;
      aGtWiz_ResetTx_pll_data_in  : out std_logic;
      aGtWiz_ResetTx_data_in      : out std_logic;
      aGtWiz_ResetTx_Done_out     : in  std_logic;
      aGtWiz_UserClkTx_active_out : in  std_logic_vector(3 downto 0);
      aGtWiz_ResetRx_pll_data_in  : out std_logic;
      aGtWiz_ResetRx_data_in      : out std_logic;
      aGtWiz_ResetRx_Done_out     : in  std_logic;
      aGtWiz_UserClkRx_active_out : in  std_logic_vector(3 downto 0);
      rRxResetDone_out            : in  std_logic_vector(4-1 downto 0);
      aRxPmaReset_in              : out std_logic_vector(4-1 downto 0);
      tTxResetDone_out            : in  std_logic_vector(4-1 downto 0);
      aTxPmaReset_in              : out std_logic_vector(4-1 downto 0);
      aEyeScanReset_in            : out std_logic_vector(4-1 downto 0);
      aGtPowerGood_out            : in  std_logic_vector(4-1 downto 0);
      aCpllPD_in                  : out std_logic_vector(4-1 downto 0);
      aCpllReset_in               : out std_logic_vector(4-1 downto 0);
      aCpllRefClkSel_in           : out GTRefClkSelAry_t(4-1 downto 0);
      aCpllLock_out               : in  std_logic_vector(4-1 downto 0);
      aCpllRefClkLost_out         : in  std_logic_vector(4-1 downto 0);
      aQpll0PD_in                 : out std_logic;
      aQpll0Reset_in              : out std_logic;
      aQpll0RefClkSel_in          : out GTRefClkSel_t;
      aQpll0Lock_out              : in  std_logic;
      aQpll0RefClkLost_out        : in  std_logic;
      aQpll1PD_in                 : out std_logic;
      aQpll1Reset_in              : out std_logic;
      aQpll1RefClkSel_in          : out GTRefClkSel_t;
      aQpll1Lock_out              : in  std_logic;
      aQpll1RefClkLost_out        : in  std_logic;
      aTxSysClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aRxSysClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aTxPllClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aRxPllClkSel_in             : out GTClkSelAry_t(4-1 downto 0);
      aTxOutClkSel_in             : out GTOutClkSelAry_t(4-1 downto 0);
      aRxOutClkSel_in             : out GTOutClkSelAry_t(4-1 downto 0);
      aRxCdrHold_in               : out std_logic_vector(4-1 downto 0);
      aRxCdrOvrdEn_in             : out std_logic_vector(4-1 downto 0);
      aRxCdrReset_in              : out std_logic_vector(4-1 downto 0);
      aRxCdrLock_out              : in  std_logic_vector(4-1 downto 0);
      tTxPiPpmEn_in               : out std_logic_vector(4-1 downto 0);
      tTxPiPpmOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      aTxPiPpmPD_in               : out std_logic_vector(4-1 downto 0);
      tTxPiPpmSel_in              : out std_logic_vector(4-1 downto 0);
      tTxPiPpmStepSize_in         : out GTTxPiPpmStepSizeAry_t(4-1 downto 0);
      rRxDfeOSHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeOSOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeAgcHold_in            : out std_logic_vector(4-1 downto 0);
      rRxDfeAgcOvrdEn_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeLFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeLFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeUTHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeUTOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeVPHold_in             : out std_logic_vector(4-1 downto 0);
      rRxDfeVPOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap2Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap2OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap3Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap3OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap4Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap4OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap5Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap5OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap6Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap6OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap7Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap7OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap8Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap8OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap9Hold_in           : out std_logic_vector(4-1 downto 0);
      rRxDfeTap9OvrdEn_in         : out std_logic_vector(4-1 downto 0);
      rRxDfeTap10Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap10OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap11Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap11OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap12Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap12OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap13Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap13OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap14Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap14OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxDfeTap15Hold_in          : out std_logic_vector(4-1 downto 0);
      rRxDfeTap15OvrdEn_in        : out std_logic_vector(4-1 downto 0);
      rRxLpmEn_in                 : out std_logic_vector(4-1 downto 0);
      rRxLpmOSHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmOSOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmGCHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmGCOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmHFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmHFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      rRxLpmLFHold_in             : out std_logic_vector(4-1 downto 0);
      rRxLpmLFOvrdEn_in           : out std_logic_vector(4-1 downto 0);
      DmonClk                     : in  std_logic_vector(4-1 downto 0);
      dDMonitorOut_out            : in  GTHDMonitorOutAry_t(4-1 downto 0);
      rRxRate_in                  : out GTRateSelAry_t(4-1 downto 0);
      rRxRateDone_out             : in  std_logic_vector(4-1 downto 0);
      tTxRate_in                  : out GTRateSelAry_t(4-1 downto 0);
      tTxRateDone_out             : in  std_logic_vector(4-1 downto 0);
      tTxDiffCtrl_in              : out GTHDiffCtrlAry_t(4-1 downto 0);
      aTxPreCursor_in             : out GTHCursorSelAry_t(4-1 downto 0);
      aTxPostCursor_in            : out GTHCursorSelAry_t(4-1 downto 0);
      rRxPrbsSel_in               : out GTPrbsSelAry_t(4-1 downto 0);
      rRxPrbsErr_out              : in  std_logic_vector(4-1 downto 0);
      rRxPrbsLocked_out           : in  std_logic_vector(4-1 downto 0);
      rRxPrbsCntReset_in          : out std_logic_vector(4-1 downto 0);
      rRxPolarity_in              : out std_logic_vector(4-1 downto 0);
      tTxPrbsSel_in               : out GTPrbsSelAry_t(4-1 downto 0);
      tTxPrbsForceErr_in          : out std_logic_vector(4-1 downto 0);
      tTxPolarity_in              : out std_logic_vector(4-1 downto 0);
      tTxDetectRx_in              : out std_logic_vector(4-1 downto 0);
      rPhyStatus_out              : in  std_logic_vector(4-1 downto 0);
      rRxStatus_out               : in  GTRxStatusAry_t(4-1 downto 0);
      tTxPd_in                    : out GTPdAry_t(4-1 downto 0);
      rRxPd_in                    : out GTPdAry_t(4-1 downto 0);
      aLoopback_in                : out GTLoopbackSelAry_t(4-1 downto 0));
  end component;

  --vhook_d aurora_64b66b_DF
  component aurora_64b66b_DF
    port (
      s_axi_tx_tdata              : in  STD_LOGIC_VECTOR(255 downto 0);
      s_axi_tx_tlast              : in  STD_LOGIC;
      s_axi_tx_tkeep              : in  STD_LOGIC_VECTOR(31 downto 0);
      s_axi_tx_tvalid             : in  STD_LOGIC;
      s_axi_tx_tready             : out STD_LOGIC;
      m_axi_rx_tdata              : out STD_LOGIC_VECTOR(255 downto 0);
      m_axi_rx_tlast              : out STD_LOGIC;
      m_axi_rx_tkeep              : out STD_LOGIC_VECTOR(31 downto 0);
      m_axi_rx_tvalid             : out STD_LOGIC;
      rxp                         : in  STD_LOGIC_VECTOR(0 to 3);
      rxn                         : in  STD_LOGIC_VECTOR(0 to 3);
      txp                         : out STD_LOGIC_VECTOR(0 to 3);
      txn                         : out STD_LOGIC_VECTOR(0 to 3);
      refclk1_in                  : in  STD_LOGIC;
      hard_err                    : out STD_LOGIC;
      soft_err                    : out STD_LOGIC;
      channel_up                  : out STD_LOGIC;
      lane_up                     : out STD_LOGIC_VECTOR(0 to 3);
      user_clk_out                : out STD_LOGIC;
      mmcm_not_locked_out         : out STD_LOGIC;
      sync_clk_out                : out STD_LOGIC;
      reset_pb                    : in  STD_LOGIC;
      gt_rxcdrovrden_in           : in  STD_LOGIC;
      power_down                  : in  STD_LOGIC;
      loopback                    : in  STD_LOGIC_VECTOR(2 downto 0);
      pma_init                    : in  STD_LOGIC;
      gt_pll_lock                 : out STD_LOGIC;
      gt0_drpaddr                 : in  STD_LOGIC_VECTOR(8 downto 0);
      gt0_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt0_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt0_drprdy                  : out STD_LOGIC;
      gt0_drpen                   : in  STD_LOGIC;
      gt0_drpwe                   : in  STD_LOGIC;
      gt1_drpaddr                 : in  STD_LOGIC_VECTOR(8 downto 0);
      gt1_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt1_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt1_drprdy                  : out STD_LOGIC;
      gt1_drpen                   : in  STD_LOGIC;
      gt1_drpwe                   : in  STD_LOGIC;
      gt2_drpaddr                 : in  STD_LOGIC_VECTOR(8 downto 0);
      gt2_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt2_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt2_drprdy                  : out STD_LOGIC;
      gt2_drpen                   : in  STD_LOGIC;
      gt2_drpwe                   : in  STD_LOGIC;
      gt3_drpaddr                 : in  STD_LOGIC_VECTOR(8 downto 0);
      gt3_drpdi                   : in  STD_LOGIC_VECTOR(15 downto 0);
      gt3_drpdo                   : out STD_LOGIC_VECTOR(15 downto 0);
      gt3_drprdy                  : out STD_LOGIC;
      gt3_drpen                   : in  STD_LOGIC;
      gt3_drpwe                   : in  STD_LOGIC;
      init_clk                    : in  STD_LOGIC;
      link_reset_out              : out STD_LOGIC;
      gt_rxusrclk_out             : out STD_LOGIC;
      gt_eyescandataerror         : out STD_LOGIC_VECTOR(3 downto 0);
      gt_eyescanreset             : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_eyescantrigger           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxcdrhold                : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxdfelpmreset            : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxlpmen                  : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpmareset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpcsreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxrate                   : in  STD_LOGIC_VECTOR(11 downto 0);
      gt_rxbufreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpmaresetdone           : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbssel                : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_rxprbserr                : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbscntreset           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxresetdone              : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxbufstatus              : out STD_LOGIC_VECTOR(11 downto 0);
      gt_txpostcursor             : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txdiffctrl               : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_txprecursor              : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txpolarity               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txinhibit                : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpmareset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpcsreset               : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txprbssel                : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_txprbsforceerr           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txbufstatus              : out STD_LOGIC_VECTOR(7 downto 0);
      gt_txresetdone              : out STD_LOGIC_VECTOR(3 downto 0);
      gt_pcsrsvdin                : in  STD_LOGIC_VECTOR(63 downto 0);
      gt_dmonitorout              : out STD_LOGIC_VECTOR(67 downto 0);
      gt_cplllock                 : out STD_LOGIC_VECTOR(3 downto 0);
      gt_qplllock                 : out STD_LOGIC;
      gt_powergood                : out STD_LOGIC_VECTOR(3 downto 0);
      gt_qpllclk_quad1_out        : out STD_LOGIC;
      gt_qpllrefclk_quad1_out     : out STD_LOGIC;
      gt_qplllock_quad1_out       : out STD_LOGIC;
      gt_qpllrefclklost_quad1_out : out STD_LOGIC;
      sys_reset_out               : out STD_LOGIC;
      gt_reset_out                : out STD_LOGIC;
      tx_out_clk                  : out STD_LOGIC);
  end component;

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
  -- CLIP signals                                            --
  -------------------------------------------------------------
  signal FAM_refclk  : std_logic_vector(2 downto 0);
  signal xMgtRefClkEnabled : std_logic_vector(3 downto 0);
  signal aReset_n : std_logic;

  -------------------------------------------------------------
  -- Vectorized signals to connect to GT Wizard Verilog core --
  -------------------------------------------------------------
  signal gtwiz_drpaddr_in : std_logic_vector(kNumPorts*kNumLanes*kAddrSize-1 downto 0);
  signal gtwiz_drpdi_in   : std_logic_vector(kNumPorts*kNumLanes*16-1 downto 0);
  signal gtwiz_drpdo_out  : std_logic_vector(kNumPorts*kNumLanes*16-1 downto 0);
  signal gtwiz_drprdy_out : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal gtwiz_drpen_in   : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal gtwiz_drpwe_in   : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal gtwiz_dDMonitorOut_out : std_logic_vector(kNumPorts*kNumLanes*17-1 downto 0);
  signal gtwiz_rRxRate_in       : std_logic_vector(kNumPorts*kNumLanes*3-1  downto 0);

  signal gtwiz_tTxDiffCtrl_in   : std_logic_vector(kNumPorts*kNumLanes*4-1  downto 0);
  signal gtwiz_aTxPreCursor_in  : std_logic_vector(kNumPorts*kNumLanes*5-1  downto 0);
  signal gtwiz_aTxPostCursor_in : std_logic_vector(kNumPorts*kNumLanes*5-1  downto 0);
  signal gtwiz_rRxPrbsSel_in    : std_logic_vector(kNumPorts*kNumLanes*4-1  downto 0);
  signal gtwiz_tTxPrbsSel_in    : std_logic_vector(kNumPorts*kNumLanes*4-1  downto 0);

  -------------------------------------------------------------
  -- Signals to connect to AXI4-Lite Register Set            --
  -------------------------------------------------------------
  type Axi4LiteReadPortInAry_t   is array(natural range <>) of Axi4LiteReadPortIn_t;
  type Axi4LiteWritePortInAry_t  is array(natural range <>) of Axi4LiteWritePortIn_t;
  type Axi4LiteReadPortOutAry_t  is array(natural range <>) of Axi4LiteReadPortOut_t;
  type Axi4LiteWritePortOutAry_t is array(natural range <>) of Axi4LiteWritePortOut_t;
  signal lAxiMasterReadPort  : Axi4LiteReadPortInAry_t  (kNumPorts-1 downto 0);
  signal lAxiMasterWritePort : Axi4LiteWritePortInAry_t (kNumPorts-1 downto 0);
  signal lAxiSlaveReadPort   : Axi4LiteReadPortOutAry_t (kNumPorts-1 downto 0);
  signal lAxiSlaveWritePort  : Axi4LiteWritePortOutAry_t(kNumPorts-1 downto 0);

  signal RxUsrClk2, TxUsrClk2 : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal rRxResetDone_out    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aRxPmaReset_in      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxResetDone_out    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aTxPmaReset_in      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aEyeScanReset_in    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aGtPowerGood_out    : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aCpllLock_out       : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aQpll0Lock_out        : std_logic_vector(kNumPorts-1 downto 0);
  signal aQpll0RefClkLost_out  : std_logic_vector(kNumPorts-1 downto 0);

  signal aRxCdrHold_in   : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal aRxCdrOvrdEn_in : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal rRxLpmEn_in        : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal gtwiz_slv_dmonclk  : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal sDMonitorOut_out   : GTHDMonitorOutAry_t(kNumPorts*kNumLanes-1 downto 0);

  signal rRxRate_in      : GTRateSelAry_t  (kNumPorts*kNumLanes-1 downto 0);

  signal tTxDiffCtrl_in   : GTHDiffCtrlAry_t (kNumPorts*kNumLanes-1 downto 0);
  signal aTxPreCursor_in  : GTHCursorSelAry_t(kNumPorts*kNumLanes-1 downto 0);
  signal aTxPostCursor_in : GTHCursorSelAry_t(kNumPorts*kNumLanes-1 downto 0);

  signal rRxPrbsSel_in       : GTPrbsSelAry_t  (kNumPorts*kNumLanes-1 downto 0);
  signal rRxPrbsErr_out      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal rRxPrbsCntReset_in  : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxPrbsSel_in       : GTPrbsSelAry_t  (kNumPorts*kNumLanes-1 downto 0);
  signal tTxPrbsForceErr_in  : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);
  signal tTxPolarity_in      : std_logic_vector(kNumPorts*kNumLanes-1 downto 0);

  signal aLoopback_in   : GTLoopbackSelAry_t(kNumPorts*kNumLanes-1 downto 0);

  -------------------------------------------------------------
  -- Vectorized signals to connect to Aurora core            --
  -------------------------------------------------------------
  signal PortRx_p : std_logic_vector(0 to 7);
  signal PortRx_n : std_logic_vector(0 to 7);
  signal PortTx_p : std_logic_vector(0 to 7);
  signal PortTx_n : std_logic_vector(0 to 7);

  -- SLVs for the single lane port signals on the cores.
  signal Port_hard_err, Port_soft_err, Port_channel_up : std_logic_vector(kNumPorts-1 downto 0);

  subtype AuroraLaneUp_t is std_logic_vector(kNumLanes-1 downto 0);
  type AuroraLaneUpAry_t is array(natural range <>) of AuroraLaneUp_t;
  signal Port_lane_up, Port_lane_up_rev : AuroraLaneUpAry_t(kNumPorts-1 downto 0);

  subtype AxiData64_t is std_logic_vector(63 downto 0);
  type AxiData64Ary_t is array(natural range <>) of AxiData64_t;
  signal uPort_s_axi_tx_tdata0, uPort_s_axi_tx_tdata1, uPort_s_axi_tx_tdata2, uPort_s_axi_tx_tdata3 : AxiData64Ary_t(kNumPorts-1 downto 0);
  signal uPort_m_axi_rx_tdata0, uPort_m_axi_rx_tdata1, uPort_m_axi_rx_tdata2, uPort_m_axi_rx_tdata3 : AxiData64Ary_t(kNumPorts-1 downto 0);

  subtype AxiData256_t is std_logic_vector(255 downto 0);
  type AxiData256Ary_t is array(natural range <>) of AxiData256_t;
  signal uPort_s_axi_tx_tdata : AxiData256Ary_t(kNumPorts-1 downto 0);
  signal uPort_m_axi_rx_tdata : AxiData256Ary_t(kNumPorts-1 downto 0);

  subtype AxiKeep_t is std_logic_vector(31 downto 0);
  type AxiKeepAry_t is array(natural range <>) of AxiKeep_t;
  signal uPort_s_axi_tx_tkeep, uPort_m_axi_rx_tkeep : AxiKeepAry_t(kNumPorts-1 downto 0);

  signal uPort_s_axi_tx_tlast, uPort_s_axi_tx_tvalid, uPort_s_axi_tx_tready : std_logic_vector(kNumPorts-1 downto 0);
  signal uPort_m_axi_rx_tlast, uPort_m_axi_rx_tvalid : std_logic_vector(kNumPorts-1 downto 0);

  signal Port_user_clk, Port_rxusrclk2, Port_sync_clk, Port_reset_pb : std_logic_vector(kNumPorts-1 downto 0);
  signal Port_mmcm_not_locked, Port_sys_reset_out, Port_link_reset_out, cPort_PMA_Init : std_logic_vector(kNumPorts-1 downto 0);

  -- Double sync signals for mmcm_not_locked. These are driven from the user_clk, but
  -- since this is a status about user_clk, we should read it back in the init_clk domain.
  signal cPort0_mmcm_not_lock_out_ms, cPort1_mmcm_not_lock_out_ms : std_logic;

  -------------------------------------------------------------
  -- Utility Functions                                       --
  -------------------------------------------------------------
  function to_StdLogic(b : boolean) return std_logic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end to_StdLogic;

  function reversi (arg : std_logic_vector) return std_logic_vector is
    variable RetVal : std_logic_vector(arg'reverse_range) := (others => '0');
  begin  -- reversi
    for index in arg'range loop
      RetVal(index) := arg(index);
    end loop;  -- index
    return RetVal;
  end reversi;

begin

  -----------------------------
  -- 6593 Required Logic     --
  -----------------------------
  -- !!! WARNING !!!
  -- Do not change this logic. Doing so may cause the CLIP to stop functioning.

  -- Configuration Netlist --
  --vhook Ni6593FixedLogic
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
      xIoModuleReady                  => xIoModuleReady,                   --out std_logic
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

  -- Drive active low reset.
  aReset_n <= not aResetSl;

  -----------------------------------------------------------------------------
  -- MGT Reference Clocks
  -----------------------------------------------------------------------------
  -- Instantiate IBUFDS_GTE4 buffers on the reference clock pins.
  -- Depending on the application, the IP may already instantiate a buffer, so
  -- these buffers may be removed in this case.

  IbufdsGen: for i in MgtRefClk_p'range generate

    --vhook_i IBUFDS_GTE3 IBUFDS_GTE3_inst0 hidegeneric=true
    --vhook_a I      MgtRefClk_p(i)
    --vhook_a IB     MgtRefClk_n(i)
    --vhook_a CEB    '0'
    --vhook_a O      FAM_refclk(i)
    --vhook_a ODIV2  open
    IBUFDS_GTE3_inst0: IBUFDS_GTE3
      port map (
        O     => FAM_refclk(i),   --out std_ulogic
        ODIV2 => open,            --out std_ulogic
        CEB   => '0',             --in  std_ulogic
        I     => MgtRefClk_p(i),  --in  std_ulogic
        IB    => MgtRefClk_n(i)); --in  std_ulogic

  end generate;

  -- ExportedMgtRefClk exports a reference clock from here to the DIO MGT CLIP
  ExportedMgtRefClk <= FAM_refclk(2);

  -----------------------------------------------------------------------------
  -- Processes
  -----------------------------------------------------------------------------
  process(aResetSl, Port_user_clk(0))
  begin
    if aResetSl = '1' then
      uPort0_HardError     <= '0';
      uPort0_SoftError     <= '0';
      uPort0_LaneUp        <= (others => '0');
      uPort0_ChannelUp     <= '0';
      uPort0_sys_reset_out <= '1';
    elsif rising_edge(Port_user_clk(0)) then
      uPort0_HardError     <= Port_hard_err     (0);
      uPort0_SoftError     <= Port_soft_err     (0);
      uPort0_LaneUp        <= Port_lane_up      (0);
      uPort0_ChannelUp     <= Port_channel_up   (0);
      uPort0_sys_reset_out <= Port_sys_reset_out(0);
    end if;
  end process;

  process(aResetSl, Port_user_clk(1))
  begin
    if aResetSl = '1' then
      uPort1_HardError     <= '0';
      uPort1_SoftError     <= '0';
      uPort1_LaneUp        <= (others => '0');
      uPort1_ChannelUp     <= '0';
      uPort1_sys_reset_out <= '1';
    elsif rising_edge(Port_user_clk(1)) then
      uPort1_HardError     <= Port_hard_err     (1);
      uPort1_SoftError     <= Port_soft_err     (1);
      uPort1_LaneUp        <= Port_lane_up      (1);
      uPort1_ChannelUp     <= Port_channel_up   (1);
      uPort1_sys_reset_out <= Port_sys_reset_out(1);
    end if;
  end process;

  process(aResetSl, InitClk)
  begin
    if aResetSl = '1' then
      cPort0_link_reset_out       <= '1';
      cPort1_link_reset_out       <= '1';
      cPort0_mmcm_not_lock_out_ms <= '1';
      cPort0_mmcm_not_lock_out    <= '1';
      cPort1_mmcm_not_lock_out_ms <= '1';
      cPort1_mmcm_not_lock_out    <= '1';
    elsif rising_edge(InitClk) then
      cPort0_link_reset_out       <= Port_link_reset_out (0);
      cPort1_link_reset_out       <= Port_link_reset_out (1);
      cPort0_mmcm_not_lock_out_ms <= Port_mmcm_not_locked(0);
      cPort0_mmcm_not_lock_out    <= cPort0_mmcm_not_lock_out_ms;
      cPort1_mmcm_not_lock_out_ms <= Port_mmcm_not_locked(1);
      cPort1_mmcm_not_lock_out    <= cPort1_mmcm_not_lock_out_ms;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Aurora Port 0 Channel AXI4-Lite and DRP Handlers
  ---------------------------------------------------------------------------
  --vhook_e MgtTest_DRP_bridge Aurora_port0_DRP
  --vhook_g kNUM_LANES  kNumLanes
  --vhook_g kADDR_SIZE  kAddrSize
  --vhook_a gtwiz_drpclk      open
  --vhook_a gtwiz_drpaddr_in  gtwiz_drpaddr_in(1*kNumLanes*kAddrSize-1 downto 0*kNumLanes*kAddrSize)
  --vhook_a gtwiz_drpdi_in    gtwiz_drpdi_in  (1*kNumLanes*16-1 downto 0*kNumLanes*16)
  --vhook_a gtwiz_drpdo_out   gtwiz_drpdo_out (1*kNumLanes*16-1 downto 0*kNumLanes*16)
  --vhook_a gtwiz_drpen_in    gtwiz_drpen_in  (1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a gtwiz_drpwe_in    gtwiz_drpwe_in  (1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a gtwiz_drprdy_out  gtwiz_drprdy_out(1*kNumLanes-1    downto 0*kNumLanes)
  --vhook_a drp_s_axi_awaddr   gtwiz0_drp_ch_s_axi_awaddr
  --vhook_a drp_s_axi_awvalid  gtwiz0_drp_ch_s_axi_awvalid
  --vhook_a drp_s_axi_awready  gtwiz0_drp_ch_s_axi_awready
  --vhook_a drp_s_axi_wdata    gtwiz0_drp_ch_s_axi_wdata
  --vhook_a drp_s_axi_wstrb    gtwiz0_drp_ch_s_axi_wstrb
  --vhook_a drp_s_axi_wvalid   gtwiz0_drp_ch_s_axi_wvalid
  --vhook_a drp_s_axi_wready   gtwiz0_drp_ch_s_axi_wready
  --vhook_a drp_s_axi_bresp    gtwiz0_drp_ch_s_axi_bresp
  --vhook_a drp_s_axi_bvalid   gtwiz0_drp_ch_s_axi_bvalid
  --vhook_a drp_s_axi_bready   gtwiz0_drp_ch_s_axi_bready
  --vhook_a drp_s_axi_araddr   gtwiz0_drp_ch_s_axi_araddr
  --vhook_a drp_s_axi_arvalid  gtwiz0_drp_ch_s_axi_arvalid
  --vhook_a drp_s_axi_arready  gtwiz0_drp_ch_s_axi_arready
  --vhook_a drp_s_axi_rdata    gtwiz0_drp_ch_s_axi_rdata
  --vhook_a drp_s_axi_rresp    gtwiz0_drp_ch_s_axi_rresp
  --vhook_a drp_s_axi_rvalid   gtwiz0_drp_ch_s_axi_rvalid
  --vhook_a drp_s_axi_rready   gtwiz0_drp_ch_s_axi_rready
  Aurora_port0_DRP: entity work.MgtTest_DRP_bridge (rtl)
    generic map (
      kNUM_LANES => kNumLanes,  --integer:=4
      kADDR_SIZE => kAddrSize)  --integer:=9
    port map (
      aResetSl          => aResetSl,                                                                --in  std_logic
      gtwiz_drpclk      => open,                                                                    --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpaddr_in  => gtwiz_drpaddr_in(1*kNumLanes*kAddrSize-1 downto 0*kNumLanes*kAddrSize),  --out std_logic_vector(kNUM_LANES*kADDR_SIZE-1:0)
      gtwiz_drpdi_in    => gtwiz_drpdi_in (1*kNumLanes*16-1 downto 0*kNumLanes*16),                 --out std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpdo_out   => gtwiz_drpdo_out (1*kNumLanes*16-1 downto 0*kNumLanes*16),                --in  std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpen_in    => gtwiz_drpen_in (1*kNumLanes-1 downto 0*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpwe_in    => gtwiz_drpwe_in (1*kNumLanes-1 downto 0*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drprdy_out  => gtwiz_drprdy_out(1*kNumLanes-1 downto 0*kNumLanes),                      --in  std_logic_vector(kNUM_LANES-1:0)
      s_aclk            => s_aclk,                                                                  --in  std_logic
      drp_s_axi_awaddr  => gtwiz0_drp_ch_s_axi_awaddr,                                              --in  std_logic_vector(31:0)
      drp_s_axi_awvalid => gtwiz0_drp_ch_s_axi_awvalid,                                             --in  std_logic
      drp_s_axi_awready => gtwiz0_drp_ch_s_axi_awready,                                             --out std_logic
      drp_s_axi_wdata   => gtwiz0_drp_ch_s_axi_wdata,                                               --in  std_logic_vector(31:0)
      drp_s_axi_wstrb   => gtwiz0_drp_ch_s_axi_wstrb,                                               --in  std_logic_vector(3:0)
      drp_s_axi_wvalid  => gtwiz0_drp_ch_s_axi_wvalid,                                              --in  std_logic
      drp_s_axi_wready  => gtwiz0_drp_ch_s_axi_wready,                                              --out std_logic
      drp_s_axi_bresp   => gtwiz0_drp_ch_s_axi_bresp,                                               --out std_logic_vector(1:0)
      drp_s_axi_bvalid  => gtwiz0_drp_ch_s_axi_bvalid,                                              --out std_logic
      drp_s_axi_bready  => gtwiz0_drp_ch_s_axi_bready,                                              --in  std_logic
      drp_s_axi_araddr  => gtwiz0_drp_ch_s_axi_araddr,                                              --in  std_logic_vector(31:0)
      drp_s_axi_arvalid => gtwiz0_drp_ch_s_axi_arvalid,                                             --in  std_logic
      drp_s_axi_arready => gtwiz0_drp_ch_s_axi_arready,                                             --out std_logic
      drp_s_axi_rdata   => gtwiz0_drp_ch_s_axi_rdata,                                               --out std_logic_vector(31:0)
      drp_s_axi_rresp   => gtwiz0_drp_ch_s_axi_rresp,                                               --out std_logic_vector(1:0)
      drp_s_axi_rvalid  => gtwiz0_drp_ch_s_axi_rvalid,                                              --out std_logic
      drp_s_axi_rready  => gtwiz0_drp_ch_s_axi_rready);                                             --in  std_logic

  --vhook_e MgtTest_DRP_bridge Aurora_port1_DRP
  --vhook_g kNUM_LANES         kNumLanes
  --vhook_g kADDR_SIZE         kAddrSize
  --vhook_a gtwiz_drpclk       open
  --vhook_a gtwiz_drpaddr_in   gtwiz_drpaddr_in(2*kNumLanes*kAddrSize-1 downto 1*kNumLanes*kAddrSize)
  --vhook_a gtwiz_drpdi_in     gtwiz_drpdi_in  (2*kNumLanes*16-1 downto 1*kNumLanes*16)
  --vhook_a gtwiz_drpdo_out    gtwiz_drpdo_out (2*kNumLanes*16-1 downto 1*kNumLanes*16)
  --vhook_a gtwiz_drpen_in     gtwiz_drpen_in  (2*kNumLanes-1    downto 1*kNumLanes)
  --vhook_a gtwiz_drpwe_in     gtwiz_drpwe_in  (2*kNumLanes-1    downto 1*kNumLanes)
  --vhook_a gtwiz_drprdy_out   gtwiz_drprdy_out(2*kNumLanes-1    downto 1*kNumLanes)
  --vhook_a drp_s_axi_awaddr   gtwiz1_drp_ch_s_axi_awaddr
  --vhook_a drp_s_axi_awvalid  gtwiz1_drp_ch_s_axi_awvalid
  --vhook_a drp_s_axi_awready  gtwiz1_drp_ch_s_axi_awready
  --vhook_a drp_s_axi_wdata    gtwiz1_drp_ch_s_axi_wdata
  --vhook_a drp_s_axi_wstrb    gtwiz1_drp_ch_s_axi_wstrb
  --vhook_a drp_s_axi_wvalid   gtwiz1_drp_ch_s_axi_wvalid
  --vhook_a drp_s_axi_wready   gtwiz1_drp_ch_s_axi_wready
  --vhook_a drp_s_axi_bresp    gtwiz1_drp_ch_s_axi_bresp
  --vhook_a drp_s_axi_bvalid   gtwiz1_drp_ch_s_axi_bvalid
  --vhook_a drp_s_axi_bready   gtwiz1_drp_ch_s_axi_bready
  --vhook_a drp_s_axi_araddr   gtwiz1_drp_ch_s_axi_araddr
  --vhook_a drp_s_axi_arvalid  gtwiz1_drp_ch_s_axi_arvalid
  --vhook_a drp_s_axi_arready  gtwiz1_drp_ch_s_axi_arready
  --vhook_a drp_s_axi_rdata    gtwiz1_drp_ch_s_axi_rdata
  --vhook_a drp_s_axi_rresp    gtwiz1_drp_ch_s_axi_rresp
  --vhook_a drp_s_axi_rvalid   gtwiz1_drp_ch_s_axi_rvalid
  --vhook_a drp_s_axi_rready   gtwiz1_drp_ch_s_axi_rready
  Aurora_port1_DRP: entity work.MgtTest_DRP_bridge (rtl)
    generic map (
      kNUM_LANES => kNumLanes,  --integer:=4
      kADDR_SIZE => kAddrSize)  --integer:=9
    port map (
      aResetSl          => aResetSl,                                                                --in  std_logic
      gtwiz_drpclk      => open,                                                                    --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpaddr_in  => gtwiz_drpaddr_in(2*kNumLanes*kAddrSize-1 downto 1*kNumLanes*kAddrSize),  --out std_logic_vector(kNUM_LANES*kADDR_SIZE-1:0)
      gtwiz_drpdi_in    => gtwiz_drpdi_in (2*kNumLanes*16-1 downto 1*kNumLanes*16),                 --out std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpdo_out   => gtwiz_drpdo_out (2*kNumLanes*16-1 downto 1*kNumLanes*16),                --in  std_logic_vector(kNUM_LANES*16-1:0)
      gtwiz_drpen_in    => gtwiz_drpen_in (2*kNumLanes-1 downto 1*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drpwe_in    => gtwiz_drpwe_in (2*kNumLanes-1 downto 1*kNumLanes),                       --out std_logic_vector(kNUM_LANES-1:0)
      gtwiz_drprdy_out  => gtwiz_drprdy_out(2*kNumLanes-1 downto 1*kNumLanes),                      --in  std_logic_vector(kNUM_LANES-1:0)
      s_aclk            => s_aclk,                                                                  --in  std_logic
      drp_s_axi_awaddr  => gtwiz1_drp_ch_s_axi_awaddr,                                              --in  std_logic_vector(31:0)
      drp_s_axi_awvalid => gtwiz1_drp_ch_s_axi_awvalid,                                             --in  std_logic
      drp_s_axi_awready => gtwiz1_drp_ch_s_axi_awready,                                             --out std_logic
      drp_s_axi_wdata   => gtwiz1_drp_ch_s_axi_wdata,                                               --in  std_logic_vector(31:0)
      drp_s_axi_wstrb   => gtwiz1_drp_ch_s_axi_wstrb,                                               --in  std_logic_vector(3:0)
      drp_s_axi_wvalid  => gtwiz1_drp_ch_s_axi_wvalid,                                              --in  std_logic
      drp_s_axi_wready  => gtwiz1_drp_ch_s_axi_wready,                                              --out std_logic
      drp_s_axi_bresp   => gtwiz1_drp_ch_s_axi_bresp,                                               --out std_logic_vector(1:0)
      drp_s_axi_bvalid  => gtwiz1_drp_ch_s_axi_bvalid,                                              --out std_logic
      drp_s_axi_bready  => gtwiz1_drp_ch_s_axi_bready,                                              --in  std_logic
      drp_s_axi_araddr  => gtwiz1_drp_ch_s_axi_araddr,                                              --in  std_logic_vector(31:0)
      drp_s_axi_arvalid => gtwiz1_drp_ch_s_axi_arvalid,                                             --in  std_logic
      drp_s_axi_arready => gtwiz1_drp_ch_s_axi_arready,                                             --out std_logic
      drp_s_axi_rdata   => gtwiz1_drp_ch_s_axi_rdata,                                               --out std_logic_vector(31:0)
      drp_s_axi_rresp   => gtwiz1_drp_ch_s_axi_rresp,                                               --out std_logic_vector(1:0)
      drp_s_axi_rvalid  => gtwiz1_drp_ch_s_axi_rvalid,                                              --out std_logic
      drp_s_axi_rready  => gtwiz1_drp_ch_s_axi_rready);                                             --in  std_logic

  -----------------------------------------------------------------------------
  -- AXI4-Lite Register Interface
  -----------------------------------------------------------------------------
  -- Fill in AXI Port records with top level signals.
  lAxiMasterWritePort(0).Address   <= unsigned(gtwiz0_ctrl_s_axi_awaddr);
  lAxiMasterWritePort(0).AddrValid <= gtwiz0_ctrl_s_axi_awvalid = '1';
  lAxiMasterWritePort(0).Data      <= gtwiz0_ctrl_s_axi_wdata;
  lAxiMasterWritePort(0).DataStrb  <= gtwiz0_ctrl_s_axi_wstrb;
  lAxiMasterWritePort(0).DataValid <= gtwiz0_ctrl_s_axi_wvalid = '1';
  lAxiMasterWritePort(0).Ready     <= gtwiz0_ctrl_s_axi_bready = '1';

  gtwiz0_ctrl_s_axi_awready <= to_StdLogic(lAxiSlaveWritePort(0).AddrReady);
  gtwiz0_ctrl_s_axi_wready  <= to_StdLogic(lAxiSlaveWritePort(0).DataReady);
  gtwiz0_ctrl_s_axi_bresp   <= lAxiSlaveWritePort(0).Response;
  gtwiz0_ctrl_s_axi_bvalid  <= to_StdLogic(lAxiSlaveWritePort(0).RespValid);

  lAxiMasterReadPort(0).Address   <= unsigned(gtwiz0_ctrl_s_axi_araddr);
  lAxiMasterReadPort(0).AddrValid <= gtwiz0_ctrl_s_axi_arvalid = '1';
  lAxiMasterReadPort(0).Ready     <= gtwiz0_ctrl_s_axi_rready = '1';

  gtwiz0_ctrl_s_axi_arready <= to_StdLogic(lAxiSlaveReadPort(0).AddrReady);
  gtwiz0_ctrl_s_axi_rdata   <= lAxiSlaveReadPort(0).Data;
  gtwiz0_ctrl_s_axi_rresp   <= lAxiSlaveReadPort(0).Response;
  gtwiz0_ctrl_s_axi_rvalid  <= to_StdLogic(lAxiSlaveReadPort(0).DataValid);

  -- Fill in AXI Port records with top level signals.
  lAxiMasterWritePort(1).Address   <= unsigned(gtwiz1_ctrl_s_axi_awaddr);
  lAxiMasterWritePort(1).AddrValid <= gtwiz1_ctrl_s_axi_awvalid = '1';
  lAxiMasterWritePort(1).Data      <= gtwiz1_ctrl_s_axi_wdata;
  lAxiMasterWritePort(1).DataStrb  <= gtwiz1_ctrl_s_axi_wstrb;
  lAxiMasterWritePort(1).DataValid <= gtwiz1_ctrl_s_axi_wvalid = '1';
  lAxiMasterWritePort(1).Ready     <= gtwiz1_ctrl_s_axi_bready = '1';

  gtwiz1_ctrl_s_axi_awready <= to_StdLogic(lAxiSlaveWritePort(1).AddrReady);
  gtwiz1_ctrl_s_axi_wready  <= to_StdLogic(lAxiSlaveWritePort(1).DataReady);
  gtwiz1_ctrl_s_axi_bresp   <= lAxiSlaveWritePort(1).Response;
  gtwiz1_ctrl_s_axi_bvalid  <= to_StdLogic(lAxiSlaveWritePort(1).RespValid);

  lAxiMasterReadPort(1).Address   <= unsigned(gtwiz1_ctrl_s_axi_araddr);
  lAxiMasterReadPort(1).AddrValid <= gtwiz1_ctrl_s_axi_arvalid = '1';
  lAxiMasterReadPort(1).Ready     <= gtwiz1_ctrl_s_axi_rready = '1';

  gtwiz1_ctrl_s_axi_arready <= to_StdLogic(lAxiSlaveReadPort(1).AddrReady);
  gtwiz1_ctrl_s_axi_rdata   <= lAxiSlaveReadPort(1).Data;
  gtwiz1_ctrl_s_axi_rresp   <= lAxiSlaveReadPort(1).Response;
  gtwiz1_ctrl_s_axi_rvalid  <= to_StdLogic(lAxiSlaveReadPort(1).DataValid);

  -- Port
  PortRx_p   (0 to 3)     <= reversi(MgtPortRx_p(7 downto 4));
  PortRx_n   (0 to 3)     <= reversi(MgtPortRx_n(7 downto 4));
  MgtPortTx_p(7 downto 4) <= reversi(PortTx_p   (0 to 3));
  MgtPortTx_n(7 downto 4) <= reversi(PortTx_n   (0 to 3));

  PortRx_p   (4 to 7)     <= reversi(MgtPortRx_p(3 downto 0));
  PortRx_n   (4 to 7)     <= reversi(MgtPortRx_n(3 downto 0));
  MgtPortTx_p(3 downto 0) <= reversi(PortTx_p   (4 to 7));
  MgtPortTx_n(3 downto 0) <= reversi(PortTx_n   (4 to 7));

  cPort_PMA_Init(0) <= cPort0_PMA_Init or aResetSl;
  cPort_PMA_Init(1) <= cPort1_PMA_Init or aResetSl;

  Port0_UserClk <= Port_user_clk(0);
  Port1_UserClk <= Port_user_clk(1);

  Port_reset_pb(0) <= cPort0_reset_pb;
  Port_reset_pb(1) <= cPort1_reset_pb;

  uPort_s_axi_tx_tdata0(0) <= uPort0_s_axi_tx_tdata0;
  uPort_s_axi_tx_tdata0(1) <= uPort1_s_axi_tx_tdata0;
  uPort_s_axi_tx_tdata1(0) <= uPort0_s_axi_tx_tdata1;
  uPort_s_axi_tx_tdata1(1) <= uPort1_s_axi_tx_tdata1;
  uPort_s_axi_tx_tdata2(0) <= uPort0_s_axi_tx_tdata2;
  uPort_s_axi_tx_tdata2(1) <= uPort1_s_axi_tx_tdata2;
  uPort_s_axi_tx_tdata3(0) <= uPort0_s_axi_tx_tdata3;
  uPort_s_axi_tx_tdata3(1) <= uPort1_s_axi_tx_tdata3;

  uPort_s_axi_tx_tkeep(0) <= uPort0_s_axi_tx_tkeep;
  uPort_s_axi_tx_tkeep(1) <= uPort1_s_axi_tx_tkeep;

  uPort_s_axi_tx_tlast(0) <= uPort0_s_axi_tx_tlast;
  uPort_s_axi_tx_tlast(1) <= uPort1_s_axi_tx_tlast;

  uPort_s_axi_tx_tvalid(0) <= uPort0_s_axi_tx_tvalid;
  uPort_s_axi_tx_tvalid(1) <= uPort1_s_axi_tx_tvalid;

  uPort0_s_axi_tx_tready <= uPort_s_axi_tx_tready(0);
  uPort1_s_axi_tx_tready <= uPort_s_axi_tx_tready(1);

  uPort0_m_axi_rx_tdata0 <= uPort_m_axi_rx_tdata0(0);
  uPort1_m_axi_rx_tdata0 <= uPort_m_axi_rx_tdata0(1);
  uPort0_m_axi_rx_tdata1 <= uPort_m_axi_rx_tdata1(0);
  uPort1_m_axi_rx_tdata1 <= uPort_m_axi_rx_tdata1(1);
  uPort0_m_axi_rx_tdata2 <= uPort_m_axi_rx_tdata2(0);
  uPort1_m_axi_rx_tdata2 <= uPort_m_axi_rx_tdata2(1);
  uPort0_m_axi_rx_tdata3 <= uPort_m_axi_rx_tdata3(0);
  uPort1_m_axi_rx_tdata3 <= uPort_m_axi_rx_tdata3(1);

  uPort0_m_axi_rx_tkeep <= uPort_m_axi_rx_tkeep(0);
  uPort1_m_axi_rx_tkeep <= uPort_m_axi_rx_tkeep(1);

  uPort0_m_axi_rx_tlast <= uPort_m_axi_rx_tlast(0);
  uPort1_m_axi_rx_tlast <= uPort_m_axi_rx_tlast(1);

  uPort0_m_axi_rx_tvalid <= uPort_m_axi_rx_tvalid(0);
  uPort1_m_axi_rx_tvalid <= uPort_m_axi_rx_tvalid(1);

  GenSigAssignment : for i in 0 to kNumPorts*kNumLanes-1 generate
    gtwiz_rRxRate_in      ((i+1)*3-1 downto i*3) <= rRxRate_in      (i);
    gtwiz_tTxDiffCtrl_in  ((i+1)*4-1 downto i*4) <= tTxDiffCtrl_in  (i);
    gtwiz_aTxPreCursor_in ((i+1)*5-1 downto i*5) <= aTxPreCursor_in (i);
    gtwiz_aTxPostCursor_in((i+1)*5-1 downto i*5) <= aTxPostCursor_in(i);
    gtwiz_rRxPrbsSel_in   ((i+1)*4-1 downto i*4) <= rRxPrbsSel_in   (i);
    gtwiz_tTxPrbsSel_in   ((i+1)*4-1 downto i*4) <= tTxPrbsSel_in   (i);
  end generate;

  GenGtwizDMonClk : for i in 0 to kNumPorts*kNumLanes-1 generate
    sDMonitorOut_out(i) <= gtwiz_dDMonitorOut_out((i+1)*17-1 downto i*17);

    --vhook_i BUFG DMonClk_bufg_instN
    --vhook_a I gtwiz_dDMonitorOut_out((i+1)*17-1)
    --vhook_a O gtwiz_slv_dmonclk(i)
    DMonClk_bufg_instN: BUFG
      port map (
        O => gtwiz_slv_dmonclk(i),                --out std_ulogic
        I => gtwiz_dDMonitorOut_out((i+1)*17-1)); --in  std_ulogic

  end generate;

  AuroraBlock : block
  begin
    GenAurora : for i in 0 to kNumPorts-1 generate
      RxUsrClk2(i*4+0) <= Port_rxusrclk2(i);
      RxUsrClk2(i*4+1) <= Port_rxusrclk2(i);
      RxUsrClk2(i*4+2) <= Port_rxusrclk2(i);
      RxUsrClk2(i*4+3) <= Port_rxusrclk2(i);
      TxUsrClk2(i*4+0) <= Port_user_clk(i);
      TxUsrClk2(i*4+1) <= Port_user_clk(i);
      TxUsrClk2(i*4+2) <= Port_user_clk(i);
      TxUsrClk2(i*4+3) <= Port_user_clk(i);

      --vhook AXI4Lite_GTHE3_Control_Regs4 AXI4Lite_GTHE3_Control_Regs4_inst
      --vhook_a LiteClk              s_aclk
      --vhook_a lAxiMasterWritePort  lAxiMasterWritePort(i)
      --vhook_a lAxiSlaveWritePort   lAxiSlaveWritePort (i)
      --vhook_a lAxiMasterReadPort   lAxiMasterReadPort (i)
      --vhook_a lAxiSlaveReadPort    lAxiSlaveReadPort  (i)
      --vhook_a RxUsrClk2            RxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a TxUsrClk2            TxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aGtWiz_ResetAll_in           open
      --vhook_a aGtWiz_RxCdr_stable_out      '1'
      --vhook_a aGtWiz_ResetTx_pll_data_in   open
      --vhook_a aGtWiz_ResetTx_data_in       open
      --vhook_a aGtWiz_ResetTx_Done_out      '1'
      --vhook_a aGtWiz_UserClkTx_active_out  (others => '1')
      --vhook_a aGtWiz_ResetRx_pll_data_in   open
      --vhook_a aGtWiz_ResetRx_data_in       open
      --vhook_a aGtWiz_ResetRx_Done_out      '1'
      --vhook_a aGtWiz_UserClkRx_active_out  (others => '1')
      --vhook_a rRxResetDone_out     rRxResetDone_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxPmaReset_in       aRxPmaReset_in  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxResetDone_out     tTxResetDone_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPmaReset_in       aTxPmaReset_in  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aEyeScanReset_in     aEyeScanReset_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aGtPowerGood_out     (others => '1')
      --vhook_a aCpllPD_in           open
      --vhook_a aCpllReset_in        open
      --vhook_a aCpllRefClkSel_in    open
      --vhook_a aCpllLock_out        aCpllLock_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aCpllRefClkLost_out  (others => '0')
      --vhook_a aQpll0PD_in            open
      --vhook_a aQpll0Reset_in         open
      --vhook_a aQpll0RefClkSel_in     open
      --vhook_a aQpll0Lock_out         aQpll0Lock_out(i)
      --vhook_a aQpll0RefClkLost_out   aQpll0RefClkLost_out(i)
      --vhook_a aQpll1PD_in            open
      --vhook_a aQpll1Reset_in         open
      --vhook_a aQpll1RefClkSel_in     open
      --vhook_a aQpll1Lock_out         '0'
      --vhook_a aQpll1RefClkLost_out   '0'
      --vhook_a aTxSysClkSel_in      open
      --vhook_a aRxSysClkSel_in      open
      --vhook_a aTxPllClkSel_in      open
      --vhook_a aRxPllClkSel_in      open
      --vhook_a aTxOutClkSel_in      open
      --vhook_a aRxOutClkSel_in      open
      --vhook_a aRxCdrHold_in        aRxCdrHold_in  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxCdrOvrdEn_in      aRxCdrOvrdEn_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aRxCdrReset_in       open
      --vhook_a aRxCdrLock_out       (others => '0')
      --vhook_a tTxPiPpmEn_in        open
      --vhook_a tTxPiPpmOvrdEn_in    open
      --vhook_a aTxPiPpmPD_in        open
      --vhook_a tTxPiPpmSel_in       open
      --vhook_a tTxPiPpmStepSize_in  open
      --vhook_a rRxDfeOsHold_in      open
      --vhook_a rRxDfeOsOvrdEn_in    open
      --vhook_a rRxDfeAgcHold_in     open
      --vhook_a rRxDfeAgcOvrdEn_in   open
      --vhook_a rRxDfeLfHold_in      open
      --vhook_a rRxDfeLfOvrdEn_in    open
      --vhook_a rRxDfeUtHold_in      open
      --vhook_a rRxDfeUtOvrdEn_in    open
      --vhook_a rRxDfeVpHold_in      open
      --vhook_a rRxDfeVpOvrdEn_in    open
      --vhook_a rRxDfeTap2Hold_in     open
      --vhook_a rRxDfeTap2OvrdEn_in   open
      --vhook_a rRxDfeTap3Hold_in     open
      --vhook_a rRxDfeTap3OvrdEn_in   open
      --vhook_a rRxDfeTap4Hold_in     open
      --vhook_a rRxDfeTap4OvrdEn_in   open
      --vhook_a rRxDfeTap5Hold_in     open
      --vhook_a rRxDfeTap5OvrdEn_in   open
      --vhook_a rRxDfeTap6Hold_in     open
      --vhook_a rRxDfeTap6OvrdEn_in   open
      --vhook_a rRxDfeTap7Hold_in     open
      --vhook_a rRxDfeTap7OvrdEn_in   open
      --vhook_a rRxDfeTap8Hold_in     open
      --vhook_a rRxDfeTap8OvrdEn_in   open
      --vhook_a rRxDfeTap9Hold_in     open
      --vhook_a rRxDfeTap9OvrdEn_in   open
      --vhook_a rRxDfeTap10Hold_in    open
      --vhook_a rRxDfeTap10OvrdEn_in  open
      --vhook_a rRxDfeTap11Hold_in    open
      --vhook_a rRxDfeTap11OvrdEn_in  open
      --vhook_a rRxDfeTap12Hold_in    open
      --vhook_a rRxDfeTap12OvrdEn_in  open
      --vhook_a rRxDfeTap13Hold_in    open
      --vhook_a rRxDfeTap13OvrdEn_in  open
      --vhook_a rRxDfeTap14Hold_in    open
      --vhook_a rRxDfeTap14OvrdEn_in  open
      --vhook_a rRxDfeTap15Hold_in    open
      --vhook_a rRxDfeTap15OvrdEn_in  open
      --vhook_a rRxLpmEn_in          rRxLpmEn_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxLpmOSHold_in      open
      --vhook_a rRxLpmOSOvrdEn_in    open
      --vhook_a rRxLpmGCHold_in      open
      --vhook_a rRxLpmGCOvrdEn_in    open
      --vhook_a rRxLpmHFHold_in      open
      --vhook_a rRxLpmHFOvrdEn_in    open
      --vhook_a rRxLpmLFHold_in      open
      --vhook_a rRxLpmLFOvrdEn_in    open
      --vhook_a DmonClk              gtwiz_slv_dmonclk((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a dDMonitorOut_out     sDMonitorOut_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxRate_in           rRxRate_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxRateDone_out      (others => '1')
      --vhook_a tTxRate_in           open
      --vhook_a tTxRateDone_out      (others => '1')
      --vhook_a tTxDiffCtrl_in       tTxDiffCtrl_in  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPreCursor_in      aTxPreCursor_in ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a aTxPostCursor_in     aTxPostCursor_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsSel_in        rRxPrbsSel_in ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsErr_out       rRxPrbsErr_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPrbsLocked_out    (others => '1')
      --vhook_a rRxPrbsCntReset_in   rRxPrbsCntReset_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a rRxPolarity_in       open
      --vhook_a tTxPrbsSel_in        tTxPrbsSel_in     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxPrbsForceErr_in   tTxPrbsForceErr_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxPolarity_in       tTxPolarity_in    ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a tTxDetectRx_in  open
      --vhook_a rPhyStatus_out  (others => '1')
      --vhook_a rRxStatus_out   (others => (others => '1'))
      --vhook_a tTxPd_in        open
      --vhook_a rRxPd_in        open
      --vhook_a aLoopback_in    aLoopback_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      AXI4Lite_GTHE3_Control_Regs4_inst: AXI4Lite_GTHE3_Control_Regs4
        port map (
          LiteClk                     => s_aclk,                                                    --in  std_logic
          aReset_n                    => aReset_n,                                                  --in  std_logic
          lAxiMasterWritePort         => lAxiMasterWritePort(i),                                    --in  Axi4LiteWritePortIn_t
          lAxiSlaveWritePort          => lAxiSlaveWritePort (i),                                    --out Axi4LiteWritePortOut_t
          lAxiMasterReadPort          => lAxiMasterReadPort (i),                                    --in  Axi4LiteReadPortIn_t
          lAxiSlaveReadPort           => lAxiSlaveReadPort (i),                                     --out Axi4LiteReadPortOut_t
          RxUsrClk2                   => RxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes),           --in  std_logic_vector(4-1:0)
          TxUsrClk2                   => TxUsrClk2((i+1)*kNumLanes-1 downto i*kNumLanes),           --in  std_logic_vector(4-1:0)
          aGtWiz_ResetAll_in          => open,                                                      --out std_logic
          aGtWiz_RxCdr_stable_out     => '1',                                                       --in  std_logic
          aGtWiz_ResetTx_pll_data_in  => open,                                                      --out std_logic
          aGtWiz_ResetTx_data_in      => open,                                                      --out std_logic
          aGtWiz_ResetTx_Done_out     => '1',                                                       --in  std_logic
          aGtWiz_UserClkTx_active_out => (others => '1'),                                           --in  std_logic_vector(3:0)
          aGtWiz_ResetRx_pll_data_in  => open,                                                      --out std_logic
          aGtWiz_ResetRx_data_in      => open,                                                      --out std_logic
          aGtWiz_ResetRx_Done_out     => '1',                                                       --in  std_logic
          aGtWiz_UserClkRx_active_out => (others => '1'),                                           --in  std_logic_vector(3:0)
          rRxResetDone_out            => rRxResetDone_out((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  std_logic_vector(4-1:0)
          aRxPmaReset_in              => aRxPmaReset_in ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          tTxResetDone_out            => tTxResetDone_out((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  std_logic_vector(4-1:0)
          aTxPmaReset_in              => aTxPmaReset_in ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          aEyeScanReset_in            => aEyeScanReset_in((i+1)*kNumLanes-1 downto i*kNumLanes),    --out std_logic_vector(4-1:0)
          aGtPowerGood_out            => (others => '1'),                                           --in  std_logic_vector(4-1:0)
          aCpllPD_in                  => open,                                                      --out std_logic_vector(4-1:0)
          aCpllReset_in               => open,                                                      --out std_logic_vector(4-1:0)
          aCpllRefClkSel_in           => open,                                                      --out GTRefClkSelAry_t(4-1:0)
          aCpllLock_out               => aCpllLock_out((i+1)*kNumLanes-1 downto i*kNumLanes),       --in  std_logic_vector(4-1:0)
          aCpllRefClkLost_out         => (others => '0'),                                           --in  std_logic_vector(4-1:0)
          aQpll0PD_in                 => open,                                                      --out std_logic
          aQpll0Reset_in              => open,                                                      --out std_logic
          aQpll0RefClkSel_in          => open,                                                      --out GTRefClkSel_t
          aQpll0Lock_out              => aQpll0Lock_out(i),                                         --in  std_logic
          aQpll0RefClkLost_out        => aQpll0RefClkLost_out(i),                                   --in  std_logic
          aQpll1PD_in                 => open,                                                      --out std_logic
          aQpll1Reset_in              => open,                                                      --out std_logic
          aQpll1RefClkSel_in          => open,                                                      --out GTRefClkSel_t
          aQpll1Lock_out              => '0',                                                       --in  std_logic
          aQpll1RefClkLost_out        => '0',                                                       --in  std_logic
          aTxSysClkSel_in             => open,                                                      --out GTClkSelAry_t(4-1:0)
          aRxSysClkSel_in             => open,                                                      --out GTClkSelAry_t(4-1:0)
          aTxPllClkSel_in             => open,                                                      --out GTClkSelAry_t(4-1:0)
          aRxPllClkSel_in             => open,                                                      --out GTClkSelAry_t(4-1:0)
          aTxOutClkSel_in             => open,                                                      --out GTOutClkSelAry_t(4-1:0)
          aRxOutClkSel_in             => open,                                                      --out GTOutClkSelAry_t(4-1:0)
          aRxCdrHold_in               => aRxCdrHold_in ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out std_logic_vector(4-1:0)
          aRxCdrOvrdEn_in             => aRxCdrOvrdEn_in((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          aRxCdrReset_in              => open,                                                      --out std_logic_vector(4-1:0)
          aRxCdrLock_out              => (others => '0'),                                           --in  std_logic_vector(4-1:0)
          tTxPiPpmEn_in               => open,                                                      --out std_logic_vector(4-1:0)
          tTxPiPpmOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          aTxPiPpmPD_in               => open,                                                      --out std_logic_vector(4-1:0)
          tTxPiPpmSel_in              => open,                                                      --out std_logic_vector(4-1:0)
          tTxPiPpmStepSize_in         => open,                                                      --out GTTxPiPpmStepSizeAry_t(4-1:0)
          rRxDfeOSHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeOSOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeAgcHold_in            => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeAgcOvrdEn_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeLFHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeLFOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeUTHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeUTOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeVPHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeVPOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap2Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap2OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap3Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap3OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap4Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap4OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap5Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap5OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap6Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap6OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap7Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap7OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap8Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap8OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap9Hold_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap9OvrdEn_in         => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap10Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap10OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap11Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap11OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap12Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap12OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap13Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap13OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap14Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap14OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap15Hold_in          => open,                                                      --out std_logic_vector(4-1:0)
          rRxDfeTap15OvrdEn_in        => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmEn_in                 => rRxLpmEn_in((i+1)*kNumLanes-1 downto i*kNumLanes),         --out std_logic_vector(4-1:0)
          rRxLpmOSHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmOSOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmGCHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmGCOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmHFHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmHFOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmLFHold_in             => open,                                                      --out std_logic_vector(4-1:0)
          rRxLpmLFOvrdEn_in           => open,                                                      --out std_logic_vector(4-1:0)
          DmonClk                     => gtwiz_slv_dmonclk((i+1)*kNumLanes-1 downto i*kNumLanes),   --in  std_logic_vector(4-1:0)
          dDMonitorOut_out            => sDMonitorOut_out((i+1)*kNumLanes-1 downto i*kNumLanes),    --in  GTHDMonitorOutAry_t(4-1:0)
          rRxRate_in                  => rRxRate_in((i+1)*kNumLanes-1 downto i*kNumLanes),          --out GTRateSelAry_t(4-1:0)
          rRxRateDone_out             => (others => '1'),                                           --in  std_logic_vector(4-1:0)
          tTxRate_in                  => open,                                                      --out GTRateSelAry_t(4-1:0)
          tTxRateDone_out             => (others => '1'),                                           --in  std_logic_vector(4-1:0)
          tTxDiffCtrl_in              => tTxDiffCtrl_in ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out GTHDiffCtrlAry_t(4-1:0)
          aTxPreCursor_in             => aTxPreCursor_in ((i+1)*kNumLanes-1 downto i*kNumLanes),    --out GTHCursorSelAry_t(4-1:0)
          aTxPostCursor_in            => aTxPostCursor_in((i+1)*kNumLanes-1 downto i*kNumLanes),    --out GTHCursorSelAry_t(4-1:0)
          rRxPrbsSel_in               => rRxPrbsSel_in ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out GTPrbsSelAry_t(4-1:0)
          rRxPrbsErr_out              => rRxPrbsErr_out((i+1)*kNumLanes-1 downto i*kNumLanes),      --in  std_logic_vector(4-1:0)
          rRxPrbsLocked_out           => (others => '1'),                                           --in  std_logic_vector(4-1:0)
          rRxPrbsCntReset_in          => rRxPrbsCntReset_in((i+1)*kNumLanes-1 downto i*kNumLanes),  --out std_logic_vector(4-1:0)
          rRxPolarity_in              => open,                                                      --out std_logic_vector(4-1:0)
          tTxPrbsSel_in               => tTxPrbsSel_in ((i+1)*kNumLanes-1 downto i*kNumLanes),      --out GTPrbsSelAry_t(4-1:0)
          tTxPrbsForceErr_in          => tTxPrbsForceErr_in((i+1)*kNumLanes-1 downto i*kNumLanes),  --out std_logic_vector(4-1:0)
          tTxPolarity_in              => tTxPolarity_in ((i+1)*kNumLanes-1 downto i*kNumLanes),     --out std_logic_vector(4-1:0)
          tTxDetectRx_in              => open,                                                      --out std_logic_vector(4-1:0)
          rPhyStatus_out              => (others => '1'),                                           --in  std_logic_vector(4-1:0)
          rRxStatus_out               => (others => (others => '1')),                               --in  GTRxStatusAry_t(4-1:0)
          tTxPd_in                    => open,                                                      --out GTPdAry_t(4-1:0)
          rRxPd_in                    => open,                                                      --out GTPdAry_t(4-1:0)
          aLoopback_in                => aLoopback_in((i+1)*kNumLanes-1 downto i*kNumLanes));       --out GTLoopbackSelAry_t(4-1:0)

      uPort_s_axi_tx_tdata(i)  <= uPort_s_axi_tx_tdata3(i) & uPort_s_axi_tx_tdata2(i) & uPort_s_axi_tx_tdata1(i) & uPort_s_axi_tx_tdata0(i);
      uPort_m_axi_rx_tdata0(i) <= uPort_m_axi_rx_tdata(i)(0*64+63 downto 0*64);
      uPort_m_axi_rx_tdata1(i) <= uPort_m_axi_rx_tdata(i)(1*64+63 downto 1*64);
      uPort_m_axi_rx_tdata2(i) <= uPort_m_axi_rx_tdata(i)(2*64+63 downto 2*64);
      uPort_m_axi_rx_tdata3(i) <= uPort_m_axi_rx_tdata(i)(3*64+63 downto 3*64);

      Port_lane_up(i) <= reversi(Port_lane_up_rev(i));

      --vhook aurora_64b66b_DF Aurora_PortN
      --vhook_a s_axi_tx_tdata   uPort_s_axi_tx_tdata (i)
      --vhook_a s_axi_tx_tlast   uPort_s_axi_tx_tlast (i)
      --vhook_a s_axi_tx_tkeep   uPort_s_axi_tx_tkeep (i)
      --vhook_a s_axi_tx_tvalid  uPort_s_axi_tx_tvalid(i)
      --vhook_a s_axi_tx_tready  uPort_s_axi_tx_tready(i)
      --vhook_a m_axi_rx_tdata   uPort_m_axi_rx_tdata (i)
      --vhook_a m_axi_rx_tlast   uPort_m_axi_rx_tlast (i)
      --vhook_a m_axi_rx_tkeep   uPort_m_axi_rx_tkeep (i)
      --vhook_a m_axi_rx_tvalid  uPort_m_axi_rx_tvalid(i)
      --vhook_a rxp  PortRx_p(i*4 to i*4+3)
      --vhook_a rxn  PortRx_n(i*4 to i*4+3)
      --vhook_a txp  PortTx_p(i*4 to i*4+3)
      --vhook_a txn  PortTx_n(i*4 to i*4+3)
      --vhook_a refclk1_in  FAM_refclk(1)
      --vhook_a hard_err         Port_hard_err  (i)
      --vhook_a soft_err         Port_soft_err  (i)
      --vhook_a lane_up          Port_lane_up_rev(i)
      --vhook_a channel_up       Port_channel_up(i)
      --vhook_a init_clk         InitClk
      --vhook_a user_clk_out     Port_user_clk(i)
      --vhook_a sync_clk_out     Port_sync_clk(i)
      --vhook_a mmcm_not_locked_out  Port_mmcm_not_locked(i)
      --vhook_a pma_init         cPort_PMA_Init(i)
      --vhook_a reset_pb         Port_reset_pb(i)
      --vhook_a power_down       '0'
      --vhook_a loopback         aLoopback_in(i*kNumLanes)
      --vhook_a gt_pll_lock      open
      --vhook_a link_reset_out   Port_link_reset_out(i)
      --vhook_a sys_reset_out    Port_sys_reset_out (i)
      --vhook_a gt_reset_out     open
      --vhook_a gt_rxusrclk_out  Port_rxusrclk2(i)
      --vhook_a tx_out_clk       open
      --vhook_a gt_qpllclk_quad1_out         open
      --vhook_a gt_qpllrefclk_quad1_out      open
      --vhook_a gt_qplllock_quad1_out        aQpll0Lock_out(i)
      --vhook_a gt_qpllrefclklost_quad1_out  aQpll0RefClkLost_out(i)
      --vhook_a gt0_drpaddr  gtwiz_drpaddr_in((i*4+1)*kAddrSize-1 downto (i*4+0)*kAddrSize)
      --vhook_a gt0_drpdi    gtwiz_drpdi_in  ((i*4+1)*16-1 downto (i*4+0)*16)
      --vhook_a gt0_drpdo    gtwiz_drpdo_out ((i*4+1)*16-1 downto (i*4+0)*16)
      --vhook_a gt0_drprdy   gtwiz_drprdy_out (i*4+0)
      --vhook_a gt0_drpen    gtwiz_drpen_in   (i*4+0)
      --vhook_a gt0_drpwe    gtwiz_drpwe_in   (i*4+0)
      --vhook_a gt1_drpaddr  gtwiz_drpaddr_in((i*4+2)*kAddrSize-1 downto (i*4+1)*kAddrSize)
      --vhook_a gt1_drpdi    gtwiz_drpdi_in  ((i*4+2)*16-1 downto (i*4+1)*16)
      --vhook_a gt1_drpdo    gtwiz_drpdo_out ((i*4+2)*16-1 downto (i*4+1)*16)
      --vhook_a gt1_drprdy   gtwiz_drprdy_out (i*4+1)
      --vhook_a gt1_drpen    gtwiz_drpen_in   (i*4+1)
      --vhook_a gt1_drpwe    gtwiz_drpwe_in   (i*4+1)
      --vhook_a gt2_drpaddr  gtwiz_drpaddr_in((i*4+3)*kAddrSize-1 downto (i*4+2)*kAddrSize)
      --vhook_a gt2_drpdi    gtwiz_drpdi_in  ((i*4+3)*16-1 downto (i*4+2)*16)
      --vhook_a gt2_drpdo    gtwiz_drpdo_out ((i*4+3)*16-1 downto (i*4+2)*16)
      --vhook_a gt2_drprdy   gtwiz_drprdy_out (i*4+2)
      --vhook_a gt2_drpen    gtwiz_drpen_in   (i*4+2)
      --vhook_a gt2_drpwe    gtwiz_drpwe_in   (i*4+2)
      --vhook_a gt3_drpaddr  gtwiz_drpaddr_in((i*4+4)*kAddrSize-1 downto (i*4+3)*kAddrSize)
      --vhook_a gt3_drpdi    gtwiz_drpdi_in  ((i*4+4)*16-1 downto (i*4+3)*16)
      --vhook_a gt3_drpdo    gtwiz_drpdo_out ((i*4+4)*16-1 downto (i*4+3)*16)
      --vhook_a gt3_drprdy   gtwiz_drprdy_out (i*4+3)
      --vhook_a gt3_drpen    gtwiz_drpen_in   (i*4+3)
      --vhook_a gt3_drpwe    gtwiz_drpwe_in   (i*4+3)
      --vhook_a gt_rxcdrovrden_in    aRxCdrOvrdEn_in (i*kNumLanes)
      --vhook_a gt_eyescandataerror  open
      --vhook_a gt_eyescanreset      aEyeScanReset_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_eyescantrigger    (others => '0')
      --vhook_a gt_rxcdrhold         aRxCdrHold_in   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxdfelpmreset     (others => '0')
      --vhook_a gt_rxlpmen           rRxLpmEn_in     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxpmareset        aRxPmaReset_in  ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxpcsreset        (others => '0')
      --vhook_a gt_rxrate            gtwiz_rRxRate_in((i+1)*kNumLanes*3-1 downto i*kNumLanes*3)
      --vhook_a gt_rxbufreset        (others => '0')
      --vhook_a gt_rxpmaresetdone    open
      --vhook_a gt_rxprbssel         gtwiz_rRxPrbsSel_in((i+1)*kNumLanes*4-1 downto i*kNumLanes*4)
      --vhook_a gt_rxprbserr         rRxPrbsErr_out     ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxprbscntreset    rRxPrbsCntReset_in ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxresetdone       rRxResetDone_out   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_rxbufstatus       open
      --vhook_a gt_txdiffctrl        gtwiz_tTxDiffCtrl_in  ((i+1)*kNumLanes*4-1 downto i*kNumLanes*4)
      --vhook_a gt_txprecursor       gtwiz_aTxPreCursor_in ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5)
      --vhook_a gt_txpostcursor      gtwiz_aTxPostCursor_in((i+1)*kNumLanes*5-1 downto i*kNumLanes*5)
      --vhook_a gt_txpolarity        tTxPolarity_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txinhibit         (others => '0')
      --vhook_a gt_txpmareset        aTxPmaReset_in((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txpcsreset        (others => '0')
      --vhook_a gt_txprbssel         gtwiz_tTxPrbsSel_in((i+1)*kNumLanes*4-1 downto i*kNumLanes*4)
      --vhook_a gt_txprbsforceerr    tTxPrbsForceErr_in ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_txbufstatus       open
      --vhook_a gt_txresetdone       tTxResetDone_out   ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_pcsrsvdin         (others => '0')
      --vhook_a gt_powergood         aGtPowerGood_out((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_dmonitorout       gtwiz_dDMonitorOut_out((i+1)*kNumLanes*17-1 downto i*kNumLanes*17)
      --vhook_a gt_cplllock          aCpllLock_out ((i+1)*kNumLanes-1 downto i*kNumLanes)
      --vhook_a gt_qplllock          open
      Aurora_PortN: aurora_64b66b_DF
        port map (
          s_axi_tx_tdata              => uPort_s_axi_tx_tdata (i),                                            --in  STD_LOGIC_VECTOR(255:0)
          s_axi_tx_tlast              => uPort_s_axi_tx_tlast (i),                                            --in  STD_LOGIC
          s_axi_tx_tkeep              => uPort_s_axi_tx_tkeep (i),                                            --in  STD_LOGIC_VECTOR(31:0)
          s_axi_tx_tvalid             => uPort_s_axi_tx_tvalid(i),                                            --in  STD_LOGIC
          s_axi_tx_tready             => uPort_s_axi_tx_tready(i),                                            --out STD_LOGIC
          m_axi_rx_tdata              => uPort_m_axi_rx_tdata (i),                                            --out STD_LOGIC_VECTOR(255:0)
          m_axi_rx_tlast              => uPort_m_axi_rx_tlast (i),                                            --out STD_LOGIC
          m_axi_rx_tkeep              => uPort_m_axi_rx_tkeep (i),                                            --out STD_LOGIC_VECTOR(31:0)
          m_axi_rx_tvalid             => uPort_m_axi_rx_tvalid(i),                                            --out STD_LOGIC
          rxp                         => PortRx_p(i*4 to i*4+3),                                              --in  STD_LOGIC_VECTOR(0:3)
          rxn                         => PortRx_n(i*4 to i*4+3),                                              --in  STD_LOGIC_VECTOR(0:3)
          txp                         => PortTx_p(i*4 to i*4+3),                                              --out STD_LOGIC_VECTOR(0:3)
          txn                         => PortTx_n(i*4 to i*4+3),                                              --out STD_LOGIC_VECTOR(0:3)
          refclk1_in                  => FAM_refclk(1),                                                       --in  STD_LOGIC
          hard_err                    => Port_hard_err (i),                                                   --out STD_LOGIC
          soft_err                    => Port_soft_err (i),                                                   --out STD_LOGIC
          channel_up                  => Port_channel_up(i),                                                  --out STD_LOGIC
          lane_up                     => Port_lane_up_rev(i),                                                 --out STD_LOGIC_VECTOR(0:3)
          user_clk_out                => Port_user_clk(i),                                                    --out STD_LOGIC
          mmcm_not_locked_out         => Port_mmcm_not_locked(i),                                             --out STD_LOGIC
          sync_clk_out                => Port_sync_clk(i),                                                    --out STD_LOGIC
          reset_pb                    => Port_reset_pb(i),                                                    --in  STD_LOGIC
          gt_rxcdrovrden_in           => aRxCdrOvrdEn_in (i*kNumLanes),                                       --in  STD_LOGIC
          power_down                  => '0',                                                                 --in  STD_LOGIC
          loopback                    => aLoopback_in(i*kNumLanes),                                           --in  STD_LOGIC_VECTOR(2:0)
          pma_init                    => cPort_PMA_Init(i),                                                   --in  STD_LOGIC
          gt_pll_lock                 => open,                                                                --out STD_LOGIC
          gt0_drpaddr                 => gtwiz_drpaddr_in((i*4+1)*kAddrSize-1 downto (i*4+0)*kAddrSize),      --in  STD_LOGIC_VECTOR(8:0)
          gt0_drpdi                   => gtwiz_drpdi_in ((i*4+1)*16-1 downto (i*4+0)*16),                     --in  STD_LOGIC_VECTOR(15:0)
          gt0_drpdo                   => gtwiz_drpdo_out ((i*4+1)*16-1 downto (i*4+0)*16),                    --out STD_LOGIC_VECTOR(15:0)
          gt0_drprdy                  => gtwiz_drprdy_out (i*4+0),                                            --out STD_LOGIC
          gt0_drpen                   => gtwiz_drpen_in (i*4+0),                                              --in  STD_LOGIC
          gt0_drpwe                   => gtwiz_drpwe_in (i*4+0),                                              --in  STD_LOGIC
          gt1_drpaddr                 => gtwiz_drpaddr_in((i*4+2)*kAddrSize-1 downto (i*4+1)*kAddrSize),      --in  STD_LOGIC_VECTOR(8:0)
          gt1_drpdi                   => gtwiz_drpdi_in ((i*4+2)*16-1 downto (i*4+1)*16),                     --in  STD_LOGIC_VECTOR(15:0)
          gt1_drpdo                   => gtwiz_drpdo_out ((i*4+2)*16-1 downto (i*4+1)*16),                    --out STD_LOGIC_VECTOR(15:0)
          gt1_drprdy                  => gtwiz_drprdy_out (i*4+1),                                            --out STD_LOGIC
          gt1_drpen                   => gtwiz_drpen_in (i*4+1),                                              --in  STD_LOGIC
          gt1_drpwe                   => gtwiz_drpwe_in (i*4+1),                                              --in  STD_LOGIC
          gt2_drpaddr                 => gtwiz_drpaddr_in((i*4+3)*kAddrSize-1 downto (i*4+2)*kAddrSize),      --in  STD_LOGIC_VECTOR(8:0)
          gt2_drpdi                   => gtwiz_drpdi_in ((i*4+3)*16-1 downto (i*4+2)*16),                     --in  STD_LOGIC_VECTOR(15:0)
          gt2_drpdo                   => gtwiz_drpdo_out ((i*4+3)*16-1 downto (i*4+2)*16),                    --out STD_LOGIC_VECTOR(15:0)
          gt2_drprdy                  => gtwiz_drprdy_out (i*4+2),                                            --out STD_LOGIC
          gt2_drpen                   => gtwiz_drpen_in (i*4+2),                                              --in  STD_LOGIC
          gt2_drpwe                   => gtwiz_drpwe_in (i*4+2),                                              --in  STD_LOGIC
          gt3_drpaddr                 => gtwiz_drpaddr_in((i*4+4)*kAddrSize-1 downto (i*4+3)*kAddrSize),      --in  STD_LOGIC_VECTOR(8:0)
          gt3_drpdi                   => gtwiz_drpdi_in ((i*4+4)*16-1 downto (i*4+3)*16),                     --in  STD_LOGIC_VECTOR(15:0)
          gt3_drpdo                   => gtwiz_drpdo_out ((i*4+4)*16-1 downto (i*4+3)*16),                    --out STD_LOGIC_VECTOR(15:0)
          gt3_drprdy                  => gtwiz_drprdy_out (i*4+3),                                            --out STD_LOGIC
          gt3_drpen                   => gtwiz_drpen_in (i*4+3),                                              --in  STD_LOGIC
          gt3_drpwe                   => gtwiz_drpwe_in (i*4+3),                                              --in  STD_LOGIC
          init_clk                    => InitClk,                                                             --in  STD_LOGIC
          link_reset_out              => Port_link_reset_out(i),                                              --out STD_LOGIC
          gt_rxusrclk_out             => Port_rxusrclk2(i),                                                   --out STD_LOGIC
          gt_eyescandataerror         => open,                                                                --out STD_LOGIC_VECTOR(3:0)
          gt_eyescanreset             => aEyeScanReset_in((i+1)*kNumLanes-1 downto i*kNumLanes),              --in  STD_LOGIC_VECTOR(3:0)
          gt_eyescantrigger           => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_rxcdrhold                => aRxCdrHold_in ((i+1)*kNumLanes-1 downto i*kNumLanes),                --in  STD_LOGIC_VECTOR(3:0)
          gt_rxdfelpmreset            => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_rxlpmen                  => rRxLpmEn_in ((i+1)*kNumLanes-1 downto i*kNumLanes),                  --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpmareset               => aRxPmaReset_in ((i+1)*kNumLanes-1 downto i*kNumLanes),               --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpcsreset               => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_rxrate                   => gtwiz_rRxRate_in((i+1)*kNumLanes*3-1 downto i*kNumLanes*3),          --in  STD_LOGIC_VECTOR(11:0)
          gt_rxbufreset               => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_rxpmaresetdone           => open,                                                                --out STD_LOGIC_VECTOR(3:0)
          gt_rxprbssel                => gtwiz_rRxPrbsSel_in((i+1)*kNumLanes*4-1 downto i*kNumLanes*4),       --in  STD_LOGIC_VECTOR(15:0)
          gt_rxprbserr                => rRxPrbsErr_out ((i+1)*kNumLanes-1 downto i*kNumLanes),               --out STD_LOGIC_VECTOR(3:0)
          gt_rxprbscntreset           => rRxPrbsCntReset_in ((i+1)*kNumLanes-1 downto i*kNumLanes),           --in  STD_LOGIC_VECTOR(3:0)
          gt_rxresetdone              => rRxResetDone_out ((i+1)*kNumLanes-1 downto i*kNumLanes),             --out STD_LOGIC_VECTOR(3:0)
          gt_rxbufstatus              => open,                                                                --out STD_LOGIC_VECTOR(11:0)
          gt_txpostcursor             => gtwiz_aTxPostCursor_in((i+1)*kNumLanes*5-1 downto i*kNumLanes*5),    --in  STD_LOGIC_VECTOR(19:0)
          gt_txdiffctrl               => gtwiz_tTxDiffCtrl_in ((i+1)*kNumLanes*4-1 downto i*kNumLanes*4),     --in  STD_LOGIC_VECTOR(15:0)
          gt_txprecursor              => gtwiz_aTxPreCursor_in ((i+1)*kNumLanes*5-1 downto i*kNumLanes*5),    --in  STD_LOGIC_VECTOR(19:0)
          gt_txpolarity               => tTxPolarity_in((i+1)*kNumLanes-1 downto i*kNumLanes),                --in  STD_LOGIC_VECTOR(3:0)
          gt_txinhibit                => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_txpmareset               => aTxPmaReset_in((i+1)*kNumLanes-1 downto i*kNumLanes),                --in  STD_LOGIC_VECTOR(3:0)
          gt_txpcsreset               => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(3:0)
          gt_txprbssel                => gtwiz_tTxPrbsSel_in((i+1)*kNumLanes*4-1 downto i*kNumLanes*4),       --in  STD_LOGIC_VECTOR(15:0)
          gt_txprbsforceerr           => tTxPrbsForceErr_in ((i+1)*kNumLanes-1 downto i*kNumLanes),           --in  STD_LOGIC_VECTOR(3:0)
          gt_txbufstatus              => open,                                                                --out STD_LOGIC_VECTOR(7:0)
          gt_txresetdone              => tTxResetDone_out ((i+1)*kNumLanes-1 downto i*kNumLanes),             --out STD_LOGIC_VECTOR(3:0)
          gt_pcsrsvdin                => (others => '0'),                                                     --in  STD_LOGIC_VECTOR(63:0)
          gt_dmonitorout              => gtwiz_dDMonitorOut_out((i+1)*kNumLanes*17-1 downto i*kNumLanes*17),  --out STD_LOGIC_VECTOR(67:0)
          gt_cplllock                 => aCpllLock_out ((i+1)*kNumLanes-1 downto i*kNumLanes),                --out STD_LOGIC_VECTOR(3:0)
          gt_qplllock                 => open,                                                                --out STD_LOGIC
          gt_powergood                => aGtPowerGood_out((i+1)*kNumLanes-1 downto i*kNumLanes),              --out STD_LOGIC_VECTOR(3:0)
          gt_qpllclk_quad1_out        => open,                                                                --out STD_LOGIC
          gt_qpllrefclk_quad1_out     => open,                                                                --out STD_LOGIC
          gt_qplllock_quad1_out       => aQpll0Lock_out(i),                                                   --out STD_LOGIC
          gt_qpllrefclklost_quad1_out => aQpll0RefClkLost_out(i),                                             --out STD_LOGIC
          sys_reset_out               => Port_sys_reset_out (i),                                              --out STD_LOGIC
          gt_reset_out                => open,                                                                --out STD_LOGIC
          tx_out_clk                  => open);                                                               --out STD_LOGIC
    end generate;
  end block AuroraBlock;
end rtl;
