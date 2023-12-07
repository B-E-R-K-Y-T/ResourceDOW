-- MacroScript File
-- Created:       Jan 15 2002
-- Last Modified: May 05 2007
-- Light Lister Script 2.8
-- Version: 3ds max 6
-- Author: Alexander Esppeschit Bicalho [discreet]
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

/* History
- added support for mr_Sky, mr_SkyPortal, and mr_Sun (LAM)
- fixed mentalray shadow map list bug by zhangy
- Added product switcher: this macro file can be shared with all Discreet products
- Added Support to Mental Ray Lights and Plugin Script lights - this uses 4 functions to manage Delegate properties
- Added Support to Blur_Adv. Shadows and mental Ray shadows
- Enabled Luminaire support
- Enabled Deletion Callback
- Removed Blur Adv. Shadows from the UI (they're still in the Engine) since PF's spec calls for that
- Fixed divide by 0 on adding mr lights to the list
- Fixed an incorrect try/catch loop that would crash the script when radiosity was present
- Fixed crash on Refresh after deleting light - LLister.UIControlList not reset, contained deleted node (LAM)
- Added support for MultiProduct (IFDEFs for #VIZR) (AB)
- Added support to Global Shadow Generator - when a Global Shadow Generator is changed, the Refresh button is 
  highlighted to warn the user he needs a refresh
- Fixed problem when launching the Light Lister when lights have manipulators enabled
- Added LineOffset and YOffset to help Japanese/Chinese localization
*/

/*

macros.run "Lights and Cameras" "Light_list"

This Light Lister supports all new lights in 3ds max 5:

- Photometric Lights
- Skylights
- IES Sun

It also supports the new shadows types:

- Area Shadows
- Adv. Raytraced shadows

*/

/* Expanding the Light Lister -- AB Jun 20, 2002

This Light Lister does not automatically support new light or shadow plugins.

For them to be supported, you need to make several changes in the script:

-- Class Definitions

Here the classes for each light types are defined. If you want to add a new light type, add a new class entry and list the
classes in the array
In the end of the script, each class definition is scanned and generates the UI entries.
You'll also need to change the script to parse and collect all instances of your class, as is done with the current code.

-- Properties

The function CreateControls generates the dynamic rollout containing all spinners, properties, etc. 
The controls are grouped by light type and handle special cases like different parameter names for MAX lights and Photometric
lights. The On/Off checkbox is an example of how to handle a control that is tied to a property in a scene light. 
In the example below, ControlName is the control name and Property is the property you want to expose/access.

	LLister.maxLightsRC.addControl #checkbox (("ControlName" + LLister.count as string) as name) "" \
		paramStr:("checked:" + (LLister.LightIndex[LLister.count][1].Property as string) + " offset:[8,-22] width:18")
	LLister.maxLightsRC.addHandler (("ControlName" + LLister.count as string) as name) #'changed state' filter:on \
		codeStr:("LLister.LightIndex[" + LLister.count as string + "][1].Property = state")

Notice the controls are all aligned using Offset. If you add a new control, you need to reorganize the remaining controls.

-- Exposing Shadow Plugins

Shadow plugins are harder to expose because each shadow has a different set of parameters, or even different parameter
names. The framework to expose them is similar to the one to expose the properties, but you need to create special cases
for each shadowplugin or each property.
For instance, if your shadow plugin class is myShadow and it exposes a Bias Property called myShadowBias, you'll need to
change the Bias Control and the Shadow Dropdown. In the Bias Control, you need to read the Bias value, and change the  
event so it checks for the correct class and sets the property.
In the Shadow Dropdown event, you need to set the control state and value acording to the shadow class.

In any case, make sure you keep a copy of the original Light Lister so you can come back to it in case you have problems

*/

macroScript Light_List
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
category:"Lights and Cameras" 
internalCategory:"Lights and Cameras" 
ButtonText:"Light Lister..."
tooltip:"Light Lister..." 
Icon:#("Lights",7)
SilentErrors:(Debug != True)
(

struct LightListerStruct (GlobalLightParameters, LightInspectorSetup, LightInspectorFloater, LightInspectorListRollout, ShadowPlugins, \
							ShadowPluginsName, maxLightsList, LSLightsList, SkyLightsList, SunLightsList, enableUIElements, \
							LuminairesList, maxLightsRC, CreateLightRollout, UIControlList, DeleteCallback, disableUIElements, \
							LightInspectorListRollout, LLUndoStr, count, lbcount, lightIndex, decayStrings, totalLightCount, \
							miLightsList, getLightProp, setLightProp, setShdProp, getShdProp, fnShadowClass, enableRefreshBtn, \
							mrSkyLightsList, mrSunLightsList, mrSkyPortalLightsList, MRSkyPortal_ShadowSamples, MRSkyPortal_Modes, \
							yOffset, LineOffset)

global LLister, LListerYOffset
if LLister == undefined or debug == true do LLister = LightListerStruct()

-- Strings for Localization

LLister.decayStrings = #("None","Inverse","Inv. Square")
LLister.LLUndoStr = "LightLister"

local dialogUp = false

-- End Strings

-- Positioning to help localization

LListerYOffset = 0
LLister.yOffset = LListerYOffset
LLister.LineOffset = 0
 
-- Useful Functions

fn subtractFromArray myArray mySub =
(
	tmpArray = #()
	for i in myArray do append tmpArray i
	for i in mySub do


	(
		itemNo = finditem tmpArray i
		local newArray = #()
		if itemNo != 0 do
		(
			for j in 1 to (itemNo-1) do append newArray tmpArray[j]
			for j in (itemNo+1) to tmpArray.count do append newArray tmpArray[j]
			tmpArray = newArray
		)
	)
	tmpArray
)

fn SortNodeArrayByName myArray =
(
qsort myArray (fn myname v1 v2 = (if v1.name < v2.name then 0 else 1))
myArray
)

fn copyArray array1 = for i in array1 collect i

fn disableUIElements array1 = for i in array1 do execute ("maxLightsRollout." + i as string + ".enabled = false")
LLister.disableUIElements = disableUIElements

fn enableRefreshBtn lightobj =
(
	if (LLister.GetLightProp lightObj #useGlobalShadowSettings) == true do
	(
		LLister.LightInspectorSetup.BtnReload.Checked = true
	)
)
LLister.enableRefreshBtn = enableRefreshBtn

fn getLightProp obj prop =
(
	if (isProperty obj prop) and not (isProperty obj #delegate) then
		getProperty obj prop
	else 
		if isProperty obj #delegate then 
			if isProperty obj.delegate prop then
				getProperty obj.delegate prop
			else undefined
		else undefined
)
LLister.getLightProp = getLightProp

fn setLightProp obj prop val =
(
	if (isProperty obj prop) and not (isProperty obj #delegate) then
		setProperty obj prop val
	else
		if isProperty obj #delegate then 
			if isProperty obj.delegate prop then
				setProperty obj.delegate prop val
			else undefined
		else undefined
)
LLister.setLightProp = setLightProp

fn getShdProp obj prop =
(
	if (isProperty obj #shadowGenerator) and not (isProperty obj #delegate) then
		if (isProperty obj.ShadowGenerator prop) do getProperty obj.ShadowGenerator prop
	else 
		if isProperty obj #delegate then 
			if isProperty obj.delegate #ShadowGenerator then
				if (isProperty obj.delegate.ShadowGenerator prop) do getProperty obj.delegate.ShadowGenerator prop
			else undefined
		else undefined
)
LLister.getShdProp = getShdProp

fn setShdProp obj prop val =
(
	if (isProperty obj #shadowGenerator) and not (isProperty obj #delegate) then
		if (isProperty obj.ShadowGenerator prop) do
		(
			setProperty obj.ShadowGenerator prop val
			LLister.enableRefreshBtn obj
		)
	else 
		if isProperty obj #delegate then 
			if isProperty obj.delegate #ShadowGenerator then
				if (isProperty obj.delegate.ShadowGenerator prop) do
				(
					setProperty obj.delegate.ShadowGenerator prop val
					LLister.enableRefreshBtn obj
				)
			else undefined
		else undefined
)
LLister.setShdProp = setShdProp

fn fnShadowClass obj = classof (LLister.getLightProp obj #shadowGenerator)
LLister.fnShadowClass = fnShadowClass

-- Collect Shadow Plugins

/* -- Removed Automatic Shadow Plugin Collection

LLister.ShadowPlugins = (subtractFromArray shadow.classes #(Missing_Shadow_Type))
qSort LLister.ShadowPlugins (fn namesort v1 v2 = if ((v1 as string)as name) > ((v2 as string)as name) then 1 else 0)
LLister.ShadowPluginsName = for i in LLister.ShadowPlugins collect i as string

*/

-- Hardcoded shadow plugins to the ones available

	LLister.ShadowPlugins = #(Adv__Ray_Traced, mental_ray_Shadow_Map, Area_Shadows, shadowMap, raytraceShadow)
	LLister.ShadowPluginsName = #("Adv. Ray Traced", "mental_ray_Shadow_Map", "Area Shadows", "Shadow Map", "Raytrace Shadow")

/* -- uncomment if you want the Blur Shadows
LLister.ShadowPlugins = #(Adv__Ray_Traced, mental_ray_Shadow_Map, Area_Shadows, Blur_Adv__Ray_Traced, shadowMap, raytraceShadow)
LLister.ShadowPluginsName = #("Adv. Ray Traced", "mental_ray_Shadow_Map", "Area Shadows", "Blur Adv. Ray Traced","Shadow Map", "Raytrace Shadow")
*/
	LLister.MRSkyPortal_ShadowSamples = for i = 1 to 10 collect (2^i) as string
	LLister.MRSkyPortal_Modes = #("Existing", "Envir.", "Custom") -- correspond to mode values of 2, 0, 1

-- Main Function

local CreateLightRollout

fn createLightRollout myCollection selectionOnly:false =
(
	LLister.LightInspectorSetup.pbar.visible = true

	-- Class Definitions
	
	maxLights = #(#TargetDirectionallight, #targetSpot, #Directionallight, #Omnilight, #freeSpot)
	SkyLights = #(#IES_Sky, #Texture_Sky, #Skylight)
	SunLights = #(#IES_Sun) -- AB: Jun 20, 2002
	LSLights = #(#Free_Area, #Target_Area, #Free_Linear, #Free_Point, #Target_Point, #Target_Linear)
	Luminaires = #(#Luminaire)
	mrLights = #(#miAreaLight, #miAreaLightomni)
	mrSkyLight = #(#mr_sky)
	mrSunLight = #(#mr_sun)
	mrSkyPortalLight = #(#mr_sky_portal)
	
	-- Scene parser
	
	SceneLights = MyCollection as array
	sceneMaxLights = #()
	sceneLSLights = #()
	sceneSkyLights = #()
	sceneSunLights = #()
	sceneLuminaires = #()
	scenemiLights = #()
	scenemrSkyLights = #()
	scenemrSunLights = #()
	scenemrSkyPortalLights = #()
	
	for i in SceneLights do
	(
		LightClass = ((classof i) as string) as name
		if findItem MaxLights LightClass != 0 do append sceneMaxLights i
		if findItem LSLights LightClass != 0 do append sceneLSLights i
		if findItem SkyLights LightClass != 0 do append sceneSkyLights i
		if findItem SunLights LightClass != 0 do append sceneSunLights i
		if findItem Luminaires LightClass != 0 do append sceneLuminaires i
		if findItem mrLights LightClass != 0 do append scenemiLights i
		if findItem mrSkyLight LightClass != 0 do append scenemrSkyLights i
		if findItem mrSunLight LightClass != 0 do append scenemrSunLights i
		if findItem mrSkyPortalLight LightClass != 0 do append scenemrSkyPortalLights i
	)
	
	-- Collect Light Instances and build array to be displayed
	
	tmpParser = #( \
		tmpsceneMaxLights = copyArray sceneMaxLights, \
		tmpscenemiLights = copyArray scenemiLights, \
		tmpscenemrSkyLights = copyArray scenemrSkyLights, \
		tmpscenemrSunLights = copyArray scenemrSunLights, \
		tmpscenemrSkyPortalLights = copyArray scenemrSkyPortalLights, \
		tmpsceneLSLights = copyArray sceneLSLights, \
		tmpsceneSkyLights = copyArray sceneSkyLights, \
		tmpsceneSunLights = copyArray sceneSunLights, \
		tmpsceneLuminaires = copyArray sceneLuminaires \
	)
	
	ListParser = #( \
		LLister.maxLightsList = #(), \
		LLister.miLightsList = #(), \
		LLister.mrSkyLightsList = #(), \
		LLister.mrSunLightsList = #(), \
		LLister.mrSkyPortalLightsList = #(), \
		LLister.LSLightsList = #(), \
		LLister.SkyLightsList = #(), \
		LLister.SunLightsList = #(), \
		LLister.LuminairesList = #() \
	)
	
	for i in 1 to tmpParser.count do
	(
		while tmpParser[i].count > 0 do
		(
			tmpNode = tmpParser[i][1].baseObject
			depends = refs.dependents tmpNode
			discard = #()
			for k in depends do if classof k != classof tmpNode or (superclassof k != light and superclassof k != helper) do append discard k
			for k in depends do 
				try
				(
					if classof k == DaylightAssemblyHead or classof k == ParamBlock2ParamBlock2 then 
						append discard k 
					else
						if k.AssemblyMember and not k.AssemblyHead and classof k.parent != DaylightAssemblyHead do append discard k
				) 
				catch()
			depends2 = subtractFromArray depends discard
			depends = SortNodeArrayByName depends2
			if depends.count > 0 do append listParser[i] depends
			tmpParser[i] = subtractFromArray tmpParser[i] (discard + depends)
		)
	)
	
	LLister.totalLightCount = 	LLister.maxLightsList.count + \
								LLister.LSLightsList.count + \
								LLister.SkyLightsList.count + \
								LLister.SunLightsList.count + \
								LLister.LuminairesList.count + \
								LLister.miLightsList.count + \
								LLister.mrSkyLightsList.count + \
								LLister.mrSkyPortalLightsList.count + \
								LLister.mrSunLightsList.count
	
	-- build controls and rollouts
	
	-- MAX Lights
	
	/*
		Rollout Creator Example...
		
		rci = rolloutCreator "myRollout" "My Rollout" 
		rci.begin()
			rci.addControl #button #myButton "My Button" paramStr:"Height:60 width:70"
			rci.addHandler #myButton #pressed filter:on codeStr:"MessageBox @Isn't this cool@ title:@Wow@"
		createDialog (rci.end())
	*/
	
	LLister.maxLightsRC = rolloutCreator "maxLightsRollout" "Lights" -- Localize the 2nd string only
	LLister.maxLightsRC.begin()
  	-- print LLister.maxLightsRC.str.count
	
	LLister.maxLightsRC.addText "fn clearCheckButtons = for i in LLister.LightInspectorListRollout.controls do if classof i == checkButtonControl do if i.checked do i.checked = false\n"
	
	LLister.count = 1
	LLister.lbCount = 1
	LLister.LightIndex = #()
	LLister.UIControlList = #(#(),#())

	fn WriteTitle hasShadow:true hasDecay:false hasSize:false isLuminaire:false isMRSky:false isMRSun:false isMRSkyPortal:false Multip:"Multiplier" = -- Localize this string
	(
		-- Start Localization
		
		local lbName
		fn lbName = 
		(
			if LLister.lbCount == undefined do LLister.lbCount = 1
			LLister.lbCount += 1
			("LB" + LLister.lbCount as string) as name
		)
		
		if isLuminaire == false do LLister.maxLightsRC.addControl #label (lbname()) "On" paramStr:(" align:#left offset:[8," + (-3 + LLister.yOffset + LLister.LineOffset) as string + "]")
		local labeloffset = if isLuminaire == false then -18 else -3
		LLister.maxLightsRC.addControl #label (lbname()) "Name" paramStr:(" align:#left offset:[28," + (labelOffset + LLister.yOffset) as string + "]")
		if ProductAppID == #VIZR then
		(
			LLister.maxLightsRC.addControl #label (lbname()) Multip paramStr:(" align:#left offset:[182,"+ (-18 + LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addControl #label (lbname()) "Color" paramStr:(" align:#left offset:[240,"+ (-18 + LLister.yOffset) as string + "]")
		)
		else
		(
			LLister.maxLightsRC.addControl #label (lbname()) Multip paramStr:(" align:#left offset:[102,"+ (-18 + LLister.yOffset) as string + "]")
			if not (isMRSky or isMRSun) do
				LLister.maxLightsRC.addControl #label (lbname()) "Color" paramStr:(" align:#left offset:[160,"+ (-18+ LLister.yOffset) as string + "]")
		)

		if hasShadow do
		(
			if ProductAppID == #VIZR then
				LLister.maxLightsRC.addControl #label (lbname()) "Shadows" paramStr:" align:#left offset:[270,-18]"
			else
			(
				LLister.maxLightsRC.addControl #label (lbname()) "Shadows" paramStr:(" align:#left offset:[190,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Map Size" paramStr:(" align:#left offset:[332,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Bias" paramStr:(" align:#left offset:[390,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Sm.Range" paramStr:(" align:#left offset:[443,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Transp." paramStr:(" align:#left offset:[495,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Int." paramStr:(" align:#left offset:[535,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Qual." paramStr:(" align:#left offset:[570,"+ (-18 + LLister.yOffset) as string + "]")
			)
		)
		if hasDecay and ProductAppID != #VIZR do
		(
			LLister.maxLightsRC.addControl #label (lbname()) "Decay" paramStr:(" align:#left offset:[612,"+ (-18 + LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addControl #label (lbname()) "Start" paramStr:(" align:#left offset:[690,"+ (-18+ LLister.yOffset) as string + "]")
		)
		if hasSize and ProductAppID != #VIZR do
		(
			LLister.maxLightsRC.addControl #label (lbname()) "Length" paramStr:(" align:#left offset:[612,"+ (-18 + LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addControl #label (lbname()) "Width" paramStr:(" align:#left offset:[671,"+ (-18 + LLister.yOffset) as string + "]")
		)
		if isMRSky do
		(
				LLister.maxLightsRC.addControl #label (lbname()) "Haze" paramStr:(" align:#left offset:[161,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "H Height" paramStr:(" align:#left offset:[218,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "H Blur" paramStr:(" align:#left offset:[277,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Ground" paramStr:(" align:#left offset:[333,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Night" paramStr:(" align:#left offset:[382,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Redness" paramStr:(" align:#left offset:[420,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Saturation" paramStr:(" align:#left offset:[480,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "UseAerialPersp" paramStr:(" align:#left offset:[540,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "AerialPersp" paramStr:(" align:#left offset:[620,"+ (-18 + LLister.yOffset) as string + "]")
		)
		if isMRSun do
		(
				LLister.maxLightsRC.addControl #label (lbname()) "Shadows" paramStr:(" align:#left offset:[159,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Softness" paramStr:(" align:#left offset:[211,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Samples" paramStr:(" align:#left offset:[258,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Targeted" paramStr:(" align:#left offset:[304,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Distance" paramStr:(" align:#left offset:[353,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Inherit" paramStr:(" align:#left offset:[426,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Haze" paramStr:(" align:#left offset:[463,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "H Height" paramStr:(" align:#left offset:[513,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Redness" paramStr:(" align:#left offset:[561,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Saturation" paramStr:(" align:#left offset:[609,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Use Targ" paramStr:(" align:#left offset:[663,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Radius" paramStr:(" align:#left offset:[712,"+ (-18 + LLister.yOffset) as string + "]")
		)
		if isMRSkyPortal do
		(
				LLister.maxLightsRC.addControl #label (lbname()) "Shadows" paramStr:(" align:#left offset:[190,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Extend" paramStr:(" align:#left offset:[240,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Samples" paramStr:(" align:#left offset:[280,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Length" paramStr:(" align:#left offset:[335,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Width" paramStr:(" align:#left offset:[408,"+ (-18+ LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Flip Flux" paramStr:(" align:#left offset:[478,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Visible" paramStr:(" align:#left offset:[525,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Transparency" paramStr:(" align:#left offset:[560,"+ (-18 + LLister.yOffset) as string + "]")
				LLister.maxLightsRC.addControl #label (lbname()) "Source" paramStr:(" align:#left offset:[640,"+ (-18 + LLister.yOffset) as string + "]")
		)

		-- End Localization
	)
	
	fn CreateControls hasShadow:true hasDecay:false hasSize:false Multiplier:#multiplier ColorType:#Color isLuminaire:false isMRSky:false isMRSun:false isMRSkyPortal:false = -- AB: Jun 20, 2002
	(
	
		-- Selection Checkbox
		
		local isLightSelected = false
		
		for i in LLister.LightIndex[LLister.count] where (not isLightSelected) do isLightSelected = i.isSelected
		
		LLister.UIControlList[1][LLister.count] = LLister.LightIndex[LLister.count][1]
		LLister.UIControlList[2][LLister.Count] = #()
		
		LLister.maxLightsRC.addControl #checkbutton (("LightSel" + LLister.count as string) as name) "" \
			paramStr:("checked:" + (isLightSelected as string) + " offset:[-5,"+ (-2+ LLister.yOffset + LLister.LineOffset) as string + "] align:#left" +\
					" width:10 height:20 ")
		LLister.maxLightsRC.addHandler (("LightSel" + LLister.count as string) as name) #'changed state' filter:on \
			codeStr: \
			(
			"clearCheckButtons();if state then (max modify mode;select LLister.LightIndex[" + LLister.count as string + "];LightSel" + (LLister.count as string) + ".checked = true); else max select none"
			)
		
		append LLister.UIControlList[2][LLister.Count] (("LightSel" + LLister.count as string) as name)
		
		-- On/Off
		
		if isLuminaire == false do
		(
			LLister.maxLightsRC.addControl #checkbox (("LightOn" + LLister.count as string) as name) "" \
				paramStr:("checked:" + ((LLister.GetlightProp LLister.LightIndex[LLister.count][1] #on) as string) + " offset:[8,"+ (-22+ LLister.yOffset) as string + "] width:18")
			LLister.maxLightsRC.addHandler (("LightOn" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #on state")
			
			append LLister.UIControlList[2][LLister.Count] (("LightOn" + LLister.count as string) as name)

		)
		
		-- Light Name
		
		local isUsingEdittextOffset = 0, editTextSize = 75, vizRoffset = 0
		if ProductAppID == #vizR do (editTextSize += 80; vizRoffset += 80)
		
		if LLister.LightIndex[LLister.count].count == 1 then
		(
			LLister.maxLightsRC.addControl #edittext (("LightName" + LLister.count as string) as name) "" \
				paramStr:(" text:\"" + LLister.LightIndex[LLister.count][1].name + "\" width:" + editTextSize as string +  \
				" height:16 offset:[23,"+ (-21+ LLister.yOffset) as string + "] height:21")
			LLister.maxLightsRC.addHandler (("LightName" + LLister.count as string) as name) #'entered txt' filter:on \
				codeStr:("LLister.LightIndex[" + LLister.count as string + "][1].name = txt")

			isUsingEdittextOffset = 4
		)
		else
		(
			theNames = for j in LLister.LightIndex[LLister.count] collect j.name
			sort theNames
			namelist = "#("
			for j in 1 to theNames.count do 
				(
				append namelist ("\"" + theNames[j] + "\"")
				if j != theNames.count do append namelist ","
				)
			append namelist ")"
			LLister.maxLightsRC.addControl #dropDownList (("LightName" + LLister.count as string) as name) "" filter:on\
				paramStr:(" items:" + NameList + " width:" + ((editTextSize-2) as string) + " offset:[27,"+ (-22+ LLister.yOffset) as string + "] ")
		)
		
		append LLister.UIControlList[2][LLister.Count] (("LightName" + LLister.count as string) as name)
		
		-- Light Multiplier

		-- AB: Jun 20, 2002
		-- Increased Limits for the spinners from 10,000 to 1,000,000
		
		if Multiplier == #multiplier or Multiplier == #skymult then
		(
			local lowerLimit = -1000000
			local upperLimit = 1000000
			if isMRSky do
			(
				lowerLimit = 0
				upperLimit = 15
			)
			if isMRSun do
			(
				lowerLimit = 0
				upperLimit = 10
			)
			if isMRSkyPortal do
			(
				lowerLimit = 0
			)
			
			LLister.maxLightsRC.addControl #spinner (("LightMult" + LLister.count as string) as name) "" \
				paramStr:("range:[" + lowerLimit as string + "," + upperLimit as string + "," + \
				(LLister.getLightProp LLister.LightIndex[LLister.count][1] Multiplier) as string + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[" +  (100 + vizRoffset) as string + \
				"," + (isUsingEdittextOffset-24+LLister.yOffset) as string + "] enabled:" + \
				((if isProperty LLister.LightIndex[LLister.count][1] Multiplier then \
				if LLister.LightIndex[LLister.count][1].multiplier.controller != undefined then \
				LLister.LightIndex[LLister.count][1].multiplier.controller.keys.count >= 0 else true \
				else try(if isProperty LLister.LightIndex[LLister.count][1].delegate Multiplier then \
				if LLister.LightIndex[LLister.count][1].delegate.multiplier.controller != undefined then \
				LLister.LightIndex[LLister.count][1].delegate.multiplier.controller.keys.count >= 0 else true) catch(true)\
				) as string))
			LLister.maxLightsRC.addHandler (("LightMult" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #"+ multiplier + " val")
		)
		else if Multiplier == #intensity then
		(
			LLister.maxLightsRC.addControl #spinner (("LightMult" + LLister.count as string) as name) "" \
				paramStr:("range:[-1000000,1000000," + (LLister.LightIndex[LLister.count][1].intensity as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[" +  (100 + vizRoffset) as string + \
				"," + (isUsingEdittextOffset-24+LLister.yoffset) as string + "] enabled:" + \
				((if isProperty LLister.LightIndex[LLister.count][1] #intensity then \
				if LLister.LightIndex[LLister.count][1].intensity.controller != undefined then \
				LLister.LightIndex[LLister.count][1].intensity.controller.keys.count >= 0 else true \
				else try(if isProperty LLister.LightIndex[LLister.count][1].delegate #intensity then \
				if LLister.LightIndex[LLister.count][1].delegate.intensity.controller != undefined then \
				LLister.LightIndex[LLister.count][1].delegate.intensity.controller.keys.count >= 0 else true) catch(true)\
				) as string))
			LLister.maxLightsRC.addHandler (("LightMult" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #intensity val")
		)
		else if Multiplier == #dimmer then
		(
			LLister.maxLightsRC.addControl #spinner (("LightMult" + LLister.count as string) as name) "" \
				paramStr:("range:[-1000000,1000000," + (LLister.LightIndex[LLister.count][1].dimmer as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[" + (100 + vizRoffset) as string + "," + \
				(isUsingEdittextOffset-24+LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightMult" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.LightIndex[" + LLister.count as string + "][1].dimmer = val")
		)
		
		append LLister.UIControlList[2][LLister.Count] (("LightMult" + LLister.count as string) as name)
		
		
		-- Light Color
		
		-- AB: Jun 20, 2002
		-- Added ColorType parameter to the function, so I can call FilterColor for Photometric Lights
		
		if ColorType == #Color or ColorType == #FilterColor or ColorType == #rgbFilter then
		(
			LLister.maxLightsRC.addControl #colorpicker (("LightCol" + LLister.count as string) as name) "" \
				paramStr:("color:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] ColorType) as string + \
				" offset:[" + (158 + vizRoffset) as string + ","+ (-23+ LLister.yOffset) as string + "] width:25")
			LLister.maxLightsRC.addHandler (("LightCol" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #" + ColorType as string + " val")
			append LLister.UIControlList[2][LLister.Count] (("LightCol" + LLister.count as string) as name)
		)
		
		if hasShadow do
		(
		
			-- Shadow On/Off
			
			LLister.maxLightsRC.addControl #checkbox (("LightShdOn" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1].baseObject #castshadows as string)+ \
				" offset:[" + (190 + vizRoffset) as string + ","+ (-22+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightShdOn" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1].baseobject #castshadows state")
			
			append LLister.UIControlList[2][LLister.Count] (("LightShdOn" + LLister.count as string) as name)
			
			-- Shadow Plugin
			
			if ProductAppID != #VIZR do
			(
			
			local LLshadowClass = LLister.fnShadowClass LLister.LightIndex[LLister.count][1]
			local LLshadowGen = (LLister.getLightProp LLister.LightIndex[LLister.count][1] #shadowGenerator)

			
			LLister.maxLightsRC.addControl #dropDownList (("LightShd" + LLister.count as string) as name) "" filter:on\
				paramStr:(" items:" + LLister.ShadowPluginsName as string + " width:110 offset:[210,"+ (-24+ LLister.yOffset) as string + "]" + \
				"selection:(finditem LLister.ShadowPlugins (LLister.fnShadowClass LLister.LightIndex[" + LLister.count as string + "][1]))")
	
			append LLister.UIControlList[2][LLister.Count] (("LightShd" + LLister.count as string) as name)
	
			-- Light Map Size
			
			local mapSizeTmp = 512
			
			if LLshadowClass == shadowMap do 
				mapSizeTmp = LLshadowGen.mapSize
			
			LLister.maxLightsRC.addControl #spinner (("LightMapSiz" + LLister.count as string) as name) "" \
				paramStr:("range:[0,10000," + (mapSizeTmp as string) + "] type:#integer " + \
				"fieldwidth:45 align:#left offset:[330,"+ (-24+ LLister.yOffset) as string + "] enabled:" \
				+ (LLshadowClass == shadowMap or LLShadowClass == mental_ray_shadow_map) as string)
			LLister.maxLightsRC.addHandler (("LightMapSiz" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setShdProp LLister.LightIndex[" + LLister.count as string + "][1] #mapSize val")
	
			append LLister.UIControlList[2][LLister.Count] (("LightMapSiz" + LLister.count as string) as name)
			
			-- Light Bias
			
			local BiasTmp = \
				case LLshadowClass of
				(
					shadowMap:			LLShadowGen.mapBias
					raytraceShadow:		LLShadowGen.raytraceBias
					Area_Shadows:		LLShadowGen.ray_Bias
					Adv__Ray_Traced:	LLShadowGen.ray_Bias
					Blur_Adv__Ray_Traced:	LLShadowGen.ray_Bias
					default:			1.0
				)

			LLister.maxLightsRC.addControl #spinner (("LightBias" + LLister.count as string) as name) "" \
				paramStr:("range:[0,10000," + (BiasTmp as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[388,"+ (-21+ LLister.yOffset) as string + "] enabled:" \
				+ (LLShadowClass == shadowMap or LLShadowClass == raytraceShadow or LLShadowClass == Blur_Adv__Ray_Traced or\
				LLShadowClass == Area_Shadows or LLShadowClass == Adv__Ray_Traced) as string)
			LLister.maxLightsRC.addHandler (("LightBias" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr: \
				(
				"local propname = case (LLister.fnShadowClass LLister.LightIndex[" + LLister.count as string + "][1]) of\n" + \
				"(shadowMap:#mapbias; raytraceShadow:#raytraceBias; Area_Shadows:#ray_bias; Adv__Ray_Traced:#ray_bias; Blur_Adv__Ray_Traced:#ray_bias;default:0)\n" + \
				"if propname != 0 do LLister.SetShdProp LLister.LightIndex[" + LLister.count as string + "][1] propName val"
				)

			append LLister.UIControlList[2][LLister.Count] (("LightBias" + LLister.count as string) as name)
	
			-- Light Sample Range
			
			local smpRangeTmp = 4.0
			local smpRangeStr = "#samplerange"   --fix the mr shadow sample problem here.
			if LLShadowClass == shadowMap  then	smpRangeTmp = LLShadowGen.samplerange
			else if LLShadowClass == mental_ray_Shadow_Map do (
				smpRangeTmp = LLShadowGen.Sample_Range
				smpRangeStr = "#Sample_Range"
			)
			
			LLister.maxLightsRC.addControl #spinner (("LightSmpRange" + LLister.count as string) as name) "" \
				paramStr:("range:[0,50," + (smpRangeTmp as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[446,"+ (-21+ LLister.yOffset) as string + "] enabled:" + (LLShadowClass == shadowMap or LLShadowClass == mental_ray_shadow_map) as string)
			LLister.maxLightsRC.addHandler (("LightSmpRange" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.SetShdProp LLister.LightIndex[" + LLister.count as string + "][1] "+smpRangeStr+" val")
	
			append LLister.UIControlList[2][LLister.Count] (("LightSmpRange" + LLister.count as string) as name)
	
			-- Transparency On/Off
			
			LLister.maxLightsRC.addControl #checkbox (("LightTrans" + LLister.count as string) as name) "" \
				paramStr:("checked:" + \
						((if LLShadowClass == Area_Shadows or LLShadowClass == Adv__Ray_Traced or LLShadowClass == Blur_Adv__Ray_Traced then \
						LLShadowGen.shadow_Transparent else false) as string) + \
						" offset:[508,"+ (-20+ LLister.yOffset) as string + "] width:15 enabled:" + \
						((LLShadowClass == Area_Shadows or LLShadowClass == Adv__Ray_Traced or LLShadowClass == Blur_Adv__Ray_Traced) as string))
			LLister.maxLightsRC.addHandler (("LightTrans" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setShdProp LLister.LightIndex[" + LLister.count as string + "][1] #shadow_Transparent state")
	
			append LLister.UIControlList[2][LLister.Count] (("LightTrans" + LLister.count as string) as name)
	
			-- Integrity
			
			LLister.maxLightsRC.addControl #spinner (("LightInteg" + LLister.count as string) as name) "" \
				paramStr:("type:#integer fieldwidth:30 align:#left range:[1,15," + \
						((if LLShadowClass == Area_Shadows or LLShadowClass == Blur_Adv__Ray_Traced or\
						LLShadowClass == Adv__Ray_Traced then \
						LLShadowGen.pass1 else 1) as string) + \
						"] offset:[521,"+ (-21+ LLister.yOffset) as string + "] width:15 enabled:" + \
						((LLShadowClass == Area_Shadows or LLShadowClass == Blur_Adv__Ray_Traced or\
						LLShadowClass == Adv__Ray_Traced) as string))
			LLister.maxLightsRC.addHandler (("LightInteg" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setShdProp LLister.LightIndex[" + LLister.count as string + "][1] #pass1 val")
	
			append LLister.UIControlList[2][LLister.Count] (("LightInteg" + LLister.count as string) as name)
	
			-- Quality
			
			LLister.maxLightsRC.addControl #spinner (("LightQual" + LLister.count as string) as name) "" \
				paramStr:("type:#integer fieldwidth:30 align:#left range:[1,15," + \
						((if LLShadowClass == Area_Shadows or LLShadowClass == Blur_Adv__Ray_Traced or \
						LLShadowClass == Adv__Ray_Traced then \
						LLShadowGen.pass2 else 2) as string) + \
						"] offset:[565,"+ (-21+ LLister.yOffset) as string + "] width:15 enabled:" + \
						((LLShadowClass == Area_Shadows or LLShadowClass == Blur_Adv__Ray_Traced or \
						LLShadowClass == Adv__Ray_Traced) as string))
			LLister.maxLightsRC.addHandler (("LightQual" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setShdProp LLister.LightIndex[" + LLister.count as string + "][1] #pass2 val")
			
			append LLister.UIControlList[2][LLister.Count] (("LightQual" + LLister.count as string) as name)
			
			-- Shadow Plugin dropdown handler
	
			LLister.maxLightsRC.addHandler (("LightShd" + LLister.count as string) as name) #'selected i' filter:on \
				codeStr:(\
					"LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #shadowGenerator (LLister.ShadowPlugins[i]());" + \
					"local shdClass = LLister.fnShadowClass LLister.LightIndex[" + LLister.count as string + "][1]\n" + \
					"LightMapSiz" + LLister.count as string + ".enabled = LightSmpRange" + LLister.count as string + ".enabled = (shdClass == shadowMap or shdClass == mental_ray_shadow_map)\n" + \
					"LightTrans" + LLister.count as string + ".enabled = LightInteg" + LLister.count as string + ".enabled = LightQual" + LLister.count as string + ".enabled = " + \
					"shdClass == Adv__Ray_Traced or shdClass == Blur_Adv__Ray_Traced or shdClass == Area_Shadows\n" + \
					"LightBias" + LLister.count as string + ".enabled = (shdClass == Area_Shadows or shdClass == shadowMap or " + \
					"shdClass == Blur_Adv__Ray_Traced or shdClass == raytraceShadow or shdClass ==  Adv__Ray_Traced)\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #mapSize) != undefined do LightMapSiz" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #sampleRange) != undefined do LightSmpRange" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #pass1) != undefined do LightInteg" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #pass2) != undefined do LightQual" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #mapBias) != undefined do LightBias" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #ray_Bias) != undefined do LightBias" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #raytraceBias) != undefined do LightBias" + \
						LLister.count as string + ".value = val\n" + \
					"if (val = LLister.getShdProp LLister.LightIndex[" + LLister.count as string + "][1] #shadow_Transparent) != undefined do LightTrans" + \
						LLister.count as string + ".checked = val\n" + \
					"LLister.enableRefreshBtn LLister.LightIndex[" + LLister.count as string + "][1]"
					)
			) -- end VIZR
		) -- end has Shadow

		
		if hasDecay and ProductAppID != #VIZR do
		(
		
			-- Decay selection
			
			LLister.maxLightsRC.addControl #dropDownList (("LightDecay" + LLister.count as string) as name) "" filter:on\
				paramStr:(" items:" + LLister.decayStrings as string + " width:80 offset:[612,"+ (-24+ LLister.yOffset) as string + "]" + \
				"selection:(LLister.getLightProp LLister.LightIndex[" + LLister.count as string + "][1] #attenDecay)")
			LLister.maxLightsRC.addHandler (("LightDecay" + LLister.count as string) as name) #'selected i' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #attenDecay i")
	
			append LLister.UIControlList[2][LLister.Count] (("LightDecay" + LLister.count as string) as name)
			

			-- Decay Start
			
			LLister.maxLightsRC.addControl #spinner (("LightDecStart" + LLister.count as string) as name) "" \
				paramStr:("range:[0,10000," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #decayRadius) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[690,"+ (-24+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightDecStart" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #decayRadius val")
		
			append LLister.UIControlList[2][LLister.Count] (("LightDecStart" + LLister.count as string) as name)
		) -- end hasDecay
		
		if hasSize and ProductAppID != #VIZR do
		(
				-- Light Length
				
				LLister.maxLightsRC.addControl #spinner (("LSLightLength" + LLister.count as string) as name) "" \
					paramStr:("range:[0,100000," + (LLister.LightIndex[LLister.count][1].light_length as string) + "] type:#float " + \
					"fieldwidth:45 align:#left offset:[610,"+ (-21+ LLister.yOffset) as string + "] enabled:" \
					+ ((LLister.LightIndex[LLister.count][1].type != #free_point and LLister.LightIndex[LLister.count][1].type != #target_point) as string))
				LLister.maxLightsRC.addHandler (("LSLightLength" + LLister.count as string) as name) #'changed val' filter:on \
					codeStr:("LLister.LightIndex[" + LLister.count as string + "][1].light_length = val")
	
				append LLister.UIControlList[2][LLister.Count] (("LSLightLength" + LLister.count as string) as name)
				
				-- Light Width
				
				LLister.maxLightsRC.addControl #spinner (("LSLightWidth" + LLister.count as string) as name) "" \
					paramStr:("range:[0,100000," + (LLister.LightIndex[LLister.count][1].light_Width as string) + "] type:#float " + \
					"fieldwidth:45 align:#left offset:[669,"+ (-21+ LLister.yOffset) as string + "] enabled:" \
					+ ((LLister.LightIndex[LLister.count][1].type != #free_point and LLister.LightIndex[LLister.count][1].type != #target_point) as string))
				LLister.maxLightsRC.addHandler (("LSLightWidth" + LLister.count as string) as name) #'changed val' filter:on \
					codeStr:("LLister.LightIndex[" + LLister.count as string + "][1].light_Width = val")
	
				append LLister.UIControlList[2][LLister.Count] (("LSLightWidth" + LLister.count as string) as name)
	
		)
		
		if isMRSky do
		(
			-- Haze
			LLister.maxLightsRC.addControl #spinner (("LightHaze" + LLister.count as string) as name) "" \
				paramStr:("range:[0,15," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #haze) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[158,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightHaze" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #haze val")
			append LLister.UIControlList[2][LLister.Count] (("LightHaze" + LLister.count as string) as name)

			-- HorizonHeight
			LLister.maxLightsRC.addControl #spinner (("LightHHeight" + LLister.count as string) as name) "" \
				paramStr:("range:[-10,10," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #HorizonHeight) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[216,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightHHeight" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #HorizonHeight val")
			append LLister.UIControlList[2][LLister.Count] (("LightHHeight" + LLister.count as string) as name)

			-- HorizonBlur
			LLister.maxLightsRC.addControl #spinner (("LightHBlur" + LLister.count as string) as name) "" \
				paramStr:("range:[0,10," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #HorizonBlur) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[274,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightHBlur" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #HorizonBlur val")
			append LLister.UIControlList[2][LLister.Count] (("LightHBlur" + LLister.count as string) as name)

			-- GroundColor
			LLister.maxLightsRC.addControl #colorpicker (("LightGroundCol" + LLister.count as string) as name) "" \
				paramStr:("color:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #GroundColor) as string + \
				" offset:[" + (335 + vizRoffset) as string + ","+ (-23+ LLister.yOffset) as string + "] width:25")
			LLister.maxLightsRC.addHandler (("LightGroundCol" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #GroundColor val")
			append LLister.UIControlList[2][LLister.Count] (("LightGroundCol" + LLister.count as string) as name)
				
			-- NightColor
			LLister.maxLightsRC.addControl #colorpicker (("LightNightCol" + LLister.count as string) as name) "" \
				paramStr:("color:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #NightColor) as string + \
				" offset:[" + (380 + vizRoffset) as string + ","+ (-25+ LLister.yOffset) as string + "] width:25")
			LLister.maxLightsRC.addHandler (("LightNightCol" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #NightColor val")
			append LLister.UIControlList[2][LLister.Count] (("LightNightCol" + LLister.count as string) as name)
				
			-- Redness
			LLister.maxLightsRC.addControl #spinner (("LightRedness" + LLister.count as string) as name) "" \
				paramStr:("range:[-1,1," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #Redness) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[419,"+ (-23+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightRedness" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #Redness val")
			append LLister.UIControlList[2][LLister.Count] (("LightRedness" + LLister.count as string) as name)

			-- Saturation
			LLister.maxLightsRC.addControl #spinner (("LightSaturation" + LLister.count as string) as name) "" \
				paramStr:("range:[0,2," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #Saturation) as string) + "] type:#float " + \
				"fieldwidth:45 align:#left offset:[477,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightSaturation" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #Saturation val")
			append LLister.UIControlList[2][LLister.Count] (("LightSaturation" + LLister.count as string) as name)

			-- UseAerialPerspective
			LLister.maxLightsRC.addControl #checkbox (("LightUseAerPersp" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #UseAerialPerspective as string)+ \
				" offset:[" + (570 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightUseAerPersp" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #UseAerialPerspective state")
			append LLister.UIControlList[2][LLister.Count] (("LightUseAerPersp" + LLister.count as string) as name)

			-- AerialPerspective
			LLister.maxLightsRC.addControl #spinner (("LightAerialPersp" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1e8," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #AerialPerspective) as string) + "] type:#float " + \
				"fieldwidth:60 align:#left offset:[618,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightAerialPersp" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #AerialPerspective val")
			append LLister.UIControlList[2][LLister.Count] (("LightAerialPersp" + LLister.count as string) as name)
		)
		
		if isMRSun do
		(
			-- Shadow On/Off
			LLister.maxLightsRC.addControl #checkbox (("LightShdOn" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1].baseObject #castshadows as string)+ \
				" offset:[" + (175 + vizRoffset) as string + ","+ (-22+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightShdOn" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1].baseobject #castshadows state")
			append LLister.UIControlList[2][LLister.Count] (("LightShdOn" + LLister.count as string) as name)

			-- shadowSoftness
			LLister.maxLightsRC.addControl #spinner (("LightShdSoft" + LLister.count as string) as name) "" \
				paramStr:("range:[0,50," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #shadowSoftness) as string) + "] type:#float " + \
				"fieldwidth:35 align:#left offset:[210,"+ (-20+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightShdSoft" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #shadowSoftness val")
			append LLister.UIControlList[2][LLister.Count] (("LightShdSoft" + LLister.count as string) as name)

			-- shadowSamples
			LLister.maxLightsRC.addControl #spinner (("LightShdSamples" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1000," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #shadowSamples) as string) + "] type:#integer " + \
				"fieldwidth:35 align:#left offset:[259,"+ (-20+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightShdSamples" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #shadowSamples val")
			append LLister.UIControlList[2][LLister.Count] (("LightShdSamples" + LLister.count as string) as name)

			-- hasTarget
			LLister.maxLightsRC.addControl #checkbox (("LightHasTarg" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #hasTarget as string)+ \
				" offset:[" + (320 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightHasTarg" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #hasTarget state")
			append LLister.UIControlList[2][LLister.Count] (("LightHasTarg" + LLister.count as string) as name)

			-- targetDistance
			LLister.maxLightsRC.addControl #spinner (("LightTargDist" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1e8," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1].baseobject #targetDistance) as string) + "] type:#float " + \
				"fieldwidth:60 align:#left offset:[352,"+ (-20+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightTargDist" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1].baseobject #targetDistance val")
			append LLister.UIControlList[2][LLister.Count] (("LightTargDist" + LLister.count as string) as name)

			-- inherit
			LLister.maxLightsRC.addControl #checkbox (("LightInherit" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #inherit as string)+ \
				" offset:[" + (435 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightInherit" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #inherit state")
			append LLister.UIControlList[2][LLister.Count] (("LightInherit" + LLister.count as string) as name)

			-- haze
			LLister.maxLightsRC.addControl #spinner (("LightHaze" + LLister.count as string) as name) "" \
				paramStr:("range:[0,15," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #haze) as string) + "] type:#float " + \
				"fieldwidth:35 align:#left offset:[463,"+ (-20+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightHaze" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #haze val")
			append LLister.UIControlList[2][LLister.Count] (("LightHaze" + LLister.count as string) as name)

			-- horizonheight
			LLister.maxLightsRC.addControl #spinner (("LightHHeight" + LLister.count as string) as name) "" \
				paramStr:("range:[-10,10," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #horizonheight) as string) + "] type:#integer " + \
				"fieldwidth:35 align:#left offset:[513,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightHHeight" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #horizonheight val")
			append LLister.UIControlList[2][LLister.Count] (("LightHHeight" + LLister.count as string) as name)

			-- redblueshift
			LLister.maxLightsRC.addControl #spinner (("LightRedness" + LLister.count as string) as name) "" \
				paramStr:("range:[-1,1," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #redblueshift) as string) + "] type:#float " + \
				"fieldwidth:35 align:#left offset:[563,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightRedness" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #redblueshift val")
			append LLister.UIControlList[2][LLister.Count] (("LightRedness" + LLister.count as string) as name)

			-- saturation
			LLister.maxLightsRC.addControl #spinner (("LightSaturation" + LLister.count as string) as name) "" \
				paramStr:("range:[0,2," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #saturation) as string) + "] type:#float " + \
				"fieldwidth:35 align:#left offset:[613,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightSaturation" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #saturation val")
			append LLister.UIControlList[2][LLister.Count] (("LightSaturation" + LLister.count as string) as name)

			-- usephotontarget
			LLister.maxLightsRC.addControl #checkbox (("LightUsePTarg" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #usephotontarget as string)+ \
				" offset:[" + (678 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightUsePTarg" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #usephotontarget state")
			append LLister.UIControlList[2][LLister.Count] (("LightUsePTarg" + LLister.count as string) as name)

			-- photontarget
			LLister.maxLightsRC.addControl #spinner (("LightPhotonTarg" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1e8," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #photontarget) as string) + "] type:#float " + \
				"fieldwidth:60 align:#left offset:[700,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightPhotonTarg" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #photontarget val")
			append LLister.UIControlList[2][LLister.Count] (("LightPhotonTarg" + LLister.count as string) as name)
		)
		
		if isMRSkyPortal do
		(
			-- Shadow On/Off
			LLister.maxLightsRC.addControl #checkbox (("LightShdOn" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1].baseObject #castshadows as string)+ \
				" offset:[" + (210 + vizRoffset) as string + ","+ (-22+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightShdOn" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1].baseobject #castshadows state")
			append LLister.UIControlList[2][LLister.Count] (("LightShdOn" + LLister.count as string) as name)

			-- extend_shadows
			LLister.maxLightsRC.addControl #checkbox (("LightExtShad" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #extend_shadows as string)+ \
				" offset:[" + (250 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightExtShad" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #extend_shadows state")
			append LLister.UIControlList[2][LLister.Count] (("LightExtShad" + LLister.count as string) as name)

			-- shadowSamples
			LLister.maxLightsRC.addControl #dropDownList (("LightShdSamples" + LLister.count as string) as name) "" filter:on\
				paramStr:(" items:" + LLister.MRSkyPortal_ShadowSamples as string + " width:52 offset:[278,"+ (-23+ LLister.yOffset) as string + "]" + \
				"selection:" + (((LLister.getLightProp LLister.LightIndex[LLister.count][1] #shadowSamples) +1) as string))
			LLister.maxLightsRC.addHandler (("LightShdSamples" + LLister.count as string) as name) #'selected i' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #shadowSamples (i-1)")
			append LLister.UIControlList[2][LLister.Count] (("LightShdSamples" + LLister.count as string) as name)

			-- light_length
			LLister.maxLightsRC.addControl #spinner (("LightLength" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1e8," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #light_length) as string) + "] type:#float " + \
				"fieldwidth:60 align:#left offset:[331,"+ (-24+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightLength" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #light_length val")
			append LLister.UIControlList[2][LLister.Count] (("LightLength" + LLister.count as string) as name)

			-- light_width
			LLister.maxLightsRC.addControl #spinner (("LightWidth" + LLister.count as string) as name) "" \
				paramStr:("range:[0,1e8," + ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #light_width) as string) + "] type:#float " + \
				"fieldwidth:60 align:#left offset:[406,"+ (-21+ LLister.yOffset) as string + "]")
			LLister.maxLightsRC.addHandler (("LightWidth" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #light_width val")
			append LLister.UIControlList[2][LLister.Count] (("LightWidth" + LLister.count as string) as name)

				-- reversed
			LLister.maxLightsRC.addControl #checkbox (("LightFlipFlux" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #reversed as string)+ \
				" offset:[" + (490 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightFlipFlux" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #reversed state")
			append LLister.UIControlList[2][LLister.Count] (("LightFlipFlux" + LLister.count as string) as name)

				-- Area_Visible
			LLister.maxLightsRC.addControl #checkbox (("LightAreaVisible" + LLister.count as string) as name) "" \
				paramStr:("checked:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #Area_Visible as string)+ \
				" offset:[" + (535 + vizRoffset) as string + ","+ (-21+ LLister.yOffset) as string + "] width:15")
			LLister.maxLightsRC.addHandler (("LightAreaVisible" + LLister.count as string) as name) #'changed state' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #Area_Visible state")
			append LLister.UIControlList[2][LLister.Count] (("LightAreaVisible" + LLister.count as string) as name)

			-- transparency
			LLister.maxLightsRC.addControl #colorpicker (("LightTransparency" + LLister.count as string) as name) "" \
				paramStr:("color:" + (LLister.getLightProp LLister.LightIndex[LLister.count][1] #transparency) as string + \
				" offset:[" + (580 + vizRoffset) as string + ","+ (-23+ LLister.yOffset) as string + "] width:25")
			LLister.maxLightsRC.addHandler (("LightTransparency" + LLister.count as string) as name) #'changed val' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #transparency val")
			append LLister.UIControlList[2][LLister.Count] (("LightTransparency" + LLister.count as string) as name)
				
			-- mode
			LLister.maxLightsRC.addControl #dropDownList (("LightSourceMode" + LLister.count as string) as name) "" filter:on\
				paramStr:(" items:" + LLister.MRSkyPortal_Modes as string + " width:70 offset:[640,"+ (-24+ LLister.yOffset) as string + "]" + \
				"selection:" + (((mod ((LLister.getLightProp LLister.LightIndex[LLister.count][1] #mode) + 1) 3) +1 ) as string))
			LLister.maxLightsRC.addHandler (("LightSourceMode" + LLister.count as string) as name) #'selected i' filter:on \
				codeStr:("LLister.setLightProp LLister.LightIndex[" + LLister.count as string + "][1] #mode (mod (i+1) 3)")
			append LLister.UIControlList[2][LLister.Count] (("LightSourceMode" + LLister.count as string) as name)
		)

		if heapFree < 1000000 do heapsize += 1000000 -- AB Jun 20, 2002
		
	) -- end CreateControls
	
	local CanAddControls = true
	local LightCountLimit = 150 -- this sets the maximum number of lights displayed
	
	if LLister.maxLightsList.count > 0 do
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #title "Standard Lights" paramStr:" align:#left"

		WriteTitle hasShadow:true hasDecay:true hasSize:false Multip:"Multiplier"
		
		-- End Localization

		for x in 1 to LLister.maxLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		
		append LLister.LightIndex LLister.maxLightsList[x]
		createControls hasShadow:true hasDecay:true
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount

		) -- end For i in MAXLights
		
	) -- end MAXLights
	
	if LLister.LSLightsList.count > 0 and CanAddControls do -- AB: Jun 20, 2002
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #LStitle "Photometric Lights" paramStr:" align:#left"

		WriteTitle hasShadow:true hasDecay:false hasSize:true Multip:"Intensity(cd)"
		
		-- End Localization

		for x in 1 to LLister.LSLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.LSLightsList[x]
		createControls hasShadow:true hasDecay:false hasSize:true Multiplier:#intensity colorType:#FilterColor
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in LS Lights

		
	) -- end if LS Lights

	if LLister.miLightsList.count > 0 and CanAddControls do -- AB: Jun 20, 2002
	(
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #miLightstitle "mental ray Area Lights" paramStr:" align:#left"
		WriteTitle hasShadow:true hasDecay:false hasSize:false Multip:"Multip." isLuminaire:false
		-- End Localization

		for x in 1 to LLister.miLightsList.count  where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.miLightsList[x]
		createControls hasShadow:true hasDecay:true hasSize:false
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in miLightsList
		
	) -- end miLightsList

	if LLister.LuminairesList.count > 0 and CanAddControls do -- AB: Jun 20, 2002
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #Luminairetitle "Luminaires" paramStr:" align:#left"

		WriteTitle hasDecay:false hasSize:false Multip:"Dimmer" hasShadow:false isLuminaire:true
		
		-- End Localization

		for x in 1 to LLister.LuminairesList.count  where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.LuminairesList[x]
		createControls hasShadow:false hasDecay:false hasSize:false Multiplier:#dimmer colorType:#FilterColor isLuminaire:true
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in LS Lights
		
	) -- end Luminaires

	if LLister.SunLightsList.count > 0 and CanAddControls do
	(

		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #Suntitle "Sun Lights" paramStr:" align:#left"

		WriteTitle hasShadow:true hasDecay:false hasSize:false Multip:"Intensity(lux)"

		-- End Localization

		for x in 1 to LLister.SunLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.SunLightsList[x]
		createControls hasShadow:true hasDecay:false hasSize:false
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in Sun Lights

		
	)


	if LLister.SkyLightsList.count > 0 and CanAddControls do
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #Skytitle "Sky Lights" paramStr:" align:#left"

		WriteTitle hasShadow:false hasDecay:false hasSize:false Multip:"Multiplier"

		-- End Localization

		for x in 1 to LLister.SkyLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.SkyLightsList[x]
		createControls hasShadow:false hasDecay:false hasSize:false
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in Sky Lights
	)
	
	if LLister.mrSkyLightsList.count > 0 and CanAddControls do
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #mrSkytitle "mr Sky Lights" paramStr:" align:#left"

		WriteTitle hasShadow:false isMRSky:true

		-- End Localization

		for x in 1 to LLister.mrSkyLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.mrSkyLightsList[x]
		createControls hasShadow:false hasDecay:false hasSize:false ColorType:#none isMRSky:true
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in mr Sky Lights
	)
	
	if LLister.mrSunLightsList.count > 0 and CanAddControls do
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #mrSuntitle "mr Sun Lights" paramStr:" align:#left"

		WriteTitle hasShadow:false isMRSun:true

		-- End Localization

		for x in 1 to LLister.mrSunLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.mrSunLightsList[x]
		createControls hasShadow:false hasDecay:false hasSize:false ColorType:#none Multiplier:#skymult isMRSun:true
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in mr Sun Lights
	)
	
	if LLister.mrSkyPortalLightsList.count > 0 and CanAddControls do
	(
		
		-- Start Localization
		
		LLister.maxLightsRC.addControl #label #mrSkyPortaltitle "mr Sky Portal Lights" paramStr:" align:#left"

		WriteTitle hasShadow:false ColorType:#rgbFilter isMRSkyPortal:true 

		-- End Localization

		for x in 1 to LLister.mrSkyPortalLightsList.count where (CanAddControls = LLister.count < LightCountLimit) do
		(
		append LLister.LightIndex LLister.mrSkyPortalLightsList[x]
		createControls hasShadow:false hasDecay:false hasSize:false ColorType:#rgbFilter isMRSkyPortal:true
		LLister.count += 1
		LLister.LightInspectorSetup.pbar.value = LLister.count*100/LLister.totalLightCount
		) -- end For i in mr_Sky_Portal Lights
	)
	
	-- Callback Handlers

	LLister.maxLightsRC.addHandler "maxLightsRollout" #'open' filter:off \
		codeStr:("LLister.DeleteCallback = when LLister.UIControlList[1] deleted obj do" + \
		"\n(\nlocal foundMe = findItem LLister.UIControlList[1] obj\n" + \
		"if foundMe > 0 do\n(\n" + \
		"LLister.disableUIElements LLister.UIControlList[2][foundMe]\n)\n)")

	LLister.maxLightsRC.addHandler "maxLightsRollout" #'close' filter:off \
		codeStr:"DeleteChangeHandler LLister.DeleteCallback"
		
	-- Removing the Refresh/ProgressBar
	
	LLister.LightInspectorSetup.pbar.value = 0
	LLister.LightInspectorSetup.pbar.visible = false
	
	-- AB: Jun 20, 2002
	-- Add a new control that tells users to use the selection mode if they had too many lights in the list
	
	if not CanAddControls and LLister.maxLightsRC.str != "" do 
		LLister.maxLightsRC.addControl #label #lbLimitControls "The maximum number of Lights has been reached, please select fewer lights and use the Selected Lights option" \
			paramStr:" align:#center offset:[0,10]"
	
	if LLister.maxLightsRC.str != "" then LLister.maxLightsRC.end() else undefined
)

LLister.CreateLightRollout = CreateLightRollout

LLister.GlobalLightParameters =
(local GlobalLightParameters
rollout GlobalLightParameters "General Settings"
(
	
	-- Start Localization
	
	radioButtons rbtoggle labels:#("Selected Lights","All Lights")
	
	local lblOffset = -18 + (if LListeryOffset == undefined then 0 else LListerYOffset)
	
	label lb01 "On" align:#left offset:[-6,-3]
	label lb03 "Multiplier"  align:#left offset:[12,lblOffset]
	label lb03a "Multiplier (%)" align:#left offset:[81,lblOffset] visible:(ProductAppID == #vizR)
	label lb04 "Color"  align:#left offset:[67,lblOffset]
	label lb05 "Shadows"  align:#left offset:[96,lblOffset]
	label lb06 "Map Size"  align:#left offset:[229,lblOffset] visible:(ProductAppID != #VIZR)
	label lb07 "Bias"  align:#left offset:[286,lblOffset] visible:(ProductAppID != #VIZR)
	label lb08 "Sm.Range"  align:#left offset:[337,lblOffset] visible:(ProductAppID != #VIZR)
	label lb09 "Trans."  align:#left offset:[390,lblOffset] visible:(ProductAppID != #VIZR)
	label lb10 "Int."  align:#left offset:[424,lblOffset] visible:(ProductAppID != #VIZR)
	label lb11 "Qual."  align:#left offset:[461,lblOffset] visible:(ProductAppID != #VIZR)
	label lb12 "Decay"  align:#left offset:[505,lblOffset] visible:(ProductAppID != #VIZR)
	label lb13 "Start"  align:#left offset:[586,lblOffset] visible:(ProductAppID != #VIZR)
	label lb14 "Length"  align:#left offset:[643,lblOffset] visible:(ProductAppID != #VIZR)
	label lb15 "Width"  align:#left offset:[699,lblOffset] visible:(ProductAppID != #VIZR)
	-- End Localization

	checkBox lightOn "" width:15 checked:true offset:[-4,0]
	spinner lightInten "" fieldWidth:45 type:#float range:[-10000,10000,1500] align:#left offset:[10,-20+ LListeryOffset] visible:(ProductAppID == #vizR)
	checkBox lightMultOn "" width:15 checked:false offset:[81,-20+ LListeryOffset] visible:(ProductAppID == #vizR)
	spinner lightMult "" fieldWidth:45 type:#float range:[-10000,10000,1.0] align:#left offset:[10,-20+ LListeryOffset]
	colorPicker lightCol "" width:25 color:white offset:[66,-23+ LListeryOffset]
	checkBox shadowOn "" width:15 checked:true offset:[96,-22+ LListeryOffset]
	dropDownList shadowType width:115 items:LLister.ShadowPluginsName offset:[113,-23+ LListeryOffset] visible:(ProductAppID != #vizR)
	spinner ShadowMapSize "" fieldWidth:45 type:#integer range:[0,10000,512] align:#left offset:[227,-24+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner ShadowBias "" fieldWidth:45 type:#float range:[0,10000,0.5] align:#left offset:[284,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner ShadowSmpRange "" fieldWidth:45 type:#float range:[0,50,4.0] align:#left offset:[341,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)
	checkBox shadowTrans "" width:15 offset:[401,-20+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner ShadowInteg "" fieldWidth:30 type:#integer range:[0,15,1] align:#left offset:[415,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner ShadowQual 	"" fieldWidth:30 type:#Integer range:[0,15,2] align:#left offset:[459,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)
	dropDownList lightDecay width:80 items:LLister.decayStrings offset:[504,-23+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner lightDecaySt "" fieldWidth:45 type:#float range:[0,10000,40] align:#left offset:[584,-24+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner lightLength "" fieldWidth:45 type:#float range:[0,10000,40] align:#left offset:[641,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)
	spinner lightWidth "" fieldWidth:45 type:#float range:[0,10000,40] align:#left offset:[697,-21+ LListeryOffset] visible:(ProductAppID != #VIZR)

	group ""
	(
	
	-- Start Localization
	
	colorpicker gTint "Global Tint:" color:lightTintColor visible:(ProductAppID != #VIZR) offset:[180,0]
	spinner gLevel "Global Level:" range:[0,10000,lightLevel]  fieldWidth:45 align:#left offset:[290,-22+ LListeryOffset] visible:(ProductAppID != #VIZR)
	colorPicker cpAmbient "Ambient Color" color:ambientColor offset:[420,-24+ LListeryOffset] visible:(ProductAppID != #VIZR)
	
	-- End Localization
	
	)
	
	on GlobalLightParameters open do
	(
		if ProductAppID == #vizR do
		(
			lightmult.range = [0,1000000.0,100.0]
			lb03.text = "Intensity (cd)"
			lb04.pos = lb04.pos + [88,0]
			lb05.pos = lb05.pos + [87,0]
			lightmult.pos = lightMult.pos + [87,0]
			lightCol.pos = lightCol.pos + [88,0]
			shadowOn.pos = shadowOn.pos + [88,0]
		)
		dialogUp = true
	)
	
	on GlobalLightParameters close do
	(
		dialogUp = false
		updateToolbarButtons()
	)
	
	on gtint changed val do lightTintColor = val
	on glevel changed val do lightLevel = val
	on cpAmbient changed val do ambientColor = val
	
	fn setCollectionProperty prop val CreateUndo:true =
	(
		if createUndo then
		(
			undo "LightLister" on 
			(
				local myCollection = if rbToggle.state == 1 then Selection else Lights
				for i in myCollection do 
				(
					setLightProp i.baseobject prop val
					setShdProp i.baseObject prop val
				)
			)
		)
		else
		(
			local myCollection = if rbToggle.state == 1 then Selection else Lights
			for i in myCollection do
			(
				setLightProp i.baseobject prop val
				setShdProp i.baseObject prop val
			)
		)
	)
	
	on lightOn changed state do setCollectionProperty #enabled state
	on lightCol changed val do 
	(
		setCollectionProperty #color val CreateUndo:false
		setCollectionProperty #filter_Color val CreateUndo:false
		setCollectionProperty #filterColor val CreateUndo:false
	)
	on shadowOn changed state do setCollectionProperty #castShadows state
	on shadowTrans changed state do setCollectionProperty #shadow_transparent state
	on shadowInteg changed val do setCollectionProperty #pass1 val CreateUndo:false
	on shadowQual changed val do setCollectionProperty #pass2 val CreateUndo:false
	on lightWidth changed val do setCollectionProperty #light_Width val CreateUndo:false
	on lightLength changed val do setCollectionProperty #light_Length val CreateUndo:false
	on lightMult changed val do 
	(
		setCollectionProperty #multiplier val CreateUndo:false
		if ProductAppID != #VIZR do setCollectionProperty #intensity val CreateUndo:false
		setCollectionProperty #dimmer val CreateUndo:false
	)
	on lightMultOn changed state do setCollectionProperty #useMultiplier state
	on lightInten changed val do setCollectionProperty #intensity val CreateUndo:false
	on ShadowMapSize changed val do setCollectionProperty #mapSize val CreateUndo:false
	on ShadowSmpRange changed val do setCollectionProperty #sampleRange val CreateUndo:false
	on lightDecaySt changed val do setCollectionProperty #decayRadius val CreateUndo:false
	on lightDecay selected d do setCollectionProperty #attenDecay d
	on shadowBias changed val do
	(
		setCollectionProperty #mapBias val CreateUndo:false
		setCollectionProperty #ray_Bias val CreateUndo:false
		setCollectionProperty #raytraceBias val CreateUndo:false
	)
	
	on shadowType selected j do
	(
		local myCollection = if rbToggle.state == 1 then Selection else Lights
		for i in myCollection do setLightProp i.baseobject #shadowGenerator (LLister.ShadowPlugins[j]())
	)

) -- end Rollout
) -- end structDef
local lblSelector

if ProductAppID == #VIZR then lblSelector = #("Scene","Selection","Batch Update") -- localize
	else lblSelector = #("All Lights","Selected Lights","General Settings") -- localize

LLister.LightInspectorSetup =
(local LightInspectorSetup
rollout LightInspectorSetup "Configuration" -- Localize
(
	radiobuttons rolloutSelector labels:lblSelector
	checkbutton btnReload "Refresh" align:#right offset:[0,-20] height:16 highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) checked:false -- Localize
	progressBar pbar width:120 pos:(btnReload.pos - [125,-1])
	
	on rolloutSelector changed state do
	(
		rolloutSelector.state = state
		case rolloutSelector.state of
		(
		1:	(
			btnReload.visible = false
			try(RemoveRollout LLister.GlobalLightParameters LLister.LightInspectorFloater) catch()
			try(RemoveRollout LLister.LightInspectorListRollout LLister.LightInspectorFloater) catch()
			LLister.LightInspectorListRollout = LLister.CreateLightRollout (Lights as array + helpers as array)
			if LLister.LightInspectorListRollout != undefined do
				addRollout LLister.LightInspectorListRollout LLister.LightInspectorFloater
			LLister.maxLightsRC = undefined
			gc light:true
			btnReload.visible = true
			)
		2:	(
			btnReload.visible = false
			try(RemoveRollout LLister.GlobalLightParameters LLister.LightInspectorFloater) catch()
			try(RemoveRollout LLister.LightInspectorListRollout LLister.LightInspectorFloater) catch()
			LLister.LightInspectorListRollout = LLister.CreateLightRollout Selection
			if LLister.LightInspectorListRollout != undefined do
				addRollout LLister.LightInspectorListRollout LLister.LightInspectorFloater
			LLister.maxLightsRC = undefined
			gc light:true
			btnReload.visible = true
			)
		3:	(
			try(RemoveRollout LLister.GlobalLightParameters LLister.LightInspectorFloater) catch()
			try(RemoveRollout LLister.LightInspectorListRollout LLister.LightInspectorFloater) catch()
			addRollout LLister.GlobalLightParameters LLister.LightInspectorFloater
			btnReload.visible = false
			)
		)
	)
	
	on btnReload changed state do
	(
		rolloutSelector.changed rolloutSelector.state
		btnReload.checked = false
	)

	on LightInspectorSetup close do
	(
		callBacks.RemoveScripts id:#LListerRollout
		setIniSetting "$plugCfg/LLister.cfg" "General" "DialogPos" (LLister.LightInspectorFloater.Pos as string) -- do not localize
		setIniSetting "$plugCfg/LLister.cfg" "General" "DialogSize" (LLister.LightInspectorFloater.Size as string) -- do not localize
		setIniSetting "$plugCfg/LLister.cfg" "General" "LastState" (rolloutSelector.state as string) -- do not localize
		
		dialogUp = false
		updateToolbarButtons()
	)
	
	on LightInspectorSetup open do
	(
		if ProductAppID == #vizR do rolloutSelector.pos = rolloutSelector.pos - [30,0,0]
		pbar.visible = false
		local lastState = (getIniSetting "$plugCfg/LLister.cfg" "General" "LastState") as integer  -- do not localize
		if lastState == 0 do lastState = 1
		if lastState < 4 do
			rolloutSelector.changed lastState
		LLister.maxLightsRC = undefined
		gc light:true

		-- Callbacks to remove Floater
		callBacks.AddScript #systemPreReset "CloseRolloutFloater LLister.LightInspectorFloater" id:#LListerRollout  -- do not localize
		callBacks.AddScript #systemPreNew "CloseRolloutFloater LLister.LightInspectorFloater" id:#LListerRollout -- do not localize
		callBacks.AddScript #filePreOpen "CloseRolloutFloater LLister.LightInspectorFloater" id:#LListerRollout -- do not localize
		
		dialogUp = true
		updateToolbarButtons()
	)
	
) -- end Rollout
) -- end StructDef

on execute do
	(

	-- Loading rollout size and position, if available
	
	local dialogPos, dialogSize
	
	dialogPos = execute (getIniSetting "$plugCfg/LLister.cfg" "General" "DialogPos") -- Do not localize
	dialogSize = execute (getIniSetting "$plugCfg/LLister.cfg" "General" "DialogSize") -- Do not localize
	
	if classof DialogPos != Point2 do dialogPos = [200,300]
	if classof DialogSize != Point2 do if ProductAppID != #VIZR then dialogSize = [800,300] else dialogSize = [360,300]
	
	if ProductAppID != #VIZR then DialogSize.x = 800 else DialogSize.x = 360
	
	try(closeRolloutFloater LLister.LightInspectorFloater) catch()
	LLister.LightInspectorFloater = newRolloutFloater "Light Lister" dialogSize.x dialogSize.y dialogPos.x dialogPos.y
	
	addRollout LLister.LightInspectorSetup LLister.LightInspectorFloater
	dialogUp = true
	)

on closeDialogs do
	(
		try(closeRolloutFloater LLister.LightInspectorFloater) catch( print "Error in LightLister" )	
		dialogUp = false	
	)
on isChecked return
	(
		dialogUp
	)
)
