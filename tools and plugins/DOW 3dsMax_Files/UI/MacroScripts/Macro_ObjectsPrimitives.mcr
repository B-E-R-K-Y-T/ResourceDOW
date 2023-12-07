-- Macro_Scripts File
-- Purpose:  define action for each creatable Standard and Extended Primitive objects to hook up to the create main menu (or quads)

/*
Revision History

	21 jan 2004, Pierre-Felix Breton
		turning some primitives back on
		
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	24 Mai 2003: Pierre-felix Breton
	created for 3ds MAX 6
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

--------------------------------------------------------------------------------------------
-- Standard Primitives

--------------------------------------------------------------------------------------------
macroScript Box 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Box" 
			ButtonText:"Box"
            icon:#("standard", 1)
(
	on execute do StartObjectCreation Box
        on isChecked return (mcrUtils.IsCreating Box)
)

--------------------------------------------------------------------------------------------
macroScript Cone 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Cone" 
			ButtonText:"Cone"
            icon:#("Standard",6)
(
	on execute do StartObjectCreation Cone
        on isChecked return (mcrUtils.IsCreating Cone)
)

--------------------------------------------------------------------------------------------
macroScript Sphere
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Sphere"
			ButtonText:"Sphere" 
            icon:#("standard", 2)
(
	on execute do StartObjectCreation Sphere 
        on isChecked return (mcrUtils.IsCreating Sphere)
)

--------------------------------------------------------------------------------------------
macroScript GeoSphere 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"GeoSphere"
			ButtonText:"GeoSphere" 
            icon:#("Standard",7) 
(
	on execute do (Try(StartObjectCreation GeoSphere) Catch() )
        on isChecked return (mcrUtils.IsCreating GeoSphere)
)

--------------------------------------------------------------------------------------------
macroScript Cylinder 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Cylinder"
			ButtonText:"Cylinder" 
            icon:#("Standard",3)
(
	on execute do StartObjectCreation Cylinder 
        on isChecked return (mcrUtils.IsCreating Cylinder)
)

--------------------------------------------------------------------------------------------
macroScript Tube 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Tube"
			ButtonText:"Tube" 
            icon:#("Standard",8)
(
	on execute do StartObjectCreation Tube 
        on isChecked return (mcrUtils.IsCreating Tube)
)


-------------------------------------------------------------------------------
macroScript Torus 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Torus"
			ButtonText:"Torus" 
            icon:#("Standard",4)
(
	on execute do StartObjectCreation Torus 
        on isChecked return (mcrUtils.IsCreating Torus)
)


--------------------------------------------------------------------------------------------
macroScript Pyramid 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Pyramid"
			ButtonText:"Pyramid" 
            icon:#("Standard",9)
(
	on execute do StartObjectCreation Pyramid 
        on isChecked return (mcrUtils.IsCreating Pyramid)
)

--------------------------------------------------------------------------------------------
macroScript Torus_Knot 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Torus Knot"
			ButtonText:"Torus Knot" 
            icon:#("Extended",7)
(
	on execute do StartObjectCreation Torus_Knot 
        on isChecked return (mcrUtils.IsCreating Torus_Knot)
)

--------------------------------------------------------------------------------------------
macroScript Quadpatch 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects Patch" 
internalCategory:"Objects Patch"
            tooltip:"Quad Patch"
			ButtonText:"Quad Patch" 
            icon:#("Patches",1)
(	
	on execute do StartObjectCreation Quadpatch
        on isChecked return (mcrUtils.IsCreating Quadpatch)
)

--------------------------------------------------------------------------------------------
macroScript Tripatch 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
category:"Objects Patch" 
internalCategory:"Objects Patch"
            tooltip:"Tri Patch"
			ButtonText:"Tri Patch" 
            icon:#("Patches",2)
(
	on execute do StartObjectCreation Tripatch 
        on isChecked return (mcrUtils.IsCreating Tripatch)
)



--------------------------------------------------------------------------------------------
macroScript plane 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Plane"
			ButtonText:"Plane" 
            icon:#("Standard",10)
(
	on execute do StartObjectCreation Plane
        on isChecked return (mcrUtils.IsCreating Plane)
)

--------------------------------------------------------------------------------------------
macroScript L_Ext 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"L-Extrusion"
			ButtonText:"L-Extrusion" 
            icon:#("Extended",10)
(
	on execute do StartObjectCreation L_Ext
        on isChecked return (mcrUtils.IsCreating L_Ext)
)

--------------------------------------------------------------------------------------------
macroScript Spindle 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Spindle"
			ButtonText:"Spindle" 
            icon:#("Extended",4)
(
	on execute do StartObjectCreation Spindle 
        on isChecked return (mcrUtils.IsCreating Spindle)
)

--------------------------------------------------------------------------------------------
macroScript ChamferBox 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"ChamferBox"
			ButtonText:"Chamfer Box" 
            icon:#("Extended",2)
(	
	on execute do StartObjectCreation ChamferBox 
        on isChecked return (mcrUtils.IsCreating ChamferBox)
)

--------------------------------------------------------------------------------------------
macroScript OilTank 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Oil Tank"
			buttontext:"Oil Tank" 
            icon:#("Extended",3)
(	
	on execute do StartObjectCreation OilTank 
        on isChecked return (mcrUtils.IsCreating OilTank)
)

--------------------------------------------------------------------------------------------
macroScript RingWave 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"RingWave"
			ButtonText:"RingWave" 
            icon:#("Extended",6)
(
	on execute do StartObjectCreation RingWave 
        on isChecked return (mcrUtils.IsCreating RingWave)
)

--------------------------------------------------------------------------------------------
macroScript C_Ext 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"C-Extrusion"
			ButtonText:"C-Extrusion" 
            icon:#("Extended",11)
(
	on execute do StartObjectCreation C_Ext 
        on isChecked return (mcrUtils.IsCreating C_Ext)
)

--------------------------------------------------------------------------------------------
macroScript Gengon 
enabledIn:#("max","viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Gengon"
			ButtonText:"Gengon" 
            icon:#("Extended",5)
(
	on execute do StartObjectCreation Gengon 
        on isChecked return (mcrUtils.IsCreating Gengon)
)

--------------------------------------------------------------------------------------------
macroScript Prism 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Prism" 
			ButtonText:"Prism"
            icon:#("Extended",12) 
(
	on execute do StartObjectCreation Prism 
        on isChecked return (mcrUtils.IsCreating Prism)
)

--------------------------------------------------------------------------------------------
macroScript Capsule 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Capsule"
			ButtonText:"Capsule" 
            icon:#("Extended",9)
(
	on execute do StartObjectCreation Capsule 
        on isChecked return (mcrUtils.IsCreating Capsule)
)



--------------------------------------------------------------------------------------------
macroScript ChamferCyl 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Chamfer Cylinder"
			ButtonText:"Chamfer Cylinder" 
            icon:#("Extended",8)
(
	on execute do StartObjectCreation ChamferCyl 
        on isChecked return (mcrUtils.IsCreating ChamferCyl)
)


--------------------------------------------------------------------------------------------
macroScript Teapot 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Teapot"
			ButtonText:"Teapot" 
            icon:#("Standard",5)
(
	on execute do StartObjectCreation Teapot 
        on isChecked return (mcrUtils.IsCreating Teapot)
)

--------------------------------------------------------------------------------------------
macroScript Hedra
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Hedra"
			ButtonText:"Hedra" 
            icon:#("Extended",1)
(
	on execute do StartObjectCreation Hedra 
        on isChecked return (mcrUtils.IsCreating Hedra)
)
--------------------------------------------------------------------------------------------
macroScript Hose 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Primitives" 
            internalCategory:"Objects Primitives" 
            tooltip:"Hose"
			ButtonText:"Hose" 
(
	on execute do StartObjectCreation Hose 
        on isChecked return (mcrUtils.IsCreating Hose)
)

