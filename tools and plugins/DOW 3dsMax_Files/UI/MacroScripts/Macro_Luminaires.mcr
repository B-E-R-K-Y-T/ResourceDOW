-- Macro Scripts File
-- Author:   PF Breton
-- Macro Scripts that offers contextual tools for Luminaires manip

/*
Revision History
    Sept 17 2001, pfb
    Filtering the .falloff property to allow the 'Set View to Luminaire' showing only on supported lights POVs

    Sept 10 2002, pfb
    added macro Luminaire_ChangePhotometricFile

    Sept 26 2002,pfb
    added to VIZ render
	
	4 Juin 2003, pfb
	added to 3dsmax 6
	
	7 Juillet 2003, pfb
	performance optimizations and fixes
	
	12 dec 2003, Pierre-Felix Breton, 
	added product switcher: this macro file can be shared with all Discreet products

	

*/

-- Quads options when right-clicking on a Luminaire Assembly
-- the requires the filterfunc.ms that ships with VIZ (Filters.xxxx commands)
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

--Macro that shows a 'Toggle Roll Angle Manipulator...' in quads
-- required in MAX 5 and above since it toggles the manipulator mode

macroScript Luminaire_EnableManipulators
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Roll Angle Manipulator Toggle"  -- LOC_NOTE: localize this
category:"Luminaires" -- LOC_NOTE: localize this
internalCategory:"Luminaires" -- LOC_NOTE: do not localize this
Tooltip:"Roll Angle Manipulator Toggle" -- LOC_NOTE: localize this

(
	-- this variable will contain the light object found by Is_Luminaire sset
	-- the reason to store this into this variable is to avoid finding the node twice
	-- during the isVisible and execute commands
	
	local lightNodes 
	lightNodes = #()
	
	-- determining if the selection set is a Luminaire Assembly that contains a single light source
	-- returns a boolean value
	fn Is_Luminaire sset = 
	(
		local boolCheckFlag = false
		if sset.count > 0 do
		(
		
			/*
			AssemblyMgr.IsAssembly <selection>
			returns undefined if the selection is NOT a single assembly
			returns the assembly head object if the selection is only on assembly
			*/
			local AsmblyHead
			AsmblyHead = AssemblyMgr.IsAssembly (sset)
			
			if AsmblyHead != undefined do -- the selection is an assembly
			(
				--check if the Assembly head got the ILuminaire interface
				--checking for Luminaire Class would disallow 3rd party luminaires working with this macro
				if (Filters.HasBaseObjectProperty AsmblyHead  #Iluminaire) == true do -- Luminaire
				(
					AssemblyMgr.FilterAssembly AsmblyHead light &lightNodes	 --looks to the member of the assembly AsmblyHead  and set the lightNodes array to all the lights contained into it
					if ((lightNodes.count == 1) and (lightNodes[1].target != undefined)) do boolCheckFlag = true -- there is a single light object in the Luminaire assembly	
				)
			)			
			
		)--end if selection.count > 0
		boolCheckFlag
	)--end fn Is_Luminaire
	
	-- determining if the selection set is a Luminaire Assembly
   On IsChecked Return manipulatemode 
   On IsVisible do	(((Filters.Is_Light selection[1]) and (selection[1].target != undefined)) or (Is_Luminaire (getCurrentSelection())))
    On Execute Do 
	(--execute begin
		actionMan.executeAction 0 "59225"
	)--execute ends
)   --end macroscript



--Macro that shows a 'Change Photometric File...' in quads
macroScript Luminaire_ChangePhotometricFile
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Change Photometric File..."  -- LOC_NOTE: localize this
category:"Luminaires" -- LOC_NOTE: localize this
internalCategory:"Luminaires" -- LOC_NOTE: do not localize this
Tooltip:"Change Photometric File..." -- LOC_NOTE: localize this

(
	-- this variable will contain the light object found by Is_Luminaire sset
	-- the reason to store this into this variable is to avoid finding the node twice
	-- during the isVisible and execute commands
	
	local lightNodes 
	lightNodes = #()
	
	-- determining if the selection set is a Luminaire Assembly that contains a single light source
	-- returns a boolean value
	fn Is_Luminaire sset = 
	(
		local boolCheckFlag = false
		if sset.count > 0 do
		(
		
		/*
		AssemblyMgr.IsAssembly <selection>
		returns undefined if the selection is NOT a single assembly
		returns the assembly head object if the selection is only on assembly
		*/
		local AsmblyHead
		AsmblyHead = AssemblyMgr.IsAssembly sset 
		
		if AsmblyHead != undefined do
		(
			--check if the Assembly head got the ILuminaire interface
			--checking for Luminaire Class would disallow 3rd party luminaires working with this macro
		    if (Filters.HasBaseObjectProperty AsmblyHead  #Iluminaire) == true do -- Luminaire
			(
				AssemblyMgr.FilterAssembly AsmblyHead light &lightNodes	 --looks to the member of the assembly AsmblyHead  and set the lightNodes array to all the lights contained into it
				if (lightNodes.count == 1) and (Filters.HasBaseObjectProperty lightNodes[1] #Distribution) and (lightNodes[1].distribution == 3) do boolCheckFlag = true -- there is a single light object in the Luminaire assembly				
			)--end if
		)
		
		)--end if sset.count
		boolCheckFlag
	)--end fn
	
	-- determining if the selection set is a Luminaire Assembly
    On IsVisible do	(Is_Luminaire (getCurrentSelection()))
    On Execute Do 
	(--execute begin
		local f
		--prompt for browsing to a file
		f = getopenfilename caption:"Select a Photometric File" types:"IES Files(*.ies)|*.ies|CIBSE Files(*.cibse)|*.cibse|LTLI Files(*.ltli)|*.ltli|All Files(*.*)|*.*" \
			filename:(lightNodes[1].webfile)
		
		--assigns the file to the light
		if f != undefined do 
			(
				lightNodes[1].webfile = f
				lightNodes[1].intensity = lightNodes[1].originalintensity --read the intensity in the IES file and resets the light intensity 
			)
	)--execute ends
)   --end macroscript


--Macro that shows a 'Activate Luminaire View' in quads
macroScript Luminaire_ActivateView
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Set View to Selected Luminaire"  -- LOC_NOTE: localize this
category:"Luminaires" -- LOC_NOTE: localize this
internalCategory:"Luminaires" -- LOC_NOTE: do not localize this
Tooltip:"Set View to Selected Luminaire" -- LOC_NOTE: localize this

(
	-- this variable will contain the light object found by Is_Luminaire sset
	-- the reason to store this into this variable is to avoid finding the node twice
	-- during the isVisibal and execute commands
	
	local lightNodes 
	lightNodes = #()
	
	-- determining if the selection set is a Luminaire Assembly that contains a single light source
	-- returns a boolean value
	fn Is_Luminaire sset = 
	(
		local boolCheckFlag = false
		if sset.count > 0 do
		(
		/*
		AssemblyMgr.IsAssembly <selection>
		returns undefined if the selection is NOT a single assembly
		returns the assembly head object if the selection is only on assembly
		*/
		local AsmblyHead
		AsmblyHead = AssemblyMgr.IsAssembly sset 
		
		if AsmblyHead != undefined 	do -- the selection is an assembly
		(
				--check if the Assembly head got the ILuminaire interface
				--checking for Luminaire Class would disallow 3rd party luminaires working with this macro
			    if (Filters.HasBaseObjectProperty AsmblyHead  #Iluminaire) == true do -- Luminaire
				(
					AssemblyMgr.FilterAssembly AsmblyHead light &lightNodes	 --looks to the member of the assembly AsmblyHead  and set the lightNodes array to all the lights contained into it
					if (lightNodes.count == 1) and ((try(viewport.canSetToViewport(lightNodes[1])) catch(false)) and (viewport.getcamera() != lightNodes[1])) == true do boolCheckFlag = true -- there is a single light object in the Luminaire assembly				
				)--end if
		)--end if
		
		)--end if seset.count
		boolCheckFlag 
	)--end fn
	
	-- determining if the selection set is a Luminaire Assembly
    On IsVisible do	(Is_Luminaire (getCurrentSelection()))
    On Execute Do ( Try(viewport.setcamera lightNodes[1]) Catch())
)

--Macro that shows a 'Select Target' in quads
macroScript Luminaire_SelectTarget
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Select Luminaire Target"  -- LOC_NOTE: localize this
category:"Luminaires" -- LOC_NOTE: localize this
internalCategory:"Luminaires" -- LOC_NOTE: do not localize this
Tooltip:"Select Luminaire Target" -- LOC_NOTE: localize this

(
	-- this variable will contain the light object found by Is_Luminaire sset
	-- the reason to store this into this variable is to avoid finding the node twice
	-- during the isVisibal and execute commands
	
	local lightNodes 
	lightNodes = #()
	
	-- determining if the selection set is a Luminaire Assembly that contains a single light source
	-- returns a boolean value
	fn Is_Luminaire sset = 
	(
		local boolCheckFlag = false
		if sset.count > 0 do
		(
		/*
		AssemblyMgr.IsAssembly <selection>
		returns undefined if the selection is NOT a single assembly
		returns the assembly head object if the selection is only on assembly
		*/
		local AsmblyHead
		AsmblyHead = AssemblyMgr.IsAssembly sset 
		
		if AsmblyHead != undefined 	do -- the selection is an assembly
		(
				--check if the Assembly head got the ILuminaire interface
				--checking for Luminaire Class would disallow 3rd party luminaires working with this macro
			    if (Filters.HasBaseObjectProperty AsmblyHead  #Iluminaire) == true do
				(
					AssemblyMgr.FilterAssembly AsmblyHead light &lightNodes	 --looks to the member of the assembly AsmblyHead  and set the lightNodes array to all the lights contained into it
					if ((lightNodes.count == 1) and (IsValidNode (lightNodes[1].target) == true)) do boolCheckFlag = true  -- there is a single light object in the Luminaire assembly
				)
			)
		)--end if sset.count > 0
		boolCheckFlag
	)--end fn
	
	-- determining if the selection set is a Luminaire Assembly
    On IsVisible do	(Is_Luminaire (getCurrentSelection()))
	On Execute Do Try(select lightNodes[1].Target) Catch()
)
