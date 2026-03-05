## XDC generated for xcku060-ffva1156-2 device
# 100.0MHz GT Reference clock constraint
create_clock -name GT_REFCLK1 -period 10.0	 [get_ports MgtRefClk_p]

###### CDC in RESET_LOGIC from INIT_CLK to USER_CLK ##############
set_false_path -to [get_pins -hier *aurora_8b10b_DF_cdc_to*/D]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer_tx_done_inst/*/CLR}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_synchronizer_rx_done_inst/*/CLR}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *bit_synchronizer_txresetdone_inst/i_in_meta_reg/D}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *bit_synchronizer_rxresetdone_inst/i_in_meta_reg/D}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *bit_synchronizer_gtwiz_reset_userclk_tx_active_inst/i_in_meta_reg/D}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *bit_synchronizer_gtwiz_reset_userclk_rx_active_inst/i_in_meta_reg/D}]