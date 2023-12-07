/*

***************************************************************************
Macro_Scripts File
Author:   Attila Szabo
Macro_Scripts that implement some of the Help menu items

Revision History
    Aug 06, 2003 - aszabo - Created
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		consolidated the hotkey movie macro in this file

	23 march 2006, Pierre-Felix Breton
		added a new "data exchange solutions" menu
		consolidated with the welcome screen

	30th June 2006, Pierre-Felix Breton
		Added a check for 64 bit in the welcome screen to load a different web page
		reduces the margins of the welcome screen
		
	April 2006, Chris Johnson
		Removed activeX controls, and added .NET controls.

-- MODIFY THIS AT YOUR OWN RISK
***************************************************************************

*/



--note: commented out:  no new features guide in 3ds max 9 

--macroScript Help_IntroAndNewFeaturesGuide
--enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
--buttontext:"&New Features Guide..."
--category:"Help" 
--internalCategory:"Help" 
--tooltip:"New Features Guide..." 

/*
(
	local fname = "\\NEWFEATURES.PDF"
	local fpath = getdir #help
	local strErrMsg = "We are unable to display the New Features Guide.\n\nPlease make sure that Adobe Acrobat Reader is properly\ninstalled on your system and then try displaying it again."
	local strMsgTitle = ""
	if (productAPPID == #viz) do 
	(
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do 
	(
		strMsgTitle = "3ds Max"
	)
		
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	
	
	On Execute Do
	(
		try
		(
			if (fpath != undefined) do
			(
				res = ShellLaunch (fpath + fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

*/

MacroScript Help_New_Features_Workshop
enabledIn:#("viz") 
ButtonText:"New Features &Workshop..."
category:"Help" 
internalCategory:"Help" 
Tooltip:"New Features Workshop..." 
(
	fname = "\\viz_nfw.chm"
	fpath = getdir #help
	
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	strMsgTitle = "Autodesk VIZ"
	local strErrMsg = "We are unable to display the New Features Workshop help.\n\nPlease make sure that your help (.chm) viewer is properly\ninstalled on your system and then try displaying it again."
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fpath + fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

MacroScript Help_QuickStart_Guide
enabledIn:#("vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Quick Start Guide"
category:"Help" 
internalCategory:"Help" 
Tooltip:"Quick Start Guide..." 
(
	fname = "\\VIZ_RENDER_QUICK_START_GUIDE.PDF"
	fpath = getdir #help
	
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	
	
	On Execute Do
	(
		try
		(
			if (fpath != undefined) do
			(
				ShellLaunch (fpath + fname) ""
			)
		) 
		catch()
	)
)

macroScript Help_Web_OnlineSupport
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
buttontext:"Online &Support..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Support..." 
(
	local fname = ""
	local strMsgTitle = ""	
	
	if (productAPPID == #vizR) do -- msw 04 Feb 2004: VIZR
	(
		fname = "http://www.autodesk.com/support"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005onlinesupport"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		local fname = "http://www.autodesk.com/3dsmax-support"
		strMsgTitle = "3ds Max"
	)

	local strErrMsg = "We are unable to display the Online Support web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Updates
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&Updates..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Updates..." 
(
	local fname = ""
	local strMsgTitle = ""	

	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005updates"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-updates "
		strMsgTitle = "3ds Max"
	)
	
	local strErrMsg = "We are unable to display the Updates web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Resources
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
buttontext:"&Resources..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Resources..." 
(

	local fname = ""
	local strMsgTitle = ""	
        
    if (productAPPID == #vizR) do -- msw 04 Feb 2004
	(
		fname = "http://www.autodesk.com/us/archdesk/html/adt_plugins/adt_plugins.htm"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005helpmenu"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-resources"
		strMsgTitle = "3ds Max"
	)

	
	local strErrMsg = "We are unable to display the Resources web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Training
enabledIn:#("max") --pfb: 2003.12.12 added product switch
buttontext:"&Training..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Training..." 
(

	local fname = ""
	local strMsgTitle = ""	
        
    if (productAPPID == #vizR) do
	(
		fname = "http://www.autodesk.com/"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do 
	(
		fname = "http://www.autodesk.com/"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do 
	(
		fname = "http://www.autodesk.com/me_training"
		strMsgTitle = "3ds Max"
	)

	
	local strErrMsg = "We are unable to display the Training web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Partners
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&Partners..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Partners..." 
(
	local fname = ""
	
	local strMsgTitle = ""
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz-content"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-developers"
		strMsgTitle = "3ds Max"
	)	
        
	local strErrMsg = "We are unable to display the Partners web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)


macroScript Help_Web_ExchangeSolutions
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&Data Exchange Solutions..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Data Exchange Solutions..." 
(
	local fname = ""
	
	local strMsgTitle = ""
	if (productAPPID == #viz) do --VIZ
	(
		fname = "http://www.autodesk.com/viz-exchange"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- MAX
	(
		fname = "http://www.autodesk.com/max-exchange"
		strMsgTitle = "3ds Max"
	)	
        
	local strErrMsg = "We are unable to display the Data Exchange Solutions web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)


macroScript HotkeyFlash 
enabledIn:#("max") --pfb: 2003.12.12 added product switch, aszabo|feb.06.04|No hotkey map for VIZ
category:"Help" 
internalCategory:"Help"
tooltip:"Hotkey Flash Movie" 
(
--	rollout rHotkeyFlash "Hotkey Map" height: 300 width: 600
--	( 
--		dotNetControl dnWeb "webbrowser" height: 300 width: 600 pos:[1,1,0]
--	 	on rHotkeyFlash open do
--		( 
--			dnWeb.ScrollBarsEnabled = false
--			local page = (getDir #maxroot) + "\\hotkeymap.html"
--			print page
--			h = dotnetobject "System.Uri" page
--			dnWeb.url = h
--		)
--	)
	on execute do
	(
		local page = (getDir #maxroot) + "\\hotkeymap.html"
		ShellLaunch page ""
		--createDialog rHotkeyFlash escapeEnable:false
	)
)


/*
Welcome Screen

Revision History:

March 22 2006; Max 9 Implementation ; Pierre-Felix Breton

Macro file can be shared with all Max based products


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/

---------------------------------------------------------------------------------------------------
/*
Welcome Screen

Shows a resizeable UI displaying html data meant to point new users to what is new, learning tool etc.

Contains "show at startup" flag saved in the 3ds max ini file


--hardcoded dependency on the following folder/files names:

	\html\welcome.screen\index.html
	\html\welcome.screen\index_x64.html


*/
---------------------------------------------------------------------------------------------------


MacroScript WelcomeScreen
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Help" 
internalCategory:"Help" 
tooltip:"Welcome Screen..." 
ButtonText:"Welcome Screen..."
SilentErrors:(Debug != True)
(


	--decalres variables
	local rlt_main
	local rlt_size
	local axMargin
	local ctrlMargin
	local topUIMargin
	local botUIMargin
	local btnWidth
	local btnHeight
	local strWebDocPath
	local strWebDocHomePage 

	
on execute do
	(

	--init variables
	
	rlt_size = point2 580 490
	axMargin = 5
	ctrlMargin = 5
	topUIMargin = 5
	botUIMargin = 30
	btnWidth    = 100
	btnHeight   = 25
	strWebDocPath = (getdir #maxroot + "html\\welcome.screen\\") -- LOC_Notes: do not localize this
	

	--set the home page.  
	strWebDocHomePage = (strWebDocPath + "index.html") -- LOC_Notes: do not localize this

	--check if it a 64 bit application.  In that case, use another webpage
	--that uses less webplugins for improved compatibility with 64 bit browsers
	if (is64bitApplication() == true) do 
	(
		strWebDocHomePage = (strWebDocPath + "index_x64.html") -- LOC_Notes: do not localize this
	)
	
	---------------------------------------------------------------------------------------------------------------
	-- Rollout UI
	---------------------------------------------------------------------------------------------------------------
	
	rollout rlt_main "Welcome Screen" -- LOC_Notes: localize this
	( 
		
		dotNetControl netweb "webbrowser"  \
				pos:[((axMargin/2) as integer) , ((axMargin/2 + topUIMargin) as integer)] \
				width: ((rlt_size.x - axMargin) as integer) \
				height: ((rlt_size.y - axMargin - topUIMargin - botUIMargin) as integer)
	
		--ok cancel help buttons
		button btnCloseDialog "Close" width:btnWidth height:btnHeight \ -- LOC_Notes: localize this
			pos:[(rlt_size.x - ctrlMargin/2 - btnWidth), (rlt_size.y - botUIMargin/2 - btnHeight/2)] \
			enabled:true
			
		--show this at startup
		checkbox chkShowAtStartup "Show this dialog at startup" checked:true \ -- LOC_Notes: localize this
					pos:[(ctrlMargin), (rlt_size.y-botUIMargin/2-btnHeight/2)]



		--//////////////////////////////////////////////////////////////////////////////
	    --Rollout Events
	    --//////////////////////////////////////////////////////////////////////////////
		
		on rlt_main open do
		( 
			--loads the value of the show at startup flag on file from the 3ds max ini file
			local strIniFlag
			strIniFlag = getIniSetting (GetMAXIniFile()) "WelcomeScreen" "ShowAtStartup" --LOC_NOTES: do not localize this
			
			if (strIniFlag == ok) do strIniFlag = "false"
			if strIniFlag == "true" do chkShowAtStartup.checked = true
			if strIniFlag == "false" do chkShowAtStartup.checked = false
	
			--sets the webpage welcome html file
			if (doesFileExist strWebDocHomePage) do 
			(
				netweb.navigate strWebDocHomePage
		)	
	)
		
		on rlt_main resized size do
	(
			-- resize the browser control
			netweb.width  = (size.x - axMargin)
			netweb.height = (size.y - axMargin - topUIMargin - botUIMargin)
			
			--repositions the Set/Cancel buttons
			btnCloseDialog.pos = [(size.x-ctrlMargin/2-btnWidth), (size.y-botUIMargin/2-btnHeight/2)]			
			chkShowAtStartup.pos = [(ctrlMargin/2), (size.y-botUIMargin/2-btnHeight/2)]		
		)
		
		
		
		on btnCloseDialog pressed do
		( 			
			--saves the show me at startup flag
			setIniSetting (GetMAXIniFile()) "WelcomeScreen" "ShowAtStartup" (chkShowAtStartup.checked as string)

			--closes the dialog
			destroyDialog(rlt_main)
)
		
		
	)--end rollout
	
	
	createDialog rlt_main (rlt_size.x as integer) (rlt_size.y as integer) \
	modal:false style:#(#style_resizing, #style_titlebar,  #style_border)


)--end on execute

)--end macro


-- END OF FILE