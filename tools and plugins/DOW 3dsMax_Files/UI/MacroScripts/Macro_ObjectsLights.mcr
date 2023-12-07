/*

  Macro_Scripts File
Purposes:  
    
	define action for each creatable Light object to hook up to the create main menu (or quads)
	defines macros for Quads

Revision History

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	9 Juillet 2003: Pierre-Felix Breton
	performance improvements, optimizations

	26 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
	
	April 22 2002: Fred Ruff
	created for 3ds MAX 5
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



--***********************************************************************************************
--Standard Lights

-------------------------------------------------------------------------------------------
macroScript Omni_Light 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            tooltip:"Omni Light"
			ButtonText:"Omni" 
            icon:#("Lights",3)
(
     on execute do StartObjectCreation OmniLight 
     on isChecked return mcrUtils.IsCreating OmniLight 
) 
-------------------------------------------------------------------------------------------
macroScript Target_Spotlight
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Target Spotlight" 
            tooltip:"Target Spotlight" 
            icon:#("Lights",1)
(
     on execute do StartObjectCreation Targetspot 
     on isChecked return mcrUtils.IsCreating Targetspot 
)
-------------------------------------------------------------------------------------------
macroScript Target_Directional_Light 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            ButtonText:"Target Directional" 
            tooltip:"Target Directional" 
            icon:#("Lights",2)
(
     on execute do StartObjectCreation TargetDirectionalLight 
     on isChecked return mcrUtils.IsCreating TargetDirectionalLight 
)
-------------------------------------------------------------------------------------------
macroScript Free_Spotlight 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            ButtonText:"Free Spotlight"
            tooltip:"Free Spotlight" 
            icon:#("Lights",4)
(
     on execute do StartObjectCreation FreeSpot 
     on isChecked return mcrUtils.IsCreating FreeSpot 
)
-------------------------------------------------------------------------------------------
macroScript Directional_Light
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Directional"
            tooltip:"Free Directional" 
            icon:#("Lights",5)
(
     on execute do StartObjectCreation DirectionalLight 
     on isChecked return mcrUtils.IsCreating DirectionalLight 
)
-------------------------------------------------------------------------------------------
macroScript Skylight
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Skylight"
            tooltip:"Skylight" 
(
     on execute do StartObjectCreation Skylight
     on isChecked return mcrUtils.IsCreating Skylight
)


--***********************************************************************************************
--Mental Ray Scripted Lights
--dependency on the following files: \stdplugs\stdscripts\Light-mentalray_AreaOmni.ms and Light-mentalray_AreaSpot.ms

-------------------------------------------------------------------------------------------
macroScript AreaOmni
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"mr Area Omni"
            tooltip:"mental ray Area Omni" 
(
     on execute do StartObjectCreation miAreaLightOmni
     on isChecked return mcrUtils.IsCreating miAreaLightOmni
)

-------------------------------------------------------------------------------------------
macroScript AreaSpot
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"mr Area Spot"
            tooltip:"mental ray Area Spot" 
(
     on execute do StartObjectCreation miAreaLight
     on isChecked return mcrUtils.IsCreating miAreaLight
)


--***********************************************************************************************
--Photometric Lights


--------------------------------------------------------------------------------------------------
macroScript Free_Point 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Free Point"
            tooltip:"Free Point Photometric" 
            icon:#("PhotometricLights",3)
(
     on execute do StartObjectCreation Free_Point
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------

macroScript Free_Linear 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Free Linear"
            tooltip:"Free Linear Photometric" 
            icon:#("PhotometricLights",6)
(
     on execute do StartObjectCreation Free_Linear
     on isChecked return mcrUtils.IsCreating Free_Linear
)
--------------------------------------------------------------------------------------------------
macroScript Target_Point 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Target Point"
            tooltip:"Target Point Photometric" 
            icon:#("PhotometricLights",2)
(
     on execute do StartObjectCreation Target_Point
     on isChecked return mcrUtils.IsCreating Target_Point
)


--------------------------------------------------------------------------------------------------
macroScript Target_Linear 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Target Linear"
            tooltip:"Target Linear Photometric" 
            icon:#("PhotometricLights",7)
(
     on execute do StartObjectCreation Target_Linear
     on isChecked return mcrUtils.IsCreating Target_Linear
)

--------------------------------------------------------------------------------------------------
macroScript Free_Area 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Free Area"
            tooltip:"Free Area Photometric" 
            icon:#("PhotometricLights",4)
(

     on execute do StartObjectCreation Free_Area
     on isChecked return mcrUtils.IsCreating Free_Area
)


--------------------------------------------------------------------------------------------------
macroScript Target_Area 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Target Area"
            tooltip:"Target Area Photometric" 
            icon:#("PhotometricLights",5)
(
     on execute do StartObjectCreation Target_Area
     on isChecked return mcrUtils.IsCreating Target_Area
)
--------------------------------------------------------------------------------------------------
macroScript mr_Sky_Portal
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"mr Sky Portal"
            tooltip:"mental ray Sky Portal" 
(
     on execute do StartObjectCreation mr_Sky_Portal
     on isChecked return mcrUtils.IsCreating mr_Sky_Portal
     on IsVisible Return isKindOf mr_Sky_Portal  MAXWrapper 
)
--------------------------------------------------------------------------------------------------
macroScript mr_Sky
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"mr Sky light"
            tooltip:"mental ray Sky" 
(
     on execute do StartObjectCreation mr_Sky
     on isChecked return mcrUtils.IsCreating mr_Sky
     on IsVisible Return isKindOf mr_Sky  MAXWrapper 
)
--------------------------------------------------------------------------------------------------
macroScript mr_Sun
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"mr Sun"
            tooltip:"mental ray Sun" 
(
     on execute do StartObjectCreation mr_Sun
     on isChecked return mcrUtils.IsCreating mr_Sun
     on IsVisible Return isKindOf mr_Sun  MAXWrapper 
)


-----------------------------------------------------------------------------------------
-- Preset Physically Based Lights
-----------------------------------------------------------------------------------------

-- POINT LIGHTS - isotropic distributions

--------------------------------------------------------------------------------------------------
-- point generic 40W bulb
macroScript Free_40W_Bulb
enabledIn:#("max", "viz", "vizr") -- new for viz 2006
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"40W Bulb"
            tooltip:"40W Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 38
			n.useMultiplier = on
		)

	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

-- point generic 60W bulb
macroScript Free_60W_Bulb
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"60W Bulb"
            tooltip:"60W Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 70
			n.useMultiplier = on
		)

	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- point generic 75W bulb
macroScript Free_75W_Bulb
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
	ButtonText:"75W Bulb"
            tooltip:"75W Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 95
			n.useMultiplier = on		
		)

	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- point generic 100W bulb
macroScript Free_100w_Bulb
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"100W Bulb"
            tooltip:"100W Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 139
			n.useMultiplier = on
		)

	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- free generic Halogen bulbs
macroScript Free_21W_Halogen_Bulb
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"21W Halogen Bulb"
            tooltip:"21W Halogen Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = on 
		 	n.kelvin = 2950
			n.distribution = 0
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 21
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- free generic Halogen bulb
macroScript Free_35W_Halogen_Bulb
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"35W Halogen Bulb"
            tooltip:"35W Halogen Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = on 
		 	n.kelvin = 3050
			n.distribution = 0
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 32
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- free generic Halogen bulb
macroScript Free_50W_Halogen_Bulb
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"50W Halogen Bulb"
            tooltip:"50W Halogen Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = on 
		 	n.kelvin = 2750
			n.distribution = 0
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 64
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- free generic Halogen bulb
macroScript Free_80W_Halogen_Bulb
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"80W Halogen Bulb"
            tooltip:"80W Halogen Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = on 
		 	n.kelvin = 2900
			n.distribution = 0
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 119
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- free generic Halogen bulb 
macroScript Free_100W_Halogen_Bulb 
enabledIn:#("max", "viz", "vizr") 
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"100W Halogen Bulb"
            tooltip:"100W Halogen Bulb" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = on 
		 	n.kelvin = 2900
			n.distribution = 0
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 161
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)


--------------------------------------------------------------------------------------------------
-- point generic Halogen spot
macroScript Free_Halogen_Spot
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Halogen Spotlight"
            tooltip:"Halogen Spotlight" 
            icon:#("PhotometricLights",3)
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 247.56 219.467  --sets the 'halogen' color
			n.distribution = 1 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.hotSpot = 25
			n.falloff = 50 --pfb; dec 5 2001 
			n.Intensity = 3000
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)
--------------------------------------------------------------------------------------------------
-- POINT LIGHTS - web distributions

-- point recessed lamp 75W
macroScript Free_Recessed_Medium_Lamp
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Recessed 75W Lamp (web)"
            tooltip:"Recessed 75W Lamp (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
			n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\point_recessed_medium_75W.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "point_recessed_medium_75W.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 1100
			n.useMultiplier = on
		)

	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)
--------------------------------------------------------------------------------------------------
-- point recessed wallwash lamp 75W
macroScript Free_Recessed_WallWash_Lamp_Low
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Recessed 75W Wallwash (web)"
            tooltip:"Recessed 75W Wallwash (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 247.56 219.467
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\point_recessed_wallwash_75W.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "point_recessed_wallwash_75W.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 1200
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)
--------------------------------------------------------------------------------------------------
-- point recessed wallwash lamp 250W
macroScript Free_Recessed_WallWash_Lamp_High
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Recessed 250W Wallwash (web)"
            tooltip:"Recessed 250W Wallwash (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 253.227 229.229 --sets the 'fluorescent' color
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\point_recessed_wallwash_250W.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "point_recessed_wallwash_250W.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 4010
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)
--------------------------------------------------------------------------------------------------
-- point street lamp
macroScript Free_Street_Lamp
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Street 400W Lamp (web)"
            tooltip:"Street 400W Lamp (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 230.363 204 --sets the 'metal halide' color
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\point_street.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "point_street.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 50000
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Free_Point newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Point
)

--------------------------------------------------------------------------------------------------
-- point stadium lamp
macroScript Target_Stadium_Lamp
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"Stadium 1000W Lamp (web)"
            tooltip:"Stadium 1000W Lamp (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
		 if iskindof n Light do
		 (

			n.useKelvin = off --forces to use the color dropdown
		    n.rgb = color 255 250.435 225.056 --sets the 'metal halide' color
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\point_stadium.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "point_stadium.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 110000
			n.useMultiplier = on
		)
	 )
     on execute do StartObjectCreation Target_Point newNodeCallback:setProps

     on isChecked return mcrUtils.IsCreating Target_Point
)


--------------------------------------------------------------------------------------------------
-- LINEAR
-- linear pendant fluorescent
macroScript Free_Fluorescent_Pendant 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"4ft Pendant Fluorescent (web)"
            tooltip:"4ft Pendant Fluorescent (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 253.227 229.229 --sets the 'fluorescent' color
			n.distribution = 3 -- sets to a webfile
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\linear_pendant.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "linear_pendant.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 3200
			n.light_length = InchesToSystemScale(48) --calls a dimension conversion function defined in the \stdplugs\editfunction.ms
			n.useMultiplier = on
			n.storeIllumToMesh = true
		)

	 )
     on execute do StartObjectCreation Free_Linear newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Linear
)

--------------------------------------------------------------------------------------------------
-- linear cove fluorescent
macroScript Free_Fluorescent_Cove 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
			ButtonText:"4ft Cove Fluorescent (web)"
            tooltip:"4ft Cove Fluorescent (web)" 

(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(	 
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 253.227 229.229 --sets the 'fluorescent' color
			n.distribution = 3 -- sets to a webfile	
			n.intensityType = 0 --sets to be in lumens rather than in cd
			if ProductAppID == #VIZR then
			(
				n.webfile = (getDir #maxroot) + "ies\\linear_cove.ies" --LOC NOTE: do not localize this
			)
			else
			(
				n.webfile = "linear_cove.ies" --LOC NOTE: do not localize this
			)
			n.Flux = 2900
			n.light_length = InchesToSystemScale(48) --calls a dimension conversion function defined in the \stdplugs\editfunction.ms
			n.useMultiplier = on
			n.storeIllumToMesh = true
			n.zrotation = 90
		)

	 )
     on execute do StartObjectCreation Free_Linear newNodeCallback:setProps
     on isChecked return mcrUtils.IsCreating Free_Linear
)



--------------------------------------------------------------------------------------------------

--***********************************************************************************************
-- Light Commands

------------------------------------------------------------------------------------------
MacroScript Light_On
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Light On"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Light On/Off Toggle" 
(
	On IsVisible Return
		Try ( Filters.Is_Light $ and (Filters.HasBaseObjectProperty $ #on) )
		Catch ( false )
	on ischecked Return
		Try (if isProperty $ #on do $.on) 
		Catch ( false )
	
	On Execute Do
		Try (if isProperty $ #on do $.on = not $.on)
		Catch ()
	on altexecute type do (macros.run "Lights and Cameras" "Light_List") -- loc_notes: do not localize this
)



------------------------------------------------------------------------------------------
MacroScript Light_Shadows
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Cast Shadows"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Shadows On/Off Toggle" 
(

	On IsVisible Return
		Try ( ((Filters.Is_Light $) and (Filters.HasBaseObjectProperty $ #CastShadows)) ) 
		Catch ( false )
	On isEnabled Return
		Try ( not ((Filters.HasBaseObjectProperty $ #AmbientOnly) and ($.baseObject.AmbientOnly))) 
		Catch ( true )
	on ischecked Return
		Try ( $.baseObject.castShadows ) Catch ( false )
	On Execute Do 
		Try ($.baseObject.castShadows = (not $.baseObject.castShadows))	
		Catch()

)


------------------------------------------------------------------------------------------
MacroScript Light_AffectDiffuse
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Affect Diffuse"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Affect Diffuse Toggle" 
(

	On IsVisible Return 
		Try ( ((Filters.Is_Light $) and (Filters.HasBaseObjectProperty $ #AffectDiffuse)and (Filters.HasBaseObjectProperty $ #AmbientOnly)) ) -- pfb, aug 30th 2001, added test for properties
		Catch( false )
	On isEnabled Return
		Try ( (not $.baseObject.AmbientOnly) ) -- pfb, aug 30th 2001, added context to be consistant with modify panel
		Catch( true )
	on ischecked Return
		Try ( $.AffectDiffuse ) Catch( false )
	
	On Execute Do
		Try ($.AffectDiffuse = (not $.AffectDiffuse))	
		Catch ()
)

------------------------------------------------------------------------------------------
MacroScript Light_AffectSpecular
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Affect Specular"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Affect Specular Toggle" 
(

	On IsVisible Return
		Try ( ((Filters.Is_Light $) and (Filters.HasBaseObjectProperty $ #AffectSpecular)and (Filters.HasBaseObjectProperty $ #AmbientOnly)) ) -- pfb, aug 30th 2001, added test for properties
		Catch ( false )
	On isEnabled Return 
		Try ( not $.baseObject.AmbientOnly ) -- pfb, aug 30th 2001, added context to be consistant with modify panel
		Catch ( true )
	on isChecked Return
		Try ( $.AffectSpecular ) Catch( false )
	
	On Execute Do 
		Try ($.AffectSpecular = (not $.AffectSpecular)) Catch()
		
)

------------------------------------------------------------------------------------------
MacroScript Light_AmbientOnly
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            ButtonText:"Ambient Only"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Ambient Only Toggle" 
(

	On IsVisible Return
		Try ( ((Filters.Is_Light $) and (Filters.HasBaseObjectProperty $ #AmbientOnly)) ) -- pfb, aug 30th 2001, added test for properties
		Catch ( false )

	on ischecked Do
		Try ( $.AmbientOnly ) Catch( false )
	
	On Execute Do
		Try ($.AmbientOnly = (not $.AmbientOnly)) Catch()
)

------------------------------------------------------------------------------------------
MacroScript Light_SelectTarget
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Select Light Target"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Select Target (Lights)" 
(

	On IsVisible Return
		Try ( ((Filters.Is_Light $) and(IsValidNode $.target)) ) -- pfb, aug 30th 2001, added test for properties so the 'select target' don't show on Omnis anymore
		Catch ( false )

	On Execute Do Try(select $.Target) Catch()

)

-----------------------------------------------------------------------------------------
macroScript Light_ActivateView
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Set View to Selected Light"
category:"Lights and Cameras" 
internalCategory:"Lights and Cameras" 
Tooltip:"Set View to Selected Light"

(

	On IsVisible Return 
		Try ( ((Filters.Is_Light $) and (viewport.getcamera() != $) and (viewport.canSetToViewport $) ) )
		Catch ( false )

	On Execute Do
	( 
		Try(viewport.setcamera $) Catch()
	)
)

MacroScript Light_Viewport_Shadows
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Viewport Shadows"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Viewport Shadows On/Off Toggle" 
(

	On IsVisible Return
		Try ((Filters.Is_Light $)AND (IViewportShadingMgr.IsLightNodeSupported $)) -- pfb, aug 30th 2001, added test for properties
		Catch ( false )
	On isEnabled Return
		Try ( (not $.baseObject.AmbientOnly) and ( $.baseObject.castShadows) and ($.INodeShadingProperties.ViewportIllumination )) -- pfb, aug 30th 2001, added context to be consistant with modify panel
		Catch ( true )
	on ischecked Return
		Try ( $.INodeShadingProperties.ViewportShadowCasting) Catch ( false )
	On Execute Do 
		Try ($.INodeShadingProperties.ViewportShadowCasting = (not $.INodeShadingProperties.ViewportShadowCasting))	
		Catch()
)

MacroScript Light_Viewport_Illumination
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Viewport Lighting"
            category:"Lights and Cameras"
            internalCategory:"Lights and Cameras"
            Tooltip:"Viewport Lighting On/Off Toggle" 
(

	On IsVisible Return
		Try ((Filters.Is_Light $)AND (IViewportShadingMgr.IsLightNodeSupported $)) -- pfb, aug 30th 2001, added test for properties
		Catch ( false )
	On isEnabled Return
		Try ( (not $.baseObject.AmbientOnly) and ($.on )) -- pfb, aug 30th 2001, added context to be consistant with modify panel
		Catch ( true )
	on ischecked Return
		Try ( $.INodeShadingProperties.Viewportillumination) Catch ( false )
	On Execute Do 
		Try ($.INodeShadingProperties.ViewportIllumination = (not $.INodeShadingProperties.ViewportIllumination))	
		Catch()
)
