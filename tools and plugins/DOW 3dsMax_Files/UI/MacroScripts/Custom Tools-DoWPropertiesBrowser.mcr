-- ///////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Custom Tools-DoWPropertiesBrowser
--
-- Last Update: 08/02/2005
-- Author: Claudio Alvaro (calvaro@relic.com)
-- Description: Displays DoW user defined properties and allows user to toggle them on or off.
--				Depressing the column header toggles the property in question for all selected nodes.
--
-- Update: 25/01/2006
-- Author: Brother Santos (brother_santos@poczta.fm)
-- Description: ShadowVolume property added
--
-- ////////////////////////////////////////////////////////////////////////////////////////////////////
macroScript DoWPropertiesBrowser
category:"Custom Tools"
toolTip:"DoW Properties Browser"
icon:#("Custom_Tools",12)
(
global lv_rollout

rollout lv_rollout "DoW Properties Browser"
	(
	-- ListView headers
	local layout_def = #(#("Object Name", 180),#("Object Class",90),#("Max Bone",60),#("Stale",40,"Stale"),#("Invisible",52,"ForceInvisible"),#("IgnoreShaders",83,"IgnoreShaders"),#("ForceSkinning",80,"ForceSkinning"),#("NoChild",53,"No_Child_Selection"),#("Remove",53,"Remove"),#("ShadowVolume",90,"ShadowVolume"))
	
	---------------------------------------------------------------------------
	-- Initialise listview.
	fn initListView lv =
		(
		lv.gridLines = true
		lv.View = #lvwReport
		lv.multiselect = true
		lv.sorted = true
		lv.sortOrder = #lvwAscending
		lv.labelEdit = #lvwManual
		lv.appearance = #ccFlat
		lv.borderStyle = #ccFixedSingle
		lv.fullRowSelect = true
		lv.backColor = color 177 240 239
		--lv.picture = loadPicture "c:/3dsmax7/ui/icons/Custom_Tools_Relic_Logo.bmp"
		--lv.pictureAlignment = #lvwTile
		
		for i in layout_def do
			(
			column = lv.columnHeaders.add()
			column.text = i[1]
			)
		LV_FIRST = 0x1000
 		LV_SETCOLUMNWIDTH = (LV_FIRST + 30) 

		for i = 0 to layout_def.count-1 do 
  			windows.sendMessage lv.hwnd LV_SETCOLUMNWIDTH i layout_def[1+i][2]
		)
	---------------------------------------------------------------------------	
	fn getTxtInfo =
		(
		count = 0
		bip_count = 0
		removed = 0
		
		for i in selection do
			if i.boneEnable == true then 
				(
				count += 1
				if ((getUserProp i "Remove") == "Yes") do 
					removed += 1
				)
			else if classOf i == Biped_Object do
				( 
				if ((findstring i.name "Footsteps") == undefined) do 
					(
					count += 1
					bip_count += 1
					if ((getUserProp i "Remove") == "Yes") do
						removed += 1
					)
				)
		
		("< " + (count as string) + " total bones >< " + ((count - removed) as string) + " active bones (export) ><" + (bip_count as string) + " biped objects >< " + (count - bip_count) as string + " bone objects >< " + (removed as string) + " with remove flag >")
		)
		
	
	---------------------------------------------------------------------------	
	-- Checks for the existance of a user defined property.
	fn getDowProp obj propName =
		(
		if (val = getUserProp obj propName) != undefined do
			if (classOf val == String and val as name == #yes) then return "Yes"
			else return (val as string)
		return "--"
		)
	---------------------------------------------------------------------------
	-- Removes a user defined property when the user toggles the corresponding cell in the listview.
	fn removeUserProp obj testStr =
		(
		s = (getUserPropBuffer obj) as stringStream
		outStr = "" as stringStream
		seek s 0
		while (not (eof s)) do
			(
			line = readline s
			
			fstr = filterString line "= "
			if fstr.count > 2 then
				(
				messageBox (obj.name + " has inproper user defined property format. User defined property stripped, please redefine.") title:"DoW Properties Error" beep:false
				format "\r\n" to:outStr
				)
			else 
				if fstr[1] != undefined do
					if (findString fstr[1] testStr) == undefined do
						format "%\r\n" line to:outStr
			)
		
		setUserPropBuffer obj (outStr as string)
		)
	---------------------------------------------------------------------------
	-- Adds a user defined property when the user toggles the corresponding cell in the listview.
	fn addUserProp obj testStr value:"Yes" =
		(
		s = (getUserPropBuffer obj) as stringStream
		outStr = "" as stringStream
		seek s 0
		while (not (eof s)) do
			(
			line = readline s
			
			fstr = filterString line "= "
			if fstr.count > 2 then
				(
				messageBox (obj.name + " has inproper user defined property format. User defined property stripped, please redefine.") title:"DoW Properties Error" beep:false
				format "\r\n" to:outStr
				)
			else
				if fstr[1] != undefined do
					format "%\r\n" line to:outStr
			)
		setUserPropBuffer obj (outStr as string)
		setUserProp obj testStr value
		)
	---------------------------------------------------------------------------
	-- Toggles bone state, and also sets other properties to default.
	fn toggleBoneProp obj =
		(
		if (obj.boneEnable) then 
			obj.boneEnable = false
		else
			(
			obj.boneEnable = true
			obj.boneFreezeLength = true
			obj.boneAutoAlign = false
			obj.boneScaleType = #none
			)
		)
	---------------------------------------------------------------------------
	-- Toggles user properties by calling either addUserProp or removeUserProp functions.
	fn toggleDowProp li prop =
		(
		obj = getNodeByName (li.text)
			
		if obj != undefined do
			(		
			if li.listSubItems[prop].text == "--" then
				(
				case prop of
					(
					2 : (li.listSubItems[prop].text = "Yes" ;
						toggleBoneProp obj)
					3 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "Stale")
					4 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "ForceInvisible")
					5 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "IgnoreShaders")
					6 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "ForceSkinning")
					7 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "No_Child_Selection")
					8 : (li.listSubItems[prop].text = "Yes" ;
						addUserProp obj "Remove")
					9 : (li.listSubItems[prop].text = "No" ;
						addUserProp obj "ShadowVolume" value:"No")
	
					default: ()
					)
				)
			else 
				(
				case prop of
					(
					2 : (li.listSubItems[prop].text = "--" ;
						toggleBoneProp obj)
					3 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "Stale")
					4 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "ForceInvisible")
					5 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "IgnoreShaders")
					6 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "ForceSkinning")
					7 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "No_Child_Selection")
					8 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "Remove")
					9 : (li.listSubItems[prop].text = "--" ;
						removeUserProp obj "ShadowVolume")

					default: ()
					)
				)
			)
		)
	---------------------------------------------------------------------------	
	-- Fills listview with current selection.
	fn populateListView lv =
		(
		lv.listItems.clear()
		for i in selection do
			(
			local classColor = (color 0 0 0)
			li = lv.listItems.add()
			li.text = i.name
			li.toolTipText = i.name
			
			if superClassOf i == Helper do classColor = (color 0 128 0)
			if classOf i == BoneGeometry do classColor = (color 255 0 0)
			if classOf i == Biped_Object do classColor = (color 0 0 255)
			
			li.foreColor = classColor
			
			sub_li = li.listSubItems.add()
			sub_li.foreColor = classColor
			sub_li.text = ((classOf i) as string)
			sub_li.toolTipText = i.name + " is a " + (classOf i as string)
			
			sub_li = li.listSubItems.add()
			sub_li.toolTipText = "Bone property of " + i.name
			sub_li.foreColor = classColor
			if i.boneEnable then
				sub_li.text = "Yes"
			else sub_li.text = "--"
						
			for j = 4 to layout_def.count do
				(
				sub_li = li.listSubItems.add()
				sub_li.foreColor = classColor
				sub_li.text = try (getDowProp i layout_def[j][3]) catch ("--")
				sub_li.toolTipText = layout_def[j][3] + " property of " + i.name
				)
			)
		)
	---------------------------------------------------------------------------	
	-- Save user defined properties for selected nodes to text file.
	fn saveDowProp nodes =
		(
		local fStream, fPath
		
		if (fPath = getSaveFileName filename:"DoWProperties.txt" caption:"Save DoWProperties") != undefined do
			(
			if (fStream = openfile fPath mode:"w") != undefined do
				(
				flush fStream
				seek fStream 0
				for i in nodes do
					(
					print i.name to:fStream
					print (getUserPropBuffer i) to:fStream
					)
				close fStream
				)
			)
		)

	---------------------------------------------------------------------------	
	-- Load user defined properties from text file.
	fn loadDowProp =
		(
		local fStream, fPath
		
		if (fPath = getOpenFileName filename:"DoWProperties.txt" caption:"Load DoWProperties") != undefined do
			(
			if (fStream = openFile fPath mode:"r") != undefined do
				(
				flush fStream
				seek fStream 0
				
				while (not (eof fStream)) do
					(
					if (node = getNodeByName(readValue fStream)) != undefined then
						(
						format "%\n" node -- output to listener
						
						local str = "" as stringStream
						local s = (readValue fStream) as stringStream
						seek s 0
						while (not (eof s)) do
							(
							line = readLine s
							format "%\r\n" line to:str
							format "\t-%\n" line -- output to listener
							)
						
						setUserPropBuffer node (str as string)
						)
					else readValue fStream
					)
				close fStream
				)
			)
		)
	---------------------------------------------------------------------------		

	-- Button definitions and activeX controls.
	button _btnSave "Save" width:60 height:21 pos:[2,4]
	button _btnLoad "Load" width:60 height:21 pos:[66,4]
	edittext _txtInfo readOnly:true height:21 pos:[130,4]
	
	activeXControl lv "MSComctlLib.ListViewCtrl.2" pos:[0,28]	
	
	on _btnSave pressed do
		(
		saveDowProp (selection as array)
		)
	
	on _btnLoad pressed do
		(
		loadDowProp()
		populateListView lv
		_txtInfo.text = getTxtInfo()
		)
	
	
	on lv mouseDown button shift x y do
		(
		hit = listView.hitTest lv.hWnd [x,y]
		if hit[1] != 0 and hit[2] >= 2 do
			toggleDowProp lv.listItems[hit[1]] hit[2]
		_txtInfo.text = getTxtInfo()
		)
	
	on lv columnClick column do
		(
		if column.index >= 3 do
			if selection.count > 0 do
				for i = 1 to selection.count do
					toggleDowProp lv.listItems[i] (column.index-1)
		_txtInfo.text = getTxtInfo()
		)
	
	on lv_rollout open do
		(
		lv.size = [(lv_rollout.width), (lv_rollout.height-28)]
		for i in geometry do
			(
			i.boneFreezeLength = true
			i.boneAutoAlign = false
			i.boneScaleType = #none
			)
		_txtInfo.text = getTxtInfo()	
		initListView lv
		populateListView lv
		)
	
	on lv_rollout resized pos do
		(
		lv.size = [(lv_rollout.width), (lv_rollout.height-28)]
		)
		
	on lv_rollout close do 
		(
		callbacks.removeScripts #selectionSetChanged id:#SceneListView
		callbacks.removeScripts #selectionSetChanged id:#TxtInfo
		)
	
	) -- end rollout
	
try(destroyDialog lv_rollout)catch()
createDialog lv_rollout width:782 height:410 style:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)

-- Callback will repopulate lisview when selection changes.
callbacks.addScript #selectionSetChanged "lv_rollout.populateListView lv_rollout.lv" id:#SceneListView
callbacks.addScript #selectionSetChanged "lv_rollout._txtInfo.text = lv_rollout.getTxtInfo()" id:#TxtInfo

) -- end macroscript
