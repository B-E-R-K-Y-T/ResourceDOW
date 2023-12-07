/*

Coordinate System Change MacroScript File
Created:  		Oct 16 2000


Author :   Fred Ruff
Version:  3ds max 4

Revision History:

	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


 
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/

MacroScript Coordsys_View
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"VIEW"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"View Coordinate System" 
(
Toolmode.coordsys #view
)

MacroScript Coordsys_Screen
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"SCREEN"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"Screen Coordinate System" 
(
Toolmode.coordsys #screen
)

MacroScript Coordsys_World
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"WORLD"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"World Coordinate System" 
(
Toolmode.coordsys #world
)

MacroScript Coordsys_Parent
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"PARENT"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"Parent Coordinate System" 
(
Toolmode.coordsys #parent
)

MacroScript Coordsys_Local
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"LOCAL"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"Local Coordinate System" 
(
Toolmode.coordsys #local
)

MacroScript Coordsys_Grid
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"GRID"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"Grid Coordinate System" 
(
Toolmode.coordsys #Grid
)

MacroScript Coordsys_Gimbal
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"GIMBAL"
Category:"Coordinate System" 
internalCategory:"Coordinate System" 
Tooltip:"Gimbal Coordinate System" 
(
Toolmode.coordsys #Gimbal
)

