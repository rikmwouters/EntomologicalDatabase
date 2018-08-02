USE EntoBase
GO

SET NOCOUNT ON

-- 1 - Variable Declaration
DECLARE @DBID int
DECLARE @CMD1 varchar(8000)
DECLARE @spidNumber int
DECLARE @SpidListLoop int
DECLARE @SpidListTable table
(UIDSpidList int IDENTITY (1,1),
SpidNumber int)

-- 2 - Populate @SpidListTable with the spid information
INSERT INTO @SpidListTable (SpidNumber)
SELECT spid
FROM Master.dbo.sysprocesses 
WHERE DBID NOT IN (1,2,3,4) -- Master, Tempdb, Model, MSDB
AND spid > 50
AND spid <> @@spid
ORDER BY spid DESC

-- 3b - Determine the highest UIDSpidList to loop through the records
SELECT @SpidListLoop = MAX(UIDSpidList) FROM @SpidListTable

-- 3c - While condition for looping through the spid records
WHILE @SpidListLoop > 0
BEGIN

-- 3d - Capture spids location
SELECT @spidNumber = spidnumber
FROM @spidListTable
WHERE UIDspidList = @SpidListLoop

-- 3e - String together the KILL statement
SELECT @CMD1 = 'KILL ' + CAST(@spidNumber AS varchar(5))

-- 3f - Execute the final string to KILL the spids
-- SELECT @CMD1
EXEC (@CMD1)

-- 3g - Descend through the spid list
SELECT @SpidListLoop = @SpidListLoop - 1
END

SET NOCOUNT OFF
GO