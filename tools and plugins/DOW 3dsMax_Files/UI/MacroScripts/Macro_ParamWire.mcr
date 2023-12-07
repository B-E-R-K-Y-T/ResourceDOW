/*
Parameter Wiring Macroscript File

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


---***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 
*/

macroScript paramWire 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"Parameter Wire"
	internalCategory:"Parameter Wire"
	buttonText:"Wire Parameters..." --pfbreton 29 mai 2003 added "..."
	tooltip:"Start Parameter Wiring..." --pfbreton 29 mai 2003 added "..."

 	Icon:#("MAXScript",1)
( 
	on isEnabled return selection.count == 1
	on execute do (paramWire.start()) 
     --on altExecute type do paramWire.OpenEditor() 


) 

macroScript paramWire_dialog
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"Parameter Wire"
	internalCategory:"Parameter Wire"
	buttonText:"Parameter Wire Dialog..." --pfbreton 29 mai 2003 added "..."
	tooltip:"Parameter Wiring Dialog..." --pfbreton 29 mai 2003 added "..."
 	Icon:#("MAXScript",1)
( 

 	on execute do (paramWire.OpenEditor()) 

) 
