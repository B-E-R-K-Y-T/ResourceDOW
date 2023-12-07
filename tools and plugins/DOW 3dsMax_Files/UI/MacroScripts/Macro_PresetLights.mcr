MacroScript Free_40W_Bulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 40W Bulb"
 tooltip:"40W Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = off
			n.rgb = color 255 244.214 214.62 
    		n.intensityType = 1 
    		n.intensity = 38.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_40W_Bulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_40W_Bulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_40W_Bulb
) 
MacroScript Free_60W_Bulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 60W Bulb"
 tooltip:"60W Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = off
			n.rgb = color 255 244.214 214.62 
    		n.intensityType = 1 
    		n.intensity = 70.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_60W_Bulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_60W_Bulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_60W_Bulb
) 
MacroScript Free_75W_Bulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 75W Bulb"
 tooltip:"75W Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = off
			n.rgb = color 255 244.214 214.62 
    		n.intensityType = 1 
    		n.intensity = 95.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_75W_Bulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_75W_Bulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_75W_Bulb
) 
MacroScript Free_100W_Bulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 100W Bulb"
 tooltip:"100W Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = off
			n.rgb = color 255 244.214 214.62 
    		n.intensityType = 1 
    		n.intensity = 139.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_100W_Bulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_100W_Bulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_100W_Bulb
) 
MacroScript Free_21W_Hbulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 21W Hbulb"
 tooltip:"21W Halogen Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 1.0
			n.useKelvin = on
			n.kelvin = 2950.0
    		n.hotSpot = 36.0
    		n.falloff = 46.0
    		n.intensityType = 0 
    		n.flux = 260.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_21W_Hbulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_21W_Hbulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_21W_Hbulb
) 
MacroScript Free_35W_Hbulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 35W Hbulb"
 tooltip:"35W Halogen Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 1.0
			n.useKelvin = on
			n.kelvin = 3050.0
    		n.hotSpot = 36.0
    		n.falloff = 46.0
    		n.intensityType = 0 
    		n.flux = 400.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_35W_Hbulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_35W_Hbulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_35W_Hbulb
) 
MacroScript Free_50W_Hbulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 50W Hbulb"
 tooltip:"50W Halogen Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 1.0
			n.useKelvin = on
			n.kelvin = 2750.0
    		n.hotSpot = 36.0
    		n.falloff = 46.0
    		n.intensityType = 0 
    		n.flux = 800.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_50W_Hbulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_50W_Hbulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_50W_Hbulb
) 
MacroScript Free_80W_Hbulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 80W Hbulb"
 tooltip:"80W Halogen Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 1.0
			n.useKelvin = on
			n.kelvin = 2900.0
    		n.hotSpot = 36.0
    		n.falloff = 46.0
    		n.intensityType = 0 
    		n.flux = 1500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_80W_Hbulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_80W_Hbulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_80W_Hbulb
) 
MacroScript Free_100W_Hbulb
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 100W Hbulb"
 tooltip:"100W Halogen Bulb"
 icon:#("PhotometricLights", 3)
 --palettehint:Incandescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 1.0
			n.useKelvin = on
			n.kelvin = 2900.0
    		n.hotSpot = 36.0
    		n.falloff = 46.0
    		n.intensityType = 0 
    		n.flux = 2030.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_100W_Hbulb
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_100W_Hbulb
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_100W_Hbulb
) 
MacroScript Free_32W_4ftLamp
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 32W 4ftLamp"
 tooltip:"32W T8 4foot Lamp"
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
			n.useKelvin = on
			n.kelvin = 5000.0
    		n.intensityType = 0 
    		n.flux = 2800.0
    		n.light_length = units.decodeValue "4'"
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_32W_4ftLamp
  		LightCreationZHeight Free_Linear lightHeight setProps lightName:#Free_32W_4ftLamp
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_32W_4ftLamp
) 
MacroScript Free_59W_8ftLamp
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 59W 8ftLamp"
 tooltip:"59W T8 8foot Lamp"
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
			n.useKelvin = on
			n.kelvin = 3000.0
    		n.intensityType = 0 
    		n.flux = 5650.0
    		n.light_length = units.decodeValue "8'"
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_59W_8ftLamp
  		LightCreationZHeight Free_Linear lightHeight setProps lightName:#Free_59W_8ftLamp
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_59W_8ftLamp
) 
MacroScript Free_8W_RedNeon
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 8W RedNeon"
 tooltip:"8W Red Neon Lamp"
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_8W_RedNeon
  		LightCreationZHeight Free_Linear lightHeight setProps lightName:#Free_8W_RedNeon
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_8W_RedNeon
) 
MacroScript Free_15W_CF
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 15W CF"
 tooltip:"15W Compact Fluor."
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2700.0
    		n.intensityType = 0 
    		n.flux = 765.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_15W_CF
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_15W_CF
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_15W_CF
) 
MacroScript Free_20W_CF
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 20W CF"
 tooltip:"20W Compact Fluor."
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2700.0
    		n.intensityType = 0 
    		n.flux = 925.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_20W_CF
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_20W_CF
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_20W_CF
) 
MacroScript Free_26W_CF
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 26W CF"
 tooltip:"26W Compact Fluor."
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2700.0
    		n.intensityType = 0 
    		n.flux = 1365.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_26W_CF
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_26W_CF
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_26W_CF
) 
MacroScript Free_29W_CF
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 29W CF"
 tooltip:"29W Compact Fluor."
 icon:#("PhotometricLights", 3)
 --palettehint:Fluorescent
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2700.0
    		n.intensityType = 0 
    		n.flux = 1500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_29W_CF
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_29W_CF
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_29W_CF
) 
MacroScript Free_39W_MV
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 39W MV"
 tooltip:"39W Mercury Vapor"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3000.0
    		n.intensityType = 0 
    		n.flux = 2100.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_39W_MV
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_39W_MV
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_39W_MV
) 
MacroScript Free_70W_MV
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 70W MV"
 tooltip:"70W Mercury Vapor"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3000.0
    		n.intensityType = 0 
    		n.flux = 4800.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_70W_MV
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_70W_MV
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_70W_MV
) 
MacroScript Free_100W_MV
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 100W MV"
 tooltip:"100W Mercury Vapor"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3000.0
    		n.intensityType = 0 
    		n.flux = 6500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_100W_MV
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_100W_MV
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_100W_MV
) 
MacroScript Free_400W_MV
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 400W MV"
 tooltip:"400W Mercury Vapor"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3700.0
    		n.intensityType = 0 
    		n.flux = 31500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_400W_MV
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_400W_MV
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_400W_MV
) 
MacroScript Free_1000W_MV
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 1000W MV"
 tooltip:"1000W Mercury Vapor"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3900.0
    		n.intensityType = 0 
    		n.flux = 82000.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_1000W_MV
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_1000W_MV
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_1000W_MV
) 
MacroScript Free_175W_MH
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 175W MH"
 tooltip:"175W Metal Halide"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 4000.0
    		n.intensityType = 0 
    		n.flux = 12500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_175W_MH
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_175W_MH
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_175W_MH
) 
MacroScript Free_250W_MH
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 250W MH"
 tooltip:"250W Metal Halide"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3900.0
    		n.intensityType = 0 
    		n.flux = 15500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_250W_MH
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_250W_MH
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_250W_MH
) 
MacroScript Free_400W_MH
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 400W MH"
 tooltip:"400W Metal Halide"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 4000.0
    		n.intensityType = 0 
    		n.flux = 35200.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_400W_MH
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_400W_MH
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_400W_MH
) 
MacroScript Free_1000W_MH
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 1000W MH"
 tooltip:"1000W Metal Halide"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 3500.0
    		n.intensityType = 0 
    		n.flux = 85500.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_1000W_MH
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_1000W_MH
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_1000W_MH
) 
MacroScript Free_100W_HPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 100W HPS"
 tooltip:"100W High Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2000.0
    		n.intensityType = 0 
    		n.flux = 8550.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_100W_HPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_100W_HPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_100W_HPS
) 
MacroScript Free_250W_HPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 250W HPS"
 tooltip:"250W High Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2100.0
    		n.intensityType = 0 
    		n.flux = 27000.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_250W_HPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_250W_HPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_250W_HPS
) 
MacroScript Free_400W_HPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 400W HPS"
 tooltip:"400W High Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2100.0
    		n.intensityType = 0 
    		n.flux = 45000.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_400W_HPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_400W_HPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_400W_HPS
) 
MacroScript Free_1000W_HPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 1000W HPS"
 tooltip:"1000W High Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:High Intensity Discharge
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 2100.0
    		n.intensityType = 0 
    		n.flux = 126000.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_1000W_HPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_1000W_HPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_1000W_HPS
) 
MacroScript Free_18W_LPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 18W LPS"
 tooltip:"18W Low Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:Low-pressure Sodium
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 1800.0
    		n.intensityType = 0 
    		n.flux = 1570.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_18W_LPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_18W_LPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_18W_LPS
) 
MacroScript Free_55W_LPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 55W LPS"
 tooltip:"55W Low Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:Low-pressure Sodium
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 1800.0
    		n.intensityType = 0 
    		n.flux = 6655.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_55W_LPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_55W_LPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_55W_LPS
) 
MacroScript Free_90W_LPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 90W LPS"
 tooltip:"90W Low Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:Low-pressure Sodium
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 1800.0
    		n.intensityType = 0 
    		n.flux = 11095.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_90W_LPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_90W_LPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_90W_LPS
) 
MacroScript Free_135W_LPS
 enabledIn:#("viz", "vizr")
 Category:"Palette Lights"
 internalCategory:"Palette Lights"
 ButtonText:"Free 135W LPS"
 tooltip:"135W Low Pressure Sodium"
 icon:#("PhotometricLights", 3)
 --palettehint:Low-pressure Sodium
(
	fn setprops n =
	( 
		if isKindof n Light do
		(
    		n.distribution = 0.0
			n.useKelvin = on
			n.kelvin = 1800.0
    		n.intensityType = 0 
    		n.flux = 19140.0
    		n.useMultiplier = on
    	)
	)
 	on execute do 
	(
  		local lightHeight = if (heightManager.getCurrentHeightIndex() != 0) do heightManager.getHeight (heightManager.getCurrentHeightIndex())
  		SetCommandPanelTaskMode #create
  		LightCreationTool.isCreatingLight = #Free_135W_LPS
  		LightCreationZHeight Free_Point lightHeight setProps lightName:#Free_135W_LPS
  	)
    on isChecked return LightCreationTool.isCreatingLight == #Free_135W_LPS
) 
