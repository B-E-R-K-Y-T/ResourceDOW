-- Macro Scripts File
-- Created:  10 december 2003
-- Version:  3ds MAX 7
-- Author:   Michaelson Britt
-- VertexPaint action items
--************************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript VertexPaint_IgnoreBackfacing
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Ignore Backfacing (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Ignore Backfacing"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			m.ignoreBackfacing = not m.ignoreBackfacing
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )	
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			m.ignoreBackfacing
		)
		else false
	)
) --VertexPaint_IgnoreBackfacing

macroScript VertexPaint_MaskUnselected
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Mask Unselected (VertexPaint)"		--LOC_NOTES:localize this
buttontext:"Mask Unselected"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			m.hideUnselSubobjs = not m.hideUnselSubobjs
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )	
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			m.hideUnselSubobjs
		)
		else false
	)
) --VertexPaint_MaskUnselected

macroScript VertexPaint_LayerOpacityUp
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Layer Opacity Up (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Layer Opacity Up"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local opacity = m.layerOpacity
			if( opacity>95 ) then m.layerOpacity = 100
			else m.layerOpacity = (opacity+5)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(m.layerOpacity<100)
		)
		else false
	)
) --VertexPaint_LayerOpacityUp

macroScript VertexPaint_LayerOpacityDown
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Layer Opacity Down (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Layer Opacity Down"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local opacity = m.layerOpacity
			if( opacity<5 ) then m.layerOpacity = 0
			else m.layerOpacity = (opacity-5)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(m.layerOpacity>0)
		)
		else false
	)

) --VertexPaint_LayerOpacityDown


macroScript VertexPaint_PaintChannelUp
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Paint Channel Up (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Paint Channel Up"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local channel = m.mapChannel
			if( channel < 99 ) do m.mapChannel = (channel+1)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(m.mapChannel < 99)
		)
		else false
	)

) --VertexPaint_PaintChannelUp

macroScript VertexPaint_PaintChannelDown
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Paint Channel Down (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Paint Channel Down"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local channel = m.mapChannel
			if( channel > -2 ) do m.mapChannel = (channel-1)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(m.mapChannel > -2)
		)
		else false
	)

) --VertexPaint_PaintChannelDown

macroScript VertexPaint_DisplayChannelUp
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Display Channel Up (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Display Channel Up"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local channel = t.mapDisplayChannel
			if( (not t.mapDisplayChannelLock) and (channel < 99) ) do
				t.mapDisplayChannel = (channel+1)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			local t = vertexPaintTool()
			((not t.mapDisplayChannelLock) and (t.mapDisplayChannel < 99))
		)
		else false
	)

) --VertexPaint_DisplayChannelUp

macroScript VertexPaint_DisplayChannelDown
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Display Channel Down (VertexPaint)"--LOC_NOTES:localize this
buttontext:"Display Channel Down"			--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local channel = t.mapDisplayChannel
			if( (not t.mapDisplayChannelLock) and (channel > -2) ) do
				t.mapDisplayChannel = (channel-1)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			local t = vertexPaintTool()
			((not t.mapDisplayChannelLock) and (t.mapDisplayChannel > -2))
		)
		else false
	)

) --VertexPaint_DisplayChannelDown

macroScript VertexPaint_LockDisplayChannel
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Lock Display Channel (VertexPaint)"--LOC_NOTES:localize this
buttontext:"Lock Display Channel"			--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()		
			t.mapDisplayChannelLock = not t.mapDisplayChannelLock
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(vertexPaintTool()).mapDisplayChannelLock
		)
		else false
	)
) --VertexPaint_LockDisplayChannel

macroScript VertexPaint_BrushSizeUp
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Brush Size Up (VertexPaint)"		--LOC_NOTES:localize this
buttontext:"Brush Size Up"					--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local size = t.brushSize
			if( size>0 ) do t.brushSize *= (6.0/5.0)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )
	)
) --VertexPaint_BrushSizeUp

macroScript VertexPaint_BrushSizeDown
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Brush Size Down (VertexPaint)"		--LOC_NOTES:localize this
buttontext:"Brush Size Down"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local size = t.brushSize
			--if( size<... ) do --FIXME: should there be an upper limit?
				t.brushSize *= (5.0/6.0)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )
	)
) --VertexPaint_BrushSizeDown

macroScript VertexPaint_BrushOpacityUp
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Brush Opacity Up (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Brush Opacity Up"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local opacity = t.brushOpacity
			if( opacity>95 ) then t.brushOpacity = 100
			else t.brushOpacity = (opacity+5)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).brushOpacity<100)
		)
		else false
	)
) --VertexPaint_BrushOpacityUp

macroScript VertexPaint_BrushOpacityDown
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Brush Opacity Down (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Brush Opacity Down"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local opacity = t.brushOpacity
			if( opacity<5 ) then t.brushOpacity = 0
			else t.brushOpacity = (opacity-5)
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).brushOpacity>0)
		)
		else false
	)
) --VertexPaint_BrushOpacityDown

macroScript VertexPaint_MirrorMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Mirror Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Mirror Mode"					--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			t.mirrorMode = not t.mirrorMode
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			(vertexPaintTool()).mirrorMode
		)
		else false
	)
) --VertexPaint_MirrorMode

macroScript VertexPaint_MirrorModeAxis
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Mirror Mode Axis (VertexPaint)"	--LOC_NOTES:localize this
buttontext:"Mirror Mode Axis"				--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()		
			local axis = t.mirrorModeAxis
			if( axis==2 ) then t.mirrorModeAxis = 0
			else t.mirrorModeAxis = (axis+1) 
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		( (classof m) == VertexPaint )
	)
) --VertexPaint_MirrorModeAxis

macroScript VertexPaint_PaintMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Paint Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Paint Mode"					--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local mode = t.curPaintMode
			if( (mode==0) or (mode==2) or (mode==8) ) then
				t.curPaintMode = 1
			else if( mode==1 ) do
				t.curPaintMode = 0
			
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) then
		(
			local mode = (vertexPaintTool()).curPaintMode
			true
		)
		else false
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).curPaintMode == 1)
		)
		else false
	)
) --VertexPaint_PaintMode

macroScript VertexPaint_EraseMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Erase Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Erase Mode"						--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local mode = t.curPaintMode
			if( (mode==0) or (mode==1) or (mode==8) or (mode==9) ) then
				t.curPaintMode = 2
			else if( mode==2 ) do
				t.curPaintMode = 0
			
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) then
		(
			local mode = (vertexPaintTool()).curPaintMode
			true
		)
		else false
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).curPaintMode == 2)
		)
		else false
	)
) --VertexPaint_EraseMode

macroScript VertexPaint_PickMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Pick Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Pick Mode"					--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local mode = t.curPaintMode
			if( (mode==0) or (mode==1) or (mode==2) or (mode==9) ) then
				t.curPaintMode = 8
			else if( mode==8 ) do
				t.curPaintMode = 0
			
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) then
		(
			local mode = (vertexPaintTool()).curPaintMode
			true
		)
		else false
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).curPaintMode == 8)
		)
		else false
	)
) --VertexPaint_PickMode

macroScript VertexPaint_EraseMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Erase Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Erase Mode"						--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local mode = t.curPaintMode
			if( (mode==0) or (mode==1) or (mode==8) or (mode==9) ) then
				t.curPaintMode = 2
			else if( mode==2 ) do
				t.curPaintMode = 0
			
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) then
		(
			local mode = (vertexPaintTool()).curPaintMode
			true
		)
		else false
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then (
			((vertexPaintTool()).curPaintMode == 2)
		)
		else false
	)
) --VertexPaint_EraseMode

macroScript VertexPaint_BlurBrushMode
enabledIn:#("max")
category:"VertexPaint"						--LOC_NOTES:localize this
internalCategory: "VertexPaint"				--LOC_NOTES: do not localize this
tooltip:"Blur Brush Mode (VertexPaint)"			--LOC_NOTES:localize this
buttontext:"Blur Brush Mode"						--LOC_NOTES:localize this
(
	on execute do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) do
		(
			local t = vertexPaintTool()
			local mode = t.curPaintMode
			if( (mode==0) or (mode==1) or (mode==2) or (mode==8) ) then
				t.curPaintMode = 9
			else if( mode==2 ) do
				t.curPaintMode = 0
			
		)
	) -- on execute
	
	on isEnabled do
	(
		local m = modPanel.GetCurrentObject()
		if( (classof m) == VertexPaint ) then
		(
			local mode = (vertexPaintTool()).curPaintMode
			true
		)
		else 
		(
			false
		)
	)

	on isChecked do
	(
		local m = modPanel.GetCurrentObject()
		if ( (classof m) == VertexPaint ) then
		(
			((vertexPaintTool()).curPaintMode == 9)
		)
		else 
		(
			false
		)
	)
) --VertexPaint_BlurBrushMode
