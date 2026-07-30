# Clocking
create_clock -name LmkClk -period 6.4 [get_ports {DeviceClk_p}]
create_clock -name SiClk -period 6.4 [get_ports {SampleClk_p}]
create_clock -name RxClkExt0  -period 1.6 [get_ports {aDiffGpio_p[28]}]
create_clock -name RxClkExt1  -period 1.6 [get_ports {aDiffGpio_p[15]}]
create_clock -name RxClkExt2  -period 1.6 [get_ports {aDiffGpio_p[53]}]

set_input_jitter [get_clocks -of_objects [get_ports {aDiffGpio_p[28]}]] 0.48
set_input_jitter [get_clocks -of_objects [get_ports {aDiffGpio_p[15]}]] 0.48
set_input_jitter [get_clocks -of_objects [get_ports {aDiffGpio_p[53]}]] 0.48

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
set_property CLOCK_DELAY_GROUP ISERDES0 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv0/O]]
set_property CLOCK_DELAY_GROUP ISERDES0 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock0/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv0/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock0/O]]

set_property CLOCK_DELAY_GROUP ISERDES1 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv1/O]]
set_property CLOCK_DELAY_GROUP ISERDES1 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock1/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv1/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock1/O]]

set_property CLOCK_DELAY_GROUP ISERDES2 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv2/O]]
set_property CLOCK_DELAY_GROUP ISERDES2 [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock2/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv2/O]]
set_property USER_CLOCK_ROOT [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_nets -of [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock2/O]]

## Added these constraints to place the BUFGCE_DIVs into correct clock region
## These constraints are needed or else the tool is not able to close the timing from ISerdesClkBufEn/CLK to ISerdesClk/CE, same applies to ISerdesClockDiv and DataClockRx buffers
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv0]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock0]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/DataClockRx0]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank44/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxDataClkMux0]

set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv1]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock1]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/DataClockRx1]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank45/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxDataClkMux1]

set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv2]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock2]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/DataClockRx2]
set_property CLOCK_REGION [get_clock_regions -of [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank46/DataDeser/DataIoDelayGen[0].ISerdes]] [get_cells %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxDataClkMux2]

########### For RX MUX Selector ###########
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock LmkClk] -group [get_clocks -include_generated_clock SiClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt0] -group [get_clocks -include_generated_clock LmkClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt0] -group [get_clocks -include_generated_clock SiClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt1] -group [get_clocks -include_generated_clock LmkClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt1] -group [get_clocks -include_generated_clock SiClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt2] -group [get_clocks -include_generated_clock LmkClk]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock RxClkExt2] -group [get_clocks -include_generated_clock SiClk]

#From bRxClkInSelection to RxDataClkMux's Selectors
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/bRxClkInSelection*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxDataClkMux*/S*] 10.0

set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/MmcmLockCycleFilter/cOSigLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxDataClkMux*/S*] 10.0

########### To close I/ODELAY related timing ###########
# Asynchronous reset signal for DataIDelayCtrl
set_false_path \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/FixedLogicSerdesCommonx/ConfigGpiox/bResetDelayCtrlLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/DataIDelayCtrl*/RST]

########### To close TimingEngine RX FPGA buffers related timing ###########
# The CLR de-assertion of the DataClockRx, ISerdesClock and ISerdesClockDiv buffers is, by design, spaced by more than
# 3 RxClkMuxed periods (1.6ns) from its CE assertion. To ensure that the CLR is de-asserted and reaches the buffers
# destination pin before the CE signal reaches the buffers CE pin, we set a max delay of 4.8 ns on the CLR signal route.

set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxBufEnableRSD*/acReset*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/DataClockRx*/CLR] 4.8

set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxBufEnableRSD*/acReset*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClock*/CLR] 4.8

set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/RxBufEnableRSD*/acReset*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx/ISerdesClockDiv*/CLR] 4.8

########### To close SE related timing ###########
# Data direction control is not a critical timing path, so we are setting the direction control delay to
# an arbitrary 10 ns delay, which should be easy for the timing tools to meet.
set_max_delay -datapath_only \
  -from [get_cells -hier -filter {NAME =~ *SeDir*} {MacallanWindow/theVI/*}] \
  -to [get_pins {%ClipInstancePath%/Ni6569SerdesClipAllInFlx/PinsMappingAllInx/SeDirectionControl*.SeDataDirCtrl/rgOutputEn_ms*/D}] 10.0

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





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllInFlx/TimingEngineAllInx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/RxBufEnableRSD*

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





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank*/DataDeser

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/RxResetSetLimitRSD

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





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank*/DataDeser

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/RxResetDelayRSD

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





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank*/DataDeser

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/RxResetSerdesRSD

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





set OriBasePath %ClipInstancePath%/Ni6569SerdesClipAllInFlx/AcqEngineBank*/BitSlipGen*.SimpleBitSlipx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/ClkRSD

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