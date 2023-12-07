Dawn of War Texture Tool v1.9
=============================

Welcome to the Dawn of War Texture Tool. This small application is designed to allow you to extract and compile all of the textures for Dawn of War and its expansion packs. This includes WTP files, RSH files and RTX files.

For those who haven't used Beroc's WTP Tool, this application is a fully featured texture compiler and extractor. It can handle textures of any size and can also handle badges and banners (or both on a single texture, if you so wish)

For those who have previously used Beroc's WTP Tool, the Texture Tool improves upon the WTP handling by correctly compiling and extracting banners and non-square textures (such as the Space Marine Scouts). It also extracts RSH files and RTX files and compiles RTX files, which Beroc's tool didn't allow for. This latest version now also compiles composite TGA images, converts DDS files to TGA files and converts TGAs to DDSs files (although this is not quite as smooth as Adobe Photoshop's implementation).

The latest version of the Texture Tool can always be found at http://skins.hiveworldterra.co.uk/Downloads/detail_DawnOfWarTextureTool.html, or http://skins.hiveworldterra.co.uk/TextureTool/ (which redirects to the previous URL)


Requirements
------------

This application requires an implementation of the .Net Framework. The Texture Tool was build for Microsoft's .Net Framework v1.1 (http://msdn.microsoft.com/netframework/downloads/framework1_1/). It may also be compatible with the .Net Framework 2.0, but this has not yet been tested.

The Texture Tool has been successfully tested with the cross-platform, open source Mono implementation of the .Net Framework (http://mono-project.com). The Texture Tool is known to work with Mono v1.1.13 on Fedora Core 5 and v1.2.3.1 on Fedora Core 6, but the default version for FC6 (v1.1.17) failed tests due to exceptions within the Mono framework.


Installation
------------

1) Extract the Zip file to a location you want (the Dawn of War folder is recommended)
2) Run the EXE.


Using the Texture Tool
----------------------

Once the program is running, click one of the buttons.

"Make WTP" takes a collection of TGA files and creates a WTP file from them.

"Extract WTP" takes a WTP file and extracts its teamcolourable layers as TGA files.

"Makes RSH" and "Make RTX" take a collection of DDS files and convert them into an RSH or RTX of the same name. Selecting a single DDS when using "Make RSH" will allow you to add additional texture maps. More details can be found later in the readme.

"Extract RSH" and "Extract RTX" take a collection of RSH or RTX files and extracts the DDS image for editing.

"Compile TGA" takes a single WTP file and your current team colour settings and compiles a single TGA that shows the image in a fully teamcoloured format.

"DDS->TGA" takes a collection of DDS files (DXT1, DXT3 or DXT5) and converts them into 32-bit TGA files. Additionally, it automatically flips the image, so your TGA file won't appear upside down as DDS files do in Photoshop.

"TGA->DDS" is not yet perfected to match the Adobe Photoshop generated DDS files, but is operational. It takes a collection of TGA files and converts them in to DDS files (DXT1, DXT3 or DXT5). MipMaps (smaller versions of the image) are also created, but these are currently blocky compared to other DDS conversion tools.

"Enable/Disable Teamcolouring" takes a collection of RSH files and alters the paths within them so that they do not load the matching WTP files (forcing the game to use the RSH file). If it is run again on a file then it will undo the change and make the RSH load the WTP file. NOTE: if an RSH file does not have a matching WTP file then this function _will not_ enable team colouring on the texture. To do this you need to create a new WTP.

All buttons allow you to select multiple files to compile or extract at once. To select multiple files, hold down the CTRL button while selecting files. Note: You only need to select one TGA to compile a WTP, not all TGAs. The other TGAs will be read in automatically.


File Formats
------------

The following is a brief description of the file formats supported:

* WTP - control team colouring. Contain a collection of TGA files for the different colourable layers.

* RSH - the fall back texture. Also used in the Dawn of War Campaign or when no specific RTX is specified for a campaign army. Contains a DirectX texture known as a DDS file (generally DXT1 with 1-bit Alpha)

* RTX - the coloured texture in Multiplayer games when team colouring is turned off for a slot. Also used in the Winter Assault campaign. Contains a DirectX texture known as a DDS file (generally DXT1 with 1-bit Alpha)

DDS files require a special plugin to edit them. Please see nVidia's page for downloads (http://developer.nvidia.com/object/nv_texture_tools.html) if you wish to edit the DDS directly. Note, though, that DDS files use lossy compression, and so multiple changes and saves can degrade the image quality.


As noted ealier, RSH files can now contain mutliple channel maps. The additional maps can only be included when the RSH files are compiled individually. Whenever a single DDS is selected for "Make RSH" a prompt is given asking whether extra maps are required. The majority of units will not need additional maps, however some special units may benefit from additional maps.

The simplest map is Self-Illumination. This map can be used to stop an area of a texture being tinted the same colour as the coloured light that is on the model. This can be seen on the Chaos Lord, where he has a red glow around his head, but his head is not tinted red.

Reflection and Specularity must be used together, and provide a reflection effect like that seen on the Monolith in Winter Assault. The Reflection image provides the shape and brightness of the reflection, while the Specularity map controls where the reflection is visible. Reflection maps are usually smaller than the main map, while Specularity maps are the same size as the main map.

The only known-but-not-functioning map is Opacity. Various tests and log reading have shown that Opacity exists, but haven't yet been able to provide working results. Functionality will be included as soon as someone produces a file with a working Opacity channel, or as soon as Relic release information on the channel.


FAQ
---

Why do I get a message like "ERROR: Data in layer collection must be the same size: 262144 bytes" when compiling a TGA?

  This means that all of the colour layers of the WTP must be the same size. Earlier versions of the Texture Tool read in all of the TGA image for the layer, including some additional data that Adobe Photoshop seems to add on the end. This additional data isn't needed and shouldn't be read in. To fix the problem, extract and recompile the WTP file then try again.
  
Why do I keep getting a message saying that the Texture Tool has skipped a layer?

  As of v1.8 the Texture Tool has had a degree of intelligence regarding the information in team colouring layers (Primary, Secondary, Trim, etc). If a file does not include any pixel with more than 2% brightness then it is treated as a pure black image that would have no affect on the texture other than to increase its size, and so is ignored. This additional feature should reduce the bloat in textures when people remove areas from a layer but do not delete the layer.
  
What does "Compile TGA" do?

  As with Beroc's WTP Tool, it creates a single TGA image coloured with appropriate team colouring. You can select the team colouring, badge and banner through the Options window.
  
What use is a 'compiled TGA'?

  There are two uses. The first is to check what a texture will look like without going into the game. The second, and perhaps more useful, is to create a teamcoloured TGA that can be converted to a DDS file and then compiled into an RTX or RSH file. This allows you to change the colour schemes in the single player campaigns, or when team colouring is disabled.
  
Why do the badges and banners not load when importing some .teamcolour files?

  The Texture Tool doesn't currently have the ability to read badges and banners out of SGA Archives. This means that any team colours using default badges and banners from the game will not display the badge or banner. The work-around is to extract the badge and banner and select them manually.
  
How do I change the badge or banner?

  Just click on the badge or banner image in the options then select the badge or banner image.
  
Why does the Texture Tool keep resetting the starting paths for selecting textures/images?

  The Texture Tool will remember the last path that you looked at and load that, but comes with a default path for texture, teamcolour and badge/banner selection. If you close down the application, the default paths will revert to their original values. To stop it doing this, go to "Edit" > "Options" and click the "Save Preferences" button.
  
Why does the Texture Tool recognise the path and let me save it but then not load badges correctly?

  The most likely answer is that you'd tripped over an oddity (or bug) in Microsoft's .Net framework. Before letting you save, the Texture Tool checks that a "badges" and "banners" folder exists in the specified directory. The Texture Tool also automatically appends a trailing slash at the end of paths if you didn't include one. The oddity comes when checking whether paths exist - Microsoft ignore any trailing spaces in directory names when checking whether folders exist. If the same isn't applied elsewhere then strange behaviour may occur!
  
Why are one or more of the paths in my Options window red?

  The Texture Tool checks that paths exist when you specify them in the Options window and won't let you save or OK them when they don't. To make it more obvious where the problem is (especially if you have added/removed the folder and not updated the path) then the text is shown in red. The Dawn of War path has an additional check to make sure that it contains a "badges" and "banners" folder and will also show up red if they do not exist.
  
Can I get the Texture Tool to remember teamcolour settings?

  Yes. As with the paths, once you have the settings correct for your defaults, just click the "Save Preferences" button in the Options dialog and the current settings will be remembered the next time you open the Texture Tool.
  
Why does the Texture Tool keep reverting to 'Basic' mode?

  As with the paths and team colour settings, you need to save any 'preference' changes that you make for them to apply after you've closed the application. If you compile lots of TGAs and want to keep the option available, select "Advanced" and then click "Save Preferences" in the "Edit" > "Options" dialog box.
  
Do I want to add additional maps to my RSH file?

  On the whole, no. Additional maps add additional processing, which will slow down low-end rigs. The Specularity/Reflection should be used especially sparingly.
  
So what is Self-Illumination?

  If a model has a coloured light added to it, all textures will be tinted by that coloured light. If you add a self illumination map then certain areas of the model will not be affected by the main colour of illumination.
  
So what is Specularity and what is Reflection?

  The Reflection map is an image used to generate the reflection pattern. At the time of writing, Texturers have only just found out how to do this, and so experimentation with the best images is still underway. The Specularity map then determines which areas will shine and how strongly the reflection map will be seen. The idea is similar to the WTP's team colouring layers whire the whiter the area of the image, the more the colour (or in this case reflection) is seen.
  
Can I add just Specularity or just Reflection?

  In theory, you probably can, but in practice there's no useful purpose! Specularity and reflection are a paired group of maps, and the game needs both to show the reflection effect.

Why would I need to disable teamcolours in an RSH? Why not just make a WTP with no colour layers?

  Although it's possible to 'disable teamcolours' by making a non-colourable WTP, altering the RSH is far more efficient. Firstly, it's only a single click and doesn't require the creation of a new TGA file as the base of the WTP. Secondly, it saves on the textures loaded (as the game will look for the non-existant WTP texture, not find it and not load a WTP for the RSH). Thirdly, it reduces file/download sizes, as RSH files are normally around 100-200KB while WTPs are at least 1.25MB.
 
Troubleshooting
---------------

Known errors:
  "The application failed to initialize properly (0xc0000135). Click OK to termintate the application" - This error only occurs if you do not have the .Net Framework (v1.1) installed on your computer. Please go to http://msdn.microsoft.com/netframework/downloads/framework1_1/ for instructions on how to download and install the framework.
  
  "ERROR: Data in layer collection must be the same size: 262144 bytes" - See the FAQ.

If you have any problems, please email me at webmaster@ibboard.co.uk with as much information as you can about the error and what you were doing, and I will look into it.

Please note that you need the .Net framework to run this application.  Later builds may be created that include the required framework code within the build, but until a free version is developed, that would cost several thousand pounds.


Distribution
------------

Feel free to use this application for working on your Dawn of War textures.

Don't redistribute this application in any way - either in part or in whole (including re-use of the DLL files) - without prior written permission from IBBoard. An unanswered email stating you will take no response as an approval _is not_ permission to re-use part or all of this application. Only IBBoard, Hive World Terra (www.hiveworldterra.co.uk) and Skins@HWT (skins.hiveworldterra.co.uk) have the right to host and give permission for re-use of the application. The author retains the right to add other sites to the list of allowed hosts, and any new 'official' hosts will be listed on Skins@HWT.

If you feel that the tool is good enough, please feel free to link to the download page (not directly to the download) and email me about your link.


History
-------

Version 1.9:	Included support for creating and extracting RSH/RTX with DXT3 textures after Jaylo101 found Soulstorm textures that couldn't be extracted
		Replaced OpenIL port with Squish for better quality DDS compression and better mipmaps

Version 1.8.1:	Fixed error that caused the WTP compilation to take the selected file as the base file instead of checking the file name end and trimming recognised values (e.g. _primary, _secondary etc) as it used to

Version 1.8:	Added extra intelligence to WTP compilation. Blank layers are now no-longer compiled in to the WTP, reducing file sizes by 0.25MB per layer. This could always have been done manually by deleting layers before compiling the texture when they weren't needed, but not all users do this, which leads to some bloated files.
				Made the Preferences record when it has been modified so that the "Save Preferences" button can now more accurately show whether some changed preferences have not been saved (previous versions had a disabled button if the Mode was changed from the Edit menu)

Version 1.7.5:	Fixed a bug that caused an "index out of bounds exception" when the _default.tga image contained a non-zero length image ID. All other images were previously unaffected.
				Changed some references to "\" in file paths to be the actual directory character for the operating system. This should improve Linux/Mac OS X compatibility (Texture Tool already successfully runs under Mono 1.13 on FC5 and 1.2.3.1 on FC6, but not 1.17 on FC6)
				Made "Save Preferences" button disable itself when clicked.
				
Version 1.7.4:	Fixed a bug that stopped RTX files from being compiled
				Added a work-around for the skull_probe.rsh file so that it can be extracted (some non-image data does not match what is expected)

Version 1.7.3:	Fixed multi-select compiling of WTPs

Version 1.7.2:	Fixed "Index out of bounds" exception that occured when no badge/banner was selected and a TGA was compiled from at WTP
				Improved handling of error when extracting/compiling RTX files that do not contain an equivalent to _default_# in their name
				Added support for 24-bit (RGB without alpha) TGA badge and banners, since DoW now supports them and some people use them

Version 1.7.1:	Fixed TGA files so that they display correctly in The GIMP (and better follow the file format standard) rather than just duplicating Adobe Photoshop output
				Fixed the Teamcolour Options so that the Save button becomes enabled when changing individual colours as well as when importing .teamcolour files

Version 1.7:	Fixed DDS->TGA conversion on non-square textures.
				Altered some error messages to be more descriptive
				Added "error details" window that shows message and stack trace when errors occur - useful for future debugging
				Added more indication as to what was stopping the Options window being okayed

Version 1.6:	Fixed errors recognising recompiled files when the file contained less data (normally "ERROR: Chunk was not of type FOLD or DATA")
				Fixed creation of RSH files without additional channels (which were not being saved)
				Fixed "Enable/Disable Teamcolouring" on RSH files with multiple images (e.g. RSH files with Specularity/Self-Illumination)
				Changed Badge and Banner layer saving so that it saves as _Badge and _Banner instead of _badge and _banner (for consistancy)
				Re-worked Options dialog to be more complete
				Re-worked file paths so the app can theoretically run in Linux under Mono (although the Mono FileDialog is currently broken)
				Re-centralised some code for easier maintenance
				Changed window icon to match application icon

Version 1.5.1:	Fixed errors with badges and banners that always stuck them in the bottom-left corner

Version 1.5r2:	Fixed error that always occured when compiling TGAs from WTPs.

Version 1.5: 	Improved DDS creation
				Added "Enable/Disable Teamcolouring"
				Moved over to a new back-end that better parses Relic's Chunky Files (as used by the IChunky Viewer tool)
		
Version 1.4r3:	Fixed a bug that was created in release 2 that stopped TGAs being compiled from WTPs, amongst other things.

Version 1.4r2:	Fixed a bug that caused an unhandled exception when opening the Options window for the first time, or when no badge/banner was selected

Version 1.4:	Added ability to include Self-Illumination and Reflection/Specularity maps
				Added ability to select a badge from anywhere, rather than just specified Dawn of War badge/banner folder
				Added full DDS->TGA conversion
				Added partial TGA->DDS conversion
				Added confirmation when overwriting files (with "Yes/No to all" options)
				Fixed a bug with RSH extraction when the RSH had self illumination or reflection/specularity maps

Version 1.3.1:	Fixed a bug with RSH and RTX compilation that caused them not to be recognised by the game engine.

Version 1.3:	Added TGA compilation
				Added team colour, badge and banner selection
				Added teamcolour importing
				Added preferences for default directory locations
				Fixed a bug with the handling of some DDS files extracted from RSH files (particularly the Valkyrie, which was a DXT5 format instead of a DXT1 like all of the others)
		
Version 1.2:	Added RSH compilation and extraction
				Added RTX compilation and extraction

Version 1.1: 	Added the ability to extract or compile multiple WTPs at once.
				Fixed a bug with the game engine not recognising recompiled Scout textures.

Version 1.0: 	The initial build, lets you compile and extract any and all WTP files


Credits
-------

Thanks to Mel Danes and Compiler for prompting my investigation in to the additional maps in the RSH file, for helping me test the new features, and for giving me support while I continued the work. Thanks also to Mel Danes for the preliminary RSH tutorial that he produced and sent to me. Hopefully it will be available in a completed format at some point.

Thanks to Alex Stewart for making the UEdTexKit (http://www.foogod.com/UEdTexKit/) available for download with public domain source of the DDS->TGA conversion.

Thanks to everyone who has worked on the OpenIL (http://openil.sourceforge.net/) project, a C# port which is used for generating mipmaps in DDS files.

Thanks to Simon Brown and Ignacio Castaño for their work on LibSquish (http://code.google.com/p/libsquish/), which is used for TGA -> DDS conversion.

Thanks to everyone who has used the tool and found bugs. It's never the best thing to hear that you've released a buggy tool, but at least people want to use the tool enough to mention the bugs.


Licenses
--------

The IBBoard, IBBoard.Graphics and IBBoard.Graphics.OpenILPort libraries are released under the LGPLv3. Source code is available on svn://svn.ibboard.co.uk/ibboard.

squishinterface_x86 and squishinterface_x64 are released under the MIT license by Simon Brown.

ICSharpCode.SharpZipLib is released under a modified GPL license (http://www.icsharpcode.net/OpenSource/SharpZipLib/).


The Future
----------

Possible ideas for later builds of this app include:
	Making TGA->DDS conversion closer to that made by Adobe Photoshop
	Determine how to correctly include Opacity maps (I know they're in there, there just aren't any 'official' examples yet)
	Allow compilation of RSH and RTX using DXT3 images (Again, requires 'official' example texture)
	Improve efficiency of extraction/compilation (if needed)
	
Any other ideas would be greatly appreciated.


Enjoy!

IBBoard
webmaster@ibboard.co.uk
www.hiveworldterra.co.uk and skins.hiveworldterra.co.uk


*****************
Legal/Disclaimer:
*****************

The following legal disclaimers are included for completeness:


This application is provided 'as is' without warranty of any kind, either express or implied, including, but not limited to, the implied warranties of fitness for a purpose, or the warranty of non-infringement. Without limiting the foregoing, IBBoard makes no warranty that:

   1. the software will meet your requirements
   2. the software will be uninterrupted, timely, secure or error-free
   3. the results that may be obtained from the use of the software will be effective, accurate or reliable
   4. the quality of the software will meet your expectations
   5. any errors in the software will be corrected.

This application and its documentation:

   1. could include technical or other mistakes, inaccuracies or typographical errors. IBBoard may make changes to the software or documentation made available on the Skins@HWT web site.
   2. may be out of date, and IBBoard makes no commitment to update such materials.

IBBoard assumes no responsibility for errors or ommissions in the software or documentation available from Skins@HWT.

In no event shall IBBoard be liable to you or any third parties for any special, punitive, incidental, indirect or consequential damages of any kind, or any damages whatsoever, including, without limitation, those resulting from loss of use, data or profits, whether or not the BGS has been advised of the possibility of such damages, and on any theory of liability, arising out of or in connection with the use of this software.

The use of the software downloaded through Skins@HWT is done at your own discretion and risk and with agreement that you will be solely responsible for any damage to your computer system or loss of data that results from such activities. No advice or information, whether oral or written, obtained by you from IBBoard or Skins@HWT shall create any warranty for the software.



All logos and trademarks in this site are property of their respective owner. All textures are modified version of original textures create by Relic Entertainment, under license to Games Workshop Ltd. They are completely unofficial modifications, and in no way endorsed by Games Workshop, THQ, Relic or any other officially associated group.

Warhammer 40K: Dawn of War logos and information Copyright © 2004

Relic Entertainment, Inc.
400-948 Homer Street Vancouver, BC, Canada V6B 2W7

and

THQ Incorporated
27001 Agoura Road, Suite 325
Calabasas Hills, CA 91301

All rights reserved. Names, trademarks, and copyrights are the property of the originating companies.

Adeptus Astartes, Blood Angels, Bloodquest, Cadian, Catachan, the Chaos devices, Cityfight, the Chaos logo, Citadel, Citadel Device, Codex, Daemonhunters, Dark Angels, Dark Eldar, 'Eavy Metal, Eldar, Eldar symbol devices, Eye of Terror, Fire Warrior, Forge World, Games Workshop, Games Workshop logo, Genestealer, Golden Demon, Gorkamorka, Great Unclean One, Inquisitor, the Inquisitor logo, the Inquisitor device, Inquisitor:Conspiracies, Keeper of Secrets, Khorne, Kroot, Lord of Change, Necron, Nurgle, Ork, Ork skull devices, Sisters of Battle, Slaanesh, Space Hulk, Space Marine, Space Marine chapters, Space Marine chapter logos, Tau, the Tau caste designations, Tyranid, Tyrannid, Tzeentch, Ultramarines, Warhammer, Warhammer 40k Device, White Dwarf, the White Dwarf logo, and all associated marks, names, races, race insignia, characters, vehicles, locations, units, illustrations and images from the Warhammer 40,000 universe are either ©, TM and/or © Copyright Games Workshop Ltd 2000-2004, variably registered in the UK and other countries around the world.

Used without permission. No challenge to their status intended. All Rights Reserved to their respective owners.