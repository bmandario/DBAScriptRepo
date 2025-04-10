USE [DBA_WORK]
GO

/****** Object:  StoredProcedure [dbo].[usp_stats_update_by_StatsTable]    Script Date: 5/20/2021 11:30:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_stats_update_by_StatsTable]
as
/*
Description:  To Update statistics run in parallel (multithreading).  
			  A job is dynamically created (for each specified number of thread) and job to call this SP.
			  Each job loop into maint. table [stats_maint_loop_by_table], check if update stats (in one distinct table) is not running, pick that table and locked it, 
			  and start updating every single stats in the table.

History:
1-	2021-05-07 - VN - Created

Sample Call:  EXEC DBA_WORK.dbo.[usp_stats_update_by_StatsTable]
*/
begin
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @StatsList table 
( 
RunID int,
DatabaseName nvarchar(max), 
TableName    nvarchar(max), 
SchemaName   nvarchar(max),
StatsName    nvarchar(max),
DenseRank	 nvarchar(100)
) 

declare @RunID int, 
		@TableRank int, 
		@Islocked bit, 
		@MaxRunID int
select @MaxRunID = max(RunID) from DBA_WORK.[dbo].[stats_maint_loop_by_table] with (nolock)


declare TableStats_cursor CURSOR FOR 
	select distinct RunID, DenseRank from DBA_WORK.[dbo].[stats_maint_loop_by_table] with (nolock)
	where RunID = @MaxRunID
		and IsLocked = 0
		group by RunID, DenseRank
		order by DenseRank

open TableStats_cursor  
fetch next from TableStats_cursor into @RunID,  @TableRank

while @@FETCH_STATUS = 0  
begin 
	select @Islocked = IsLocked from DBA_WORK.[dbo].[stats_maint_loop_by_table] with (nolock)
		where DenseRank=@TableRank and RunID=@RunID
	if (@Islocked=0)
	begin
		--Lock table prior update stats occur on that table
		update t
		set t.isLocked = 1
		from DBA_WORK.[dbo].[stats_maint_loop_by_table] t WITH (nolock)
		where DenseRank=@TableRank and RunID=@RunID

		insert into @StatsList
		select  RunID int, DatabaseName, 
				TableName, SchemaName,
				StatsName, DenseRank	
				from DBA_WORK.[dbo].[stats_maint_loop_by_table] WITH (nolock)
				where DenseRank=@TableRank and RunID=@RunID

		/*==================
		Looping statistics
		====================*/
		declare @j int=0,
				@StatCount int;

		set @StatCount =(select Count(*) from @StatsList) 
		while @j < @StatCount 
		begin 
			declare @DatabaseName_Stats nvarchar(max), 
					@Table_Stats nvarchar(max),
					@Schema_Stats nvarchar(max), 
					@stats_Name nvarchar(max),
					@StatUpdateCommand nvarchar(max)

			select top 1 @DatabaseName_Stats=DatabaseName, 
					@Table_Stats=TableName, 
					@Schema_Stats=SchemaName,  
					@stats_Name=StatsName 
					from @StatsList

		
			set @StatUpdateCommand=N'Update Statistics [' + @DatabaseName_Stats 
									+ '].[' + @Schema_Stats + '].[' + @Table_Stats + '] ([' + @stats_Name
									+ ']) with fullscan;' 
			print 'Updating stat ... ' + @StatUpdateCommand

			begin try
				update st 
					set st.UpdateStatsBegin = CURRENT_TIMESTAMP
					from  DBA_WORK.dbo.stats_maint_loop_by_table st WITH (nolock)
					where DatabaseName = @DatabaseName_Stats 
						and TableName = @Table_Stats 
						and SchemaName = @Schema_Stats
						and StatsName = @stats_Name
						and Completed = 0
						and DenseRank = @TableRank
						and RunID = @RunID
				--=======================================================
				EXEC Sp_executesql 
					@StatUpdateCommand 
				--=======================================================
				update st 
					set st.UpdateStatsEnd = CURRENT_TIMESTAMP, Completed = 1
					from  DBA_WORK.dbo.stats_maint_loop_by_table st WITH (nolock)
					where DatabaseName = @DatabaseName_Stats 
						and TableName = @Table_Stats 
						and SchemaName = @Schema_Stats
						and StatsName = @stats_Name
						and Completed = 0
						and DenseRank = @TableRank
						and RunID = @RunID
			end try
			begin catch
				INSERT intO DBA_WORK.dbo.stats_maint_Error (RunID, ErrorCommand, UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage, Errordatetime)
				VALUES
					(@RunID,
					@StatUpdateCommand, 
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE());
			end catch

			set @j=@j + 1 
			delete from @StatsList 
				where  DatabaseName = @DatabaseName_Stats 
					and TableName = @Table_Stats 
					and SchemaName = @Schema_Stats
					and StatsName = @stats_Name 
		end -- while @j < @StatCount 
	end -- @Islocked=0
	WAITFOR DELAY '00:00:03'

	fetch next from  TableStats_cursor into @RunID,  @TableRank
end 

close TableStats_cursor  
deallocate TableStats_cursor 
end
GO


