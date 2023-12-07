/*
 Show TimeSlider Macro

12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		changed logic to fit better with max termiology and behavior

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--

MacroScript UI_TimeSlider_Toggle
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Show Time Slider"
Category:"Customize User Interface" 
internalCategory:"Customize User Interface" 
Tooltip:"Show Time Slider" 
-- Needs Icon
(
	
	on isChecked return (TimeSlider.IsVisible ())
	on execute do
	(	
		Try(If (TimeSlider.IsVisible ()) == False then (TimeSlider.SetVisible True) else (TimeSlider.SetVisible False))Catch()
	)

)