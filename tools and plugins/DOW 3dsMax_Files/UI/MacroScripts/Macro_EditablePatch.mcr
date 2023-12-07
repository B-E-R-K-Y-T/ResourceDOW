/*

EditPatch Operations MacroScript File

Revision history:

		June 12 2000: Frank DeLise
			3ds max 4
	
		10 Juin 2003: Pierre-Felix Breton
			3ds max 6
	
		12 dec 2003, Pierre-Felix Breton, 
			added product switcher: this macroscript file can be shared with all Discreet products


EditPatch operations Macroscript file.

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 
-- Renamed Flt_EditPath --> Filters.Is_EditPatch

MacroScript EPatch_Attach
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Attach"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Attach (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		Try(ApplyOperation Edit_Patch Patchops.startAttach)Catch()
	
	)

)

MacroScript EPatch_Detach_Element
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Detach Element"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Detach Element (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.Detach)Catch()
	
	)

)
MacroScript EPatch_Detach_Patch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Detach"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Detach (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.Detach)Catch()
	
	)

)
MacroScript EPatch_Extrude_Edge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Edge"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Extrude Edge (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.StartExtrude)Catch()
	
	)

)
MacroScript EPatch_Extrude_Patch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Patch"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Extrude Patch (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.StartExtrude)Catch()
	
	)

)
MacroScript EPatch_Extrude_Element
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extrude Element"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Extrude Element (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.StartExtrude)Catch()
	
	)

)
MacroScript EPatch_Bind
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bind"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Bind (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Patch PatchOps.StartBind)Catch()
	
	)

)
MacroScript EPatch_UnBind
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unbind"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Unbind (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 1 then Try(ApplyOperation Edit_Patch PatchOps.UnBind)Catch()
		else subobjectlevel = 1
	)

)
MacroScript EPatch_Weld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Weld Verticies"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Weld Vertices (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.Weld)Catch()
	
	)

)
MacroScript EPatch_Add_Tri
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Add Tri"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Add Tri (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.AddTri)Catch()
	
	)

)

MacroScript EPatch_Add_Quad
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Add Quad"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Add Quad (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.AddQuad)Catch()
	
	)

)

MacroScript EPatch_Hide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hide (Patch)"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Hide (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatchSpecifyLevel #{2..5}

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		else Try(ApplyOperation Edit_Patch PatchOps.Hide)Catch()
	
	)

)

MacroScript EPatch_UnHide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unhide All (Patch)"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Unhide All (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatchSpecifyLevel #{2..5}

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == undefined then subobjectlevel = 1
		Try(ApplyOperation Edit_Patch PatchOps.UnHideAll)Catch()
	
	)

)

MacroScript EPatch_Bevel_Patch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bevel Patch"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Bevel Patch (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.StartBevel)Catch()
	
	)

)
MacroScript EPatch_Bevel_Element
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bevel Element"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Bevel Element (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.StartBevel)Catch()
	
	)

)

MacroScript EPatch_Delete_Vertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Vertex"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Delete Patch Vertex (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Patch PatchOps.Delete)Catch()
	
	)

)

MacroScript EPatch_Delete_Edge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Edge"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Delete Patch Edge (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.Delete)Catch()
	
	)

)


MacroScript EPatch_Delete_Patch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Patch"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Delete Patch (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.Delete)Catch()
	
	)

)

MacroScript EPatch_Delete_Element
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Patch Element"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Delete Patch Element (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.Delete)Catch()
	
	)

)

MacroScript EPatch_Subdivide_Edge
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Subdivide Edge"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Subdivide Edge (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 2 then Try(ApplyOperation Edit_Patch PatchOps.Subdivide)Catch()
		else subobjectlevel = 2
	
	)

)

MacroScript EPatch_Subdivide_Patch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Subdivide Patch"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Subdivide Patch (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 3 or subobjectlevel == 4 then Try(ApplyOperation Edit_Patch PatchOps.Subdivide)Catch()
		else subobjectlevel = 3
	)

)
MacroScript EPatch_Subdivide_Element
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Subdivide Element"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Subdivide Element (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 4 then Try(ApplyOperation Edit_Patch PatchOps.Subdivide)Catch()
		else subobjectlevel = 4
	)

)
-- Last Updated: 	Sept 5 2000
--
-- Author :   Fred Ruff
-- Version:  3ds max 4
--
-- 
-- EditPatch operations Macroscript updates.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

MacroScript EPatch_CreatePatch
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Patch"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Create (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.startcreate)Catch()
	)
)
MacroScript EPatch_TargetWeld
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Target Weld"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Target Weld (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Patch PatchOps.StartWeldtarget)Catch()
	)
)
MacroScript EPatch_FlipNormalMode
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Flip Normals Mode"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Flip Normals Mode (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Patch PatchOps.StartFlipNormalMode)Catch()
	)
)
MacroScript EPatch_SelectOpenEdges
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Select Open Edges"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Select Open Edges (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.SelectOpenEdges)Catch()
	)
)
MacroScript EPatch_BreakVertex
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Break Vertex"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Break Vertex (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel == 1  then Try(ApplyOperation Edit_Patch PatchOps.Break)Catch()
		else subobjectlevel = 1
	)
)
MacroScript EPatch_CreateShapeFromEdges
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Shape"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Create Shape From Edges (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Patch PatchOps.CreateShapeFromEdges)Catch()
	)
)
MacroScript EPatch_FlipNormal
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Flip Normal"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Flip Normals Selected (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.FlipNormal)Catch()
	)
)
MacroScript EPatch_UnifyNormal
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unify Normals"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Unify Normals (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.UnifyNormal)Catch()
	)
)
MacroScript EPatch_SelectByMatID
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Selected by ID"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Select by Material ID (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.SelectByMatID)Catch()
	)
)
MacroScript EPatch_SelectBySG
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Selected by Smoothing Group"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Selected by Smoothing Group (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.SelectBySG)Catch()
	)
)
MacroScript EPatch_ClearAllSG
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Clear All Smoothing Groups"
Category:"Editable Patch Object" 
internalCategory:"Editable Patch Object" 
Tooltip:"Clear All Smoothing Groups (Patch)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditPatch()
	On IsVisible Return Filters.Is_EditPatch()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 4 then subobjectlevel = 4
		Try(ApplyOperation Edit_Patch PatchOps.ClearAllSG)Catch()
	)
)
