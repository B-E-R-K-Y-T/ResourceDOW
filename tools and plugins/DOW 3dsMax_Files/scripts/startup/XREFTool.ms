--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- XREF Tool
-- by Brother Santos
--
-- Change log:
--
-- 0.2
--
-- -- Remove button now works
-- -- Added Add All & Remove All buttons
-- -- Xrefing animations with the same name is no longer possible
--
-- 0.1 First Release
--
-- - XREF-ing animations from WHM files
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

include "RelicChunkLib.ms"																	-- Include RelicChunkLib
clearListener()																				-- Clear Listener Window

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < LoadAnimations > - Load WHM & WHE Animation List
--------------------------------------------------------------------------------------------

function LoadAnimations filepath =
(	
animations = #()																			-- Array To Hold Animation Info
struct str_animation (name, path)															-- Structure To Hold Animation Info
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Read Chunk
whm_path_array = #()																		-- Temporary Array For String Filtering
whm_xref_path = ""																			-- WHM XREF-ed Animations Path

-- Break File Path Into Sub Strings
whm_path_array = filterString (getFilenamePath filepath) "\\"

-- Look For 'Art' String
art_str_pos = 1
while (whm_path_array[art_str_pos] as name) != ("art" as name) do art_str_pos += 1

-- Build New File Path
for i=art_str_pos to whm_path_array.count do whm_xref_path += (whm_path_array[i] + "/")

-- Add File Name
whm_xref_path += getFilenameFile (filenameFromPath filepath)

whmfilepath = getFilenamePath filepath + getFilenameFile (filenameFromPath filepath) + ".whm"
whefilepath = getFilenamePath filepath + getFilenameFile (filenameFromPath filepath) + ".whe"

-- Open WHM File For Reading
file = fopen whmfilepath "rbS"	

if file != undefined then
(
-- Skip 'Relic Chunky' Header
fseek file 24 #seek_set		-- skipping 24 bytes - size of 'Relic Chunky' header
-- Skip 'File Burn Info'
if (current_chunk = ReadChunkHeader file) != false then SkipChunk file current_chunk	-- skip whole File Burn Info chunk
fbisize = current_chunk.size + 33	-- File Burn Info Size + File Burn Info Header Size
-- Skip 'Folder SGM' Header
current_chunk = ReadChunkHeader file

while (current_chunk = ReadChunkHeader file) != false do
(
case current_chunk.typeid of
(
"FOLDANIM": 				-- FOLDANIM - Animation Data
(
animation = str_animation name:"" path:""
animation.name = current_chunk.name
animation.path = whm_xref_path
append animations animation
SkipChunk file current_chunk
)
default: SkipChunk file current_chunk	-- Skip Chunks By Default
)
)
-- Close WHM File
fclose file
)


-- Open WHE File For Reading

file = fopen whefilepath "rbS"

if file != undefined then
(
-- Skip 'Relic Chunky' Header
fseek file 24 #seek_set		-- skipping 24 bytes - size of 'Relic Chunky' header
-- Skip 'File Burn Info'
if (current_chunk = ReadChunkHeader file) != false then SkipChunk file	current_chunk-- skip whole File Burn Info chunk
fbisize = current_chunk.size + 33	-- File Burn Info Size + File Burn Info Header Size
-- Skip 'Folder EBP' Header
current_chunk = ReadChunkHeader file

while (current_chunk = ReadChunkHeader file) != false do
(
case current_chunk.typeid of
(
"FOLDANIM": 				-- FOLDANIM - Animation Data
(
anim_path_length = 0;
anim_path = ""
animation = str_animation name:"" path:""
-- Set Animation Name
animation.name = current_chunk.name
-- Read DATAXREF Chunk
current_chunk = ReadChunkHeader file	-- Read Header
anim_path_length = ReadLong file		-- Read Anim Path Length
for i = 1 to anim_path_length do		-- Read Anim Path
(
buffer = ReadByte file
char = bit.intAsChar buffer
anim_path += char	-- convert to string
)
-- Set Animation Path
animation.path = anim_path
-- Add Animation To The List
append animations animation
-- Skip To Next Chunk
fseek file (ReadLong file) #seek_cur	-- Skip The Rest Of Chunk
current_chunk = ReadChunkHeader file	-- Read DATAANBV Header
SkipChunk file current_chunk			-- Skip DATAANBV Chunk
)
default: SkipChunk file current_chunk	-- Skip Chunks By Default
)
)
-- Close WHE File
fclose file
)

-- Return Animations Array
return animations
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < SaveEBP > - Save EBP Animation List (XREF-s)
--------------------------------------------------------------------------------------------

function SaveEBP filepath animations ebpitems =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Read Chunk

if filepath != undefined then
(
-- Set Temp WHE Filename
srcebpfilename = filepath
tmpebpfilename = (filepath + ".tmp")

-- Open WHE Files
srcebpfile = fopen srcebpfilename "rbS"		-- open source ebp for reading in binary format
tmpebpfile = fopen tmpebpfilename "wbS"		-- create temp ebp for writing in binary format

-- If Source EBP Is Opened - Process File
if srcebpfile != undefined then	-- can't open file
(
-- Copy 'Relic Chunky' Header From Source EBP To Temp EBP
for i=1 to 24 do	-- 24 is 'Relic Chunky' header size
(
byte = ReadByte srcebpfile
WriteByte tmpebpfile byte
)
-- Copy 'Folder EBP' Header From Source WHE To Temp WHE
current_chunk = ReadChunkHeader srcebpfile
WriteChunkHeader tmpebpfile current_chunk
foldrebpheader = current_chunk	-- store foldrebp header for later use
folderebp_pos = (ftell tmpebpfile) - 8 - current_chunk.namelength

--> Write New ANIM-s here !!!
for i=1 to ebpitems.count do
(
num_anim = 0
for j=1 to animations.count do if animations[j].name == ebpitems[i] then num_anim = j

-- Write FOLDANIM Header
current_chunk.typeid = "FOLDANIM"
current_chunk.version = 2
current_chunk.size = 20 + 8 + animations[num_anim].path.count + animations[num_anim].name.count + 20 + animations[num_anim].name.count + 1 + 24
current_chunk.namelength = animations[num_anim].name.count + 1
current_chunk.name = animations[num_anim].name
WriteChunkHeader tmpebpfile current_chunk

-- Write DATAXREF Header
current_chunk.typeid = "DATAXREF"
current_chunk.version = 3
current_chunk.size = 8 + animations[num_anim].path.count + animations[num_anim].name.count
current_chunk.namelength = 0
WriteChunkHeader tmpebpfile current_chunk

-- Write DATAXREF Chunk
WriteLong tmpebpfile animations[num_anim].path.count
for j=1 to animations[num_anim].path.count do WriteByte tmpebpfile (bit.charAsInt animations[num_anim].path[j])
WriteLong tmpebpfile animations[num_anim].name.count
for j=1 to animations[num_anim].name.count do WriteByte tmpebpfile (bit.charAsInt animations[num_anim].name[j])

-- Write DATAANBV Header
current_chunk.typeid = "DATAANBV"
current_chunk.version = 1
current_chunk.size = 24
current_chunk.namelength = animations[num_anim].name.count + 1
current_chunk.name = animations[num_anim].name
WriteChunkHeader tmpebpfile current_chunk

-- Write DATAANBV Chunk	- Unknown Data (24 bytes) - Fill With 00
for j=1 to 24 do WriteByte tmpebpfile 0
)

-- Get Next Chunk Until End Of File
while (current_chunk = ReadChunkHeader srcebpfile) != false do	-- read from source whe file
(
case current_chunk.typeid of
(
"FOLDANIM": 												-- FOLDANIM	- XREF-ed Animations - Copy If Wasn't XREF-ed
(
if (findItem ebpitems current_chunk.name) == 0 then CopyChunk srcebpfile tmpebpfile current_chunk
else SkipChunk srcebpfile current_chunk				
)
default: CopyChunk srcebpfile tmpebpfile current_chunk		-- Copy Chunks From Source WHE To Temp WHE By Default
)
)

-- Get new EBP file size
fseek tmpebpfile 0 #seek_end
-- File Size - 'RC' Header(24) - FOLDREBP Header(20) - Namelength (Just In Case...)
new_foldrebp_size = ftell tmpebpfile - 24 - 20
-- Write New Size To FOLDREBP Header In Temp WHE File
fseek tmpebpfile folderebp_pos #seek_set	-- get to FOLDREBP size
WriteLong tmpebpfile new_foldrebp_size

-- Close Temp WHE File
fclose tmpebpfile
-- Close Source WHE File
fclose srcebpfile
-- Delete Source WHE File
deleteFile srcebpfilename
-- Rename Temp WHE File
renameFile tmpebpfilename srcebpfilename
)
else messagebox "Can't open file!"	-- Show MsgBox & Terminate Script
)
)

--------------------------------------------------------------------------------------------
--------------------------------------[ BEGIN SCRIPT ]--------------------------------------
--------------------------------------------------------------------------------------------

utility XREFTool "XREF Tool"
(
-------------
---[ GUI ]---
-------------

button xref "XREF Tool" width:120 															-- Create [XREF Tool] Button

----------------
---[ DIALOG ]---
----------------

rollout xrefdialog "XREF Tool"
(
-------------------
---[ VARIABLES ]---
-------------------

struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
local current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""			-- Currently Read Chunk
struct str_animation (name, path)															-- Structure To Hold Animation Info
local source_animations = #()																-- Array To Hold WHE Animations Info
local ebpfilepath = ""																		-- Path Of Target EBP File

--------------------
---[ DIALOG GUI ]---
--------------------

label label_source "Source:" pos:[30, 20] width:75 height:15								-- Create [Source] Label
label label_ebp "EBP:" pos:[30, 48] width:75 height:15										-- Create [EBP] Label
button button_source "<<< Select Source WHM or WHE File >>>" \								-- Create [Source] Button
pos:[75, 17] width:395 height:19
button button_ebp "<<< Select EBP File >>>" pos:[75, 45] width:395 height:19				-- Create [EBP] Button
button button_add "Add" pos:[207, 145] width:85 height:28									-- Create [Add] Button
button button_remove "Remove" pos:[207, 185] width:85 height:28								-- Create [Remove] Button
button button_addall "Add All" pos:[207, 246] width:85 height:28							-- Create [Add All] Button
button button_removeall "Remove All" pos:[207, 286] width:85 height:28						-- Create [Remove All] Button
button button_save "Save" pos:[107, 380] width:85 height:28									-- Create [Save] Button
button button_ok "OK" pos:[207, 380] width:85 height:28										-- Create [OK] Button
button button_close "Close" pos:[307, 380] width:85 height:28								-- Create [Close] Button
listbox listbox_whm "Source:" pos:[30, 80] width:160 height:20								-- Create [Source] Listbox
listbox listbox_ebp "EBP:" pos:[310, 80] width:160 height:20								-- Create [EBP] Listbox

-------------------------------------------
---< EVENT >--- Button Pressed - [ Source ]
-------------------------------------------

on button_source pressed do 
(
source_animation_names = #()																-- Temporary Array To Store Source Animation Names

maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get Max [Scripts/Startup] Dir Path
LastSourceDir= getINISetting (maxpath + "\\XREFTool.ini") "Directories" "LastSourceDir"		-- Get [LastSourceDir] From INI File

sourcefilepath = getOpenFileName caption:"Select source WHM or WHE file..." \				-- Get Source File Path
filename:LastSourceDir types:"WHM(*.whm)|*.whm|WHE(*.whe)|*.whe"

if sourcefilepath != undefined then 
(
setINISetting (maxpath + "\\XREFTool.ini") "Directories" "LastSourceDir" sourcefilepath		-- Save [LastSourceDir] In INI File
button_source.caption = getFilenameFile (filenameFromPath sourcefilepath)					-- Set Source Button Caption To Source File Name
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
while listbox_whm.items.count > 0 do deleteItem temp_whm 1									-- Delete All Items From WHM Listbox
while listbox_ebp.items.count > 0 do deleteItem temp_ebp 1									-- Delete All Items From EBP Listbox
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_remove.enabled = false																-- Disable [Remove] Button
button_removeall.enabled = false															-- Disable [Remove All] Button
source_animations = LoadAnimations sourcefilepath											-- Load Animation List From WHM & WHE Files
for i=1 to source_animations.count do 
append source_animation_names source_animations[i].name										-- Add Animations To WHM List Box (Temp Array)
sort source_animation_names																	-- Sort Items In WHM Listbox
listbox_whm.items = source_animation_names													-- Add Animations To WHM List Box
listbox_whm.enabled = true																	-- Enable WHM Listbox
listbox_whm.selection = 1																	-- Select First Item In WHM Listbox
if listbox_ebp.enabled == true then 														-- Enable Buttons If Listbox EBP Is Enabled
(
button_add.enabled = true																	-- Enable [Add] Button
button_addall.enabled = true																-- Enable [Add All] Button
)
)
)

----------------------------------------
---< EVENT >--- Button Pressed - [ EBP ]
----------------------------------------

on button_ebp pressed do 
(
ebp_animation_names = #()																	-- Temporary Array To Store EBP Animation Names

maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get Max [Scripts/Startup] Dir Path
LastEBPDir = getINISetting (maxpath + "\\XREFTool.ini") "Directories" "LastEBPDir"			-- Get [LastEBPDir] From INI File

ebpfilepath = getOpenFileName caption:"Select target EBP file..."  \						-- Get EBP File Path
filename:LastEBPDir types:"EBP(*.ebp)|*.ebp"

if ebpfilepath != undefined then 															-- Proceed If User Selected EBP File To Open
(
setINISetting (maxpath + "\\XREFTool.ini") "Directories" "LastEBPDir" ebpfilepath			-- Save [LastEBPDir] In INI File
button_ebp.caption = getFilenameFile (filenameFromPath ebpfilepath)							-- Set EBP Button Caption To EBP File Name
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
for i=1 to listbox_ebp.items.count do insertItem listbox_ebp.items[i] temp_whm 1			-- Add All Items From EBP Listbox To WHM Listbox
while listbox_ebp.items.count > 0 do deleteItem temp_ebp 1									-- Delete All Items From EBP Listbox
sort temp_whm																				-- Sort Items In WHM Listbox	
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_remove.enabled = false																-- Disable [Remove] Button
button_removeall.enabled = false															-- Disable [Remove All] Button
listbox_whm.selection = 1																	-- Select First Item In WHM Listbox
listbox_ebp.enabled = true																	-- Enable EBP Listbox
if listbox_whm.enabled == true then															-- Enable Buttons If Listbox WHM Is Enabled
(
button_add.enabled = true																	-- Enable [Add] Button
button_addall.enabled = true																-- Enable [Add All] Button
)
)
)

----------------------------------------
---< EVENT >--- Button Pressed - [ Add ]
----------------------------------------

on button_add pressed do 
(
if listbox_whm.selection != 0 do															-- Check If Any Item Is Selected In WHM Listbox
(
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
item = listbox_whm.items[listbox_whm.selection]												-- Store Selected Item Name
insertItem listbox_whm.items[listbox_whm.selection] temp_ebp 1								-- Add Selected Item From WHM Listbox To EBP Listbox
deleteItem temp_whm listbox_whm.selection													-- Delete Selected Item From WHM Listbox
sort temp_ebp																				-- Sort Items In EBP Listbox
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_remove.enabled = true																-- Enable [Remove] Button
button_removeall.enabled = true																-- Enable [Remove All] Button
if listbox_whm.items.count == 0 then 
(
button_add.enabled = false																	-- Disable [Add] Button If WHM Listbox Is Empty					
button_addall.enabled = false																-- Disable [Add All] Button If WHM Listbox Is Empty
)
listbox_ebp.selection = findItem listbox_ebp.items item										-- Select Added Item In EBP Listbox
if listbox_whm.selection == 0 then listbox_whm.selection = listbox_whm.items.count			-- Select Last Item If No Items Selected
)
)

-------------------------------------------
---< EVENT >--- Button Pressed - [ Remove ]
-------------------------------------------

on button_remove pressed do 
(
if listbox_ebp.selection != 0 do															-- Check If Any Item Is Selected In EBP Listbox
(
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
item = listbox_ebp.items[listbox_ebp.selection]												-- Store Selected Item Name
insertItem listbox_ebp.items[listbox_ebp.selection] temp_whm 1								-- Add Selected Item From WHM Listbox To EBP Listbox
deleteItem temp_ebp listbox_ebp.selection													-- Delete Selected Item From WHM Listbox
sort temp_whm																				-- Sort Items In WHM Listbox
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_add.enabled = true																	-- Enable [Add] Button
button_addall.enabled = true																-- Enable [Add All] Button
if listbox_ebp.items.count == 0 then 
(
button_remove.enabled = false																-- Disable [Remove] Button If EBP Listbox Is Empty
button_removeall.enabled = false															-- Disable [Remove All] Button If EBP Listbox Is Empty
)
listbox_whm.selection = findItem listbox_whm.items item										-- Select Removed Item In WHM Listbox
if listbox_ebp.selection == 0 then listbox_ebp.selection = listbox_ebp.items.count			-- Select Last Item If No Items Selected
)
)

--------------------------------------------
---< EVENT >--- Button Pressed - [ Add All ]
--------------------------------------------

on button_addall pressed do 
(
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
for i=1 to listbox_whm.items.count do insertItem listbox_whm.items[i] temp_ebp 1			-- Add All Items From WHM Listbox To EBP Listbox
while listbox_whm.items.count > 0 do deleteItem temp_whm 1									-- Delete All Items From WHM Listbox
sort temp_ebp																				-- Sort Items In EBP Listbox
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_remove.enabled = true																-- Enable [Remove] Button
button_removeall.enabled = true																-- Enable [Remove All] Button
button_add.enabled = false																	-- Disable [Add] Button					
button_addall.enabled = false																-- Disable [Add All] Button
listbox_ebp.selection = 1																	-- Select First Item In EBP Listbox
)

-----------------------------------------------
---< EVENT >--- Button Pressed - [ Remove All ]
-----------------------------------------------

on button_removeall pressed do 
(
temp_whm = listbox_whm.items																-- Create Temporary Arrays For WHM Listbox
temp_ebp = listbox_ebp.items																-- Create Temporary Arrays For EBP Listbox
for i=1 to listbox_ebp.items.count do insertItem listbox_ebp.items[i] temp_whm 1			-- Add All Items From EBP Listbox To WHM Listbox
while listbox_ebp.items.count > 0 do deleteItem temp_ebp 1									-- Delete All Items From EBP Listbox
sort temp_whm																				-- Sort Items In WHM Listbox
listbox_ebp.items = temp_ebp																-- Update EBP Listbox
listbox_whm.items = temp_whm																-- Update WHM Listbox
button_add.enabled = true																	-- Enable [Add] Button
button_addall.enabled = true																-- Enable [Add All] Button
button_remove.enabled = false																-- Disable [Remove] Button
button_removeall.enabled = false															-- Disable [Remove All] Button
listbox_whm.selection = 1																	-- Select First Item In WHM Listbox
)

-----------------------------------------
---< EVENT >--- Button Pressed - [ Save ]
-----------------------------------------

on button_save pressed do
(
SaveEBP ebpfilepath source_animations listbox_ebp.items										-- Save EBP File
)

----------------------------------------------
---< EVENT >--- Button Pressed - [ XREF Tool ]
----------------------------------------------

on button_ok pressed do
(
SaveEBP ebpfilepath source_animations listbox_ebp.items										-- Save EBP File								
DestroyDialog xrefdialog																	-- Close Dialog Window
)

------------------------------------------
---< EVENT >--- Button Pressed - [ Close ]
------------------------------------------

on button_close pressed do DestroyDialog xrefdialog											-- Close Dialog Window

---------------------------------------------
---< EVENT >--- Open Dialog - [ XREF Dialog ]
---------------------------------------------

on xrefdialog open do
(
button_add.enabled = false																	-- Disable [Add] Button
button_remove.enabled = false																-- Disable [Remove] Button
button_addall.enabled = false																-- Disable [Add All] Button
button_removeall.enabled = false															-- Disable [Remove All] Button
listbox_whm.enabled = false																	-- Disable [WHM] Listbox
listbox_ebp.enabled = false																	-- Disable [EBP] Listbox
)

)

----------------------------------------------
---< EVENT >--- Button Pressed - [ XREF Tool ]
----------------------------------------------

on xref pressed do
(
CreateDialog xrefdialog height:425 width:500 lockHeight:true lockWidth:true modal:true		-- Create Dialog Window
)

)

--------------------------------------------------------------------------------------------
---------------------------------------[ END SCRIPT ]---------------------------------------
--------------------------------------------------------------------------------------------