/*
*/
macroScript StartContentBrowser
	enabledIn:#("VIZR", "viz")
	ToolTip:"Start Content Browser"
	ButtonText:"Start Content Browser"
	Category:"AutoCAD Architecture Tools"
	internalCategory:"AutoCAD Architecture Tools"
	Icon:#("ACADCB",1) -- this points the icon to the ACADCB.BMP file, 1st icon
(
	
	on isEnabled return (doesFileExist(getDir #maxroot + "AECCB.EXE"))
	on execute do
	(
		if doesFileExist(getDir #maxroot + "AECCB.EXE") then
			shelllaunch (getDir #maxroot + "AECCB.EXE") ""
	)
)
