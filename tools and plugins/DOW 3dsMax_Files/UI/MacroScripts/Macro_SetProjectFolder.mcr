--//////////////////////////////////////////////////////////////////////////////////////////////////////
/*


Create/set project struture  macro

	by pfbreton, David Cunningham, 2006, 3ds max 9
	
	1.	User invokes the Set Project Folder command.
	2.	He his provided with a Browse for Folder dialog and selects a folder.
	3.  The current Path Configuration are backup'ed in the current working folder
	4.	The working directory is changed to the selected directory.
	5.	If the folder contains a *.mxp file, the first *.mxp file is loaded.
	6.	If not, a pre-defined directory structure is created and assigned to the "System Directories"
	7.	A *.mxp file is saved within the directory (to be used the next time..)

*/
--//////////////////////////////////////////////////////////////////////////////////////////////////////
macroScript SetProjectFolder
	category:"Tools" 			-- LOC Notes: Localize this 
	internalCategory:"Tools" 
	tooltip:"Set Project Folder..."				-- LOC Notes: Localize this 
	ButtonText:"Set Project Folder..." 			-- LOC Notes: Localize this 
(
	local _SetProjectFolder_macro_option_promptUser
	local _SetProjectFolder_macro_option_newFolder
	On Execute Do	
	(
		--------------------------------
		--Browse for folder dialog
		--------------------------------
		local strMyFolder= ""
		local strCurrProjectFolder = pathconfig.getCurrentProjectFolder()
		if( _SetProjectFolder_macro_option_promptUser == undefined  or  -- the value hasn't been defined, default to prompt user
			_SetProjectFolder_macro_option_promptUser == true) then
		(
			strMyFolder = getSavePath caption:"Select Project Folder.\n\nThis corresponds to the root of your current project." \
								 initialDir:(strCurrProjectFolder) -- LOC Notes: Localize this 
		)
		else
		(
			-- we use the global value set from within the app
			strMyFolder = _SetProjectFolder_macro_option_newFolder
		)
		-- always default to prompt the user
		_SetProjectFolder_macro_option_promptUser = true

		--user selected a valid folder
		if (strMyFolder != undefined) and (strMyFolder != "") then  
		(		
			-----------------------------------------------
			-- backup the current config paths settings in the current working folder 
			-- to not lose possible modifications that might have been done
			-- before switching the working folder
			-----------------------------------------------
			local strFolderNames = #()
			strFolderNames = filterstring (strCurrProjectFolder) "\\" 
			pathconfig.SaveTo(pathconfig.getCurrentProjectFolderPath())
			
			-- this call will prompt the user to create the folder, if it does not exist
			pathconfig.setCurrentProjectFolder strMyFolder

			-----------------------------------------------
			--does a selected folder contains *.mxp files?
			-----------------------------------------------
			local arStrFnames = #()
			arStrFnames = getfiles (strMyFolder + "\\*.mxp") -- LOC Notes: Do Not Localize this 
			
			if(pathconfig.IsProjectFolder(strMyFolder)) then 
			(
				--Warns the user about the fact that the folder contains 
				--more than one *.mxp file: assumes that the first found is used.
				if (arStrFnames.count != 1) then
				(
					messagebox ("The selected folder contains more than one Paths Configuration File.\nThe following file:\n\n" + arStrFnames[1] +"\n\nwill be used to determine your Paths Configuration.") title:"Set Project Folder..." beep:false -- LOC Notes: Localize this 
				)
				
				--loads the MXP file
				pathconfig.load(arStrFnames[1])
			)
			else
			(
				------------------------------------------------------------------
				--No MXP file exists.  Assume the creation of a new "project"
				-- sets and define the various system directories

				------------------------------------------------------------------
						
			
				------------------------------------------------------------------
				--Create Folder filter
				-- It is possible to filter out project folders from the creation process
				-- by adding them as filters.  These filters are persistent for the application
				-- session, so they must be removed if different project configurations are 
				-- required during the session.
				
				-- simply uncomment the following code and use whichever filters are appropriate
				
				-- pathconfig.addProjectDirectoryCreateFilter(#image)
				-- pathconfig.addProjectDirectoryCreateFilter(#preview)
				
				-- or, to remove the filters, use the following
				-- pathconfig.removeAllProjectDirectoryCreateFilters()
				
				-- or, you can remove them one by one
				-- pathconfig.removeProjectDirectoryCreateFilter(#image)
				-- pathconfig.removeProjectDirectoryCreateFilter(#preview)

				------------------------------------------------------------------

				-- This loop Creates the Folders for your project
				-- filtered folder IDs will be ignored
				local dir = ""
				local dirCount = pathconfig.getProjectSubDirectoryCount()
				for i = 1 to dirCount do
				(
					
					dir = pathconfig.getProjectSubDirectory i
					dir = pathconfig.convertPathToAbsolute dir
					makedir dir all:true
				)
				
				--saves the config paths to the configs dir using the same name as the currently selected folder
				strFolderNames = #()
				strFolderNames = filterstring strMyFolder  "\\"
				
				if (strFolderNames.count > 0) then
				(
					pathconfig.SaveTo(strMyFolder + "\\" + strFolderNames[(strFolderNames.count)] + ".mxp") -- LOC Notes: Localize this
				)
				else
				(
					messagebox ("The folder name chosen is invalid") title:"Set Project Folder..." beep:false -- LOC Notes: Localize this 
				)	
			)
		) 
		else if (strMyFolder == "") then
		(
			--user selected an invalide folder
			messagebox ("The folder name chosen is invalid") title:"Set Project Folder..." beep:false -- LOC Notes: Localize this 
		)
		-- user canceled, do nothing.	
	)
)

