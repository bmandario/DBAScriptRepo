USE [master]

GO

sp_configure 'show advanced options',1

GO

RECONFIGURE WITH OVERRIDE

GO

sp_configure 'Database Mail XPs',1

GO

RECONFIGURE 

GO



-- Create a New Mail Profile for Notifications

EXECUTE msdb.dbo.sysmail_add_profile_sp

       @profile_name = 'DBA_Notifications',

       @description = 'Profile for sending Automated DBA Notifications'

GO



-- Set the New Profile as the Default

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp

    @profile_name = 'DBA_Notifications',

    @principal_name = 'public',

    @is_default = 1 ;

GO



-- Create an Account for the Notifications

EXECUTE msdb.dbo.sysmail_add_account_sp

    @account_name = 'SQLDBA',

    @description = 'Account for Automated DBA Notifications',

    @email_address = 'SQLDBA_MAILBOX@INGRAMMICRO.COM',

    @display_name = 'SQL DBA',

    @mailserver_name = 'uschizrelay.corporate.ingrammicro.com'
  --ECOMMERCE relay

GO



-- Add the Account to the Profile

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp

    @profile_name = 'DBA_Notifications',

    @account_name = 'SQLDBA',

    @sequence_number = 1

GO



--Create DBA mail operator

USE [msdb]

GO

EXEC msdb.dbo.sp_add_operator @name=N'DBA', 

@enabled=1, 

@pager_days=0, 

@email_address=N'SQLDBA_MAILBOX@INGRAMMICRO.COM'

GO



--Enable Mail Profile For SQL Agent

USE [msdb]

GO



DECLARE @ProductVersion varchar(128) = CONVERT(varchar(128), SERVERPROPERTY('ProductVersion'));

--Do this if the sql version is SQL 2008R2 or below

IF left(@ProductVersion,2) <11

     --Set the sql agent to use Database Mail and not SQLMail

     EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', N'REG_DWORD', 1;

IF left(@ProductVersion,2) <11

     --Set sql agent to use the 'MyDBMailProfile' mail profile

     EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', N'REG_SZ', N'DBA_Notifications';



ELSE



-- Do this if the sql version is above SQL 2008R2

EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1, 

@databasemail_profile=N'DBA_Notifications', 

@use_databasemail=1



GO
USE [msdb]
GO

/****** Object:  Job [$$IM Database Maintenance.Validation]    Script Date: 9/13/2024 10:22:17 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 9/13/2024 10:22:17 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'$$IM Database Maintenance.Validation', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Execute Query]    Script Date: 9/13/2024 10:22:17 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Execute Query', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF( 0 < 
(SELECT
count(*)
FROM
    msdb.dbo.sysjobs AS j
INNER JOIN
    (
        SELECT job_id, instance_id = MAX(instance_id)
            FROM msdb.dbo.sysjobhistory
            GROUP BY job_id
    ) AS l
    ON j.job_id = l.job_id
INNER JOIN
    msdb.dbo.sysjobhistory AS h
    ON h.job_id = l.job_id
    AND h.instance_id = l.instance_id 
WHERE J.Name IN(
''$$IM Database Maintenance.DBCC'',
''$$IM Database Maintenance.Index'',
''$$IM Database Maintenance.Stats'',
''$$ IM Database Maintenance.DBCC'',
''$$ IM Database Maintenance.Index'',
''$$ IM Database Maintenance.Stats''
) AND h.run_duration <= 3))
	EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = ''DBA_Notifications'',  
    @recipients = ''SQLDBA_Mailbox@ingrammicro.com'',  
    @subject = ''SentryOne Monitoring Server Failure'',  
	@query = ''SELECT @@SERVERNAME'',
    @body =  ''Please validate the maintenance jobs of the server in the email. Maintenance jobs are running in too low of a duration.''
ELSE IF (1=(select count(*) from msdb.dbo.sysjobs where date_created < GETDATE()-30 and name = ''$$IM Database Maintenance Job Validation''))
	EXEC sp_delete_job
		@job_name = N''$$IM Database Maintenance Job Validation''', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20240913, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'91548c01-250c-405b-83df-5b1b18b1940d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO




