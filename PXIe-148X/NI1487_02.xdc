##################################################################
# Differential Data
##################################################################
set DphyPins [get_ports { \
  aDiffGpio0_n  \
  aDiffGpio0_p  \
  aDiffGpio10_n \
  aDiffGpio10_p \
  aDiffGpio11_n \
  aDiffGpio11_p \
  aDiffGpio12_n \
  aDiffGpio12_p \
  aDiffGpio13_n \
  aDiffGpio13_p \
  aDiffGpio14_n \
  aDiffGpio14_p \
  aDiffGpio15_n \
  aDiffGpio15_p \
  aDiffGpio16_n \
  aDiffGpio16_p \
  aDiffGpio18_n \
  aDiffGpio18_p \
  aDiffGpio19_n \
  aDiffGpio19_p \
  aDiffGpio20_n \
  aDiffGpio20_p \
  aDiffGpio21_n \
  aDiffGpio21_p \
  aDiffGpio22_n \
  aDiffGpio22_p \
  aDiffGpio23_n \
  aDiffGpio23_p \
  aDiffGpio24_n \
  aDiffGpio24_p \
  aDiffGpio25_n \
  aDiffGpio25_p \
  aDiffGpio26_n \
  aDiffGpio26_p \
  aDiffGpio28_n \
  aDiffGpio28_p \
  aDiffGpio29_n \
  aDiffGpio29_p \
  aDiffGpio2_n  \
  aDiffGpio2_p  \
  aDiffGpio30_n \
  aDiffGpio30_p \
  aDiffGpio31_n \
  aDiffGpio31_p \
  aDiffGpio32_n \
  aDiffGpio32_p \
  aDiffGpio33_n \
  aDiffGpio33_p \
  aDiffGpio34_n \
  aDiffGpio34_p \
  aDiffGpio35_n \
  aDiffGpio35_p \
  aDiffGpio36_n \
  aDiffGpio36_p \
  aDiffGpio38_n \
  aDiffGpio38_p \
  aDiffGpio39_n \
  aDiffGpio39_p \
  aDiffGpio3_n  \
  aDiffGpio3_p  \
  aDiffGpio41_n \
  aDiffGpio41_p \
  aDiffGpio42_n \
  aDiffGpio42_p \
  aDiffGpio43_n \
  aDiffGpio43_p \
  aDiffGpio44_n \
  aDiffGpio44_p \
  aDiffGpio4_n  \
  aDiffGpio4_p  \
  aDiffGpio5_n  \
  aDiffGpio5_p  \
  aDiffGpio6_n  \
  aDiffGpio6_p  \
  aDiffGpio7_n  \
  aDiffGpio7_p  \
  aDiffGpio8_n  \
  aDiffGpio8_p  \
  aDiffGpio9_n  \
  aDiffGpio9_p  \
}]

set_property IOSTANDARD MIPI_DPHY_DCI $DphyPins

##################################################################
# Single Ended Data
##################################################################
set SeDataPins_NoBoardPulls [get_ports { \
  aSeGpio[0]  \
  aSeGpio[4]  \
  aSeGpio[6]  \
  aSeGpio[8]  \
  aSeGpio[10] \
  aSeGpio[12] \
  aSeGpio[14] \
  aSeGpio[16] \
  aSeGpio[18] \
  aSeGpio[22] \
  aSeGpio[24] \
  aSeGpio[26] \
  aSeGpio[28] \
  aSeGpio[1]  \
  aSeGpio[3]  \
  aSeGpio[5]  \
  aSeGpio[7]  \
  aSeGpio[9]  \
  aSeGpio[11] \
  aSeGpio[13] \
  aSeGpio[15] \
  aSeGpio[19] \
  aSeGpio[21] \
  aSeGpio[23] \
  aSeGpio[27] \
  aSeGpio[29] \
}]

set SeDataPins_WithBoardPulls [get_ports { \
  aSeGpio[2]  \
  aSeGpio[25] \
}]

set SeDataPins_ConfigReset [get_ports { \
  aSeGpio[25] \
}]

set IoBridgeRdClkPins [get_ports { \
  aSeGpio[17]  \
  aSeGpio[20]  \
}]

set_property IOSTANDARD LVCMOS18 $SeDataPins_NoBoardPulls
set_property SLEW FAST $SeDataPins_NoBoardPulls
set_property DRIVE 12 $SeDataPins_NoBoardPulls
set_property IOB TRUE $SeDataPins_NoBoardPulls
set_property PULLTYPE PULLDOWN $SeDataPins_NoBoardPulls

set_property IOSTANDARD LVCMOS18 $SeDataPins_WithBoardPulls
set_property SLEW FAST $SeDataPins_WithBoardPulls
set_property DRIVE 12 $SeDataPins_WithBoardPulls
set_property IOB TRUE $SeDataPins_WithBoardPulls

#Deliberately override fast slew on reset to prevent non-monotonic edge due
#to multi-destination routing.
set_property SLEW SLOW $SeDataPins_ConfigReset

#Setting IO Bridge Clock input to HSTL_18 IO Standard for tighter input timing
#Not changing data pins to HSTL_18 as that caused a slower output driver
#and caused output timing to fail.  Just changing the clock to HSTL_18 is enough
#to pass timing.
set_property INTERNAL_VREF 0.9 [get_iobanks 88]
set_property INTERNAL_VREF 0.9 [get_iobanks 89]
set_property OFFCHIP_TERM NONE $IoBridgeRdClkPins
set_property IOSTANDARD HSTL_I_18 $IoBridgeRdClkPins
set_property SLEW SLOW $IoBridgeRdClkPins

set SeDataPins_NoIOB [get_ports { \
  aSeGpio[0]  \
  aSeGpio[4]  \
  aSeGpio[6]  \
  aSeGpio[8]  \
  aSeGpio[10] \
  aSeGpio[14] \
  aSeGpio[16] \
  aSeGpio[18] \
  aSeGpio[22] \
  aSeGpio[1]  \
  aSeGpio[3]  \
  aSeGpio[5]  \
  aSeGpio[9]  \
  aSeGpio[11] \
  aSeGpio[15] \
  aSeGpio[19] \
  aSeGpio[21] \
  aSeGpio[23] \
}]

# Override any previous IOB setting on the CPLD config interface
# to improve timing on the flops
set_property IOB FALSE $SeDataPins_NoIOB