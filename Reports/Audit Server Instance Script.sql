USE [msdb]
GO
/****** Object:  Job [$$ IM Database Monitoring - Audit]    Script Date: 3/14/2019 3:42:17 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 3/14/2019 3:42:17 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'$$ IM Database Monitoring - Audit', 
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
                    /****** Object:  Step [AUDIT]    Script Date: 3/14/2019 3:42:18 PM ******/
                    EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'AUDIT', 
                      @step_id=1, 
                        @cmdexec_success_code=0, 
                          @on_success_action=1, 
                            @on_success_step_id=0, 
                              @on_fail_action=2, 
                                @on_fail_step_id=0, 
                                  @retry_attempts=0, 
                                    @retry_interval=0, 
                                      @os_run_priority=0, @subsystem=N'TSQL', 
                                        @command=N'SET NOCOUNT ON
                                        USE [msdb]
                                        GO
                                        /****** Object:  Table [dbo].[AppServerConnections]    Script Date: 04/24/2012 10:30:28 ******/
                                        IF  NOT EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N''[dbo].[AppServerConnections]'') AND type in (N''U''))
                                        CREATE TABLE [dbo].[AppServerConnections](
                                             [servername] [varchar](30) NULL,
                                              [databasename] [varchar](100) NULL,
                                               [loginame] [varchar](100) NULL,
                                                [hostname] [varchar](30) NULL,
                                                 [last_batch] [datetime] NULL
                                        ) ON [PRIMARY]
                                        GO
                                        DECLARE @servername varchar(30) 
                                        DECLARE @databasename varchar (100)
                                        DECLARE @loginame varchar(100)
                                        DECLARE @hostname varchar(30)
                                        DECLARE @last_batch datetime
                                        declare user_audit cursor for
                                        SELECT DISTINCT @@servername as server,DB_NAME(dbid)as databasename,loginame,hostname,MAX(last_batch) as last_batch
                                        FROM master..sysprocesses WHERE LEN(hostname)>0 
                                        and DB_NAME(dbid) not in  (''master'',''model'',''msdb'',''tempdb'')
                                        GROUP BY hostname,DB_NAME(dbid),loginame
                                        open user_audit
                                        fetch next from user_audit into @servername,@databasename,@loginame,@hostname,@last_batch
                                        while (@@fetch_status = 0)
                                        begin
                                        --PRINT @servername,@varchar,@loginame,@hostname,@last_batch
                                        if exists (select * from AppServerConnections where [servername]=@servername and [databasename]=@databasename
                                        and [loginame]=@loginame and [hostname]=@hostname)
                                        update AppServerConnections
                                        set [last_batch]=@last_batch
                                        where [servername]=@servername and [databasename]=@databasename
                                        and [loginame]=@loginame and [hostname]=@hostname
                                        else 
                                        insert into AppServerConnections values (@servername,@databasename,@loginame,@hostname,@last_batch)

                                        fetch next from user_audit into @servername,@databasename,@loginame,@hostname,@last_batch
                                        end
                                        close user_audit
                                        deallocate user_audit
                                        GO
                                        SET NOCOUNT OFF', 
                                          @database_name=N'master', ------CHANGE DATABASE HERE
                                            @flags=0
                                            IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
                                            EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
                                            IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
                                            EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'AUDIT', 
                                              @enabled=1, 
                                                @freq_type=4, 
                                                  @freq_interval=1, 
                                                    @freq_subday_type=4, 
                                                      @freq_subday_interval=5, 
                                                        @freq_relative_interval=0, 
                                                          @freq_recurrence_factor=0, 
                                                            @active_start_date=20120516, 
                                                              @active_end_date=99991231, 
                                                                @active_start_time=0, 
                                                                  @active_end_time=235959, 
                                                                    @schedule_uid=N'33da46fc-efd9-4004-9c42-0ba1e86a6e0a'
                                                                    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
                                                                    EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
                                                                    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
                                                                    COMMIT TRANSACTION
                                                                    GOTO EndSave
                                                                    QuitWithRollback:
                                                                        IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
                                                                        EndSave:
                                                                        GO
                                                                        
                                        