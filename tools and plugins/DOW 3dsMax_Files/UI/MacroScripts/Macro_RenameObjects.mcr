--******************************************
-- Object Renaming Utility
-- 1.29.99 v1.06
-- David Humpherys
-- david@rezn8.com
--******************************************
MacroScript RenameObjects
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	tooltip:"Rename Objects..." --pfb 24 mai 2003: added "..." after the name
	buttontext:"Rename Objects..."
(	
	global ReNameFloater
	local MyAry = #()
	local PickAry = #()
	local checked = false
	rollout renamerollout "Rename Objects" width:216 height:300
	(
		radiobuttons objs "" pos:[48,12] width:129 height:16 labels:#("Selected", "Pick") columns:2
		checkbox base "" pos:[8,40] width:16 height:16 checked:true
		edittext base_text "Base Name: " pos:[26,40] width:172 height:16 enabled:true fieldwidth:101 
		checkbox prefix "" pos:[8,73] width:16 height:16
		edittext pre_text "Prefix: " pos:[26,73] width:172 height:16 enabled:true fieldwidth:101 
		spinner delPreSpin "" pos:[96,97] width:45 height:16 range:[0,20,0] type:#integer
		checkbox delPre "Remove First:" pos:[8,97] width:89 height:16 
		checkbox suffix "" pos:[8,130] width:16 height:16
		edittext suf_text "Suffix: " pos:[26,130] width:172 height:16 enabled:true fieldwidth:101 
		spinner delSufSpin "" pos:[96,154] width:45 height:16 range:[0,20,0] type:#integer
		checkbox delSuf "Remove Last:" pos:[8,154] width:90 height:16 
		checkbox suf_num "Numbered" pos:[8,187] width:73 height:16
		spinner base_num "Base Number: " pos:[58,207] width:90 height:16 range:[0,9999,0] type:#integer 
		spinner num_step "Step: " pos:[81,228] width:68 height:16 range:[-999,999,1] type:#integer 
		button do_rename "Rename" pos:[8,261] width:200 height:30
	
		label lbl16 "Digits" pos:[145,97] width:40 height:16
		label lbl17 "Digits" pos:[145,154] width:40 height:16
		on objs changed state do
		(
			if objs.state==2 then
			(
			-- CAL-06/21/02: use the previously picked object if selectByName is canceled
			MyAry =selectByName title:"Pick Objects to Rename" buttonText:"Use"
			if MyAry == undefined then MyAry = PickAry else PickAry = MyAry
			print MyAry
			)
		)
/* CAL-07/16/02: leave them on all the times to be consistent with other checkboxes
		on base changed state do
		(
			if state==on then base_text.enabled=true
			if state==off then base_text.enabled=false
		)
		on prefix changed state do
		(
			if state==on then pre_text.enabled=true
			if state==off then pre_text.enabled=false
		)
		on suffix changed state do
		(
			if state==on then suf_text.enabled=true
			if state==off then suf_text.enabled=false
		)
*/
		on do_rename pressed do with undo on
		(	
			if objs.state==1 then MyAry=selection
			findErrors=0
			CountNum=1
			for i in MyAry do
			(			
				if base.state==true then 
					(
					if base_text.text.count==0 then 
						(
						messagebox "Base Name text field empty." Title:"Base Rename Error"
						exit loop
						)
					i.name=base_text.text
					)
		
				if delpre.state==true then 
					(	
					if delprespin.value >= i.name.count then 
						(
						messagebox "The object being renamed doesn't have enough characters in
its name to remove the requested number. Rename cancelled." Title:"Prefix Rename Error:" 
						FindErrors=1
						exit loop
						)
					i.name=(substring i.name (delprespin.value+1) i.name.count)
					)
					
				if prefix.state==true then 
					(
					if Pre_text.text.count==0 then 
						(
						messagebox "Add Prefix text field empty." Title:"Prefix Rename Error:"
						FindErrors=1
						exit loop
						)
					i.name=(pre_text.text + i.name)
					)
							
				if delsuf.state==true then 
					(
					if delsufspin.value>=i.name.count then 
						(
						messagebox "The object being renamed doesn't have enough characters in
its name to remove the requested number. Rename cancelled." Title:"Suffix Rename Error:"
						FindErrors=1
						exit loop
						)
					i.name=(substring i.name 1 (i.name.count-delsufspin.value))
					)
					
				if suffix.state==true then 
					(
					if suf_text.text.count==0 then 
						(
						messagebox "Add Suffix text field empty." Title:"Suffix Rename Error:"
						FindErrors=1
						exit loop
						)
					i.name=(i.name + suf_text.text)
					)
		
				if suf_num.state==true then 
					(
					NumberPad=((base_num.value + ((CountNum-1)*num_step.value)) as string)
					if NumberPad.count == 1 then NumberPad=("0"+NumberPad)
					i.name=i.name + NumberPad
					CountNum+=1
					-- print "hello"
					)
			)
			-- Remove the comments from this line to close the rollout each time you rename
			--if findErrors == 0 then (closerolloutfloater ReNameFloater)
			
		)
		
		on renamerollout close do
		(
			checked = false
			updateToolbarButtons()
		)
	)
on execute do	
	(
		createDialog renamerollout 
		checked = true
	)

on closeDialogs do
	(
		destroyDialog renamerollout
	)
on isChecked return (checked)
)




