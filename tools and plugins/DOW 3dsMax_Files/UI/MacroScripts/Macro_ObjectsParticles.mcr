-- Macro_Scripts File
-- Purpose:  define action for each creatable Particles Systems objects to hook up to the create main menu (or quads)

/*
Revision History

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	24 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
	
	Nov 17 1998: Frank Delise
	created
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

---------------------------------------------------------------------------
macroScript PFFindTarget
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Particle Flow Find Target" 
            buttontext:"Find Target" 
            --Icon:#("Particles",3)
(
    on execute do StartObjectCreation Find_Target
    on isChecked return mcrUtils.IsCreating Find_Target
)

---------------------------------------------------------------------------
macroScript PFSpeedByIcon
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Particle Flow Speed by Icon" 
            buttontext:"Speed by Icon" 
            --Icon:#("Particles",3)
(
    on execute do StartObjectCreation SpeedByIcon
    on isChecked return mcrUtils.IsCreating SpeedByIcon
)
---------------------------------------------------------------------------
macroScript PFSource
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"Particle Flow Source Particle System" 
            buttontext:"Particle Flow Source" 
            --Icon:#("Particles",3)
(
    on execute do StartObjectCreation PF_Source
    on isChecked return mcrUtils.IsCreating PF_Source
)
---------------------------------------------------------------------------
macroScript PArray
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"PArray Particle System" 
            buttontext:"PArray" 
            Icon:#("Particles",3)
(
    on execute do StartObjectCreation PArray
    on isChecked return mcrUtils.IsCreating PArray
)
---------------------------------------------------------------------------
macroScript PCloud
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"PCloud Particle System" 
            buttontext:"PCloud" 
            Icon:#("Particles",6)
(
    on execute do StartObjectCreation PCloud 
    on isChecked return mcrUtils.IsCreating PCloud
)
---------------------------------------------------------------------------
macroScript Blizzard
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"Blizzard Particle System" 
            buttontext:"Blizzard" 
            Icon:#("Particles",5)
(
    on execute do StartObjectCreation Blizzard 
    on isChecked return mcrUtils.IsCreating Blizzard
)
---------------------------------------------------------------------------
macroScript SuperSpray
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"Super Spray Particle System"
			buttontext:"Super Spray" 
            Icon:#("Particles",2)
(
    on execute do StartObjectCreation SuperSpray 
    on isChecked return mcrUtils.IsCreating SuperSpray
)
---------------------------------------------------------------------------
macroScript Spray
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"Spray Particle System" 
            buttontext:"Spray" 
            Icon:#("Particles",1)
(
    on execute do StartObjectCreation Spray
    on isChecked return mcrUtils.IsCreating Spray
)
---------------------------------------------------------------------------
macroScript Snow
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Particle Systems" 
            internalCategory:"Objects Particle Systems" 
            tooltip:"Snow Particle System" 
            buttontext:"Snow" 
            Icon:#("Particles",4)
(
    on execute do StartObjectCreation Snow 
    on isChecked return mcrUtils.IsCreating Snow
)
