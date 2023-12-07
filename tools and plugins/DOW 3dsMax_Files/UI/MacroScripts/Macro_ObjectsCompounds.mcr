-- Macro_Scripts File
-- Purpose:  define action for each creatable Compound objects to hook up to the create main menu (or quads)

/*
Revision History
	July 6 2006, Pierre-Felix Breton
		Added the Pro Boolean to 3dsmax 9

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	24 Mai 2003: Pierre-felix Breton
		created for 3ds MAX 6
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



----------------------------------------------------------------------------------------------------
macroScript Terrain 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects Compounds" 
internalCategory:"Objects Compounds" 
tooltip:"Terrain Compound Object" 
buttontext:"Terrain" 
Icon:#("Compound",4)
(
   on execute do StartObjectCreation Terrain 
   on isChecked return (mcrUtils.IsCreating Terrain)
   on isEnabled return okToCreate Terrain

)

----------------------------------------------------------------------------------------------------
macroScript Morph 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
category:"Objects Compounds" 
internalCategory:"Objects Compounds" 
tooltip:"Morph Compound Object" 
buttontext:"Morph" 
Icon:#("Compound",1)
(
   on execute do StartObjectCreation Morph
   on isChecked return (mcrUtils.IsCreating Morph)
   on isEnabled return okToCreate Morph

)

----------------------------------------------------------------------------------------------------
macroScript Conform 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
category:"Objects Compounds" 
internalCategory:"Objects Compounds" 
tooltip:"Conform Compound Object" 
buttontext:"Conform" 
Icon:#("Compound",2)
(
   on execute do StartObjectCreation Conform
   on isChecked return (mcrUtils.IsCreating Conform)
   on isEnabled return okToCreate Conform
)

----------------------------------------------------------------------------------------------------
macroScript ShapeMerge 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"ShapeMerge Compound Object" 
            buttontext:"ShapeMerge" 
            Icon:#("Compound",3)
(
   on execute do StartObjectCreation ShapeMerge
   on isChecked return (mcrUtils.IsCreating ShapeMerge)
   on isEnabled return (okToCreate ShapeMerge)
)

----------------------------------------------------------------------------------------------------
macroScript Loft 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"Loft Compound Object" 
            buttontext:"Loft" 
            Icon:#("Compound",8)
(
   on execute do StartObjectCreation Loft
   on isChecked return (mcrUtils.IsCreating Loft)
   on isEnabled return okToCreate Loft

)

----------------------------------------------------------------------------------------------------
macroScript Scatter 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"Scatter Compound Object" 
            buttontext:"Scatter" 
            Icon:#("Compound",5)
(
   on execute do StartObjectCreation Scatter
   on isChecked return (mcrUtils.IsCreating Scatter)
   on isEnabled return okToCreate Scatter

)

----------------------------------------------------------------------------------------------------
macroScript Connect 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"Connect Compound Object" 
            buttontext:"Connect" 
            Icon:#("Compound",6)
(
    on execute do StartObjectCreation Connect
   on isChecked return (mcrUtils.IsCreating Connect)
   on isEnabled return okToCreate Connect

)

----------------------------------------------------------------------------------------------------
macroScript Boolean 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"Boolean Compound Object" 
            buttontext:"Boolean" 
            Icon:#("Compound",7)
(
   on execute do StartObjectCreation Boolean2
   on isChecked return (mcrUtils.IsCreating Boolean2)
   on isEnabled return okToCreate Boolean2

)

----------------------------------------------------------------------------------------------------
macroScript BlobMesh 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"BlobMesh Compound Object" 
            buttontext:"BlobMesh " 
            --Icon:#("Compound",5)
(
   on execute do StartObjectCreation BlobMesh 
   on isChecked return (mcrUtils.IsCreating BlobMesh )
   on isEnabled return okToCreate BlobMesh 

)

----------------------------------------------------------------------------------------------------
macroScript Mesher 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"MesherCompound Object" 
            buttontext:"Mesher" 
            --Icon:#("Compound",5)
(
   on execute do StartObjectCreation Mesher 
   on isChecked return (mcrUtils.IsCreating Mesher )
   on isEnabled return okToCreate Mesher 

)

----------------------------------------------------------------------------------------------------
macroScript ProBoolean 
enabledIn:#("max")
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"ProBoolean Compound Object" 
            buttontext:"ProBoolean" 
            Icon:#("PowerBoolean",7)
(
   on execute do StartObjectCreation ProBoolean
   on isChecked return (mcrUtils.IsCreating ProBoolean)
   on isEnabled return okToCreate ProBoolean
)

----------------------------------------------------------------------------------------------------
macroScript Procutter
enabledIn:#("max")
            category:"Objects Compounds" 
            internalCategory:"Objects Compounds" 
            tooltip:"ProCutter Compound Object" 
            buttontext:"ProCutter" 
            Icon:#("PowerBoolean",9)
(
   on execute do StartObjectCreation ProCutter
   on isChecked return (mcrUtils.IsCreating ProCutter)
   on isEnabled return okToCreate ProCutter
)