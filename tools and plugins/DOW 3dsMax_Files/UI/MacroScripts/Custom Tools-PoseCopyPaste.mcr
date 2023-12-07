macroScript PoseCopyPaste
category:"Custom Tools" 
buttontext:"PoseCopyPaste"
tooltip:"Copy and Paste Poses" 
icon:#("Custom_Tools",11)
(
local poseList = #()
---------------------------------------------------------------
function limitmatrix m =
	(
	tm = matrix3 1
	tm.row1.x = (m.row1.x * 100000) as integer / 100000.0
	tm.row1.y = (m.row1.y * 100000) as integer / 100000.0
	tm.row1.z = (m.row1.z * 100000) as integer / 100000.0

	tm.row2.x = (m.row2.x * 100000) as integer / 100000.0
	tm.row2.y = (m.row2.y * 100000) as integer / 100000.0
	tm.row2.z = (m.row2.z * 100000) as integer / 100000.0

	tm.row3.x = (m.row3.x * 100000) as integer / 100000.0
	tm.row3.y = (m.row3.y * 100000) as integer / 100000.0
	tm.row3.z = (m.row3.z * 100000) as integer / 100000.0

	tm.row4.x = (m.row4.x * 100000) as integer / 100000.0
	tm.row4.y = (m.row4.y * 100000) as integer / 100000.0
	tm.row4.z = (m.row4.z * 100000) as integer / 100000.0
	
	tm		
	)

---------------------------------------------------------------
-- This function will return the level at which an object is in the hierarchy
fn getDepth obj =
	(
	local depth = 0
	
	while (obj.parent != undefined) do
		(
		obj = obj.parent
		depth += 1
		)
	
	depth
	)

---------------------------------------------------------------

fn sortByDepth objArray =
	(
	-- the following contained function is used in the qSort function
	fn depthSortFN v1 v2 =
		(
		local d1 = getDepth v1
		local d2 = getDepth v2
		
		case of
			(
			(d1 > d2): 1
			(d1 < d2): -1
			default: 0
			)
		)
	
	qSort objArray depthSortFN
	)

---------------------------------------------------------------	
-- This function copies the current pose and returns a pose array 
	fn copyPose =
		(
		local objSet = getCurrentSelection()
				
		if objSet != undefined and objSet.count != 0 then
			(
			local pose = #()
			
			sortByDepth objSet
									
			for i in objSet do
				(
				at time currentTime
					( 
					append pose #(i.name,(limitmatrix i.transform))
					)
				)
			
			insertItem "New Pose" pose 1
			insertItem objSet.count pose 2	
			pose
			)
		else undefined
		)
---------------------------------------------------------------	

fn pastePose pose =
	(
	if (pose != undefined and pose.count != 0) then
		(
		at time currentTime
			(
			for i = 3 to pose.count do
				(
				local obj
				if (obj = getNodeByName pose[i][1]) != undefined then
					obj.transform = pose[i][2]
				else return false
				)
			)
		
		true
		)
	else false
	)
---------------------------------------------------------------	
-- This function writes the pose list to a file

	fn savePoses poseList =
		(
		if poseList != undefined and poseList.count != 0 do
			(
			local fStream, fPath
			
			if (fPath = getSaveFileName filename:"poseList.txt" caption:"Save Poses") != undefined do
				(
				if (fStream = openFile fPath mode:"w") != undefined do
					(
					flush fStream
					seek fStream 0
					for i in poseList do print i to:fStream
					close fStream
					return true
					)
				)
			)
		false
		)

---------------------------------------------------------------	
-- This function reads the pose list from a file
	fn loadPoses =
		(
		local fStream, fPath
		local poseList = #()	
		
		if (fPath = getOpenFileName filename:"poseList.txt" caption:"Load Poses") != undefined then
			(
			if (fStream = openFile fPath mode:"r") != undefined do
				(
				flush fStream
				seek fStream 0
				
				while (eof fStream) == false do
					(
					local tmpArray = #()
					local count 
					
					append tmpArray (readValue fStream)
					append tmpArray (count = readValue fStream)
					
					for i = 1 to count do
						(
						append tmpArray (readValue fStream)
						)
						
					append poseList tmpArray
					)
				
				close fStream	
				poseList
				)
			)
		else undefined
		)

---------------------------------------------------------------	
-- This function refreshes the listBox items list
	fn refreshListBox poseList =
		(
		local listBoxItems = for i in poseList collect i[1]
		listBoxItems
		)

---------------------------------------------------------------	
rollout _poseCopyPasteRollout "Pose copy\\paste tool"
	(
	
	label _lblPoseName "Selected Pose" align:#left
	edittext _txtPoseName align:#left
	listbox _poseList "Poses list"
	
	button _btnCopy "Copy" width:60 height:21 enabled:true across:2 align:#left
	button _btnSave "Save" width:60 height:21 enabled:false align:#right
	
	button _btnPaste "Paste" width:60 height:21 enabled:false across:2 align:#left
	button _btnLoad "Load" width:60 height:21 enabled:true align:#right
	
	button _btnDelete "Delete" width:60 height:21 enabled:false align:#center
	
	label _lblInfo "" align:#center
	
---------------------------------------------------------------	
	on _poseList selected sel do
		(
		_txtPoseName.text = _poseList.items[sel]
		_lblInfo.text = poseList[sel][2] as string + " objects in captured pose."
		)
---------------------------------------------------------------		
	on _btnCopy pressed do
		(
		if (getCurrentSelection()).count != 0 do
			(
			append poseList (copyPose())
			_lblInfo.text = (poseList[poseList.count][2] as string) + " objects copied."
			_poseList.items = refreshListBox poseList
			_txtPoseName.text = _poseList.selected

			if poseList.count != 0 do
				(
				_btnSave.enabled = true
				_btnPaste.enabled = true
				_btnDelete.enabled = true
				)
			)
		)
---------------------------------------------------------------		
	on _btnPaste pressed do
		(
		local result = true
		
		if (pastePose poseList[_poseList.selection]) do
			(
			_lblInfo.text = _poseList.items[_poseList.selection] + " pasted to " + (poseList[_poseList.selection][2] as string) + " objects."
			_poseList.items = refreshListBox poseList
			_txtPoseName.text = _poseList.selected
			)
		)
---------------------------------------------------------------		
	on _btnSave pressed do
		(
		if poseList.count != 0 then 
			(
			if (savePoses poseList) then
				_lblInfo.text = poseList.count as string + " poses saved."
			else _lblInfo.text = "Save failed!"
			)
		else _lblInfo.txt = "No poses to save!"
		_txtPoseName.text = _poseList.selected
	
		)
---------------------------------------------------------------		
	on _btnLoad pressed do
		(
		if (poseList = loadPoses()) != undefined then
			(
			_poseList.items = refreshListBox poseList
			_lblInfo.text = poseList.count as string + " poses loaded."
			_txtPoseName.text = _poseList.selected
			
			if poseList.count != 0 do
			(
			_btnSave.enabled = true
			_btnPaste.enabled = true
			_btnDelete.enabled = true
			)
			
			)
		else _lblInfo.text = "Loading failed!"
		)
---------------------------------------------------------------		
	on _btnDelete pressed do
		(
		if queryBox "Are you sure you want to delete the selected pose?" beep:false do
			(
			local tmpSel = _poseList.selected
			
			deleteItem poseList _poseList.selection
			_poseList.items = refreshListBox poseList
			_lblInfo.text = tmpSel + " was deleted!"
			)
			
		if poseList.count == 0 do
			(
			_btnSave.enabled = false
			_btnPaste.enabled = false
			_btnDelete.enabled = false
			_txtPoseName.text = ""
			)
				
		)
---------------------------------------------------------------	
	on _poseList doubleClicked sel do
		(
		pastePose poseList[sel]
		_lblInfo.text = _poseList.selected + " pasted to " + (poseList[sel][2] as string) + " objects."
		_poseList.items = refreshListBox poseList
		_txtPoseName.text = _poseList.selected
		)
---------------------------------------------------------------		
	on _txtPoseName entered txt do
		(
		poseList[_poseList.selection][1] = txt
		_poseList.items = refreshListBox poseList
		_txtPoseName.text = _poseList.selected
		)
---------------------------------------------------------------		
	) -- rollout end

createDialog _poseCopyPasteRollout
) -- macroscript end
