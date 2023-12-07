/*

Schematic View MacroScript File

Created:  		April 1 2003

Author :  Michael Russo
Version:  3ds max 6

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 

*/

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Localization Notes
--
-- /* "Localize On" */ states an area where locization should begin
-- /* "Localize Off" */ states an area where locization should end
--
-- *** Localization Note *** states that the next line has special localization instructions for the next line.
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

MacroScript SVAlignLeft
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Left"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Left" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iLeft = pt.x

				-- Loop thru and find left-most node
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.x < iLeft then iLeft = pt.x
				)

				-- Set selection list to left-most value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.x = iLeft
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVAlignRight
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Right"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Right" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iRight = pt.x

				-- Loop thru and find right-most node
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.x > iRight then iRight = pt.x
				)

				-- Set selection list to right-most value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.x = iRight
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVAlignTop
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Top"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Top" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iTop = pt.y

				-- Loop thru and find top-most node
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.y < iTop then iTop = pt.y
				)

				-- Set selection list to top-most value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.y = iTop
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVAlignBottom
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Bottom"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Bottom" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iBottom = pt.y

				-- Loop thru and find bottom-most node
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.y > iBottom then iBottom = pt.y
				)

				-- Set selection list to bottom-most value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.y = iBottom
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVAlignVCenter
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Vertical Center"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Vertical Center" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (
			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iTop = pt.y
				local iBottom = pt.y

				-- Loop thru and find top and bottom-most values
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.y > iBottom then iBottom = pt.y
					if pt.y < iTop then iTop = pt.y
				)

				-- Set selection list to centered value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.y = (iTop + iBottom) / 2
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVAlignHCenter
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Align Horizontal Center"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Align Horizontal Center" 
(
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 1 do (

				-- Get first entry in selection list
				local pt = sv.getSVNodePos selList[1]
				local iLeft = pt.x
				local iRight = pt.x

				-- Loop thru and find left and right-most values
				for i in selList do (
					pt = sv.getSVNodePos i
					if pt.x > iRight then iRight = pt.x
					if pt.x < iLeft then iLeft = pt.x
				)

				-- Set selection list to centered value
				for i in selList do (
					pt = sv.getSVNodePos i
					pt.x = (iLeft + iRight) / 2
					sv.setSVNodePos i sv.moveChildren pt
				)
			)

			-- End SV edit session
			sv.endEdit()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.alwaysarrange != true
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVParamWire
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Wire Parameters"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Wire Parameters" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do sv.setMode #PARAMWIRE
	)
)


MacroScript SVAlwaysArrange
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Always Arrange"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Always Arrange" 
(
	on execute do
	(
		if( schematicviews.current!=undefined ) do
			schematicviews.current.alwaysarrange = not schematicviews.current.alwaysarrange
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else not schematicviews.current.TestIncludeFilter #selectedOnly
	)

	on isVisible do return (schematicViews.current!=undefined)
	on isChecked do
	(
		if( schematicviews.current==undefined ) then false
		else schematicviews.current.alwaysarrange
	)
)

MacroScript SVSyncSelection
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Sync Selection"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Sync Selection" 
(
	on execute do
	(
		if( schematicviews.current!=undefined ) do
		(
			schematicviews.current.syncSelection = not schematicviews.current.syncSelection
		)
	)

	on isVisible do return (schematicViews.current!=undefined)
	on isChecked do
	(
		if( schematicviews.current==undefined ) then false
		else schematicviews.current.syncSelection
	)
)


MacroScript SVUnShrinkAll
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"UnShrink All"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"UnShrink All" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current!=undefined ) do (
			schematicviews.current.unShrinkAll()
			schematicviews.current.updateView false
		)
	)
)


MacroScript SVShrinkSelected
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Shrink Selected"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Shrink Selected" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()
			
			sv.shrink()

			-- End SV edit session
			sv.endEdit()
			
			sv.updateView false
		)
	)
)

MacroScript SVUnShrinkSelected
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"UnShrink Selected"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"UnShrink Selected" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			sv.unshrink()

			-- End SV edit session
			sv.endEdit()
			
			sv.updateView false
		)
	)
)

MacroScript SVArrangeSelected
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Arrange Selected"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Arrange Selected" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local selList = sv.getSelectedSVNodes()

			if selList.count > 0 do (
				sv.arrangeSVNode()
			)

			-- End SV edit session
			sv.endEdit()
			
			sv.updateView false
		)
	)
)

MacroScript SVAssignController
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Assign Controller"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Assign Controller" 
(
	on execute do
	(
		if( schematicviews.current!=undefined ) then
		(
			schematicviews.current.ShowAssignControllerDialog()
		)
	)

	on isEnabled do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.canAssignController()
	)
	on isVisible do return (schematicViews.current!=undefined)
)

MacroScript SVDeleteSelected
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Selected"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Delete Selected" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.DeleteSelected()
	)
)

MacroScript SVRefresh
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Refresh View"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Refresh View" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.updateView true
	)
)

MacroScript SVShowPreferenceDialog
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Preferences..."
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Preferences..." 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.ShowPreferencesDialog()
	)
)

MacroScript SVShowDisplayFloater
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Display Floater"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Display Floater" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.ShowDisplayFloater true
	)
)

MacroScript SVShowRelDialogSelected
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Relationship Viewer Selected"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Relationship Viewer Selected" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.ShowRelationshipDialog false
	)
)

MacroScript SVShowRelDialogAll
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"Relationship Viewer All"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"Relationship Viewer All" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		if( schematicviews.current==undefined ) then true
		else schematicviews.current.ShowRelationshipDialog true
	)
)

MacroScript SVShowAnimatedControllers
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
ButtonText:"List View - Animated Controllers"
Category:"Schematic View" 
internalCategory:"Schematic View" 
Tooltip:"List View - Animated Controllers" 
(
	on isVisible do return (schematicViews.current!=undefined)
	on execute do
	(
		-- Get current schematic view interface
		local sv = schematicViews.current

		if sv != undefined do (

			-- Begin SV edit session
			sv.beginEdit()

			-- Get list of selected SV Nodes
			local numNodes = sv.getNumSVNodes()

			local animCtrls = #()

			for i = 0 to numNodes-1 do
			(
				if sv.testSVNodeState i #animated do append animCtrls i				
			)

			sv.ShowListViewdialog animCtrls title:"Animated Controllers" id:50

			-- End SV edit session
			sv.endEdit()
		)
	)
)
