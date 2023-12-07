/*
Macro_Scripts File
Purposes:  
    
	define action for each creatable Spacewarp object to hook up to the create main menu (or quads)
	defines macros for Quads

Revision History

	2 aug 2004, Pierre-Felix Breton
		added 3ds max r7 objects

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	26 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
	
	28 jan 1999: Frank Delise
	created

*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

-----------------------------------------------------------------------------------------
macroScript SpaceBend 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Bend Space Warp"
            buttontext:"Bend"
            Icon:#("SW_ModBased",1)
(
    on execute do StartObjectCreation SpaceBend
    on isChecked return mcrUtils.IsCreating SpaceBend
)
-----------------------------------------------------------------------------------------
macroScript SpaceTaper 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Taper Space Warp" 
            buttontext:"Taper" 
            Icon:#("SW_ModBased",2)
(
    on execute do StartObjectCreation SpaceTaper
    on isChecked return mcrUtils.IsCreating SpaceTaper
)
-----------------------------------------------------------------------------------------
macroScript SpaceNoise 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Noise Space Warp" 
            buttontext:"Noise" 
            Icon:#("SW_ModBased",3)
(
    on execute do StartObjectCreation SpaceNoise
    on isChecked return mcrUtils.IsCreating SpaceNoise
)
-----------------------------------------------------------------------------------------
macroScript SpaceTwist 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Twist Space Warp" 
            buttontext:"Twist" 
            Icon:#("SW_ModBased",4)
(
    on execute do StartObjectCreation SpaceTwist
    on isChecked return mcrUtils.IsCreating SpaceTwist
)
-----------------------------------------------------------------------------------------
macroScript SpaceSkew 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Skew Space Warp" 
            buttontext:"Skew" 
            Icon:#("SW_ModBased",5)
(
    on execute do StartObjectCreation SpaceSkew
    on isChecked return mcrUtils.IsCreating SpaceSkew
)
-----------------------------------------------------------------------------------------
macroScript SpaceStretch 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Stretch Space Warp" 
            buttontext:"Stretch" 
            Icon:#("SW_ModBased",6)
(
    on execute do StartObjectCreation SpaceStretch
    on isChecked return mcrUtils.IsCreating SpaceStretch
)
-----------------------------------------------------------------------------------------
macroScript Ripple 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Ripple Space Warp" 
            buttontext:"Ripple" 
            Icon:#("SW_GeoDef",6)
(
    on execute do StartObjectCreation SpaceRipple
    on isChecked return mcrUtils.IsCreating SpaceRipple
)

-----------------------------------------------------------------------------------------
macroScript FFD_Cyl 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"FFD(Cyl) Space Warp" 
			ButtonText:"FFD(Cyl)" 
            Icon:#("SW_GeoDef",5)
(
    on execute do StartObjectCreation SpaceFFDCyl
    on isChecked return mcrUtils.IsCreating SpaceFFDCyl
)

-----------------------------------------------------------------------------------------
macroScript FFD_Box 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"FFD(Box) Space Warp"
			ButtonText:"FFD(Box)"
            Icon:#("SW_GeoDef",1)
(
    on execute do StartObjectCreation SpaceFFDBox
    on isChecked return mcrUtils.IsCreating SpaceFFDBox
)
-----------------------------------------------------------------------------------------
macroScript Motor 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Motor Space Warp" 
            buttontext:"Motor" 
            Icon:#("SW_PartDyn",3)
(
    on execute do StartObjectCreation Motor
    on isChecked return mcrUtils.IsCreating Motor
)
-----------------------------------------------------------------------------------------
macroScript Pbomb 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"PBomb Space Warp" 
            buttontext:"PBomb" 
            Icon:#("SW_PartDyn",4)
(
    on execute do StartObjectCreation PBomb 
    on isChecked return mcrUtils.IsCreating PBomb 
)
-----------------------------------------------------------------------------------------
macroScript Push 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Push Space Warp" 
            buttontext:"Push" 
            Icon:#("SW_PartDyn",5)
(
    on execute do StartObjectCreation PushSpaceWarp 
    on isChecked return mcrUtils.IsCreating PushSpaceWarp 
)

-----------------------------------------------------------------------------------------
macroScript Vortex 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Vortex Space Warp" 
            buttontext:"Vortex" 
            --Icon:#("SW_PartDyn",5)
(
    on execute do StartObjectCreation Vortex 
    on isChecked return mcrUtils.IsCreating Vortex 
)

-----------------------------------------------------------------------------------------
macroScript Drag 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Drag Space Warp" 
            buttontext:"Drag" 
            --Icon:#("SW_PartDyn",5)
(
    on execute do StartObjectCreation Drag 
    on isChecked return mcrUtils.IsCreating Drag 
)
-----------------------------------------------------------------------------------------
macroScript SDynaFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"SDynaFlect Space Warp" 
            buttontext:"SDynaFlect" 
            Icon:#("SW_DynInt",2)
(
    on execute do StartObjectCreation SDynaFlect
    on isChecked return mcrUtils.IsCreating SDynaFlect
)
-----------------------------------------------------------------------------------------
macroScript PDynaFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"PDynaFlect Space Warp" 
            buttontext:"PDynaFlect" 
            Icon:#("SW_DynInt",3)
(
    on execute do StartObjectCreation PDynaFlect 
    on isChecked return mcrUtils.IsCreating PDynaFlect 
)
-----------------------------------------------------------------------------------------
macroScript UDynaFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"UDynaFlect Space Warp" 
            buttontext:"UDynaFlect" 
            Icon:#("SW_DynInt",4)
(
    on execute do StartObjectCreation UDynaFlect 
    on isChecked return mcrUtils.IsCreating UDynaFlect 
)

-----------------------------------------------------------------------------------------
macroScript POmniFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"POmniFlect Space Warp" 
            buttontext:"POmniFlect" 
            Icon:#("SW_PartOnly",1)
(
    on execute do StartObjectCreation POmniFlect 
    on isChecked return mcrUtils.IsCreating POmniFlect 
)

-----------------------------------------------------------------------------------------
macroScript SOmniFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"SOmniFlect Space Warp" 
            buttontext:"SOmniFlect" 
            Icon:#("SW_PartOnly",5)
(
    on execute do StartObjectCreation SOmniFlect 
    on isChecked return mcrUtils.IsCreating SOmniFlect 
)

-----------------------------------------------------------------------------------------
macroScript UOmniFlect 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"UOmniFlect Space Warp" 
            buttontext:"UOmniFlect" 
            Icon:#("SW_PartOnly",2)
(
    on execute do StartObjectCreation UOmniFlect 
    on isChecked return mcrUtils.IsCreating UOmniFlect 
)
-----------------------------------------------------------------------------------------
macroScript SDeflector 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"SDeflector Space Warp" 
            buttontext:"SDeflector" 
            Icon:#("SW_PartOnly",6)
(
    on execute do StartObjectCreation SDeflector 
    on isChecked return mcrUtils.IsCreating SDeflector 
)
-----------------------------------------------------------------------------------------
macroScript UDeflector 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"UDeflector Space Warp" 
            buttontext:"UDeflector" 
            Icon:#("SW_PartOnly",7)
(
    on execute do StartObjectCreation UDeflector 
    on isChecked return mcrUtils.IsCreating UDeflector 
)


-----------------------------------------------------------------------------------------
macroScript Wave 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Wave Space Warp" 
            buttontext:"Wave" 
            Icon:#("SW_GeoDef",2)
(
    on execute do StartObjectCreation SpaceWave 
    on isChecked return mcrUtils.IsCreating SpaceWave 
)

-----------------------------------------------------------------------------------------
macroScript Gravity 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Gravity Space Warp" 
            buttontext:"Gravity" 
            Icon:#("SW_PartDyn",1)
(
    on execute do StartObjectCreation Gravity 
    on isChecked return mcrUtils.IsCreating Gravity 
)

-----------------------------------------------------------------------------------------
macroScript Wind 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Wind Space Warp" 
            buttontext:"Wind" 
            Icon:#("SW_PartDyn",2)
(
    on execute do StartObjectCreation Wind 
    on isChecked return mcrUtils.IsCreating Wind 
)

-----------------------------------------------------------------------------------------
macroScript Displace 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Displace Space Warp" 
            buttontext:"Displace" 
            Icon:#("SW_GeoDef",3)
(
    on execute do StartObjectCreation SpaceDisplace 
    on isChecked return mcrUtils.IsCreating SpaceDisplace 
)

-----------------------------------------------------------------------------------------
macroScript Deflector 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Deflector Space Warp" 
            buttontext:"Deflector" 
            Icon:#("SW_Partonly",4)
(
    on execute do StartObjectCreation Deflector 
    on isChecked return mcrUtils.IsCreating Deflector 
)

-----------------------------------------------------------------------------------------
macroScript Bomb  
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Bomb Space Warp" 
            buttontext:"Bomb" 
            Icon:#("SW_GeoDef",4)
(
    on execute do StartObjectCreation Bomb 
    on isChecked return mcrUtils.IsCreating Bomb 
)

-----------------------------------------------------------------------------------------
macroScript Path_Follow 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Path Follow Space Warp" 
            buttontext:"Path Follow" 
            Icon:#("SW_Partonly",3)
(
    on execute do StartObjectCreation Path_Follow
    on isChecked return mcrUtils.IsCreating Path_Follow
)
-----------------------------------------------------------------------------------------
macroScript SpaceConform 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Conform Space Warp" 
            buttontext:"Conform" 
            Icon:#("SW_GeoDef",7)
(
    on execute do StartObjectCreation ConformSpacewarp 
    on isChecked return mcrUtils.IsCreating ConformSpacewarp 
)

-----------------------------------------------------------------------------------------
macroScript Vector_Field
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Space Warps" 
            internalCategory:"Objects Space Warps" 
            tooltip:"Vector Field Space Warp" 
            buttontext:"Vector Field" 
            --Icon:#("SW_GeoDef",7)
(
    on execute do StartObjectCreation Vector_Field 
    on isChecked return mcrUtils.IsCreating Vector_Field
)

