/*
Macro_Script File
Author:  pfbreton; inspired from a script from Borislav Petrov, 1999

Versions: Autodesk VIZ 4, 3ds MAX 5, 3ds MAX 6, Viz Render.

Description:

	This Macro prompt for a short text note and	grabs the active viewport. 
	It pops the resulting image in a vfb.
	
	The motivation behind this idea is to let users creating quick snapshots of their design without
	having to use Print Screen.
	
	The notes option is useful for adding short text descriptions on the image as an overlay.
	
Revision History:

	6 July 2004, Pierre-Felix Breton,
		disabled when non standard vports are active

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products
		fixed a bug where the text is slightly misaligned from its frame


	24 Mai 2003, Pierre-Felix Breton
		Added to 3dsMAX 6 build

	January 7th 2003, Pierre-Felix Breton
		force complete redraw do workaround the display bug preventing the label from being displayed
		in some situations
            

	Dec 24 2002,Pierre-Felix Breton
		added "..." after the macro/menu labels names		

	Nov 5th 2002 - initial impleentation
	
	Localization Notes:
		This script is written in a way that it is easily localizable.

*/

macroscript ViewportGrab
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
category:"Tools" 
internalCategory:"Tools"
buttontext:"Grab Viewport..."
Tooltip:"Grab Viewport..."

(--macro begin

--------------------------------------------------------------------
--Macro Variables 
--------------------------------------------------------------------
local previousUpdateRectangle -- variable used to cache the previous rectangle that was drawn

--------------------------------------------------------------------
--Macro Functions
--------------------------------------------------------------------
/*
	This finction receives a string and draw a
	the text in rectangle filled with a flat color in the lower right corner of the active viewport
	
	There are checks with the lenght of the string to see if it fits in the viewport.
	
	Return true if succeeded, false if failed.
*/
function drawNotesOnViewport strNotes = 
(	

	/* pfb January 7th: commented the interactive preview due to display bugs
	if previousUpdateRectangle != undefined do
	(
		gw.clearscreen previousUpdateRectangle useBkG:true
		gw.updateScreen()
	)
	*/
	local result = false
	
	if strNotes != "" do
	(
		--temp strings
		local strText = strNotes 
		
		--layout variables
		local labelPos = [0,0,0]
		local textPos
		local textExtents --the size of the textstring in pixels
		local updateRec
		local intMargins = 5 -- this is to offset the coordinates of the elements to maintain margins around the text
		local intVportSize -- the size of the active viewport 
		local i --counter used in some loops below
		
		--polygons and drawn entities variables
		local arPt3PolygonCoords = #()
		local clrLabelColor = (colorman.getcolor #tooltiptext as color)* 255 --color 0 0 0
		local clrLabelBgColor = (colorman.getcolor #tooltipbackground as color) * 255 --color 200 200 200

		--get the width and height of the text since the layout is based on this.
		textExtents = gw.getTextExtent strText
	
		--calculates the current Viewport size and defines the location of the label to display
		--label should display in the lower right corner of the viewport
		intVportSize = [gw.GetWinSizeX(), gw.GetWinSizeY()]
		labelPos = [(intVportSize.x - textExtents.x - intMargins - 10),(intVportSize.y - textExtents.y - intMargins - 5),0]
	
		--calculates the rectangle containing the text
		--this rectangle is used to invalidate the required viewport area
		--calculates the invalidation rectangle and text position
		
		updateRect = box2 labelPos.x labelPos.y (textExtents.x + 2* intMargins) (textExtents.y + intMargins)
		textPos = [(labelPos.x + intMargins - 1),(labelPos.y + textExtents.y + 4),0]
			
		-- do the job only if the viewport is wide enough to accept the text.	
		if ((intVportSize.x - 10) > (updateRect.w)) then
		(
				--calculates the vertex position used to draw the polylines and poygons around the text
				arPt3PolygonCoords = #([updateRect.left,updateRect.top,0], [updateRect.left,(updateRect.bottom - 1),0],[(updateRect.right - 1),(updateRect.bottom - 1),0], [(updateRect.right - 1),updateRect.top,0])
					
			    --draw text inside an outlined rectangle
				/* 
				
				--this code only works in SZB.  Nothing handles this in OGL or D3D.
				-- According to Norbert Jeske, the only way would be to use gw.TriStrip (not gw.wTriStrip or gw.hTriStrip), which does not exists in MAX at the moment I wrote these lines.
				
				gw.setcolor #fill clrLabelBgColor 
				
				gw.wPolygon #(arPt3PolygonCoords[1], arPt3PolygonCoords[2], arPt3PolygonCoords[3]) \
								#(clrLabelBgColor,clrLabelBgColor,clrLabelBgColor) \
								#([1.0,.5,0],[.5,.5,0], [0,0,.5])
								
				gw.wPolygon #(arPt3PolygonCoords[3], arPt3PolygonCoords[1], arPt3PolygonCoords[4]) \
								#(clrLabelBgColor,clrLabelBgColor,clrLabelBgColor) \
								#([1.0,.5,0],[.5,.5,0], [0,0,.5])					
								
				*/
				
				--hack the filled rectangle by painting many polylines to workaround the lack of support for polygons (see above)
				gw.setcolor #line clrLabelBgColor 
		
				--loop as many time as required to create one horizontal line per pixel to fill
				--the background of the text with a solid white color
		
				--loop through it and fill the rectangle with horizontal lines
				for i = 1 to (updateRect.h - 2) do
				(
					local start, end
					start = [arPt3PolygonCoords[1].x, (arPt3PolygonCoords[1].y + i),0]
					end = [arPt3PolygonCoords[4].x, (arPt3PolygonCoords[4].y + i),0]
					gw.wPolyline #(start,end) false
				)
				
				
				--draw a border around the text
				gw.setcolor #line clrLabelColor
				gw.wPolyline arPt3PolygonCoords true
				
				--draw text
				gw.wtext textPos strText color:(clrLabelColor)
				
				--update the screen
				gw.enlargeUpdateRect updateRect
				--gw.enlargeUpdateRect #whole --updateRect
			
				gw.updateScreen() 
				
				previousUpdateRectangle  = updateRect		
				result = true -- the text is drawn and the function can bail out
				
		) -- end if viewport wide enough	then
		else 
		(
			result = false --the text is NOT drawn because the string is larger than the viewport and the function bail out by returning false
		)
	)--end if strNotes != ""
		
	result -- the string was empty and the function can bail out by returning false
) -- end function function drawNotesOnViewport strNotes 


--------------------------------------------------------------------
--Rollouts
--------------------------------------------------------------------
rollout rltAddNotes "Grab Active Viewport" width:300 height:80
	(
	
		fn grabIt =
		(
				local bmpGrab 
				bmpGrab = gw.getViewportDib() --get the viewport bitmap into variable 
				
				display bmpGrab --display the bitmap in a VFB 

				-- flushes Ram usage from the created bitmaps
				bmpGrab = undefined
				freescenebitmaps()
				destroydialog rltAddNotes
		)

		label lblInstructions "Add a label if desired before grabbing the image." pos:[10,10]
		edittext edtxtLine text:"" pos:[5,27] width:250
	
		button btnGrab "Grab" pos:[120,50] width:65
		button btnCancel "Cancel" pos:[190,50] width:65


		/* pfb January 7th: commented the interactive preview due to display bugs

		on edtxtLine changed text do
		(
			drawNotesOnViewport text 	
		)
		
		
		on edtxtLine entered text do
		(
			drawNotesOnViewport text	
		)
		*/
	
		on btnGrab pressed do
			(
				if edtxtLine.text != "" do
				(
					forcecompleteredraw dodisabled:true --pfb January 7th: to get it working, a full redraw has to be done
					drawNotesOnViewport edtxtLine.text
				)
				grabIt()		
			)--end btnAddNoteOk pressed

		On btnCancel pressed do destroydialog rltAddNotes
		on edtxtLine entered arg do
		(
				if edtxtLine.text != "" do
				(
					forcecompleteredraw dodisabled:true --pfb January 7th: to get it working, a full redraw has to be done
					drawNotesOnViewport edtxtLine.text
				)
				grabIt()
		)

		on rltAddNotes open do setfocus edtxtLine 
		
	)--end rollout

--------------------------------------------------------------------
--Macro Events 
--------------------------------------------------------------------
	on isEnabled do
	(
		--filters out the non standard vport types
		local vporttype = viewport.gettype()
		case vporttype  of
					(
						undefined:false --extended viewports or active shade returns false
						#view_track:false	--trackviews returns false																	
						default:true --any other standard viewport returns true
					)--end case
	)--end on isEnabled
	
	on execute do
	(
		CreateDialog  rltAddNotes width:265 height:80
	)--end on execute
		
)--end ViewportGrab Macroscript