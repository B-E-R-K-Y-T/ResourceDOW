--
-- Utility for exporting Models from MAX (and gMAX)
--	(c)2000-2003 Relic Entertainment Inc.
--

include "Startup/RelicFileDateCompare.ms"


-- compensate for MaxScript shortcoming (straight from the MaxScript docs on strings)
fn uppercase instring =
(
	local upper, lower, outstring
	upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower = "abcdefghijklmnopqrstuvwxyz"
	
	outstring = copy instring
	
	for i=1 to outstring.count do
	(
		j = findString lower outstring[ i ]
		if( j != undefined ) do outstring[ i ] = upper[ j ]
	)

	outstring
)

-- does a file exist?  Compensates for Gmax
fn myDoesFileExist filename =
(
	if doesFileExist filename then
	(
		try
		(
			-- this will except if the file isn't there
			getFileAttribute filename #readOnly

			-- file is truely there
			return true
		)
		catch
		(
			-- file is not there, and gmax lied
			return false
		)
	)

	-- file is not there
	return false
)

-- recursively create a directory
fn makeDirRecursive dirname =
(
	if (dirname.count == 0) then
	(
		return false
	)
	
	-- check if it exists already
	if( ( getDirectories dirname ).count != 0 ) then
	(
		return true
	)
	
	-- strip trailing slash
	if( dirname[ dirname.count ] == "\\" ) then
	(
		dirname = substring dirname 1 (dirname.count - 1)
	)
	
	-- extract parent directory and strip trailing slash
	parentdir = getFilenamePath dirname
	if (parentdir[ parentdir.count ] == "\\" ) then
	(
		parentdir = substring parentdir 1 ( parentdir.count - 1 )
	)

	-- check if we were able to create the parents
	if (makeDirRecursive parentdir == false) then
	(
		return false
	)

	if (myDoesFileExist dirname) then
	(
		return true 
	)
	
	return makeDir dirname
)

--
fn isFileReadonly filename =
(
	if( myDoesFileExist filename ) then
	(
		if( getFileAttribute filename #readOnly ) then
		(
			return true
		)
	)
	
	return false
)		


--------------------------------------------

-- progress bar
global g_WarhammerModelExportProgress
global g_WarhammerModelStopExport

-- Extensions
c_ExportExtension	= ".SGM"
c_ExporterFilename	= "W40KExporter9.dle"

-- Folder constants
c_RefFile			= "REF"

c_RefFolder			= "REFERENCE\\"
c_AnimFolder		= "ANIMATIONS\\"
c_TexturesFolder	= "TEXTURES\\"

--
g_FileExtension		= ""

-- Time comparisons
g_NewestDate
g_OldestDate 
g_ExporterDate

-- Current export file list
g_ExportList		= ""

-- model name and folder mappings
g_ModelName     	= ""
g_DataSrcPath   	= ""
g_IntDataSrcPath	= ""
g_GenDataSrcPath	= ""
g_DataPath 			= ""

--------------------------------------------

fn SetExtension =
(
	-- detect GMAX
	g_FileExtension = ".max"
	try
	(
		-- copyFile is not allowed under gmax
		copyFile "" ""
	)
	catch
	(
		g_FileExtension = ".gmax"
	)
)

fn SetDataSrcPath filename =
(
	bFound = false
	g_DataSrcPath = filename

	foundIndex = findString filename c_RefFolder
	if( not foundIndex == undefined ) then
	(
		-- in the reference folder
		g_DataSrcPath = subString filename 1 ( foundIndex - 1 )
		bFound = true
	)
	else
	(
		foundIndex = findString filename c_AnimFolder
		if( not foundIndex == undefined ) then
		(
			-- in the animation folder
			g_DataSrcPath = subString filename 1 ( foundIndex - 1 )
			bFound = true
		)
	)

	return bFound
)

fn SetModelName = 
(
	g_ModelName = g_DataSrcPath
	g_ModelName = substring g_ModelName 1 ( g_ModelName.count - 1 )
	g_ModelName = getFilenameFile( g_ModelName )
)

fn SetExportList =
(
	g_ExportList = #()
		
	-- Model REF file
	for item in getfiles( g_DataSrcPath + c_RefFolder + c_RefFile + g_FileExtension ) do
	(
		append g_ExportList (uppercase ( c_RefFolder + ( getFilenameFile item ) + g_FileExtension ) )
	)

	-- Animations

	-- Get the list of directories with animations
	dirArray = GetDirectories( g_DataSrcPath + c_AnimFolder + "*" )
	for d in dirArray do
	(
		join dirArray( GetDirectories( d + "*" ) )
	)

	-- Get the list of animations in the found directories
	foundFiles = #()
	join foundFiles( getFiles( g_DataSrcPath + c_AnimFolder + "*" + g_FileExtension  ) )

	for d in dirArray do
	(
		join foundFiles( getFiles( d + "*" + g_FileExtension ) )
	)

	-- Append the relative name of animations to export
	for f in foundFiles do
	(
		animDirIndex = findString f c_AnimFolder
		if( not animDirIndex == undefined ) then
		(
			append g_ExportList (uppercase ( substring f animDirIndex -1 ) )
		)
	)
)

fn SetupScript filename =
(
	bStatus = true

	g_FileExtension = ""

	g_NewestDate = 0
	g_OldestDate = 0 
	g_ExporterDate = 0

	g_ExportList = ""

	g_ModelName = ""
	g_DataSrcPath = ""
	g_IntDataSrcPath = ""
	g_GenDataSrcPath = ""
	g_DataPath = ""

	if( SetDataSrcPath( filename ) == false ) then
	(
		bStatus = false
	)

	SetExtension()
	SetModelName()
	SetExportList()
	
	return bStatus
)

fn GetMergeRefFile =
(
	refFile = undefined

	-- Get REF file from Reference directory
	for item in getfiles( g_IntDataSrcPath + c_RefFolder + "*" + c_ExportExtension ) do
	(
		if( ( uppercase( getFilenameFile item ) ) == c_RefFile ) then
		(
			refFile = item
		)
	)

	return refFile
)

fn GetMergeAnimationList =
(
	mergeAnimlist = #()

	-- Get Animation files from Animation directory
	for item in getfiles( g_IntDataSrcPath + c_AnimFolder + "*" + c_ExportExtension ) do
	(
		append mergeAnimlist item
	)

	return mergeAnimlist
)

fn ConvertRelativeSrcNameToFullIntName item =
(
	animFolderIndex = findString item c_AnimFolder
		
	if( not animFolderIndex == undefined ) then
	(
		-- Anim file
		filename = subString item ( animFolderIndex + c_AnimFolder.count ) -1

		-- Sub-folder
		path = GetFilenamePath( filename )
		if( path.count > 0 ) then
		(
			path = substring path 1 ( path.count - 1 )
			path = path + "_"
		)
	
		item = g_IntDataSrcPath + c_AnimFolder + path + GetFilenameFile( filename ) + c_ExportExtension
	)
	else
	(
		-- Ref file
		item = g_IntDataSrcPath + c_RefFolder + GetFilenameFile( item ) + c_ExportExtension
	)
	
	return item
)

fn CheckForOrphanedFile item = 
(
	found = false

	for temp in g_ExportList do
	(
		temp = ConvertRelativeSrcNameToFullIntName( temp )
		
		if( item == temp ) then
		(
			found = true
			exit
		)
	)

	if( not found ) then
	(
		print( g_ModelName + ": Removing " + filenameFromPath( item ) + " - matching MAX file not found" )
		deleteFile( item )
	)
	else
	(
		local fileDate = getSortableDate( item )
			
		if( fileDate > g_NewestDate ) then
		(
			g_NewestDate = fileDate
		)
			
		if( fileDate < g_OldestDate ) then
		(
			g_OldestDate = fileDate
		)
	)
)

rollout g_WarhammerModelExportProgress "Progress"
(
	progressbar exportprogress "Progress"
	button cancelexp "Cancel" width:100 align:#center

	on cancelexp pressed do
	(
		g_WarhammerModelStopExport = true
	)
)

function ExportModelInternal bForceExport bUpdateUI bSkipReadOnly  bExportModel bExportTextures =
(
	-- Verify that we have a ref.max file
	if( myDoesFileExist( g_DataSrcPath + c_RefFile + g_FileExtension ) == false ) and 
		( myDoesFileExist( g_DataSrcPath + c_RefFolder ) == true ) and
		( myDoesFileExist( g_DataSrcPath + c_RefFolder + c_RefFile + g_FileExtension ) == false ) then
	(
		titleText = "Warhammer Exporter: " + g_ModelName
		messageBox( "Unable to find '" + c_RefFile + g_FileExtension + "' file!" ) title:titleText
		print( titleText  + "- Unable to find '" + c_RefFile + g_FileExtension + "' file!" )

		return false
	)

	-- Extract the intermediate and final directories from the 'pipeline.ini'		
	g_IntDataSrcPath = w40k_pipeline_sourcetointermediate g_DataSrcPath
	g_GenDataSrcPath = w40k_pipeline_sourcetogeneric g_DataSrcPath
	g_DataPath = w40k_pipeline_sourcetofinal g_DataSrcPath

	if( ( g_IntDataSrcPath == undefined ) or ( g_GenDataSrcPath == undefined ) or ( g_DataPath == undefined ) ) then
	(
		titleText = "Warhammer Exporter: " + g_ModelName
		messageBox( "Not under a project mapping (pipeline.ini)!\nPlease make sure you have the file in the proper data source!" ) title:titleText
		print( titleText  + "- Not under a project mapping (pipeline.ini)!\nPlease make sure you have the file in the proper data source!" )
		return false
	)
	
	-- strip off the last directory from g_DataPath, because this is the filename now
	if( g_DataPath[ g_DataPath.count ] == "\\" ) then
	(
		g_DataPath = substring g_DataPath 1 ( g_DataPath.count - 1 )
	)

	g_DataPath = getFilenamePath g_DataPath

	-- strip off the last directory from g_GenDataSrcPath, because this is the filename now
	if( g_GenDataSrcPath[ g_GenDataSrcPath.count ] == "\\" ) then
	(
		g_GenDataSrcPath = substring g_GenDataSrcPath 1 ( g_GenDataSrcPath.count - 1 )
	)

	g_GenDataSrcPath = getFilenamePath g_GenDataSrcPath

	-- Check if we can write to the exportfile
	if (isFileReadonly(g_GenDataSrcPath + g_ModelName + c_ExportExtension)) then
	(
		titleText = "Warhammer Exporter: " + g_ModelName

		if( bSkipReadOnly == true ) then
		(
			-- ignore this type of error and skip the export
			print( titleText  + "- Read only, skipping file..." )
			return true
		)
		else
		(
			fileToOpen = g_GenDataSrcPath + g_ModelName + c_ExportExtension
			perforceResult = w40k_p4_openoradd fileToOpen
			if (perforceResult == false) then
			(
				w40k_p4_reset
				messageBox( "Cannot export to file '" + g_GenDataSrcPath + g_ModelName + c_ExportExtension + "'!  It was unable to be opened or added in Perforce." ) title:titleText
				print( titleText  + "- Cannot export to file '" + g_GenDataSrcPath + g_ModelName + c_ExportExtension + "'!  It was unable to be opened or added in Perforce." )
				return false
			)
		)
	)

	-- (Re)set dates
	g_NewestDate = "00000101000000"
	g_OldestDate = "99991231235959"

	-- Get the date of the exporter DLE
	g_ExporterDate = g_OldestDate
	local tmpVal = findString scriptsPath "Scripts"

	if( tmpVal != undefined ) then
	(
		local plugDir = replace scriptsPath tmpVal 7 "plugins"
		g_ExporterDate = getSortableDate( plugDir + "\\" + c_ExporterFilename )
	)
	-- check dates on intermediate files
	-- Incremental check, verify export plugin is older than SGMs and delete orphaned ones

	-- Reference folder
	for item in getfiles( g_IntDataSrcPath + c_RefFolder + "*" + c_ExportExtension ) do
	(
		CheckForOrphanedFile( item )
	)

	-- Anim folder
	for item in getfiles( g_IntDataSrcPath + c_AnimFolder + "*" + c_ExportExtension ) do
	(
		CheckForOrphanedFile( item )
	)

	-- If we have a new exporter or we're asked to force a rebuild then delete all of the files
	if( bForceExport == true or g_ExporterDate > g_OldestDate ) then
	(
		-- Delete all of the files in the Intermediate_DataSrc directory

		if( g_ExporterDate > g_OldestDate ) then
		(
			print( g_ModelName + ": New exporter, exporting all files..." )
		)
		else
		(
			print( g_ModelName + ": Forcing full export..." )
		)

		files = getFiles ( g_IntDataSrcPath + c_RefFolder + "\\*" + c_ExportExtension )
		for f in files do
		(
			deleteFile f
		)

		files = getFiles ( g_IntDataSrcPath + c_AnimFolder + "\\*" + c_ExportExtension )
		for f in files do
		(
			deleteFile f
		)
	)
	else
	(
		print( g_ModelName + ": Performing incremental export..." )
	)

	-- strip out unmodified .max files
	local i = 1
	while( i <= g_ExportList.count ) do
	(
		local currentFile = g_DataSrcPath + g_ExportList[ i ]
		local saveTo = ConvertRelativeSrcNameToFullIntName g_ExportList[ i ]

		bSkip = false

		-- Reference folder
		if( myDoesFileExist saveTo ) and ( fileDateCompare currentFile saveTo < 0 ) then
		(
			bSkip = true
		)

		-- Animation folder
		if( myDoesFileExist saveTo ) and ( fileDateCompare currentFile saveTo < 0 ) then
		(
			bSkip = true
		)

		if( bSkip == true ) then
		(
			print( g_ModelName + ": Skipping '" + g_ExportList[ i ] + "'" )
			deleteItem g_ExportList i
		)
		else
		(
			i = i + 1
		)	)

	numFiles = g_ExportList.count

	if( numFiles > 0 ) then
	(
		-- start exporting

		-- add DataSrc to texture map path
		mapPaths.add( g_DataSrcPath + c_TexturesFolder )

		-- progress bar
		if( bUpdateUI == true ) then
		(
			g_WarhammerModelStopExport = false
			addRollout g_WarhammerModelExportProgress
			g_WarhammerModelExportProgress.exportprogress.value = 0
		)

		for i=1 to numFiles do
		(
			if( bUpdateUI == true ) then
			(
				-- Export cancelled?
				if( g_WarhammerModelStopExport ) then
				(
					removeRollout g_WarhammerModelExportProgress
					print( g_ModelName + ": User cancelled model export" )
					return true
				)
			)

			local currentFile = g_DataSrcPath + g_ExportList[ i ]
			local saveTo = ConvertRelativeSrcNameToFullIntName g_ExportList[ i ]

			print( g_ModelName + ": Loading file '" + g_ExportList[ i ] + "'..." )
			loadmaxfile currentFile quiet:true
			gw.updateScreen()

			-- DO EXPORT
			exportOK = true
			try
			(
			    
			    print( g_ModelName + ": Exporting file '" + g_ExportList[ i ] + "'..." )
				exportOK = exportfile( saveTo ) #noPrompt
				
				if( exportOK == true ) then
				(
					-- No error reported, do we have an exported file?
					if( not myDoesFileExist( saveTo ) ) then
					(
						exportOK = false
					)
				)
			)
			catch
			(
				-- Serious error occured
				exportOK = false
			)
			
			-- check if we encountered an error?
			if( exportOK == false ) then
			(
				titleText = "Warhammer Exporter: " + g_ModelName
				messageBox( "Unable to export: " + currentFile + "!" ) title:titleText
				print( titleText  + "- Unable to export: " + currentFile + "!" )

				if( bUpdateUI == true ) then
				(
					removeRollout g_WarhammerModelExportProgress
				)

				return false
			)

			if( bUpdateUI == true ) then
			(
				g_WarhammerModelExportProgress.exportprogress.value = 100.0 * ( i * 2 + 0 ) / ( g_ExportList.count * 2 )
			)
		)

		if( bUpdateUI == true ) then
		(
			removeRollout g_WarhammerModelExportProgress
		)

		-- remove textures folder from texture map path
		index = mapPaths.count()
		mapPaths.delete( index )
	)
	else
	(
		g_WarhammerModelExportProgress.exportprogress.value = 100.0
		gw.updateScreen()
	)
       
	-- MERGE Files
	print( g_ModelName + ": Merging..." )

	-- Get model file
	mergeRefFile = GetMergeRefFile()
	if( mergeRefFile == undefined ) then
	(
		titleText = "Warhammer Exporter: " + g_ModelName
		messageBox( "Unable to find reference file for merging!" ) title:titleText
		print( titleText  + "- Unable to find reference file for merging!" )
		return false
	)

	mergeOK = true
	mergeToFile = g_GenDataSrcPath + g_ModelName + c_ExportExtension

	-- Get anim list
	mergeAnimList = GetMergeAnimationList()

	-- Merge animations
	try
	(   -- temporary external flag setting for animerge
	    w40k_animergeFlags bExportModel bExportTextures
	    
		
	    mergeOK = w40k_animerge mergeToFile mergeRefFile mergeAnimList
		
	)
	catch
	(
		-- Serious error occured
		mergeOK = false
	)

	if( mergeOK == false ) then
	(
		titleText = "Warhammer Exporter: " + g_ModelName
		messageBox( "Unable to export/merge: " + mergeToFile ) title:titleText
		print( titleText  + "- Unable to export/merge model!" )
		return false
	)

	-- Burn the model
	burnOK = true
	try
	(
		burnOK = w40k_burner mergeToFile
	)
	catch
	(
		-- A boo boo happened
		w40k_burner_reset
		burnOK = false
	)

	if (burnOK == false) then
	(	
		titleText = "Warhammer Exporter: " + g_ModelName
		messageBox("Unable to burn: " + mergeToFile) title:titleText
		print(titleText + "- Unable to burn model!")
		return false
	)

	print( g_ModelName + ": Exported successfully." )
	return true
)

function ExportModel filepath bForceExport bSkipReadOnly bExportModel bExportTextures  =
(
	if( SetupScript( filepath ) == false ) then
	(
		return false
	)

	ExportModelInternal bForceExport false bSkipReadOnly bExportModel bExportTextures 
)


--------------------------------------------
utility exporter "Warhammer Model Export"
(
	-- Dialog buttons
	edittext exportname "Exporting" enabled:false
	dropdownlist fileList "Files" items:#() height:20
	checkbox forcerebuild "Force Full Export" checked:false
	checkbox exportmodel "Export Model" checked:true
	checkbox exporttextures "Export Textures" checked:true
	
	button refresh "Refresh" align:#center width:100
	button export "Export" align:#center width:100


	fn UpdateUI =
	(
		-- Set the model name
		exportname.text = g_ModelName

		-- strip off paths
		tempfiles =#() 
		for item in g_ExportList do
		(
			temp = item
		
			animFolderIndex = findString item c_AnimFolder
			if( not animFolderIndex == undefined ) then
			(
				animFolder = subString temp c_AnimFolder.count -1
				animFolder = getFilenamePath animFolder
				animFolder = subString animFolder 2 -1

				temp = animFolder + getFilenameFile( temp )
			)
			else
			(
				temp = getFilenameFile( temp )
			)

			append tempfiles temp
		)

		fileList.items = tempfiles
	)

	on exporter open do
	(
		if( SetupScript( maxFilePath ) == true ) then
		(
			UpdateUI()
		)
	)

	on refresh pressed do
	(
		if( SetupScript( maxFilePath ) == true ) then
		(
			UpdateUI()
		)
	)

	on export pressed do
	(
		if( SetupScript( maxFilePath ) == false ) then
		(
			messageBox( "Unable to determine source path!\nMake sure you have followed the standard directory layout." ) title:"Warhammer Exporter"
			return false
		)

		UpdateUI()

		if( not checkForSave() ) then
		(
			return false
		)
		
		if( objects.count == 0 ) then
		(
			messageBox( "No files present for export!" ) title:"Warhammer Exporter"
			return false
		)

		ExportModelInternal forcerebuild.checked true false exportmodel.checked exporttextures.checked 
	)
)
