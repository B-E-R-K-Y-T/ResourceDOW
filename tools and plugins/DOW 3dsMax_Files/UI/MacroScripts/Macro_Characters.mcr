/*
-------------------------------------------------------------------------------------------
Macros for character assembly scripted plugin
By:Ravi Karra [Discreet] - ravi.karra@autodesk.com

Created:11/26/01

Revision History:

	07/24/03 - aszabo
		Removed code from createCharacters that was added to compensate for a problem in the group creation code
	
 	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
		moved the Macro_InitialPose.mcr inside this tool

 
--***********************************************************************************************
*/
macroScript CreateCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Create a Character"
ButtonText:"Create Character"

(
	fn createCharacter nodes =
	(
		animate off
		(
			local chr = assemblyMgr.assemble nodes name:(uniqueName "Character") classDesc:CharacterAssembly
			chr.assemblyBBoxDisplay = false
			chr.wirecolor = (colorMan.getColor #chr_color)*255			
		)
		chr
	)
	
	rollout rSkippedCharacterNodes "Character Error"
	(
		--label lbl "The following list of objects are parented to objects \noutside of the current selection and cannot be \nincluded as members of this character." offset:[190,0] align:#center height:40
		label lbl "A character assembly cannot be created since more than \none object is parented to objects outside of current selection."  offset:[140,0] height:35
		listBox lbSkipped "Error Nodes:" align:#center items:#() height:10
		button btnOK "Ok" width:40 height:20
		
		on rSkippedCharacterNodes open do
		(
			rSkippedCharacterNodes.lbSkipped.items = g_skipped_nodes
		)
		on lbSkipped selected idx do
		(
			select ( getNodeByName g_skipped_nodes[idx])
		)	
		on btnOK pressed do destroyDialog rSkippedCharacterNodes
	)
	
	on execute do
	(		
		local obj_array = selection as array
		if assemblyMgr.canAssemble selection then	

		(
			undo "Destroy Character" on 
			(
				local chr = createCharacter obj_array
				if chr != undefined then
				(
					assemblyMgr.open chr
					select chr
				)
			)
		)
		else
		(
			undo off
			(
				g_skipped_nodes = #()
				
				for obj in obj_array do
					if obj.parent != undefined and (findItem obj_array obj.parent) == 0 then				
						append g_skipped_nodes obj.name
				createDialog rSkippedCharacterNodes width:300 height:250 modal:true
				select obj_array
			)
		)

		
	)
	on isEnabled do (selection.count > 0 /*and (assemblyMgr.canAssemble selection)*/)
)


macroScript DestroyCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Destroy Character"
ButtonText:"Destroy Character"
(
	on execute do
	(
		undo "Destroy Character" on 
		(
			if (assemblyMgr.canClose selection) then
				max delete
			else
				assemblyMgr.disassemble selection
		)
	)
	on isEnabled do (selection.count == 1 and ((assemblyMgr.canDisassemble selection) or ((isGroupHead $) and (assemblyMgr.canClose selection))))
)

macroScript LockCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Lock a Character"
ButtonText:"Lock"
(
	on execute do
	(
		undo "Lock a Character" on
		(
			assemblyMgr.close selection select:false
		)
	)
	on isEnabled do (selection.count > 0 and (assemblyMgr.canClose selection))
)

macroScript UnLockCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Unlock a Character"
ButtonText:"Unlock"
(
	on execute do
	(
		undo "UnLock Character" on
		(		
			assemblyMgr.open selection
		)
	)
	on isEnabled do (selection.count > 0 and (assemblyMgr.canOpen selection))
)

macroScript InsertCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Insert a Character"
ButtonText:"Insert Character..."
(
	on execute do
	(
		local seed = pathConfig.getDir #animations + "\\"
		local f = getOpenFileName filename:seed types:"3ds Max Characters (*.chr)|*.chr|All (*.*)|*.*|"
		if f != undefined then
		(
			undo off
			(
				mergeMaxFile f #mergeDups #select #promptDups
			)
		)		
	)
--	on isEnabled do (selection.count > 0)
)

macroScript SaveCharacter
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Characters"
internalCategory:"Characters"
tooltip:"Save a Character"
ButtonText:"Save Character..."
(
	fn getGroupHead objs = 
	(
		local result = undefined
		for ob in objs where keepgoing == true do 
		(
			if ob.assemblyHead do 
			(
				result = ob
				keepgoing = false
			)
		)
		result
	)
	on execute do
	(
		undo off
		(
			local objs = selection as array
			local f = getSaveFileName types:"3ds Max Characters (*.chr)|*.chr|All (*.*)|*.*|"
			if f != undefined then
			(
				redrawOff
				(
					g_suspendCharacterRedraw = true
					local head = (getGroupHead objs)
					local parentNode = head.parent
					head.parent = undefined
					local locked = assemblyMgr.canOpen head
					if not locked then assemblyMgr.close head --select:true
					select head		
					saveNodes selection f
					format "character locked:%\n" locked
					if not locked then assemblyMgr.open head clearSelection:false
					head.parent = parentNode
					g_suspendCharacterRedraw = false
					select objs
				)
			)
		)
	)
	on isEnabled do (
		(selection.count == 1 and (classof selection[1]) == CharacterAssembly) or
		(selection.count > 1 and (classof (getGroupHead selection)) == CharacterAssembly)
	)
)--end macro

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
/*
SkinPose Macros

--
-- Created: January 4, 2002
-- Last Updated: January 4, 2002
--
-- Author : Jianmin Zhao
-- Version:  3ds max 5
--
-- Loop over selected objects and apply setSkinPose(), assumeSkinPose(),
-- and toggle skinPoseMode.
--

*/
macroScript SetSkinPose
enabledIn:#("max") --pfb: 2003.12.11 added product switch

            ButtonText:"Set as Skin Pose"
            category:"Characters"
            internalCategory:"Characters"
            Tooltip:"Set Skin Pose" 
(

	On Execute Do (
		local res = queryBox "Do you really want to Set the Skin Pose ?" title:"Character"
		if res then
		(	
			undo "Set as Skin Pose" on
			(
				for s in Selection do
				(
					s.setSkinPose()
					if (classof s == CharacterAssembly) do for c in s.children do
						(
							c.setSkinPose()
						)
				)	
			)
			redrawViews()
		)
	)

)--end macros

macroScript AssumeSkinPose
enabledIn:#("max") --pfb: 2003.12.11 added product switch

            ButtonText:"Assume Skin Pose"
            category:"Characters"
            internalCategory:"Characters"
            Tooltip:"Assume Skin Pose" 
(

	On Execute Do
	(	
		undo "Assume Skin Pose" on
		(
			for s in Selection do
			(
				s.assumeSkinPose()
				if (classof s == CharacterAssembly) do for c in s.children do
					(
						c.assumeSkinPose()
					)
			)				
		)
		redrawViews()			
	)	
)--end macro

macroScript SkinPoseMode
enabledIn:#("max") --pfb: 2003.12.11 added product switch
            ButtonText:"Skin Pose Mode"
            category:"Characters"
            internalCategory:"Characters"
            Tooltip:"Skin Pose Mode, On/Off Toggle" 
(
	local determinate = false
	local checked = false
	Fn checkState =
	(
		checked = false
		determinate = false
		local first = false;
		local obj_array = selection as array
		for s in selection do if (classof s == CharacterAssembly) then
			join obj_array s.children
		for i in obj_array do (
			if first then (
				local x = i.SkinPoseMode
				if checked then (
					if (not x) then determinate = false
				) else (
					if x then determinate = false
				)
			) else (
				first = true
				checked = i.skinPoseMode
				determinate = true
			)
		)
		
		Return checked
	)

	On isChecked Return checkState()

	On isEnabled Return determinate

	On Execute Do (
		local obj_array = selection as array
		for s in selection do if (classof s == CharacterAssembly) then
			join obj_array s.children

		if selection.count == 1 and (classof $ == CharacterAssembly) and (GetCommandPanelTaskMode() == #modify) and 
		   (g_characterTimer != undefined) then
			g_characterTimer.active = true
			
		For i In obj_array Do
			i.skinPoseMode = not checked

		redrawViews()			
	)
)--end macro


