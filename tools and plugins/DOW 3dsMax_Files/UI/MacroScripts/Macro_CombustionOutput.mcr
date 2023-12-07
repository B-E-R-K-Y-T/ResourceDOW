/*

Combustion Output MacroScript File
Created:		Sept 6 2000
Author:		Fred Moreau

Revision History:
	Yann Bertaud
		changed the method for which the render element filename was retrieved. Using the new GetRenderElementFilename method. 
		re.bitmap.filename was replaced by refilename which is defined by eman.GetRenderElementfilename (e)
		
	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
	

*/

Macroscript CombustionOutput 
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
category:"File" 
internalCategory:"File"
ButtonText:"RenderElements to combustion(tm)"
tooltip:"RenderElements to combustion(tm)"
icon:#("CWS_Output",2)
silentErrors:true
(
	SetSilentMode true											-- Set Silent Mode for BitMap Loading
	eman = maxOps.GetCurRenderElementMgr()						-- Get Current Render Elements Manager
	if (eman.NumRenderElements()) > 0 and (eman.GetElementsActive()) == true and eman.GetCombustionOutputPath() != "" then
	(
		try
		(
			re_array = #()										-- Init the RenderElements Array
			for e = 0 to (eman.NumRenderElements() - 1) do		-- For all RenderElements in REManager
			(
				re = eman.GetRenderElement e					-- Get the Element
				refilename = eman.GetRenderElementfilename (e)	-- added for 3ds max 5, use new GetRenderElementFilename method to get render element filename.
				try (re.enabled ; OkToGo = True) catch (OkToGo = False) -- Is Element Plug-In Missing
				if OkToGo then							-- If Element is not Standin
				(
					if re.enabled == true and refilename != undefined then	-- If Element Enabled
					(
						if not IsCwsImgType refilename then	-- Check combustion ImageType Compliance
						(
							Print "Ok"
							cwsMessage = "Warning! Image type NOT supported in combustion(tm)!\n" +
							(re.elementName + " Element is outputting to " + (getfilenameType refilename) + " files")
							cwsWarn cwsMessage
						)
						else
						(
							if ((KindOfRenderElement re) == #Diffuse or (KindOfRenderElement re) == #Shadow or (KindOfRenderElement re) == #Atmosphere) and (findItem #(".tga", ".tif", ".rla", ".rpf", ".png") (getfilenameType refilename) == 0) then
							(
								cwsMessage = "Warning! Element requires Alpha\n" +
								re.elementName + " Element is outputting to " + (getfilenameType refilename) + " files\n" +
								"It is recommended that you output Diffuse, Shadows and Atmosphere Elements to RGBA files, such as Targa, Tiff, Rla, Rpf or Png"
								cwsWarn cwsMessage
							)
							cwselement = relement name:re.elementName kind:(KindOfRenderElement re) file:refilename transferMode:1 Visibility:Off
							append re_array cwselement				-- Add RenderElement to the Process List
						)
					)-- end If Enabled
					else
					(
						cwsMessage = "Warning! " + re.elementName + " Element has no Bitmap, or is disabled !"
						cwsWarn cwsMessage
					)
				)-- end If not Standin
				else
				(
					cwsMessage = "Warning! Element is using Missing Dll"
					cwsWarn cwsMessage
				)
			)-- end for loop
			if re_array.count != 0 then
			(
				RElements2cws re_array (eman.GetCombustionOutputPath())
				print "Render Elements have been output to combustion(tm) successfully."
			)-- end if
			Else
			(
				cwsMessage = "No Render Elements to output"
				cwsWarn cwsMessage
			)
		)-- end try
		catch
		(
			try (close (eman.GetCombustionOutputPath())) catch()
			cwsMessage = "Errors occurred when outputting to combustion(tm) file!"
			cwsWarn cwsMessage
		)-- end catch
	)
	else
	(
			cwsMessage = "Warning! combustion(tm) workspace file Not Set!\n" +
"Or No Render Elements to output"
			cwsWarn cwsMessage
	)
	SetSilentMode false -- Reset Silent Mode Off for BitMap Loading
)