use DBA_WORK
go
alter procedure [dbo].[usp_stats_update_multithreaded_ByTable] (@NumOfThread int) as
/*
Description:  Update statistics in multi threaded (runn in parallel).  Each job continue run 1 table stats at a time until all table stats finished.

History:
1-	2021-04-25 - VN - Created

Sample Call:  EXEC DBA_WORK.dbo.[usp_stats_update_multithreaded_ByTable] @NumOfThread=3
*/
begin
SET NOCOUNT ON;
set Deadlock_Priority Low;

set NOCOUNT ON
declare @rc int,
		@thread int,
		@tblCount int,
		@tblCountEachList int

declare @WorkDB nvarchar(20),
		@timestamp nvarchar(14),
		@SublistTable nvarchar(100),
		@FQTableName nvarchar(1000),
		@DRankCond nvarchar(100),
		@SQLInsertSubTable nvarchar(max),
		@SQLDelTempTable nvarchar(max),
		@ProcName nvarchar(100)

set @thread = @NumOfThread
set @WorkDB = 'DBA_WORK'
set @timestamp = format(CURRENT_TIMESTAMP,'yyyyMMddHHmmss')
set @ProcName = 'usp_stats_update_by_StatsTable'

/*
--=====================
-- Take master stats list and mark each row based on DBname and TableName
--=====================
IF OBJECT_ID('tempdb..#TableRankCount') IS NOT NULL
    DROP TABLE #TableRankCount

select RunID, DatabaseName, TableName,	SchemaName,	StatsName,
	DENSE_RANK() OVER (ORDER BY DatabaseName, TableName) AS "DenseRank" 
	into #TableRankCount
	from DBA_WORK.[dbo].[stats_maint_statistic_level] 
	where RunID = (select max(RunID) from DBA_WORK.[dbo].[stats_maint_statistic_level])

select @tblCount = max(DenseRank) from #TableRankCount
set @tblCountEachList = @tblCount/@thread

select @tblCountEachList
*/
declare @HostSrv nvarchar(100),
		@JobName nvarchar(2000),
		@CmdStartJob nvarchar(500),
		@NameIncrement nvarchar(100)
set @HostSrv = @@SERVERNAME

declare @i int = 1
while (@i <= @thread)
begin
	set @NameIncrement = cast(@i as nvarchar(2)) + '_' + @timestamp
/*
	set @SublistTable = '__StatSublist_' + @NameIncrement
	set @FQTableName =  '[' + @WorkDB + '].[dbo].[' + @SublistTable + ']'
	--set @SQLCreateSubTable = 'create table [' + @WorkDB + '].[dbo].[' + @SublistTable + '] (' + @SublistColumn + ')'
	--print @SQLCreateSubTable

	if @i = @thread
		set @DRankCond = ''
	else
		set @DRankCond = 'where DenseRank <= ' + cast(@tblCountEachList*@i as nvarchar(10))

	--=====================
	--Split the master stats list into sublist table (depend on number of thread (@thread))
	--=====================
	set @SQLInsertSubTable = 'select * into ' + @FQTableName + ' from #TableRankCount ' + @DRankCond
	print @SQLInsertSubTable
	EXEC Sp_executesql @SQLInsertSubTable

	--==== Remove data from temp tabe after archived to sublist table
	set @SQLDelTempTable = 'delete from #TableRankCount ' + @DRankCond
	print @SQLDelTempTable
	EXEC Sp_executesql @SQLDelTempTable
*/
	--=====================
	--Create SQL Agent job for each sublist stats table (depend on number of thread)
	--=====================
	set @JobName = N'__IM_UpdateStats_ByTable_' + @NameIncrement
	EXEC DBA_WORK.dbo.usp_stats_job_create @JobName = @JobName, @DBName = @WorkDB, @ProcName=@ProcName

	set @CmdStartJob = N'EXEC msdb.dbo.sp_start_job N''' + @JobName + ''';'
	print @CmdStartJob 
		EXEC Sp_executesql  @CmdStartJob

	set @i = @i + 1
end
end;

GO