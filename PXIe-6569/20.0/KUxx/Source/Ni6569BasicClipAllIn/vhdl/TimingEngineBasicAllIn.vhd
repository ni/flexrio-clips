-------------------------------------------------------------------------------
--
-- File: TimingEngineBasicAllIn.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 24 August 2020
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
--    LmkClk         - This clock is sourced by the LMK4832.  Its default frequency is 150 MHz
--                     It is present once the LMK04832 is configured.  This clock feeds one of the TxDataClkMux
--                     inputs to generate TxDataClk and OdelayClk.
--    SiClk          - This clock is sourced by the Si514.  Its default frequency is 150MHz
--                     It is present once the Si514 is configured. This clock feeds one of the TxDataClkMux
--                     inputs to generate TxDataClk and OdelayClk.
--    RxSSClk        - This clock, which is externally provided by the user, is sourced from a clock capable pin.
--                     It is fed into buffer to generate RxDataClk and IdelayClk.
--    RxDataClk      - This clock is generated from the buffer that is sourced by RxSSClk or LmkClk/SiClk
--                     to provide the data acquisition clock to LabVIEW.
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

entity TimingEngineBasicAllIn is
  port (
    -------------------
    -- Clocks/resets --
    -------------------
    BusClk                    : in  std_logic;
    bAxiPeriphReset_n         : in  std_logic;
    aDelayCtrlRdy             : in  std_logic;

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
    RxSSClk                   : in std_logic;
    SiClk                     : in  std_logic;
    LmkClk                    : in  std_logic;
    RxDataClk                 : out std_logic;
    DelayRefClk               : out std_logic;
    SeRegisterClk             : out std_logic;

    ----------------
    -- LV Control --
    ----------------
    aDiagramClkEnable         : in  std_logic
  );

end TimingEngineBasicAllIn;

architecture RTL of TimingEngineBasicAllIn is

   --vhook_sigstart
   signal aPllLockedLcl: std_ulogic;
   signal bDelayCtrlRdy: std_logic;
   signal bDiagramClkEnable: std_logic;
   signal bPllLocked: std_logic;
   signal bSRegPortIn: SRegPortIn_t;
   signal bSRegPortOut: SRegPortOut_t;
   signal dDelayCtrlEnable: boolean;
   signal DelayRefClkLcl: std_ulogic;
   signal PllClkFbIn: std_ulogic;
   signal PllClkFbOut: std_ulogic;
   signal rClkOutEn: boolean;
   signal RxSSClkBuf: std_ulogic;
   signal SeRegisterClkLcl: std_ulogic;
   signal sSeDirectionEnable: boolean;
   signal tClkOutEn: boolean;
   signal tdClkOutEn: boolean;
   signal TxDataClk: std_ulogic;
   signal TxDataClkLcl: std_ulogic;
  --vhook_sigend

  signal bPllReset           : std_logic := '1';
  signal bMmcmLocked         : std_logic := '0';
  signal bMmcmUnlockedSticky : std_logic := '0';
  signal bPllUnlockedSticky  : std_logic := '0';
  signal bGateClock          : std_logic := '1';
  signal bTxClkInSelection   : std_logic := '0';
  signal bRxClkInSelection   : std_logic := '0';

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
        bPllReset  <= '1';
        bGateClock  <= '1';
        bMmcmLocked <= '0';
        bMmcmUnlockedSticky <= '0';
        bPllUnlockedSticky <= '0';
        bTxClkInSelection <= '0';
        bRxClkInSelection <= '0';
      else
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

        TempData := SRegWriteData (
          RegInfo    => kMmcmStatusRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bMmcmLocked <= '1';
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

        --xmlparse xml_on
        --<regmap name="TimingEngine">
        --  <group name="MMCM">
        --    <register name="RxClkInSelection" size="32" offset="0x14" attributes="Writable">
        --      <bitfield name="SetRxClkInSelection" range="0" attributes="strobe">
        --        <info>Set '0' to select from RxSSClk (external).  Set '1' to select from TxDataClock.
        --              In All-In SERDES CLIP, this is to apply on Bank 44 only.
        --         </info>
        --      </bitfield>
        --      <bitfield name="ClearRxClkInSelection" range="1" attributes="strobe">
        --        <info>Clear this selection and choose default value as RxSSClk (external).
        --              In All-In SERDES CLIP, this is to apply on Bank 44 only.
        --        </info>
        --      </bitfield>
        --    </register>
        --  </group>
        --</regmap >
        --xmlparse xml_off
        TempData := SRegWriteData (
          RegInfo    => kRxClkInSelectionRec,
          OldData    => (others => '0'),  --this can be all '0's because there are only strobes
          SRegPortIn => bSRegPortIn);

        bRxClkInSelection <= (bRxClkInSelection or TempData(kSetRxClkInSelection)) and not TempData(kClearRxClkInSelection);

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
    --vhook_a cReset not bAxiPeriphReset_n
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

    ------------------------------------------------
    -- Silab / LMK Clock Selection implementation --
    ------------------------------------------------
    --vhook_i BUFGCTRL            TxDataClkMux
    --vhook_g CE_TYPE_CE0         "SYNC"
    --vhook_g CE_TYPE_CE1         "SYNC"
    --vhook_g INIT_OUT            0
    --vhook_g IS_CE0_INVERTED     '0'
    --vhook_g IS_CE1_INVERTED     '0'
    --vhook_g IS_I0_INVERTED      '0'
    --vhook_g IS_I1_INVERTED      '0'
    --vhook_g IS_IGNORE0_INVERTED '0'
    --vhook_g IS_IGNORE1_INVERTED '0'
    --vhook_g IS_S0_INVERTED      '0'
    --vhook_g IS_S1_INVERTED      '1'
    --vhook_g PRESELECT_I0        FALSE
    --vhook_g PRESELECT_I1        FALSE
    --vhook_g SIM_DEVICE          "ULTRASCALE"
    --vhook_g STARTUP_SYNC        "FALSE"
    --vhook_a I0                  SiClk
    --vhook_a I1                  LmkClk
    --vhook_a O                   TxDataClkLcl
    --vhook_a S0                  bTxClkInSelection
    --vhook_a S1                  bTxClkInSelection
    --vhook_a CE0                 '1'
    --vhook_a CE1                 '1'
    --vhook_a IGNORE0             '1'
    --vhook_a IGNORE1             '1'
    TxDataClkMux: BUFGCTRL
      generic map (
        CE_TYPE_CE0         => "SYNC",        --string:="SYNC"
        CE_TYPE_CE1         => "SYNC",        --string:="SYNC"
        INIT_OUT            => 0,             --integer:=0
        IS_CE0_INVERTED     => '0',           --bit:='0'
        IS_CE1_INVERTED     => '0',           --bit:='0'
        IS_I0_INVERTED      => '0',           --bit:='0'
        IS_I1_INVERTED      => '0',           --bit:='0'
        IS_IGNORE0_INVERTED => '0',           --bit:='0'
        IS_IGNORE1_INVERTED => '0',           --bit:='0'
        IS_S0_INVERTED      => '0',           --bit:='0'
        IS_S1_INVERTED      => '1',           --bit:='0'
        PRESELECT_I0        => FALSE,         --boolean:=FALSE
        PRESELECT_I1        => FALSE,         --boolean:=FALSE
        SIM_DEVICE          => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC        => "FALSE")       --string:="FALSE"
      port map (
        O       => TxDataClkLcl,       --out std_ulogic
        CE0     => '1',                --in  std_ulogic
        CE1     => '1',                --in  std_ulogic
        I0      => SiClk,              --in  std_ulogic
        I1      => LmkClk,             --in  std_ulogic
        IGNORE0 => '1',                --in  std_ulogic
        IGNORE1 => '1',                --in  std_ulogic
        S0      => bTxClkInSelection,  --in  std_ulogic
        S1      => bTxClkInSelection); --in  std_ulogic

    --vhook_e AsyncDisableSyncEnable   TxDataClockEnableRSD
    --vhook_a Clk                      TxDataClkLcl
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 tClkOutEn
    TxDataClockEnableRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => TxDataClkLcl,            --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => tClkOutEn);              --out boolean

    --vhook_i BUFGCE            TxDataClkBufgce
    --vhook_g IS_CE_INVERTED    '0'
    --vhook_g IS_I_INVERTED     '0'
    --vhook_g CE_TYPE           "SYNC"
    --vhook_g SIM_DEVICE        "ULTRASCALE"
    --vhook_g STARTUP_SYNC      "FALSE"
    --vhook_a I                 TxDataClkLcl
    --vhook_a O                 TxDataClk
    --vhook_a CE                to_StdLogic(tClkOutEn)
    TxDataClkBufgce: BUFGCE
      generic map (
        CE_TYPE        => "SYNC",        --string:="SYNC"
        IS_CE_INVERTED => '0',           --bit:='0'
        IS_I_INVERTED  => '0',           --bit:='0'
        SIM_DEVICE     => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC   => "FALSE")       --string:="FALSE"
      port map (
        O  => TxDataClk,               --out std_ulogic
        CE => to_StdLogic(tClkOutEn),  --in  std_ulogic
        I  => TxDataClkLcl);           --in  std_ulogic

    --------------------------------------
    -- RX implementation --
    --------------------------------------

    --vhook_i BUFG              RxSSClkBufG
    --vhook_a I                 RxSSClk
    --vhook_a O                 RxSSClkBuf
    RxSSClkBufG: BUFG
      port map (
        O => RxSSClkBuf,  --out std_ulogic
        I => RxSSClk);    --in  std_ulogic

    --vhook_e AsyncDisableSyncEnable   RxTxDataClkMuxEnableRSD
    --vhook_a Clk                      TxDataClk
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 tdClkOutEn
    RxTxDataClkMuxEnableRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => TxDataClk,               --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => tdClkOutEn);             --out boolean

    --vhook_e AsyncDisableSyncEnable   RxSsClkMuxEnableRSD
    --vhook_a Clk                      RxSSClkBuf
    --vhook_a aDisable                 to_Boolean(bGateClock)
    --vhook_a acEnable                 rClkOutEn
    RxSsClkMuxEnableRSD: entity work.AsyncDisableSyncEnable (rtl)
      port map (
        Clk      => RxSSClkBuf,              --in  std_logic
        aDisable => to_Boolean(bGateClock),  --in  boolean
        acEnable => rClkOutEn);              --out boolean

    --vhook_i BUFGCTRL            RxDataClkMux
    --vhook_g CE_TYPE_CE0         "SYNC"
    --vhook_g CE_TYPE_CE1         "SYNC"
    --vhook_g INIT_OUT            0
    --vhook_g IS_CE0_INVERTED     '0'
    --vhook_g IS_CE1_INVERTED     '0'
    --vhook_g IS_I0_INVERTED      '0'
    --vhook_g IS_I1_INVERTED      '0'
    --vhook_g IS_IGNORE0_INVERTED '0'
    --vhook_g IS_IGNORE1_INVERTED '0'
    --vhook_g IS_S0_INVERTED      '1'
    --vhook_g IS_S1_INVERTED      '0'
    --vhook_g PRESELECT_I0        FALSE
    --vhook_g PRESELECT_I1        FALSE
    --vhook_g SIM_DEVICE          "ULTRASCALE"
    --vhook_g STARTUP_SYNC        "FALSE"
    --vhook_a I0                  RxSSClkBuf
    --vhook_a I1                  TxDataClk
    --vhook_a O                   RxDataClk
    --vhook_a S0                  bRxClkInSelection
    --vhook_a S1                  bRxClkInSelection
    --vhook_a CE0                 to_StdLogic(rClkOutEn)
    --vhook_a CE1                 to_StdLogic(tdClkOutEn)
    --vhook_a IGNORE0             '1'
    --vhook_a IGNORE1             '1'
    RxDataClkMux: BUFGCTRL
      generic map (
        CE_TYPE_CE0         => "SYNC",        --string:="SYNC"
        CE_TYPE_CE1         => "SYNC",        --string:="SYNC"
        INIT_OUT            => 0,             --integer:=0
        IS_CE0_INVERTED     => '0',           --bit:='0'
        IS_CE1_INVERTED     => '0',           --bit:='0'
        IS_I0_INVERTED      => '0',           --bit:='0'
        IS_I1_INVERTED      => '0',           --bit:='0'
        IS_IGNORE0_INVERTED => '0',           --bit:='0'
        IS_IGNORE1_INVERTED => '0',           --bit:='0'
        IS_S0_INVERTED      => '1',           --bit:='0'
        IS_S1_INVERTED      => '0',           --bit:='0'
        PRESELECT_I0        => FALSE,         --boolean:=FALSE
        PRESELECT_I1        => FALSE,         --boolean:=FALSE
        SIM_DEVICE          => "ULTRASCALE",  --string:="ULTRASCALE"
        STARTUP_SYNC        => "FALSE")       --string:="FALSE"
      port map (
        O       => RxDataClk,                --out std_ulogic
        CE0     => to_StdLogic(rClkOutEn),   --in  std_ulogic
        CE1     => to_StdLogic(tdClkOutEn),  --in  std_ulogic
        I0      => RxSSClkBuf,               --in  std_ulogic
        I1      => TxDataClk,                --in  std_ulogic
        IGNORE0 => '1',                      --in  std_ulogic
        IGNORE1 => '1',                      --in  std_ulogic
        S0      => bRxClkInSelection,        --in  std_ulogic
        S1      => bRxClkInSelection);       --in  std_ulogic

end RTL;
