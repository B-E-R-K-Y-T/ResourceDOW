/*

-- Macro Scripts File
-- Macro Scripts for render properties and render presets

Revision History:

	30 Juin 2004, Pierre-Felix Breton
		bug fix:  motion blur don't fail anymore on multiple selection

	4 May 2004, Pierre-Felix Breton
		modified the quick render presets shortcuts to skip the environement and effects categories
		added icons

	29 march 2004, Pierre-Felix Breton
		added "quick render shortcuts" macros, for render presets
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

 	9 Juin 2003: Pierre-Felix Breton
 	added tests for "bylayer/byobject" flags to prevent "disconnections" from the layer system.
	
*/


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

--------------------------------------------------------------------------------------------
-- Quick render shortcuts macros 
--------------------------------------------------------------------------------------------

/*
Usage:

	Once on a toolbar, a user can Shift + Click, it will save the current render settings in a "slot"
	Click on the button loads the settings.
*/


macroScript RenderPresetSlotA
	category:"Render"
	internalCategory: "Render" 
	toolTip:"Render Preset Slot A (shift+click to save)" 
	ButtonText:"A"
	Icon:#("Render",11)

(

	on execute do
	(
		if (keyboard.shiftPressed) 
		then RenderPresets.Save 0 ((getdir #renderpresets) + "\\a.rps") #{1,4..64} --shift key saves the preset. Environment and Effects categories (2 and 3) are skipped on purpose
		else -- no key pressed
		(
			--load the preset
			if (doesFileExist ((getdir #renderpresets) + "\\a.rps") == true) do	renderpresets.LoadAll 0 ((getdir #renderpresets) + "\\a.rps")
		)
	)--end on execute
)


macroScript RenderPresetSlotB
	category:"Render"
	internalCategory: "Render" 
	toolTip:"Render Preset Slot B (shift+click to save)" 
	ButtonText:"B"
	Icon:#("Render",12)

(

	on execute do
	(
		if (keyboard.shiftPressed) 
		then RenderPresets.Save 0 ((getdir #renderpresets) + "\\b.rps") #{1,4..64} --shift key saves the preset. Environment and Effects categories (2 and 3) are skipped on purpose
		else -- no key pressed
		(
			--load the preset
			if (doesFileExist ((getdir #renderpresets) + "\\b.rps") == true) do	renderpresets.LoadAll 0 ((getdir #renderpresets) + "\\b.rps")
		)
	)--end on execute
)



macroScript RenderPresetSlotC
	category:"Render"
	internalCategory: "Render" 
	toolTip:"Render Preset Slot C (shift+click to save)" 
	ButtonText:"C"
	Icon:#("Render",13)
(

	on execute do
	(
		if (keyboard.shiftPressed) 
		then RenderPresets.Save 0 ((getdir #renderpresets) + "\\c.rps") #{1,4..64} --shift key saves the preset. Environment and Effects categories (2 and 3) are skipped on purpose
		else -- no key pressed
		(
			--load the preset
			if (doesFileExist ((getdir #renderpresets) + "\\c.rps") == true) do	renderpresets.LoadAll 0 ((getdir #renderpresets) + "\\c.rps")
		)
	)--end on execute
)



--------------------------------------------------------------------------------------------
-- Object properties macros 
--------------------------------------------------------------------------------------------
MacroScript InheritVis
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch

            ButtonText:"Inherit Visibility"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Inherit Visibility" 
(

	On IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do Try ($.inheritvisibility) Catch ()
	On Execute Do Try ($.inheritvisibility = not $.inheritvisibility)Catch ()
)

MacroScript Renderable
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Renderable"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Renderable" 
(

	--on altExecute type do actionMan.executeAction 0 "40022" -- loc_notes: DO NOT LOCALIZE THIS
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return ((superclassof $ == GeometryClass) or (superclassof $ == Light)) -- pfb; 9 juin 2003
	on ischecked Do	Try ($.renderable) Catch ()
	On Execute Do Try ($.renderable = not $.renderable)	Catch ()
)

MacroScript CastShadows
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Cast Shadows"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Cast Shadows" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.CastShadows)	Catch ()
	On Execute Do Try ($.CastShadows= not $.CastShadows)Catch ()
)
MacroScript ReceiveShadows
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Receive Shadows"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Receive Shadows" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.ReceiveShadows) Catch ()
	On Execute Do Try ($.ReceiveShadows= not $.ReceiveShadows)Catch ()
)

MacroScript VisibleToCamera
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Visible to Camera"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Visible to Camera" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.primaryVisibility)Catch ()
	
	On Execute Do Try ($.primaryVisibility= not $.primaryVisibility)Catch ()
)

MacroScript VisibleToReflection
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Visible to Reflection"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Visible to Reflection" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.secondaryVisibility)	Catch ()
	On Execute Do Try ($.secondaryVisibility= not $.secondaryVisibility)Catch ()
)

MacroScript ApplyAtmospherics
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Apply Atmospherics"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Apply Atmospherics" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.applyAtmospherics)Catch ()
	
	On Execute Do Try ($.applyAtmospherics= not $.applyAtmospherics)Catch ()
)
MacroScript RenderOccluded
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Render Occluded Objects"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Render Occluded" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.renderbylayer) -- pfb; 9 juin 2003
	On IsVisible Return superclassof $ == GeometryClass
	on ischecked Do	Try ($.renderOccluded)Catch ()
	On Execute Do Try ($.renderOccluded= not $.renderOccluded)Catch ()
)
MacroScript MotionBlurToggle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Motion Blur"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"On/Off Motion Blur" 
(
	on IsEnabled Return if (selection.count != 1) then true else (not $.motionbylayer) -- pfb; 9 juin 2003
	On IsVisible Return (selection.count == 1) --pfb 23 feb 2004: relaxed the mblur properties to work on all objects
	on ischecked Do	Try ($.motionBlurOn)Catch ()
	On Execute Do Try ($.motionBlurOn= not $.motionBlurOn)Catch ()
)
MacroScript RenderSelected
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Render Selected"
            category:"Render"
            internalCategory:"Render"
            Tooltip:"Render Selected" 
(
	On Execute Do Try (render rendertype:#selection)Catch ()
)
