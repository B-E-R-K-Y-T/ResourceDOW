/*
Macro Scripts File that exposes actions for the Create New shape option in the Create Shape panel
-- Author:   Michael Russo


	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


-- Macro Scripts for Create Panel
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/
macroScript StartNewShapeLock
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Create" 
            internalCategory:"Create" 
            tooltip:"Start New Shape Lock"
            ButtonText:"Start New Shape Lock" 
(
	On Execute Do	
	(
		Try
		(
			if maxOps.startNewShapeLock == true then 
			(
				maxOps.startNewShapeLock = false
			) else (
				maxOps.startNewShapeLock = true
			)
		)
		Catch() 
	)
        on isChecked return (maxOps.startNewShapeLock)
)

macroScript StartNewShape
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Create" 
            internalCategory:"Create" 
            tooltip:"Start New Shape"
            ButtonText:"Start New Shape" 
(
	on execute do (Try( maxOps.startNewShape() ) Catch() )
)

