/*
 EditMesh Operations MacroScript File
 Version:  3ds max 6
 
 Revision History:
 	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


 
 EditMesh operations Macroscript file.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--
-- Renamed flt_EditM --> Filters.Is_EditMesh
*/


MacroScript EMesh_Attach
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Attach"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Attach (Mesh)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		ApplyOperation Edit_Mesh meshops.startAttach
	
	)

)
MacroScript EMesh_Detach
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Detach"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Detach (Mesh)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try(ApplyOperation Edit_Mesh meshops.Detach)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
		
	)

)
MacroScript EMesh_Weld
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Weld Selected"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Weld Vertices (Mesh)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		
		ApplyOperation Edit_Mesh meshops.Weld
	
	)

)
MacroScript EMesh_Hide
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Hide (Mesh)"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Hide (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMeshSpecifyLevel #{2,4..6}

	On Execute Do
	(
		Try(ApplyOperation Edit_Mesh meshops.Hide)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)
MacroScript EMesh_UnHide
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Unhide All (Mesh)"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Unhide All (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMeshSpecifyLevel #{2,4..6}

	On Execute Do
	(
		Try(ApplyOperation Edit_Mesh meshops.UnHideAll)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)
)
MacroScript EMesh_Collapse
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Collapse"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Collapse (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		Try(ApplyOperation Edit_Mesh meshops.collapse)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)
)

MacroScript EMesh_View_Align
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"View Align"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"View Align (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 0 then subobjectlevel = 4
		else ApplyOperation Edit_Mesh meshops.viewAlign
	)

)

MacroScript EMesh_Grid_Align
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Grid Align"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Grid Align (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(

		Try(ApplyOperation Edit_Mesh meshops.gridAlign)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)
MacroScript EMesh_Make_Planer
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Make Planar"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Make Planar (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 0 then subobjectlevel = 4
		else Try(ApplyOperation Edit_Mesh meshops.MakePlanar)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)
MacroScript EMesh_Flip
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Flip Normals Mode"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Flip Normals Selected (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Mesh meshops.startFlipNormalmode)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)
MacroScript EMesh_Unify
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Unify Normals"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Unify Normals (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(

		Try(ApplyOperation Edit_Mesh meshops.Unifynormal)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)

MacroScript EMesh_Inset
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Inset"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Inset selection (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(

		Try
		(
			extrudeface $ #selection 0 50
		)Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)
-- *******************************************************************
--  Mesh Ops:  Vertex Mode  
--
--  SO LEVELS: 1 = vertex; 2 = edges; 3 = faces; 4 = polygons
--
-- *******************************************************************

MacroScript EMesh_VChamfer
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Chamfer Vertex"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Chamfer Vertex (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		Try
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			ApplyOperation Edit_Mesh meshops.startchamfer
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	
	)

)
MacroScript EMesh_VCreate
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Create Vertices"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Create Vertices (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			ApplyOperation Edit_Mesh meshops.startCreate
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_VBreak
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Break Vertices"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Break Vertices (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			
			if SubObjectLevel == 1 then ApplyOperation Edit_Mesh meshops.break
			else SubObjectLevel = 1
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_RemoveIsolatedVerts
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Remove Isolated Verts"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Remove Isolated Vertices (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			ApplyOperation Edit_Mesh meshops.removeisolatedverts
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_SlicePlane
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Slice Plane"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Slice Plane (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 4
			ApplyOperation Edit_Mesh meshops.startsliceplane
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)
MacroScript EMesh_TargetWeld
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Target Weld"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Target Weld (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 1
			ApplyOperation Edit_Mesh meshops.startWeldTarget
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

-- *******************************************************************
-- Mesh Ops:  Edge Mode 
--
--  SO LEVELS: 1 = vertex; 2 = edges; 3 = faces; 4 = polygons
--
-- *******************************************************************

MacroScript EMesh_EExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Extrude Edge"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Extrude Edge (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.startExtrude
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_EChamfer
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Chamfer Edge"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Chamfer Edge (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.startChamfer
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_ECut
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Cut Edge"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Cut Edge (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.startCut
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)


MacroScript EMesh_EDivide
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Divide Edges"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Divide Edges (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.startDivide
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_ETurn
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Turn Edges Mode"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Turn Edges (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.startTurn
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_EVisible
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Visible Edge"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Visible Edge (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.VisibleEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_EInVisible
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Invisible Edge"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Invisible Edge (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.InVisibleEdge
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_OpenEdges
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Select Open Edges"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Select Open Edges (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.SelectOpenEdges
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_ShapeFromEdges
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Shape from Edges"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Create Shape from Edges (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			SubObjectLevel = 2
			ApplyOperation Edit_Mesh meshops.CreateShapeFromEdges
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

-- *******************************************************************
--  Mesh Ops: Face Mode  
--
--  SO LEVELS: 1 = vertex; 2 = edges; 3 = faces; 4 = polygons
--
-- *******************************************************************

MacroScript EMesh_FExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Extrude Face"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Extrude Face (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startExtrude
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_FBevel
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Bevel Face"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Bevel Face (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startBevel
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_FCreate
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Create Faces"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Create Faces (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startCreate
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_FCut
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Cut Faces"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Cut Faces (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startCut
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_FDivide
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Divide Faces"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Divide Faces (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startDivide
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_FFlip
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Flip Faces"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Flip Faces (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 3 then subobjectlevel = 3
			ApplyOperation Edit_Mesh meshops.startFlipNormalmode
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

-- *******************************************************************
-- Mesh Ops: Polygon Mode 
--
--  SO LEVELS: 1 = vertex; 2 = edges; 3 = faces; 4 = polygons
--
-- *******************************************************************

MacroScript EMesh_PExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Extrude Polygons"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Extrude Polygons (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startExtrude
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_PCreate
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Create Polygons"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Create Polygons (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startCreate
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_PExtrude
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Extrude Polygons"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Extrude Polygons (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startExtrude
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_PCut
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Cut Polygons"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Cut Polygons (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startCut
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)


MacroScript EMesh_PDivide
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Divide Polygons"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Divide Polygons (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startDivide
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_PBevel
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Bevel Polygon"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Bevel Polygon (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startBevel
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)

MacroScript EMesh_PFlip
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Flip Polygon"
Category:"Editable Mesh Object" 
internalCategory:"Editable Mesh Object" 
Tooltip:"Flip Polygon (Mesh)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditMesh()
	On IsVisible Return Filters.Is_EditMesh()

	On Execute Do
	(
		
		Try	
		(
			If SubObjectLevel == undefined then Max Modify Mode
			if subobjectlevel != 4 then subobjectlevel = 4
			ApplyOperation Edit_Mesh meshops.startFlipNormalMode
		)
		Catch(MessageBox "Operation Failed" Title:"Mesh Editing")
	)

)






