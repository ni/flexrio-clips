# vreview_group HIL_NI7891Xdc
# vreview_closed https://review-board.natinst.com/r/363145/
# vreview_reviewers mizhang kyiew milim

#########################################################################################
# Group the I/O ports
#########################################################################################
###########################################################
# Fam1 Slow Clock ADC
###########################################################
# Slow Clock ADC
set Fam1SlowClkOutAdc  [get_ports aDiffGpio_p[5]]

# Slow ADC Group
set Fam1SlowAdcStart [get_ports {aDiffGpio_n[3] aDiffGpio_p[6] aDiffGpio_n[7] aDiffGpio_p[10] aDiffGpio_n[13] aDiffGpio_p[16] aDiffGpio_n[17] aDiffGpio_p[20]}]
set Fam1SlowAdcData  [get_ports {aDiffGpio_p[3] aDiffGpio_p[4] aDiffGpio_n[4] aDiffGpio_n[6] aDiffGpio_p[7] aDiffGpio_p[8] aDiffGpio_n[8] aDiffGpio_p[9] aDiffGpio_n[9] aDiffGpio_n[10] aDiffGpio_p[11] aDiffGpio_n[11] aDiffGpio_p[12] aDiffGpio_n[12] aDiffGpio_p[14] aDiffGpio_n[14] }]

###########################################################
# Fam1 Slow Clock DAC
###########################################################
# Slow Clock DAC
set Fam1SlowClkOutDac  [get_ports aDiffGpio_p[19]]

# Slow DAC Group
set Fam1SlowDacData  [get_ports {aDiffGpio_p[21] aDiffGpio_n[21] aDiffGpio_p[22] aDiffGpio_n[22] aDiffGpio_p[23] aDiffGpio_n[23] aDiffGpio_p[24] aDiffGpio_n[24] aDiffGpio_p[25] aDiffGpio_n[25] aDiffGpio_p[26] aDiffGpio_n[26] aDiffGpio_p[27] aDiffGpio_n[27] aDiffGpio_p[28] aDiffGpio_n[28] aDiffGpio_p[29] aDiffGpio_n[29] aDiffGpio_p[30] aDiffGpio_n[30] aDiffGpio_p[31] aDiffGpio_n[31] aDiffGpio_p[32] aDiffGpio_n[32] aDiffGpio_p[33] aDiffGpio_n[33] aDiffGpio_p[34] aDiffGpio_n[34] aDiffGpio_p[35] aDiffGpio_n[35] aDiffGpio_p[36] aDiffGpio_n[36] }]

###########################################################
# Fam2 Fast Clock DAC
###########################################################
# Fast Clock
set Fam2FastClkOutDac [get_ports aDiffGpio_p[37]]

# Fast DAC Group
set Fam2FastDacData  [get_ports {aDiffGpio_p[38] aDiffGpio_p[39] aDiffGpio_p[40] aDiffGpio_p[41] aDiffGpio_p[42] aDiffGpio_p[43] aDiffGpio_p[44] aDiffGpio_p[45] aDiffGpio_p[46] aDiffGpio_p[47] aDiffGpio_p[48] aDiffGpio_p[49] aDiffGpio_p[50] aDiffGpio_p[51] aDiffGpio_p[52] aDiffGpio_p[53] aDiffGpio_p[54] aDiffGpio_p[55] aDiffGpio_p[56] aDiffGpio_p[57] aDiffGpio_p[58] aDiffGpio_p[59] aDiffGpio_p[60] aDiffGpio_p[61] aDiffGpio_p[62] aDiffGpio_p[63] aDiffGpio_p[64] aDiffGpio_p[65] aDiffGpio_p[66] aDiffGpio_p[67] aDiffGpio_p[68] aDiffGpio_p[69]}]

###########################################################
# Fam2 DI
###########################################################
# DIO
set Fam2Dio [get_ports {aConfigSeIo[3] aConfigSeIo[4] aConfigSeIo[5] aConfigSeIo[6] aConfigSeIo[8] aConfigSeIo[9] aConfigSeIo[10] aConfigSeIo[11] aConfigSeIo[12] aConfigSeIo[13] aConfigSeIo[14] aConfigSeIo[15] aConfigSeIo[16] aConfigSeIo[17] aConfigSeIo[18] aConfigSeIo[19] aConfigSeIo[20] aConfigSeIo[21] aConfigSeIo[22] aConfigSeIo[23] aConfigSeIo[24] aConfigSeIo[25] aConfigSeIo[26] aConfigSeIo[27] aConfigSeIo[28] aConfigSeIo[29] aDiffGpio_p[0] aDiffGpio_n[0] aDiffGpio_p[1] aDiffGpio_n[1] aDiffGpio_p[2] aDiffGpio_n[2]}]

###########################################################
# JTAG
###########################################################
set FamJtagOut  [get_ports {aDiffGpio_p[15] aDiffGpio_n[15] aDiffGpio_p[17] aDiffGpio_p[18] aDiffGpio_n[18] aDiffGpio_n[20]}]
set FamJtagIn   [get_ports {aDiffGpio_n[16] aDiffGpio_p[13]}]

###########################################################
# Misc
###########################################################
# I2C ports
set I2cIo [get_ports {aSeGpio[0] aSeGpio[1]}]
# Reset ports
set ResetIo [get_ports {aSeGpio[2]}]

#########################################################################################
# Create Clock
#########################################################################################
# Slow Clock
create_generated_clock -name Fam1SlowClkAdc -source [get_pins %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT0] -divide_by 1 $Fam1SlowClkOutAdc
create_generated_clock -name Fam1SlowClkDac -source [get_pins %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT0] -divide_by 1 $Fam1SlowClkOutDac

# Fast Clock
create_generated_clock -name Fam2FastClkDac -source [get_pins %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/UltraScaleODDRClk/CLKDIV] -divide_by 1 $Fam2FastClkOutDac

#########################################################################################
# SlowClk Timing Constant
#########################################################################################
###########################################################
# Output Timing
###########################################################
# Below timing would leave (tFamFpgaSetup + tFamFpgaHold) sample window for FAM FPGA sampling the data
set tFamFpgaSetup 3.200;
set tFamFpgaHold -0.700;
set tFamPcbSetup  2.200;
set tFamPcbHold   1.200;

###########################################################
# Input Timing
###########################################################
# Below timing would require (tMainFpgaSetup + tMainFpgaHold) sample window from FAM FPGA
set tSlowClkPeriod 10.000;
set tMainFpgaSetup 3.500;
set tMainFpgaHold  0.600;

#########################################################################################
# Constraint of Fam1 SlowClk ADC Timing
#########################################################################################
###########################################################
# Output Timing
###########################################################
# Fam1 Slow ADC Group
set_output_delay -clock [get_clocks Fam1SlowClkAdc] -min -add_delay [expr 0 - ($tFamPcbHold  + $tFamFpgaHold)]   $Fam1SlowAdcStart
set_output_delay -clock [get_clocks Fam1SlowClkAdc] -max -add_delay [expr     ($tFamPcbSetup + $tFamFpgaSetup)]  $Fam1SlowAdcStart

###########################################################
# Input Timing
###########################################################
# Fam1 Slow ADC Group
set_input_delay  -clock [get_clocks Fam1SlowClkAdc] -min -add_delay [expr ($tMainFpgaHold)]                      $Fam1SlowAdcData
set_input_delay  -clock [get_clocks Fam1SlowClkAdc] -max -add_delay [expr ($tSlowClkPeriod - $tMainFpgaSetup)]   $Fam1SlowAdcData

#########################################################################################
# Constraint of Fam1 SlowClk DAC Timing
#########################################################################################
###########################################################
# Output Timing
###########################################################
# Fam1 Slow DAC Group
set_output_delay -clock [get_clocks Fam1SlowClkDac] -min -add_delay [expr 0 - ($tFamPcbHold  + $tFamFpgaHold)]   $Fam1SlowDacData
set_output_delay -clock [get_clocks Fam1SlowClkDac] -max -add_delay [expr     ($tFamPcbSetup + $tFamFpgaSetup)]  $Fam1SlowDacData


#########################################################################################
# FastClk Timing Constant
#########################################################################################
###########################################################
# Output Timing
###########################################################
set tFastClkPeriod 10.000;
set tFamFpgaSkewBeforeEdge 1.100;
set tFamFpgaSkewAfterEdge 1.250;
set tFamPcbSkew 0.250;

#########################################################################################
# Constraint of Fam2 FastClk DAC Timing
#########################################################################################
# Fam2 Fast DAC Group
set_output_delay -clock [get_clocks Fam2FastClkDac] -clock_fall -min -add_delay [expr ($tFamFpgaSkewBeforeEdge - $tFamPcbSkew)] $Fam2FastDacData
set_output_delay -clock [get_clocks Fam2FastClkDac] -clock_fall -max -add_delay [expr ($tFastClkPeriod/2 - ($tFamFpgaSkewAfterEdge - $tFamPcbSkew))] $Fam2FastDacData
set_output_delay -clock [get_clocks Fam2FastClkDac]             -min -add_delay [expr ($tFamFpgaSkewBeforeEdge - $tFamPcbSkew)] $Fam2FastDacData
set_output_delay -clock [get_clocks Fam2FastClkDac]             -max -add_delay [expr ($tFastClkPeriod/2 - ($tFamFpgaSkewAfterEdge - $tFamPcbSkew))] $Fam2FastDacData


#########################################################################################
# Constraint of Max IO Delay
#########################################################################################
# I2C timing is relatively slow
set tRelaxDelay 20.000
set_max_delay $tRelaxDelay -to $I2cIo

# May apply max delay on the DI and DIO path

#########################################################################################
# Constraint of FALSE timing
#########################################################################################
#set_clock_groups -asynchronous -group [get_clocks [list SlowClk [get_clocks -of_objects [get_pins %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT0]]]]
#set_false_path -through [get_nets {%ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/aFldUpdJtagTck %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/aFldUpdJtagTdi %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/aFldUpdJtagTms aFldUpdJtagSel aFldUpdJtagTdo}]

###########################################################
# Ignore timing on the enable of the buffer
###########################################################
set_false_path -from [get_cells -hierarchical *bClkOutEn_reg*]    -to [get_cells -hierarchical *SafeBUFGCTRLx*]
set_false_path -from [get_cells -hierarchical *bRegSlowClkOutEn_reg*] -to [get_cells -hierarchical *SafeBUFGCTRLx*]
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam1SlowClkOutAdc
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam1SlowAdcStart
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam1SlowClkOutDac
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam1SlowDacData
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam2FastClkOutDac
set_false_path -from [get_cells -hierarchical *bRegFamOutputEnabled_reg*]  -to $Fam2FastDacData

###########################################################
# Ignore timing on the asynchronous reset
###########################################################
set_false_path -to [get_pins -hierarchical -filter {NAME =~ %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/DoubleSyncSlowClkReset/DoubleSyncBasex/DoubleSyncAsyncInBasex/*/CLR}]

###########################################################
# Ignore timing on the DoubleSyncBool for sIoModuleReady
###########################################################
# Set BasePath
set BasePath %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/DoubleSyncIoModuleReady/DoubleSyncBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

###########################################################
# Ignore timing on the DoubleSyncBool for aSlowClkReset
###########################################################
# Set BasePath
set BasePath %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/DoubleSyncSlowClkReset/DoubleSyncBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

###########################################################
# Ignore timing on the DoubleSyncBool for sCalReady
###########################################################
# Set BasePath
set BasePath %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/*/DoubleSyncCalReady/DoubleSyncBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]

###########################################################
# Ignore timing on the calibration data
###########################################################
set_false_path -from [get_cells -hierarchical -filter {NAME =~"%ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/CalibrationRegsx/bRegFam*"}] -to [get_cells -hierarchical -filter {NAME =~"*TxFam*SlowDacData/sRegCalData*"}]
set_false_path -from [get_cells -hierarchical -filter {NAME =~"%ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/CalibrationRegsx/bRegFam*"}] -to [get_cells -hierarchical -filter {NAME =~"*TxFam*FastDacDataDual/sRegCalData*"}]
set_false_path -from [get_cells -hierarchical -filter {NAME =~"%ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/CalibrationRegsx/bRegFam*"}] -to [get_cells -hierarchical -filter {NAME =~"*RxFam*SlowAdcData/sRegFxpData*"}]

###########################################################
# Ignore timing on the ResetSyncDeassert for Gpio
###########################################################
# Set BasePath
set BasePath %ClipInstancePath%/NI7891FixedLogicx/CommonFixedLogicx/ConfigGpiox/*/DoubleSyncBoolAsyncInx/DoubleSyncSlAsyncInx/DoubleSyncAsyncInBasex

# ---------------------------------------------------------------------------------------
# DoubleSyncAsyncInBase
# ---------------------------------------------------------------------------------------
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

# There is an implicit assumption that aReset coming into ResetSyncDeassert can always
# be treated as fully-asynchronous. This will certainly be the case if the signal is
# coming from a pin. But even if it's coming from an internal FF, it is never useful
# to treat is as synchronous. If the signal were synchronous to the output clock, we
# would have no need for the ResetSyncDeassert in the first place. So it's safe to
# except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
# true), and avoid the potential for spurious Reset Recovery analysis on that path.
set TNM_oSigs [get_cells "$BasePath/oSig*x/*" -filter {IS_SEQUENTIAL==true}]
set TNM_Prst  [get_pins -of $TNM_oSigs        -filter {REF_PIN_NAME==PRE}]
set_false_path -to $TNM_oSigs -through $TNM_Prst

###########################################################
# Ignore timing on the JTAG
###########################################################
set_false_path -to $FamJtagOut
set_false_path -from $FamJtagIn

#########################################################################################
# Constraints of I/O Pins
#########################################################################################
###########################################################
# IO Standard
###########################################################
# Enable DIFF resistor on LVDS input
set_property DIFF_TERM TRUE [get_ports SampleClk_p]

# LVCMOS18 FAM I2c
set_property IOSTANDARD LVCMOS18 $I2cIo
set_property DRIVE 4   $I2cIo
set_property SLEW SLOW $I2cIo
set_property IOSTANDARD LVCMOS18 $ResetIo
set_property DRIVE 4   $ResetIo
set_property SLEW SLOW $ResetIo

# LVCMOS18 Fam1 SlowAdc
set_property IOSTANDARD LVDS $Fam1SlowClkOutAdc
set_property IOSTANDARD LVDCI_18 $Fam1SlowAdcStart
set_property SLEW SLOW $Fam1SlowAdcStart
set_property IOSTANDARD LVCMOS18 $Fam1SlowAdcData

# LVCMOS18 Fam1 SlowDac
set_property IOSTANDARD LVDS $Fam1SlowClkOutDac
set_property IOSTANDARD LVDCI_18 $Fam1SlowDacData
set_property SLEW SLOW $Fam1SlowDacData

# LVDS Fam2 FastDac
set_property IOSTANDARD LVDS $Fam2FastClkOutDac
set_property IOSTANDARD LVDS $Fam2FastDacData

# Set Fam JTAG
set_property IOSTANDARD LVDCI_18 $FamJtagOut

# Set DIO
set_property IOSTANDARD LVDCI_18 [get_ports {aDiffGpio_p[0] aDiffGpio_n[0] aDiffGpio_p[1] aDiffGpio_n[1] aDiffGpio_p[2] aDiffGpio_n[2]}]

###########################################################
# Misc
###########################################################
set_property PULLUP TRUE $I2cIo

# Uncomment line below when compiling CLIP for initial programming
#set_property PULLTYPE PULLUP [get_ports {aIoReady}]
