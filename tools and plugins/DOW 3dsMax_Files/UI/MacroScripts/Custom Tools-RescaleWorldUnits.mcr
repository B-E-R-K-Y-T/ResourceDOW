macroScript RescaleWorldUnits
category:"Custom Tools"
toolTip:"Rescale World Units"
icon:#("Classic",25)
(

-- Global Variables
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

rollout _rescaleUnitsRollout "Rescale Unit" width:162 height:112
	(
		button btn1 "Rescale" pos:[40,56] width:80 height:36
		spinner spn1 "Scale" pos:[32,16] width:96 height:16 type:#float range:[0.1,10,1]
		
	
	on btn1 pressed do
		(
		fPath = getSavePath "Select Root Folder"
		
		if fPath != undefined do
			(
			maxFiles = GetFilesRecursive fPath "*.max"
			
			if (fStream = createFile (fPath + "\\RescaleUnit.log")) != undefined do
				(
				flush fStream
				for i in maxfiles do
					print i to:fStream
				close fStream
				)
				
			for i in maxfiles do
				(
				loadMaxFile i quiet:true
				rescaleWorldUnits spn1.value
				saveMaxFile i
				)
		
			)
		) -- end on btn1 pressed
	) -- end rollout
try (destroyDialog _rescaleUnitsRollout) catch()
createDialog _rescaleUnitsRollout
) -- end macroscript
