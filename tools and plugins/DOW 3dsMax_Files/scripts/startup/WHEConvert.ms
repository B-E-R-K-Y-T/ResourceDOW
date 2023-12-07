--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- WHE Convert
-- by Brother Santos
--
-- Change log:
--
-- 0.25
--
-- - Fixed bug causing script not to work after max load
--
-- 0.2
--
-- - Added WHE fixing (after saving by Object Editor)
-- - Convert WHE function now creates a dummy SGM file
--
-- 0.1 First Release
--
-- - WHE -> EBP conversion added
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

include "RelicChunkLib.ms"																	-- Include RelicChunkLib
clearListener()																				-- Clear Listener Window

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDANIM_C > - Chunk Handler - XREF-ed Animations
--------------------------------------------------------------------------------------------

function CH_FOLDANIM_C ebpfile whefile chunk =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Processed Chunk

chunk.version = 2																			-- Change FOLDANIM Version From 3 To 2
WriteChunkHeader ebpfile chunk																-- Write FOLDANIM Header To EBP File
current_chunk = ReadChunkHeader whefile														-- Read DATAXREF Chunk Header From WHE File
current_chunk.version = 3																	-- Change DATAXREF Version From 1 To 3
CopyChunk whefile ebpfile current_chunk														-- Write DATAXREF Chunk To EBP File
current_chunk = ReadChunkHeader whefile														-- Read DATAANBV Chunk Header From WHE File
CopyChunk whefile ebpfile current_chunk														-- Write DATAANBV Chunk To EBP File
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < FIX_FOLDANIM > - Remove Empty Stubs From WHE File
--------------------------------------------------------------------------------------------

function FIX_FOLDANIM srcwhefile tmpwhefile =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Processed Chunk

anim_path_length = 0;																		-- Length Of Animation Path
anim_path = ""																				-- Animation Path

current_pos = (ftell srcwhefile) - current_chunk.namelength - 20							-- Store FOLDANIM Chunk Header Position

current_chunk = ReadChunkHeader srcwhefile													-- Read DATAXREF Chunk Header
anim_path_length = ReadLong srcwhefile														-- Read Animation Path Length
for i = 1 to anim_path_length do anim_path += bit.intAsChar (ReadByte srcwhefile)			-- Read Animation Path

motion_error = findString anim_path "motion_error"											-- Check If Animation Is Valid 

fseek srcwhefile current_pos #seek_set														-- Go Back To Stored FOLDANIM Chunk Header Position
current_chunk = ReadChunkHeader srcwhefile													-- Read FOLDANIM Header

if motion_error == undefined then CopyChunk srcwhefile tmpwhefile current_chunk				-- No Motion Error - Write Chunk
else SkipChunk srcwhefile current_chunk														-- Motion Error - Skip Chunk
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_DATAACTS > - Chunk Handler - Actions
--------------------------------------------------------------------------------------------

function CH_DATAACTS ebpfile whefile =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Processed Chunk

current_chunk.typeid = "FOLDACTR"															-- Create FOLDACTR Chunk Header
current_chunk.version = 1
current_chunk.size = 0																		-- Size Will Be Calculted Later
current_chunk.namelength = 0
current_chunk.name = ""

foldactr_size_pos = ftell ebpfile + 12														-- Store FOLDACTR Size Position
WriteChunkHeader ebpfile current_chunk														-- Write FOLDACTR chunk header To EBP File

foldactr_data_pos = ftell ebpfile															-- Store Position Of FOLDACTR Data

num_actions = ReadLong whefile																-- Read Number Of Actions From WHE File

for i = 1 to num_actions do
(
contains_actions = false;

dataactn_size_pos = ftell ebpfile + 12														-- Store DATAACTN Size Position

current_chunk.typeid = "DATAACTN"															-- Create DATAACTN chunk header
current_chunk.version = 1
current_chunk.size = 0																		-- Size Will Be Calculted Later
current_chunk.name = ""
current_chunk.namelength = ReadLong whefile + 1		
for j = 1 to (current_chunk.namelength - 1) do current_chunk.name += bit.intAsChar (ReadByte whefile)

WriteChunkHeader ebpfile current_chunk														-- Write DATAACTN Chunk Header To EBP File

dataactn_data_pos = ftell ebpfile															-- Store Position Of DATAACTN Data

num_sub_actions = ReadLong whefile															-- Read Number Of Sub Actions Or Motions From WHE File
WriteLong ebpfile num_sub_actions															-- Write Number Of Sub Actions Or Motions To EBP File

if num_sub_actions == 0 then																-- Empty Action Or Action Containing Other Actions
(
num_sub_actions = ReadLong whefile															-- Read Number Of Sub Actions Again From WHE File
WriteLong ebpfile num_sub_actions															-- Write Number Of Sub Actions Again To EBP File
contains_actions = true;																	-- Action Contains Other Actions
)

for k = 1 to num_sub_actions do
(
action_name_length = ReadLong whefile														-- Read Action Name Length From WHE File
WriteLong ebpfile action_name_length														-- Write Action Name Length To EBP File

for j = 1 to action_name_length do															-- Copy Action Name From WHE File To EBP File
(
byte = ReadByte whefile																		-- Read Byte From WHE File
WriteByte ebpfile byte																		-- Write Byte To EBP File
)

condition_property = ReadLong whefile														-- Read Action Condition Property From WHE File(0-if)(1-elseif)(2-else)(3-none)
WriteLong ebpfile condition_property														-- Write Action Condition Property To EBP File

if condition_property == 0 or condition_property == 1 do									-- Condition 'if' or 'else if'
(
condition_name_length = ReadLong whefile													-- Read Condition Name Length From WHE File
WriteLong ebpfile condition_name_length														-- Write Condition Name Length To EBP File
for j = 1 to condition_name_length do														-- Copy Condition Name From WHE File To EBP File
(
byte = ReadByte whefile																		-- Read Byte From WHE File
WriteByte ebpfile byte																		-- Write Byte To EBP File
)
)
)

if contains_actions == false then 															-- Action Contains Motions
(
contains_motions = ReadLong whefile															-- Read 4 Bytes (00 00 00 00) From WHE File
WriteLong ebpfile contains_motions															-- Write 4 Bytes (00 00 00 00) To EBP File 
)

current_pos = ftell ebpfile																	-- Store Current EBP File Position
dataactn_size = (current_pos - dataactn_data_pos)											-- Get New DATAACTN Chunk Size
fseek ebpfile dataactn_size_pos #seek_set													-- Move To DATAACTN Size In EBP File
WriteLong ebpfile dataactn_size																-- Write New DATAACTN Size To EBP File
fseek ebpfile current_pos #seek_set															-- Go Back To Stored Position In EBP File
)

current_pos = ftell ebpfile																	-- Store Current EBP File Position
foldactr_size = (current_pos - foldactr_data_pos)											-- Get New FOLDACTR Chunk Size
fseek ebpfile foldactr_size_pos #seek_set													-- Move To FOLDACTR Size In EBP File
WriteLong ebpfile foldactr_size																-- Write New FOLDACTR Size To EBP File
fseek ebpfile current_pos #seek_set															-- Go Back To Stored Position In EBP File
)

--------------------------------------------------------------------------------------------
--------------------------------------[ BEGIN SCRIPT ]--------------------------------------
--------------------------------------------------------------------------------------------

utility WHEConvert "WHE Convert"
(
-------------------
---[ VARIABLES ]---
-------------------

struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
local current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""			-- Currently Processed Chunk

-------------
---[ GUI ]---
-------------

button convert "Convert WHE" width:120 														-- Create 'Convert WHE' Button
button fixwhe "Fix WHE" width:120															-- Create 'Fix WHE' Button
button setoutputdir "Set Output Dir" width:120												-- Create 'Set Output Dir' Button

----------------
---[ EVENTS ]---
----------------
------------------------------------------------
---< EVENT >--- Button Pressed - [ Convert WHE ]
------------------------------------------------

on convert pressed do
(
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get Max Startup Scripts Folder Path
LastDir = getINISetting (maxpath + "\WHEConvert.ini") "Directories" "LastDir"				-- Get [LastDir] From INI File

-- Show File Open Window & Get WHE File Name
whefilename = getOpenFileName caption:"Select a WHE file to convert..." filename:LastDir types:"WHE(*.whe)|*.whe"

if whefilename != undefined then															-- If We Got WHE Filename - Open File
(
setINISetting (maxpath + "\WHEConvert.ini") "Directories" "LastDir" whefilename				-- Store [LastDir] In INI File
completeRedraw()																			-- Redraw All Viewports

-- Get EBP File Path
whe_filepath_array = filterString whefilename "\\"
whe_fileneme_array = filterString whe_filepath_array[whe_filepath_array.count] "."
ebpfile = whe_fileneme_array[1];
ebpfilename = (getINISetting (maxpath + "\WHEConvert.ini") "Directories" "OutputDir" + "\\" + ebpfile + ".ebp")

whefile = fopen whefilename "rbS"															-- Open WHE File For Reading In Binary Format
ebpfile = fopen ebpfilename "wbS"															-- Open EBP File For Writing In Binary Format

if whefile != undefined then																-- If WHE File Is Opened - Process File
(
print "Converting..."																		-- Print Status Into Listener

for i=1 to 24 do																			-- Copy 'Relic Chunky' Header From WHE File To EBP File
(
byte = ReadByte whefile																		-- Read Byte From WHE File
WriteByte ebpfile byte																		-- Write Byte To EBP File
)
current_chunk = ReadChunkHeader whefile														-- Read 'File Burn Info' Chunk Header From WHE File
SkipChunk whefile current_chunk																-- Skip 'File Burn Info' Chunk
current_chunk = ReadChunkHeader whefile														-- Read FOLDREBP Chunk Header From WHE File
WriteChunkHeader ebpfile current_chunk														-- Write FOLDREBP Chunk To EBP File
foldrebpheader = current_chunk																-- Store FOLDREBP Chunk Header For Later Use

while (current_chunk = ReadChunkHeader whefile) != false do									-- Get Next Chunk Until End Of File
(
case current_chunk.typeid of
(
"FOLDANIM": CH_FOLDANIM_C ebpfile whefile	current_chunk										-- FOLDANIM	- XREF-ed Animations
"DATAACTS": CH_DATAACTS ebpfile whefile														-- DATAACTS - Actions
default: CopyChunk whefile ebpfile current_chunk											-- Copy Chunk From WHE File To EBP File By Default
)
)

fseek ebpfile 0 #seek_end																	-- Move To The End Of EBP File
foldrebpheader.size = ftell ebpfile - 44 - foldrebpheader.namelength 						-- Get New FOLDREBP Size
fseek ebpfile (24 + 12) #seek_set															-- Skip RC Header & Get To FOLDREBP Size
WriteLong ebpfile foldrebpheader.size														-- Write New Size To FOLDREBP Header

fclose ebpfile																				-- Close EBP File
fclose whefile																				-- Close WHE File

--sgmfilepath = getFilenamePath ebpfilename													-- Get SGM File Path
--sgmfilename = getFilenameFile (filenameFromPath ebpfilename)								-- Get SGM File Name
--copyFile (maxpath + "\dummy.sgm") (sgmfilepath + sgmfilename + ".sgm")						-- Create Dummy SGM File

print "Conversion successful!"																-- Print Status Into Listener
messagebox "Conversion successful!"															-- Show MsgBox
)
else messagebox "Can't open file!"															-- Show MsgBox & Terminate Script
)
)

--------------------------------------------
---< EVENT >--- Button Pressed - [ Fix WHE ]
--------------------------------------------

on fixwhe pressed do
(
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get Max Startup Scripts Folder Path
LastDir = getINISetting (maxpath + "\WHEConvert.ini") "Directories" "LastDir"				-- Get [LastDir] From INI File

-- Show File Open Window & Get WHE File Name
srcwhefilename = getOpenFileName caption:"Select a WHE file to fix..." filename:LastDir types:"WHE(*.whe)|*.whe"

if srcwhefilename != undefined then															-- If We Got WHE Filename - Open File
(
setINISetting (maxpath + "\WHEConvert.ini") "Directories" "LastDir" srcwhefilename			-- Store [LastDir] In INI File

tmpwhefilename = (srcwhefilename + ".tmp")													-- Set Temp WHE Filename

srcwhefile = fopen srcwhefilename "rbS"														-- Open Source EBP For Reading In Binary Format
tmpwhefile = fopen tmpwhefilename "wbS"														-- Create Temp EBP For Writing In Binary Format

if srcwhefile != undefined then																-- If Source EBP Is Opened - Process File
(
print "Fixing..."																			-- Print Status Into Listener

for i=1 to 24 do																			-- Copy 'Relic Chunky' Header From Source WHE To Temp WHE
(
byte = ReadByte srcwhefile																	-- Read Byte From Source WHE File
WriteByte tmpwhefile byte																	-- Write Byte To Temp WHE File
)
current_chunk = ReadChunkHeader srcwhefile													-- Read 'File Burn Info' Chunk Header From Source WHE
CopyChunk srcwhefile tmpwhefile current_chunk												-- Copy 'File Burn Info' Chunk To Temp WHE
fbi_size = 20 + current_chunk.namelength + current_chunk.size								-- Calculate 'File Burn Info' Chunk Size
current_chunk = ReadChunkHeader srcwhefile													-- Read FOLDREBP Chunk Header From Source WHE
WriteChunkHeader tmpwhefile	current_chunk													-- Write FOLDREBP Chunk Header To Temp WHE														
foldrebpheader = current_chunk																-- Store FOLDREBP Header For Later Use
folderebp_pos = (ftell tmpwhefile) - 8 - current_chunk.namelength							-- Calculate FOLDREBP Chunk Offset

while (current_chunk = ReadChunkHeader srcwhefile) != false do								-- Get Next Chunk Until End Of File
(
case current_chunk.typeid of
(
"FOLDANIM": FIX_FOLDANIM srcwhefile tmpwhefile												-- FOLDANIM	- XREF-ed Animations
default: CopyChunk srcwhefile tmpwhefile current_chunk										-- Copy Chunk From Source WHE To Temp WHE By Default
)
)

fseek tmpwhefile 0 #seek_end																-- Move To The End Of Temp WHE File
new_foldrebp_size = ftell tmpwhefile-24-fbi_size-20-foldrebpheader.namelength				-- Get New FOLDREBP Size
fseek tmpwhefile folderebp_pos #seek_set													-- Move To FOLDREBP Chunk Header Size
WriteLong tmpwhefile new_foldrebp_size														-- Write New FOLDERB Size To Temp WHE File

fclose tmpwhefile																			-- Close Temp WHE File
fclose srcwhefile																			-- Close Source WHE File
deleteFile srcwhefilename																	-- Delete Source WHE File
renameFile tmpwhefilename srcwhefilename													-- Rename Temp WHE File To Source WHE File Name

print "File is fixed!"																		-- Print Status Into Listener
messagebox "File is fixed!"																	-- Show MsgBox
)
else messagebox "Can't open file!"															-- Show MsgBox & Terminate Script
)
)

---------------------------------------------------
---< EVENT >--- Button Pressed - [ Set Output Dir ]
---------------------------------------------------

on setoutputdir pressed do
(
outputdir = getSavePath caption:"Select output directory for EBP files..."					-- Show Folder Selection Window & Get Output Directory
if outputdir != undefined then																-- Proceed If User Selected Output Directory
(
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get Max Startup Scripts Folder Path
setINISetting (maxpath + "\WHEConvert.ini") "Directories" "OutputDir" outputdir				-- Set [OutputDir] In INI File
)
)
)

--------------------------------------------------------------------------------------------
---------------------------------------[ END SCRIPT ]---------------------------------------
--------------------------------------------------------------------------------------------