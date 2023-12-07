/*

Convert To: MacroScript File


	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

 
This script enables all surface conversions through Macroscripts.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 

*/


MacroScript Collapse_Stack 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Collapse Stack" 
	Category:"Modifier Stack" 
	internalCategory:"Modifier Stack" 
	Tooltip:"Collapse Stack" 
	-- Needs Icon
	--Icon:#("Max_edit_modifiers",1)
(	
	
	On isEnabled return Try(Filters.Are_Modifiers_Applied())Catch()
	On isVisible return Try(Filters.Are_Modifiers_Applied())Catch() 
	On Execute Do	
	(
		Undo on 
		(
			if SubObjectLevel == undefined then Max Modify Mode
			For obj in selection do
			(
				Try(CollapseStack obj)Catch()
			)		
		) 
	
	)
	
)


MacroScript Modify_Mode 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Modify Mode" 
	Category:"Modifier Stack" 
	internalCategory:"Modifier Stack" 
	Tooltip:"Modify Mode" 
	-- Needs Icon
	--Icon:#("Max_edit_modifiers",1)
(	
	
	On isEnabled return (Try(getCommandPanelTaskMode() != #modify)Catch())
	On isVisible return (Try(getCommandPanelTaskMode() != #modify)Catch()) 
	On Execute Do	
	(
		Max Modify Mode 
	
	)
	
)
MacroScript Create_Mode 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Create Mode" 
	Category:"Modifier Stack" 
	internalCategory:"Modifier Stack" 
	Tooltip:"Create Mode" 
	-- Needs Icon
	--Icon:#("Max_edit_modifiers",1)
(	
	
	On isEnabled return (Try(getCommandPanelTaskMode() != #create)Catch())
	On isVisible return (Try(getCommandPanelTaskMode() != #create)Catch()) 
	On Execute Do	
	(
		Max Create Mode 
	
	)
	
)


MacroScript Convert_to_Mesh 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Convert to Editable Mesh" 
	Category:"Modifier Stack" 
	internalCategory:"Modifier Stack" 
	Tooltip:"Convert to Editable Mesh" 
	Icon:#("Max_edit_modifiers",1)
(	

	On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] Mesh)Catch())
	On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] Mesh)Catch()) 
	On Execute Do	
	(
		SuspendEditing()
		for obj in selection do
		(
			Try(ConvertToMesh obj)Catch() 
		)
		ResumeEditing()
		Max modify mode
	)
)

MacroScript Convert_to_Patch 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Convert to Editable Patch" 
	Category:"Modifier Stack"  
	internalCategory:"Modifier Stack"  
	Tooltip:"Convert to Editable Patch" 
	Icon:#("Max_edit_modifiers",2)
(	

	On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] Editable_Patch)Catch())
	On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] Editable_Patch)Catch()) 
	On Execute Do	
	(
		SuspendEditing()
		for obj in selection do
		(
			Try(ConvertTo obj Editable_Patch)Catch() 
		)
		ResumeEditing()
		Max modify mode
	)
)

MacroScript Convert_to_Spline 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Convert to Editable Spline" 
	Category:"Modifier Stack" 
	internalCategory:"Modifier Stack" 
	Tooltip:"Convert to Editable Spline" 
	Icon:#("Max_edit_modifiers",11)
(	

	On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] SplineShape)Catch())
	On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] SplineShape)Catch()) 
	On Execute Do	
	(
		SuspendEditing()
		for obj in selection do
		(
			Try(ConvertToSplineShape obj)Catch() 
		)
		ResumeEditing()
		Max modify mode
	)
)

MacroScript Convert_to_NURBS 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Convert to NURBS" 
	Category:"Modifier Stack"  
	internalCategory:"Modifier Stack"  
	Tooltip:"Convert to NURBS Surface" 
	Icon:#("Max_edit_modifiers",16)
(	

	On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] NURBSSurface)Catch())
	On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] NURBSSurface)Catch()) 
	On Execute Do	
	(
		SuspendEditing()
		Try
		(
			Obj = $
			ConvertToNURBSSurface $ 
			Select Obj
		)
		Catch() 
		ResumeEditing()
		Max modify mode
	)
)

MacroScript Convert_to_Poly
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Convert to Editable Poly" 
	Category:"Modifier Stack"  
	internalCategory:"Modifier Stack"  
	Tooltip:"Convert to Editable Polygon" 
	Icon:#("Max_edit_modifiers",16)
(	

	On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] Editable_Poly)Catch())
	On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] Editable_Poly)Catch()) 
	On Execute Do	
	(
		SuspendEditing()
		Try(
		for obj in selection do
		(
			Try(ConvertTo obj Editable_Poly)Catch() 
		)
		Max modify mode
		)
		Catch() 
		ResumeEditing()
	)
)

-- Added by NH as part of Grab bag feature.  Provide an Action item for Show End Result in modifier stack
MacroScript Show_End_Result_Toggle
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
            category:"Modifier Stack" 
            internalCategory:"Modifier Stack" 
            ButtonText:"Show End Result Toggle"
            tooltip:"Show End Result" 

(
     on execute do showEndResult = not showEndResult -- action to execute - toggle the setting
     on isEnabled return true -- greyed out if false
     on isChecked return showEndResult -- checked if true
     on isVisible return true -- visible if true
)

-- Added by NH as part of Maintain Custom Attributes on Stack Collapse feature.  Provide an Action item for togglng the Survive flag state
MacroScript Maintain_Custom_Attributes_On_StackCollapse_Toggle
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
            category:"Modifier Stack" 
            internalCategory:"Modifier Stack" 
            ButtonText:"Maintain Custom Attributes on Stack Collapse"
            tooltip:"Maintain Custom Attributes on Stack Collapse" 

(
     on execute do custattribCollapsemanager.surviveState = not custattribCollapsemanager.surviveState -- action to execute - toggle the setting
     on isEnabled return true -- greyed out if false
     on isChecked return custattribCollapsemanager.surviveState -- checked if true
     on isVisible return true -- visible if true
)

macroScript ProjectioModToggleNodeVisibility
enabledIn:#("max") 
	category:"Projection Modifier" 
	internalCategory:"Projection Modifier" 
	tooltip:"Geometry Selection Visibility Toggle"
	ButtonText:"Geometry Selection Visibility Toggle" 
(
	On Execute Do	
	(
		Try (
			if selection.Count > 0 do (
				pmod = FindPMod $
				if pmod != undefined do (
					pmodi = pmod.projectionModOps
					pmodi.setGeomSelNodesVisibility (not pmodi.getGeomSelNodesVisibility())
				)
			)
		)
		Catch()
	)

	on isEnabled do
	(
		selection.Count > 0
	)
)

macroScript ProjectioModDisplayToggleEnable
enabledIn:#("max") 
	category:"Projection Modifier" 
	internalCategory:"Projection Modifier" 
	tooltip:"Display Toggle Enable"
	ButtonText:"Display Toggle Enable" 
(
	On Execute Do	
	(
		Try (
			if selection.Count > 0 do (
				local pmod = FindPMod $
				if pmod != undefined do (
					pmod.displayToggleEnable = (not pmod.displayToggleEnable)
				)
			)
		)
		Catch()
	)

	on isEnabled do
	(
		selection.Count > 0
	)
)

macroScript ProjectioModDisplayToggleMode
enabledIn:#("max") 
	category:"Projection Modifier" 
	internalCategory:"Projection Modifier" 
	tooltip:"Display Toggle Mode"
	ButtonText:"Display Toggle Mode" 
(
	On Execute Do	
	(
		Try (
			if selection.Count > 0 do (
				local pmod = FindPMod $
				if pmod != undefined do (
					local pmodMode = pmod.displayToggleMode
					if (pmodMode==1) then
					     pmod.displayToggleMode = 2
					else pmod.displayToggleMode = 1
				)
			)
		)
		Catch()
	)

	on isEnabled do
	(
		selection.Count > 0
	)
)
