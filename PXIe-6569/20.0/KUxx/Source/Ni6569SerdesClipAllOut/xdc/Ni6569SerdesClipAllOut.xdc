# Clocking
create_clock -name LmkClk -period 6.4 [get_ports {DeviceClk_p}]
create_clock -name SiClk -period 6.4 [get_ports {SampleClk_p}]

# Finding all non-Clip Clk80, including AxiClk
set FlexRIOClk80 [get_clocks [all_clocks] -filter {NAME =~ *Reliable* && IS_GENERATED && SOURCE !~ *CLIP* && PERIOD == 12.5}]

set_property DIFF_TERM_ADV TERM_100 [get_ports SampleClk_?]
set_property DIFF_TERM_ADV TERM_100 [get_ports DeviceClk_?]

##################################################################
# Differential Data
##################################################################
set DiffDataPins [get_ports { aDiffGpio_p[*] aDiffGpio_n[*] }]

set_property DIFF_TERM_ADV TERM_100 $DiffDataPins
set_property IOSTANDARD LVDS $DiffDataPins

##################################################################
# Single Ended Data
##################################################################

set SeDataPins [get_ports { \
  aSeGpio[0] aSeGpio[2] aSeGpio[4] aSeGpio[6] aSeGpio[8] aSeGpio[10] aSeGpio[12] aSeGpio[14] aSeGpio[16] aSeGpio[18] aSeGpio[20] aSeGpio[22] aSeGpio[24] aSeGpio[26] aSeGpio[28] \
  aSeGpio[1] aSeGpio[3] aSeGpio[5] aSeGpio[7] aSeGpio[9] aSeGpio[11] aSeGpio[13] aSeGpio[15] aSeGpio[17] aSeGpio[19] aSeGpio[21] aSeGpio[23] aSeGpio[25] aSeGpio[27] aSeGpio[29] }]

set_property SLEW FAST $SeDataPins
set_property DRIVE 12 $SeDataPins

##################### SERDES constraints #####################
# According to AR#67885, the below mentioned constraints are to reduce skew between CLKDIV and CLK of SERDES

set_property CLOCK_DELAY_GROUP OSERDES [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClockDiv/O]]
set_property CLOCK_DELAY_GROUP OSERDES [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClock/O]]

set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer/SerialGen[31].OSerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClockDiv/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer/SerialGen[31].OSerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClock/O]]

set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer/SerialGen[31].OSerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClock]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer/SerialGen[31].OSerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClockDiv]

########### To close I/ODELAY related timing ###########
# Asynchronous reset signal for DataIDelayCtrl
set_false_path \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/FixedLogicSerdesCommonx/ConfigGpiox/bResetDelayCtrlLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/DataIDelayCtrl*/RST]

########### For TX Clock Selector ###########
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock LmkClk] -group [get_clocks -include_generated_clock SiClk]

########### To close TimingEngine TX FPGA buffers related timing ###########
# This constraint ensures that the TxDataClk BUFGCE_DIV asynchronous reset is removed before the CE is asserted.
# The CE signal is driven by an AsyncDisableSyncEnable module and will, therefore, only assert after, at least,
# 2 TxDataClk periods (12.8 ns) after bGateClock is de-asserted.
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/bGateClock*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/DataClockTx/CLR] 10

# This constraint ensures that the TxDataClk BUFGCE_DIV asynchronous reset is removed before the CE is asserted.
# The CE signal is driven by an AsyncDisableSyncEnable module and will, therefore, only assert after, at least,
# 2 TxDataClkCopy periods (12.8 ns) after bGateClock is de-asserted.
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/bGateClock*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/DataClockCopyTx/CLR] 10

# The CLR de-assertion of the OSerdesClockDiv BUFGCE_DIV buffer is, by design, spaced by more than 3 TxSampleClock periods (1.6ns)
# from its CE assertion. To ensure that the CLR is de-asserted and reaches the BUFGCE_DIV destination pin before the CE
# signal reaches the BUFGCE_DIV CE pin, we set a max delay of 4.8 ns on the CLR signal route.
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsTxBufgceClrLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClockDiv/CLR] 4.8

# The CLR de-assertion of the OSerdesClock BUFGCE_DIV buffer is, by design, spaced by more than 3 TxSampleClock periods (1.6ns)
# from its CE assertion. To ensure that the CLR is de-asserted and reaches the BUFGCE_DIV destination pin before the CE
# signal reaches the BUFGCE_DIV CE pin, we set a max delay of 4.8 ns on the CLR signal route.
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsTxBufgceClrLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClock/CLR] 4.8

# Set max delay to 10ns since aClkOutInversion is asynchronous signal
set_max_delay -datapath_only \
  -from [get_pins {MacallanWindow/theVI/IO_Socket_aClkOutInversion*_dout/DoRegister.SyncRegisterVector*.SyncRegisterRising.cSyncRegister/C}] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/ClkOutInversionBank*DS/DoubleSyncAsyncInBasex/oSig_msx/Gen*.FDCEx/D] 10.0

########### To close SE related timing ###########
# Data direction control is not a critical timing path, so we are setting the direction control delay to
# an arbitrary 10 ns delay, which should be easy for the timing tools to meet.
set_max_delay -datapath_only \
  -from [get_cells -hier -filter {NAME =~ *SeDir*} {MacallanWindow/theVI/*}] \
  -to [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/PinsMappingAllOutx/SeDirectionControl*.SeDataDirCtrl/rgOutputEn_ms*/D}] 10.0

########### To close PFI related timing ###########
# The FPGA IOB component only has one IOB FF. The data FF is prioritized to take this IOB FF location for consistent
# timing between compiles. The data OE FF is not critical and is, therefore, forced to not be in an IOB (Overrides
# LVFPGA constraint). Without this constraint, a placement error would result since both the data FF and the OE FF
# will compete for the single IOB FF.
set_property IOB FALSE [get_cells -hier -filter {NAME =~ *aLvdsPfiDir*}]

# Skip looback timing analysis from OBUF to IBUF.
set_false_path -from [get_cells -hier -filter {NAME =~ *aLvdsPfiDir*}] -to [get_cells -hier -filter {NAME =~ *aLvdsPfiInput*}] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]
set_false_path -from [get_cells -hier -filter {NAME =~ *aLvdsPfiDir*}] -to [get_ports aDiffGpio_p[55]] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]
set_false_path -from [get_cells -hier -filter {NAME =~ *aLvdsPfiDir*}] -to [get_ports aDiffGpio_p[52]] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]
set_false_path -from [get_cells -hier -filter {NAME =~ *bFamOutputsEnabledLcl*}] -to [get_cells -hier -filter {NAME =~ *aLvdsPfiInput*}] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]
set_false_path -from [get_cells -hier -filter {NAME =~ *bFamOutputsEnabledLcl*}] -to [get_ports aDiffGpio_p[55]] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]
set_false_path -from [get_cells -hier -filter {NAME =~ *bFamOutputsEnabledLcl*}] -to [get_ports aDiffGpio_p[52]] -through [get_cells -hier -filter {NAME =~ *AcqGenData_DIFFIOBUF*}]

################################################################# For DEBUG PURPOSE #######################################

### # [DEBUG] From bTxDataClkCopyCount (running at 625MHz) to LabVIEW VI (running at TxDataClk 156.25MHz)
### set_max_delay \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/TxDataClkCopyCounterSample/HBx/BlkOut.ODataFlop/GenFlops*.DFlopx/Gen*.FDCEx/C}] \
###   -to [get_pins {MacallanWindow/theVI/IO_Socket_bTxDataClkCopyCount_din/cFirstRegister_ms*/D}] 10.0
###
### # [DEBUG] From bOSerdesClkDivCopyCount (running at 625MHz) to LabVIEW VI (running at TxDataClk 156.25MHz)
### set_max_delay \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClkDivCounterSample/HBx/BlkOut.ODataFlop/GenFlops*.DFlopx/Gen*.FDCEx/C}] \
###   -to [get_pins {MacallanWindow/theVI/IO_Socket_bOSerdesClkDivCopyCount_din/cFirstRegister_ms*/D}] 10.0
###
### # [DEBUG] CLR signal is asynchronous signal and hence, this is to override the tools from analyzing the TxDataClkCopyCounterSample Handshake's CLR path synchronously.
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/TxDataClkCopyCounterSample/HBx/*/*/*/CLR] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/TxDataClkCopyCounterSample/HBx/*/*/CLR] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/TxDataClkCopyCounterSample/HBx/*/CLR] 10.0
###
### # [DEBUG] CLR signal is asynchronous signal and hence, this is to override the tools from analyzing the OSerdesClkDivCounterSample Handshake's CLR path synchronously.
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClkDivCounterSample/HBx/*/*/*/CLR] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClkDivCounterSample/HBx/*/*/CLR] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C}] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClkDivCounterSample/HBx/*/CLR] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/OSerdesClkDivCounterSample/HBx/BlkRdy.iReset*/Gen*.FDPEx/PRE] 10.0
###
### set_max_delay -datapath_only \
###   -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/tsBufResetVec*/C] \
###   -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx/TxDataClkCopyCounterSample/HBx/BlkRdy.iReset*/Gen*.FDPEx/PRE] 10.0
###
### set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx
###
### #########################
### ## Handshake Constraints
### #########################
###
### set BasePath $OriBasePath/TxDataClkCopyCounterSample
###
### set HandshakeSlvPath $BasePath
### set BasePath $BasePath/HBx
###
### # ---------------------------------------------------------------------------------------
### # HandshakeBaseRSD
### # ---------------------------------------------------------------------------------------
### # Save incoming path
### set HandshakeBasePath $BasePath
###
### # Data
### set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iLclStoredData*"      -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oData   [get_cells "$BasePath/*ODataFlop*/*/*"        -filter {IS_SEQUENTIAL==true}]
### # Toggle
### set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle_msx/*"    -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
### # Ready
### set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReady*" -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]
###
### # Find out the minimum period of the clocks related to the previous groups.
### set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
### set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
###
### # The datapath clock crossings must be less than 2X the period of the destination clock.
### set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]
###
### # Toggle
### set_max_delay  -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms -datapath_only [expr 0.5 * $T_OClkMin]
### set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]
###
### # The return ready path isn't very important here.
### set_max_delay  -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms -datapath_only [expr 0.5 * $T_IClkMin]
### set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]
###
###
###
###
###
### set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx
###
### #########################
### ## Handshake Constraints
### #########################
###
### set BasePath $OriBasePath/OSerdesClkDivCounterSample
###
### set HandshakeSlvPath $BasePath
### set BasePath $BasePath/HBx
###
### # ---------------------------------------------------------------------------------------
### # HandshakeBaseRSD
### # ---------------------------------------------------------------------------------------
### # Save incoming path
### set HandshakeBasePath $BasePath
###
### # Data
### set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iLclStoredData*"      -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oData   [get_cells "$BasePath/*ODataFlop*/*/*"        -filter {IS_SEQUENTIAL==true}]
### # Toggle
### set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle_msx/*"    -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
### # Ready
### set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReady*" -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
### set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]
###
### # Find out the minimum period of the clocks related to the previous groups.
### set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
### set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]
###
### # The datapath clock crossings must be less than 2X the period of the destination clock.
### set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]
###
### # Toggle
### set_max_delay  -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms -datapath_only [expr 0.5 * $T_OClkMin]
### set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]
###
### # The return ready path isn't very important here.
### set_max_delay  -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms -datapath_only [expr 0.5 * $T_IClkMin]
### set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]

################################################################# END DEBUG PURPOSE #######################################

set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx

#########################
## DoubleSync Constraints
#########################

set BasePath $OriBasePath/ClkOutInversionBank*

# Save Incoming path
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/TxSampleResetRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/DataClockCopyTxEnableRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/TimingEngineAllOutx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/DataClockTxEnableRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/TxResetSetLimitRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/TxResetDelayRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllOutFlx/GenerationEnginex/DataSer

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/TxResetSerdesRSD

set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx

set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx

set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
# Save incoming path
set DoubleSyncAsyncInBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
# False path coming in through the D pin.
set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
# Half-cycle max-delay from metastable to stable flop, to give time for metastability to
# settle out.
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

set BasePath $DoubleSyncSlAsyncInPath

set BasePath $DoubleSyncBoolAsyncInPath

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.


set TNM_oSigs [get_cells "$DoubleSyncAsyncInBasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs                         -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

set BasePath $ResetSyncDeassertPath