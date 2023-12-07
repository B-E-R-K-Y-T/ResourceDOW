/*

Quad Swap MacroScript File


	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

MacroScript AssignRCAnimation
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Quad Swap to Animation" 
	Category:"Quad Menu Sets" 
	internalCategory:"Quad Menu Sets" 
	Tooltip:"Quad Swap to Animation" 

(
	quadmenu = menuman.findQuadMenu "Animation          [Alt+RMB]"
        if (quadmenu != undefined) then 
        (
  	    quadmenu.trackmenu true
	    menuman.setViewportRightClickMenu #nonePressed quadmenu
        )
)

MacroScript AssignRCCommon
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Quad Swap to Default" 
	Category:"Quad Menu Sets" 
	internalCategory:"Quad Menu Sets" 
	Tooltip:"Quad Swap to Default" 

(
	quadmenu = menuman.findQuadMenu "Default Viewport Quad" 
        if (quadmenu != undefined) then 
        (
  	    quadmenu.trackmenu true
	    menuman.setViewportRightClickMenu #nonePressed quadmenu
        )
)

MacroScript AssignRCModeling
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Quad Swap to Modeling" 
	Category:"Quad Menu Sets" 
	internalCategory:"Quad Menu Sets" 
	Tooltip:"Quad Swap to Modeling" 

(
	quadmenu = menuman.findQuadMenu "Modeling          [Ctrl+RMB]" 
        if (quadmenu != undefined) then 
        (
	    quadmenu.trackmenu true
	    menuman.setViewportRightClickMenu #nonePressed quadmenu
        )
)

MacroScript AssignRCRendering
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	ButtonText:"Quad Swap to Rendering" 
	Category:"Quad Menu Sets" 
	internalCategory:"Quad Menu Sets" 
	Tooltip:"Quad Swap to Rendering" 

	(
	quadmenu = menuman.findQuadMenu "Lighting | Render          [Ctrl+Alt+RMB]"
        if (quadmenu != undefined) then 
        (
	    quadmenu.trackmenu true
	    menuman.setViewportRightClickMenu #nonePressed quadmenu
        )
	)
