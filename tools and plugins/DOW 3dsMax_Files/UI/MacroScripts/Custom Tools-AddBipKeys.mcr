macroScript AddBipKeys
category:"Custom Tools"
toolTip:"Add Biped COM Keys"
icon:#("Custom_Tools",1)
(
on isEnabled return selection.count == 1 and classOf selection[1] == Biped_Object

on execute do
	(
	
	bip = (biped.getNode selection[1] 13).transform.controller
	
	vert = bip.vertical.controller
	horiz = bip.horizontal.controller
	turn = bip.turning.controller
	
	biped.addNewKey horiz currentTime
	biped.addNewKey vert currentTime
	biped.addNewKey turn currentTime
	)
)		