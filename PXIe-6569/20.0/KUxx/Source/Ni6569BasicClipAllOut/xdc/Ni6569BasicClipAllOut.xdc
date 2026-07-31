# Clocking
create_clock -name LmkClk -period 6.667 [get_ports {DeviceClk_p}]
create_clock -name SiClk -period 6.667 [get_ports {SampleClk_p}]

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

####################################################################################
# Constraints from CLIP
####################################################################################
# Place dvTdcAssert under IOB.
set_property IOB TRUE [get_ports -filter {NAME =~ *dvTdcAssert*}]

########### To close I/ODELAY related timing ###########
# Asynchronous reset signal for DataIDelayCtrl
set_false_path \
  -from [get_pins %ClipInstancePath%/Ni6569BasicClipAllOutFlx/FixedLogicBasicCommonx/ConfigGpiox/bResetDelayCtrlLcl*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569BasicClipAllOutFlx/DataIDelayCtrl*/RST]

########### For TX MUX Selector ###########
#From bTxClkInSelection to TxDataClkMux's Selectors
set_max_delay -datapath_only \
  -from [get_pins %ClipInstancePath%/Ni6569BasicClipAllOutFlx/TimingEngineBasicAllOutx/bTxClkInSelection*/C] \
  -to [get_pins %ClipInstancePath%/Ni6569BasicClipAllOutFlx/TimingEngineBasicAllOutx/TxDataClkMux/S*] 10.0

set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clock LmkClk] -group [get_clocks -include_generated_clock SiClk]

########### To close SE related timing ###########
# Constrain SE line direction control path to 5 ns for fast direction switching
set_max_delay -datapath_only \
  -from [get_cells -hier -filter {NAME =~ *SeDir*} {MacallanWindow/theVI/*}] \
  -to [get_pins {%ClipInstancePath%/Ni6569BasicClipAllOutFlx/PinsMappingAllOutx/SeDirectionControl*.SeDataDirCtrl/rgOutputEn_ms*/D}] 5.0

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





set OriBasePath %ClipInstancePath%/Ni6569BasicClipAllOutFlx

#########################
## DoubleSync Constraints
#########################

set BasePath $OriBasePath/ClkOutInversionDS

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





set OriBasePath %ClipInstancePath%/Ni6569BasicClipAllOutFlx/ODelayBasicx

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

set BasePath $ResetSyncDeassertPath










set OriBasePath %ClipInstancePath%/Ni6569BasicClipAllOutFlx/TimingEngineBasicAllOutx

################################
## ResetSyncDeassert Constraints
################################

set BasePath $OriBasePath/TxDataClockEnableRSD

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