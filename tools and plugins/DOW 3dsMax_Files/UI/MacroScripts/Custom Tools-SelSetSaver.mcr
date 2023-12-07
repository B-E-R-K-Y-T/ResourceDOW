macroScript SelSetSaver

category:"Custom Tools" 
buttontext:"SelSetSaver"
tooltip:"Save and Load Selection Sets" 
icon:#("Custom_Tools",10)
(

-- function declarations
---------------------------------------------------------------	
	fn getSelSets selSetArray =
		(
		local sArray = #()
	
		if selSetArray.count > 0 then
			(
			for i = 1 to selSetArray.count do
				(
				local tmpArray = #()
				
				append tmpArray ((getNamedSelSetItemCount selSetArray[i]) + 1)
				append tmpArray (getNamedSelSetName selSetArray[i])
								
				for j = 1 to (getNamedSelSetItemCount selSetArray[i]) do
					(
					append tmpArray (getNamedSelSetItem selSetArray[i] j).name
					)
				append sArray tmpArray
				)
			return sArray
			)
		else return undefined
		)
	
---------------------------------------------------------------	
	fn writeSelSets fStream sArray =
		(
	
		for i = 1 to sArray.count do
			for j = 1 to sArray[i].count do
				print sArray[i][j] to:fStream
	
		)
---------------------------------------------------------------	
	fn writeSelSetsToFile selSetArray =
		(
		local fPath, fStream, sArray
					
		fPath = getSaveFileName filename:"SelSets.txt" caption:"Save Selection Sets"
				
		if (fStream = createFile fPath) != undefined do
			(
			flush fStream
			if (sArray = getSelSets selSetArray) != undefined do
				writeSelSets fStream sArray
			close fStream
			)
		)
---------------------------------------------------------------

	fn readSelSets fStream =
		(
		local sArray = #()
		
		seek fStream 0	

		while (eof fStream) == false do
			(
			local tmpArray = #()
			local count 
			
			count = readValue fStream
			
			for i = 1 to count do
				append tmpArray (readValue fStream)
				
			append sArray tmpArray
			)
		
		return sArray
		)
---------------------------------------------------------------	
	fn readSelSetsFromFile =
		(
		local fPath, fStream, sArray
		
		fPath = getOpenFileName filename:"SelSets.txt" caption:"Open Selection Sets"
				
		if (fStream = openFile fPath mode:"rb") != undefined do
			(
			flush fStream
			sArray = readSelSets fStream
			close fStream
			)
		
		return sArray
		)
		
	
---------------------------------------------------------------
	fn createSelSets sArray =
		(
		
		for i = 1 to sArray.count do
			(
			local str = "#("
								
			for j = 2 to sArray[i].count do
				(
				if isValidNode (execute ("$'" + sArray[i][j] + "'")) do	-- checks to see if object is in scene
					(
					if sArray[i][j+1] != undefined then 
						str += ("$'" + sArray[i][j] + "', ")
						
					else str += "$'" + sArray[i][j] + "')" 
					)
				)
			
			if selectionSets[sArray[i][1]] == undefined do
				try (selectionSets[sArray[i][1]] = (execute str)) catch ()
			)
		)
---------------------------------------------------------------

	fn alphaSort a b abArray: =
		(
		local a1 = abArray[a]
		local b1 = abArray[b]
		
		case of
			(
			(a1 < b1): -1
			(a1 > b1): 1
			default: 0
			)
		)
	
---------------------------------------------------------------

	fn initSelSetArrays =
		(
		local _selSetNameArray = #() -- actual selection set names internal order
		local _selSetIndexArray = #() -- indexed selection set names for sorting 
		local _multiSelSetsArray = #() -- sorted selection set names for display

		for i = 1 to getNumNamedSelSets() do
			append _selSetNameArray (getNamedSelSetName i) -- get selection set names and store in array
		
		_selSetIndexArray = for i = 1 to _selSetNameArray.count collect i -- store index array and sort alphanumerically
		qsort _selSetIndexArray alphaSort abArray:_selSetNameArray
		
		_multiSelSetsArray = for i = 1 to _selSetNameArray.count collect _selSetNameArray[_selSetIndexArray[i]] -- create array of names based on sorted index
		
		return #(_selSetIndexArray,_multiSelSetsArray)
		)
---------------------------------------------------------------		
		
-- macroscript starts here

_selSets = initSelSetArrays()

rollout _selSetSaver "Selection Set Saver"
	(
	multiListBox _multiSelSets "Selection Sets" items:_selSets[2] selection:#{1.._selSets[2].count}
	button _btnSave "Save" width:56 height:21 across:2 align:#left
	button _btnLoad "Load" width:56 height:21 align:#right
	button _btnCancel "Cancel" width:56 height:21 align:#center
	
	on _multiSelSets selectionEnd do
		(
		_selSets = initSelSetArrays()
		_multiSelSets.items = _selSets[2]
		)
	
	on _btnSave pressed do
		(
		a = _multiSelSets.selection as array
		b = for i = 1 to a.count collect _selSets[1][i]
		writeSelSetsToFile b
		_selSets = initSelSetArrays()
		_multiSelSets.items = _selSets[2]
		)
	
	on _btnLoad pressed do
		(
		joe = readSelSetsFromFile()
		createSelSets (joe)
		_selSets = initSelSetArrays()
		_multiSelSets.items = _selSets[2]
		)
		
	on _btnCancel pressed do
		(
		destroyDialog _selSetSaver
		)
	
	)

createDialog _selSetSaver
) 
