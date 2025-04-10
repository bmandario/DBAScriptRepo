<# 
.Synopsis
SQL Server Validation Test

.Description
SQL configuration settings for database connection to SQL DBA servers.
#>
# SQL Configuration
function Get-SQLSVServer {
	if ($env:USERDNSDOMAIN -match 'corporate') {
		return "$(hostname)\MAPS"
	}
	else {
		return hostname
	}
}
function Get-SQLSVDatabase {
	return 'ServerValidation'
}
function Format-ErrorLog {
	param (
		[string] $ExceptionMessage
	)
	$ErrorLog = 'D:\PS\Server Validation\error.txt'
	"Exception in $($MyInvocation.ScriptName) $(Get-Date) on $($MyInvocation.ScriptLineNumber) for below error:" | Out-file $ErrorLog -Append
	$ExceptionMessage | Out-file $ErrorLog -Append
}
function Get-SQLServerInfo ($ServerName, $Query, $InsertTable, $ValidationID) {
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = "Server=$ServerName;Initial Catalog=master;Integrated Security=True;"
	$SqlConnection.Open()
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = $Query
	$SqlCmd.Connection = $SqlConnection
	$SqlCmd.CommandTimeout = 0
	$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd
	$DataSet = New-Object System.Data.DataSet
	$SqlAdapter.Fill($DataSet)
	$SqlConnection.Close()

	$ServerNameCol = New-Object Data.DataColumn
	$ServerNameCol.ColumnName = 'ServerName'
	$DataSet.Tables[0].Columns.Add($ServerNameCol)
	$ServerNameCol.SetOrdinal(0);
	$DataSet.Tables[0] | ForEach-Object { $_.ServerName = $ServerName }

	$ValidationIDCol = New-Object Data.DataColumn
	$ValidationIDCol.ColumnName = 'ValidationID'
	$DataSet.Tables[0].Columns.Add($ValidationIDCol)
	$ValidationIDCol.SetOrdinal(0);
	$DataSet.Tables[0] | ForEach-Object { $_.ValidationID = $ValidationID }

	try {
		$SqlBulkCopy = New-Object ('Data.SqlClient.SqlBulkCopy') "Server=$(Get-SQLSVServer);Database=$(Get-SQLSVDatabase);Trusted_Connection=True"
		$SqlBulkCopy.DestinationTableName = $InsertTable
		$SqlBulkCopy.BatchSize = 5000
		$SqlBulkCopy.BulkCopyTimeout = 0
		$SqlBulkCopy.WriteToServer($DataSet.Tables[0])
		$SqlBulkCopy.Close()
	}
	catch {
		$ex = $_.Exception
		Format-ErrorLog $ex.Message
	}
	finally {
		$SqlBulkCopy.Close()
	}
}

# Remote Server Queries
function Get-AdvancedSQLServerConfiguration {
	return @"
SELECT name, value, minimum, maximum, value_in_use AS ValueInUse
FROM  sys.configurations
WHERE name IN (
'xp_cmdshell'
,'max server memory (MB)'
,'cost threshold for parallelism'
,'max degree of parallelism'
,'max worker threads')
"@
}
function Get-ExecSPLinkedServer {
	return 'EXEC msdb.dbo.sp_linkedservers'
}
function Get-ExecSPLogShipping {
	return 'EXEC master.dbo.sp_help_log_shipping_monitor'
}
function Get-ExecSPDBMailStatus {
	return 'EXEC msdb.dbo.sysmail_help_status_sp'
}
function Get-ExecSPDBMail {
	return 'EXEC msdb.dbo.sysmail_help_principalprofile_sp'
}
function Get-SelectDatabaseSecurity {
	return @"
USE MASTER

BEGIN
DECLARE @SQLVerNo INT;
SET @SQLVerNo = cast(substring(CAST(Serverproperty('ProductVersion') AS VARCHAR(50)) ,0,charindex('.',CAST(Serverproperty('ProductVersion') AS VARCHAR(50)) ,0)) as int);

IF @SQLVerNo >= 9 
	IF EXISTS (SELECT TOP 1
	*
FROM Tempdb.sys.objects (nolock)
WHERE name LIKE '#TUser%')
		DROP TABLE #TUser
ELSE
IF @SQLVerNo = 8
BEGIN
	IF EXISTS (SELECT TOP 1
	*
	FROM Tempdb.dbo.sysobjects (nolock)
	WHERE name LIKE '#TUser%')
		DROP TABLE #TUser
END

CREATE TABLE #TUser
(
	InstanceName VARCHAR(256),
	DBName SYSNAME,
	[Name] SYSNAME,
	GroupName SYSNAME NULL,
	LoginName SYSNAME NULL,
	default_database_name SYSNAME NULL,
	default_schema_name VARCHAR(256) NULL,
	Principal_id INT
)

IF @SQLVerNo = 8
BEGIN
	INSERT INTO #TUser
	EXEC sp_MSForEachdb
	'
	SELECT 
	@@SERVICENAME AS InstanceName,
		''?'' as DBName,
		u.name As UserName,
		CASE WHEN (r.uid IS NULL) THEN ''public'' ELSE r.name END AS GroupName,
		l.name AS LoginName,
		NULL AS Default_db_Name,
		NULL as default_Schema_name,
		u.uid
	FROM [?].dbo.sysUsers u
		LEFT JOIN ([?].dbo.sysMembers m 
		JOIN [?].dbo.sysUsers r
		ON m.groupuid = r.uid)
		ON m.memberuid = u.uid
		LEFT JOIN dbo.sysLogins l
		ON u.sid = l.sid
	WHERE u.islogin = 1 OR u.isntname = 1 OR u.isntgroup = 1
		/*and u.name like ''tester''*/
	ORDER BY u.name
	'
END

ELSE 
IF @SQLVerNo >= 9
BEGIN
	INSERT INTO #TUser
	EXEC sp_MSForEachdb
	'
	SELECT 
	@@SERVICENAME AS InstanceName,
		''?'',
		u.name,
		CASE WHEN (r.principal_id IS NULL) THEN ''public'' ELSE r.name END GroupName,
		l.name LoginName,
		l.default_database_name,
		u.default_schema_name,
		u.principal_id
	FROM [?].sys.database_principals u
		LEFT JOIN ([?].sys.database_role_members m
		JOIN [?].sys.database_principals r 
		ON m.role_principal_id = r.principal_id)
		ON m.member_principal_id = u.principal_id
		LEFT JOIN [?].sys.server_principals l
		ON u.sid = l.sid
	WHERE u.TYPE <> ''R''
		/*and u.name like ''tester''*/
	order by u.name
	'
END

SELECT *
FROM #TUser
ORDER BY DBName, [name], GroupName
END

DROP TABLE #TUser
"@
}
function Get-SelectSSIS {
	return @"
SELECT PCK.name AS PackageName
	, PCK.[description] AS [Description]
	, FLD.foldername AS FolderName
	, CASE PCK.packagetype
			WHEN 0 THEN 'Default client'
			WHEN 1 THEN 'I/O Wizard'
			WHEN 2 THEN 'DTS Designer'
			WHEN 3 THEN 'Replication'
			WHEN 5 THEN 'SSIS Designer'
			WHEN 6 THEN 'Maintenance Plan'
			ELSE 'Unknown' END AS PackageTye
	, LG.name AS OwnerName
	, PCK.createdate AS CreateDate
	, CONVERT(varchar(10), vermajor)
		+ '.' + CONVERT(varchar(10), verminor)
		+ '.' + CONVERT(varchar(10), verbuild) AS Version
FROM msdb.dbo.sysssispackages AS PCK
LEFT JOIN msdb.dbo.sysssispackagefolders AS FLD
ON PCK.folderid = FLD.folderid
LEFT JOIN sys.syslogins AS LG
ON PCK.ownersid = LG.sid
ORDER BY PCK.name;
"@
}
function Get-SelectSysAdminUser {
	return @"
SELECT 'sysadmin' as 'Role'
	, CONVERT (NVARCHAR(50), name) COLLATE DATABASE_DEFAULT AS 'Login\Member Name'
FROM sys.server_principals
WHERE IS_SRVROLEMEMBER('sysadmin', name) = 1
"@
}
function Get-SelectServerAdminUser {
	return @"
SELECT CONVERT (NVARCHAR(20),r.name) AS'Role'
			, CONVERT (NVARCHAR(50),p.name) AS 'Login\Member Name'
FROM sys.server_principals r
JOIN sys.server_role_members m ON r.principal_id = m.role_principal_id
JOIN sys.server_principals p ON	p.principal_id = m.member_principal_id
WHERE (r.type ='R')and(r.name='serveradmin')
"@
}
function Get-SelectJob {
	return @"
	use [msdb]
	Declare @weekDay Table 
	(
		mask int
		, maskValue varchar(32)
	);
	Insert Into @weekDay
		Select 1, 'Sunday'
	UNION ALL
		Select 2, 'Monday'
	UNION ALL
		Select 4, 'Tuesday'
	UNION ALL
		Select 8, 'Wednesday'
	UNION ALL
		Select 16, 'Thursday'
	UNION ALL
		Select 32, 'Friday'
	UNION ALL
		Select 64, 'Saturday';
	With
		SCHED
		as
		(
			Select sched.name As 'scheduleName'
	, sched.schedule_id
	, jobsched.job_id as job_id
	, Case 
		When sched.freq_type = 1 
		Then 'Once' 
		When sched.freq_type = 4 And sched.freq_interval = 1 
		Then 'Daily'
		When sched.freq_type = 4 
		Then 'Every ' + Cast(sched.freq_interval As varchar(5)) + ' days'
		When sched.freq_type = 8 
		Then Replace( Replace( Replace(( 
		Select maskValue
				From @weekDay As x
				Where sched.freq_interval & x.mask <> 0
				Order By mask
				For XML Raw)
		, '"/><row maskValue="', ', '), '<row maskValue="', ''), '"/>', '') 
		+ Case When sched.freq_recurrence_factor <> 0
					And sched.freq_recurrence_factor = 1 
		Then '; weekly' 
	When sched.freq_recurrence_factor <> 0 
		Then '; every ' 
		+ Cast(sched.freq_recurrence_factor As varchar(10)) + ' weeks' 
		End
		When sched.freq_type = 16 
		Then 'On day ' 
		+ Cast(sched.freq_interval As varchar(10)) + ' of every '
		+ Cast(sched.freq_recurrence_factor As varchar(10)) + ' months' 
		When sched.freq_type = 32 
		Then Case 
		When sched.freq_relative_interval = 1 
		Then 'First'
		When sched.freq_relative_interval = 2 
		Then 'Second'
		When sched.freq_relative_interval = 4 
		Then 'Third'
		When sched.freq_relative_interval = 8 
		Then 'Fourth'
		When sched.freq_relative_interval = 16 
		Then 'Last'
	End + 
	Case 
		When sched.freq_interval = 1 
		Then ' Sunday'
		When sched.freq_interval = 2 
		Then ' Monday'
		When sched.freq_interval = 3 
		Then ' Tuesday'
		When sched.freq_interval = 4 
		Then ' Wednesday'
		When sched.freq_interval = 5 
		Then ' Thursday'
		When sched.freq_interval = 6 
		Then ' Friday'
		When sched.freq_interval = 7 
		Then ' Saturday'
		When sched.freq_interval = 8 
		Then ' Day'
		When sched.freq_interval = 9 
		Then ' Weekday'
		When sched.freq_interval = 10 
		Then ' Weekend'
	End
	+ 
	Case 
		When sched.freq_recurrence_factor <> 0
					And sched.freq_recurrence_factor = 1 
		Then '; monthly'
		When sched.freq_recurrence_factor <> 0 
		Then '; every ' 
	+ Cast(sched.freq_recurrence_factor As varchar(10)) + ' months' 
	End
	When sched.freq_type = 64 
		Then 'StartUp'
	When sched.freq_type = 128 
		Then 'Idle'
	End As 'frequency'
	, IsNull('Every ' + Cast(sched.freq_subday_interval As varchar(10)) + 
	Case 
		When sched.freq_subday_type = 2 
		Then ' seconds'
		When sched.freq_subday_type = 4 
		Then ' minutes'
		When sched.freq_subday_type = 8 
		Then ' hours'
	End, 'Once') As 'subFrequency'
		, [Start_time] =  
		CASE LEN(sched.active_start_time)
			WHEN 1 THEN CAST('00:00:0' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(sched.active_start_time, 3), 1)
			+ ':' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(sched.active_start_time, 4), 2)
			+ ':' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(sched.active_start_time, 5), 1)
			+ ':' + LEFT(RIGHT(sched.active_start_time, 4), 2)
			+ ':' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(sched.active_start_time, 6), 2)
			+ ':' + LEFT(RIGHT(sched.active_start_time, 4), 2)
			+ ':' + RIGHT(sched.active_start_time, 2) AS CHAR(8))
		END
			, [End_time] =  
		CASE LEN(sched.active_end_time)
			WHEN 1 THEN CAST('00:00:0' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(sched.active_end_time, 3), 1)
			+ ':' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(sched.active_end_time, 4), 2)
			+ ':' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(sched.active_end_time, 5), 1)
			+ ':' + LEFT(RIGHT(sched.active_end_time, 4), 2)
			+ ':' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(sched.active_end_time, 6), 2)
			+ ':' + LEFT(RIGHT(sched.active_end_time, 4), 2)
			+ ':' + RIGHT(sched.active_end_time, 2) AS CHAR(8))
		END
	, Replicate('0', 6 - Len(jobsched.next_run_time)) 
		+ Cast(jobsched.next_run_time As varchar(6)) As 'nextRunTime'
	, Cast(jobsched.next_run_date As char(8)) As 'nextRunDate'
			From msdb.dbo.sysschedules As sched
				Join msdb.dbo.sysjobschedules As jobsched
				On sched.schedule_id = jobsched.schedule_id
		),
		JOB
		as
		(
			SELECT
				[job_id] =    job.job_id
	, [Job_Name] =   job.Name
	, [Job_Enabled] =  
		CASE job.Enabled
		WHEN 1 THEN 'Yes'
		WHEN 0 THEN 'No'
		END
	, [Owner] = (select l.name
	 from  msdb..sysjobs s 
	 left join master.sys.syslogins l on s.owner_sid = l.sid
	 WHERE s.name = job.name)
	, [Sched_ID] =   sched.schedule_id
	, [Sched_Enabled] =  
		CASE sched.enabled
			WHEN 1 THEN 'Yes'
			WHEN 0 THEN 'No'
		END
	, [Sched_Frequency] = 
		CASE sched.freq_type
			WHEN 1 THEN 'Once'
			WHEN 4 THEN 'Daily'
			WHEN 8 THEN 'Weekly'
			WHEN 16 THEN 'Monthly'
			WHEN 32 THEN 'Monthly relative'
			WHEN 64 THEN 'When SQLServer Agent starts'
		END
	, [Next_Run_Date] =  
		CASE next_run_date
			WHEN 0 THEN NULL
			ELSE SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 1, 4) + '/' +
			SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 5, 2) + '/' +
			SUBSTRING(CONVERT(VARCHAR(15), next_run_date), 7, 2)
		END
	, [Next_Run_Time] =  
		CASE LEN(next_run_time)
			WHEN 1 THEN CAST('00:00:0' + RIGHT(next_run_time, 2) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:' + RIGHT(next_run_time, 2) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(next_run_time, 3), 1)
			+ ':' + RIGHT(next_run_time, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(next_run_time, 4), 2)
			+ ':' + RIGHT(next_run_time, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(next_run_time, 5), 1)
			+ ':' + LEFT(RIGHT(next_run_time, 4), 2)
			+ ':' + RIGHT(next_run_time, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(next_run_time, 6), 2)
			+ ':' + LEFT(RIGHT(next_run_time, 4), 2)
			+ ':' + RIGHT(next_run_time, 2) AS CHAR(8))
		END
	, [Max_Duration] =  
		CASE LEN(max_run_duration)
			WHEN 1 THEN CAST('00:00:0'
			+ CAST(max_run_duration AS CHAR) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:'
			+ CAST(max_run_duration AS CHAR) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(max_run_duration, 3), 1)
			+ ':' + RIGHT(max_run_duration, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(max_run_duration, 4), 2)
			+ ':' + RIGHT(max_run_duration, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(max_run_duration, 5), 1)
			+ ':' + LEFT(RIGHT(max_run_duration, 4), 2)
			+ ':' + RIGHT(max_run_duration, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(max_run_duration, 6), 2)
			+ ':' + LEFT(RIGHT(max_run_duration, 4), 2)
			+ ':' + RIGHT(max_run_duration, 2) AS CHAR(8))
		END
	, [Min_Duration] =  
		CASE LEN(min_run_duration)
			WHEN 1 THEN CAST('00:00:0'
			+ CAST(min_run_duration AS CHAR) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:'
			+ CAST(min_run_duration AS CHAR) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(min_run_duration, 3), 1)
			+ ':' + RIGHT(min_run_duration, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(min_run_duration, 4), 2)
			+ ':' + RIGHT(min_run_duration, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(min_run_duration, 5), 1)
			+ ':' + LEFT(RIGHT(min_run_duration, 4), 2)
			+ ':' + RIGHT(min_run_duration, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(min_run_duration, 6), 2)
			+ ':' + LEFT(RIGHT(min_run_duration, 4), 2)
			+ ':' + RIGHT(min_run_duration, 2) AS CHAR(8))
		END
	, [Avg_Duration] =  
		CASE LEN(avg_run_duration)
			WHEN 1 THEN CAST('00:00:0'
			+ CAST(avg_run_duration AS CHAR) AS CHAR(8))
			WHEN 2 THEN CAST('00:00:'
			+ CAST(avg_run_duration AS CHAR) AS CHAR(8))
			WHEN 3 THEN CAST('00:0'
			+ LEFT(RIGHT(avg_run_duration, 3), 1)
			+ ':' + RIGHT(avg_run_duration, 2) AS CHAR(8))
			WHEN 4 THEN CAST('00:'
			+ LEFT(RIGHT(avg_run_duration, 4), 2)
			+ ':' + RIGHT(avg_run_duration, 2) AS CHAR(8))
			WHEN 5 THEN CAST('0'
			+ LEFT(RIGHT(avg_run_duration, 5), 1)
			+ ':' + LEFT(RIGHT(avg_run_duration, 4), 2)
			+ ':' + RIGHT(avg_run_duration, 2) AS CHAR(8))
			WHEN 6 THEN CAST(LEFT(RIGHT(avg_run_duration, 6), 2)
			+ ':' + LEFT(RIGHT(avg_run_duration, 4), 2)
			+ ':' + RIGHT(avg_run_duration, 2) AS CHAR(8))
		END
	, [Subday_Frequency] = 
			CASE (sched.freq_subday_interval)
			WHEN 0 THEN 'Once'
			ELSE CAST('Every '
			+ RIGHT(sched.freq_subday_interval, 2)
			+ ' '
			+ CASE (sched.freq_subday_type)
			WHEN 1 THEN 'Once'
			WHEN 4 THEN 'Minutes'
			WHEN 8 THEN 'Hours'
			END AS CHAR(16))
			END
	, [Sched_End Date] =  sched.active_end_date
	, [Sched_End Time] =  sched.active_end_time
	, [Fail_Notify_Name] = 
			CASE
			WHEN oper.enabled = 0 THEN 'Disabled: '
			ELSE ''
			END + oper.name
	, [Fail_Notify_Email] = oper.email_address
	, server
			FROM dbo.sysjobs job
				LEFT JOIN (SELECT
					job_schd.job_id
	, sys_schd.enabled
	, sys_schd.schedule_id
	, sys_schd.freq_type
	, sys_schd.freq_subday_type
	, sys_schd.freq_subday_interval
	, next_run_date = 
		CASE
			WHEN job_schd.next_run_date = 0 THEN sys_schd.active_start_date
			ELSE job_schd.next_run_date
		END
	, next_run_time = 
		CASE
			WHEN job_schd.next_run_date = 0 THEN sys_schd.active_start_time
			ELSE job_schd.next_run_time
		END
	, active_end_date = NULLIF(sys_schd.active_end_date, '99991231')
	, active_end_time = NULLIF(sys_schd.active_end_time, '235959')
				FROM dbo.sysjobschedules job_schd
					LEFT JOIN dbo.sysschedules sys_schd
					ON job_schd.schedule_id = sys_schd.schedule_id) sched
				ON job.job_id = sched.job_id
				LEFT OUTER JOIN (SELECT
					job_id, server
	, MAX(job_his.run_duration) AS max_run_duration
	, MIN(job_his.run_duration) AS min_run_duration
	, AVG(job_his.run_duration) AS avg_run_duration
				FROM dbo.sysjobhistory job_his
				GROUP BY job_id, server) Q1
				ON job.job_id = Q1.job_id
				LEFT JOIN sysoperators oper
				ON job.notify_email_operator_id = oper.id
		)
	SELECT b.job_name, b.job_enabled, isnull(b.sched_enabled,'No') as sched_enabled,
		isnull(a.scheduleName, 'None') as scheduleName, isnull(a.frequency,'Not scheduled') as frequency,
		isnull(a.subFrequency, 'None') as subFrequency, isnull(a.start_time,'-') as start_time, isnull(a.end_Time,'-') as end_time,
		isnull(b.Next_Run_Date, '-') as Next_Run_Date, isnull(b.Next_Run_Time, '-') as Next_Run_Time,
		isnull(b.Max_Duration, '-') as Max_Duration, isnull(b.Min_Duration, '-') as Min_Duration,
		isnull(b.Avg_Duration, '-') as Avg_Duration, isnull(b.Fail_Notify_Name, 'None') as Fail_Notify_Name,
		isnull(b.Fail_Notify_Email, 'None') as Fail_Notify_Email
	FROM SCHED a RIGHT OUTER JOIN JOB b
		ON a.job_id = b.job_id
	ORDER BY job_name
"@
}
function Get-SelectLogin {
	return 'SELECT Name, principal_id, sid, type, type_desc, is_disabled, create_date, modify_date, default_database_name, default_language_name, credential_id, owning_principal_id, is_fixed_role FROM sys.server_principals WHERE type = ''S'' OR type = ''U'' OR type = ''G'''
}
function Get-SelectTimezone {
	return @"
DECLARE @TimeZone VARCHAR(100)
EXEC MASTER.dbo.xp_regread 'HKEY_LOCAL_MACHINE',
'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
'TimeZoneKeyName',@TimeZone OUT
SELECT @TimeZone
"@
}
function Get-ExecProviders {
	return 'EXEC sys.sp_enum_oledb_providers'
}
# Server Migration Validation Tables
function Get-SourceLinkedServerTable { return '[src].[LinkedServer]' }
function Get-SourceLogShippingTable { return '[src].[LogShipping]' }
function Get-SourceMailStatusTable { return '[src].[MailStatus]' }
function Get-SourceMailTable { return '[src].[Mail]' }
function Get-SourceDatabaseSecurityTable { return '[src].[DatabaseSecurity]' }
function Get-SourceSSISTable { return '[src].[SSIS]' }
function Get-SourceSysAdminUserTable { return '[src].[SysAdminUser]' }
function Get-SourceServerAdminUserTable { return '[src].[ServerAdminUser]' }
function Get-SourceJobTable { return '[src].[Job]' }
function Get-SourceLoginTable { return '[src].[Login]' }
function Get-SourceTimezoneTable { return '[src].[Timezone]' }
function Get-SourceAdvancedSQLServerConfigurationTable { return '[src].[AdvancedSQLServerConfiguration]' }
function Get-SourceProvidersTable { return '[src].[Providers]' }

function Get-DestinationLinkedServerTable { return '[des].[LinkedServer]' }
function Get-DestinationLogShippingTable { return '[des].[LogShipping]' }
function Get-DestinationMailStatusTable { return '[des].[MailStatus]' }
function Get-DestinationMailTable { return '[des].[Mail]' }
function Get-DestinationDatabaseSecurityTable { return '[des].[DatabaseSecurity]' }
function Get-DestinationSSISTable { return '[des].[SSIS]' }
function Get-DestinationSysAdminUserTable { return '[des].[SysAdminUser]' }
function Get-DestinationServerAdminUserTable { return '[des].[ServerAdminUser]' }
function Get-DestinationJobTable { return '[des].[Job]' }
function Get-DestinationLoginTable { return '[des].[Login]' }
function Get-DestinationTimezoneTable { return '[des].[Timezone]' }
function Get-DestinationAdvancedSQLServerConfigurationTable { return '[des].[AdvancedSQLServerConfiguration]' }
function Get-DestinationProvidersTable { return '[des].[Providers]' }

# Remote Server Information Collection
function Get-SourceServerInformation {
	param(
		[string] $ServerName,
		[int] $ValidationID
	)
	Get-SQLServerInfo $ServerName (Get-ExecSPLinkedServer) (Get-SourceLinkedServerTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPLogShipping) (Get-SourceLogShippingTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPDBMailStatus) (Get-SourceMailStatusTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPDBMail) (Get-SourceMailTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectDatabaseSecurity) (Get-SourceDatabaseSecurityTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectSSIS) (Get-SourceSSISTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectSysAdminUser) (Get-SourceSysAdminUserTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectServerAdminUser) (Get-SourceServerAdminUserTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectJob) (Get-SourceJobTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectLogin) (Get-SourceLoginTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectTimezone) (Get-SourceTimezoneTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-AdvancedSQLServerConfiguration) (Get-SourceAdvancedSQLServerConfigurationTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecProviders) (Get-SourceProvidersTable) $ValidationID
}
function Get-DestinationServerInformation {
	param(
		[string] $ServerName,
		[int] $ValidationID
	)
	Get-SQLServerInfo $ServerName (Get-ExecSPLinkedServer) (Get-DestinationLinkedServerTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPLogShipping) (Get-DestinationLogShippingTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPDBMailStatus) (Get-DestinationMailStatusTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecSPDBMail) (Get-DestinationMailTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectDatabaseSecurity) (Get-DestinationDatabaseSecurityTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectSSIS) (Get-DestinationSSISTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectSysAdminUser) (Get-DestinationSysAdminUserTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectServerAdminUser) (Get-DestinationServerAdminUserTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectJob) (Get-DestinationJobTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectLogin) (Get-DestinationLoginTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-SelectTimezone) (Get-DestinationTimezoneTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-AdvancedSQLServerConfiguration) (Get-DestinationAdvancedSQLServerConfigurationTable) $ValidationID
	Get-SQLServerInfo $ServerName (Get-ExecProviders) (Get-DestinationProvidersTable) $ValidationID
}