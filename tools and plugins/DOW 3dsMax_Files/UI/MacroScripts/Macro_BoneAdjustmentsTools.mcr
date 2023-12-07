/*
Bone Adjustment Tools MacroScript File
Version:  3ds max 6

Created:       November  27 2001

Revision History:

	Apr 20 2004, Mike Tsoupko-Sitnikov
		added the preview capability to the "Mirror"tool
	
	Feb 6 2004, Mike Tsoupko-Sitnikov
		added "Mirror" tool for bone objects
	
	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products

Authors:	Ambarish Goswami 
			(except for the code corresponding to the five buttons
			in "Bone Tools" groupbox in "Bone Editing Tools" rollout:
			Reassign Root, Remove Bone, Connect Bones, Create End, and
			Delete Bone. Those were written by: Herman Saksono. Ambarish 
			fixed a few exception bugs in this code)

		Herman Saksono wishes to thank Arkhadi Pustaka for his contibution
			 in developing the Reassign Root tool

		Mike Tsoupko-Sitnikov - refactoring, additions, fixes		



 Bone Adjustment Tools
 This script improves workflow with bones. 
 The script completely replaces the functionalities of the following 
 		three existing dialogs:
	1 : Character Tools > Bone Options
	2 : Object Properties > General > Bone (lower right corner)
	3 : Modify Panel > Bone Parameters

 It adds several functionalities:

  Bone Editing Tools
	Bone Pivot Position Groupbox:
			Bone Edit Mode: Does the same thing as "Don't Affect Children"
		Bone Tools Groupbox (not written by AmbarishG, except bugfixes):
			Reassign Root: 
			Remove Bone: 
			Connect Bones:
			Create End:
			Delete Bone:
			Create Bone:
		Bone Coloring groupbox:
			You can now specify the color of individual bones
			Gradient Coloring (functionality available only if multiple 
					bones are selected): 
				You can automatically progressively color bones from a start color 
				for the first bone to an end color for the last bone

		
  Fin Adjustment Tools:
		Absolute/Relative Mode (for the Bone Geometry Spinners)
			In Relative mode, the spinners are set to zero and
			the spinner values are added to the corresponding
			Bone Geometry and Fins parameters

		Copy/Paste Mode
			You can now copy all the Bone Geometry and Fins parameters
			from one bone and paste them to one or many (selected) bones
			Copy button is disabled in the relative mode

  Object Properties:
		All usual properties are available:
			Bone On, Freeze Length, Auto-Align checkboxes
			Stretch options: None, Scale, Squash
			Axis options: X, Y, Z, Flip
			Realign and Reset Stretch buttons

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- Additional Modifications:
--

macroScript BoneAdjustmentTools
enabledIn:#("max") --pfb: 2003.12.11 added product switch
ButtonText:"Bone Tools..."
category:"Animation Tools"
internalCategory:"Animation Tools"
Tooltip:"Bone Tools..." 
(

global BoneAdjustmentsFloater_FinToolsRollout
global BoneAdjustmentsFloater_updateTRFlag
global BoneAdjustmentsFloater_updateOPRFlag
global BoneAdjustmentsFloater

local ObjectPropsRollout, ToolsRollout
local updateFTRFlag
local mirrorAxisValue = 1, mirrorFlipValue = 1, mirrorOffsetValue = 0
local bafSize  = [ 225, 518], bafPos = [40, 139]
local toolsOpen = true, finsOpen = false, objOpen = false, checked = false
local iniFile = "$plugcfg/BoneAdjustmentTools.ini" 

function GetINIConfigData filename section key default =
(
	local res = getINISetting filename section key
	if res == "" then default
	else readValue (stringStream res)
) -- end - function GetINIConfigData

function SetINIConfigData filename section key value =
(
	setINISetting filename section key (value as string)
) -- end - function SetINIConfigData

function isMacroRecorderEnabled = 
(
  (getINISetting (GetMAXIniFile()) "MAXScript" "EnableMacroRecorder") == "1" --pfb;19 aug 2003 removed hardcoded access to 3dsmax.ini
)

-------------------------------------------------------------------------
-- Below ------ Third Rollout -- Object Properties ----------------------
rollout ObjectPropsRollout "Object Properties" width:208 height:158
(
	--------------- variables ------------------------------------
	local UpdateOPRUI  	-- declare function as local
	--local BoneAdjustmentsFloater_updateOPRFlag	-- declare flag. Set to true on selection set change, reset in UpdateBoneUI
	
	-------------- Bone Properties Groupbox elements -------------------------
	----------------------------------------------------------------------
	GroupBox grp1 "Bone Properties" pos:[6,4] width:196 height:211
	checkbox BoneOn_chk "Bone On" pos:[12,24] width:100 height:16
	checkbox Freeze_chk "Freeze Length" pos:[12,48] width:100 height:16
	checkbox AutoAlign_chk "Auto-Align" pos:[12,72] width:100 height:16
	
	button Realign_btn "Realign" pos:[113,24] width:72 height:20
	button ResetStretch_btn "Reset Stretch" pos:[113,48] width:72 height:20
	button ResetScale_btn "Reset Scale" pos:[113,72] width:72 height:20
	
	checkbox CorrNegStretch_chk "Correct Negative Stretch" pos:[12,96] width:170 height:16
	
	label MultiLabel "Multiple Bone Selected" pos:[12,116] width:160 height:16
	label StretchFactor "Stretch Factor: undefined" pos:[12,133] width:160 height:16
	
	radiobuttons Stretch_rdo "Stretch" pos:[12,150] width:100 height:36 labels:#("None", "Scale", "Squash") columns:1
	radiobuttons Axis_rdo "Axis" pos:[110,150] width:100 height:36 labels:#("X", "Y", "Z") columns:1
	checkbox BoneFlip_chk "Flip" pos:[150,164] width:50 height:16

	------- function to correct for the negative stretch -------
	fn correctNegativeStretch bone ask =
	(
		local axisIndex, ooscale
        case bone.boneAxis of
		(
			#X: axisIndex = 1
			#Y: axisIndex = 2
			#Z: axisIndex = 3
		)
		
		ooscale = bone.objectOffsetScale
		if (ooscale[axisIndex] < 0) and ((not ask) or (queryBox "Correct negative stretch?" title:bone.Name)) do
		(
			ooscale[axisIndex] = -ooscale[axisIndex]
			axisIndex = axisIndex+2
			if axisIndex > 3 do axisIndex = axisIndex-3
			ooscale[axisIndex] = -ooscale[axisIndex]
			bone.objectOffsetScale = ooscale
		)
	)

	------- function to reset scale of selected bones ------
	fn ResetScaleOfSelectedBones ask =
	(
		-- define the bone structure that contains the bone and its level in the hierarchy
		struct BoneLevel (index, level)
		local bones     = #()

		-- fill the array of bone structures. intialize the hierarchy level with 0
		for i = 1 to selection.count do
		(
			bones[i] = BoneLevel i 0		
		)

		-- calculate the hierarchy level for each bone in bones array. the hierarchy level
		-- is the number of ancestors between the current bone and the root node
		for i = 1 to bones.count do
		(
		  local node = selection[bones[i].index]
		  local n    = 0
		  do
		  (
			n    = n + 1
			node = node.parent
		  ) while (node != undefined)
		  bones[i].level = n
		)

		-- sort the bones array by the hierarchy level
		qsort bones (fn myLevel v1 v2 = (v1.level - v2.level))

		-- reset scale for all bones in the bones array
		--print "***resetting***"
		for i = 1 to bones.count do
		(
		    --print "----"
			--print bones[i]
			--print selection[bones[i].index]
			ResetScale selection[bones[i].index]
			if ask do correctNegativeStretch selection[bones[i].index] false
		)

	)

	on BoneOn_chk changed state  do
	(
		undo "Bone On" on 
		( 
			selection.boneEnable = state
			Freeze_chk.enabled = state		
			AutoAlign_chk.enabled = state
			Stretch_rdo.enabled = state
			Axis_rdo.enabled = state
			ResetStretch_btn.enabled = state
			BoneFlip_chk.enabled = state
			Realign_btn.enabled = state 
			ResetScale_btn.enabled = state
			CorrNegStretch_chk.enabled = state
		)
		if isMacroRecorderEnabled() do format "$.boneEnable=%\n" state to:MacroRecorder
	)
	on Freeze_chk changed state do
	(
		undo "Freeze Length" on ( 
			selection.boneFreezeLength = state
		)
		if isMacroRecorderEnabled() do format "$.boneFreezeLength=%\n" state to:MacroRecorder
	)
	on AutoAlign_chk changed state do
	(
		undo "Auto-Align" on ( 
			selection.boneAutoAlign = state
		)
		if isMacroRecorderEnabled() do format "$.boneAutoAlign=%\n" state to:MacroRecorder
	)

	on Realign_btn pressed do
	(
		undo "Realign" on 
		( 
			for i in selection do
			(
				i.realignBoneToChild()
			)
		)
	)

	on ResetStretch_btn pressed do
	(
	
		undo "Reset Stretch" on 
		( 
			if CorrNegStretch_chk.state then for b in selection do correctNegativeStretch b false
			for b in selection do b.resetBoneStretch()
		)

	)
	
	on ResetScale_btn pressed do
	(
		undo "Reset Scale" on 
		( 
			ResetScaleOfSelectedBones CorrNegStretch_chk.state
		)
	)
	
	
	on Stretch_rdo changed state do
	(
	
		undo "Stretch" on 
		( 
			local val = #None
			case Stretch_rdo.state of 
			(
				1: val = #None
				2: val = #Scale
				3: val = #Squash
			)
			selection.boneScaleType = val
			if isMacroRecorderEnabled() do format "$.boneScaleType=%\n" val to:MacroRecorder
		)
	)
	
	on Axis_rdo changed state do
	(
		undo "Axis" on 
		( 
			local val = #X
			case Axis_rdo.state of 
			(
				1: val = #X
				2: val = #Y
				3: val = #Z
			)
			selection.boneAxis = val
			if isMacroRecorderEnabled() do format "$.boneAxis=%\n" val to:MacroRecorder

		)
	)
	
	on BoneFlip_chk changed state do
	(
		undo "Bone Flip On/Off" on ( 
			selection.boneAxisFlip = state
			if isMacroRecorderEnabled() do format "$.boneAxisFlip=%\n" state to:MacroRecorder
		)
	)

	
	------- function to update the 3 chkbxs in Bone Properties grpbx-------
	fn updateChkBox chkB paramOne =
	(
		local ChkBStateBoneOne = getProperty selection[1] paramOne  	
		local FoundDifferent = false	
		for i = 2 to selection.count do
		(
			if ChkBStateBoneOne != (getProperty selection[i] paramOne) do 
			(
				FoundDifferent = true
				exit
			)
		)
		
		if FoundDifferent then
		(
			chkB.triState = 2
		)
		else 
		(
			chkB.state = ChkBStateBoneOne
		)	
	)

	fn GetRadioButton paramOne =
	(
		local result = #nondet
		local RdoStateOne = getProperty selection[1] paramOne  	
		local FoundDifferent = false	
		for i = 2 to selection.count where FoundDifferent == false do
		(
			if RdoStateOne != (getProperty selection[i] paramOne) do 
			(
				FoundDifferent = true -- This will now exit the for loop
				-- exit
			)
		)
		
		if FoundDifferent then
		(
			result = #nondet
		)
		else 
		(
			result = RdoStateOne
		)	
		result
	)

	fn UpdateStretch_rdo x =
	(
		case x of
		(
			#nondet : Stretch_rdo.state = 0
			#None : Stretch_rdo.state = 1
			#Scale : Stretch_rdo.state = 2
			#Squash : Stretch_rdo.state = 3
		)
	)
	
	fn UpdateAxis_rdo x =
	(
		case x of
		(
			#nondet : Axis_rdo.state = 0
			#X : Axis_rdo.state = 1
			#Y : Axis_rdo.state = 2
			#Z : Axis_rdo.state = 3
		)
	)

	fn EnableBoneProperties x =
	(
		Freeze_chk.enabled 		= x
		AutoAlign_chk.enabled 	= x
		Realign_btn.enabled		= x
		ResetStretch_btn.enabled 		= x
		ResetScale_btn.enabled 	= x
		Stretch_rdo.enabled 	= x
		Axis_rdo.enabled 		= x
		BoneFlip_chk.enabled	= x
		CorrNegStretch_chk.enabled	= x
	)
	
	fn GetStretchFactor bone =
	(
		local axisIndex, tm, p
        case bone.boneAxis of
		(
			#X: axisIndex = 1
			#Y: axisIndex = 2
			#Z: axisIndex = 3
		)
		tm = bone.stretchTM
		p = [0,0,0]	
		tm[4] = p
		p[axisIndex] = 1	
		p = p * tm
		p[axisIndex]
	)
	

	fn UpdateOPRUI  =
	(
		if BoneAdjustmentsFloater_updateOPRFlag == true do -- explicitly test against true in case we are called before updateFlag is initialized
		(
			BoneAdjustmentsFloater_updateOPRFlag = false
			case selection.count of
			(
				0 : (
						MultiLabel.text = selection.count as string + " bones Selected"
						StretchFactor.text = "Stretch Factor: undefined"
						BoneOn_chk.enabled 		= false
						EnableBoneProperties	false

						BoneOn_chk.state 		= false
						Freeze_chk.state 		= true
						AutoAlign_chk.state 	= true
						UpdateStretch_rdo		#Scale
						UpdateAxis_rdo			#X
						BoneFlip_chk.state	 	= false
					)
				1 : (							
						BoneOn_chk.enabled 		= true
						BoneOn_chk.state 		= selection[1].boneEnable
						EnableBoneProperties	BoneOn_chk.state

						Freeze_chk.state 		= selection[1].boneFreezeLength
						AutoAlign_chk.state 	= selection[1].boneAutoAlign
						UpdateStretch_rdo		selection[1].boneScaleType
						UpdateAxis_rdo			selection[1].boneAxis
						BoneFlip_chk.state 		= selection[1].boneAxisFlip

						if classof selection[1] != BoneGeometry then
						(
							MultiLabel.text = "Selection is not a Bone Object" as string
							StretchFactor.text = "Stretch Factor: undefined"
						)
						else
						(
							MultiLabel.text    = selection.count as string + " bone Selected"
							StretchFactor.text = "Stretch Factor: "+(GetStretchFactor(selection[1]) as string)
						)
					)
				default:
					(

						local foundNonBone = false
						for i = 1 to selection.count do
						(
							if classof selection[i] != BoneGeometry then
							(
								foundNonBone = true
								exit
							)
						)
						
						if foundNonBone == true then
						(
							MultiLabel.text = "Selection has a non-Bone Object" as string
						)

						else
						(
							MultiLabel.text = selection.count as string + " bones Selected"
						)
						StretchFactor.text = "Stretch Factor: undefined"
						
						
						---- Process the state of the "Bone On" button --
						BoneOn_chk.enabled = true
						updateChkBox BoneOn_chk #boneEnable

						if BoneOn_chk.triState == 1 then
						(
							EnableBoneProperties true
						)
						else
						(
							EnableBoneProperties false
						)

						---- Process the state of the "Freeze Length" checkbox --
						updateChkBox Freeze_chk #boneFreezeLength
			
						---- Process the state of the "Auto-Align" checkbox ---
						updateChkBox AutoAlign_chk #boneAutoAlign

						---- Process the state of the "Stretch" radio ---
						UpdateStretch_rdo (GetRadioButton #boneScaleType)

						---- Process the state of the "Axis" radio ---
						UpdateAxis_rdo (GetRadioButton #boneAxis)

						---- Process the state of the "Flip" checkbox ---
						updateChkBox BoneFlip_chk #boneAxisFlip

					)
			)
		)
	)
	
	fn UpdateOPRUINow  =
	(
		BoneAdjustmentsFloater_updateOPRFlag = true
		UpdateOPRUI()
	)
	
	on ObjectPropsRollout open do
	(
		ObjectPropsRollout.open = objOpen
		CorrNegStretch_chk.state = true
		-- callbacks to update the UI
		callbacks.addScript #selectionSetChanged "BoneAdjustmentsFloater_updateOPRFlag = true" id:#agOPRUpdate
		callbacks.addScript #sceneUndo "BoneAdjustmentsFloater_updateOPRFlag = true" id:#agOPRUpdate
		callbacks.addScript #sceneRedo "BoneAdjustmentsFloater_updateOPRFlag = true" id:#agOPRUpdate
		registerRedrawViewsCallback ObjectPropsRollout.UpdateOPRUINow 
		registerTimeCallback ObjectPropsRollout.UpdateOPRUINow 
		BoneAdjustmentsFloater_updateOPRFlag = true -- set to update rollout ui
		UpdateOPRUI()
		

	)
	on ObjectPropsRollout close do
	(	
		objOpen = ObjectPropsRollout.open
		SetINIConfigData iniFile "ObjectPropsRollout" "Open" objOpen 

	    -- don't need the callbacks after the rollout is closed, kill 'em
		unregisterTimeCallback ObjectPropsRollout.UpdateOPRUINow 
		unregisterRedrawViewsCallback ObjectPropsRollout.UpdateOPRUINow
		callbacks.removeScripts id:#agOPRUpdate  -- remove by id
		callbacks.removeScripts id:#BoneAdjTools 
	)
)

-- Above ------ Third Rollout -- Object Properties  ----------------------
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- Below ------ Second Rollout -- Fin Adjustment Tools -------------------
rollout BoneAdjustmentsFloater_FinToolsRollout "Fin Adjustment Tools" width:208 height:468
(
	--------------- variables ------------------------------------
		--------------- variables ------------------------------------
	local UpdateFTRUI  	-- declare function as local
	--local updateFTRFlag	-- declare flag. Set to true on selection set change, reset in UpdateBoneUI

	local updateSpinners
	local setSpinnersToZero 
	local EnableAllSpinners
	local DisableAllSpinners 
	local Abs_Rel_State  -- 1 for Absolute and 0 for Relative

	---- temporary variables for copy and paste operation ------------
	local tempWidth,tempHeight,tempTaper
	local tempSideSize,tempSideStartT, tempSideEndT
	local tempFrontSize,tempFrontStartT,tempFrontEndT
	local tempBackSize,tempBackStartT,tempBackEndT
	local tempSideFinState,tempFrontFinState,tempBackFinState
	local tempBufferValid=false

	---- temporary variables for undo  ------------
	local undWidth=#(),undHeight=#(),undTaper=#() 
	local undSideSize=#(),undSideStartT=#(), undSideEndT=#()
	local undFrontSize=#(),undFrontStartT=#(),undFrontEndT=#()
	local undBackSize=#(),undBackStartT=#(),undBackEndT=#()
	local undSideFinState=#(),undFrontFinState=#(),undBackFinState=#()

	---- temporary variables for absolute and relative operation ------------
	local absWidth=#(),absHeight=#(),absTaper=#() 
	local absSideSize=#(),absSideStartT=#(), absSideEndT=#()
	local absFrontSize=#(),absFrontStartT=#(),absFrontEndT=#()
	local absBackSize=#(),absBackStartT=#(),absBackEndT=#()
	local absSideFinState=#(),absFrontFinState=#(),absBackFinState=#()
	local locVar1=0
	local locVar2=0
	
	
	------ Absolute/relative radiobuttons and Copy/Paste functions --- 
	------------------------------------------------------------------
	radiobuttons Abs_Rel_rad "" pos:[16,8] width:156 height:16 labels:#("Absolute", "Relative") columns:2	

	button Copy_btn "Copy" pos:[23,36] width:67 height:20
	button Paste_btn "Paste" pos:[118,34] width:67 height:20
	
	-------Bone Object Groupbox -------------------------------
	-----------------------------------------------------------
	GroupBox Bone_obj_grp "Bone Objects" pos:[7,65] width:194 height:85

	-------Bone Object Spinners ----------------------
	spinner width_spn "Width: " pos:[55,85] width:106 height:16 range:[-1e+030,1e+030,5]fieldwidth:60
	spinner Height_spn "Height: " pos:[52,105] width:109 height:16 range:[-1e+030,1e+030,10] fieldwidth:60
	spinner taper_spn "Taper:" pos:[58,124] width:103 height:16 range:[-1e+030,1e+030,0.9] fieldwidth:60

	
	-------------- Fins Groupbox elements -------------------------
	---------------------------------------------------------------
	GroupBox Fins_grp "Fins" pos:[7,156] width:195 height:302

	-------Side Fin Checkbox and Spinners ----------------------
	checkbox Side_Fin_chk "Side Fins" pos:[13,172] width:65 height:18
	spinner side_size_spn "Size: " pos:[63,194] width:98 height:16 range:[-1e+030,1e+030,5] fieldwidth:60
	spinner side_end_spn "End Taper:" pos:[36,234] width:125 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	spinner side_start_spn "Start Taper: " pos:[30,214] width:131 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	
	-------Front Fin Checkbox and Spinners ----------------------
	checkbox Front_Fin_chk "Front Fin" pos:[13,269] width:65 height:18
	spinner front_size_spn "Size: " pos:[63,297] width:98 height:16 range:[-1e+030,1e+030,5] fieldwidth:60
	spinner front_start_spn "Start Taper: " pos:[30,318] width:131 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	spinner front_end_spn "End Taper:" pos:[36,338] width:125 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	
	-------Back Fin Checkbox and Spinners ----------------------
	checkbox Back_Fin_chk "Back Fin" pos:[13,366] width:65 height:18
	spinner back_size_spn "Size: " pos:[63,392] width:98 height:16 range:[-1e+030,1e+030,5] fieldwidth:60
	spinner back_start_spn "Start Taper: " pos:[30,412] width:131 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	spinner back_end_spn "End Taper:" pos:[36,432] width:125 height:16 range:[-1e+030,1e+030,0.1] fieldwidth:60
	
	
	------- function to Remember Absolute Spinner Values -------------
	fn RememberAbsSpinnerValues =
	(
		a = 1
		For i in Selection do
		(		
			absWidth[a] 			= 	i.width 				-- width_spn.value
			absHeight[a] 			= 	i.height 				-- height_spn.value
			absTaper[a] 			= 	i.taper 				-- taper_spn.value
			absSideSize[a] 			= 	i.sidefinssize 			-- side_size_spn.value
			absSideStartT[a] 		= 	i.sidefinsstarttaper 	-- side_start_spn.value
			absSideEndT[a] 			= 	i.sidefinsendtaper		-- side_end_spn.value
			absFrontSize[a] 		= 	i.frontfinsize			-- front_size_spn.value
			absFrontStartT[a] 		= 	i.frontfinstarttaper	-- front_start_spn.value
			absFrontEndT[a] 		= 	i.frontfinendtaper		-- front_end_spn.value
			absBackSize[a] 			= 	i.backfinsize			-- back_size_spn.value
			absBackStartT[a] 		= 	i.backfinstarttaper		-- back_start_spn.value
			absBackEndT[a] 			= 	i.backfinendtaper		-- back_end_spn.value
			absSideFinState[a] 		= 	i.sidefins				-- Side_Fin_chk.state
			absFrontFinState[a] 	= 	i.frontfin				-- Front_Fin_chk.state
			absBackFinState[a] 		= 	i.backfin				-- Back_Fin_chk.state
			a = a + 1
		)
	)	

	fn RememberThisSpinnerValue paramOne =
	(
		a = 1
		For i in Selection do
		(		
			case paramOne of 
			(

				#width 					: absWidth[a] = i.width
				#height 				: absheight[a] = i.height
				#taper 					: abstaper[a] = i.taper
				#sidefinssize 			: absSideSize[a] = i.sidefinssize
				#sidefinsstarttaper		: absSideStartT[a] = i.sidefinsstarttaper
				#sidefinsendtaper		: absSideEndT[a] = i.sidefinsendtaper
				#frontfinsize			: absFrontSize[a] = i.frontfinsize
				#frontfinstarttaper		: absFrontStartT[a] = i.frontfinstarttaper
				#frontfinendtaper		: absFrontEndT[a] = i.frontfinendtaper
				#backfinsize			: absBackSize[a] = i.backfinsize	
				#backfinstarttaper		: absBackStartT[a] = i.backfinstarttaper	
				#backfinendtaper		: absBackEndT[a] = i.backfinendtaper
			)
			a = a + 1
		)
	)					

	------- function to Remember Undo Values -------------
	fn RememberUndSpinnerValues =
	(
		a = 1
		For i in Selection do
		(		
			undWidth[a] 			= 	i.width 				-- width_spn.value
			undHeight[a] 			= 	i.height 				-- height_spn.value
			undTaper[a] 			= 	i.taper 				-- taper_spn.value
			undSideSize[a] 			= 	i.sidefinssize 			-- side_size_spn.value
			undSideStartT[a] 		= 	i.sidefinsstarttaper 	-- side_start_spn.value
			undSideEndT[a] 			= 	i.sidefinsendtaper		-- side_end_spn.value
			undFrontSize[a] 		= 	i.frontfinsize			-- front_size_spn.value
			undFrontStartT[a] 		= 	i.frontfinstarttaper	-- front_start_spn.value
			undFrontEndT[a] 		= 	i.frontfinendtaper		-- front_end_spn.value
			undBackSize[a] 			= 	i.backfinsize			-- back_size_spn.value
			undBackStartT[a] 		= 	i.backfinstarttaper		-- back_start_spn.value
			undBackEndT[a] 			= 	i.backfinendtaper		-- back_end_spn.value
			undSideFinState[a] 		= 	i.sidefins				-- Side_Fin_chk.state
			undFrontFinState[a] 	= 	i.frontfin				-- Front_Fin_chk.state
			undBackFinState[a] 		= 	i.backfin				-- Back_Fin_chk.state
			a = a + 1
		)
	)	

	fn EqualsThisUndValue paramOne =
	(
		local result = true
		a = 1
		for i in Selection do
		(		
			case paramOne of 
			(
				#width 					: if ( undWidth[a] != i.width ) then result = false
				#height 				: if ( undheight[a] != i.height ) then result = false
				#taper 					: if ( undtaper[a] != i.taper ) then result = false
				#sidefinssize 			: if ( undSideSize[a] != i.sidefinssize ) then result = false
				#sidefinsstarttaper		: if ( undSideStartT[a] != i.sidefinsstarttaper ) then result = false
				#sidefinsendtaper		: if ( undSideEndT[a] != i.sidefinsendtaper ) then result = false
				#frontfinsize			: if ( undFrontSize[a] != i.frontfinsize ) then result = false
				#frontfinstarttaper		: if ( undFrontStartT[a] != i.frontfinstarttaper ) then result = false
				#frontfinendtaper		: if ( undFrontEndT[a] != i.frontfinendtaper ) then result = false
				#backfinsize			: if ( undBackSize[a] != i.backfinsize	 ) then result = false
				#backfinstarttaper		: if ( undBackStartT[a] != i.backfinstarttaper	 ) then result = false
				#backfinendtaper		: if ( undBackEndT[a] != i.backfinendtaper ) then result = false
			)
			a = a + 1
		)
		result
	)					

	fn RememberThisUndValue paramOne =
	(
		a = 1
		For i in Selection do
		(		
			case paramOne of 
			(

				#width 					: undWidth[a] = i.width
				#height 				: undheight[a] = i.height
				#taper 					: undtaper[a] = i.taper
				#sidefinssize 			: undSideSize[a] = i.sidefinssize
				#sidefinsstarttaper		: undSideStartT[a] = i.sidefinsstarttaper
				#sidefinsendtaper		: undSideEndT[a] = i.sidefinsendtaper
				#frontfinsize			: undFrontSize[a] = i.frontfinsize
				#frontfinstarttaper		: undFrontStartT[a] = i.frontfinstarttaper
				#frontfinendtaper		: undFrontEndT[a] = i.frontfinendtaper
				#backfinsize			: undBackSize[a] = i.backfinsize	
				#backfinstarttaper		: undBackStartT[a] = i.backfinstarttaper	
				#backfinendtaper		: undBackEndT[a] = i.backfinendtaper
			)
			a = a + 1
		)
	)					
		
	on Abs_Rel_rad changed state do
	(
		undo "Abs/Rel" on ( 
			EnableAllSpinners()
			case Abs_Rel_rad.state of 
			(
				1: -- means the state is Absolute
				(
					Abs_Rel_State = 1
					updateSpinners()
					Copy_btn.enabled 		= true
				)
				
				2: -- means the state is Relative
				(
					Abs_Rel_State = 0
					RememberAbsSpinnerValues()
					setSpinnersToZero()
					Copy_btn.enabled 		= false
				)
			)
		)
	)
	
	------- function to Change Checkbox -------------
	fn changeChkB paramOne paramState =
	(
	    local a = 1
		For i in Selection do
		(
			setProperty i paramOne paramState
			a = a + 1
		)
		if isMacroRecorderEnabled() do (if a > 0 do format "$.%=%\n" (paramOne as string) paramState to:MacroRecorder)
	)

	------- function to Change Spinner -------------
	fn changeSpn paramOne paramState rec =
	(	
	    local recording = isMacroRecorderEnabled()   
		local a = 1
		For i in Selection do
		(			
			flagForeground i true
			if Abs_Rel_State == 1 then
			(
				setProperty i paramOne paramState
			)
			else
			(
				case paramOne of 
				(

					#width 					: locVar1 = absWidth[a]
					#height 				: locVar1 = absheight[a]
					#taper 					: locVar1 = abstaper[a]
					#sidefinssize 			: locVar1 = absSideSize[a] 
					#sidefinsstarttaper		: locVar1 = absSideStartT[a] 
					#sidefinsendtaper		: locVar1 = absSideEndT[a] 
					#frontfinsize			: locVar1 = absFrontSize[a] 
					#frontfinstarttaper		: locVar1 = absFrontStartT[a] 
					#frontfinendtaper		: locVar1 = absFrontEndT[a] 
					#backfinsize			: locVar1 = absBackSize[a] 
					#backfinstarttaper		: locVar1 = absBackStartT[a] 
					#backfinendtaper		: locVar1 = absBackEndT[a] 
				)
				
				locVar2 = paramState + locVar1
				setProperty i paramOne locVar2
				if rec and recording do format "$%.%=%\n" i.name (paramOne as string) locVar2 to:MacroRecorder
			)
			flagForeground i false
			a =  a + 1
		)

		if rec and Abs_Rel_State == 1 and a > 0 and recording do format "$.%=%\n" (paramOne as string) paramState to:MacroRecorder
	)
	
	------- function to update the 3 chkbxs in the Fin grpbx -------
	fn updateChkBox chkB paramOne =
	(
		local ChkBStateBoneOne = getProperty selection[1] paramOne  	
		local FoundDifferent = false	
		for i = 2 to selection.count do
		(
			if ChkBStateBoneOne != (getProperty selection[i] paramOne) do 
			(
				FoundDifferent = true
				exit
			)
		)
		
		chkB.enabled = true
		if FoundDifferent then
		(
			chkB.triState = 2
		)
		else 
		(
			chkB.state = ChkBStateBoneOne
		)	
	)
	
	fn EnableAllSpinners = 
	(
		------- Bone Object --------
		width_spn.enabled 		= true
		height_spn.enabled 		= true
		taper_spn.enabled 		= true
		
		------- side fin --------
		Side_Fin_chk.enabled 	= true
		side_size_spn.enabled 	= true
		side_start_spn.enabled 	= true
		side_end_spn.enabled 	= true
		
		------- front fin --------
		Front_Fin_chk.enabled 	= true
		front_size_spn.enabled 	= true
		front_start_spn.enabled = true
		front_end_spn.enabled 	= true
		
		------- back fin --------
		Back_Fin_chk.enabled 	= true					
		back_size_spn.enabled 	= true
		back_start_spn.enabled 	= true
		back_end_spn.enabled 	= true
	)
	
	fn DisableAllSpinners = 
	(
		---- disable the spinner checkboxes -----
		Front_Fin_chk.state 	= false
		Side_Fin_chk.state 		= false
		Back_Fin_chk.state 		= false
						
		------- Bone Object --------
		width_spn.enabled 		= false
		height_spn.enabled 		= false
		taper_spn.enabled 		= false
		
		------- side fin --------
		Side_Fin_chk.enabled 	= false
		side_size_spn.enabled 	= false
		side_start_spn.enabled 	= false
		side_end_spn.enabled 	= false
		
		------- front fin --------
		Front_Fin_chk.enabled 	= false
		front_size_spn.enabled 	= false
		front_start_spn.enabled = false
		front_end_spn.enabled 	= false
		
		------- back fin --------
		Back_Fin_chk.enabled 	= false					
		back_size_spn.enabled 	= false
		back_start_spn.enabled 	= false
		back_end_spn.enabled 	= false
		
		--- disable some other stuff that happen together --------------
		Copy_btn.enabled 		= false
		Paste_btn.enabled 		= false
		Abs_Rel_Rad.enabled 	= false
	)


	------- function to update the 12 spinners in the Fin groupbox -------
	fn updateSpn spn paramOne =
	(

		local SpnValueBoneOne = getProperty selection[1] paramOne
		local FoundDifferent = false
		local average = SpnValueBoneOne 
		
		if Abs_Rel_State == 1 then (
			for i = 2 to selection.count do
			(
				average = average + (getProperty selection[i] paramOne)
				if SpnValueBoneOne != (getProperty selection[i] paramOne) do 
				(
					FoundDifferent = true
				)
			)
			average = average/selection.count

			if FoundDifferent then
			(
				spn.value = average 
			)
			else 
			(
				spn.value = SpnValueBoneOne 
			)
		)
		else (
			RememberAbsSpinnerValues()
			setSpinnersToZero()
		)
	
	)

	fn updateSpinners = -- called when selection = 1 and after paste operation
	(	
	
		case selection.count of
		(
			0 : 
			(
				DisableAllSpinners()
			)
			
			1 : 
			(
				if classof selection[1] != BoneGeometry then
				(
					DisableAllSpinners()
				)
				else
				(
					EnableAllSpinners()
					
					Side_Fin_chk.state 		= selection[1].sidefins
					Front_Fin_chk.state 	= selection[1].frontfin
					Back_Fin_chk.state 		= selection[1].backfin
			
					------- Bone Object spinners --------
					width_spn.value 		= selection[1].width
					height_spn.value 		= selection[1].height
					taper_spn.value 		= selection[1].taper
				
					------- side fin spinners --------
					side_size_spn.value 	= selection[1].sidefinssize
					side_start_spn.value 	= selection[1].sidefinsstarttaper
					side_end_spn.value 		= selection[1].sidefinsendtaper
								
					------- front fin spinners --------
					front_size_spn.value 	= selection[1].frontfinsize
					front_start_spn.value 	= selection[1].frontfinstarttaper
					front_end_spn.value 	= selection[1].frontfinendtaper
					
					------- back fin spinners --------				
					back_size_spn.value 	= selection[1].backfinsize
					back_start_spn.value 	= selection[1].backfinstarttaper
					back_end_spn.value 		= selection[1].backfinendtaper
				)		
			)
			default:
			(					
				updateSpn side_size_spn #sidefinssize
				updateSpn side_start_spn #sidefinsstarttaper						
				updateSpn side_end_spn #sidefinsendtaper												
				updateSpn front_size_spn #frontfinsize		
				updateSpn front_start_spn #frontfinstarttaper
				updateSpn front_end_spn #frontfinendtaper																	
				updateSpn back_size_spn #backfinsize					
				updateSpn back_start_spn #backfinstarttaper								
				updateSpn back_end_spn #backfinendtaper						
				updateSpn width_spn #width
				updateSpn height_spn #height
				updateSpn taper_spn #taper
	
			)
		)
	)
	
	fn setSpinnersToZero = -- called when Relative is set in Fins groupbox
	(
		For i in selection do
		(
			------------ updating the fin spinner values ------------

			------- Bone Object spinners --------
			width_spn.value 		= 0.0
			height_spn.value 		= 0.0
			taper_spn.value 		= 0.0
		
			------- side fin spinners --------
			Side_Fin_chk.state 		= i.sidefins
			side_size_spn.value 	= 0.0
			side_start_spn.value 	= 0.0
			side_end_spn.value 		= 0.0
						
			------- front fin spinners --------
			Front_Fin_chk.state 	= i.frontfin
			front_size_spn.value 	= 0.0
			front_start_spn.value 	= 0.0
			front_end_spn.value 	= 0.0

			------- back fin spinners --------
			Back_Fin_chk.state 		= i.backfin						
			back_size_spn.value 	= 0.0
			back_start_spn.value 	= 0.0
			back_end_spn.value 		= 0.0
		)

	)
	
	fn ProcessUndoSpinner paramOne spv =
	(
		if ( not EqualsThisUndValue paramOne ) then
		(
  			with redraw off
			(
				local a = 1
				For i in Selection do
				(		
					flagForeground i true

					case paramOne of 
					(
						#width 					: setProperty i paramOne		 undWidth[a] 			-- width_spn.value
						#height 				: setProperty i paramOne				 undHeight[a] 			-- height_spn.value
						#taper 					: setProperty i paramOne				 undTaper[a] 			-- taper_spn.value
						#sidefinssize 			: setProperty i paramOne 				 undSideSize[a] 			-- side_size_spn.value
						#sidefinsstarttaper		: setProperty i paramOne 		 undSideStartT[a] 		-- side_start_spn.value
						#sidefinsendtaper		: setProperty i paramOne			 undSideEndT[a] 			-- side_end_spn.value
						#frontfinsize			: setProperty i paramOne				 undFrontSize[a] 		-- front_size_spn.value
						#frontfinstarttaper		: setProperty i paramOne		 undFrontStartT[a] 		-- front_start_spn.value
						#frontfinendtaper		: setProperty i paramOne			 undFrontEndT[a] 		-- front_end_spn.value
						#backfinsize			: setProperty i paramOne				 undBackSize[a] 			-- back_size_spn.value
						#backfinstarttaper		: setProperty i paramOne			 undBackStartT[a] 		-- back_start_spn.value
						#backfinendtaper		: setProperty i paramOne			 undBackEndT[a] 			-- back_end_spn.value
					)
					flagForeground i false
					a = a + 1
				)
			)

			undo "Change Fin Parameter" on
			(
				changeSpn paramOne spv true
			)

			RememberThisUndValue paramOne
		)
	)					

	on width_spn changed state do
		changeSpn #width state false

	on width_spn entered do 
	(
		ProcessUndoSpinner #width width_spn.value
		if Abs_Rel_State == 0 then 
		(
		RememberThisSpinnerValue #width
		width_spn.value = 0
		)
	)

	on Height_spn changed state do
		changeSpn #height state false
	
	on Height_spn entered do 
	(
		ProcessUndoSpinner #height Height_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #height
			Height_spn.value = 0
		)
	)

	on taper_spn changed state do
		changeSpn #taper state false
	
	on taper_spn entered do 
	(
		ProcessUndoSpinner #taper taper_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #taper
			taper_spn.value = 0
		)
	)

	on Side_Fin_chk changed state do
	(
		undo "Side Fin On/OFF" on
		(
			changeChkB #sidefins state
		)
	)

	on side_size_spn changed state do
		changeSpn #sidefinssize state false
		
	on side_size_spn entered do 
	(
		ProcessUndoSpinner #sidefinssize side_size_spn.value
		if Abs_Rel_State == 0 then 
		(
			side_size_spn.value = 0
			RememberThisSpinnerValue #sidefinssize
		)
	)
	
	on side_start_spn changed state do
		changeSpn #sidefinsstarttaper state false
	
	on side_start_spn entered do 
	(
		ProcessUndoSpinner #sidefinsstarttaper side_start_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #sidefinsstarttaper
			side_start_spn.value = 0
		)
	)

	on side_end_spn changed state do
		changeSpn #sidefinsendtaper state false
	
	on side_end_spn entered do 
	(
		ProcessUndoSpinner #sidefinsendtaper side_end_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #sidefinsendtaper
			side_end_spn.value = 0
		)
	)

	on Front_Fin_chk changed state do
	(
		undo "Front Fin On/OFF" on
		(
			changeChkB #frontfin state
		)
	)
			
	on front_size_spn changed state do
		changeSpn #frontfinsize state false
	
	on front_size_spn entered do 
	(
		ProcessUndoSpinner #frontfinsize front_size_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #frontfinsize
			front_size_spn.value = 0
		)
	)

	on front_start_spn changed state do
		changeSpn #frontfinstarttaper state false
	
	on front_start_spn entered do 
	(
		ProcessUndoSpinner #frontfinstarttaper front_start_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #frontfinstarttaper
			front_start_spn.value = 0
		)
	)

	on front_end_spn changed state do
		changeSpn #frontfinendtaper state false
	
	on front_end_spn entered do 
	(
		ProcessUndoSpinner #frontfinendtaper front_end_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #frontfinendtaper
			front_end_spn.value = 0
		)
	) 

	on Back_Fin_chk changed state do
	(
		undo "Back Fin On/OFF" on
		(
			changeChkB #backfin state
		)
	)

	on back_size_spn changed state do
		changeSpn #backfinsize state false
	
	on back_size_spn entered do 
	(
		ProcessUndoSpinner #backfinsize back_size_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #backfinsize
			back_size_spn.value = 0
		)
	) 

	on back_start_spn changed state do
		changeSpn #backfinstarttaper state false
	
	on back_start_spn entered do 
	(
		ProcessUndoSpinner #backfinstarttaper back_start_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #backfinstarttaper
			back_start_spn.value = 0
		)
	) 

	on back_end_spn changed state do
		changeSpn #backfinendtaper state false
	
	on back_end_spn entered do 
	(
		ProcessUndoSpinner #backfinendtaper back_end_spn.value
		if Abs_Rel_State == 0 then 
		(
			RememberThisSpinnerValue #backfinendtaper
			back_end_spn.value = 0
		)
	) 


	on Copy_btn pressed do
	(
		undo "Copy" on 
		( 	
			tempWidth 				= 	width_spn.value
			tempHeight 				= 	height_spn.value
			tempTaper 				= 	taper_spn.value
			tempSideSize 			= 	side_size_spn.value
			tempSideStartT 			= 	side_start_spn.value
			tempSideEndT 			= 	side_end_spn.value
			tempFrontSize 			= 	front_size_spn.value
			tempFrontStartT 		= 	front_start_spn.value
			tempFrontEndT 			= 	front_end_spn.value
			tempBackSize 			= 	back_size_spn.value
			tempBackStartT 			= 	back_start_spn.value
			tempBackEndT 			= 	back_end_spn.value
			tempSideFinState 		= 	Side_Fin_chk.state
			tempFrontFinState 		= 	Front_Fin_chk.state
			tempBackFinState 		= 	Back_Fin_chk.state
			tempBufferValid         =   true
			Paste_btn.enabled 	    = 	tempBufferValid
		)
	)
	on Paste_btn pressed do
	(
		undo "paste" on 
		( 
			For i in Selection do
			(
				i.width 				= 	tempWidth 
				i.height 				= 	tempHeight 
				i.taper 				= 	tempTaper 
				i.sidefinssize 			= 	tempSideSize 
				i.sidefinsstarttaper 	= 	tempSideStartT 
				i.sidefinsendtaper 		= 	tempSideEndT 
				i.frontfinsize 			= 	tempFrontSize 
				i.frontfinstarttaper 	= 	tempFrontStartT 
				i.frontfinendtaper 		= 	tempFrontEndT 
				i.backfinsize 			= 	tempBackSize 
				i.backfinstarttaper 	= 	tempBackStartT 
				i.backfinendtaper 		= 	tempBackEndT 
				i.sidefins 				= 	tempSideFinState 
				i.frontfin 				= 	tempFrontFinState 
				i.backfin 				= 	tempBackFinState 
			)
			EnableAllSpinners()
			updateSpinners()
		)
	)
	
	fn UpdateFTRUIforce =
	(
		updateFTRFlag = true
		UpdateFTRUI()
	)
	
	-- UpdateFTRUI called by redraw views callback. updateFlag will be true if an update is needed.
	fn UpdateFTRUI =
	(
		if updateFTRFlag == true do -- explicitly test against true in case we are called before updateFlag is initialized
		(
			updateFTRFlag = false
			case selection.count of
			(
				0 : (
						DisableAllSpinners()
					)
				1 : (
						if classof selection[1] != BoneGeometry then
						(
							DisableAllSpinners()
						)
						else
						(
							EnableAllSpinners()		
							Paste_btn.enabled 		= tempBufferValid							
							Abs_Rel_Rad.enabled 	= true
							RememberUndSpinnerValues()


							if Abs_Rel_State == 1 then
							(
								updateSpinners()
								RememberAbsSpinnerValues()
								Copy_btn.enabled 		= true
							)
							else
							(
								RememberAbsSpinnerValues()
								setSpinnersToZero()
								Copy_btn.enabled 		= false
							)
						)
						
					)
				default:
					(						
						local foundNonBone = false
						for i = 1 to selection.count do
						(
							if classof selection[i] != BoneGeometry then
							(
								foundNonBone = true
								exit
							)
						)
						if foundNonBone == true then
						(
							DisableAllSpinners()
						)
						
						else
						(
							Copy_btn.enabled 		= false
							Paste_btn.enabled 		= tempBufferValid
							Abs_Rel_Rad.enabled 	= true
							EnableAllSpinners()									
							RememberAbsSpinnerValues()
							RememberUndSpinnerValues()
											
							---- Process the state of the "Side Fin" checkbox ---
							updateChkBox Side_Fin_chk #sidefins
						
							---- Process the state of the Side Fin "Size" spinner --						
							updateSpn side_size_spn #sidefinssize
						
							---- Process the state of the Side Fin "Start Taper" spinner --
							updateSpn side_start_spn #sidefinsstarttaper						

							---- Process the state of the Side Fin "End Taper" spinner --
							updateSpn side_end_spn #sidefinsendtaper						

							---- Process the state of the "Front Fin" checkbox ---
							updateChkBox Front_Fin_chk #frontfin						
						
							---- Process the state of the Front Fin "Size" spinner --
							updateSpn front_size_spn #frontfinsize		
						
							---- Process the state of the Front Fin "Start Taper" spinner --
							updateSpn front_start_spn #frontfinstarttaper
						
							---- Process the state of the Front Fin "End Taper" spinner --
							updateSpn front_end_spn #frontfinendtaper																	
						
							---- Process the state of the "Back Fin" checkbox ---
							updateChkBox Back_Fin_chk #backfin 

							---- Process the state of the Back Fin "Size" spinner --
							updateSpn back_size_spn #backfinsize					
						
							---- Process the state of the Back Fin "Start Taper" spinner --
							updateSpn back_start_spn #backfinstarttaper					
												
							---- Process the state of the Back Fin "End Taper" spinner --
							updateSpn back_end_spn #backfinendtaper						
						
							---- Process state of "Width" spinner --
							updateSpn width_spn #width
						
							---- Process state of "Height" spinner --
							updateSpn height_spn #height
												
							---- Process state of "Taper" spinner --
							updateSpn taper_spn #taper
						)
					) 
			)
		)
	)
		
	on BoneAdjustmentsFloater_FinToolsRollout open do
	(
		BoneAdjustmentsFloater_FinToolsRollout.open = finsOpen
		Abs_Rel_State = 1
		Abs_Rel_Rad.state = 1	
		Copy_btn.enabled 		= true	
		-- callbacks to update the UI
		callbacks.addScript #selectionSetChanged "BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUIforce()" id:#agFTRUpdate
		callbacks.addScript #sceneUndo "BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUIforce()" id:#agFTRUpdate
		callbacks.addScript #SceneRedo "BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUIforce()" id:#agFTRUpdate
		registerRedrawViewsCallback BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUI 
		updateFTRFlag = true -- set to update rollout ui
		UpdateFTRUI()
	)
	
	on BoneAdjustmentsFloater_FinToolsRollout close do
	(	
		finsOpen = BoneAdjustmentsFloater_FinToolsRollout.open
		SetINIConfigData iniFile "FinToolsRollout" "Open" finsOpen 
	
	    -- don't need the callbacks after the rollout is closed, kill 'em
		unregisterRedrawViewsCallback BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUI 
		callbacks.removeScripts id:#agFTRUpdate -- remove by id
	)
)
-- Above ------ Second Rollout -- Fin Adjustment Tools -----------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- Below ------ First Rollout -- Bone Editing Tools ---------------------
rollout ToolsRollout "Bone Editing Tools" width:208 height:330
(
	--------------- variables ------------------------------------
	local UpdateTRUI, getEndPoint, removeIKsolvers 	-- declare function as local
	local boneEditModeTurnedOnByMe = false
	
	-------------- Bone Pivot Position Groupbox elements --------------
	-------------------------------------------------------------------
	GroupBox grp4 "Bone Pivot Position" pos:[8,4] width:196 height:47
	checkbutton BoneEdit_btn "Bone Edit Mode" pos:[37,22] width:119 height:20 -- highlightColor:(color ((colorman.getcolor #pressedbutton).x *255) ((colorman.getcolor #pressedbutton).y *255)((colorman.getcolor #pressedbutton).z *255))
	--checkbox Affect_children_chk "Affect Children" pos:[108,177] width:91 height:16

	-------------- Bone Tools Groupbox elements -------------------------
	---------------------------------------------------------------
	GroupBox grp31 "Bone Tools" pos:[7,56]    width:196 height:126
    checkButton CreateBone_btn "Create Bones" pos:[19,74]		width:80 height:20 highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255))
	button CreateEnd_btn "Create End" 		  pos:[111,74] 	width:80 height:20
    button RemoveBone_btn "Remove Bone" 	  pos:[19,101] 	width:80 height:20
	button ConnectBones_btn "Connect Bones"   pos:[111,101] 	width:80 height:20
	button DeleteBone_btn "Delete Bone" 	  pos:[19,128] 	width:80 height:20
	button ReassignRoot_btn "Reassign Root"   pos:[111,128] 	width:80 height:20
	checkbutton RefineBone_btn "Refine" 	  pos:[19,155] 	width:80 height:20 highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255))
	button Mirror_btn "Mirror"                pos:[111,155] 	width:80 height:20

    -- HightLightColor:(colorMan.getColor #colorName)
	-------------- Bone Coloring Groupbox elements -------------------------
	---------------------------------------------------------------
	GroupBox Bone_Coloring_grp "Bone Coloring" pos:[8,185] width:195 height:115
	colorPicker Bone_color_cp "Selected Bone Color: " pos:[24,207] width:145 height:16 title:"Selected Bone Color" color:[174, 186, 203] 




	-------------- Gradient Coloring Groupbox elements -------------------------
	GroupBox grp11 "Gradient Coloring" pos:[11,231] width:189 height:63
	button Gradient_btn "Apply Gradient" pos:[17,258] width:79 height:20
	colorPicker start_color_cp "Start Color: " pos:[100,248] fieldwidth:35 height:16 title:"Start Color" color:[174, 186, 203] 
	colorPicker End_color_cp "End Color:  " pos:[100,267] fieldwidth:35 height:16 title:"End Color" color:[174, 186, 203] 	


	fn getEndPoint a =
	(
		if ( classOf(a) == BoneGeometry ) then
		(
		   [a.length,0,0] * a.objectTransform
		)
		else
		(
		   (a.transform).translation
		)
	)

	fn removeIKsolvers a =
	(
	   if ( (not IsProperty a "pos") or (not IsProperty a "rotation") ) do
	   (
	     HDIKSys.RemoveChain a
	   )
	)

	fn putChildIntoAssembly a =
	(
		if ( (a.parent != undefined) and (a.parent.assemblyMember) ) do
		(
		  a.assemblyMember     = true
		  a.assemblyMemberOpen = true
		)
	)

	fn getAssemblyHead a =
	(
	   b = a
	   while ( b != undefined ) do
	   (
			if (     b.assemblyHead   ) do return b
			if ( not b.assemblyMember ) do exit
			b = b.parent
	   )
	   undefined
	)

	fn copyBoneHeightWidth destination source =
	(
		if ( (source != undefined) and (classOf(source) == BoneGeometry) ) do
		(
			destination.width   = source.width
			destination.height  = source.height
		)
	)

	timer boneEditModeTimer interval:100 active:true

	on BoneEdit_btn changed state do
	(
		if (BoneEdit_btn.state == true) then
		(
			boneEditModeTurnedOnByMe = true
			maxops.affectchildren = false
			if isCreatingObject Bones do 
			(
				StopCreating()
			)
		)
		else
		(
			boneEditModeTurnedOnByMe = false
			maxops.affectchildren = true
		)
	)

	on boneEditModeTimer tick do
	(
		if ( BoneEdit_btn.state == maxops.affectChildren ) do 
		(
			BoneEdit_btn.state = (not maxops.affectChildren)
		)
		if ( BoneEdit_btn.enabled == animButtonState ) do
		(
		  BoneEdit_btn.enabled = (not animButtonState)
		)
	)

	on Bone_color_cp changed color do
	(
		undo "Bone Color Changed" on
		(
			for i= 1 to selection.count do
			(
				selection[i].wirecolor	= Bone_color_cp.color
			)
			--start_color_cp.color 	= selection[1].wirecolor
			--end_color_cp.color		= selection[selection.count].wirecolor
		)
	
	)
	
	on Gradient_btn pressed do
	(
		undo "Apply Gradient" on
		(
			local level     = #()
	      
			for i = 1 to selection.count do
			(
			  local node = selection[i]
			  local n    = 0
			  do
			  (
			    n    = n + 1
			    node = node.parent
			  ) while (node != undefined)
			  level[i] = n
			)

			local minLevel = level[1]
			local maxLevel = minLevel

			for i = 1 to selection.count do
			(
				if ( minLevel > level[i] ) do minLevel = level[i]
				if ( maxLevel < level[i] ) do maxLevel = level[i]
			)

			local span = maxLevel - minLevel
			if ( span < 1 ) do span = 1

			local colorDiff = end_color_cp.color - start_color_cp.color
			local colorDiffDistrib = colorDiff/span
			for i= 1 to selection.count do
			(
				selection[i].wirecolor = start_color_cp.color + (level[i] - minLevel) * colorDiffDistrib 
			)
			--start_color_cp.color 	= selection[1].wirecolor
			end_color_cp.color		= start_color_cp.color + (maxLevel - minLevel) * colorDiffDistrib
		)
	)
	
	on start_color_cp changed color do
	(
		--selection[1].wirecolor = start_color_cp.color
	)
	on End_color_cp changed color do
	(
		--selection[selection.count].wirecolor = end_color_cp.color
	)
	
	on ReassignRoot_btn pressed do
	(
		undo "Reassign Root" on
		(			
			with redraw off
			(
				with animate off
				(
					local deleteBoneArr = #()
					local currentBone   = selection[1]
					local selBone       = undefined
					local chlBone       = undefined
					local parentBone    = currentBone.parent
					local prevBone      = undefined
					local newBone       = undefined
					local newBoneArr    = #()
					local endBone       = undefined
					local revReset
					local exPrevBone    = undefined
					local i
						
					fn isPosSame a b =
					(
						local posTol = 5
						v1=a
						v2=b
						vi=0
						
						if ((v1.x) <= (v2.x  + posTol)) and ((v1.x) >= (v2.x  - posTol)) then vi +=1
						if ((v1.y) <= (v2.y  + posTol)) and ((v1.y) >= (v2.y  - posTol)) then vi +=1
						if ((v1.z) <= (v2.z  + posTol)) and ((v1.z) >= (v2.z  - posTol)) then vi +=1
						
						if vi > 1 then true else false
					)
				
					append deleteBoneArr currentBone

					removeIKsolvers currentBone
		
					if currentBone.children.count > 0 then
					(
						chlBone = currentBone.children
						revReset = true
					)


					if (classOf(currentBone) == BoneGeometry) and (currentBone.length == 10) and (currentBone.children.count == 0) then 
					(
						currentBone = parentBone
						parentBone = currentBone.parent
						append deleteBoneArr currentBone
					)

					if (parentBone != undefined) then
					(
						do   -- bone creation loop
						(
					        removeIKsolvers currentBone

						    if ( classOf(currentBone) == BoneGeometry ) then
							(
								newBone = boneSys.createBone (getEndPoint currentBone) currentBone.transform.translation currentBone.dir
								copyBoneHeightWidth newBone currentBone
								newBone.name = currentBone.name
								newBone.wirecolor=currentBone.wirecolor
								newBone.parent = prevBone
								newBone.resetBoneStretch()
								
 								if (parentBone.children.count > 1) and (parentBone.parent != undefined) then
								(
									parentBone.children.parent =  newBone
								)
								
								if (newBone.children == 0) and (newBone.length == 10) then
								(
									delete newBone
								)
								
								if chlBone != undefined then
								(
									chlBone.parent=newBone
								)
								
								if prevBone == undefined then
								(
									selBone = newbone
								)				
				

								prevBone = newBone
								currentBone = parentBone
								parentBone = currentBone.parent
								
								if ( classOf(currentBone) == BoneGeometry ) do append deleteBoneArr currentBone
								append newBoneArr newBone
							)
							else
							(
 								if (parentBone.children.count > 1) and (parentBone.parent != undefined) then
								(
								  local siblings = #()
								  for  b in parentBone.children do
								  (
								    if b != currentBone then
									(
									  append siblings b
									)
								  )
								  for i = 1 to siblings.count do
								  (
									(siblings[i]).parent = currentBone
								  )
								)

								if chlBone != undefined then
								(
									chlBone.parent=currentBone
								)

								if prevBone == undefined then
								(
									selBone = currentBone
								)	

								exPrevBone  = prevBone
								prevBone    = currentBone
								currentBone = parentBone
								parentBone  = currentBone.parent
								prevBone.parent = exPrevBone
								if ( classOf(currentBone) == BoneGeometry ) do append deleteBoneArr currentBone
							)
						
						) while (parentBone != undefined) -- bone creation loop

				        --removeIKsolvers currentBone

						if currentBone.children.count > 1 then
						(
							if ( classOf(currentBone) == BoneGeometry ) then
							(
						        local chlVar = #()

								for b in currentBone.children do
								(
					                --removeIKsolvers b
									append chlVar b
									b.parent = undefined
								)

								newBone = boneSys.createBone (getEndPoint currentBone) currentBone.transform.translation currentBone.dir
								copyBoneHeightWidth newBone currentBone
								newBone.name = currentBone.name
								newBone.wirecolor=currentBone.wirecolor
								newBone.parent = prevBone		
								
								chlVar.parent=newBone
								
								newBone.realignBoneToChild()
								newBone.resetBoneStretch()
								append newBoneArr newBone
							)
							else
							(
								currentBone.parent = prevBone		
								append newBoneArr currentBone
							)
						)
						else
						(
							if ( classOf(currentBone) == BoneGeometry ) then
							(
								newBone = boneSys.createBone (getEndPoint currentBone) currentBone.transform.translation currentBone.dir
								copyBoneHeightWidth newBone currentBone
								newBone.name = currentBone.name
								newBone.wirecolor=currentBone.wirecolor
								newBone.parent = prevBone
								append newBoneArr newBone
								
								parentBone = newBone
								
								newBone=BoneSys.createBone parentBone.transform.translation (parentBone.transform.translation+6) parentBone.dir
								copyBoneHeightWidth newBone parentBone
								newBone.rotation=parentBone.rotation
								newBone.pos=parentBone.transform.translation
								in coordSys Local move newBone [parentBone.length,0,0]
								newBone.parent=parentBone
								newBone.width=parentBone.width
								newBone.height=parentBone.height
								newBone.taper=90
								newBone.length=(parentBone.width+parentBone.height)/2
								newBone.wirecolor=parentBone.wirecolor
							)
							else
							(
								currentBone.parent = prevBone
							)
						)					
						
						for b in deleteBoneArr do
						(
						  if not isDeleted b do delete b
						)
						
						if (revReset != true) then
						(
							for i=1 to newBoneArr.count do 
							(
								(newBoneArr[i]).resetBoneStretch()
							)
						)
						else
						(
							for i=newBoneArr.count to 2 by -1 do 
							(
								(newBoneArr[i]).resetBoneStretch()
							)
						)
						
						
						select selBone
					)
				)
			)	
		)	
	)
	
	
	on RemoveBone_btn pressed do
	(	
		undo "Remove Bone" on(
			if (selection.count == 1) do
			(
				with Animate Off -- with Animate Off bracket open
				(
					with redraw off 
					(
					    removeIKsolvers $
						if keyboard.shiftPressed == false then --remove bone, extend children
						(
						    local parent = $.parent

							if parent != undefined do 
							(
								parent.ResetBoneStretch()
							)

							for i=1 to $.children.count do
							(
								local	chl = $.children [1]
							    removeIKsolvers chl
 							    if (classOf chl == BoneGeometry) do chl.pivot = $.transform.translation
								chl.parent=parent
 							    chl.ResetBoneStretch()
							)
						
							$.parent=undefined
							delete $
						)
						else --remove bone, extend parent
						(
							local chlArr=#()
							local chlAsm=#()
							
							for i=1 to $.children.count do
							(
								append chlArr $.children[i]
								append chlAsm $.children[i].assemblyMember
							    removeIKsolvers $.children[i]
							)
							
							local chl=$.children[1]
							local prt=$.parent
					
							local asmMbr = $.assemblyMember
							$.pivot=chl.transform.translation 
							--delete $

							for i=1 to chlArr.count do
							(
								chlArr[i].parent=prt
								if ( asmMbr and chlAsm[i] ) do
								(
									putChildIntoAssembly chlArr[i]
								)
							)
							delete $
							if ( prt != undefined ) do 
							(
							    prt.realignBoneToChild()
								prt.ResetBoneStretch()
							)


						)
					)  -- with Redraw Off bracket close
					redrawviews()
				) -- with Animate Off bracket close
			)
		)
	)
	
	
	on CreateEnd_btn pressed do
	(
		undo "Create End" on
		(
			if (selection.count == 1) do
			(
				with Animate Off   --with Animate Off bracket open
				(   
					local parentBone  = selection[1]
					local parentTrans = parentBone.transform
					local parentPos   = parentTrans.translation
					local newbone

					with redraw off 					(
						newBone=BoneSys.createBone parentPos (parentPos+6) parentBone.dir
						newBone.transform = parentTrans
						in coordSys Local move newBone [parentBone.length,0,0]

						newBone.parent    = parentBone
						putChildIntoAssembly newBone

						newBone.width     = parentBone.width
						newBone.height    = parentBone.height
						newBone.taper     = 90
						newBone.length    = (parentBone.width+parentBone.height)/2
						newBone.wirecolor = parentBone.wirecolor

						select newBone
					)

					redrawViews()
					
				) -- with Animate Off bracket close
			)
		)
	)
		
		
	on DeleteBone_btn pressed do
	(
		undo "Delete Bone" on(
			if (selection.count == 1 ) do -- and $.parent != undefined) do
			(
				with Animate Off 
				( -- with Animate Off bracket open
					local parentBone = $.parent
				    if ( parentBone != undefined ) then
					(
						parentBone.ResetBoneStretch()
						if parentBone.children.count == 1 then
						(
							if ($.children.count > 0) and (classOf selection[1] == BoneGeometry) then
							(
								local selTrans = $.transform
								local selPos   = selTrans.translation

								newbone=BoneSys.createBone selPos (selPos+6) ($.dir)
								newbone.transform = parentBone.transform
								newbone.pos       = selPos
								newbone.name      = $.name
								newbone.wirecolor = $.wirecolor
								newbone.parent    = parentBone
								newBone.width     = $.width
								newBone.height    = $.height
								newBone.taper     = 90
								newBone.length    = ($.width+$.height)/2
							)
							removeIKsolvers $
							delete $
						)
						else
						(
							removeIKsolvers $
							delete $
						)
					)
					else
					(
					  removeIKsolvers $
					  delete $
					)
				) -- with Animate Off bracket close
			) 
		) -- undo on close
	)
	
	on ConnectBones_btn pressed do
	(
		undo "Connect Bones" on
		(
			local parentBone, childBone, newBone
			with Animate Off -- with Animate Off bracket open
			(
				parentBone = selection[1]
				parentTip  = [parentBone.length,0,0] * parentBone.objectTransform --parentBone.transform

				fn boneFilt o = Filters.Is_Bone o
				
				if parentbone.children.count != 0 and keyboard.shiftPressed == false then
				(
					childBone = PickObject count:1 select:false filter:boneFilt count:1 Message:"Pick End Bone" Rubberband:parentTip ForceListenerFocus:False
			
					if childbone != undefined then
					(
						zaxis   = parentBone.dir
						newbone = BoneSys.createbone parentTip childBone.transform.translation zaxis
					)
				)
				else
				(
					childBone = PickObject count:1 select:false filter:boneFilt count:1 Message:"Pick End Bone" Rubberband:parentTip ForceListenerFocus:False

					if childbone != undefined then
					(
						zaxis   = (parentBone.dir+childBone.dir)/2
						newbone = BoneSys.createbone parentTip childBone.transform.translation zaxis
					)
				)
				
				try
				(
					parentBone.ResetBoneStretch()
					newbone.width    = (parentbone.width+childbone.width)/2
					newbone.height   = (parentbone.height+childbone.height)/2
					newbone.taper    = (parentbone.taper+childbone.taper)/2
					newbone.name     = uniqueName "connectBone"


					newBone.parent    = parentBone
					if ( childBone.assemblyMember ) do
					(
						putChildIntoAssembly newBone
					)
					childBone.parent = newbone
				)
				catch()

			) -- with Animate Off bracket close
		) -- undo on close
	)	
	
	
	------ code to turn off "Create Bone" button once bone creation process ends	
	timer createBoneTimer interval:100 active:true

	on CreateBone_btn changed state do
	(
		if state then
		(
			StartObjectCreation Bones
			createBoneTimer.active = true
		)
		else
		(
			if isCreatingObject Bones do 
			(
				StopCreating()
			)
		)
	)
	
	on createBoneTimer tick do
	(
		if not isCreatingObject Bones then
		(
			CreateBone_btn.checked = false
			--createBoneTimer.active = false
		)
		else
		(
			CreateBone_btn.checked = true
		)
	)
	--------------------------------------------------------
	
	------ code to turn off "Refine" button once bone creation process ends
	
	timer refineBoneTimer interval:100 active:false

	on RefineBone_btn changed state do
	(
		bonesys.RefineBone()
		
		if state do 
		(
			refineBoneTimer.active = true
		)
	)
	
	on refineBoneTimer tick do
	(
		if toolmode.commandmode != #pick and toolmode.commandmode != #viewport do 
		(
			RefineBone_btn.checked = false
			refineBoneTimer.active = false
		)
	)
	
	rollout BoneMirror "Bone Mirror" width:200 height:110
	(
		-- set up the controls for the pop-up dialog
		radiobuttons mirrorAxis   "Mirror Axis"        pos:[4,4]     width:90 height:80 labels:#("X", "XY", "Y", "YZ", "Z", "ZX") columns:2
		radiobuttons mirrorFlip   "Bone Axis to Flip"  pos:[104,4]   width:90 height:40 labels:#("Y", "Z") columns:2 default:2 
		spinner      mirrorOffset "Offset"             pos:[104,40]  width:90 height:24 type:#worldunits range:[-10000,10000,0] fieldwidth:50 scale:1
		button       mirrorOK     "OK"                 pos:[4 ,80]   width:60 height:20
		button       mirrorCancel "Cancel"             pos:[72,80]   width:60 height:20
		local        created       = #()
		local        selected      = #()
		local        checkNonBones = true
		
		fn UnMirror =
		(
			with redraw off
			(
				for i = 1 to created.count do
				(
					delete created[i]
				)
				created.count = 0;
				select selected
			)
		)

		fn MirrorSelectedBones axisFactor flipZ offset =
		(
			-- define the bone structure that contains the bone and its level in the hierarchy
			struct BoneLevel (index, level)
			local bones     = #()

			-- fill the array of bone structures. intialize the hierarchy level with 0
			for i = 1 to selection.count do
			(
				bones[i] = BoneLevel i 0		
			)

			-- calculate the hierarchy level for each bone in bones array. the hierarchy level
			-- is the number of ancestors between the current bone and the root node
			for i = 1 to bones.count do
			(
				local node = selection[bones[i].index]
				local n    = 0
				do
				(
					n    = n + 1
					node = node.parent
				) while (node != undefined)
				bones[i].level = n
			)

			-- sort the bones array by the hierarchy level
			qsort bones (fn myLevel v1 v2 = (v1.level - v2.level))
		
			-- prepare the storage for the new bones and their parents
			local parents = #()
			local root    = selection[bones[1].index].transform.translation
			created.count = 0
			
			-- loop through the sorted selection so that the hierarchy is browsed from top to bottom
			for i = 1 to bones.count do
			(
				local original = selection[bones[i].index] 
				if (classof original != BoneGeometry) do -- not a real bone
				(
					append parents undefined --no parent will be assigned. undefined is added only to keep the numbering
					continue
				)

				-- take the start point, end point and the Z axis from the original bone				
				local boneStart  = original.pos
				local boneEnd    = getEndPoint original
				local boneZ      = original.dir
				
				-- apply mirroring to the start and end points
				for k = 1 to 3 do
				(
					if ( axisFactor[k] < 0 ) do
					(
					  boneStart [k] = 2.0*root[k] - boneStart[k] + offset
					  boneEnd   [k] = 2.0*root[k] - boneEnd  [k] + offset
					  boneZ     [k] = -boneZ[k]
					)
				)

				-- flip the bone's Z axis if the flipZ argument says so
				if ( flipZ ) do boneZ = -boneZ

				-- create the reflection of the original bone				
				local reflection              = bonesys.createbone boneStart boneEnd boneZ
				
				-- copy all applicable parameters from the original bone to the reflection
				reflection.backfin            = original.backfin
				reflection.backfinendtaper    = original.backfinendtaper
				reflection.backfinsize        = original.backfinsize 
				reflection.backfinstarttaper  = original.backfinstarttaper
				reflection.frontfin           = original.frontfin
				reflection.frontfinendtaper   = original.frontfinendtaper
				reflection.frontfinsize       = original.frontfinsize
				reflection.frontfinstarttaper = original.frontfinstarttaper
				reflection.height             = original.height
				reflection.name               = original.name + "(mirrored)"
				reflection.sidefins           = original.sidefins 
				reflection.sidefinsendtaper   = original.sidefinsendtaper
				reflection.sidefinssize       = original.sidefinssize
				reflection.sidefinsstarttaper = original.sidefinsstarttaper
				reflection.taper              = original.taper
				reflection.width              = original.width
				reflection.wirecolor          = original.wirecolor

				-- add the created bone to the lists				
				append parents reflection
				append created reflection
				
				-- begin parent assignment
				
				-- if there's no parent then do nothing and go to the next bone
				if ( original.parent == undefined ) do continue; 
			
				local parent = original.parent

				-- check if the parent is among selected nodes			
				if ( not parent.isSelected ) then
				( 
					reflection.parent = parent -- if isn't then let the original and the created one share the parent
				)
				else
				(  -- find the index of the parent and assign the appropriate parent from the list of created parents 
					for p = i-1 to 1 by -1 do
					(
						if ( parent == selection[bones[p].index] ) do
						(
							reflection.parent = parents[p]
							exit
						)
					)
				)
			)

			-- select the new bones			
			if ( created.count > 0 ) do
			(
				clearSelection();
				select created
			)
		)
		
		fn CallMirror u =
		(
			-- get the parameters from the dialog
			mirrorAxisValue   = mirrorAxis.state
			mirrorFlipValue   = mirrorFlip.state 
			mirrorOffsetValue = mirrorOffset.value
			
			if checkNonBones do
			(
				-- check whether all selected nodes are proper bones and display the warning if they aren't			
				for bone in selection do
				(
					if (classof bone != BoneGeometry) do 
					(
						goOn = queryBox "Proceed anyway?" title:"One or more of selected nodes are not bones"
						if ( not goOn ) then return undefined
						checkNonBones = false
					)
				)
			)
			
			-- set up the negating multipliers for the axis' components
			local axisFactor = [1,1,1]
			if (mirrorAxisValue<=2 or  mirrorAxisValue==6) do axisFactor.x = -1;
			if (mirrorAxisValue>=2 and mirrorAxisValue<=4) do axisFactor.y = -1;
			if (mirrorAxisValue>=4                       ) do axisFactor.z = -1;
			
			-- call the mirror function
			with redraw off
			(
				if u then
				(
					undo "Mirror" on
					(
						MirrorSelectedBones axisFactor (mirrorFlipValue==2) mirrorOffsetValue
					)
				)
				else 
				(
					MirrorSelectedBones axisFactor (mirrorFlipValue==2) mirrorOffsetValue
				)
			)
		)

		on BoneMirror open do
		(
			mirrorAxis.state   = mirrorAxisValue
			mirrorFlip.state   = mirrorFlipValue
			mirrorOffset.value = mirrorOffsetValue

			fristRun           = true			
			created.count      = 0
			selected.count     = 0			
			for i = 1 to selection.count do
			(
				selected[i] = selection[i]
			)
			
			CallMirror false
		)
		
		on mirrorAxis changed state do
		(
			UnMirror()
			CallMirror false
		)
		
		on mirrorFlip changed state do
		(
			UnMirror()
			CallMirror false
		)
		
		on mirrorOffset changed state do
		(
			UnMirror()
			CallMirror false
		)
		
		on mirrorOK pressed do
		(
			UnMirror()
			CallMirror true
			destroydialog BoneMirror
		)
			
		on mirrorCancel pressed do
		(
			UnMirror()
			destroydialog BoneMirror
		)
		
	)
	
	on Mirror_btn pressed do
	(	
		createdialog BoneMirror modal:true pos:mouse.screenpos
	)
	
	--------------------------------------------------------
	
	-- UpdateBoneUI called by redraw views callback. updateFlag will be true if an update is needed.
	fn UpdateTRUI  =
	(
		if BoneAdjustmentsFloater_updateTRFlag == true do -- explicitly test against true in case we are called before updateFlag is initialized
		(
			if (maxops.affectchildren == false) then BoneEdit_btn.state = true
			else BoneEdit_btn.state = false

			BoneAdjustmentsFloater_updateTRFlag = false
			case selection.count of
			(
				0 : (
					Bone_color_cp.enabled   	= false
					Gradient_btn.enabled    	= false
					start_color_cp.enabled  	= false
					end_color_cp.enabled    	= false
					ReassignRoot_btn.enabled 	= false		
					RemoveBone_btn.enabled 		= false	
					Mirror_btn.enabled 		    = false	
					CreateEnd_btn.enabled 		= false	
					DeleteBone_btn.enabled 		= false	
					ConnectBones_btn.enabled 	= false
					CreateBone_btn.checked   	= false
					)
				1 : (
				    local b                 = selection[1]
					local isBone            = (classOf b == BoneGeometry)

					ReassignRoot_btn.enabled 		= isBone  
					RemoveBone_btn.enabled 			= true	
					Mirror_btn.enabled 		        = isBone	
					CreateEnd_btn.enabled 			= isBone and (selection[1].children.count < 1)	
					DeleteBone_btn.enabled 			= true	
					ConnectBones_btn.enabled 		= isBone
					Bone_color_cp.enabled 	= true
					Bone_color_cp.color		= b.wirecolor
					Gradient_btn.enabled 	= false
					start_color_cp.enabled 	= false
					end_color_cp.enabled 	= false
					CreateBone_btn.checked 	= mcrUtils.IsCreating Bones
   				    createBoneTimer.active  = CreateBone_btn.checked

					--start_color_cp.color 	= b.wirecolor
					--end_color_cp.color 	= b.wirecolor							
					)
				default:
					(		
					ReassignRoot_btn.enabled 		= false		
					RemoveBone_btn.enabled 			= false	
					CreateEnd_btn.enabled 			= false	
					DeleteBone_btn.enabled 			= false	
					ConnectBones_btn.enabled 		= false			
					Mirror_btn.enabled 		        = true	
					Bone_color_cp.enabled 	= false
					Gradient_btn.enabled 	= true
					start_color_cp.enabled 	= true
					end_color_cp.enabled 	= true
					start_color_cp.color 	= selection[1].wirecolor
					end_color_cp.color 		= selection[selection.count].wirecolor
					CreateBone_btn.checked 	= mcrUtils.IsCreating Bones
 		    		createBoneTimer.active  = CreateBone_btn.checked
					) 
			)
		)
	)


	on ToolsRollout open do
	(
		ToolsRollout.open = toolsOpen
		-- callbacks to update the UI
		callbacks.addScript #selectionSetChanged "BoneAdjustmentsFloater_updateTRFlag = true" id:#agTRUpdate
		callbacks.addScript #sceneUndo "BoneAdjustmentsFloater_updateTRFlag = true" id:#agTRUpdate
		callbacks.addScript #sceneRedo "BoneAdjustmentsFloater_updateTRFlag = true" id:#agTRUpdate
		registerRedrawViewsCallback ToolsRollout.UpdateTRUI 
		BoneAdjustmentsFloater_updateTRFlag = true -- set to update rollout ui
		UpdateTRUI()
		
		-- callbacks to handle file reset/new/open
		callbacks.addscript #systemPreReset "if classof BoneAdjustmentsFloater == RolloutFloater then closerolloutfloater BoneAdjustmentsFloater" id:#agBATResetNewOpen
		callbacks.addscript #systemPreNew   "if classof BoneAdjustmentsFloater == RolloutFloater then closerolloutfloater BoneAdjustmentsFloater" id:#agBATResetNewOpen
		callbacks.addscript #filePreOpen    "if classof BoneAdjustmentsFloater == RolloutFloater then closerolloutfloater BoneAdjustmentsFloater" id:#agBATResetNewOpen
	)
	
	on ToolsRollout close do
	(	
		checked = false
	 	updateToolbarButtons() 
		toolsOpen = ToolsRollout.open
		SetINIConfigData iniFile "ToolsRollout" "Open" toolsOpen 

		unregisterRedrawViewsCallback ToolsRollout.UpdateTRUI 
		callbacks.removeScripts id:#agTRUpdate -- remove by id
		callbacks.removeScripts id:#agBATResetNewOpen -- remove by id
		
		if ( boneEditModeTurnedOnByMe == true ) do --mike.ts 2003.03.10
		(
			boneEditModeTurnedOnByMe = false;
			maxops.affectchildren    = true   
		)
	)	
)

on execute do	
(

    if isMacroRecorderEnabled() do format "\n" to:MacroRecorder

    -- clear old callbacks if present
    if classof BoneAdjustmentsFloater == RolloutFloater do 
    (	
    	unregisterRedrawViewsCallback ObjectPropsRollout.UpdateOPRUI
    	callbacks.removeScripts id:#agOPRUpdate  -- remove by id
    	
    	unregisterRedrawViewsCallback BoneAdjustmentsFloater_FinToolsRollout.UpdateFTRUI
    	callbacks.removeScripts id:#agFTRUpdate  -- remove by id
    
    	unregisterRedrawViewsCallback ToolsRollout.UpdateTRUI
    	callbacks.removeScripts id:#agTRUpdate  -- remove by id
    
    )
    
	-- create the rollout window and add the  rollout
	try
	(
		--cui.unregisterDialogBar BoneAdjustmentsFloater
		bafSize = BoneAdjustmentsFloater.size
		bafPos  = BoneAdjustmentsFloater.pos
		
		SetINIConfigData iniFile "Dialog" "Left"   bafPos.x 
		SetINIConfigData iniFile "Dialog" "Top"    bafPos.y 
		SetINIConfigData iniFile "Dialog" "Width"  bafSize.x 
		SetINIConfigData iniFile "Dialog" "Height" bafSize.y 
		
		closerolloutfloater BoneAdjustmentsFloater
	)
	catch()
	
	bafPos.x  = GetINIConfigData iniFile "Dialog" "Left"    40  
	bafPos.y  = GetINIConfigData iniFile "Dialog" "Top"    139
	bafSize.x = GetINIConfigData iniFile "Dialog" "Width"  225
	bafSize.y = GetINIConfigData iniFile "Dialog" "Height" 518
	
	BoneAdjustmentsFloater= newRolloutFloater "Bone Tools"  bafSize.x bafSize.y bafPos.x bafPos.y
	
	checked = true
	
	toolsOpen = GetINIConfigData iniFile "ToolsRollout"       "Open" true
	finsOpen  = GetINIConfigData iniFile "FinToolsRollout"    "Open" false
	objOpen   = GetINIConfigData iniFile "ObjectPropsRollout" "Open" false
	
	-- add the three subgroup rollouts
	addRollout 	ToolsRollout		BoneAdjustmentsFloater 
	addRollout 	BoneAdjustmentsFloater_FinToolsRollout		BoneAdjustmentsFloater
	addRollout 	ObjectPropsRollout	BoneAdjustmentsFloater
	
	-- temporarily disable docking functionality
	--cui.registerDialogBar BoneAdjustmentsFloater
	
	-- **************************************************************************
	-- this should be added when you detect a single bone selection on the FIN rollout
	-- things to worry about:
	-- name this function something standard for the script
	
	-- deleteChangeHandler abc -- called right before the new callback and on rollout close
	-- abc = when parameters selection[1] change handleAt:#redrawViews id:#testWhen do print "Hi"
	-- **************************************************************************
)
on closeDialogs do
	(
		checked = false
		try
		(
			--cui.unregisterDialogBar BoneAdjustmentsFloater
			bafSize = BoneAdjustmentsFloater.size
			bafPos  = BoneAdjustmentsFloater.pos
			
			SetINIConfigData iniFile "Dialog" "Left"   bafPos.x 
			SetINIConfigData iniFile "Dialog" "Top"    bafPos.y 
			SetINIConfigData iniFile "Dialog" "Width"  bafSize.x 
			SetINIConfigData iniFile "Dialog" "Height" bafSize.y 
			
			closerolloutfloater BoneAdjustmentsFloater
		)
		catch()
	)
on isChecked return (checked)
)