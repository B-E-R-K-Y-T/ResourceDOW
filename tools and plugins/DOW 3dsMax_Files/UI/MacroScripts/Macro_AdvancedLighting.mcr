/*

Macro_Scripts File
Created:  29 Mai 2003
Author:   PF Breton

Macro_Scripts that lauches the Advanced Lighting Panel and Assigns the desired plugins if none is used yet


Revision History

	29 Mai 2003, Pierre-Felix Breton created
	
	10 dec 2003, Pierre-Felix Breton, 
               added product switcher: this macroscript file can be shared with all Discreet products



*/


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

--------------------------------------------------------------------------------------------------
-- MacroScripts for Lauching the UI
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Radiosity

MacroScript AdvLighting_Radiosity
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
ButtonText:"Radiosity..."
category:"Render" 
internalCategory:"Render" 
Tooltip:"Radiosity..." 
Icon:#("Radiosity",1)
(
	on execute do
	(
		local assignAdvLighting= false
		--shows the panel
		sceneradiosity.showpanel()
		
		if classof sceneradiosity.radiosity == Light_Tracer
		then
		(
			local answer
			answer = QueryBox "Changing the advanced lighting plugin will discard its solution. Are you sure?" \
			title:"Change Advanced Lighting Plugin" beep:false
			
			if answer == true do assignAdvLighting= true
		)--end then
		else
		(
			assignAdvLighting= true
		)--end else

		
		if assignAdvLighting == true do
		(
			--assigns a default engine
			if classof sceneradiosity.radiosity != Radiosity do sceneradiosity.radiosity = Discreet_Radiosity()
		
			--assigns a default exposure control
			if (classof sceneExposureControl.exposureControl == UndefinedClass) do 
			(
				local answer
				answer = QueryBox "You are assigning the Radiosity plugin.\n\n It is recommended that you use a Camera Exposure Control with it.\n\n Would you like to change this now?" \
					title:"Radiosity..." beep:false
	
				if answer == true do sceneExposureControl.exposureControl = Logarithmic_Exposure_Control()
			)
		)--end if assignAdvLighting == true do

	)
	
	on isenabled return ((classof renderers.current == Default_Scanline_Renderer))
)



macroScript LightingAnalysis
ButtonText:"Lighting Analysis..."
category:"Render" 
internalCategory:"Render" 
Tooltip:"Lighting Analysis..."
(

on isEnabled return	((classof sceneradiosity.radiosity == Discreet_Radiosity) and (sceneradiosity.radiosity.CanShowLightingStatistics())) --checks if the lighting analysis tools is available with the engine's current state
On Execute Do
	( 
		Try(sceneradiosity.radiosity.ShowLightingStatistics()) Catch()
	)
)


-------------------------------------------------------------------------------------------------
-- MacroScripts for Quad Controls: Daylight Assemblies
--------------------------------------------------------------------------------------------------
-- store direct illumination of Sunlight located inside a Daylight assembly
macroScript RadProperty_StoreSun
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
category:"Render"
internalCategory:"Render"
buttonText:"Store Direct Illumination: Sun"
Tooltip:"Store Direct Illumination: Sun"
( --macroScript RadTool_StoreSun begin

	fn notRadiosExcluded obj =
	(
		((obj.globalIlluminationByLayer and not obj.layer.isGIExcluded) or
		(not obj.globalIlluminationByLayer and not obj.isGIExcluded))
	)
	
	--visibility of menu item
	on isVisible return 
	(
		if classof (assemblyMgr.isassembly selection) != DaylightAssemblyHead then false
		else 
		(
			sunObj = (assemblyMgr.isassembly selection).sun
			if sunObj == undefined then false
				else 
				(
				local sunobj2
				for i in selection do 
					if classof i == IES_Sun or classof i == Directionallight do sunObj2 = i
				if sunObj2 != undefined do notRadiosExcluded sunObj2
				)
				)
	)--end on isvisible
	
	-- status of property					
	on isChecked return 
	(
		if classof (assemblyMgr.isassembly selection) != DaylightAssemblyHead then false
		else 
			if (assemblyMgr.isassembly selection).sun == undefined then false
			else
			(
				sunObj = (assemblyMgr.isassembly selection).sun
				if sunObj == undefined then false
					else 
					(
					local sunobj2
						for i in selection do 
							if classof i == IES_Sun or classof i == Directionallight do sunObj2 = i
						if sunObj2 != undefined do notRadiosExcluded sunObj2 and sunObj2.storeIllumToMesh
					)
			)
	)--end on ischecked
	
	-- execution
	on execute do		
	(
		local sunobj2
		for i in selection do 
			if classof i == IES_Sun or classof i == Directionallight do sunObj2 = i
		sunObj2.globalIlluminationByLayer = false
		sunObj2.storeIllumToMesh = not sunObj2.storeIllumToMesh
	)--end on execute
	
) --macroScript RadTool_StoreSun end



-- store direct illumination of skylight located inside a Daylight assembly
macroScript RadProperty_StoreSky
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
category:"Render"
internalCategory:"Render"
buttonText:"Store Direct Illumination: Sky"
Tooltip:"Store Direct Illumination: Sky"

( --macroScript RadTool_Storesky begin

	fn notRadiosExcluded obj =
	(
		((obj.globalIlluminationByLayer and not obj.layer.isGIExcluded) or
		(not obj.globalIlluminationByLayer and not obj.isGIExcluded))
	)
	
	--visibility of menu item
	on isVisible return 
	(
		if classof (assemblyMgr.isassembly selection) != DaylightAssemblyHead then false
		else 
		(
			skyObj = (assemblyMgr.isassembly selection).sky
			if skyObj == undefined then false
				else 
				(
				local skyobj2
				for i in selection do 
					if classof i == IES_sky or classof i == Texture_Sky do skyObj2 = i
				if skyObj2 != undefined do notRadiosExcluded skyObj2
				)
				)
	)--end on isvisible
	
	-- status of property					
	on isChecked return 
	(
		if classof (assemblyMgr.isassembly selection) != DaylightAssemblyHead then false
		else 
			if (assemblyMgr.isassembly selection).sky == undefined then false
			else
			(
				skyObj = (assemblyMgr.isassembly selection).sky
				if skyObj == undefined then false
					else 
					(
					local skyobj2
						for i in selection do 
							if classof i == IES_sky or classof i == Texture_Sky do skyObj2 = i
						if skyObj2 != undefined do notRadiosExcluded skyObj2 and skyObj2.storeIllumToMesh
					)
			)
	)--end on ischecked
	
	-- execution
	on execute do		
	(
		local skyobj2
		for i in selection do 
			if classof i == IES_sky or classof i == Texture_Sky do skyObj2 = i
		skyObj2.globalIlluminationByLayer = false
		skyObj2.storeIllumToMesh = not skyObj2.storeIllumToMesh
	)--end on execute
	
) --macroScript RadTool_Storesky end


MacroScript Exposure_Control
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
ButtonText:"Exposure Control..."
category:"Render" 
internalCategory:"Render" 
Tooltip:"Exposure Control.." 
Icon:#("Exposure",1)
(
	on execute do 
	(
		--assigns a default exposure control
		if sceneExposureControl.exposureControl == undefined do 
				sceneExposureControl.exposureControl = Logarithmic_Exposure_Control()
				actionMan.executeAction 0 "40029" -- LOC NOTE: Do Not Localize this
	)
)

--------------------------------------------------------------------------------------------------
-- Light tracer

MacroScript AdvLighting_LightTracer
enabledIn:#("max") --pfb: 2003.12.11 added product switch
ButtonText:"Light Tracer..."
category:"Render" 
internalCategory:"Render" 
Tooltip:"Light Tracer..." 
--Icon:#("Radiosity",1)
(
	on execute do
(
		local assignAdvLighting= false
		--shows the panel
		sceneradiosity.showpanel()
		
		if classof sceneradiosity.radiosity == Radiosity
		then
		(
			local answer
			answer = QueryBox "Changing the advanced lighting plugin will discard its solution. Are you sure?" \
			title:"Change Advanced Lighting Plugin" beep:false
			
			if answer == true do assignAdvLighting= true
		)--end then
		else
		(
			assignAdvLighting= true
		)--end else

		
		if assignAdvLighting == true do
		(
			--assigns a default engine
			if classof sceneradiosity.radiosity != Light_Tracer do sceneradiosity.radiosity = Light_Tracer()

		)--end if assignAdvLighting == true do

	)


	
	on isenabled return ((classof renderers.current == Default_Scanline_Renderer) )
)
