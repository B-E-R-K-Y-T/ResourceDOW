/*


Macro Script that converts selected Lights into mental ray area lights

Revision History:


	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		migrated bug fixes from the "utility-mentalry_ConvertAreaLights.ms"


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

*/

macroScript ConvertToAreaLight
enabledIn:#("max") --pfb: 2003.12.12 added product switch
category:"mental ray"  
internalCategory:"mental ray"  
tooltip:"Convert to Area Light" 
buttontext:"Convert to Area Light" 
(

	include "stdplugs\stdscripts\Light-mentalray_AreaOmni.ms" --LOC_Notes: do not localize this
	include "stdplugs\stdscripts\Light-mentalray_AreaSpot.ms" --LOC_Notes: do not localize this

	local Alight, Sel_props, Sel_Objs, tg, Sel_converted
----------------------------------------------------------------------------------------
-- Added Jan 30 2001 2 Functions for saving and recalling volume light info
----------------------------------------------------------------------------------------
	fn GetVolumeInfo CurLight=
	(
		local VolList=#()
		if numAtmospherics != 0 do for j = 1 to numAtmospherics do
			(
			TempAtmos = GetAtmospheric j
			for q = 1 to TempAtmos.numgizmos  do 
				(
				PGizLight = getgizmo TempAtmos q
				if PGizLight == curlight do append VolList j
				)
			
			)
		vollist
	)
	
	fn SetVolumeInfo VolList CurLight =
	(
		for i = 1 to VolList.count do
			(
			TempAtmos = GetAtmospheric VolList[i]
			AppendGizmo TempAtmos CurLight
			)
	)
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
	

on isEnabled return (Filters.Is_Light selection[1]) and (classof selection[1] != miAreaLight)

On Execute Do
(
		local isInvalidLightsInSelection = true
		local sel_Objs = Selection as array
		
		if Sel_Objs.count < 1 then messagebox "Please Select Some Lights to convert" title:"Convert Area Lights" --LOC_Notes: localize this
		
		sel_converted = #()

		for i in 1 to Sel_Objs.count do
		(
----------------------------------------------------------------------------------------		
-- This remembers which volume light if any are on the current light.
----------------------------------------------------------------------------------------
		VLNum = GetVolumeInfo Sel_Objs[i]	
		--print vlnum
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
			if (SuperClassof Sel_Objs[i]) == light then
				(
					--checks if the light contained in the selection set is valid or not
					case of
					(
						------------------------------------------------------------------------------------------
						--Omnilights
						(classof Sel_Objs[i] == Omnilight):
							(
								ALight = miarealightomni ()
								Alight.transform = Sel_Objs[i].transform
								ALight.omnilight.raytracedshadows = Sel_Objs[i].raytracedshadows
								if Sel_Objs[i].includelist != undefined do 
									ALight.omnilight.includelist = Sel_Objs[i].includelist
								if Sel_Objs[i].excludelist != undefined do 
									ALight.omnilight.excludelist = Sel_Objs[i].excludelist
								if Sel_Objs[i].projectormap != undefined do 
									ALight.omnilight.projectormap = Sel_Objs[i].projectormap
								if Sel_Objs[i].shadowprojectormap != undefined do 
									ALight.omnilight.shadowprojectormap = Sel_Objs[i].shadowprojectormap
								Sel_Props = getpropnames Sel_Objs[i]
								try for j in Sel_Props do
									if j != #includelist and j != excludelist and j != #projectormap and j != #shadowprojectormap and j != #Indirect_Illumination_Params and j != #value and j != #type do
										setproperty ALight.omnilight j (getproperty Sel_Objs[i] j) catch ()
								append sel_converted Sel_Objs[i]
								
							)--end case omnilight
							
						------------------------------------------------------------------------------------------
						--Spotlights
						(classof Sel_Objs[i] == freespot or classof Sel_Objs[i] == targetspot):
							(
								ALight = miarealight ()
								Alight.transform = Sel_Objs[i].transform
									if classof Sel_Objs[i] == targetspot do
										(
										tg = targetobject name:(Alight.name + ".target") --LOC_Notes: do not localize this
										tg.transform = Sel_Objs[i].target.transform
										Alight.target = tg
										)
								ALight.targetspot.raytracedshadows = Sel_Objs[i].raytracedshadows
								if Sel_Objs[i].includelist != undefined do 
									ALight.targetspot.includelist = Sel_Objs[i].includelist
								if Sel_Objs[i].excludelist != undefined do 
									ALight.targetspot.excludelist = Sel_Objs[i].excludelist
								if Sel_Objs[i].projectormap != undefined do 
									ALight.targetspot.projectormap = Sel_Objs[i].projectormap
								if Sel_Objs[i].shadowprojectormap != undefined do 
									ALight.targetspot.shadowprojectormap = Sel_Objs[i].shadowprojectormap
								Sel_Props = getpropnames Sel_Objs[i]
								try for j in Sel_Props do
									if j != #includelist and j != excludelist and j != #projectormap and j != #shadowprojectormap and j != #Indirect_Illumination_Params and j != #value and j != #type do
										setproperty ALight.targetspot j (getproperty Sel_Objs[i] j) catch ()
								append sel_converted Sel_Objs[i]
							)--end if spotlight
							
						------------------------------------------------------------------------------------------
						--Directlights
						(classof Sel_Objs[i] == Directionallight or classof Sel_Objs[i] == TargetDirectionallight):
							(
								ALight = miarealight ()
								Alight.transform = Sel_Objs[i].transform
								if classof Sel_Objs[i] == TargetDirectionallight do
									(
									tg = targetobject name:(Alight.name + ".target") --LOC_Notes: do not localize this
									tg.transform = Sel_Objs[i].target.transform
									Alight.target = tg
									)
								ALight.targetspot.raytracedshadows = Sel_Objs[i].raytracedshadows
								if Sel_Objs[i].includelist != undefined do 
									ALight.targetspot.includelist = Sel_Objs[i].includelist
								if Sel_Objs[i].excludelist != undefined do 
									ALight.targetspot.excludelist = Sel_Objs[i].excludelist
								if Sel_Objs[i].projectormap != undefined do 
									ALight.targetspot.projectormap = Sel_Objs[i].projectormap
								if Sel_Objs[i].shadowprojectormap != undefined do 
									ALight.targetspot.shadowprojectormap = Sel_Objs[i].shadowprojectormap
								Sel_Props = getpropnames Sel_Objs[i]
								try for j in Sel_Props do
									if j != #includelist and j != excludelist and j != #projectormap and j != #shadowprojectormap and j != #Indirect_Illumination_Params and j != #value and j != #type do
										setproperty ALight.targetspot j (getproperty Sel_Objs[i] j) catch ()
								if Alight.targetspot.coneshape == 1 then
									(
									Alight.Area_Type = 2
									Alight.Disc_Radius = Sel_Objs[i].falloff
									)
								  else
								  	(
									Alight.Area_Type = 1
									Alight.Rectangle_Height = Sel_Objs[i].falloff/Sel_Objs[i].aspect*2
									Alight.Rectangle_Width = Sel_Objs[i].falloff*2
									)
								append sel_converted Sel_Objs[i]
							)--end if directlights
						
						------------------------------------------------------------------------------------------
						--Default
						default: messagebox ("The selected light cannot be converted to an mr Area light:\n" + (Sel_Objs[i].name) + " \nIt will be skipped by the utility.") title:"Convert Selected Lights" --LOC_Notes: localize this
					)--end case

				)--end if selected object classof light

			if VLnum != OK do SetVolumeInfo VLnum Alight				
		)
		if sel_converted.count > 0 do
		(
			if querybox "Delete Old Lights?" then --LOC_Notes: localize this
			(

					for i in 1 to sel_converted.count do
						(
		
						undo on (Delete sel_converted[i])
				
						)


			)--end then
			else
			(

					for i in 1 to sel_converted.count do
						(
		
						undo on ( Try(sel_converted[i].on = false)Catch ())
				
						)


			)--end else
		)--end if sel_converted.count > 0 do
	
	)--end on execute

)--end macro
