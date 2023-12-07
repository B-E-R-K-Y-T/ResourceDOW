/*
EditPoly Operations MacroScript File

Created:  		Aug 19 2000
Revision History: 	
	
	Feb 25, 2002, by Steve Anderson - heavily reorganized.
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products

	28 May 2004, Steve Anderson
		Added support for Edit Poly modifier to most scripts.

EditPoly operations Macroscript file.

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--

-- *******************************************************************
--  Poly Ops: Selection
-- *******************************************************************

MacroScript EPoly_Shrink
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Shrink"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Shrink Selection (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			A.buttonOp #ShrinkSelection
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Grow
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Grow"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Grow Selection (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			A.buttonOp #GrowSelection
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Select_Loop
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Select Loop"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Select Loop (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..4}

	On Execute Do (
		Try (
			if subobjectlevel == undefined then max modify mode
			local A = Filters.GetModOrObj()
			A.buttonOp #SelectEdgeLoop
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Select_Ring
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Select Ring"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Select Ring (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..4}

	On Execute Do (
		Try (
			if subobjectlevel == undefined then max modify mode
			local A = Filters.GetModOrObj()
			A.buttonOp #SelectEdgeRing
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
--  Poly Ops: Edit Geometry
-- *******************************************************************

MacroScript EPoly_Repeat_Last
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Repeat"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Repeat Last (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do
	(
		Try (
			local A = Filters.GetModOrObj()
			A.RepeatLastOperation ()
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Collapse
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Collapse"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Collapse (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectLevel == 1) then (A.ButtonOp #CollapseVertex)
				else if (subobjectLevel>1) and (subobjectLevel<4) then (A.ButtonOp #CollapseEdge)
				else if (subobjectLevel>3) then (A.ButtonOp #CollapseFace)
			)
			else (A.buttonOp #Collapse)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Attach
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Attach"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Attach (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		local A = Filters.GetModOrObj()
		(Filters.Is_This_EditPolyMod A) and (A.GetPickMode() == #Attach)
	)

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		local A = Filters.GetModOrObj()
		A.enterPickMode #Attach
	)
	
	On AltExecute type Do (
		if subobjectlevel == undefined then max modify mode
		local A = Filters.GetModOrObj()
		if (Filters.Is_This_EditPolyObj A) then (A.buttonOp #AttachList)
		else (A.PopupDialog #Attach)
	)
)

MacroScript EPoly_Detach
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Detach"
Category:"Editable Polygon Object"
internalCategory:"Editable Polygon Object"
Tooltip:"Detach (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do
	(
		Try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyObj A) then (
				if (A.GetMeshSelLevel() != #Object) then $.EditablePoly.buttonOp #Detach
			) else (
				if (subobjectlevel == 1) then (A.PopupDialog #DetachVertex)
				else if (subobjectLevel > 1) then (A.PopupDialog #DetachFace)
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_SlicePlane
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Slice Plane"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Slice Plane (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..6}
	On IsChecked Return Filters.Is_EPoly_SliceMode()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #SlicePlane
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Slice
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Slice"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Slice (Poly)" 
-- Needs Icon
(
	On IsEnabled Return (Filters.Is_EPoly_SliceMode())
	On IsVisible Return (Filters.Is_EPoly_SliceMode())

	On Execute Do (
		Try	(
			local A = Filters.GetModOrObj()
			if (A.inSlicePlaneMode ()) then (
				if (Filters.Is_This_EditPolyMod A) then (A.CommitAndRepeat())
				else (A.buttonOp #Slice)
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_resetPlane
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Reset Plane"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Reset Plane (Poly)" 
-- Needs Icon
(
	On IsEnabled Return (Filters.Is_EPoly_SliceMode())
	On IsVisible Return (Filters.Is_EPoly_SliceMode())

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.buttonOp #ResetSlicePlane
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Quickslice
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Quickslice"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Quickslice (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#Quickslice)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.ToggleCommandMode #Quickslice
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Cut
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Cut"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Cut (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#Cut)
		)
		catch ( false )
	)


	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then (A.ToggleCommandMode #Cut)
			else (A.toggleCommandMode #CutVertex)	-- (Really a general Cut mode.)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Meshsmooth
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Meshsmooth"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Meshsmooth (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #MeshSmooth
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type Do (
		Try (
			local A = Filters.GetModOrObj()
			A.popupDialog #MeshSmooth
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Tessellate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Tessellate"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Tessellate (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #Tessellate
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type Do (
		Try (
			local A = Filters.GetModOrObj()
			A.popupDialog #Tessellate
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Make_Planar
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Make Planar"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Make Planar (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object

	On Execute Do (
		If SubObjectLevel == undefined then Max Modify Mode
		Try (
			local A = Filters.GetModOrObj()
			A.buttonOp #MakePlanar
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_View_Align
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"View Align"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"View Align (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			A.buttonOp #AlignView
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_Grid_Align
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Grid Align"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Grid Align (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			A.buttonOp #AlignGrid
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Hide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hide"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Hide (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try(
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #HideVertex
				else A.ButtonOp #HideFace
			)
			else A.buttonOp #HideSelection
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_Hide_Unselected
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hide Unselected"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Hide Unselected (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try(
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #HideUnselectedVertex
				else A.ButtonOp #HideUnselectedFace
			)
			else A.buttonOp #HideUnselected
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_UnHide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unhide All"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Unhide All (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #UnhideAllVertex
				else A.ButtonOp #UnhideAllFace
			)
			else A.buttonOp #UnhideAll
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)


-- *******************************************************************
--  Poly Ops:  Generalized versions of SO-specific operations
--             This section lets users simply call "Extrude",
--			   "Chamfer", etc, and it uses the current SO mode.
-- *******************************************************************

MacroScript EPoly_Create
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				local mode = A.GetCommandMode
				(mode == #CreateVertex) or (mode == #CreateEdge) or (mode == #CreateFace)
			)
			else false
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			local msl = A.GetMeshSelLevel ()
			if msl == #vertex then (A.toggleCommandMode #CreateVertex)
			else (
				if msl == #edge then (A.toggleCommandMode #CreateEdge)
				else (A.toggleCommandMode #CreateFace)
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Remove
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Remove"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Remove (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..3}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..3}

	On Execute Do (
		try (
			if subobjectlevel == undefined then max modify mode
			local A = Filters.GetModOrObj()
			if ((subobjectLevel==1) or (subobjectLevel==2)) then (
				if (Filters.Is_This_EditPolyMod A) then
				(
					if (subobjectLevel == 1) then A.ButtonOp #RemoveVertex
					else A.ButtonOp #RemoveEdge
				)
				else A.buttonOp #Remove
			) else (
				-- Put us in a suitable SO level
				subobjectLevel = 2
			)
		)
		catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_InsertVertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Insert Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Insert Vertex (Poly)" 
-- Needs Icon
(
	-- Active in Edge, Border, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..6}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				local mode = A.GetCommandMode()
				(mode == #DivideEdge) or (mode == #DivideFace)
			)
			else false
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			-- default to Edge:
			if subobjectLevel < 2 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			msl = A.GetMeshSelLevel ()
			if msl == #Edge then (A.toggleCommandMode #DivideEdge)
			if msl == #Face then (A.toggleCommandMode #DivideFace)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Extrude
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude (Poly)" 
-- Needs Icon
(
	-- Active in any SO level:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..5}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				local mode = A.GetCommandMode()
				(mode == #ExtrudeVertex) or (mode == #ExtrudeEdge) or (mode == #ExtrudeFace)
			)
			else false
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			-- default to Face level:
			if subobjectLevel == 0 then subobjectLevel = 4
			if subobjectLevel == 5 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			msl = A.GetMeshSelLevel ()
			if msl == #vertex then (A.toggleCommandMode #ExtrudeVertex)
			if msl == #edge then (A.toggleCommandMode #ExtrudeEdge)
			if msl == #face then (A.toggleCommandMode #ExtrudeFace)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			-- default to Face level:
			if subobjectLevel == 0 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				local level = A.GetMeshSelLevel()
				if (level == #Vertex) then (A.PopupDialog #ExtrudeVertex)
				else if (level == #Edge) then (A.PopupDialog #ExtrudeEdge)
				else if (level == #Face) then (A.PopupDialog #ExtrudeFace)
			)
			else (A.popupDialog #Extrude)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Chamfer
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Chamfer"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Chamfer (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge, Border levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..4}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				local mode = A.GetCommandMode()
				(mode == #ChamferVertex) or (mode == #ChamferEdge)
			)
			else false
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			-- default to Edge level:
			if subobjectLevel > 3 then subobjectLevel = 2
			if subobjectLevel == 0 then subobjectLevel = 2
			if subobjectLevel == 1 then (A.toggleCommandMode #ChamferVertex)
			else (A.toggleCommandMode #ChamferEdge)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			-- default to Edge level:
			if subobjectLevel > 3 then subobjectLevel = 2
			if subobjectLevel == 0 then subobjectLevel = 2
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectLevel == 1) then (A.PopupDialog #ChamferVertex)
				else (A.PopupDialog #ChamferEdge)
			)
			else (A.popupDialog #Chamfer)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Weld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Weld"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Weld (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..3}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..3}

	On Execute Do (
		Try (
			if subobjectlevel == undefined then max modify mode
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then 
			(
				if (subobjectLevel == 1) then A.ButtonOp #WeldVertex
				else A.buttonOp #WeldEdge
			)
			else A.buttonOp #WeldSelected
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then
			(
				if (subobjectLevel == 1) then A.PopupDialog #WeldVertex
				else A.popupDialog #WeldEdge
			)
			else A.popupDialog #WeldSelected
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_TargetWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Target Weld"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Target Weld (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..3}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..3}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #Weld)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined do (Max Modify Mode)
			local A = Filters.GetModOrObj ()
			A.toggleCommandMode #Weld
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Target Weld")
	)
)

-- We need two versions of this Connect macro, even though we really want one,
-- because the edge level has an altExecute method and the vertex level doesn't.
-- There's no way as yet to suppress the altExecute icon in vertex level.
-- (Should be something like On IsAltVisible...)

MacroScript EPoly_Connect
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Connect"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Connect (no dialog) (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge, levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2}

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		local A = Filters.GetModOrObj()
		A.buttonOp #ConnectVertices
	)
)

MacroScript EPoly_Connect2
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Connect"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Connect (with dialog) (Poly)" 
-- Needs Icon
(
	-- Active in Vertex, Edge levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3}

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		local A = Filters.GetModOrObj()
		A.buttonOp #ConnectEdges
	)

	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.popupDialog #ConnectEdges
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
--  Poly Ops:  Vertex specific stuff
-- *******************************************************************

MacroScript EPoly_Break
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Break"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Break (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.buttonOp #BreakVertex
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_RemoveIsolatedVerts
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Isolated Vertices"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Remove Isolated Vertices (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.buttonOp #RemoveIsoVerts
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_RemoveIsolatedMapVerts
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Unused Map Vertices"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Remove Unused Map Vertices (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.buttonOp #RemoveIsoMapVerts
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)


-- *******************************************************************
-- Poly Ops:  Edit Edges
-- *******************************************************************

MacroScript EPoly_Split
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Split"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Split (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 2 then subobjectlevel = 2
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #SplitEdges
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_ShapeFromEdges
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Shape"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create Shape (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..4}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then (A.PopupDialog #CreateShape)
			else (A.buttonOp #CreateShape)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
-- Poly Ops:  Border specific stuff
-- *******************************************************************

MacroScript EPoly_Cap
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Cap"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Cap (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{4}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.buttonOp #Cap
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
--  Poly Ops: Face specific stuff
-- *******************************************************************

MacroScript EPoly_Bevel
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bevel"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Bevel (Poly)" 
-- Needs Icon(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #Bevel)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #Bevel
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.popupDialog #Bevel
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Outline
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Outline"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Outline (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #OutlineFace)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #OutlineFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.popupDialog #Outline
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Inset
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Inset"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Inset (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #InsetFace)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #InsetFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.popupDialog #Inset
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Retriangulate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Retriangulate"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Retriangulate (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5..6}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel < 4 then subobjectlevel = 4
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #Retriangulate
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Flip
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Flip Normals"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Flip Normals (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5..6}

	On Execute Do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		-- default to Element level here:
		If SubObjectLevel < 4 then SubObjectLevel = 5
		else (
			Try(
				local A = Filters.GetModOrObj()
				if (Filters.Is_This_EditPolyMod A) then
				(
					if (subobjectLevel == 4) then A.buttonOp #FlipFace
					else A.ButtonOp #FlipElement
				)
				else A.buttonOp #FlipNormals
			)
			Catch(MessageBox "Operation Failed" Title:"Poly Editing")
		)
	)

)

MacroScript EPoly_Hinge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hinge from Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Hinge from Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #HingeFromEdge)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #HingeFromEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.popupDialog #HingeFromEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Extrude_Along_Spline
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude along Spline"
Category:"Editable Polygon Object"
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude along Spline (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5}

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.enterPickMode #pickShape
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj ()
			A.popupDialog #ExtrudeAlongSpline
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EditTri
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Edit Triangulation"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Edit Triangulation (Poly)" 
-- Needs Icon
(
	-- active in Edge, Border, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..6}
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode() == #EditTriangulation)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel < 2 then subobjectlevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #EditTriangulation
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_ClearSmoothing
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Clear All Smoothing Groups"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Clear All Smoothing Groups (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5..6}

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel < 4 then subobjectlevel = 4
			else (
				local A = Filters.GetModOrObj()
				if (Filters.Is_This_EditPolyObj A) then A.buttonOp #ClearSmoothingGroups
				else (
					A.smoothingGroupsToClear = -1
					A.smoothingGroupsToSet = 0
					A.ButtonOp #SetSmooth
				)
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Autosmooth
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Auto Smooth Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Auto Smooth (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{5..6}

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel < 4 then subobjectlevel = 4
			else (
				local A = Filters.GetModOrObj()
				A.ButtonOp #Autosmooth
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

-- *******************************************************************
--  Poly Ops: Parameter toggles
-- *******************************************************************

MacroScript EPoly_NURMS_Toggle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"NURMS Toggle"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"NURMS Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditPoly()
	On IsVisible Return Filters.Is_EditPoly()
	On IsChecked Do (
		Try ( $.surfSubdivide )
		Catch ( false )
	)

	On Execute Do
	(
		
		Try	
		(
		$.surfSubdivide = (not $.surfSubdivide)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_SoftSel_Toggle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Soft Selection"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Soft Selection Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			A.useSoftSel
		)
		Catch ( false )
	)

	On Execute Do
	(
		
		Try	
		(
			local A = Filters.GetModOrObj()
			A.useSoftSel = (not A.useSoftSel)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_IgnoreBack_Toggle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Ignore Backfacing"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Ignore Backfacing Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			A.ignoreBackfacing
		)
		Catch ( false )
	)

	On Execute Do (
		Try	(
			local A = Filters.GetModOrObj()
			A.ignoreBackfacing = (not A.ignoreBackfacing)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

MacroScript EPoly_Toggle_Edge_Constraint
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Edge Constraint"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Edge Constraint Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			(A.constrainType == 1)
		)
		Catch ( false )
	)

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if A.constrainType == 1 then (A.constrainType = 0)
			else (A.constrainType = 1)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Toggle_Face_Constraint
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Face Constraint"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Face Constraint Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			(A.constrainType == 2)
		)
		Catch ( false )
	)

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if A.constrainType == 2 then (A.constrainType = 0)
			else (A.constrainType = 2)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- This isn't a parameter toggle, exactly, but it acts similar, so we put it here
MacroScript EPoly_Toggle_Shaded_Faces
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Shaded Faces"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Shaded Face Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			if subobjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 0 then (
				local A = Filters.GetModOrObj()
				A.buttonOp #ToggleShadedFaces
			)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
--  Poly Ops: Selection conversion
-- *******************************************************************

MacroScript EPoly_Convert_Sel_To_Vertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Convert to Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Convert to Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..6}

	On Execute Do (
		Try (
			if subobjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.ConvertSelection #CurrentLevel #Vertex
			subobjectLevel = 1
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Convert_Sel_To_Edge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Convert to Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Convert to Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try (
			if subobjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.ConvertSelection #CurrentLevel #Edge
			subobjectLevel = 2
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Convert_Sel_To_Face
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Convert to Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Convert to Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..4}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..4}

	On Execute Do (
		Try (
			if subobjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			A.ConvertSelection #CurrentLevel #Face
			subobjectLevel = 4
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)


