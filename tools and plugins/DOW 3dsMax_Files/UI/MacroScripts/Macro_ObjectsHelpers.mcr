/*
Macro_Scripts File
Purposes:  
    
	define action for each creatable Helper object to hook up to the create main menu (or quads)
	defines macros for Quads

Revision History
	2 aug 2004, Pierre-Felix Breton
		added character studio helpers and new math helper

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

	26 Mai 2003: Pierre-felix Breton
		created for 3ds MAX 6


*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK



------------------------------------------------------------------------------
macroScript Dummy 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Dummy"
			ButtonText:"Dummy" 
            Icon:#("Helpers",1)
(
    on execute do StartObjectCreation Dummy
    on isChecked return mcrUtils.IsCreating Dummy 
)
------------------------------------------------------------------------------
macroScript Point 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Point" 
			ButtonText:"Point"
            Icon:#("Helpers",2)
(
    on execute do StartObjectCreation Point
    on isChecked return mcrUtils.IsCreating Point 
)
------------------------------------------------------------------------------
macroScript Protractor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Protractor"
			ButtonText:"Protractor" 
            Icon:#("Helpers",3)
(
    on execute do StartObjectCreation Protractor
    on isChecked return mcrUtils.IsCreating Protractor
)
------------------------------------------------------------------------------
macroScript Grid 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Grid"
			ButtonText:"Grid" 
            Icon:#("Helpers",4)
(
    on execute do StartObjectCreation Grid
    on isChecked return mcrUtils.IsCreating Grid 
)


macroScript ActivateGrid 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch

            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Activate Grid (Context)"
			ButtonText:"Activate Grid" 

(
	On IsEnabled Return (if activegrid != $ do true)
	On IsVisible Return Filters.Is_Grid $

	On Execute Do Try(ActiveGrid = $)Catch()
)
macroScript ActivateHomeGrid 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Activate HomeGrid (Context)"
			ButtonText:"Activate HomeGrid" 
(
	On IsEnabled Return (if activegrid != undefined do true)
	On IsVisible Return Filters.Is_Grid $

	On Execute Do Try(max activate home grid)Catch()
)

--**********************************************************

------------------------------------------------------------------------------
macroScript Tape 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Tape Measure"
			ButtonText:"Tape Measure" 
            Icon:#("Helpers",5)
(
    on execute do StartObjectCreation Tape
    on isChecked return mcrUtils.IsCreating Tape 
)


------------------------------------------------------------------------------
macroScript Compass 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Compass"
			ButtonText:"Compass" 
            Icon:#("Helpers",6)
(
    on execute do StartObjectCreation Compass
    on isChecked return mcrUtils.IsCreating Compass 
)


------------------------------------------------------------------------------
macroScript Boxgizmo
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Box Gizmo (Atmospheres)"
			ButtonText:"Box Gizmo" 
            Icon:#("AtmosApp",1)
(
    on execute do StartObjectCreation BoxGizmo
    on isChecked return mcrUtils.IsCreating BoxGizmo 
)


------------------------------------------------------------------------------
macroScript CylGizmo 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Cylinder Gizmo (Atmospheres)"
			ButtonText:"Cylinder Gizmo" 
            Icon:#("AtmosApp",2)
(
    on execute do StartObjectCreation CylGizmo
    on isChecked return mcrUtils.IsCreating CylGizmo 
)


------------------------------------------------------------------------------
macroScript SphereGizmo 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Sphere Gizmo (Atmospheres)"
			ButtonText:"Sphere Gizmo" 
            Icon:#("AtmosApp",3)
(
    on execute do StartObjectCreation SphereGizmo
    on isChecked return mcrUtils.IsCreating SphereGizmo 
)


------------------------------------------------------------------------------
macroScript CamPoint 
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Camera Point"
			ButtonText:"Camera Point" 
            Icon:#("CamP",1)
(
    on execute do StartObjectCreation CamPoint
    on isChecked return mcrUtils.IsCreating CamPoint 
)


------------------------------------------------------------------------------
macroScript ManipConeAngle 
enabledIn:#("max") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Manipulator Cone Angle"
			ButtonText:"Cone Angle" 
(
    on execute do StartObjectCreation Cone_Angle
    on isChecked return mcrUtils.IsCreating Cone_Angle
)

------------------------------------------------------------------------------
macroScript ManipPlaneAngle 
enabledIn:#("max") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Manipulator Plane Angle"
			ButtonText:"Plane Angle" 
(
    on execute do StartObjectCreation Plane_Angle
    on isChecked return mcrUtils.IsCreating Plane_Angle
)

------------------------------------------------------------------------------
macroScript ManipSlider 
enabledIn:#("max") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Manipulator Slider"
			ButtonText:"Slider" 
(
    on execute do StartObjectCreation sliderManipulator
    on isChecked return mcrUtils.IsCreating sliderManipulator
)

------------------------------------------------------------------------------
macroScript VRMLAnchor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Anchor"
			ButtonText:"Anchor" 
(
    on execute do StartObjectCreation anchor
    on isChecked return mcrUtils.IsCreating anchor
)

------------------------------------------------------------------------------
macroScript VRMLAudioClip 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Audio Clip"
			ButtonText:"Audio Clip" 
(
    on execute do StartObjectCreation audioclip
    on isChecked return mcrUtils.IsCreating audioclip
)
------------------------------------------------------------------------------
macroScript VRMLBackground 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Background"
			ButtonText:"Background" 
(
    on execute do StartObjectCreation background
    on isChecked return mcrUtils.IsCreating background
)

------------------------------------------------------------------------------
macroScript VRMLBillboard 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Billboard"
			ButtonText:"Billboard" 
(
    on execute do StartObjectCreation billboard
    on isChecked return mcrUtils.IsCreating billboard
)

------------------------------------------------------------------------------
macroScript VRMLFog 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Fog"
			ButtonText:"Fog" 
(
    on execute do StartObjectCreation foghelper
    on isChecked return mcrUtils.IsCreating foghelper
)

------------------------------------------------------------------------------
macroScript VRMLInline 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Inline"
			ButtonText:"Inline" 
(
    on execute do StartObjectCreation inline
    on isChecked return mcrUtils.IsCreating inline
)

------------------------------------------------------------------------------
macroScript VRMLLOD 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML LOD"
			ButtonText:"LOD" 
(
    on execute do StartObjectCreation lod
    on isChecked return mcrUtils.IsCreating lod
)

------------------------------------------------------------------------------
macroScript VRMLNavInfo 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML NavInfo"
			ButtonText:"NavInfo" 
(
    on execute do StartObjectCreation NavInfo
    on isChecked return mcrUtils.IsCreating NavInfo
)

------------------------------------------------------------------------------
macroScript VRMLProxSensor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML ProxSensor"
			ButtonText:"ProxSensor" 
(
    on execute do StartObjectCreation ProxSensor
    on isChecked return mcrUtils.IsCreating ProxSensor
)

------------------------------------------------------------------------------
macroScript VRMLSound 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML Sound"
			ButtonText:"Sound" 
(
    on execute do StartObjectCreation Sound
    on isChecked return mcrUtils.IsCreating Sound
)

------------------------------------------------------------------------------
macroScript VRMLTimeSensor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML TimeSensor"
			ButtonText:"TimeSensor" 
(
    on execute do StartObjectCreation TimeSensor
    on isChecked return mcrUtils.IsCreating TimeSensor
)

------------------------------------------------------------------------------
macroScript VRMLTouchSensor 
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch 
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"VRML TouchSensor"
			ButtonText:"TouchSensor" 
(
    on execute do StartObjectCreation TouchSensor
    on isChecked return mcrUtils.IsCreating TouchSensor
)


------------------------------------------------------------------------------
macroScript Character_Studio_Delegate 
enabledIn:#("max")
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Delegate"
			ButtonText:"Delegate" 
(
    on execute do StartObjectCreation Delegate
    on isChecked return mcrUtils.IsCreating Delegate
)
------------------------------------------------------------------------------
macroScript Character_Studio_Crowd
enabledIn:#("max")
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Crowd"
			ButtonText:"Crowd" 
(
    on execute do StartObjectCreation Crowd
    on isChecked return mcrUtils.IsCreating Crowd
)

------------------------------------------------------------------------------
macroScript ExposeTM
enabledIn:#("max")
            category:"Objects Helpers" 
            internalCategory:"Objects Helpers" 
            tooltip:"Expose Transform"
			ButtonText:"Expose Transform" 
(
    on execute do StartObjectCreation ExposeTm
    on isChecked return mcrUtils.IsCreating ExposeTm
)