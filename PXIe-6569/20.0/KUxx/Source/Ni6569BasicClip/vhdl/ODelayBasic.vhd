-------------------------------------------------------------------------------
--
-- File: ODelayBasic.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 25 August 2020
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
-- Purpose: ODelayBasic delays the user data using ODELAY block before
-- routing it to the output buffers.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.PkgNiUtilities.all;
use work.PkgNi6569.all;

entity ODelayBasic is
  generic (
    kNumTxChannels        : natural := 32;
    kIoDelayGroupName     : string := "IOdelayGroup"
  );
  port (
    -- Clocks, Reset & Control
    aResetDelay            : in std_logic;
    TxDataClk              : in std_logic;
    aDelayCtrlRdy          : in std_logic;

    --ODELAY and OSERDES control signals
    tTxInc                 : in std_logic_vector(kNumTxChannels-1 downto 0);
    tTxClkDelayEn          : in std_logic_vector(kNumTxChannels-1 downto 0);
    tDlyCount              : in DelayArray_t(kNumTxChannels-1 downto 0);
    tTxCntValOut           : out DelayArray_t(kNumTxChannels-1 downto 0);
    tIncDecReady           : out std_logic_vector(kNumTxChannels-1 downto 0);

    -- Input to ODelays
    tLvdsOutput           : in  std_logic_vector(kNumTxChannels-1 downto 0);

    -- Data from ODelay
    aLvdsOutputToOBuf     : out std_logic_vector(kNumTxChannels-1 downto 0)
  );
end ODelayBasic;

architecture RTL of ODelayBasic is

  attribute IODELAY_GROUP         : string;
  signal tTxClkCe, tODelayEn      : std_logic_vector(kNumTxChannels-1 downto 0);
  signal tTxClkDelayEnTemp        : std_logic_vector(kNumTxChannels-1 downto 0);
  signal tTxCntValOutLcl          : DelayArray_t(kNumTxChannels-1 downto 0);
  signal tGetMinimumDelayLimit    : BooleanVector(kNumTxChannels-1 downto 0);
  signal tTxEnVtc                 : std_logic_vector(kNumTxChannels-1 downto 0);
  signal tLvdsInputToOdelay       : std_logic_vector(kNumTxChannels-1 downto 0);
  signal tSetLowLimitDone         : std_logic_vector(kNumTxChannels-1 downto 0);
  signal tTxInitialCntValOut      : DelayArray_t(kNumTxChannels-1 downto 0);

  --vhook_sigstart
  signal atResetDelay: boolean;
  signal tDelayCtrlRdy: std_logic;
  --vhook_sigend

begin

  --vhook_e ResetSyncDeassert   TxResetDelayRSD
  --vhook_a Clk                 TxDataClk
  --vhook_a aReset              {to_Boolean(aResetDelay)}
  --vhook_a acReset             atResetDelay
  TxResetDelayRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => TxDataClk,                --in  std_logic
      aReset  => to_Boolean(aResetDelay),  --in  boolean
      acReset => atResetDelay);            --out boolean

  --vhook_e DoubleSyncSlAsyncIn IDelayCtrlReadyTxDS
  --vhook_g kResetVal           '0'
  --vhook_a aoReset             atResetDelay
  --vhook_a OClk                TxDataClk
  --vhook_a aSig                aDelayCtrlRdy
  --vhook_a oSig                tDelayCtrlRdy
  IDelayCtrlReadyTxDS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aDelayCtrlRdy,  --in  std_logic
      aoReset => atResetDelay,   --in  boolean
      OClk    => TxDataClk,      --in  std_logic
      oSig    => tDelayCtrlRdy); --out std_logic

  DataODelayGen : for i in 0 to kNumTxChannels-1 generate
    attribute IODELAY_GROUP of DataODelay : label is kIoDelayGroupName;

    attribute DONT_TOUCH: string;
    attribute DONT_TOUCH of DataODelay: label is "TRUE";
  begin

    ---------------------------------------------------------------
    -- Process to detect a rising edge on the user-driven
    -- ClkDelayStrobe signal
    ---------------------------------------------------------------

    TxClockEnablePulseCreation: process (atResetDelay, TxDataClk)
    begin
      if atResetDelay then
        tTxClkDelayEnTemp(i) <= '0';
        tTxClkCe(i) <= '0';
      elsif rising_edge(TxDataClk) then
          tTxClkDelayEnTemp(i) <= tTxClkDelayEn(i);
          if (tTxClkDelayEn(i) and (not tTxClkDelayEnTemp(i))) = '1' then
            tTxClkCe(i) <= '1';
          else
            tTxClkCe(i) <= '0';
          end if;
      end if;
    end process TxClockEnablePulseCreation;

    ----------------------------------------------------------
    -- This state machine sets the lower limit delay value. --
    -- It only runs once after download                     --
    ----------------------------------------------------------
    --vhook_e GetMinDelayLimit         TxGetDelayLimit
    --vhook_a Clk                      TxDataClk
    --vhook_a aReset                   atResetDelay
    --vhook_a cGetMinimumDelayLimit    tGetMinimumDelayLimit(i)
    --vhook_a cCntValFromIdelay        tTxCntValOutLcl(i)
    --vhook_a cSetLowLimitDone         tSetLowLimitDone(i)
    --vhook_a cAlignDelayValue         tTxInitialCntValOut(i)
    TxGetDelayLimit: entity work.GetMinDelayLimit (rtl)
      port map (
        Clk                   => TxDataClk,                 --in  std_logic
        aReset                => atResetDelay,              --in  boolean
        cGetMinimumDelayLimit => tGetMinimumDelayLimit(i),  --in  boolean
        cCntValFromIdelay     => tTxCntValOutLcl(i),        --in  std_logic_vector(kDelayCntValSize-1:0)
        cSetLowLimitDone      => tSetLowLimitDone(i),       --out std_logic
        cAlignDelayValue      => tTxInitialCntValOut(i));   --out std_logic_vector(kDelayCntValSize-1:0)

    ------------------------------------------------------------------------------
    -- State machine to check whether the delay value is within allowable range --
    ------------------------------------------------------------------------------
    --vhook_e UpperLowerDelayLimit     TxUpperLowerDelayLimitx
    --vhook_a Clk                      TxDataClk
    --vhook_a aReset                   atResetDelay
    --vhook_a cDelayCtrlRdy            {to_Boolean(tDelayCtrlRdy)}
    --vhook_a cSetLowLimitDone         {to_Boolean(tSetLowLimitDone(i))}
    --vhook_a cMinDecTap               tTxInitialCntValOut(i)
    --vhook_a cRequestDelay            {to_Boolean(tTxClkCe(i))}
    --vhook_a cInc                     tTxInc(i)
    --vhook_a cCntValFromIdelay        tTxCntValOutLcl(i)
    --vhook_a cDlyCount                tDlyCount(i)
    --vhook_a cGetMinimumDelayLimit    tGetMinimumDelayLimit(i)
    --vhook_a cEnVtc                   tTxEnVtc(i)
    --vhook_a cDelayEn                 tOdelayEn(i)
    --vhook_a cIncDecReady             tIncDecReady(i)
    --vhook_a cDisplayCountValue       tTxCntValOut(i)
    TxUpperLowerDelayLimitx: entity work.UpperLowerDelayLimit (rtl)
      port map (
        Clk                   => TxDataClk,                        --in  std_logic
        aReset                => atResetDelay,                     --in  boolean
        cDelayCtrlRdy         => to_Boolean(tDelayCtrlRdy),        --in  boolean
        cSetLowLimitDone      => to_Boolean(tSetLowLimitDone(i)),  --in  boolean
        cMinDecTap            => tTxInitialCntValOut(i),           --in  std_logic_vector(kDelayCntValSize-1:0)
        cRequestDelay         => to_Boolean(tTxClkCe(i)),          --in  boolean
        cInc                  => tTxInc(i),                        --in  std_logic
        cCntValFromIdelay     => tTxCntValOutLcl(i),               --in  std_logic_vector(kDelayCntValSize-1:0)
        cDlyCount             => tDlyCount(i),                     --in  std_logic_vector(kDelayCntValSize-1:0)
        cGetMinimumDelayLimit => tGetMinimumDelayLimit(i),         --out boolean
        cEnVtc                => tTxEnVtc(i),                      --out std_logic
        cDelayEn              => tOdelayEn(i),                     --out std_logic
        cIncDecReady          => tIncDecReady(i),                  --out std_logic
        cDisplayCountValue    => tTxCntValOut(i));                 --out std_logic_vector(kDelayCntValSize-1:0)

    ---------------------------------------------------------------
    -- Simple Flip-Flop before feeding in ODELAY
    -- This is to fix the Vivado clash issue that the input of ODELAY
    -- has to be come from simple FF / ODDR / OSERDES.
    ---------------------------------------------------------------
    OdelayLvdsFlipFlop: process (atResetDelay, TxDataClk)
    begin
      if atResetDelay then
        tLvdsInputToOdelay(i) <= '0';
      elsif rising_edge(TxDataClk) then
        tLvdsInputToOdelay(i) <= tLvdsOutput(i);
      end if;
    end process OdelayLvdsFlipFlop;
    -----------------------------------------------------------
    --Instantiate an IoDelay for each channel
    -----------------------------------------------------------
    -- Referring to AR#67859, for users of 2016.2 with an initial DELAY_VALUE of less than 20 ps,
    -- the delay in hardware will not be what was requested. However all of the IDELAY/ODELAYs
    -- with bytes/banks that have the same DELAY_VALUE will be aligned to each other.
    -- To work around the issue, choose an initial DELAY_VALUE equal to or greater than 20 ps.

    --vhook_i ODELAYE3             DataODelay
    --vhook_a CASCADE              "NONE"
    --vhook_a DELAY_FORMAT         "TIME"
    --vhook_a DELAY_TYPE           "VAR_LOAD"
    --vhook_a DELAY_VALUE          20
    --vhook_a IS_CLK_INVERTED      '0'
    --vhook_a IS_RST_INVERTED      '0'
    --vhook_a REFCLK_FREQUENCY     200.0
    --vhook_a SIM_DEVICE           "ULTRASCALE"
    --vhook_a SIM_VERSION          2.0
    --vhook_a UPDATE_MODE          "ASYNC"
    --vhook_a CASC_OUT             open
    --vhook_a CNTVALUEOUT          tTxCntValOutLcl(i)
    --vhook_a DATAOUT              aLvdsOutputToOBuf(i)
    --vhook_a CASC_IN              '0'
    --vhook_a CASC_RETURN          '0'
    --vhook_a CE                   tODelayEn(i)
    --vhook_a CLK                  TxDataClk
    --vhook_a CNTVALUEIN           (others => '0')
    --vhook_a EN_VTC               tTxEnVtc(i)
    --vhook_a INC                  tTxInc(i)
    --vhook_a LOAD                 '0'
    --vhook_a ODATAIN              tLvdsInputToOdelay(i)
    --vhook_a RST                  to_StdLogic(atResetDelay)
    DataODelay: ODELAYE3
      generic map (
        CASCADE          => "NONE",        --string:="NONE"
        DELAY_FORMAT     => "TIME",        --string:="TIME"
        DELAY_TYPE       => "VAR_LOAD",    --string:="FIXED"
        DELAY_VALUE      => 20,            --integer:=0
        IS_CLK_INVERTED  => '0',           --bit:='0'
        IS_RST_INVERTED  => '0',           --bit:='0'
        REFCLK_FREQUENCY => 200.0,         --real:=300.0
        SIM_DEVICE       => "ULTRASCALE",  --string:="ULTRASCALE"
        SIM_VERSION      => 2.0,           --real:=2.0
        UPDATE_MODE      => "ASYNC")       --string:="ASYNC"
      port map (
        CASC_OUT    => open,                       --out std_ulogic
        CNTVALUEOUT => tTxCntValOutLcl(i),         --out std_logic_vector(8:0)
        DATAOUT     => aLvdsOutputToOBuf(i),       --out std_ulogic
        CASC_IN     => '0',                        --in  std_ulogic
        CASC_RETURN => '0',                        --in  std_ulogic
        CE          => tODelayEn(i),               --in  std_ulogic
        CLK         => TxDataClk,                  --in  std_ulogic
        CNTVALUEIN  => (others => '0'),            --in  std_logic_vector(8:0)
        EN_VTC      => tTxEnVtc(i),                --in  std_ulogic
        INC         => tTxInc(i),                  --in  std_ulogic
        LOAD        => '0',                        --in  std_ulogic
        ODATAIN     => tLvdsInputToOdelay(i),      --in  std_ulogic
        RST         => to_StdLogic(atResetDelay)); --in  std_ulogic

  end generate DataODelayGen;

end RTL;