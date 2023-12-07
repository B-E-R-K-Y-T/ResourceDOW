/*
Quad Menu Options Macroscript File

Macro Scripts for Setting Quad Menu Options and colors
Author:   Fred Ruff, John Burnett, Boris Petrov

Revision History:

	2001, created
	
	11 dec 2003, Pierre-Felix Breton, 
    	added product switcher: this macroscript file can be shared with all Discreet products



--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/
--***********************************************************************************************
-- Interface Rollout		
--***********************************************************************************************
macroscript AdvancedQuadOptions
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.11 added product switch
category:"Customize User Interface" 
internalCategory:"Customize User Interface" 
tooltip:"Advanced Quad Option Menu"
buttontext:"Advanced Quad Options"
(
global QMS_AdvancedQuadOptions
	rollout QMS_AdvancedQuadOptions "Advanced Quad Menu Options" width:588 height:410
	(
	local QuadOptionsColorLocks = #("locktback","lockttext","lockback","locktext","lockhtext","lockhback","locklutext","lockdish","lockdiss","lockborder")
	local QuadOptionsUIArray = #(
				#("q1tback","q2tback","q3tback","q4tback"),
				#("q1Ttext","q2Ttext","q3Ttext","q4Ttext"),
				#("q1back","q2back","q3back","q4back"),
				#("q1text","q2text","q3text","q4text"),
				#("q1htext","q2htext","q3htext","q4htext"),
				#("q1hback","q2hback","q3hback","q4hback"),
				#("q1lutext","q2lutext","q3lutext","q4lutext"),
				#("q1dish","q2dish","q3dish","q4dish"),
				#("q1diss","q2diss","q3diss","q4diss"),
				#("q1border","q2border","q3border","q4border")
				)
	local Q1bmp = bitmap 32 32 color:(quadmenusettings.GetTitleBarBackgroundColor 1)
	local Q2bmp = bitmap 32 32 color:(quadmenusettings.GetTitleBarBackgroundColor 2)
	local Q3bmp = bitmap 32 32 color:(quadmenusettings.GetTitleBarBackgroundColor 3)
	local Q4bmp = bitmap 32 32 color:(quadmenusettings.GetTitleBarBackgroundColor 4)
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\		
-- Note to localization.  The following strings are used to diplay the fonts you can choose.
-- The system uses these strings to set the fonts for the quad menus. 
-- See the "Body of main interface reactions" at the bottom of the script to see where this happens
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		
		local fontList = #(
			"",
			"Arial","    Arial Bold","    Arial Bold Italic","    Arial Italic",
			"Arial Black",
			"Comic Sans MS","    Comic Sans MS Bold",
			"Courier New","    Courier New Bold","    Courier New Bold Italic","    Courier New Italic",
			"Georgia","    Georgia Bold","    Georgia Bold Italic","    Georgia Italic",
			"Impact",
			"Lucida Console",
			"Lucida Sans Unicode",
			"Microsoft Sans Serif Regular",
			"Palatino Linotype","    Palatino Linotype Bold","    Palatino Linotype Bold Italic","    Palatino Linotype Italic",
			"Symbol",
			"Tahoma","    Tahoma Bold",
			"Times New Roman","    Times New Roman Bold","    Times New Roman Bold Italic","    Times New Roman Italic",
			"Trebuchet MS","    Trebuchet MS Bold","    Trebuchet MS Bold Italic","    Trebuchet MS Italic",
			"Verdana","    Verdana Bold","    Verdana Bold Italic","    Verdana Italic",
			"Webdings",
			"WingDings"
		)
	local str
	
-- Define the rollout interface
	--Save options
		GroupBox grp7 "Save" pos:[10,10] width:360 height:50
		button LoadQcl "Load" pos:[15,30] width:60 height:20
		button SaveQcl "Save" pos:[83,30] width:60 height:20
		button savestartup "Save As Startup" pos:[160,30] width:90 height:20
		button reset "Reset To Startup" pos:[260,30] width:100 height:20
	-- Quad Position Buttons
		label qposlabel "Starting Quadrant" pos:[37,73] 
		checkButton qpos3 "3" pos:[60,95] width:20 height:20 highlightcolor:(quadmenusettings.GetHighlightedItemBackgroundColor 3)
		checkButton qpos2 "2" pos:[80,95] width:20 height:20 highlightcolor:(quadmenusettings.GetHighlightedItemBackgroundColor 2)
		checkButton qpos1 "1" pos:[80,115] width:20 height:20 highlightcolor:(quadmenusettings.GetHighlightedItemBackgroundColor 1)
		checkButton qpos4 "4" pos:[60,115] width:20 height:20 highlightcolor:(quadmenusettings.GetHighlightedItemBackgroundColor 4)

	--Small quad center samples as bitmaps	
		bitmap Q1bmpUI "Bitmap" pos:[150,98] width:30 height:30 bitmap:q1bmp
		bitmap q2bmpUI "Bitmap" pos:[230,98] width:30 height:30 bitmap:q2bmp
		bitmap q3bmpUI "Bitmap" pos:[279,98] width:30 height:30 bitmap:q3bmp
		bitmap q4bmpUI "Bitmap" pos:[328,98] width:30 height:30 bitmap:q4bmp
		label lbl106 "Quad 1" pos:[146,73] width:40 height:20
		label lbl107 "Quad 2" pos:[225,73] width:40 height:20
		label lbl108 "Quad 3" pos:[275,73] width:40 height:20
		label lbl109 "Quad 4" pos:[325,73] width:40 height:20
	-- Color Titles as labels
		label lbl18 "Title Background" pos:[54,151] width:90 height:20	
		label lbl17 "Title Text" pos:[92,174] width:50 height:20
		label lbl10 "Background" pos:[78,198] width:70 height:20
		label lbl9 "Text" pos:[114,222] width:36 height:20
		label lbl13 "Highlighted Text" pos:[59,246] width:84 height:20 align:#right
		label lbl14 "Highlighted Background" pos:[22,270] width:120 height:20
		label lbl16 "Last Used Text" pos:[63,295] width:77 height:20
		label lbl19 "Disabled Highlight" pos:[49,320] width:91 height:20
		label lbl20 "Disabled Shadow" pos:[52,345] width:92 height:20
		label lbl15 "Border" pos:[103,370] width:36 height:20
	-- Colorpickers
		GroupBox grp11 "Colors" pos:[11,60] width:360 height:340
		colorPicker Q1TBack "" pos:[142,151] width:40 height:20
		colorPicker Q2TBack "" pos:[222,151] width:40 height:20
		colorPicker Q3TBack "" pos:[272,151] width:40 height:20 
		colorPicker Q4TBack "" pos:[322,151] width:40 height:20
		colorPicker Q2TText "" pos:[222,174] width:40 height:20
		colorPicker Q1TText "" pos:[142,174] width:40 height:20
		colorPicker Q3TText "" pos:[272,174] width:40 height:20
		colorPicker Q4TText "" pos:[322,174] width:40 height:20
		colorPicker Q2Back "" pos:[222,198] width:40 height:20
		colorPicker Q1Back "" pos:[142,198] width:40 height:20
		colorPicker Q3Back "" pos:[272,198] width:40 height:20
		colorPicker Q4Back "" pos:[322,198] width:40 height:20
		colorPicker Q2Text "" pos:[222,222] width:40 height:20
		colorPicker Q1Text "" pos:[142,222] width:40 height:20
		colorPicker Q3Text "" pos:[272,222] width:40 height:20
		colorPicker Q4Text "" pos:[322,222] width:40 height:20
		colorPicker Q2Htext "" pos:[222,246] width:40 height:20
		colorPicker Q1HText "" pos:[142,246] width:40 height:20
		colorPicker Q3Htext "" pos:[272,246] width:40 height:20
		colorPicker Q4HText "" pos:[322,246] width:40 height:20
		colorPicker Q2HBack "" pos:[222,270] width:40 height:20
		colorPicker Q1HBack "" pos:[142,270] width:40 height:20
		colorPicker q3hback "" pos:[272,270] width:40 height:20
		colorPicker q4hback "" pos:[322,270] width:40 height:20
		colorPicker q2lutext "" pos:[222,295] width:40 height:20
		colorPicker q1lutext "" pos:[142,295] width:40 height:20
		colorPicker q3lutext "" pos:[272,295] width:40 height:20
		colorPicker q4lutext "" pos:[322,295] width:40 height:20
		colorPicker q2dish "" pos:[222,320] width:40 height:20
		colorPicker q1dish "" pos:[142,320] width:40 height:20
		colorPicker q3dish "" pos:[272,320] width:40 height:20
		colorPicker q4dish "" pos:[322,320] width:40 height:20
		colorPicker q2diss "" pos:[222,345] width:40 height:20
		colorPicker q1diss "" pos:[142,345] width:40 height:20
		colorPicker q3diss "" pos:[272,345] width:40 height:20
		colorPicker q4diss "" pos:[322,345] width:40 height:20
		colorPicker q2border "" pos:[222,370] width:40 height:20
		colorPicker q1border "" pos:[142,370] width:40 height:20
		colorPicker q3border "" pos:[272,370] width:40 height:20
		colorPicker q4border "" pos:[322,370] width:40 height:20
	-- "Lock" Checkboxes
		checkbutton lockTBack "L" pos:[192,151] width:20 height:20 checked:true
		checkbutton LockTText "L" pos:[192,174] width:20 height:20  checked:true
		checkbutton lockback "L" pos:[192,198] width:20 height:20 checked:true
		checkbutton locktext "L" pos:[192,222] width:20 height:20 checked:true
		checkbutton lockhtext "L" pos:[192,246] width:20 height:20 checked:true
		checkbutton lockhback "L" pos:[192,270] width:20 height:20 checked:true
		checkbutton locklutext "L" pos:[192,295] width:20 height:20 checked:true
		checkbutton lockdish "L" pos:[192,320] width:20 height:20 checked:true
		checkbutton lockdiss "L" pos:[192,345] width:20 height:20 checked:true
		checkbutton lockborder "L" pos:[192,370] width:20 height:20 checked:true
	-- Display Options
		GroupBox grp12 "Display" pos:[380,10] width:200 height:110
		checkbox UniformQW "Uniform Quad Width" pos:[390,30] width:160 height:20
		checkbox MirrorQuads "Mirror Quads" pos:[390,50] width:79 height:20
		Spinner VertMargin "Vertical Margins" pos:[481,73] width:62 height:20 type:#integer
		label lbl21 "Opacity Amount:" pos:[411,93] width:79 height:20
		spinner OpacityAmt "" pos:[493,94] width:50 height:16
	-- Positioning Settings
		GroupBox grp13 "Positioning" pos:[380,121] width:200 height:87
		checkbox ReposQuad "Reposition Quad When Off Screen" pos:[390,140] width:185 height:20
		checkbox MoveCursor "Move Cursor When Repositioned" pos:[390,160] width:180 height:20 enabled:true
		checkbox ReturnCursor "Return Cursor After Repositioned" pos:[390,180] width:180 height:18
	-- Fonts and sizes
		GroupBox grp14 "Fonts" pos:[380,209] width:200 height:120
		dropdownList TitleFont "Title Font" pos:[390,227] width:180 height:40 items:fontlist height:5
		label lbl22 "Size:" pos:[485,224] width:30 height:15 
		spinner TitleFontSize "" pos:[517,226] width:50 height:16 type:#Integer range:[1,20,5]
		dropdownList MenuFont "Menu Font" pos:[389,280] width:180 height:40 items:fontlist height:5
		label lbl23 "Size:" pos:[485,279] width:30 height:15
		spinner MenuFontSize "" pos:[516,280] width:50 height:16 type:#Integer range:[1,20,1]
	-- Animation options
		GroupBox grpanim "Animation" pos:[380,330] width:200 height:70
		dropdownList AnimationType "Type" pos:[391,350] width:80 height:40 enabled:true items:#("None","Stretch","Fade")
		spinner steps "" pos:[520,350] width:50 height:16 range:[0,20,5] type:#integer
		spinner speed "" pos:[520,370] width:50 height:16 range:[0,20,5] type:#integer
		label lbl24 "Steps" pos:[480,350] width:30 height:20
		label lbl25 "Pause" pos:[480,370] width:35 height:20
		
--***********************************************************************************************
-- Functions
--***********************************************************************************************

-- Function to update little bitmaps in interface
		fn UpdateBitmaps =
		( -- Create intial Bitmaps
		Q1bmp = bitmap 32 32 color:(quadmenusettings.GetItemBackgroundColor 1)
		Q2bmp = bitmap 32 32 color:(quadmenusettings.GetItemBackgroundColor 2)
		Q3bmp = bitmap 32 32 color:(quadmenusettings.GetItemBackgroundColor 3)
		Q4bmp = bitmap 32 32 color:(quadmenusettings.GetItemBackgroundColor 4)
		
		-- Update Q1
			bmpHline = #()
			for i = 1 to 32 do bmpHline[i] = quadmenusettings.GetBorderColor 1
			setpixels q1bmp [0,16] bmpHline
			bmpVline = #(quadmenusettings.GetBorderColor 1)
			for i = 1 to 32 do setpixels q1bmp [16,i] bmpVline
			bmpFill = #()
			for i = 1 to 15 do bmpFill[i] = quadmenusettings.GetHighlightedItemBackgroundColor 1
			for i = 17 to 32 do setpixels q1bmp [17,i] bmpFill
		-- Update Q2
			bmpHline = #()
			for i = 1 to 32 do bmpHline[i] = quadmenusettings.GetBorderColor 2
			setpixels q2bmp [0,16] bmpHline
			bmpVline = #(quadmenusettings.GetBorderColor 2)
			for i = 1 to 32 do setpixels q2bmp [16,i] bmpVline
			bmpFill = #()
			for i = 1 to 15 do bmpFill[i] = quadmenusettings.GetHighlightedItemBackgroundColor 2
			for i = 0 to 16 do setpixels q2bmp [17,i] bmpFill
		-- Update Q3
			bmpHline = #()
			for i = 1 to 32 do bmpHline[i] = quadmenusettings.GetBorderColor 3
			setpixels q3bmp [0,16] bmpHline
			bmpVline = #(quadmenusettings.GetBorderColor 3)
			for i = 1 to 32 do setpixels q3bmp [16,i] bmpVline
			bmpFill = #()
			for i = 1 to 15 do bmpFill[i] = quadmenusettings.GetHighlightedItemBackgroundColor 3
			for i = 0 to 16 do setpixels q3bmp [0,i] bmpFill
		-- Update Q4
			bmpHline = #()
			for i = 1 to 32 do bmpHline[i] = quadmenusettings.GetBorderColor 4
			setpixels q4bmp [0,16] bmpHline
			bmpVline = #(quadmenusettings.GetBorderColor 4)
			for i = 1 to 32 do setpixels q4bmp [16,i] bmpVline
			bmpFill = #()
			for i = 1 to 15 do bmpFill[i] = quadmenusettings.GetHighlightedItemBackgroundColor 4
			for i = 16 to 32 do setpixels q4bmp [0,i] bmpFill
		--Redraw all UI items
			q1bmpUI.bitmap = q1bmp
			q2bmpUI.bitmap = q2bmp
			q3bmpUI.bitmap = q3bmp
			q4bmpUI.bitmap = q4bmp
		)

-- Function to Strip out extra spaces in a string
		fn StripSpaces aString = 
		(
			local strAr = filterString aString " "
			local newStr = ""
			for str in strAr do newStr += (str + " ")
			subString newStr 1 (newStr.count-1)
		)
-- Function to check colors and set the interface locks
		fn SetLocks =
		(
			QMS = quadmenusettings
			if (QMS.GetTitleBarBackgroundColor 1)==(QMS.GetTitleBarBackgroundColor 2)and(QMS.GetTitleBarBackgroundColor 1)==(QMS.GetTitleBarBackgroundColor 3)and(QMS.GetTitleBarBackgroundColor 1)==(QMS.GetTitleBarBackgroundColor 4)then locktback.checked = true
			else locktback.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
			
			if (QMS.GetItemBackgroundColor 1)==(QMS.GetItemBackgroundColor 2)and(QMS.GetItemBackgroundColor 1)==(QMS.GetItemBackgroundColor 3)and(QMS.GetItemBackgroundColor 1)==(QMS.GetItemBackgroundColor 4) then lockback.checked = true
			else lockback.checked = false
			
			if (QMS.GetItemTextColor 1)==(QMS.GetItemTextColor 2)and(QMS.GetItemTextColor 1)==(QMS.GetItemTextColor 3)and(QMS.GetItemTextColor 1)==(QMS.GetItemTextColor 4) then locktext.checked = true
			else locktext.checked = false
			
			if (QMS.GetHighlightedItemTextColor 1)==(QMS.GetHighlightedItemTextColor 2)and(QMS.GetHighlightedItemTextColor 1)==(QMS.GetHighlightedItemTextColor 3)and(QMS.GetHighlightedItemTextColor 1)==(QMS.GetHighlightedItemTextColor 4) then lockhtext.checked = true
			else lockhtext.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
			
			if (QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 2)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 3)and(QMS.GetTitleBarTextColor 1)==(QMS.GetTitleBarTextColor 4) then lockttext.checked = true
			else lockttext.checked = false
		)

-- Function for setting all colorpicker colors to match current quad settings
		fn InitalizeColorPickers =
		(
			
			-- Set Start Position checkboxes
			local xpos= quadmenusettings.GetInitialCursorLocXInBox_0to1()
			local ypos= quadmenusettings.GetInitialCursorLocYInBox_0to1()
			--print  xpos;--print ypos
			if xpos > 0 and ypos > 0 do QMS_AdvancedQuadOptions.qpos1.checked = true
			--else (qpos2.checked = false; qpos3.checked = false; qpos4.checked = false)
		
			if xpos > 0 and ypos < 0 do QMS_AdvancedQuadOptions.qpos2.checked = true
			--else (qpos1.checked = false; qpos3.checked = false; qpos4.checked = false)
			
			if xpos < 0 and ypos < 0 do QMS_AdvancedQuadOptions.qpos3.checked = true
			--else (qpos1.checked = false; qpos2.checked = false; qpos4.checked = false)

			if xpos < 0 and ypos > 0 do QMS_AdvancedQuadOptions.qpos4.checked = true
			--else (qpos1.checked = false; qpos2.checked = false; qpos3.checked = false)
	
			-- Set all checkboxes and spinners to current states
			UniformQW.state = quadmenusettings.GetUseUniformQuadWidth()
			VertMargin.value = quadmenusettings.GetVerticalMarginInPoints()
			MirrorQuads.state = quadmenusettings.GetMirrorQuad()
			OpacityAmt.value = (quadmenusettings.GetOpacity() *100)
			
			ReposQuad.state = quadmenusettings.GetRepositionWhenClipped()
			MoveCursor.state = quadmenusettings.GetMoveCursorOnReposition()
			MoveCursor.enabled = ReposQuad.state
			ReturnCursor.state = quadmenusettings.GetReturnCursorAfterReposition()
			ReturnCursor.enabled = MoveCursor.state
			
			TitleFont.selected = quadmenusettings.GetTitleFontFace()
			MenuFont.selected = quadmenusettings.GetItemFontFace()
			TitleFontSize.value = quadmenusettings.GetTitleFontSize()
			MenuFontSize.value = quadmenusettings.GetItemFontSize()
			AnimationType.selection = (quadmenusettings.GetDisplayMethod()+1)
			Steps.value = quadmenusettings.GetAnimatedSteps()
			Speed.value = quadmenusettings.GetAnimatedStepTime()
			-- Set all color pickers
			q1tback.color = quadmenusettings.GetTitleBarBackgroundColor 1
			q2tback.color = quadmenusettings.GetTitleBarBackgroundColor 2
			q3tback.color = quadmenusettings.GetTitleBarBackgroundColor 3
			q4tback.color = quadmenusettings.GetTitleBarBackgroundColor 4
			
			q1ttext.color = quadmenusettings.GetTitleBarTextColor 1
			q2ttext.color = quadmenusettings.GetTitleBarTextColor 2
			q3ttext.color = quadmenusettings.GetTitleBarTextColor 3
			q4ttext.color = quadmenusettings.GetTitleBarTextColor 4
			
			q1back.color = quadmenusettings.GetItemBackgroundColor 1
			q2back.color = quadmenusettings.GetItemBackgroundColor 2
			q3back.color = quadmenusettings.GetItemBackgroundColor 3
			q4back.color = quadmenusettings.GetItemBackgroundColor 4
		
			q1text.color = quadmenusettings.GetItemTextColor 1
			q2text.color = quadmenusettings.GetItemTextColor 2
			q3text.color = quadmenusettings.GetItemTextColor 3
			q4text.color = quadmenusettings.GetItemTextColor 4
			
			q1htext.color = quadmenusettings.GetHighlightedItemTextColor 1
			q2htext.color = quadmenusettings.GetHighlightedItemTextColor 2
			q3htext.color = quadmenusettings.GetHighlightedItemTextColor 3
			q4htext.color = quadmenusettings.GetHighlightedItemTextColor 4
		
			q1hback.color = quadmenusettings.GetHighlightedItemBackgroundColor 1
			q2hback.color = quadmenusettings.GetHighlightedItemBackgroundColor 2
			q3hback.color = quadmenusettings.GetHighlightedItemBackgroundColor 3
			q4hback.color = quadmenusettings.GetHighlightedItemBackgroundColor 4
			
			q1lutext.color = quadmenusettings.GetLastExecutedItemTextColor 1
			q2lutext.color = quadmenusettings.GetLastExecutedItemTextColor 2
			q3lutext.color = quadmenusettings.GetLastExecutedItemTextColor 3
			q4lutext.color = quadmenusettings.GetLastExecutedItemTextColor 4
		
			q1dish.color = quadmenusettings.GetDisabledHighlightColor 1
			q2dish.color = quadmenusettings.GetDisabledHighlightColor 2
			q3dish.color = quadmenusettings.GetDisabledHighlightColor 3
			q4dish.color = quadmenusettings.GetDisabledHighlightColor 4	
		
			q1diss.color = quadmenusettings.GetDisabledShadowColor 1
			q2diss.color = quadmenusettings.GetDisabledShadowColor 2
			q3diss.color = quadmenusettings.GetDisabledShadowColor 3
			q4diss.color = quadmenusettings.GetDisabledShadowColor 4	
			
			q1border.color = quadmenusettings.GetborderColor 1
			q2border.color = quadmenusettings.GetborderColor 2
			q3border.color = quadmenusettings.GetborderColor 3
			q4border.color = quadmenusettings.GetborderColor 4
		)
	
	-- Function to update all the quad settings at once. Called everytime you adjust a UI widjet
		fn UpdateAllQuadColors =
		(
			 quadmenusettings.SetTitleBarBackgroundColor 1 q1tback.color
			 quadmenusettings.SetTitleBarBackgroundColor 2 q2tback.color
			 quadmenusettings.SetTitleBarBackgroundColor 3 q3tback.color
			 quadmenusettings.SetTitleBarBackgroundColor 4 q4tback.color
			
			 quadmenusettings.SetTitleBarTextColor 1 q1ttext.color
			 quadmenusettings.SetTitleBarTextColor 2 q2ttext.color
			 quadmenusettings.SetTitleBarTextColor 3 q3ttext.color
			 quadmenusettings.SetTitleBarTextColor 4 q4ttext.color
				
			 quadmenusettings.SetItemBackgroundColor 1 q1back.color
			 quadmenusettings.SetItemBackgroundColor 2 q2back.color
			 quadmenusettings.SetItemBackgroundColor 3 q3back.color
			 quadmenusettings.SetItemBackgroundColor 4 q4back.color
		
			quadmenusettings.SetItemTextColor 1 q1text.color
			quadmenusettings.SetItemTextColor 2	q2text.color
			quadmenusettings.SetItemTextColor 3	q3text.color
			quadmenusettings.SetItemTextColor 4	q4text.color
				
			quadmenusettings.SetHighlightedItemTextColor 1 q1htext.color 
			quadmenusettings.SetHighlightedItemTextColor 2 q2htext.color 
			quadmenusettings.SetHighlightedItemTextColor 3 q3htext.color
			quadmenusettings.SetHighlightedItemTextColor 4 q4htext.color
		
			quadmenusettings.SetHighlightedItemBackgroundColor 1 q1hback.color
			quadmenusettings.SetHighlightedItemBackgroundColor 2 q2hback.color
			quadmenusettings.SetHighlightedItemBackgroundColor 3 q3hback.color
		 	quadmenusettings.SetHighlightedItemBackgroundColor 4 q4hback.color
			 
			quadmenusettings.SetLastExecutedItemTextColor 1 q1lutext.color
			quadmenusettings.SetLastExecutedItemTextColor 2 q2lutext.color
			quadmenusettings.SetLastExecutedItemTextColor 3 q3lutext.color
		 	quadmenusettings.SetLastExecutedItemTextColor 4	q4lutext.color
		
			 quadmenusettings.SetDisabledHighlightColor 1 q1dish.color
			 quadmenusettings.SetDisabledHighlightColor 2 q2dish.color
			 quadmenusettings.SetDisabledHighlightColor 3 q3dish.color
			 quadmenusettings.SetDisabledHighlightColor 4 q4dish.color
		
			quadmenusettings.SetDisabledShadowColor 1 q1diss.color 
			quadmenusettings.SetDisabledShadowColor 2 q2diss.color
			quadmenusettings.SetDisabledShadowColor 3 q3diss.color
			quadmenusettings.SetDisabledShadowColor 4 q4diss.color	
			
			quadmenusettings.SetborderColor 1 q1border.color
			quadmenusettings.SetborderColor 2 q2border.color
			quadmenusettings.SetborderColor 3 q3border.color
			quadmenusettings.SetborderColor 4 q4border.color
		)
-- Function to change the interface colors with respect to the lock status
		fn UpdateColorPicker QuadNum ItemName Lock=
		(
			numquad = QuadNum
			local str = ""
			local val = FindItem QuadOptionsColorLocks ItemName
			if lock == true then 
			(
				for i = 1 to 4 do 
				(
					Try
					(
						str =  "QMS_AdvancedQuadOptions." +QuadOptionsUIArray[val][i]+".color = QMS_AdvancedQuadOptions."+QuadOptionsUIArray[val][numQuad]+".color\n"
						execute str
					)
					Catch()
				)
			)
			else 
			(
				Try
				(
					str = "QMS_AdvancedQuadOptions."+ QuadOptionsUIArray[val][numQuad]+".color = QMS_AdvancedQuadOptions."+QuadOptionsUIArray[val][numQuad]+".color\n"
					execute str
				)
				Catch()
			)
			UpdateAllQuadColors()
			UpdateBitmaps()
		)

--***********************************************************************************************
-- Body of main interface reactions
--***********************************************************************************************
		on Loadqcl pressed do 
		(
			QclFileName = getOpenFilename caption:"Load Quad Options" types:"Quad Options File(*.qop)|*.qop|"
			try (filein (QclFilename)) Catch ()
			InitalizeColorPickers()
			SetLocks()
			UpdateBitmaps()
		)
		on Saveqcl pressed do
		(
			Try 
			(
				qopFileName = getSaveFilename caption:"Save Quad Colors" types:"Quad Color File(*.qop)|*.qop|"
				local qopPath = getfilenamepath qopFileName
				local qopFile = getfilenamefile qopFileName
				SaveQuadClr qopPath qopFile ".qop" "Advanced Quad Options Save Command"
			)
			Catch ()
		)
		on savestartup pressed do 
		(
		if (querybox  "Are you sure?" Title:"Save as Startup") == true do 
			(
			local startuppath = "$userStartupScripts\\"
			local startupname = "QuadColor_Startup"
			SaveQuadClr  startuppath startupname ".ms" "Advanced Quad Options Save Startup Command"
			)
		)
		on reset pressed do
		(	
		local str = "$userStartupScripts\\QuadColor_Startup.ms"
		--print str
			Try fileIn str
			Catch (messagebox "No Startup File Found." title:"Warning")
			InitalizeColorPickers();UpdateBitmaps()
		)
		on qpos1 changed state do if state == true do 
		(
		qpos2.checked = false; qpos3.checked = false; qpos4.checked = false
		quadmenusettings.SetInitialCursorLocInBox_0to1 .5 .5
		)
		on qpos2 changed state do if state == true do 
		(
		qpos1.checked = false; qpos3.checked = false; qpos4.checked = false
		quadmenusettings.SetInitialCursorLocInBox_0to1 .5 -.5
		)
		on qpos3 changed state do if state == true do 
		(
		qpos1.checked = false; qpos2.checked = false; qpos4.checked = false
		quadmenusettings.SetInitialCursorLocInBox_0to1 -.5 -.5
		)
		on qpos4 changed state do if state == true do 
		(
		qpos1.checked = false; qpos2.checked = false; qpos3.checked = false
		quadmenusettings.SetInitialCursorLocInBox_0to1 -.5 .5
		)
		
		On UniformQW changed state do quadmenusettings.SetUseUniformQuadWidth UniformQW.state
		On VertMargin changed value do quadmenusettings.SetVerticalMarginInPoints VertMargin.value
		on MirrorQuads changed state do quadmenusettings.SetMirrorQuad MirrorQuads.state
		on OpacityAmt changed value do quadmenusettings.SetOpacity (OpacityAmt.value *.01)
		
		on ReposQuad changed state do 
		(
		quadmenusettings.SetRepositionWhenClipped ReposQuad.state
		MoveCursor.enabled = ReposQuad.state
		)
		on MoveCursor changed state do 
		(
		quadmenusettings.SetMoveCursorOnReposition MoveCursor.state
		ReturnCursor.enabled = MoveCursor.state
		)
		on ReturnCursor changed state do quadmenusettings.SetReturnCursorAfterReposition MoveCursor.state
		
		on TitleFont selected TFont do quadmenusettings.SetTitleFontFace (StripSpaces (FontList[TFont]))
		on MenuFont selected MFont do quadmenusettings.SetItemFontFace (StripSpaces (FontList[MFont]))
		on TitleFontSize changed value do quadmenusettings.SetTitleFontSize value
		on MenuFontSize changed value do quadmenusettings.SetItemFontSize value
		
		on AnimationType selected Type do quadmenusettings.SetDisplayMethod (Type-1)
		on Steps changed value do quadmenusettings.SetAnimatedSteps Value
		on Speed changed value do quadmenusettings.SetAnimatedStepTime Value
		
		on q1tback changed color do UpdateColorPicker 1 "locktback" locktback.checked
		on q2tback changed color do UpdateColorPicker 2 "locktback" locktback.checked
		on q3tback changed color do UpdateColorPicker 3 "locktback" locktback.checked
		on q4tback changed color do UpdateColorPicker 4 "locktback" locktback.checked
		on locktback changed state do UpdateColorPicker 1 "locktback" locktback.checked
		
		on q1TText changed color do UpdateColorPicker 1 "lockttext" lockTText.checked
		on q2TText changed color do UpdateColorPicker 2 "lockttext" lockTText.checked
		on q3TText changed color do UpdateColorPicker 3 "lockttext" lockTText.checked
		on q4TText changed color do UpdateColorPicker 4 "lockttext" lockTText.checked
		on lockTText changed state do UpdateColorPicker 1 "lockttext" lockTText.checked
			
		on q1back changed color do UpdateColorPicker 1 "lockback" lockback.checked
		on q2back changed color do UpdateColorPicker 2 "lockback" lockback.checked
		on q3back changed color do UpdateColorPicker 3 "lockback" lockback.checked
		on q4back changed color do UpdateColorPicker 4 "lockback" lockback.checked
		on lockback changed state do UpdateColorPicker 1 "lockback" lockback.checked
				
		on q1text changed color do UpdateColorPicker 1 "locktext" locktext.checked
		on q2text changed color do UpdateColorPicker 2 "locktext" locktext.checked
		on q3text changed color do UpdateColorPicker 3 "locktext" locktext.checked
		on q4text changed color do UpdateColorPicker 4 "locktext" locktext.checked
		on locktext changed state do UpdateColorPicker 1 "locktext" locktext.checked
		
		on q1htext changed color do UpdateColorPicker 1 "lockhtext" lockhtext.checked
		on q2htext changed color do UpdateColorPicker 2 "lockhtext" lockhtext.checked
		on q3htext changed color do UpdateColorPicker 3 "lockhtext" lockhtext.checked
		on q4htext changed color do UpdateColorPicker 4 "lockhtext" lockhtext.checked
		on lockhtext changed state do UpdateColorPicker 1 "lockhtext" lockhtext.checked
				
		on q1hback changed color do UpdateColorPicker 1 "lockhback" lockhback.checked
		on q2hback changed color do UpdateColorPicker 2 "lockhback" lockhback.checked
		on q3hback changed color do UpdateColorPicker 3 "lockhback" lockhback.checked
		on q4hback changed color do UpdateColorPicker 4 "lockhback" lockhback.checked
		on lockhback changed state do UpdateColorPicker 1 "lockhback" lockhback.checked
		
		on q1lutext changed color do UpdateColorPicker 1 "locklutext" locklutext.checked
		on q2lutext changed color do UpdateColorPicker 2 "locklutext" locklutext.checked
		on q3lutext changed color do UpdateColorPicker 3 "locklutext" locklutext.checked
		on q4lutext changed color do UpdateColorPicker 4 "locklutext" locklutext.checked
		on locklutext changed state do UpdateColorPicker 1 "locklutext" locklutext.checked
		
		on q1dish changed color do UpdateColorPicker 1 "lockdish" lockdish.checked
		on q2dish changed color do UpdateColorPicker 2 "lockdish" lockdish.checked
		on q3dish changed color do UpdateColorPicker 3 "lockdish" lockdish.checked
		on q4dish changed color do UpdateColorPicker 4 "lockdish" lockdish.checked
		on lockdish changed state do UpdateColorPicker 1 "lockdish" lockdish.checked
		
		on q1diss changed color do UpdateColorPicker 1 "lockdiss" lockdiss.checked
		on q2diss changed color do UpdateColorPicker 2 "lockdiss" lockdiss.checked
		on q3diss changed color do UpdateColorPicker 3 "lockdiss" lockdiss.checked
		on q4diss changed color do UpdateColorPicker 4 "lockdiss" lockdisse.checked
		on lockdish changed state do UpdateColorPicker 1 "lockdish" lockdiss.checked
		
		on q1border changed color do UpdateColorPicker 1 "lockborder" lockborder.checked
		on q2border changed color do UpdateColorPicker 2 "lockborder" lockborder.checked
		on q3border changed color do UpdateColorPicker 3 "lockborder" lockborder.checked
		on q4border changed color do UpdateColorPicker 4 "lockborder" lockborder.checked
		on lockborder changed state do UpdateColorPicker 1 "lockborder" lockdiss.checked
		
		-- Call update function on startup
		on QMS_AdvancedQuadOptions open do 
		(	

			InitalizeColorPickers()
			SetLocks()
			UpdateBitmaps()
		)
	)
	CreateDialog QMS_AdvancedQuadOptions width:595 height:405
)