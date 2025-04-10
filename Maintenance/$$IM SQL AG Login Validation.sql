USE [msdb]
GO

/****** Object:  Job [$$IM SQL AG Login Validation]    Script Date: 10/3/2024 6:35:50 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 10/3/2024 6:35:50 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'$$IM SQL AG Login Validation', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [SQL AG Login Validation]    Script Date: 10/3/2024 6:35:50 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'SQL AG Login Validation', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @tableHTML  NVARCHAR(MAX) ;  
DECLARE @SQLInstance1  NVARCHAR(50) = ''USCHWSQL1586A'' --SQL Instance on where you''ll put the Job
DECLARE @SQLInstance2  NVARCHAR(50) = ''USCHWSQL1586B'' 
DECLARE @mailsubject  NVARCHAR(200) ;  

SET @tableHTML =  
    N''<H3>''+@SQLInstance1+'' / ''+@SQLInstance2+'' AG Login Validation</H3>'' +  
    N''<table border="1">'' +  
    N''<tr><th>SQL Login</th><th>Status</th>'' +  
    N''</tr>'' +  
    CAST ( ( SELECT td = ISNULL(tbl1.name, tbl2.name),       '''',  
                    td = CASE
WHEN tbl1.name IS NULL then ''Login does not exist on ''+@SQLInstance1
WHEN tbl2.name IS NULL then ''Login does not exist on ''+@SQLInstance2
WHEN tbl1.sid <> tbl2.sid then ''SIDs do not match''
WHEN tbl1.password_hash <> tbl2.password_hash then ''Hashed Password do not match''
else ''Unknown''
END , ''''
FROM (SELECT ''''+@SQLInstance1+'''' "Server",sp.name, sp.sid, password_hash
FROM master.sys.server_principals AS sp
LEFT JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.type in (''U'',''G'',''S'') AND sp.name not like ''##%'' AND sp.name not in (''sa'') ) as tbl1
FULL OUTER JOIN
(SELECT ''''+@SQLInstance2+'''' "Server",sp.name, sp.sid, password_hash
FROM [USCHWSQL1586B].master.sys.server_principals AS sp
LEFT JOIN [USCHWSQL1586B].master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.type in (''U'',''G'',''S'') AND sp.name not like ''##%'' AND sp.name not in (''sa'') ) as tbl2 on tbl1.name = tbl2.name
WHERE tbl1.name IS NULL
OR tbl2.name IS NULL
OR tbl1.sid <> tbl2.sid
OR tbl1.password_hash <> tbl2.password_hash

              FOR XML PATH(''tr''), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N''</table>'' ;

SET @mailsubject = @SQLInstance1 + ''/'' +@SQLInstance2+'' AG Login Validation''
EXEC msdb.dbo.sp_send_dbmail @recipients=''sqldba2@ingrammicro.com'',  
    @subject = @mailsubject,  
    @body = @tableHTML,  
    @body_format = ''HTML'' ;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily 6PM', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220324, 
		@active_end_date=99991231, 
		@active_start_time=180000, 
		@active_end_time=235959, 
		@schedule_uid=N'2d84b80d-4f46-4f36-90b0-a5bd3ef959d2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


