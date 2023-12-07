/*

Macro Scripts for Dynamics

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript Damper 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
            category:"Objects Dynamics" 
            internalCategory:"Objects Dynamics" 
            tooltip:"Damper"
            buttontext:"Damper" 
            icon:#("DynObj",2) 
(
	on execute do (Try(StartObjectCreation Damper)Catch() )
        on isChecked return (mcrUtils.IsCreating Damper)
)

macroScript Spring
enabledIn:#("max") --pfb: 2003.12.12 added product switch 
	category:"Objects Dynamics" 
	internalCategory:"Objects Dynamics" 
	tooltip:"Spring"
	buttontext:"Spring" 
	icon:#("DynObj", 1)
(
	on execute do (Try(StartObjectCreation Spring)Catch())
        on isChecked return (mcrUtils.IsCreating Spring)
)

