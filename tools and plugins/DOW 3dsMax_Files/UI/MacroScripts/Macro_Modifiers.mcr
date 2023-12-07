/*

Macro_Scripts File
Purposes:  
    
	define action for each modifier to hook up to the create main menu (or quads)
	
	Requires AddmodFunc.ms

Revision History
	9 June 2005, Pierre-Felix Breton
		Adding Hair modifiers
		
	18 May 2005, Pierre-Felix Breton
		Adding Cloth modifiers

	16 fev 2004, Pierre-Felix Breton
		adding UVW Unwrap back
		adding Renderable Spline Modifier

	15 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


	26 Mai 2003: Pierre-felix Breton
		created for 3ds MAX 6
	
	April 22 2002: Fred Ruff
		created for 3ds MAX 5
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK




macroScript Bend
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            ButtonText:"Bend"
			tooltip:"Bend Modifier" 
            Icon:#("Standard_Modifiers",1)
(
	on execute do AddMod Bend
	on isEnabled return mcrUtils.ValidMod Bend
)

macroScript Taper 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Taper"
            tooltip:"Taper Modifier" 
            Icon:#("Standard_Modifiers",2)
(
	on execute do AddMod Taper
	on isEnabled return mcrUtils.ValidMod Taper
)

macroScript MeshSmooth 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"MeshSmooth"
            tooltip:"MeshSmooth Modifier" 
            Icon:#("Standard_Modifiers",19)
(
	on execute do AddMod MeshSmooth
	on isEnabled return mcrUtils.ValidMod MeshSmooth
)

macroScript Ripple 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Ripple"
            tooltip:"Ripple Modifier" 
            Icon:#("Standard_Modifiers",9)
(
	on execute do AddMod Ripple
	on isEnabled return mcrUtils.ValidMod Ripple
)

macroScript Wave 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Wave"
            tooltip:"Wave Modifier" 
            Icon:#("Standard_Modifiers",8)
(
	on execute do AddMod Wave
	on isEnabled return mcrUtils.ValidMod Wave
)

macroScript Edit_Mesh 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Edit Mesh Modifier"
			ButtonText:"Edit Mesh" 
            Icon:#("Max_Edit_Modifiers",1)
(
	on execute do AddMod Edit_Mesh
	on isEnabled return mcrUtils.ValidMod Edit_Mesh
)

macroScript Edit_Spline
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch  
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Edit Spline Modifier"
			ButtonText:"Edit Spline"
            Icon:#("Max_Edit_Modifiers",11)
(
	on execute do AddMod Edit_Spline
	on isEnabled return mcrUtils.ValidMod Edit_Spline
)

macroScript Relax 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Relax"
            tooltip:"Relax Modifier" 
            Icon:#("Standard_Modifiers",21)
(
	on execute do AddMod Relax
	on isEnabled return mcrUtils.ValidMod Relax
)

macroScript Edit_Patch 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Edit Patch Modifier"
			ButtonText:"Edit Patch" 
            Icon:#("Max_Edit_Modifiers",2)
(
	on execute do AddMod Edit_Patch
	on isEnabled return mcrUtils.ValidMod Edit_Patch
)

macroScript Twist 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers"
            internalCategory:"Modifiers"
			ButtonText:"Twist" 
            tooltip:"Twist Modifier" 
            Icon:#("Standard_Modifiers",4)
(
	on execute do AddMod Twist
	on isEnabled return mcrUtils.ValidMod Twist
)

macroScript Extrude 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Extrude"
            tooltip:"Extrude Modifier" 
            Icon:#("Standard_Modifiers",13)
(
	on execute do AddMod Extrude
	on isEnabled return mcrUtils.ValidMod Extrude
)

macroScript Lathe 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Lathe"
            tooltip:"Lathe Modifier" 
            Icon:#("Standard_Modifiers",14)
(
	on execute do AddMod Lathe
	on isEnabled return mcrUtils.ValidMod Lathe
)

macroScript Bevel 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Bevel"
            tooltip:"Bevel Modifier" 
            Icon:#("Standard_Modifiers",17)
(
	on execute do AddMod Bevel	on isEnabled return mcrUtils.ValidMod Bevel
)

macroScript Stretch 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Stretch"
            tooltip:"Stretch Modifier" 
            Icon:#("Standard_Modifiers",5)
(
	on execute do AddMod Stretch
	on isEnabled return mcrUtils.ValidMod Stretch
)

macroScript Face_Extrude 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Face Extrude Modifier"
			ButtonText:"Face Extrude" 
            Icon:#("Max_Edit_Modifiers",5)
(
	on execute do AddMod Face_Extrude
	on isEnabled return mcrUtils.ValidMod Face_Extrude
)

macroScript Optimize 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Optimize"
            tooltip:"Optimize Modifier" 
            Icon:#("Standard_Modifiers",34)
(
	on execute do AddMod Optimize
	on isEnabled return mcrUtils.ValidMod Optimize
)

macroScript Displace 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Displace"
            tooltip:"Displace Modifier" 
            Icon:#("Standard_Modifiers",18)
(
	on execute do AddMod Displace
	on isEnabled return mcrUtils.ValidMod Displace
)

macroScript Linked_xform 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Linked XForm Modifier"
			ButtonText:"Linked XForm" 
            Icon:#("Standard_Modifiers",32)
(
	on execute do AddMod Linked_xform
	on isEnabled return mcrUtils.ValidMod Linked_xform
)

macroScript Affect_Region 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Affect Region Modifier"
			ButtonText:"Affect Region" 
            Icon:#("Standard_Modifiers",15)
(
	on execute do AddMod Affect_Region
	on isEnabled return mcrUtils.ValidMod Affect_Region
)

macroScript Uvwmap 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"UVW Map Modifier"
			ButtonText:"UVW Map" 
            Icon:#("Material_Modifiers",4)
(
	on execute do AddMod Uvwmap
	on isEnabled return mcrUtils.ValidMod Uvwmap
)

macroScript Volumeselect 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Volume Select Modifier" 
			ButtonText:"Volume Select"
            Icon:#("Max_Edit_Modifiers",4)
(
	on execute do AddMod VolumeSelect
	on isEnabled return mcrUtils.ValidMod VolumeSelect
)

macroScript Material_ID 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Material Modifier"
			ButtonText:"Material" 
            Icon:#("Material_Modifiers",2)
(
	on execute do AddMod Materialmodifier
	on isEnabled return mcrUtils.ValidMod Materialmodifier
)

macroScript Smooth 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Smooth Modifier"
			ButtonText:"Smooth" 
            Icon:#("Standard_Modifiers",23)
(
	on execute do AddMod smooth
	on isEnabled return mcrUtils.ValidMod smooth
)

macroScript Normalmodifier 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Normal Modifier" 
			ButtonText:"Normal Modifier"
            Icon:#("Max_Edit_Modifiers",6)
(
	on execute do AddMod Normalmodifier
	on isEnabled return mcrUtils.ValidMod Normalmodifier
)

macroScript Skin 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Skin Modifier" 
			ButtonText:"Skin"
            Icon:#("Standard_Modifiers",26)
(
	on execute do AddMod Skin
	on isEnabled return mcrUtils.ValidMod Skin
)

macroScript Unwrap_UVW 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Unwrap UVW Modifier" 
			ButtonText:"Unwrap UVW"
            Icon:#("Material_Modifiers",6)
(
	on execute do AddMod Unwrap_UVW
	on isEnabled return mcrUtils.ValidMod Unwrap_UVW
)

macroScript Push 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Push Modifier"
			ButtonText:"Push" 
            Icon:#("Standard_Modifiers",36)
(
	on execute do AddMod Push
	on isEnabled return mcrUtils.ValidMod Push
)

macroScript Trim_Extend 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Trim/Extend Modifier"
			ButtonText:"Trim/Extend"
            Icon:#("Max_Edit_Modifiers",14)
(
	on execute do AddMod Trim_Extend
	on isEnabled return mcrUtils.ValidMod Trim_Extend
)

macroScript Squeeze 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Squeeze Modifier"
			ButtonText:"Squeeze" 
            Icon:#("Standard_Modifiers",6)
(
	on execute do AddMod Squeeze
	on isEnabled return mcrUtils.ValidMod Squeeze
)

macroScript Delete_Spline 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Delete Spline Modifier"
			ButtonText:"Delete Spline" 
            Icon:#("Max_Edit_Modifiers",12)
(
	on execute do AddMod DeleteSplineModifier
	on isEnabled return mcrUtils.ValidMod DeleteSplineModifier
)

macroScript CrossSection 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"CrossSection Modifier"
			ButtonText:"CrossSection" 
            Icon:#("Surface_Tools",1)
(
	on execute do AddMod CrossSection
	on isEnabled return mcrUtils.ValidMod CrossSection
)

macroScript Surface 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Surface Modifier"
			ButtonText:"Surface" 
            Icon:#("Surface_Tools",2)
(
	on execute do AddMod surface
	on isEnabled return mcrUtils.ValidMod surface
)

macroScript Lattice 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Lattice Modifier"
			ButtonText:"Lattice" 
            Icon:#("Max_Edit_Modifiers",8)
(
	on execute do AddMod Lattice
	on isEnabled return mcrUtils.ValidMod Lattice
)

macroScript Fillet_Chamfer 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Fillet/Chamfer Modifier"
			ButtonText:"Fillet/Chamfer" 
            Icon:#("Max_Edit_Modifiers",13)
(
	on execute do AddMod Fillet_Chamfer
	on isEnabled return mcrUtils.ValidMod Fillet_Chamfer
)

macroScript Morpher 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Morpher Modifier"
			ButtonText:"Morpher" 
            Icon:#("Standard_Modifiers",24)
(
	on execute do AddMod Morpher
	on isEnabled return mcrUtils.ValidMod Morpher
)

macroScript Normalize_Spline 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Normalize Spline Modifier"
			ButtonText:"Normalize Spline" 
            Icon:#("Max_Edit_Modifiers",13)
(
	on execute do AddMod Normalize_Spline
	on isEnabled return mcrUtils.ValidMod Normalize_Spline
)

macroScript FFD_2x2x2 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD 2x2x2 Modifier" 
			ButtonText:"FFD 2x2x2"
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_2x2x2
	on isEnabled return mcrUtils.ValidMod FFD_2x2x2
)

macroScript FFD_4x4x4 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD 4x4x4 Modifier"
			ButtonText:"FFD 4x4x4" 
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_4x4x4
	on isEnabled return mcrUtils.ValidMod FFD_4x4x4
)

macroScript FFD_3x3x3 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD 3x3x3 Modifier"
			ButtonText:"FFD 3x3x3" 
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_3x3x3
	on isEnabled return mcrUtils.ValidMod FFD_3x3x3
)

macroScript CameraMap 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Camera Map Modifier"
			ButtonText:"Camera Map" 
            Icon:#("Deform_Modifiers",1)
(
	on execute do AddMod CameraMap
	on isEnabled return mcrUtils.ValidMod CameraMap
)


macroScript XForm 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"XForm Modifier"
			ButtonText:"XForm" 
            Icon:#("Standard_Modifiers",31)
(
	on execute do AddMod XForm
	on isEnabled return mcrUtils.ValidMod XForm
)

macroScript Slice 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Slice Modifier"
			ButtonText:"Slice" 
            Icon:#("Standard_Modifiers",30)
(
	on execute do AddMod slicemodifier
	on isEnabled return mcrUtils.ValidMod slicemodifier
)

macroScript FFD_Select 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD Select Modifier"
			ButtonText:"FFD Select" 
            Icon:#("Standard_Modifiers",12)
(
	on execute do AddMod FFD_Select
	on isEnabled return mcrUtils.ValidMod FFD_Select
)

macroScript Melt 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Melt Modifier"
			ButtonText:"Melt" 
            Icon:#("Standard_Modifiers",20)
(
	on execute do 
	(	try (AddMod Melt) Catch(MessageBox "Melt not installed!" Title:"Modifiers")
	)
	on isEnabled return mcrUtils.ValidMod Melt
)

macroScript STL_Check 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"STL Check Modifier"
			ButtonText:"STL Check" 
            Icon:#("Standard_Modifiers",33)
(
	on execute do AddMod STL_Check
	on isEnabled return mcrUtils.ValidMod STL_Check
)

macroScript Cap_Holes 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Cap Holes Modifier"
			ButtonText:"Cap Holes" 
            Icon:#("Standard_Modifiers",29)
(
	on execute do AddMod Cap_Holes
	on isEnabled return mcrUtils.ValidMod Cap_Holes
)

macroScript Preserve 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Preserve Modifier"
			ButtonText:"Preserve" 
            Icon:#("Standard_Modifiers",35)
(
	on execute do AddMod Preserve
	on isEnabled return mcrUtils.ValidMod Preserve
)

macroScript Spline_Select 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Spline Select Modifier" 
			ButtonText:"Spline Select"
            Icon:#("Max_Edit_Modifiers",10)
(
	on execute do AddMod SplineSelect
	on isEnabled return mcrUtils.ValidMod SplineSelect
)

macroScript Material_By_Element 
enabledIn:#("max", "viz","vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Material By Element Modifier"
			ButtonText:"Material By Element" 
            Icon:#("Material_Modifiers",3)
(
	on execute do AddMod MaterialByElement
	on isEnabled return mcrUtils.ValidMod MaterialByElement
)

macroScript UVW_Xform 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"UVW XForm Modifier"
			ButtonText:"UVW XForm"
            Icon:#("Material_Modifiers",5)
(
	on execute do AddMod UVW_Xform
	on isEnabled return mcrUtils.ValidMod UVW_Xform
)



macroScript PatchDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Patch Deform Modifier"
			ButtonText:"Patch Deform" 
            Icon:#("Deform_Modifiers",3)
(
	on execute do AddMod PatchDeform
	on isEnabled return mcrUtils.ValidMod PatchDeform
)

macroScript WPatchDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Patch Deform Modifier (WSM)"
			ButtonText:"Patch Deform (WSM)" 
            Icon:#("Deform_Modifiers",3)
(
	on execute do AddMod SpacePatchDeform
	on isEnabled return mcrUtils.ValidMod SpacePatchDeform
)

macroScript NSurf_Sel 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Surface Selection Modifier"
			ButtonText:"Surface Select" 
            Icon:#("Max_Edit_Modifiers",16)
(
	on execute do AddMod NSurf_Sel
	on isEnabled return mcrUtils.ValidMod NSurf_Sel
)

macroScript Vertex_Paint 
enabledIn:#("max") --pfb: 2003.12.15 added product switch WGS:12/08/04 removed vertex paint from VIZ
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Vertex Paint Modifier"
			ButtonText:"Vertex Paint" 
            Icon:#("Standard_Modifiers",37)
( 
	on execute do
	(	
		AddMod VertexPaint
	/* -- 29 mai 2003; pfb:  commented out fancy triggering because inconsistant with the way the create panel works and may ruin layers connection
		if ((AddMod VertexPaint) == true) then  -- it worked, do so logical presets
		(
			for i = 1 to selection.count do
			(
				selection[i].showvertexcolors = true
				selection[i].vertexcolorsshaded = true
				selection[i].wirecolor = white
			)
		)
		-- else do nothing
	*/
	)

	on isEnabled return mcrUtils.ValidMod VertexPaint
)


macroScript Skew 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Skew Modifier"
			ButtonText:"Skew" 
            Icon:#("Standard_Modifiers",3)
(
	on execute do AddMod Skew
	on isEnabled return mcrUtils.ValidMod Skew
)

macroScript Mesh_Select
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch  
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Mesh Select Modifier"
			ButtonText:"Mesh Select" 
            Icon:#("Max_Edit_Modifiers",3)
(
	on execute do AddMod Mesh_Select
	on isEnabled return mcrUtils.ValidMod Mesh_Select
)

macroScript SurfDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Surf Deform Modifier" 
			ButtonText:"Surf Deform"
            Icon:#("Deform_Modifiers",5)
(
	on execute do AddMod SurfDeform
	on isEnabled return mcrUtils.ValidMod SurfDeform
)


macroScript Disp_Approx 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Disp Approx Modifier"
			ButtonText:"Disp Approx"
            Icon:#("Max_Edit_Modifiers",18)
(
	on execute do AddMod Disp_Approx
	on isEnabled return mcrUtils.ValidMod Disp_Approx
)

macroScript Bevel_Profile 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Bevel Profile Modifier"
			ButtonText:"Bevel Profile" 
            Icon:#("Standard_Modifiers",16)
(
	on execute do AddMod Bevel_Profile
	on isEnabled return mcrUtils.ValidMod Bevel_Profile
)

macroScript PathDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Path Deform Modifier" 
			ButtonText:"Path Deform"
            Icon:#("Deform_Modifiers",7) 
(
	on execute do AddMod PathDeform
	on isEnabled return mcrUtils.ValidMod PathDeform
)

macroScript WPathDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Path Deform Modifier (WSM)" 
			ButtonText:"Path Deform (WSM)"
            Icon:#("Deform_Modifiers",7) 
(
	on execute do AddMod SpacePathDeform
	on isEnabled return mcrUtils.ValidMod SpacePathDeform
)

macroScript FFDBox 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD Box Modifier"
			ButtonText:"FFD Box"
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFDBox
	on isEnabled return mcrUtils.ValidMod FFDBox
)

macroScript FFDCyl 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"FFD Cylinder Modifier" 
			ButtonText:"FFD Cylinder"
            Icon:#("Standard_Modifiers",11)
(
	on execute do AddMod FFDCyl
	on isEnabled return mcrUtils.ValidMod FFDCyl
)

macroScript Tessellate 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Tessellate Modifier"
			ButtonText:"Tessellate" 
            Icon:#("Max_Edit_Modifiers",7)
(
	on execute do AddMod Tessellate
	on isEnabled return mcrUtils.ValidMod Tessellate
)

macroScript Spherify 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Spherify Modifier"
			ButtonText:"Spherify" 
            Icon:#("Standard_Modifiers",22)
(
	on execute do AddMod Spherify
	on isEnabled return mcrUtils.ValidMod Spherify
)

macroScript Flex 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Flex Modifier"
			ButtonText:"Flex" 
            Icon:#("Standard_Modifiers",27)
(
	on execute do AddMod Flex
	on isEnabled return mcrUtils.ValidMod Flex
)

macroScript Mirror 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Mirror Modifier"
			ButtonText:"Mirror" 
            Icon:#("Standard_Modifiers",28)
(
	on execute do AddMod Mirror
	on isEnabled return mcrUtils.ValidMod Mirror
)

macroScript DeleteMesh 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Delete Mesh Modifier"
			ButtonText:"Delete Mesh"
            Icon:#("Max_Edit_Modifiers",9)
(
	on execute do AddMod DeleteMesh
	on isEnabled return mcrUtils.ValidMod DeleteMesh
)

macroScript MultiRes 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"MultiRes Modifier"
			ButtonText:"MultiRes"
(
	on execute do AddMod MultiRes
	on isEnabled return mcrUtils.ValidMod MultiRes
)

macroScript Noise 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Noise Modifier"
			ButtonText:"Noise" 
            Icon:#("Standard_Modifiers",7)
(
	on execute do AddMod Noisemodifier
	on isEnabled return mcrUtils.ValidMod Noisemodifier
)

-- Added new r4 modifiers 
--***********************************************************************************************

macroScript DeletePatch 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Delete Patch Modifier" 
			ButtonText:"Delete Patch"
(
	on execute do AddMod DeletePatch
	on isEnabled return mcrUtils.ValidMod DeletePatch
)
macroScript PatchSelect 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Patch Select Modifier" 
			ButtonText:"Patch Select" 
(
	on execute do AddMod Patch_Select
	on isEnabled return mcrUtils.ValidMod Patch_Select
)
macroScript PointCache 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Point Cache Modifier" 
			ButtonText:"Point Cache"
(
	on execute do AddMod Point_Cache
	on isEnabled return mcrUtils.ValidMod Point_Cache
)

macroScript WPointCache 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Point Cache Modifier (WSM)" 
			ButtonText:"Point Cache (WSM)"
(
	on execute do AddMod Point_CacheSpacewarpModifier
	on isEnabled return mcrUtils.ValidMod Point_CacheSpacewarpModifier
)

macroScript HSDSModifier 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"HSDS Modifier" 
			ButtonText:"HSDS Modifier"
(
	on execute do AddMod HSDS_Modifier
	on isEnabled return mcrUtils.ValidMod HSDS_Modifier
)
macroScript ConvertToPatch 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
           category:"Modifiers" 
           internalCategory:"Modifiers" 
            tooltip:"Convert To Patch Modifier" 
			ButtonText:"Convert To Patch"
(
	on execute do AddMod ConvertToPatch
	on isEnabled return mcrUtils.ValidMod ConvertToPatch
)
macroScript SpaceCameraMap 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Camera Map (WSM)"
			ButtonText:"Camera Map (WSM)" 
            Icon:#("Deform_Modifiers",1)
(
	on execute do addModifier $ (SpaceCameraMap ())
	on isEnabled return mcrUtils.ValidMod SpaceCameraMap 
)
macroScript SpaceSurfDeform 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"SurfDeform (WSM)" 
			ButtonText:"Surf Deform (WSM)"
            Icon:#("Deform_Modifiers",5)
(
	on execute do addModifier $ (SpaceSurfDeform ())
	on isEnabled return mcrUtils.ValidMod SpaceSurfDeform 
)

macroScript PolySelect 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Poly Select Modifier" 
			ButtonText:"Poly Select" 
(
	on execute do AddMod Poly_Select
	on isEnabled return mcrUtils.ValidMod Poly_Select
)
--***********************************************************************************************
-- added max 5 modifiers

macroScript Subdivide 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Subdivide Modifier" 
			ButtonText:"Subdivide" 
(
	on execute do AddMod Subdivide 
	on isEnabled return mcrUtils.ValidMod Subdivide 
)

macroScript WSubdivide 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Subdivide Modifier (WSM)" 
			ButtonText:"Subdivide (WSM)" 
(
	on execute do AddMod subdivideSpacewarpModifier 
	on isEnabled return mcrUtils.ValidMod subdivideSpacewarpModifier 
)
macroScript EditNormals 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Edit Normals Modifier" 
			ButtonText:"Edit Normals" 
(
	on execute do AddMod EditNormals 
	on isEnabled return mcrUtils.ValidMod EditNormals 
)
macroScript Symmetry 
enabledIn:#("max","viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Symmetry Modifier" 
			ButtonText:"Symmetry" 
(
	on execute do AddMod Symmetry
	on isEnabled return mcrUtils.ValidMod Symmetry
)
macroScript VertexWeld 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Vertex Weld Modifier" 
			ButtonText:"Vertex Weld" 
(
	on execute do AddMod Vertex_Weld 
	on isEnabled return mcrUtils.ValidMod Vertex_Weld 
)
macroScript SplineIkControl 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"SplineIk Control Modifier" 
			ButtonText:"SplineIk Control" 
(
	on execute do AddMod Spline_Ik_Control 
	on isEnabled return mcrUtils.ValidMod Spline_Ik_Control 
)

--***********************************************************************************************
-- added during MAX max 6 cycle
macroScript SelectByChannel 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Select By Channel Modifier" 
			ButtonText:"Select By Channel" 
(
	on execute do AddMod Select_By_Channel 
	on isEnabled return mcrUtils.ValidMod Select_By_Channel 
)

macroScript Shell 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Shell Modifier" 
			ButtonText:"Shell" 
(
	on execute do AddMod Shell 
	on isEnabled return mcrUtils.ValidMod Shell 
)
macroScript WDispApprox
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Displace Mesh Modifier (WSM)" 
			ButtonText:"Displace Mesh (WSM)" 
(
	on execute do AddMod Displace_Mesh
	on isEnabled return mcrUtils.ValidMod Displace_Mesh
)

macroScript TurnToPolyMod 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Turn To Poly Modifier" 
			ButtonText:"Turn To Poly" 
(
	on execute do AddMod Turn_To_Poly
	on isEnabled return mcrUtils.ValidMod Turn_To_Poly

)

macroScript TurnToPatchMod 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Turn To Patch Modifier" 
			ButtonText:"Turn To Patch" 
(
	on execute do AddMod Turn_To_Patch 
	on isEnabled return mcrUtils.ValidMod Turn_To_Patch 

)

macroScript TurnToMeshMod 
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Turn To Mesh Modifier" 
			ButtonText:"Turn To Mesh" 
(
	on execute do AddMod Turn_To_Mesh
	on isEnabled return mcrUtils.ValidMod Turn_To_Mesh

)

macroScript UvwmapAdd 
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"UVW Mapping Add Modifier"
			ButtonText:"UVW Mapping Add" 
            
(
	on execute do AddMod UVW_Mapping_Add
	on isEnabled return mcrUtils.ValidMod UVW_Mapping_Add
)

macroScript UvwmapClear
enabledIn:#("max") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"UVW Mapping Clear Modifier"
			ButtonText:"UVW Mapping Clear" 
            
(
	on execute do AddMod UVW_Mapping_Clear
	on isEnabled return mcrUtils.ValidMod UVW_Mapping_Clear
)

macroScript WMapscaler
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"MapScaler Modifier (WSM)"
			ButtonText:"MapScaler (WSM)" 
            
(
	on execute do AddMod MapScaler
	on isEnabled return mcrUtils.ValidMod MapScaler
)

macroScript MapScaler 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Map Scaler Modifier"
			ButtonText:"Map Scaler" 
(
	on execute do addModifier $ (MapScaler ())
        on isEnabled return mcrUtils.ValidMod MapScaler
)


-- new modifier for Autodesk VIZ 2005
macroScript RenderableSPline
enabledIn:#("max", "viz") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Renderable Spline Modifier" 
			ButtonText:"Renderable Spline Modifier"
            --Icon:#("Material_Modifiers",6)
(
	on execute do AddMod Renderable_Spline
	on isEnabled return mcrUtils.ValidMod Renderable_Spline
)


-- pfbreton, mai 29 12 2003
-- this function is similar to the CameraCorrection_Quad available in the Macros_Cameras.mcr
-- the only difference is in the Visibility flags for Quads
-- the reason for this is to have the menu item visible from the pulldown | Modifier menu
-- AND control the visibility in the quads.  Doing this requires a duplicated definition of the scripts

macroScript CameraCorrection 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.15 added product switch 
            category:"Modifiers" 
            internalCategory:"Modifiers" 
            tooltip:"Camera Correction Modifier" 
	    ButtonText:"Camera Correction"
(
    on execute do addMod CamPerspCorrect
    on isEnabled return (Filters.Is_Camera $)
)

-- moved attribute holder modifier into stdplugs/stdscripts for max r7
macroScript Attribute_Holder 
enabledIn:#("max", "viz") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Attribute Holder Modifier"
			ButtonText:"Attribute Holder" 
(
	on execute do AddMod EmptyModifier 
	on isEnabled return mcrUtils.ValidMod EmptyModifier 
)


-- pfbreton: adding new modifiers for 3ds max 7
macroScript ProjectionMod 
enabledIn:#("max") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Projection Modifier"
			ButtonText:"Projection" 
(
	on execute do AddMod ProjectionMod
	on isEnabled return mcrUtils.ValidMod ProjectionMod
)


macroScript Skin_MorphMod 
enabledIn:#("max") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Skin Morph Modifier"
			ButtonText:"Skin Morph" 
(
	on execute do AddMod Skin_Morph
	on isEnabled return mcrUtils.ValidMod Skin_Morph
)

macroScript Skin_WrapMod 
enabledIn:#("max") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Skin Wrap Modifier"
			ButtonText:"Skin Wrap" 
(
	on execute do AddMod Skin_Wrap
	on isEnabled return mcrUtils.ValidMod Skin_Wrap
)
macroScript Skin_WrapPatchMod 
enabledIn:#("max") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Skin Wrap Patch Modifier"
			ButtonText:"Skin Wrap Patch" 
(
	on execute do AddMod Skin_Wrap_Patch
	on isEnabled return mcrUtils.ValidMod Skin_Wrap_Patch
)

macroScript TurboSmoothMod 
enabledIn:#("max", "viz") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"TurboSmooth Modifier"
			ButtonText:"TurboSmooth" 
(
	on execute do AddMod TurboSmooth
	on isEnabled return mcrUtils.ValidMod TurboSmooth
)

macroScript EditPolyMod 
enabledIn:#("max", "viz") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Edit Poly Modifier"
			ButtonText:"Edit Poly" 
(
	on execute do AddMod EditPolyMod
	on isEnabled return mcrUtils.ValidMod EditPolyMod
)

macroScript PhysiqueMod
enabledIn:#("max", "viz") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Physique Modifier"
			ButtonText:"Physique" 
(
	on execute do AddMod Physique
	on isEnabled return mcrUtils.ValidMod Physique
)

macroScript SubstituteMod
enabledIn:#("max", "viz") 
			category:"Modifiers" 
			internalCategory:"Modifiers" 
			tooltip:"Substitute Modifier"
			ButtonText:"Substitute" 
(
	on execute do AddMod SubstituteMod
	on isEnabled return mcrUtils.ValidMod SubstituteMod
)

macroScript SweepMod
enabledIn:#("max", "viz")
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Sweep"
            tooltip:"Sweep Modifier" 

(
	on execute do AddMod Sweep
	on isEnabled return mcrUtils.ValidMod Sweep
)

macroScript ClothMod
enabledIn:#("max")
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Cloth"
            tooltip:"Cloth Modifier" 

(
	on execute do AddMod Cloth
	on isEnabled return mcrUtils.ValidMod Cloth
)

macroScript Garment_MakerMod
enabledIn:#("max")
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Garment Maker"
            tooltip:"Garment Maker Modifier" 

(
	on execute do AddMod Garment_Maker
	on isEnabled return mcrUtils.ValidMod Garment_Maker
)

macroScript HairMod
enabledIn:#("max")
            category:"Modifiers" 
            internalCategory:"Modifiers" 
			ButtonText:"Hair and Fur (WSM)"
            tooltip:"Hair and Fur (WSM) Modifier" 

(
	on execute do AddMod HairMod
	on isEnabled return mcrUtils.ValidMod HairMod
)
