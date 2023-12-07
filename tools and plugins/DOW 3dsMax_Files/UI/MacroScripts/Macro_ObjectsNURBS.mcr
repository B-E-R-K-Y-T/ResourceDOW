-- Macro_Scripts File
-- Purpose:  define action for each creatable Nurbs surfaces and curves objects to hook up to the create main menu (or quads)

/*
Revision History

	22 Jan 2004, Pierre-Felix Breton
		
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	
	24 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
macroScript Point_Surf 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch

            category:"Objects NURBS" 
            internalCategory:"Objects NURBS" 
			tooltip:"Point Surface" 
			ButtonText:"Point Surface"
            icon:#("NURBSSurface",1)
(
	on execute do (Try(StartObjectCreation Point_Surf) Catch () )
        on isChecked return (mcrUtils.IsCreating Point_Surf)
)

--------------------------------------------------------------------------------------------
macroScript CV_Surf 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects NURBS" 
            internalCategory:"Objects NURBS" 
            tooltip:"CV Surface"
			ButtonText:"CV Surface" 
            icon:#("NURBSSurface",2)
(
	on execute do (Try(StartObjectCreation NURBSSurf) Catch())
        on isChecked return (mcrUtils.IsCreating NURBSSurf)
)

--------------------------------------------------------------------------------------------
macroScript Point_Curve 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects NURBS" 
            internalCategory:"NObjects NURBSURBS" 
            tooltip:"Point Curve" 
            buttontext:"Point Curve" 
            Icon:#("NURBScurve",1)
(
   on execute do StartObjectCreation Point_Curve
   on isChecked return mcrUtils.IsCreating Point_Curve
)

--------------------------------------------------------------------------------------------
macroScript CV_Curve 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects NURBS" 
            internalCategory:"Objects NURBS" 
            tooltip:"CV Curve" 
            buttontext:"CV Curve" 
            Icon:#("NURBScurve",2)
(
   on execute do StartObjectCreation CV_Curve
   on isChecked return mcrUtils.IsCreating CV_Curve 
)
