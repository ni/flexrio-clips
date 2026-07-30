-------------------------------------------------------------------------------
--
-- File: PkgMipiTypes.vhd
-- Author: Craig Conway
-- Original Project: NI Cores MIPI CSI-2 IP
-- Date: 13 November 2019
--
-------------------------------------------------------------------------------
-- (c) 2019 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--   This package contains records that consolidate the signals connecting
-- to Xilinx D-PHY Tx and Rx cores.
--
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library work;
   use work.PkgDphyIfcRegMap.all;

package PkgMipiTypes is

  constant kFifoPktCntSize : natural := 14;
  subtype FifoPktCnt_t is unsigned(kFifoPktCntSize - 1 downto 0);
  type FifoPktCntAry_t is array (natural range <>) of FifoPktCnt_t;

  constant kDPhyLanes : natural := 4;

  type MipiTxHsLaneIn_t is record
    TxDataHS : std_logic_vector(7 downto 0); --in: dlx_txdatahs(7:0)
    TxRequestHS : std_logic;
  end record;

  type MipiTxHsLaneInAry_t is array(kDPhyLanes-1 downto 0) of MipiTxHsLaneIn_t;

  type MipiTxEscLaneIn_t is record
    TxRequestEsc : std_logic;
    TxLpdtEsc : std_logic;
    TxUlpsEsc : std_logic;
    TxUlpsExit : std_logic;
    TxTriggerEsc : std_logic_vector(3 downto 0);
    TxDataEsc : std_logic_vector(7 downto 0);
    TxValidEsc : std_logic;
  end record;

  constant kMipiTxEscLaneInZero : MipiTxEscLaneIn_t := (TxDataEsc=>X"00", TxTriggerEsc=>X"0", others=>'0');

  subtype ActiveLaneCount_t is unsigned(2 downto 0);

  type MipiChanIn_t is record
    cCoreRst : std_logic;
    aEnable : std_logic;
    -- TX signals
    aContinuousHsMode : std_logic;   -- th prefix = TxByteClkHS
    cTxUlpsClk : std_logic;          -- c prefix = CoreClk
    cTxUlpsExit : std_logic;         -- te prefix = Tx Esc Clock
    teTxRequestEsc : std_logic;      -- b prefix = BusClk
    teTxLpdtEsc : std_logic;
    aForceTxStopMode : std_logic;
    bTxStopStateDwell : std_logic_vector(kTxStopStateDwellSize-1 downto 0);
    bTxHighSpeedDwell : std_logic_vector(kTxHighSpeedDwellSize-1 downto 0);
    bActiveLaneCount : ActiveLaneCount_t;
    -- RX signals
    aForceRxMode : std_logic;
  end record;

  constant kMipiChanInZero : MipiChanIn_t := (
     bTxStopStateDwell => (others=>'0'),
     bTxHighSpeedDwell => (others=>'0'),
     bActiveLaneCount  => to_unsigned(4, ActiveLaneCount_t'length),
     others => '0');

  type MipiChanInAry_t is array (natural range <>) of MipiChanIn_t;

  -- This record reports status of Tx and Rx
  type MipiChanOut_t is record
    PacketGenBusy, ChannelIsRx, InitDone, StopState, UlpsActiveNot, PllLockOut, -- rx and tx
    MmcmLockOut, -- tx only
    RxClkActiveHS, RxUlpsClkNot : std_logic; -- rx only
  end record;

  constant kMipiChanOutZero : MipiChanOut_t := (UlpsActiveNot=>'1', RxUlpsClkNot=>'1', others=>'0');

  type MipiChanOutAry_t is array (natural range <>) of MipiChanOut_t;

  -- type MipiTxLaneIn_t is record
  --   aEnable : std_logic;
  --   aForceTxStopMode : std_logic;
  --   thHS : MipiTxHsLaneIn_t; -- high speed signals
  --   teEsc : MipiTxEscLaneIn_t; -- escape mode signals
  -- end record;
  -- type MipiTxLaneInAry_t is array(kDPhyLanes-1 downto 0) of MipiTxLaneIn_t;

  -- type MipiTxIn_t is record
  --   aClEnable : std_logic;
  --   thClTxRequestHS : std_logic;
  --   cClTxUlpsClk : std_logic;
  --   cClTxUlpsExit : std_logic;
  --   TxClkEsc : std_logic; --prefix te
  --   Lane : MipiTxLaneInAry_t;
  -- end record;

  -- type MipiTxLaneOut_t is record
  --   aUlpsActiveNot : std_logic;
  --   thTxReadyHS : std_logic; -- out: dlx_txreadyhs
  --   teTxReadyEsc : std_logic;
  --   aStopState : std_logic;
  -- end record;
  -- type MipiTxLaneOutAry_t is array(kDPhyLanes-1 downto 0) of MipiTxLaneOut_t;

  -- type MipiTxOut_t is record
  --   aInitDone : std_logic;
  --   --TxClkEscOut : std_logic; -- prefix te
  --   --aMmcmLockOut : std_logic;
  --   aClStopState : std_logic;
  --   aClUlpsActiveNot : std_logic;
  --   thClTxClkActiveHS : std_logic;
  --   --TxByteClkHS : std_logic; -- prefix th -- 10-187.5 MHz (derived from lineclk/8)
  --   Lane : MipiTxLaneOutAry_t;
  -- end record;

  -- type MipiRxLaneIn_t is record
  --   aEnable : std_logic;
  --     -- Enable Lane Module (for specific lane)
  --     -- This active-High signal forces the lane module out of
  --     -- “shutdown”. All line drivers, receivers, terminators,
  --     -- and contention detectors are turned off when Enable is
  --     -- Low. When Enable is Low, all other PPI inputs are
  --     -- ignored and all PPI outputs are driven to the default
  --     -- inactive state. Enable is level sensitive and does not
  --     -- depend on any clock.
  --   aForceRxMode : std_logic;
  --     -- Force Lane Module to Re-Initialization.
  --     -- This signal allows the protocol to initialize a Lane module
  --     -- and should be released, that is, driven Low, only when the
  --     -- Dp and Dn inputs are in the Stop state for a time T_INIT, or
  --     -- longer.
  --     -- Note: Assert this signal when the RX Data Lane is in
  --     -- stopstate. Asserting this signal in the middle of High-Speed
  --     -- data reception will result in data integrity failures.
  -- end record;
  -- type MipiRxLaneInAry_t is array(kDPhyLanes-1 downto 0) of MipiRxLaneIn_t;

  type MipiRxIn_t is record
    aClEnable : std_logic;
      -- Enable Lane Module (for entire channel).
      -- This active-High signal forces the lane module out of
      -- “shutdown”. All line drivers, receivers, terminators,
      -- and contention detectors are turned off when Enable is
      -- Low. When Enable is Low, all other PPI inputs are
      -- ignored and all PPI outputs are driven to the default
      -- inactive state. Enable is level sensitive and does not
      -- depend on any clock.
      -- In addition to driving the channel's Enable input, this
      -- also drives the Enable input for each lane instead of
      -- allowing per-lane control.
    aClForceRxMode : std_logic;
      -- This drives the 4 ForceRxMode signals on the lanes instead
      -- of allowing per-lane control.
  end record;

  -- prefix rh == RxByteClkHS
  -- prefix re == RxClkEsc (per lane clock)

  -- These signals are used by Lanes and by Channels
  type MipiRxHsOut_t is record
    Valid : std_logic; -- This connects to a FIFO's iWt or oDataValid signals. It is ignored when flattening
    RxActiveHS : std_logic;
      -- High-Speed Reception Active.
      -- This active-High signal indicates that the lane module is actively
      -- receiving a high-speed transmission from the lane interconnect.
    RxValidHS : std_logic;
      -- High-Speed Receive Data Valid.
      -- This active-High signal indicates that the lane module is driving
      -- data to the protocol on the rxdatahs[7:0] output. There is no
      -- rxreadyhs signal, and the protocol is expected to capture
      -- rxdatahs[7:0] on every rising edge of rxbyteclkhs where rxvalidhs
      -- is asserted. There is no provision for the protocol to slow down
      -- (throttle) the receive data.
    RxSyncHS : std_logic;
      -- Receiver Synchronization Observed.
      -- This active-High signal indicates that the Lane module has seen
      -- an appropriate synchronization event. rxsynchs is High for one
      -- cycle of rxbyteclkhs at the beginning of a high-speed transmission
      -- when rxactivehs is first asserted.
    --RxSkewCalHS : std_logic;  -- this doesn't seem to appear in the Xilinx Rx instance
      -- High-Speed Receive Skew Calibration.
      -- This active high signal indicates that the high speed deskew burst
      -- is being received.
    ErrSoTHS : std_logic;
      -- Start-of-Transmission (SoT) Error.
      -- If the high-speed SoT leader sequence is corrupted, but in such a
      -- way that proper synchronization can still be achieved, this active-
      -- High signal is asserted for one cycle of rxbyteclkhs. This is
      -- considered to be a soft error in the leader sequence and confidence
      -- in the payload data is reduced.
    ErrSoTSyncHS : std_logic;
      -- Start-of-Transmission Synchronization Error.
      -- If the high-speed SoT leader sequence is corrupted in a way that
      -- proper synchronization cannot be expected, this active-High signal is
      -- asserted for one cycle of rxbyteclkhs.
    EoT : std_logic; -- This is not provided by the PHY. We have to create it ourselves.
    InternalError : std_logic; -- Driven by NI's error detection circuit.
    RxSkewCalHS : std_logic; -- Skew Calibration detected.
  end record;


  type MipiRxHsLaneOut_t is record
    RxDataHS : unsigned(7 downto 0);
    Stat : MipiRxHsOut_t;
  end record;

  type MipiRxHsChanOut_t is record
    RxDataHS : unsigned(31 downto 0);
    Stat : MipiRxHsOut_t;
  end record;

  constant kRxLaneHsUnpackWidth : natural := 16;
  constant kRxChanHsUnpackWidth : natural := 40;
  constant kMipiRxHsOutZero : MipiRxHsOut_t := (others=>'0');
  constant kMipiRxHsLaneOutZero : MipiRxHsLaneOut_t := (RxDataHS=>X"00", Stat=>kMipiRxHsOutZero);
  constant kMipiRxHsChanOutZero : MipiRxHsChanOut_t := (RxDataHS=>X"00000000", Stat=>kMipiRxHsOutZero);

  function To_Unsigned(x : MipiRxHsOut_t) return unsigned;
  function To_MipiRxHsOut(x : unsigned) return MipiRxHsOut_t;
  function To_Unsigned(x : MipiRxHsLaneOut_t) return unsigned;
  function To_MipiRxHsLaneOut(x : unsigned) return MipiRxHsLaneOut_t;
  function To_Unsigned(x : MipiRxHsChanOut_t) return unsigned;
  function To_MipiRxHsChanOut(x : unsigned) return MipiRxHsChanOut_t;


  -- constant kMipiRxHsLaneOutZero : MipiRxHsLaneOut_t := (RxDataHS=>X"00", others=>'0');

  -- function To_Unsigned(x : MipiRxHsLaneOut_t) return unsigned;
  -- function To_MipiRxHsLaneOut(x : unsigned) return MipiRxHsLaneOut_t;

  type MipiRxEscLaneOut_t is record
    RxLpdtEsc : std_logic;
      -- Escape Low-Power Data Receive Mode.
      -- This active-High signal is asserted to indicate that the lane module is
      -- in low-power data receive mode. While in this mode, received data
      -- bytes are driven onto the rxdataesc[7:0] output when rxvalidesc is
      -- active. The lane module remains in this mode with rxlpdtesc
      -- asserted until a Stop state is detected on the lane interconnect.
    RxUlpsEsc : std_logic;
      -- Escape Ultra-Low Power (Receive) Mode. This active-High signal is
      -- asserted to indicate that the lane module has entered the ultra-low
      -- power state. The lane module remains in this mode with rxulpsesc
      -- asserted until a Stop state is detected on the lane interconnect.
    RxTriggerEsc : std_logic_vector(3 downto 0);
      -- Escape Mode Receive Trigger 0-3.
      -- These active-High signals indicate that a trigger event has been
      -- received. The asserted rxtriggeresc[3:0] signal remains active until a
      -- Stop state is detected on the lane interconnect. The following
      -- mapping is done by the D-PHY RX module:
      -- * Reset-Trigger -> rxtriggeresc[3:0] = 4'b0001
      -- * Unknown-3 -> rxtriggeresc[3:0] = 4'b0010
      -- * Unknown-4 -> rxtriggeresc[3:0] = 4'b0100
      -- * Unknown-5 -> rxtriggeresc[3:0] = 4'b1000
    RxDataEsc : std_logic_vector(7 downto 0);
      -- Escape Mode Receive Data.
      -- This is the eight-bit escape mode low-power data received by the
      -- lane module. The signal connected to rxdataesc[0] is received first.
      -- Data is transferred on rising edges of rxclkesc.
    RxValidEsc : std_logic;
      -- Escape Mode Receive Data Valid.
      -- This active-High signal indicates that the lane module is driving valid
      -- data to the protocol on the rxdataesc[7:0] output. There is no
      -- rxreadyesc signal, and the protocol is expected to capture
      -- rxdataesc[7:0] on every rising edge of rxclkesc where rxvalidesc is
      -- asserted. There is no provision for the protocol to slow down
      -- (throttle) the receive data.
  end record;

  constant kMipiRxEscLaneOutZero : MipiRxEscLaneOut_t := (RxDataEsc=>X"00",
                                                          RxTriggerEsc=>X"0",
                                                          others=>'0');

  type MipiRxAsyncLaneOut_t is record
    -- StopState : std_logic;
    --   -- Lane is in Stop state.
    --   -- This active-High signal indicates that the Lane module
    --   -- (TX or RX) is currently in the Stop state. Also, the
    --   -- protocol can use this signal to indirectly determine if
    --   -- the PHY line levels are in the LP-11 state.
    --   -- Note: This signal is asynchronous to any clock in the
    --   -- PPI.
    -- UlpsActiveNot : std_logic;
    --   -- ULP State (not) Active.
    --   -- This active-Low signal is asserted to indicate that the
    --   -- Lane is in the ULP state. For a receiver, this signal
    --   -- indicates that the Lane is in the Ultra Low Power (ULP)
    --   -- state. At the beginning of the ULP state, ulpsactivenot
    --   -- is asserted together with rxulpsesc, or rxclkulpsnot for
    --   -- a clock lane. At the end of the ULP state, this signal
    --   -- becomes inactive to indicate that the Mark-1 state has
    --   -- been observed. Later, after a period of time (Twakeup),
    --   -- the rxulpsesc (or rxclkulpsnot) signal is deasserted.
    RxClkEsc : std_logic; -- prefix re, 10-20 MHz
      -- Escape Mode Receive Clock.
      -- This signal is used to transfer received data to the protocol during
      -- escape mode. This clock is generated from the two low-power
      -- signals in the lane interconnect. Because of the asynchronous nature
      -- of escape mode data transmission, this clock cannot be periodic.
    ErrEsc : std_logic;
      -- Escape Entry Error.
      -- If an unrecognized escape entry command is received, this active-
      -- High signal is asserted and remains asserted until the next change in
      -- line state.
    ErrSyncEsc : std_logic;
      -- Low-Power Data Transmission Synchronization Error.
      -- If the number of bits received during a low-power data transmission
      -- is not a multiple of eight when the transmission ends, this active-
      -- High signal is asserted and remains asserted until the next change in
      -- line state.
    ErrControl : std_logic;
      -- Control Error.
      -- This active-High signal is asserted when an incorrect line state
      -- sequence is detected. For example, if a turn-around request or
      -- escape mode request is immediately followed by a Stop state instead
      -- of the required Bridge state, this signal is asserted and remains
      -- asserted until the next change in line state.
  end record;

  constant kMipiRxAsyncLaneOutZero : MipiRxAsyncLaneOut_t := (others => '0');

  -- type MipiRxHsChanOut_t is record
  --   -- These signals are collected from the various lanes after
  --   -- the lane merging function
  --   RxDataHS : unsigned(31 downto 0);
  --   Sig : MipiRxHsSignals_t;
  --   RxValidHS : std_logic;
  --   RxActiveHS : std_logic;
  --   RxSyncHS : std_logic;
  --   ErrSoTHS : std_logic;
  --   ErrSoTSyncHS : std_logic;
  --   EoT : std_logic; -- This is not provided by the PHY. We have to create it ourselves.
  --   Valid : std_logic; -- This connects to a FIFO's iWt or oDataValid signals.
  -- end record;

  -- constant kMipiRxHsOutZero : MipiRxHsOut_t := (RxDataHS=>32X"0", others=>'0');
  -- function To_Unsigned(x : MipiRxHsOut_t) return unsigned;
  -- function To_MipiRxHsOut(x : unsigned) return MipiRxHsOut_t;

  -- type MipiRxAsyncOut_t is record
  --   InitDone : std_logic;
  --   ClStopState : std_logic;
  --     -- Channel is in Stop state.
  --     -- This active-High signal indicates that the channel
  --     -- (TX or RX) is currently in the Stop state. Also, the
  --     -- protocol can use this signal to indirectly determine if
  --     -- the PHY line levels are in the LP-11 state.
  --     -- Note: This signal is asynchronous to any clock in the
  --     -- PPI.
  --   ClUlpsActiveNot : std_logic;
  --     -- ULP State (not) Active.
  --     -- This active-Low signal is asserted to indicate that the
  --     -- Lane is in the ULP state. For a receiver, this signal
  --     -- indicates that the Lane is in the Ultra Low Power (ULP)
  --     -- state. At the beginning of the ULP state, ulpsactivenot
  --     -- is asserted together with rxulpsesc, or rxclkulpsnot for
  --     -- a clock lane. At the end of the ULP state, this signal
  --     -- becomes inactive to indicate that the Mark-1 state has
  --     -- been observed. Later, after a period of time (Twakeup),
  --     -- the rxulpsesc (or rxclkulpsnot) signal is deasserted.
  --   ClRxClkActiveHS : std_logic;
  --     -- Receiver Clock Active.
  --     -- This asynchronous, active-High signal indicates that a clock lane
  --     -- is receiving a Double Data Rate (DDR) clock signal.
  --   ClRxUlpsClkNot : std_logic;
  --     -- Receiver Ultra-Low Power State on Clock Lane.
  --     -- This active-Low signal is asserted to indicate that the clock lane
  --     -- module has entered the ultra-low power state. The lane module
  --     -- remains in this mode with rxulpsclknot asserted until a Stop state
  --     -- is detected on the lane interconnect.
  -- end record;



  -- type MipiRxChanOut_t is record
  --   dHS : MipiRxHsOut_t;
  --   aStat : MipiRxAsyncOut_t;
  -- end record;


  --   -- Merged high-speed lane signals
  --   rhHS : MipiRxHsOut_t;
  --   -- The escape mode signals are not included at this time
  -- end record;

  type MipiPins_t is record
    Clk_p, Clk_n : std_logic;
    cData_p, cData_n : std_logic_vector(kDPhyLanes-1 downto 0);
  end record;

  constant kMipiPinsZero : MipiPins_t := (Clk_p=>'0',
                                          Clk_n=>'0',
                                          others=>(others=>'0'));

  subtype MipiPinsFlat_t is std_logic_vector(kDPhyLanes*2+1 downto 0);

  function Flatten(Rec:MipiPins_t) return MipiPinsFlat_t;
  function Unflatten(Vec:MipiPinsFlat_t) return MipiPins_t;

  type MipiPinsAry_t is array (natural range <>) of MipiPins_t;

  type MipiPinsFlatAry_t is array (natural range <>) of MipiPinsFlat_t;
  function Flatten(Arr:MipiPinsAry_t) return MipiPinsFlatAry_t;
  function Unflatten(Arr:MipiPinsFlatAry_t) return MipiPinsAry_t;

  -- type AxiSlaveIn_t is record
  --   WriteAddressChannel : Axi4LiteAddressChannel_t;
  --   WriteDataChannel : Axi4LiteWriteDataChannel_t;
  --   WriteResponseReady : std_logic;
  --   ReadAddressChannel : Axi4LiteAddressChannel_t;
  --   ReadDataReady : std_logic;
  -- end record;

  -- type AxiSlaveOut_t is record
  --   WriteAddressReady : std_logic;
  --   WriteDataReady : std_logic;
  --   WriteResponseChannel : Axi4LiteWriteResponseChannel_t;
  --   ReadAddressReady : std_logic;
  --   ReadDataChannel : Axi4LiteReadDataChannel_t;
  -- end record;

  type PacketGen_t is record
    Header      : std_logic_vector(47 downto 16);
    FillerCount : std_logic_vector(15 downto 8);
    Go          : std_logic_vector(7 downto 0); -- This must be LSB for ease of channel selection.
  end record;

  constant kPacketGenZero : PacketGen_t := (others=>(others=>'0'));

  subtype PacketGenFlat_t is std_logic_vector(kPacketGenZero.Header'left downto 0);

  function Flatten(Rec:PacketGen_t) return PacketGenFlat_t;
  function Unflatten(Vec:PacketGenFlat_t) return PacketGen_t;


  type TxDebug_t is record
    vEmptyCount : std_logic_vector(8 downto 0);
    thFullCount : std_logic_vector(5 downto 0);
    thLaneHasSpace : std_logic_vector(3 downto 0);
    thLaneHasData : std_logic_vector(3 downto 0);
    thPacketCount : std_logic_vector(13 downto 0);
    thDlState : std_logic_vector(4 downto 0);
    thClHighSpeed : std_logic;
    thWordCount : std_logic_vector(15 downto 0);
  end record;

  constant kTxDebugZero : TxDebug_t := (thClHighSpeed=>'0', others => (others => '0'));

end package PkgMipiTypes;

package body PkgMipiTypes is

  function To_Unsigned(x : MipiRxHsOut_t) return unsigned is
    variable Val : unsigned(7 downto 0) := (others => '0');
  begin
    -- The .Valid field is ignored because it is used for connecting to a FIFO's control signals.
    Val(7) := x.RxSkewCalHS;
    Val(6) := x.RxActiveHS;
    Val(5) := x.RxValidHS;
    Val(4) := x.RxSyncHS;
    Val(3) := x.ErrSoTHS;
    Val(2) := x.ErrSoTSyncHS;
    Val(1) := x.EoT;
    Val(0) := x.InternalError;
    return Val;
  end function To_Unsigned;

  function To_MipiRxHsOut(x : unsigned) return MipiRxHsOut_t is
    variable Vec : unsigned(x'length-1 downto 0) := x;
    variable Val : MipiRxHsOut_t;
  begin
    Val.RxSkewCalHS := Vec(7);
    Val.RxActiveHS := Vec(6);
    Val.RxValidHS := Vec(5);
    Val.RxSyncHS := Vec(4);
    Val.ErrSoTHS := Vec(3);
    Val.ErrSoTSyncHS := Vec(2);
    Val.EoT := Vec(1);
    Val.InternalError := Vec(0);
    return Val;
  end function To_MipiRxHsOut;

  function To_Unsigned(x : MipiRxHsLaneOut_t) return unsigned is
    variable Val : unsigned(kRxLaneHsUnpackWidth-1 downto 0) := (others => '0');
  begin
    Val := To_Unsigned(x.Stat) & x.RxDataHS;
    return Val;
  end function To_Unsigned;

  function To_MipiRxHsLaneOut(x : unsigned) return MipiRxHsLaneOut_t is
    variable Val : MipiRxHsLaneOut_t;
  begin
    Val.Stat := To_MipiRxHsOut(x(kRxLaneHsUnpackWidth-1 downto 8));
    Val.RxDataHS := x(7 downto 0);
    return Val;
  end function To_MipiRxHsLaneOut;

  function To_Unsigned(x : MipiRxHsChanOut_t) return unsigned is
    variable Val : unsigned(kRxChanHsUnpackWidth-1 downto 0) := (others => '0');
  begin
    Val := To_Unsigned(x.Stat) & x.RxDataHS;
    return Val;
  end function To_Unsigned;

  function To_MipiRxHsChanOut(x : unsigned) return MipiRxHsChanOut_t is
    variable Val : MipiRxHsChanOut_t;
  begin
    Val.Stat := To_MipiRxHsOut(x(kRxChanHsUnpackWidth-1 downto 32));
    Val.RxDataHS := x(31 downto 0);
    return Val;
  end function To_MipiRxHsChanOut;

  function Flatten(Rec:PacketGen_t) return PacketGenFlat_t is
    variable Vec : PacketGenFlat_t;
  begin
    Vec(kPacketGenZero.Header'range) := Rec.Header;
    Vec(kPacketGenZero.FillerCount'range) := Rec.FillerCount;
    Vec(kPacketGenZero.Go'range) := Rec.Go;
    return Vec;
  end function Flatten;

  function Unflatten(Vec:PacketGenFlat_t) return PacketGen_t is
    variable Rec : PacketGen_t;
  begin
    Rec.Header := Vec(kPacketGenZero.Header'range);
    Rec.FillerCount := Vec(kPacketGenZero.FillerCount'range);
    Rec.Go := Vec(kPacketGenZero.Go'range);
    return Rec;
  end function Unflatten;

  function Flatten(Rec:MipiPins_t) return MipiPinsFlat_t is
    variable Vec : MipiPinsFlat_t;
  begin
    for i in 0 to kDPhyLanes-1 loop
      Vec(i*2) := Rec.cData_p(i);
      Vec(i*2+1) := Rec.cData_n(i);
    end loop;
    Vec(kDPhyLanes*2) := Rec.Clk_p;
    Vec(kDPhyLanes*2+1) := Rec.Clk_n;
    return Vec;
  end function Flatten;

  function Unflatten(Vec: MipiPinsFlat_t) return MipiPins_t is
    variable Rec : MipiPins_t;
  begin
    for i in 0 to kDPhyLanes-1 loop
      Rec.cData_p(i) := Vec(i*2);
      Rec.cData_n(i) := Vec(i*2+1);
    end loop;
    Rec.Clk_p := Vec(kDPhyLanes*2);
    Rec.Clk_n := Vec(kDPhyLanes*2+1);
    return Rec;
  end function Unflatten;

  function Flatten(Arr: MipiPinsAry_t) return MipiPinsFlatAry_t is
    variable ToRet : MipiPinsFlatAry_t(Arr'length - 1 downto 0);
  begin
    for i in 0 to Arr'length - 1 loop
      ToRet(i) := Flatten(Arr(i));
    end loop;
    return ToRet;
  end function Flatten;

  function Unflatten(Arr: MipiPinsFlatAry_t) return MipiPinsAry_t is
    variable ToRet : MipiPinsAry_t(Arr'length - 1 downto 0);
  begin
    for i in 0 to Arr'length - 1 loop
      ToRet(i) := Unflatten(Arr(i));
    end loop;
    return ToRet;
  end function Unflatten;

end package body PkgMipiTypes;
