/*
Freeze Transform MacroScript File



Author :   Frederick Ruff

Revision History:
	
	Dec 1 2000, created
	
	Aug 22 2003, Larry Minton
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
    08 mar 2006, Michael Zyracki
	    added support for Animation Layers, by disabling  Freezes over layers, and making sure zero
		keys are set on active layers.

 
This script adds tools for freezing a transform
This is done via adding a second controller to the controllers stack.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/
macroScript FreezeTransform
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Freeze Transform"  	
	Category:"Animation Tools"  	
	internalCategory:"Animation Tools"  	
	Tooltip:"Freeze Transform"  
( 	
	fn FreezeTransform = 	
	( 		
		local Obj = Selection as array 	
		suspendEditing which:#motion
		for i = 1 to Obj.count do 		
		( 
			Try
			(	
				local CurObj = Obj[i] 	
	
				if classof CurObj.rotation.controller != Rotation_Layer do
				(

					-- freeze rotation		
					CurObj.rotation.controller = Euler_Xyz() 		
					CurObj.rotation.controller = Rotation_list() 			
					CurObj.rotation.controller.available.controller = Euler_xyz() 		
					
					/* "Localization on" */  
				
					CurObj.rotation.controller.setname 1 "Frozen Rotation" 		
					CurObj.rotation.controller.setname 2 "Zero Euler XYZ" 		
				
					/* "Localization off" */  
					
					CurObj.rotation.controller.SetActive 2 		
				)
				if classof CurObj.position.controller != Position_Layer do
				(

					-- freeze position
					CurObj.position.controller = Bezier_Position() 			
					CurObj.position.controller = position_list() 			
					CurObj.position.controller.available.controller = Position_XYZ() 	
		
					/* "Localization on" */  
							
					CurObj.position.controller.setname 1 "Frozen Position" 	
					CurObj.position.controller.setname 2 "Zero Pos XYZ" 			
					
					/* "Localization off" */  
					
					CurObj.position.controller.SetActive 2 		
		
					-- position to zero
					CurObj.Position.controller[2].x_Position = 0
					CurObj.Position.controller[2].y_Position = 0
					CurObj.Position.controller[2].z_Position = 0
				)
			)	
			/* "Localization on" */  
					
			Catch( messagebox "A failure occurred while freezing an object's transform." title:"Freeze Transform")
					
			/* "Localization off" */  	
		)
		resumeEditing which:#motion
	)
	
	/* "Localization on" */  
	
	if querybox "Freezing the transform involves setting up another layer of controllers.\nYou will lose any constraints or animation that was applied to these objects.\n\nNOTE: You can use the \"Transform To Zero\" command to get these objects back to this transform. \n\n                                                  Would you like to continue?" title:"Freeze Transforms"== true do 
	
	/* "Localization off" */
  
	FreezeTransform()

 )
 -- Set Transform to Zero
MacroScript TransformToZero
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Transform To Zero" 
	Category:"Animation Tools" 
	internalCategory:"Animation Tools" 
	Tooltip:"Transform To Zero" 
(
	fn TransformToZero =
	(
	
		local Obj = Selection as array
		for i = 1 to Obj.count do
		(
			Try
			(
				local CurObj = Obj[i]
				if classof CurObj.Position.controller == Position_Layer then
				(
					local active = CurObj.position.controller.active
					CurObj.Position.controller[active].value = (Point3 0 0 0)
				)
				else
				(
					CurObj.Position.controller[2].x_Position = 0
					CurObj.Position.controller[2].y_Position = 0
					CurObj.Position.controller[2].z_Position = 0
				)

				if classof CurObj.rotation.controller == Rotation_Layer then
				(
					local active = CurObj.rotation.controller.active
				  	CurObj.rotation.controller[active].value = (quat 0 0 0 1)
				)
				else
				(
					CurObj.rotation.controller[2].x_rotation = 0
					CurObj.rotation.controller[2].y_rotation = 0
					CurObj.rotation.controller[2].z_rotation = 0
				)	
			)
			/* "Localization on" */  
			
			Catch( messagebox "One of the object's transform was never frozen." title:"Freeze Transform")
			
			/* "Localization off" */  	
		)
		select Obj
	)

	TransformToZero()
)
 -- Freeze Rotation Only
 macroScript FreezeRotation
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Freeze Rotation"  	
	Category:"Animation Tools"  	
	internalCategory:"Animation Tools"  	
	Tooltip:"Freeze Rotation"  
( 	
	fn FreezeRotation = 	
	( 		
		local Obj = Selection as array 		
		for i = 1 to Obj.count do 		
		( 	
			Try
			(		
				local CurObj = Obj[i] 	
				if classof CurObj.rotation.controller != Rotation_Layer do
				(
			
					CurObj.rotation.controller = Euler_Xyz() 		
					CurObj.rotation.controller = Rotation_list() 		
					
					/* "Localization on" */
		  
					CurObj.rotation.controller.setname 1 "Inital Pose" 		
					CurObj.rotation.controller.available.controller = Euler_xyz() 		
					CurObj.rotation.controller.setname 1 "Inital Pose" 		
					CurObj.rotation.controller.setname 2 "Keyframe XYZ" 		
					CurObj.rotation.controller.SetActive 2 		
				)
				
				/* "Localization off" */  
			)
			
			/* "Localization on" */  
			
			Catch( messagebox "A failure occurred while freezing an object's rotation." title:"Freeze Transform")
			
			/* "Localization off" */  	
		) 		
		select Obj 
	) 
	
	FreezeRotation()
 )
 
 -- Freeze Position only
macroScript FreezePosition
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Freeze Position"  	
	Category:"Animation Tools"  	
	internalCategory:"Animation Tools"  	
	Tooltip:"Freeze Position"  
( 	
	fn FreezePosition = 	
	( 		
		local Obj = Selection as array 		
		for i = 1 to Obj.count do 		
		(
			Try
			(
				local CurObj = Obj[i] 	

				if classof CurObj.Position.controller !=  Position_Layer do
				(
	
					-- freeze position		
					CurObj.position.controller = Bezier_Position() 			
					CurObj.position.controller = position_list() 			
					
					/* "Localization on" */
		  
					CurObj.position.controller.setname 1 "Inital Pose" 			
					CurObj.position.controller.available.controller = Position_XYZ() 						
					CurObj.position.controller.setname 2 "Keyframe XYZ" 			
					CurObj.position.controller.SetActive 2 		
				
					/* "Localization off" */  	
					
					-- position to zero
					CurObj.Position.controller[2].x_Position = 0
					CurObj.Position.controller[2].y_Position = 0
					CurObj.Position.controller[2].z_Position = 0
				)
			)
			
			/* "Localization on" */  
			
			Catch( messagebox "A failure occurred while freezing an object's position." title:"Freeze Transform")
			
			/* "Localization off" */  	
		) 		
		select Obj 	
	) 
	
	FreezePosition()
) 

--Set Rotation to Zero
MacroScript RotationToZero
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Rotation To Zero" 
	Category:"Animation Tools" 
	internalCategory:"Animation Tools" 
	Tooltip:"Rotation To Zero" 
(
	fn RotationToZero =
	(
		local Obj = Selection as array
		for i = 1 to Obj.count do
		(
			Try
			(
				local CurObj = Obj[i]
				if classof CurObj.rotation.controller == Rotation_Layer then
				(
					local active = CurObj.rotation.controller.active
				  	CurObj.rotation.controller[active].value = (quat 0 0 0 1)
				)
				else
				(
					CurObj.rotation.controller[2].x_rotation = 0
					CurObj.rotation.controller[2].y_rotation = 0
					CurObj.rotation.controller[2].z_rotation = 0
				)	
			)
			
			/* "Localization on" */  
	
			Catch( messagebox "One of the object's rotation was never frozen." title:"Freeze Transform")
		
			/* "Localization off" */  
		)
		select Obj
	)
	
	RotationToZero()
)

-- Position To Zero
MacroScript PositionToZero
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Position To Zero" 
	Category:"Animation Tools" 
	internalCategory:"Animation Tools" 
	Tooltip:"Position To Zero" 
(
	fn PositionToZero =
	(
	
		local Obj = Selection as array
		for i = 1 to Obj.count do
		(
			Try
			(
				local CurObj = Obj[i]
				if classof CurObj.Position.controller == Position_Layer then
				(
					local active = CurObj.position.controller.active
					CurObj.Position.controller[active].value = (Point3 0 0 0)
				)
				else
				(
					CurObj.Position.controller[2].x_Position = 0
					CurObj.Position.controller[2].y_Position = 0
					CurObj.Position.controller[2].z_Position = 0
				)
			)
			/* "Localization on" */  
			
			Catch( messagebox "One of the object's position was never frozen." title:"Freeze Transform")
			
			/* "Localization off" */  	
		)
		select Obj
	)

	PositionToZero()
)