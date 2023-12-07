macroScript ToggleTrajectory
buttonText:"ToggleTrajectory"
category:"Custom Tools" 
tooltip:"Quick Trajectory Toggle"
icon:#("TrackViewKeyTangents",14)
(

on isEnabled return selection.count == 1

on execute do
	(
	sel = selection[1]
	if getTrajectoryOn sel then 
		setTrajectoryOn sel false
	else setTrajectoryOn sel true
	)
)