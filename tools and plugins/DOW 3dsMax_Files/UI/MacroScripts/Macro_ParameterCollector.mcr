-- Macro Scripts File
-- Created:  Jan 12 2004
-- Author:   Michael Russo
-- Macro Scripts for Parameter Collector
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript ParamCollectorShow
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Parameter Collector"
	ButtonText:"Parameter Collector" 
(
	On Execute Do     
	(
		Try (
			if ParamCollectorOps.visible != undefined do ParamCollectorOps.visible = true 
		)
		Catch() 
	)

	on closeDialogs do
	(
		Try (
			if ParamCollectorOps.visible != undefined do ParamCollectorOps.visible = false 
		)
		Catch() 
	)

	on isChecked Do
	(
		if ParamCollectorOps.visible == undefined then false
		else ParamCollectorOps.visible
	)

)

macroScript ParamCollectorTrackView
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Collect Parameters TV"
	ButtonText:"Collect Parameters TV" 
(
	On Execute Do	
	(
 		if trackviews.current != undefined do  (
 		
			if (not ParamCollectorOps.visible) do ParamCollectorOps.visible = true
			
 			--trackviews.current.updatelist()
 			local iCount = trackviews.current.numSelTracks()
 			local anims = #()
 			local subs = #()
			for i = 1 to iCount do
			(
				local anim = trackviews.current.getParentOfSelected i
				if anim != undefined do (
					local subnum = trackviews.current.getSelectedSubNum i
					append anims anim
					append subs subnum
				)
			)
			for i = 1 to anims.count do (
				ParamCollectorOps.addParameterBySubNum anims[i] subs[i] 0 0 ""			
			) 
			ParamCollectorOps.refresh()
		)
	)

	on isEnabled do
	(
		trackviews.current != undefined and trackviews.current.numSelTracks() > 0
	)
)



macroScript ParamCollectorSchematicView
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Collect Parameters SV"
	ButtonText:"Collect Parameters SV" 
(
	On Execute Do	
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if (not ParamCollectorOps.visible) do ParamCollectorOps.visible = true

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			for i in selList do (
				local anim = sv.getSVNodeOwner i
				local subnum = sv.getSVNodeAnimID i
				ParamCollectorOps.addParameterBySubNum anim (subnum+1) 0 0 ""
			)

			ParamCollectorOps.refresh()

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if schematicViews.current != undefined then 
		(
			local selList = schematicViews.current.getSelectedSVNodes()	
			selList.Count > 0
		)
		else
		(
			false
		)
	)
)

macroScript ParamCollectorNewCollection
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"New Collection"
	ButtonText:"New Collection" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.NewCollection() )
		Catch() 
	)
	
	On isEnabled return (ParamCollectorOps.GetActiveCollection() > 1 )
)

macroScript ParamCollectorDuplicateCollection
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Duplicate Collection"
	ButtonText:"Duplicate Collection" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.DuplicateCollection() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.GetActiveCollection() > 1)
)

macroScript ParamCollectorDeleteCollection
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete Collection"
	ButtonText:"Delete Collection" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.DeleteCollection() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.GetActiveCollection() > 1)
)


macroScript ParamCollectorMultiEdits
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Multiple Edits"
	ButtonText:"Multiple Edits" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.multiedits = not ParamCollectorOps.multiedits )
		Catch() 
	)

	on isChecked return (ParamCollectorOps.multiedits)
--	On isEnabled return (ParamCollectorOps.AnySelected())	
)

macroScript ParamCollectorAbsolute
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Absolute"
	ButtonText:"Absolute" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.isAbsolute = true )
		Catch() 
	)

	on isChecked return (ParamCollectorOps.isAbsolute)
)

macroScript ParamCollectorRelative
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Relative"
	ButtonText:"Relative" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.isAbsolute = false )
		Catch() 
	)

	on isChecked return (not ParamCollectorOps.isAbsolute)
)

macroScript ParamCollectorAddToSelected
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Add to Selected"
	ButtonText:"Add to Selected" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doAddToSelectedDialog() )
		Catch() 
	)
	
	On isEnabled return (ParamCollectorOps.IsRolloutSelected())
)

macroScript ParamCollectorAdd
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Add"
	ButtonText:"Add" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doAddDialog() )
		Catch() 
	)
)

macroScript ParamCollectorDeleteSelected
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete Selected"
	ButtonText:"Delete Selected" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.deleteSelectedParameters() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorDeleteAll
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete All"
	ButtonText:"Delete All" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.deleteAllParameters() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnyRollouts())
)

macroScript ParamCollectorNewRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"New Rollout"
	ButtonText:"New Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.addNewRollout "" false)
		Catch() 
	)
)

macroScript ParamCollectorNewRolloutWithSelected
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"New Rollout Selected Parameters"
	ButtonText:"New Rollout Selected Parameters" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.addNewRollout "" true)
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorDeleteRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete Rollout"
	ButtonText:"Delete Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.deleteRollout -1 )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.IsRolloutSelected())
)

macroScript ParamCollectorDeleteRolloutMoveUp
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete Rollout Move Up"
	ButtonText:"Delete Rollout Move Up" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.deleteRolloutMoveUp -1 )
		Catch() 
	)
	On isEnabled Do
	(
		if (ParamCollectorOps.IsRolloutSelected()) then 
		(
			local iRolloutIndex = ParamCollectorOps.getSelectedRollout()
			(iRolloutIndex > 1)
		)
		else
			false
	)
)

macroScript ParamCollectorDeleteRolloutMoveDown
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Delete Rollout Move Down"
	ButtonText:"Delete Rollout Move Down" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.deleteRolloutMoveDown -1 )
		Catch() 
	)
	On isEnabled Do
	(
		if (ParamCollectorOps.IsRolloutSelected()) then
		(
			local iCollection = ParamCollectorOps.GetActiveCollection()
			local iNumRollouts = ParamCollectorOps.numRollouts iCollection
			local iRolloutIndex = ParamCollectorOps.getSelectedRollout()
			(iRolloutIndex < iNumRollouts)
		)
		else
			false
	)
)

macroScript ParamCollectorPutToObject
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Put to Object"
	ButtonText:"Put to Object" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doPutToObjectDialog() )
		Catch() 
	)
)

macroScript ParamCollectorGetFromObject
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Get from Object"
	ButtonText:"Get from Object" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doGetFromObjectDialog() )
		Catch() 
	)
)

macroScript ParamCollectorRemoveFromObject
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Remove from Object"
	ButtonText:"Remove from Object" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doRemoveFromObjectDialog() )
		Catch() 
	)
)

macroScript ParamCollectorLinkToObject
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Link to Object"
	ButtonText:"Link to Object" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doLinkToObjectDialog() )
		Catch() 
	)
)

macroScript ParamCollectorRemoveLinkToObject
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Remove Link To Object"
	ButtonText:"Remove Link To Object" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.RemoveLinkToObject() )
		Catch() 
	)
)

macroScript ParamCollectorRenameRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Rename Rollout"
	ButtonText:"Rename Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doRenameRolloutDialog() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.IsRolloutSelected())
)

macroScript ParamCollectorMoveParamsUp
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Move Parameters Up"
	ButtonText:"Move Parameters Up" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.moveSelectedParameters #moveUp )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorMoveParamsDown
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Move Parameters Down"
	ButtonText:"Move Parameters Down" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.moveSelectedParameters #moveDown )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorMoveParamsUpRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Move Parameters Up by Rollout"
	ButtonText:"Move Parameters Up by Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.moveSelectedParameters #moveUpRollout )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorMoveParamsDownRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Move Parameters Down by Rollout"
	ButtonText:"Move Parameters Down by Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.moveSelectedParameters #moveDownRollout )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)


macroScript ParamCollectorSelectAll
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Select All"
	ButtonText:"Select All" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.selectAll() )
		Catch() 
	)
	On isEnabled do 
	(
		if (ParamCollectorOps.AnyParameters()) then
		(
			local iCollection = ParamCollectorOps.getActiveCollection()
			local iNumParams = ParamCollectorOps.getNumParametersInCollection iCollection
			local iNumSel = ParamCollectorOps.numSelected()
			(iNumParams != iNumSel)
		)
		else
			false
	)
)

macroScript ParamCollectorSelectAllRollout
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Select All Rollout"
	ButtonText:"Select All Rollout" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.selectAllRollout() )
		Catch() 
	)
	On isEnabled do
	(
		if (ParamCollectorOps.IsRolloutSelected()) then
		(
			local iCollection = ParamCollectorOps.getActiveCollection()
			local iSelRollout = ParamCollectorOps.getSelectedRollout()
			local iNumParams = ParamCollectorOps.getNumParameters iCollection iSelRollout
			local iNumSel = ParamCollectorOps.getNumSelectedParameters iCollection iSelRollout
			(iNumParams != iNumSel) 
		)
		else
			false
	)
)

macroScript ParamCollectorSelectNone
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Select None"
	ButtonText:"Select None" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.selectNone() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorSelectInvert
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Select Invert"
	ButtonText:"Select Invert" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.selectInvert() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnyParameters())	
)

macroScript ParamCollectorShowTBKeys
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Show Keys in Track Bar"
	ButtonText:"Show Keys in Track Bar" 
(
	On Execute Do	
	(
		Try( 
			if ParamCollectorOps.hideOtherKeys then (
				ParamCollectorOps.showTrackBarKeys = true
				ParamCollectorOps.hideOtherKeys = false
			)
			else (
				ParamCollectorOps.showTrackBarKeys = not ParamCollectorOps.showTrackBarKeys 
			)
		)
		Catch() 
	)

	on isChecked return (ParamCollectorOps.showTrackBarKeys and (not ParamCollectorOps.hideOtherKeys))
)

macroScript ParamCollectorShowTBSelectedKeys
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Show Selected Keys in Track Bar"
	ButtonText:"Show Selected Keys in Track Bar" 
(
	On Execute Do	
	(
		Try( 
			if ParamCollectorOps.hideOtherKeys then (
				ParamCollectorOps.showTrackBarSelectedKeys = true
				ParamCollectorOps.hideOtherKeys = false
			)
			else (
				ParamCollectorOps.showTrackBarSelectedKeys = not ParamCollectorOps.showTrackBarSelectedKeys 
			)
		)
		Catch() 
	)

	on isChecked return (ParamCollectorOps.showTrackBarSelectedKeys and (not ParamCollectorOps.hideOtherKeys))
)

macroScript ParamCollectorIsolateTBKeys
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Isolate Keys in Track Bar"
	ButtonText:"Isolate Keys in Track Bar" 
(
	On Execute Do	
	(
		Try( 
			if not ParamCollectorOps.hideOtherKeys then (
				ParamCollectorOps.showTrackBarKeys = true
				ParamCollectorOps.hideOtherKeys = true
			)
			else (
				ParamCollectorOps.showTrackBarKeys = not ParamCollectorOps.showTrackBarKeys 
			)
		)
		Catch() 
	)

	on isChecked return (ParamCollectorOps.showTrackBarKeys and ParamCollectorOps.hideOtherKeys)
)

macroScript ParamCollectorIsolateTBSelectedKeys
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Isolate Selected Keys in Track Bar"
	ButtonText:"Isolate Selected Keys in Track Bar" 
(
	On Execute Do	
	(
		Try( 
			if not ParamCollectorOps.hideOtherKeys then (
				ParamCollectorOps.showTrackBarSelectedKeys = true
				ParamCollectorOps.hideOtherKeys = true
			)
			else (
				ParamCollectorOps.showTrackBarSelectedKeys = not ParamCollectorOps.showTrackBarSelectedKeys 
			)
		)
		Catch() 
	)

	on isChecked return (ParamCollectorOps.showTrackBarSelectedKeys and ParamCollectorOps.hideOtherKeys)
)

macroScript ParamCollectorEditNotes
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Edit Notes"
	ButtonText:"Edit Notes" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.doEditNotesDialog() )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)

macroScript ParamCollectorKeyAll
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Key All"
	ButtonText:"Key All" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.keyParameters false )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnyParameters() and animButtonState)
)

macroScript ParamCollectorKeySelected
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Key Selected"
	ButtonText:"Key Selected" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.keyParameters true )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected() and animButtonState)
)

macroScript ParamCollectorResetAll
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Reset All"
	ButtonText:"Reset All" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.resetParameters false )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnyParameters())
)

macroScript ParamCollectorResetSelected
	category:"Parameter Collector" 
	internalCategory:"Parameter Collector" 
	tooltip:"Reset Selected"
	ButtonText:"Reset Selected" 
(
	On Execute Do	
	(
		Try( ParamCollectorOps.resetParameters true )
		Catch() 
	)
	On isEnabled return (ParamCollectorOps.AnySelected())
)
