-- Script to calculate storage from sys.master_files -- good to find all FG
--VN

if exists (select null from tempdb..sysobjects where name like '%#DatabaseIDs%')
      drop table #DatabaseIDs
if exists (select null from tempdb..sysobjects where name like '%#DatabaseInfo%')
      drop table #DatabaseInfo


Create TABLE #DatabaseIDs (DatabaseNumber INT IDENTITY(1,1), DatabaseID INT, DatabaseName VARCHAR(250))
create table #DatabaseInfo (DatabaseName VARCHAR(250), LogicalName VARCHAR(250),FileType VARCHAR(20), 
PhysicalName VARCHAR(500), [Size_MB] DECIMAL(38,2), [Used_MB] DECIMAL(38,2), [Used(%)] DECIMAL(38,2), 
[Available_MB] DECIMAL(38,2), [Available(%)] DECIMAL(38,2), MaxSizeInMB VARCHAR(20), GrowthRate VARCHAR(50))

DECLARE @DatabaseCount INT
DECLARE @DatabaseNumber INT
DECLARE @DatabaseName VARCHAR(250)
DECLARE @SQLText VARCHAR(4000)
Select @DatabaseNumber = 1 
/*Populate the list of Database IDs and Database Names*/
INSERT INTO #DatabaseIDs (DatabaseID, DatabaseName)
SELECT database_id AS DatabaseID, name 
FROM MASTER.sys.databases where state = 0 

/*Get a count of how many databases there are*/
SELECT @DatabaseCount = COUNT(*) FROM #DatabaseIDs

/*Loop over each database and insert the requested informaiton into the table*/
WHILE @DatabaseNumber <= @DatabaseCount
BEGIN

    SELECT @DatabaseName = DatabaseName
    FROM #DatabaseIDs
    WHERE DatabaseNumber = @DatabaseNumber
    
    SET @SQLText = '
        USE [' + @DatabaseName + ']
        SELECT
        DB_NAME(database_id) AS DatabaseName,
        Name AS LogicalName,
        CASE WHEN type_desc = ''ROWS'' THEN ''Data File'' WHEN type_desc = ''LOG'' THEN ''Log File'' ELSE ''Unknown'' END AS FileType,
        Physical_Name AS PhysicalName,
        size/128.0 AS FileSizeInMB,
        CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6))/128.0 AS UsedSpaceInMB,
        ((CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6)))/(size)) * 100 AS PercentUsed,
        size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6))/128.0 AS AvailableSpaceInMB,
        ((size - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6)))/(size)) * 100 AS PercentAvailable,
        CASE WHEN max_size = -1 THEN ''Unrestricted'' ELSE CONVERT(VARCHAR, max_size) END AS MaxSizeInMB,
        CASE WHEN is_percent_growth = 1 THEN CONVERT(VARCHAR, growth) + '' %'' ELSE CONVERT(VARCHAR, growth/128) + '' MB'' END AS GrowthRate
    FROM sys.master_files
    WHERE type_desc IN (''ROWS'',''LOG'') AND DB_NAME(database_id) = ' + '''' + @DatabaseName + ''''
    
    INSERT INTO #DatabaseInfo
        EXEC (@SQLText)
    
    SET @DatabaseNumber = @DatabaseNumber + 1
END

SELECT * FROM #DatabaseInfo 