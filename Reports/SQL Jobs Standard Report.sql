USE MSDB
SET NOCOUNT ON;
SELECT  @@servername AS Server, 
j.[name] AS [JobName],
j.[enabled], 
j.date_created,
j.date_modified,
j.[notify_level_email],
CASE WHEN j.[notify_level_email] = 0 THEN 'Email Notification is not enabled'
WHEN j.[notify_level_email] = 1 THEN 'Notify On Success of the job'
WHEN j.[notify_level_email] = 2 THEN 'Notify On Failure of the job'
WHEN j.[notify_level_email] = 3 THEN 'Notify Always'
END AS [Notify_Level],
L.name AS Job_Owner,
email_address
FROM 
[dbo].[sysjobs] j
LEFT JOIN [dbo].[sysoperators] o ON (j.[notify_email_operator_id] = o.[id])
LEFT JOIN master.dbo.syslogins L ON J.owner_sid = L.sid
WHERE 
J.name <> 'LiteSpeed for SQL Server Update Native Backup statistics'
AND J.name <> 'syspolicy_purge_history'
AND J.name <> 'SQL Sentry 2.0 Alert Trap'
--and J.Name NOT like '%$$IM Database%'
--AND j.[enabled] = 1
GO