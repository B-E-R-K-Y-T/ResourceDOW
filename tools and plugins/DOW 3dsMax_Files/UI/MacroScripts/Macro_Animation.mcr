/*
 
***************************************************************************
Macro_Scripts File
Author:   Adam Felt
Macro_Scripts that implement some animation specific methods

Revision History
    May 26, 2004 - Adam Felt - Created
    December 14, 2004 - Nicolas Léonard - added ToggleLimits
	
-- MODIFY THIS AT YOUR OWN RISK
***************************************************************************

*/

macroScript DeleteSelectedAnimation
enabledIn:#("max", "viz")
buttontext:"Delete Selected Animation"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Delete Selected Animation" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	
	On Execute Do
	(
		maxOps.deleteSelectedAnimation()
	)
)

macroScript OpenReactionManager
	enabledIn:#("max")
	buttontext:"Reaction Manager"
	category:"Animation Tools"
	internalCategory:"Animation Tools" 
	toolTip:"Reaction Manager"
(
	reactionMgr.openEditor()
)

macroScript OpenAnimationLayers
	enabledIn:#("max")
	buttontext:"Animation Layers"
	category:"Animation Tools"
	internalCategory:"Animation Tools" 
	toolTip:"Animation Layers"
(
	animLayerManager.showAnimLayersManagerToolbar true	
)

macroScript ToggleLimits
	enabledIn:#("max", "viz")
	buttontext:"Toggle Limits"
	category:"Animation Tools"
	internalCategory:"Animation Tools" 
	toolTip:"Toggle Limits"
(
	Fn toggleAnimLimits anim &limitTab &toggleValue =
	(
		local ILimitControl
		if anim != undefined do
		(
			if (ILimitControl = getInterface anim #limits) != undefined do		
			(
				if toggleValue and anim.IsEnabled() do
				(
					toggleValue = false
				)
				append limitTab anim 
			)
			
			for i = 1 to anim.numsubs do
			(
				toggleAnimLimits (getSubAnim anim i) &limitTab &toggleValue
			) 
		)
	)

	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	On Execute Do
	(
		local limitTab = #()
		local toggleValue = true
		for s in selection do
		(
			toggleAnimLimits s &limitTab &toggleValue
		)
		for limit in limitTab do 
		(
			limit.SetEnabled toggleValue
		)
	)
)

macroScript TrajectoryToggle
enabledIn:#("max")
buttontext:"Trajectory Toggle"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Trajectory Toggle" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
	On Execute Do
	(
		if(maxOps.trajectoryMode == true) then
			maxOps.trajectoryMode = false
		else
			maxOps.trajectoryMode = true
	)
)


macroScript TrajectoryKeyModeToggle
enabledIn:#("max")
buttontext:"Trajectory Key Mode Toggle"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Trajectory Key Mode Toggle" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
		
	On Execute Do
	(
		if(maxOps.trajectoryKeySubMode == true) then
			maxOps.trajectoryKeySubMode = false
		else
			maxOps.trajectoryKeySubMode = true
	)
)

macroScript TrajectoryAddKeyModeToggle
enabledIn:#("max")
buttontext:"Trajectory Add Key Mode Toggle"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Trajectory Add Key Mode Toggle" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	
	On Execute Do
	(
		if(maxOps.trajectoryAddKeyMode == true) then
			maxOps.trajectoryAddKeyMode = false
		else
			maxOps.trajectoryAddKeyMode = true
	)
)

macroScript TrajectoryDeleteKey
enabledIn:#("max")
buttontext:"Trajectory Delete Key"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Trajectory Delete Key" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	
	On Execute Do
	(
		maxOps.deleteSelectedTrajectoryKey()

	)
)



-- END OF FILE
