--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Relic Chunk Lib
-- by Brother Santos
--
-- Version 1.0
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
--------------------------------------[ BEGIN SCRIPT ]--------------------------------------
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < ReadChunkHeader > - Read Next Chunk Header
--------------------------------------------------------------------------------------------

function ReadChunkHeader file =
(
struct chunkheader (typeid, version, size, namelength, name)								-- Structure Holding Chunk Header Data
chunk = chunkheader typeid:"" version:0 size:0 namelength:0 name:""							-- Currently Processed Chunk

for i=1 to 8 do																				-- Read Chunk Type (4) & ID (4)
(
if (buffer = ReadByte file) == undefined then return false									-- Exit If No More Chunks Left (EOF)
chunk.typeid += bit.intAsChar buffer														-- Convert To String
)
chunk.version = ReadLong file																-- Read Chunk Version (4)
chunk.size = ReadLong file																	-- Read Chunk Size (4)
chunk.namelength = ReadLong file															-- Read Chunk Name Length (4)
for i=1 to chunk.namelength do chunk.name += bit.intAsChar (ReadByte file)					-- Read Chunk Name (X - Chunk Name Length)
return chunk																				-- Return Chunk Header
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < SkipChunk > - Skip Current Chunk
--------------------------------------------------------------------------------------------

function SkipChunk file chunk =
(
fseek file chunk.size #seek_cur																-- Skip Chunk Size
)

--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < WriteChunkHeader> - Write Chunk Header
--------------------------------------------------------------------------------------------

function WriteChunkHeader file chunk =
(
for i=1 to 8 do WriteByte file (bit.charAsInt chunk.typeid[i])								-- Write Chunk Type & ID
WriteLong file chunk.version																-- Write Chunk Version
WriteLong file chunk.size																	-- Write Chunk Size
WriteLong file chunk.namelength																-- Write Chunk Name Length
if chunk.namelength != 0 then WriteString file chunk.name									-- Write Chunk Name (With 0 At The End)
)
--------------------------------------------------------------------------------------------
---[ FUNCTION ]--- < CopyChunk > - Copy Chunk From One File To Another
--------------------------------------------------------------------------------------------

function CopyChunk srcfile destfile chunk =
(
WriteChunkHeader destfile chunk																-- Write Chunk Header
for i=1 to chunk.size do																	-- Copy Chunk From SRCFile To DESTFile
(
byte = ReadByte srcfile																		-- Read Byte From SRCFile
WriteByte destfile byte																		-- Write Byte To DESTFile
)
)

--------------------------------------------------------------------------------------------
---------------------------------------[ END SCRIPT ]---------------------------------------
--------------------------------------------------------------------------------------------