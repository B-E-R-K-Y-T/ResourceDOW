/*

  Macro_Scripts File
Purposes:  
    
	define action for each creatable Shape object to hook up to the create main menu (or quads)


Revision History
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	26 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
	
	Nov 17 1999: Frank Delise
	created
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

----------------------------------------------------------
macroScript Lines 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Line Shape" 
            buttontext:"Line" 
            Icon:#("Splines",1)
(
   on execute do StartObjectCreation Line
   on isChecked return (mcrUtils.IsCreating Line)
)
----------------------------------------------------------
macroScript Circle 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Circle Shape" 
            buttontext:"Circle" 
            Icon:#("Splines",2)
(
   on execute do StartObjectCreation Circle 
   on isChecked return (mcrUtils.IsCreating Circle)
)
----------------------------------------------------------
macroScript Arc 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Arc Shape" 
            buttontext:"Arc" 
            Icon:#("Splines",3)
(
   on execute do StartObjectCreation Arc
   on isChecked return (mcrUtils.IsCreating Arc)
)
----------------------------------------------------------
macroScript Ngon 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"NGon Shape" 
            buttontext:"NGon" 
            Icon:#("Splines",4)
(
   on execute do StartObjectCreation Ngon
   on isChecked return (mcrUtils.IsCreating Ngon)
)
----------------------------------------------------------
macroScript Text 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Text Shape" 
            buttontext:"Text" 
            Icon:#("Splines",5)
(
   on execute do StartObjectCreation Text 
   on isChecked return (mcrUtils.IsCreating Text)
)
----------------------------------------------------------
macroScript Rectangle 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Rectangle Shape" 
            buttontext:"Rectangle" 
            Icon:#("Splines",7)
(
   on execute do StartObjectCreation Rectangle 
   on isChecked return (mcrUtils.IsCreating Rectangle)
)
----------------------------------------------------------
macroScript Ellipse 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Ellipse Shape" 
            buttontext:"Ellipse" 
            Icon:#("Splines",8)
(
   on execute do StartObjectCreation Ellipse 	
   on isChecked return (mcrUtils.IsCreating Ellipse)
)
----------------------------------------------------------
macroScript Donut 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Donut Shape" 
            buttontext:"Donut" 
            Icon:#("Splines",9)
(
   on execute do StartObjectCreation Donut 
   on isChecked return (mcrUtils.IsCreating Donut)
)
----------------------------------------------------------
macroScript Star 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Star Shape" 
            buttontext:"Star" 
            Icon:#("Splines",10)
(
   on execute do StartObjectCreation Star 
   on isChecked return (mcrUtils.IsCreating Star)
)
----------------------------------------------------------
macroScript Helix 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Helix Shape" 
            buttontext:"Helix" 
            Icon:#("Splines",11)
(
   on execute do StartObjectCreation Helix 
   on isChecked return (mcrUtils.IsCreating Helix)
)

----------------------------------------------------------
macroScript Section 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Section Shape" 
            buttontext:"Section " 
            Icon:#("Splines",6)
(
   on execute do StartObjectCreation Section 
   on isChecked return (mcrUtils.IsCreating Section)
)

----------------------------------------------------------
macroScript WRectangle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"WRectangle Shape" 
            buttontext:"WRectangle " 
            Icon:#("ExtendedSplines",2)
(
   on execute do StartObjectCreation WalledRectangle
   on isChecked return (mcrUtils.IsCreating WalledRectangle)
)

----------------------------------------------------------
macroScript Angle
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Angle Shape" 
            buttontext:"Angle " 
            Icon:#("ExtendedSplines",3)
(
   on execute do StartObjectCreation Angle
   on isChecked return (mcrUtils.IsCreating Angle)
)

----------------------------------------------------------
macroScript WideFlange
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Wide Flange Shape" 
            buttontext:"Wide Flange " 
            Icon:#("ExtendedSplines",4)
(
   on execute do StartObjectCreation WideFlange
   on isChecked return (mcrUtils.IsCreating WideFlange)
)

----------------------------------------------------------
macroScript Channel
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Channel Shape" 
            buttontext:"Channel " 
            Icon:#("ExtendedSplines",5)
(
   on execute do StartObjectCreation Channel
   on isChecked return (mcrUtils.IsCreating Channel)
)

----------------------------------------------------------
macroScript Tee
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Shapes" 
            internalCategory:"Objects Shapes" 
            tooltip:"Tee Shape" 
            buttontext:"Tee " 
            Icon:#("ExtendedSplines",6)
(
   on execute do StartObjectCreation Tee
   on isChecked return (mcrUtils.IsCreating Tee)
)
