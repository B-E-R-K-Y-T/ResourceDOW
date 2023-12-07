macroScript Non_Uniform_Scale
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Non-uniform Scale"
	buttontext:"Non-uniform Scale"
	Icon:#("Maintoolbar",27)
(
	try (ToolMode.nonUniformScale ())
	Catch ()
)

macroScript Move
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Move"
	buttontext:"Move"
	Icon:#("Maintoolbar",21)
(
	on execute do try (Max Move) Catch ()
	on altExecute type do 
	(	
		try (Max Move) Catch ()
		actionMan.executeAction 0 "40093" -- loc_notes: DO NOT LOCALIZE THIS
	)
	
)

macroScript Rotate
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Rotate"
	buttontext:"Rotate"
	Icon:#("Maintoolbar",23)

(
	on execute do try (Max Rotate) Catch ()
	on altExecute type do 
	(	
		try (Max Rotate) Catch ()
		actionMan.executeAction 0 "40093" -- loc_notes: DO NOT LOCALIZE THIS
	)
)

macroScript Scale
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Scale"
	buttontext:"Scale"
	Icon:#("Maintoolbar",25)
(
	on execute do try (Max Scale) Catch ()
	on altExecute type do 
	(	
		try (Max Scale) Catch ()
		actionMan.executeAction 0 "40093" -- loc_notes: DO NOT LOCALIZE THIS
	)
)
macroScript SmartScale
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Smart Scale"
	buttontext:"Smart Scale"
	Icon:#("Maintoolbar",25)
(
	try 
	(
		if toolmode.commandmode == #squash or toolmode.commandmode == #nuscale or toolmode.commandmode == #uscale then max scale cycle
		else max scale 
	)
	catch ()
)
macroScript SmartSelect
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Selection"
	internalCategory:"Selection"
	toolTip:"Smart Select"	buttontext:"Smart Select"
	Icon:#("Maintoolbar",11)
(
	try 
	(
		if toolmode.commandmode == #select then max cycle select 
		else max select
	)
	catch ()
)

macroScript PaintSelBrushSizeUp
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Selection"
	internalCategory:"Selection"
	toolTip:"Paint Selection Size Up"
	buttontext:"Paint Selection Size Up"
(
	try 
	(
		local size = maxops.paintSelBrushSize
		local newSize = (size * 1.25) as integer
		if( size == newSize ) do newSize = size+1
		maxops.paintSelBrushSize = newsize
	)
	catch ()
)

macroScript PaintSelBrushSizeDown
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Selection"
	internalCategory:"Selection"
	toolTip:"Paint Selection Size Down"
	buttontext:"Paint Selection Size Down"
(
	try 
	(
		local size = maxops.paintSelBrushSize
		local newSize = (size * 0.8) as integer
		if( newSize>1 ) do maxops.paintSelBrushSize = newSize
	)
	catch ()
)

macroScript uniformPlanarScale
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Uniform Planar Scale"
	buttontext:"Uniform Planar Scale"
	-- Needs Icon
(
	on isChecked return 
	(
		tmgizmos.uniformPlaneScaling
	)

	On Execute do
	(
	if  tmgizmos.uniformPlaneScaling then
		 tmgizmos.uniformPlaneScaling = FALSE
	else  tmgizmos.uniformPlaneScaling = TRUE
	)
)

macroScript freeRotate
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Free Rotate"
	buttontext:"Free Rotate"
	-- Needs Icon
(
	on isChecked return
	(
		tmgizmos.freeRotate
	)

	On Execute do
	(
	if  tmgizmos.freeRotate then
		 tmgizmos.freeRotate = false
	else  tmgizmos.freeRotate = true
	)
)


---pfb 28 dec 2003
macroScript PivotMode_Toggle
	enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
	category:"Tools"
	internalCategory:"Tools"
	toolTip:"Affect Pivot Only Mode Toggle"
	buttontext:"Affect Pivot Only Mode Toggle"
	--Icon:#("Internal",25)
(
	on execute do 
	(
		if maxops.pivotmode != #pivotonly
		then maxops.pivotmode = #pivotonly
		else maxops.pivotmode = #none

	)
)

