--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- WHM Import
-- by Brother Santos
--
-- Change log:
--
-- 0.6
--
-- - 
--
-- 0.55 
--
-- - Stencil shadows are now supported
--
-- 0.5
--
-- - Animation import added
-- - Fix Skin utility added
--
-- 0.4
--
-- - Marker import added
--
-- 0.3
--
-- - Skeleton import added
--
-- 0.2
-- 
-- - Script can now import buildings and environment models
-- - Fixed material editor bug
--
-- 0.11 Bug Fix Release
--
-- - Script will now function without need to evaluate it again
-- - Added zooming on imported model
--
-- 0.1 First Release
--
-- - Model import added
-- - Material import added
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

include "RelicChunkLib.ms"																	-- Include RelicChunkLib
clearListener()																				-- Clear Listener Window

--------------------------------------------------------------------------------------------
----------------------------------- [ GLOBAL VARIABLES] ------------------------------------
--------------------------------------------------------------------------------------------

global texture_count = 0
global texture_array = #()
global bone_array = #()
global xref_bone_array = #()
global created_bones_array = #()															-- Array To Store Created Bones
global multimat = multimaterial numsubs:1

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDTXTR > - Chunk Handler - Internal Texture
--------------------------------------------------------------------------------------------

function CH_FOLDTXTR file chunk save_path =
(
makeDir (save_path + "\\Textures")
rshfilename = (filenameFromPath chunk.name) + ".rsh"
rshfilepath = save_path + "\\Textures\\" + rshfilename
rshfile = fopen rshfilepath "wbS"

if rshfile != undefined then
(
WriteString rshfile "Relic Chunky"
fseek rshfile 12 #seek_set
WriteLong rshfile 1706509
WriteLong rshfile 1
WriteLong rshfile 1

WriteString rshfile "FOLDSHRF"
fseek rshfile 32 #seek_set
WriteLong rshfile 1
WriteLong rshfile (chunk.size + 20 + chunk.namelength)
WriteLong rshfile chunk.namelength
WriteString rshfile chunk.name

CopyChunk file rshfile chunk
)
else messagebox "Can't create RSH file!"		
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_DATASSHR > - Chunk Handler - Material Data
--------------------------------------------------------------------------------------------

function CH_DATASSHR file =
(
texture_path = ""
texpath = ""
texture_path_array = #()
texture_path_length = 0
datasrc_dir = "\\ModTools\\DataSrc\\"

maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"
dowpath = getINISetting (maxpath + "\WHMImport.ini") "Directories" "DawnOfWar"
modfolder = getINISetting (maxpath + "\WHMImport.ini") "Directories" "ModFolder"

texture_path_length = ReadLong file		-- read texture path length

-- Read Texture Path & Convert To String
for i=1 to texture_path_length do texture_path += bit.intAsChar (ReadByte file)	

if (findItem texture_array texture_path) == 0 then
(
append texture_array texture_path
texture_count += 1
texture_path_array = filterString texture_path "/"		-- get material name (texture name)

-- add new material to multi material
for i=1 to texture_path_array.count do
(
texpath += texture_path_array[i]
if i<texture_path_array.count then texpath += "\\"
)
texture_path = (dowpath + datasrc_dir + modfolder + "\\" + texpath + ".tga")
texture_map = bitmaptexture filename: texture_path		-- create new texture map
new_material = standardMaterial diffuseMap:texture_map showInViewport:true		-- create new material
new_material.name = texture_path_array[texture_path_array.count]	-- set new material name
multimat[multimat.numsubs] = new_material	-- add new material to multi material
multimat.names[multimat.numsubs] = texture_path_array[texture_path_array.count]		-- set mulitmaterial slot name
multimat.numsubs +=1	-- add another material slot to multi material
)
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_DATASKEL > - Chunk Handler - Skeleton Data
--------------------------------------------------------------------------------------------

function CH_DATASKEL file xref =
(
num_bones = 0																				-- Number Of Bones
bonenamelength = 0																			-- Bone Name Length
bone_counter = -1																			-- Bone Hierarchy Counter
start = point3 0 0 0
end = point3 0 0 0.5
zaxis = point3 0 0 0
																	
struct bonedata (name, level, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, rot_w)				-- Structure To Hold Bone Data (4, X, 4, 28)

---< READ BONES >---
			
num_bones = ReadLong file																	-- Read Number Of Bones

for i=1 to num_bones do																		-- Read Each Bone Data
(
bone = bonedata name:"" level:0 pos_x:0 pos_y:0 pos_z:0 rot_x:0 rot_y:0 rot_z:0 rot_w:0		-- Reset Bonedata Structure
bonenamelength = ReadLong file																-- Read Bone Name length
for j=1 to bonenamelength do																-- Read Bone Name
(
buffer = ReadByte file
char = bit.intAsChar buffer
bone.name += char
)
bone.level = ReadLong file																	-- Read Bone Hierarchy Level
bone.pos_x = ReadFloat file																	-- Read Bone X Position
bone.pos_y = ReadFloat file																	-- Read Bone Y Position
bone.pos_z = ReadFloat file																	-- Read Bone Z Position
bone.rot_x = ReadFloat file																	-- Read Bone X Rotation
bone.rot_y = ReadFloat file																	-- Read Bone Y Position
bone.rot_z = ReadFloat file																	-- Read Bone Z Position
bone.rot_w = ReadFloat file																	-- Read Bone W Position
if xref == false then append bone_array bone												-- Add Bone To Bone Array
else append xref_bone_array bone
--print bone
)

if xref == false then
(
---< CREATE BONES >---

for i=1 to num_bones do			-- read each bone data
(
---< CREATE BONE >---

bone_counter = bone_array[i].level															-- Set Bone Counter To Level Of New Bone
new_bone = BoneSys.createBone start end zaxis												-- Create Bone
new_bone.width = 0.1																		-- Set Width
new_bone.height = 0.1																		-- Set Height
new_bone.name = bone_array[i].name															-- Set Name
new_bone.boneScaleType = #none																-- Stretch Off

---< LINK BONE >---

current_bone = i																			-- Set Current Bone Number

--print (current_bone as string + "-" + new_bone.name + "-" + bone_counter as string)

while current_bone > 0	do																	-- Go Backwards From Current Bone To The Root
(
if bone_array[current_bone].level < bone_counter then										-- Find First Bone With Smaller Bone Counter
(
new_bone.parent = created_bones_array[current_bone]											-- Link To Parent
exit																						-- Exit Loop If Parent Is Found
)
current_bone -= 1																			-- One Bone Backwards
)

created_bones_array[i] = new_bone															-- Add New Bone To Created Bones Array

---< POSITION & ROTATION >---


if bone_counter == -1 then																	-- First Bone - World Coordinates
(
rotmat = (quat bone_array[i].rot_x bone_array[i].rot_y bone_array[i].rot_z bone_array[i].rot_w) as matrix3
rotmat = inverse rotmat
mat = matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
newmat = mat * rotmat * (inverse mat)
newmat = newmat as quat
new_bone.rotation = (inverse newmat)
rot = eulerangles 90 0 0
in coordsys local rotate new_bone rot														-- Set Bone Rotation
new_bone.pos = (point3 -bone_array[i].pos_x -bone_array[i].pos_z bone_array[i].pos_y)		-- Set Bone Position
)
else																						-- Child Bones - Parent Coordinates
(
newmat = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])											-- Create Zero Matrix

bonequat = (quat bone_array[i].rot_x bone_array[i].rot_y bone_array[i].rot_z bone_array[i].rot_w) as matrix3	-- Turn Quat Into Matrix
newmat.row1 = (point3 bonequat[1][1] -bonequat[2][1] -bonequat[3][1])						-- Set 1st Row
newmat.row2 = (point3 -bonequat[1][2] bonequat[2][2] bonequat[3][2])						-- Set 2nd Row
newmat.row3 = (point3 -bonequat[1][3] bonequat[2][3] bonequat[3][3])						-- Set 3rd Row
newmat.row4 = (point3 bone_array[i].pos_x bone_array[i].pos_y bone_array[i].pos_z)			-- Set 4th Row

newrot = newmat as quat																		-- Get Rotation Part From Matrix
newrot.w *= -1																				-- Negate Rotation W

newpos = newmat.translationpart																-- Get Translation Part From Matrix
newpos.x *= -1																				-- Negate Position X

in coordsys parent new_bone.rotation = newrot												-- Set Child Bone Rotation
in coordsys parent new_bone.pos = newpos													-- Set Child Bone Position
)
)

---< MASTER >---

master = dummy()																			-- Create Master Dummy
master.boxsize = [1,1,1]																	-- Set Master Dummy Size

if findString bone_array[1].name "master" != undefined then									-- Master Is A Bone
(
master.name = created_bones_array[1].name													-- Set Name (First Bone)
master.rotation = created_bones_array[1].rotation											-- Set Rotation (First Bone)
master.pos = created_bones_array[1].pos														-- Set Position (First Bone)
master.setBoneEnable true 0																	-- Turn To Bone
master.boneAutoAlign = false																-- Turn Off Auto Align
master.boneScaleType = #none																-- Turn Off Stretch
while created_bones_array[1].children.count > 0 do 											-- Relink First Bone Children To Master
append master.children created_bones_array[1].children[1]
delete created_bones_array[1]																-- Delete First Bone
created_bones_array[1] = master																-- Replace Bone Node With Dummy Node
)
else 																						-- Master Is Not A Bone
(
master.name = "Master"																		-- Set Name
master.rotation = (quat -0.5 -0.5 -0.5 -0.5)												-- Set Rotation
master.pos = [0,0.00402224,-0.491935]														-- Set Position
for i=1 to created_bones_array.count do														-- Link All Root Bones To Master
if bone_array[i].level == -1 then created_bones_array[i].parent = master
)
)
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDMSLC > - Chunk Handler - FOLDMSGR Sub Chunk - Mesh Data
---------------------------------------------------------------------------------------------

function CH_FOLDMSLC file meshname xref =
(
-- Structure Holding Chunk Header Data
struct chunkheader (typeid, version, size, namelength, name)
-- Currently Readed Chunk
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""

vert_array = #()				-- array to store vertex data
skin_vert_array = #()			-- array to store skin vertices
skin_bone_array = #()			-- array to store skin bone names
normal_array = #()				-- array to store normal data
face_array = #()				-- array to store face data
uvw_array = #()					-- array to store texture coordinates
matid_array = #()				-- array to store material id's
matedit_array = #()				-- array to store materials for use in material editor
material_array = #()			-- array to store materials connected with given mesh
shadow_vert_array = #()
shadow_face_array = #()
num_vertices = 0				-- number of vertices in the mesh
num_faces = 0					-- number of faces in the mesh
num_materials = 0				-- number of materials applied to mesh
vertex_count = 0				-- read vertex count
face_count = 0					-- read face count
uvw_count = 0					-- read uvw cords count
material_count = 0				-- read material count
mesh_name = meshname  			-- store FOLDMSLC name before it gets overwriteen
num_skin_bones = 0				-- number of bones mesh is weighted to
bone_name_length = 0			-- length of each skin bone
bone_name = ""					-- bone name
struct str_skin_vert (weight, bone)

------------------------
---[ READ MESH DATA ]---
------------------------

---< DATADATA CHUNK >---

current_chunk = ReadChunkHeader file	-- read DATADATA header
fseek file 13 #seek_cur		-- skip 13 bytes (unknown)
num_skin_bones = ReadLong file	-- get number of bones mesh is weighted to

---< SKIN BONES >---

for i=1 to num_skin_bones do
(
bone_name = ""
bone_name_length = ReadLong file		-- read bone name length
for j=1 to bone_name_length do bone_name += bit.intAsChar (ReadByte file)	-- read bone name
append skin_bone_array bone_name 
fseek file 4 #seek_cur		-- skip 4 bytes (unknown)
)

---< VERTICES >---

num_vertices = ReadLong file -- read number of vertices
fseek file 4 #seek_cur		-- skip 4 bytes (unknown)

vertex = point3 0 0 0
normal = point3 0 0 0
face = point3 0 0 0
uvw = point3 0 0 0

for i=1 to num_vertices do
(
vertex.x = -(ReadFloat file)
vertex.z = ReadFloat file
vertex.y = -(ReadFloat file)
append vert_array [vertex.x, vertex.y, vertex.z]
vertex_count += 1
)

---< SKIN >---

if num_skin_bones != 0 then 
(
for i=1 to num_vertices do
(
skin_vert = str_skin_vert weight:#(0.0, 0.0, 0.0, 0.0) bone:#(0, 0, 0, 0)	-- Reset Structure

skin_vert.weight[1] = ReadFloat file							-- Read 1st Bone Weight
skin_vert.weight[2] = ReadFloat file							-- Read 2nd Bone Weight
skin_vert.weight[3] = ReadFloat file							-- Read 3rd Bone Weight
skin_vert.weight[4] = 1 - skin_vert.weight[1] - skin_vert.weight[2] - skin_vert.weight[3]		-- Calculate 4th Bone Weight

-- Read Bones
for j=1 to 4 do 
if (skin_vert.bone[j] = ReadByte file) != -1 then
if xref == false then skin_vert.bone[j] = findItem skin_bone_array bone_array[skin_vert.bone[j]+1].name
else skin_vert.bone[j] = findItem skin_bone_array xref_bone_array[skin_vert.bone[j]+1].name

-- Add Vertex To Array
append skin_vert_array skin_vert
)
)

--print skin_vert_array

---< NORMALS >---

for i=1 to num_vertices do
(
normal.x = -(ReadFloat file)
normal.z = ReadFloat file
normal.y = -(ReadFloat file)
append normal_array [normal.x, normal.y, normal.z]
)

---< UVW MAP >---

for i=1 to num_vertices do
(
uvw.x = ReadFloat file
uvw.y = ReadFloat file
append uvw_array [uvw.x, uvw.y, uvw.z]
uvw_count += 1
)

-- skip to texture path
fseek file 4 #seek_cur		-- skip 4 bytes (unknown)

---< MATERIALS >---

num_materials = ReadLong file	-- read number of materials

-- read materials
for i=1 to num_materials do
(
texture_path_length = ReadLong file		-- read texture path length

texture_path = ""

for i=1 to texture_path_length do
(
buffer = ReadByte file
char = bit.intAsChar buffer
texture_path += char
)

mat_id = 0
for i=1 to texture_count do if texture_array[i] == texture_path then mat_id = i

material_count += 1

-- read number of faces connected with this material
num_faces = (ReadLong file) / 3		-- faces are given as a number of vertices that makes them - divide by 3

-- read faces connected with this material
for j=1 to num_faces do	
(
face.x = ReadShort file + 1
face.z = ReadShort file + 1
face.y = ReadShort file + 1
append face_array [face.x, face.y, face.z]
append matid_array mat_id
face_count += 1
)
fseek file 8 #seek_cur																-- Skip 8 Bytes To Next Texture Name Length
)

---< SHADOW VOLUME >---

unknown_1 = ReadLong file															-- Unknown Data 1
for i=1 to unknown_1 do fseek file 12 #seek_cur										-- Skip Unknown Data 1

unknown_2 = ReadLong file															-- Unknown Data 2
for i=1 to unknown_2 do fseek file 24 #seek_cur										-- Skip Unknown Data 2

unknown_3 = ReadLong file															-- Unknown Data 3
for i=1 to unknown_3 do fseek file 40 #seek_cur										-- Skip Unknown Data 3

/*
print ("Mesh_name: " + mesh_name)
print ("Num_vertices: " + num_vertices as string)
print ("Num_faces: " + num_faces as string)

shadow_verts = ReadLong file														-- Read Shadow Mesh Vertex Number		
print ("Shadow Vertices: " + shadow_verts as string)

for i=1 to shadow_verts do 
(
vertex.x = -(ReadFloat file)														-- Read Vertex X
vertex.z = ReadFloat file															-- Read Vertex Y
vertex.y = -(ReadFloat file)														-- Read Vertex Z
append shadow_vert_array [vertex.x, vertex.y, vertex.z]								-- Add Vertex To Shadow Vertex Array
if mesh_name == "Listening_Post_Nub_R" then
(
print ("Vertex " + i as string + ": (" + vertex.x as string + ", " + vertex.y as string + ", " + vertex.z as string + ")")
)
)

shadow_faces = ReadLong file														-- Read Shadow Mesh Face Number
for i=1 to shadow_faces do 
(
normal.x = ReadFloat file
normal.y = ReadFloat file
normal.z = ReadFloat file
--fseek file 12 #seek_cur																-- Skip Face Normals
face.x = ReadLong file + 1															-- Read 1st Face Vertex
face.z = ReadLong file + 1															-- Read 2nd Face Vertex
face.y = ReadLong file + 1															-- Read 3rd Face Vertex
append shadow_face_array [face.x, face.y, face.z]									-- Add Face To Shadow Face Array
if mesh_name == "Listening_Post_Nub_R" then
(
print ("Normal " + i as string + ": (" + normal.x as string + ", " + normal.y as string + ", " + normal.z as string + ")")
print ("Face " + i as string + ": (" + face.x as string + ", " + face.y as string + ", " + face.z as string + ")")
)
)
print ("Shadow Faces: " + shadow_faces as string)

shadow_edges = ReadLong file														-- Read Shadow Mesh Edge Number
print ("Shadow Edges: " + shadow_edges as string)
for i=1 to shadow_edges do 
(
temp1 = ReadLong file
temp2 = ReadLong file
temp3 = ReadLong file
temp4 = ReadLong file
temp5 = ReadFloat file
temp6 = ReadFloat file
temp7 = ReadFloat file
temp8 = ReadFloat file
temp9 = ReadFloat file
temp10 = ReadFloat file
)

--shadow_mesh = mesh vertices:shadow_vert_array faces:shadow_face_array
--shadow_mesh.name = ("SHADOW_" + mesh_name)
--shadow_mesh.wireColor = (color 173 173 173)
--for i=1 to shadow_mesh.numfaces do setFaceSmoothGroup shadow_mesh i 0
*/
---< DATABVOL CHUNK >---

current_chunk = ReadChunkHeader file												-- Read DATABVOL Header
SkipChunk file current_chunk														-- Skip DATABVOL Chunk

---------------------
---[ CREATE MESH ]---
---------------------

---< CREATE MESH >---

new_mesh = mesh vertices:vert_array faces:face_array materialIDs:matid_array		-- Create New Mesh

---< SET BONE MESH >---

if (IsValidNode (bone = getNodeByName mesh_name exact:true)) == true then			-- Copy Pivot Point From Bone To Mesh
(
bone.setBoneEnable false 0
convertToMesh bone
attach bone new_mesh
meshop.deleteFaces bone #{1..14}
new_mesh = bone
setRenderable new_mesh true
new_mesh.setBoneEnable true 0
new_mesh.boneAutoAlign = false
new_mesh.boneScaleType = #none
)

---< MESH PROPERTIES >---

new_mesh.name = mesh_name															-- Set Name
new_mesh.wireColor = (color 28 89 177)												-- Set Color (Blue)
new_mesh.material = multimat														-- Set Material (Multi Material)

---< UVW MAP >---

setMesh new_mesh mesh tverts:uvw_array												-- Update Mesh With UVW Coordinates
buildTVFaces new_mesh																-- Create UVW Map
for i=1 to new_mesh.numfaces do
(
face = getFace new_mesh i															-- Get Each Face
setTVFace new_mesh i face.x face.y face.z											-- Set UVW Coordinates
setFaceSmoothGroup new_mesh i 0														-- Clear All Smoothing Groups
)

---< SKIN >---

if num_skin_bones > 0 then															-- Check If WHM File Contains Any Bones
(
if (skin_bone_array[1] as name) != (new_mesh.name as name) then						-- Mesh Is Not Weighted To Itself -> Create Skin
(
-- Create Skin Modifier
mod_skin = Skin filter_vertices:true filter_cross_sections:false filter_envelopes:false \
draw_all_gizmos:false envelopesAlwaysOnTop:false crossSectionsAlwaysOnTop:false showNoEnvelopes:true
-- Add Skin Modifier To Mesh
addModifier new_mesh mod_skin
max modify mode
select new_mesh

for i=1 to skin_bone_array.count do 
skinOps.addbone new_mesh.skin (getNodeByName skin_bone_array[i] exact:true) 0

select new_mesh
for i=1 to num_vertices do 
for j=1 to 4 do
if skin_vert_array[i].bone[j] != -1 then skinOps.SetVertexWeights new_mesh.skin i skin_vert_array[i].bone[j] skin_vert_array[i].weight[j]
)
else if num_skin_bones == 1 then setUserProp new_mesh "ForceSkinning" "Yes"			-- Mesh Is Weighted To Itself -> Force Skinning
)

update new_mesh																		-- Update Mesh
deselect new_mesh																	-- Deselect Mesh

--print (new_mesh.name + " - " + num_skin_bones as string + " - " + skin_bone_array as string)

---< WELD VERTICES >---

meshop.weldVertsByThreshold new_mesh new_mesh.verts 0.00000001						-- Weld Vertices

/*
current_vertex = 1
vertex = 1

while current_vertex <= new_mesh.numverts do
(
vertlist = #()
vertex = current_vertex
while vertex <= new_mesh.numverts do
(
if (getVert new_mesh vertex) == (getVert new_mesh current_vertex) then append vertlist vertex
vertex += 1
)
meshop.weldVertSet new_mesh vertlist
current_vertex += 1
)
*/
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_DATADATA > - Chunk Handler - Sub Chunk Of FOLDMSGR - Mesh List
--------------------------------------------------------------------------------------------

function CH_DATADATA file =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""							-- Currently Processed Chunk

maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"
dowpath = getINISetting (maxpath + "\WHMImport.ini") "Directories" "DawnOfWar"
modfolder = getINISetting (maxpath + "\WHMImport.ini") "Directories" "ModFolder"

num_meshes = ReadLong file																	-- Read Number Of Meshes

for i=1 to num_meshes do																	-- Read Each Mesh
(
mesh_name = ""																				-- Mesh Name
mesh_path = ""																				-- Mesh Path

mesh_name_length = ReadLong file															-- Read Mesh Name Length

for j=1 to mesh_name_length do mesh_name += bit.intAsChar (ReadByte file)					-- Read Mesh Name

mesh_path_length = ReadLong file	
																							-- Read Mesh Path Length
if mesh_path_length > 0 then
(
for j=1 to mesh_path_length do mesh_path += bit.intAsChar (ReadByte file)					-- Read Mesh Path

--filename = (dowpath + "/" + modfolder + "/Data/" + mesh_path + ".whm")
filename = ("../base_mesh/" + (filenameFromPath mesh_path) + ".whm")
--print ("Mesh: " + mesh_path)
--print ("Filename:" + filename)

xreffile = fopen filename "rbS"																-- Open WHM For Reading In Binary Format

if xreffile != undefined then
(
fseek xreffile 24 #seek_set																	-- Skip 'Relic Chunky' Header
chunk = ReadChunkHeader xreffile															-- Read 'File Burn Info' Header
SkipChunk xreffile chunk																	-- Skip 'File Burn Info' Chunk
chunk = ReadChunkHeader xreffile 															-- Skip 'Folder SGM' Header

while (chunk = ReadChunkHeader xreffile) != false do									-- Read Chunks Until End Of File
(
case chunk.typeid of
(
"DATASSHR": CH_DATASSHR xreffile																-- DATASSHR - Texture Data
"DATASKEL": CH_DATASKEL xreffile true																-- FOLDMSLC - Skeleton Data
"FOLDMSGR":
(
while (chunk = ReadChunkHeader xreffile) != false do									-- Read FOLDMSLC Chunks
(
case chunk.typeid of
(
"FOLDMSLC": 
(
if (chunk.name as name) != (mesh_name as name) then SkipChunk xreffile chunk
else CH_FOLDMSLC xreffile chunk.name true
)
"DATADATA": SkipChunk xreffile chunk
"DATABVOL":																					-- DATABVOL - Unknown
(
SkipChunk xreffile chunk
exit											
)
)
)
)
default: SkipChunk xreffile chunk 															-- Skipping Chunks By Default
)
)

fclose xreffile
)	
else messagebox "Can't open file!"															-- Show Error Msg Box

)

mesh_parent = ReadLong file																	-- Read Mesh Parent

if mesh_parent != -1 then
(
mesh = getNodeByName mesh_name exact:true													-- Get Mesh Node From The Scene
if mesh == created_bones_array[mesh_parent+1] then setUserProp mesh "ForceSkinning" "Yes"	-- Set Force Skinning If Parent Is The Same As Mesh
else mesh.parent = created_bones_array[mesh_parent+1]										-- Else Set New Parent
)

--print (mesh_name as string + " -|- " + mesh_path as string + " -|- " + mesh_parent as string)
)
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDMSGR > - Chunk Handler - Mesh Data
--------------------------------------------------------------------------------------------

function CH_FOLDMSGR file =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Processed Chunk

while (current_chunk = ReadChunkHeader file) != false do									-- Read FOLDMSLC Chunks
(
case current_chunk.typeid of
(
"FOLDMSLC": CH_FOLDMSLC file current_chunk.name	false										-- FOLDMSLC - Mesh Data
"DATADATA": CH_DATADATA file																-- DATADATA - Mesh List
"DATABVOL":																					-- DATABVOL - Unknown
(
SkipChunk file current_chunk
return true												
)
)
)
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_DATAMARK > - Chunk Handler - Marker Data
--------------------------------------------------------------------------------------------

function CH_DATAMARK file =
(
num_markers = 0																				-- Number Of Markers
markermat = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])										-- Marker Matrix
struct markerdata (name, parent)															-- Structure To Hold Marker Data

num_markers = ReadLong file																	-- Read Number Of Markers

for i=1 to num_markers do																	-- Read All Markers
(
zero markermat																				-- Reset Marker Matrix
marker = markerdata name:"" parent:"" 														-- Reset Markerdata Structure

markernamelength = ReadLong file															-- Read Marker Name length
for j=1 to markernamelength do																-- Read Marker Name
(
buffer = ReadByte file
char = bit.intAsChar buffer
marker.name += char
)

parentnamelength = ReadLong file															-- Read Parent Name length
for j=1 to parentnamelength do																-- Read Parent Name
(
buffer = ReadByte file
char = bit.intAsChar buffer
marker.parent += char
)

markermat.row1 = (point3 (ReadFloat file) (ReadFloat file) (ReadFloat file))				-- Read 1st Row Of The Matrix
markermat.row2 = (point3 (ReadFloat file) (ReadFloat file) (ReadFloat file))				-- Read 2nd Row Of The Matrix
markermat.row3 = (point3 (ReadFloat file) (ReadFloat file) (ReadFloat file))				-- Read 3rd Row Of The Matrix
markermat.row4 = (point3 (ReadFloat file) (ReadFloat file) (ReadFloat file))				-- Read 4th Row Of The Matrix

newmarker = point size:10																	-- Create New Point Helper With Size 10
newmarker.scale = [0.03, 0.03, 0.03]														-- Set Scale Of New Marker
newmarker.wireColor = (color 14 255 2)														-- Set Color Of New Marker

if (IsValidNode (bone = getNodeByName marker.name exact:true)) == true then
(
newmarker.setBoneEnable true 0
newmarker.boneScaleType = #none
while bone.children.count > 0 do append newmarker.children bone.children[1]
delete bone
)

newmarker.name = marker.name																-- Set Name Of New Marker
--if IsValidNode (getNodeByName marker.parent exact:true) then
newmarker.parent = getNodeByName marker.parent exact:true									-- Set Parent Of New Marker
--else newmarker.parent = created_bones_array[1]

if marker.parent != "" then 																-- Set Position & Rotation For Linked Markers
(
markermat.row1.y *= -1																		-- Inverse Matrix[1][2]
markermat.row1.z *= -1																		-- Inverse Matrix[1][3]
markermat.row2.x *= -1																		-- Inverse Matrix[2][1]
markermat.row3.x *= -1																		-- Inverse Matrix[3][1]
markermat.row4.x *= -1																		-- Inverse Matrix[4][1]
markerrot = markermat as quat																-- Get Rotation Part Of The Matrix
markerpos = markermat.translationpart														-- Get Translation Part Of The Matrix
markerrot.w *= -1																			-- Inverse W
in coordsys parent newmarker.rotation = markerrot											-- Set Rotation In Parent Coordsys
in coordsys parent newmarker.pos = markerpos												-- Set Position In Parent Coordsys
)
else if marker.parent == "" or newmarker.parent == undefined then							-- Set Position & Rotation For Non Linked Markers
(
markerrot = markermat as quat																-- Get Rotation Part Of The Matrix	
markerrot = markerrot as matrix3															-- Convert To Matrix3
mat = matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
newmat = mat * markerrot * (inverse mat)
newmat = newmat as quat																		-- Convert To Quat
newmarker.rotation = (inverse newmat)														-- Set Rotation In World Coordinates
rot = eulerangles 90 0 0																	-- Rotate Marker By 90* On X
in coordsys local rotate newmarker rot														-- Rotate Marker In Local Coordinates

markerpos = markermat.translationpart														-- Get Translation Part Of The Matrix
newmarker.pos = (point3 -markerpos.x -markerpos.z markerpos.y)								-- Set Position In World Coordinates
)
)
										
if (marker_icon = getNodeByName "marker_icon" exact:true) != undefined then					-- Link Marker Icon
if marker_icon.parent == undefined then marker_icon.parent = (getNodeByName "master" exact:true)
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CH_FOLDANIM > - Chunk Handler - Animations
--------------------------------------------------------------------------------------------

function CH_FOLDANIM file =
(
-- Structure Holding Chunk Header Data
struct chunkheader (typeid, version, size, namelength, name)
-- Currently Readed Chunk
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""

poskeys_array = #()
struct strposkeys (frame, key_pos_x, key_pos_y, key_pos_z)

---< DATADATA >---

current_chunk = ReadChunkHeader file														-- Read DATADATA Chunk Header
--print ("Name:" + current_chunk.name)														-- This will be the name of animations file...

num_frames = ReadLong file																	-- Read Number Of Frames
animationRange = interval 0 (num_frames - 1)												-- Set Start & End Frames
--print ("Frames: " + num_frames as string)
fseek file 4 #seek_cur																		-- Skip 4 Bytes (Unknown)

---< BONES >---

num_bones = ReadLong file																	-- Read Number Of Bones
--print ("Bones: " + num_bones as string)

for i=1 to num_bones do																		-- Read Bones
(
bone_name = ""																				-- Clear Bone Name
bone_name_length = ReadLong file															-- Read Bone Name Length
for j=1 to bone_name_length do bone_name += bit.intAsChar (ReadByte file)					-- Read Bone Name	
bone = getNodeByName bone_name exact:true
--print ("Bone " + i as string + ": " + bone_name)

keys_pos = ReadLong file																	-- Read Number Of Postion Keys
--print ("Keys pos: " + keys_pos as string)

while poskeys_array.count > 0 do deleteItem poskeys_array 1

for j=1 to keys_pos do																		-- Read Postion Keys
(
poskey = strposkeys frame:0 key_pos_x:0 key_pos_y:0 key_pos_z:0
poskey.frame = floor (ReadFloat file * num_frames)	
if poskey.frame == num_frames then poskey.frame -= 1
poskey.key_pos_x = ReadFloat file															-- Read Position X
poskey.key_pos_y = ReadFloat file															-- Read Position Y
poskey.key_pos_z = ReadFloat file															-- Read Position Z
append poskeys_array poskey	

--print ("Pos Frame " + poskeys.frame as string + ": " + "[" + (-poskeys.key_pos_x) as string + ", " + poskeys.key_pos_y as string + ", " + poskeys.key_pos_z as string + "]")
--print ("Pos Frame " + poskey.frame as string + ": " + "[" + (-poskey.key_pos_x) as string + ", " + (-poskey.key_pos_z) as string + ", " + poskey.key_pos_y as string + "]")
)

keys_rot = ReadLong file																	-- Read Number Of Rotation Keys
--print ("Keys rot: " + keys_rot as string)

bone_pos = bone.pos
--bone.rotation.controller = tcb_rotation()

for j=1 to keys_rot do																		-- Read Rotation Keys
(
frame = floor (ReadFloat file * num_frames)													-- Read Frame Number
if frame == num_frames then frame -= 1

key_rot_x = ReadFloat file																	-- Read Rotation X
key_rot_y = ReadFloat file																	-- Read Rotation Y
key_rot_z = ReadFloat file																	-- Read Rotation Z
key_rot_w = ReadFloat file																	-- Read Rotation W
--print ("Rot Frame " + frame as string + ": " + "[" + key_rot_x as string + ", " + key_rot_y as string + ", " + key_rot_z as string + ", " + key_rot_w as string + "]")

if bone.parent != undefined and bone.parent.name != "Master" then
(
newmat = (matrix3 [0,0,0] [0,0,0] [0,0,0] [0,0,0])											-- Create Zero Matrix

bonequat = (quat key_rot_x key_rot_y key_rot_z key_rot_w) as matrix3						-- Turn Quat Into Matrix
newmat.row1 = (point3 bonequat[1][1] -bonequat[2][1] -bonequat[3][1])						-- Set 1st Row
newmat.row2 = (point3 -bonequat[1][2] bonequat[2][2] bonequat[3][2])						-- Set 2nd Row
newmat.row3 = (point3 -bonequat[1][3] bonequat[2][3] bonequat[3][3])						-- Set 3rd Row
newmat.row4 = bone.pos																		-- Set 4th Row

newrot = newmat as quat																		-- Get Rotation Part From Matrix
newrot.w *= -1																				-- Negate Rotation W

animate on at time frame in coordsys parent bone.rotation = newrot							-- Set Child Bone Rotation

bone.pos = bone_pos
)
else if bone.parent == undefined or bone.parent.name == "Master" then
(
rotmat = (quat key_rot_x key_rot_y key_rot_z key_rot_w) as matrix3
rotmat = inverse rotmat
mat = matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
newmat = mat * rotmat * (inverse mat)
newmat = newmat as quat
animate on at time frame bone.rotation = (inverse newmat)
rot = eulerangles 90 0 0
animate on at time frame in coordsys local rotate bone rot		
--print ("Rot Frame " + frame as string + ": " + bone.rotation as string)
bone.pos = bone_pos
)
)

while bone.pos.controller.keys.count > 0 do 												-- Clear All Position Keys
deleteKey bone.pos.controller bone.pos.controller.keys.count

--bone.pos.controller = linear_position()

for j=1 to keys_pos do																		
(
if bone.parent != undefined and bone.parent.name != "Master" then
(
animate on at time poskeys_array[j].frame in coordsys parent bone.pos = [-poskeys_array[j].key_pos_x, poskeys_array[j].key_pos_y, poskeys_array[j].key_pos_z]
)
else if bone.parent == undefined or bone.parent.name == "Master" then
(
animate on at time poskeys_array[j].frame bone.pos = [-poskeys_array[j].key_pos_x, -poskeys_array[j].key_pos_z, poskeys_array[j].key_pos_y]
)
)

stale = ReadByte file																		-- Read Stale Property
if stale == 0 then setUserProp bone "Stale" "Yes"											-- Set Stale Property
--print ("Stale: " + stale as string)
)

---< MESHES & TEXTURES >---

visible_meshes = #()

num_meshes = ReadLong file																	-- Read Number Of Meshes
--print ("Meshes: " + num_meshes as string)

for i=1 to num_meshes do																	-- Read Bones
(
mesh_name = ""																				-- Clear Mesh Name
mesh_name_length = ReadLong file															-- Read Mesh Name Length
for j=1 to mesh_name_length do mesh_name += bit.intAsChar (ReadByte file)					-- Read Mesh Name
--print ("Mesh " + i as string + ": " + mesh_name)

if (IsValidNode (mesh = getNodeByName mesh_name exact:true)) == true then 					-- Mesh
(
fseek file 12 #seek_cur																		-- Skip 12 Bytes (Unknown)
keys_vis = ReadLong file - 1																-- Read Number Of Visibility Keys
--print ("Keys vis: " + keys_vis as string)
fseek file 4 #seek_cur																		-- Skip 4 Bytes (Unknown)
force_invisible = ReadFloat file															-- Read ForceInvisible Property
if force_invisible == 0 then
(
if (findItem visible_meshes mesh_name) == 0 then setUserProp mesh "ForceInvisible" "Yes"	-- Set ForceInvisible Property				
)
else append visible_meshes mesh_name							
--print ("Force invisible: " + force_invisible as string)

if keys_vis > 0 then 
(
mesh.visibility = bezier_float() 
animate on at time 0 mesh.visibility.controller.value = 1.0
)

for j=1 to keys_vis do																		-- Read Visibility Keys
(
frame = floor (ReadFloat file * num_frames)													-- Read Frame Number
if frame == num_frames then frame -= 1
key_vis = ReadFloat file																	-- Read Visibility
animate on at time frame mesh.visibility.controller.value = key_vis
--print ("Vis Frame " + frame as string + ": " + key_vis as string)
)
)
else																						-- Texture
(
fseek file 8 #seek_cur																		-- Skip 8 Bytes (Unknown)
tex_anim_type = ReadLong file																-- 1-U 2-V 3-TileU 4-TileV
keys_tex = ReadLong file																	-- Read Number Of Texture Keys
--print ("Keys tex: " + keys_tex as string)
--print ("Tex anim type: " + tex_anim_type as string)

mat = 0

for j=1 to meditMaterials[1].count do
(
temp_str = ""
temp_str_array = filterString mesh_name "/"
for k=1 to temp_str_array.count do append temp_str ("\\" + temp_str_array[k])
if (findString meditMaterials[1].materialList[j].diffuseMap.fileName temp_str) != undefined then
mat = meditMaterials[1].materialList[j]
)

for j=1 to keys_tex do																		-- Read Texture Keys
(
frame = floor (ReadFloat file * num_frames)													-- Read Frame Number
if frame == num_frames then frame -= 1
key_tex = ReadFloat file																	-- Read Offset
--print ("Tex Frame " + frame as string + ": " + key_tex as string)

case tex_anim_type of
(
1: animate on at time frame mat.diffuseMap.coords.U_Offset = -key_tex
2: animate on at time frame mat.diffuseMap.coords.V_Offset = -key_tex
3: animate on at time frame mat.diffuseMap.coords.U_Tiling = -key_tex
4: animate on at time frame mat.diffuseMap.coords.V_Tiling = -key_tex
)
)
)
)

---< CAMERA >---

if current_chunk.version == 2 then															-- Read Camera Data If DATADATA Chunk Version 2
(
num_cams = ReadLong file																	-- Read Number Of Cameras
--print ("Cams:" + num_cams as string)

for k=1 to num_cams do																		-- Read Cameras
(
cam_name = ""																				-- Clear Camera Name
cam_name_length = ReadLong file																-- Read Camera Name Length
for j=1 to cam_name_length do cam_name += bit.intAsChar (ReadByte file)						-- Read Camera Name
--print ("Cam " + k as string + ": " + cam_name)
cam_pos_keys = ReadLong file																-- Read Number Of Camera Position Keys (?)
for j=1 to cam_pos_keys do fseek file 16 #seek_cur											-- Skip Camera Position Keys
cam_rot_keys = ReadLong file																-- Read Number Of Camera Rotation Keys (?)
for j=1 to cam_rot_keys do fseek file 20 #seek_cur											-- Skip Camera Rotation Keys
)
)

---< DATAANBV >---

current_chunk = ReadChunkHeader file														-- Read DATAANBV Chunk Header
fseek file current_chunk.size #seek_cur														-- Skip DATAANBV Chunk
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < SHADOW_FOLDMSLC > - Chunk Handler - FOLDMSLC Sub Chunk - Mesh Data
---------------------------------------------------------------------------------------------

function SHADOW_FOLDMSLC whmfile tmpwhmfile chunk =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""					-- Currently Readed Chunk

foldmslc_chunk_pos = ftell tmpwhmfile

foldmslc_size_pos = (ftell tmpwhmfile) + 12													-- Store FOLDMSLC Chunk Header Size Position

WriteChunkHeader tmpwhmfile	chunk															-- Write FOLDMSLC Chunk Header To Temp WHM File

foldmslc_data_pos = ftell tmpwhmfile

---< DATADATA CHUNK >---

datadata_size_pos = (ftell tmpwhmfile) + 12													-- Store DATADATA Chunk Header Size Position

current_chunk = ReadChunkHeader whmfile														-- Read DATADATA Chunk Header From WHM File
WriteChunkHeader tmpwhmfile	current_chunk													-- Write DATADATA Chunk Header To Temp WHM File

datadata_data_pos = ftell tmpwhmfile

for i=1 to 13 do WriteByte tmpwhmfile (ReadByte whmfile)									-- Copy 13 Bytes (Unknown)

---< SKIN BONES >---

num_skin_bones = ReadLong whmfile															-- Read Number Of Skin Bones From WHM File
WriteLong tmpwhmfile num_skin_bones															-- Write Number Of Skin Bones To Temp WHM File

for i=1 to num_skin_bones do
(
bone_name_length = ReadLong whmfile															-- Read Bone Name Length From WHM File
WriteLong tmpwhmfile bone_name_length														-- Write Bone Name Length To Temp WHM File
for j=1 to bone_name_length do WriteByte tmpwhmfile (ReadByte whmfile)						-- Copy Bone Name
WriteLong tmpwhmfile (ReadLong whmfile)														-- Copy 4 Bytes (Unknown)										
)

---< VERTICES >---

num_vertices = ReadLong whmfile																-- Read Number Of Vertices From WHM File
WriteLong tmpwhmfile num_vertices															-- Write Number Of Vertices To Temp WHM File
WriteLong tmpwhmfile (ReadLong whmfile)														-- Copy 4 Bytes (Unknown)

for i=1 to num_vertices do for j=1 to 12 do WriteByte tmpwhmfile (ReadByte whmfile)			-- Copy Vertices
									
---< SKIN >---

if num_skin_bones != 0 then 
for i=1 to num_vertices do for j=1 to 16 do WriteByte tmpwhmfile (ReadByte whmfile)			-- Copy Bone Weights

---< NORMALS >---

for i=1 to num_vertices do for j=1 to 12 do WriteByte tmpwhmfile (ReadByte whmfile)			-- Copy Normals

---< UVW MAP >---

for i=1 to num_vertices do for j=1 to 8 do WriteByte tmpwhmfile (ReadByte whmfile)			-- Copy UVW Map

WriteLong tmpwhmfile (ReadLong whmfile)														-- Copy 4 Bytes (Unknown)

---< MATERIALS >---

num_materials = ReadLong whmfile															-- Read Number Of Materials From WHM File
WriteLong tmpwhmfile num_materials															-- Write Number Of Materials To Temp WHM File

for i=1 to num_materials do
(
texture_path_length = ReadLong whmfile														-- Read Texture Name Length From WHM File
WriteLong tmpwhmfile texture_path_length													-- Write Texture Name Length To Temp WHM File
for j=1 to texture_path_length do WriteByte tmpwhmfile (ReadByte whmfile)					-- Copy Texture Name

num_faces = (ReadLong whmfile) / 3															-- Read Number Of Faces For This Material
WriteLong tmpwhmfile (num_faces * 3)														-- Write Number Of Faces To Temp WHM File

for j=1 to num_faces do	for k=1 to 6 do WriteByte tmpwhmfile (ReadByte whmfile)				-- Copy Faces

for j=1 to 8 do	WriteByte tmpwhmfile (ReadByte whmfile)										-- Copy 8 Bytes (Unknown)
)

---< SHADOW VOLUME >---

mesh_node = getNodeByName chunk.name exact:true												-- Select Mesh

--------------------------------------------------------------------------------------------

shadow_verts = ReadLong whmfile																-- Skip Shadow Mesh Vertex Number From WHM File
for i=1 to shadow_verts do for j=1 to 12 do ReadByte whmfile								-- Skip Shadow Mesh Vertices

if mesh_node != undefined and (getUserProp mesh_node "ShadowVolume") != "No" then						
(

vertex = point3 0 0 0

WriteLong tmpwhmfile mesh_node.numverts														-- Write Shadow Mesh Vertex Number To Temp WHM File

for i=1 to mesh_node.numverts do
(
vertex = getVert mesh_node i
WriteFloat tmpwhmfile -vertex.x
WriteFloat tmpwhmfile vertex.z
WriteFloat tmpwhmfile -vertex.y
)
)
else WriteLong tmpwhmfile 0

--------------------------------------------------------------------------------------------

shadow_faces = ReadLong whmfile
for i=1 to shadow_faces do for j=1 to 24 do ReadByte whmfile

if mesh_node != undefined and (getUserProp mesh_node "ShadowVolume") != "No" then						
(
normal = point3 0 0 0

WriteLong tmpwhmfile mesh_node.numfaces

for i=1 to mesh_node.numfaces do
(
normal = getFaceNormal mesh_node i
WriteFloat tmpwhmfile -normal.x
WriteFloat tmpwhmfile normal.z
WriteFloat tmpwhmfile -normal.y
face_vertices = getFace mesh_node i
WriteLong tmpwhmfile (face_vertices.x - 1)
WriteLong tmpwhmfile (face_vertices.z - 1)
WriteLong tmpwhmfile (face_vertices.y - 1)
)
)
else WriteLong tmpwhmfile 0

--------------------------------------------------------------------------------------------

shadow_edges = ReadLong whmfile																-- Read Shadow Mesh Edge Number From WHM File
for i=1 to shadow_edges do for j=1 to 40 do ReadByte whmfile

if mesh_node != undefined and (getUserProp mesh_node "ShadowVolume") != "No" then						
(
edges = #()

for i=1 to mesh_node.numfaces do
(
face_edges = (meshop.getEdgesUsingFace mesh_node i) as array

edge = meshop.getEdgesReverseEdge mesh_node face_edges[3]
face = (meshop.getFacesUsingEdge mesh_node edge) as array
if face.count != 0 then if face[1] > i then append edges face_edges[3]

edge = meshop.getEdgesReverseEdge mesh_node face_edges[2]
face = (meshop.getFacesUsingEdge mesh_node edge) as array
if face.count != 0 then if face[1] > i then append edges face_edges[2]

edge = meshop.getEdgesReverseEdge mesh_node face_edges[1]
face = (meshop.getFacesUsingEdge mesh_node edge) as array
if face.count != 0 then if face[1] > i then append edges face_edges[1]
)

WriteLong tmpwhmfile edges.count

for i=1 to edges.count do
(
edge_verts = (meshop.getVertsUsingEdge mesh_node edges[i]) as array
edge2 = meshop.getEdgesReverseEdge mesh_node edges[i]
face1 = (meshop.getFacesUsingEdge mesh_node edges[i]) as array
face2 = (meshop.getFacesUsingEdge mesh_node edge2) as array
vert1 = getVert mesh_node edge_verts[1]
vert2 = getVert mesh_node edge_verts[2]

WriteLong tmpwhmfile (edge_verts[1]-1)
WriteLong tmpwhmfile (edge_verts[2]-1)
WriteLong tmpwhmfile (face1[1]-1)
WriteLong tmpwhmfile (face2[1]-1)
WriteFloat tmpwhmfile -vert1.x
WriteFloat tmpwhmfile vert1.z
WriteFloat tmpwhmfile -vert1.y
WriteFloat tmpwhmfile -vert2.x
WriteFloat tmpwhmfile vert2.z
WriteFloat tmpwhmfile -vert2.y
)
)
else WriteLong tmpwhmfile 0

--------------------------------------------------------------------------------------------

datadata_end_pos = ftell tmpwhmfile

current_file_pos = ftell tmpwhmfile
fseek tmpwhmfile datadata_size_pos #seek_set												-- Move To DATADATA Chunk Header Size
WriteLong tmpwhmfile (datadata_end_pos - datadata_data_pos)									-- Write New DATADATA Chunk Size To Temp WHM File
fseek tmpwhmfile current_file_pos #seek_set

---< DATABVOL CHUNK >---

current_chunk = ReadChunkHeader whmfile														-- Read DATABVOL Chunk Header From WHM File
CopyChunk whmfile tmpwhmfile current_chunk													-- Copy DATABVOL Chunk Header To Temp WHM File

foldmslc_end_pos = ftell tmpwhmfile

current_file_pos = ftell tmpwhmfile
fseek tmpwhmfile foldmslc_size_pos #seek_set												-- Move To DATADATA Chunk Header Size
WriteLong tmpwhmfile (foldmslc_end_pos - foldmslc_data_pos)									-- Write New DATADATA Chunk Size To Temp WHM File
fseek tmpwhmfile current_file_pos #seek_set

return (foldmslc_end_pos - foldmslc_chunk_pos)
)

--------------------------------------------------------------------------------------------
--------------------------------------[ BEGIN SCRIPT ]--------------------------------------
--------------------------------------------------------------------------------------------

utility WHMImport "WHM Import"																-- WHM Import Utility
(
-------------------
---[ VARIABLES ]---
-------------------

struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
local current_chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""			-- Currently Processed Chunk

-------------
---[ GUI ]---
-------------

button import "Import WHM" width:120 														-- Create [Import WHM] Button
button dowdir "Set Dawn of War Dir" width:120												-- Create [Set Dawn of War Dir] Button
button moddir "Set Mod Dir" width:120														-- Create [Set Mod Dir] Button
button fixskin "Fix Skin" width:120															-- Create [Fix Skin] Button
button shadowvolume "Shadow Volumes" width:120												-- Create [Shadow Volume] Button

----------------
---[ EVENTS ]---
----------------
-----------------------------------------------
---< EVENT >--- Button Pressed - [ Import WHM ]
-----------------------------------------------

on import pressed do																		-- Button [Import WHM] Pressed
(
bone_array = #()
xref_bone_array = #()
created_bones_array = #()
multimat = multimaterial numsubs:1

maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get MAX Path
LastDir = getINISetting (maxpath + "\WHMImport.ini") "Directories" "LastDir"				-- Read Last Directory
dowpath = getINISetting (maxpath + "\WHMImport.ini") "Directories" "DawnOfWar"
modfolder = getINISetting (maxpath + "\WHMImport.ini") "Directories" "ModFolder"

-- Show 'Open File' Dialog & Get WHM File To Import
filename = getOpenFileName caption:"Select a WHM file to import..." filename:LastDir types:"WHM (*.whm)|*.whm"

if filename != undefined then																-- Check If User Selected A File
(
setINISetting (maxpath + "\WHMImport.ini") "Directories" "LastDir" filename
resetMaxFile #noPrompt																		-- Reset MAX

local file = fopen filename "rbS"															-- Open WHM For Reading In Binary Format

if file != undefined then																	-- Check If File Is Opened
(
save_path = getSavePath caption:"Select where to save your file..."							-- Show 'Select Folder' Dialog
if save_path != undefined then
(
makeDir (save_path + "\\Reference")
makeDir (save_path + "\\Animations")

progressStart "Import progress:"

print "Importing..."
fseek file 24 #seek_set																		-- Skip 'Relic Chunky' Header
current_chunk = ReadChunkHeader file														-- Read 'File Burn Info' Header
SkipChunk file current_chunk																-- Skip 'File Burn Info' Chunk
fbisize = current_chunk.size + 33															-- File Burn Info Size + File Burn Info Header Size
current_chunk = ReadChunkHeader file														-- Skip 'Folder SGM' Header

texture_count = 0																			-- Reset Texture Count
texture_array = #()																			-- Clear Texture Array
bone_array = #()																			-- Clear Bone Array
multimat.numsubs = 1																		-- Reset Multi Material
setMeditMaterial 1 multimat																	-- Add Multi Material To First Material Editor Slot
num_anims = 0	
anim_count = 0																			

while (current_chunk = ReadChunkHeader file) != false do									-- Read Chunks Until End Of File
(
case current_chunk.typeid of
(
"DATASSHR": CH_DATASSHR file																-- DATASSHR - Texture Data
"FOLDTXTR": CH_FOLDTXTR file current_chunk save_path										-- FOLDTXTR - Internal Texture
"DATASKEL": CH_DATASKEL file false															-- FOLDMSLC - Skeleton Data
"FOLDMSGR": CH_FOLDMSGR file																-- FOLDMSGR - Mesh Data
"DATAMARK": CH_DATAMARK file																-- DATAMARK - Marker Data
"FOLDANIM": 
(
SkipChunk file current_chunk
num_anims += 1
)
default: SkipChunk file current_chunk 														-- Skipping Chunks By Default
)
)

print txtr_array
print shdr_array

multimat.numsubs -= 1 																		-- Delete Empty Sub Material
for obj in objects do if obj.boneEnable == true then obj.resetBoneStretch() 				-- Reset Bones Stretch
animationRange = interval 0 1																-- Set Start & End Frames
max tool zoomextents all																	-- Zoom Extents All Viewports
max tool zoomextents all																	-- Zoom Extents All Viewports

saveMaxFile (save_path + "\\Reference\\Ref.max")

progressUpdate (100.0 * 1 / (num_anims + 1))

fseek file 0 #seek_set																		-- Rewind File

fseek file 24 #seek_set																		-- Skip 'Relic Chunky' Header
current_chunk = ReadChunkHeader file														-- Read 'File Burn Info' Header
SkipChunk file current_chunk																-- Skip 'File Burn Info' Chunk
fbisize = current_chunk.size + 33															-- File Burn Info Size + File Burn Info Header Size
current_chunk = ReadChunkHeader file														-- Skip 'Folder SGM' Header

while (current_chunk = ReadChunkHeader file) != false do									-- Read Chunks Until End Of File
(
case current_chunk.typeid of
(
"FOLDANIM": 
(
loadMaxFile (save_path + "\\Reference\\Ref.max")
CH_FOLDANIM file																			-- FOLDANIM - Animations
saveMaxFile (save_path + "\\Animations\\" + current_chunk.name +".max") useNewFile:false
anim_count += 1
progressUpdate (100.0 * anim_count / (num_anims + 1))
)
default: SkipChunk file current_chunk 														-- Skipping Chunks By Default
)
)

loadMaxFile (save_path + "\\Reference\\Ref.max")

progressEnd()

fclose file																					-- Close WHM File

print "Import successful!"
)
)
else messagebox "Can't open file!"															-- Show Error Msg Box & Terminate Script
)
)

--------------------------------------------------------
---< EVENT >--- Button Pressed - [ Set Dawn of War Dir ]
--------------------------------------------------------

on dowdir pressed do																		-- Button 'Set Dawn of War Dir'
(
dowpath = getSavePath caption:"Select your Dawn of War folder..."							-- Show 'Select Folder' Dialog & Get DoW Path
if dowpath != undefined then
(
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get MAX Path
setINISetting (maxpath + "\WHMImport.ini") "Directories" "DawnOfWar" dowpath				-- Write DoW Path to INI File
)
)

------------------------------------------------
---< EVENT >--- Button Pressed - [ Set Mod Dir ]
------------------------------------------------

on moddir pressed do																		-- Button 'Set Mod Dir'
(
modfolder = getSavePath caption:"Select your Mod folder..."									-- Show 'Select Folder' Dialog & Get Mod Path
if modfolder != undefined then
(
modfolder_path_array = filterString modfolder "\\"											-- Filter Mod Path by '\\'
modfolder = modfolder_path_array[modfolder_path_array.count]								-- Get Mod Folder
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get MAX Path
setINISetting (maxpath + "\WHMImport.ini") "Directories" "ModFolder" modfolder				-- Write Mod Folder to INI File
)
)

---------------------------------------------
---< EVENT >--- Button Pressed - [ Fix Skin ]
---------------------------------------------

on fixskin pressed do																		-- Button 'Fix Skin'
(
envfilelist = #()
reffilename = getOpenFileName caption:"Select a REF.MAX file to open..." filename:"REF.MAX" types:"REF.MAX|REF.MAX"
--print reffilename
loadMaxFile reffilename
for obj in objects do 
(
if obj.modifiers[#Skin] != undefined then
(
--print obj.name
select obj
setCommandPanelTaskMode mode:#modify
modPanel.setCurrentObject obj.skin node:obj
skinOps.saveEnvelope obj.skin (obj.name + ".env")
append envfilelist (obj.name + ".env")
)
)

animationfiles = getFiles "../Animations/*.max"

for f in animationfiles do 
(
loadMAXFile f

for obj in objects do 
(
if obj.modifiers[#Skin] != undefined then
(
select obj
setCommandPanelTaskMode mode:#modify
modPanel.setCurrentObject obj.skin node:obj
if (findItem envfilelist (obj.name + ".env")) != 0 then
skinOps.loadEnvelope obj.skin ("../Reference/" + obj.name + ".env")
saveMaxFile f useNewFile:false
)
)
)
for i=1 to envfilelist.count do deleteFile ("../Reference/" + envfilelist[i])
loadMaxFile reffilename
)

----------------------------------------------------
---< EVENT >--- Button Pressed - [ Shadow Volume ]
----------------------------------------------------

on shadowvolume pressed do																	-- Button [Shadow Volume] Pressed
(
maxpath = getINISetting (getMAXIniFile()) "Directories" "Startup Scripts"					-- Get MAX Path

LastShadowDir = getINISetting (maxpath + "\WHMImport.ini") "Directories" "LastShadowDir"	-- Read Last Shadow Directory

-- Show 'Open File' Dialog & Get WHM File To Open
filename = getOpenFileName caption:"Select a WHM file..." filename:LastShadowDir types:"WHM (*.whm)|*.whm"

if filename != undefined then																-- Check If User Selected A File
(
setINISetting (maxpath + "\WHMImport.ini") "Directories" "LastShadowDir" filename			-- Set Last Shadow Directory

tmpfilename = (filename + ".tmp")															-- Set Temp WHM Filename

whmfile = fopen filename "rbS"																-- Open WHM File For Reading In Binary Format
tmpwhmfile = fopen tmpfilename "wbS"														-- Create Temp WHM File For Writing In Binary Format

if whmfile != undefined then
(
for i=1 to 24 do																			-- Copy 'Relic Chunky' Header From WHM To Temp WHM
(
byte = ReadByte whmfile																		-- Read Byte From WHM File
WriteByte tmpwhmfile byte																	-- Write Byte To Temp WHM File
)
current_chunk = ReadChunkHeader whmfile														-- Read 'File Burn Info' Chunk Header From WHM File
CopyChunk whmfile tmpwhmfile current_chunk													-- Copy 'File Burn Info' Chunk To Temp WHM File
fbi_size = 20 + current_chunk.namelength + current_chunk.size								-- Calculate 'File Burn Info' Chunk Size
current_chunk = ReadChunkHeader whmfile														-- Read FOLDRSGM Chunk Header From WHM File
WriteChunkHeader tmpwhmfile	current_chunk													-- Write FOLDRSGM Chunk Header To Temp WHM File														
foldrsgm_header = current_chunk																-- Store FOLDRSGM Header For Later Use
foldrsgm_pos = (ftell tmpwhmfile) - 8 - current_chunk.namelength							-- Calculate FOLDRSGM Chunk Offset

new_foldmsgr_size = 0

while (current_chunk = ReadChunkHeader whmfile) != false do									-- Get Next Chunk Until End Of File
(
case current_chunk.typeid of
(
"FOLDMSGR": 
(
foldmsgr_size_pos = (ftell tmpwhmfile) + 12													-- Store FOLDMSGR Chunk Header Size Position
WriteChunkHeader tmpwhmfile	current_chunk													-- Write FOLDMSGR Chunk Header To Temp WHM File
foldmsgr_data_pos = ftell tmpwhmfile
)
"FOLDMSLC": new_foldmsgr_size += (SHADOW_FOLDMSLC whmfile tmpwhmfile current_chunk)			-- FOLDMSLC - Mesh Data
default: CopyChunk whmfile tmpwhmfile current_chunk											-- Copy Chunk From WHM To Temp WHM By Default
)
)

fclose tmpwhmfile

tmpwhmfile = fopen tmpfilename "rbS"

fseek tmpwhmfile foldmsgr_data_pos #seek_set												-- Move To The End Of Temp WHM File
fseek tmpwhmfile new_foldmsgr_size #seek_cur
current_chunk = ReadChunkHeader tmpwhmfile
new_foldmsgr_size += 20 + current_chunk.namelength + current_chunk.size
SkipChunk tmpwhmfile current_chunk
current_chunk = ReadChunkHeader tmpwhmfile
new_foldmsgr_size += 20 + current_chunk.namelength + current_chunk.size

fclose tmpwhmfile

tmpwhmfile = fopen tmpfilename "rb+"	

fseek tmpwhmfile foldmsgr_size_pos #seek_set												-- Move To The End Of Temp WHM File
WriteLong tmpwhmfile new_foldmsgr_size														-- Write New FOLDMSGR Size To Temp WHM File

fseek tmpwhmfile 0 #seek_end																-- Move To The End Of Temp WHM File
new_foldrsgm_size = ftell tmpwhmfile-24-fbi_size-20-foldrsgm_header.namelength				-- Get New FOLDRSGM Size
fseek tmpwhmfile foldrsgm_pos #seek_set														-- Move To FOLDRSGM Chunk Header Size
WriteLong tmpwhmfile new_foldrsgm_size														-- Write New FOLDRSGM Size To Temp WHM File

fclose tmpwhmfile																			-- Close Temp WHM File
fclose whmfile																				-- Close WHM File
deleteFile filename																			-- Delete WHM File
renameFile tmpfilename filename																-- Rename Temp WHM File To WHM File Name

messagebox "Shadow Volumes Created!"														-- Show MsgBox
)
else messagebox "Can't open WHM file!"		
)
)										

)

--------------------------------------------------------------------------------------------
---------------------------------------[ END SCRIPT ]---------------------------------------
--------------------------------------------------------------------------------------------