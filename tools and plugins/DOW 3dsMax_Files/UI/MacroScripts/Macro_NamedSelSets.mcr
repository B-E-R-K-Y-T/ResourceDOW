-- Macro_namedSelSets.ms - visual named selection set manager
-- October 30, 2001
-- Mark Young, Ravi Karra

/*
Revision History:

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


	19 Juin 2003; pfbreton
		changed layers handling and object properties handling to work with the new Layers logic change	
	
	24 mai 2003: pf breton 
		changed the name of the button text and tooltips
	
	26 apr 2004: LA Minton
		delaying dialog resets until viewport redraw
		isChecked/closeDialog handlers added
	
	4 apr 2006: Chris P. Johnson
		Replaced the activeX tree control with the .NET treeview control. 
		This was a Major overhaul of this script to make it play nice with .NET.
		Attempted to clean up the code to make it more comprehensible.
		Changed the dialog to a dockable floater, thus it cannot now be minimized
		  or viewed in a seperate viewport. However it was felt that the benefits outweighed
		  the drawbacks.
		Drag and drop now works consistently with treenodes. Now Entire selection sets can be
		  dragged and dropped. Before this was not possible.
	19 Oct 2006: Chris P. Johnson
		TODO: If you highlight selected object with the button on the top right, then deselct the object, the highlight stays.
			As designed. The performance penalty would be too great to introduce an 'on select' event handler.
		FIXED: The right click highlight selected item does not work.
		TODO: Clarify find next. 
			Who knows...?? Ask Ravi!
		FIXED: Dragging and dropping nodes to other nodes collapses them.
		TODO: Multiple selections??
			Not now.
		FIXED: Changing scene object names in treeview does not work.
          FIXED: Selecting treenode objects always selected their representative objects	
                objects in the scene. This behavior has been removed. Now you have to control + 
                click the treenode to select the scene objects. Previously the activeX control
                in max 8 allowed you to double click the treenode and hence select scene objects.
                In Max 9, double clicking a treenode expands and collapses it, with no work-around
                for changing the expansion state. Thus we couldn't use that event handler for selecting
                nodes.
*/

macroScript namedSelSets 
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	ButtonText:"Edit Named Selection Sets..." --pfb 24.05.2003
	category:"Edit" 
	internalCategory:"Edit" 
	tooltip:"Edit Named Selection Sets..." --pfb 24.05.2003

(
	--Forward declarations
	local vEditNamedSelectionSets	/* Rollout definition */
	local ensMenu				/* RcMenu  definition */
	local sToolbar				/* Struct  definition */	     
	
	--Struct definitions
	struct sToolbar (buttons=#())
	struct namedSelSetsData_struct (vEditNamedSelectionSets, ensMenu)
	
	--variables
	global namedSelSetsData
	local clone_node = undefined
	local is_cut = undefined

	local debug = true	
	--Utility function for converting maxscript colors to .NET colors
	function MXSColor_to_dotNetColor hColor = --New function
	(
		local dnColor = dotNetClass "System.Drawing.Color"
		dnColor.fromARGB hColor.r hColor.g hColor.b
	)
	
	
	function InspectTreeNodeClass netTreeNode =
	(
		--[brief] Used to inspect a treeNode
		format "TreeNode Name: %\n" netTreeNode.name
		format "TreeNode Text: %\n" netTreeNode.text
		format "TreeNode Tag:  %\n" netTreeNode.tag
	)
	
	rcMenu ensMenu
	(
		menuItem mi_rename		"Rename (F2)"
		menuItem mi_cut			"Cut (Ctrl+X)"
		menuItem mi_copy		"Copy (Ctrl+C)"
		menuItem mi_paste		"Paste (Ctrl+V)"
		menuItem mi_collapse	"Collapse All"
		menuItem mi_expand		"Expand All"
	seperator sep1
		menuItem mi_create		""
		menuItem mi_delete		""
		menuItem mi_add			""
		menuItem mi_subtract	""
	seperator sep2
		menuItem mi_selectSet	""
		menuItem mi_selectName	""
		menuItem mi_query		""
		menuItem mi_findNext	"Find Next (Ctrl+G)"
		
		on mi_rename picked   do ( vEditNamedSelectionSets.startEdit()           )  
		on mi_collapse picked do ( tvops.CollapseAll vEditNamedSelectionSets.vTVSets )  
		on mi_expand picked   do ( tvops.ExpandAll   vEditNamedSelectionSets.vTVSets )  
		
		on mi_create		picked do vEditNamedSelectionSets.executeButton #create
		on mi_delete		picked do vEditNamedSelectionSets.executeButton #delete
		on mi_add			picked do vEditNamedSelectionSets.executeButton #add
		on mi_subtract		picked do vEditNamedSelectionSets.executeButton #subtract
		on mi_selectSet 	picked do vEditNamedSelectionSets.executeButton #selectSet
		on mi_selectName 	picked do vEditNamedSelectionSets.executeButton #selectName
		on mi_query			picked do vEditNamedSelectionSets.executeButton #query
		on mi_findNext 		picked do vEditNamedSelectionSets.findNext()
		
		on ensMenu open do 
		(
			--Set the text for the menu items, and their default enabled state
			local menuItems = #(mi_create, mi_delete, mi_add, mi_subtract, mi_selectSet, mi_selectName, mi_query)
			for i = 1 to menuItems.count do
			(
				menuItems[i].text    = namedSelSetsData.vEditNamedSelectionSets.btnToolTips[i]
				menuItems[i].enabled = namedSelSetsData.vEditNamedSelectionSets.vToolbar.buttons[i].enabled
			)

			-- set states for cut/copy/paste
			local sel = vEditNamedSelectionSets.vTVSets.selectedNode
			
			if sel != undefined do
			(
				mi_paste.enabled = 	(vEditNamedSelectionSets.isSelSet sel.tag) and (clone_node != undefined) and (sel.text != clone_node.text)
			)
		)	
		on mi_cut picked do 
		(			
			clone_node = vEditNamedSelectionSets.vTVSets.selectedNode
			if clone_node != undefined do
			(
				clone_node.imageindex = 2
				vEditNamedSelectionSets.vTVSets.invalidate()
				is_cut = true
			)
		)
		on mi_copy picked do 
		(
			clone_node = vEditNamedSelectionSets.vTVSets.selectedNode
			if clone_node != undefined do 
			(
				clone_node.imageindex = 2
				vEditNamedSelectionSets.vTVSets.invalidate()
				is_cut = false
			)
		)
		on mi_paste picked do 
		(
			if clone_node != undefined then
			(
				local destNode = vEditNamedSelectionSets.vTVSets.selectedNode
				clone_node.imageindex = if (vEditNamedSelectionSets.IsSelSet clone_node.tag ) then 0  else 1
				vEditNamedSelectionSets.ReAssignObjects clone_node destNode is_cut				
				vEditNamedSelectionSets.vTVSets.invalidate()
				is_cut = false	
			)
		)
	)
	rollout vEditNamedSelectionSets "Named Selection Sets" width:340 height:375
	(
		--------------------------------------------------------
		local btnToolTips = #(
			"Create New Set",
			"Remove",
			"Add Selected Objects",
			"Subtract Selected Objects",
			"Select Objects in Set",
			"Select Objects By Name",
			"Highlight Selected Objects"
			)
		local bw = 24, bh = 24	--button width and button height			
		local vToolbar
		local ini_file = ((getDir #plugcfg) + "\\namedSelSets.ini")
		--------------------------------------------------------
		button vCreate		"" pos:[10 + bw*0, 5] width:bw height:bh tooltip: btnToolTips[1] --"Create New Set"
		button vDelete		"" pos:[10 + bw*1, 5] width:bw height:bh tooltip: btnToolTips[2] --"Remove"
		button vAdd			"" pos:[10 + bw*2, 5] width:bw height:bh tooltip: btnToolTips[3] --"Add Selected Objects"
		button vSubtract	"" pos:[10 + bw*3, 5] width:bw height:bh tooltip: btnToolTips[4] --"Subtract Selected Objects"
		button vSelectSet	"" pos:[10 + bw*4, 5] width:bw height:bh tooltip: btnToolTips[5] --"Select Objects in Set"
		button vSelectName	"" pos:[10 + bw*5, 5] width:bw height:bh tooltip: btnToolTips[6] --"Select Objects By Name"
		button vQuery		"" pos:[10 + bw*6, 5] width:bw height:bh tooltip: btnToolTips[7] --"Highlight Selected Objects"
		
		dotNetControl vTVSets    "System.Windows.Forms.TreeView" pos:[5,10 + bh] width:330 height:300
		dotNetControl vStatusBar "System.Windows.Forms.TextBox"  pos:[5,360] width:330 height:20
		
		-- Various locals ------------------------------------
		local btns = #(#create, #delete, #add, #subtract, #selectSet, #selectName, #query)		
		
		local highLightedTreeNodes = #() -- highlighted nodes
		local tvBackColor 		= color 223 223 223
		local tvNodeHighColor 	= color 120 0 0 
		local tvSetHighColor 	= color 0 0 120
		local drag_node = undefined, drop_node = undefined
		
		local DelayedResetGUI_Registered = false
		local rolloutOpen = false
		
		-- various key equivalents
		local kCtrl = 8, kF2 = 113, kF5 = 116, kDelete = 46, kCtrlX = 24, kCtrlC = 3, kCtrlV = 22, kCtrlG = 7
		
		-- ++ --------------Various Init Functions--------------- ++ --
		function initTreeView tv = 
		(
			tvops.InitTreeView tv pFullRowSel:true pAllowDrop:true

			local hfont = dotNetObject "System.Drawing.Font" "Arial" 10.0
			tv.font = hfont
			
			local imgFiles = #("$ui/icons/tvSet.ico","$ui/icons/tvObj.ico","$ui/icons/tvCutObj.ico")
			local transparency = (color 185 185 185)
			tvops.InitImageList tv imgFiles pSize:16 pTransparentColor:transparency 
		)

		function initButtons = 
		(
			-- collect the toolbar buttons into vToolbar.buttons array
			vToolBar.buttons = #(vCreate, vDelete, vAdd, vSubtract, vSelectSet, vSelectName, vQuery)
			
			-- assign image indices
			local buttonCount = btns.count
			for  b = 1 to buttonCount do
			(
				local ii = b * 2-1
				if b > 6 then ii -= 1
				vToolbar.buttons[b].images = #(
					"enss_tools_16i.bmp", 
					"enss_tools_16a.bmp",
					13, ii, ii, ii+1, ii+1)

					vToolbar.buttons[b].toolTip = btnToolTips[b]
			)
		)
		
		function initStatusBar sb = 
		(
			local bStyle = dotNetClass "System.Windows.Forms.BorderStyle"
			--vStatusBar.BorderStyle = bStyle.FixedSingle
			vStatusBar.BorderStyle = bStyle.Fixed3D
			local bColor 	= dotNetClass "System.Drawing.Color"
			vStatusBar.BackColor = bColor.fromARGB tvBackColor.r tvBackColor.b tvBackColor.g
			
			vStatusBar.text     = "Ready"
			vStatusBar.wordwrap = true
			vStatusBar.readOnly = true
		)
		-- ++ ------------Various Query Functions---------------- ++ --
		function isSelSet strName = --no fix needed
		(
			((classof strName) == String and selectionSets[strName] != undefined)
		)
		-- ++ ------------- Tree View Node Functions-------------- ++ --
		-- These functions are completely decoupled from selection Sets
		function addObjsToTreeView maxObjs parentTreeNode = 
		(		
			--[brief] Given an array of max scene objects, and a parent tree Node, 
			--        this function creates a tree node for each object under the parent node.
			--[param] maxObjs - A maxscript array of scene objects.
			--[param] parentTreeNode - An object of the System.Windows.Forms.TreeNode class.
			if parentTreeNode == undefined do throw "ERROR! parentTreeNode is undefined in FN addObjsToTreeView"
			if isValidNode maxObjs then maxObjs = #(maxObjs)
			
			--cache this method to improve performance
			local AddNodesToParentFN = parentTreeNode.nodes.add 
			for obj in maxObjs do
			(
				-- add a treeode with a                     key          and text (caption)
				local tvn              = AddNodesToParentFN (obj.inode.handle as string) obj.name
				
				tvn.imageindex         = 1
				tvn.selectedImageIndex = 1
				
				 -- tag the treenode with the scene object
				tvn.tag = dotNetMxsvalue obj
				
--				format "\tObject Name: % ------\n" obj.name
--				InspectTreeNodeClass tvn
			)
		)
		function removeObjsFromTreeView maxObjs oldParentTreeNode = --new function
		(
			--This function removes tree nodes from a parent treeNode
			--if (classof maxObjs != array) do throw "ERROR! maxObjs is not a array in FN removeObjsFromTreeView()"
			if maxObjs == undefined or maxObjs.count == 0 do throw "ERROR! maxObjs is empty in FN removeObjsFromTreeView()"
			
			local DO_NOT_RECURSE = false
			for movedObject in maxObjs do
			(
				local childNodes = oldParentTreeNode.nodes.Find (movedObject.inode.handle as string) DO_NOT_RECURSE				
				for child in childNodes do child.remove()
			)
		)
		function addSelSetToTreeView selSetName = 
		(
			--Add a node with a                               key   and  String
			local ssTreeNode              = vTVSets.nodes.add selSetName selSetName
			ssTreeNode.tag 		     = selSetName
			ssTreeNode.ImageIndex 	     = 0
			ssTreeNode.selectedImageIndex = 0
			ssTreeNode
		)
		function removeSelSetFromTreeView treeNode =
		(
			vTVSets.nodes.remove treeNode
		)
		-- ++ ------------- Selection Set Methods ---------------- ++ --
		-- These functions are completely decoupled from from the treeview
		function GetSelSetObjects setname = --new function
		(
			if selectionSets[setname] == undefined do throw "Selection Set Name is undefined in FN GetSelSetObjects"
					
			--Get the old objects in the destination Selection Set
			local oldSelSetObjs = for obj in selectionSets[setname] collect obj
			if oldSelSetObjs == undefined do throw "ERROR! old oldSSObjs is undefined in FN GetSelSetObjects()"			
			oldSelSetObjs
		)
		function AddObjectsToSelectionSet objs setname =
		(
			--IMPORTANT NOTE: Returns a new array of non-duplicated scene objs that were 
			--added to the selection set.
			local oldSelSetObjs = GetSelSetObjects setname
			
			--Prevent duplicate entries in oldSelSetObjs arrays
			local nonDuplicatedObjs = #()
			
			for ob in objs do
			(
				local index = findItem oldSelSetObjs ob
				if index == 0 do --If not found
				(
					append oldSelSetObjs ob
					append nonDuplicatedObjs ob
				)
			)
			
			--Add to the selection set
			selectionSets[setname] = oldSelSetObjs
			nonDuplicatedObjs
		)
		function RemoveObjectsFromSelectionSet objs setname =
		(
			local oldSelSetObjs = GetSelSetObjects setname
			
			--for each moved object
			for removedObject in objs do
			(
				--see if it is in the old selection set array
				local index = findItem oldSelSetObjs removedObject
				if (index > 0) do
				(
					--if so, remove it from the old selection set
					deleteItem oldSelSetObjs index
				)
			) 
			selectionSets[setname] = oldSelSetObjs
			selectionSets[setname]
		)
		-- ++ ------------- GUI Methods ---------------- ++ --
		function fUpdateButtons selNode: = 
		(
			if selNode == unsupplied do selNode = vTVSets.selectedNode
			if selNode != undefined do
			(
				local isSceneSelected 		= (selection.count > 0)
				local isObjectTreeNodeSelected = false
				if selNode != undefined do 
				(
					isObjectTreeNodeSelected = selNode.parent != undefined
				)
				local isAnyTreeNodeSelected 	= vTVSets.selectedNode != undefined
				local hasTreeObjects 		= vTVSets.nodes.count > 0
				
				vdelete.enabled    = hasTreeObjects					            --"Remove"
				vadd.enabled       = isSceneSelected and (NOT isObjectTreeNodeSelected) --"Add Selected Objects"
				vsubtract.enabled  = isSceneSelected and (NOT isObjectTreeNodeSelected) --"Subtract Selected Objects" 
				vselectSet.enabled = hasTreeObjects  --and (NOT isObjectTreeNodeSelected) --"Select Objects in Set"
				
				local cursel = getCurrentSelection()
				--for the selection set caption
				local selsetStr = ""
				if selNode != undefined do (
					selsetStr = if (isSelSet selNode.tag) then selNode.text else if (isValidNode selNode.tag.value) then selNode.text else ""
				)
				--for the selected scene object string
				local selStr = if cursel.count == 1 then cursel[1].name else cursel.count as string
				
				vStatusBar.text = "{" + selsetStr + "} - " + "Selected: " + selStr
			)
		)
		function fResetGUI = 
		(
			tvops.ClearTvNodes vTVSets
			vTVSets.sorted = true
			
			local numberSelSets = getNumNamedSelSets()
			for i = 1 to numberSelSets do
			(
				local ssTreeNode = addSelSetToTreeView (getNamedSelSetName i)
	
				addObjsToTreeView selectionSets[i] ssTreeNode
			)
		)
		function DelayedResetGUI =
		(
			if DelayedResetGUI_Registered do
			(
				unregisterRedrawviewsCallback DelayedResetGUI
				if rolloutOpen do fResetGUI()
				DelayedResetGUI_Registered = false
			)
		)
		function fRegDelayedResetGUI =
		(
			if not DelayedResetGUI_Registered do
			(
				DelayedResetGUI_Registered = true
				registerRedrawviewsCallback DelayedResetGUI
			)
		)
		function fRefresh reset:true =
		(
			local selIndex = if vTVSets.selectedNode == undefined then 0 else vTVSets.selectedNode.index
			
			if reset do fResetGUI()
			vTVSets.refresh()
		)
		function CreateSet = 
		(
			--Creates a new selection Set, and adds a tree Node to the UI
			--Find a unique selection set name
			local i = 1
			local keepGoing = true
			while (keepGoing) do (
				local newName = "New Set"
				if (i >= 1) and (i < 10) then newName = newName + " ( 0"+ (i as string) + ")"
				        else if (i >= 10) do newName = newName + " ( "+ (i as string) + ")"
					
				if (selectionSets[newName] == undefined) then keepGoing = false
				else i = i + 1
			)
			--Create the selection set
			selectionSets[newName] = selection
			
			local newSetNode = (addSelSetToTreeView newName)
			vTVSets.selectedNode = newSetNode
			
			addObjsToTreeView (getCurrentSelection()) newSetNode
			
			vTVSets.labelEdit = true
			newSetNode.BeginEdit()
		)
		-- ++ ------------- Object Manipulation Methods ---------------- ++ --
		-- These functions operate on BOTH treeview nodes and selection sets
		function AddItems objs destTreeNode = --new function
		(
			--Adds an array of scene objects to a Tree Node representing a selection Set
			--        if objs == undefined do throw "ERROR! objs is undefined in FN AddItems"
			--if destTreeNode == undefined do throw "ERROR! destTreeNode is undefined in FN AddItems"
			
			--The destination Tree Node should never represent a scene object
			if (destTreeNode != undefined) and (IsSelSet destTreeNode.tag) do
			(
				--Get the selection set name
				local selSetName = destTreeNode.tag
				
				--Add to the selection set
				--NOTE: it is possible for objs here to be modified, as duplicate
				--entries are removed.
				objs = AddObjectsToSelectionSet objs selSetName
				
				--Add to the treeview
				addObjsToTreeView objs destTreeNode
			)
		)
		function fRemoveItems objs treeNode = --new function
		(
			--Removes an array of scene objects from a Tree Node representing a selection Set
			--    if objs == undefined do throw "ERROR! objs is undefined in FN fRemoveItems"
			
			--The old parent Tree Node should never represent a scene object
			if (treeNode != undefined) and (IsSelSet treeNode.tag) do 
			(	
				--Get the selection set name
				local selSetName = treeNode.tag
				
				--remove nodes from the treeview
				removeObjsFromTreeView objs treeNode
				
				--remove from the old selection set
				RemoveObjectsFromSelectionSet objs selSetName
			)
		)
		-------------------------------------------------------------------
		function fDeleteItem =
		(
			--Actived by a single delete command (i.e. keyboard). 
			--This operates on a Selection Set or a Scene object

			local selectednode = vTVSets.selectedNode			
			if (selectednode != undefined) do 
			(
				local val = selectednode.tag
				
				if (classof val) == String and selectionSets[val] != undefined then
				(
					--val is a selection Set string
					deleteItem selectionSets selectednode.text
					removeSelSetFromTreeView selectednode
				)
				else if (isValidNode val.value) then
				(
					--val is a dotNetObject wrapping a scene object
					fRemoveItems #(val.value) selectedNode.parent
				)
			)
			fUpdateButtons()
		)
		function fSelectObjects sel =
		(
			local selSet = undefined
			
			if ( (sel != undefined) and (NOT(isSelSet sel.tag)) ) do
			(
				if (isValidNode sel.tag.value) and (sel.parent != undefined)do
				(
					sel = sel.parent
				)
			)
			
			if (sel != undefined) and (sel.text != undefined) and (selectionSets[sel.text] != undefined) then
			(	
				selSet = selectionSets[sel.text]
			)
			
			if (selSet != undefined) then
			(
				with redraw Off
				(
					clearSelection()
					
					local setObjs = for obj in selSet where (obj != undefined not obj.isHidden and not obj.isFrozen) collect obj
					if setObjs.count != selset.count then					
					(
							
						local unset = QueryBox "This set contains hidden and/or frozen objects.\nDo you want these objects to be unhidden and unfrozen?\n(Choosing \"No\" means that the hidden/frozen objects will not be selected.)" \
												title:"3ds max"
						if unset == true then
						( 
							unhide   selSet doLayer:true -- pfbreton; 19 June 2003
							unfreeze selset doLayer:true -- pfbreton; 19 June 2003
							select selSet
						)
						else
						(
							select setObjs
						)
					)
					else
					(
						select selSet				
					)
				)					
			)
		)
		function SelQuery =
		(
			setWaitCursor()
				
			--Clear the previous highlighted nodes					
			local dnColor = dotNetClass  "System.Drawing.Color"
			for hn in highLightedTreeNodes do
			(
				hn.foreColor = dnColor.fromARGB 0 0 0
				hn.nodeFont = vTVSets.Font
			)
			
			vTVSets.selectedNode = undefined
			highLightedTreeNodes = #()
			

			local INCLUDE_SUBTREES  = true
			local dnFontFamily    = dotNetObject "System.Drawing.FontFamily" "Arial"
			local dnFontStyle     = dotNetClass  "System.Drawing.FontStyle"
			local dnHighLightFont = dotNetObject "System.Drawing.Font" dnFontFamily 10 (dnFontStyle.Bold)
			
			for obj in selection do
			(
				--Find the tree node
				local selectedTreeNodes = vTVSets.nodes.find (obj.inode.handle as string) INCLUDE_SUBTREES
				
				--for each found tree node found
				for cNode in selectedTreeNodes do
				(
					--highlight the child tree node
					cNode.nodeFont = dnHighLightFont
					cNode.forecolor = MXSColor_to_dotNetColor tvSetHighColor
					append highLightedTreeNodes cNode
					
					--highlight the parent tree node if it exists
					local parentedSelSetNode = undefined
					if (cNode.parent != undefined) do 
					( 
						parentedSelSetNode = cNode.parent
						append highLightedTreeNodes parentedSelSetNode
						parentedSelSetNode.nodeFont  = dnHighLightFont
						parentedSelSetNode.foreColor = MXSColor_to_dotNetColor tvSetHighColor
					)	
				)
			)
			if highLightedTreeNodes.count > 0 do highLightedTreeNodes[1].ensureVisible()
				
			setArrowCursor()
		)
		function findNext = 
		(
			--find next highlighted selection set tree node
			if highLightedTreeNodes.count > 2 do 
			(
				local sel = vTVSets.selectedNode
				local c 
				if sel == undefined then
				(
					local endIndex = highLightedTreeNodes.count
					c = highLightedTreeNodes[endIndex]
				)
				else
				(
					if (isSelSet sel.tag) then
						c = sel
					else if (isValidNode sel.tag.value) then
						c = sel.parent
					else  
						c = sel 
				)
				
				for tNode in highLightedTreeNodes where (isSelSet tNode.tag) do
				(
					if tNode.nodeFont.bold == true do
					(
						vTVSets.selectedNode = tNode
					)
				)
			)
		)
		function fOpen =
		(
			if GetCommandPanelTaskMode() == #modify and subobjectlevel > 0 then
			(
				max rns
			)
			else
			(
				local pos    = execute (getIniSetting ini_file #general #position)
				local width  = execute (getIniSetting ini_file #general #width)
				local height = execute (getIniSetting ini_file #general #height)
				
				if pos    == ok do pos    = [100, 100]					
				if width  == ok do width  = 340
				if height == ok do height = 375
				createDialog vEditNamedSelectionSets width:width  \
											 height:height \
											    pos:pos    \
					                          style: #(#style_titlebar, #style_sysmenu, #style_resizing, #style_minimizebox, #style_toolwindow) \
					                         escapeEnable:false
				cui.RegisterDialogBar vEditNamedSelectionSets maxsize: [-1,-1] style: #(#cui_dock_vert,#cui_floatable) minSize: [182,150] 
			)
		)
		function startEdit =
		(
			if vTVSets.selectedNode != undefined then
			(
				vTVSets.labelEdit = true
				vTVSets.selectedNode.beginEdit()
				true
			)
			else
			(
				vTVSets.labelEdit = false
				false	
			)
		)
		function ReAssignObjects draggedNode destinationNode bMove = 
		(
			--Get the scene objects that are moving
			if (draggedNode == undefined) do throw "dragged node is undefined in FN ReAssignObjects"
			
			--Can move a tree node representing either a selection set or one scene	object
			local movedObjs = if isSelSet draggedNode.tag then selectionSets[draggedNode.tag] else #(draggedNode.tag.value)

			if (movedObjs != undefined) and (movedObjs.count != 0) do 
			(
				--Add the scene objects to the destination selection set tree Node
				AddItems movedObjs destinationNode
				
				------------------------------------------------
				--If the user held down the control key, the entries
				--will be copied, otherwise remove the old tree nodes.
				if bMove do
				(
					if (IsSelSet draggedNode.tag) then
					(	
						fRemoveItems movedObjs draggedNode
					)
					else --This is an object
					(
						fRemoveItems movedObjs draggedNode.parent	
					)
				)
				------------------------------------------------
				gc light:true
			)
		)
		function ShutDown =
		(
			cui.UnRegisterDialogBar vEditNamedSelectionSets
			destroyDialog namedSelSetsData.vEditNamedSelectionSets
		)
		function RegisterSelectionSetCallbacks = 
		(
			--New callbacks in 3dsmax version 9.0
			--These help the selection set dialog keep current with selection set activities in the UI. All actions that
			--occur in the selection set dialog that match these actions should probably temporarily disable these event handlers.
			callbacks.addscript #NamedSelSetDeleted      "namedSelSetsData.vEditNamedSelectionSets.OnSelectionSetDeleted()" \
				id:#vEditNamedSelectionSetsCallBacks
			callbacks.addscript #NamedSelSetCreated      "namedSelSetsData.vEditNamedSelectionSets.OnSelectionSetAdded()" \
				id:#vEditNamedSelectionSetsCallBacks
			callbacks.addscript #NamedSelSetRenamed  	 "namedSelSetsData.vEditNamedSelectionSets.OnSelectionSetRenamed()" \
				id:#vEditNamedSelectionSetsCallBacks			
		)
		function UnRegisterSelectionSetCallbacks = 
		(
			callbacks.removeScripts id:#vEditNamedSelectionSetsCallBacks
		)
		---------------------------------------------------
		on vEditNamedSelectionSets open do
		(
			vToolbar = sToolbar() 
			initTreeView vTVSets
			
			DelayedResetGUI_Registered = false
			rolloutOpen = true
			initButtons()
			initStatusBar vStatusbar
			
			fResetGUI()
			fUpdateButtons()
			
				local tvSize = [vEditNamedSelectionSets.width,vEditNamedSelectionSets.height] - [20, 60]
			vTVSets.width  = tvsize.x
			vTVSets.height = tvsize.y
			vStatusbar.pos = [10, vEditNamedSelectionSets.height-25]
				local sbSize = [vEditNamedSelectionSets.width - 20, 20]
			vStatusbar.width = sbSize.x
			vStatusBar.height= sbSize.y
			
			callbacks.addScript #selectionSetChanged	"namedSelSetsData.vEditNamedSelectionSets.fUpdateButtons()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #filePostOpen			"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPostReset		"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPostNew			"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets	
			callbacks.addScript #nodePostDelete 		"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets					
			callbacks.addScript #nodeRenamed			"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #sceneUndo				"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #sceneRedo				"namedSelSetsData.vEditNamedSelectionSets.fRegDelayedResetGUI()" \
				id:#vEditNamedSelectionSets
			--==============================================================	
			RegisterSelectionSetCallbacks()
			--==============================================================
			-- New callback in 3dsMax 9.0
			callbacks.addscript #ModPanelSubObjectLevelChanged  	"namedSelSetsData.vEditNamedSelectionSets.OnSubObjectLevelChanged()" \
				id:#vEditNamedSelectionSets
			--==============================================================	
			callbacks.addScript #systemPreReset			"namedSelSetsData.vEditNamedSelectionSets.shutdown()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPreNew			"namedSelSetsData.vEditNamedSelectionSets.shutdown()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #filePreOpen			"namedSelSetsData.vEditNamedSelectionSets.shutdown()" \
				id:#vEditNamedSelectionSets
		)
		on vEditNamedSelectionSets close do
		(
			rolloutOpen = false
			--try (
				callbacks.removeScripts id:#vEditNamedSelectionSets
				callbacks.removeScripts id:#vEditNamedSelectionSetsCallBacks
				--unRegisterViewWindow vEditNamedSelectionSets --Dialog is now a floater 
				clone_node = undefined
				setIniSetting ini_file #general #position ((getDialogPos vEditNamedSelectionSets) as string)
				setIniSetting ini_file #general #width     (vEditNamedSelectionSets.width  as string)
				setIniSetting ini_file #general #height    (vEditNamedSelectionSets.height as string)
			--) catch ( format "Error writing INI file: %\n" ini_file )
			updateToolbarButtons()	
		)
		on vEditNamedSelectionSets resized size do
		(
			local tvSize = size - [10, 60]
			vTVSets.width  = tvSize.x
			vTVSets.height = tvSize.y
			
			vStatusbar.pos = [5, size.y-25]
			
			local sbSize = [size.x - 10, 20]
			vStatusbar.width  = sbSize.x
			vStatusbar.height = sbSize.y
		)
		---------------------------------------------------		
		-- button click event handlers
		function executeButton hName = 
		(
			callbacks.removeScripts id:#vEditNamedSelectionSetsCallBacks
			undo on
			(
				case hName of
				(
					#create:		CreateSet()   
					#delete:		fDeleteItem()  
					#add:		AddItems    (getCurrentSelection()) vTVSets.selectedNode
					#subtract:	fRemoveItems (getCurrentSelection()) vTVSets.selectedNode
					#selectSet:	fSelectObjects (vTVSets.selectedNode)
					#selectName: 	
					(
						local objs = (selectByName title:"Select Objects")
						if objs != undefined then select objs
					)
					#query: 		SelQuery()
				)
			)
			RegisterSelectionSetCallbacks()
		)
		
		on vCreate	pressed do executeButton #create
		on vDelete	pressed do executeButton #delete
		on vAdd		pressed do executeButton #add
		on vSubtract	pressed do executeButton #subtract
		on vSelectSet	pressed do executeButton #selectSet
		on vSelectName	pressed do executeButton #selectName
		on vQuery		pressed do executeButton #query
		
		--------------------------------------------------
		-- TreeView Event Handlers
		--------------------------------------------------
		on vTVSets KeyDown arg do      --arg is <System.Windows.Forms.KeyEventArgs>
		(
			if arg.Control do vTVSets.labelEdit = false
		)
		
		on vTVSets keyUp arg do
		(	
			-- arg is System.Windows.Forms.KeyEventArgs
			if arg.Control then (
				vTVSets.labelEdit = true
			)
			else (
				vTVSets.labelEdit = false
			)

			case arg.keyValue of
			(
				kF5: 	fRefresh()
				kF2: 	startEdit()
				kDelete: 	fDeleteItem()
			)
		)
		
		on vTVSets keyPress arg do
		(	
			--callbacks.removeScripts id:#vEditNamedSelectionSetsCallBacks

			-- arg is System.Windows.Forms.KeyPressEventArgs
			local theKey = getproperty arg #keychar asDotNetObject: true
			local cn = dotNetClass "System.Convert"
			local KeyCharNum = cn.ToInt32 theKey
			
			/*
			Note: All keyChar's returned with the control key pressed
			are unprintable as a maxscript string. However keyboard input
			returned when SHIFT is pressed is correct.

			Note: See MSDN documentation for this event type.
			See KeyPressEventArgs.KeyChar Property  for restrictions 
			on keys that cannot be accessed.
			*/
			local sel = vTVSets.selectedNode
			
			if sel != undefined do
			(
				case KeyCharNum of
				(
					kCtrlX 	: ensMenu.mi_cut.picked()
					kCtrlC	: ensMenu.mi_copy.picked()
					kCtrlV	: if isSelSet sel.tag then ensMenu.mi_paste.picked()
					kCtrlG    : findNext()
				)
			)
			--RegisterSelectionSetCallbacks()
		)
		
		on vTVSets afterLabelEdit arg do 
		(	
			callbacks.removeScripts id:#vEditNamedSelectionSetsCallBacks
			-- arg is System.Windows.Forms.NodeLabelEditEventArgs
			if (arg.cancelEdit == false) and (arg.label != undefined) and (arg.label != "") then
			(
				local newString   = arg.label
				local selTreeNode = vTVSets.selectedNode	
				local oldString   = selTreeNode.text
				local val         = selTreeNode.tag
				
				if isSelSet val then
				(
					--Change the name in the SelectionSet
					local theSet = selectionSets[oldString]
					theSet.name = newString
					
					--Change the fields data in the treeNode UI
					selTreeNode.tag = newString
					selTreeNode.text = newString
					selTreeNode.name = newString
				)
				else if (isValidNode val.value) then
				(
					val.value.name = newString
				)
			)
			else if arg.label == "" do
			(
				messageBox "An empty string is invalid name.\nSetting name to the old value and\nRefreshing the list.\n"
				
				fResetGUI()
			)
			RegisterSelectionSetCallbacks()
		)
		
		on vTVSets MouseUp arg do 
		(
			-- arg is System.Windows.Forms.MouseEventArgs
			--enableAccelerators = false			
			local hitNode = tvops.getHitNode arg vTVSets
			
			fUpdateButtons selNode: hitNode
			local mouseButtons = dotNetClass "System.Windows.Forms.MouseButtons"
			
			if arg.button == mouseButtons.right and hitNode != undefined do
			(
				vTVSets.selectedNode = hitNode
				popupmenu ensMenu pop:[arg.x, arg.y] rollout:vEditNamedSelectionSets
			)
		)
		
		--on vTVSets click arg do
		on vTVSets NodeMouseClick arg do
		( 		
			if (keyboard.controlpressed) do
			(	
				--local selNode = tvops.getHitNode arg vTVSets
				local selNode = arg.node
				if (selNode != undefined) do
				(	
					local val = selNode.tag
					undo "Select Set" on
					(
						if isSelSet val then						
							fSelectObjects selNode
						else if (isValidNode val.value) then 
							select val.value
					)
				)
			)
		)
			
		on vTVSets ItemDrag arg do
		(	
			-- arg is System.Windows.Forms.ItemDragEventArgs
			--This event handler simply gets the drag and drop going, and activates the
			--important DoDragDrop method. You must FIRST call the DoDragDrop method
			--to enable the DragDrop event handler.
			drag_node = arg.item

			if drag_node != undefined do 
			(
				local effect = dotNetclass "System.Windows.Forms.DragDropEffects"	
				vTVSets.DoDragDrop arg.item effect.move
			)
		)

		on vTVSets DragOver arg do
		(	
			-- arg is System.Windows.Forms.DragEventArgs	
			--This function:
			-- Keeps the mouse cursor 'painted' with the drag cursor.
			-- Highlights a valid droppable selection set treeNode.
			-- Checks that you can't drag an object to it's previous parent.
			if (drag_node != undefined) and (arg.data.GetDataPresent(dotNetClass "System.Windows.Forms.TreeNode")) do
			(
				local dragDropEffect = dotNetclass "System.Windows.Forms.DragDropEffects"
				arg.effect = dragDropEffect.move
				
				local position = dotNetObject "System.Drawing.Point" arg.x arg.y
				position = vTVSets.pointToClient position
				
				drop_node = vTVSets.GetNodeAt position
				
				if drop_node != undefined do 
				(
					--Only allow dropping on a selection set tree node
					if (isSelSet drop_node.tag) then
					(
						--If the drag node is a selection set, then highlight it
						if (isSelSet drag_node.tag) then
						(
							if drop_node.text != drag_node.text then
								vTVSets.selectedNode = drop_node --dropHighlight
							else
								vTVSets.selectedNode = undefined
						)
						else --Dragging an object
						(
							--Only object level tree nodes have a parent property
							if drop_node.text != drag_node.parent.text then
								vTVSets.selectedNode = drop_node --dropHighlight
							else
								--Do not allow dragging to it's own parent
								drop_node = undefined
								--vTVSets.selectedNode = undefined
						)
					)
					else
					(
						vTVSets.selectedNode = undefined
						drop_node = undefined
					)
				)

			)
		)
		
		on vTVSets DragDrop arg do
		(	
			UnRegisterSelectionSetCallbacks()
			-- arg is System.Windows.Forms.DragEventArgs

			--You must first have called the treeviews DoDragDrop Method when you start your
			--drag and drop operation. Only AFTER you call the DoDragDrop method will the
			--DragDrop event get called
			
			if (drop_node != undefined) and (drag_node != undefined) do
			( 
				--Do not allow to drag a tree node on to itself
				if (drop_node != drag_node) do
				(	
					vTVSets.beginUpdate()
					ReAssignObjects drag_node drop_node (arg.keyState != kCtrl)
					vTVSets.endUpdate()
				)
			)
			RegisterSelectionSetCallbacks()
		)

		-------------------------------------------------------------------
		-- Callback Event Handlers
		--
		-- These functions are registered when the rollout opens up.
		-------------------------------------------------------------------
		function OnSelectionSetDeleted =
		(
			local oldSetName = callbacks.notificationParam()

			--Find the tree node
			local deletedTreeNodes = vTVSets.nodes.find oldSetName false
			
			local deletedTreeNode = deletedTreeNodes[1]
			deletedTreeNode.remove()
		)
		function OnSelectionSetAdded =
		(
			local newSetName = callbacks.notificationParam()
			if selectionsets[newSetName] != undefined do
			(
				local objs = for item in selectionSets[newSetName] collect item
				
				--Add a selection set node to the treeview
				local newSelSet = addSelSetToTreeView newSetName
				
				--Add object nodes to the treeview
				addObjsToTreeView objs newSelSet

			)
		)
		function OnSelectionSetRenamed =
		(
			local param = callbacks.notificationParam()
			
			local newName = param[2]
			local oldName = param[1]
				
			--Find the tree node
			local renameTreeNodes = vTVSets.nodes.find oldName false
			if (renameTreeNodes != undefined) and (renameTreeNodes.count > 0) then
			(	
				local renameTreeNode = renameTreeNodes[1]
				renameTreeNode.text  = newName
				renameTreeNode.tag   = newName
				renameTreeNode.name  = newName
			)
			else
			(
				-- "No node found"	
			)
		)
		function OnSubObjectLevelChanged =
		(
			--The Named Selection Set Editor is only for object selection,
			--not, sub-object selection. Thus when the user enters sub-object
			--mode, this UI should become disabled.
			local param = callbacks.notificationParam()
			
			if (param != undefined) do
			(
				local newSubObjectLevel = param[1]
				if (newSubObjectLevel == 0) then
				(
					for control in vEditNamedSelectionSets.controls do control.enabled = true
				)
				else
				(
					for control in vEditNamedSelectionSets.controls do control.enabled = false	
				)
			)
		)		
	)
	
	on execute do 
	(
		namedSelSetsData = namedSelSetsData_struct vEditNamedSelectionSets ensMenu
		vEditNamedSelectionSets.fOpen()
	)
	
	on isChecked do 
	(
		vEditNamedSelectionSets.rolloutOpen
	)
		
	on closeDialogs do
	(
		if (vEditNamedSelectionSets.DialogBar) do 
		(
			cui.UnRegisterDialogBar vEditNamedSelectionSets
		)
		destroyDialog vEditNamedSelectionSets
	)
)
