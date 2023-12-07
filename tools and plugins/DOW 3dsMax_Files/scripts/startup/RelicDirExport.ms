--
-- Utility for exporting directories of models from MAX (and gMAX)
--	(c)2003 Relic Entertainment Inc.
--


include "Startup/RelicModelExport.ms"


fn GetFilesRecursive root pattern = 
( 
	dirArray = GetDirectories( root + "*" )

	for d in dirArray do
	(
		join dirArray( GetDirectories( d + "*" ) )
	)

	foundFiles = #() 

	for f in dirArray do
	(
		join foundFiles( getFiles( f + pattern ) )

	)

	return foundFiles 
) 


--------------------------------------------
utility exporter "Warhammer Dir Export"
(
	local g_ExportProgress
	local g_StopExport

	local g_DirectoryName
	local g_ExportList = #()


	-- Dialog buttons
	edittext exportname "Exporting" enabled:false
	dropdownlist modelList "Models" items:#() height:20
	checkbox forcerebuild "Force Full Export" checked:false
	button setdir "Set Directory" align:#center width:100
	button export "Export" align:#center width:100

	fn WarhammerDirExportSet =
	(
		directoryName = getSavePath caption:"Choose the model folder to export:"
		
		if( directoryName == undefined ) then
		(
			exportname.text = ""
		)
		else
		(
			-- Set dir
			g_DirectoryName  = directoryName
		
			-- Get list of models to export
			g_ExportList = #()
			g_ExportList = GetFilesRecursive g_DirectoryName "REF.max"

			-- update dependent ui
			exportname.text = g_DirectoryName 

			tempfiles =#() 
			
			-- Add model names to list to be exported
			for f in g_ExportList do
			(
				-- strip off 'REF.MAX'
				temp = getFilenamePath( f )
				
				-- strip off 'REFERENCE' dir
				temp = substring temp 1 ( temp.count - 1 )
				temp = getFilenamePath( temp )

				-- get parent dir as filename
				temp = substring temp 1 ( temp.count - 1 )
				temp = getFilenameFile( temp )
				
				append tempfiles temp
			)
			
			modelList.items = tempfiles
		)
	)

	fn ExportDirectory =
	(
		if( g_DirectoryName == undefined ) then
		(
			WarhammerDirExportSet()
		)
		
		if( not g_DirectoryName == undefined ) then
		(
			-- start exporting
			g_StopExport = false
			addRollout g_ExportProgress
			g_ExportProgress.exportprogress.value = 0

			print( "Warhammer Dir Export: Started..." )
			print( "\n" )

			numItems = g_ExportList.count
			i = 0

			for f in g_ExportList do
			(
				-- Export cancelled?
				if( g_StopExport ) then
				(
					removeRollout g_ExportProgress
					print( "User cancelled directory export" )
					return true
				)

				-- Do export
				dir = getFilenamePath( f )
				result = ExportModel dir forcerebuild.checked false
				if( result == false ) then
				(
					removeRollout g_ExportProgress
					print( "Error exporting model, aborted directory export!" )
					return false
				)

				print( "\n" )
				g_ExportProgress.exportprogress.value = 100.0 * ( i * 2 + 0 ) / ( numItems * 2 )

				i = i + 1	
			)

			print( "Warhammer Dir Export: Finished successfully." )

			removeRollout g_ExportProgress
			
			return true
		)
		else
		(
			print( "No directory selected for export!" )
			return false
		)
	)

	on setdir pressed do
	(
		WarhammerDirExportSet()
	)

	on export pressed do
	(
		ExportDirectory()
	)

	rollout g_ExportProgress "Progress"
	(
		progressbar exportprogress "Progress"
		button cancelexp "Cancel" width:100 align:#center

		on cancelexp pressed do
		(
			g_StopExport = true
		)
	)
)
