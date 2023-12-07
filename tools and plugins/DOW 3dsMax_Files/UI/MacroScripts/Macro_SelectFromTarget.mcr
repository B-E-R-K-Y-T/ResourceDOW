/*

Macro Scripts File
Created:   4 Juin 2003: 3dsmax 6
Author:   PF Breton

Macro Scripts for Targets allowing to select the 'parent' camera, light or luminaires

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



-- general usage macroscript for any targets
MacroScript SelectFromTarget
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Select Object From Target"
category:"Selection" 
internalCategory:"Selection" 
Tooltip:"Select Object From Target" 
(
	On IsVisible Return ((Filters.Is_Target $) and not (Filters.Is_Camera $.lookat) and not (Filters.Is_Light $.lookat))
	On Execute Do Try(select $.lookat) Catch()
)


-- specific to cameras
MacroScript SelectCameraFromTarget
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Select Camera"
category:"Selection" 
internalCategory:"Selection" 
Tooltip:"Select Camera" 
(
	On IsVisible Return ((Filters.Is_Target $) and (Filters.Is_Camera $.lookat))
	On Execute Do Try(select $.lookat) Catch()
)

-- specific to lights
MacroScript SelectCameraFromLight
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Select Light"
category:"Selection" 
internalCategory:"Selection" 
Tooltip:"Select Light" 
(
	On IsVisible Return ((Filters.Is_Target $) and (Filters.Is_Light $.lookat))
	On Execute Do Try(select $.lookat) Catch()
)
