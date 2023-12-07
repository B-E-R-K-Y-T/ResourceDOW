-- Macro Scripts File
-- Created:  13 january 2005
-- Version:  3ds MAX 8
-- Author:   Michaelson Britt
-- Brush Preset action items
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript BrushPresets_OpenManager
	enabledIn:#("max") --rl: 2006.12.13 added product switch
	category:"Brush Presets"
	internalCategory:"Brush Presets"
	toolTip:"Open Brush Preset Manager"
	ButtonText:"Brush Preset Manager" 
	icon:#("Maxscript",1)
(
	on execute do (
		local b = brushpresetmgr
		if (b!=undefined) and b.IsActive() do
			b.OpenPresetMgr()
	)
	on isEnabled do (
		local b = brushpresetmgr
		(b!=undefined) and b.IsActive()
	)
)

macroScript BrushPresets_AddPreset
	enabledIn:#("max") --rl: 2006.12.13 added product switch
	category:"Brush Presets"
	internalCategory:"Brush Presets"
	toolTip:"Add Brush Preset"
	ButtonText:"Add Brush Preset" 
	icon:#("LayerToolbar",2)
(
	on execute do (
		local b = brushpresetmgr
		if (b!=undefined) and b.IsActive() do
			b.AddPreset()
	)
	on isEnabled do (
		local b = brushpresetmgr
		(b!=undefined) and b.IsActive()
	)
)
