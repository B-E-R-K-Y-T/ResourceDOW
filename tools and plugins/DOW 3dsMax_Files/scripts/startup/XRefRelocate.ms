--
-- Macro script for relocating xref objects
--


global XRefRelocateToolIsActive = false


macroScript XRefRelocateTool
	category:"XRefRelocateTool"
	toolTip:"Relocates XRef objects in a max file"
(
	XRefRelocateToolIsActive = true

	--
	-- main rollout:
	--
	rollout XRefRelocate_main "Settings"
	(
		listbox XRefNames "XRef Objects in Scene" height:10
		button DoRelocate "Relocate..." width:100	tooltip:"Relocate the currently selected XRef file" across:2
		button DoRefresh "Refresh" width:100	tooltip:"Relocate the currently selected XRef file"

		function CheckFilesTheSame newname oldname =
		(
			local new_objs = getMAXFileObjectNames newname
			
			-- Go through the XRef objects in the scene and see if we can find an object with the same
			-- name in the new xref file

			for each in $* do  
			(  
				if classof each == XRefObject then  
				(
					if (each.filename == oldname) then
					(
						local nameToFind = each.objectName as name
						
						if ((findItem new_objs nameToFind) == 0) then
						(
							return false
						)
					)
				)
			)
			
			return true
		)

		function RelocateXRefObject = 
		(
			sel = XRefNames.selected
			
			newname = getOpenFileName "Choose the new location of the file" types:"Max Files(*.max)|*.max"
			
			if (newname == undefined) then
			(
				MessageBox("Relocation cancelled");
			)
			else
			(
				doconvert = true
				
				-- pop up a query box to warn the artists if the files hold different objects
				if ((CheckFilesTheSame newname sel)== false) then
				(
					doconvert = queryBox "The files have different objects in them, are you sure you want to convert?"
				)
				
				-- Do the conversion:				
				if (doconvert == true) then
				(
					count = 0
					
					for each in $* do  
					(  
						if classof each == XRefObject then  
						(
							sOldPath = each.filename 
							sOldName = getFilenameFile sOldPath
							
							if (sOldPath == sel) then
							(
								-- We've found an object with the same xref object name. Relocate it!
								each.filename = newname
								count = count + 1;
							)
						)
					)
					
					MessageBox("Replaced " + (count as string) + " XRef Objects")
				)
				else
				(
					MessageBox("Conversion Cancelled")
				)
			)
		)


		function FillListBox =
		(
			-- Walk through xref objects and add the filename to the listbox
			local Sel = #();

			for each in $* do  
			(  
				if classof each == XRefObject then  
				(
					-- only add the file once
					if ((findItem Sel each.filename) == 0) then
					(
						append Sel each.filename
					)											
				)
			)			
			XRefNames.items = Sel
		)
		
		
		
		on DoRelocate pressed do (
			RelocateXRefObject()
				
			-- Reinit the listbox
			FillListBox()					
		)
		
		

		on DoRefresh pressed do (
			FillListBox()
		)
	
		on XRefRelocate_main open do 
		( 
			-- Fill the list box with all the objects in the scene
			FillListBox()
		)
	)

	--
	-- about rollout:
	--

	rollout XRefRelocate_about "About"(
		label xref_about1  "XRef Relocator"
		label xref_about2  "Version 1.0 for 3D Studio max 5.1"
		label xref_about4  "(c) Relic Entertainment"
		label xref_about5  ""
		label xref_about6  "Created by Nick Waanders"
	)


	XRefRelocate_floater = newrolloutfloater "XRef Relocator" 800 245 200 100					-- create the floater

	addrollout XRefRelocate_main		XRefRelocate_floater											-- add the main rollout
	addrollout XRefRelocate_about		XRefRelocate_floater rolledup:true							-- add the about rollout

)


