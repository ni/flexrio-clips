-------------------------------------------------------------------------------
--
-- File: UserRTL_PXIe7903_ClipTemplate.vhd
-- Author: National Instruments
-- Original Project: PXIe-7903 HSS
-- Date: 02 June 2022
--
-------------------------------------------------------------------------------
-- (c) 2022 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This template is intended to be used as an example to create a custom 7903
-- I/O module CLIP. It includes the logic that is required for the 7903 to operate.
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
-- The required diagram signals are status signals that are common to any 7903
-- CLIP. These are exposed in the LabVIEW FPGA diagram and should be connected
-- to an indicator for use by the driver. See the 7903 LabVIEW examples for
-- more information on how to do this.
--
-- The user diagram signals are signals specific to the CLIP's IP. When you
-- change these signals, the CLIP XML must be updated to reflect these changes.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFlexRioTargetConfig.all;

library unisim;
  use unisim.vcomponents.all;

entity UserRTL_PXIe7903_ClipTemplate is
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
    -- Configuration
    aLmkI2cSda          : inout std_logic;
    aLmkI2cScl          : inout std_logic;
    aLmk1Pdn_n          : out std_logic;
    aLmk2Pdn_n          : out std_logic;
    aLmk1Gpio0          : out std_logic;
    aLmk2Gpio0          : out std_logic;
    aLmk1Status0        : in std_logic;
    aLmk1Status1        : in std_logic;
    aLmk2Status0        : in std_logic;
    aLmk2Status1        : in std_logic;
    aIPassPrsnt_n       : in std_logic_vector(7 downto 0);
    aIPassIntr_n        : in std_logic_vector(7 downto 0);
    aIPassSCL           : inout std_logic_vector(11 downto 0);
    aIPassSDA           : inout std_logic_vector(11 downto 0);
    aPortExpReset_n     : out std_logic;
    aPortExpIntr_n      : in std_logic;
    aPortExpSda         : inout std_logic;
    aPortExpScl         : inout std_logic;
    aIPassVccPowerFault_n : in std_logic;

    -- Reserved Interfaces
    stIoModuleSupportsFRAGLs : out std_logic;

    ------------------------------
    -- DIO Signals              --
    ------------------------------
    aDio : inout std_logic_vector(7 downto 0);

    ----------------------------------
    -- AXI Communication Interfaces --
    ----------------------------------
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
    --vhook_nowarn xClipAxi4LiteInterrupt

    ------------------------------
    -- MGT Socket Interface     --
    ------------------------------
    -- These signals connect directly to the MGT pins, and should be connected to the
    -- user's IP.
    MgtRefClk_p : in  std_logic_vector(11 downto 0);
    MgtRefClk_n : in  std_logic_vector(11 downto 0);
    MgtPortRx_p : in  std_logic_vector(47 downto 0);
    MgtPortRx_n : in  std_logic_vector(47 downto 0);
    MgtPortTx_p : out std_logic_vector(47 downto 0);
    MgtPortTx_n : out std_logic_vector(47 downto 0);

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
    -- DIO
    aDioOut : in  std_logic_vector(7 downto 0);
    aDioIn  : out std_logic_vector(7 downto 0);

    ------------------------------
    -- USER Diagram Signals     --
    ------------------------------
    -- These signals may be modified to meet the requirements of the CLIP.
    -- If the ports are modified, the CLIP XML file must be updated to
    -- reflect the port map.
    MgtRefClk0     : out std_logic;
    MgtRefClk1     : out std_logic;
    MgtRefClk2     : out std_logic;
    MgtRefClk3     : out std_logic;
    MgtRefClk4     : out std_logic;
    MgtRefClk5     : out std_logic;
    MgtRefClk6     : out std_logic;
    MgtRefClk7     : out std_logic;
    MgtRefClk8     : out std_logic;
    MgtRefClk9     : out std_logic;
    MgtRefClk10    : out std_logic;
    MgtRefClk11    : out std_logic
  );
end UserRTL_PXIe7903_ClipTemplate;

architecture rtl of UserRTL_PXIe7903_ClipTemplate is

  --vhook_sigstart
  --vhook_sigend

  --vhook_d SasquatchClipFixedLogic
  component SasquatchClipFixedLogic
    port (
      AxiClk                          : in  std_logic;
      aDiagramReset                   : in  std_logic;
      aLmkI2cSda                      : inout std_logic;
      aLmkI2cScl                      : inout std_logic;
      aLmk1Pdn_n                      : out std_logic;
      aLmk2Pdn_n                      : out std_logic;
      aLmk1Gpio0                      : out std_logic;
      aLmk2Gpio0                      : out std_logic;
      aLmk1Status0                    : in  std_logic;
      aLmk1Status1                    : in  std_logic;
      aLmk2Status0                    : in  std_logic;
      aLmk2Status1                    : in  std_logic;
      aIPassPrsnt_n                   : in  std_logic_vector(7 downto 0);
      aIPassIntr_n                    : in  std_logic_vector(7 downto 0);
      aIPassSCL                       : inout std_logic_vector(11 downto 0);
      aIPassSDA                       : inout std_logic_vector(11 downto 0);
      aPortExpReset_n                 : out std_logic;
      aPortExpIntr_n                  : in  std_logic;
      aPortExpSda                     : inout std_logic;
      aPortExpScl                     : inout std_logic;
      stIoModuleSupportsFRAGLs        : out std_logic;
      xIoModuleReady                  : out std_logic;
      xIoModuleErrorCode              : out std_logic_vector(31 downto 0);
      xMgtRefClkEnabled               : out std_logic_vector(11 downto 0);
      aDioOutEn                       : out std_logic_vector(7 downto 0);
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
  signal xMgtRefClkEnabled : std_logic_vector(11 downto 0);
  signal aDioOutEn         : std_logic_vector(7 downto 0);
  signal IoModMgtRefclk    : std_logic_vector(MgtRefClk_p'range);
  signal IoModMgtRefclkDiv : std_logic_vector(MgtRefClk_p'range);

  -------------------------------------------------------------
  -- USER CLIP signals                                       --
  -------------------------------------------------------------
  signal MgtRefClkArray : std_logic_vector(MgtRefClk_p'range);

begin
  -----------------------------
  -- 7903 Required Logic--
  -----------------------------
  -- !!! WARNING !!!
  -- Do not change this logic. Doing so may cause the CLIP to stop functioning.

  -- Configuration Netlist --
  --vhook SasquatchClipFixedLogic
  --vhook_a xIoModuleReady xIoModuleReadyLcl
  --vhook_a aDiagramReset  aResetSl
  SasquatchClipFixedLogicx: SasquatchClipFixedLogic
    port map (
      AxiClk                          => AxiClk,                           --in  std_logic
      aDiagramReset                   => aResetSl,                         --in  std_logic
      aLmkI2cSda                      => aLmkI2cSda,                       --inout std_logic
      aLmkI2cScl                      => aLmkI2cScl,                       --inout std_logic
      aLmk1Pdn_n                      => aLmk1Pdn_n,                       --out std_logic
      aLmk2Pdn_n                      => aLmk2Pdn_n,                       --out std_logic
      aLmk1Gpio0                      => aLmk1Gpio0,                       --out std_logic
      aLmk2Gpio0                      => aLmk2Gpio0,                       --out std_logic
      aLmk1Status0                    => aLmk1Status0,                     --in  std_logic
      aLmk1Status1                    => aLmk1Status1,                     --in  std_logic
      aLmk2Status0                    => aLmk2Status0,                     --in  std_logic
      aLmk2Status1                    => aLmk2Status1,                     --in  std_logic
      aIPassPrsnt_n                   => aIPassPrsnt_n,                    --in  std_logic_vector(7:0)
      aIPassIntr_n                    => aIPassIntr_n,                     --in  std_logic_vector(7:0)
      aIPassSCL                       => aIPassSCL,                        --inout std_logic_vector(11:0)
      aIPassSDA                       => aIPassSDA,                        --inout std_logic_vector(11:0)
      aPortExpReset_n                 => aPortExpReset_n,                  --out std_logic
      aPortExpIntr_n                  => aPortExpIntr_n,                   --in  std_logic
      aPortExpSda                     => aPortExpSda,                      --inout std_logic
      aPortExpScl                     => aPortExpScl,                      --inout std_logic
      stIoModuleSupportsFRAGLs        => stIoModuleSupportsFRAGLs,         --out std_logic
      xIoModuleReady                  => xIoModuleReadyLcl,                --out std_logic
      xIoModuleErrorCode              => xIoModuleErrorCode,               --out std_logic_vector(31:0)
      xMgtRefClkEnabled               => xMgtRefClkEnabled,                --out std_logic_vector(11:0)
      aDioOutEn                       => aDioOutEn,                        --out std_logic_vector(7:0)
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

  GenDioBuffers: for i in aDio'range generate
    aDio(i) <= aDioOut(i) when aDioOutEn(i) = '1' else 'Z';
  end generate GenDioBuffers;
  aDioIn <= aDio;

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

  -----------------------------------------------------------------------------
  -- User Logic
  -----------------------------------------------------------------------------
  -- ADD YOUR LOGIC HERE

  -- Instantiate BUFG_GTs to pass the reference clocks back to LabVIEW. To prevent
  -- glitchy clocks from passing back through to LabVIEW while clocks are getting
  -- reconfigured, gate this clock using xMgtRefClkEnabled.
  -- These clocks are divided by 2, so a 200MHz reference clock will show up to
  -- LabVIEW as a 100MHz clock
  BufgGen: for i in MgtRefClk_p'range generate

    --vhook_i BUFG_GT BUFGx
    --vhook_g SIM_DEVICE "ULTRASCALE_PLUS"
    --vhook_g STARTUP_SYNC "FALSE"
    --vhook_a O       MgtRefClkArray(i)
    --vhook_a CE      xMgtRefClkEnabled(i)
    --vhook_a CEMASK  '0'
    --vhook_a CLR     '0'
    --vhook_a CLRMASK '1'
    --vhook_a DIV     "001"
    --vhook_a I       IoModMgtRefclkDiv(i)
    BUFGx: BUFG_GT
      generic map (
        SIM_DEVICE   => "ULTRASCALE_PLUS",  --string:="ULTRASCALE"
        STARTUP_SYNC => "FALSE")            --string:="FALSE"
      port map (
        O       => MgtRefClkArray(i),     --out std_ulogic
        CE      => xMgtRefClkEnabled(i),  --in  std_ulogic
        CEMASK  => '0',                   --in  std_ulogic
        CLR     => '0',                   --in  std_ulogic
        CLRMASK => '1',                   --in  std_ulogic
        DIV     => "001",                 --in  std_logic_vector(2:0)
        I       => IoModMgtRefclkDiv(i)); --in  std_ulogic

  end generate;

  MgtRefClk0  <= MgtRefClkArray(0);
  MgtRefClk1  <= MgtRefClkArray(1);
  MgtRefClk2  <= MgtRefClkArray(2);
  MgtRefClk3  <= MgtRefClkArray(3);
  MgtRefClk4  <= MgtRefClkArray(4);
  MgtRefClk5  <= MgtRefClkArray(5);
  MgtRefClk6  <= MgtRefClkArray(6);
  MgtRefClk7  <= MgtRefClkArray(7);
  MgtRefClk8  <= MgtRefClkArray(8);
  MgtRefClk9  <= MgtRefClkArray(9);
  MgtRefClk10 <= MgtRefClkArray(10);
  MgtRefClk11 <= MgtRefClkArray(11);

end rtl;
