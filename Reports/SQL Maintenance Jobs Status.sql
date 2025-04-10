select @@SERVERNAME AS 'Server Name', NAME,enabled,CASE 
notify_level_email 
WHEN 0 THEN 'Not Enabled'
WHEN 1 THEN 'On Success'
WHEN 2 THEN 'On Failure'
WHEN 3 THEN 'ALWAYS'
END AS Notify_level_email
From msdb.dbo.sysjobs where name LIKE '$$%'
--INTO DBAWORK.dbo.Job_and_email_notify From msdb.dbo.sysjobs where name LIKE '$$%'--Uncomment and comment out above line if need to place into table