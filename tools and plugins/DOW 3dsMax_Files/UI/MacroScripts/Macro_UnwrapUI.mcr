/*
Macro_scripts for UVW Unwrap

Version: 3dsmax 9



Revision History:
		
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		moved functions and dialog definition into the /stdplug/stdscripts/modifier_uvwunwrap_dialog.ms
	
	28th august 2006, Pierre-Felix Breton
		minor updates to actions

*/




macroScript OpenUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"OpenUnwrapUI"		
	silentErrors:TRUE

	
(

  unwrapModPKW = modpanel.getcurrentobject()
  xPKW =  unwrapModPKW.GetWindowX()
  yPKW =  unwrapModPKW.GetWindowY()
  hPKW =  unwrapModPKW.GetWindowH()
  if (hPKW==0) then
  	(
	yPKW = -10
	)  
  pPKW = Point2 xPKW (yPKW+hPKW)
  CreateDialog UnwrapUIDialog pos:pPKW style:#(#style_border)
  
  if (hPKW==0) then
  	(
	unwrapUIdialog.height = 0 
	)
  
)


macroScript MoveUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"MoveUnwrapUI"	
	silentErrors:TRUE

	
(
  unwrapModPKW = modpanel.getcurrentobject()
  xPKW = unwrapModPKW .GetWindowX()
  yPKW = unwrapModPKW .GetWindowY()
  hPKW = unwrapModPKW .GetWindowH()
  
  if (hPKW==0) then  
  	(
	yPKW = -10
	)

  pPKW = Point2 xPKW (yPKW+hPKW)
  SetDialogPos UnwrapUIDialog pPKW
    
  if (hPKW==0) then
  	(
	unwrapUIdialog.height = 0 
	)
   else
    (
	if 	(UnwrapUIDialog.dash_options.state==TRUE) then
		(
		if (unwrapUIdialog.height != 163 ) then
			unwrapUIdialog.height = 163  
		)
	else 
		(
		if (unwrapUIdialog.height != 78 ) then
			unwrapUIdialog.height = 78  
		)
	unwrapUIdialog.UpdateUI()
	)
)


macroScript CloseUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"CloseUnwrapUI"
	silentErrors:TRUE

	
(
  DestroyDialog UnwrapUIDialog
)


-----------------------------------------------------

macroScript UVWUnwrap_Stitch
enabledIn:#("max", "viz", "vizr") 
	category:"UVW Unwrap"
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"Stitch Selected"
	buttontext:"Stitch Selected"
(
	on execute do actionMan.executeAction 2077580866 "40043"  -- All Commands: Stitch
	on altExecute type do actionMan.executeAction 2077580866 "40044"  -- All Commands: Stitch Dialog	
)

macroScript UVWUnwrap_Sketch
enabledIn:#("max", "viz", "vizr") 
	category:"UVW Unwrap"
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"Sketch Vertices"
	buttontext:"Sketch Vertices"
(
	on execute do actionMan.executeAction 2077580866 "40114"  -- All Commands: Sketch
	on altExecute type do actionMan.executeAction 2077580866 "40112"  -- All Commands: Sketch Dialog
)

macroScript UVWUnwrap_Pack
enabledIn:#("max", "viz", "vizr") 
	category:"UVW Unwrap"
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"Pack UVs"
	buttontext:"Pack UVs"
(
	on execute do actionMan.executeAction 2077580866 "40074"  -- All Commands: Pack
	on altExecute type do actionMan.executeAction 2077580866 "40075"  -- All Commands: Pack Dialog
)

macroScript UVWUnwrap_Relax
enabledIn:#("max", "viz", "vizr") 
	category:"UVW Unwrap"
	internalCategory: "UVW Unwrap"  --do not localize
	toolTip:"Relax"
	buttontext:"Relax"
(
	on execute do actionMan.executeAction 2077580866 "40135"  -- All Commands: Relax
	on altExecute type do actionMan.executeAction 2077580866 "40136"  -- All Commands: Relax Dialog
)