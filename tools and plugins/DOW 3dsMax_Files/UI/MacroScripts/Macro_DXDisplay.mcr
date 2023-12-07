/*

	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


*/


macroScript DXEffectToggleDisplay 
enabledIn:#("max") --pfb: 2003.12.11 added product switch
            category:"Views" 
            internalCategory:"DXDisplayManager" 
            ButtonText:"DX Effect Toggle Display"
            tooltip:"DX Effect Toggle Display" 

(
     on execute do globalDxDisplayManager.ForceSoftware = not globalDxDisplayManager.ForceSoftware -- action to execute - toggle the setting
     on isEnabled return true -- greyed out if false
     on isChecked return globalDxDisplayManager.ForceSoftware -- checked if true
     on isVisible return globalDxDisplayManager.isDxActive() -- visible if true
)


macroScript DXEffectToggleDisplaySelected 
enabledIn:#("max") --pfb: 2003.12.11 added product switch
            category:"Views" 
            internalCategory:"DXDisplayManager" 
            ButtonText:"DX Effect Toggle Display Selected"
            tooltip:"DX Effect Toggle Display Selected" 


(
     on execute do globalDxDisplayManager.ForceSelected = not globalDxDisplayManager.ForceSelected -- action to execute - toggle the setting
     on isEnabled return globalDxDisplayManager.ForceSoftware -- greyed out if false
     on isChecked return globalDxDisplayManager.ForceSelected -- checked if true
     on isVisible return globalDxDisplayManager.isDxActive() -- visible if true
)