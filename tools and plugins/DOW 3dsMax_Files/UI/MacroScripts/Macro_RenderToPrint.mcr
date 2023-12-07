-- Macro Scripts File
-- Created:  Aug 23, 1999
-- Modified: May 23, 2003
-- Render to Print 2.6
-- Version: 3dsmax 6
-- Author: Alexander Esppeschit Bicalho [discreet]
--***********************************************************************************************

/* 

Note to Localization:

Script is ready for localization and follows the Guidelines
The paper sizes show up in the array definition at the end of the script
In order to add paper sizes, either edit the PrintWiz.INI or delete it and add the 
paper definition to the script as exemplified below:

	append PaperFormats #("MyPaper",2,22.4,31.7,187)
	Where the array elements are: #(<name>,<Units>,<Width>,<Height>,<DPI>)
	Units of 1 = mm, units of 2 = Inches

History
	July 16th 2004, Pierre-Felix Breton
		fixed some render resolution refreshing issues.

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	Version 2.6  -- removed dependency from PrintWiz.INI. The script now creates it upon startup.

*/

MacroScript RenderToPrint
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Render" 
	internalCategory:"Render" 
	tooltip:"Print Size Wizard..."
	buttonText:"Print Size Wizard..."
(
global rcalc_floater, rcalc_rollout

	/* Localize ON */
	
	local rcalc_txt01 = "Uncompressed file size: "
	local rcalc_txt02 = " Kb" -- I don't think the Kilobytes symbol should be localized, but just in case...
	
	/* Localize OFF */

	local printWizIni = getDir #plugCFG + "\\printwiz.ini" -- do not localize unless you rename paths or filenames
	
	
-- Functions to make the bitmaps

fn makeLandScapeBmp =
(
	mybmp = bitmap 150 100
	bgColor = ((colorman.getcolor #window)*255) as color
	fgColor = ((colorman.getcolor #window_text)*255) as color
	bgColorRow = #()
	for i in 0 to 149 do append bgColorRow bgColor
	for i in 0 to 99 do setpixels mybmp [0,i] bgColorRow
	fgColorRow = #()
	for i in 1 to 100 do append fgColorRow fgColor
	setpixels mybmp [20,20] fgColorRow
	setpixels mybmp [20,21] fgColorRow
	setpixels mybmp [30,20] fgColorRow
	setpixels mybmp [30,21] fgColorRow
	setpixels mybmp [20,80] fgColorRow
	setpixels mybmp [20,79] fgColorRow
	for i in 20 to 80 do setPixels mybmp [20,i] #(fgColor,fgColor)
	for i in 20 to 70 do setPixels mybmp [129,i] #(fgColor,fgColor)
	for i in 71 to 80 do setPixels mybmp [120,i] #(fgColor,fgColor)
	fgColorRow = #()
	for i in 1 to 10 do append fgColorRow fgColor
	setpixels mybmp [120,70] fgColorrow
	setpixels mybmp [120,71] fgColorrow
	for i in 1 to 9 do setPixels mybmp [119+i,80-i] #(fgColor,fgColor,fgColor)
	mybmp
)

fn makePortraitBmp =
(
	mybmp = bitmap 150 100
	bgColor = ((colorman.getcolor #window)*255) as color
	fgColor = ((colorman.getcolor #window_text)*255) as color
	bgColorRow = #()
	for i in 0 to 149 do append bgColorRow bgColor
	for i in 0 to 99 do setpixels mybmp [0,i] bgColorRow
	fgColorRow = #()
	for i in 1 to 40 do append fgColorRow fgColor
	setpixels mybmp [50,15] fgColorRow
	setpixels mybmp [50,16] fgColorRow
	setpixels mybmp [60,15] fgColorRow
	setpixels mybmp [60,16] fgColorRow
	setpixels mybmp [50,85] fgColorRow
	setpixels mybmp [50,84] fgColorRow
	for i in 15 to 85 do setPixels mybmp [50,i] #(fgColor,fgColor)
	for i in 15 to 75 do setPixels mybmp [99,i] #(fgColor,fgColor)
	for i in 76 to 85 do setPixels mybmp [90,i] #(fgColor,fgColor)
	fgColorRow = #()
	for i in 1 to 10 do append fgColorRow fgColor
	setpixels mybmp [90,75] fgColorrow
	setpixels mybmp [90,76] fgColorrow
	for i in 1 to 9 do setPixels mybmp [89+i,85-i] #(fgColor,fgColor,fgColor)
	mybmp
)

-- function to set the renderer data

fn setRenderData CW CH DP ALPHA COMPRESS SAVE FNAME =
(
	previousRendSceneState = renderSceneDialog.isopen()
	if renderSceneDialog.isopen() do renderSceneDialog.close()
	renderHeight = CH
	renderWidth = CW
	renderPixelAspect = 1.0
	rendtimeType = 1
	try(
		tif.setDpi DP
		if ALPHA then tif.setAlpha #true else tif.setAlpha #false
		if COMPRESS then tif.setCompression #packbits else tif.setCompression #none
		)
	catch()
	rendSaveFile = SAVE
	rendOutputFileName = FNAME
	if previousRendSceneState do renderSceneDialog.open() 
)

-- function to calculate the settings based on the DPI

fn rcalc fnunit CW CH DP FHL FWL FSS =
( 
	multi = case fnunit.state of 
	( 
		1: 25.4 as float
		2: 1 as float
	)
	CCW = (CW*DP/multi) as integer
	CCH = (CH*DP/multi) as integer
	fsize = (CCH*CCW*3/1024) as integer
	FSS.text = rcalc_txt01 + (fsize as string) + rcalc_txt02
	FHL.value = CCH
	FWL.value = CCW
	if CCW > CCH then rcalc_rollout.rbOrient.state = 2 else rcalc_rollout.rbOrient.state = 1
	if rcalc_rollout.rbOrient.state == 1 then
		(
		try(rcalc_rollout.bmpOrient.bitmap = makePortraitbmp())
		catch()
		)
		else
		(
		try(rcalc_rollout.bmpOrient.bitmap = makeLandscapeBmp())
		catch()
		)
	
)

-- Function to read value (numbers) out of INI files

fn getIniValue iniFile Key Arg =
(
	str = getIniSetting iniFile Key Arg
	if str != "" do readValue (Str as stringStream)
)

-- function to make integers into two digit strings

fn twoDigit i = 
(
	if i < 10 and i >= 0 then ("0" + (i as string)) else (i as string)
)


try(destroyDialog rcalc_rollout) catch()

-- Rollout

rollout rcalc_rollout "Print Size Wizard" width:350 height:310
(
	
	local pName = #(), pWidth = #(), pHeight = #(), pDPI = #(), pUnit = #()
	
	group "Paper Size"
	(
		
		-- List of paper sizes
		
		dropdownlist paper items:#("Custom...") width:120
		
		-- Units definition
		
		label CU "Choose Unit:" align:#left 
		radiobuttons rbUnit labels:#("mm", "inches") align:#left
		
		-- Some typical DPI presets
		
		label CD "Choose DPI Value:" align:#left offset:[0,5]
		button dpi_72 "72 " width:33 align:#left
		button dpi_150 "150" width:33 pos:(dpi_72.pos + [35,0])
		button dpi_300 "300" width:33 pos:(dpi_72.pos + [70,0])
		button dpi_600 "600" width:33 pos:(dpi_72.pos + [105,0])
		
		radiobuttons rbOrient labels:#("Portrait","Landscape") width:140 align:#right offset:[0,-115]
		bitmap bmpOrient width:150 height:100 align:#right checked:true
		
		-- Spinner for the definition of the paper size. They're disabled if you pick a predefined paper size.
		
		spinner spnW "Paper Width: " type:#float range:[0,10000,(((renderwidth as float) /300.0)*25.4)] scale:0.1 fieldwidth:50 offset:[-175,0]
		spinner spnH "Paper Height:" type:#float range:[0,10000,(((renderheight as float) /300.0)*25.4)] scale:0.1 fieldwidth:50 offset:[-175,0]
		spinner DPI "DPI: " type:#integer range:[0,1200,300] fieldwidth:50 offset:[-175,0]
		
		label IS "" align:#right offset:[0,-80]
		spinner spnWL "Image Width:  " type:#integer range:[0,100000,640] align:#right fieldwidth:50 
		spinner spnHL "Image Height: " type:#integer range:[0,100000,480] align:#right fieldwidth:50 
		
		label lbFS "Uncompressed file size:" align:#right offset:[0,2]
	)
	
	group "Rendering"
	(
		checkbox chkSave "Save File"
		button btnSave "Files..." offset:[72,-22] align:#left height:18 width:70
		editText edFname "" enabled:false width:180 align:#right height:16 offset:[0,-22]
		checkbox chkAlpha "Save Alpha Channel" across:2
		checkbox chkCompress "Compress File"
		button btnRender "Render Scene Dialog..." align:#left width:160 -- AB: VIZR change
		button btnQR "Quick Render" offset:[0,-26] width:160 align:#right -- AB: VIZR change
		-- button btnRNR "Region Net Render" align:#right offset:[0,-26] width:106 -- AB: VIZR change
	)

	on btnQR pressed do 
	(	
		setRenderData spnWL.value spnHL.value DPI.value chkAlpha.checked chkCompress.checked chkSave.checked edFname.text
		destroyDialog rcalc_rollout
		max quick render
	)
	
	on btnRender pressed do 
	(
		setRenderData spnWL.value spnHL.value DPI.value chkAlpha.checked chkCompress.checked chkSave.checked edFname.text
		destroyDialog rcalc_rollout
		renderSceneDialog.open()
	)

	-- Portrait and Landscape flip
	
	on rbOrient changed state do
	(
		if rbOrient.state == 1 then			(
			try(bmpOrient.bitmap = makePortraitBmp())
			catch()
			TMP = spnW.value
			spnW.value = spnH.value
			spnH.value = TMP
			rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
			)
			else
			(
			try(bmpOrient.bitmap = makeLandscapeBmp())
			catch()
		 	TMP = spnW.value
			spnW.value = spnH.value
			spnH.value = TMP
			rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
			)
			renderheight = spnHL.value
			renderwidth = spnWL.value

	)

	on spnWL changed val do
	(
		multi = case rbUnit.state of 
				( 
				1: 25.4 as float
				2: 1 as float
				)
		renderwidth = spnWL.value
		spnw.range = [0,10000,(spnWL.value as float )/dpi.value*multi]
		spnh.range = [0,10000,(spnHL.value as float)/dpi.value*multi]
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)

	on spnHL changed val do
	(
		multi = case rbUnit.state of 
				( 
				1: 25.4 as float
				2: 1 as float
				)
		renderheight = spnHL.value
		spnw.range = [0,10000,(spnWL.value as float )/dpi.value*multi]
		spnh.range = [0,10000,(spnHL.value as float)/dpi.value*multi]
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)


	on dpi_72 pressed do 
	(
		dpi.value = 72
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)
	
	on dpi_150 pressed do 
	(
		dpi.value = 150
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)
	
	on dpi_300 pressed do 
	(
		dpi.value = 300
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)
	
	on dpi_600 pressed do 
	(
		dpi.value = 600
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)
	
--   This is where the Paper size dropdownlist is evaluated.
--   Basically, it disables the spinners, and sets the paper size and width, in inches for A-F sizes
--   and mm for A0-A5 sizes. Automatically, it sets a predefined DPI value, so it can reach a moreless
--   optimum value for Ploted output files.

-- These values are read from an external INI file.

	on paper selected i do
	(
		if i == 1 then
		(
			spnW.enabled = spnH.enabled = spnWL.enabled = spnHL.enabled = true
		)
		else
		(
			spnW.enabled = spnH.enabled = spnWL.enabled = spnHL.enabled = false
			if rbOrient.state == 2 then
			(
				spnW.value = pWidth[i-1]
				spnH.value = pHeight[i-1]
			)
			else
			(
				spnH.value = pWidth[i-1]
				spnW.value = pHeight[i-1]
			)
			DPI.value = pDPI[i-1]
			rbUnit.state = pUnit[i-1]
			rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		)
		renderheight = spnHL.value
		renderwidth = spnWL.value

	)

	on rbUnit changed state do 
	(
		multi = case rbUnit.state of 
			( 
			1: 25.4 as float
			2: 1 as float
			)
		spnw.range = [0,10000,(spnWL.value as float)/dpi.value*multi]
		spnh.range = [0,10000,(spnHL.value as float)/dpi.value*multi]
	)
	
	-- spinner changed values triggers
	
	on spnH changed val do 
	(
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderheight = spnHL.value
	)
	
	on spnW changed val do 
	(
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		renderwidth = spnWL.value
	)
	
	on DPI changed val do rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
	
	-- Set the Filename (only TIFF supports DPI information)
	
	on btnSave pressed do
	(
		/* Note to Localization: the following string shows up in the Select File dialog */
	
		fname = getSaveFileName caption:"Select TIFF File" types:"TIFF File (*.tif)|*.tif|"
		if fname != undefined do
		(
			edFname.text = fname
			chkSave.checked = true
			chkSave.enabled = (edFname.text != "")
		)
	)
	
	-- Prepare the UI and load Renderer defaults when open
	
	on rcalc_rollout open do
	(
		if renderSceneDialog.isopen() do
		(
			--renderSceneDialog.commit() line removed because of redundant code :  close already handles this
			renderSceneDialog.close()
		)
		spnWL.value = renderWidth
		spnHL.value = renderHeight
		chkSave.checked = rendSaveFile
		if rendOutputFileName != "" do
			edFname.text = 	(getfilenamePath rendOutputFileName) + \
							(getfilenameFile rendOutputFileName) + ".tif"
		chkSave.enabled = (edFname.text != "")
		try(
			chkAlpha.checked = (tif.getAlpha() == #true)
			chkCompress.checked = (tif.getCompression() == #packbits)
			DPI.value = tif.getDPI()
			)
		catch()
		
		--reads the system units and assigns the right defaults value
		if productAppID != #vizR then
		(
			case units.systemtype of
			(
				#inches:rbUnit.state = 2
				#feet:rbUnit.state = 2
				#miles:rbUnit.state = 2
				
				#millimeters:rbUnit.state = 1
				#centimeters:rbUnit.state = 1
				#meters:rbUnit.state = 1
				#kilometers:rbUnit.state = 1
				default:rbUnit.state = 2
			)
		)
		else rbUnit.state = 2
		
		multi = case rbUnit.state of 
			( 
			1: 25.4 as float
			2: 1 as float
			)
		spnw.range = [0,10000,(spnWL.value as float)/dpi.value*multi]
		spnh.range = [0,10000,(spnHL.value as float)/dpi.value*multi]
		rcalc rbUnit spnW.value spnH.value DPI.value spnHL spnWL lbFS
		
		ddownItems = paper.items

		-- Read INI File
		
		
		nformats = getIniValue printWizIni "General" "NumberOfFormats" -- do not Localize
		
		/* Note to Localization - the following strings are the ones from the list of paper sizes */
		
		if nFormats == undefined do
		(
			PaperFormats = #()
			append PaperFormats #("A - 11x8.5in",2,11,8.5,300)
			append PaperFormats #("B - 17x11in",2,17,11,200)
			append PaperFormats #("C - 22x17in",2,22,17,150)
			append PaperFormats #("D - 34x22in",2,34,22,100)
			append PaperFormats #("E - 44x34in",2,44,34,75)
			append PaperFormats #("A0 - 1189x841mm",1,1189,841,75)
			append PaperFormats #("A1 - 841x594mm",1,841,594,100)
			append PaperFormats #("A2 - 594x420mm",1,594,420,150)
			append PaperFormats #("A3 - 420x297mm",1,420,297,200)
			append PaperFormats #("A4 - 297x210mm",1,297,210,300)
			append PaperFormats #("A5 - 210x148mm",1,210,148,300)
			append PaperFormats #("Letter",2,11,8.5,300)
			append PaperFormats #("Legal",2,14,8.5,300)
			append PaperFormats #("Tabloid",2,17,11,200)

			/* Do NOT Localize START */

			setIniSetting printWizIni "General" "NumberOfFormats" (PaperFormats.count as string)
			setINISetting printWizIni "General" "DialogPos" "[500,210]"

			for i in 1 to PaperFormats.count do
			(
				x = twoDigit i
				setIniSetting printWizIni ("Format" + x) "Name" 	PaperFormats[i][1]
				setIniSetting printWizIni ("Format" + x) "Unit"		(PaperFormats[i][2] as string)
				setIniSetting printWizIni ("Format" + x) "Width"	(PaperFormats[i][3] as string)
				setIniSetting printWizIni ("Format" + x) "Height"	(PaperFormats[i][4] as string)
				setIniSetting printWizIni ("Format" + x) "DPI"		(PaperFormats[i][5] as string)
			)
			nFormats = PaperFormats.count
		)

		for i in 1 to nformats do
		(
			x = twoDigit i
			append pName	(getIniSetting printWizIni ("Format" + x) "Name")
			append ddownItems pname[i]
			append pWidth	(getIniValue printWizIni ("Format" + x)   "Width")
			append pHeight 	(getIniValue printWizIni ("Format" + x)   "Height")
			append pDPI 	(getIniValue printWizIni ("Format" + x)   "DPI")
			append pUnit	(getIniValue printWizIni ("Format" + x)   "Unit")
		)
		
		/* Do NOT Localize END */
		
		paper.items = ddownItems
		
	)
	
	on rcalc_rollout close do
	(
		dialogPos = getDialogPos rcalc_rollout
		setIniSetting printWizIni "General" "DialogPos" (dialogpos as string)
	)

)
--end rollout
dialogPos = execute(getIniSetting printWizIni "General" "DialogPos")
if classof dialogPos == Point2 then
	createDialog rcalc_rollout pos:dialogPos modal:true
	else createDialog rcalc_rollout modal:true
)
--end Macro
