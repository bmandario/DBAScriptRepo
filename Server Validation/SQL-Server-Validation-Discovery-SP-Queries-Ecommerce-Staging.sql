/*********************************************
 * SQL Server Validation Discovery SP Queries
 *********************************************/
USE [ServerValidation]
GO

/****** Object:  StoredProcedure [res].[usp_CompatibilityStart]    Script Date: 3/12/2020 9:39:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_CompatibilityStart]
  @Server nvarchar(40)

AS

DECLARE @ModelDbCompatibilityLevel TINYINT
, @CurrentID INT

INSERT INTO [dbo].[History]
  ([EndTimestamp]
  , [CompareName])
VALUES
  (NULL, 'Compatibility')
SET @CurrentID = SCOPE_IDENTITY()

SET @CurrentID = (SELECT [ValidationID]
FROM [dbo].[History]
WHERE [EndTimestamp] IS NULL AND [UserName] = SYSTEM_USER AND [StartTimestamp] IN (SELECT max([StartTimestamp])
  FROM [dbo].[History]))

INSERT INTO [ServerValidation].[src].[SQLDatabase]  ([ValidationID],[FQDN],[instancename],[name],[compatibility_level],[collation_name],[is_read_committed_snapshot_on],[is_published],[is_subscribed])
SELECT @CurrentID, v_ps_DB_P_A.[FQDN], v_ps_DB_P_A.[instancename], v_ps_DB_P_A.[name], v_ps_DB_P_A.[compatibility_level], v_ps_DB_P_A.[collation_name],v_ps_DB_P_A.[is_read_committed_snapshot_on], v_ps_DB_P_A.[is_published], v_ps_DB_P_A.[is_subscribed]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_ps_DB_Properties_All] v_ps_DB_P_A
WHERE v_ps_DB_P_A.[FQDN] LIKE @Server + '%'

SET @ModelDbCompatibilityLevel =
(SELECT [compatibility_level]
FROM [ServerValidation].[src].[SQLDatabase]
WHERE [name] = 'model' AND [FQDN] LIKE @Server + '%' AND [ValidationID] = @CurrentID)

INSERT INTO [ServerValidation].[res].[DBCompatibility]
SELECT @CurrentID, [FQDN], [name] , [compatibility_level], @ModelDbCompatibilityLevel, CASE WHEN [compatibility_level] = @ModelDbCompatibilityLevel THEN 1 ELSE 0 END
FROM [ServerValidation].[src].[SQLDatabase]
WHERE [name] NOT IN ('model','msdb','master','tempdb') AND [FQDN] LIKE @Server + '%' AND [ValidationID] = @CurrentID

UPDATE [dbo].[History]
SET [EndTimestamp] = GETDATE()
WHERE [ValidationID] = @CurrentID
GO


/****************************************************************/
USE [ServerValidation]
GO

/****** Object:  StoredProcedure [dbo].[usp_Validation_Step1]    Script Date: 5/8/2020 3:55:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_Validation_Step1]
	@SourceServer nvarchar(40)
,	@DestinationServer nvarchar(40)
,	@UserName nvarchar(40)

AS

/** Generate ID and record current user, user sid, and date/time **/
DECLARE @CurrentID int

INSERT INTO [ServerValidation].[dbo].[History]
	([UserName]
	, [UserSID]
	, [EndTimestamp]
	, [CompareName])
VALUES
	(@UserName
	, SUSER_SID(@UserName)
	, NULL
  , 'Server')
SET @CurrentID = SCOPE_IDENTITY()


/** Retrieve MAPS data for source server **/
--OS/Server
INSERT INTO [ServerValidation].[src].[ServerBuild]   ([ValidationID],[ComputerName],[CurrentOperatingSystem],[IPAddress],[Domain/Workgroup],[NumberOfCores],[SystemMemTotal])
SELECT @CurrentID, v_WVA.[ComputerName], v_WVA.[CurrentOperatingSystem], v_WVA.[IPAddress], v_WVA.[Domain/Workgroup], v_WVA.[NumberOfCores], v_WVA.[SystemMemTotal]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_WinViewALL] v_WVA
WHERE v_WVA.[ComputerName] LIKE @SourceServer + '%'

--Storage
INSERT INTO [ServerValidation].[src].[ServerStorage] ([ValidationID],[ComputerName],[DriveLetter],[SizeInGB])
SELECT @CurrentID,v_WVD.[ComputerName],v_WVD.[DriveLetter],v_WVD.[SizeInGB]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_WinViewDisk] v_WVD
WHERE v_WVD.[ComputerName] LIKE @SourceServer + '%'

--Instance Info
INSERT INTO [ServerValidation].[src].[SQLInstance]  ([ValidationID],[FQDN],[Port],[InstanceName],[Edition],[VersionMajor],[ProductLevel],[Collation])
SELECT @CurrentID,v_IP_A.[FQDN],
CASE
	WHEN v_IP_A.[ConnStr] LIKE '%,%' THEN RIGHT(v_IP_A.[ConnStr], charindex(',', reverse(v_IP_A.[ConnStr])) - 1)
	ELSE '1433'
	END AS Port,
	v_IP_A.[InstanceName],v_IP_A.[Edition],v_IP_A.[VersionMajor],v_IP_A.[ProductLevel],v_IP_A.[Collation]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_InstanceProperties_All] v_IP_A
WHERE v_IP_A.[FQDN] LIKE @SourceServer + '%'

--DB
INSERT INTO [ServerValidation].[src].[SQLDatabase]([ValidationID],[FQDN],[instancename],[name],[compatibility_level],[collation_name],[is_read_committed_snapshot_on],[is_published],[is_subscribed])
SELECT @CurrentID, v_ps_DB_P_A.[FQDN], v_ps_DB_P_A.[instancename], v_ps_DB_P_A.[name], v_ps_DB_P_A.[compatibility_level], v_ps_DB_P_A.[collation_name],v_ps_DB_P_A.[is_read_committed_snapshot_on], v_ps_DB_P_A.[is_published], v_ps_DB_P_A.[is_subscribed]
FROM [DISCOVERY].[dbo].[v_ps_DB_Properties_All] v_ps_DB_P_A
WHERE v_ps_DB_P_A.[FQDN] LIKE @SourceServer + '%'

-- Reporting Server
INSERT INTO [ServerValidation].[src].[WindowsService]
SELECT @CurrentID,[Name0],[DisplayName0],[ServiceName],[StartMode0],[StartName0],[State0],[Status0]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[sccm_v_GS_Service] sccm_v_GS_S
WHERE sccm_v_GS_S.[DisplayName0] LIKE '%Report%' AND sccm_v_GS_S.[Name0] LIKE @SourceServer + '%'

/** Retrieve MAPS data for destination server **/
--OS/Server
INSERT INTO [ServerValidation].[des].[ServerBuild]  ([ValidationID],[ComputerName],[CurrentOperatingSystem],[IPAddress],[Domain/Workgroup],[NumberOfCores],[SystemMemTotal])
SELECT @CurrentID, v_WVA.[ComputerName], v_WVA.[CurrentOperatingSystem], v_WVA.[IPAddress], v_WVA.[Domain/Workgroup], v_WVA.[NumberOfCores], v_WVA.[SystemMemTotal]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_WinViewALL] v_WVA
WHERE v_WVA.[ComputerName] LIKE @DestinationServer + '%'

--Storage
INSERT INTO [ServerValidation].[des].[ServerStorage]([ValidationID],[ComputerName],[DriveLetter],[SizeInGB])
SELECT @CurrentID,v_WVD.[ComputerName],v_WVD.[DriveLetter],v_WVD.[SizeInGB]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_WinViewDisk] v_WVD
WHERE v_WVD.[ComputerName] LIKE @DestinationServer + '%'

--Instance Info
INSERT INTO [ServerValidation].[des].[SQLInstance] ([ValidationID],[FQDN],[Port],[InstanceName],[Edition],[VersionMajor],[ProductLevel],[Collation])
SELECT @CurrentID,v_IP_A.[FQDN],
CASE
	WHEN v_IP_A.[ConnStr] LIKE '%,%' THEN RIGHT(v_IP_A.[ConnStr], charindex(',', reverse(v_IP_A.[ConnStr])) - 1)
	ELSE '1433'
	END AS Port,
	v_IP_A.[InstanceName],v_IP_A.[Edition],v_IP_A.[VersionMajor],v_IP_A.[ProductLevel],v_IP_A.[Collation]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_InstanceProperties_All] v_IP_A
WHERE v_IP_A.[FQDN] LIKE @DestinationServer + '%'

--DB
INSERT INTO [ServerValidation].[des].[SQLDatabase]([ValidationID],[FQDN],[instancename],[name],[compatibility_level],[collation_name],[is_read_committed_snapshot_on],[is_published],[is_subscribed])
SELECT @CurrentID, v_ps_DB_P_A.[FQDN], v_ps_DB_P_A.[instancename], v_ps_DB_P_A.[name], v_ps_DB_P_A.[compatibility_level], v_ps_DB_P_A.[collation_name],v_ps_DB_P_A.[is_read_committed_snapshot_on], v_ps_DB_P_A.[is_published], v_ps_DB_P_A.[is_subscribed]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[v_ps_DB_Properties_All] v_ps_DB_P_A
WHERE v_ps_DB_P_A.[FQDN] LIKE @DestinationServer + '%'

-- Reporting Server
INSERT INTO [ServerValidation].[des].[WindowsService]
SELECT @CurrentID,[Name0],[DisplayName0],[ServiceName],[StartMode0],[StartName0],[State0],[Status0]
FROM [10.22.33.18,7002].[DISCOVERY].[dbo].[sccm_v_GS_Service] sccm_v_GS_S
WHERE sccm_v_GS_S.[DisplayName0] LIKE '%Report%' AND sccm_v_GS_S.[Name0] LIKE @DestinationServer + '%'

/** Return ID **/
SELECT @CurrentID
GO