--
-- @file Macro_Hair.mcr
--
-- @author Gonzalo Rueda <grueda@animatedpixel.com>
--
-- $Started: 2004/08/02 $
-- $Date: 2006/08/10 03:27:27 $
-- $Revision: 1.1 $
--
-- @brief   These are the macro scripts declared by Hair.
--
-- Copyright Joe Alter, Inc. 2004 
--
-- This work may not be duplicated, in whole or part, without the express
-- written permission of Joe Alter, Inc.
--


macroScript Hair_AddMod 
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Add Hair Modifier"
            buttontext:"Add Hair Modifier"
(
   on execute do
   (
      if $ != undefined then
      (
         hair.addMod $
		   setCommandPanelTaskMode mode:#create
		   setCommandPanelTaskMode mode:#modify
		   completeRedraw()
      )
   )
)


macroScript Hair_AddEffect
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Add Hair Effect"
            buttontext:"Add Hair Effect"
(
   on execute do
   (
      hair.addEffect true
   )
)


macroScript Hair_Purge
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Purge"
            buttontext:"Purge"
(
   on execute do
   (
      hair.Purge()
   )
)


macroScript Hair_AddHairProperties
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Add hair properties"
            buttontext:"Add Hair Properties"
(
   on execute do
   (
      if $ != undefined then
      (
         hair.AddHairProperties $
      )
   )
)


macroScript Hair_ConvertHairsToMesh
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Convert Hairs To Mesh"
            buttontext:"ConvertHairsToMesh"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()

			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)

			if currentModifier != undefined then currentModifier.ConvertToMesh instance:obj
			break
		 )
      )
   )
)


macroScript Hair_ConvertHairsToSplines
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Convert Hairs To Splines"
            buttontext:"ConvertHairsToSplines"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)
			
			if currentModifier != undefined then currentModifier.ConvertHairsToSplines instance:obj
			break
		 )
      )
   )
)

macroScript Hair_ConvertGuidesToSplines
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Convert Guides To Splines"
            buttontext:"ConvertGuidesToSplines"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)
			
			if currentModifier != undefined then currentModifier.ConvertGuidesToSplines instance:obj
			break
		 )
      )
   )
)

macroScript Hair_CopyHairdo
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Copy Hairdo"
            buttontext:"CopyHairdo"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)

			if currentModifier != undefined then currentModifier.CopyHairdo instance:obj
			break
		 )
      )
   )
)

macroScript Hair_PasteHairdo
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Paste Hairdo"
            buttontext:"Paste Hairdo"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)

			if currentModifier != undefined then currentModifier.PasteHairdo instance:obj
			break
		 )
      )
   )
)

macroScript Hair_ReplaceRest
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Replace Rest"
            buttontext:"ReplaceRest"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)
			
			if currentModifier != undefined then currentModifier.ResetRest instance:obj
			break
		 )
      )
   )
)

macroScript Hair_RegrowHair
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Regrow Hair"
            buttontext:"RegrowHair"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()
			
			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)
			
			if currentModifier != undefined then currentModifier.RegrowHair instance:obj
			break
		 )
      )
   )
)

macroScript Hair_ClearHairInstanceMesh
			enabledIn:#("max") --rl: 2006.12.12 added product switch
            category:"Hair and Fur" 
            internalCategory:"Hair" 
            tooltip:"Clear Hair InstanceMesh"
            buttontext:"ClearHairInstanceMesh"
(
   on execute do
   (
      if $ != undefined then
      (
         for obj in $ do 
		 (
			--modifier = getActiveHairMod()

			currentModifier = undefined			
			if getCommandPanelTaskMode() == #modify then
			(
				modifier = modPanel.getCurrentObject()
				if modifier != undefined then
				(
					if isKindOf modifier HairMod == true then
					(
						currentModifier = modifier
					)		
				)	
			)

			if currentModifier != undefined then currentModifier.ClearInstance()
			break
		 )
      )
   )
)
