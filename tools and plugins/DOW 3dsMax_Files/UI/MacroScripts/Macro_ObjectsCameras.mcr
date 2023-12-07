-- Macro Scripts File


/* revision history


	13 Jan 2004, Alexander Bicalho
		added Target Camera with Elevation for VIZ Render
		Removed "VIZR" from the product list of the regular Target Camera

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		consolidated the preview DOF macro from the Macro_Render.mcr

       22 Juillet 2003; Pierre-Felix Breton
                Modified to use the old match camera to view when a camera is selected
       24 Mai 2003; Pierre-Felix Breton
                Migrated VIZ 4 functionality in 3ds MAX 6

	August 29 2001 Pierre-Felix Breton
		Added Macro allowing creating a camera from the selected Perspective Viewport
	
	August 30th 2001 Pierre-Felix Breton
	added test for properties so the 'select target' don't show on free cameras anymore
	
	Sept 12 2001 Pierre-Felix Breton
	added a Macro allowing applying the Correction Modifier from the Quad menu.
	
	17 Nov 1998; Frank Delise: initial implementation
*/

-- Macro Scripts for Cameras
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


--***********************************************************************************************
-- Creation Macros
-- enables actions for creation from menus and quads
------------------------------------------------------------------------------------------
macroScript Free_Camera 
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	tooltip:"Free Camera" 
	buttontext:"Free Camera" 
	icon:#("Cameras",2)
	--palettehint: Cameras --used for publishing to palettes
(
	on execute do
	(
  		if ProductAppID == #viz or ProductAppID == #vizr then
		(
			local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
	  		SetCommandPanelTaskMode #create
	  		LightCreationTool.isCreatingLight = #Free_Camera
	  		LightCreationZHeight FreeCamera lightHeight setProps lightName:#Free_Camera
		)
		else
			StartObjectCreation FreeCamera
	)
	on isChecked do
	(
		local result = true
	   	if ProductAppID == #viz or ProductAppID == #vizr then
	   	(
			result = (LightCreationTool.isCreatingLight == #Free_Camera)
		)
		else
		(
			result = mcrUtils.IsCreating FreeCamera
		)
		result
	)
)
------------------------------------------------------------------------------------------
macroScript Target_Camera 
	enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	tooltip:"Target Camera" 
	buttontext:"Target Camera" 
	icon:#("Cameras",1)
	--palettehint: Cameras --used for publishing to palettes
(
	on execute do
	(
  		if ProductAppID == #viz or ProductAppID == #vizr then
		(
	  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
	  		SetCommandPanelTaskMode #create
	  		LightCreationTool.isCreatingLight = #Target_Camera
	  		LightCreationZHeight TargetCamera lightHeight setProps lightName:#Target_Camera isTargeted:true
		)
		else
			StartObjectCreation TargetCamera
	)   
	on isChecked do
	(
   		if ProductAppID == #viz or ProductAppID == #vizr then 
   		(
			(LightCreationTool.isCreatingLight == Target_Camera)
		)
		else
		(
   			mcrUtils.IsCreating Target_Camera
   		)
	)
)

macroScript Target_CameraVR
	enabledIn:#("vizR") -- AB: This script should only load in VIZ Render
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	tooltip:"Target Camera" 
	buttontext:"Target Camera" 
	Icon:#("Cameras",1) 
(

	local isCreatingTargetCamera = False
	local st, cam
	on execute do 
	(
		isCreatingTargetCamera = true
		
		tool LiftedTargetCamera
		(
			
			
			on mousePoint clickNo do 
			(

				if clickNo == 1 do 
				(
					st = gridPoint --+ theCameraIncrement
					in coordsys grid cam = TargetCamera pos:st target:(TargetObject pos:st wirecolor:(color 5 54 179)) wirecolor:(color 5 54 179)
					cam.name = "TempCameraName"
					cam.name = uniquename "Camera" -- needs to be Localized
					cam.target.name = cam.name + ".Target" -- needs to be Localized
					select cam
					selectMore cam.target				
				)
				if clickNo == 2 then 
				(
					if isValidNode cam then select cam else #abort
				)
				if clickNo == 3 then 
				(
					--select cam
					#stop
				)
			)--end mousepoint
			on MouseMove clickNo do 
			(
				if (clickNo == 2) do 
				(
					if isValidNode cam then  -- add protection for deletion
					in coordsys grid cam.target.pos = gridPoint --+ theCameraIncrement
					else #abort
				)
				if (clickNo == 3) do 
				(		
					if isValidNode cam then  -- add protection for deletion
					(
					--exits the function to prevent the lift function from being called		local vporttype = viewport.gettype()
					local vporttype = viewport.gettype()
					case vporttype  of
					(
						#view_left: #stop
						#view_right: #stop						
						#view_front: #stop							
						#view_right: #stop													
						default: --lift the camera
						(
							in coordsys grid
							(
								local height = gridDist.z
								cam.pos.z = height
								cam.target.pos.z = height   -- + theCameraIncrement
								
								--displays in the prompt
								displayTempPrompt ("Camera height: " + (units.formatValue height)) 1000
							)
						)--continues with lift function
					)
				)
					else #abort
				)
			)--end mouse move
		)-- end tool
		local status
		status = starttool LiftedTargetCamera
		if status == #abort do
			if isValidNode cam do delete cam

		--wraps up the creation process
		cam = undefined
		isCreatingTargetCamera = false

		
	) -- end Execute
	
	on isChecked return (isCreatingTargetCamera)

) -- end MacroScript


-- added 'create camera from view command for VIZ R4
------------------------------------------------------------------------------------------
macroScript Camera_CreateFromView
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Create Camera From View"
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	Tooltip:"Create Camera From View"
	Icon:#("Cameras",3)
(

	On IsEnabled Return (If (viewport.Gettype() == #view_persp_user) do return true)
	On Execute Do
	( 
	  --camera variable
	  local c
	  local wcol = (color 5 54 179)
	  local targdist = getscreenscalefactor [0,0,0]
	  -- get viewport tm
	  local viewfov = getVIewFOV()
	  local cXform =  Inverse(viewport.getTM())
	  
	  --disablesceneredraw() 
	  -- perspective views
	  if viewport.Gettype() == #view_persp_user
	  then
		(
		if (superclassof selection[1]) == camera --check if selection is a camera
			then --if selection is a camera, than call the match camera to view action
			(
			  actionMan.executeAction 0 "40249" --loc_notes: do not localize this
			)
			else --if selection is not a camera, then create it for the user
			(
			  -- creates a camera, and assigns the current Vport Transforms
			  c = Freecamera  targetDistance:targdist isSelected:on wirecolor:wcol
			  c.fov = viewfov
			  c.orthoProjection = false 
			  c.Transform = cXform 
			  viewport.setcamera c
			  c.type = #target
			  c.target.wirecolor = wcol
			)--end then
		)--end then
		else
		(

		)--end else

	  -- clears the local variables
	  c = undefined 
	  viewfov = undefined
	  cXform  = undefined
	  
	  --enablesceneredraw()
	  
	)--end on execute
)--end macro

--***********************************************************************************************
-- Selection macros

MacroScript Camera_SelectTarget
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Select Camera Target"
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	Tooltip:"Select Target (Cameras)" 
(

	On IsVisible Return ((Filters.Is_Camera $) and(IsValidNode $.target)) -- pfb, aug 30th 2001, added test for properties so the 'select target' don't show on Omnis anymore
	On Execute Do Try(select $.Target) Catch()
)



--***********************************************************************************************
-- Viewport Macros
macroScript Camera_ActivateView
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Set View to Selected Camera"
category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	Tooltip:"Set View to Selected Camera"
(

	On IsVisible Return ((Filters.Is_Camera $) and (viewport.getcamera() != $) and (viewport.canSetToViewport $) )
	On Execute Do
	( 
		Try(viewport.setcamera $) Catch()
	)
)


--***********************************************************************************************
-- Perspective Correction
-- this function is similar to the CameraCorrection available in the Macros_Modifers.mcr
-- the only difference is in the Visibility flags for Quads
-- the reason for this is to have the menu item visible from the pulldown | Modifier menu
-- AND control the visibility in the quads.  Doing this requires a duplicated definition of the macros

macroScript CameraCorrection_Quad 
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Lights and Cameras" 
	internalCategory:"Lights and Cameras" 
	tooltip:"Apply Camera Correction Modifier (Context)" 
	ButtonText:"Apply Camera Correction Modifier"
(
    on execute do addMod CamPerspCorrect
    on isVisible return (Filters.Is_Camera $)
)


--***********************************************************************************************
-- Preview DOF

macroScript Preview_DOF 
	enabledIn:#("max") --pfb: 2003.12.12 added product switch
	ButtonText:"Preview DOF in Viewport" 
	category:"Render" 
	internalCategory:"Render" 
	tooltip:"Preview Depth of Field in Viewport" 
	buttontext:"Preview Depth of Field in Viewport"        
(
	Try(MaxOps.displayActiveCameraViewWithMultiPassEffect())Catch()
)
