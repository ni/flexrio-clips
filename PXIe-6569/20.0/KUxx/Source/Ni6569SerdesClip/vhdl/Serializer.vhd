-------------------------------------------------------------------------------
--
-- File: Serializer.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 12 December 2019
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
-- Purpose:  The Serializer receives data from LVFPGA, then serializes the
-- data, routes them through Odelay blocks and outputs the data to GPIO pins.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgNi6569.all;

entity Serializer is
  generic (
    kNumChannels      : natural := 32;
    kIoDelayGroupName : string  := "OdelayGroup"
  );
  port (
    -- Clocks, Reset & Control
    aResetDelay            : in std_logic;
    aResetSerdes           : in std_logic;
    GenClkDiv              : in std_logic;
    GenClk                 : in std_logic;
    TxDataClk              : in std_logic;
    aIoOutputEnable        : in std_logic;
    aDelayCtrlRdy          : in std_logic;

    --ODELAY and OSERDES control signals
    tTxInc                 : in std_logic_vector(kNumChannels-1 downto 0);
    tTxClkDelayEn          : in std_logic_vector(kNumChannels-1 downto 0);
    tDlyCount              : in DelayArray_t(kNumChannels-1 downto 0);
    tTxCntValOut           : out DelayArray_t(kNumChannels-1 downto 0);
    tIncDecReady           : out std_logic_vector(kNumChannels-1 downto 0);

    -- Slow Generation Data
    tLvdsGenData      : in  SerArray_t(kNumChannels-1 downto 0);

    -- Serialized data and Tristate signals to output buffers
    gLvdsOutput       : out std_logic_vector(kNumChannels-1 downto 0);
    gTristateOut      : out std_logic_vector(kNumChannels-1 downto 0)
  );
end Serializer;

architecture RTL of Serializer is

  attribute IODELAY_GROUP               : string;
  signal tTxClkCe                       : std_logic_vector(kNumChannels-1 downto 0);
  signal tTxClkDelayEnTemp              : std_logic_vector(kNumChannels-1 downto 0);
  signal gLvdsOutputFromOSerdes         : std_logic_vector(kNumChannels-1 downto 0);
  signal aStaticTristate                : std_logic_vector(kNumChannels-1 downto 0);
  signal tODelayEn                      : std_logic_vector(kNumChannels-1 downto 0);
  signal tTxCntValOutLcl                : DelayArray_t(kNumChannels-1 downto 0);
  signal tGetMinimumDelayLimit          : BooleanVector(kNumChannels-1 downto 0);
  signal tTxEnVtc                       : std_logic_vector(kNumChannels-1 downto 0);
  signal tSetLowLimitDone               : std_logic_vector(kNumChannels-1 downto 0);
  signal tTxInitialCntValOut            : DelayArray_t(kNumChannels-1 downto 0);

  --vhook_sigstart
  signal agResetDelay: boolean;
  signal agResetSerdes: boolean;
  signal atResetDelay: boolean;
  signal tDelayCtrlRdy: std_logic;
  --vhook_sigend

begin

  --vhook_e ResetSyncDeassert   TxResetSetLimitRSD
  --vhook_a Clk                 TxDataClk
  --vhook_a aReset              {to_Boolean(aResetDelay)}
  --vhook_a acReset             atResetDelay
  TxResetSetLimitRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => TxDataClk,                --in  std_logic
      aReset  => to_Boolean(aResetDelay),  --in  boolean
      acReset => atResetDelay);            --out boolean

  --vhook_e ResetSyncDeassert   TxResetDelayRSD
  --vhook_a Clk                 GenClkDiv
  --vhook_a aReset              {to_Boolean(aResetDelay)}
  --vhook_a acReset             agResetDelay
  TxResetDelayRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => GenClkDiv,                --in  std_logic
      aReset  => to_Boolean(aResetDelay),  --in  boolean
      acReset => agResetDelay);            --out boolean

  --vhook_e ResetSyncDeassert   TxResetSerdesRSD
  --vhook_a Clk                 GenClkDiv
  --vhook_a aReset              {to_Boolean(aResetSerdes)}
  --vhook_a acReset             agResetSerdes
  TxResetSerdesRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => GenClkDiv,                 --in  std_logic
      aReset  => to_Boolean(aResetSerdes),  --in  boolean
      acReset => agResetSerdes);            --out boolean

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

  SerialGen: for i in 0 to kNumChannels-1 generate
      attribute IODELAY_GROUP of DataODelay : label is kIoDelayGroupName;

      attribute DONT_TOUCH: string;
      attribute DONT_TOUCH of DataODelay: label is "TRUE";
  begin

    aStaticTristate(i) <= '0' when aIoOutputEnable = '1' else '1';

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
    -- It only runs once after download/reset               --
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
    --vhook_a DATAOUT              gLvdsOutput(i)
    --vhook_a CASC_IN              '0'
    --vhook_a CASC_RETURN          '0'
    --vhook_a CE                   tOdelayEn(i)
    --vhook_a CLK                  GenClkDiv
    --vhook_a CNTVALUEIN           (others => '0')
    --vhook_a EN_VTC               tTxEnVtc(i)
    --vhook_a INC                  tTxInc(i)
    --vhook_a LOAD                 '0'
    --vhook_a ODATAIN              gLvdsOutputFromOSerdes(i)
    --vhook_a RST                  to_StdLogic(agResetDelay)
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
        DATAOUT     => gLvdsOutput(i),             --out std_ulogic
        CASC_IN     => '0',                        --in  std_ulogic
        CASC_RETURN => '0',                        --in  std_ulogic
        CE          => tOdelayEn(i),               --in  std_ulogic
        CLK         => GenClkDiv,                  --in  std_ulogic
        CNTVALUEIN  => (others => '0'),            --in  std_logic_vector(8:0)
        EN_VTC      => tTxEnVtc(i),                --in  std_ulogic
        INC         => tTxInc(i),                  --in  std_ulogic
        LOAD        => '0',                        --in  std_ulogic
        ODATAIN     => gLvdsOutputFromOSerdes(i),  --in  std_ulogic
        RST         => to_StdLogic(agResetDelay)); --in  std_ulogic

    ------------------------------------------------------
    --Instantiate OSERDES for each channel
    ------------------------------------------------------
    --vhook_i OSERDESE3 OSerdes
    --vhook_a DATA_WIDTH          kSerFactor
    --vhook_a INIT                '0'
    --vhook_a IS_CLKDIV_INVERTED  '0'
    --vhook_a IS_CLK_INVERTED     '0'
    --vhook_a IS_RST_INVERTED     '0'
    --vhook_a ODDR_MODE           "FALSE"
    --vhook_a OSERDES_D_BYPASS    "FALSE"
    --vhook_a OSERDES_T_BYPASS    "FALSE"
    --vhook_a SIM_DEVICE          "ULTRASCALE"
    --vhook_a SIM_VERSION         2.0
    --vhook_a OQ                  gLvdsOutputFromOSerdes(i)
    --vhook_a T_OUT               gTristateOut(i)
    --vhook_a CLK                 GenClk
    --vhook_a CLKDIV              GenClkDiv
    --vhook_a D                   tLvdsGenData(i)
    --vhook_a RST                 to_StdLogic(agResetSerdes)
    --vhook_a T                   aStaticTristate(i)
    OSerdes: OSERDESE3
      generic map (
        DATA_WIDTH         => kSerFactor,    --integer:=8
        INIT               => '0',           --bit:='0'
        IS_CLKDIV_INVERTED => '0',           --bit:='0'
        IS_CLK_INVERTED    => '0',           --bit:='0'
        IS_RST_INVERTED    => '0',           --bit:='0'
        ODDR_MODE          => "FALSE",       --string:="FALSE"
        OSERDES_D_BYPASS   => "FALSE",       --string:="FALSE"
        OSERDES_T_BYPASS   => "FALSE",       --string:="FALSE"
        SIM_DEVICE         => "ULTRASCALE",  --string:="ULTRASCALE"
        SIM_VERSION        => 2.0)           --real:=2.0
      port map (
        OQ     => gLvdsOutputFromOSerdes(i),   --out std_ulogic
        T_OUT  => gTristateOut(i),             --out std_ulogic
        CLK    => GenClk,                      --in  std_ulogic
        CLKDIV => GenClkDiv,                   --in  std_ulogic
        D      => tLvdsGenData(i),             --in  std_logic_vector(7:0)
        RST    => to_StdLogic(agResetSerdes),  --in  std_ulogic
        T      => aStaticTristate(i));         --in  std_ulogic

  end generate SerialGen;

end RTL;
