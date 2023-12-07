/*
Easy Bones Creation MacroScript File

 Created:  		April 18 2000

 Author :   Frank DeLise
 Version:  3ds max 4

 IK tools
 This script increases workflow on Bones and IK.
 
 
 Revision History:
 
	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products

 
*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



macroScript Bones 
enabledIn:#("max") --pfb: 2003.12.11 added product switch
category:"Inverse Kinematics" 
internalCategory:"Inverse Kinematics" 
tooltip:"Bones IK Chain" 
buttontext:"Bones IK Chain" 
Icon:#("MainToolbar",49)
(
    on execute do  StartObjectCreation Bones 
    on isChecked return mcrUtils.IsCreating Bones 
)


MacroScript Auto_Bones
enabledIn:#("max") --pfb: 2003.12.11 added product switch
ButtonText:"Bone Options"
Category:"Animation Tools" --pfb: 2003.12.11 falls under the animation tools, just like the Bones Tools dialog
internalCategory:"Animation Tools"  --pfb: 2003.12.11 falls under the animation tools, just like the Bones Tools dialog
Tooltip:"Bone Options" 
Icon:#("MainToolbar",49)

(

	On Execute do
	(
		If ABone_Roll != undefined then Try(DestroyDialog ABone_Roll)Catch() 
		Rollout ABone_Roll "Bone Options"
		(
			CheckBox ABone_ON "Bone On\Off" Across:2 Checked:False
			Button ABone_ReAlign "ReAlign" Width:80 Align:#Right 
			CheckBox ABone_Auto "Auto Align" Across:2 Enabled:False Checked:False
			Button ABone_ResetStretch "Reset Stretch" Width:80 Offset:[5,0] Enabled:False
			CheckBox ABone_Freeze "Freeze Length" Enabled:False Checked:False
			RadioButtons ABone_ScaleType Labels:#("Scale", "Squash", "None") Enabled:False
			CheckBox ABone_SLinks "Show Links" Across:2 Checked:False
			CheckBox ABone_LinksOnly "Show Links Only" Across:2 Checked:False Offset:[-10,0]
			Button ABone_Sel "Update Selected" Width:150
			Label ABone_1 "----" 
		
			
		
			fn Eval_ABone = 
			(
				Try(
				For i in 1 to Selection.count do
				(
					Selection[i].SetBoneEnable ABone_On.Checked SliderTime
					Selection[i].BoneAutoAlign = ABone_Auto.Checked
					Selection[i].BoneFreezeLength = ABone_Freeze.Checked
					Selection[i].ShowLinks = ABone_SLinks.Checked
					Selection[i].ShowLinksOnly = ABone_LinksOnly.Checked
					
					Case ABone_ScaleType.State of
					(
						1:(Selection[i].BoneScaleType = #Scale)
						2:(Selection[i].BoneScaleType = #Squash) 
						3:(Selection[i].BoneScaleType = #None)  
					)
					ABone_1.text = ("Auto Boned " + i as string + " Object(s)")
				)
				If Selection.Count == 0 then ABone_1.text = ("No Objects Selected")
				)
				Catch()
			) 
			
			On ABone_SLinks Changed State do (Eval_ABone();completeRedraw()  )
			On ABone_LinksOnly Changed State do (Eval_ABone();completeRedraw()  )
			
			On ABone_Sel Pressed Do (Eval_ABone())
			On Abone_On Changed State Do
			(
				ABone_Auto.Enabled = State
				ABone_ResetStretch.Enabled = State
				ABone_Freeze.Enabled = State
				ABone_ScaleType.Enabled = State
				ABone_1.Enabled = State
				Eval_ABone ()
			)
			On ABone_Freeze Changed State Do (Eval_ABone())
			On ABone_ScaleType Changed State Do (Eval_ABone())
			On ABone_Auto Changed State Do (Eval_ABone())
			On ABone_ReAlign Pressed do 
			(	
				For i in 1 to Selection.count do
				(
					Try(
					Selection[i].ReAlignBoneToChild ()
					ABone_1.text = ("ReAligned " + i as string + " Object(s)")
					)Catch()
				)
				If Selection.Count == 0 then ABone_1.text = ("No Objects Selected")
			)
			On ABone_ResetStretch Pressed do 
			(
				
				For i in 1 to Selection.count do
				(
					Try(
					Selection[i].ResetBoneStretch ()
					ABone_1.text = ("Reset Stretch On " + i as string + " Object(s)")
					)Catch()
				)
				If Selection.Count == 0 then ABone_1.text = ("No Objects Selected")
				
			)
			
			
	)
		CreateDialog ABone_Roll Pos:[150,150] Width:200 height:160
		
	
)

)
