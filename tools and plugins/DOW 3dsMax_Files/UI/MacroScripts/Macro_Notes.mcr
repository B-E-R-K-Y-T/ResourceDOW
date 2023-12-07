-- Notes MacroScript File
--
-- Created:  		Dec 1 2000
-- Last Updated: 	Dec 20 2000
--
-- Author :   Frederick Ruff
/*
Version:  3ds max 6

 
This script adds Popup Notes to scene files.
***********************************************************************************************
 MODIFY THIS AT YOUR OWN RISK
 

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 Localization Notes

 "Localize On" states an area where locization should begin
 "Localize Off"  states an area where locization should end

*** Localization Note *** states that the next line has special localization instructions for the next line.
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

*/

MacroScript AddPopupNote
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Add Pop-up Note"
Category:"Pop up Note" 
internalCategory:"Pop up Note" 
Tooltip:"Add a Pop-up Note" 
(
	/* "Localize On" */
	--Persistent Global Note_NoteString
	--Persistent Global Note_AuthorString
	--Persistent Global Note_TextString
	rollout NoteRollout "Pop-up Note" width:500 height:400
	(

	Edittext auth "Author:" fieldwidth:150 text:""
	Edittext dtstmp "Date:" fieldwidth:150 offset:[8,0] text:localtime
	Checkbox Persist "Show Note on File Open" checked:true
	Edittext line1 height:200 text:""

	Button CanclAll "Cancel" offset:[110,0] width:75
	Button Go "Add Note" offset:[190,-26] width:75
	
	On Go pressed do
		(
		callbacks.removescripts id:#SceneNote
		
		
		-- *** Localization Note *** states that the next line has special localization instructions for the next line.
		-- Persistent Global Note_NoteString = "Messagebox \"" + "(loc)Author: " + auth.text+"\n"+dtstmp.text+"\n\n(loc)Note Comments:\n"+ line1.text+ "\"" + "title:\"(loc)Pop-up Note\""
		
		Persistent Global Note_NoteString = "Messagebox \"" + "Author: " + auth.text+"\n"+dtstmp.text+"\n\nNote Comments:\n"+ line1.text+ "\"" + "title:\"Pop-up Note\""
		Persistent Global Note_AuthorString = auth.text
		Persistent Global Note_TextString = line1.text
		If Persist.checked == true do callbacks.addscript #filepostopen "Execute Note_NoteString" id:#SceneNote persistent:true
		destroydialog NoteRollout
		fileproperties.addproperty #summary "comments" Note_TextString
		fileproperties.addproperty #summary "author" Note_AuthorString

		)
	On NoteRollout Open do 
		(
			try (auth.text = fileProperties.getPropertyvalue #summary 2) Catch()
			try (line1.text = fileProperties.getPropertyvalue #summary 1) Catch()
		)
	On CanclAll pressed do destroydialog NoteRollout
	)
	CreateDialog  NoteRollout  width:500 height:300		
	
)

MacroScript ReadPopupNote
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch

ButtonText:"Read Pop-up Note"
Category:"Pop up Note" 
internalCategory:"Pop up Note" 
Tooltip:"Reads the Pop-up Note" 
(
	If Note_NoteString != undefined then Execute Note_NoteString
	Else  MessageBox "No Notes present." Title:"Pop-up Note" beep:no
)

MacroScript DeletePopupNote
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Delete Pop-up Note"
Category:"Pop up Note" 
internalCategory:"Pop up Note" 
Tooltip:"Delete the Pop-up Note" 
(
	If Note_NoteString != undefined then
	(
		 if querybox "Are you sure?" then 
		(
		callbacks.removescripts id:#SceneNote
		messagebox "The Note has been deleted." title:"Pop-up Note" beep:no
		Note_NoteString = undefined
		)
	)
	Else  MessageBox "No Notes present." Title:"Pop-up Note" beep:no
)

MacroScript SupressPopupNote
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Suppress Pop-up Note"
Category:"Pop up Note" 
internalCategory:"Pop up Note" 
Tooltip:"Suppress a persistent Pop-up Note" 
(
	if Note_NoteString != undefined then
		(
		callbacks.removescripts id:#SceneNote
	
		messagebox "The Note has been suppressed.\n\n It will no longer appear when the file is opened. Please re-save the file in order to save the changes." title:"Pop-up Note" beep:no
		)
	Else MessageBox "No Note present." Title:"Pop-up Note" beep:no
)
/* "Localize Off" */