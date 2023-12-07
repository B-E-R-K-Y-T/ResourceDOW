/*
Constraints assignment MacroScript File
Constraint tools
This script increases workflow on assigning constraints by adding a controller automatically.

-- Aug 15 added prompting
-- Aug 20 added LinkConstraint
-- Nov 6  added "H" key support ForceListenerFocus
-- Dec 14 Added Biped Support  
-- Dec 18 Fixed LookAt, Orientation and Noise Rotation constraints - passing wrong channel to AddConstraint
-- Jan 4  Added support for HI IK and HD IK objects; Added group support
-- Feb 16 04 Attachment filter fnc detects attaching controller to self
-- Feb 18 04 Added check for return value of constraint.AppendTarget
-- Feb 23 04 Updated pick filter of constraints to use DependencyLoopTest 


Author :   Frank DeLise
Version:  3ds max 6

Revision History:

	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


***********************************************************************************************
 MODIFY THIS AT YOUR OWN RISK

*/

MacroScript Path
	enabledIn:#("max", "viz") 
	ButtonText:"Path Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Path Constraint" 
	SilentErrors:(Debug != false)

(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		AssignConstraintSelection Path "Pos" Position_List ShapeFilterFn "Pick Shape to Constrain to.." "Path Constraint Not Completed"
	)
)


MacroScript LinkConstraint
	enabledIn:#("max", "viz") 
	ButtonText:"Link Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Link Constraint" 
	SilentErrors:(Debug != True)
	
(
	Global EC_TargetOBJ = "None"

	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
					
			EC_TargetOBJ = PickObject count:1 filter:ConstrFilterFn message:"Pick Object to Link to.." Rubberband:selection[1].transform.pos ForceListenerFocus:False
			if EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				for node in selection do
				(
					local controllerClass = classof node.controller
					if not (controllerClass == BipSlave_Control or
							controllerClass == XRef_Controller or
							(controllerClass == IK_ControllerMatrix3Controller and 
							 node.controller[1].controller == undefined)) then
					(
						-------------------------------------------------------------------------------------------
						-- Skip group members, only apply to head
						-------------------------------------------------------------------------------------------
						local h = node.parent 
						if not (h != undefined and h.isSelected and isGroupHead h) then
						(
							---------------------------------------------------------------------------------------
							-- Add Constraint 
							-- If it's not a link constraint already, check for IK object and IK goal object
							---------------------------------------------------------------------------------------	
							local constraint
							if Classof node.controller == IKControl then 
							(
								constraint = node.Transform.controller.fk_sub_control.controller
							)
							else if Classof node.controller == IKChainControl then 
							(
								constraint = node.Transform.controller.ik_goal.controller
							)	
							else 
							(
								constraint = node.Transform.controller
							)
							If Classof constraint != Link_Constraint do 
							(
								constraint = Link_Constraint ()
								if Classof node.controller == IKControl then 
								(
									node.Transform.controller.fk_sub_control.controller = constraint
								)
								else if Classof node.controller == IKChainControl then 
								(
									node.Transform.controller.ik_goal.controller = constraint
								)	
								else 
								(
									node.Transform.controller = constraint
								)
							)
							
							---------------------------------------------------------------------------------------
							-- Add Links to Link Constraint
							---------------------------------------------------------------------------------------
							local res = true;
							if Classof node.controller == IKControl then 
							(
								res = node.controller.fk_sub_control.controller.AddTarget EC_TargetOBJ SliderTime
							)
							else if Classof node.controller == IKChainControl then 
							(
								res = node.controller.ik_goal.controller.AddTarget EC_TargetOBJ SliderTime
							)	
							else
							(
								res = node.Transform.controller.AddTarget EC_TargetOBJ SliderTime
							)
									
							if (res != true) then 
							(
								throw 0
							)
						)
					)
				)
			)
		)
		Catch (MessageBox "Link Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript Position_Constraint
	enabledIn:#("max", "viz") 
	ButtonText:"Position Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Position Constraint" 
	SilentErrors:(Debug != True)

(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(			
		AssignConstraintSelection Position_Constraint "Pos" Position_List ConstrFilterFn "Pick Object to Constrain to.." "Position Constraint Not Completed"
	)
)


MacroScript Orientation_Constraint
	enabledIn:#("max", "viz") 
	ButtonText:"Orientation Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Orientation Constraint" 
	SilentErrors:(Debug != True)

(
	-- Check to see if something valid is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		AssignConstraintSelection Orientation_Constraint "Rotation" Rotation_List ConstrFilterFn "Pick Object to Constrain to.." "Orientation Constraint Not Completed"
	)
)


MacroScript LookAt
	enabledIn:#("max", "viz") 
	ButtonText:"LookAt Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"LookAt Constraint"
	SilentErrors:(Debug != True) 

(
	-- Check to see if something valid is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		AssignConstraintSelection LookAt_Constraint "Rotation" Rotation_List ConstrFilterFn "Pick Object to Look At.." "LookAt Constraint Not Completed"
	)
)


MacroScript Attachment
	enabledIn:#("max", "viz") 
	ButtonText:"Attachment Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Attachment Constraint"
	SilentErrors:(Debug != True) 


(
	Global EC_TargetOBJ = "None"
	
	-- Check to see if something valid is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
					
			EC_TargetOBJ = PickObject count:1 filter:GeomFilterFn message:"Pick Object to Attach to.." Rubberband:selection[1].transform.pos ForceListenerFocus:False
			if EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				for node in selection do
				(
					local controllerClass = classof node.controller
					if not (controllerClass == BipSlave_Control or
							controllerClass == XRef_Controller or
							(controllerClass == IK_ControllerMatrix3Controller and 
							 node.controller[1].controller == undefined)) then
					(
						-------------------------------------------------------------------------------------------
						-- Skip group members, only apply to head
						-------------------------------------------------------------------------------------------
						local h = node.parent 
						if not (h != undefined and h.isSelected and isGroupHead h) then
						(
							if (refs.DependencyLoopTest EC_TargetOBJ node.controller != true) then
							(
								-------------------------------------------------------------------------------------------
								-- Add List Controller
								-------------------------------------------------------------------------------------------
								
								local cont = AddListController node "Pos" Position_List 
								
								-------------------------------------------------------------------------------------------
								-- Add Constraint
								---------------------------------------------------------------------------------------
								If classof cont[listCtrl.GetActive cont].object != Attachment then 
								(
									constraint = AddConstraint node "Pos" Attachment true
								)
								else 
								(
									constraint = cont[listCtrl.GetActive cont].object
								)
						
								-------------------------------------------------------------------------------------------
								-- Set Node Attached To, initial key
								-------------------------------------------------------------------------------------------
								constraint.Node = EC_TargetOBJ
								local key = AttachCtrl.addnewkey constraint 0
								key.face = 1
					
								-------------------------------------------------------------------------------------------
								-- Set Active Controller
								-------------------------------------------------------------------------------------------
										
								SetActiveController cont constraint
																		
								--Format "%\n"  (node.name + " is Attached to " + EC_TargetOBJ.name) to:Listener
							)
						)
					)
				)
			)			
		)
		Catch (MessageBox "Attachment Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript Surface
	enabledIn:#("max", "viz") 
	ButtonText:"Surface Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Surface Constraint"
	SilentErrors:(Debug != True) 


(
	Local ConstraintCompleted = False
	Global EC_TargetOBJ = "None"
	
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		Undo on
		(
			Try 
			(
				-------------------------------------------------------------------------------------------
				-- Switch to Motion Panel
				-------------------------------------------------------------------------------------------
			
				IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
		
				-------------------------------------------------------------------------------------------
						
				EC_TargetOBJ = PickObject count:1 filter:SurfaceFilterFn message:"Pick Surface to Attach to.." Rubberband:selection[1].transform.pos ForceListenerFocus:False
				if EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
				(
					for node in selection do
					(
						local controllerClass = classof node.controller
						if not (controllerClass == BipSlave_Control or
								controllerClass == XRef_Controller or
								(controllerClass == IK_ControllerMatrix3Controller and 
								 node.controller[1].controller == undefined)) then
						(
							-------------------------------------------------------------------------------------------
							-- Skip group members, only apply to head
							-------------------------------------------------------------------------------------------
							local h = node.parent 
							if not (h != undefined and h.isSelected and isGroupHead h) then
							(
								if (refs.DependencyLoopTest EC_TargetOBJ node.controller != true) then
								(
									-------------------------------------------------------------------------------------------
									-- Add List Controller
									-------------------------------------------------------------------------------------------
									
									local cont = AddListController node "Pos" Position_List 
									
									-------------------------------------------------------------------------------------------
									-- Add Constraint
									---------------------------------------------------------------------------------------
									If classof cont[listCtrl.GetActive cont].object != Surface_Position then 
									(
										constraint = AddConstraint node "Pos" Surface_Position true
									)
									else 
									(
										constraint = cont[listCtrl.GetActive cont].object
									)
									
									-------------------------------------------------------------------------------------------
									-- Add Object
									-------------------------------------------------------------------------------------------
										
									constraint.Surface = EC_TargetOBJ
										
									-------------------------------------------------------------------------------------------
									-- Set Active Controller
									-------------------------------------------------------------------------------------------
											
									SetActiveController cont constraint
								)
							)
						)
					)
				)
			)
			Catch (MessageBox "Surface Constraint Not Completed" Title:"Constraints")
		)
	)
)



MacroScript Bezier_P
	enabledIn:#("max", "viz") 
	ButtonText:"Bezier Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Bezier Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Bezier_Position "Pos" Position_List "Bezier Position Controller Not Completed"
	)
)

MacroScript Bezier_S
	enabledIn:#("max", "viz") 
	ButtonText:"Bezier Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Bezier Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Bezier_Scale "Scale" Scale_List "Bezier Scale Controller Not Completed"
	)
)



MacroScript Noise_P
	enabledIn:#("max", "viz") 
	ButtonText:"Noise Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Noise_Position "Pos" Position_List "Noise Position Controller Not Completed"
	)
)


MacroScript Noise_R
	enabledIn:#("max", "viz") 
	ButtonText:"Noise Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Noise_Rotation "Rotation" Rotation_List "Noise Rotation Controller Not Completed"
	)
)

	
MacroScript Noise_S
	enabledIn:#("max", "viz") 
	ButtonText:"Noise Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Noise_Scale "Scale" Scale_List "Noise Scale Controller Not Completed"
	)
)

MacroScript Audio_P
	enabledIn:#("max", "viz") 
	ButtonText:"Audio Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection AudioPosition "Pos" Position_List "Audio Position Controller Not Completed"
	)
)
	

MacroScript Audio_R
	enabledIn:#("max", "viz") 
	ButtonText:"Audio Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection AudioRotation "Rotation" Rotation_List "Audio Rotation Controller Not Completed"
	)
)


MacroScript Audio_S
	enabledIn:#("max", "viz") 
	ButtonText:"Audio Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection AudioScale "Scale" Scale_List "Audio Scale Controller Not Completed"
	)
)

MacroScript Linear_P
	enabledIn:#("max", "viz") 
	ButtonText:"Linear Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Linear_Position "Pos" Position_List "Linear Position Controller Not Completed"
	)
)




MacroScript Linear_R
	enabledIn:#("max", "viz") 
	ButtonText:"Linear Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Linear_Rotation "Rotation" Rotation_List "Linear Rotation Controller Not Completed"
	)
)


MacroScript Linear_S
	enabledIn:#("max", "viz") 
	ButtonText:"Linear Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Linear_Scale "Scale" Scale_List "Linear Scale Controller Not Completed"
	)
)


MacroScript Expression_P
	enabledIn:#("max") 
	ButtonText:"Position Expression"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Position Expression Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Position_Expression "Pos" Position_List "Position Expression Controller Not Completed"
	)
)



MacroScript Expression_S
	enabledIn:#("max") 
	ButtonText:"Scale Expression"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Scale Expression Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Scale_Expression "Scale" Scale_List "Scale Expression Controller Not Completed"
	)
)


MacroScript Mocap_P
	enabledIn:#("max") 
	ButtonText:"Position Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Position Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Position_Motion_Capture "Pos" Position_List "Position Motion Capture Controller Not Completed"
	)
)




MacroScript Mocap_R
	enabledIn:#("max") 
	ButtonText:"Rotation Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Rotation Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Rotation_Motion_Capture "Rotation" Rotation_List "Rotation Motion Capture Controller Not Completed"
	)
)


MacroScript Mocap_S
	enabledIn:#("max") 
	ButtonText:"Scale Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Scale Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Scale_Motion_Capture "Scale" Scale_List "Scale Motion Capture Controller Not Completed"
	)
)


MacroScript Reactor_P
	enabledIn:#("max") 
	ButtonText:"Position Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Position_Reactor "Pos" Position_List "Position Reaction Controller Not Completed"
	)
)




MacroScript Reactor_R
	enabledIn:#("max") 
	ButtonText:"Rotation Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Rotation_Reactor "Rotation" Rotation_List "Rotation Reaction Controller Not Completed"
	)
)


MacroScript Reactor_S
	enabledIn:#("max") 
	ButtonText:"Scale Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Scale_Reactor "Scale" Scale_List "Scale Reaction Controller Not Completed"
	)
)


MacroScript Script_P
	enabledIn:#("max", "viz") 
	ButtonText:"Position Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Position_Script "Pos" Position_List "Position Script Controller Not Completed"
	)
)




MacroScript Script_R
	enabledIn:#("max", "viz") 
	ButtonText:"Rotation Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Rotation_Script "Rotation" Rotation_List "Rotation Script Controller Not Completed"
	)
)


MacroScript Script_S
	enabledIn:#("max", "viz") 
	ButtonText:"Scale Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Scale_Script "Scale" Scale_List "Scale Script Controller Not Completed"
	)
)


MacroScript XYZ_P
	enabledIn:#("max", "viz") 
	ButtonText:"Position XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"XYZ Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Position_XYZ "Pos" Position_List "Position XYZ Controller Not Completed"
	)
)




MacroScript EulerXYZ_R
	enabledIn:#("max", "viz") 
	ButtonText:"Euler XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Euler XYZ Controller"
	SilentErrors:(Debug != True) 
	
(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection Euler_XYZ "Rotation" Rotation_List "Euler XYZ Controller Not Completed"
	)
)


MacroScript XYZ_S
	enabledIn:#("max", "viz") 
	ButtonText:"Scale XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"XYZ Scale Controller"
	SilentErrors:(Debug != True) 
	
(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection ScaleXYZ "Scale" Scale_List "Scale XYZ Controller Not Completed"
	)
)

MacroScript Slave_P
	enabledIn:#("max", "viz") 
	ButtonText:"Slave Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Position Controller"
	SilentErrors:(Debug != True) 

(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection SlavePos "Pos" Position_List "Slave Position Controller Not Completed"			
	)
)




MacroScript Slave_R
	enabledIn:#("max", "viz") 
	ButtonText:"Slave Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Rotation Controller"
	SilentErrors:(Debug != True) 

(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection SlaveRotation "Rotation" Rotation_List "Slave Rotation Controller Not Completed"
	)
)


MacroScript Slave_S
	enabledIn:#("max", "viz") 
	ButtonText:"Slave Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection SlaveScale "Scale" Scale_List "Slave Scale Controller Not Completed"
	)
)

MacroScript Spring_P
	enabledIn:#("max") 
	ButtonText:"Spring Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Spring Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection SpringPositionController "Pos" Position_List "Spring Position Controller Not Completed"			
	)
)




MacroScript Smooth_R
	enabledIn:#("max", "viz") 
	ButtonText:"Smooth Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Smooth Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			for node in selection do
			(
				local controllerClass = classof node.controller
				if not (controllerClass == BipSlave_Control or
						controllerClass == XRef_Controller or
						(controllerClass == IK_ControllerMatrix3Controller and 
						 node.controller[1].controller == undefined)) then
				(
					-------------------------------------------------------------------------------------------
					-- Skip group members, only apply to head
					-------------------------------------------------------------------------------------------
					local h = node.parent 
					if not (h != undefined and h.isSelected and isGroupHead h) then
					(				
						-------------------------------------------------------------------------------------------
						-- Add List Controller
						-------------------------------------------------------------------------------------------
						
						local cont = AddListController node "Rotation" Rotation_List 
						
						-------------------------------------------------------------------------------------------
						-- Add Constraint
						---------------------------------------------------------------------------------------
						If classof cont[listCtrl.GetActive cont].object != Smooth_Rotation then controller = AddConstraint node "Rotation" bezier_rotation true
							else controller = cont[listCtrl.GetActive cont].object
				
						-------------------------------------------------------------------------------------------
						-- Set Active Controller
						-------------------------------------------------------------------------------------------
								
						SetActiveController cont controller
						
						-- the script used to select the selected node here, but I don't see why, and 
						-- it would now break the loop on selected nodes
					)
				)
			)
		)
		Catch (MessageBox "Smooth Rotation Controller Not Completed" Title:"Controller")

--		AssignControllerSelection Smooth_Rotation "Rotation" Rotation_List "Smooth Rotation Controller Not Completed"
	)
)

MacroScript TCB_P
	enabledIn:#("max", "viz") 
	ButtonText:"TCB Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Position Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection TCB_Position "Pos" Position_List "TCB Position Controller Not Completed"			
	)
)



MacroScript TCB_R
	enabledIn:#("max", "viz") 
	ButtonText:"TCB Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Rotation Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection TCB_Rotation "Rotation" Rotation_List "TCB Rotation Controller Not Completed"
	)
)

MacroScript TCB_S
	enabledIn:#("max", "viz") 
	ButtonText:"TCB Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Scale Controller"
	SilentErrors:(Debug != True) 


(
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)

	on execute do 
	(
		AssignControllerSelection TCB_Scale "Scale" Scale_List "TCB Scale Controller Not Completed"
	)
)


MacroScript PRS
	enabledIn:#("max", "viz") 
	ButtonText:"PRS Controller"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"PRS Controller" 
	SilentErrors:(Debug != True)
	
(		
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		Try 
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			for node in selection do
			(
				local controllerClass = classof node.controller
				if not (controllerClass == BipSlave_Control or
						controllerClass == XRef_Controller or
						(controllerClass == IK_ControllerMatrix3Controller and 
						 node.controller[1].controller == undefined)) then
				(
					-------------------------------------------------------------------------------------------
					-- Skip group members, only apply to head
					-------------------------------------------------------------------------------------------
					local h = node.parent 
					if not (h != undefined and h.isSelected and isGroupHead h) then
					(				
						local constraint
						constraint = node.Transform.controller
						if Classof constraint != prs() do
						(
							node.Transform.controller = prs()
						)
					)
				)
			)
				
		)
		Catch (MessageBox "PRS Controller Not Completed" Title:"Controllers")
	)
)

MacroScript Transform_script
	enabledIn:#("max", "viz") 
	ButtonText:"Transform Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Transform Script" 
	SilentErrors:(Debug != True)
	
(		
	-- Check to see if any valid node is selected
	on isEnabled do
	(
		IsValidControllerSelection()
	)
	 
	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF selection.count == 1 AND getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			for node in selection do
			(
				local controllerClass = classof node.controller
				if not (controllerClass == BipSlave_Control or
						controllerClass == XRef_Controller or
						(controllerClass == IK_ControllerMatrix3Controller and 
						 node.controller[1].controller == undefined)) then
				(
					-------------------------------------------------------------------------------------------
					-- Skip group members, only apply to head
					-------------------------------------------------------------------------------------------
					local h = node.parent 
					if not (h != undefined and h.isSelected and isGroupHead h) then
					(				
						local constraint
						constraint = node.Transform.controller
						if Classof constraint != transform_script() do
						(
							node.Transform.controller = transform_script()
						)
					)
				)
			)
				
		)
		Catch (MessageBox "Transform Script Controller Not Completed" Title:"Controllers")
	)
)
