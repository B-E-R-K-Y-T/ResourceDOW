-------------------------------------------------------------------------------
-- Macro_WalkThrough.mcr
--
-- History:
--  06.26.02 - Michael Russo
--
-- Copyright ©2004, Discreet
-------------------------------------------------------------------------------



macroScript WalkThroughToggle 
	buttonText:"WalkThrough" 
	category:"Views"
	internalCategory:"Views" 
	tooltip:"WalkThrough View Mode" 
	icon:#("ViewControls", 47)
(
	on execute do
	(
		walkThroughOps.start()
	)
	On isChecked return (walkThroughOps.IsActive)
)
