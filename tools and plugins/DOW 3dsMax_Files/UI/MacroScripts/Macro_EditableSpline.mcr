/*
EditSpline Operations MacroScript File


Revision History:

	June 12 2000, Created

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products

EditSpline operations Macroscript file.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 
-- Renamed flt_EditS --> Filters.Is_EditSpline
*/
MacroScript ESpline_Attach
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Attach"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Attach (Spline)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		ApplyOperation Edit_Spline Splineops.startAttach
	
	)

)
MacroScript ESpline_Detach_Segment
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Detach Segment"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Detach Segment (Spline)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		else if subobjectlevel == 2 do Try(ApplyOperation Edit_Spline Splineops.Detach)Catch(MessageBox "Operation Failed" Title:"Spline Editing")
		
	)

)

MacroScript ESpline_Detach_Spline
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Detach Spline"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Detach Spline (Spline)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.Detach)Catch(MessageBox "Operation Failed" Title:"Spline Editing")
		
	)

)
MacroScript ESpline_Weld
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Weld Vertices"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Weld Vertices (Spline)" 
-- Needs Icon
(
	On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		
		ApplyOperation Edit_Spline Splineops.Weld
	
	)

)
MacroScript ESpline_Hide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Hide (Spline)"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Hide (Spline)" 
-- Needs Icon
(

	On IsVisible Return Filters.Is_EditSplineSpecifyLevel #{2..4}

	On Execute Do
	(
		Try(ApplyOperation Edit_Spline Splineops.Hide)Catch(MessageBox "Operation Failed" Title:"Spline Editing")
	)

)
MacroScript ESpline_UnHide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unhide All (Spline)"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Unhide All (Splines)" 
-- Needs Icon
(
	
	On IsVisible Return Filters.Is_EditSplineSpecifyLevel #{2..4}

	On Execute Do
	(
		Try(ApplyOperation Edit_Spline Splineops.UnHideAll)Catch(MessageBox "Operation Failed" Title:"Spline Editing")
	)
)

MacroScript ESpline_Reverse
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Reverse Spline"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Reverse (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(

		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.Reverse)Catch(MessageBox "Operation Failed" Title:"Spline Editing")
	
	)

)

MacroScript ESpline_Insert
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Insert"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Insert Selection (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		Try(ApplyOperation Edit_Spline Splineops.StartInsert)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Trim
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Trim"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Trim (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.StartTrim)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)
MacroScript ESpline_Break
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Break Vertices"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Break Vertices (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartBreak)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)
MacroScript ESpline_UnBind
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Unbind"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Unbind (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.Unbind)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Divide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Divide"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Divide (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Spline Splineops.Divide)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Explode
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Explode"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Explode (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.Explode)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Create_Line
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Create Line"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Create Line (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		Try(ApplyOperation Edit_Spline Splineops.StartCreateLine)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_MirrorHoriz
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Mirror Horizontally"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Mirror Horizontally (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.MirrorHoriz)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Refine
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Refine"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Refine (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartRefine)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Refine_Connect
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Refine Connect"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Refine Connect (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartRefineConnect)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Extend
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Extend"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Extend (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.StartExtend)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Make_First
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Make First"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Make First (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.MakeFirst)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Close
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Close"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Close (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.Close)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Delete_Vertex
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Vertex"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Delete Vertex (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.Delete)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)
MacroScript ESpline_Delete_Segment
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Segment"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Delete Segment (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 2 then subobjectlevel = 2
		Try(ApplyOperation Edit_Spline Splineops.Delete)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)
MacroScript ESpline_Delete_Spline
enabledIn:#("max", "viz","vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Spline"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Delete Spline (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.Delete)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_MirrorVert
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Mirror Vertically"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Mirror Vertically (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.MirrorVert)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Fillet
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Fillet"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Fillet (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartFillet)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Outline
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Outline"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Outline (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.StartOutline)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Cross_Insert
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Cross Insert"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Cross Insert (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartCrossInsert)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Subtract
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Subtract"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Subtract (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		Try(ApplyOperation Edit_Spline Splineops.StartSubtract)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Bind
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Bind"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Bind (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartBind)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Attach_Multiple
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Attach Multiple"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Attach Multiple (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		Try(ApplyOperation Edit_Spline Splineops.AttachMultiple)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Cycle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Cycle Vertices"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Cycle Vertices (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline SplineOps.Cycle)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Connect
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Connect"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Connect (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.StartConnect)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)

MacroScript ESpline_Mirror_Both
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Mirror Both"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Mirror Both H&V (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 3 then subobjectlevel = 3
		Try(ApplyOperation Edit_Spline Splineops.MirrorBoth)Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
	)

)



-- *******************************************************************
--  Spline Ops:  Vertex Mode  
--
--  SO LEVELS: 1 = vertex; 2 = Segment; 3 = Spline
--
-- *******************************************************************

MacroScript ESpline_VChamfer
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Chamfer Vertex"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Chamfer Vertex (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		Try
		(
			If SubObjectLevel == undefined then Max Modify Mode
		if subobjectlevel != 1 then subobjectlevel = 1
			ApplyOperation Edit_Spline Splineops.startchamfer
		)
		Catch(MessageBox "Operation Failed" Title:"Spline Editing")
	
	)

)

MacroScript ESpline_Fuse_Vertex
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Fuse Vertices"
Category:"Editable Spline Object" 
internalCategory:"Editable Spline Object" 
Tooltip:"Fuse Vertices (Spline)" 
-- Needs Icon
(
	--On IsEnabled Return Filters.Is_EditSpline()
	On IsVisible Return Filters.Is_EditSpline()

	On Execute Do
	(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.Fuse)
		Catch(MessageBox "Operation Failed" Title:"Spline Editing")	
  )
)

