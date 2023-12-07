--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- RTX Tool
-- by Brother Santos
--
-- 0.1 First Release
--
-- - Conversion from RSH to RTX file format
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

include "RelicChunkLib.ms"																	-- Include RelicChunkLib
clearListener()																				-- Clear Listener Window

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDTXTR > - Chunk Handler - Internal Texture
--------------------------------------------------------------------------------------------

function ConvertRSH rshfilename =
(
rtxfilename = (getFilenamePath rshfilename) + (getFilenameFile (filenameFromPath rshfilename)) + ".rtx"

rshfile = fopen rshfilename "rbS"
rtxfile = fopen rtxfilename "wbS"

if rshfile != undefined then
(
if rtxfile != undefined then
(
for i=1 to 24 do WriteByte rtxfile (ReadByte rshfile)
current_chunk = ReadChunkHeader rshfile
current_chunk = ReadChunkHeader rshfile
CopyChunk rshfile rtxfile current_chunk

fclose rtxfile
fclose rshfile
deleteFile rshfilename
)
else messagebox "Can't create RTX file!"	
)
else messagebox "Can't open RSH file!"	
return true
) 

--------------------------------------------------------------------------------------------
--------------------------------------[ BEGIN SCRIPT ]--------------------------------------
--------------------------------------------------------------------------------------------

utility RTXTool "RTX Tool"
(
-------------------
---[ VARIABLES ]---
-------------------

struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
local current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""			-- Currently Processed Chunk

-------------
---[ GUI ]---
-------------

button button_fileconvert "File Convert" width:120											-- Create [File Convert] Button
button button_dirconvert "Dir Convert" width:120											-- Create [Dir Convert] Button

----------------
---[ EVENTS ]---
----------------
----------------------------------------------------
---< EVENT >--- Button Pressed - [ File Convert ]
----------------------------------------------------

on button_fileconvert pressed do															
(
rshfilename = getOpenFileName caption:"Select a RSH file to convert..." types:"RSH (*.rsh)|*.rsh"
if rshfilename != undefined then if (ConvertRSH rshfilename) then messagebox "File was successfully converted!"
)
----------------------------------------------------
---< EVENT >--- Button Pressed - [ Dir Convert ]
----------------------------------------------------

on button_dirconvert pressed do	
(
dirpath = getSavePath caption:"Select directory containing RSH files to convert..."

if dirpath != undefined then
(
converted_files = 0
rshfiles = getFiles (dirpath + "\\*.rsh")
for file in rshfiles do if (ConvertRSH file) then converted_files += 1

messagebox ("Converted files: " + converted_files as string)
)
)

)

--------------------------------------------------------------------------------------------
---------------------------------------[ END SCRIPT ]---------------------------------------
--------------------------------------------------------------------------------------------