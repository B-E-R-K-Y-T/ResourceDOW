------------------------------------------------------------
-- Tool aligns foot and toes to ground plane
-- ToDo: add hand functionality
------------------------------------------------------------
macroScript BipedLimbAlign
buttonText:"BipedLimbAlign"
category:"Custom Tools" 
tooltip:"Align biped hand/foot with ground plane"
icon:#("Custom_Tools",5)
(

on isEnabled return (selection.count == 1) and (classOf selection[1] == Biped_Object)

on execute do
	(
	------------------------------------------------------------
	-- funtion that returns the number of links in a biped chain
	------------------------------------------------------------
	fn bipedNumLinks bNode =
		(
		if classOf bNode == Biped_Object do
			(
			count = 0
			member = biped.getIdLink bNode
			
			for i = 1 to 16 do
				if (biped.getNode bNode member[1] link:i) != undefined do 
					count += 1
			)
		count
		)
				
	------------------------------------------------------------
	

	
	sel = selection[1]
	selLink = biped.getIdLink sel
	
	if selLink[1] >= 1 and selLink[1] <= 8 do
		(
	
		local toeNodes = #()
		local isHand = false
		--------------------------------------------------
		-- any portion of left arm selected including fingers	
		if selLink[1] == 1 or selLink[1] == 3 do 
			(
			limb = biped.getNode sel 1 link:4
			isHand = true
			)
	
		--------------------------------------------------
		-- any portion of right arm selected including fingers
		if selLink[1] == 2 or selLink[1] == 4 do 
			(
			limb = biped.getNode sel 2 link:4
			isHand = true
			)
		
		--------------------------------------------------
		-- any portion of left leg selected including toes
		if selLink[1] == 5 or selLink[1] == 7 do
			(
			if (limb = biped.getNode sel #lleg link:4) == undefined then
				(
				limb = biped.getNode sel 5 link:3
				for i = 1 to 15 do
					if ((biped.getNode limb 7 link:i) != undefined) then (append toeNodes (biped.getNode limb 7 link:i))
				)
			)
		
		--------------------------------------------------	
		-- any portion of right leg selected including toes	
		if selLink[1] == 6 or selLink[1] == 8 do 
			(
			if (limb = biped.getNode sel #rleg link:4) == undefined then
				(
				limb = biped.getNode sel 6 link:3
				for i = 1 to 15 do
					if ((biped.getNode limb 8 link:i) != undefined) then (append toeNodes (biped.getNode limb 8 link:i))
				)
			)
	
		--------------------------------------------------		
		if isHand then
			(
			)
		else
			(
			--Aligning the Toes with the foot:	
			toeRot = in coordsys limb rotate ((eulerangles 0 0 90) as matrix3) (biped.getTransform limb #Rotation)
			if (toeNodes.count != 0) do 
				for i = 1 to toeNodes.count do 
					biped.setTransform toeNodes[i] #Rotation (toeRot) true
	
			--Aligning the foot with the XY plane:
			limbRot = quatToEuler(biped.getTransform limb #rotation)
			limbRot.y_rotation = 90
			limbRot = EulerToQuat(limbRot)
			biped.setTransform limb #Rotation (limbRot) true
			
			--Moving the Foot Back on the ground:
			ToePos = biped.getTransform toeNodes[1] #Pos
			
			if $'Floor' != undefined then
				(
				ToePos.z = $'Floor'.transform.position.z
				)--end if floor is there
			else
				(
				ToePos.z = 0
				)--end if no floor
			
			biped.setTransform toeNodes[1] #Pos ToePos true
			) -- end else
		) -- end conditional if statement
	) -- end execute
) -- end macroscript
