/*

  Macro_Scripts File
Purposes:  
    
	define actions for the viewport shading manager introduced in 3ds max 10

Revision History
	March 2007: Neil Hazzard
	created for 3ds MAX 10
*/

-- Macro Scripts for IViewportShadingMgr
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--***********************************************************************************************

MacroScript Viewport_Shading_None
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Off"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Shading None On/Off Toggle" 
(
	on ischecked do IViewportShadingMgr.ShadingLimits == #None
	
	On Execute Do 
		Try (IViewportShadingMgr.ShadingLimits = #None)
		Catch()
)

MacroScript Viewport_Shading_Good
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Good"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Shading Good On/Off Toggle" 
(
	on ischecked do IViewportShadingMgr.ShadingLimits == #good

	On isEnabled do IViewportShadingMgr.IsShadingLimitValid #good

	On Execute Do 
		Try (IViewportShadingMgr.ShadingLimits = #good)
		Catch()
)

MacroScript Viewport_Shading_Best
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Best"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Shading Best On/Off Toggle" 
(
	on ischecked do IViewportShadingMgr.ShadingLimits == #best
		
	On isEnabled do IViewportShadingMgr.IsShadingLimitValid #best
	
	On Execute Do 
		Try (IViewportShadingMgr.ShadingLimits = #Best)
		Catch()
)

MacroScript Viewport_Shading_Display_Selected_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Display Only Selected Lights"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Display Only Selected Lights" 
(
	On Execute Do IViewportShadingMgr.DisplayOnlySelectedLights()
)

MacroScript Viewport_Shading_Toggle_Selected_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Auto Display Selected Lights"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Display Only Selected Lights On/Off Toggle" 
(
	on ischecked do IViewportShadingMgr.AutoDisplaySelLights 
	On Execute Do
		Try (IViewportShadingMgr.AutoDisplaySelLights  = (not IViewportShadingMgr.AutoDisplaySelLights ))	
		catch()
)

MacroScript Viewport_Shading_Lock_Selected_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Lock Selected Lights"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Lock Selected Lights" 
(
	On Execute Do IViewportShadingMgr.LockSelectedLights true
)

MacroScript Viewport_Shading_Unlock_Selected_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Unlock Selected Lights"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Unlock Selected Lights" 
(
	On Execute Do IViewportShadingMgr.LockSelectedLights false
)

MacroScript Viewport_Shading_Select_Illuminating_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Select Lights Displaying Lighting "
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Select Lights Displaying Lighting"  
(
	On Execute Do IViewportShadingMgr.SelectIlluminatingLights()
)

MacroScript Viewport_Shading_Select_Shadow_Casting_Lights
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Select Lights Displaying Shadows "
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Select Lights Displaying Shadows" 
(
	On Execute Do IViewportShadingMgr.SelectShadowCastingLights()
)

MacroScript Viewport_Shading_Enable_Shadows_Selected
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Enable Viewport Shadows Selected"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Enable Viewport Shadows Selected" 
(
	On Execute Do IViewportShadingMgr.CastShadowsSelectedOnly true
)

MacroScript Viewport_Shading_Disable_Shadows_Selected
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Disable Viewport Shadows Selected"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Disable Viewport Shadows Selected" 
(
	On Execute Do IViewportShadingMgr.CastShadowsSelectedOnly false
)

MacroScript Viewport_GPU_Diagnostics
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
            ButtonText:"Diagnose Video Hardware"
            category:"Viewport Shading Manager"
            internalCategory:"Viewport Shading Manager"
            Tooltip:"Diagnose Video Hardware" 
(
	On Execute Do IViewportShadingMgr.ReviewGPUDiagnostics()
)