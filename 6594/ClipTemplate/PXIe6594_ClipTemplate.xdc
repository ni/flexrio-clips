# vreview_group Ni6594TemplateClipConstraints
# vreview_closed http://review-board.natinst.com/r/332216/
# vreview_reviewers kygreen dhearn amoch

# Any constraints required by the user IP should be included in here.
# This template CLIP routes MgtRefClk(3:0) directly to the LabVIEW diagram.
# Constraints are included here to set these clocks to a maximum rate of
# 333MHz. Other IP will require modifying these constraints to set the
# reference clock to the proper frequency for the protocol, and adding
# additional constraints.

create_clock -period 3 [get_ports MgtRefClk_p[0]]
create_clock -period 3 [get_ports MgtRefClk_p[1]]
create_clock -period 3 [get_ports MgtRefClk_p[2]]
create_clock -period 3 [get_ports MgtRefClk_p[3]]

