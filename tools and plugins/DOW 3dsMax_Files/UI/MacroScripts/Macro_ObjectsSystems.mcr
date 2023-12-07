/*
Macro_Scripts File
Purposes:  
    
	define action for each creatable System object to hook up to the create main menu (or quads)
	defines macros for Quads

Revision History

	2 aug 2004, Pierre-Felix Breton
		added 3ds max r7 objects

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


	26 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6

*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

-----------------------------------------------------------------------------------------
-- Day Light System
-----------------------------------------------------------------------------------------

macroScript DayLight 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
category:"Lights and Cameras"
internalCategory:"Lights and Cameras"
ButtonText:"Daylight System"
tooltip:"Daylight System" 
icon:#("Systems",2)
(
     on execute do 
	 	(
			StartObjectCreation Daylight
			
			local currentExpCtrl = sceneExposureControl.exposureControl
			
			
			--with mental ray renderer, looks for a mr photgraphic exp with daylight
			if (classof renderers.current == mental_ray_renderer) then
			(
				if (classof currentExpCtrl == mr_Photographic_Exposure_Control) do 
				(
					if ((currentExpCtrl.exposure_value == 15) and (currentExpCtrl.active == true)) do return()
				)
				local answer
				answer = QueryBox "You are creating a Daylight Object.\n\n  It is recommended that you use the mr Photographic Exposure Control set to an Exposure Value of EV = 15.\n\n  Would you like to change this now?" \
					title:"Daylight Object Creation" beep:false

				if answer == true do 
				(
					-- only create a new one if the current one is not a mr Photographic Exposure Control
					if (classof currentExpCtrl != mr_Photographic_Exposure_Control) do 
					(
						sceneExposureControl.exposureControl = mr_Photographic_Exposure_Control()
					)
					
					sceneExposureControl.exposureControl.active = true
					sceneExposureControl.exposureControl.exposure_mode = 0
					sceneExposureControl.exposureControl.exposure_value = 15
				)
			)
			--looks for a log exp with daylight
			else
			(
				if (classof currentExpCtrl == Logarithmic_Exposure_Control) do 
				(
					if ((currentExpCtrl.exteriordaylight == true) and (currentExpCtrl.active == true)) do return()
				)
				local answer
				answer = QueryBox "You are creating a Daylight Object.\n\n It is recommended that you use the Logarithmic Exposure Control with the Exterior Daylight Flag.\n\n Would you like to change this now?" \
					title:"Daylight Object Creation" beep:false

				if answer == true do 
				(
					-- only create a new one if the current one is not a Logarithmic Exposure Control
					if (classof currentExpCtrl != Logarithmic_Exposure_Control) do 
					(
						sceneExposureControl.exposureControl = Logarithmic_Exposure_Control()
					)
					sceneExposureControl.exposureControl.active = true
					sceneExposureControl.exposureControl.exteriordaylight = true
				)
			)
					
		)
     on isChecked return mcrUtils.IsCreating Daylight
)


macroScript SunLight 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
category:"Lights and Cameras"
internalCategory:"Lights and Cameras"
ButtonText:"Sunlight System"
tooltip:"Sunlight System" 
(
     on execute do 
	 	(
			StartObjectCreation Sunlight
		)
     on isChecked return mcrUtils.IsCreating Sunlight
)


-----------------------------------------------------------------------------------------
macroScript RingArray
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Systems" 
            internalCategory:"Objects Systems" 
            tooltip:"Ring Array" 
            buttontext:"Ring Array" 
            --Icon:#("SW_GeoDef",7)
(
    on execute do StartObjectCreation Ring_Array 
    on isChecked return mcrUtils.IsCreating Ring_Array
)

-----------------------------------------------------------------------------------------
macroScript Biped
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Systems" 
            internalCategory:"Objects Systems" 
            tooltip:"Biped" 
            buttontext:"Biped" 
            --Icon:#("SW_GeoDef",7)
(
    on execute do StartObjectCreation bipedSystem
    on isChecked return mcrUtils.IsCreating bipedSystem
)

