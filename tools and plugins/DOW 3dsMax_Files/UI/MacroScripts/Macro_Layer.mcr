/*
Macro_scripts for Layers
Created: Mark Young
Version: 3dsmax 6



Revision History:

	9 Juin 2003; Pierre-Felix Breton
		checked in max

	13 juin 2003; Pierre-Felix Breton
		optimizations suggested by Larry Minton
	
	17 Juin 2003; Pierre-Felix breton
		bug fixes and localization notes
		
	5 aout 2003; Pierre-Felix Breton
		bug fixes
		
	13 aout 2003; Pierre-Felix Breton
		bug fixes

	19 aout 2003; Pierre-Felix Breton
		bug fixes

	11 sept 2003; Mark Young
		added LayerPropertiesByLayer macro
		
	6 fevrier 2003; Pierre-Felix Breton
		added the following macros:
		Isolate SeleDction`s Layer:  isolates the layer of the selected objecs 
		Freeze Selection`s Layer: freeze the layers of the selected objects 
		Hide Selection`s Layer : hide the layers of the selected objects

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


        19 dec 2003, Pierre-Felix Breton
                added VIZ Render scripts
*/



--Add selected Objects to Current Layer

macroScript LayerAdd
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Layers"
	internalCategory: "Layers" --LOC_NOTES: do not localize this
	toolTip:"Add Selection to Current Layer" --LOC_NOTES: localize this
	ButtonText:"Add to Layer" --LOC_NOTES: localize this
	Icon:#("LayerToolbar",2) --LOC_NOTES: do not localize this

(
	-- cost/benefit too high?
	on isEnabled do return (selection.count > 0) --13 juin 2003; Pierre-Felix Breton
	on execute do
	(
		local vLayer = LayerManager.current
		local vObjects = selection as array
		local vItem
		for vItem in vObjects do vLayer.addNode vItem
	)
)

-- eof


-- Macro_LayerCreate.mcr
-- 1) Pops up dialog to get new Layer name from user (and option for adding selection)
-- 2) Creates new Layer
-- 3) Names new Layer based upon #1
-- 4) Sets new Layer to be "Current Layer"
-- 5) Adds selected Objects to new Layer unless user opts out in #1

macroScript LayerCreate
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Layers" --LOC_NOTES: localize this
	internalCategory: "Layers" --LOC_NOTES: do not localize this
	toolTip:"Create New Layer"  --LOC_NOTES: localize this
	buttonText:"Create New Layer"   --LOC_NOTES: localize this
	icon:#("LayerToolbar",1)    --LOC_NOTES: do not localize this
	(
	-- set parameters in dialog creation method
	local vNameLayer

	-- formats a number into a 2 digits number if lower than 10 and returns a string	
	fn FormatIntToString val = 
	(
		local strVal
		strVal = (val as string)
		if val < 10 do strVal = "0" + (val as string) --LOC_NOTES: do not localize this
		strVal
	)


	-- get automatic name ("Layer #") for new layer - starting point for user input
     function fNewLayerName =

     (

         local vIndex = 1 --LayerManager.count

         local vName = ""

		 while (vName = "Layer" + (FormatIntToString  (vIndex)); ((LayerManager.getLayerFromName vName) != undefined)) do  --LOC_NOTES: localize this

              vIndex = vIndex + 1

         vName

     )--end function


    -- create layer if name is unused
	-- assign name from "vNameLayer" - delete layer if this fails
	-- set new Layer as current
	-- add selected objects if "flagAddSelection" is true
	-- destroy dialog if naming succeeded
	function fCreateLayer flagAddSelection vNameLayer =
	(
		with undo label:"Create Layer" on --LOC_NOTES: localize this
		(
			local vLayer 
			vlayer = LayerManager.newLayer()
			--checks for leading spaces:
			--compares the trimmed string with original string
			--if they are not the same, it means that spaces has been trimmed and the 
			--string do contains leading space, tabs or else, so the layer name is invlid
			vNameLayer = trimleft vNameLayer 
			vNameLayer = trimright vNameLayer 

			vLayer.setName vNameLayer
			vLayer.current = true
			if (flagAddSelection) do 
				(
					local vItem
					for vItem in (selection as array) do vLayer.addNode vItem
					vItem = undefined
				)--end if flagaddselection
		)		
	)--end function
	
	--this function determines if a string contains leading spaces
	--returns true or false based on the answer
	function isLayerNameValid strName =
	(
		strName = trimleft strName 
		strName = trimright strName 
		--assumes that the layer name is valid, flag to false if not
		local boolIsLayerNameValid = true
		
		--checks for an empty layer name:
		if (strName == "") do boolIsLayerNameValid = false
		
		--checks for existing name in the layers list:
		if (layermanager.getlayerfromname strName) != undefined do boolIsLayerNameValid = false
		--returns the flag
		boolIsLayerNameValid
	
	)

	-- dialog presented when nothing is selected
	-- gets name input and calls "fCreateLayer"
	-- calls "fCreateLayer" or destroys itself if cancelled
	rollout vRollout "Create New Layer" width:240 height:80 --LOC_NOTES: localize this
	(
		edittext vEdittext "Name:" text:vNameLayer pos:[25,15] width:195 --LOC_NOTES: localize this
		button vButtonOK "OK" pos:[60,65] width:65 --LOC_NOTES: localize this
		button vButtonCancel "Cancel" pos:[155,65] width:65 --LOC_NOTES: localize this
		checkbox vCheckbox "Move Selection to New Layer" checked:true pos:[60,40] --LOC_NOTES: localize this

		on vEdittext changed arg do 
		(
			vNameLayer = arg
			
			if (isLayerNameValid vNameLayer)  --prevent layers with empty names or leading spaces from being created: pfbreton 13 aout 2003
			then vButtonOK.enabled = true
			else vButtonOK.enabled = false
		)
		
		
		-- removes the ability to hit enter in the text field to prevent the unexpected exit of the dialog when 
		-- the control losts focus (bug #
		on vEdittext entered arg do 
		(
			setfocus vButtonOK 
			/*
			vNameLayer = arg
			if (isLayerNameValid vNameLayer) --prevent layers with empty names or leading spaces from being created: pfbreton 13 aout 2003
			then 
			(
				fCreateLayer vCheckbox.checked vNameLayer
				destroyDialog vRollout 
			)
			else ()-- do nothing if the layer name is not valid 
			*/
			
		)--end vEdittext entered arg
		
		on vButtonOK pressed do 
		(
			vNameLayer = vEdittext.text
			fCreateLayer vCheckbox.checked vNameLayer
			destroyDialog vRollout 
		)
		on vButtonCancel pressed do 
		(
			destroyDialog vRollout
		)
		on vRollout open do 
		(	
			if (selection.count == 0) do vCheckbox.checked = false
			setfocus vEdittext
		)
		
	)--end rollout


    -- get initial [automatic] name string
	-- read selection
	-- launch appropriate dialog
	on execute do
	(
		vNameLayer = fNewLayerName()
		createDialog vRollout width:245 height:95		
	)--end execute
)

-- eof



-- Macro_LayerSelect.mcr - Select Objects in Current Layer

-- known issue: Does not work when Ctrl key is pressed ...

macroScript LayerSelect
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Layers" --LOC_NOTES: localize this
	internalCategory: "Layers" --LOC_NOTES: do not localize this
	toolTip:"Select Objects in Current Layer" --LOC_NOTES: localize this
	ButtonText:"Select Layer" --LOC_NOTES: localize this
	Icon:#("LayerToolbar",3) --LOC_NOTES: do not localize this
(
	on execute do
	(
		local vObjects
		LayerManager.current.nodes &vObjects
		if (keyboard.shiftPressed) then selectMore vObjects
		else select vObjects
		vObjects = undefined
	)
)

-- eof

-- Macro_LayerSet.mcr - Set Current Layer to that containing Selection

macroScript LayerSet
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Layers" --LOC_NOTES: localize this
	internalCategory: "Layers" --LOC_NOTES: do not localize this
	toolTip:"Set Current Layer to Selection's Layer" --LOC_NOTES: localize this
	ButtonText:"Set Layer" --LOC_NOTES: localize this
	Icon:#("LayerToolbar",4) --LOC_NOTES: do not localize this
(
	function fGetLayerContainingSelection = --13 juin 2003; Pierre-Felix Breton
	(
		local vLayer = undefined
		vLayer = selection[1].INodeLayerProperties.layer --using selection[1] is faster than copying the selection in an array
	)--end function

	-- cost/benefit too high?
	on isEnabled return (selection.count == 1) --13 juin 2003; Pierre-Felix Breton
	on execute do
	(
		local vLayer = fGetLayerContainingSelection()
		if (vLayer != undefined) do vLayer.current = true
		vLayer = undefined
	)
)

-- eof


-----------------------------------------------
macroScript LayerManager 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
category:"Layers"  --LOC_NOTES:localize this
	internalCategory: "Layers" --LOC_NOTES: do not localize this
tooltip:"Layer Manager" --LOC_NOTES:localize this
buttontext:"Layer Manager"  --LOC_NOTES:localize this
Icon:#("LayerToolbar",5)--LOC_NOTES: do not localize this
(
	on execute do
	(
		try layermanager.editlayerbyname ""	catch(messagebox "Error running layer manager."	) --LOC_NOTES:localize this
	)-- on execute
	on closeDialogs do
	(
		try layermanager.closeDialog() catch(messagebox "Error running layer manager.") --LOC_NOTES:localize this
	)
	on isChecked do
	(
		try layermanager.isDialogOpen() catch(messagebox "Error running layer manager.") --LOC_NOTES:localize this
	)
)--layer_manager


-- added following macro 11 sept 2003; mjyoung
---------------------
macroScript LayerPropertiesByLayer 
enabledIn:#("max", "viz") 
category:"Layers" --LOC_NOTES:localize this
internalCategory: "Layers" --LOC_NOTES:do not localize this
tooltip:"By Layer Properties for Selected Objects" --LOC_NOTES:localize this
buttontext:"By Layer" --LOC_NOTES:localize this
Icon:#("LayerToolbar",6) --LOC_NOTES:do not localize this
(
	local hit_set, hit_item, n, i

	on isEnabled return (selection.count > 0)

	on execute do (
		hit_set = $selection
		if (hit_set != undefined) do 
		(
			n = hit_set.count
			for i=1 to n do (
				try (
					hit_item = hit_set[i]
					hit_item.displayByLayer= true
					hit_item.renderByLayer= true
					hit_item.motionByLayer= true
					hit_item.colorByLayer= true
					hit_item.globalIlluminationByLayer = true
				)
				catch (
				)
			)
		)
	)-- on execute
) -- LayerPropertiesByLayer



--pfb: 2003.12.19 added vizr macros
macroScript all_layers_on 
enabledIn:#("vizr") 
category:"Layers" 
internalCategory: "Layers"
tooltip:"Turn All Layers On"
buttontext:"All Layers On" 
Icon:#("ACAD_LayerTools",10) 
--SilentErrors:(Debug == undefined or Debug != True)
(
	-- VARIABLE DECLARATIONS
	 local layer
	 
	-- FUNCTION DECLARATIONS
	-- no local functions

	on execute do
	(
		count = layermanager.count - 1
		for i = 0 to count do
		(
			layer = layermanager.getlayer i
			layer.on = true
		)
	
		-- completeredraw()
		g_isoHidden = undefined
	)-- on execute
)--all_layers_on

macroScript layer_lock 
enabledIn:#("vizr") 
category:"Layers" 
internalCategory: "Layers"
tooltip:"Lock Object's Layer"
buttontext:"Layer Lock" 
Icon:#("ACAD_LayerTools",11) 
--SilentErrors:(Debug == undefined or Debug != True)
(
	on isenabled return (selection.count >0)
	on execute do
	(
		for obj in selection do	obj.layer.lock = true

	)-- on execute

)--layer_lock

macroScript layer_off 
enabledIn:#("vizr") 
category:"Layers" 
internalCategory: "Layers"
tooltip:"Turn Object's Layer Off"
buttontext:"Layer Off" 
Icon:#("ACAD_LayerTools",9) 
--SilentErrors:(Debug == undefined or Debug != True)
(
	on isenabled return (selection.count >0)
	on execute do
	(
		for obj in selection do	obj.layer.on = false

		g_isoHidden = undefined
	)-- on execute
	
)--layer_off

macroScript layer_unlock 
enabledIn:#("vizr") 
category:"Layers" 
internalCategory: "Layers"
tooltip:"Unlock All Layers"
buttontext:"All Layers Unlock" 
Icon:#("ACAD_LayerTools",12) 
--SilentErrors:(Debug == undefined or Debug != True)
/*
This can't possibly work since you can't pick objects which are frozen.
we've updated pickObject ot take a new keyword pickFrozen
*/
(
	-- VARIABLE DECLARATIONS
    local layer

	on execute do
	(
		count = layermanager.count - 1
		for i = 0 to count do
		(
			layer = layermanager.getlayer i
			layer.lock = false
		)
	
	-- completeredraw()
	)-- on execute

)--all layers unlock


-- //////////////////////////////////////////////////////////////////////////////
--  New layer tools for Design VIZ users - 6 feb 2003
--  Isolate Selection`s Layer:  isolates the layer of the selected objecs 
--  Freeze Selection`s Layer: freeze the layers of the selected objects 
--  Hide Selection`s Layer : hide the layers of the selected objects

macroScript LayerIsolate
enabledIn:#("viz", "max")
category:"Layers" --LOC_NOTES: localize this
internalCategory: "Layers" --LOC_NOTES: do not localize this
toolTip:"Isolate Selection's Layer" --LOC_NOTES: localize this
ButtonText:"Isolate Selection's Layer" --LOC_NOTES: localize this
--Icon:#("LayerToolbar",3) --LOC_NOTES: do not localize this
	(
	on isEnabled return (selection.count > 0)

	on execute do
	(
	
		-- variables
		local count
		local i
		
		-- disable scene redraw to prevent a bunch of flashing.
		with redraw off
		(
		
			--build an array containing the layers associated with the current selection
			local vObjects = selection as array
			
			
			-- turn off all the layers as an initial step
			count = layermanager.count - 1
			for i = 0 to count do
			(
				layer = layermanager.getlayer i
				layer.on = false
			)--end for
	
	
			--turn on all layers associated with the selection
			for i in vObjects do
			(
				i.layer.on = true		
			)--end for
			
		)--end with redraw off
		
	)-- end on execute
)--end macro

macroScript LayerFreeze
enabledIn:#("viz", "max")
category:"Layers" --LOC_NOTES: localize this
internalCategory: "Layers" --LOC_NOTES: do not localize this
toolTip:"Freeze Selection's Layer" --LOC_NOTES: localize this
ButtonText:"Freeze Selection's Layer" --LOC_NOTES: localize this
--Icon:#("LayerToolbar",3) --LOC_NOTES: do not localize this
(
	on isEnabled return (selection.count > 0)
	on execute do
	(
		-- variables
		local i
		
		-- disable scene redraw to prevent a bunch of flashing.
		with redraw off
		(		
			local vObjects = selection as array
			for i in vObjects do
			(
				i.layer.lock = true		
			)--end for
			
		)--end with redraw off	
	)-- end on execute
)--end macro

macroScript LayerHide
enabledIn:#("viz", "max")
category:"Layers" --LOC_NOTES: localize this
internalCategory: "Layers" --LOC_NOTES: do not localize this
toolTip:"Hide Selection's Layer" --LOC_NOTES: localize this
ButtonText:"Hide Selection's Layer" --LOC_NOTES: localize this
--Icon:#("LayerToolbar",3) --LOC_NOTES: do not localize this
(
	on isEnabled return (selection.count > 0)
	on execute do
	(
		-- variables
		local i
		
		-- disable scene redraw to prevent a bunch of flashing.
		with redraw off
		(		
			local vObjects = selection as array
			for i in vObjects do
			(
				i.layer.on = false
			)--end for
			
		)--end with redraw off	
	)-- end on execute
)--end macro


-- //////////////////////////////////////////////////////////////////////////////

-- end of file