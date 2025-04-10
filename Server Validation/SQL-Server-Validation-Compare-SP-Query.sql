/*********************************************
 * Server Validation Compare SP Query
 *********************************************/
USE [ServerValidation]
GO

/****** Object:  StoredProcedure [dbo].[usp_Validation_Step3]    Script Date: 5/8/2020 3:55:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_Validation_Step3]
  @SourceServer nvarchar(40)
, @DestinationServer nvarchar(40)
, @CurrentID INT

AS

DECLARE @SourceValue nvarchar(40)
, @DestinationValue nvarchar(40)
, @SourceCount TINYINT
, @DestinationCount TINYINT
, @Result BIT
, @SettingValue nvarchar(40)

/** Compare staging data based on criteria **/
INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Validation Date'
, @SourceServer
, GETDATE()
, @DestinationServer
, GETDATE()
, @Result)

/* Server Info (CPU, Memory, # of Drives) */
--OS
SET @SourceValue =
(SELECT TOP 1 [CurrentOperatingSystem]
FROM [ServerValidation].[src].[ServerBuild]
WHERE [ComputerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue =
(SELECT TOP 1 [CurrentOperatingSystem]
FROM [ServerValidation].[des].[ServerBuild]
WHERE [ComputerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'OS Version'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

--CPU
SET @SourceValue =
(SELECT TOP 1
  [NumberOfCores]
FROM [ServerValidation].[src].[ServerBuild]
WHERE [ComputerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue =
(SELECT TOP 1
  [NumberOfCores]
FROM [ServerValidation].[des].[ServerBuild]
WHERE [ComputerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of CPUs'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

--Memory
SET @SourceValue =
(SELECT TOP 1
  [SystemMemTotal]
FROM [ServerValidation].[src].[ServerBuild]
WHERE [ComputerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue =
(SELECT TOP 1
  [SystemMemTotal]
FROM [ServerValidation].[des].[ServerBuild]
WHERE [ComputerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Memory'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

--Number of Drives
SET @SourceValue =
(SELECT COUNT([DriveLetter]) AS DriveCount
FROM [ServerValidation].[src].[ServerStorage]
WHERE [ComputerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue =
(SELECT COUNT([DriveLetter]) AS DriveCount
FROM [ServerValidation].[des].[ServerStorage]
WHERE [ComputerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of Drives'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* Instance */
SET @SettingValue = (SELECT Value 
FROM [ServerValidation].[dbo].[Settings]
WHERE [Name] = 'SQL Version')

SET @DestinationValue =
(SELECT TOP 1
  [VersionMajor]
FROM [ServerValidation].[des].[SQLInstance]
WHERE [FQDN] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SettingValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'SQL Server Version'
, @SourceServer
, @SettingValue
, @DestinationServer
, @DestinationValue
, @Result)


SELECT [FQDN], [InstanceName], [CheckName], Result.[CheckValues]
INTO #SOURCEINSTANCE
FROM (SELECT CAST(@CurrentID AS nvarchar(40)) AS [ValidationID]
      , CAST([FQDN] AS nvarchar(40)) AS [FQDN]
      , CAST([Port] AS nvarchar(40)) AS [Port]
      , CAST([InstanceName] AS nvarchar(40)) AS [InstanceName]
      , CAST([Edition] AS nvarchar(40)) AS [Edition]
      , CAST([ProductLevel] AS nvarchar(40)) AS [ProductLevel]
      , CAST([Collation] AS nvarchar(40)) AS [Collation]
  FROM [ServerValidation].[src].[SQLInstance]
  WHERE [ValidationID] = @CurrentID) AS SIN
  UNPIVOT ( CheckValues FOR CheckName IN ([Port],[Edition],[ProductLevel],[Collation]) ) AS Result
WHERE [FQDN] LIKE @SourceServer + '%'

SELECT [FQDN], [InstanceName], [CheckName], Result.[CheckValues]
INTO #DESTINATIONINSTANCE
FROM (SELECT CAST(@CurrentID AS nvarchar(40)) AS [ValidationID]
      , CAST([FQDN] AS nvarchar(40)) AS [FQDN]
      , CAST([Port] AS nvarchar(40)) AS [Port]
      , CAST([InstanceName] AS nvarchar(40)) AS [InstanceName]
      , CAST([Edition] AS nvarchar(40)) AS [Edition]
      , CAST([ProductLevel] AS nvarchar(40)) AS [ProductLevel]
      , CAST([Collation] AS nvarchar(40)) AS [Collation]
  FROM [ServerValidation].[des].[SQLInstance]
  WHERE [ValidationID] = @CurrentID) AS DIN
  UNPIVOT ( CheckValues FOR CheckName IN ([Port], [Edition], [ProductLevel], [Collation]) ) AS Result
WHERE [FQDN] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, CASE WHEN a.[checkvalues] IS NULL THEN b.[InstanceName] + ' ' + b.[CheckName] ELSE a.[InstanceName] + ' ' + a.[CheckName] END, a.[FQDN], a.[CheckValues], b.[FQDN], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEINSTANCE a
  FULL OUTER JOIN #DESTINATIONINSTANCE b ON a.[InstanceName] + ' ' + a.[CheckName] = b.[InstanceName] + ' ' + b.[CheckName]

DROP TABLE #SOURCEINSTANCE
DROP TABLE #DESTINATIONINSTANCE

/* Advanced Configuration */
--max server memory (MB)
SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCEMAXMEMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[src].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max server memory (MB)') AS SMC
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @SourceServer + '%'

SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONMAXMEMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[des].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max server memory (MB)') AS SMC
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, a.Name + ' ' + a.[CheckName], a.[ServerName], a.[CheckValues], b.[ServerName], b.CheckValues, CASE WHEN a.checkvalues = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEMAXMEMCONFIG a
  INNER JOIN #DESTINATIONMAXMEMCONFIG b ON a.[CheckName] = b.[CheckName]

DROP TABLE #SOURCEMAXMEMCONFIG
DROP TABLE #DESTINATIONMAXMEMCONFIG

--cost threshold for parallelism
SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCECOSTPARALLELISMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[src].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'cost threshold for parallelism') AS SPC
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @SourceServer + '%'

SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONCOSTPARALLELISMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[des].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'cost threshold for parallelism') AS DPC
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, a.[Name] + ' ' + a.[CheckName], a.[ServerName], a.[CheckValues], b.[ServerName], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCECOSTPARALLELISMCONFIG a
  INNER JOIN #DESTINATIONCOSTPARALLELISMCONFIG b ON a.[CheckName] = b.[CheckName]

DROP TABLE #SOURCECOSTPARALLELISMCONFIG
DROP TABLE #DESTINATIONCOSTPARALLELISMCONFIG

--max degree of parallelism
SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCEMAXPARALLELISMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[src].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max degree of parallelism') AS SDP
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @SourceServer + '%'

SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONMAXPARALLELISMCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[des].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max degree of parallelism') AS DDP
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, a.[Name] + ' ' + a.[CheckName], a.[ServerName], a.[CheckValues], b.[ServerName], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEMAXPARALLELISMCONFIG a
  INNER JOIN #DESTINATIONMAXPARALLELISMCONFIG b ON a.[CheckName] = b.[CheckName]

DROP TABLE #SOURCEMAXPARALLELISMCONFIG
DROP TABLE #DESTINATIONMAXPARALLELISMCONFIG

--max worker threads
SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCEMAXWORKERCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[src].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max worker threads') AS SMW
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @SourceServer + '%'

SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONMAXWORKERCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[des].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'max worker threads') AS DMW
  UNPIVOT ( CheckValues FOR CheckName IN (ValueInUse) ) AS Result
WHERE [ServerName] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, a.[Name] + ' ' + a.[CheckName], a.[ServerName], a.[CheckValues], b.[ServerName], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEMAXWORKERCONFIG a
  INNER JOIN #DESTINATIONMAXWORKERCONFIG b ON a.[CheckName] = b.[CheckName]

DROP TABLE #SOURCEMAXWORKERCONFIG
DROP TABLE #DESTINATIONMAXWORKERCONFIG

--xp_cmdshell
SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCEXPCMDSHELLCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[src].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'xp_cmdshell') AS SMW
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @SourceServer + '%'

SELECT [ServerName], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONXPCMDSHELLCONFIG
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([ServerName] AS nvarchar(40)) AS [ServerName]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , CAST([ValueInUse] AS int) AS [ValueInUse]
  FROM [ServerValidation].[des].[AdvancedSQLServerConfiguration]
  WHERE [ValidationID] = @CurrentID AND [Name] = 'xp_cmdshell') AS DMW
  UNPIVOT ( CheckValues FOR CheckName IN ([ValueInUse]) ) AS Result
WHERE [ServerName] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, a.[Name] + ' ' + a.[CheckName], a.[ServerName], a.[CheckValues], b.[ServerName], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEXPCMDSHELLCONFIG a
  INNER JOIN #DESTINATIONXPCMDSHELLCONFIG b ON a.[CheckName] = b.[CheckName]

DROP TABLE #SOURCEXPCMDSHELLCONFIG
DROP TABLE #DESTINATIONXPCMDSHELLCONFIG

--DB Isolation
SELECT [FQDN], [Name], [CheckName], Result.[CheckValues]
INTO #SOURCEDBISOLATION
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([FQDN] AS nvarchar(40)) AS [FQDN]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , [is_read_committed_snapshot_on] AS [is_read_committed_snapshot_on]
  FROM [ServerValidation].[src].[SQLDatabase]
  WHERE [ValidationID] = @CurrentID) AS SDI
  UNPIVOT ( CheckValues FOR CheckName IN ([is_read_committed_snapshot_on]) ) AS Result
WHERE [FQDN] LIKE @SourceServer + '%'

SELECT [FQDN], [Name], [CheckName], Result.[CheckValues]
INTO #DESTINATIONDBISOLATION
FROM (SELECT CAST(@CurrentID AS int) AS [ValidationID]
      , CAST([FQDN] AS nvarchar(40)) AS [FQDN]
      , CAST([Name] AS nvarchar(100)) AS [Name]
      , [is_read_committed_snapshot_on] AS [is_read_committed_snapshot_on]
  FROM [ServerValidation].[des].[SQLDatabase]
  WHERE [ValidationID] = @CurrentID) AS DDI
  UNPIVOT ( CheckValues FOR CheckName IN ([is_read_committed_snapshot_on]) ) AS Result
WHERE [FQDN] LIKE @DestinationServer + '%'

INSERT INTO [ServerValidation].[res].[Server]
SELECT @CurrentID, CASE WHEN a.[checkvalues] IS NULL THEN '[' + b.[Name] + '] ' + b.[CheckName] ELSE '[' + a.[Name] + '] ' + a.[CheckName] END, a.[FQDN], a.[CheckValues], b.[FQDN], b.[CheckValues], CASE WHEN a.[checkvalues] = b.[checkvalues] THEN 1 ELSE 0 END
FROM #SOURCEDBISOLATION a
  FULL OUTER JOIN #DESTINATIONDBISOLATION b ON a.[Name] + ' ' + a.[CheckName] = b.[Name] + ' ' + b.[CheckName]

DROP TABLE #SOURCEDBISOLATION
DROP TABLE #DESTINATIONDBISOLATION

/* SSRS */
SET @SourceCount = (SELECT COUNT([DisplayName])
FROM [ServerValidation].[src].[WindowsService]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationCount = 
(SELECT COUNT([DisplayName])
FROM [ServerValidation].[des].[WindowsService]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

BEGIN
IF (@SourceCount > 0) 
SET @SourceValue =
(SELECT TOP(1) [DisplayName]
FROM [ServerValidation].[src].[WindowsService]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)
ELSE
SET @SourceValue = 'None'
END

BEGIN
IF (@DestinationCount > 0) 
SET @DestinationValue = 
(SELECT TOP(1) [DisplayName]
FROM [ServerValidation].[des].[WindowsService]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)
ELSE
SET @DestinationValue = 'None'
END

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'SQL Server Reporting Services'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* Server Timezone */
SET @SourceValue =
(SELECT [TimeZoneKeyName]
FROM [ServerValidation].[src].[Timezone]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue = 
(SELECT [TimeZoneKeyName]
FROM [ServerValidation].[des].[Timezone]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Timezone Name'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* Providers */
SET @SourceCount = (SELECT COUNT([Name])
FROM [ServerValidation].[src].[Providers]
WHERE [ServerName] LIKE @SourceServer + '%' AND [Name] = 'OraOLEDB.Oracle' AND [ValidationID] = @CurrentID)

SET @DestinationCount = 
(SELECT COUNT([Name])
FROM [ServerValidation].[des].[Providers]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [Name] = 'OraOLEDB.Oracle' AND [ValidationID] = @CurrentID)

BEGIN
IF (@SourceCount > 0) 
SET @SourceValue =
(SELECT TOP(1) [Name]
FROM [ServerValidation].[src].[Providers]
WHERE [ServerName] LIKE @SourceServer + '%' AND [Name] = 'OraOLEDB.Oracle' AND [ValidationID] = @CurrentID)
ELSE
SET @SourceValue = 'None'
END

BEGIN
IF (@DestinationCount > 0) 
SET @DestinationValue = 
(SELECT TOP(1) [Name]
FROM [ServerValidation].[des].[Providers]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [Name] = 'OraOLEDB.Oracle' AND [ValidationID] = @CurrentID)
ELSE
SET @DestinationValue = 'None'
END

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Oracle Provider'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* SQL DBA AD group permissions */
SET @SourceValue =
(SELECT [Login\Member Name]
FROM [ServerValidation].[src].[SysAdminUser]
WHERE [Login\Member Name] = 'CORPORATE\NA_IM_SQL_ADM' AND [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue = 
(SELECT [Login\Member Name]
FROM [ServerValidation].[des].[SysAdminUser]
WHERE [Login\Member Name] = 'CORPORATE\NA_IM_SQL_ADM' AND [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'SQL SysAdmin AD Group Exist'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* Database count - Row count only, it doesn't mean the data will match. */
SET @SourceCount = (SELECT COUNT(name) AS DatabaseCount
FROM [ServerValidation].[src].[SQLDatabase]
WHERE [FQDN] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY FQDN)

SET @DestinationCount = (SELECT COUNT(name) AS DatabaseCount
FROM [ServerValidation].[des].[SQLDatabase]
WHERE [FQDN] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY FQDN)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of Databases'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Count of databases not owned by sa */
SET @SourceCount = (SELECT COUNT(name) AS DatabaseCount
FROM [ServerValidation].[src].[SQLDatabase]
WHERE [FQDN] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID AND [DB_Owner] <> 'sa'
GROUP BY FQDN)

SET @DestinationCount = (SELECT COUNT(name) AS DatabaseCount
FROM [ServerValidation].[des].[SQLDatabase]
WHERE [FQDN] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID AND [DB_Owner] <> 'sa'
GROUP BY FQDN)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of Databases not owned by sa'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)


/* Job count total (enabled) Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[src].[Job]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID AND [job_enabled] = 'Yes'
GROUP BY ServerName)

SET @DestinationCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[des].[Job]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID AND [job_enabled] = 'Yes'
GROUP BY ServerName)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of enabled jobs'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Job count table (disabled) Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[src].[Job]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID AND [job_enabled] = 'No'
GROUP BY ServerName)

SET @DestinationCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[des].[Job]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID AND [job_enabled] = 'No'
GROUP BY ServerName)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of disabled jobs'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Job count total Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[src].[Job]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY ServerName)

SET @DestinationCount =
(SELECT COUNT(job_name) AS JobCount
FROM [ServerValidation].[des].[Job]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY ServerName)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Total Number of jobs'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Job Owner Check for jobs that are not owned by SA or agent. */
SET @SourceCount =
(SELECT COUNT(Owner) AS JobCount
FROM [ServerValidation].[src].[Job]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID AND [Owner] <> 'sa' AND [Owner] NOT LIKE '%AGENT'
GROUP BY ServerName)

SET @DestinationCount =
(SELECT COUNT(Owner) AS JobCount
FROM [ServerValidation].[des].[Job]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID AND [Owner] <> 'sa' AND [Owner] NOT LIKE '%AGENT'
GROUP BY ServerName)

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of jobs that are not owned by SA or SQL Agent'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Linked serversRow count only, it doesn't mean the data will match.
This will return results even if there are no linked servers since it will always display at least 1 row for itself. */
SET @SourceCount =
(SELECT COUNT([SRV_NAME]) AS LinkedServerCount
FROM [ServerValidation].[src].[LinkedServer]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

SET @DestinationCount =
(SELECT COUNT([SRV_NAME]) AS LinkedServerCount
FROM [ServerValidation].[des].[LinkedServer]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of linked servers'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* 3rd party software Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT([ProductName]) NumberofSoftware
FROM [ServerValidation].[src].[InstalledSoftware]
WHERE [ComputerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ComputerName])

SET @DestinationCount =
(SELECT COUNT([ProductName]) NumberofSoftware
FROM [ServerValidation].[des].[InstalledSoftware]
WHERE [ComputerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ComputerName])

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of 3rd party software installed'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Server role users Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT([Login\Member Name]) AS SysAdminCount
FROM [ServerValidation].[src].[ServerAdminUser]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

SET @DestinationCount =
(SELECT COUNT([Login\Member Name]) AS SysAdminCount
FROM [ServerValidation].[des].[ServerAdminUser]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of serveradmin users'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Sysadmin role users Row count only, it doesn't mean the data will match. */
SET @SourceCount =
(SELECT COUNT([Login\Member Name]) AS SysAdminCount
FROM [ServerValidation].[src].[SysAdminUser]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

SET @DestinationCount =
(SELECT COUNT([Login\Member Name]) AS SysAdminCount
FROM [ServerValidation].[des].[SysAdminUser]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of sysadmin users'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Database Mail */
SET @SourceValue =
(SELECT [Status]
FROM [ServerValidation].[src].[MailStatus]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID)

SET @DestinationValue =
(SELECT [Status]
FROM [ServerValidation].[des].[MailStatus]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID)

IF (@SourceValue = @DestinationValue) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Database Mail Status'
, @SourceServer
, @SourceValue
, @DestinationServer
, @DestinationValue
, @Result)

/* Number of Logins */
SET @SourceCount =
(SELECT COUNT([Name]) AS LoginCount
FROM [ServerValidation].[src].[Login]
WHERE [ServerName] LIKE @SourceServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

SET @DestinationCount =
(SELECT COUNT([Name]) AS LoginCount
FROM [ServerValidation].[des].[Login]
WHERE [ServerName] LIKE @DestinationServer + '%' AND [ValidationID] = @CurrentID
GROUP BY [ServerName])

IF (@SourceCount = @DestinationCount) 
SET @Result = 1
ELSE 
SET @Result = 0

INSERT INTO [ServerValidation].[res].[Server]
VALUES
  (@CurrentID
, 'Number of logins'
, @SourceServer
, @SourceCount
, @DestinationServer
, @DestinationCount
, @Result)

/* Mark end of run */
UPDATE [ServerValidation].[dbo].[History]
SET [EndTimestamp] = GETDATE()
WHERE [ValidationID] = @CurrentID
GO