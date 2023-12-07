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

-- *******************************************************************
--  Poly Ops:  Edit Vertices
-- *******************************************************************

MacroScript EPoly_VCreate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#CreateVertex)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #CreateVertex
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VRemove
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Remove Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		try (
			if subobjectlevel == undefined then max modify mode
			if subobjectLevel != 1 then subobjectLevel = 1
			else
			(
				local A = Filters.GetModOrObj()
				if (Filters.Is_This_EditPolyMod A) then A.ButtonOp #RemoveVertex
				else A.buttonOp #Remove
			)
		)
		catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VBreak
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Break Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Break Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			If SubObjectLevel != 1 then SubObjectLevel = 1
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #BreakVertex
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#ExtrudeVertex)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #ExtrudeVertex
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then A.PopupDialog #ExtrudeVertex
			else A.popupDialog #Extrude
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VChamfer
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Chamfer Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Chamfer Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#ChamferVertex)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #ChamferVertex
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then A.PopupDialog #ChamferVertex
			else A.popupDialog #Chamfer
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Weld Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Weld Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		else (
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then A.buttonOp #WeldVertex
			else A.buttonOp #WeldSelected
		)
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 1 then subobjectlevel = 1
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then A.PopupDialog #WeldVertex
			else A.PopupDialog #WeldSelected
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VTargetWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Target Weld Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Target Weld Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#Weld) and (subobjectlevel == 1)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if SubObjectLevel != 1 then subobjectLevel = 1
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #Weld
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_VConnect
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Connect Vertex"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Connect Vertex (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		else
		(
			local A = Filters.GetModOrObj()
			A.buttonOp #ConnectVertices
		)
	)
)

-- *******************************************************************
-- Poly Ops:  Edit Edges
-- *******************************************************************

MacroScript EPoly_ECreate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#CreateEdge)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 3 then SubObjectLevel = 2		-- (don't change from Border level.)
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #createEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_ERemove
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Remove Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		try (
			if subobjectlevel == undefined then max modify mode
			if subobjectLevel != 2 then subobjectLevel = 2
			else
			(
				local A = Filters.GetModOrObj()
				if (Filters.Is_This_EditPolyMod A) then A.ButtonOp #RemoveEdge
				else A.buttonOp #Remove
			)
		)
		catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_ESplit
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Split Edges"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Split Edges (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

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

MacroScript EPoly_EInsertVertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Insert Vertex in Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Insert Vertex in Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#DivideEdge)
		)
		catch ( false )
	)


	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 2 then subobjectLevel = 2
			if subobjectLevel > 3 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			A.ToggleCommandMode #DivideEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#ExtrudeEdge)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 2 then subobjectLevel = 2
			if subobjectLevel > 3 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #ExtrudeEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 2 then subobjectLevel = 2
			if subobjectLevel > 3 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then A.PopupDialog #ExtrudeEdge
			else A.popupDialog #Extrude
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EChamfer
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Chamfer Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Chamfer Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#ChamferEdge)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 2 then subobjectLevel = 2
			if subobjectLevel > 3 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #ChamferEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 2 then subobjectLevel = 2
			if subobjectLevel > 3 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then A.PopupDialog #ChamferEdge
			else A.popupDialog #Chamfer
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Weld Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Weld Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		else
		(
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then A.buttonOp #WeldEdge
			else A.buttonOp #WeldSelected
		)
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 2 then subobjectlevel = 2
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then A.popupDialog #WeldEdge
			else A.popupDialog #WeldSelected
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_ETargetWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Target Weld Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Target Weld Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#Weld) and (A.GetMeshSelLevel()==#Edge)
		)
		catch ( false )
	)

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if SubObjectLevel != 2 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #Weld
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EConnect
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Connect Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Connect Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if subobjectlevel == undefined then max modify mode
			if (subobjectLevel == 2) or (subobjectLevel == 3) then A.buttonOp #ConnectEdges
			else subobjectLevel = 2
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel > 3 then subobjectLevel = 2
			if subobjectLevel < 2 then subobjectLevel = 2
			local A = Filters.GetModOrObj()
			A.popupDialog #ConnectEdges
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_EShapeFromEdges
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Shape from Edges"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create Shape from Edges (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if (subobjectLevel < 2) or (subobjectLevel > 3) then subobjectLevel = 2
			else (
				local A = Filters.GetModOrObj()
				A.buttonOp #CreateShape
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
-- Poly Ops:  Edit Borders
-- *******************************************************************

-- Note: Insert Vertex, Extrude, Chamfer, Connect, create Shape, are all handled in Edge above.

MacroScript EPoly_BCap
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Cap Border"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Cap Border (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			else
			(
				local A = Filters.GetModOrObj()
				A.buttonOp #Cap
			)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

-- *******************************************************************
--  Poly Ops: Edit Faces
-- *******************************************************************

MacroScript EPoly_FCreate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Polygon"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Create Polygon (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#CreateFace)
		)
		catch ( false )
	)


	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if (subobjectLevel > 0) and (subobjectLevel < 4) then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #CreateFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FInsertVertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Insert Vertex in Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Insert Vertex in Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#DivideFace)
		)
		catch ( false )
	)


	On Execute Do (
		Try	(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.ToggleCommandMode #DivideFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#ExtrudeFace)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #ExtrudeFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then A.PopupDialog #ExtrudeFace
			else A.popupDialog #Extrude
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FBevel
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bevel Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Bevel Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#Bevel)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #Bevel
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.popupDialog #Bevel
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FOutline
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Outline Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Outline Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#OutlineFace)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #OutlineFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.popupDialog #Outline
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FInset
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Inset Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Inset Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#InsetFace)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #InsetFace
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel < 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.popupDialog #Inset
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FRetriangulate
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Retriangulate Face"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Retriangulate Face (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

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

MacroScript EPoly_FFlip
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Flip Face Normals"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Flip Face Normals (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

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
					if (subobjectlevel == 4) then A.ButtonOp #FlipFace
					else A.ButtonOp #FlipElement
				)
				else A.buttonOp #FlipNormals
			)
			Catch(MessageBox "Operation Failed" Title:"Poly Editing")
		)
	)

)

MacroScript EPoly_FHinge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hinge Face from Edge"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Hinge Face from Edge (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		try (
			local A = Filters.GetModOrObj()
			(Filters.Is_This_EditPolyMod A) and (A.GetCommandMode()==#HingeFromEdge)
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.toggleCommandMode #HingeFromEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.PopupDialog #HingeFromEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_FExtrude_Along_Spline
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Face along Spline"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Extrude Face along Spline (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.enterPickMode #pickShape
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
	On AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectLevel != 4 then subobjectLevel = 4
			local A = Filters.GetModOrObj()
			A.popupDialog #ExtrudeAlongSpline
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Toggle_Normal_Constraint
enabledIn:#("max", "viz") 
ButtonText:"Normal Constraint"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Normal Constraint Toggle (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			(A.constrainType == 3)
		)
		Catch ( false )
	)

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if A.constrainType == 3 then (A.constrainType = 0)
			else (A.constrainType = 3)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)

MacroScript EPoly_Preview_Select_Mode
enabledIn:#("max", "viz") 
ButtonText:"Preview Select Mode"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Preview Select Mode (Poly)" 
-- Needs Icon
(	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if A.selectMode == 2 then (A.selectMode = 0)
			else (A.selectMode = A.selectMode+1)
		)
		Catch (MessageBox "Operation Failed" Title:"Poly Editing")
	)
)



MacroScript EPoly_SoftSel_Lock_Toggle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Soft Selection Lock"
Category:"Editable Polygon Object" 
internalCategory:"Editable Polygon Object" 
Tooltip:"Soft Selection Lock (Poly)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EPoly()
	On IsVisible Return Filters.Is_EPoly()
	On IsChecked Do (
		Try (
			local A = Filters.GetModOrObj()
			A.lockSoftSel
		)
		Catch ( false )
	)

	On Execute Do
	(
		
		Try	
		(
			local A = Filters.GetModOrObj()
			A.lockSoftSel = (not A.lockSoftSel)
		)
		Catch(MessageBox "Operation Failed" Title:"Poly Editing")
	)

)

