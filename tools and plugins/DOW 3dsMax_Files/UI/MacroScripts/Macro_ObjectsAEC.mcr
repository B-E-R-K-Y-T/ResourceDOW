-- Macro_Scripts File
-- Purpose:  define action for each creatable AEC Primitive objects to hook up to the create main menu (or quads)

/*
Revision History

	24 Mai 2003: Pierre-felix Breton
		created for 3ds MAX 6

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



----------------------------------------------------------------------------------------------------
--Doors
macroScript PivotDoor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC"
internalCategory:"Objects AEC" 
tooltip:"Pivot Door" 
buttontext:"Pivot Door" 
icon:#("ObjectsAEC_Doors",1)
(
StartObjectCreation pivot 
)

macroScript BifoldDoor
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC"
internalCategory:"Objects AEC"
tooltip:"BiFold Door" 
buttontext:"BiFold Door" 
icon:#("ObjectsAEC_Doors",2)
(
StartObjectCreation BiFold
)

macroScript SlidingDoor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Sliding Door"
buttontext:"Sliding Door" 
icon:#("ObjectsAEC_Doors",3)
(
StartObjectCreation SlidingDoor
)


----------------------------------------------------------------------------------------------------
--Windows
macroScript AwningWindow 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Awning Window"
buttontext:"Awning Window"
icon:#("ObjectsAEC_Win",1)
(
StartObjectCreation Awning 
)

macroScript FixedWindow 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Fixed Window" 
buttontext:"Fixed Window" 
icon:#("ObjectsAEC_Win",3)
(
StartObjectCreation Fixed
)

macroScript ProjectedWindow
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Projected Window" 
buttontext:"Projected Window" 
icon:#("ObjectsAEC_Win",5)
(
StartObjectCreation projected
)

macroScript CasementWindow 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Casement Window" 
buttontext:"Casement Window" 
icon:#("ObjectsAEC_Win",2)
(
StartObjectCreation Casement
)

macroScript PivotedWindow 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Pivoted Window" 
buttontext:"Pivoted Window" 
icon:#("ObjectsAEC_Win",4)
(
StartObjectCreation Pivoted
)

macroScript SlidingWindow 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Sliding Window" 
buttontext:"Sliding Window" 
icon:#("ObjectsAEC_Win",6)
(
StartObjectCreation SlidingWindow 
)



----------------------------------------------------------------------------------------------------
--Foliage
macroScript Foliage 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Foliage" 
buttontext:"Foliage" 
icon:#("ObjectsAEC_misc",1)
(
cui.CommandPanelOpen = true
StartObjectCreation Foliage
)



----------------------------------------------------------------------------------------------------
--Railing
macroScript Railing 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Railing" 
buttontext:"Railing" 
icon:#("ObjectsAEC_misc",2)
(
StartObjectCreation Railing
)



----------------------------------------------------------------------------------------------------
--Stairs
macroScript SpiralStair 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Spiral Stair" 
buttontext:"Spiral Stair" 
icon:#("ObjectsAEC_Stairs",4)
(
StartObjectCreation Spiral_Stair
)

macroScript L_Stair 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"L-Type Stair" 
buttontext:"L-Type Stair" 
icon:#("ObjectsAEC_Stairs",1)
(
StartObjectCreation L_Type_Stair
)

macroScript StraightStair 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Straight Stair" 
buttontext:"Straight Stair" 
icon:#("ObjectsAEC_Stairs",3)
(
StartObjectCreation Straight_Stair
)

macroScript U_Stair 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC"
internalCategory:"Objects AEC"
tooltip:"U-Type Stair" 
buttontext:"U-Type Stair" 
icon:#("ObjectsAEC_Stairs",2)
(
StartObjectCreation U_Type_Stair
)



----------------------------------------------------------------------------------------------------
--Wall
macroScript Wall 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects AEC" 
internalCategory:"Objects AEC"
tooltip:"Wall"
buttontext:"Wall"
icon:#("ObjectsAEC_misc",3)
(
StartObjectCreation Wall
)


