# Any constraints required by the user IP should be included in here.
# This template CLIP routes MgtRefClk(11:0) directly to the LabVIEW diagram.
# Constraints are included here to set these clocks to a maximum rate of
# 775MHz. Other IP will require modifying these constraints to set the
# reference clock to the proper frequency for the protocol, and adding
# additional constraints.

create_clock -period 1.29 [get_ports MgtRefClk_p[0]]
create_clock -period 1.29 [get_ports MgtRefClk_p[1]]
create_clock -period 1.29 [get_ports MgtRefClk_p[2]]
create_clock -period 1.29 [get_ports MgtRefClk_p[3]]
create_clock -period 1.29 [get_ports MgtRefClk_p[4]]
create_clock -period 1.29 [get_ports MgtRefClk_p[5]]
create_clock -period 1.29 [get_ports MgtRefClk_p[6]]
create_clock -period 1.29 [get_ports MgtRefClk_p[7]]
create_clock -period 1.29 [get_ports MgtRefClk_p[8]]
create_clock -period 1.29 [get_ports MgtRefClk_p[9]]
create_clock -period 1.29 [get_ports MgtRefClk_p[10]]
create_clock -period 1.29 [get_ports MgtRefClk_p[11]]

