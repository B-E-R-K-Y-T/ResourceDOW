/*

This utility will allow you to quickly Include or Exclude 
a selection set into a light.

Revision History:

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products



--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

*/
MacroScript Light_Include 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Lights and Cameras" 
internalCategory:"Lights and Cameras" 
tooltip:"Light Include/Exclude Tool"
buttontext:"Light Include/Exclude"
icon:#("Lights",6)
(
	Rollout Incl "Includes / Exludes"
	(
	local curlight
	local ex_names = #()
	local inc_names = #()
	local foo = #()
	fn testLight obj = isproperty obj.baseobject #includelist

	group "Geometry"
	(
		Radiobuttons inc_ex labels:#("Include","Exclude") 
		pickbutton AssignToLight "Assign to Light" filter:testLight 
	)
	Group "List Light Properties"
	(
		label l1 "Current displayed light:" across:2
		label sellight "none"
		pickbutton ViewLightExInc "Choose Light" across:2  filter:testLight 
		button clr "Clear Light" enabled:false
		Radiobuttons ltinex labels:#("Include","Exclude") enabled:false
		listbox lst "Objects" items:#() enabled:false
	)
		Button help "Help"
	
	on help pressed do messagebox "Light Include/Exclude\nThis utility allows you to assign objects to lights in the viewport,\nrather than by choosing a light and selecting an object from a list.\n\n Example:\n 1) Select some geometry.\n 2) Choose Include or Exclude.\n 3) Click the \"Assign to Light\" button.\n 4) Then click the light you want.\n\nThose objects are now Included or Excluded from that light.\n\nLight Properties:\nInside Light properties, you can see the Include/Exclude list\nof any light in the scene. When assigning geometry to a light,\nit displayes that light's list in the listbox.\n\nChoose Light:\nWill allow you to pick another light to view it's include list.\nClear Light:\nWill clear the currently selected light's include list." beep:false
	on AssignToLight picked obj do
	(
		NA =0
		
		objectname = obj.name
		curlight = obj
		
		-- 	CHECK FOR ANY LIGHTS IN SELECTIOIN OF GEOMETRY
		temp = selection as array
		for i = 1 to temp.count do
		(
			temp2 = temp[i]
			if iskindof temp2 light == true then  NA =1
		)
		If NA != 1 then 
		(
			if iskindof obj light == true then
			(
				clr.enabled = true
				foo = selection as array
				if inc_ex.state == 1 then 
				(
					if curlight.includelist != undefined then join foo curlight.includelist
					curlight.includelist = foo 
				)
				else 
				(
					if curlight.excludelist != undefined then join foo curlight.excludelist
					curlight.excludelist = foo
				)
				-- PUT INCLUDE LIST INTO LIST BOX
				if inc_ex.state == 1 then
				(
					if obj.includelist.count > 1 then -- PUT INCLUDE LIST INTO LIST BOX
					(
						temp =#()
						for i = 1 to obj.includelist.count do
						(
							temp[i] = obj.includelist[i].name
						)
						lst.items = temp
						ltinex.state = 1
						ltinex.enabled = true
						lst.enabled = true
					)
					else -- IF OBJECT IS SINGLE DO THIS 
					(
						if obj.includelist[1] != undefined then
						(
							print obj.includelist[1].name
							lst.items = #(obj.includelist[1].name)
							ltinex.state = 1
							ltinex.enabled = true
							lst.enabled = true
						)
						else messagebox "Please select Geometry!"
					)
				)
				Else -- PUT EXCLUSUION LIST INTO LIST BOX
				(
				if obj.excludelist.count > 1 then
					(
						temp =#()
						for i = 1 to obj.excludelist.count do
						(
							temp[i] = obj.excludelist[i].name
						)
						lst.items = temp
						ltinex.state = 2
						ltinex.enabled = true
						lst.enabled = true
					)
					else
					(
						lst.items = #(obj.excludelist[1].name)
						ltinex.state = 2
						ltinex.enabled = true
						lst.enabled = true
					)
				)
				sellight.text = objectname
			)
			else messagebox "Please pick a Light!"
		)	
		Else messagebox "Please pick geometry first, then choose a light to assign it to."
	)
	On ltinex changed state do
	(	if state == 1 and curlight.excludelist != undefined then 
		(
			-- 	SWITCH EXCLUDE TO INCLUDE
			curlight.includelist = curlight.excludelist
		)
		else if curlight.includelist != undefined then 
		(
			-- SWITCH INCLUDE TO EXCLUDE
			curlight.excludelist = 	curlight.includelist
		)
	)
	On clr pressed do
	(
		if ltinex.state == 1 then
			curlight.includelist = #()
		else
			curlight.excludelist = #()
		ex_names = #()
		inc_names = #()
		lst.items = inc_names
	)	
		
	on ViewLightExInc picked obj do
	(
		if iskindof obj light == true then
		(
			sellight.text = obj.name
			curlight = obj
			clr.enabled = true
			ex_names = #()
			inc_names = #()
			ex_list = obj.excludelist 
			inc_list = obj.includelist 
			-- IF EXCLUDE LIST EXISTS DO THESE LINES
			if obj.excludelist != undefined then 
			(
				for i=1 to ex_list.count do
				(
					ex_names[i] = ex_list[i].name
				)
				lst.items = ex_names
				print lst.items
				ltinex.state = 2
				ltinex.enabled = true
				lst.enabled = true
			)
			
			Else if obj.includelist != undefined then 
			(
				for i=1 to inc_list.count do
				(
					inc_names[i] = inc_list[i].name
				)
						
				lst.items = inc_names
				ltinex.state = 1
				ltinex.enabled = true
				lst.enabled = true
			)
		)
		else messagebox "Please pick a light"
			
	)
)
			
Global floatlt
		
if floatLt != undefined then
								(
								closerolloutfloater floatLt
								floatlt = undefined
								)

floatLt = newRolloutFloater "Light Incl/Exl" 250 410 10 170
addRollout Incl floatLt									

)	


