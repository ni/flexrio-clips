-------------------------------------------------------------------------------
--
-- File: Deserializer.vhd
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
-- Purpose: Deserializer receives the data from the input buffers, routes them
-- through the Idelay blocks, then deserializes the data.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.PkgNi6569.all;
use work.PkgNiUtilities.all;

entity Deserializer is
  generic (
    kNumChannels          : natural := 32;
    kIoDelayGroupName     : string := "IdelayGroup"
  );
  port (
    -- Clocks, Reset & Control
    aResetDelay            : in std_logic;
    aResetSerdes           : in std_logic;
    aDelayCtrlRdy          : in std_logic;
    RxDataClk              : in std_logic;
    AcqClkDiv              : in std_logic;
    AcqClk                 : in std_logic;

    --Input to IDelays
    aLvdsInput             : in std_logic_vector(kNumChannels-1 downto 0);

    --IDELAY and ISERDES control signals
    rRxInc                 : in std_logic_vector(kNumChannels-1 downto 0);
    rRxClkDelayEn          : in std_logic_vector(kNumChannels-1 downto 0);
    rDlyCount              : in DelayArray_t(kNumChannels-1 downto 0);
    rRxCntValOut           : out DelayArray_t(kNumChannels-1 downto 0);
    rIncDecReady           : out std_logic_vector(kNumChannels-1 downto 0);

    --Deserialized data
    qLvdsAcqData           : out DeserArray_t(kNumChannels-1 downto 0)
  );
end Deserializer;

architecture RTL of Deserializer is

  attribute IODELAY_GROUP         : string;
  signal rRxClkCe, rIdelayEn      : std_logic_vector(kNumChannels-1 downto 0);
  signal rRxClkDelayEnTemp        : std_logic_vector(kNumChannels-1 downto 0);
  signal rRxCntValOutLcl          : DelayArray_t(kNumChannels-1 downto 0);
  signal rGetMinimumDelayLimit    : BooleanVector(kNumChannels-1 downto 0);
  signal aLvdsInputFromIdelay     : std_logic_vector(kNumChannels-1 downto 0);
  signal rRxEnVtc                 : std_logic_vector(kNumChannels-1 downto 0);
  signal rSetLowLimitDone         : std_logic_vector(kNumChannels-1 downto 0);
  signal rRxInitialCntValOut      : DelayArray_t(kNumChannels-1 downto 0);

  --vhook_sigstart
  signal aqResetDelay: boolean;
  signal aqResetSerdes: boolean;
  signal arResetDelay: boolean;
  signal rDelayCtrlRdy: std_logic;
  --vhook_sigend

begin

  --vhook_e ResetSyncDeassert   RxResetSetLimitRSD
  --vhook_a Clk                 RxDataClk
  --vhook_a aReset              {to_Boolean(aResetDelay)}
  --vhook_a acReset             arResetDelay
  RxResetSetLimitRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => RxDataClk,                --in  std_logic
      aReset  => to_Boolean(aResetDelay),  --in  boolean
      acReset => arResetDelay);            --out boolean

  --vhook_e ResetSyncDeassert   RxResetDelayRSD
  --vhook_a Clk                 AcqClkDiv
  --vhook_a aReset              {to_Boolean(aResetDelay)}
  --vhook_a acReset             aqResetDelay
  RxResetDelayRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => AcqClkDiv,                --in  std_logic
      aReset  => to_Boolean(aResetDelay),  --in  boolean
      acReset => aqResetDelay);            --out boolean

  --vhook_e ResetSyncDeassert   RxResetSerdesRSD
  --vhook_a Clk                 AcqClkDiv
  --vhook_a aReset              {to_Boolean(aResetSerdes)}
  --vhook_a acReset             aqResetSerdes
  RxResetSerdesRSD: entity work.ResetSyncDeassert (rtl)
    port map (
      Clk     => AcqClkDiv,                 --in  std_logic
      aReset  => to_Boolean(aResetSerdes),  --in  boolean
      acReset => aqResetSerdes);            --out boolean

  --vhook_e DoubleSyncSlAsyncIn  IDelayCtrlReadyDS
  --vhook_g kResetVal            '0'
  --vhook_a aoReset              arResetDelay
  --vhook_a OClk                 RxDataClk
  --vhook_a aSig                 aDelayCtrlRdy
  --vhook_a oSig                 rDelayCtrlRdy
  IDelayCtrlReadyDS: entity work.DoubleSyncSlAsyncIn (rtl)
    generic map (kResetVal => '0')  --std_logic:='0'
    port map (
      aSig    => aDelayCtrlRdy,  --in  std_logic
      aoReset => arResetDelay,   --in  boolean
      OClk    => RxDataClk,      --in  std_logic
      oSig    => rDelayCtrlRdy); --out std_logic

  DataIoDelayGen : for i in 0 to kNumChannels-1 generate
    attribute IODELAY_GROUP of DataIDelay : label is kIoDelayGroupName;

    attribute DONT_TOUCH: string;
    attribute DONT_TOUCH of DataIDelay: label is "TRUE";
  begin

    ---------------------------------------------------------------
    -- Process to detect a rising edge on the user-driven
    -- ClkDelayStrobe signal
    ---------------------------------------------------------------

    RxClockEnablePulseCreation: process (arResetDelay, RxDataClk)
    begin
      if arResetDelay then
        rRxClkDelayEnTemp(i) <= '0';
        rRxClkCe(i) <= '0';
      elsif rising_edge(RxDataClk) then
          rRxClkDelayEnTemp(i) <= rRxClkDelayEn(i);
          if (rRxClkDelayEn(i) and (not rRxClkDelayEnTemp(i))) = '1' then
            rRxClkCe(i) <= '1';
          else
            rRxClkCe(i) <= '0';
          end if;
      end if;
    end process RxClockEnablePulseCreation;

    ----------------------------------------------------------
    -- This state machine sets the lower limit delay value. --
    -- It only runs once after download/reset               --
    ----------------------------------------------------------
    --vhook_e GetMinDelayLimit         RxGetDelayLimit
    --vhook_a Clk                      RxDataClk
    --vhook_a aReset                   arResetDelay
    --vhook_a cGetMinimumDelayLimit    rGetMinimumDelayLimit(i)
    --vhook_a cCntValFromIdelay        rRxCntValOutLcl(i)
    --vhook_a cSetLowLimitDone         rSetLowLimitDone(i)
    --vhook_a cAlignDelayValue         rRxInitialCntValOut(i)
    RxGetDelayLimit: entity work.GetMinDelayLimit (rtl)
      port map (
        Clk                   => RxDataClk,                 --in  std_logic
        aReset                => arResetDelay,              --in  boolean
        cGetMinimumDelayLimit => rGetMinimumDelayLimit(i),  --in  boolean
        cCntValFromIdelay     => rRxCntValOutLcl(i),        --in  std_logic_vector(kDelayCntValSize-1:0)
        cSetLowLimitDone      => rSetLowLimitDone(i),       --out std_logic
        cAlignDelayValue      => rRxInitialCntValOut(i));   --out std_logic_vector(kDelayCntValSize-1:0)

    ------------------------------------------------------------------------------
    -- State machine to check whether the delay value is within allowable range --
    ------------------------------------------------------------------------------
    --vhook_e UpperLowerDelayLimit     RxUpperLowerDelayLimitx
    --vhook_a Clk                      RxDataClk
    --vhook_a aReset                   arResetDelay
    --vhook_a cDelayCtrlRdy            {to_Boolean(rDelayCtrlRdy)}
    --vhook_a cSetLowLimitDone         {to_Boolean(rSetLowLimitDone(i))}
    --vhook_a cMinDecTap               rRxInitialCntValOut(i)
    --vhook_a cRequestDelay            {to_Boolean(rRxClkCe(i))}
    --vhook_a cInc                     rRxInc(i)
    --vhook_a cCntValFromIdelay        rRxCntValOutLcl(i)
    --vhook_a cDlyCount                rDlyCount(i)
    --vhook_a cGetMinimumDelayLimit    rGetMinimumDelayLimit(i)
    --vhook_a cEnVtc                   rRxEnVtc(i)
    --vhook_a cDelayEn                 rIdelayEn(i)
    --vhook_a cIncDecReady             rIncDecReady(i)
    --vhook_a cDisplayCountValue       rRxCntValOut(i)
    RxUpperLowerDelayLimitx: entity work.UpperLowerDelayLimit (rtl)
      port map (
        Clk                   => RxDataClk,                        --in  std_logic
        aReset                => arResetDelay,                     --in  boolean
        cDelayCtrlRdy         => to_Boolean(rDelayCtrlRdy),        --in  boolean
        cSetLowLimitDone      => to_Boolean(rSetLowLimitDone(i)),  --in  boolean
        cMinDecTap            => rRxInitialCntValOut(i),           --in  std_logic_vector(kDelayCntValSize-1:0)
        cRequestDelay         => to_Boolean(rRxClkCe(i)),          --in  boolean
        cInc                  => rRxInc(i),                        --in  std_logic
        cCntValFromIdelay     => rRxCntValOutLcl(i),               --in  std_logic_vector(kDelayCntValSize-1:0)
        cDlyCount             => rDlyCount(i),                     --in  std_logic_vector(kDelayCntValSize-1:0)
        cGetMinimumDelayLimit => rGetMinimumDelayLimit(i),         --out boolean
        cEnVtc                => rRxEnVtc(i),                      --out std_logic
        cDelayEn              => rIdelayEn(i),                     --out std_logic
        cIncDecReady          => rIncDecReady(i),                  --out std_logic
        cDisplayCountValue    => rRxCntValOut(i));                 --out std_logic_vector(kDelayCntValSize-1:0)

    -----------------------------------------------------------
    --Instantiate an IoDelay for each channel
    -----------------------------------------------------------
    -- Referring to AR#67859, for users of 2016.2 with an initial DELAY_VALUE of less than 20 ps,
    -- the delay in hardware will not be what was requested. However all of the IDELAY/ODELAYs
    -- with bytes/banks that have the same DELAY_VALUE will be aligned to each other.
    -- To work around the issue, choose an initial DELAY_VALUE equal to or greater than 20 ps.

    --vhook_i IDELAYE3             DataIDelay
    --vhook_a CASCADE              "NONE"
    --vhook_a DELAY_FORMAT         "TIME"
    --vhook_a DELAY_SRC            "IDATAIN"
    --vhook_a DELAY_TYPE           "VAR_LOAD"
    --vhook_a DELAY_VALUE          20
    --vhook_a IS_CLK_INVERTED      '0'
    --vhook_a IS_RST_INVERTED      '0'
    --vhook_a LOOPBACK             "FALSE"
    --vhook_a REFCLK_FREQUENCY     200.0
    --vhook_a SIM_DEVICE           "ULTRASCALE"
    --vhook_a SIM_VERSION          2.0
    --vhook_a UPDATE_MODE          "ASYNC"
    --vhook_a CASC_OUT             open
    --vhook_a CNTVALUEOUT          rRxCntValOutLcl(i)
    --vhook_a DATAOUT              aLvdsInputFromIdelay(i)
    --vhook_a CASC_IN              '0'
    --vhook_a CASC_RETURN          '0'
    --vhook_a CE                   rIdelayEn(i)
    --vhook_a CLK                  AcqClkDiv
    --vhook_a CNTVALUEIN           (others => '0')
    --vhook_a DATAIN               '0'
    --vhook_a EN_VTC               rRxEnVtc(i)
    --vhook_a IDATAIN              aLvdsInput(i)
    --vhook_a INC                  rRxInc(i)
    --vhook_a LOAD                 '0'
    --vhook_a RST                  to_StdLogic(aqResetDelay)
    DataIDelay: IDELAYE3
      generic map (
        CASCADE          => "NONE",        --string:="NONE"
        DELAY_FORMAT     => "TIME",        --string:="TIME"
        DELAY_SRC        => "IDATAIN",     --string:="IDATAIN"
        DELAY_TYPE       => "VAR_LOAD",    --string:="FIXED"
        DELAY_VALUE      => 20,            --integer:=0
        IS_CLK_INVERTED  => '0',           --bit:='0'
        IS_RST_INVERTED  => '0',           --bit:='0'
        LOOPBACK         => "FALSE",       --string:="FALSE"
        REFCLK_FREQUENCY => 200.0,         --real:=300.0
        SIM_DEVICE       => "ULTRASCALE",  --string:="ULTRASCALE"
        SIM_VERSION      => 2.0,           --real:=2.0
        UPDATE_MODE      => "ASYNC")       --string:="ASYNC"
      port map (
        CASC_OUT    => open,                       --out std_ulogic
        CNTVALUEOUT => rRxCntValOutLcl(i),         --out std_logic_vector(8:0)
        DATAOUT     => aLvdsInputFromIdelay(i),    --out std_ulogic
        CASC_IN     => '0',                        --in  std_ulogic
        CASC_RETURN => '0',                        --in  std_ulogic
        CE          => rIdelayEn(i),               --in  std_ulogic
        CLK         => AcqClkDiv,                  --in  std_ulogic
        CNTVALUEIN  => (others => '0'),            --in  std_logic_vector(8:0)
        DATAIN      => '0',                        --in  std_ulogic
        EN_VTC      => rRxEnVtc(i),                --in  std_ulogic
        IDATAIN     => aLvdsInput(i),              --in  std_ulogic
        INC         => rRxInc(i),                  --in  std_ulogic
        LOAD        => '0',                        --in  std_ulogic
        RST         => to_StdLogic(aqResetDelay)); --in  std_ulogic

    ------------------------------------------------------
    --Instantiate ISERDES for each channel
    ------------------------------------------------------
    --vhook_i ISERDESE3 ISerdes
    --vhook_a DATA_WIDTH          kDeserFactor
    --vhook_a DDR_CLK_EDGE        "OPPOSITE_EDGE"
    --vhook_a FIFO_ENABLE         "FALSE"
    --vhook_a FIFO_SYNC_MODE      "FALSE"
    --vhook_a IDDR_MODE           "FALSE"
    --vhook_a IS_CLK_B_INVERTED    '1'
    --vhook_a IS_CLK_INVERTED      '0'
    --vhook_a IS_RST_INVERTED      '0'
    --vhook_a SIM_DEVICE           "ULTRASCALE"
    --vhook_a SIM_VERSION          2.0
    --vhook_a FIFO_EMPTY          open
    --vhook_a INTERNAL_DIVCLK     open
    --vhook_a Q                   qLvdsAcqData(i)
    --vhook_a CLK                 AcqClk
    --vhook_a CLKDIV              AcqClkDiv
    --vhook_a CLK_B               AcqClk
    --vhook_a D                   aLvdsInputFromIdelay(i)
    --vhook_a FIFO_RD_CLK         '0'
    --vhook_a FIFO_RD_EN          '0'
    --vhook_a RST                 to_StdLogic(aqResetSerdes)
    ISerdes: ISERDESE3
      generic map (
        DATA_WIDTH        => kDeserFactor,     --integer:=8
        DDR_CLK_EDGE      => "OPPOSITE_EDGE",  --string:="OPPOSITE_EDGE"
        FIFO_ENABLE       => "FALSE",          --string:="FALSE"
        FIFO_SYNC_MODE    => "FALSE",          --string:="FALSE"
        IDDR_MODE         => "FALSE",          --string:="FALSE"
        IS_CLK_B_INVERTED => '1',              --bit:='0'
        IS_CLK_INVERTED   => '0',              --bit:='0'
        IS_RST_INVERTED   => '0',              --bit:='0'
        SIM_DEVICE        => "ULTRASCALE",     --string:="ULTRASCALE"
        SIM_VERSION       => 2.0)              --real:=2.0
      port map (
        FIFO_EMPTY      => open,                        --out std_ulogic
        INTERNAL_DIVCLK => open,                        --out std_ulogic
        Q               => qLvdsAcqData(i),             --out std_logic_vector(7:0)
        CLK             => AcqClk,                      --in  std_ulogic
        CLKDIV          => AcqClkDiv,                   --in  std_ulogic
        CLK_B           => AcqClk,                      --in  std_ulogic
        D               => aLvdsInputFromIdelay(i),     --in  std_ulogic
        FIFO_RD_CLK     => '0',                         --in  std_ulogic
        FIFO_RD_EN      => '0',                         --in  std_ulogic
        RST             => to_StdLogic(aqResetSerdes)); --in  std_ulogic

  end generate DataIoDelayGen;

end RTL;
