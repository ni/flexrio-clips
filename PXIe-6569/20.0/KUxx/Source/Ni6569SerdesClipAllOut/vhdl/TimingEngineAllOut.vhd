-------------------------------------------------------------------------------
--
-- File: TimingEngineAllOut.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 13 December 2019
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
-- Purpose: This file generates the clocks required by LVFPGA and the CLIP.
--  All of the controls/status signals are accessed via the BaRegPort.
--
--  Clock Summary:
--    LmkClk         - This clock is sourced by the LMK4832.  Its default frequency is 156.25MHz
--                     It is present once the LMK04832 is configured.  This clock is fed into one of the MMCM CLKIN
--                     inputs to generate TxDataClk, OSerdesClk and OSerdesClkDiv.
--    SiClk          - This clock is sourced by the Si514.  Its default frequency is 156.25MHz
--                     It is present once the Si514 is configured. This clock is fed into one of the MMCM CLKIN
--                     inputs to generate TxDataClk, OSerdesClk and OSerdesClkDiv.
--    TxDataClk      - This clock is generated from an MMCM output to provide the data generation clock for LabVIEW.
--    OSerdesClk     - This clock is generated from an MMCM to provide the fast clock to the OSERDES component.
--    OSerdesClkDiv  - This clock is generated from MMCM to provide the slow clock to the OSERDES and ODELAY components.
--    DelayRefClk    - This clock is generated from a PLL, sourced by a reliable clock, to provide the clock for
--                     the IDELAYCTRL component
--    SeRegisterClk  - This clock is generated from a PLL to sample the direction control for single
--                     ended signals to avoid double driving bidirectional IOs.
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
  use work.PkgTimingEngine.all;
  use work.PkgSRegPort.all;

entity TimingEngineAllOut is
  port (
    -------------------
    -- Clocks/resets --
    -------------------
    BusClk                    : in  std_logic;
    bAxiPeriphReset_n         : in  std_logic;
    aDelayCtrlRdy             : in std_logic;

    ---------
    -- AXI --
    ---------
    bAxiWriteAddressChannel   : in  Axi4LiteAddressChannel_t;
    bAxiWriteAddressReady     : out boolean;
    bAxiWriteDataChannel      : in  Axi4LiteWriteDataChannel_t;
    bAxiWriteDataReady        : out boolean;
    bAxiWriteResponseChannel  : out Axi4LiteWriteResponseChannel_t;
    bAxiWriteResponseReady    : in  boolean;
    bAxiReadAddressChannel    : in  Axi4LiteAddressChannel_t;
    bAxiReadAddressReady      : out boolean;
    bAxiReadDataChannel       : out Axi4LiteReadDataChannel_t;
    bAxiReadDataReady         : in  boolean;

    ----------------
    -- PLL Clocks --
    ----------------
    SiClk                     : in  std_logic;
    LmkClk                    : in  std_logic;
    TxDataClk                 : out std_logic;
    OSerdesClkDiv             : out std_logic;
    OSerdesClk                : out std_logic;
    DelayRefClk               : out std_logic;
    SeRegisterClk             : out std_logic;

    -------------------------------------------------------------------------------
    -- DRP interface to GT core, names are w.r.t. the GT core
    -------------------------------------------------------------------------------
    DrpClk      : in  std_logic;
    dDrpAddr    : in  std_logic_vector(6 downto 0);
    dDrpDataIn  : in  std_logic_vector(15 downto 0);
    dDrpDataOut : out std_logic_vector(15 downto 0);
    dDrpEn      : in  std_logic;
    dDrpWe      : in  std_logic;
    dDrpRdy     : out std_logic;

    ----------------
    -- LV Control --
    ----------------
    aDiagramClkEnable         : in  std_logic
  );

end TimingEngineAllOut;

architecture RTL of TimingEngineAllOut is

   --vhook_sigstart
   signal aMmcmLockedLcl: std_ulogic;
   signal aPllLockedLcl: std_ulogic;
   signal bDelayCtrlRdy: std_logic;
   signal bDiagramClkEnable: std_logic;
   signal bMmcmLocked: std_logic;
   signal bPllLocked: std_logic;
   signal bSRegPortIn: SRegPortIn_t;
   signal bSRegPortOut: SRegPortOut_t;
   signal dDelayCtrlEnable: boolean;
   signal DelayRefClkLcl: std_ulogic;
   signal MmcmClkFbIn: std_ulogic;
   signal MmcmClkFbOut: std_ulogic;
   signal PllClkFbIn: std_ulogic;
   signal PllClkFbOut: std_ulogic;
   signal SeRegisterClkLcl: std_ulogic;
   signal sSeDirectionEnable: boolean;
   signal tcClkOutEn: boolean;
   signal tClkOutEn: boolean;
   signal tsTxBufClr: boolean;
   signal TxDataClkCopy: std_ulogic;
   signal TxDataClkCopyLcl: std_ulogic;
   signal TxDataClkLcl: std_ulogic;
   signal TxSampleClk: std_ulogic;
   signal TxSampleClkLcl: std_ulogic;
  --vhook_sigend

  constant kTxClkEnCountLength   : natural := 3;
  signal tsTxClkEnCount          : natural range 0 to kTxClkEnCountLength := kTxClkEnCountLength;
  signal tsTxBufgceCeLcl         : std_logic := '0';
  signal tsTxBufgceCe            : std_logic := '0';
  signal tsTxBufgceClrLcl        : std_logic := '1';
  signal tsTxBufgceClr           : std_logic := '1';
  signal tsTxClkEnCountEnabled   : boolean := false;
  signal tsDataClkDlydRisingEdge : std_logic := '0';
  signal tsDataClkToggle         : std_logic := '0';
  signal tsDataClkToggleDlyd     : std_logic := '0';
  signal tTxDataClkToggle        : std_logic := '0';
  signal tTxDataClkToggleDlyd    : std_logic := '0';

  signal bMmcmReset              : std_logic := '1';
  signal bPllReset               : std_logic := '1';
  signal bMmcmUnlockedSticky     : std_logic := '0';
  signal bPllUnlockedSticky      : std_logic := '0';
  signal bGateClock              : std_logic := '1';
  signal bRstClkSyncLogic        : std_logic := '1';
  signal bTxClkInSelection       : std_logic := '0';

  attribute DONT_TOUCH: string;
  attribute DONT_TOUCH of DataClockTx     : label is "TRUE";
  attribute DONT_TOUCH of OSerdesClockDiv : label is "TRUE";
  attribute DONT_TOUCH of OSerdesClock    : label is "TRUE";

begin

  --vhook_e DoubleSyncSlAsyncIn IDelayControlReadyDS
  --vhook_g kResetVal '0'
  --vhook_a aoReset false
  --vhook_a OClk BusClk
  --vhook_a aSig aDelayCtrlRdy
  --vhook_a oSig bDelayCtrlRdy
  IDelayControlReadyDS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aDelayCtrlRdy,  --in  std_logic
      aoReset => false,          --in  boolean
      OClk    => BusClk,         --in  std_logic
      oSig    => bDelayCtrlRdy); --out std_logic

  --vhook_e Axi4LiteCore
  --vhook_a kAddressSpaceLog2 6
  --vhook_a aAxiPeriphReset std_logic'('0')
  Axi4LiteCorex: entity work.Axi4LiteCore (rtl)
    generic map (kAddressSpaceLog2 => 6)  --positive:=12
    port map (
      aAxiPeriphReset          => std_logic'('0'),           --in  std_logic
      bAxiPeriphReset_n        => bAxiPeriphReset_n,         --in  std_logic
      BusClk                   => BusClk,                    --in  std_logic
      bAxiWriteAddressChannel  => bAxiWriteAddressChannel,   --in  Axi4LiteAddressChannel_t
      bAxiWriteAddressReady    => bAxiWriteAddressReady,     --out boolean
      bAxiWriteDataChannel     => bAxiWriteDataChannel,      --in  Axi4LiteWriteDataChannel_t
      bAxiWriteDataReady       => bAxiWriteDataReady,        --out boolean
      bAxiWriteResponseChannel => bAxiWriteResponseChannel,  --out Axi4LiteWriteResponseChannel_t
      bAxiWriteResponseReady   => bAxiWriteResponseReady,    --in  boolean
      bAxiReadAddressChannel   => bAxiReadAddressChannel,    --in  Axi4LiteAddressChannel_t
      bAxiReadAddressReady     => bAxiReadAddressReady,      --out boolean
      bAxiReadDataChannel      => bAxiReadDataChannel,       --out Axi4LiteReadDataChannel_t
      bAxiReadDataReady        => bAxiReadDataReady,         --in  boolean
      bSRegPortIn              => bSRegPortIn,               --out SRegPortIn_t
      bSRegPortOut             => bSRegPortOut);             --in  SRegPortOut_t

  AxiRegisterWrite: process (BusClk) is
    variable TempData : Axi4LiteData_t := (others => '0');
  begin
    if rising_edge(BusClk) then

      if bAxiPeriphReset_n = '0' then
        bMmcmReset <= '1';
        bPllReset  <= '1';
        bGateClock <= '1';
        bRstClkSyncLogic <= '1';
        bMmcmUnlockedSticky <= '0';
        bPllUnlockedSticky <= '0';
        bTxClkInSelection <= '0';
      else
        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="MMCM" offset="0x00">
        --    <register name="MmcmControl" size="32" offset="0x0" attributes="Writable">
        --      <bitfield name="SetMmcmReset" range="0" attributes="strobe">
        --        <info>Puts the MMCM in reset. The FPGA MMCM must be reset on power-up
        --              or if its lock signal is lost.
        --         </info>
        --      </bitfield>
        --      <bitfield name="ClearMmcmReset" range="1" attributes="strobe">
        --        <info>Removes the FPGA MMCM reset.
        --        </info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kMmcmControlRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bMmcmReset <= (bMmcmReset or TempData(kSetMmcmReset)) and not TempData(kClearMmcmReset);

        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="MMCM" offset="0x00">
        --    <register name="PllControl" size="32" offset="0x4" attributes="Writable">
        --      <bitfield name="SetPllReset" range="0" attributes="strobe">
        --        <info>Puts the FPGA PLL in reset. The FPGA PLL reset must be asserted
        --              on power-up, when the PLL lock is lost.
        --        </info>
        --      </bitfield>
        --      <bitfield name="ClearPllReset" range="1" attributes="strobe">
        --        <info>Removes the reset from the FPGA PLL.
        --        </info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kPllControlRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bPllReset <= (bPllReset or TempData(kSetPllReset)) and not TempData(kClearPllReset);

        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="ClockEnables" offset="0x20">
        --    <register name="ClockControl" size="32" offset="0x0" attributes="Writable">
        --      <bitfield name="SetClockGate" range="0" attributes="strobe">
        --        <info>Gate the data clocks to the FPGA diagram.</info>
        --      </bitfield>
        --      <bitfield name="ClearClockGate" range="1" attributes="strobe">
        --        <info>Enables the data clocks to the FPGA diagram. This signal
        --              shall only be deasserted after the MMCM/PLL are locked and LV clock
        --              enable signal (LvClockEn) is asserted.
        --        </info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kClockControlRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bGateClock <= (bGateClock or TempData(kSetClockGate)) and not TempData(kClearClockGate);

        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="ClockEnables" offset="0x20">
        --    <register name="ResetClockSyncLogic" size="32" offset="0x8" attributes="Writable">
        --      <bitfield name="SetClockSyncLogicReset" range="0" attributes="strobe">
        --        <info>Puts resets on logics that control CLR and CE assertion/deassertion
        --              on OSERDESCLK and OSERDESCLKDIV buffers.
        --              The assertion is before disable the data clock.
        --        </info>
        --      </bitfield>
        --      <bitfield name="ClearClockSyncLogicReset" range="1" attributes="strobe">
        --        <info>Removes the reset after enable the data clock.</info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kResetClockSyncLogicRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bRstClkSyncLogic <= (bRstClkSyncLogic or TempData(kSetClockSyncLogicReset)) and not TempData(kClearClockSyncLogicReset);

        TempData := SRegWriteData (
          RegInfo    => kMmcmStatusRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bMmcmUnlockedSticky <= (bMmcmUnlockedSticky or not bMmcmLocked) and not TempData(kMmcmUnlockedSticky);

        TempData := SRegWriteData (
          RegInfo    => kPllStatusRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bPllUnlockedSticky <= (bPllUnlockedSticky or not bPllLocked) and not TempData(kPllUnlockedSticky);

        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="MMCM">
        --    <register name="ClkInSelection" size="32" offset="0x10" attributes="Writable">
        --      <bitfield name="SetClkInSelection" range="0" attributes="strobe">
        --        <info>Set '0' to select from LMK4832 Device Clock.  Set '1' to select from Si514 Sample Clock
        --         </info>
        --      </bitfield>
        --      <bitfield name="ClearClkInSelection" range="1" attributes="strobe">
        --        <info>Clear this selection and choose default value as LMK4832 Device Clock
        --        </info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kClkInSelectionRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bTxClkInSelection <= (bTxClkInSelection or TempData(kSetClkInSelection)) and not TempData(kClearClkInSelection);

      end if;
    end if;
  end process;

  AxiReadCombinatorial: process (bMmcmLocked,bMmcmUnlockedSticky,bPllLocked,bPllUnlockedSticky,bDiagramClkEnable,bDelayCtrlRdy,bSRegPortIn) is
    variable RegData : Axi4LiteData_t := (others => '0');
  begin
    RegData := (others => '0');
    --xmlparse xml_on
    --<regmap name="TimingEngine">
    --  <group name="MMCM">
    --    <register name="MmcmStatus" size="32" offset="0x8" attributes="Readable|Writable">
    --      <bitfield name="MmcmLocked" range="0" writable="false">
    --        <info>Reads '1' if the FPGA MMCM is locked.
    --        </info>
    --      </bitfield>
    --      <bitfield name="MmcmUnlockedSticky" range="1" clearable="true">
    --        <info>Asserts if the value of MmcmLocked is ever '0'. Resets to '1', so it must cleared
    --          every time the timing engine is reset</info>
    --      </bitfield>
    --    </register>
    --  </group>
    --</regmap >
    --xmlparse xml_off
    RegData := RegData or SRegReadData(
      RegInfo      => kMmcmStatusRec,
      RegReadValue => SetBit(kMmcmLocked, bMmcmLocked) or
                      SetBit(kMmcmUnlockedSticky, bMmcmUnlockedSticky),
      SRegPortIn   => bSRegPortIn);

    --xmlparse xml_on
    --<regmap name="TimingEngine">
    --  <group name="MMCM">
    --    <register name="PllStatus" size="32" offset="0xC" attributes="Readable|Writable">
    --      <bitfield name="PllLocked" range="0" writable="false">
    --        <info>Reads 1 if the FPGA PLL is locked.
    --        </info>
    --      </bitfield>
    --      <bitfield name="PllUnlockedSticky" range="1" clearable="true">
    --        <info>Asserts if the value of PllLocked  is ever '0'. Resets to '1', so it must cleared
    --          every time the timing engine is reset</info>
    --      </bitfield>
    --    </register>
    --  </group>
    --</regmap >
    --xmlparse xml_off
    RegData := RegData or SRegReadData(
      RegInfo      => kPllStatusRec,
      RegReadValue => SetBit(kPllLocked, bPllLocked) or
                      SetBit(kPllUnlockedSticky, bPllUnlockedSticky),
      SRegPortIn   => bSRegPortIn);

    --xmlparse xml_on
    --<regmap name="TimingEngine">
    --  <group name="ClockEnables">
    --    <register name="ClkStatus" size="32" offset="0x10" attributes="Readable">
    --      <bitfield name="LvClockEnable" range="0">
    --        <info>Reads 1 if it is safe to enable the clocks.</info>
    --      </bitfield>
    --      <bitfield name="IdelayCtrlReady" range="1">
    --        <info>Reads 1 if the IDelayCtrlReady is asserted.</info>
    --      </bitfield>
    --    </register>
    --  </group>
    --</regmap >
    --xmlparse xml_off
    RegData := RegData or SRegReadData(
      RegInfo      => kClkStatusRec,
      RegReadValue => SetBit(kLvClockEnable, bDiagramClkEnable) or
                      SetBit(kIdelayCtrlReady, bDelayCtrlRdy),
      SRegPortIn   => bSRegPortIn);

    bSRegPortOut <= RegData;

  end process;

    ----------------------------------------------------------------------------------------
    -- Clocking
    ----------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------
    -- MMCM
    ----------------------------------------------------------------------------------------

    --vhook_i MMCME3_ADV            TxMmcm
    --vhook_g BANDWIDTH             "HIGH"
    --vhook_g CLKFBOUT_MULT_F       8.00
    --vhook_g CLKFBOUT_PHASE        00.0
    --vhook_g CLKFBOUT_USE_FINE_PS  "FALSE"
    --vhook_g CLKIN1_PERIOD         6.4
    --vhook_g CLKIN2_PERIOD         6.4
    --vhook_g CLKOUT0_DIVIDE_F      2.0
    --vhook_g CLKOUT1_DIVIDE        8
    --vhook_g CLKOUT2_DIVIDE        8
    --vhook_g CLKOUT3_DIVIDE        2
    --vhook_g CLKOUT4_DIVIDE        2
    --vhook_g CLKOUT5_DIVIDE        2
    --vhook_g CLKOUT6_DIVIDE        8
    --vhook_g CLKOUT0_PHASE         0.0
    --vhook_g CLKOUT1_PHASE         0.0
    --vhook_g CLKOUT2_PHASE         0.0
    --vhook_g CLKOUT3_PHASE         0.0
    --vhook_g CLKOUT4_PHASE         0.0
    --vhook_g CLKOUT5_PHASE         0.0
    --vhook_g CLKOUT6_PHASE         0.0
    --vhook_g CLKOUT0_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT1_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT2_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT3_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT4_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT5_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT6_USE_FINE_PS   "FALSE"
    --vhook_g CLKOUT0_DUTY_CYCLE    0.500
    --vhook_g CLKOUT1_DUTY_CYCLE    0.500
    --vhook_g CLKOUT2_DUTY_CYCLE    0.500
    --vhook_g CLKOUT3_DUTY_CYCLE    0.500
    --vhook_g CLKOUT4_DUTY_CYCLE    0.500
    --vhook_g CLKOUT5_DUTY_CYCLE    0.500
    --vhook_g CLKOUT6_DUTY_CYCLE    0.500
    --vhook_g CLKOUT4_CASCADE       "FALSE"
    --vhook_g COMPENSATION          "AUTO"
    --vhook_g DIVCLK_DIVIDE         1
    --vhook_g REF_JITTER1           0.010000
    --vhook_g REF_JITTER2           0.010000
    --vhook_g STARTUP_WAIT          "FALSE"
    --vhook_g IS_CLKFBIN_INVERTED   '0'
    --vhook_g IS_CLKIN1_INVERTED    '0'
    --vhook_g IS_CLKIN2_INVERTED    '0'
    --vhook_g IS_CLKINSEL_INVERTED  '0'
    --vhook_g IS_PSEN_INVERTED      '0'
    --vhook_g IS_PSINCDEC_INVERTED  '0'
    --vhook_g IS_PWRDWN_INVERTED    '0'
    --vhook_g IS_RST_INVERTED       '0'
    --vhook_g SS_EN                 "FALSE"
    --vhook_g SS_MODE               "CENTER_HIGH"
    --vhook_g SS_MOD_PERIOD         10000
    --vhook_a CLKINSEL              bTxClkInSelection
    --vhook_a CLKIN1                SiClk
    --vhook_a CLKIN2                LmkClk
    --vhook_a CLKFBOUT              MmcmClkFbOut
    --vhook_a CLKFBOUTB             open
    --vhook_a CDDCDONE              open
    --vhook_a CLKFBSTOPPED          open
    --vhook_a CLKINSTOPPED          open
    --vhook_a CDDCREQ               '0'
    --vhook_a CLKOUT0               TxSampleClkLcl
    --vhook_a CLKOUT1               TxDataClkLcl
    --vhook_a CLKOUT2               TxDataClkCopyLcl
    --vhook_a CLKOUT3               open
    --vhook_a CLKOUT4               open
    --vhook_a CLKOUT5               open
    --vhook_a CLKOUT6               open
    --vhook_a CLKOUT0B              open
    --vhook_a CLKOUT1B              open
    --vhook_a CLKOUT2B              open
    --vhook_a CLKOUT3B              open
    --vhook_a DADDR                 dDrpAddr
    --vhook_a DCLK                  DrpClk
    --vhook_a DEN                   dDrpEn
    --vhook_a DI                    dDrpDataIn
    --vhook_a DO                    dDrpDataOut
    --vhook_a DRDY                  dDrpRdy
    --vhook_a DWE                   dDrpWe
    --vhook_a LOCKED                aMmcmLockedLcl
    --vhook_a CLKFBIN               MmcmClkFbIn
    --vhook_a PSCLK                 '0'
    --vhook_a PSDONE                open
    --vhook_a PSEN                  '0'
    --vhook_a PSINCDEC              '0'
    --vhook_a PWRDWN                '0'
    --vhook_a RST                   bMmcmReset
    TxMmcm: MMCME3_ADV
      generic map (
        BANDWIDTH            => "HIGH",         --string:="OPTIMIZED"
        CLKFBOUT_MULT_F      => 8.00,           --real:=5.000
        CLKFBOUT_PHASE       => 00.0,           --real:=0.000
        CLKFBOUT_USE_FINE_PS => "FALSE",        --string:="FALSE"
        CLKIN1_PERIOD        => 6.4,            --real:=0.000
        CLKIN2_PERIOD        => 6.4,            --real:=0.000
        CLKOUT0_DIVIDE_F     => 2.0,            --real:=1.000
        CLKOUT0_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT0_PHASE        => 0.0,            --real:=0.000
        CLKOUT0_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT1_DIVIDE       => 8,              --integer:=1
        CLKOUT1_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT1_PHASE        => 0.0,            --real:=0.000
        CLKOUT1_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT2_DIVIDE       => 8,              --integer:=1
        CLKOUT2_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT2_PHASE        => 0.0,            --real:=0.000
        CLKOUT2_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT3_DIVIDE       => 2,              --integer:=1
        CLKOUT3_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT3_PHASE        => 0.0,            --real:=0.000
        CLKOUT3_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT4_CASCADE      => "FALSE",        --string:="FALSE"
        CLKOUT4_DIVIDE       => 2,              --integer:=1
        CLKOUT4_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT4_PHASE        => 0.0,            --real:=0.000
        CLKOUT4_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT5_DIVIDE       => 2,              --integer:=1
        CLKOUT5_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT5_PHASE        => 0.0,            --real:=0.000
        CLKOUT5_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        CLKOUT6_DIVIDE       => 8,              --integer:=1
        CLKOUT6_DUTY_CYCLE   => 0.500,          --real:=0.500
        CLKOUT6_PHASE        => 0.0,            --real:=0.000
        CLKOUT6_USE_FINE_PS  => "FALSE",        --string:="FALSE"
        COMPENSATION         => "AUTO",         --string:="AUTO"
        DIVCLK_DIVIDE        => 1,              --integer:=1
        IS_CLKFBIN_INVERTED  => '0',            --bit:='0'
        IS_CLKIN1_INVERTED   => '0',            --bit:='0'
        IS_CLKIN2_INVERTED   => '0',            --bit:='0'
        IS_CLKINSEL_INVERTED => '0',            --bit:='0'
        IS_PSEN_INVERTED     => '0',            --bit:='0'
        IS_PSINCDEC_INVERTED => '0',            --bit:='0'
        IS_PWRDWN_INVERTED   => '0',            --bit:='0'
        IS_RST_INVERTED      => '0',            --bit:='0'
        REF_JITTER1          => 0.010000,       --real:=0.010
        REF_JITTER2          => 0.010000,       --real:=0.010
        SS_EN                => "FALSE",        --string:="FALSE"
        SS_MODE              => "CENTER_HIGH",  --string:="CENTER_HIGH"
        SS_MOD_PERIOD        => 10000,          --integer:=10000
        STARTUP_WAIT         => "FALSE")        --string:="FALSE"
      port map (
        CDDCDONE     => open,               --out std_ulogic
        CLKFBOUT     => MmcmClkFbOut,       --out std_ulogic
        CLKFBOUTB    => open,               --out std_ulogic
        CLKFBSTOPPED => open,               --out std_ulogic
        CLKINSTOPPED => open,               --out std_ulogic
        CLKOUT0      => TxSampleClkLcl,     --out std_ulogic
        CLKOUT0B     => open,               --out std_ulogic
        CLKOUT1      => TxDataClkLcl,       --out std_ulogic
        CLKOUT1B     => open,               --out std_ulogic
        CLKOUT2      => TxDataClkCopyLcl,   --out std_ulogic
        CLKOUT2B     => open,               --out std_ulogic
        CLKOUT3      => open,               --out std_ulogic
        CLKOUT3B     => open,               --out std_ulogic
        CLKOUT4      => open,               --out std_ulogic
        CLKOUT5      => open,               --out std_ulogic
        CLKOUT6      => open,               --out std_ulogic
        DO           => dDrpDataOut,        --out std_logic_vector(15:0)
        DRDY         => dDrpRdy,            --out std_ulogic
        LOCKED       => aMmcmLockedLcl,     --out std_ulogic
        PSDONE       => open,               --out std_ulogic
        CDDCREQ      => '0',                --in  std_ulogic
        CLKFBIN      => MmcmClkFbIn,        --in  std_ulogic
        CLKIN1       => SiClk,              --in  std_ulogic
        CLKIN2       => LmkClk,             --in  std_ulogic
        CLKINSEL     => bTxClkInSelection,  --in  std_ulogic
        DADDR        => dDrpAddr,           --in  std_logic_vector(6:0)
        DCLK         => DrpClk,             --in  std_ulogic
        DEN          => dDrpEn,             --in  std_ulogic
        DI           => dDrpDataIn,         --in  std_logic_vector(15:0)
        DWE          => dDrpWe,             --in  std_ulogic
        PSCLK        => '0',                --in  std_ulogic
        PSEN         => '0',                --in  std_ulogic
        PSINCDEC     => '0',                --in  std_ulogic
        PWRDWN       => '0',                --in  std_ulogic
        RST          => bMmcmReset);        --in  std_ulogic

    -- A 8000 cycle filter at 80 MHz gives us 100 uSec. This is enough to filter out any false locks from the MMCM.
    --vhook_e FilterStdLogic MmcmLockCycleFilter
    --vhook_g kFilterLength 8000
    --vhook_g kFilterActiveValue std_logic'('1')
    --vhook_a aReset std_logic'('0')
    --vhook_af {cReset} {not bAxiPeriphReset_n}
    --vhook_a Clk BusClk
    --vhook_a aISig aMmcmLockedLcl
    --vhook_a cOSig bMmcmLocked
    MmcmLockCycleFilter: entity work.FilterStdLogic (rtl)
      generic map (
        kFilterLength      => 8000,             --natural
        kFilterActiveValue => std_logic'('1'))  --std_logic:='0'
      port map (
        aReset => std_logic'('0'),        --in  std_logic
        cReset => not bAxiPeriphReset_n,  --in  std_logic
        Clk    => BusClk,                 --in  std_logic
        aISig  => aMmcmLockedLcl,         --in  std_logic
        cOSig  => bMmcmLocked);           --out std_logic

    --vhook_e DoubleSyncSlAsyncIn SyncClkEn
    --vhook_g kResetVal '0'
    --vhook_a aoReset false
    --vhook_a OClk BusClk
    --vhook_a aSig aDiagramClkEnable
    --vhook_a oSig bDiagramClkEnable
    SyncClkEn: entity work.DoubleSyncSlAsyncIn (rtl)
      generic map (kResetVal => '0')  --std_logic:='0'
      port map (
        aSig    => aDiagramClkEnable,  --in  std_logic
        aoReset => false,              --in  boolean
        OClk    => BusClk,             --in  std_logic
        oSig    => bDiagramClkEnable); --out std_logic

    --vhook_i BUFG MmcmFbBufG
    --vhook_a I MmcmClkFbOut
    --vhook_a O MmcmClkFbIn
    MmcmFbBufG: BUFG
      port map (
        O => MmcmClkFbIn,   --out std_ulogic
        I => MmcmClkFbOut); --in  std_ulogic

    --vhook_e AsyncDisableSyncEnable   DelayRefClockResetRSD
    --vhook_a Clk                      DelayRefClkLcl
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 dDelayCtrlEnable
    DelayRefClockResetRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => DelayRefClkLcl,          --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => dDelayCtrlEnable);       --out boolean

    --vhook_i BUFGCE            DelayRefClockBufG
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 DelayRefClkLcl
    --vhook_a O                 DelayRefClk
    --vhook_a CE                to_StdLogic(dDelayCtrlEnable)
    DelayRefClockBufG: BUFGCE
      generic map (
        CE_TYPE        => "SYNC",        --string:="SYNC"
        IS_CE_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED  => '0',           --bit:='0'
        SIM_DEVICE     => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC   => "FALSE")       --string:="FALSE"
      port map (
        O  => DelayRefClk,                    --out std_ulogic
        CE => to_StdLogic(dDelayCtrlEnable),  --in  std_ulogic
        I  => DelayRefClkLcl);                --in  std_ulogic

    --vhook_e AsyncDisableSyncEnable   SeRegisterClockResetRSD
    --vhook_a Clk                      SeRegisterClkLcl
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 sSeDirectionEnable
    SeRegisterClockResetRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => SeRegisterClkLcl,        --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => sSeDirectionEnable);     --out boolean

    --vhook_i BUFGCE            SeRegisterClockBufG
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 SeRegisterClkLcl
    --vhook_a O                 SeRegisterClk
    --vhook_a CE                to_StdLogic(sSeDirectionEnable)
    SeRegisterClockBufG: BUFGCE
      generic map (
        CE_TYPE        => "SYNC",        --string:="SYNC"
        IS_CE_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED  => '0',           --bit:='0'
        SIM_DEVICE     => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC   => "FALSE")       --string:="FALSE"
      port map (
        O  => SeRegisterClk,                    --out std_ulogic
        CE => to_StdLogic(sSeDirectionEnable),  --in  std_ulogic
        I  => SeRegisterClkLcl);                --in  std_ulogic

    --vhook_i PLLE3_BASE            IDelayCtrlPll
    --vhook_g CLKFBOUT_MULT         10
    --vhook_g CLKFBOUT_PHASE        00.0
    --vhook_g CLKIN_PERIOD          12.5
    --vhook_g CLKOUT0_DIVIDE        4
    --vhook_g CLKOUT1_DIVIDE        4
    --vhook_g CLKOUT0_PHASE         0.0
    --vhook_g CLKOUT1_PHASE         0.0
    --vhook_g CLKOUT0_DUTY_CYCLE    0.500
    --vhook_g CLKOUT1_DUTY_CYCLE    0.500
    --vhook_g DIVCLK_DIVIDE         1
    --vhook_g CLKOUTPHY_MODE        "VCO_2X"
    --vhook_g IS_CLKFBIN_INVERTED   '0'
    --vhook_g IS_CLKIN_INVERTED     '0'
    --vhook_g IS_PWRDWN_INVERTED    '0'
    --vhook_g IS_RST_INVERTED       '0'
    --vhook_g REF_JITTER            0.010000
    --vhook_g STARTUP_WAIT          "FALSE"
    --vhook_a CLKFBOUT              PllClkFbOut
    --vhook_a CLKOUT0               DelayRefClkLcl
    --vhook_a CLKOUT0B              open
    --vhook_a CLKOUT1               SeRegisterClkLcl
    --vhook_a CLKOUT1B              open
    --vhook_a CLKOUTPHYEN           '0'
    --vhook_a CLKOUTPHY             open
    --vhook_a LOCKED                aPllLockedLcl
    --vhook_a CLKFBIN               PllClkFbIn
    --vhook_a CLKIN                 BusClk
    --vhook_a PWRDWN                '0'
    --vhook_a RST                   bPllReset
    IDelayCtrlPll: PLLE3_BASE
      generic map (
        CLKFBOUT_MULT       => 10,        --integer:=5
        CLKFBOUT_PHASE      => 00.0,      --real:=0.000
        CLKIN_PERIOD        => 12.5,      --real:=0.000
        CLKOUT0_DIVIDE      => 4,         --integer:=1
        CLKOUT0_DUTY_CYCLE  => 0.500,     --real:=0.500
        CLKOUT0_PHASE       => 0.0,       --real:=0.000
        CLKOUT1_DIVIDE      => 4,         --integer:=1
        CLKOUT1_DUTY_CYCLE  => 0.500,     --real:=0.500
        CLKOUT1_PHASE       => 0.0,       --real:=0.000
        CLKOUTPHY_MODE      => "VCO_2X",  --string:="VCO_2X"
        DIVCLK_DIVIDE       => 1,         --integer:=1
        IS_CLKFBIN_INVERTED => '0',       --bit:='0'
        IS_CLKIN_INVERTED   => '0',       --bit:='0'
        IS_PWRDWN_INVERTED  => '0',       --bit:='0'
        IS_RST_INVERTED     => '0',       --bit:='0'
        REF_JITTER          => 0.010000,  --real:=0.010
        STARTUP_WAIT        => "FALSE")   --string:="FALSE"
      port map (
        CLKFBOUT    => PllClkFbOut,       --out std_ulogic
        CLKOUT0     => DelayRefClkLcl,    --out std_ulogic
        CLKOUT0B    => open,              --out std_ulogic
        CLKOUT1     => SeRegisterClkLcl,  --out std_ulogic
        CLKOUT1B    => open,              --out std_ulogic
        CLKOUTPHY   => open,              --out std_ulogic
        LOCKED      => aPllLockedLcl,     --out std_ulogic
        CLKFBIN     => PllClkFbIn,        --in  std_ulogic
        CLKIN       => BusClk,            --in  std_ulogic
        CLKOUTPHYEN => '0',               --in  std_ulogic
        PWRDWN      => '0',               --in  std_ulogic
        RST         => bPllReset);        --in  std_ulogic

    --vhook_e FilterStdLogic PllLockCycleFilter
    --vhook_g kFilterLength 8000
    --vhook_g kFilterActiveValue std_logic'('1')
    --vhook_a aReset std_logic'('0')
    --vhook_af {cReset} {not bAxiPeriphReset_n}
    --vhook_a Clk BusClk
    --vhook_a aISig aPllLockedLcl
    --vhook_a cOSig bPllLocked
    PllLockCycleFilter: entity work.FilterStdLogic (rtl)
      generic map (
        kFilterLength      => 8000,             --natural
        kFilterActiveValue => std_logic'('1'))  --std_logic:='0'
      port map (
        aReset => std_logic'('0'),        --in  std_logic
        cReset => not bAxiPeriphReset_n,  --in  std_logic
        Clk    => BusClk,                 --in  std_logic
        aISig  => aPllLockedLcl,          --in  std_logic
        cOSig  => bPllLocked);            --out std_logic

    --vhook_i BUFG PllFbBufG
    --vhook_a I PllClkFbOut
    --vhook_a O PllClkFbIn
    PllFbBufG: BUFG
      port map (
        O => PllClkFbIn,   --out std_ulogic
        I => PllClkFbOut); --in  std_ulogic

    --------------------------------------
    -- TX Clock phase alignment --
    --------------------------------------

    --vhook_e ResetSyncDeassert   TxSampleResetRSD
    --vhook_a Clk                 TxSampleClk
    --vhook_a aReset              {to_Boolean(bRstClkSyncLogic)}
    --vhook_a acReset             tsTxBufClr
    TxSampleResetRSD: entity work.ResetSyncDeassert (rtl)
      port map (
        Clk     => TxSampleClk,                   --in  std_logic
        aReset  => to_Boolean(bRstClkSyncLogic),  --in  boolean
        acReset => tsTxBufClr);                   --out boolean

    --vhook_e AsyncDisableSyncEnable   DataClockCopyTxEnableRSD
    --vhook_a Clk                      TxDataClkCopyLcl
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 tcClkOutEn
    DataClockCopyTxEnableRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => TxDataClkCopyLcl,        --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => tcClkOutEn);             --out boolean

    --vhook_i BUFG ClockTxSampleBufG
    --vhook_a I TxSampleClkLcl
    --vhook_a O TxSampleClk
    ClockTxSampleBufG: BUFG
      port map (
        O => TxSampleClk,     --out std_ulogic
        I => TxSampleClkLcl); --in  std_ulogic

    --vhook_i BUFGCE_DIV        DataClockCopyTx
    --vhook_g BUFGCE_DIVIDE     1
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_CLR_INVERTED   '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g HARDSYNC_CLR      "FALSE"
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 TxDataClkCopyLcl
    --vhook_a O                 TxDataClkCopy
    --vhook_a CE                to_StdLogic(tcClkOutEn)
    --vhook_a CLR               bGateClock
    DataClockCopyTx: BUFGCE_DIV
      generic map (
        BUFGCE_DIVIDE   => 1,             --integer:=1
        CE_TYPE         => "SYNC",        --string:="SYNC"
        HARDSYNC_CLR    => "FALSE",       --string:="FALSE"
        IS_CE_INVERTED  => '0',           --bit:='0'
        IS_CLR_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED   => '0',           --bit:='0'
        SIM_DEVICE      => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC    => "FALSE")       --string:="FALSE"
      port map (
        O   => TxDataClkCopy,            --out std_ulogic
        CE  => to_StdLogic(tcClkOutEn),  --in  std_ulogic
        CLR => bGateClock,               --in  std_ulogic
        I   => TxDataClkCopyLcl);        --in  std_ulogic

    TxDataClkCopyFF: process (tsTxBufClr, TxDataClkCopy)
    begin
      if (tsTxBufClr) then
        tTxDataClkToggle <= '0';
      elsif rising_edge(TxDataClkCopy) then
        tTxDataClkToggle <= not tTxDataClkToggle;
      end if;
    end process TxDataClkCopyFF;

    -- Add this FF so that the tools do not need to be constrainted
    -- by the feedback path to the D input of the flop that is clocked
    -- off on DataClockTx as well as the same time trying to close
    -- timing between DataClockTx and TxSampleClk
    TxDataClkCopyAddFF: process (tsTxBufClr, TxDataClkCopy)
    begin
      if (tsTxBufClr) then
        tTxDataClkToggleDlyd <= '0';
      elsif rising_edge(TxDataClkCopy) then
        tTxDataClkToggleDlyd <= tTxDataClkToggle;
      end if;
    end process TxDataClkCopyAddFF;

    DataClkTxDelayRisingEdge: process(tsTxBufClr, TxSampleClk)
    begin
      if (tsTxBufClr) then
        tsDataClkToggle <= '0';
        tsDataClkToggleDlyd <= '0';
        tsDataClkDlydRisingEdge <= '0';
      elsif rising_edge(TxSampleClk) then
        tsDataClkToggle  <= tTxDataClkToggleDlyd;
        tsDataClkToggleDlyd  <= tsDataClkToggle;
        tsDataClkDlydRisingEdge <= tsDataClkToggle and (not tsDataClkToggleDlyd);
      end if;
    end process DataClkTxDelayRisingEdge;

    -- Use the TxSampleClk to do the reset/enabling of the BUFGCE_DIV.
    -- Take a look at the section labeled “Using BUFGCE_DIV to Reduce Clock Uncertainty” in UG949
    -- This is to reduce clock uncertainty by using same MMCM output
    -- BUFGCE_DIV O output is 0 when CLR is High (active).
    -- When CE is High, the I input is transferred to the O output.

    TxClrCeProc:process (tsTxBufClr,TxSampleClk)
    begin
      if (tsTxBufClr) then
        tsTxBufgceClrLcl <= '1';
        tsTxBufgceCeLcl  <= '0';
        tsTxClkEnCount <= kTxClkEnCountLength;
        tsTxClkEnCountEnabled <= false;
      elsif rising_edge(TxSampleClk) then
        -- De-assert tsTxBufgceClrLcl (not metastable because of RSD)
        tsTxBufgceClrLcl <= '0';
        -- Wait on CLR to de-assert before starting CE logic
        if tsTxBufgceClrLcl = '0' then
          -- Wait on data clock rising edge to enable the CE counter
          if (tsDataClkDlydRisingEdge = '1' and not tsTxClkEnCountEnabled) then
             tsTxClkEnCountEnabled <= true;
          -- If counter is enabled
          elsif tsTxClkEnCountEnabled then
             -- If count has not yet reached 0, decrement the counter
             if (tsTxClkEnCount /= 0) then
                tsTxClkEnCount <= tsTxClkEnCount - 1;
             -- Else, enable the BUFGCE buffer
             else
                 tsTxBufgceCeLcl <= '1';
             end if;
          end if;
        end if;
      end if;
    end process TxClrCeProc;

    tsTxBufgceClr   <= tsTxBufgceClrLcl;

    tsTxBufgceCe    <= tsTxBufgceCeLcl;

    --------------------------------------
    -- TX implementation --
    --------------------------------------

    --vhook_e AsyncDisableSyncEnable   DataClockTxEnableRSD
    --vhook_a Clk                      TxDataClkLcl
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 tClkOutEn
    DataClockTxEnableRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => TxDataClkLcl,            --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => tClkOutEn);              --out boolean

    --vhook_i BUFGCE_DIV        DataClockTx
    --vhook_g BUFGCE_DIVIDE     1
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_CLR_INVERTED   '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g HARDSYNC_CLR      "FALSE"
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 TxDataClkLcl
    --vhook_a O                 TxDataClk
    --vhook_a CE                to_StdLogic(tClkOutEn)
    --vhook_a CLR               bGateClock
    DataClockTx: BUFGCE_DIV
      generic map (
        BUFGCE_DIVIDE   => 1,             --integer:=1
        CE_TYPE         => "SYNC",        --string:="SYNC"
        HARDSYNC_CLR    => "FALSE",       --string:="FALSE"
        IS_CE_INVERTED  => '0',           --bit:='0'
        IS_CLR_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED   => '0',           --bit:='0'
        SIM_DEVICE      => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC    => "FALSE")       --string:="FALSE"
      port map (
        O   => TxDataClk,               --out std_ulogic
        CE  => to_StdLogic(tClkOutEn),  --in  std_ulogic
        CLR => bGateClock,              --in  std_ulogic
        I   => TxDataClkLcl);           --in  std_ulogic

    --vhook_i BUFGCE_DIV        OSerdesClockDiv
    --vhook_g BUFGCE_DIVIDE     4
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g HARDSYNC_CLR      "FALSE"
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_CLR_INVERTED   '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 TxSampleClk
    --vhook_a O                 OSerdesClkDiv
    --vhook_a CE                tsTxBufgceCe
    --vhook_a CLR               tsTxBufgceClr
    OSerdesClockDiv: BUFGCE_DIV
      generic map (
        BUFGCE_DIVIDE   => 4,             --integer:=1
        CE_TYPE         => "SYNC",        --string:="SYNC"
        HARDSYNC_CLR    => "FALSE",       --string:="FALSE"
        IS_CE_INVERTED  => '0',           --bit:='0'
        IS_CLR_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED   => '0',           --bit:='0'
        SIM_DEVICE      => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC    => "FALSE")       --string:="FALSE"
      port map (
        O   => OSerdesClkDiv,  --out std_ulogic
        CE  => tsTxBufgceCe,   --in  std_ulogic
        CLR => tsTxBufgceClr,  --in  std_ulogic
        I   => TxSampleClk);   --in  std_ulogic

    --vhook_i BUFGCE_DIV           OSerdesClock
    --vhook_g BUFGCE_DIVIDE        1
    --vhook_g CE_TYPE              "SYNC"
    --vhook_g HARDSYNC_CLR         "FALSE"
    --vhook_g IS_CE_INVERTED       '0'
    --vhook_g IS_CLR_INVERTED      '0'
    --vhook_g IS_I_INVERTED        '0'
    --vhook_g SIM_DEVICE           "ULTRASCALE"
    --vhook_g STARTUP_SYNC         "FALSE"
    --vhook_a I                    TxSampleClk
    --vhook_a O                    OSerdesClk
    --vhook_a CE                   tsTxBufgceCe
    --vhook_a CLR                  tsTxBufgceClr
    OSerdesClock: BUFGCE_DIV
      generic map (
        BUFGCE_DIVIDE   => 1,             --integer:=1
        CE_TYPE         => "SYNC",        --string:="SYNC"
        HARDSYNC_CLR    => "FALSE",       --string:="FALSE"
        IS_CE_INVERTED  => '0',           --bit:='0'
        IS_CLR_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED   => '0',           --bit:='0'
        SIM_DEVICE      => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC    => "FALSE")       --string:="FALSE"
      port map (
        O   => OSerdesClk,     --out std_ulogic
        CE  => tsTxBufgceCe,   --in  std_ulogic
        CLR => tsTxBufgceClr,  --in  std_ulogic
        I   => TxSampleClk);   --in  std_ulogic

end RTL;