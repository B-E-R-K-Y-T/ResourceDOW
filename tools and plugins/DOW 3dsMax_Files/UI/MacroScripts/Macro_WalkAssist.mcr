-- MacroScript File
-- Created:       Jan 15 2002
-- Last Modified: Mar 15 2005
-- Walkthrough Assistant 2.0
-- Version: VIZ 2006
-- Author: Jeremy Hubbell, Discreet
-- Modified: Alexander Esppeschit Bicalho, Discreet
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

/* History

Nov 08 04 to Mar 07 05 - AB - Refactored version 2.0 adding several new features:
	- Added Multiple Camera Support
	- Removed explicit camera naming 
	- Moved Render Preview to its own rollout
	- Added option to create Free/Target cameras
	- Added new Look-At rollout available when using a Target Camera
	- Added support for Undo/Redo, for camera creation and deletion
	- Added support for renaming a camera outside of the script
	- Moved "Eye Level" controls to the Path Control UI
	- Added "Remove all head Animation" to View Controls
	- Changed "Eye Level" and "Target Distance" spinners to type #worldUnits
	- Added redrawViewsCallback to allow the slider to be updated
	- Reduced the quality of the Render Preview so it renders faster
	- Added ability to save and restore dialog position, size and rollout states
	- Added ability to remove the Path Controller reverting to bezier_position controller
	- Saved the original Path Z level in APPData channel 272 and 273
	- Added callbacks to close the script at File Reset/New/Open
	- Added product switch
	- Changed the "X" button (Remove Path) to a bitmap loaded from the existing icons
	- Added a "Set Viewport to Camera" button as discussed with Shana
	- Fixed bugs with "Move to Eye Level" spinner - this is ready for testing
	- Implemnted Look-At rollout - this is fully functional and ready for testing
	- Added Undo support to "Constant Speed" and "Follow Path" options
	- Unified the methods to close the dialog - they're all call a single method
	- Script will not render if renderer is missing
	- Path Buttons are now updated on Rename
	- Implemented error checking for all of the events that handle controllers
	- Reset the Render button when closing
	- Added support for cameras as XRef Objects
	- Changed getPathControl so it can handle Link_Transform controllers
	- Added objectXrefPostMerge callback to receive notifications when Cameras are xrefed in or out
	- Update Eye level value when user moves the Spline in the Viewport
	- The Target Distance spinner is now disabled when the target is bound to an object or path
	- Added a try/catch around the renderer in case it fails

26 sept 2001 - PFBreton - Updated the code for VizR4 support
22 oct 2001 - PFBreton - Code Fix

*/

macroScript walk_assist 
enabledIn:#("viz", "vizr")
	icon:#("WalkThrough",1)
	category:"Animation" 
	internalCategory:"Animation"
	ButtonText:"Walkthrough Assistant..." 
	tooltip:"Walkthrough Assistant..."

(

struct walkAssistuct (floating_main, walkpath, target, walk_cam, updateSlider, \
						floaterOpen, rlt_main, rlt_view, rlt_adv, rlt_render, rlt_lookAt, \
						bm, pos_control, shape_filter, checkForCam, iniFile, loadDialogPos, \
						saveDialogPos, defaultHeight, defaultTargDist, getPathControl, destroy, \
						updateAllCallback, updateNameCallback, saveRolloutState, getRolloutState, \
						loadXBitmap, xBitmap, LookAtObj, supportsKeyframes, canMoveZ, canRotateZ, \
						canRotateX, isClosingRollouts, LocStr, StaticStr)

global walkAssist

if walkAssist == undefined do walkAssist = walkAssistuct()
walkAssist.isClosingRollouts = false

-- DO NOT LOCALIZE THESE

walkAssist.iniFile = getDir #plugcfg + "\\walkAssist.ini" -- DO NOT LOCALIZE
walkAssist.DefaultHeight = units.decodeValue "65\"" -- DO NOT LOCALIZE
walkAssist.defaultTargDist = units.decodeValue "160\"" -- DO NOT LOCALIZE
walkAssist.staticStr = #("Open", \ --1
						"Closed", \ --2
						"RolloutState",\ -- 3
						"Main",\ -- 4
						"Render",\ -- 5
						"LookAt",\ -- 6
						"Advanced",\ -- 7
						"View",\ -- 8
						"DialogSize",\ -- 9
						"DialogPos",\ -- 10
						"PositionX",\ -- 11
						"PositionY",\ -- 12
						"SizeX",\ -- 13
						"SizeY") -- 14

-- LOCALIZE THESE -- THIS MEANS YES, THESE ARE TO BE LOCALIZED

walkAssist.LocStr = #("Move Path to Eye Level", \ -- 1
					"Pick Path", \ -- 2
					"Select", \ -- 3
					"Camera Type", \ -- 4
					"Create Camera", \ -- 5
					"Walkthrough_Cam", \ -- 6
					"Remove Path", \ -- 7
					"Rendering has been cancelled", \ -- 8
					"Level Eye", \ -- 9
					"Remove Animation", \ -- 10
					"Pick Target Path", \ -- 11
					"Pick Target Object", \ -- 12
					"Pick Look-At Target", \ -- 13
					"Remove Look-At", \ -- 14
					"Constant Speed", \ -- 15
					"Follow Path", \ -- 16
					"Walkthrough Assistant", -- 17
					"Render Failed") -- 18

--*****************Funtions*********************

fn shape_filter obj = isKindOf obj Shape
walkAssist.shape_filter = shape_Filter
fn checkforcam =
(
	if walkAssist.rlt_main.lb_cam.selection > 0 do
	(
		if selection.count == 1 do
			if superclassof selection[1] == camera then
			(
				if walkAssist.walk_cam != selection[1] do
				(
				walkAssist.walk_cam = selection[1]
				walkAssist.rlt_main.selectCamera walkAssist.walk_cam
				walkAssist.rlt_main.updateTargeted()
				walkAssist.rlt_main.updatePathControls()
			)
			)
			else
			(
				walkAssist.walk_cam = \
					walkAssist.rlt_main.CameraList[walkAssist.rlt_main.lb_cam.selection]
			)
	)
)
walkAssist.checkForCam = checkForCam

fn getPathControl obj =
(
	local result = undefined
	if obj != undefined do
	(
		tmController = obj.controller -- 622993
		if classof tmController == Link_transform do
			tmController = obj.controller[1].controller
		if isProperty tmController #position do
		(
			if classof tmController.pos.controller == path_constraint do
			(
				result = tmController.pos.controller
			)
			
			if classof tmController.pos.controller == position_list do
			(
				for i in 1 to tmController.pos.controller.count do
				(
					if classof tmController.pos.controller[i].controller == path_constraint do
					(
						result = tmController.pos.controller[i].controller
					)
				)
			)
		)
	)
	result
)
walkAssist.getPathControl = getPathControl

fn updateSlider =
(
	if walkAssist.walk_cam != undefined and \
		walkAssist.rlt_view != undefined and \
		walkAssist.rlt_adv != undefined do
	(
		if walkAssist.rlt_view.open do
		(
			if not walkAssist.rlt_view.cam_rot.enabled do -- 612062
				walkAssist.rlt_view.updateUI()
			if isProperty walkAssist.walk_cam #rotation do
			(
				walkAssist.rlt_view.cam_rot.value = walkAssist.walk_cam.rotation.z_rotation
				walkAssist.rlt_view.cam_tilt.value = (walkAssist.walk_cam.rotation.x_rotation - 90)
			)
		)
		if walkAssist.rlt_adv.open do
		(
			if isProperty walkAssist.walk_Cam #curfov do
				walkAssist.rlt_adv.walk_cam_fov.value = walkAssist.walk_cam.curfov
			if isProperty walkAssist.walk_Cam #target_Distance then
				if walkAssist.walk_cam.target_Distance != undefined do
					walkAssist.rlt_adv.targ_dist.value = walkAssist.walk_cam.target_Distance
			if isProperty walkAssist.walk_Cam #targetDistance do
				if walkAssist.walk_cam.targetDistance != undefined do
					walkAssist.rlt_adv.targ_dist.value = walkAssist.walk_cam.targetDistance
		)
		if walkAssist.walkPath != undefined do
		(
			if walkAssist.rlt_main.ck_moveEye.checked do
				if walkAssist.canMoveZ walkAssist.walkPath do
					walkAssist.rlt_main.spn_eye.value = walkAssist.walkPath.pos.z
			PathControl = walkAssist.getPathControl walkAssist.walk_cam
			if PathControl != undefined do
			(
				walkAssist.rlt_adv.nmlize.checked = pathControl.constantVelocity
				walkAssist.rlt_adv.follow.checked = pathControl.follow
			)
		)
	)	
)
walkAssist.updateSlider = updateSlider

fn updateAllCallback type =
(
	notification = callbacks.notificationParam()
	if notification == walkAssist.LocStr[1] do
	(
		moveObj = not walkAssist.rlt_main.ck_moveEye.checked
		if walkAssist.walkPath != undefined do
			setAppData walkAssist.walkPath 273 (moveObj as string)
	)

	walkAssist.rlt_main.countCameras()

	if walkAssist.rlt_main.numCameras != walkAssist.rlt_main.oldNumCam or \
	   walkAssist.rlt_main.numTargets != walkAssist.rlt_main.oldNumTarg or \
	   classof notification == targetObject or type == #undo or type == #delete do
	(
		if walkAssist.walk_cam != undefined do
			if isDeleted walkAssist.walk_cam do 
				walkAssist.walk_cam = undefined
		walkAssist.rlt_main.RestartUI()
	)
)
walkAssist.updateAllCallback = updateAllCallback

fn updateNameCallback =
(
	params = callbacks.notificationParam()
	if params.count == 3 do
		if params[3] != undefined do
		(
			if superclassof params[3] == camera do
				if classof params[2] == string do
					walkAssist.rlt_main.updateNameList params[3] params[2]
			if params[3] == walkAssist.walkPath do
				if classof params[2] == string do
					walkAssist.rlt_main.btn_path.text = params[2]
			if params[3] == walkAssist.LookAtObj do
				if classof params[2] == string do
					walkAssist.rlt_LookAt.btn_Targpath.text = params[2]
		)
)
walkAssist.updateNameCallback = updateNameCallback

fn destroy =
(
	if (callbacks.notificationParam()) == 2 do return undefined
	if walkAssist.floating_main != undefined do
	(
		walkAssist.isClosingRollouts = true
		walkAssist.saveDialogPos()
		removeRollout walkAssist.rlt_adv
		removeRollout walkAssist.rlt_view
		removeRollout walkAssist.rlt_main
		removeRollout walkAssist.rlt_render
		closeRolloutFloater walkAssist.floating_main
		walkAssist.floating_main = undefined
		updateToolbarButtons()
		walkAssist.isClosingRollouts = false
		gc light:true
	)
)
walkAssist.destroy = destroy

fn saveRolloutState rlt key =
(
	state = walkAssist.staticStr[1]
	try
	(
	if rlt != undefined do if not rlt.open then state = walkAssist.staticStr[2]
	)
	catch()
	setIniSetting walkAssist.iniFile walkAssist.staticStr[3] key state
)
walkAssist.saveRolloutState = saveRolloutState

fn getRolloutState key =
(
	(getIniSetting walkAssist.iniFile walkAssist.staticStr[3] key) as name == #closed
)
walkAssist.getRolloutState = getRolloutState

fn loadXbitmap =
(
	bmpFile = "enss_tools_24i.bmp"
	bmpFilea = "enss_tools_24a.bmp"
	if (colorman.resolveiconfolder bmpFile &bmpFile) and (colorman.resolveiconfolder bmpFilea &bmpFilea) do
	(
		mybmp = openBitmap bmpFile
		mybmpA = openBitmap bmpFileA
		newBmp = bitmap 48 24
		newBmpA = bitmap 48 24
		for i in 0 to 24 do
		(
			px = getPixels myBmp [49,i] 48
			setPixels newBmp [0,i] px
			px = getPixels myBmpA [49,i] 48
			setPixels newBmpA [0,i] px
		)
		close mybmp
		#(newBmp, newBmpA)
	)
)
walkAssist.loadXBitmap = loadXBitmap

fn SupportsKeyframes ctl sub:#none =
(
	if not isController ctl do return false
	if ctl.keyable do return true
	if classof ctl == position_list or
		classof ctl == rotation_list or
		classof ctl == scale_list or
		classof ctl == point3_list or
		classof ctl == float_list do
		(
			if ctl.count > 0 do
			(
				id = ctl.active
				subClt = ctl[id].object
				return (supportskeyFrames subClt)
			)
		)
	if classof ctl == position_xyz or
		classof ctl == euler_xyz or
		classof ctl == scale_xyz do
		(
			xKeyable = supportsKeyframes ctl[1].controller
			yKeyable = supportsKeyframes ctl[2].controller
			zKeyable = supportsKeyframes ctl[3].controller
			case sub of
			(
				#X: return xKeyable
				#Y: return yKeyable
				#Z: return zKeyable
				default: return (xKeyable or yKeyable or zKeyable)
			)
		)
	false
)
walkAssist.SupportsKeyframes = SupportsKeyframes 

fn canMoveZ path =
(
	returnVal = false
	if Path != undefined and isValidNode path do
		if classof path.controller == prs or \
			classof path.controller == lookAt or \
			classof path.controller == Link_transform do
			returnVal = supportsKeyFrames path.position.controller sub:#z
	returnVal
)
walkAssist.canMoveZ = canMoveZ

fn canRotateZ cam =
(
	returnVal = false
	if cam != undefined do
		if classof cam.controller == prs or classof cam.controller == link_transform do
			if hasProperty cam.controller #rotation do
				returnVal = supportsKeyFrames cam.rotation.controller sub:#z
	returnVal
)
walkAssist.canRotateZ = canRotateZ

fn canRotateX cam =
(
	returnVal = false
	if cam != undefined do
		if classof cam.controller == prs or classof cam.controller == link_transform do
			if hasProperty cam.controller #rotation do
				returnVal = supportsKeyFrames cam.rotation.controller sub:#x
	returnVal
)
walkAssist.canRotateX = canRotateX

--*********************End Functions******************

--************This whole section contains the controls and functions for the Main Controls**********

rollout rlt_main "Main Controls" 
(

	local cameraList, nameList, numCameras, numTargets, oldNumCam, oldNumTarg

--***********************This section builds the main control user interface************************
	
	Group "Camera Creation"
		(
		button cr_cam "Create New Camera" \
			toolTip:"Creates a walkthrough camera" \
			message:"Click to create a camera for the walkthrough" \
			enabled:true width:150
		radioButtons rb_camType labels:#("Free","Targeted")
	)
	Group "Cameras"
	(
		ListBox lb_cam "" height:5
		checkBox ck_targetCam "Targeted" offset:[5,0]
		button btn_setView "Set Viewport to Camera" height:20 width:180
	)
	Group "Path Control" 
		(
			pickbutton btn_Path "Pick Path" \
				toolTip:"Selects a path for camera" \
				message:"Select a spline object for a path" \
				enabled:false \
				width:100 height:22\
				filter:walkAssist.shape_filter offset:[-15,0]
			button btn_RemPath "X" width:24 pos:(btn_Path.pos + [105,0]) height:22 tooltip:"Clear Path"
			checkBox ck_moveEye "Move Path to Eye level" align:#center
			spinner spn_eye "Eye Level:" fieldWidth:60 align:#center \
				type:#worldUnits range:[-10000,10000,walkAssist.DefaultHeight] \
		)

	
--******************* Misc Functions to handle UI *****************************

	fn resetPathBtn = 
	(
		btn_path.text = walkAssist.LocStr[2] -- Pick Path
		ck_moveEye.enabled = spn_eye.enabled = true
		if walkAssist.walkPath != undefined do
			if isDeleted walkAssist.walkPath do
				walkAssist.walkPath = undefined
	)

	fn updatePathControls =
	(
		if walkAssist.walk_cam == undefined then
		(
			btn_path.enabled = btn_remPath.enabled = false
		)
		else
		(
			btn_path.enabled = (isProperty walkAssist.walk_cam.controller #position or \
								classof walkAssist.walk_cam.controller == Link_Transform)
			PathControl = walkAssist.getPathControl walkAssist.walk_cam
			if PathControl != undefined then
			(
				if PathControl.Path != undefined then
				(
					btn_path.text = pathControl.Path.name
					walkAssist.walkPath = pathControl.path
					oldPathLevel = getAppData walkAssist.walkPath 272
					ck_moveEye.checked = (getAppData walkAssist.walkPath 273) == (#true as string)
					if oldPathLevel != undefined and ck_moveEye.checked then
					(
						if walkAssist.canMoveZ walkAssist.walkPath do
							spn_eye.value = walkAssist.walkPath.pos.z
					)
					else spn_eye.value = walkAssist.DefaultHeight
					ck_moveEye.enabled = spn_eye.enabled = walkAssist.canMoveZ walkAssist.walkPath
				)
				else
					resetPathBtn()
				btn_remPath.enabled = PathControl.Path != undefined
			)
			else
			(
				resetPathBtn()
				btn_remPath.enabled = false
				walkAssist.walkpath = undefined
			)
		)
		-- walkAssist.rlt_adv.updateUI()
	)
	
	fn movePath2EyeLevel =
	(
		if ck_moveEye.checked do
			if walkAssist.walkPath != undefined do
			(
				if walkAssist.canMoveZ walkAssist.walkPath do
				walkAssist.walkPath.pos.z = spn_eye.value
			)
	)

	fn selectCamera obj =
	(
		for i in 1 to cameraList.count do
		(
			if cameraList[i] == obj do
				lb_cam.selection = i
		)
	)

	fn populateCamList =
	(
		nameList = #()
		cameraList = #()
		for i in cameras do
		(
			if superclassof i == Camera do
			(
				append cameraList i
				if classof i == xrefObject then
					append nameList ("{" + i.name + "}")
				else
				append nameList i.name
			)
		)
		lb_cam.items = nameList
		if lb_cam.selection > 0 and walkAssist.walk_cam == undefined then
			walkAssist.walk_cam = cameraList[lb_cam.selection]
		else
			if lb_cam.selection > 0 then 
				selectCamera walkAssist.walk_cam
			else
				walkAssist.walk_cam = undefined

		oldNumCam = cameralist.count
		oldNumTarg = cameras.count - oldNumCam
	)
	
	fn updateNameList obj newName =
	(
		foundme = findItem cameraList obj
		if foundme > 0 do
		(
			if classof obj == xrefObject then
				nameList[foundme] = "{" + newName + "}"
			else 
			nameList[foundme] = newName
			lb_cam.items = nameList
		)
	)
	
	fn countCameras =
	(
		numCameras = 0
		numTargets = 0
		for i in cameras do
		(
			if superclassof i == Camera do
			(
				if isProperty i #type then
				(
				numCameras += 1
					if i.type == #target do numTargets += 1
				)
				else
				(
					numCameras += 1
					if classof i.controller == lookat do numTargets += 1
				)
			)
		)
	)
	
	fn updateTargeted =
	(
		if lb_cam.selection > 0 then
		(
			ck_targetCam.enabled = isProperty walkAssist.walk_cam #type
			btn_setView.enabled = true
			if classof cameraList[lb_cam.selection] != xrefObject then
			ck_targetCam.checked = classof cameraList[lb_cam.selection] == Targetcamera
			else
				ck_targetCam.checked = classof cameraList[lb_cam.selection].controller == lookat
		)
		else
		(
			ck_targetCam.enabled = btn_setView.enabled = false
			walkAssist.isClosingRollouts = true
			removeRollout walkAssist.rlt_view
			removeRollout walkAssist.rlt_lookAt
			removeRollout walkAssist.rlt_adv
			removeRollout walkAssist.rlt_render
			walkAssist.isClosingRollouts = false
		)
		if lb_cam.selection > 0 do
		(
			walkAssist.isClosingRollouts = true
			removeRollout walkAssist.rlt_view
			removeRollout walkAssist.rlt_lookAt
			removeRollout walkAssist.rlt_adv
			removeRollout walkAssist.rlt_render
			walkAssist.isClosingRollouts = false
			walkAssist.target = walkAssist.walk_cam.target
			if ck_targetCam.checked then
			(
				addRollout walkAssist.rlt_render walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[5])
				addRollout walkAssist.rlt_lookAt walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[6])
				addRollout walkAssist.rlt_adv walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[7])
			)
			else
			(
				addRollout walkAssist.rlt_render walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[5])
				addRollout walkAssist.rlt_view walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[8])
				addRollout walkAssist.rlt_adv walkAssist.floating_main \
					rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[7])
			)
		)
		walkAssist.rlt_render.rp.enabled = lb_cam.selection > 0 and \
			classof renderers.current != Missing_RefMaker and \
			classof renderers.current != Missing_Renderer
	)
	
	fn restartUI =
	(
		populateCamList()
		updateTargeted()
		updatePathControls()
	)
	
	on lb_cam selected val do
	(
		if walkAssist.walk_cam != cameraList[lb_cam.selection] do
		(
		walkAssist.walk_cam = cameraList[lb_cam.selection]
		updateTargeted()
		updatePathControls()
			walkAssist.rlt_adv.updateUI()
		)
	)

	on lb_cam doubleClicked val do
	(
		undo label:walkAssist.LocStr[3] on -- Select
		(
			if getCommandPanelTaskMode() != #modify do setCommandPanelTaskMode #modify
			select cameraList[val]
		)
	)

	on ck_targetCam changed state do
	(
		undo label:walkAssist.LocStr[4] on -- Camera Type
		(
			walkAssist.isClosingRollouts = true
			removeRollout walkAssist.rlt_view
			walkAssist.isClosingRollouts = false
			if lb_cam.selection > 0 then
			(
				if classof cameraList[lb_cam.selection] == TargetCamera then
				(
					cameraList[lb_cam.selection].type = #free
					pathControl = walkAssist.getPathControl cameraList[lb_cam.selection]
					if PathControl != undefined do
					(
						pathControl.axis = 1
						pathControl.follow = walkAssist.rlt_adv.follow.checked
						if isProperty walkAssist.walk_cam #rotation do
						(
							walkAssist.walk_cam.rotation.z_rotation = 0
						)
						-- maybe delete rotation keyframes or reset the rotation?
					)
				)
				else
					cameraList[lb_cam.selection].type = #target
			)
			updateTargeted()
		)
	)

	on btn_setView pressed do
	(
		if walkAssist.walk_cam != undefined do
		(
			if viewport.getType != undefined do
				viewport.setCamera walkAssist.walk_cam
		)
	)
	
--********************This section tells the script what to do when the camera is created***********

	on rlt_main open do
	(
		restartUI()
		walkAssist.xBitmap = walkAssist.loadXBitmap()
		if walkAssist.xBitmap != undefined do
		(
			btn_remPath.images = #(walkAssist.xbitmap[1], walkAssist.xbitmap[2], 2, 1, 1, 2, 2)
		)

		-- *** Do not Localize ***

		callbacks.addScript #SceneNodeAdded (#'walkAssist.updateAllCallback #node' as string) id:#walkAssist
		callbacks.addScript #nodePostDelete (#'walkAssist.updateAllCallback #delete' as string) id:#walkAssist
		callbacks.addScript #sceneUndo (#'walkAssist.updateAllCallback #undo' as string) id:#walkAssist
		callbacks.addScript #sceneRedo (#'walkAssist.updateAllCallback #undo' as string) id:#walkAssist
		callbacks.addScript #objectXrefPostMerge (#'walkAssist.updateAllCallback #xref' as string) id:#walkAssist
		
		callbacks.addScript #nodeNameSet (#'walkAssist.updateNameCallback()' as string) id:#walkAssist
		
		callbacks.addScript #filePreOpen (#'walkAssist.destroy()' as string) id:#walkAssist
		callbacks.addScript #systemPreNew (#'walkAssist.destroy()' as string) id:#walkAssist
		callbacks.addScript #systemPreReset (#'walkAssist.destroy()' as string) id:#walkAssist
		callbacks.addScript #preSystemShutdown (#'walkAssist.destroy()' as string) id:#walkAssist
	)

	on rlt_main close do 
	(
		walkAssist.saveRolloutState rlt_main walkAssist.staticStr[4]
		walkAssist.saveDialogPos()
		callbacks.removeScripts id:#walkAssist
		walkAssist.walk_cam = undefined
		updateToolbarButtons()
		if walkAssist.isClosingRollouts == false do walkAssist.destroy()
	)

	on cr_cam pressed do 
		(
			undo label:walkAssist.LocStr[5] on -- Create Camera
			(
				walkAssist.walk_cam=Freecamera \
					fov:50 \
					farrange:10000 \
					pos:[0,0,walkAssist.DefaultHeight]
				walkAssist.walk_cam.targetDistance = walkAssist.DefaultTargDist
				walkAssist.walk_cam.name = cam = uniqueName walkAssist.LocStr[6] -- Walkthrough_Cam
				walkAssist.walk_cam.rotation.controller = euler_xyz()
				walkAssist.walk_cam.rotation = quat 90 x_axis
				walkAssist.walk_cam.showCone = true
				if rb_camType.state == 2 do walkAssist.walk_cam.type = #target

				populateCamList()
				selectCamera walkAssist.walk_cam
				updateTargeted()
				updatePathControls()
			)
		)

--************************This section tells the script what to do when the path is picked***********
	
	on ck_moveeye changed state do
	(
		if walkAssist.walkPath != undefined do
		(
			undo label:walkAssist.LocStr[1] on
			(
				oldPathLevel = getAppData walkAssist.walkPath 272
				setAppData walkAssist.walkPath 273 (state as string)
				if state then
				(
					if oldPathLevel == undefined do
						if isProperty walkAssist.walkPath #position do
						(
							setAppData walkAssist.walkPath 272 (walkAssist.walkPath.pos.z as string)
						)
					movePath2EyeLevel()
				)
				else
					if oldPathLevel != undefined do
					(
						if walkAssist.canMoveZ walkAssist.walkPath do 
							walkAssist.walkPath.pos.z = oldPathLevel as float
					)
			)
		)
	)
	
	on spn_eye changed val do
	(
		movePath2EyeLevel()
	)
	
	on btn_remPath pressed do
	(
		undo label:walkAssist.LocStr[7] on -- Remove Path
		(
			if walkAssist.walkPath != undefined do
			(
				walkAssist.walk_cam.pos.controller = bezier_position()
				updatePathControls()
				walkAssist.rlt_adv.updateUI()
				walkAssist.walkPath = undefined
			)
		)
	)
	
	on btn_Path picked obj do 
	(
		if (isProperty walkAssist.walk_cam.controller #position or \
			classof walkAssist.walk_cam.controller == Link_Transform) do
		(
			undo label:walkAssist.LocStr[2] on -- Pick Path
		(	-- adding the Path to the camera
			walkAssist.walkPath = obj
			setAppData walkAssist.walkPath 273 (ck_moveEye.checked as string)
			
			if ck_moveEye.checked do
			(
				oldPathLevel = getAppData walkAssist.walkPath 272
				if oldPathLevel == undefined do
					(
						if walkAssist.canMoveZ walkAssist.walkPath do
					setAppData walkAssist.walkPath 272 (walkAssist.walkPath.pos.z as string)
					)
					if walkAssist.canMoveZ walkAssist.walkPath do
				walkAssist.walkPath.pos.z = spn_eye.value
			)
			walkAssist.walk_cam.pos.controller = path_constraint()
			PosCont = walkAssist.walk_cam.pos.controller
			PosCont.path = walkAssist.walkPath
			PosCont.ConstantVelocity = walkAssist.rlt_adv.nmlize.checked
			posCont.Follow = walkAssist.rlt_adv.follow.checked
			posCont.axis = 1
			
			-- if not Target Cam, then reset rotation controllers
			if walkAssist.walk_cam.target == undefined do
			(
					walkAssist.walk_cam.rotation.controller = euler_xyz()
				current_rot = walkAssist.walk_cam.rotation.z_rotation
			)

			)
		)

			-- setting UI controls
			updatePathControls()			
		walkAssist.rlt_adv.updateUI()
	)
)
walkAssist.rlt_main = rlt_main

--Render Preview***************************

rollout rlt_render "Render Preview"
(
	button rp "Click to Render Preview" toolTip:"Renders a preview of the camera's view" \
		width:150 height:112 enabled:false
	
	on rlt_render close do 
	(
		walkAssist.SaveRolloutState rlt_render walkAssist.staticStr[5]
		walkAssist.rlt_render.rp.images = undefined
		updateToolbarButtons()
		if walkAssist.isClosingRollouts == false do walkAssist.destroy()
	)

	on rp pressed do
	( 	-- 611477
		if walkAssist.rlt_main.lb_cam.selection > 0 and \
			classof renderers.current != Missing_RefMaker and\
			classof renderers.current != Missing_Renderer then
		(
		
			walkAssist.bm = bitmap 150 112
			hasCanceled = false
			try(
			render camera:walkAssist.walk_cam vfb:off \
				progressBar:off to:walkAssist.bm renderfields:false ComputeRadiosity: false \
				antiAliasing:false enablePixelSampler:false objectMotionBlur:false imageMotionBlur:false \
				quiet:true cancelled:&hasCancelled
			if hasCancelled then
				messageBox walkAssist.LocStr[8] title:walkAssist.LocStr[17]-- Rendering has been cancelled
			else
				rp.images = #(walkAssist.bm, undefined, 1, 1, 1, 1, 1)			
			)
			catch(
				messageBox (walkAssist.LocStr[18] + ":\n" + (getCurrentException())) title:walkAssist.LocStr[17]
			) -- Render Failed
			--22 oct 2001, pfb;  flushes memory assocoated with the rendered bitmap
			close walkAssist.bm
			walkAssist.bm = undefined
			freescenebitmaps()
			gc light:true
		)
		else
		(
			rp.enabled = false
		)
	)
)

walkAssist.rlt_render = rlt_render

--***********This section defines all of the controls and functions for the view controls**************

rollout rlt_view "View Controls" 
	(
		group "Turn Head"
		(
		slider cam_rot "" align:#center ticks: 4 \
			range: [179.5, -179.5, 0] enabled:false type:#float
		label lf_ct "   <-- Left" align:#left across:3 
		button slid_ctr "Center" toolTip:"Reset camera to looking down path" \
			align:#center height:20 enabled:false
		label ct_rt "Right -->  " align:#right
		spinner cam_tilt "Head Tilt Angle" \
			range: [-90, 90, 0] enabled:false fieldwidth:55 align:#center
		button lvl_eye "Reset Eyes Level" toolTip:"Reset camera to a level view" \
			align:#center height:20 enabled:false width:150
		button rem_Anim "Remove all head animation" \
			height:20 align:#center width:150
		)
	
	fn updateUI =
	(
		if walkAssist.walk_cam != undefined do
		(
			for i in rlt_view.controls do i.enabled = true
			if classof walkAssist.walk_cam.controller == prs or \
				(classof walkAssist.walk_cam.controller == Link_transform and \
				walkAssist.walk_cam.target == undefined) then
			(
				cam_rot.enabled = slid_ctr.enabled = walkAssist.canRotateZ walkAssist.walk_cam sub:#z
				cam_tilt.enabled = lvl_eye.enabled = walkAssist.canRotateX walkAssist.walk_cam sub:#X
				if isProperty walkAssist.walk_cam.controller #rotation then
			(
					rem_Anim.enabled = walkAssist.supportsKeyframes walkAssist.walk_cam.rotation.controller
			)
				else
					rem_anim.enabled = false
			)
			else for i in rlt_view.controls do i.enabled = false
		)
	)

	on rlt_view open do
	(
		updateUI()
		registerRedrawViewsCallback walkAssist.updateSlider
		walkAssist.updateSlider()
	)

	on rlt_view close do
	(
		walkAssist.saveRolloutState rlt_view walkAssist.staticStr[8]
		unRegisterRedrawViewsCallback walkAssist.updateSlider
		if walkAssist.isClosingRollouts == false do walkAssist.destroy()
		updateToolbarButtons()
	)
		
--****************************Functions for View Controls*****************

--Rotate Camera Left or Right**************
	
	on cam_rot changed val do
		(
			if walkAssist.canRotateZ walkAssist.walk_cam then
				walkAssist.walk_cam.rotation.z_rotation = cam_rot.value
			else updateUI()
		)

--Center Camera back along path************
	
	on slid_ctr pressed do
		(
			if walkAssist.canRotateZ walkAssist.walk_cam then
			(
			cam_rot.value = 0
				walkAssist.walk_cam.rotation.z_rotation = cam_rot.value
			)
			else updateUI()
		)

--Tilt Camera Up and Down******************	
	
	on cam_tilt changed val do 
		(
			if walkAssist.canRotateX walkAssist.walk_cam then
				walkAssist.walk_cam.rotation.x_rotation = cam_tilt.value + 90
			else updateUI()
		)
	
--Center Tilt back to Eyes Level***********
	
	on lvl_eye pressed do
		(
		if walkAssist.canRotateX walkAssist.walk_cam then
		(
			undo label:walkAssist.LocStr[9] on --Level Eye
			(
			cam_tilt.value = 0
				walkAssist.walk_cam.rotation.x_rotation = cam_tilt.value + 90
				)
			)
		else updateUI()
		)

	on rem_Anim pressed do
	(
		-- add Confirmation?
		undo label:walkAssist.LocStr[10] on -- Remove Animation
		(
			if walkAssist.supportsKeyframes walkAssist.walk_cam.rotation.controller do
				deleteKeys walkAssist.walk_cam.rotation.controller #allKeys
		)
	)
)
walkAssist.rlt_view = rlt_view

--********************* Look-At Camera Rollout ****************************--

rollout rlt_lookAt "Look-At Camera"
(
	
	local targPath

	fn shapeObj_filter obj = 
	(
		if walkAssist.rlt_lookAt.rb_lookAt.state == 1 then
			isKindOf obj Shape and obj != walkAssist.walkPath
		else 
			obj != walkAssist.walk_cam and obj != walkAssist.target
	)

		group "Look-At Camera"
		(
			radioButtons rb_LookAt labels:#("Path","Object")
		pickbutton btn_TargPath "Pick Target Path" tooltip:"Select an Object or Path for the Target"\
			offset:[-15,0] width:100 filter:shapeObj_filter height:22
		button btn_RemTargPath "X" tooltip:"Clear Look-At Object/Path" \
			width:24 height:22 pos:(btn_targPath.pos + [105,0])
	)

-- **************** Functions ********************* --

	fn updateTargetUI updateRadio:true =
	(
		walkAssist.target = walkAssist.walk_cam.target
		if walkAssist.target != undefined then
		(
			targPath = walkAssist.GetPathControl walkAssist.target
			if targPath != undefined then
			(
				walkAssist.lookAtObj = targPath.path
				if isValidObj walkAssist.lookAtObj then
				(
					btn_targPath.text = walkAssist.lookAtObj.name
				if updateRadio do rb_lookAt.state = 1
				btn_remTargPath.enabled = true
			)
				else btn_remTargPath.enabled = false
			)
			else
			(
				if walkAssist.target.parent != undefined then
				(
					walkAssist.lookAtObj = walkAssist.target.parent
					btn_targPath.text = walkAssist.lookAtObj.name
					btn_remTargPath.enabled = true
					if updateRadio do rb_lookAt.state = 2
				)
				else
				(
					if updateRadio do rb_lookAt.state = 1
					if rb_lookAt.state == 1 then
						btn_targPath.text = walkAssist.LocStr[11] -- Pick Target Path
					else
						btn_targPath.text = walkAssist.LocStr[12] -- Pick Target Object
					btn_remTargPath.enabled = false
				)
			)
		)
		else for i in walkAssist.rlt_lookAt.controls do i.enabled = false
	)
	
	on rb_lookAt changed state do
	(
		updateTargetUI updateRadio:false
	)
	
	on btn_TargPath picked obj do
	(
		undo label:walkAssist.LocStr[13] on -- Pick Look-At Target
		(
			if rb_lookat.state == 1 then
			(
				try(
				walkAssist.target.parent = undefined
				)
				catch()
				walkAssist.target.pos.controller = path_constraint()
				walkAssist.target.pos.controller.path = obj
			)
			else
			(
				walkAssist.target.pos.controller = position_xyz()
				move walkAssist.target (obj.transform.translation - walkAssist.target.transform.translation)
				try(
				walkAssist.target.parent = obj
			)
				catch()
			)
		)
		updateTargetUI updateRadio:false
		walkAssist.rlt_adv.updateUI()
	)
	
	on btn_remTargPath pressed do
	(
		undo label:walkAssist.LocStr[14] on -- Remove Look-At
		(
			if walkAssist.target != undefined do
			(
				walkAssist.target.pos.controller = position_xyz()
				try(
				walkAssist.target.parent = undefined
			)
				catch()
			)
		)
		updateTargetUI updateRadio:true
		walkAssist.rlt_adv.updateUI()
	)
	
	on rlt_lookat open do
	(
		updateTargetUI()
		registerRedrawViewsCallback walkAssist.updateSlider
		if walkAssist.xBitmap != undefined do
		(
			btn_remTargPath.images = #(walkAssist.xbitmap[1], walkAssist.xbitmap[2], 2, 1, 1, 2, 2)
		)
		)
		
	on rlt_lookAt close do 
	(
		walkAssist.saveRolloutState walkAssist.rlt_lookAt walkAssist.staticStr[6]
		unRegisterRedrawViewsCallback walkAssist.updateSlider
		if walkAssist.isClosingRollouts == false do walkAssist.destroy()
		updateToolbarButtons()
	)
)

walkAssist.rlt_LookAt = rlt_LookAt

--******************This section defines the interface and functions of the advanced controls rollout***
rollout rlt_adv "Advanced Controls" 
(


--******************Defining User Interface Elements****************************************************
	
	Group "Camera Controls"
		(
		spinner walk_cam_fov "Field of View: " \
			range: [0,200,50] \
			width:100 \
			align:#center \
			enabled:false
			fieldwidth:60
			offset:[30,0]
		spinner targ_dist "Target Distance: " \
			width:100 \
			enabled:false \
			range:[0,10000,160] \
			align:#center
			type:#worldUnits
			fieldwidth:60
			offset:[30,0]
		)
	
	Group "Path Controls"
		(
		checkbox nmlize "Constant Speed" align:#left enabled:false checked:true
		checkbox follow "Follow Path" align:#left enabled:false checked:true
		)

	fn updateUI =
	(
		walk_cam_fov.enabled = targ_dist.enabled = walkAssist.walk_cam != undefined
		if walkAssist.walk_cam != undefined do
		(
			if isProperty walkassist.walk_cam #curfov then
				walk_cam_fov.value = walkAssist.walk_cam.curfov
			else walk_cam_fov.enabled = false
			if isProperty walkAssist.walk_Cam #target_Distance do
				if walkAssist.walk_cam.target_Distance != undefined do
					walkAssist.rlt_adv.targ_dist.value = walkAssist.walk_cam.target_Distance
			if isProperty walkAssist.walk_Cam #targetDistance do
				if walkAssist.walk_cam.targetDistance != undefined do
					walkAssist.rlt_adv.targ_dist.value = walkAssist.walk_cam.targetDistance
		)
		pathControl = walkAssist.getPathControl walkAssist.Walk_cam
		if PathControl != undefined then
		(
			nmLize.enabled = follow.enabled = pathControl.path != undefined
			nmlize.checked = pathControl.constantVelocity
			follow.checked = pathControl.follow
		)
		else nmLize.enabled = follow.enabled = false
		walkAssist.target = walkAssist.walk_cam.target
		if walkAssist.target != undefined then
		(
			targPath = walkAssist.GetPathControl walkAssist.target
			walkAssist.rlt_adv.targ_dist.enabled = targPath == undefined and walkAssist.target.parent == undefined
		)

	)
	
	on rlt_adv open do updateUI()

	on rlt_adv close do
	(
		walkAssist.saveRolloutState rlt_adv walkAssist.staticStr[7]
		if walkAssist.isClosingRollouts == false do walkAssist.destroy()
		updateToolbarButtons()
	)

--******Functions for Advanced Controls*****************************************************************
--Constant Velocity On/Off state******************************		
	
	on nmlize changed state do
	(
		if walkAssist.walk_cam != undefined do
		(
			PathControl = walkAssist.getPathControl walkAssist.walk_cam
			if PathControl != undefined do
				undo label:walkAssist.LocStr[15] on -- constant speed
				pathControl.constantVelocity = nmlize.checked
		)
	)

	on follow changed state do
	(
		if walkAssist.walk_cam != undefined do
		(
			PathControl = walkAssist.getPathControl walkAssist.walk_cam
			if PathControl != undefined do
				undo label:walkAssist.LocStr[16] on -- Follow Path
				pathControl.follow = follow.checked
		)
	)

	on targ_dist changed value do 
		(
		if walkAssist.walk_cam != undefined do
		(
			if isProperty walkAssist.walk_cam #target_distance do
				walkAssist.walk_cam.target_Distance = targ_dist.value
			if isProperty walkAssist.walk_cam #targetDistance do
				walkAssist.walk_cam.targetDistance = targ_dist.value
		)
		)
	on walk_cam_fov changed value do 
		(
		if walkAssist.walk_cam != undefined do
			if isProperty walkAssist.walk_cam #curfov do
				walkAssist.walk_cam.curfov = walk_cam_fov.value
		)
)
walkAssist.rlt_adv = rlt_adv


--****This section manages the floating window that contains all of the controls above*********

fn saveDialogPos =
(
	dialogPos = walkAssist.floating_Main.pos
	dialogSize = walkAssist.floating_Main.size
	setIniSetting walkAssist.iniFile walkAssist.staticStr[10] walkAssist.staticStr[11] ((dialogPos.x as integer) as string)
	setIniSetting walkAssist.iniFile walkAssist.staticStr[10] walkAssist.staticStr[12] ((dialogPos.y as integer) as string)
	setIniSetting walkAssist.iniFile walkAssist.staticStr[9] walkAssist.staticStr[13] ((dialogSize.x as integer) as string)
	setIniSetting walkAssist.iniFile walkAssist.staticStr[9] walkAssist.staticStr[14] ((dialogSize.y as integer) as string)
)
walkAssist.saveDialogPos = saveDialogPos

fn loadDialogPos =
(
	dialogPos = [3,66]
	dialogSize = [218,506]
	maxDialogPos = sysInfo.desktopSize - dialogSize
	minDialogSize = [218,105]
	dialogPosNew = [0,0]
	dialogSizeNew = [0,0]
	dialogPosnew.x = (getIniSetting walkAssist.iniFile walkAssist.staticStr[10] walkAssist.staticStr[11]) as integer
	dialogPosnew.y = (getIniSetting walkAssist.iniFile walkAssist.staticStr[10] walkAssist.staticStr[12]) as integer
	dialogSizenew.x = (getIniSetting walkAssist.iniFile walkAssist.staticStr[9] walkAssist.staticStr[13]) as integer
	dialogSizenew.y = (getIniSetting walkAssist.iniFile walkAssist.staticStr[9] walkAssist.staticStr[14]) as integer
	if (dialogPosNew.x < 0 or dialogPosNew.x > maxDialogPos.x) do dialogPosNew.x = dialogPos.x
	if (dialogPosNew.y < 0 or dialogPosNew.y > maxDialogPos.y) do dialogPosNew.y = dialogPos.y
	if (dialogSizeNew.x < minDialogSize.x) do dialogSizeNew.x = dialogSize.x
	if (dialogSizeNew.y < minDialogSize.y) do dialogSizeNew.y = dialogSize.y
	#(dialogSizeNew.x, dialogSizeNew.y, dialogPosNew.x, dialogPosNew.y)
)
walkAssist.loadDialogPos = loadDialogPos

on execute do
(

	local isOpen = false
	
	if walkAssist.floating_main != undefined then
		isOpen = walkAssist.floating_main.open
	
	if isOpen == true then
		walkAssist.destroy()
	else
	(
		posArray = walkAssist.loadDialogPos()
		if posArray == undefined do posArray = #(218, 506, 3, 66)
		walkAssist.floating_main = newRolloutFloater walkAssist.LocStr[17] \ -- Walkthrough Assistant
			posArray[1] posArray[2] posArray[3] posArray[4]
		addRollout walkAssist.rlt_main walkAssist.floating_main \
			rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[4])
		addRollout walkAssist.rlt_render walkAssist.floating_main \
			rolledUp:(walkAssist.getRolloutState walkAssist.staticStr[5])
		walkAssist.checkforcam()
	)
)	

on closeDialogs do
	(
		if walkAssist.floating_main != undefined do 
			if walkAssist.floating_main.Open do
				walkAssist.destroy()
	)

on isChecked return
	(
		returnval = false
		if walkAssist != undefined then
		if walkAssist.floating_main != undefined then
				returnval = walkAssist.floating_main.Open
		returnval
	)
)