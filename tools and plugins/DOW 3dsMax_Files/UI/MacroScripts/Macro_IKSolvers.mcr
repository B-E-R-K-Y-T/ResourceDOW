/*
   
Easy IK Assignment MacroScript File

Revision History:

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


This script increases workflow on assigning IK Solvers.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 
*/


MacroScript HD_IK
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"HD Solver"
	Category:"Inverse Kinematics" 
	internalCategory:"Inverse Kinematics" 
	Tooltip:"History-Dependent IK Solver" 
	Icon:#("MainToolbar",49)
	SilentErrors:(Debug == undefined or Debug != True)

(
	
			
	on isEnabled return selection.count == 1 or 
						selection.count > 1 and
						(
							local h = selection[1].parent 
							h != undefined and h.isSelected and isGroupHead h
						)
	 
	on execute do 
	(
		Global EC_OBJ, EC_TargetObj
		
		Animate Off
		(
			EC_OBJ = selection[1]
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn ChildFilt o = Filters.Is_Child EC_OBJ o or Filters.Is_Parent EC_OBJ o
			
			-------------------------------------------------------------------------------------------
						
			EC_TargetOBJ = PickObject count:1 select:false filter:ChildFilt count:#Multiple Message:"Pick Joint to complete IK Chain" Rubberband:EC_OBJ.pos ForceListenerFocus:False
			
			If EC_TargetOBJ != #escape and EC_TargetOBJ != undefined then 
			(
				if Filters.Is_Child EC_OBJ EC_TargetOBJ then
				(
					NIK = HDiksys.ikchain EC_OBJ EC_TargetOBJ True
									
				)
				Else
				(
					NIK = HDiksys.ikchain  EC_TargetOBJ EC_OBJ True
				)
		
				
			)
				
			Max Motion Mode
		)
		
	)		

)
MacroScript HI_IK
enabledIn:#("max") --pfb: 2003.12.12 added product switch
	ButtonText:"HI Solver"
	Category:"Inverse Kinematics" 
	internalCategory:"Inverse Kinematics" 
	Tooltip:"History-Independent IK Solver" 
	Icon:#("MainToolbar",49)
	SilentErrors:(Debug == undefined or Debug != True)

(
	
	
	-- Check to see if something is selected
		
	on isEnabled return selection.count == 1 or 
						selection.count > 1 and
						(
							local h = selection[1].parent 
							h != undefined and h.isSelected and isGroupHead h
						)
	 
	on execute do 
	(
		Global EC_OBJ, EC_TargetObj
					
		Animate off
		(	
			EC_OBJ = selection[1]
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn ChildFilt o = Filters.Is_Child EC_OBJ o or Filters.Is_Parent EC_OBJ o
			
			-------------------------------------------------------------------------------------------
						
			EC_TargetOBJ = PickObject count:1 select:false filter:ChildFilt count:#Multiple Message:"Pick Joint to complete IK Chain" Rubberband:EC_OBJ.pos ForceListenerFocus:False
			
			If EC_TargetOBJ != #escape and EC_TargetOBJ != undefined then 
			(
				if Filters.Is_Child EC_OBJ EC_TargetOBJ then
				(
					NIK = iksys.ikchain EC_OBJ EC_TargetOBJ "IKHISolver"
				)
				Else
				(
					NIK = iksys.ikchain  EC_TargetOBJ EC_OBJ "IKHISolver"
				)
							
			)
			Max Motion Mode
		)
					
	)		

)

MacroScript IK_Limb
enabledIn:#("max") --pfb: 2003.12.12 added product switch
	ButtonText:"IK Limb Solver"
	Category:"Inverse Kinematics" 
	internalCategory:"Inverse Kinematics" 
	Tooltip:"IK Limb Solver" 
	Icon:#("MainToolbar",49)
	SilentErrors:(Debug == undefined or Debug != True)

(
	
		
	-- Check to see if something is selected
		
	on isEnabled return selection.count == 1 or 
						selection.count > 1 and
						(
							local h = selection[1].parent 
							h != undefined and h.isSelected and isGroupHead h
						)
	 
	on execute do 
	(
		Global EC_OBJ, EC_TargetObj		
		EC_OBJ = selection[1]
		
		-------------------------------------------------------------------------------------------
		-- Define Filter Function for PickObject Selection
		-------------------------------------------------------------------------------------------
		
		fn ChildFilt o = Filters.Is_Child EC_OBJ o or Filters.Is_Parent EC_OBJ o
		
		-------------------------------------------------------------------------------------------
			
		Animate off
		(
			EC_TargetOBJ = PickObject count:1 select:false filter:ChildFilt Message:"Pick Joint to complete IK Chain" count:#Multiple Rubberband:EC_OBJ.pos ForceListenerFocus:False
			
			If EC_TargetOBJ != #escape and EC_TargetOBJ != undefined then 
			(
				if Filters.Is_Child EC_OBJ EC_TargetOBJ then
				(
					NIK = iksys.ikchain EC_OBJ EC_TargetOBJ "IKLimb"
				)
					Else
				(
					NIK = iksys.ikchain EC_TargetOBJ EC_OBJ  "IKLimb"
				)
						
			)
			
			Max Motion Mode
		)
			
	)	
)



MacroScript SPLINE_IK
enabledIn:#("max") --pfb: 2003.12.12 added product switch
	ButtonText:"SplineIK Solver"
	Category:"Inverse Kinematics" 
	internalCategory:"Inverse Kinematics" 
	Tooltip:"Spline IK Solver" 
	Icon:#("MainToolbar",49)
	SilentErrors:(Debug == undefined or Debug != True)

(
	Global EC_OBJ, EC_TargetObj, EC_SplineOBJ, EC_HelperOBJ
	
	-- Check to see if something is selected
	on isEnabled return selection.count == 1 or 
						selection.count > 1 and
						(
							local h = selection[1].parent 
							h != undefined and h.isSelected and isGroupHead h
						)
	 
	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
		
					
		Animate off
		(	
			-------------------------------------------------------------------------------------------
			-- Define Filter Functions for PickObject Selection
			-------------------------------------------------------------------------------------------			
			fn ChildFilt o = Filters.Is_Child EC_OBJ o or Filters.Is_Parent EC_OBJ o
			fn ShapeFilt o = superClassOf o == Shape and o != EC_OBJ
			-------------------------------------------------------------------------------------------
						
			EC_TargetOBJ = PickObject count:1 select:false filter:ChildFilt count:#Multiple Message:"Pick Joint to complete IK Chain" Rubberband:EC_OBJ.pos ForceListenerFocus:False			
			If EC_TargetOBJ != #escape and EC_TargetOBJ != undefined then 
			(
				if Filters.Is_Child EC_OBJ EC_TargetOBJ then
				(
					NIK = iksys.IKChain  EC_OBJ EC_TargetOBJ "SplineIKSolver"
				)
				Else
				(
					NIK = iksys.IKChain  EC_TargetOBJ EC_OBJ "SplineIKSolver"
				)
							
			)
			
			EC_SplineOBJ = PickObject count:1 select:false filter:ShapeFilt count:#Multiple Message:"Pick Spline to assign SplineIK" Rubberband:EC_TargetOBJ.pos ForceListenerFo
			
			If EC_SplineOBJ != undefined and EC_SplineOBJ != "None" then
			(
				-------------------------------------------------------------------------------------------
				-- Make the Spline the goal shape of the SplineIK
				-------------------------------------------------------------------------------------------
				NIK.transform.controller.pickShape = EC_SplineOBJ		
								
				-------------------------------------------------------------------------------------------			
				-- Add SplinIKControl Modifier and Create Helpers
				-------------------------------------------------------------------------------------------		
				mod = Spline_IK_Control()
				AddModifier EC_SplineOBJ (mod)
				mod.createHelper(0)
				EC_HelperOBJ = mod.helper_list[1]
				
				-- Set the upnode to the first helper
				NIK.controller.upnode = EC_HelperObj

				-------------------------------------------------------------------------------------------
				-- Add List Controller and Path Constraint
				-------------------------------------------------------------------------------------------
				local cont
				if Filters.Is_Child EC_OBJ EC_TargetOBJ then
				(
					cont = AddListController EC_OBJ "Pos" Position_List
					If classof cont[listCtrl.GetActive cont].object != Path_Constraint then constraint = AddConstraint EC_OBJ "Pos" Path_Constraint true
					else constraint = cont[listCtrl.GetActive cont].object
				)
				else
				(
					cont = AddListController EC_TargetOBJ "Pos" Position_List
					If classof cont[listCtrl.GetActive cont].object != Path_Constraint then constraint = AddConstraint EC_TargetOBJ "Pos" Path_Constraint true
					else constraint = cont[listCtrl.GetActive cont].object
				)

				-------------------------------------------------------------------------------------------
				-- Add Path Constraint Object Target as the spline
				-------------------------------------------------------------------------------------------		
				constraint.AppendTarget EC_SplineObj 50
				DeleteKeys constraint.percent.controller
				constraint.percent = 0.0
							
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
				
				--Format "%\n"  (EC_OBJ.name + " is Position Constrained to " + EC_HelperOBJ.name) to:Listener
							
				Select EC_OBJ
			)	

			Max Motion Mode
		)
		
		)
		Catch (MessageBox "SplineIK Not Completed" Title:"IK")
					
	)		

)





