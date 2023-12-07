macroScript RunExecute
	category:"Custom Tools"
	toolTip:"Runs execute.ms on all files within a folder"
	icon:#("TrackBar",2)
(
	global maxfiles = #()
	
	---------------------------------------------------------------------------
	-- Recursively search for files
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

	---------------------------------------------------------------------------
	fPath = getSavePath "Select Path"
	if fPath != undefined do
		(
		maxFiles = GetFilesRecursive fPath "*.max"
		/*
		if (fStream = createFile (fPath + "\\Execute.log")) != undefined do
			(
			flush fStream
			for i in maxfiles do
				print i to:fStream
			close fStream
			)
		*/	
		for i in maxfiles do
			(
			loadMaxFile i quiet:true
			include "ui\\macroscripts\\execute.ms"
			saveMaxFile i
			)
		)
)
