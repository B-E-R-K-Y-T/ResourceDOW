/*
 Custom Attributes MacroScript File

 Created:  		May 15 2000
 Author :   Frank DeLise
 Version:  3ds max 6
 
 Revision History:
 
 	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
	16 mar 2004, Larry Minton
		added explicit track picking, code cleanup, addition of more parameter types
 	30 mar 2004, Larry Minton
		added editing of existing parameters
 	08 apr 2004, Larry Minton
		added SV and TV macroscripts
	13 apr 2004, Larry Minton
		added parameter renaming
	14 apr 2004, Larry Minton
		added string parameter
	06 may 2004, Larry Minton
		added View_Custom_Attributes, combined Edit and Delete dialogs

 Custom Attributes Macroscript file.
 Uses structures defined in file: stdplugs\stdscripts\custattribstructs.ms
 
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--
--  This Script Adds Custom Attributes to Objects. An Object is just about anything in MAX,
--  including modifiers, base objects, nodes, root scene node, materials, controllers, render
--  effects, render elements, and bake elements.
*/

-- if name or internal category change, update macro.run calls in TV and SV versions below
MacroScript Custom_Attributes
	enabledIn:#("max") --pfb: 2003.12.11 added product switch
	ButtonText:"Parameter Editor..." --pfbreton 29 mai 2003 added "..."
	Category:"Customize User Interface" 
	internalCategory:"Customize User Interface" 
	Tooltip:"Parameter Editor" --pfbreton 29 mai 2003 added "..."
	SilentErrors:false -- (CAT_Debug != True)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Localization Notes
--
-- /* Localize On */ states an area where localization should begin
-- /* Localize Off */ states an area where localization should end
--
-- *** Localization Note *** states that the next line has special localization instructions for the next line.
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(
	global CAT_Debug = false -- true --  x
	global CAT_Debug2 = false -- true -- x

	global	CAT_ParamBlock, CAT_UIItem -- structure definitions
	global	CAT_ParamBlock_Array, CAT_UIItems_Array -- arrays containing instances of CAT_ParamBlock and CAT_UIItem structs
	global	CAT_Source -- 2 element array containing the CAT_ParamBlock_Array and CAT_UIItems_Array arrays. Stored with the attribute definition
	global	CAT_Param_Remap -- if not undefined, 2 element array. Each element is array of names, where element 1 array is orig param name, element 2 array is new param name

	local	CAT_DefData_Current_Version = 2 -- the current version number of the def data format. Used for updating old data defs

	-- the rollouts for the various UI options for each data type
	local	CAT_PropRoll_Boolean, CAT_PropRoll_Float, CAT_PropRoll_Percent, CAT_PropRoll_Angle, CAT_PropRoll_WorldUnits, CAT_PropRoll_Integer, 
			CAT_PropRoll_TextureMap, CAT_PropRoll_Material, CAT_PropRoll_Array, CAT_PropRoll_Color, CAT_PropRoll_Node, CAT_PropRoll_String
	global	CAT_TestRoll -- the Rollout used for testing the current attribute. Dynamically recreated as needed. Must be global.
--	global	CAT_SampleCommandPanel -- the rollout CAT_TestRoll is place into (contains a subRollout)

	-- functions to switch to the rollouts for each data type
	local	CAT_Set_Roll_Boolean, CAT_Set_Roll_Float, CAT_Set_Roll_Percent, CAT_Set_Roll_Angle, CAT_Set_Roll_WorldUnits, CAT_Set_Roll_Integer, 
			CAT_Set_Roll_TextureMap, CAT_Set_Roll_Material, CAT_Set_Roll_Array, CAT_Set_Roll_Color, CAT_Set_Roll_Node, CAT_Set_Roll_String,
			CAT_Set_Roll_NULL 
	local	CAT_Close_Attrib_Rollouts -- function to close the above data type rollouts and the testing rollout
	local	CAT_Open_Attrib_Rollout -- function to open one of the above data type rollouts and the testing rollout
	
	global	CAT_FinishRoll -- the "Attribute" rollout - specifies where to apply the Attribute. Must be global
	
	global	CAT_Floater -- the Custom Attribute rollout floater. Must be global.
	
	global	CAT_SelChange -- function called when selection set changes - must be global
	global	CAT_Reset -- function called on a scene reset - must be global

	global	CAT_OpenDialog -- function that opens the Edit Parameters dialog. Must be global
	global	CAT_SetTargetObject -- function that can be called externally to set the target track to the specified object
	
	-- function to build a ui string using the ROC item data in the provided UIItem structure instance
	local	CAT_BuildUIStringForControl

	-- function of testing to see if name is a MXS token name
	local 	CAT_isReservedToken 

	-- function to fix up 'color as string' strings to include "::" before color
	local 	CAT_FixupColorString 
	
	-- functions for wrapping and unwrapping strings into/from a string
	local	CAT_wrapString, CAT_unwrapString	
	local	CAT_Defs -- the custom attribute definitions read from the target object
	local	CAT_NewAttrib -- info on the new attribute being added
	global	CAT_CurrentDef -- the current custom attribute def. Must be global
	local	CAT_DefData -- the user-supplied def data value for the current custom attribute def
	global	CAT_DEF -- the variable the new cust attribute def is assigned to. Must be global
	local	CAT_UI_Array -- CAT_UI_Array is a string array for the delete and edit listboxes
	
	local	CAT_Current_ParamType	-- The current parameter type as defined by CAT_FinishRoll.CAT_Type dropdown. Valid
									-- values are contained in CAT_ParamIDs
	local	CAT_Current_UIOptionRO	-- The current XXX UI Options rollout
	local	CAT_Current_UIType	-- The current parameter type as defined by CAT_FinishRoll.CAT_UIType dropdown. Valid
								-- values are contained in CAT_UIIDs
	local	CAT_Current_UITypes	-- The currently valid parameter types in the CAT_FinishRoll.CAT_UIType dropdown.
	
	local	CAT_CheckedText, CAT_UIText -- parameter name text. The CheckedText version is surrounded by single quotes
	local	CAT_TextChecker -- function that takes a parameter name, and sets CAT_CheckedText and CAT_UIText 
	local	CAT_substituteString -- function that replaces all occurrences of one string with another in the work string
	
	local	CAT_IsApplying -- flag that is set while applying a ca def
	local	CAT_InEdit -- flag that is set while Edit Attribute rollout is open
	local	CAT_Updating_UI -- keep CAT_EvalUI from looping.  Specifies that you are already updating.
	
	local	CAT_GetDef -- function to get the custom attribute definition from the current object
	local	CAT_DefExist -- function that returns true if there is a custom attribute definition for the current object
	local	CAT_SetDef -- This function is used to set the custom atrributes definition data to the selected object
	local	CAT_EvalUI -- This function builds the "Testing Attribute" dynamic rollout
	local	CAT_AddUI -- This function sets up the parameter and creates the custom attribute definition

	global	CAT_EditUIRoll -- the "Edit Attribute" rollout -- must be global
	global	CAT_EditUIRoll_Height -- the height of the CAT_EditUIRoll dialog -- must be global

	local	CAT_Edit_Set -- Function for initializing the Edits
	local	CAT_PickedTargetObject -- the object selected from the Pick Explicit Track dialog
	global	CAT_TargetObject -- the current target object -- must be global

	Persistent Global CAT_UINum -- the number that is appended to "param" to form a unique name

	local	CAT_AttribName -- the name of the custom attribute definition class
	local	CAT_AttribName_Name -- the name of the custom attribute definition class as a Name value

	-- *** Localization Note ***
	-- don't localize CAT_ParamIDs, can localize CAT_ParamTypes. Order can be changed, but order of item pairs in CAT_ParamIDs 
	-- and CAT_ParamTypes must be maintained
	local	CAT_ParamIDs =   #(#angle, #Array, #boolean, #color, #float, #frgba, #integer, #material, #node, #percent, #string, #textureMap, #worldUnits)
	local	CAT_ParamTypes = #("Angle", "Array", "Boolean", "Color", "Float", "fRGBA", "Integer", "Material", "Node", "Percent", "String", "TextureMap", "WorldUnits")

		
	-- *** Localization Note ***
	-- don't localize CAT_UIIDs, can localize CAT_UITypes. Do not change order of these!
	local	CAT_UIIDs = #(#Spinner, #Slider, #DropDownList, #CheckBox, #CheckButton, #MapButton, #MaterialButton, #ColorPicker, #PickButton,
						  #ComboBox,#ListBox,#EditText)
	local	CAT_UITypes = #("Spinner", "Slider", "DropDownList", "CheckBox", "CheckButton", "MapButton", "MaterialButton", "ColorPicker", "PickButton",
						    "ComboBox","ListBox","EditText")

	-- the following are automatically created local variable names in a scripted CA. A CA parameter cannot be one of these names.
	local localReservedNames = #(#this, #delegate, #version, #loading)
		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout States
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	global	CAT_UI_POS, CAT_UI_Size -- must be global
	global	CAT_FinishRoll_Open	-- Whether the CAT_FinishRoll rollout is opened or not. must be global
	global	CAT_UIOptionRO_Open	-- Whether the current XXX UI Options rollout is opened or not. must be global
	global	CAT_TestRO_Open	-- Whether the Testing Attribute rollout is opened or not. must be global
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Float Options
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/* Localize On */
	
	Rollout CAT_PropRoll_Float "Float UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		local updateTestRange -- local function

		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:100 	Align:#Center 	Type:#Integer 	Range:[1,320,160] 	
		)
		Group "Range"
		(
			Spinner CAT_UIRangeStart 		"From:"		 	Range:[-99999,99999,0] 		Align:#Center 	Across:2 		Type:#Float Width:90
			Spinner CAT_UIRangeEnd 			"To:" 			Range:[-99999,99999,100]	Align:#Right 					Type:#Float Width:90
			Spinner CAT_UIRangeDefault 		"Default:" 		Range:[-99999,99999,0] 		Align:#Center	Across:1 		Type:#Float Width:95	Offset:[-5,0]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	
		Group "Orientation and Ticks"
		(
			CheckBox CAT_Orient "Vertical" Align:#Left Across:2 Enabled:False
			Spinner CAT_Ticks "Ticks:" Type:#Integer Range:[0,999,0] Enabled:False
		)
		
	/* Localize Off */
							
		fn updateTestRange which value =
		(	local range = CAT_TestRoll.controls[1].range
			range[which] = value
			CAT_TestRoll.controls[1].range = range
		)
		
		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()	
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_Orient 				Changed 	State do 	CAT_EvalUI()
		
		On CAT_Ticks		 		Changed 	value do	if CAT_TestRoll.controls[1].ticks != 0 and value != 0 then CAT_TestRoll.controls[1].ticks = value else CAT_EvalUI()

		On CAT_UIRangeStart 		Changed 	Value do	updateTestRange 1 Value 
		On CAT_UIRangeEnd 			Changed		Value do	updateTestRange 2 Value 
		On CAT_UIRangeDefault 		Changed		Value do	updateTestRange 3 Value 
	)
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Percent Options
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/* Localize On */
	
	Rollout CAT_PropRoll_Percent "Percent UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		local updateTestRange -- local function

		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:100 	Align:#Center 	Type:#Integer 	Range:[1,320,160] 	
		)
		Group "Range"
		(
			Spinner CAT_UIRangeStart 		"From:"		 	Range:[-99999,99999,0] 		Align:#Center 	Across:2 		Type:#Float Width:90
			Spinner CAT_UIRangeEnd 			"To:" 			Range:[-99999,99999,100]	Align:#Right 					Type:#Float Width:90
			Spinner CAT_UIRangeDefault 		"Default:" 		Range:[-99999,99999,0] 		Align:#Center	Across:1 		Type:#Float Width:95 Offset:[-5,0]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	
		Group "Orientation and Ticks"
		(
			CheckBox CAT_Orient "Vertical" Align:#Left Across:2 Enabled:False
			Spinner CAT_Ticks "Ticks:" Type:#Integer Range:[0,999,0] Enabled:False
		)
		
	/* Localize Off */
							
		fn updateTestRange which value =
		(	local range = CAT_TestRoll.controls[1].range
			range[which] = value
			CAT_TestRoll.controls[1].range = range
		)
		
		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()	
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_Orient 				Changed 	State do 	CAT_EvalUI()
		
		On CAT_Ticks		 		Changed 	value do	if CAT_TestRoll.controls[1].ticks != 0 and value != 0 then CAT_TestRoll.controls[1].ticks = value else CAT_EvalUI()

		On CAT_UIRangeStart 		Changed 	Value do	updateTestRange 1 Value 
		On CAT_UIRangeEnd 			Changed		Value do	updateTestRange 2 Value 
		On CAT_UIRangeDefault 		Changed		Value do	updateTestRange 3 Value 
	)
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Angle Options
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/* Localize On */
	
	Rollout CAT_PropRoll_Angle "Angle UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		local updateTestRange -- local function

		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:100 	Align:#Center 	Type:#Integer 	Range:[1,320,160] 	
		)
		Group "Range"
		(
			Spinner CAT_UIRangeStart 		"From:"		 	Range:[-99999,99999,0] 		Align:#Center 	Across:2 		Type:#Float Width:90
			Spinner CAT_UIRangeEnd 			"To:" 			Range:[-99999,99999,360]	Align:#Right 					Type:#Float Width:90
			Spinner CAT_UIRangeDefault 		"Default:" 		Range:[-99999,99999,0] 		Align:#Center	Across:1 		Type:#Float Width:95 Offset:[-5,0]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	
		Group "Orientation and Ticks"
		(
			CheckBox CAT_Orient "Vertical" Align:#Left Across:2 Enabled:False
			Spinner CAT_Ticks "Ticks:" Type:#Integer Range:[0,999,0] Enabled:False
		)
		
	/* Localize Off */
							
		fn updateTestRange which value =
		(	local range = CAT_TestRoll.controls[1].range
			range[which] = value
			CAT_TestRoll.controls[1].range = range
		)
		
		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()	
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_Orient 				Changed 	State do 	CAT_EvalUI()
		
		On CAT_Ticks		 		Changed 	value do	if CAT_TestRoll.controls[1].ticks != 0 and value != 0 then CAT_TestRoll.controls[1].ticks = value else CAT_EvalUI()

		On CAT_UIRangeStart 		Changed 	Value do	updateTestRange 1 Value 
		On CAT_UIRangeEnd 			Changed		Value do	updateTestRange 2 Value 
		On CAT_UIRangeDefault 		Changed		Value do	updateTestRange 3 Value 
	)
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for WorldUnits Options
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/* Localize On */
	
	Rollout CAT_PropRoll_WorldUnits "WorldUnits UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		local rangeVal = 1e7-1
		local updateTestRange -- local function
		
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:100 	Align:#Center 	Type:#Integer 	Range:[1,320,160] 	
		)
		Group "Range"
		(
			Spinner CAT_UIRangeStart 		"From:"		 	Range:[-rangeVal,rangeVal,0] 		Align:#Left 	Across:2 		Type:#WorldUnits fieldWidth:62 Offset:[-5,0]
			Spinner CAT_UIRangeEnd 			"To:" 			Range:[-rangeVal,rangeVal,rangeVal]	Align:#Right 					Type:#WorldUnits fieldWidth:62 Offset:[2,0]
			Spinner CAT_UIRangeDefault 		"Default:" 		Range:[-rangeVal,rangeVal,0] 		Align:#Center	Across:1 		Type:#WorldUnits fieldWidth:60 Offset:[-5,0]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	
		Group "Orientation and Ticks"
		(
			CheckBox CAT_Orient "Vertical" Align:#Left Across:2 Enabled:False
			Spinner CAT_Ticks "Ticks:" Type:#Integer Range:[0,999,0] Enabled:False
		)
		
	/* Localize Off */
							
		fn updateTestRange which value =
		(	local range = CAT_TestRoll.controls[1].range
			range[which] = value
			CAT_TestRoll.controls[1].range = range
		)
		
		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()	
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_Orient 				Changed 	State do 	CAT_EvalUI()
		
		On CAT_Ticks		 		Changed 	value do	if CAT_TestRoll.controls[1].ticks != 0 and value != 0 then CAT_TestRoll.controls[1].ticks = value else CAT_EvalUI()

		On CAT_UIRangeStart 		Changed 	Value do	updateTestRange 1 Value 
		On CAT_UIRangeEnd 			Changed		Value do	updateTestRange 2 Value 
		On CAT_UIRangeDefault 		Changed		Value do	updateTestRange 3 Value 
	)
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Integer Options
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/* Localize On */
		
	Rollout CAT_PropRoll_Integer "Integer UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		local updateTestRange -- local function
		
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:100 	Align:#Center 	Type:#Integer 	Range:[1,320,160] 	
		)
		Group "Range"
		(
			Spinner CAT_UIRangeStart 	"From:"		 	Range:[-99999,99999,0] 		Align:#Center 	Across:2 	Type:#Integer Width:90
			Spinner CAT_UIRangeEnd 		"To:" 			Range:[-99999,99999,100]	Align:#Right 				Type:#Integer Width:90
			Spinner CAT_UIRangeDefault "Default:" 		Range:[-99999,99999,0] 		Align:#Center	Across:1 	Type:#Integer Width:90 Offset:[-5,0]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	
		Group "Orientation and Ticks"
		(
			CheckBox CAT_Orient "Vertical" Align:#Left Across:2 Enabled:False
			Spinner CAT_Ticks "Ticks:" Type:#Integer Range:[0,999,0] Enabled:False
		)
		
	/* Localize Off */	
	
		fn updateTestRange which value =
		(	local range = CAT_TestRoll.controls[1].range
			range[which] = value
			CAT_TestRoll.controls[1].range = range
		)
		
		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()	
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_Orient 				Changed 	State do 	CAT_EvalUI()
		
		On CAT_Ticks		 		Changed 	value do	if CAT_TestRoll.controls[1].ticks != 0 and value != 0 then CAT_TestRoll.controls[1].ticks = value else CAT_EvalUI()

		On CAT_UIRangeStart 		Changed 	Value do	updateTestRange 1 Value 
		On CAT_UIRangeEnd 			Changed		Value do	updateTestRange 2 Value 
		On CAT_UIRangeDefault 		Changed		Value do	updateTestRange 3 Value 

	)
		
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Boolean Options
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/* Localize On */
	
	Rollout CAT_PropRoll_Boolean "Boolean UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer	 Range:[1,320,70] 	Across:2
			Spinner CAT_Height 	"Height:"	Width:70 	Align:#Right 	Type:#Integer	 Range:[1,160,15]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)	

		Group "Check Button Options"
		(
			ColorPicker CAT_HighLight "Highlight Color:" Color:[253,221,8] Enabled:False modal:true
		)
			
	/* Localize Off */
		
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	

		On CAT_Highlight 			Changed		Value do	CAT_TestRoll.controls[1].HighlightColor = Value
	)
	
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Array Options
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/* Localize On */
	
	Rollout CAT_PropRoll_Array "Array UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		Local CAT_MyArray = #() -- note: used in CAT_EvalUI
		
		Group "Size"
		(
			Spinner CAT_Width 	"Width:"	Width:70	Align:#Right 	Type:#Integer 	Range:[1,320,150] 	Across:2
			Spinner CAT_Height 	"Height:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,160,5]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)
		Group "Array"
		(
			EditText CAT_ArrayName "Item name:"
			Button CAT_AddItem "Add Item" Across:3 Width:60 offset:[-3,0]
			Button CAT_DeleteItem "Delete Item" Width:60 offset:[4,0]
			Button CAT_ClearArray "Clear Array" Width:60 offset:[5,0]
			ListBox CAT_AItems ""	
		)
			
	/* Localize Off */

		On CAT_AddItem pressed do
		(
			if CAT_Debug == true do format "CAT_ArrayName.Text: %\n" CAT_UIText
			Append CAT_MyArray (CAT_wrapString CAT_ArrayName.Text)
			
			formatted_name_array = #()
			for text_string in CAT_MyArray do
				Append formatted_name_array (CAT_unwrapString text_string)
			CAT_AItems.items = formatted_name_array
			
			CAT_ArrayName.Text = ""
			
			CAT_EvalUI()
			setfocus CAT_ArrayName
		)	
		
		On CAT_DeleteItem pressed do
		(
			if CAT_AItems.selection != 0 do 
			(
				deleteItem CAT_MyArray CAT_AItems.selection 
				
				formatted_name_array = #()
				for text_string in CAT_MyArray do
					Append formatted_name_array (CAT_unwrapString text_string)
				CAT_AItems.items = formatted_name_array
				
				CAT_EvalUI()
			)
		)	
		
		On CAT_ClearArray Pressed do
		(	
			CAT_MyArray = #()
			CAT_AItems.items = CAT_MyArray
			CAT_EvalUI()
		)

		On CAT_Width 				Changed		value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
	)
	
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Color Options
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/* Localize On */

	Rollout CAT_PropRoll_Color "Color UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,320,100] 	Across:2
			Spinner CAT_Height 	"Height:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,160,25]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)
		Group "ColorPicker Default Color"
		(
			ColorPicker CAT_DColor "Default Color:" Color:[253,221,8] Enabled:True modal:true
		)
			
	/* Localize Off */
			
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_DColor				Changed		Value do	CAT_TestRoll.controls[1].color = Value
	)
		
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Node Options
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This is the rollup for editing Node picking options

	/* Localize On */
	
	Rollout CAT_PropRoll_Node "Node UI Options" SilentErrors:false -- (CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,320,150] 	Across:2
			Spinner CAT_Height 	"Height:"	Width:70	Align:#Right 	Type:#Integer 	Range:[1,160,25]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)
			
	/* Localize Off */
		
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
	)

	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for TextureMap Options
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This is the rollup for editing Map Button options
	
	/* Localize On */
	
	Rollout CAT_PropRoll_TextureMap "TextureMap UI Options" SilentErrors:false --(CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer	Range:[1,320,150] 	Across:2
			Spinner CAT_Height 	"Height:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,160,25]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)

	/* Localize Off */	
			
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
	)
		
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Material Options
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This is the rollup for editing Material Button options
	
	/* Localize On */
	
	Rollout CAT_PropRoll_Material "Material UI Options" SilentErrors:false --(CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer	Range:[1,320,150] 	Across:2
			Spinner CAT_Height 	"Height:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,160,25]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)

	/* Localize Off */	
			
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
	)
		
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for String Options
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This is the rollup for editing EditText options
	
	/* Localize On */
	
	Rollout CAT_PropRoll_String "String UI Options" SilentErrors:false --(CAT_Debug != True)
	(
		Group "Size"
		(
			Spinner CAT_Width 	"Width:" 	Width:70 	Align:#Right 	Type:#Integer	Range:[1,320,150] 	Across:2
			Spinner CAT_Height 	"Height:" 	Width:70 	Align:#Right 	Type:#Integer 	Range:[1,160,17]
		)
		Group "Alignment"
		(
			RadioButtons CAT_Align Labels:#("Left", "Right", "Center") columns:3 Across:1 Default:3
			Spinner CAT_UIOffset_X			"Offsets:  X:"	Range:[-99999,99999,0]		Align:#Left		Across:2		Type:#Integer		Offset:[10,0]
			Spinner CAT_UIOffset_Y			"Y:"			Range:[-99999,99999,0]		Align:#Right					Type:#Integer 		Offset:[-10,0]
		)
		Group "Label"
		(
			checkbox CAT_UILabelOnTop	"Label above text box"
		)
		Group "EditText Default Text"
		(
			EditText CAT_DText "Default Text:" text:"" Enabled:True
		)

	/* Localize Off */	
			
		On CAT_Width 				Changed		Value do 	CAT_EvalUI()
		On CAT_Height 				Changed 	Value do	CAT_EvalUI()
		On CAT_Align 				Changed		State do	CAT_EvalUI()
		On CAT_UIOffset_X			Changed		Value do	CAT_EvalUI()	
		On CAT_UIOffset_Y			Changed		Value do	CAT_EvalUI()	
		On CAT_UILabelOnTop			Changed		State do	CAT_EvalUI()	
		On CAT_DText 				Changed		Value do	CAT_TestRoll.controls[1].text = Value
	)
		
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Creating the final Attribute
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/* Localize On */
				
	Rollout CAT_FinishRoll "Attribute" SilentErrors:false --(CAT_Debug != True)
	(
		local update_buttons, reg_delayed_update_buttons, setTargetObject  -- local functions
		local DoUpdateButtonStateRegistered = false -- local variable
		
		Group "Add to Type:"
		(
			DropDownList CAT_AddTo Items:#("Selected Object's Base Level", "Selected Object's Current Modifier", "Selected Object's Material", "Picked Track") 
			checkbutton CAT_PickTrack align:#left offset:[-5,3] images:#("TrackViewTools_16i.bmp",undefined,108,1,1,1,1) tooltip:"Pick Explicit Track"
			listbox CAT_PickedTrack "" items:#("Pick Explicit Track","") width:170 align:#left offset:[16,-32] readonly:true enabled:false height:2 selection:0
		)
		Group "Add/Edit/Delete"
		(
			Button CAT_Add  	"Add" 		Width:90 	Across:2	Height:20
			Button CAT_Update	"Edit/Delete..."	Width:90				Height:20
			Label CAT_L2 		"" 			Offset:[0,-14]
		)
	
		Group "Parameter Type:"
		(
			DropDownList CAT_Type Items:CAT_ParamTypes height:14
		)
		
		Group "UI Type"
		(
			DropDownList CAT_UIType
			EditText CAT_UIName "Name:" text:"Param"
		)

	/* Localize Off */
	
		On CAT_FinishRoll open do 
		(
			if CAT_UIText != undefined do CAT_UIName.text = CAT_UIText
			CAT_Current_ParamType = #Float -- always start with float value spinner
			CAT_Type.selection = findItem CAT_ParamIDs CAT_Current_ParamType
			CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
			CAT_Current_UIType = CAT_UIIDs[1]
			update_buttons()
			callbacks.addScript #modPanelObjPostChange "CAT_FinishRoll.reg_delayed_update_buttons()" id:#CAT_UpdateApplyButtons
			DoUpdateButtonStateRegistered = false
		)

		on CAT_FinishRoll oktoclose do 
		(
			try
			(
				CAT_FinishRoll_Open = CAT_FinishRoll.open
				CAT_UIOptionRO_Open = CAT_Current_UIOptionRO.open
				CAT_TestRO_Open = CAT_TestRoll.open
			)
			catch()
			true
		)
		
		On CAT_FinishRoll close do 
		(
			callbacks.removeScripts id:#CAT_UpdateApplyButtons
			
			CAT_InEdit = false
			
			-- note: don't remove #systemPreReset, #filePreOpenor or #systemPreNew callbacks, and don't set 
			-- CAT_Reset to undefined - want active even when dialog isn't up.
			-- don't delete rollouts (except CAT_TestRoll) or any functions
			CallBacks.RemoveScripts #SelectionSetChanged ID:#CAT_Callback
			if CAT_EditUIRoll != undefined do 
			(
				CAT_EditUIRoll.inUpdate = false
				DestroyDialog CAT_EditUIRoll
			)

			CAT_DEF = CAT_Defs = CAT_CurrentDef = CAT_NewAttrib = CAT_DefData = undefined
			CAT_TargetObject = CAT_PickedTargetObject = undefined
			CAT_ParamBlock_Array = CAT_UIItems_Array = CAT_Source = CAT_UI_Array = undefined
			CAT_Floater = undefined
			CAT_CheckedText = CAT_UIText = CAT_AttribName = CAT_AttribName_Name = CAT_Updating_UI = undefined

			updateToolbarButtons()
		)
		
		On CAT_FinishRoll moved pos do
		(
			CAT_UI_POS = pos
		)
		
		On CAT_FinishRoll Resized Size do
		(
			CAT_UI_Size = Size
		)
		
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This is where the whole thing begins. :) When "Add" in the UI is pressed the code starts here....
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		On CAT_Add Pressed do
		(
			---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			-- If Attribute exists, extract definition. Clears UI and ParamBlock Arrays
			---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			CAT_GetDef()
			
			---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			-- Check for duplicate UI items
			---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			CAT_TextChecker CAT_UIName.text
			
			
			local paramExists = false
			for param in CAT_Paramblock_Array while not paramExists do
			(
				if CAT_Debug == True then Format "param name: >%<; CAT_CheckedText: >%<\n" param.name CAT_CheckedText
				paramExists = (stricmp param.name CAT_CheckedText) == 0
			)
			
			/* Localize On */
			
			if CAT_CheckedText == "''" then 
				MessageBox "Null Parameter Names Not Allowed!\nPlease Enter a New Name" Title:"Custom Attributes" 
			
			else if paramExists then 
				MessageBox "Parameter Name Exists!\nPlease Enter a New Name" Title:"Custom Attributes" 

			else if CAT_isReservedToken CAT_UIText or (finditem localReservedNames (CAT_UIText as name) != 0) then 
				MessageBox "Specified Parameter Name Not Allowed!\nPlease Enter a New Name" Title:"Custom Attributes"
			
			/* Localize Off */
			
			else
			(
				undo "Add CA" on 
				(
					---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					--- Call the CAT_AddUI function, This function sets up the parameter and creates the custom attribute definition
					--- set add mode true
					---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

					ui_added = CAT_AddUI isAddingParam:true
					
					---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					-- Once the UI item is added, append the new UI item and Paramblock item into the following 2 arrays 
					---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					 if ui_added == true do
					 (
						Append CAT_ParamBlock_Array CAT_NewAttrib[1]
						Append CAT_UIItems_Array CAT_NewAttrib[2]
						
						-- Debug Print
						
						If CAT_Debug == True then Format "Added ParamBlock Item: %\n" CAT_ParamBlock_Array[CAT_ParamBlock_Array.count].name
						If CAT_Debug == True then Format "Added UI Item: %\n" CAT_ParamBlock_Array[CAT_ParamBlock_Array.count].name
						
						If CAT_Debug == True then Format "New ParamBlock Array: %\n" CAT_ParamBlock_Array
						If CAT_Debug == True then Format "New UIItems Array: %\n" CAT_UIItems_Array
						
						CAT_Source[1] = CAT_ParamBlock_Array
						CAT_Source[2] = CAT_UIItems_Array
					 
						---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						-- This takes the new paramblock and UI Items and sets it into the object as the new defdata using CAT_SetDef() function 
						---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

						CAT_SetDef ()
					
						---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						-- Increment the param name number and reset the UI name fields
						--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
						CAT_UINum += 1
						CAT_CheckedText = CAT_UIText = ("Param" + CAT_UINum as string)
						CAT_FinishRoll.CAT_UIName.text = CAT_UIText
				 	 ) 
				) -- undo off
				
				CAT_EvalUI()
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- Update UI List
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				CAT_GetDef()
			)
		)
	
							
		On CAT_Update Pressed do
		(
			CAT_GetDef()
			CreateDialog CAT_EditUIRoll Pos:([CAT_Floater.Pos.x + 225, CAT_Floater.Pos.y + 250]) Width:220 Height:275 lockheight:false lockwidth:true style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
		)
		
		on CAT_AddTo selected arg do
		(
			if arg == 4 and CAT_PickedTargetObject == undefined do
			(
				CAT_PickTrack.state = true
				CAT_PickTrack.changed true
			)
			update_buttons()
		)
		
		fn update_buttons =
		(
			if (not CAT_IsApplying) do
			(
				If CAT_Debug == True then Format "update_buttons called\n"
				
				if (CAT_InEdit) then
				(
					CAT_PickTrack.enabled = CAT_PickedTrack.enabled = CAT_AddTo.enabled = CAT_Add.enabled = CAT_Update.enabled = false
					CAT_Type.enabled = false
--					CAT_UIName.enabled = false
				)
				else
				(
					CAT_PickedTrack.enabled = CAT_AddTo.selection == 4 and CAT_PickedTargetObject != undefined
					CAT_PickTrack.enabled = CAT_AddTo.enabled = true
					CAT_Type.enabled = true
--					CAT_UIName.enabled = true
					
					if CAT_AddTo.selection == 4 then
					(
						CAT_TargetObject = CAT_PickedTargetObject
						CAT_TargetNode = undefined
					)
					else if selection.count == 1 then
					(
						CAT_TargetNode = Selection[1]
						CAT_TargetObject = 
							Case CAT_AddTo.selection of
							(
								1: CAT_TargetNode.baseobject
								2: (	local curObj = modpanel.getcurrentObject()
										if (isKindOf curObj Modifier) then curObj else undefined
								   )
								3: CAT_TargetNode.material
							)
					)
					else
						CAT_TargetObject = CAT_TargetNode = undefined
						
					local buttonsEnabled = CAT_TargetObject != undefined
					CAT_Add.enabled = CAT_Update.enabled = buttonsEnabled 
		
					if DoUpdateButtonStateRegistered do
					(
						unregisterRedrawViewsCallback update_buttons 
						DoUpdateButtonStateRegistered = false
					)
				)
			)
		)
		
		fn reg_delayed_update_buttons =
		(
			if not DoUpdateButtonStateRegistered do
			(
				DoUpdateButtonStateRegistered = true
				registerRedrawViewsCallback update_buttons 
				If CAT_Debug == True then Format "reg_delayed_update_buttons performed\n"
			)
		)
		
		fn setTargetObject pickObj name1 name2 = 
		(
			CAT_PickedTrack.items = #(name1,name2)
			CAT_PickedTrack.enabled = true
			CAT_PickedTargetObject = CAT_TargetObject = pickObj 
			CAT_AddTo.selection = 4
			CAT_Add.enabled = CAT_Update.enabled = true
		)
		
		on CAT_PickTrack changed state do
		(	
			local TVP_filter 
			fn TVP_filter tvp = 
			(
				local pickObj = tvp.anim
				if classof pickObj == subAnim do pickObj = pickObj.object
				local client = tvp.client
				pickObj != undefined and classof pickObj != ParamBlock2ParamBlock2 and classof client != Default_Sound
			)
			local pickRes = trackView.pickTrackDlg TVP_filter options:0x04000000 -- set focus to selected node if any
			if pickRes != undefined do 
			(
				local pickObj = pickRes.anim
				if classof pickObj == subAnim do pickObj = pickObj.object
				if pickObj != undefined then
				(
					local name1 = pickRes.name 
					local name2 = ""
					if pickObj == rootnode do name1 = "Scene Root Node"
					if isController pickObj do append name1 " controller"
					local mxs_expr = name1 
					if (isValidObj pickObj) do
						mxs_expr = exprForMAXObject pickObj explicitNames:true
					if (mxs_expr != "<unknown>") do
					(
						if mxs_expr.count > 1 and mxs_expr[1] == "$" do
							mxs_expr = substring mxs_expr 2 -1
						name2 = mxs_expr 
					)
					setTargetObject pickObj name1 name2
				)
				else
				(
					/* Localize On */
					messagebox "Unable to access object for picked item" title:"Custom Attributes"
					/* Localize Off */
				)
			)
			CAT_PickTrack.state = false
		)
		On CAT_UIType selected i do
		(
			local newType = CAT_Current_UITypes[i]
			if CAT_Current_UIType != newType do
			(
			-- special case for switching between CheckBox and CheckButton - need to change height
				if newType == #CheckButton then CAT_Current_UIOptionRO.CAT_Height.value = 25
				else if newType == #CheckBox do CAT_Current_UIOptionRO.CAT_Height.value = 15
				
				CAT_Current_UIType = newType 
				CAT_EvalUI()
			)
		)
		
		On CAT_UIName Changed text do 
		(
			-- AF (4/23/01) make this a valid string by putting single quotes around it 
			CAT_TextChecker text
		)
		
		On CAT_UIName entered text do 
		(
			-- AF (4/23/01) make this a valid string by putting single quotes around it 
			CAT_TextChecker text
		 	CAT_EvalUI()
		)
	
		On CAT_Type selected i do
		(
			CAT_Current_ParamType = CAT_ParamIDs[i]
			Case CAT_Current_ParamType of 
			(
				#Float: CAT_Set_Roll_Float() -- Float
				#Percent: CAT_Set_Roll_Percent() -- Percent
				#Angle: CAT_Set_Roll_Angle() -- Angle
				#WorldUnits: CAT_Set_Roll_WorldUnits() -- WorldUnits
				#Integer: CAT_Set_Roll_Integer() -- Integer	
				#Boolean: CAT_Set_Roll_Boolean() -- Boolean
				#Array: CAT_Set_Roll_Array() -- Array			
				#Node: CAT_Set_Roll_Node() -- Node
				#Color: CAT_Set_Roll_Color false -- Color, no alpha
				#TextureMap: CAT_Set_Roll_TextureMap() -- TextureMap
				#Material: CAT_Set_Roll_Material() -- Material
				#fRGBA: CAT_Set_Roll_Color true -- Color, alpha
				#String: CAT_Set_Roll_String()-- String
			)
		 	CAT_EvalUI()
		)
	) 
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Function for testing the UI
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	FN CAT_EvalUI setFocusToFloater:true= 
	(
		fn processAlignment theEvalString opt offset_X offset_Y =
		(
			append theEvalString " Align:#" 
			Case opt of 
			(
				1: append theEvalString "Left"
				2: append theEvalString "Right"
				3: append theEvalString "Center"
			)
			append theEvalString " Offset:[" 
			append theEvalString (offset_X as string)
			append theEvalString "," 
			append theEvalString (offset_Y as string)
			append theEvalString "]" 
		)
		
		if CAT_Debug == true do 
			format "-------------------------------\n--In CAT_EvalUI, CAT_Updating_UI: %; CAT_UIType: %; CAT_Type: %\n-------------------------------\n" CAT_Updating_UI CAT_Current_UIType CAT_Current_ParamType 
		
		if CAT_Updating_UI == false do
		(
			CAT_Updating_UI = true
			if (CAT_TestRoll != undefined and CAT_TestRoll.isDisplayed) do
			(
				CAT_TestRO_Open = CAT_TestRoll.open
				RemoveRollout CAT_TestRoll CAT_Floater
			)

			-- *** Localization Note ***
			-- The "Testing Attribute" name needs to be localized in (append CAT_EvalString "\"Testing Attribute\"")
			local uiTypeCat = CAT_Current_UIType
			if uiTypeCat == #DropdownList or uiTypeCat == #ListBox do uiTypeCat = #ComboBox
							
			CAT_EvalString = "Rollout CAT_TestRoll "
			append CAT_EvalString "\"Testing Attribute\""
			append CAT_EvalString " \n( \n" 
			append CAT_EvalString CAT_Current_UIType
			append CAT_EvalString " CAT_Testui " 
			append CAT_EvalString "\"" 
			append CAT_EvalString CAT_UIText
			if uiTypeCat == #Spinner or uiTypeCat == #Slider or uiTypeCat == #ComboBox or uiTypeCat == #ColorPicker or uiTypeCat == #EditText do 
				append CAT_EvalString ":"
			append CAT_EvalString "\"" 
			append CAT_EvalString " Type:#"

			Case uiTypeCat of
			(
					
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- Spinner
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
				#Spinner:
				(
					local sType = CAT_Current_ParamType
					if sType == #Percent or sType == #Angle do sType = #Float
					append CAT_EvalString sType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					append CAT_EvalString " Range:" 
					append CAT_EvalString (range as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					CAT_Current_UIOptionRO.CAT_Orient.Enabled = False
					CAT_Current_UIOptionRO.CAT_Ticks.Enabled = False
				)
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- Slider
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				 
				#Slider:
				(
					local sType = CAT_Current_ParamType
					if sType == #Percent or sType == #Angle do sType = #Float
					append CAT_EvalString sType
					append CAT_EvalString " Width:"
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					append CAT_EvalString " Orient:#" 
					append CAT_EvalString (if CAT_Current_UIOptionRO.CAT_Orient.state == True then "Vertical" Else "Horizontal")
					append CAT_EvalString " Ticks:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Ticks.value as string)
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					append CAT_EvalString " Range:" 
					append CAT_EvalString (range as string)
				
					CAT_Current_UIOptionRO.CAT_Orient.Enabled = True
					CAT_Current_UIOptionRO.CAT_Ticks.Enabled = True
				) 
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- DropDownList/ComboBox/ListBox
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#ComboBox:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string) 
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					append CAT_EvalString " Items:" 
					with printAllElements on 
						append CAT_EvalString (CAT_Current_UIOptionRO.CAT_MyArray as string)
				)
						
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- Checkbox
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#CheckBox:	
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
	
					CAT_Current_UIOptionRO.CAT_Highlight.Enabled = False
				)
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- CheckButton
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#CheckButton:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)
					append CAT_EvalString " HighlightColor:" 
					append CAT_EvalString (CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_Highlight.color as string))

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					CAT_Current_UIOptionRO.CAT_Highlight.Enabled = True
				)
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- MapButton
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#MapButton:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- MaterialButton
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#MaterialButton:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- ColorPicker
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#ColorPicker:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)
					append CAT_EvalString " Color:" 
					append CAT_EvalString (CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_DColor.Color as string))
					
					if CAT_Current_ParamType == #fRGBA do
						append CAT_EvalString " Alpha:true" 
					append CAT_EvalString " modal:true"

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- PickButton
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#PickButton:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:"  
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:"  
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					append CAT_EvalString " autoDisplay:true"
				)
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				-- EditText
				-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				#EditText:
				(
					append CAT_EvalString CAT_Current_ParamType
					append CAT_EvalString " Width:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Width.value as string)
					append CAT_EvalString " Height:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_Height.value as string)
					append CAT_EvalString " Text:" 
					append CAT_EvalString (CAT_wrapString CAT_Current_UIOptionRO.CAT_DText.text quote:true)
					append CAT_EvalString " LabelOnTop:" 
					append CAT_EvalString (CAT_Current_UIOptionRO.CAT_UILabelOnTop.state as string)

					processAlignment CAT_EvalString CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				
			)
  						
			append CAT_EvalString "\n)\n"
	
			Try
			(	
				If CAT_Debug == True then Format "Executing CAT_EvalString:\n%\n" CAT_EvalString
				Execute CAT_EvalString
			)
			Catch
			( 
				/* Localize On */
				if queryBox "Error evaluating defining script! \n Display script in script editor?" title:"Custom Attributes" do
				(
					local scriptEd = newscript()
					format "%\n" CAT_EvalString to:scriptEd 
				)
				/* Localize Off */
			)
			AddRollout CAT_TestRoll CAT_Floater rolledUp:(not CAT_TestRO_Open)
			if setFocusToFloater do setFocus CAT_Floater 
			CAT_Updating_UI = false			
		)
	)

	FN CAT_AddUI isAddingParam:false = 
	(
		fn processAlignment theUIItem opt offset_X offset_Y =
		(
			Case opt of 
			(
				1: theUIItem.Align = "Left"
				2: theUIItem.Align = "Right" 
				3: theUIItem.Align = "Center"
			)
			theUIItem.Offset = "[" + offset_X as string + "," + offset_Y as string + "]"
		)

		If CAT_Debug == True then 
			Format "-------------------------------\n-- Add UI Performed.. Add Mode: %\n-------------------------------\n" isAddingParam

		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- local Strings
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		Local CUSTString, CAT_ArrayString, CAT_ArrayUIString 
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Begin CUSTString, This will be the String that is Executed
		-- Define Attribute Definition Start
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		CUSTString = "CAT_DEF = attributes " + CAT_AttribName + " \n"
		
		If CAT_DefExist () == True then append CUSTString "Redefine:CAT_CurrentDef\n"

		if CAT_Param_Remap != undefined do 
		(
			append CUSTString "remap:#("
			append CUSTString "#("
			for param in CAT_Param_Remap[1] do append CUSTString ("#" + param + ",")
			CUSTString[CUSTString.count]=")" -- change last "," to ")"
			append CUSTString ",#("
			for param in CAT_Param_Remap[2] do append CUSTString ("#" + param + ",")
			CUSTString[CUSTString.count]=")" -- change last "," to ")"
			append CUSTString ")\n"
		)
					 
		append CUSTString "(\nParameters main rollout:params\n(\n"
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build First ParamBlock Def
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- AF (4/23/01) All we need to do is put "'"'s around the string
		CAT_TextChecker CAT_FinishRoll.CAT_UIName.text
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- If in Add Mode then do the following
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						
		If isAddingParam then
		(	
			CAT_NewAttrib[1] = CAT_ParamBlock Name:CAT_CheckedText
			CAT_NewAttrib[1].ui = CAT_CheckedText
						
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Is the ParamBlock an Array?
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
			if CAT_Current_ParamType != #Array then
			(
				CAT_NewAttrib[1].Type = CAT_Current_ParamType
			)
			Else 
			(
				CAT_NewAttrib[1].Type = #Integer
				CAT_NewAttrib[1].Default = "1"
			)
			
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Is the ParamBlock an Integer Float, Boolean or Color?
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if CAT_Current_ParamType == #Integer or CAT_Current_ParamType == #Float or CAT_Current_ParamType == #Percent or 
			   CAT_Current_ParamType == #Angle or CAT_Current_ParamType == #WorldUnits then
				CAT_NewAttrib[1].Default = CAT_Current_UIOptionRO.CAT_UIRangeDefault.value as string
			Else if CAT_Current_ParamType == #Boolean then
				CAT_NewAttrib[1].Default = "False"
			Else if CAT_Current_ParamType == #Color or CAT_Current_ParamType == #fRGBA then
				CAT_NewAttrib[1].Default = CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_DColor.color as string)
			Else if CAT_Current_ParamType == #String then
				CAT_NewAttrib[1].Default = CAT_wrapString CAT_Current_UIOptionRO.CAT_DText.text
			Else
				CAT_NewAttrib[1].Default = "1"
		)
	
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build Exisiting Param Block String
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						
		If CAT_ParamBlock_Array.count >= 1 then
		(
			For CurrentParam in CAT_ParamBlock_Array do
			(
				If CAT_Debug == True then Format "ReBuilding ParamBlock Item: %\n" CurrentParam.name
				
				local paramType = CurrentParam.Type
	
				append CUSTString CurrentParam.Name 
				append CUSTString " Type:#" ; append CUSTString paramType 
				append CUSTString " UI:" ; append CUSTString CurrentParam.UI 
				
				If paramType == #Node or paramType == #TextureMap or paramType == #Material then 
					append CUSTString "\n"
				Else If paramType == #String then 
				(
					append CUSTString " Default:" ; append CUSTString ("\"" + CurrentParam.Default + "\"")
					append CUSTString "\n"
				)
				Else 
				(
					append CUSTString " Default:" ; append CUSTString CurrentParam.Default 
					append CUSTString "\n"
				)
			)
		)
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Add new Parameter
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If isAddingParam then
		(
			local CurrentParam = CAT_NewAttrib[1]
			local paramType = CurrentParam.Type
	
			append CUSTString CurrentParam.Name 
			append CUSTString " Type:#" ; append CUSTString paramType 
			append CUSTString " UI:" ; append CUSTString CurrentParam.UI 
			
			If paramType == #Node or paramType == #TextureMap or paramType == #Material then 
				append CUSTString "\n"
			Else If paramType == #String then 
			(
				append CUSTString " Default:" ; append CUSTString ("\"" + CurrentParam.Default + "\"")
				append CUSTString "\n"
			)
			Else 
			(
				append CUSTString " Default:" ; append CUSTString CurrentParam.Default 
				append CUSTString "\n"
			)
		)
		
		append CUSTString ")\n" 
		
		-- 	Debug
		If CAT_Debug == True then Format "%\n" CUSTString

		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build Rollout String
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		append CUSTString "Rollout Params \"" 

		/* Localize On */
		append CUSTString "Custom Attributes" 
		/* Localize Off */

		append CUSTString "\"\n(\n"
 
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build Array String
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		CAT_ArrayString = ""
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build Existing Array
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If CAT_UIItems_Array.count >= 1 then
		(
			with printAllElements on
			(
				for item in CAT_UIItems_Array do
				(
					if item.ui == #DropdownList or item.ui == #ComboBox or item.ui == #ListBox then
					(
						append CAT_ArrayString ("Local '" + (substring item.name 2 (item.name.count-2)) + "Array' = " + item.array as string + "\n")
					)
				)
			)
			append CUSTString CAT_ArrayString
			If CAT_Debug == True then Format "Array Output: %\n" CAT_ArrayString
		)
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- If an Array is used, build an Array definition
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
		If isAddingParam then
		(
			if CAT_Current_ParamType == #Array then
			(
				CAT_ArrayString = ("Local '" + (substring CAT_CheckedText 2 (CAT_CheckedText.count-2)) + "Array' = #(")
				
				For i in 1 to CAT_PropRoll_Array.CAT_MyArray.count do
				(
					append CAT_ArrayString "\""
					append CAT_ArrayString (CAT_PropRoll_Array.CAT_MyArray[i] as string)
					append CAT_ArrayString "\""
					If i != CAT_PropRoll_Array.CAT_MyArray.count then append CAT_ArrayString ", "
				)
				append CAT_ArrayString ")\n"
				append CUSTString CAT_ArrayString
		
				If CAT_Debug == True then Format "Array def: %\n" CAT_ArrayString
			)
		)
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build Exisiting UI array
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If CAT_UIItems_Array.count >= 1 then
		(
			For CurrentUI in CAT_UIItems_Array do
			(
				If CAT_Debug == True then Format "ReBuilding UI item: %\n" CurrentUI.name
				append CUSTString (CAT_BuildUIStringForControl CurrentUI)
			)
		)
											
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Build new UI parameter
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If isAddingParam then
		(
			local theUIItem
			
			local uiTypeCat = CAT_Current_UIType
			if uiTypeCat == #DropdownList or uiTypeCat == #ListBox do uiTypeCat = #ComboBox

			Case uiTypeCat of
			(
				#Spinner:
				(
 					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText height:"16" Type:CAT_Current_ParamType
					theUIItem.Width =  CAT_Current_UIOptionRO.CAT_Width.value as string
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					theUIItem.Range = range as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#Slider:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType
					theUIItem.Width =  CAT_Current_UIOptionRO.CAT_Width.value as string
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					theUIItem.Range = range as string
					theUIItem.Orient = (if CAT_Current_UIOptionRO.CAT_Orient.state == True then "Vertical" Else "Horizontal")
					theUIItem.Ticks = CAT_Current_UIOptionRO.CAT_Ticks.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#ComboBox:	
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					theUIItem.Items = "'" + (substring CAT_CheckedText 2 (CAT_CheckedText.count-2)) + "Array'"
					theUIItem.array = CAT_Current_UIOptionRO.CAT_MyArray
					
					CAT_Current_UIOptionRO.CAT_MyArray = #()
					CAT_Current_UIOptionRO.CAT_AItems.items = #()
				)
				#CheckBox:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#CheckButton:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					theUIItem.HighLightColor = CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_Highlight.color as string)
				)
				#MapButton:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType 
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#MaterialButton:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType 
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#ColorPicker:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText
					theUIItem.Type = CAT_Current_ParamType
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					theUIItem.Color = CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_DColor.Color as string)
				)
				#PickButton:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#EditText:
				(
					theUIItem = CAT_UIItem UI:CAT_Current_UIType Name:CAT_CheckedText String:CAT_UIText Type:CAT_Current_ParamType 
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.state CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					theUIItem.Default = CAT_wrapString CAT_Current_UIOptionRO.CAT_DText.text
					theUIItem.LabelOnTop = CAT_Current_UIOptionRO.CAT_UILabelOnTop.state as string
				)
			)
			CAT_NewAttrib[2] = theUIItem

			-- Add the new UI parameter
			append CUSTString (CAT_BuildUIStringForControl CAT_NewAttrib[2])
		)
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Add Custom Attribute to Object
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		append CUSTString ")\n)\n"
--		append CUSTString "CustAttributes.add CAT_TargetObject CAT_DEF #Unique BaseObject:false" -- don't need unique since only have 1 target
		append CUSTString "CustAttributes.add CAT_TargetObject CAT_DEF BaseObject:false"
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Execute Command
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		-- Hold the selection
		
		local CAT_TempHold = Selection as Array
		local CAT_TaskMode = getCommandPanelTaskMode()
		local CAT_HoldStack = modpanel.GetCurrentobject ()
		local CAT_SOLevel = subobjectLevel
						
		function_return_value = true

		Try
		(
			If CAT_Debug == True do Format "Executing CUSTString:\n-------------------------------\n%\n-------------------------------\n" CUSTString
			CAT_IsApplying = true
			Execute CUSTString
			If CAT_Debug == True do Format "Execution completed\n"
		)
		Catch
		(
			/* Localize on */
			if queryBox "Attribute Addition Error! \n Display script in script editor?" title:"Custom Attributes" do
			(
				local scriptEd = newscript()
				format "%\n" CUSTString to:scriptEd 
			)
			/* Localize off */
			function_return_value = false
		)
		
		CAT_IsApplying = false
		
		-- restore selection if it has changed
		local CAT_TempHold2 = Selection as Array
		local selChanged = CAT_TempHold2.count != CAT_TempHold.count
		for obj in CAT_TempHold while not selChanged do
			selChanged = (findItem CAT_TempHold2 obj) == 0
		if selChanged do Select CAT_TempHold
		
		If CAT_Debug == True do 
			Format "restored selection info - was/is - count, changed: %/%, %; task: %/%; obj: %/%\n" CAT_TempHold.count CAT_TempHold2.count selChanged CAT_TaskMode (getCommandPanelTaskMode()) CAT_HoldStack (modpanel.GetCurrentobject())
			
		if getCommandPanelTaskMode() != CAT_TaskMode do setCommandPanelTaskMode mode:CAT_TaskMode 
		if (CAT_HoldStack != undefined and modpanel.GetCurrentobject() != CAT_HoldStack ) do 
			ModPanel.SetCurrentObject CAT_HoldStack
		if CAT_SOLevel != subobjectLevel do subobjectLevel = CAT_SOLevel

		CAT_FinishRoll.update_buttons()

		function_return_value
	)
		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Selection Change Function (Enabled and Disable UI)
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_SelChange = 
	(
		if CAT_FinishRoll.CAT_AddTo.selection != 4 do -- if not working on picked track....
		(
			CAT_FinishRoll.update_buttons()
			if CAT_EditUIRoll != undefined do DestroyDialog CAT_EditUIRoll
		)
	)	 
 		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Reset Function
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	FN CAT_Reset = 
	(
		CAT_UINum = undefined
		CAT_CheckedText = ""
		CAT_UIText = ""
		if CAT_EditUIRoll != undefined do DestroyDialog CAT_EditUIRoll
		if CAT_Floater != undefined do CloseRolloutFloater CAT_Floater
	)

	fn CAT_SetTargetObject targetObject name1 =
	(
		local name2 = ""
		local mxs_expr = exprForMAXObject targetObject explicitNames:true
		if (mxs_expr != "<unknown>") do
		(
			if mxs_expr.count > 1 and mxs_expr[1] == "$" do
				mxs_expr = substring mxs_expr 2 -1
			name2 = mxs_expr 
		)
		CAT_FinishRoll.setTargetObject targetObject name1 name2
		CAT_SelChange()
	)
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- This function is used to test a CA definition to see if it is one of ours
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_IsValidCADef theCADef = (local defdata = theCADef.defdata
									theCADef.name == CAT_AttribName_Name and ((classof defdata) == Array) and 
									(defdata.count == 2 or defdata.count == 3) and 
									(classof defdata[1] == Array and classof defdata[2] == Array) and
									(defdata[1].count == defdata[2].count) and
									(defdata[1].count == 0 or 
									 (classof defdata[1][1] == CAT_ParamBlock and classof defdata[2][1] == CAT_UIItem))
								   )
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Check Definition Data
	-- This function is used to check the custom atrributes definition data, See if it exists
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_DefExist =
	(
		CAT_Defs = CustAttributes.getdefs CAT_TargetObject BaseObject:false
		
		local res = false
		if CAT_Defs != undefined then 
		(	
			for def in CAT_Defs while not res do res = CAT_IsValidCADef def
		)
		res
	) 
	
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Count Definition Data
	-- This function is used to count the number of our CAs on the object
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_CountDefs =
	(
		CAT_Defs = CustAttributes.getdefs CAT_TargetObject BaseObject:false
		
		local res = 0
		if CAT_Defs != undefined then 
		(	
			for def in CAT_Defs where (CAT_IsValidCADef def) do res += 1
		)
		res
	) 

	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Set Definition Data
	-- This function is used to set the custom atrributes definition data to the selected object
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_SetDef which:1 =
	(
		if CAT_Debug == True then Format "-------------------------------\n-- Set Definition Performed.. which: %\n-------------------------------\n" which

		CAT_Defs = CustAttributes.getdefs CAT_TargetObject BaseObject:false
			
		if CAT_Defs != undefined then 
		(	
			local notFound = true
			local numFound = 0
			For def in CAT_Defs while notFound do
			(
				if def.name == CAT_AttribName_Name do numFound += 1
				if numFound == which do
				(
					custAttributes.setDefData def #(CAT_Source[1],CAT_Source[2],CAT_DefData_Current_Version)
					notFound = false
					if CAT_Debug == True then 
					(	
						Format "Updated def data on: %\n" CAT_TargetObject
						Format "\tParamBlock Array: %\n" CAT_Source[1]
						Format "\tUIItems Array: %\n" CAT_Source[2]
					)
				)
			)
		)
	) 
		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Get Definition Data
	-- This function is used to retrieve the custom atrributes definition data from the selected object
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fn CAT_GetDef which:1 = 
	(
		If CAT_Debug == True then Format "-------------------------------\n-- Get Definition Performed.. which: %\n-------------------------------\n" which
		
		CAT_ParamBlock_Array = #()
		CAT_UIItems_Array = #()
		CAT_Source = #()
		CAT_NewAttrib = #()	
		CAT_UI_Array = #()
		CAT_CurrentDef = undefined
		
		if (CAT_TargetObject != undefined) then
		(
			CAT_Defs = CustAttributes.getdefs CAT_TargetObject BaseObject:false
			
			If CAT_Defs == Undefined then CAT_Defs = #()
				
			local notFound = true
			local numFound = 0
			For def in CAT_Defs while notFound where (CAT_IsValidCADef def) do
			(
				numFound += 1
				if numFound == which do
				(
					notFound = false
					CAT_CurrentDef = def
					CAT_DefData = CAT_CurrentDef.defdata
					CAT_ParamBlock_Array = CAT_DefData[1]
					CAT_UIItems_Array = CAT_DefData[2]
					
					local defDataVersion = 1
					if CAT_DefData.count > 2 do defDataVersion = CAT_DefData[3]
					
					-- patch up old files - need to change param and ui types from string to name values, strip trailing spaces
					if defDataVersion == 1 and CAT_UIItems_Array.count > 0 do
					(
						for o in CAT_UIItems_Array do 
						(	
							o.type = o.type as name
							local n = o.ui.count
							if (o.ui[n] == " ") do o.ui = substring o.ui 1 (n-1)
							o.ui = o.ui as name
						)
						for o in CAT_ParamBlock_Array do o.type = o.type as name
					)
					
					CAT_UI_Array = #()
					
					CAT_Source[1] = CAT_ParamBlock_Array 
					CAT_Source[2] = CAT_UIItems_Array 
					
					For i in 1 to CAT_DefData[2].count do
					(
						local uiType = CAT_UITypes[findItem CAT_UIIDs CAT_DefData[2][i].UI]
						local label = CAT_unwrapString CAT_DefData[2][i].String
						label = CAT_substituteString label "\\\\" "\\"
						Append CAT_UI_Array (uiType + " ---- " + label)
					)
				)
			)	
			
			If CAT_Debug == True then 
			(
				Format "Read def data from: %\n" CAT_TargetObject
				Format "\tCAT_UIItems_Array: %\n" CAT_UIItems_Array
				Format "\tCAT_ParamBlock_Array: %\n" CAT_ParamBlock_Array
				Format "\tCAT_UI_Array: %\n" CAT_UI_Array
			)
		)
		else
			CAT_Defs = #()
	)
		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Paramblock Definition
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- expand string - example: '\"' to '\\\"' 
	fn CAT_substituteString inString fromStr toStr =
	(
		if CAT_Debug == True do format "CAT_substituteString in -  inString:% fromStr:% toStr:% \n" inString fromStr toStr
		local workstring = copy inString 
		local lengthFrom = fromStr.count
		local lengthTo = toStr.count
		local location = findString workstring fromStr 
		local master_location = 1
		while location != undefined do
		( 
			master_location += (location-1)
			workstring = replace workstring master_location lengthFrom toStr 
			master_location += lengthTo
			location = findString (subString workstring master_location -1) fromStr 
		)
		if CAT_Debug == True do format "CAT_substituteString out -  workstring:% \n" workstring
		workstring -- return value
	)

	FN CAT_isReservedToken theName =
	(
		local reservedTokens = #(#local, #global, #function, #fn, #mapped, #if, #then, #else, #do, #collect, #while, 
					#case, #and, #or, #not, #for, #in, #from, #to, #by, #of, #where, #as, #with, #animate, #coordsys, 
					#set, #undo, #about, #at, #on, #off, #max, #utility, #rollout, #return, #exit, #when, #continue,
					#struct, #try, #catch, #throw, #plugin, #tool, #persistent, #parameters, #rcmenu, #macroScript, 
					#dropScript, #attributes)
		(findItem reservedTokens (theName as name)) != 0
	)

	FN CAT_FixupColorString theString = replace theString 1 1 "(::"
	
	FN CAT_TextChecker t =
	(
		if CAT_Debug == True do format "CAT_TextChecker in -  t:% \n" t
		t = CAT_substituteString t "\\" "\\\\"

		CAT_UIText = t = CAT_wrapString t

		local str = "'"
		local location = findString t str
		while location != undefined do
		( 
			if location == 1 or location == t.count then
				(t = replace t location 1 "")
			else
				(t = replace t location 1 "_")
			location = findString t str
		)

		CAT_CheckedText = "'" + t + "'"
		if CAT_Debug == True do format "CAT_TextChecker out - CAT_UIText:% CAT_CheckedText:% \n" CAT_UIText CAT_CheckedText
		CAT_CheckedText -- return value
	)	 

	FN CAT_Close_Attrib_Rollouts =
	(
		if (CAT_TestRoll != undefined and CAT_TestRoll.isDisplayed) do
		(
			CAT_TestRO_Open = CAT_TestRoll.open
			RemoveRollout CAT_TestRoll CAT_Floater
		)
		if (CAT_Current_UIOptionRO != undefined and CAT_Current_UIOptionRO.isDisplayed) do
		(
			CAT_UIOptionRO_Open = CAT_Current_UIOptionRO.open
			RemoveRollout CAT_Current_UIOptionRO CAT_Floater
		)
	)
	
	FN CAT_Open_Attrib_Rollout theRollout =
	(
		AddRollout theRollout CAT_Floater rolledUp:(not CAT_UIOptionRO_Open)
		CAT_Current_UIOptionRO = theRollout
	)
	
	FN CAT_Set_Roll_NULL = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Current_UIOptionRO = undefined
								
		CAT_FinishRoll.CAT_UIType.items = #() 
		CAT_Current_UITypes = #() 
		CAT_FinishRoll.CAT_UIType.selection = 0
		CAT_Current_UIType = #null
	)
	
	FN CAT_Set_Roll_Float = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Float 
								
		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
		CAT_Current_UITypes = #(CAT_UIIDs[1],CAT_UIIDs[2]) -- #Spinner, #Slider
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)
	
	FN CAT_Set_Roll_Percent = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Percent 
								
		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
		CAT_Current_UITypes = #(CAT_UIIDs[1],CAT_UIIDs[2]) -- #Spinner, #Slider
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_Angle = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Angle 
								
		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
		CAT_Current_UITypes = #(CAT_UIIDs[1],CAT_UIIDs[2]) -- #Spinner, #Slider
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_WorldUnits = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_WorldUnits 
								
		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
		CAT_Current_UITypes = #(CAT_UIIDs[1],CAT_UIIDs[2]) -- #Spinner, #Slider
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_Integer = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Integer 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
		CAT_Current_UITypes = #(CAT_UIIDs[1],CAT_UIIDs[2]) -- #Spinner, #Slider
		CAT_FinishRoll.CAT_UIType.selection = 1	
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)
	
	FN CAT_Set_Roll_Boolean = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Boolean 

	 	CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[4],CAT_UITypes[5]) -- "CheckBox", "CheckButton"
		CAT_Current_UITypes = #(CAT_UIIDs[4],CAT_UIIDs[5]) -- #CheckBox, #CheckButton
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)
	
	FN CAT_Set_Roll_Array = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Array 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[3],CAT_UITypes[10],CAT_UITypes[11]) -- "DropDownList", "ComboBox", "ListBox"
		CAT_Current_UITypes = #(CAT_UIIDs[3],CAT_UIIDs[10],CAT_UIIDs[11]) -- #DropDownList,#ComboBox,#ListBox
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_Node = 
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Node 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[9]) -- "PickButton"
		CAT_Current_UITypes = #(CAT_UIIDs[9]) -- #PickButton
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_Color useAlpha =
	( 
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Color 
		CAT_PropRoll_Color.CAT_DColor.alpha = useAlpha

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[8]) -- "ColorPicker"
		CAT_Current_UITypes = #(CAT_UIIDs[8]) -- #ColorPicker
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_TextureMap =
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_TextureMap 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[6]) -- "MapButton"
		CAT_Current_UITypes = #(CAT_UIIDs[6]) -- #MapButton
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)
		
	FN CAT_Set_Roll_Material =
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_Material 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[7]) -- "MaterialButton"
		CAT_Current_UITypes = #(CAT_UIIDs[7]) -- #MaterialButton
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)

	FN CAT_Set_Roll_String =
	(
		CAT_Close_Attrib_Rollouts()
		CAT_Open_Attrib_Rollout CAT_PropRoll_String 

		CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[12]) -- "EditText"
		CAT_Current_UITypes = #(CAT_UIIDs[12]) -- #EditText
		CAT_FinishRoll.CAT_UIType.selection = 1
		CAT_Current_UIType = CAT_Current_UITypes[1]
	)
		
	-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Function for initializing the Edits
	-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	FN CAT_Edit_Set ui_item = 
	(
		fn processAlignment theRO opt offset =
		(
			Case opt of
			(
				"Left": theRO.CAT_Align.State = 1
				"Right": theRO.CAT_Align.State = 2
				"Center": theRO.CAT_Align.State = 3
			)
			offsetVal = execute offset
			theRO.CAT_UIOffset_X.value = offsetVal.x
			theRO.CAT_UIOffset_Y.value = offsetVal.y
		)

		local txt = CAT_unwrapString ui_item.String
		CAT_FinishRoll.CAT_UIName.text = CAT_substituteString txt "\\\\" "\\"

		CAT_UIText = ui_item.String
		CAT_CheckedText = ui_item.Name 
 
		CAT_Current_ParamType = ui_item.type
		CAT_FinishRoll.CAT_Type.selection = finditem CAT_ParamIDs CAT_Current_ParamType
		If CAT_Debug == True then format "CAT_Edit_Set ui_item:%; \n\tCAT_UIText:%; CAT_CheckedText:%\n" ui_item CAT_UIText CAT_CheckedText
		local valType = CAT_Current_ParamType
		if valType == #Float or valType == #Percent or valType == #Angle or valType == #WorldUnits or valType == #Integer then valType = #Number
		else if valType == #Color or valType == #fRGBA do valType = #ColorType
		
		CAT_FinishRoll.CAT_UIType.enabled = CAT_FinishRoll.CAT_UIName.enabled = valType != #null

		Case valType of 
		(
			#null:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_NULL()
				CAT_Current_UIType = #null
				CAT_FinishRoll.CAT_UIType.selection = 0
				CAT_Updating_UI = false 
			)
			#Number:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				Case CAT_Current_ParamType of
				(
					#Float: CAT_Set_Roll_Float ()
					#Percent: CAT_Set_Roll_Percent ()
					#Angle: CAT_Set_Roll_Angle()
					#WorldUnits: CAT_Set_Roll_WorldUnits ()
					#Integer: CAT_Set_Roll_Integer()
				)
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false 

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				local range = execute (ui_item.Range)
				CAT_Current_UIOptionRO.CAT_UIRangeStart.value = range.x
				CAT_Current_UIOptionRO.CAT_UIRangeEnd.value = range.y
				CAT_Current_UIOptionRO.CAT_UIRangeDefault.value = range.z
				
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				if ui_item.UI == #slider then 
				(
					CAT_Current_UIOptionRO.CAT_Orient.state = ui_item.orient == "Vertical"
					CAT_Current_UIOptionRO.CAT_Orient.Enabled = True
					CAT_Current_UIOptionRO.CAT_Ticks.Enabled = True
				)
				else
				(
					CAT_Current_UIOptionRO.CAT_Orient.state = false
					CAT_Current_UIOptionRO.CAT_Orient.Enabled = False
					CAT_Current_UIOptionRO.CAT_Ticks.Enabled = False
				)
				
				CAT_Current_UIOptionRO.CAT_Ticks.value = ui_item.ticks as integer
				CAT_EvalUI setFocusToFloater:false
			)
					
			#Boolean:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_Boolean ()	
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
											
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				Case ui_item.UI of
				(
					#CheckBox:
					(
						CAT_Current_UIOptionRO.CAT_Highlight.enabled = False
						CAT_Current_UIOptionRO.CAT_Highlight.color = (execute (ui_item.HighLightColor))											
					)
								
					#CheckButton:
					(
						CAT_Current_UIOptionRO.CAT_Highlight.enabled = True
						CAT_Current_UIOptionRO.CAT_Highlight.color = (execute (ui_item.HighLightColor))
					)
				)
				
				CAT_EvalUI setFocusToFloater:false
			)
						
			#Array:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_Array()
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false
				
				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
											
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_Current_UIOptionRO.CAT_MYArray = copy ui_item.Array #nomap
				CAT_Current_UIOptionRO.CAT_AItems.Items = CAT_Current_UIOptionRO.CAT_MYArray
				
				CAT_EvalUI setFocusToFloater:false
			)
		
			#Node:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_Node ()
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false
				
				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
											
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_EvalUI setFocusToFloater:false
			)

			#ColorType:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_Color (CAT_Current_ParamType == #fRGBA)
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
											
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_Current_UIOptionRO.CAT_DColor.Color = (execute (ui_item.Color))
				CAT_EvalUI setFocusToFloater:false
			)
					
			#TextureMap:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_TextureMap()
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
										
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_EvalUI setFocusToFloater:false
			)

			#Material:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_Material()
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
										
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_EvalUI setFocusToFloater:false
			)

			#String:
			(
				CAT_Updating_UI = true -- block CAT_EvalUI from executing
				CAT_Set_Roll_String()
				CAT_Current_UIType = ui_item.UI
				CAT_FinishRoll.CAT_UIType.selection = findItem CAT_Current_UITypes ui_item.UI
				CAT_Updating_UI = false

				CAT_Current_UIOptionRO.CAT_Width.value = ui_item.Width as integer
				CAT_Current_UIOptionRO.CAT_Height.value = ui_item.Height as integer
										
				processAlignment CAT_Current_UIOptionRO ui_item.Align ui_item.Offset
				
				CAT_Current_UIOptionRO.CAT_DText.text = CAT_unwrapString ui_item.Default
				CAT_Current_UIOptionRO.CAT_UILabelOnTop.state = ui_item.LabelOnTop as BooleanClass

				CAT_EvalUI setFocusToFloater:false
			)

		)
	)
		
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Rollout for Editing UI Elements
	-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* Localize on */
	Rollout CAT_EditUIRoll "Edit Attributes/Parameters" SilentErrors:false --(CAT_Debug != True)
	(
		local processAlignment, ModPanelObjChange, reloadEditData, rebuildEditData, updateUI -- local functions
		local inUpdate -- local var - used to prevent RO closure when updated CA def
		local b1_yoff -- local var - y offset of up, down and accept buttons from bottom of dialog
		local b2_yoff -- local var - y offset of delete and delete all buttons from bottom of dialog
		local b3_yoff -- local var - y offset of apply, reset, and cancel buttons from bottom of dialog
		local l_yoff -- local var - delta y difference between dialog height and CAT_UIList height
		
		local CAT_EditData_Array, UI_Data_XRef, UI_List_Data, CAT_SceneData_Array
		local null_UIItem = CAT_UIItem #null "" "" #null
		local currentItem 

		struct CAT_EditData (index, currentDef, defData, paramBlock_Array, uiItems_Array, ui_Array, source, dirty = false)
		struct editDataPair (editData, index)

		listbox CAT_UIList "Attributes/Parameters:" pos:[6,6] width:207 height:12
		button CAT_EditUI_Up "U" pos:[11,191] width:21 height:21 images:#("CA_edit_arrows_16i.bmp", undefined, 4, 3, 3, 4, 4)
		button CAT_EditUI_Down "D" pos:[36,191] width:21 height:21 images:#("CA_edit_arrows_16i.bmp", undefined, 4, 1, 1, 2, 2)
		button CAT_EditUI_Accept "Accept Parameter Changes" pos:[61,191] 		
		button CAT_EditUI_Delete "Delete Parameter" pos:[7,219] width:90  
		button CAT_EditUI_DeleteAll "Delete All Parameters" pos:[101,219] width:110
		button CAT_EditUI_Apply "Apply Changes" pos:[11,247] 
		button CAT_EditUI_Reset "Reset" pos:[105,247] 
		button CAT_EditUI_Cancel "Cancel" pos:[156,247] 	
		
	/* Localize off */

		local compare
		fn compare v1 v2 = 
		(
			local res = true
			if classof v1 == Array and classof v2 == Array then 
			(
				if v1.count == v2.count then
					for i = 1 to v1.count while res do res = compare v1[i] v2[i]
				else
					res = false
			)
			else
				res = v1 == v2
			res
		)

		fn CAT_UIList_SelectionChanged index =
		(
			currentItem = null_UIItem 
			if index == 0 then
			(
				CAT_EditUI_Up.enabled = CAT_EditUI_Down.enabled = CAT_EditUI_Accept.enabled = false
				CAT_EditUI_Delete.enabled = CAT_EditUI_DeleteAll.enabled = false
				CAT_EditUI_Delete.text = "Delete Parameter"
				CAT_EditUI_DeleteAll.text = "Delete All Parameters"
			)
			else
			(
				local editData = UI_Data_XRef[index].editData 
				CAT_CurrentDef = editData.currentDef
				CAT_DefData = editData.defData
				CAT_ParamBlock_Array = editData.paramBlock_Array
				CAT_UIItems_Array = editData.uiItems_Array
				CAT_UI_Array = editData.ui_Array
				CAT_Source = editData.source 
				CAT_EditUI_Delete.enabled = CAT_EditUI_DeleteAll.enabled = true
				
				if UI_Data_XRef[index].index != 0 then  -- parameter selected
				(
					currentItem = UI_Data_XRef[index].editData.uiItems_Array[UI_Data_XRef[index].index]
					CAT_EditUI_Accept.enabled = true
					CAT_EditUI_Delete.text = "Delete Parameter"
					CAT_EditUI_DeleteAll.text = "Delete All Parameters"
					
					if index > 1 then
						CAT_EditUI_Up.enabled = UI_Data_XRef[index-1].index != 0
					else
						CAT_EditUI_Up.enabled = false
						
					if index < UI_Data_XRef.count then
						CAT_EditUI_Down.enabled = UI_Data_XRef[index+1].index != 0
					else
						CAT_EditUI_Down.enabled = false
				)
				else -- CA selected
				(
					CAT_EditUI_Accept.enabled = false
					CAT_EditUI_Delete.text = "Delete Attribute"
					CAT_EditUI_DeleteAll.text = "Delete All Attributes"

					local notFound = true
					for i = 1 to (index-1) while notFound do
						notFound = UI_Data_XRef[i].index != 0
					CAT_EditUI_Up.enabled = not notFound
					
					notFound = true
					for i = (index+1) to UI_Data_XRef.count while notFound do
						notFound = UI_Data_XRef[i].index != 0
					CAT_EditUI_Down.enabled = not notFound
				)
			)
			CAT_Edit_Set currentItem
		)

		On CAT_UIList selected i do
		(
			CAT_UIList_SelectionChanged i
		)
	
		On CAT_EditUI_Accept pressed do 
		(
			-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			-- This is where the edit selected button action takes place.
			-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			If CAT_Debug == True then Format "Current Def Data Information Before Edit = %\n" CAT_Source
			If CAT_Debug == True then Format "ParamType: %; UIType: %\n" CAT_Current_ParamType CAT_Current_UIType
			
			-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			-- This is where the Paramblock and UI edits take place.
			-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			local k = UI_Data_XRef[CAT_UIList.selection].index
			local theUIItem = CAT_UIItems_Array[k]
			local thePBItem = CAT_ParamBlock_Array[k]
 
			local origUIItem = copy theUIItem 
			local origPBItem = copy thePBItem 
			
			-- make sure we won't have a duplicate parameter name
			local noDupe = true
			local newParamName = CAT_CheckedText as name
			for i = 1 to CAT_ParamBlock_Array.count while noDupe where i != k do
				noDupe = CAT_ParamBlock_Array[i].Name as name != newParamName 

			/* Localize On */
			
			if CAT_CheckedText == "''" do 
			(
				MessageBox "Null Parameter Names Not Allowed!\nPlease Enter a New Name" Title:"Custom Attributes" 
				return false
			)
			
			if (not noDupe) do
			(
				MessageBox "Parameter Name Exists!\nPlease Enter a New Name" Title:"Custom Attributes" 
				return false
			)
			
			if CAT_isReservedToken CAT_UIText or (finditem localReservedNames (CAT_UIText as name) != 0) then 
			(
				MessageBox "Specified Parameter Name Not Allowed!\nPlease Enter a New Name" Title:"Custom Attributes"
				return false
			)

			/* Localize Off */

			theUIItem.String = CAT_UIText
			theUIItem.UI = CAT_Current_UIType
			theUIItem.Type = CAT_Current_ParamType
			theUIItem.Name = CAT_CheckedText

			thePBItem.Type = CAT_Current_ParamType
			thePBItem.Name = CAT_CheckedText
			thePBItem.UI = CAT_CheckedText
			
			local uiTypeCat = CAT_Current_UIType
			if uiTypeCat == #DropdownList or uiTypeCat == #ListBox do uiTypeCat = #ComboBox

			Case uiTypeCat of
			(
				#Spinner:
				(
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					theUIItem.Range = range as string
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					thePBItem.Default = CAT_Current_UIOptionRO.CAT_UIRangeDefault.value as string
				)
				#Slider:
				(
					local range = [CAT_Current_UIOptionRO.CAT_UIRangeStart.value, CAT_Current_UIOptionRO.CAT_UIRangeEnd.value, CAT_Current_UIOptionRO.CAT_UIRangeDefault.value]
					theUIItem.Range = range as string
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					theUIItem.Orient = (if CAT_Current_UIOptionRO.CAT_Orient.state == True then "Vertical" Else "Horizontal")
					theUIItem.Ticks = CAT_Current_UIOptionRO.CAT_Ticks.value as string

					thePBItem.Default = CAT_Current_UIOptionRO.CAT_UIRangeDefault.value as string
				)
				#CheckBox:
				(	
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					thePBItem.Default = "False"
				)
				#CheckButton:
				(
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					theUIItem.HighlightColor = CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_Highlight.color as string)

					thePBItem.Default = "False"
				)
				#ColorPicker:
				(
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					theUIItem.Color = CAT_FixupColorString (CAT_Current_UIOptionRO.CAT_DColor.Color as string)
					theUIItem.Alpha = (CAT_Current_ParamType == #fRGBA) as string

					thePBItem.Default = theUIItem.Color
				)
				#PickButton:
				(
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#MapButton:
				(	
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#MaterialButton:
				(	
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
				)
				#ComboBox:
				(
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value
					
					theUIItem.Array = copy CAT_Current_UIOptionRO.CAT_MyArray #nomap
					theUIItem.Items = "'" + (substring CAT_CheckedText 2 (CAT_CheckedText.count-2)) + "Array'"
					
					thePBItem.Type = #Integer
					thePBItem.Default = "1"
				)
				#EditText:
				(	
					theUIItem.Width = CAT_Current_UIOptionRO.CAT_Width.value as string
					theUIItem.Height = CAT_Current_UIOptionRO.CAT_Height.value as string
					processAlignment theUIItem CAT_Current_UIOptionRO.CAT_Align.State CAT_Current_UIOptionRO.CAT_UIOffset_X.value CAT_Current_UIOptionRO.CAT_UIOffset_Y.value

					theUIItem.Default = CAT_wrapString CAT_Current_UIOptionRO.CAT_DText.text
					theUIItem.LabelOnTop = CAT_Current_UIOptionRO.CAT_UILabelOnTop.state as string
					thePBItem.Default = theUIItem.Default 
				)
			)
	
			local uiType = CAT_UITypes[findItem CAT_UIIDs CAT_Current_UIType]
			local label = CAT_unwrapString theUIItem.String
			label = CAT_substituteString label "\\\\" "\\"
			CAT_UI_Array[CAT_UIList.selection] = uiType + " ---- " + label
			CAT_UIList.selected = CAT_UI_Array[CAT_UIList.selection]
			
			local noChange = true
			for pn in (getpropnames origUIItem) while nochange do noChange = compare (getproperty origUIItem pn) (getproperty theUIItem pn)
			for pn in (getpropnames origPBItem) while nochange do noChange = compare (getproperty origPBItem pn) (getproperty thePBItem pn)
			If CAT_Debug == True then 
			(
				Format "origUIItem: %\n" origUIItem
				Format "theUIItem : %\n" theUIItem 
				Format "origPBItem: %\n" origPBItem 
				Format "thePBItem : %\n" thePBItem 
				format "noChange: %\n" noChange 
			)
			if not noChange do
				UI_Data_XRef[CAT_UIList.selection].editData.dirty = true -- mark CA def as dirty 

			If CAT_Debug == True then 
				Format "Current Def Data Information after Edit:\n\tCAT_ParamBlock_Array: %\n\tCAT_UIItems_Array: %\n" CAT_ParamBlock_Array CAT_UIItems_Array 
			true 
		)
	 
		-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- CAT_Source is the source for defdata, CAT_Source[1] is the paramblock array, CAT_Source[2] is the UI items associated with the paramblock. 
		-- This is what is associated in the the defdata of the object.
		--
		-- Once the item is modified, the arrays are stuffed into CAT_Source[1] and CAT_Source[2]
		-- The Current definition is then set back to the current definition, "setDefData def CAT_Source"
		-- CAT_CurrentDef is the current custom attribute and is retrieved whenever CAT_GetDef() is called on the selected object.
		-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		On CAT_EditUI_Apply pressed do 
		(

			-- accept changes in Parameter Editor
			if CAT_EditUI_Accept.enabled do
			(
				local res = CAT_EditUI_Accept.pressed()
				if res == false do return false
			)

			local CAT_TempHold = Selection as Array
			local CAT_TaskMode = getCommandPanelTaskMode()
			local CAT_HoldStack = modpanel.GetCurrentobject ()
			local CAT_SOLevel = subobjectLevel
			
			undo "Edit CA" on 
			(						
				-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
				-- CAT_AddUI is the function that adds the actually custom attribute	
				-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
				
				inUpdate = true
				local ui_list_selection = CAT_UIList.selection 
				
				local usedDefs = #{}
				local orderDefs = #()
				for index = 1 to UI_Data_XRef.count do
				(
					local item = UI_Data_XRef[index]
					if item.index == 0 then
					(
						local edData = item.editData
						If CAT_Debug == True do 
							format "Edit CA: UI_Data_XRef[%]: %\n" index item
						usedDefs[edData.index] = true
						append orderDefs edData.index
					)
				)
				If CAT_Debug == True then 
					format "Edit CA: usedDefs: %; orderDefs: %\n" usedDefs orderDefs 

				local editingSuspended = false
				try
				(
					-- update definitions 
					for index = CAT_SceneData_Array.count to 1 by -1 do
					(	
						local editData = CAT_SceneData_Array[index] 
						If CAT_Debug == True then format "Edit CA: index: % - %\n" index editData
						if usedDefs[index] then 
						(
							if (editData.dirty) do
							(
								If CAT_Debug == True then format "Edit CA: updating index: % - %\n" index editData
								CAT_CurrentDef = editData.currentDef
								CAT_DefData = editData.defData
								CAT_ParamBlock_Array = editData.paramBlock_Array
								CAT_UIItems_Array = editData.uiItems_Array
								CAT_UI_Array = editData.ui_Array
								CAT_Source = editData.source 
			
								local renameOccurred = false
								for param in CAT_ParamBlock_Array where param.OrigName != param.name do
								(
									if not renameOccurred do CAT_Param_Remap = #(#(),#())
									append CAT_Param_Remap[1] (param.OrigName as name)
									append CAT_Param_Remap[2] (param.name as name)
									renameOccurred = true
								)
								for param in CAT_ParamBlock_Array do param.OrigName = undefined
				
								CAT_Source[1] = CAT_ParamBlock_Array
								CAT_Source[2] = CAT_UIItems_Array
								CAT_SetDef which:editData.index
								
								if not editingSuspended do
								(
									editingSuspended = true
									SuspendEditing()
								)
								CAT_AddUI()
							)
						)
						else
						(
							If CAT_Debug == True then format "Edit CA - deleting: index: % - %\n" index editData
							if not editingSuspended do
							(
								editingSuspended = true
								SuspendEditing()
							)
							custattributes.delete CAT_TargetObject editData.currentDef BaseObject:false
						)
					)
					
					-- reorder CAs
					local needReorder = false
					for i = 2 to orderDefs.count while not needReorder do needReorder = orderDefs[i-1] > orderDefs[i]
					If CAT_Debug == True then 
						format "Edit CA: needReorder: %\n" needReorder 
					if needReorder do
					(
						if not editingSuspended do
						(
							editingSuspended = true
							SuspendEditing()
						)

						local retainedDefs = copy orderDefs #nomap
						sort retainedDefs 
						local caIndex = #()
						local n = 0
						
						local targ_ca_array = CAT_TargetObject.custAttributes
						for i = 1 to targ_ca_array.count do
						(
							local ca = targ_ca_array[i]
							if (ismscustattrib ca and CAT_IsValidCADef (classof ca)) do
								append caIndex i
						)
						If CAT_Debug == True then 
							format "Edit CA: retainedDefs: %; orderDefs: %; caIndex: %\n" retainedDefs orderDefs caIndex
							
						for i = 1 to retainedDefs.count do
						(
							local i1 = retainedDefs[i]
							local i2 = orderDefs[i]
							If CAT_Debug == True then 
								format "Edit CA: i: %; i1: %; i2: %\n" i i1 i2
							if i1 != i2 then
							(
								local i3 = findItem retainedDefs i2
								swap targ_ca_array[caIndex[i]] targ_ca_array[caIndex[i3]]
								swap retainedDefs[i] retainedDefs[i3]
								If CAT_Debug == True then 
									format "Edit CA: i3: %; retainedDefs: %; orderDefs: %; caIndex: %\n" i3 retainedDefs orderDefs caIndex
							)
						)
					)
				
					CAT_Param_Remap = undefined
					
					reloadEditData()
					rebuildEditData()
					updateUI()
					CAT_UIList.selection = ui_list_selection 
					CAT_UIList_SelectionChanged ui_list_selection 
					
					if editingSuspended do
					(
						resumeEditing()

						with undo off
						(
							-- restore selection if it has changed
							local CAT_TempHold2 = Selection as Array
							local selChanged = CAT_TempHold2.count != CAT_TempHold.count
							for obj in CAT_TempHold while not selChanged do
								selChanged = (findItem CAT_TempHold2 obj) == 0
							if selChanged do Select CAT_TempHold
							
							If CAT_Debug == True do 
								Format "restored selection info - was/is - count, changed: %/%, %; task: %/%; obj: %/%\n" CAT_TempHold.count CAT_TempHold2.count selChanged CAT_TaskMode (getCommandPanelTaskMode()) CAT_HoldStack (modpanel.GetCurrentobject())
								
							if getCommandPanelTaskMode() != CAT_TaskMode do setCommandPanelTaskMode mode:CAT_TaskMode 
							if (CAT_HoldStack != undefined and modpanel.GetCurrentobject() != CAT_HoldStack ) do 
								ModPanel.SetCurrentObject CAT_HoldStack
							if CAT_SOLevel != subobjectLevel do subobjectLevel = CAT_SOLevel
						)
					)

					inUpdate = false
				)
				catch 
				(
					if editingSuspended do
					(
						resumeEditing()

						with undo off
						(
							-- restore selection if it has changed
							local CAT_TempHold2 = Selection as Array
							local selChanged = CAT_TempHold2.count != CAT_TempHold.count
							for obj in CAT_TempHold while not selChanged do
								selChanged = (findItem CAT_TempHold2 obj) == 0
							if selChanged do Select CAT_TempHold
							
							If CAT_Debug == True do 
								Format "restored selection info - was/is - count, changed: %/%, %; task: %/%; obj: %/%\n" CAT_TempHold.count CAT_TempHold2.count selChanged CAT_TaskMode (getCommandPanelTaskMode()) CAT_HoldStack (modpanel.GetCurrentobject())
								
							if getCommandPanelTaskMode() != CAT_TaskMode do setCommandPanelTaskMode mode:CAT_TaskMode 
							if (CAT_HoldStack != undefined and modpanel.GetCurrentobject() != CAT_HoldStack ) do 
								ModPanel.SetCurrentObject CAT_HoldStack
							if CAT_SOLevel != subobjectLevel do subobjectLevel = CAT_SOLevel
						)
					)
					
					inUpdate = false
					CAT_Param_Remap = undefined
					
					reloadEditData()
					rebuildEditData()
					updateUI()
					CAT_UIList.selection = ui_list_selection 
					CAT_UIList_SelectionChanged ui_list_selection 
					throw
				)
			)	
		)

		On CAT_EditUI_Cancel pressed Do 
		(
			inUpdate = false  -- to allow closing after script failures
			DestroyDialog CAT_EditUIRoll
		)

		fn reloadEditData =
		(
			-- collect all of the defs
			CAT_EditData_Array = #()
			CAT_SceneData_Array = #()
			local numCAs = CAT_CountDefs()
			for i = 1 to numCAs do
			(
				CAT_GetDef which:i
				-- store the orig param names so we can detect parameter name changes
				for param in CAT_ParamBlock_Array do
					param.OrigName = param.name
				local ed = CAT_EditData i CAT_CurrentDef CAT_DefData CAT_ParamBlock_Array CAT_UIItems_Array CAT_UI_Array CAT_Source
				append CAT_EditData_Array ed
				append CAT_SceneData_Array ed
			)

			If CAT_Debug == True do 
				format "reloadEditData: %; %\n" numCAs CAT_EditData_Array
		)
		
		fn rebuildEditData =
		(
			-- build the list for the listbox
			UI_Data_XRef = #()
			UI_List_Data = #()
			local uiIndex = 1
			local numCAs = CAT_EditData_Array.count
			for i = 1 to numCAs do
			(
				local editData_Array = CAT_EditData_Array[i]
--				if (numCAs > 1) then
				(
					append UI_Data_XRef (editDataPair editData_Array 0)
					local caName = copy CAT_AttribName
					for j = 1 to caName.count where caName[j] == "_" do caName[j] = " "
					append UI_List_Data ("  ==== " + caName + " - " + (editData_Array.index as string) + " ====")
				)
				local ui_array = CAT_EditData_Array[i].ui_array
				for j = 1 to ui_array.count do
				(
					append UI_Data_XRef (editDataPair editData_Array j)
					append UI_List_Data ui_array[j]
				)
			)
		)
		
 		fn updateUI =
		(
			CAT_UIList.Items = UI_List_Data
			
			currentItem = null_UIItem 
			if (UI_Data_XRef.count != 0) then 
			(
				local selIndex = 1
				if (UI_Data_XRef.count > 1 and UI_Data_XRef[1].index == 0 and UI_Data_XRef[2].index != 0) do
					selIndex = 2
				CAT_UIList.selection = selIndex
				CAT_UIList_SelectionChanged selIndex
			)
			else
			(
				CAT_EditUI_Accept.enabled = CAT_EditUI_Delete.enabled = CAT_EditUI_DeleteAll.enabled = false
				CAT_EditUI_Up.enabled = CAT_EditUI_Down.enabled = false
				CAT_Edit_Set currentItem
			)	
		)
		
		On CAT_EditUI_Reset pressed Do 
		(
			reloadEditData()
			rebuildEditData()
			updateUI()
		)

		on CAT_EditUIRoll open do
		(
			CAT_InEdit = true
			inUpdate = false
			
			reloadEditData()
			rebuildEditData()
			updateUI()

			CAT_FinishRoll.update_buttons()
			callbacks.addScript #modPanelObjPostChange "CAT_EditUIRoll.ModPanelObjChange()" id:#CAT_Edit_ModPanelObjChange
				
			b1_yoff = CAT_EditUI_Accept.pos.y - CAT_EditUIRoll.height
			b2_yoff = CAT_EditUI_Delete.pos.y - CAT_EditUIRoll.height
			b3_yoff = CAT_EditUI_Apply.pos.y - CAT_EditUIRoll.height
			l_yoff = CAT_UIList.height - CAT_EditUIRoll.height

			local dialogSize = GetDialogSize CAT_EditUIRoll
			if CAT_EditUIRoll_Height == undefined then
				CAT_EditUIRoll_Height = dialogSize.y
			else
				CAT_EditUIRoll.height = CAT_EditUIRoll_Height
		)
		
		on CAT_EditUIRoll close do
		(
			callbacks.removeScripts id:#CAT_Edit_ModPanelObjChange
			CAT_InEdit = false
			CAT_CheckedText = CAT_UIText = ("Param" + CAT_UINum as string)
			CAT_FinishRoll.CAT_UIName.text = CAT_UIText
			CAT_GetDef()
			if currentItem.type == #null do
			(
				CAT_Current_ParamType = #float
				CAT_FinishRoll.CAT_Type.selection = findItem CAT_ParamIDs CAT_Current_ParamType
				CAT_FinishRoll.CAT_UIType.items = #(CAT_UITypes[1],CAT_UITypes[2]) -- "Spinner", "Slider"
				CAT_Current_UIType = CAT_UIIDs[1]
				CAT_Set_Roll_Float()
				CAT_FinishRoll.CAT_UIType.enabled = CAT_FinishRoll.CAT_UIName.enabled = true
			)
			CAT_FinishRoll.update_buttons()
			CAT_EvalUI setFocusToFloater:false

			CAT_EditData_Array = CAT_SceneData_Array = UI_Data_XRef = UI_List_Data = undefined
			null_UIItem = undefined
			currentItem = undefined
		)
		
		on CAT_EditUIRoll OKToclose do (not inUpdate) -- return false if not currently updating CA
		
		on CAT_EditUIRoll resized newSize do 
		(
			If CAT_Debug == True then 
				format "resize in: % : % : % : % : %\n" CAT_EditUIRoll_Height newSize (GetDialogSize CAT_EditUIRoll) CAT_EditUI_Accept.pos b_yoff
			if newSize.y < 132 then 
				CAT_EditUIRoll.height = newSize.y = 132
			CAT_EditUIRoll_Height = newsize.y
			local y = b1_yoff + CAT_EditUIRoll.height
			CAT_EditUI_Up.pos = [CAT_EditUI_Up.pos.x,y]
			CAT_EditUI_Down.pos = [CAT_EditUI_Down.pos.x,y]
			CAT_EditUI_Accept.pos = [CAT_EditUI_Accept.pos.x,y]
			
			y = b2_yoff + CAT_EditUIRoll.height
			CAT_EditUI_Delete.pos = [CAT_EditUI_Delete.pos.x,y]
			CAT_EditUI_DeleteAll.pos = [CAT_EditUI_DeleteAll.pos.x,y]

			y = b3_yoff + CAT_EditUIRoll.height
			CAT_EditUI_Apply.pos = [CAT_EditUI_Apply.pos.x,y]
			CAT_EditUI_Reset.pos = [CAT_EditUI_Reset.pos.x,y]
			CAT_EditUI_Cancel.pos = [CAT_EditUI_Cancel.pos.x,y]
			
			CAT_UIList.height = l_yoff + CAT_EditUIRoll.height

			If CAT_Debug == True then 
				format "resize out: % : % : % : % : %\n" CAT_EditUIRoll_Height newSize (GetDialogSize CAT_EditUIRoll) CAT_EditUI_Accept.pos.y b_yoff
		) 
		

		on CAT_EditUI_Up pressed do
		(	
			local index = CAT_UIList.selection
			local edDataPair = UI_Data_XRef[index]
			If CAT_Debug == True then format "CAT_EditUI_Up pressed index: %\n" edDataPair.index
			if edDataPair.index != 0 then  -- parameter selected
			(
				local paramIndex = edDataPair.index
				local paramIndexm1 = paramIndex-1
				
				swap CAT_UIItems_Array[paramIndex] CAT_UIItems_Array[paramIndexm1]
				swap CAT_ParamBlock_Array[paramIndex] CAT_ParamBlock_Array[paramIndexm1] 
				swap CAT_UI_Array[paramIndex] CAT_UI_Array[paramIndexm1]
				swap UI_List_Data[index] UI_List_Data[index-1]
				CAT_UIList.Items = UI_List_Data
				local ii = index - 1
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii
				edDataPair.editData.dirty = true
			)
			else -- CA selected
			(
				local editData = edDataPair.editData
				local caIndex = findItem CAT_EditData_Array editData
				If CAT_Debug == True then 
				(
					format "CAT_EditUI_Up pressed A: % : %\n" caIndex CAT_EditData_Array[caIndex]
					format "CAT_EditUI_Up pressed B: % : %\n" (caIndex-1) CAT_EditData_Array[caIndex-1]
				)
				swap CAT_EditData_Array[caIndex] CAT_EditData_Array[caIndex-1]
				rebuildEditData()
				updateUI()
				local notFound = true
				local ii
				for i = 1 to UI_Data_XRef.count while notFound do
				(	ii = i;notFound = UI_Data_XRef[i].editData != editData)
				If CAT_Debug == True then format "CAT_EditUI_Up pressed C: % : %\n" notFound  ii
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii
			)
		)
		
		on CAT_EditUI_Down pressed do
		(	
			local index = CAT_UIList.selection
			local edDataPair = UI_Data_XRef[index]
			if edDataPair.index != 0 then  -- parameter selected
			(
				local paramIndex = edDataPair.index
				local paramIndexp1 = paramIndex+1
				
				swap CAT_UIItems_Array[paramIndex] CAT_UIItems_Array[paramIndexp1]
				swap CAT_ParamBlock_Array[paramIndex] CAT_ParamBlock_Array[paramIndexp1]
				swap CAT_UI_Array[paramIndex] CAT_UI_Array[paramIndexp1]
				swap UI_List_Data[index] UI_List_Data[index+1]
				CAT_UIList.Items = UI_List_Data
				local ii = index + 1
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii
				edDataPair.editData.dirty = true
				
			)
			else -- CA selected
			(
				local editData = edDataPair.editData
				local caIndex = findItem CAT_EditData_Array editData
				swap CAT_EditData_Array[caIndex] CAT_EditData_Array[caIndex+1]
				rebuildEditData()
				updateUI()
				local notFound = true
				local ii
				for i = 1 to UI_Data_XRef.count while notFound do
				(	ii = i;notFound = UI_Data_XRef[i].editData != editData)
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii
			)
		)
		
		On CAT_EditUI_Delete pressed do 
		(
			local index = CAT_UIList.selection
			local edDataPair = UI_Data_XRef[index]
			if edDataPair.index != 0 then  -- parameter selected
			(
				local paramIndex = edDataPair.index
				deleteItem CAT_UIItems_Array paramIndex
				deleteItem CAT_ParamBlock_Array paramIndex
				deleteItem CAT_UI_Array paramIndex
				deleteItem UI_Data_XRef index
				deleteItem UI_List_Data index
				CAT_UIList.Items = UI_List_Data
				for i = index to UI_Data_XRef.count while UI_Data_XRef[i].index != 0 do
					UI_Data_XRef[i].index -= 1
				local ii = index
				if index > UI_Data_XRef.count or UI_Data_XRef[index].index == 0 do ii -= 1
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii
				edDataPair.editData.dirty = true
				
			)
			else -- CA selected
			(

				local editData = edDataPair.editData
				local caIndex = findItem CAT_EditData_Array editData
				deleteItem CAT_EditData_Array caIndex
				rebuildEditData()
				updateUI()
				local ii = amin index UI_Data_XRef.count
				CAT_UIList.selection = ii
				CAT_UIList_SelectionChanged ii

			)
		)

		On CAT_EditUI_DeleteAll pressed do 
		(
			local index = CAT_UIList.selection
			local edDataPair = UI_Data_XRef[index]
			if edDataPair.index != 0 then  -- parameter selected
			(
				local caIndex = edDataPair.editData.index
				local caPos
				for i = UI_Data_XRef.count to 1 by -1 do 
				(
					local edDataPair2 = UI_Data_XRef[i]
					if edDataPair2.editData.index == caIndex do
					(
						if edDataPair2.index == 0 then caPos = i
						else 
						(
							local paramIndex = edDataPair2.index
							deleteItem CAT_UIItems_Array paramIndex
							deleteItem CAT_ParamBlock_Array paramIndex
							deleteItem CAT_UI_Array paramIndex
							deleteItem UI_Data_XRef i
							deleteItem UI_List_Data i
						)
					)
				)
				
				CAT_UIList.Items = UI_List_Data
				CAT_UIList.selection = caPos
				CAT_UIList_SelectionChanged caPos
				edDataPair.editData.dirty = true
				
			)
			else -- CA selected
			(

				CAT_EditData_Array=#()
				rebuildEditData()
				updateUI()
				CAT_UIList.selection = 0
				CAT_UIList_SelectionChanged 0
			)
		)

		fn processAlignment theUIItem opt offset_X offset_Y =
		(
			Case opt of 
			(
				1: theUIItem.Align = "Left"
				2: theUIItem.Align = "Right" 
				3: theUIItem.Align = "Center"
			)
			theUIItem.Offset = "[" + offset_X as string + "," + offset_Y as string + "]"
		)
		
		-- function called when a #modPanelObjPostChange event occurs
		fn ModPanelObjChange = 
		(
			DestroyDialog CAT_EditUIRoll
		)
	)

	-- function to build a ui string using the ROC item data in the provided UIItem structure instance
	fn CAT_BuildUIStringForControl theUIItem =
	(
		local UI_type = theUIItem.UI
		local uiTypeCat = UI_type
		if uiTypeCat == #DropdownList or uiTypeCat == #ListBox do uiTypeCat = #ComboBox
		
		local UIString = UI_type as string
		append UIString " " 
		append UIString theUIItem.Name 
		append UIString " \"" ; append UIString theUIItem.String 
		if uiTypeCat == #Spinner or uiTypeCat == #Slider or uiTypeCat == #ComboBox or uiTypeCat == #ColorPicker or uiTypeCat == #EditText do 
			append UIString ":"
		append UIString "\""
		append UIString " Width:" ; append UIString theUIItem.Width 
		append UIString " Height:" ; append UIString theUIItem.Height 
		append UIString " Align:#" ; append UIString theUIItem.Align 
		append UIString " Offset:" ; append UIString theUIItem.Offset 
		
		if UI_type == #Spinner or UI_type == #Slider then
		(	
			local sType = theUIItem.Type
			if sType == #Percent or sType == #Angle do sType = #Float
			append UIString " Type:#" ; append UIString sType
		)
		else
		(	append UIString " Type:#" ; append UIString theUIItem.Type)

		if (UI_type == #Spinner or UI_type == #Slider) do
		(	append UIString " Range:" ; append UIString theUIItem.Range)

		if (UI_type == #Slider) do
		(
			append UIString " Orient:#" ; append UIString theUIItem.Orient 
			append UIString " Ticks:" ; append UIString theUIItem.Ticks 
		)
		
		if (uiTypeCat == #ComboBox) do
		(	append UIString " Items:" ; append UIString theUIItem.Items)
			
		if (UI_type == #CheckButton) do
		(	append UIString " HighLightcolor:" ; append UIString theUIItem.HighLightColor)
			
		if (UI_type == #ColorPicker) do
		(	append UIString " Color:" ; append UIString theUIItem.Color)

		if (theUIItem.Type == #fRGBA) do
		(	append UIString " Alpha:" ; append UIString theUIItem.Alpha)

		if (UI_type == #PickButton) do
		(	append UIString " autoDisplay:true" )

		if (UI_type == #EditText) do
		(	append UIString " labelOnTop:" ; append UIString theUIItem.labelOnTop)
			
		append UIString "\n"
		If CAT_Debug == True then Format "theUIItem = %; UIString = %\n" theUIItem UIString 
		UIString 
	)
	
	fn CAT_wrapString inString quote:false=
	(
		if CAT_Debug == True do format "CAT_wrapString in - inString:%\n" inString 
		local str = "\""
		local str2 = "\\\""
		
		local temp_text_string = CAT_substituteString inString str str2 

		if quote do 
			temp_text_string = str + temp_text_string + str
			
		if CAT_Debug == True do format "CAT_wrapString out - temp_text_string:%\n" temp_text_string
		temp_text_string -- return value
	)
	
	fn CAT_unwrapString inString =
	(
		if CAT_Debug == True do format "CAT_unwrapString in - inString:%\n" inString 
		local str = "\\\""
		local str2 = "\""
		
		local temp_text_string = CAT_substituteString inString str str2 

		if CAT_Debug == True do format "CAT_unwrapString out - temp_text_string:%\n" temp_text_string
		temp_text_string -- return value
	)

	fn CAT_OpenDialog =
	(	
		-- reality check...
		if (CAT_FinishRoll != undefined and CAT_FinishRoll.isDisplayed) do return false
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Initialize Variables 
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		CAT_ParamBlock_Array = #()
		CAT_UIItems_Array = #()
		CAT_Source = #()
		CAT_Param_Remap = undefined
		
		if CAT_UINum == undefined do CAT_UINum = 1
		
		CAT_AttribName = "Custom_Attributes" -- the name of the custom attribute definition class. Do not localize!
		CAT_AttribName_Name = CAT_AttribName as name
	
		CAT_Updating_UI = false
		CAT_IsApplying = False
		CAT_InEdit = False
		
		/* Localize on */
		
		If CAT_CheckedText == undefined or CAT_CheckedText == "" do
		(
			CAT_CheckedText = ("Param" + CAT_UINum as string)
			CAT_UIText = CAT_CheckedText
		)
		/* Localize off */

		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Open up UI and addrollouts
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If CAT_Floater != undefined then CloseRolloutFloater CAT_Floater
		If CAT_UI_Size == undefined then CAT_UI_Size = [225,619]
		If CAT_UI_Pos == undefined then CAT_UI_Pos = getMAXWindowPos() + (getMAXWindowSize()/4)
		if CAT_UI_Pos.x < 0 do CAT_UI_Pos.x=0
		if CAT_UI_Pos.y < 0 do CAT_UI_Pos.y=0
		If CAT_FinishRoll_Open == undefined then CAT_FinishRoll_Open = true
		If CAT_UIOptionRO_Open == undefined then CAT_UIOptionRO_Open = true
		If CAT_TestRO_Open == undefined then CAT_TestRO_Open = true
		IF CAT_CheckedText == undefined or CAT_CheckedText == "" do
		(
			CAT_CheckedText = "Param1"
			CAT_UIText = CAT_CheckedText
		)
						
		/* Localize on */
		
		CAT_Floater = NewRolloutFloater "Parameter Editor" CAT_UI_Size.X CAT_UI_Size.Y CAT_UI_Pos.X CAT_UI_Pos.Y
		
		/* Localize off */
					
		AddRollout CAT_FinishRoll CAT_Floater rolledUP:(not CAT_FinishRoll_Open)
		CAT_Set_Roll_Float()
	
		CAT_EvalUI()
		
		if ( superclassof (modpanel.GetCurrentobject()) == modifier ) do CAT_FinishRoll.CAT_AddTo.selection = 2
		
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Create Selection handler
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		Callbacks.RemoveScripts ID:#CAT_Callback_Reset
		
		Callbacks.Addscript #selectionSetChanged "CAT_SelChange()" ID:#CAT_Callback
		Callbacks.Addscript #systemPreReset "CAT_Reset()" ID:#CAT_Callback_Reset
		Callbacks.Addscript #filePreOpen "CAT_Reset()" ID:#CAT_Callback_Reset
		Callbacks.Addscript #systemPreNew "CAT_Reset()" ID:#CAT_Callback_Reset
		CAT_SelChange ()
	)
	
	on execute do with undo off
	(
		if (CAT_FinishRoll != undefined and not CAT_FinishRoll.isDisplayed) do CAT_OpenDialog()
	)
	on isEnabled return (CAT_FinishRoll != undefined)
	on isChecked return (CAT_Floater != undefined and CAT_FinishRoll != undefined and CAT_FinishRoll.isDisplayed)
	on closeDialogs do with undo off
	(
		if (CAT_Floater != undefined and CAT_FinishRoll != undefined and CAT_FinishRoll.isDisplayed) do CloseRolloutFloater CAT_Floater
	)
)

MacroScript SVCustom_Attributes
	enabledIn:#("max") 
	ButtonText:"Edit Parameter..." 
	Category:"Schematic View" 
	internalCategory:"Schematic View" 
	Tooltip:"Add/Edit Parameters... (SV)" 
	SilentErrors:false -- (CAT_Debug != True)
(
	on Execute do
	(
		global CAT_FinishRoll, CAT_OpenDialog, CAT_SetTargetObject, CAT_Floater  -- globals from Custom_Attributes macroScript
		fn CAT_IsValidCADef theCADef = (local defdata = theCADef.defdata
										theCADef.name == #Custom_Attributes and ((classof defdata) == Array) and 
										(defdata.count == 2 or defdata.count == 3) and 
										(classof defdata[1] == Array and classof defdata[2] == Array) and
										(defdata[1].count == defdata[2].count) and
										(defdata[1].count == 0 or 
										 (classof defdata[1][1] == CAT_ParamBlock and classof defdata[2][1] == CAT_UIItem))
									   )

		local sv = schematicviews.current
		local svSelNodes = sv.getSelectedSVNodes()
		local svSelNode = sv.getSVNodeAnim svSelNodes[1]
		if (ismscustattrib svSelNode and CAT_IsValidCADef (classof svSelNode)) do
		(
			svSelNodes[1] = sv.getParentSVNodeID svSelNodes[1] 0
			svSelNode = sv.getSVNodeAnim svSelNodes[1]
		)
		local svSelNodeName = sv.getSVNodeName svSelNodes[1]
		if isController svSelNode do append svSelNodeName " controller"
		
		-- open Parameter Editor if not open
		if CAT_OpenDialog == undefined then-- Custom_Attributes macroScript not evaluated yet
			macros.run "Customize User Interface" "Custom_Attributes"
		else if (CAT_FinishRoll == undefined or not CAT_FinishRoll.isDisplayed) do
			CAT_OpenDialog()
		CAT_SetTargetObject svSelNode svSelNodeName
		setfocus CAT_Floater 
	)


	local okToExecute = fn okToExecute =
	(
		local sv, svSelNodes, theObject
		sv = schematicviews.current
		sv != undefined and (svSelNodes = sv.getSelectedSVNodes()).count == 1 and
		(theObject = sv.getSVNodeAnim svSelNodes[1]) != undefined  and 
		(classof theObject != ParamBlock2ParamBlock2)
	)

	on isVisible return okToExecute()
	on isEnabled return okToExecute()
)

MacroScript TVCustom_Attributes
	enabledIn:#("max") 
	ButtonText:"Edit Parameter... (TV)" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"Add/Edit Parameters... (TV)" 
	SilentErrors:false -- (CAT_Debug != True)
(
	on Execute do
	(
		global CAT_FinishRoll, CAT_OpenDialog, CAT_SetTargetObject, CAT_Floater  -- globals from Custom_Attributes macroScript
		fn CAT_IsValidCADef theCADef = (local defdata = theCADef.defdata
										theCADef.name == #Custom_Attributes and ((classof defdata) == Array) and 
										(defdata.count == 2 or defdata.count == 3) and 
										(classof defdata[1] == Array and classof defdata[2] == Array) and
										(defdata[1].count == defdata[2].count) and
										(defdata[1].count == 0 or 
										 (classof defdata[1][1] == CAT_ParamBlock and classof defdata[2][1] == CAT_UIItem))
									   )
		
		local tv = trackviews.current
		local tvSelNode = tv.getSelected 1
		local tvSelNodeName 
		if tvSelNode == rootnode then
			tvSelNodeName = "Scene Root Node"
		else if (isvalidnode tvSelNode) then
			tvSelNodeName = tvSelNode.name
		else if (ismscustattrib tvSelNode and CAT_IsValidCADef (classof tvSelNode)) then
		(
			tvSelNode = custAttributes.getOwner tvSelNode
			local tvSelParent = tv.getParent (tv.getIndex tvSelNode)
			local notFound = true
			local tvSelSubNum 
			for i = 1 to tvSelParent.numsubs while notFound do
				if (getSubAnim tvSelParent i).object == tvSelNode do
				(
					notFound = false
					tvSelSubNum = i
				)
			if tvSelSubNum != undefined then
				tvSelNodeName = getSubAnimName tvSelParent tvSelSubNum asString:true
			else
				tvSelNodeName = (classof tvSelNode) as string
			if isController tvSelNode do append tvSelNodeName " controller"
		)
		else if (isKindOf tvSelNode CustAttrib) then
			tvSelNodeName = tvSelNode.name
		else
		(
			local tvSelParent = tv.getParentOfSelected 1
			local tvSelSubNum = tv.getSelectedSubNum 1
			if tvSelParent != undefined then
			(
				-- video post and global tracks are subAnims of a ReferenceTarget, and then that ReferenceTarget
				-- is a a subAnim of the Scene (World in TV). MXS considers these 2 tracks to be direct subAnims of 
				-- Scene. Need to patch up the subAnim number in this case
				if tvSelSubNum > 1 and tvSelParent.superclassid == 256 do
				(	
					local cid = tvSelParent.classid
					if cid[1] == 8738 and cid[2] == 0 do tvSelSubNum += 1
				)
				-- check to make sure we got everything right
				local testObj = tvSelParent[tvSelSubNum]
				if classof testObj == subAnim do testObj.object
				if testObj == tvSelNode then
					tvSelNodeName = getSubAnimName tvSelParent tvSelSubNum asString:true
				else
				(	
					local notFound = true
					local tvSelSubNum2 
					for i = 1 to tvSelParent.numsubs while notFound do
						if (getSubAnim tvSelParent i).object == tvSelNode do
						(
							notFound = false
							tvSelSubNum2 = i
						)
					if tvSelSubNum2 != undefined then
						tvSelNodeName = getSubAnimName tvSelParent tvSelSubNum2 asString:true
					else
					(
						-- no good answer here - really need a trackViews method that returns the name of the track...
						tvSelNodeName = (classof tvSelNode) as string
					)
				)
			)
			else
				tvSelNodeName = (classof tvSelNode) as string
			
			if isController tvSelNode do append tvSelNodeName " controller"
		)
		
		-- open Parameter Editor if not open
		if CAT_OpenDialog == undefined then-- Custom_Attributes macroScript not evaluated yet
			macros.run "Customize User Interface" "Custom_Attributes"
		else if (CAT_FinishRoll == undefined or not CAT_FinishRoll.isDisplayed) do
			CAT_OpenDialog()
		CAT_SetTargetObject tvSelNode tvSelNodeName
		setfocus CAT_Floater 
	)

	local okToExecute = fn okToExecute =
	(
		local tv, theObject, theObjClass
		tv = trackviews.current
		tv != undefined and tv.numSelTracks() == 1 and 
		(theObject = tv.getSelected 1) != undefined and
		((theObjClass = classof theObject) != ParamBlock2ParamBlock2) and 
		(theObjClass != Scene) and 
		(classof (tv.getParentOfSelected 1) != Default_Sound)
	)

	on isVisible return okToExecute()
	on isEnabled return okToExecute()
)

MacroScript SVView_Custom_Attributes
	enabledIn:#("max") 
	ButtonText:"View Attribute Dialog..." 
	Category:"Schematic View" 
	internalCategory:"Schematic View" 
	Tooltip:"View Attribute Dialog... (SV)" 
	SilentErrors:false -- (CAT_Debug != True)
(
	on Execute do
	(
		local sv = schematicviews.current
		local svSelNodes = sv.getSelectedSVNodes()
		local svSelNode = sv.getSVNodeAnim svSelNodes[1]
		local width = 162
		if isKindof (custattributes.getOwner svSelNode) material do width = 326
		createDialog svSelNode.params width:width
	)

	local okToExecute = fn okToExecute =
	(
		fn CAT_IsValidCADef theCADef = (local defdata = theCADef.defdata
										theCADef.name == #Custom_Attributes and ((classof defdata) == Array) and 
										(defdata.count == 2 or defdata.count == 3) and 
										(classof defdata[1] == Array and classof defdata[2] == Array) and
										(defdata[1].count == defdata[2].count) and
										(defdata[1].count == 0 or 
										 (classof defdata[1][1] == CAT_ParamBlock and classof defdata[2][1] == CAT_UIItem))
									   )

		local  sv, svSelNode, svSelNodes
		sv = schematicviews.current
		sv != undefined and (svSelNodes = sv.getSelectedSVNodes()).count == 1 and
		(svSelNode = sv.getSVNodeAnim svSelNodes[1]) != undefined  and
		ismscustattrib svSelNode and
		CAT_IsValidCADef (classof svSelNode) and
		(isproperty svSelNode #params) and 
		(
			local ro = svSelNode.params
			(classof ro.params) == RolloutClass and not ro.isDisplayed
		) -- return value
	)

	on isVisible return okToExecute()
	on isEnabled return okToExecute()
)

MacroScript TVView_Custom_Attributes
	enabledIn:#("max") 
	ButtonText:"View Attribute Dialog... (TV)" 
	Category:"Track View" 
	internalCategory:"Track View" 
	Tooltip:"View Attribute Dialog... (TV)" 
	SilentErrors:false -- (CAT_Debug != True)
(
	on Execute do
	(
		local tv = trackviews.current
		local tvSelNode = tv.getSelected 1
		local width = 162
		if isKindof (custattributes.getOwner tvSelNode) material do width = 326
		createDialog tvSelNode.params width:width
	)

	local okToExecute = fn okToExecute =
	(
		fn CAT_IsValidCADef theCADef = (local defdata = theCADef.defdata
										theCADef.name == #Custom_Attributes and ((classof defdata) == Array) and 
										(defdata.count == 2 or defdata.count == 3) and 
										(classof defdata[1] == Array and classof defdata[2] == Array) and
										(defdata[1].count == defdata[2].count) and
										(defdata[1].count == 0 or 
										 (classof defdata[1][1] == CAT_ParamBlock and classof defdata[2][1] == CAT_UIItem))
									   )

		local tv, tvSelNode, ro
		tv = trackviews.current
		tv != undefined and tv.numSelTracks() == 1 and 
		(tvSelNode = tv.getSelected 1) != undefined and
		ismscustattrib tvSelNode and
		CAT_IsValidCADef (classof tvSelNode) and
		(isproperty tvSelNode #params) and 
		(
			local ro = tvSelNode.params
			(classof ro.params) == RolloutClass and not ro.isDisplayed
		) -- return value
	)

	on isVisible return okToExecute()
	on isEnabled return okToExecute()
)
