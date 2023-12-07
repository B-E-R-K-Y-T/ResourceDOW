/*
********************************************************************************
Macro Scripts for Trackview
Author:   Adam Felt

Revision History:
		11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
		consolidated the macro_collapsecontroller.mcr with the macro_trackview.mcr



Modify at your own risk
-- ********************************************************************************
*/

-- Animation Editor Launch Macors
-- ********************************************
macroScript LaunchFCurveEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Curve Editor (Open)"
	buttonText:"Curve Editor..."
	Icon:#("TrackViewTools",23)
(
	on execute do
	(
-- Open the track view
		if  (trackviews.open "Track View - Curve Editor" layoutName:"Function Curve Layout") == true then 
		(
			-- Set up the parameters for a fcurve editor
			if trackviews.current != undefined do
			(
				trackviews.current.setname "Track View - Curve Editor"
				trackviews.current.modifySubTree = false
			)
		)
		else (
			messageBox "The Track View window could not be opened.\nThe maximum number of editors may have been reached.\nTry closing and deleting existing Track Views." title:"Track View"
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
macroScript SwitchToFCurveEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Curve Editor (Switch To)"
	buttonText:"Curve Editor"
	--Icon:#("TrackViewTools",23)
(
	on execute do
	(
		if trackviews.current != undefined do
		(
			trackviews.current.setname "Track View - Curve Editor"
			trackviews.current.modifySubTree = false
			trackviews.current.ui.loadLayout "Function Curve Layout"
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
macroScript LaunchDopeSheetEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Dope Sheet(Open)"
	buttonText:"Dope Sheet..."
	Icon:#("TrackViewTools",15)
(
	on execute do
	(
		-- Open the track view
		if (trackviews.open "Track View - Dope Sheet" layoutName:"Dope Sheet Layout") == true then
		(
			-- Set up the parameters for a fcurve editor
			if trackviews.current != undefined do
			(
				trackviews.current.setname "Track View - Dope Sheet"
				trackviews.current.modifySubTree = true
			)
		)
		else (
			messageBox "The Track View window could not be opened.\nThe maximum number of editors may have been reached.\nTry closing and deleting existing Track Views." title:"Track View"
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
macroScript SwitchDopeSheetEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Dope Sheet (Switch To)"
	buttonText:"Dope Sheet"
	--Icon:#("TrackViewTools",15)
(
	on execute do
	(
		if trackviews.current != undefined do
		(
			trackviews.current.setname "Track View - Dope Sheet"
			trackviews.current.modifySubTree = true
			trackviews.current.ui.loadLayout "Dope Sheet Layout"
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
macroScript LaunchRangeEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Controller Range Editor (Open)"
	buttonText:"Controller Range Editor..."
	Icon:#("TrackViewTools",21)
(
	on execute do
	(
		
-- Pop up the warning with no titlebar
		createdialog ConstWarning style:#(#style_border)

-- Open the track view
		CR_Edit= trackviews.open "Track View - Controller Editor" layoutName:"Controller Range Layout"
	
-- Set up the parameters for a controller editor	
		if trackviews.current != undefined do
		(
			trackviews.current.setname "Track View - Controller Editor"
			trackviews.current.modifySubTree = false
			trackviews.current.editmode = #positionranges
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
macroScript SwitchRangeEditor
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Controller Ranges(Switch To)"
	buttonText:"Controller Ranges..."
	--Icon:#("TrackViewTools",21)
(
	on execute do
	(
		if trackviews.current != undefined do
		(
			trackviews.current.ui.showKeyableIcons = true
			trackviews.current.setname "Track View - Controller Ranges"
			trackviews.current.modifySubTree = false
			trackviews.current.editmode = #positionranges
			trackviews.current.ui.loadLayout "Controller Range Layout"
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
-- Curve Editor Macros
-- ********************************************
macroScript ShowNonselectedCurves
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Show Nonselected Curves"
	buttonText:"Show Non-Selected Curves"
	Icon:#("TrackViewTools",62)
(
	on execute do
	(
		if trackviews.current != undefined do
		(
			trackviews.current.showNonSelCurves = true
			trackviews.current.freezeNonSelCurves = false
		)
	)
	On isChecked do
 	(
		if trackviews.current != undefined 
		then trackviews.current.showNonSelCurves
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript HideNonselectedCurves
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Hide Nonselected Curves"
	buttonText:"Hide Non-Selected Curves"
	Icon:#("TrackViewTools",64)
(
	on execute do
	(
		trackviews.current.showNonSelCurves = false
	)
	on isChecked do
 	(
		if trackviews.current != undefined 
		then not trackviews.current.showNonSelCurves
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript FreezeNonselectedCurves
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Freeze Nonselected Curves"
	buttonText:"Freeze Non-Selected Curves"
	Icon:#("TrackViewTools",63)
(
	on execute do
	(
		if (trackviews.currenttrackview.freezeNonSelCurves) == true 
		then trackviews.currenttrackview.freezeNonSelCurves = false
		else trackviews.currenttrackview.freezeNonSelCurves = true
	)
	on isChecked do
 	(
		if trackviews.current != undefined 
		then trackviews.current.freezeNonSelCurves
		else false
	)
	on isEnabled do
 	(
		if trackviews.current != undefined 
		then trackviews.current.showNonSelCurves
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript ShowAllTangents
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Show All Tangents"
	buttonText:"Show All Tangents"
	Icon:#("TrackViewTools",80)
(
	on ischecked do
	(
		if trackviews.current != undefined 
		then ((trackviews.current.showTangents as string) == "all")
		else false
	)
	on execute do
	(
		if trackviews.current != undefined do
		(	
			if (trackviews.currenttrackview.showTangents as string) == "selected" or (trackviews.currenttrackview.showTangents as string) == "none" 
			then trackviews.currenttrackview.showTangents = #all
			else trackviews.currenttrackview.showTangents = #selected
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript ShowSelectedTangents
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Show Selected Tangents"
	buttonText:"Selected"
	Icon:#("TrackViewTools",77)
(
	on ischecked do
	(
		if trackviews.current != undefined 
		then ((trackviews.current.showTangents as string) == "selected")
		else false
	)
	on execute do
	(
		if trackviews.current != undefined do
		(	
			trackviews.current.showTangents = #selected
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript HideTangents
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Hide Tangents"
	buttonText:"None"
	Icon:#("TrackViewTools",78)
(
	on ischecked do
	(
		if trackviews.current != undefined 
		then ((trackviews.current.showTangents as string) == "none")
		else false
	)
	on execute do
	(
		if trackviews.current != undefined do
		(	
			trackviews.current.showTangents = #all
		)
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript ShowFrozenKeys
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Show Frozen Keys"
	buttonText:"Show Frozen Keys"
	--Icon:#("TrackViewTools",63) NO ICON YET
(
	on execute do
	(
		if trackviews.current != undefined do
		(	
			trackviews.current.showFrozenKeys = not trackviews.current.showFrozenKeys
		)
	)
	on ischecked do
	(
		if trackviews.current != undefined 
		then trackviews.current.showFrozenKeys
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript InteractiveUpdate
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Interactive Update"
	buttonText:"Interactive Update"
	--Icon:#("TrackViewTools",63) NO ICON YET
(
	on execute do
	(
		if trackviews.current != undefined do
		(	
			trackviews.currenttrackview.interactiveupdate = not trackviews.currenttrackview.interactiveupdate
			-- sync time and interactive update are mutually exclusive
			-- if you are turning on interactive update turn off sync time
			if trackviews.currenttrackview.interactiveupdate do
				trackviews.currenttrackview.syncTime = false
		)
	)
	on ischecked do
	(
		if trackviews.current != undefined 
		then trackviews.currenttrackview.interactiveupdate
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript SyncTime
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	category:"Track View"
    internalCategory:"Track View" 
	toolTip:"Sync Cursor Time"
	buttonText:"Sync Cursor Time"
	--Icon:#("TrackViewTools",63) NO ICON YET
(
	on execute do
	(
		if trackviews.current != undefined do
		(	
			trackviews.currenttrackview.syncTime = not trackviews.currenttrackview.syncTime
			-- sync time and interactive update are mutually exclusive
			-- if you are turning on sync time turn off interactive update
			if trackviews.currenttrackview.syncTime do
				trackviews.currenttrackview.interactiveupdate = false
		)
	)
	on ischecked do
	(
		if trackviews.current != undefined 
		then trackviews.currenttrackview.syncTime
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

-- UI Layout macros
-- ********************************************

macroScript TV_Load_Layout
			enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Load Layout" 
            buttontext:"Load Layout..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout Layouts "Load Layout" width:150 height:117
	(
		local tv
		
		dropdownList layoutList "Layouts" pos:[9,11] width:132 height:40
		button LoadLayout "Load" pos:[37,77] width:72 height:24
		
		on Layouts open do
		(
			tv = trackviews.current.ui
			local ct = tv.LayoutCount()
			local items = #()			
			for i = 1 to ct do
			(
				append items (tv.getLayoutName i)
			)
			layoutList.items = items
		)
		on LoadLayout pressed do
		(
			tv.loadLayout layoutList.selected
		)
	)
	on execute do 
	(
		if trackviews.current != undefined do
		(
			createDialog Layouts parent:trackviews.current.ui.hwnd pos:[100,100]
		)
	)
	on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Save_Layout
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Save Layout" 
            buttontext:"Save Layout..." 
            -- Icon:#("TrackViewTools",0)
(
   
	rollout SaveLayouts "Save Layout" width:162 height:108
	(
		editText LayoutName "" pos:[6,32] width:146 height:24
		label lbl1 "Layout Name" pos:[11,11] width:141 height:18
		button SaveLayout "Save" pos:[41,68] width:75 height:27
		
		on SaveLayout pressed do
		(
			if LayoutName.text != "" then
			(
				trackviews.currenttrackview.ui.saveLayout (LayoutName.text)
			) else (
				MessageBox "You must provide a name for the Layout" title:"No Layout Name"
			)
		)
	)
   on execute do 
   (
   		if trackviews.currenttrackview != undefined do
		(
			createDialog SaveLayouts parent:trackviews.currenttrackview.ui.hwnd pos:[100,100]
		)
   )
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Load_Menu_Bar
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Load Menu Bar" 
            buttontext:"Load Menu Bar..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout LoadMenuBar "Load New Menu Bar" width:248 height:108
	(
		button LoadMenu "Load" pos:[79,68] width:72 height:24
		dropDownList menuList "Menus" pos:[12,17] width:222 height:40
		on LoadMenuBar open do
		(
			tv = trackviews.currenttrackview.ui
			local ct = menuMan.numMenus()
			local items = #()			
			for i = 1 to ct do
			(
				if (menuMan.getMenu i).GetTitle() != "" do
				(
					append items ((menuMan.getMenu i).GetTitle())
				)
			)
			menuList.items = items
		)
		on LoadMenu pressed do
		(
			trackviews.currenttrackview.ui.menuBar = menuList.selected
		)
	)   
	on execute do 
	(
		if trackviews.currenttrackview != undefined do
		(
			createDialog LoadMenuBar parent:trackviews.currenttrackview.ui.hwnd pos:[100,100]
		)
	)
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Load_Controller_Quad_Menu
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Load Controller Quad Menu" 
            buttontext:"Load Controller Quad Menu..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout LoadQuadMenu "Load New Controller Quad Menu" width:248 height:108
	(
		button LoadMenu "Load" pos:[79,68] width:72 height:24
		dropDownList menuList "Menus" pos:[12,17] width:222 height:40
		on LoadQuadMenu open do
		(
			local ct = menuMan.numMenus()
			local items = #()			
			for i = 1 to ct do
			(
				if (menuMan.getMenu i).GetTitle() != "" do
				(
					append items ((menuMan.getMenu i).GetTitle())
				)
			)
			menuList.items = items
		)
		on LoadMenu pressed do
		(
			trackviews.current.ui.controllerQuadMenu = menuList.selected
		)
	)   
	on execute do 
	(
		if trackviews.current != undefined do
		(
			createDialog LoadQuadMenu parent:trackviews.current.ui.hwnd pos:[100,100]
		)
	)
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Load_Key_Quad_Menu
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Load Key Quad Menu" 
            buttontext:"Load Key Quad Menu..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout LoadQuadMenu "Load New Key Quad Menu" width:248 height:108
	(
		button LoadMenu "Load" pos:[79,68] width:72 height:24
		dropDownList menuList "Menus" pos:[12,17] width:222 height:40
		on LoadQuadMenu open do
		(
			local ct = menuMan.numMenus()
			local items = #()			
			for i = 1 to ct do
			(
				if (menuMan.getMenu i).GetTitle() != "" do
				(
					append items ((menuMan.getMenu i).GetTitle())
				)
			)
			menuList.items = items
		)
		on LoadMenu pressed do
		(
			trackviews.current.ui.keyQuadMenu = menuList.selected
		)
	)   
	on execute do 
	(
		if trackviews.current != undefined do
		(
			createDialog LoadQuadMenu parent:trackviews.current.ui.hwnd pos:[100,100]
		)
	)
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Add_Toolbar
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Add Toolbar" 
            buttontext:"Add Toolbar..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout AddToolbar "Add Toolbar" width:162 height:108
	(
		editText ToolbarName "" pos:[6,32] width:146 height:24
		label lbl1 "Toolbar Name" pos:[11,11] width:141 height:18
		button Add "Add" pos:[41,68] width:75 height:27
		
		on Add pressed do
		(
			if ToolbarName.text != "" then
			(
				trackviews.currenttrackview.ui.addToolbar (ToolbarName.text)
			) else (
				MessageBox "You must provide a name for the Layout" title:"No Layout Name"
			)
		)
	)
   on execute do 
   (
   		if trackviews.currenttrackview != undefined do
		(
			createDialog AddToolbar parent:trackviews.currenttrackview.ui.hwnd pos:[100,100]
		)
   )
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Delete_Toolbar
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Delete Toolbar" 
            buttontext:"Delete Toolbar..." 
            -- Icon:#("TrackViewTools",0)
(
	rollout DeleteToolbar "Delete Toolbar" width:248 height:108
	(
		button Delete "Delete" pos:[79,68] width:72 height:24
		dropDownList toolbarList "Toolbars" pos:[12,17] width:222 height:40
		on DeleteToolbar open do
		(
			tv = trackviews.currenttrackview.ui
			local ct = tv.toolbarCount()
			local items = #()			
			for i = 1 to ct do
			(
				append items (tv.getToolbarName i)
			)
			toolbarList.items = items
		)
		on Delete pressed do
		(
			if QueryBox "This will perminently delete the toolbar.\nDo you wish to continue?" beep:false do
			(
				trackviews.currenttrackview.ui.DeleteToolbar toolbarList.selected
			)
		)
	)   
	on execute do 
	(
		if trackviews.current != undefined do
		(
			createDialog DeleteToolbar parent:trackviews.current.ui.hwnd pos:[100,100]
		)
	)
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

/*
-- Provided as an example of how to toggle the display of a specific toolbar
macroScript TV_Show_Hide_Name_Toolbar
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Name Toolbar" 
            buttontext:"Name" 
            -- Icon:#("TrackViewTools",0)
(
   on execute do 
   (
	   	if trackviews.currenttrackview != undefined do
		(
			if trackviews.currenttrackview.ui.isToolbarVisible "Name : Animation Editor" then
				( trackviews.currenttrackview.ui.hideToolbar "Name : Animation Editor" )
			else ( trackviews.currenttrackview.ui.showToolbar "Name : Animation Editor" )
		)
   )
   on isChecked do
   (
	   	if trackviews.current != undefined then
		then (trackviews.currenttrackview.ui.isToolbarVisible "name") 
		else false
	)
)
*/


 macroScript TV_Show_All_Toolbars
 	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show All Toolbars" 
            buttontext:"All" 
            -- Icon:#("TrackViewTools",0)
(
   on execute do 
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.showAllToolbars()
		)
   )
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Hide_All_Toolbars
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Hide All Toolbars" 
            buttontext:"None" 
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.hideAllToolbars()
		)
   )
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Show_Hide_Menu_Bar
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Menu Bar" 
            buttontext:"Menu Bar" 
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.showMenuBar = not trackviews.currenttrackview.ui.showMenuBar
		)
   )
   on isChecked do 
   (
 	   	if trackviews.current != undefined 
		then (trackviews.currenttrackview.ui.showMenuBar)
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Show_Hide_Scroll_Bars
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Scroll Bars" 
            buttontext:"Scroll Bars"
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.current != undefined do
		(
			trackviews.current.ui.showScrollBars = not trackviews.current.ui.showScrollBars
		)
   )
   on isChecked do 
   (
 	   	if trackviews.current != undefined 
		then (trackviews.currenttrackview.ui.showScrollBars)
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Show_Hide_Controller_Window
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Controller Window" 
            buttontext:"Controller Window"
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.showTrackWindow = not trackviews.currenttrackview.ui.showTrackWindow
		)
   )
   on isChecked do 
   (
 	   	if trackviews.current != undefined 
		then (trackviews.currenttrackview.ui.showTrackWindow)
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Show_Hide_Key_Window
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Key Window" 
            buttontext:"Key Window"
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.showKeyWindow = not trackviews.currenttrackview.ui.showKeyWindow
		)
   )
   on isChecked do 
   (
 	   	if trackviews.current != undefined 
		then (trackviews.currenttrackview.ui.showKeyWindow)
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript TV_Show_Hide_Time_Ruler
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Show/Hide Time Ruler" 
            buttontext:"Time Ruler"
            -- Icon:#("TrackViewTools",0)
(
   on execute do
   (
	   	if trackviews.currenttrackview != undefined do
		(
			trackviews.currenttrackview.ui.showTimeRuler = not trackviews.currenttrackview.ui.showTimeRuler
		)
   )
   on isChecked do 
   (
 	   	if trackviews.current != undefined 
		then (trackviews.currenttrackview.ui.showTimeRuler)
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
-- Display and Selection Filter macros
-- ************************************************
MacroScript ManualNavigation
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Manual Navigation" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Manual Navigation" 
(
   	on execute do 
   	(
   		if trackviews.current != undefined do
		(
			trackviews.current.manualNavigation = not trackviews.current.manualNavigation
		)
	)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_Children
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Children" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand Children" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandChildren = not trackviews.current.autoExpandChildren)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandChildren
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_Selected_Only
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Selected Only" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand Selected Only" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandSelectedOnly = not trackviews.current.autoExpandSelectedOnly)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandSelectedOnly
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_Transforms
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Transforms" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand Transforms" 
	--Icon:#("TrackViewTools",23)
(
  	on execute do (trackviews.current.autoExpandTransforms = not trackviews.current.autoExpandTransforms)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandTransforms
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_XYZ
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand XYZ Components" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand XYZ Components" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandXYZ = not trackviews.current.autoExpandXYZ)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandXYZ
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_Objects
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Objects" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand Base Objects" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandObjects = not trackviews.current.autoExpandObjects)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandObjects
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
MacroScript Auto_Expand_Modifiers
	enabledIn:#("max") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Modifiers" 
	Category:"Track View" 
	internalCategory:"Animation Object" 
	Tooltip:"Auto Expand Modifiers" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandModifiers = not trackviews.current.autoExpandModifiers)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandModifiers
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Expand_Materials
	enabledIn:#("max") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Expand Materials" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Expand Materials" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoExpandMaterials = not trackviews.current.autoExpandMaterials)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoExpandMaterials
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Select_Animated
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Select Animated" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Select Animated" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoSelectAnimated = not trackviews.current.autoSelectAnimated)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoSelectAnimated
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Select_Position
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Select Position" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Select Position" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoSelectPosition = not trackviews.current.autoSelectPosition)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoSelectPosition
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Select_Rotation
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Select Rotation" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Select Rotation" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoSelectRotation = not trackviews.current.autoSelectRotation)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoSelectRotation
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Select_Scale
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Select Scale" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Select Scale" 
	--Icon:#("TrackViewTools",23)
(
  	on execute do (trackviews.current.autoSelectScale = not trackviews.current.autoSelectScale)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoSelectScale
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Auto_Select_XYZ
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Auto Select XYZ Components" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Auto Select XYZ Components" 
	--Icon:#("TrackViewTools",23)
(
   	on execute do (trackviews.current.autoSelectXYZ = not trackviews.current.autoSelectXYZ)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoSelectXYZ
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript Auto_Scroll_To_Selected
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Auto Scroll To Selected" 
            buttontext:"Auto Scroll Selected" 
            -- Icon:#("TrackViewTools",0)
(
   	on execute do (trackviews.current.autoScrollToSelected = not trackviews.current.autoScrollToSelected)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoScrollToSelected
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

macroScript Auto_Scroll_To_Root
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
            category:"Track View" 
            internalCategory:"Track View" 
            tooltip:"Auto Scroll To Root" 
            buttontext:"Auto Scroll Root" 
            -- Icon:#("TrackViewTools",0)
(
   	on execute do (trackviews.current.autoScrollToRoot = not trackviews.current.autoScrollToRoot)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.autoScrollToRoot
		else false
	)
	on isEnabled do 
	(
		if trackviews.current != undefined 
		then not trackviews.current.manualNavigation
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

-- R4 Trackview selected method
-- *************************************************
MacroScript TrackView_Selected
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Track View Selected" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"View Selected Curves" 
	Icon:#("TrackViewTools",23)
(
	fn TrackSel = 
	(
		
		TrackView.Open "Selected"
		TrackView.setFilter "Selected" #modifiedObjects #SelectedObjects #curveX #curveY #curveZ #Objects #Hierarchy #Transforms #Position #Rotation #Scale #positionX #positionY #positionZ #rotationX #rotationY #rotationZ #scaleX #scaleY #scaleZ
		TrackView.zoomSelected "Selected"
	)
	
	fn CloseTrackSel =
	(
		for t in 1 to Trackview.NumTrackViews() do
		(
			If Trackview.GetTrackviewName T == "Selected" then
			(
				TrackView.Close "Selected"
 			)
			Else
			(
			)
		)
	)

	On IsVisible return selection.count != 0
	On IsEnabled return selection.count != 0
	On Execute do
	(
		(
			CloseTrackSel ()
			TrackSel ()
			TrackView.zoomSelected Selection[1].name
		)
	)

)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Toggle_Keyable_Icons
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Show Keyable Icons" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Show Keyable Icons" 
	Icon:#("TrackViewTools",107)
(
    on execute do (trackviews.current.ui.showKeyableIcons = not trackviews.current.ui.showKeyableIcons)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.ui.showKeyableIcons
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Toggle_Custom_Icons
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Show Custom Icons" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Show Custom Icons" 
	--Icon:#("TrackViewTools",23)
(
    on execute do (trackviews.current.ui.showCustomIcons = not trackviews.current.ui.showCustomIcons)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.ui.showCustomIcons
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Toggle_Modify_Children
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Modify Child Keys" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Modify Child Keys" 
	Icon:#("TrackViewTools",60)
(
    on execute do (trackviews.current.modifyChildren = not trackviews.current.modifyChildren)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.modifyChildren
		else false
	)
	on isVisible do 
	(
		if trackviews.current != undefined 
		then trackviews.current.editMode != #editFCurves
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Use_SoftSelect
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Use Soft Select" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Use Soft Select" 
(
	on execute do 
	(
		if trackviews.current != undefined do
		( 
			trackviews.current.useSoftSelect = not trackviews.current.useSoftSelect
		)
	)
	on isChecked do 
	(
		if trackviews.current != undefined 
		then trackviews.current.useSoftSelect
		else false
	)
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript SoftSelect_Settings
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Soft Select Settings..." 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Soft Select Settings" 
(
	on execute do 
	(
		tv = trackviews.current
		if tv != undefined do
		(
			tv.launchUtility "Soft Selection Settings Manager"
		)
	)
	on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************

MacroScript Maximize_Trackbar
	enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"Close" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Toggle Trackbar" 
	Icon:#("TrackBar",1)
(
   on execute do with redraw off
   (
	   if timeslider.isvisible() == true then 
	   	(
			if (trackviews.open "Trackbar" layoutName:"Trackbar Layout" dock:#bottom height:170) do
			   (
		  	   maxIni = (GetMAXIniFile())--pfb removed hardcoded access to 3dsmax.ini		
			   iniState = getFileAttribute maxIni #readOnly
			   setFileAttribute maxIni #readOnly true
			   maxOps.trackbar.visible = false
			   timeSlider.SetVisible false
			   setFileAttribute maxIni #readOnly iniState
			   )
		)
		Else 
		(
 		   trackviews.close "Trackbar"
		   maxIni = (GetMAXIniFile())--pfb : removed hardcoded access to 3dsmax.ini
		   iniState = getFileAttribute maxIni #readOnly
		   setFileAttribute maxIni #readOnly true
		   maxOps.trackbar.visible = true
		   timeSlider.SetVisible true
		   setFileAttribute maxIni #readOnly iniState
  		)
   )
   on isChecked return false
)--end macro

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************


/*
/********************************************************************************
Macro Script to collapse the current trackview selection to keyframe controllers.
This will turn any procedural controller into a keyframed controller. 
Options:
Start Frame
End Frame
Samples (displayed in frames)
New Controller type
Add to new layer (keeps the original controller stored on a layer with a weight of 0)
Written by Discreet Staff (02/25/02)

Revision History:
		11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products



Modify at your own risk
-- ********************************************************************************
*/
macroScript collapseController
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
category:"Track View"
internalCategory:"Track View" 
toolTip:"Collapse Controller..."
buttonText:"Collapse Controller..."
(
	on isEnabled do
	(
		local res = false
 		if trackviews.current != undefined do 
		(
			local parentTracks = #()
			local subNums = #()
			for i in 1 to trackviews.current.numSelTracks() do
			(
				local p = (trackviews.current.getParentOfSelected i)
				if p != undefined do 
				(
					append parentTracks p
					append subNums (trackviews.current.getSelectedSubNum i)
				)
			)
			for i in 1 to parentTracks.count while not res do
			(
				local tmpController
				if parentTracks[i][subNums[i]] != undefined do 
				(
					tmpController = parentTracks[i][subNums[i]].controller
				)
				if (isController tmpController) == true do
				(
					if (classof tmpController != Biped_SubAnim and classof parentTracks[i] != Biped_SubAnim) do res = true
				)
			)
		)
		res
	)
	
	on execute do
	(
		global rltCollapseControllerSetup, collapseController2Controller, collapseController2EulerController

		fn collapseController2EulerController ControllerFrom ControllerTo Start End Samples =
		(
			-- function handles everything in ticks, to ensure flexibility and precision
			local starttick = start*ticksPerFrame, endtick = end*ticksPerFrame, sampletick = samples*ticksPerFrame
			for i in starttick to endtick by sampletick do
			(
				t = ((i/ticksPerFrame) as time)
				tmpXKey = addNewKey controllerTo[1].controller t
				tmpXKey.value = at time t (QuatToEuler controllerFrom.value).x
				tmpYKey = addNewKey controllerTo[2].controller t
				tmpYKey.value = at time t (QuatToEuler controllerFrom.value).y
				tmpZKey = addNewKey controllerTo[3].controller t
				tmpZKey.value = at time t (QuatToEuler controllerFrom.value).z
				
			) -- end for
			controllerTo
		) -- end fn collapseController2EulerController
		
		fn collapseController2Controller ControllerFrom ControllerTo Start End Samples =
		(
			if (Classof controllerTo) == Euler_XYZ do
			(
				return (collapseController2EulerController ControllerFrom ControllerTo Start End Samples)
			) -- end if
			-- function handles everything in ticks, to ensure flexibility and precision
			local starttick = start*ticksPerFrame, endtick = end*ticksPerFrame, sampletick = samples*ticksPerFrame
			for i in starttick to endtick by sampletick do
			(
				tmpKey = addNewKey controllerTo ((i/ticksPerFrame) as time)
				tmpKey.value = at time ((i/ticksPerFrame) as time) controllerFrom.value
				
			) -- end for
			controllerTo
		) -- end fn collapseController2Controller
		
		rollout rltCollapseControllerSetup "Collapse Controller" width:162 height:171
		(
		
			spinner spnStart "Start Frame" pos:[28,7] width:111 height:16 range:[-100000,100000,0] fieldwidth:45
			spinner spnEnd "End Frame" pos:[31,28] width:108 height:16 range:[-100000,100000,100] fieldwidth:45
			spinner spnSamples "Samples" pos:[42,49] width:97 height:16 range:[0,1000,1] fieldwidth:45
			label lbSampleUnits "f" pos:[146,50] width:3 height:13
			radiobuttons rbType "Collapse to:" pos:[14,68] width:138 height:46 labels:#("Bezier or Euler Controller", "Linear or TCB Controller") columns:1
			checkbox newLayer "Add to New Layer" pos:[15,119] width:135 height:15
			button btnOK "OK" pos:[15,143] width:65 height:21 across:2
			button btnCancel "Cancel" pos:[83,143] width:65 height:21
				
			on rltCollapseControllerSetup open do
			(
				controllerRange = animationRange
				
				if trackviews.current != undefined AND trackviews.current.numSelTracks() == 1 do
				(
					local tmpController = trackviews.current.getSelected 1
					if (isController tmpController) == true do
					(
						controllerRange = getTimeRange tmpController
						-- There's a bug in PositionXYZ. It does not return the ranges from the children controllers, so it's very tough to collapse them...
						if (controllerRange.start as integer)/ticksPerFrame == -13421772 do controllerRange = animationRange
					)
				)
				
				spnStart.value = controllerRange.start
				spnEnd.value = controllerRange.end
				
			)
			on btnOK pressed do
			(
				if spnSamples.value == 0.0 do 
				(
					destroyDialog rltCollapseControllerSetup
					return()
				)
					
				local parentTracks = #()
				local subNums = #()
				for i in 1 to trackviews.current.numSelTracks() do
				(
					append parentTracks (trackviews.current.getParentOfSelected i)
					append subNums (trackviews.current.getSelectedSubNum i)
				)
				
				for i in 1 to parentTracks.count do
				(
					if parentTracks[i] != undefined and classof parentTracks[i] != Biped_SubAnim do
					(	
						local oldController = parentTracks[i][subNums[i]].controller
						-- superclassof Biped_SubAnim incorrectly reports FloatController, exclude
						if (classof oldController == Biped_SubAnim) do oldController = undefined 
						local listController = undefined
						local newController = undefined
						case superClassof oldController of
						(
							PositionController:
							(
								case rbType.state of
								(
									1:	newController = Bezier_Position()
									2:	newController = Linear_Position()
								)
								if newLayer.checked == true and (classof parentTracks[i]) != Position_List do
									( listController = Position_List() )
							)
							FloatController:
							(
								case rbType.state of
								(
									1:	newController = Bezier_Float()
									2:	newController = Linear_Float()
								)
								if newLayer.checked == true and (classof parentTracks[i]) != Float_List do
									( listController = Float_List() )
							)
							Point3Controller:
							(
								case rbType.state of
								(
									1:	newController = Bezier_Point3()
									2:	newController = Bezier_Point3()
								)
								if newLayer.checked == true and (classof parentTracks[i]) != Point3_List do
									( listController = Point3_List() )
							)
							RotationController:
							(
								case rbType.state of
								(
									1:	newController = Euler_XYZ()
									2:	newController = TCB_Rotation()
								)
								if newLayer.checked == true and (classof parentTracks[i]) != Rotation_List do
									( listController = Rotation_List() )
							)
							ScaleController:
							(
								case rbType.state of
								(
									1:	newController = Bezier_Scale()
									2:	newController = Linear_Scale()
								)
								if newLayer.checked == true and (classof parentTracks[i]) != Scale_List do
									( listController = Scale_List() )
							)
						) -- end superclass case
						if newController != undefined do try
						(
							Undo "Collapse Controller" On 
							(
								if newLayer.checked == true then 
								(						
									local index = 0
									if listController == undefined then 
									(
										listController = parentTracks[i]
										index = subNums[i]
									)
									else 
									(
										parentTracks[i][subNums[i]].controller = listController
										index = listController.count
									)
										
									listController.weights[index].value = 0.0
									listController.setName index ((listController.getName index) + " (collapsed)")
									listController[listController.count+1].controller = newController
									listController.setActive listController.count
								)
								else 
								(
									parentTracks[i][subNums[i]].controller = newController
								)
								newController = collapseController2Controller oldController newController spnStart.value spnEnd.value spnSamples.value
							)
						)
						catch(format "failure replacing subanim % of %: controller: %\n" i parentTracks[i] oldController )
					)
				)
				destroyDialog rltCollapseControllerSetup
			)
			on btnCancel pressed do
				destroyDialog rltCollapseControllerSetup
		)
		
		if trackviews.current != undefined then
		(
			createDialog rltCollapseControllerSetup modal:false parent:trackviews.current.ui.hwnd
		)
		else
		(
			createDialog rltCollapseControllerSetup modal:false
		)
			
	) -- end Execute

) -- end Macro




/*
/********************************************************************************
Macro Script to enable an animation layer over the trackview selection.
Written by Michael Zyracki (03/15/06)




Modify at your own risk
-- ********************************************************************************
*/
macroScript enableAnimLayer
enabledIn:#("max") --mz: assuming anim layers are just in max
category:"Track View"
internalCategory:"Track View" 
toolTip:"Enable Anim Layer..."
buttonText:"Enable Anim Layer..."
(
	on isEnabled do
	(
		local res = false
 		if trackviews.current != undefined do 
		(
			local parentTracks = #()
			local subNums = #()
			for i in 1 to trackviews.current.numSelTracks() do
			(
				local p = (trackviews.current.getParentOfSelected i)
				if p != undefined do 
				(
					append parentTracks p
					append subNums (trackviews.current.getSelectedSubNum i)
				)
			)
			for i in 1 to parentTracks.count while not res do
			(

				if(AnimLayerManager.canEnableLayer parentTracks[i][subNums[i]] parentTracks[i] subNums[i]) == true do res = true
			)
		)
		res
	)
	
	on execute do
	(
		if trackviews.current != undefined do 
		(
			for i in 1 to trackviews.current.numSelTracks() do
			(
				local p = (trackviews.current.getParentOfSelected i)
				local sub = (trackviews.current.getSelectedSubNum i)
				local ani = p[sub]
				AnimLayerManager.enableLayer ani p sub

			)
			
		)
			
	) -- end Execute

) -- end Macro




/********************************************************************************
Macro Script to save animation from the trackview selection.
Written by Michael Zyracki (10/25/06)

Modify at your own risk
-- ********************************************************************************
*/

macroScript saveAnimationTrackView
enabledIn:#("max") --mz: assuming saving animation is just in max
category:"Track View"
internalCategory:"Track View" 
toolTip:"Save Animation..."
buttonText:"Save Animation..."
(
	on isEnabled do
	(
		(trackviews.current != undefined and (trackviews.current.numSelTracks() > 0))
	)
	
	on execute do
	(
		if trackviews.current != undefined do 
		(
			local anims = #()
			local parentTracks = #()
			local subNums = #()
			for i in 1 to trackviews.current.numSelTracks() do
			(
				local p = (trackviews.current.getParentOfSelected i)
				if p != undefined do 
				(
					append anims (trackviews.current.getSelected i)
					append parentTracks p
					append subNums (trackviews.current.getSelectedSubNum i)
				)
			)
			loadSaveAnimation.saveAnimationDlgFromAnims anims parentTracks subNums
		)
			
	) -- end Execute

) -- end Macro



/********************************************************************************
Macro Script to load animation into the trackview selection.
Written by Michael Zyracki (10/25/06)

Modify at your own risk
-- ********************************************************************************
*/

macroScript loadAnimationTrackView
enabledIn:#("max") --mz: assuming loading animation is just in max
category:"Track View"
internalCategory:"Track View" 
toolTip:"Load Animation..."
buttonText:"Load Animation..."
(
	on isEnabled do
	(
		(trackviews.current != undefined and (trackviews.current.numSelTracks() > 0))
	)
	
	on execute do
	(
	
		if trackviews.current != undefined do 
		(
			local anims = #()
			local parentTracks = #()
			local subNums = #()
			for i in 1 to trackviews.current.numSelTracks() do
			(
				local p = (trackviews.current.getParentOfSelected i)
				if p != undefined do 
				(
					append anims (trackviews.current.getSelected i)
					append parentTracks p
					append subNums (trackviews.current.getSelectedSubNum i)
				)
			)
			loadSaveAnimation.loadAnimationDlgFromAnims anims parentTracks subNums
		)
			
	) -- end Execute

) -- end Macro

