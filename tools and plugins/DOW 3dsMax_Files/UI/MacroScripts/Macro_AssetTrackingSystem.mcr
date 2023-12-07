-- Macro Scripts File
-- Created:  Jan 12 2005
-- Author:   Michael Russo
-- Macro Scripts for Asset Tracking System
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript AssetTrackingSystemShow
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Asset Tracking..."
	ButtonText:"Asset Tracking..." 
(
	On Execute Do     
	(
		Try (
			if ATSOps != undefined do ATSOps.visible = true 
		)
		Catch() 
	)

	on closeDialogs do
	(
		Try (
			if ATSOps != undefined do ATSOps.visible = false 
		)
		Catch() 
	)

	on isChecked Do
	(
		local result = true
		if ATSOps == undefined then
		(
			result = false
		)
		else
		(
			result = ATSOps.visible
		)
		result
	)

)

macroScript AssetTrackingSystemDisabled
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Disable Asset Tracking"
	ButtonText:"Disable Asset Tracking" 
(
	On Execute Do	
	(
		Try( ATSOps.disabled = not ATSOps.disabled )
		Catch() 
	)

	on isChecked return ATSOps.disabled
	on isEnabled return (ATSOps.NumProviders() > 0)
)

macroScript AssetTrackingSystemAutoLogin
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Auto Login"
	ButtonText:"Auto Login" 
(
	On Execute Do	
	(
		Try( ATSOps.autologin = not ATSOps.autologin )
		Catch() 
	)

	on isChecked return ATSOps.autologin
	on isEnabled return (ATSOps.NumProviders() > 0)	
)

macroScript AssetTrackingSystemCheckNetworkPaths
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Check Network Paths"
	ButtonText:"Check Network Paths" 
(
	On Execute Do	
	(
		Try( ATSOps.checkNetworkPaths = not ATSOps.checkNetworkPaths )
		Catch() 
	)

	on isChecked return ATSOps.checkNetworkPaths	
)

macroScript AssetTrackingSystemTreeView
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Tree View"
	ButtonText:"Tree View" 
(
	On Execute Do	
	(
		Try( ATSOps.treeview = not ATSOps.treeview )
		Catch() 
	)

	on isChecked return ATSOps.treeview
)

macroScript AssetTrackingSystemTableView
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Table View"
	ButtonText:"Table View" 
(
	On Execute Do	
	(
		Try( ATSOps.tableview = not ATSOps.tableview )
		Catch() 
	)

	on isChecked return ATSOps.tableview
)

macroScript AssetTrackingSystemDisplayExcluded
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Display Excluded Files"
	ButtonText:"Display Excluded Files" 
(
	On Execute Do	
	(
		Try( ATSOps.DisplayExcluded = not ATSOps.DisplayExcluded )
		Catch() 
	)

	on isChecked return ATSOps.DisplayExcluded
	on isEnabled return (ATSOps.NumProviders() > 0)	
)

macroScript AssetTrackingSystemExcludeOutputFiles
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Exclude Output Files"
	ButtonText:"Exclude Output Files" 
(
	On Execute Do	
	(
		Try( ATSOps.ExcludeOutputFiles = not ATSOps.ExcludeOutputFiles )
		Catch() 
	)

	on isChecked return ATSOps.ExcludeOutputFiles
	on isEnabled return (ATSOps.NumProviders() > 0)	
)

macroScript AssetTrackingSystemRefresh
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Refresh"
	ButtonText:"Refresh" 
(
	On Execute Do	
	(
		Try( ATSOps.Refresh() )
		Catch() 
	)

)

macroScript AssetTrackingSystemLogin
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Log in..."
	ButtonText:"Log in..." 
(
	On Execute Do	
	(
		Try( ATSOps.Login 0 )
		Catch() 
	)
	on isEnabled return ( (not ATSOps.IsInitialized 0) and (not ATSOps.Disabled) and (ATSOps.NumProviders() > 0))
)

macroScript AssetTrackingSystemLogout
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Log out"
	ButtonText:"Log out" 
(
	On Execute Do	
	(
		Try( ATSOps.Logout 0 )
		Catch() 
	)
	on isEnabled return (ATSOps.IsInitialized 0)
)

macroScript AssetTrackingSystemCheckin
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Checkin..."
	ButtonText:"Checkin..." 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			local comment = ""
			ATSOps.Checkin 0 filelist comment
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanCheckin()
)

macroScript AssetTrackingSystemCheckout
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Checkout..."
	ButtonText:"Checkout..." 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			local comment = ""
			ATSOps.Checkout 0 filelist comment
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanCheckout()
)

macroScript AssetTrackingSystemUndoCheckout
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Undo Checkout..."
	ButtonText:"Undo Checkout..." 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			ATSOps.UndoCheckout 0 filelist
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanUndoCheckout()
)

macroScript AssetTrackingSystemAddFile
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Add Files..."
	ButtonText:"Add Files..." 
(
	On Execute Do	
	(
		Try(	
			local filelist = #() 
			local comment = ""
			ATSOps.AddFiles 0 filelist comment
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanAddFiles()
)

macroScript AssetTrackingSystemGetLatest
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Get Latest"
	ButtonText:"Get Latest" 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			ATSOps.GetLatest 0 filelist
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanGetLatest()
)

macroScript AssetTrackingSystemProperties
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Properties..."
	ButtonText:"Properties..." 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			ATSOps.Properties 0 filelist
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanProperties()
)

macroScript AssetTrackingSystemHistory
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"History..."
	ButtonText:"History..." 
(
	On Execute Do	
	(
		Try(
			local filelist = #() 
			ATSOps.ShowHistory 0 filelist
		)
		Catch() 
	)
	
	on isEnabled return ATSOps.CanShowHistory()
)

macroScript AssetTrackingSystemOptions
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Options..."
	ButtonText:"Options..." 
(
	On Execute Do	
	(
		Try( ATSOps.LaunchOptions 0 )
		Catch() 
	)
	
	on isEnabled return (ATSOps.IsInitialized 0)
)

macroScript AssetTrackingSystemLaunchSCC
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Launch Provider..."
	ButtonText:"Launch Provider..." 
(
	On Execute Do	
	(
		Try( ATSOps.LaunchProvider 0 )
		Catch() 
	)
	
	on isEnabled return ((not ATSOps.Disabled) and (ATSOps.NumProviders() > 0))
)

macroScript AssetTrackingSystemWorkingComment
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Working Comment..."
	ButtonText:"Working Comment..." 
(
	On Execute Do	
	(
		Try( ATSOps.ShowWorkingCommentDialog() )
		Catch() 
	)
	
	on isEnabled return ((ATSOps.IsInitialized 0) and (ATSOps.IsProjectOpen 0))
)

macroScript AssetTrackingSystemPromptsDialog
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Prompts Dialog..."
	ButtonText:"Prompts Dialog..." 
(
	On Execute Do	
	(
		Try( ATSOps.ShowPromptsDialog() )
		Catch() 
	)
)

macroScript AssetTrackingSystemDViewImageFile
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"View Image File..."
	ButtonText:"View Image File..." 
(
	On Execute Do	
	(
		myFileList = #()
		iCount = atsops.getSelectedFiles &myFileList
		if iCount > 0 then 
		(
			-- Use resolved file names
			myResolvedFileList = #()
			atsops.getResolvedPaths &myFileList &myResolvedFileList
			if (myResolvedFileList.count > 0) then
			(
				local bm = openBitmap myResolvedFileList[1]
				if (bm != undefined) then
				(
					display bm
				)
			)
		)
	)
	
	on isEnabled Do
	(
		local result = true
		if atsops.numFilesSelected() != 1 then
		(
			result = false
		)
		myFileList = #()
		atsops.getSelectedFiles &myFileList
		if (myFileList.count > 0) then
		(
			local canImportBitmap = maxops.canImportBitmap myFileList[1]
			if (not canImportBitmap) then
			(
				result = false
			)
		)
		result
	)
)

macroScript AssetTrackingSystemCustomDeps
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Custom Dependencies..."
	ButtonText:"Custom Dependencies..." 
(
	On Execute Do	
	(
		Try( 
			ATSCustomDepsOps.LaunchDialog() 
			if ATSOps.visible do ATSOps.Refresh()
		)
		Catch() 
	)
)

macroScript AssetTrackingSystemGetFromProvider
	category:"Asset Tracking System" 
	internalCategory:"Asset Tracking System" 
	tooltip:"Get From Provider..."
	ButtonText:"Get From Provider..." 
(
	On Execute Do	
	(
		Try(
			fl = #() 
			ATSOps.GetFromProvider 0 "All files (*.*)" "*.*" false true true &fl
			)
		Catch() 
	)
	
	on isEnabled return (ATSOps.CanGetFromProvider 0)
)

--***********************************************************************************************
-- BITMAP PROXIES
-- Version:  3ds Max 9
-- Author:   Michaelson Britt
-- Bitmap Proxy action items
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript BitmapProxies_GlobalSettings
	enabledIn:#("max") --rl: 2006.12.20 added product switch
	category:"Asset Tracking System"
	internalCategory:"Asset Tracking System"
	toolTip:"Global Settings..."
	ButtonText:"Global Settings..." 
(
	on execute do (
		local b = bitmapProxyMgr
		if (b!=undefined) do (
			b.ShowConfigDialog()
		)
		if (atsops != undefined) do (
			atsops.refresh()
		)

	)
	on isEnabled do (
		local b = bitmapProxyMgr
		b != undefined
	)
)--end macro

macroScript BitmapProxies_EnableProxySystem
	enabledIn:#("max") --rl: 2006.12.20 added product switch
	category:"Asset Tracking System"
	internalCategory:"Asset Tracking System"
	toolTip:"Enable Proxy System"
	ButtonText:"Enable Proxy System"
(
	on execute do (
		local b = bitmapProxyMgr
		if (b!=undefined) do (
			local enable = b.globalProxyEnable
			b.globalProxyEnable = (not enable)  -- NOTE: proxies refreshed automatically
		)
		if (atsops != undefined) do (
			atsops.refresh()
		)

	)
	on isEnabled do (
		local b = bitmapProxyMgr
		b != undefined
	)
	on isChecked do (
		local b = bitmapProxyMgr
		local result = (b != undefined) and b.globalProxyEnable
		result
	)
)--end macro
