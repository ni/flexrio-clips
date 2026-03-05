# Constraints for an Aurora 2 port, 4 lane implementation using GTH transievers


set LineRateInGbs 16.25

############################### User clock constraints ##############################
### OUTCLK period expression: [expr INT_DATAWIDTH/LineRateInGbs] ###
### USERCLK2 period will be auto-derived thru BUFG_GT       ###
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST/RXOUTCLK}]

create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]
create_clock -period [expr 32/$LineRateInGbs] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gthe3_channel_gen.gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST/TXOUTCLK}]

create_clock -period [expr 32/$LineRateInGbs] -name port0_rxusrclk2 [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 32/$LineRateInGbs] -name port1_rxusrclk2 [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port0_txusrclk2 [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]
create_clock -period [expr 64/$LineRateInGbs] -name port1_txusrclk2 [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]

# SYNC Clock Constraint - same as TX USRCLK in UltraScale
create_clock -period [expr 32/$LineRateInGbs] -name port0_sync_clk [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[0].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]
create_clock -period [expr 32/$LineRateInGbs] -name port1_sync_clk [get_pins -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[1].Aurora_PortN/*/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk_inst/O}]

########################### UltraScale Digital Monitor clock ###########################
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[0].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[1].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[2].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[3].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[4].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[5].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[6].DMonClk_bufg_instN/O}]
create_clock -period [expr 1/.500] [get_pins -hier -filter {NAME =~ %ClipInstancePath%/GenGtwizDMonClk[7].DMonClk_bufg_instN/O}]


########################### False Paths - UltraScale GT Wizard ExDes ###########################
set_false_path -to [get_cells -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[*].Aurora_PortN/*bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[*].Aurora_PortN/*reset_synchronizer*inst/rst_in_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_tx_active_*_reg}]
set_false_path -to [get_cells -hier -filter {NAME =~ %ClipInstancePath%/AuroraBlock.GenAurora[*].Aurora_PortN/*gtwiz_userclk_rx_active_*_reg}]

###########################       False Paths - Aurora Core          ###########################
set_false_path -to [get_pins -hier -filter {NAME =~ %ClipInstancePath%/*aurora_64b66b_*_cdc_to*/D}]

##############################################################
####################### Port 0 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port0_TNM_TxResetDone_out [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_txusrclk2"] -to $port0_TNM_TxResetDone_out -datapath_only 10.0

set port0_TNM_RxResetDone_out [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port0_rxusrclk2"] -to $port0_TNM_RxResetDone_out -datapath_only 10.0

set port0_TNM_lRxLpmEn [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxLpmEn [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxLpmEn -to $port0_TNM_rRxLpmEn -datapath_only 10.0

set port0_TNM_lRxHoldReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxHoldReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxHoldReg -to $port0_TNM_rRxHoldReg_ms -datapath_only 10.0

set port0_TNM_lRxOvrdReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxOvrdReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxOvrdReg -to $port0_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port0_TNM_lRxPolarityReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_rRxPolarityReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lRxPolarityReg -to $port0_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port0_TNM_lTxPolarityReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_tTxPolarityReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port0_TNM_lTxPolarityReg -to $port0_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port0_TNM_PulseSync_iDlySigx  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSig_msx  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_oSigx     [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_PulseSync_AoSig_msx [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_PulseSync_iDlySigx -to $port0_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port0_TNM_PulseSync_oSigx    -to $port0_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port0_TNM_HandShake_iStoredData        [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oDataFlop          [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iPushToggle        [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggle0_ms    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_oPushToggleToReady [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port0_TNM_HandShake_iRdyPushToggle_ms  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[0].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port0_TNM_HandShake_iStoredData        -to $port0_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_iPushToggle        -to $port0_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port0_TNM_HandShake_oPushToggleToReady -to $port0_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

##############################################################
####################### Port 1 ###############################
##############################################################
############# DoubleSync Clock crossings in AXI4-Lite register component ############
set port1_TNM_TxResetDone_out [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lTxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_txusrclk2"] -to $port1_TNM_TxResetDone_out -datapath_only 10.0

set port1_TNM_RxResetDone_out [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxResetDone_out_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from [get_clocks "port1_rxusrclk2"] -to $port1_TNM_RxResetDone_out -datapath_only 10.0

set port1_TNM_lRxLpmEn [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxLpmEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxLpmEn [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRxLpmEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxLpmEn -to $port1_TNM_rRxLpmEn -datapath_only 10.0

set port1_TNM_lRxHoldReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRx*Hold_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxHoldReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRx*Hold_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxHoldReg -to $port1_TNM_rRxHoldReg_ms -datapath_only 10.0

set port1_TNM_lRxOvrdReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRx*OvrdEn_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxOvrdReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRx*OvrdEn_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxOvrdReg -to $port1_TNM_rRxOvrdReg_ms -datapath_only 10.0

set port1_TNM_lRxPolarityReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lRxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_rRxPolarityReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].rRxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lRxPolarityReg -to $port1_TNM_rRxPolarityReg_ms -datapath_only 10.0

set port1_TNM_lTxPolarityReg    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/lTxPolarity_in_reg*} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_tTxPolarityReg_ms [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].tTxPolarity_in_ms_reg*} -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $port1_TNM_lTxPolarityReg -to $port1_TNM_tTxPolarityReg_ms -datapath_only 10.0


############# PulseSync (CoreComponents3) Clock crossings in AXI4-Lite register component #############
set port1_TNM_PulseSync_iDlySigx  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/iDlySigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSig_msx  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_oSigx     [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_PulseSync_AoSig_msx [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].PS_*/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_PulseSync_iDlySigx -to $port1_TNM_PulseSync_oSig_msx  -datapath_only 10.0
set_max_delay -from $port1_TNM_PulseSync_oSigx    -to $port1_TNM_PulseSync_AoSig_msx -datapath_only 10.0

############# HandShake Clock crossings in AXI4-Lite register component #############
set port1_TNM_HandShake_iStoredData        [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iStoredDatax/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oDataFlop          [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oDataFlopx/GenFlops[*].DFlopx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iPushToggle        [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkIn.iPushTogglex/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggle0_ms    [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggle0_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_oPushToggleToReady [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkOut.oPushToggleToReadyx/*FDCEx} -filter {IS_SEQUENTIAL==true}]
set port1_TNM_HandShake_iRdyPushToggle_ms  [get_cells {%ClipInstancePath%/AuroraBlock.GenAurora[1].AXI4Lite_GTHE3_Control_Regs4_inst/AXI4Lite_GTHE3_Control_Regs4_inst/GenCrossings[*].HS_*/HBx/BlkRdy.iRdyPushToggle_msx/*FDCEx} -filter {IS_SEQUENTIAL==true}]

set_max_delay -from $port1_TNM_HandShake_iStoredData        -to $port1_TNM_HandShake_oDataFlop         -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_iPushToggle        -to $port1_TNM_HandShake_oPushToggle0_ms   -datapath_only 10.0
set_max_delay -from $port1_TNM_HandShake_oPushToggleToReady -to $port1_TNM_HandShake_iRdyPushToggle_ms -datapath_only 10.0

############# Double sync clock crossings in top level #############
set mmcmNotLockedDsStart [get_cells %ClipInstancePath%/AuroraBlock.GenAurora[*].Aurora_PortN/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.gtwiz_userclk_tx_active_out_reg* -filter {IS_SEQUENTIAL==true}]
set mmcmNotLockedDsEnd   [get_cells %ClipInstancePath%/cPort*_mmcm_not_lock_out_ms_reg* -filter {IS_SEQUENTIAL==true}]
set_max_delay -from $mmcmNotLockedDsStart -to $mmcmNotLockedDsEnd -datapath_only 10.0
