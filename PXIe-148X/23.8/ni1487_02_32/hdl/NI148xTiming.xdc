
###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################
## Start add from file NI148xClipTopCommon.xdc
#-----------------------------------------------------------------------------
# Create Input and Output Clocks
#-----------------------------------------------------------------------------
set ClipPllOut0 [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx/CLKOUT0]
set ClipPllOut1 [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx/CLKOUT1]
set ClipPllOut2 [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx/CLKOUT2]
set ClipPllOut3 [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx/CLKOUT3]
set ClipPllOut4 [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx/CLKOUT4]

#ClipPllOutx goes from the above MMCMs and through a BUFGCTRL
#The CTRL then routes to a particular clock region and fans out from there
#Fix the location that the clock fans out from in order to provide consistent
#skew between all 3 clocks to the IO pins, which is important for meeting IO timing.
set_property USER_CLOCK_ROOT {X2Y4} [get_nets -of_objects [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk0SafeBufgce/SafeBUFGCTRLx/O]]
set_property USER_CLOCK_ROOT {X2Y4} [get_nets -of_objects [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk1SafeBufgce/SafeBUFGCTRLx/O]]
set_property USER_CLOCK_ROOT {X2Y4} [get_nets -of_objects [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk2SafeBufgce/SafeBUFGCTRLx/O]]
#Also fix the MMCM and BUGCE's associated with above clock paths.  It was first observed this was not needed,
#but later observed placement of these components caused timing failurs.
set_property LOC MMCM_X0Y4     [get_cells %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/MMCME4_BASEx]
set_property CLOCK_REGION X2Y4 [get_cells %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk0SafeBufgce/SafeBUFGCTRLx]
set_property CLOCK_REGION X2Y4 [get_cells %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk1SafeBufgce/SafeBUFGCTRLx]
set_property CLOCK_REGION X2Y4 [get_cells %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk2SafeBufgce/SafeBUFGCTRLx]

set_property LOC MMCM_X0Y0     [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankA/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
set_property CLOCK_REGION X2Y0 [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankA/BUFGCTRL0x]
set_property CLOCK_REGION X2Y0 [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankA/BUFGCTRL1x]

set_property LOC MMCM_X0Y3     [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankB/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
set_property CLOCK_REGION X2Y3 [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankB/BUFGCTRL0x]
set_property CLOCK_REGION X2Y3 [get_cells %ClipInstancePath%/*/*/MipiSharedLogicBankB/BUFGCTRL1x]

# Override MIPI TX Byte Clock frequency to support 2.5G to one slot module only (eg. NI 1489). This will causes warning Timing 38-3, DRC PDRC-181 and Constraints 18-1056. They are expected and can be ignored.
create_clock -name MipiTxByteClkA0 -period 3.2 [get_pins -regexp {%ClipInstancePath%/.*/Mipi[24]Tx(2Rxx|x)/MipiSharedLogicBankA/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0}]
create_clock -name MipiTxByteClkB0 -period 3.2 [get_pins -regexp {%ClipInstancePath%/.*/Mipi[24]Tx(2Rxx|x)/MipiSharedLogicBankB/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0}]
create_clock -name MipiTxByteClkA1 -period 3.2 [get_pins -regexp {%ClipInstancePath%/.*/Mipi[24]Tx(2Rxx|x)/MipiSharedLogicBankA/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT1}]
create_clock -name MipiTxByteClkB1 -period 3.2 [get_pins -regexp {%ClipInstancePath%/.*/Mipi[24]Tx(2Rxx|x)/MipiSharedLogicBankB/SharedLogicMmcmx/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT1}]

#Referencing the OSERDESE3 cell by the name of the output net because Vivado moves things around due to Xilinx documenting to implement this with an ODDRE1 component.
set InnerWriteClkOddr [get_cells -of_objects [get_nets %ClipInstancePath%/InnerFamCfgWriteClk] -filter {PRIMITIVE_SUBGROUP == SERDES}]
set OuterWriteClkOddr [get_cells -of_objects [get_nets %ClipInstancePath%/OuterFamCfgWriteClk] -filter {PRIMITIVE_SUBGROUP == SERDES}]

set InnerWriteClkOddrSrcPin [get_pins -of_objects $InnerWriteClkOddr -filter {REF_PIN_NAME == CLK}]
set OuterWriteClkOddrSrcPin [get_pins -of_objects $OuterWriteClkOddr -filter {REF_PIN_NAME == CLK}]

set IoClkFlop [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/InnerFamTransparentIoBridgeMaster/IoClockGeneratorx/IoClockFlopx/cLclQ_reg]
set IoClkFlopSrcPin [get_pins -of_objects $IoClkFlop -filter {REF_PIN_NAME == C}]
set IoClkFlopClkPin [get_pins -of_objects $IoClkFlop -filter {REF_PIN_NAME == Q}]

# Each IO Bridge makes a clock, but we only use one of them. Generating both prevents unclocked logic from
# showing up in the check timing report
set IoClkFlopUnused [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/OuterFamTransparentIoBridgeMaster/IoClockGeneratorx/IoClockFlopx/cLclQ_reg]
set IoClkFlopUnusedSrcPin [get_pins -of_objects $IoClkFlopUnused -filter {REF_PIN_NAME == C}]
set IoClkFlopUnusedClkPin [get_pins -of_objects $IoClkFlopUnused -filter {REF_PIN_NAME == Q}]

create_generated_clock -name SerialIoClock           $ClipPllOut0
create_generated_clock -name OuterConfigWriteClkPll  $ClipPllOut1
create_generated_clock -name InnerConfigWriteClkPll  $ClipPllOut2
create_generated_clock -name VideoClock              $ClipPllOut3
create_generated_clock -name FastVideoClock          $ClipPllOut4

create_clock           -name InnerConfigReadClk          -period 10.000 [get_ports {aSeGpio[17]}]
create_clock           -name OuterConfigReadClk          -period 10.000 [get_ports {aSeGpio[20]}]
create_clock           -name ConfigReadClkExternal       -period 10.000

create_generated_clock -name InnerConfigWriteClk     -source [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk1SafeBufgce/SafeBUFGCTRLx/O] -divide_by 1 [get_ports aSeGpio[13]]
create_generated_clock -name OuterConfigWriteClk     -source [get_pins %ClipInstancePath%/NI148xFixedLogicx/TimingEnginex/Clk2SafeBufgce/SafeBUFGCTRLx/O] -divide_by 1 [get_ports aSeGpio[12]]
create_generated_clock -name IoClock                 -source $IoClkFlopSrcPin -edges {1 51 101} $IoClkFlopClkPin
create_generated_clock -name IoClockUnused           -source $IoClkFlopUnusedSrcPin -edges {1 51 101} $IoClkFlopUnusedClkPin

################################################################
#Fix placement of IO Bridge receive fabric flops
################################################################
#In order to meet hold timing, the input flops for the IO Bridge interface are placed in fabric allowing vivado to lengthen the data path to meet hold time.
#These flops should be placed in the same clock region as the input clock in order to reduce clock network skew and capacitive loading, giving further margin
#for this IO timing parameter.

set ConfigReadPblock [create_pblock pblock_IoBridgeRd]
# Restrict Vivado2021.1 to place components within the PBLOCK. Not required by Vivado2019.1.
set_property IS_SOFT FALSE $ConfigReadPblock

#Placing PBLOCK directly adjacent to IO column in same clock region.
resize_pblock $ConfigReadPblock -add {SLICE_X74Y240:SLICE_X78Y299}

#Do this for the inner and outer FAM, for both data and Frame.
add_cells_to_pblock [get_pblocks $ConfigReadPblock]   [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/InnerFamTransparentIoBridgeMaster/FpgaIODDRsx/GenDataIODDRs[*].DataIDDRx]
add_cells_to_pblock [get_pblocks $ConfigReadPblock]   [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/OuterFamTransparentIoBridgeMaster/FpgaIODDRsx/GenDataIODDRs[*].DataIDDRx]
add_cells_to_pblock [get_pblocks $ConfigReadPblock]   [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/InnerFamTransparentIoBridgeMaster/FpgaIODDRsx/FrameIDDRx]
add_cells_to_pblock [get_pblocks $ConfigReadPblock]   [get_cells %ClipInstancePath%/NI148xFixedLogicx/IoBridgeWrapperx/OuterFamTransparentIoBridgeMaster/FpgaIODDRsx/FrameIDDRx]

######################################################################################
# Reinforce the placements of internal BUFGCE of each MIPI RX interface to be next to
# the BITSLICEs and within same clock region.
# This improves the placement in Vivado 2021.1 to mitigate the Contraints 18-1000 error.
######################################################################################

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan0x/mipi_dphy_rx_0x/inst/inst/slave_rx.mipi_dphy_rx_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan0x/mipi_dphy_rx_0x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan1x/mipi_dphy_rx_1x/inst/inst/slave_rx.mipi_dphy_rx_1_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan1x/mipi_dphy_rx_1x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan2x/mipi_dphy_rx_2x/inst/inst/slave_rx.mipi_dphy_rx_2_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan2x/mipi_dphy_rx_2x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan3x/mipi_dphy_rx_3x/inst/inst/slave_rx.mipi_dphy_rx_3_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan3x/mipi_dphy_rx_3x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan4x/mipi_dphy_rx_4x/inst/inst/slave_rx.mipi_dphy_rx_4_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan4x/mipi_dphy_rx_4x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan5x/mipi_dphy_rx_5x/inst/inst/slave_rx.mipi_dphy_rx_5_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan5x/mipi_dphy_rx_5x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan6x/mipi_dphy_rx_6x/inst/inst/slave_rx.mipi_dphy_rx_6_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan6x/mipi_dphy_rx_6x/inst/inst/rxbyteclkhs_buf]

set_property CLOCK_REGION [get_clock_regions -of \
[get_cells %ClipInstancePath%/*/*/MipiRxChan7x/mipi_dphy_rx_7x/inst/inst/slave_rx.mipi_dphy_rx_7_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[*].rx_bitslice_if_bs]] \
[get_cells %ClipInstancePath%/*/*/MipiRxChan7x/mipi_dphy_rx_7x/inst/inst/rxbyteclkhs_buf]


#-----------------------------------------------------------------------------
# Board timing parameters (FPGA carrier included in delays)
#-----------------------------------------------------------------------------
# derived from simulation
set tp_clk_to_fpga_min           0.920
set tp_clk_to_fpga_max           1.114
set tp_data_to_fpga_min          0.711
set tp_data_to_fpga_max          1.513

# derived from simulation
set tp_clk_to_cpld_min           0.782
set tp_clk_to_cpld_max           1.026
set tp_data_to_cpld_min          0.588
set tp_data_to_cpld_max          1.015

# from CPLD sdc file
set t_cpld_setup                  1.05
set t_cpld_hold                   0.25
set t_cpld_data_to_clock_dly_min  0.185
set t_cpld_data_to_clock_dly_max  1.6

#-----------------------------------------------------------------------------
# Fam Config IO resources
#-----------------------------------------------------------------------------
set InnerConfigDataFramePorts  [get_ports {aSeGpio[1] aSeGpio[4] aSeGpio[6] aSeGpio[9] aSeGpio[11] aSeGpio[15] aSeGpio[19] aSeGpio[23] aSeGpio[21]}]
set OuterConfigDataFramePorts  [get_ports {aSeGpio[0] aSeGpio[3] aSeGpio[5] aSeGpio[8] aSeGpio[10] aSeGpio[14] aSeGpio[18] aSeGpio[22] aSeGpio[16]}]

set InnerConfigIOBUFs     [get_cells -regexp {%ClipInstancePath%/.*IOBUFx} -filter {NAME=~.*InnerFrameIOBUFx || NAME=~.*InnerDataIOBUFx}]
set OuterConfigIOBUFs     [get_cells -regexp {%ClipInstancePath%/.*IOBUFx} -filter {NAME=~.*OuterFrameIOBUFx || NAME=~.*OuterDataIOBUFx}]
set WriteClkIOBUFs        [get_cells -regexp {%ClipInstancePath%/.*IOBUFx} -filter {NAME=~.*OuterFamCfgWriteClkIOBUFx || NAME=~.*InnerFamCfgWriteClkIOBUFx}]
set ConfigResetIOBUF      [get_cells -regexp {%ClipInstancePath%/.*IOBUFx} -filter {NAME=~.*InnerFamConfigResetIOBUFx}]

set InnerConfigIOBUF_Is   [get_pins -of_objects $InnerConfigIOBUFs -filter {REF_PIN_NAME == I}]
set InnerConfigIOBUF_Ts   [get_pins -of_objects $InnerConfigIOBUFs -filter {REF_PIN_NAME == T}]
set OuterConfigIOBUF_Is   [get_pins -of_objects $OuterConfigIOBUFs -filter {REF_PIN_NAME == I}]
set OuterConfigIOBUF_Ts   [get_pins -of_objects $OuterConfigIOBUFs -filter {REF_PIN_NAME == T}]
set WriteClkIOBUF_Ts      [get_pins -of_objects $WriteClkIOBUFs    -filter {REF_PIN_NAME == T}]
set ConfigResetIOBUF_T    [get_pins -of_objects $ConfigResetIOBUF  -filter {REF_PIN_NAME == T}]

#-----------------------------------------------------------------------------
# Data Output Constraint
#-----------------------------------------------------------------------------
set_output_delay -clock [get_clocks InnerConfigWriteClk] -min                        [expr $tp_data_to_cpld_min - $tp_clk_to_cpld_max - $t_cpld_hold ] [get_ports $InnerConfigDataFramePorts]
set_output_delay -clock [get_clocks InnerConfigWriteClk] -min -clock_fall -add_delay [expr $tp_data_to_cpld_min - $tp_clk_to_cpld_max - $t_cpld_hold ] [get_ports $InnerConfigDataFramePorts]
set_output_delay -clock [get_clocks OuterConfigWriteClk] -min                        [expr $tp_data_to_cpld_min - $tp_clk_to_cpld_max - $t_cpld_hold ] [get_ports $OuterConfigDataFramePorts]
set_output_delay -clock [get_clocks OuterConfigWriteClk] -min -clock_fall -add_delay [expr $tp_data_to_cpld_min - $tp_clk_to_cpld_max - $t_cpld_hold ] [get_ports $OuterConfigDataFramePorts]

set_output_delay -clock [get_clocks InnerConfigWriteClk] -max                        [expr $tp_data_to_cpld_max  - $tp_clk_to_cpld_min + $t_cpld_setup] [get_ports $InnerConfigDataFramePorts]
set_output_delay -clock [get_clocks InnerConfigWriteClk] -max -clock_fall -add_delay [expr $tp_data_to_cpld_max  - $tp_clk_to_cpld_min + $t_cpld_setup] [get_ports $InnerConfigDataFramePorts]
set_output_delay -clock [get_clocks OuterConfigWriteClk] -max                        [expr $tp_data_to_cpld_max  - $tp_clk_to_cpld_min + $t_cpld_setup] [get_ports $OuterConfigDataFramePorts]
set_output_delay -clock [get_clocks OuterConfigWriteClk] -max -clock_fall -add_delay [expr $tp_data_to_cpld_max  - $tp_clk_to_cpld_min + $t_cpld_setup] [get_ports $OuterConfigDataFramePorts]

#-----------------------------------------------------------------------------
# Data Input Constraint
#-----------------------------------------------------------------------------
set_input_delay -clock ConfigReadClkExternal -min                        [expr $tp_data_to_fpga_min + $t_cpld_data_to_clock_dly_min - $tp_clk_to_fpga_max] [get_ports $InnerConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -clock_fall -min -add_delay [expr $tp_data_to_fpga_min + $t_cpld_data_to_clock_dly_min - $tp_clk_to_fpga_max] [get_ports $InnerConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -min                        [expr $tp_data_to_fpga_min + $t_cpld_data_to_clock_dly_min - $tp_clk_to_fpga_max] [get_ports $OuterConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -clock_fall -min -add_delay [expr $tp_data_to_fpga_min + $t_cpld_data_to_clock_dly_min - $tp_clk_to_fpga_max] [get_ports $OuterConfigDataFramePorts]

set_input_delay -clock ConfigReadClkExternal -max                        [expr $tp_data_to_fpga_max + $t_cpld_data_to_clock_dly_max - $tp_clk_to_fpga_min] [get_ports $InnerConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -clock_fall -max -add_delay [expr $tp_data_to_fpga_max + $t_cpld_data_to_clock_dly_max - $tp_clk_to_fpga_min] [get_ports $InnerConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -max                        [expr $tp_data_to_fpga_max + $t_cpld_data_to_clock_dly_max - $tp_clk_to_fpga_min] [get_ports $OuterConfigDataFramePorts]
set_input_delay -clock ConfigReadClkExternal -clock_fall -max -add_delay [expr $tp_data_to_fpga_max + $t_cpld_data_to_clock_dly_max - $tp_clk_to_fpga_min] [get_ports $OuterConfigDataFramePorts]

#-----------------------------------------------------------------------------
# Tristate Output Setup Exceptions
#-----------------------------------------------------------------------------
# Only analyze rise to rise for setup. The tristate signal is SDR.
set_false_path -setup -rise_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Ts -fall_to [get_clocks InnerConfigWriteClk]
set_false_path -setup -fall_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Ts -to      [get_clocks InnerConfigWriteClk]

set_false_path -setup -rise_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Ts -fall_to [get_clocks OuterConfigWriteClk]
set_false_path -setup -fall_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Ts -to      [get_clocks OuterConfigWriteClk]

# The Tristate on the clock and reset are false-pathed, since the signal clears during start-up well before the signals are toggled and
# there is no need to meet timing on these signals.
set_false_path -through $WriteClkIOBUF_Ts
set_false_path -through $ConfigResetIOBUF_T

# It takes longer to set the bus to be tristated than to set the bus to be actively driven. Vivado also analyzes the
# second rising edge instead of the edge that immediately follows the launch clock rising edge. These multicycle paths
# ensure the correct edges are used for the assertion and deassertion of the tristate signal.
set_multicycle_path 0 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -fall_through $InnerConfigIOBUF_Ts -to [get_clocks InnerConfigWriteClk]
set_multicycle_path 1 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -rise_through $InnerConfigIOBUF_Ts -to [get_clocks InnerConfigWriteClk]

set_multicycle_path 0 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -fall_through $OuterConfigIOBUF_Ts -to [get_clocks OuterConfigWriteClk]
set_multicycle_path 1 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -rise_through $OuterConfigIOBUF_Ts -to [get_clocks OuterConfigWriteClk]

#-----------------------------------------------------------------------------
# Tristate Output Hold Exceptions
#-----------------------------------------------------------------------------
# Analyze fall to rise for hold. The tristate signal is SDR.
set_false_path -hold  -rise_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Ts -to      [get_clocks InnerConfigWriteClk]
set_false_path -hold  -fall_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Ts -fall_to [get_clocks InnerConfigWriteClk]

set_false_path -hold  -rise_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Ts -to      [get_clocks OuterConfigWriteClk]
set_false_path -hold  -fall_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Ts -fall_to [get_clocks OuterConfigWriteClk]

# It takes longer to set the bus to be tristated than to set the bus to be actively driven.
set_multicycle_path -1 -hold -end -from [get_clocks -of_objects $ClipPllOut0] -fall_through $InnerConfigIOBUF_Ts -to [get_clocks InnerConfigWriteClk]
set_multicycle_path -1 -hold -end -from [get_clocks -of_objects $ClipPllOut0] -fall_through $OuterConfigIOBUF_Ts -to [get_clocks OuterConfigWriteClk]

#-----------------------------------------------------------------------------
# Data Output Setup Exceptions
#-----------------------------------------------------------------------------
set_false_path -setup -rise_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -fall_to [get_clocks InnerConfigWriteClk]
set_false_path -setup -fall_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -rise_to [get_clocks InnerConfigWriteClk]
set_multicycle_path 0 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -to [get_clocks InnerConfigWriteClk]

set_false_path -setup -rise_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -fall_to [get_clocks OuterConfigWriteClk]
set_false_path -setup -fall_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -rise_to [get_clocks OuterConfigWriteClk]
set_multicycle_path 0 -setup -end -from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -to [get_clocks OuterConfigWriteClk]

#-----------------------------------------------------------------------------
# Data Output Hold Exceptions
#-----------------------------------------------------------------------------
set_false_path -hold  -rise_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -rise_to [get_clocks InnerConfigWriteClk]
set_false_path -hold  -fall_from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -fall_to [get_clocks InnerConfigWriteClk]
set_multicycle_path -1 -hold -end -from [get_clocks -of_objects $ClipPllOut0] -through $InnerConfigIOBUF_Is -to [get_clocks InnerConfigWriteClk]

set_false_path -hold  -rise_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -rise_to [get_clocks OuterConfigWriteClk]
set_false_path -hold  -fall_from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -fall_to [get_clocks OuterConfigWriteClk]
set_multicycle_path -1 -hold -end -from [get_clocks -of_objects $ClipPllOut0] -through $OuterConfigIOBUF_Is -to [get_clocks OuterConfigWriteClk]

# Don't analyze ReadClock to WriteClock timing
set_false_path -from [get_clocks InnerConfigReadClk] -to [get_clocks InnerConfigWriteClk]
set_false_path -from [get_clocks OuterConfigReadClk] -to [get_clocks OuterConfigWriteClk]

#-----------------------------------------------------------------------------
# xIoEnable Constraints
#-----------------------------------------------------------------------------
# Don't analyze async output enable on JTAG IO
set_false_path -from [get_cells %ClipInstancePath%/xIoOutputEnableLcl_reg] -to [get_ports {aSeGpio[7] aSeGpio[24] aSeGpio[26] aSeGpio[27] aSeGpio[28]}]

#-----------------------------------------------------------------------------
# Exclusive Clocks on CSI2 IP Shared Logic
#-----------------------------------------------------------------------------
# Get each pair of clocks which feed the output of each PLL through the mux
set SharedLogicAPll0Clk0 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankA/BUFGCTRL0x/I0]]
set SharedLogicAPll0Clk1 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankA/BUFGCTRL0x/I1]]
set SharedLogicAPll1Clk0 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankA/BUFGCTRL1x/I0]]
set SharedLogicAPll1Clk1 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankA/BUFGCTRL1x/I1]]
set SharedLogicBPll0Clk0 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankB/BUFGCTRL0x/I0]]
set SharedLogicBPll0Clk1 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankB/BUFGCTRL0x/I1]]
set SharedLogicBPll1Clk0 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankB/BUFGCTRL1x/I0]]
set SharedLogicBPll1Clk1 [get_clocks -include_generated_clocks -of_objects [get_pins %ClipInstancePath%/Mipi*/*/MipiSharedLogicBankB/BUFGCTRL1x/I1]]

# Set each pair as logically_exclusive
set_clock_groups -logically_exclusive -group $SharedLogicAPll0Clk0 -group $SharedLogicAPll0Clk1
set_clock_groups -logically_exclusive -group $SharedLogicAPll1Clk0 -group $SharedLogicAPll1Clk1
set_clock_groups -logically_exclusive -group $SharedLogicBPll0Clk0 -group $SharedLogicBPll0Clk1
set_clock_groups -logically_exclusive -group $SharedLogicBPll1Clk0 -group $SharedLogicBPll1Clk1



set NI148xClipTop0 [current_instance .]
current_instance %ClipInstancePath%/NI148xFixedLogicx
## Start add from file ni148xfixedlogic.xdc

###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################
## Start add from file NI148xFixedLogic.xdc



set BasePath SerialIoClkRSD
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set NI148xFixedLogic0 [current_instance .]
current_instance MicroblazeWrapperx
set NI148xFixedLogic1 [current_instance .]
current_instance FamConfigMicroblazex
## Start add from file FamConfigMicroblaze_mod.xdc
set FamConfigMicroblazeInst [current_instance .]

####################################################################################
# Generated by Vivado 2019.1.1 built on 'Sat Jun 29 08:04:45 MDT 2019' by 'xbuild'
# Command Used: write_xdc -exclude_physical -force /azp/agent/_work/11/s/hw-flexrio/iomodules/automotive_vision/clip/objects/tool/synth_mb_netlist/Release/xdc/timing/FamConfigMicroblaze.xdc
####################################################################################


####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_axi_timer_0_0.xdc'
####################################################################################

current_instance FamConfigMicroblazeBdx/axi_timer_0/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_mdm_0_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/mdm_0/U0
create_clock -period 33.333 [get_pins Use*.BSCAN*/*/INTERNAL_TCK]
create_generated_clock -source [get_pins Use*.BSCAN*/*/INTERNAL_TCK] -divide_by 2 [get_pins Use*.BSCAN*/*/UPDATE]
create_generated_clock -source [get_pins Use*.BSCAN*/*/INTERNAL_TCK] -divide_by 1 [get_pins Use*.BSCAN*/*/DRCK]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins Use*.BSCAN*/*/INTERNAL_TCK]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins Use*.BSCAN*/*/UPDATE]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins Use*.BSCAN*/*/DRCK]]
set_input_delay -clock [get_clocks -of_objects [get_pins Use*.BSCAN*/*/DRCK]] 1.000 [get_pins Use*.BSCAN*/*/INTERNAL_TDI]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_microblaze_0_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/microblaze_0/U0
set_false_path -through [get_ports -scoped_to_current_instance Reset]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_dlmb_v10_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/microblaze_0_local_memory/dlmb_v10/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_ilmb_v10_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/microblaze_0_local_memory/ilmb_v10/U0
set_false_path -through [get_ports -scoped_to_current_instance SYS_Rst]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_0_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/proc_sys_reset_0/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_1_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/proc_sys_reset_1/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_2_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/proc_sys_reset_2/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_3_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/proc_sys_reset_3/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_4_0.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/proc_sys_reset_4/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'FamConfigMicroblazeBd_proc_sys_reset_0_1.xdc'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/proc_sys_reset_0/U0
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'xpm_cdc_handshake.tcl'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
set_max_delay -datapath_only -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000
set_bus_skew -from [get_cells src_hsdata_ff_reg*] -to [get_cells dest_hsdata_ff_reg*] 3003.000

####################################################################################
# Constraints from file : 'xpm_cdc_single.tcl'
####################################################################################

current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m10_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m09_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m08_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m07_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m06_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m05_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m04_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m02_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m01_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake/xpm_cdc_single_dest2src_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance -quiet
current_instance $FamConfigMicroblazeInst
current_instance FamConfigMicroblazeBdx/serialclock_axi/axi_interconnect_0/m00_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake/xpm_cdc_single_src2dest_inst
set_false_path -to [get_cells {syncstages_ff_reg[0]}]

# Vivado Generated miscellaneous constraints

#revert back to original instance
current_instance -quiet
current_instance $FamConfigMicroblazeInst



current_instance -quiet
current_instance $NI148xFixedLogic1

current_instance -quiet
current_instance $NI148xFixedLogic0
set NI148xFixedLogic0 [current_instance .]
current_instance IoBridgeWrapperx
set NI148xFixedLogic1 [current_instance .]
current_instance InnerFamTransparentIoBridgeMaster
## Start add from file TransparentIoBridgeMaster.xdc

###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################
set BasePath ConfigReadClkRSDx
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/DataHSx
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/OcRevisionErrDsx
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/ReadyDsx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/RevisionErrDsx
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/RevisionHSx
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigOeDsx
## Start include, file DoubleSyncSL_RSD.xml
set DoubleSyncSlRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlRsdPath






current_instance -quiet
current_instance $NI148xFixedLogic1
set NI148xFixedLogic1 [current_instance .]
current_instance OuterFamTransparentIoBridgeMaster
## Start add from file TransparentIoBridgeMaster.xdc

###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################
set BasePath ConfigReadClkRSDx
## Start include, file ResetSyncDeassert.xml
set ResetSyncDeassertPath $BasePath
set BasePath $BasePath/DoubleSyncBoolAsyncInx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/DataHSx
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/OcRevisionErrDsx
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/ReadyDsx
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/RevisionErrDsx
## Start include, file DoubleSyncBoolRSD.xml
set DoubleSyncBoolRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncBoolRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigReadClkCrossingx/RevisionHSx
## Start include, file HandshakeSLV_RSD.xml
set HandshakeSlvRsdPath $BasePath
set BasePath $BasePath/HBx
## Start add from file HandshakeBaseRSD.xdc
# ---------------------------------------------------------------------------------------
# HandshakeBaseRSD
# ---------------------------------------------------------------------------------------
# Save incoming path
set HandshakeBaseRsdPath $BasePath

# Data
set TNM_HS_iData   [get_cells "$BasePath/BlkIn.iStoredDatax/*/*"      -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oData   [get_cells "$BasePath/*oDataFlopx/*/*"        -filter {IS_SEQUENTIAL==true}]
# Toggle
set TNM_HS_iTog    [get_cells "$BasePath/*iPushTogglex/*"        -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog_ms [get_cells "$BasePath/*oPushToggle0_msx/*"    -filter {IS_SEQUENTIAL==true}]
set TNM_HS_oTog    [get_cells "$BasePath/*oPushToggle1x/*"       -filter {IS_SEQUENTIAL==true}]
# Ready
set TNM_HS_oRdy    [get_cells "$BasePath/*oPushToggleToReadyx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy_ms [get_cells "$BasePath/*iRdyPushToggle_msx/*"  -filter {IS_SEQUENTIAL==true}]
set TNM_HS_iRdy    [get_cells "$BasePath/*iRdyPushTogglex/*"     -filter {IS_SEQUENTIAL==true}]

# Find out the minimum period of the clocks related to the previous groups.
set T_IClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_iData]] ,])"]
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_HS_oData]] ,])"]

# The datapath clock crossings must be less than 2X the period of the destination clock.
set_max_delay  -from $TNM_HS_iData   -to $TNM_HS_oData -datapath_only [expr 2 * $T_OClkMin - 0.5]

# Toggle
set_false_path -from $TNM_HS_iTog    -to $TNM_HS_oTog_ms
set_max_delay  -from $TNM_HS_oTog_ms -to $TNM_HS_oTog -datapath_only [expr 0.5 * $T_OClkMin]

# The return ready path isn't very important here.
set_false_path -from $TNM_HS_oRdy    -to $TNM_HS_iRdy_ms
set_max_delay  -from $TNM_HS_iRdy_ms -to $TNM_HS_iRdy -datapath_only [expr 0.5 * $T_IClkMin]


set BasePath $HandshakeSlvRsdPath


set BasePath IoBridgeMasterFsmx/InputLogicBlock.ConfigOeDsx
## Start include, file DoubleSyncSL_RSD.xml
set DoubleSyncSlRsdPath $BasePath
set BasePath $BasePath/DoubleSyncBasex
## Start add from file DoubleSyncBase.xdc
# ---------------------------------------------------------------------------------------
# DoubleSyncBase
# ---------------------------------------------------------------------------------------
# Save Incoming path
set DoubleSyncBasePath $BasePath

# First create the groups that will be needed in the -from/to constraints
set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]

#Second, find out the period of the clocks related to the previous groups
set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]

set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]


set BasePath $DoubleSyncSlRsdPath






current_instance -quiet
current_instance $NI148xFixedLogic1

current_instance -quiet
current_instance $NI148xFixedLogic0
set NI148xFixedLogic0 [current_instance .]
current_instance TimingEnginex
## Start include, file TimingEngine.xml
set BasePath SyncClkEn
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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


set BasePath FilterStdLogicx
## Start include, file FilterStdLogic.xml
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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





# Ignore timing on the enable of the safebufgce
set_false_path -from [get_cells bSerialIoClkEn_reg] -to [get_cells -hierarchical SafeBUFGCTRLx]
set_false_path -from [get_cells bDataClkEn_reg] -to [get_cells -hierarchical SafeBUFGCTRLx]




current_instance -quiet
current_instance $NI148xFixedLogic0
set NI148xFixedLogic0 [current_instance .]
current_instance JtagControlx
set BasePath FldUpdJtagTdoDs
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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



current_instance -quiet
current_instance $NI148xFixedLogic0
set NI148xFixedLogic0 [current_instance .]
current_instance JtagControlx
set BasePath InnerFldUpdJtagSelDs
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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



current_instance -quiet
current_instance $NI148xFixedLogic0
set NI148xFixedLogic0 [current_instance .]
current_instance JtagControlx
set BasePath IsJtagNoMuxDs
## Start include, file DoubleSyncBoolAsyncIn.xml
set DoubleSyncBoolAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncSlAsyncInx
## Start include, file DoubleSyncSlAsyncIn.xml
set DoubleSyncSlAsyncInPath $BasePath
set BasePath $BasePath/DoubleSyncAsyncInBasex
## Start add from file DoubleSyncAsyncInBase.xdc
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



current_instance -quiet
current_instance $NI148xFixedLogic0




current_instance -quiet
current_instance $NI148xClipTop0


###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################
set NI148xClipTop0 [current_instance .]
current_instance %ClipInstancePath%/Mipi8TxTopx
## Start add from file Mipi8TxTop_mod.xdc
set NiMipiCsi2Inst [current_instance .]

####################################################################################
# Generated by Vivado 2019.1.1 built on 'Sat Jun 29 08:04:45 MDT 2019' by 'xbuild'
# Command Used: write_xdc -force -exclude_physical /azp/agent/_work/11/s/hw-flexrio/iomodules/automotive_vision/clip/objects/tool/synth_mipicsi2ip/Mipi8TxTop/outputs/Mipi8TxTop.xdc
####################################################################################


####################################################################################
# Constraints from file : 'SharedLogicMmcm.xdc'
####################################################################################

current_instance Mipi8Txx/MipiSharedLogicBankA/SharedLogicMmcmx/inst
set_false_path -from [get_pins -leaf -of_objects [get_cells -hier *ram_clk_config* -filter is_sequential] -filter NAME=~*/C] -to [get_pins -leaf -of_objects [get_cells -hier *ram* -filter is_sequential] -filter NAME=~*/D]
current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiSharedLogicBankB/SharedLogicMmcmx/inst
set_false_path -from [get_pins -leaf -of_objects [get_cells -hier *ram_clk_config* -filter is_sequential] -filter NAME=~*/C] -to [get_pins -leaf -of_objects [get_cells -hier *ram* -filter is_sequential] -filter NAME=~*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_0.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan0x/mipi_dphy_tx_0x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_0_hssio_tx64.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan0x/mipi_dphy_tx_0x/inst/inst/master_tx.mipi_dphy_tx_0_tx64_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_1.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan1x/mipi_dphy_tx_1x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_1_hssio_tx64.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan1x/mipi_dphy_tx_1x/inst/inst/master_tx.mipi_dphy_tx_1_tx64_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_2.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan2x/mipi_dphy_tx_2x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_2_hssio_tx64.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan2x/mipi_dphy_tx_2x/inst/inst/master_tx.mipi_dphy_tx_2_tx64_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_3.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan3x/mipi_dphy_tx_3x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_3_hssio_tx64.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan3x/mipi_dphy_tx_3x/inst/inst/master_tx.mipi_dphy_tx_3_tx64_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_4.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan4x/mipi_dphy_tx_4x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_4_hssio_tx67.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan4x/mipi_dphy_tx_4x/inst/inst/master_tx.mipi_dphy_tx_4_tx67_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_5.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan5x/mipi_dphy_tx_5x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_5_hssio_tx67.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan5x/mipi_dphy_tx_5x/inst/inst/master_tx.mipi_dphy_tx_5_tx67_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_6.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan6x/mipi_dphy_tx_6x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_6_hssio_tx67.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan6x/mipi_dphy_tx_6x/inst/inst/master_tx.mipi_dphy_tx_6_tx67_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_7.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan7x/mipi_dphy_tx_7x/inst
set_false_path -to [get_pins -hier *cdc_to*/D]

####################################################################################
# Constraints from file : 'mipi_dphy_tx_7_hssio_tx67.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
current_instance Mipi8Txx/MipiTxChan7x/mipi_dphy_tx_7x/inst/inst/master_tx.mipi_dphy_tx_7_tx67_hssio_i/inst
set_false_path -to [get_pins -hier *sync_flop_0*/D]

####################################################################################
# Constraints from file : 'Mipi8TxTop.xdc'
####################################################################################

current_instance -quiet
current_instance $NiMipiCsi2Inst
create_clock -period 5.000 -name VideoClk -waveform {0.000 2.500} [get_ports VideoClk]
create_clock -period 2.500 -name FastVideoClk -waveform {0.000 1.250} [get_ports FastVideoClk]
create_clock -period 5.000 -name CoreClk -waveform {0.000 2.500} [get_ports CoreClk]
create_clock -period 12.500 -name BusClk -waveform {0.000 6.250} [get_ports BusClk]
set_false_path -from [get_cells -hierarchical *bPll*ClkMuxSel_reg*] -to [get_cells -hierarchical BUFGCTRL*x]
set_false_path -from [get_clocks BusClk] -to [get_clocks CoreClk]
set_input_delay -clock [get_clocks BusClk] -min -add_delay 2.000 [get_ports {bAxiToSlaveFlat[*]}]
set_input_delay -clock [get_clocks BusClk] -max -add_delay 2.500 [get_ports {bAxiToSlaveFlat[*]}]
set_input_delay -clock [get_clocks CoreClk] -min -add_delay 2.000 [get_ports cReset]
set_input_delay -clock [get_clocks CoreClk] -max -add_delay 2.500 [get_ports cReset]
set_input_delay -clock [get_clocks BusClk] -min -add_delay 2.000 [get_ports bAxiIcReset_n]
set_input_delay -clock [get_clocks BusClk] -max -add_delay 2.500 [get_ports bAxiIcReset_n]
set_input_delay -clock [get_clocks BusClk] -min -add_delay 2.000 [get_ports bAxiPeriphReset_n]
set_input_delay -clock [get_clocks BusClk] -max -add_delay 2.500 [get_ports bAxiPeriphReset_n]
set_input_delay -clock [get_clocks VideoClk] -min -add_delay 2.000 [get_ports vReset]
set_input_delay -clock [get_clocks VideoClk] -max -add_delay 2.500 [get_ports vReset]
set_false_path -through [get_pins -of [get_cells -hier *bVec_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bVec_ms* -filter IS_SEQUENTIAL==true]
set_false_path -through [get_pins -of [get_cells -hier *bTxChan0Debug_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bTxChan0Debug_ms* -filter IS_SEQUENTIAL==true]
set_false_path -through [get_pins -of [get_cells -hier -regexp .*AxiStreamToPpix/.*/cStopState_ms_reg -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier -regexp .*AxiStreamToPpix/.*/cStopState_ms_reg -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier -regexp .*AxiStreamToPpix/.*/cStopState_ms_reg -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp .*AxiStreamToPpix/.*/cStopState_reg -filter IS_SEQUENTIAL==true] 2.667
set_false_path -through [get_pins -of [get_cells -hier *cResetPhy_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *cResetPhy_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *cResetPhy_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *cResetPhy_reg* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -through [get_pins -of [get_cells -hier *bPllLocked0_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bPllLocked0_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *bPllLocked0_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *bPllLocked0_reg* -filter IS_SEQUENTIAL==true] 6.250
set_false_path -through [get_pins -of [get_cells -hier *bPllLocked1_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bPllLocked1_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *bPllLocked1_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *bPllLocked1_reg* -filter IS_SEQUENTIAL==true] 6.250
set_false_path -through [get_pins -of [get_cells -hier *bMmcmLocked_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bMmcmLocked_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *bMmcmLocked_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *bMmcmLocked_reg* -filter IS_SEQUENTIAL==true] 6.250
set_false_path -through [get_pins -of [get_cells -hier *bTxSystemRst_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *bTxSystemRst_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *bTxSystemRst_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *bTxSystemRst_reg* -filter IS_SEQUENTIAL==true] 6.250
set_false_path -through [get_pins -of [get_cells -hier *cLockedAll_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *cLockedAll_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *cLockedAll_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *cLockedAll_reg* -filter IS_SEQUENTIAL==true] 2.500
set_max_delay -datapath_only -from [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 9.500
set_false_path -from [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -from [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/SyncPacketGenx/HandshakeSLV_RSDx/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 6.250
set_false_path -through [get_pins -of [get_cells -hier -regexp {.*Mipi.Tx(4Rx|2Rx)?x/MipiTxChan.x/RsdResetGenx/(SyncReset\[\d+\].)?cSig(_ms)?x.*} -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==PRE] -to [get_cells -hier -regexp {.*Mipi.Tx(4Rx|2Rx)?x/MipiTxChan.x/RsdResetGenx/(SyncReset\[\d+\].)?cSig(_ms)?x.*} -filter IS_SEQUENTIAL==true]
set_input_delay -clock [get_clocks VideoClk] -min -add_delay 1.000 [get_ports {vTxChan*AxiStreamFlat[*]}]
set_input_delay -clock [get_clocks VideoClk] -max -add_delay 1.500 [get_ports {vTxChan*AxiStreamFlat[*]}]
set_false_path -through [get_pins -of [get_cells -hier *thContinuousHsMode_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *thContinuousHsMode_ms* -filter IS_SEQUENTIAL==true]
set_false_path -through [get_pins -of [get_cells -hier *thClrTxFifo_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *thClrTxFifo_ms* -filter IS_SEQUENTIAL==true]
set_false_path -through [get_pins -of [get_cells -hier *fClrTxFifo_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *fClrTxFifo_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] 2.500
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/.*/.*} -filter IS_SEQUENTIAL==true] 1.250
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] 5.000
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoClockSlowToFastClk/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/.*/.*} -filter IS_SEQUENTIAL==true] 2.500
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrAGrayx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] 5.333
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrBGrayx/.*/.*} -filter IS_SEQUENTIAL==true] 2.667
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToOClkx/cAddrAGrayx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] 2.500
set_max_delay -datapath_only -from [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGray_msx/.*/.*} -filter IS_SEQUENTIAL==true] -to [get_cells -hier -regexp {.*Mipi8Txx/MipiTxChan\dx/AxiStreamToPpix/FifoFastVideoClkToTxByteClkHS/Fifox/FifoFlagsx/BlkAddr.SyncToIClkx/cAddrBGrayx/.*/.*} -filter IS_SEQUENTIAL==true] 1.250
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 10.166
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxDataLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 6.250
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 9.500
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/ActiveLaneCountHandshake/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 6.250
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 10.166
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/TxClockLaneCtrlx/HandshakeUnsignedRSDx/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 6.250
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 10.166
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/ActiveLaneCountHandshake/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 6.250
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/BlkIn.iStoredDatax/*/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*oDataFlopx/*/* -filter IS_SEQUENTIAL==true] 9.500
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*iPushTogglex/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*oPushToggle0_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*oPushToggle1x/* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*oPushToggleToReadyx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*iRdyPushToggle_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/HandshakeUnsignedRSDx/HBx/*iRdyPushTogglex/* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncBasex/iDlySigx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncBasex/DoubleSyncAsyncInBasex/oSigx/* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -through [get_pins -of [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncAsyncInBasex/oSig_msx/* -filter IS_SEQUENTIAL==true] -to [get_cells Mipi8Txx/MipiTxChan*/AxiStreamToPpix/PulseSyncSL_RSDx/PulseSyncBasex/DoubleSyncAsyncInBasex/oSigx/* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -through [get_pins -of [get_cells -hier *vFsmReadyForTxTog_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *vFsmReadyForTxTog_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *vFsmReadyForTxTog_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *vFsmReadyForTxTog_reg* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -through [get_pins -of [get_cells -hier *vFsmTxDoneTog_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *vFsmTxDoneTog_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *vFsmTxDoneTog_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *vFsmTxDoneTog_reg* -filter IS_SEQUENTIAL==true] 2.500
set_false_path -through [get_pins -of [get_cells -hier *thFsmTxDoneAckTog_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *thFsmTxDoneAckTog_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *thFsmTxDoneAckTog_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *thFsmTxDoneAckTog_reg* -filter IS_SEQUENTIAL==true] 2.667
set_false_path -through [get_pins -of [get_cells -hier *thReset_ms* -filter IS_SEQUENTIAL==true] -filter REF_PIN_NAME==D] -to [get_cells -hier *thReset_ms* -filter IS_SEQUENTIAL==true]
set_max_delay -datapath_only -from [get_cells -hier *thReset_ms* -filter IS_SEQUENTIAL==true] -to [get_cells -hier *thReset_reg* -filter IS_SEQUENTIAL==true] 2.667

# Vivado Generated miscellaneous constraints

#revert back to original instance
current_instance -quiet
current_instance $NiMipiCsi2Inst



current_instance -quiet
current_instance $NI148xClipTop0
## Start add from file NI148xIoTiming.xdc



