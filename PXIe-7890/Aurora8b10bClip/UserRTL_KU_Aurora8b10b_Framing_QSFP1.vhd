-------------------------------------------------------------------------------
--
-- File: UserRTL_KU_Aurora8b10b_Framing_QSFP1.vhd
-- Author: National Instruments
-- Original Project: FlexRIO
-- Date: 20 June 2021
--
-------------------------------------------------------------------------------
-- (c) 2021 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This CLIP instantiates an Aurora 8b10b core for the Kintex Ultrascale.
-- This core is configured with the following settings:
--
-- 4 Lanes
-- Line rate: 4Gbps
-- Reference Clock: 100MHz
-- Interface: Framing
-- CRC: None
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;

library unisim;
  use unisim.vcomponents.all;

entity UserRTL_KU_Aurora8b10b_Framing_QSFP1 is
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
    Qsfp1SocketClk80  : in  std_logic;

    -- MGT Interface
    Qsfp1MgtRefClk_p  : in  std_logic_vector(1 downto 0);
    Qsfp1MgtRefClk_n  : in  std_logic_vector(1 downto 0);

    Qsfp1MgtRx_p      : in  std_logic_vector(3 downto 0);
    Qsfp1MgtRx_n      : in  std_logic_vector(3 downto 0);
    Qsfp1MgtTx_p      : out std_logic_vector(3 downto 0);
    Qsfp1MgtTx_n      : out std_logic_vector(3 downto 0);

    -- Initialization reset signals to the Aurora cores
    cPort1_reset               : in  std_logic;
    -- The following signals are REQUIRED to be in the init_clk domain:
    cLane0_link_reset_out      : out std_logic;  -- Driven High if hot-plug count expires
    cLane1_link_reset_out      : out std_logic;  -- Driven High if hot-plug count expires
    cLane2_link_reset_out      : out std_logic;  -- Driven High if hot-plug count expires
    cLane3_link_reset_out      : out std_logic;  -- Driven High if hot-plug count expires

    -------------------------------------------------------------------------------------
    -- Clock and Reset
    -------------------------------------------------------------------------------------
    -- Resets the Aurora 8B/10B core (active-High)
    -- This signal must be asserted for at least six user_clk cycles.
    aUserClkReset       : in  std_logic;
    -- The reset signal for the transceivers is connected to the top
    -- level through a debouncer. The gt_reset port should be
    -- asserted when the module is first powered up in hardware.
    -- The signal is debounced using init_clk_in and must be
    -- asserted for six init_clk_in cycles.
    aInitClkReset       : in  std_logic;

    -- Link Errors
    -- The following signals are REQUIRED to be in the Port1_UserClk domain:
    -- - Lane 0
    uLane0_HardError           : out std_logic;
    uLane0_SoftError           : out std_logic;
    uLane0_LaneUp              : out std_logic;
    uLane0_ChannelUp           : out std_logic;
    uLane0_sys_reset_out       : out std_logic;
    uLane0_Loopback            : in  std_logic_vector(2 downto 0);
    -- - Lane 1
    uLane1_HardError           : out std_logic;
    uLane1_SoftError           : out std_logic;
    uLane1_LaneUp              : out std_logic;
    uLane1_ChannelUp           : out std_logic;
    uLane1_sys_reset_out       : out std_logic;
    uLane1_Loopback            : in  std_logic_vector(2 downto 0);
    -- - Lane 2
    uLane2_HardError           : out std_logic;
    uLane2_SoftError           : out std_logic;
    uLane2_LaneUp              : out std_logic;
    uLane2_ChannelUp           : out std_logic;
    uLane2_sys_reset_out       : out std_logic;
    uLane2_Loopback            : in  std_logic_vector(2 downto 0);
    -- - Lane 3
    uLane3_HardError           : out std_logic;
    uLane3_SoftError           : out std_logic;
    uLane3_LaneUp              : out std_logic;
    uLane3_ChannelUp           : out std_logic;
    uLane3_sys_reset_out       : out std_logic;
    uLane3_Loopback            : in  std_logic_vector(2 downto 0);

    -- AXI Streaming User Clock Outputs (to LabVIEW FPGA diagram from I/O Socket)
    -- These clocks run at the line rate/64. By default, at 16.375Gbps, these
    -- clocks run at 255.86MHz.
    UserClk0                    : out std_logic;
    UserClk1                    : out std_logic;
    UserClk2                    : out std_logic;
    UserClk3                    : out std_logic;

    -------------------------------------------------------------------------------
    -- AXI4-Lite interfaces - Aurora Port 0
    -------------------------------------------------------------------------------
    -- AXI Streaming and UFC - TX Interface
    -- The following signals are REQUIRED to be in the UserClk domain:
    uLane0_s_axi_tx_tdata      : in  std_logic_vector(31 downto 0);
    uLane0_s_axi_tx_tkeep      : in  std_logic_vector(3 downto 0);
    uLane0_s_axi_tx_tlast      : in  std_logic;
    uLane0_s_axi_tx_tvalid     : in  std_logic;
    uLane0_s_axi_tx_tready     : out std_logic;

    uLane0_s_axi_ufc_tx_tvalid : in std_logic;
    uLane0_s_axi_ufc_tx_tdata  : in std_logic_vector(2 downto 0);
    uLane0_s_axi_ufc_tx_tready : out std_logic;

    uLane1_s_axi_tx_tdata      : in  std_logic_vector(31 downto 0);
    uLane1_s_axi_tx_tkeep      : in  std_logic_vector(3 downto 0);
    uLane1_s_axi_tx_tlast      : in  std_logic;
    uLane1_s_axi_tx_tvalid     : in  std_logic;
    uLane1_s_axi_tx_tready     : out std_logic;

    uLane1_s_axi_ufc_tx_tvalid : in std_logic;
    uLane1_s_axi_ufc_tx_tdata  : in std_logic_vector(2 downto 0);
    uLane1_s_axi_ufc_tx_tready : out std_logic;

    uLane2_s_axi_tx_tdata      : in  std_logic_vector(31 downto 0);
    uLane2_s_axi_tx_tkeep      : in  std_logic_vector(3 downto 0);
    uLane2_s_axi_tx_tlast      : in  std_logic;
    uLane2_s_axi_tx_tvalid     : in  std_logic;
    uLane2_s_axi_tx_tready     : out std_logic;

    uLane2_s_axi_ufc_tx_tvalid : in std_logic;
    uLane2_s_axi_ufc_tx_tdata  : in std_logic_vector(2 downto 0);
    uLane2_s_axi_ufc_tx_tready : out std_logic;

    uLane3_s_axi_tx_tdata      : in  std_logic_vector(31 downto 0);
    uLane3_s_axi_tx_tkeep      : in  std_logic_vector(3 downto 0);
    uLane3_s_axi_tx_tlast      : in  std_logic;
    uLane3_s_axi_tx_tvalid     : in  std_logic;
    uLane3_s_axi_tx_tready     : out std_logic;

    uLane3_s_axi_ufc_tx_tvalid : in std_logic;
    uLane3_s_axi_ufc_tx_tdata  : in std_logic_vector(2 downto 0);
    uLane3_s_axi_ufc_tx_tready : out std_logic;

    -- AXI Streaming and UFC - RX Interface
    -- The following signals are REQUIRED to be in the UserClk domain:
    uLane0_m_axi_rx_tdata      : out std_logic_vector(31 downto 0);
    uLane0_m_axi_rx_tkeep      : out std_logic_vector(3 downto 0);
    uLane0_m_axi_rx_tlast      : out std_logic;
    uLane0_m_axi_rx_tvalid     : out std_logic;

    uLane0_m_axi_ufc_rx_tdata  : out std_logic_vector(31 downto 0);
    uLane0_m_axi_ufc_rx_tkeep  : out std_logic_vector(3 downto 0);
    uLane0_m_axi_ufc_rx_tvalid : out std_logic;
    uLane0_m_axi_ufc_rx_tlast  : out std_logic;

    uLane1_m_axi_rx_tdata      : out std_logic_vector(31 downto 0);
    uLane1_m_axi_rx_tkeep      : out std_logic_vector(3 downto 0);
    uLane1_m_axi_rx_tlast      : out std_logic;
    uLane1_m_axi_rx_tvalid     : out std_logic;

    uLane1_m_axi_ufc_rx_tdata  : out std_logic_vector(31 downto 0);
    uLane1_m_axi_ufc_rx_tkeep  : out std_logic_vector(3 downto 0);
    uLane1_m_axi_ufc_rx_tvalid : out std_logic;
    uLane1_m_axi_ufc_rx_tlast  : out std_logic;

    uLane2_m_axi_rx_tdata      : out std_logic_vector(31 downto 0);
    uLane2_m_axi_rx_tkeep      : out std_logic_vector(3 downto 0);
    uLane2_m_axi_rx_tlast      : out std_logic;
    uLane2_m_axi_rx_tvalid     : out std_logic;

    uLane2_m_axi_ufc_rx_tdata  : out std_logic_vector(31 downto 0);
    uLane2_m_axi_ufc_rx_tkeep  : out std_logic_vector(3 downto 0);
    uLane2_m_axi_ufc_rx_tvalid : out std_logic;
    uLane2_m_axi_ufc_rx_tlast  : out std_logic;

    uLane3_m_axi_rx_tdata      : out std_logic_vector(31 downto 0);
    uLane3_m_axi_rx_tkeep      : out std_logic_vector(3 downto 0);
    uLane3_m_axi_rx_tlast      : out std_logic;
    uLane3_m_axi_rx_tvalid     : out std_logic;

    uLane3_m_axi_ufc_rx_tdata  : out std_logic_vector(31 downto 0);
    uLane3_m_axi_ufc_rx_tkeep  : out std_logic_vector(3 downto 0);
    uLane3_m_axi_ufc_rx_tvalid : out std_logic;
    uLane3_m_axi_ufc_rx_tlast  : out std_logic
  );
end UserRTL_KU_Aurora8b10b_Framing_QSFP1;

architecture rtl of UserRTL_KU_Aurora8b10b_Framing_QSFP1 is

  --vhook_sigstart
  --vhook_sigend

  constant kNumLanes : integer := 4;  -- lanes per port

  --vhook_d aurora_8b10b_DF
  component aurora_8b10b_DF
    port (
      s_axi_tx_tdata      : in  STD_LOGIC_VECTOR(0 to 31);
      s_axi_tx_tkeep      : in  STD_LOGIC_VECTOR(0 to 3);
      s_axi_tx_tvalid     : in  STD_LOGIC;
      s_axi_tx_tlast      : in  STD_LOGIC;
      s_axi_tx_tready     : out STD_LOGIC;
      m_axi_rx_tdata      : out STD_LOGIC_VECTOR(0 to 31);
      m_axi_rx_tkeep      : out STD_LOGIC_VECTOR(0 to 3);
      m_axi_rx_tvalid     : out STD_LOGIC;
      m_axi_rx_tlast      : out STD_LOGIC;
      s_axi_ufc_tx_tvalid : in  STD_LOGIC;
      s_axi_ufc_tx_tdata  : in  STD_LOGIC_VECTOR(0 to 2);
      s_axi_ufc_tx_tready : out STD_LOGIC;
      m_axi_ufc_rx_tdata  : out STD_LOGIC_VECTOR(0 to 31);
      m_axi_ufc_rx_tkeep  : out STD_LOGIC_VECTOR(0 to 3);
      m_axi_ufc_rx_tvalid : out STD_LOGIC;
      m_axi_ufc_rx_tlast  : out STD_LOGIC;
      rxp                 : in  STD_LOGIC;
      rxn                 : in  STD_LOGIC;
      txp                 : out STD_LOGIC;
      txn                 : out STD_LOGIC;
      gt_refclk1          : in  STD_LOGIC;
      frame_err           : out STD_LOGIC;
      hard_err            : out STD_LOGIC;
      soft_err            : out STD_LOGIC;
      lane_up             : out STD_LOGIC;
      channel_up          : out STD_LOGIC;
      user_clk_out        : out STD_LOGIC;
      sync_clk_out        : out STD_LOGIC;
      gt_reset            : in  STD_LOGIC;
      reset               : in  STD_LOGIC;
      sys_reset_out       : out STD_LOGIC;
      gt_reset_out        : out STD_LOGIC;
      power_down          : in  STD_LOGIC;
      loopback            : in  STD_LOGIC_VECTOR(2 downto 0);
      tx_lock             : out STD_LOGIC;
      init_clk_in         : in  STD_LOGIC;
      tx_resetdone_out    : out STD_LOGIC;
      rx_resetdone_out    : out STD_LOGIC;
      link_reset_out      : out STD_LOGIC;
      gt0_drpaddr         : in  STD_LOGIC_VECTOR(8 downto 0);
      gt0_drpdi           : in  STD_LOGIC_VECTOR(15 downto 0);
      gt0_drpdo           : out STD_LOGIC_VECTOR(15 downto 0);
      gt0_drpen           : in  STD_LOGIC;
      gt0_drprdy          : out STD_LOGIC;
      gt0_drpwe           : in  STD_LOGIC;
      gt_powergood        : out STD_LOGIC_VECTOR(0 to 0);
      pll_not_locked_out  : out STD_LOGIC);
  end component;

  -------------------------------------------------------------
  -- CLIP signals                                            --
  -------------------------------------------------------------
  signal MgtRefclk  : std_logic_vector(Qsfp1MgtRefClk_p'range);

  subtype Loopback_t is std_logic_vector(2 downto 0);
  type LoopbackAry_t is array(natural range <>) of Loopback_t;
  signal uLaneLoopback : LoopbackAry_t(kNumLanes-1 downto 0);
  -------------------------------------------------------------
  -- Vectorized signals to connect to Aurora core            --
  -------------------------------------------------------------
  signal PortRx_p : std_logic_vector(0 to 3);
  signal PortRx_n : std_logic_vector(0 to 3);
  signal PortTx_p : std_logic_vector(0 to 3);
  signal PortTx_n : std_logic_vector(0 to 3);

  -- SLVs for the single lane port signals on the cores.
  -- signal Port_hard_err, Port_soft_err, Port_channel_up : std_logic_vector(kNumPorts-1 downto 0);
  signal Lane_hard_err, Lane_soft_err, Lane_channel_up : std_logic_vector(kNumLanes-1 downto 0);

  signal Lane_lane_up, Lane_lane_up_rev : std_logic_vector(kNumLanes-1 downto 0);

  subtype AxiData_t is std_logic_vector(31 downto 0);
  type AxiDataAry_t is array(natural range <>) of AxiData_t;
  signal uLane_s_axi_tx_tdata : AxiDataAry_t(kNumLanes-1 downto 0);
  signal uLane_m_axi_rx_tdata : AxiDataAry_t(kNumLanes-1 downto 0);

  subtype AxiKeep_t is std_logic_vector(3 downto 0);
  type AxiKeepAry_t is array(natural range <>) of AxiKeep_t;
  signal uLane_s_axi_tx_tkeep, uLane_m_axi_rx_tkeep : AxiKeepAry_t(kNumLanes-1 downto 0);

  signal uLane_s_axi_tx_tlast, uLane_s_axi_tx_tvalid, uLane_s_axi_tx_tready : std_logic_vector(kNumLanes-1 downto 0);
  signal uLane_m_axi_rx_tlast, uLane_m_axi_rx_tvalid : std_logic_vector(kNumLanes-1 downto 0);

  signal Lane_user_clk : std_logic_vector(kNumLanes-1 downto 0);
  signal Lane_sys_reset_out, Lane_link_reset_out : std_logic_vector(kNumLanes-1 downto 0);

  signal frame_err        : std_logic_vector(kNumLanes-1 downto 0);
  signal gt_powergood     : std_logic_vector(kNumLanes-1 downto 0);

  signal ulane_s_axi_ufc_tx_tvalid : std_logic_vector(kNumLanes-1 downto 0);

  subtype UfcTxTdata_t is std_logic_vector(2 downto 0);
  type UfcTxTdataAry_t is array(natural range <>) of UfcTxTdata_t;
  signal ulane_s_axi_ufc_tx_tdata  : UfcTxTdataAry_t(kNumLanes-1 downto 0);
  signal ulane_s_axi_ufc_tx_tready : std_logic_vector(kNumLanes-1 downto 0);

  subtype UfcRxTdata_t is std_logic_vector(31 downto 0);
  type UfcRxTdataAry_t is array(natural range <>) of UfcRxTdata_t;
  signal ulane_m_axi_ufc_rx_tdata  : UfcRxTdataAry_t(kNumLanes-1 downto 0);

  subtype UfcRxTkeep_t is std_logic_vector(3 downto 0);
  type UfcRxTkeepAry_t is array(natural range <>) of UfcRxTkeep_t;

  signal ulane_m_axi_ufc_rx_tkeep  : UfcRxTkeepAry_t(kNumLanes-1 downto 0);
  signal ulane_m_axi_ufc_rx_tvalid : std_logic_vector(kNumLanes-1 downto 0);
  signal ulane_m_axi_ufc_rx_tlast  : std_logic_vector(kNumLanes-1 downto 0);
  signal InitClk : std_logic;

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

  -----------------------------------------------------------------------------
  -- MGT Reference Clocks
  -----------------------------------------------------------------------------
  -- Instantiate IBUFDS_GTE4 buffers on the reference clock pins.
  -- Depending on the application, the IP may already instantiate a buffer, so
  -- these buffers may be removed in this case.
  -- For this example, the design will take the refclk from Qsfp1MgtRefClk_p/n(0)

  IbufdsGen: for i in Qsfp1MgtRefClk_p'range generate

    --vhook_i IBUFDS_GTE3 IBUFDS_GTE3_inst0 hidegeneric=true
    --vhook_a I      Qsfp1MgtRefClk_p(i)
    --vhook_a IB     Qsfp1MgtRefClk_n(i)
    --vhook_a CEB    '0'
    --vhook_a O      MgtRefclk(i)
    --vhook_a ODIV2  open
    IBUFDS_GTE3_inst0: IBUFDS_GTE3
      port map (
        O     => MgtRefclk(i),         --out std_ulogic
        ODIV2 => open,                 --out std_ulogic
        CEB   => '0',                  --in  std_ulogic
        I     => Qsfp1MgtRefClk_p(i),  --in  std_ulogic
        IB    => Qsfp1MgtRefClk_n(i)); --in  std_ulogic

  end generate;

  -- On-board 80 MHz clock for use with CLIP interfacing signals
  InitClk <= Qsfp1SocketClk80;

  -----------------------------------------------------------------------------
  -- Debug Signals
  -----------------------------------------------------------------------------
  uLane0_HardError     <= Lane_hard_err     (0);
  uLane0_SoftError     <= Lane_soft_err     (0);
  uLane0_LaneUp        <= Lane_lane_up      (0);
  uLane0_ChannelUp     <= Lane_channel_up   (0);
  uLane0_sys_reset_out <= Lane_sys_reset_out(0);
  uLaneLoopback(0)     <= uLane0_Loopback;

  uLane1_HardError     <= Lane_hard_err     (1);
  uLane1_SoftError     <= Lane_soft_err     (1);
  uLane1_LaneUp        <= Lane_lane_up      (1);
  uLane1_ChannelUp     <= Lane_channel_up   (1);
  uLane1_sys_reset_out <= Lane_sys_reset_out(1);
  uLaneLoopback(1)     <= uLane1_Loopback;

  uLane2_HardError     <= Lane_hard_err     (2);
  uLane2_SoftError     <= Lane_soft_err     (2);
  uLane2_LaneUp        <= Lane_lane_up      (2);
  uLane2_ChannelUp     <= Lane_channel_up   (2);
  uLane2_sys_reset_out <= Lane_sys_reset_out(2);
  uLaneLoopback(2)     <= uLane2_Loopback;

  uLane3_HardError     <= Lane_hard_err     (3);
  uLane3_SoftError     <= Lane_soft_err     (3);
  uLane3_LaneUp        <= Lane_lane_up      (3);
  uLane3_ChannelUp     <= Lane_channel_up   (3);
  uLane3_sys_reset_out <= Lane_sys_reset_out(3);
  uLaneLoopback(3)     <= uLane3_Loopback;

  process(aResetSl, InitClk)
  begin
    if aResetSl = '1' then
      cLane0_link_reset_out       <= '1';
      cLane1_link_reset_out       <= '1';
      cLane2_link_reset_out       <= '1';
      cLane3_link_reset_out       <= '1';
    elsif rising_edge(InitClk) then
      cLane0_link_reset_out       <= Lane_link_reset_out (0) ;
      cLane1_link_reset_out       <= Lane_link_reset_out (1) ;
      cLane2_link_reset_out       <= Lane_link_reset_out (2) ;
      cLane3_link_reset_out       <= Lane_link_reset_out (3) ;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- MGT Port
  -----------------------------------------------------------------------------
  PortRx_p    (0 to 3)     <= reversi(Qsfp1MgtRx_p(3 downto 0));
  PortRx_n    (0 to 3)     <= reversi(Qsfp1MgtRx_n(3 downto 0));
  Qsfp1MgtTx_p(3 downto 0) <= reversi(PortTx_p   (0 to 3));
  Qsfp1MgtTx_n(3 downto 0) <= reversi(PortTx_n   (0 to 3));

  -----------------------------------------------------------------------------
  -- User Clock Interface
  -----------------------------------------------------------------------------
  UserClk0 <= Lane_user_clk(0);
  UserClk1 <= Lane_user_clk(1);
  UserClk2 <= Lane_user_clk(2);
  UserClk3 <= Lane_user_clk(3);

  -----------------------------------------------------------------------------
  -- AXI4-Lite Register Interface
  -----------------------------------------------------------------------------
  uLane_s_axi_tx_tdata(0) <= uLane0_s_axi_tx_tdata;
  uLane_s_axi_tx_tdata(1) <= uLane1_s_axi_tx_tdata;
  uLane_s_axi_tx_tdata(2) <= uLane2_s_axi_tx_tdata;
  uLane_s_axi_tx_tdata(3) <= uLane3_s_axi_tx_tdata;

  uLane_s_axi_tx_tkeep(0) <= uLane0_s_axi_tx_tkeep;
  uLane_s_axi_tx_tkeep(1) <= uLane1_s_axi_tx_tkeep;
  uLane_s_axi_tx_tkeep(2) <= uLane2_s_axi_tx_tkeep;
  uLane_s_axi_tx_tkeep(3) <= uLane3_s_axi_tx_tkeep;

  uLane_s_axi_tx_tlast(0) <= uLane0_s_axi_tx_tlast;
  uLane_s_axi_tx_tlast(1) <= uLane1_s_axi_tx_tlast;
  uLane_s_axi_tx_tlast(2) <= uLane2_s_axi_tx_tlast;
  uLane_s_axi_tx_tlast(3) <= uLane3_s_axi_tx_tlast;

  uLane_s_axi_tx_tvalid(0) <= uLane0_s_axi_tx_tvalid;
  uLane_s_axi_tx_tvalid(1) <= uLane1_s_axi_tx_tvalid;
  uLane_s_axi_tx_tvalid(2) <= uLane2_s_axi_tx_tvalid;
  uLane_s_axi_tx_tvalid(3) <= uLane3_s_axi_tx_tvalid;

  uLane0_s_axi_tx_tready <= uLane_s_axi_tx_tready(0);
  uLane1_s_axi_tx_tready <= uLane_s_axi_tx_tready(1);
  uLane2_s_axi_tx_tready <= uLane_s_axi_tx_tready(2);
  uLane3_s_axi_tx_tready <= uLane_s_axi_tx_tready(3);

  uLane0_m_axi_rx_tdata <= uLane_m_axi_rx_tdata(0);
  uLane1_m_axi_rx_tdata <= uLane_m_axi_rx_tdata(1);
  uLane2_m_axi_rx_tdata <= uLane_m_axi_rx_tdata(2);
  uLane3_m_axi_rx_tdata <= uLane_m_axi_rx_tdata(3);

  uLane0_m_axi_rx_tkeep <= uLane_m_axi_rx_tkeep(0);
  uLane1_m_axi_rx_tkeep <= uLane_m_axi_rx_tkeep(1);
  uLane2_m_axi_rx_tkeep <= uLane_m_axi_rx_tkeep(2);
  uLane3_m_axi_rx_tkeep <= uLane_m_axi_rx_tkeep(3);

  uLane0_m_axi_rx_tlast <= uLane_m_axi_rx_tlast(0);
  uLane1_m_axi_rx_tlast <= uLane_m_axi_rx_tlast(1);
  uLane2_m_axi_rx_tlast <= uLane_m_axi_rx_tlast(2);
  uLane3_m_axi_rx_tlast <= uLane_m_axi_rx_tlast(3);

  uLane0_m_axi_rx_tvalid <= uLane_m_axi_rx_tvalid(0);
  uLane1_m_axi_rx_tvalid <= uLane_m_axi_rx_tvalid(1);
  uLane2_m_axi_rx_tvalid <= uLane_m_axi_rx_tvalid(2);
  uLane3_m_axi_rx_tvalid <= uLane_m_axi_rx_tvalid(3);

  -----------------------------------------------------------------------------
  -- UFC Interface
  -----------------------------------------------------------------------------
  uLane_s_axi_ufc_tx_tvalid(0) <= uLane0_s_axi_ufc_tx_tvalid;
  uLane_s_axi_ufc_tx_tvalid(1) <= uLane1_s_axi_ufc_tx_tvalid;
  uLane_s_axi_ufc_tx_tvalid(2) <= uLane2_s_axi_ufc_tx_tvalid;
  uLane_s_axi_ufc_tx_tvalid(3) <= uLane3_s_axi_ufc_tx_tvalid;

  uLane_s_axi_ufc_tx_tdata(0)  <= uLane0_s_axi_ufc_tx_tdata;
  uLane_s_axi_ufc_tx_tdata(1)  <= uLane1_s_axi_ufc_tx_tdata;
  uLane_s_axi_ufc_tx_tdata(2)  <= uLane2_s_axi_ufc_tx_tdata;
  uLane_s_axi_ufc_tx_tdata(3)  <= uLane3_s_axi_ufc_tx_tdata;

  uLane0_s_axi_ufc_tx_tready <= uLane_s_axi_ufc_tx_tready(0);
  uLane1_s_axi_ufc_tx_tready <= uLane_s_axi_ufc_tx_tready(1);
  uLane2_s_axi_ufc_tx_tready <= uLane_s_axi_ufc_tx_tready(2);
  uLane3_s_axi_ufc_tx_tready <= uLane_s_axi_ufc_tx_tready(3);

  uLane0_m_axi_ufc_rx_tdata  <= uLane_m_axi_ufc_rx_tdata (0);
  uLane1_m_axi_ufc_rx_tdata  <= uLane_m_axi_ufc_rx_tdata (1);
  uLane2_m_axi_ufc_rx_tdata  <= uLane_m_axi_ufc_rx_tdata (2);
  uLane3_m_axi_ufc_rx_tdata  <= uLane_m_axi_ufc_rx_tdata (3);

  uLane0_m_axi_ufc_rx_tkeep  <= uLane_m_axi_ufc_rx_tkeep (0);
  uLane1_m_axi_ufc_rx_tkeep  <= uLane_m_axi_ufc_rx_tkeep (1);
  uLane2_m_axi_ufc_rx_tkeep  <= uLane_m_axi_ufc_rx_tkeep (2);
  uLane3_m_axi_ufc_rx_tkeep  <= uLane_m_axi_ufc_rx_tkeep (3);

  uLane0_m_axi_ufc_rx_tvalid <= uLane_m_axi_ufc_rx_tvalid(0);
  uLane1_m_axi_ufc_rx_tvalid <= uLane_m_axi_ufc_rx_tvalid(1);
  uLane2_m_axi_ufc_rx_tvalid <= uLane_m_axi_ufc_rx_tvalid(2);
  uLane3_m_axi_ufc_rx_tvalid <= uLane_m_axi_ufc_rx_tvalid(3);

  uLane0_m_axi_ufc_rx_tlast  <= uLane_m_axi_ufc_rx_tlast (0);
  uLane1_m_axi_ufc_rx_tlast  <= uLane_m_axi_ufc_rx_tlast (1);
  uLane2_m_axi_ufc_rx_tlast  <= uLane_m_axi_ufc_rx_tlast (2);
  uLane3_m_axi_ufc_rx_tlast  <= uLane_m_axi_ufc_rx_tlast (3);
  AuroraBlock : block
  begin
    Lane_lane_up <= Lane_lane_up_rev;

    GenAuroraLane : for j in 0 to kNumLanes-1 generate
      --vhook aurora_8b10b_DF Aurora_PortN
      --vhook_a s_axi_tx_tdata     uLane_s_axi_tx_tdata (j)
      --vhook_a s_axi_tx_tlast     uLane_s_axi_tx_tlast (j)
      --vhook_a s_axi_tx_tkeep     uLane_s_axi_tx_tkeep (j)
      --vhook_a s_axi_tx_tvalid    uLane_s_axi_tx_tvalid (j)
      --vhook_a s_axi_tx_tready    uLane_s_axi_tx_tready (j)
      --vhook_a m_axi_rx_tdata     uLane_m_axi_rx_tdata (j)
      --vhook_a m_axi_rx_tlast     uLane_m_axi_rx_tlast (j)
      --vhook_a m_axi_rx_tkeep     uLane_m_axi_rx_tkeep (j)
      --vhook_a m_axi_rx_tvalid    uLane_m_axi_rx_tvalid (j)
      --vhook_a s_axi_ufc_tx_tvalid uLane_s_axi_ufc_tx_tvalid(j)
      --vhook_a s_axi_ufc_tx_tdata  uLane_s_axi_ufc_tx_tdata (j)
      --vhook_a s_axi_ufc_tx_tready uLane_s_axi_ufc_tx_tready(j)
      --vhook_a m_axi_ufc_rx_tdata  uLane_m_axi_ufc_rx_tdata (j)
      --vhook_a m_axi_ufc_rx_tkeep  uLane_m_axi_ufc_rx_tkeep (j)
      --vhook_a m_axi_ufc_rx_tvalid uLane_m_axi_ufc_rx_tvalid(j)
      --vhook_a m_axi_ufc_rx_tlast  uLane_m_axi_ufc_rx_tlast (j)
      --vhook_a rxp                PortRx_p(j)
      --vhook_a rxn                PortRx_n(j)
      --vhook_a txp                PortTx_p(j)
      --vhook_a txn                PortTx_n(j)
      --vhook_a gt_refclk1         MgtRefclk(0)
      --vhook_a frame_err          frame_err(j)
      --vhook_a tx_lock            open
      --vhook_a tx_resetdone_out   open
      --vhook_a rx_resetdone_out   open
      --vhook_a gt_powergood       gt_powergood(j downto j)
      --vhook_a hard_err           Lane_hard_err(j)
      --vhook_a soft_err           Lane_soft_err(j)
      --vhook_a lane_up            Lane_lane_up_rev(j)
      --vhook_a channel_up         Lane_channel_up(j)
      --vhook_a init_clk_in        InitClk
      --vhook_a user_clk_out       Lane_user_clk(j)
      --vhook_a sync_clk_out       open
      --vhook_a power_down         '0'
      --vhook_a loopback           uLaneLoopback(j)
      --vhook_a link_reset_out     Lane_link_reset_out(j)
      --vhook_a sys_reset_out      Lane_sys_reset_out(j)
      --vhook_a gt_reset_out       open
      --vhook_a gt0_drpaddr        (others => '0')
      --vhook_a gt0_drpdi          (others => '0')
      --vhook_a gt0_drpdo          open
      --vhook_a gt0_drprdy         open
      --vhook_a gt0_drpen          '0'
      --vhook_a gt0_drpwe          '0'
      --vhook_a gt_reset           aInitClkReset
      --vhook_a reset              aUserClkReset
      --vhook_a pll_not_locked_out open
      Aurora_PortN: aurora_8b10b_DF
        port map (
          s_axi_tx_tdata      => uLane_s_axi_tx_tdata (j),      --in  STD_LOGIC_VECTOR(0:31)
          s_axi_tx_tkeep      => uLane_s_axi_tx_tkeep (j),      --in  STD_LOGIC_VECTOR(0:3)
          s_axi_tx_tvalid     => uLane_s_axi_tx_tvalid (j),     --in  STD_LOGIC
          s_axi_tx_tlast      => uLane_s_axi_tx_tlast (j),      --in  STD_LOGIC
          s_axi_tx_tready     => uLane_s_axi_tx_tready (j),     --out STD_LOGIC
          m_axi_rx_tdata      => uLane_m_axi_rx_tdata (j),      --out STD_LOGIC_VECTOR(0:31)
          m_axi_rx_tkeep      => uLane_m_axi_rx_tkeep (j),      --out STD_LOGIC_VECTOR(0:3)
          m_axi_rx_tvalid     => uLane_m_axi_rx_tvalid (j),     --out STD_LOGIC
          m_axi_rx_tlast      => uLane_m_axi_rx_tlast (j),      --out STD_LOGIC
          s_axi_ufc_tx_tvalid => uLane_s_axi_ufc_tx_tvalid(j),  --in  STD_LOGIC
          s_axi_ufc_tx_tdata  => uLane_s_axi_ufc_tx_tdata (j),  --in  STD_LOGIC_VECTOR(0:2)
          s_axi_ufc_tx_tready => uLane_s_axi_ufc_tx_tready(j),  --out STD_LOGIC
          m_axi_ufc_rx_tdata  => uLane_m_axi_ufc_rx_tdata (j),  --out STD_LOGIC_VECTOR(0:31)
          m_axi_ufc_rx_tkeep  => uLane_m_axi_ufc_rx_tkeep (j),  --out STD_LOGIC_VECTOR(0:3)
          m_axi_ufc_rx_tvalid => uLane_m_axi_ufc_rx_tvalid(j),  --out STD_LOGIC
          m_axi_ufc_rx_tlast  => uLane_m_axi_ufc_rx_tlast (j),  --out STD_LOGIC
          rxp                 => PortRx_p(j),                   --in  STD_LOGIC
          rxn                 => PortRx_n(j),                   --in  STD_LOGIC
          txp                 => PortTx_p(j),                   --out STD_LOGIC
          txn                 => PortTx_n(j),                   --out STD_LOGIC
          gt_refclk1          => MgtRefclk(0),                  --in  STD_LOGIC
          frame_err           => frame_err(j),                  --out STD_LOGIC
          hard_err            => Lane_hard_err(j),              --out STD_LOGIC
          soft_err            => Lane_soft_err(j),              --out STD_LOGIC
          lane_up             => Lane_lane_up_rev(j),           --out STD_LOGIC
          channel_up          => Lane_channel_up(j),            --out STD_LOGIC
          user_clk_out        => Lane_user_clk(j),              --out STD_LOGIC
          sync_clk_out        => open,                          --out STD_LOGIC
          gt_reset            => aInitClkReset,                 --in  STD_LOGIC
          reset               => aUserClkReset,                 --in  STD_LOGIC
          sys_reset_out       => Lane_sys_reset_out(j),         --out STD_LOGIC
          gt_reset_out        => open,                          --out STD_LOGIC
          power_down          => '0',                           --in  STD_LOGIC
          loopback            => uLaneLoopback(j),              --in  STD_LOGIC_VECTOR(2:0)
          tx_lock             => open,                          --out STD_LOGIC
          init_clk_in         => InitClk,                       --in  STD_LOGIC
          tx_resetdone_out    => open,                          --out STD_LOGIC
          rx_resetdone_out    => open,                          --out STD_LOGIC
          link_reset_out      => Lane_link_reset_out(j),        --out STD_LOGIC
          gt0_drpaddr         => (others => '0'),               --in  STD_LOGIC_VECTOR(8:0)
          gt0_drpdi           => (others => '0'),               --in  STD_LOGIC_VECTOR(15:0)
          gt0_drpdo           => open,                          --out STD_LOGIC_VECTOR(15:0)
          gt0_drpen           => '0',                           --in  STD_LOGIC
          gt0_drprdy          => open,                          --out STD_LOGIC
          gt0_drpwe           => '0',                           --in  STD_LOGIC
          gt_powergood        => gt_powergood(j downto j),      --out STD_LOGIC_VECTOR(0:0)
          pll_not_locked_out  => open);                         --out STD_LOGIC
    end generate;

  end block AuroraBlock;
end rtl;
