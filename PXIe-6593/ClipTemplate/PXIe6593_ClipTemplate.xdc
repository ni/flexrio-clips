# This XDC file just creates period constraints on the reference clock.
# Any constraints required by the user IP should be added in here.

create_clock -period 3 [get_ports MgtRefClk_p[0]]
create_clock -period 3 [get_ports MgtRefClk_p[1]]
create_clock -period 3 [get_ports MgtRefClk_p[2]]

