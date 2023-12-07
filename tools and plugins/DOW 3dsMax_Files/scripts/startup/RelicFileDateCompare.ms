-- Compares two files' modification dates
--
-- format:
--    <int> = fileDateCompare <filename1> <filename2>
--
-- returns:
--      1   if file1 is newer than file2
--      0   if file1 is the same age as file2
--     -1   if file1 is older than file2

fn makeSortableDate inDate =
(
	local dateSep = filterString inDate "/ :"
	local outDate
	local tmpStr
	local ampm = 6

	-- Find out where our AM/PM setting is (might have seconds)	
	if ( dateSep[6] != "AM" and dateSep[6] != "PM" ) then ampm = 7
	
	-- First the year
	outDate = dateSep[3]
	
	-- Next the month
	tmpStr = dateSep[1]
	if ( tmpStr.count < 2 ) then tmpStr = "0"+tmpStr
	outDate += tmpStr
	
	-- Now the day
	tmpStr = dateSep[2]
	if ( tmpStr.count < 2 ) then tmpStr = "0"+tmpStr
	outDate += tmpStr
	
	-- Now the Hour (military conversion)
	tmpStr = dateSep[4]
	if ( (tmpStr as integer) == 12 ) then tmpStr = "00"
	if ( dateSep[ampm] == "PM" ) then tmpStr = (((tmpStr as integer) + 12) as string)
	if ( tmpStr.count < 2 ) then tmpStr = "0"+tmpStr
	outDate += tmpStr
	
	-- Now the Minute
	tmpStr = dateSep[5]
	if ( tmpStr.count < 2 ) then tmpStr = "0"+tmpStr
	outDate += tmpStr

	-- Now Seconds (if AM/PM, just puts adds a "00")
	if ( ampm == 7 ) then tmpStr = dateSep[6]
	else tmpStr = "00"
	if ( tmpStr.count < 2 ) then tmpStr = "0"+tmpStr
	outDate += tmpStr
	
	return outDate	
)

fn getSortableDate inFile =
(
	return makeSortableDate( getFileModDate( inFile ) )
)

fn fileDateCompare file1 file2 =
(
	local f1Date = getSortableDate file1
	local f2Date = getSortableDate file2
	
	if ( f1Date > f2Date ) then return 1
	if ( f1Date < f2Date ) then return -1

	-- f1Date == f2Date
	return 0
)
