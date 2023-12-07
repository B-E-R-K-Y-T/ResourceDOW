/*

Isolate Selection Script File
Created:  		July 31 2001
Author:   Pete Samson


Isolate Selection Functions
This script creates functions for Isolating selected geometery.
***********************************************************************************************
MODIFY THIS AT YOUR OWN RISK

Revision History:

12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

August 17 2003; Pierre-Felix Breton
	Bug fixes

August 05 2003; Pierre-Felix Breton
	Bug fixes

June 19 2003, Pierre-Felix Breton
	Fixes to respect the new hide/freeze and bylayer logic

June 12 2003, Pierre-Felix Breton
       3ds Max 6 integration

Feb 10 2003, Pierre-Felix Breton
	tool was failing when selection is locked

Jan 30th 2003, Pierre-Felix Breton
	added a security check for frozen selection (selection lock) preventing the isolate to to be succesfull

Jan 7th 2003, Pierre-Felix Breton
	changed "Isolate Selection" for "Isolate Selected"

Dec 24 2002,Pierre-Felix Breton
	added "..." after the macro/menu labels names		

Nov 25 2002 - Pierre-Felix Breton
	Uncommented APPID code for specific VizRender functionnality

Nov 1 2002 - Alexander Esppeschit Bicalho
	Added support for Styles Hierarchy, Blocks still have issues

October 10th 2002 - LM
	minor cleanup, added code that never made it from MAX to VIZ versions


Oct 10 2002 - Alexander Esppeschit Bicalho
	Performance Improvements and benchmark

July 17th 2002 - Pierre-Felix Breton 
	integrated changes from MAX 5
	disabled the "zoom extents" command occuring when the isolation is invoked.

*/

-- LAM - following line will only be run when this file is evaluated since it is outside the macroScript. This forces the dialog to be destroyed.
-- LAM - in the following line, Iso2Roll.scrollPos will be 'undefined' if rollout not in dialog
try
(
	global Iso2Roll;
	if (iskindof Iso2Roll RolloutClass and Iso2Roll.scrollPos != undefined) do 
	(
		destroyDialog Iso2Roll
	)
)
catch()  

-- Further tweaks and cleanups, 010813  --prs.

-- Added uses of SetIniSetting() and GetIniSetting(), 010828  --prs.

MacroScript Isolate_Selection
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
Category:"Tools" 
internalCategory:"Tools" 
ToolTip:"Isolate Selection" 
buttontext:"Isolate Selection" 
Icon:#("ViewPortNavigationControls",7) 
SilentErrors:(Debug == undefined or Debug != True)
(

	-- *****************************************************************************************
	-- Define globals that stick with the file. Declare as persistent in the execute handler so they are made persistent
	-- whenever the macroscript is executed. Otherwise they are persistent only up to a file load or reset.
	-- *****************************************************************************************
	Global Iso2Lations
	Global Iso2Hidden, Iso2Camera
	Global Iso2ObjArr, Iso2View, Iso2HidFlags 
	
	-- *****************************************************************************************
	-- Define non-persistent globals 
	-- *****************************************************************************************
	Global Iso2Roll, Iso2ObjDel  -- LAM - removed Iso2Floater, using createDialog instead

--global debugwindow

	--  all the functions are inside the rollout. This allows us to get to the functions from outside the macroScript 
	--  (in particular the post-load callback). Note that since the functions are inside the rollout, to access them from outside they need
	--  to be specified as properties of the rollout (i.e., Iso2Roll.UpdateSelection())
	/* "Localization on" */  
	
	local isADTHead, isBlockHead
	-- xavier robitaille | 2003.03.02 | isolate selected dialog now uses its own ini file.
	local iniFile = ((getDir #plugcfg) + "\\isolateSel.ini")
	
	fn isADTHead n = 
	(
		local result = false
		if (iskindof n node) then
		(
			adtStyleIfc = styleMgr.IsInstance n
			if (atStyleIfc != undefined )then 
			(
				result = (adtStyleIfc.GetCompositeStyle() == adtStyleIfc)
			)
		)
		result
	)
	
	fn isBlockHead n = 
	(
		local result = false
		if (iskindof n node) then 
		(
			blkIfc = blockMgr.IsInstance n
			if (blkIfc != undefined) then -- n is not a block component
			(
				result = (blkIfc.numComponents > 0)
			)
		)
		result
	)

	
	rollout Iso2Roll "Warning: Isolated Selection" width:200 height:47
	(
		-- *****************************************************************************************
		-- declare functions as locals. Allows forward referencing
		-- *****************************************************************************************
		
		Local HideXRefs, UpdateSelection, RestoreView, Iso2late, UNIso2late, OldUnIsolate
		
		Local xRefHiddenState

		fn HideXRefs hide:true = 
		(
			local numxrefs = xrefs.getXRefFileCount()
			if (hide) then
			(
				xRefHiddenState = #()
				xRefHiddenState.Count = numxrefs 
			)
		 	for k = 1 to numxrefs do
			(
				local y = xrefs.getXRefFile k
				if (hide) then 
				(
					xRefHiddenState[k] = y.hidden					
				)
				if (hide) then 
				(
					y.hidden = hide 
				)
				else if (xRefHiddenState.Count != numxrefs) then 
				(
					y.hidden = hide 
				)
				else 
				(
					y.hidden = xRefHiddenState[k]
				)
	        )
		)	
	
		fn UpdateSelection note:false =
		(
--if Iso2Hidden != undefined then format "entering UpdateSelection, % items to unhide\n" Iso2Hidden.count to:debugwindow
--format "  and Iso2lations =  %, note = %\n" Iso2lations note to:debugwindow

			-- disable scene redraw to prevent a bunch of flashing.
			with redraw off
			(
				try 
				(	
					if classof iso2Hidden != Array do iso2Hidden = #()
					
-- **IMPORTANT** -- 
					tmpSuperSel = selection as array
					if ((productAPPID == #vizR) or (productAPPID == #max)) do -- pfb 12 juin 2003: VIZR and MAX functionality
					(
						count = 1
						while count <= tmpSuperSel.count do
						(
							if isADTHead tmpSuperSel[count] or isBlockHead tmpSuperSel[count] do join tmpSuperSel tmpSuperSel[count].children
							count += 1
						)
					)

					select tmpSuperSel
					local tmpSelection = tmpSuperSel  -- AB: this has what's currently selected, and to be isolated
					if (isSelectionFrozen() == true)do thawSelection() -- pfb: if the selection is locked, the whole thing fails ....

			        --gets the invert of the selection
					local tmpInvSelection = for obj in objects where (not (obj.ishiddenInVpt or obj.isSelected)) collect obj --pfbreton, 5 august 2003

					join iso2Hidden tmpInvSelection -- this adds the InvSelection to the list of hidden object	

					/* -- IMPORTANT --- */
					if productAppID == #vizR do --*/
					(
						objects.displayByLayer = true
					)
	
					max hide inv -- AB

					Iso2lations = true
				)
				catch()
			)
			if productAPPID != #vizR do Max tool zoomextents -- pfb July 17th 2002, disabled the zoom extents commands
		)
	
		fn RestoreView =
		(
			Try 
			(
				If (Viewport.GetType () == #view_persp_user) then
				(
					If Iso2Camera != undefined then
					 	max vpt camera 
					Else
					( 
						-- AB made max tool zoom extents
						-- pfb July 17th 2002, disabled the zoom extents commands
						if productAPPID != #vizR do 
						(
							Max tool zoomextents 
							Viewport.SetTM Iso2View
						)
					)
				)

			)
			Catch ()
		) --end fn Restore View
	
		fn Iso2late =
		(
--if debugwindow == undefined then debugwindow = newScript()
--format "Entering Iso2late, % objects\n" selection.count to:debugwindow

			-- *********************************************************************************
			-- Set the current object as the isolated object
			-- *********************************************************************************
			
			Iso2ObjArr = selection as array
			
			-- **IMPORTANT** -- 
			if ((productAPPID == #vizR) or (productAPPID == #max)) do -- pfb 12 juin 2003: VIZR and MAX functionality
			(
				count = 1
				while count <= Iso2ObjArr.count do
				(
					if isADTHead Iso2ObjArr[count] or isBlockHead Iso2ObjArr[count] do join Iso2ObjArr Iso2ObjArr[count].children
					count += 1
				)
			)-- end if productapp id
			
			-- *********************************************************************************
			--	Sets up a handler in case the isolated object is deleted. This function restores
			--	the scene
			-- *********************************************************************************
			
--format "Creating delete handler, there are % items; objects: %\n" Iso2ObjArr.count Iso2ObjArr to:debugwindow
			if Iso2ObjArr.count != 0 do		-- protection if no objects are selected, otherwise would get runtime error in next statement
			(	
				Iso2ObjDel = When Iso2ObjArr deleted obj do
				(
--format "Entering delete handler, there are % items; deleted object: %\n" Iso2ObjArr.count obj to:debugwindow
		
					local index = finditem Iso2ObjArr obj
					if index > 0 then
						deleteitem Iso2ObjArr index
		
--format "  and now there are % items\n" Iso2ObjArr.count to:debugwindow
		
					if Iso2ObjArr.count < 1 then
					(
						Iso2lations = false
						destroyDialog Iso2Roll
						
						try(UNhide Iso2Hidden dolayer:true) catch()
												-- *****************************************************************************
						-- Restore the saved viewport state
						-- *****************************************************************************
						
						RestoreView()
					) 
				) 
			)
	
			if Iso2lations != true then
			(
				HideXRefs()
				
				-- *********************************************************************************
				-- Makes sure you are not in a subobject level
				-- *********************************************************************************
		
				sublevel = SubObjectLevel
				SubObjectLevel = 0
				
				-- *********************************************************************************
				-- Save Camera view
				-- *********************************************************************************
				Iso2Camera = GetActiveCamera ()
		
				If (Viewport.GetType () == #view_persp_user) then (Iso2View = Viewport.GetTM ()) 
		
			-- *************************************************************************************
			-- Save Which Objects Got hidden		
			-- *************************************************************************************
				 
				UpdateSelection note:true
				if sublevel != undefined do try(SubObjectLevel = sublevel)catch()
			)
			else
			(
				UpdateSelection note:false
			)
					
		
			-- LAM - localize on?
			If (viewport.GetType == #view_camera) then (Max vpt persp user) 
			
			
			-- *************************************************************************************
			-- Builds a script into the file, so if the file is saved while isolated, when the file is re-opened an attempt will be 
			-- made to open the rollout. If the rollout cannot be opened, a messagebox will appear on file open.
			-- *************************************************************************************
			
			-- LAM - what should the behavior be if the rollout cannot be opened on file load? What it user doesn't have isolate macroscript installed?
			-- instead of messagebox, do a recovery? If so, following callback script would be used. Doesn't handle hidden XRefs, would need to build 
			-- HideXRefs function into this script string (if rollout isn't defined, then HideXRefs isn't defined either). 
			-- Can't put XRefScenes in a persistent global.
--			local callbackScript = "global Iso2Roll; if iskindof Iso2Roll RolloutClass do (try (select Iso2ObjArr);catch (Max select all);createDialog Iso2Roll) else (Try (Unhide Iso2Hidden;Iso2lations=false);Catch())"
			
			/* "Localization on" Loc: The quoted MAXScript shouldn't be localized, the message box text and title should */
		
			local callbackScript = "global Iso2Roll; if iskindof Iso2Roll RolloutClass then (try (select Iso2ObjArr);catch (Max select all);createDialog Iso2Roll) else MessageBox \"One or more objects are currently Isolated\" title:\"Isolate Selection\"" 
			callbacks.addScript #FilePostOpen callbackScript ID:#FJDIso2 Persistent:True -- LAM - changed ID name to prevent conflict with Iso1 script
			displayTempPrompt "Isolated Selection" 3000	-- moved from listener window 010822  --prs.
			
			/* "Localization off" */  
		)
	
		fn UNIso2late = 
		(
--format "Entering UnIso2late\n" to:debugwindow
	
			sublevel = SubObjectLevel
			Try(SubObjectLevel = 0)Catch()
			Try(CallBacks.RemoveScripts ID:#FJDIso2) Catch () -- LAM changed name to prevent conflict with Iso script
					
--format "now in UnIso2late, sublevel = %\n" sublevel to:debugwindow
	
			hideXRefs hide:false  -- LAM - passing boolean instead of integer flag
			
			Iso2lations = false
	
--format "in UnIso2late, Iso2ObjArr = %\n" Iso2ObjArr to:debugwindow
--format "in UnIso2late, Iso2Hidden = %\n" Iso2Hidden to:debugwindow

			-- *****************************************************************************************
			-- Check for other Isolated Objects
			-- *****************************************************************************************
		
			If Iso2ObjArr == undefined then 
			(
				/* "Localization on" */ 
		 
				Format "%\n" "Object has been Hidden or Removed Cannot UN-ISOLATE"
			
				/* "Localization off" */  
			)
			Else
			(
		
				-- *************************************************************************************
				-- Put everything back
				-- *************************************************************************************
							
--format "in UnIso2late, to unhide % items\n" Iso2Hidden.count to:debugwindow		

		
				Iso2Hidden = for obj in Iso2Hidden where isValidNode obj collect obj
				Try (Unhide Iso2Hidden dolayer:true)Catch ()

			
					/* **IMPORTANT** -- */
					if productAPPID == #vizR do
					(
						Try
						(
							for obj in Iso2Hidden where isValidNode obj do
							obj.displayByLayer = true
						) Catch ()
					)--end if productapp id
			
				Iso2HidFlags = #()
				
				RestoreView()

				if sublevel == undefined or sublevel == 0 then
				(
					-- AB: Select Iso2ObjArr
				) else (
					SubObjectLevel = sublevel
				)
				
				/* "Localization on" */  
				
				displayTempPrompt "Objects Un-isolated" 3000 -- moved from listener 010822  --prs.
				
				/* "Localization off" */  
				
				Try (DeleteChangeHandler Iso2ObjDel) Catch ()
				
				Iso2Hidden = Iso2ObjArr = #() -- no need to keep entries in arrays
			)
		)

		-- LAM - stripped down UNIsolate from R4.2 Isolate script.
		-- Loc: Note that the names of the functions to be executed are not localized.
		fn OldUnIsolate = 
		(	
--format "in OldUnIsolate\n" to:debugwindow
			-- the persistent globals from the R4.2 Isolate script. Using the execute method to get the value of the persistent globals so that we don't
			-- need to declare all of these as globals. Kill the variables as persistents.
			local IsoLations = execute "( IsoLations )"; persistents.remove #IsoLations 
			local ISORoll = execute "( ISORoll )"; persistents.remove #ISORoll 
			local UnIsolate = execute "( UnIsolate )"; persistents.remove #UnIsolate 
			local IsoLate = execute "( IsoLate )"; persistents.remove #IsoLate 
			local IsoFloater = execute "( IsoFloater )"; persistents.remove #IsoFloater 
			local IsoHidden = execute "( IsoHidden )"; persistents.remove #IsoHidden 
			local IsoCamera = execute "( IsoCamera )"; persistents.remove #IsoCamera 
			local IOBJDel = execute "( IOBJDel )"; persistents.remove #IOBJDel 
			local IObj = execute "( IObj )"; persistents.remove #IObj 
			local IsoFrame = execute "( IsoFrame )"; persistents.remove #IsoFrame 
			local IsoAnimStart = execute "( IsoAnimStart )"; persistents.remove #IsoAnimStart 
			local IsoAnimEnd = execute "( IsoAnimEnd )"; persistents.remove #IsoAnimEnd 
			local IsoCam = execute "( IsoCam )"; persistents.remove #IsoCam 
			local IObjPosX = execute "( IObjPosX )"; persistents.remove #IObjPosX 
			local IObjPosY = execute "( IObjPosY )"; persistents.remove #IObjPosY 
			local IObjPosZ = execute "( IObjPosZ )"; persistents.remove #IObjPosZ 
			local IObjPivX = execute "( IObjPivX )"; persistents.remove #IObjPivX 
			local IObjPivY = execute "( IObjPivY )"; persistents.remove #IObjPivY 
			local IObjPivZ = execute "( IObjPivZ )"; persistents.remove #IObjPivZ 
			local IsoView = execute "( IsoView )"; persistents.remove #IsoView 
			local IsoViewTM = execute "( IsoViewTM )"; persistents.remove #IsoViewTM 
			local IObjRotX = execute "( IObjRotX )"; persistents.remove #IObjRotX 
			local IObjRotY = execute "( IObjRotY )"; persistents.remove #IObjRotY 
			local IObjRotZ = execute "( IObjRotZ )"; persistents.remove #IObjRotZ 

			Try (SubObjectLevel = 0) Catch ()
			Try (CallBacks.RemoveScripts ID:#FJDIso) Catch ()
						
			hideXRefs hide:false
			
			If IOBJ != undefined then 
			(
				At time IsoFrame 
				(	
					Try (Hide IsoHidden) Catch ()
					IOBJ.pos.x = 0
					IOBJ.pos.y = 0
					IOBJ.pos.z = 0
					IOBJ.pivot = [0,0,0]
							
					Max Select All
					Move Selection [IOBJPosX,IOBJPosY,IOBJPosZ]	
					Select IOBJ
								
							
					IOBJ.pos.x = IOBJPosX
					IOBJ.pos.y = IOBJPosY
					IOBJ.pos.z = IOBJPosZ
					IOBJ.pivot.x = IOBJPivX
					IOBJ.pivot.y = IOBJPivY
					IOBJ.pivot.z = IOBJPivZ
								
						
					Try (Unhide IsoHidden dolayer:true)
					Catch ()
					
					Try 
					(	If (Viewport.GetType () == #view_persp_user) then 
						(
							If IsoCamera != undefined then
							(
						 		max vpt camera 
							)
							Else
							( 
								Max tool zoomextents
								Viewport.SetTM IsoView
								completeRedraw()
							)
						)
						Else
						(
							Max tool zoomextents
							)
					)
					Catch ()
				)	
				
				Select IOBJ
				
				AnimationRange  = (Interval IsoAnimStart IsoAnimEnd)
				Set Animate Off
			)
--format "exiting OldUnIsolate\n" to:debugwindow
		)
	
		-- *************************************************************************************
		-- Start of rollout UI and handlers
		-- *************************************************************************************

		-- Nov 29 2001 Changed the size and text of the button to read more clearly
		-- Also changed the highlight color to use the active Command color fromthe color manager (So it always matches)
		
		button Sel2Iso "Isolate Selection" pos:[53,7] width:94 height:0  -- LAM - localize?
			
		checkbutton C2Iso "Exit Isolation Mode" pos:[8,8] width:184 height:32 highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) checked:true  -- LAM - localize?
--		Button C2Iso "Exit Isolation"  -- LAM - localize?
		
		on Iso2Roll open do -- with undo on -- call Iso2late to set object delete callback
		(	
			Iso2late()
		)--end of onIso2Roll open
		
		on Iso2Roll Close do -- with undo "Isolate_End" on
		(
			if Iso2lations == true then
			(
				Iso2lations = false
				UnIso2late ()
			)
			Else
			(
				Iso2lations = false
			)
		)

		on Sel2Iso pressed do -- with undo "Isolate_Update" on
		(
			Iso2ObjArr = selection as array  -- what should behavior be if no objects are selected?
			UpdateSelection note:false
		)
	
		on C2Iso changed state do
--		on C2Iso pressed do
		(
			try (
				setIniSetting (iniFile) "IsolatedDialogPosition" "Position" \
					((((GetDialogPos(Iso2Roll)).x as integer) as string) + " " + (((GetDialogPos(Iso2Roll)).y as integer) as string))
				) catch ()
			destroyDialog Iso2Roll			
		)
	) -- end Iso2Roll
	
	-- pfb, July 17th 2002: turn this on to disable the macro in SO mode
	--on isEnabled return (selection.count > 0 and subObjectLevel == 0 or subObjectLevel == undefined)) 
	
	-- pfb, July 17th 2002: turn this on to enable the macro in SO mode
	on isEnabled return(selection.count > 0 and ((subObjectLevel == 0 or subObjectLevel == undefined) or (Iso2Lations == False and subObjectLevel > 0)))
	
	on execute do with undo off
	(
--if debugwindow == undefined then debugwindow = newScript()

--format "starting execution, iso2lations = %; Iso2Roll = %; Iso2Roll.scrollPos = %\n" iso2lations Iso2Roll (if Iso2Roll != undefined then Iso2Roll.scrollPos else undefined) to:debugwindow
--format "checking for old isolate, IsoLations= %; IObj = %; IsoAnimStart = %\n" (execute "IsoLations") (execute "IObj") (execute "IsoAnimStart") to:debugwindow

		-- check for R4.2 isolates and update to Isolate Selection. Coming out of OldUnIsolate, the isolated object is selected.
		-- Saying that a R4.2 isolate exists if global variable Isolations is true, global variable IObj contains a node value, and global 
		-- variable IsoAnimStart is a time value.
		-- Using the execute method to access the global variables (if they exist) so that we don't need to declare them as globals.
		-- Loc: Note that names of functions to be executed are not localized.
		if (execute "( IsoLations )") == true do
		(
			if isValidNode (execute "( IObj )") do
			(	try (if isKindof (execute "( IsoAnimStart )") time do Iso2Roll.OldUnIsolate())
				catch()  -- add warning message?
			)
		)

		-- declare the persistent globals as persistent. This will force them to persistent whenever the macroscript is run.
		Persistent Global Iso2Lations
		Persistent Global Iso2Hidden, Iso2Camera
		Persistent Global Iso2ObjArr, Iso2View, Iso2HidFlags 

		-- check to see if macroscript button pressed when the rollout isn't up, but we have isolated objects (i.e., after file load with isolated objects)
		-- if so, select the objects so that the rollouts open handler sets up the object delete callback.
		if iso2lations == true and Iso2Roll.scrollPos == undefined do  -- Iso2Roll.scrollPos will be 'undefined' if rollout not in dialog
		(	
			Iso2ObjArr = for obj in Iso2ObjArr where isValidNode obj collect obj
			try (select Iso2ObjArr)
			catch (Max select all)
		)
		if selection.count > 0 then		-- no effect if nothing selected
		(
			if Iso2Roll.scrollPos == undefined then -- rollout not displayed, open handler will take care of doing the isolation
			(
				x = -1
				y = -1
				screenLoc = getIniSetting (iniFile) "IsolatedDialogPosition" "Position"
--format "screenLoc = %\n" screenLoc to:debugwindow
				if screenLoc != "" then
				(
					locStream = screenLoc as stringStream
					try (
						x = readValue(locStream)
						y = readValue(locStream)						) catch ()
				)
--format "x = %, y = %\n" x y to:debugwindow
				if (x > 0 and y > 0) then
					createDialog Iso2Roll 200 47 x y 
				else
					createDialog Iso2Roll height:47 width:200
			)
			else
				Iso2Roll.Sel2Iso.pressed() -- rollout displayed, simulate "Isolate Selection" button press
		)
	)--end of onExecute

)--end of macro


----**********************************************************************************************************************
-- This macro is Isolating unselected geometery.  It basically inverses the selection and call the Isolate Selection macros defined above

MacroScript Isolate_Inverse_Selection
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
Category:"Tools" 
internalCategory:"Tools" 
ToolTip:"Isolate Unselected..." 
buttontext:"Isolate Unselected..." 
Icon:#("ViewPortNavigationControls",7) 
SilentErrors:True
(

	on isEnabled return(selection.count > 0 and (subObjectLevel == 0 or subObjectLevel == undefined))
			
	on execute do with undo off
	(
		-- saves the current selection filter (all, lights, geometry etc...)
		local SavedSelectionFilter
		SavedSelectionFilter = GetSelectFilter()

		--set the selection filter to all in order to provide an efficient Isolation tool
		SetSelectFilter 1
		if (isSelectionFrozen() == true)do thawSelection() ---pfb feb 10 2003, tool was failing when selection is locked
		max select invert
		macros.run "Tools" "Isolate_Selection"
		max select none
		
		--restores the previously saved selection filter
		SetSelectFilter SavedSelectionFilter
	)
)
