USE [DBA_WORK]
GO
/****** Object:  StoredProcedure [dbo].[usp_stats_job_create]    Script Date: 5/20/2021 5:44:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[usp_stats_job_create] (@JobName varchar(100), @DBName varchar(100), @ProcName varchar(100))
as
begin
declare @srv nvarchar(100) = @@servername,
		@JobCommand nvarchar(max),
		@JobSP nvarchar(200),
		@StepName nvarchar(100)

set @JobSP = @ProcName 
set @StepName = N'Run Update Stats from Master List'
set @JobCommand = N'EXEC '+ @DBName +'.dbo.' + @JobSP 

--Add a job
EXEC msdb.dbo.sp_add_job
	@job_name = @JobName,
	@enabled=1, 
	@notify_level_eventlog=2, 
	@notify_level_email=2, 
	@notify_level_netsend=0, 
	@notify_level_page=0,  
	@description=N'No description available.', 
	@category_name=N'Database Maintenance',
	@owner_login_name=N'sa', 
	@notify_email_operator_name=N'DBA',
	@delete_level=1;

--Add a job step named process step. This step runs the stored procedure
EXEC msdb.dbo.sp_add_jobstep
    @job_name = @JobName,
    @step_name = @StepName,
    @subsystem = N'TSQL',
    @command = @JobCommand,
	@database_name=@DBName,
	@step_id=1, 
	@cmdexec_success_code=0, 
	@on_success_action=1, 
	@on_success_step_id=0, 
	@on_fail_action=2, 
	@on_fail_step_id=0, 
	@retry_attempts=0, 
	@retry_interval=0, 
	@os_run_priority=0;

EXEC msdb.dbo.sp_add_jobserver
    @job_name =  @JobName,
    @server_name = @srv;

end;
