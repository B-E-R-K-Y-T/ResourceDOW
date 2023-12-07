macroScript ExportDoWCoords
	category:"Custom Tools"
	toolTip:"Convert and export selected object coords to text file"
	icon:#("Custom_Tools",12)
(
	

	-- Converts pose
		fn convertPos pos =
			(
			cpos = [-pos.x,pos.z,-pos.y]
			return cpos
			)

	-- This function writes the pose list to a file
	-----------------------------------------------
		fn writeToFile list =
			(
			if list != undefined and list.count != 0 do
				(
				local fStream, fPath
				
				if (fPath = getSaveFileName filename:"list.txt" caption:"Save List") != undefined do
					(
					if (fStream = openFile fPath mode:"w") != undefined do
						(
						flush fStream
						seek fStream 0
						for i in list do print i to:fStream
						close fStream
						return true
						)
					)
				)
			false
			)

	if selection.count != 0 do
		(
		local dumpList = #()
		for i in selection do
			(
			local tArray = #(i.name,(convertPos	i.pos))
			append dumpList tArray
			)
			
		writeToFile dumplist
		)
)
