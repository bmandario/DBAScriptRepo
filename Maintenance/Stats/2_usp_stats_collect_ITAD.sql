USE [DBA_WORK]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
alter procedure [dbo].[usp_stats_collect] as
/*
Description:  Collect stats with criteria modification>=500 OR last_updated < 3 days ago.

History:
1-	2021-03-16 - VN - Created
2-	2021-03-17 - VN:  Modified where conditions.  3 condition are added
3-	2021-04-16 - VN:  Removed ITAD condition and added DBA standard condition to update stats.
4-  2021-05-01 - VN:  V2 - New logic:  Loop on the maint table and update stats by table level
5-  2021-05-20 - VN:  Use ITAD standard for stats collection

Sample Call:  EXEC DBA_WORK.dbo.[usp_stats_collect] 
*/
begin
SET NOCOUNT ON;
set Deadlock_Priority Low;

declare @DatabaseName varchar(500),
		@DBCount int,
		@SQLCommand nvarchar(max), 
		@StatsUpdateCommand nvarchar(max),
		@RunID int,
		@ModCond1 nvarchar(50),
		@DayCond1 int,
		@Condition1 nvarchar(max),
		@ModCond2 nvarchar(50),
		@DayCond2 int,
		@Condition2 nvarchar(max),
		@Condition3 nvarchar(max);

/*Remove this standard, and use ITAD standard
--Condition 1 in where clause
--DBA standard: 
/* 
rowcount<1mil -> 10% mod vs rowcount
rowcount>1mil -> 20% mod vs rowcount
*/
set @ModCond1 = '0'
set @Condition1 = ' sp.modification_counter > ' + @ModCond1
*/

/*ITAD standard:*/

--Condition 1 in where clause
set @ModCond1 = '0'
set @DayCond1 = 3
set @Condition1 = ' sp.modification_counter > ' + @ModCond1 + ' and ' + 'dateDiff(dd,last_updated,Getdate())>' + cast(@DayCond1 as nvarchar(2))

--Condition 2 in where clause
set @ModCond2 = '500'
set @DayCond2 = 0
set @Condition2 = ' sp.modification_counter > ' + @ModCond2 + ' and ' + 'dateDiff(dd,last_updated,Getdate())>' + cast(@DayCond2 as nvarchar(2))

--Condition 3 in where clause 
set @Condition3 = 'obj.name like ''sys%''or b.name like ''sys%'' 
	or obj.name like ''%_bkp'' or obj.name like ''%_backup'' or obj.name like ''%_temp'' or obj.name like ''%_tmp'' or obj.name like ''%_stg'' or obj.name like ''%_staging''
	or obj.name like ''bkp_%'' or obj.name like ''backup_%'' or obj.name like ''temp_%'' or obj.name like ''tmp_%'' or obj.name like ''stg_%'' or obj.name like ''staging_%''
	or obj.name like ''MSpub%'' or obj.name like ''MSsub%'' or obj.name like ''MSpeer%'' 
	or obj.name like ''MIG_%''
	or obj.name like ''History_%''
	and obj.name NOT in (
		''History_PartsOrders'',
		''History_OrderStatus'',
		''History_Load'',
		''History_Repair'',
		''History_Warehouse'',
		''History_AssetFMVConversion'',
		''History_Comments'',
		''History_Detail_Pallet'',
		''History_CustomerInventoryStatus'',
		''History_JobSchedule'',
		''History_JobStatus'')'

create table #tempdatabases (DatabaseName varchar(max)) 
insert into #tempdatabases (DatabaseName) 
	select [name] from sys.databases where  database_id > 4 and [name] not in ('distribution', 'DBA_WORK')
	and is_read_only = 0 and state = 0 order by name

--Create logging table
if not exists (select 1 from dba_work.information_schema.tables 
				   where table_schema = 'dbo' 
					   and table_name = 'stats_maint_loop_by_table'
					   and table_catalog = 'dba_work')
begin
	create table DBA_WORK.dbo.stats_maint_loop_by_table
	( 
		RunID int,
		DatabaseName varchar(300), 
		TableName    varchar(300), 
		SchemaName   varchar(30),
		StatsName	 varchar(300),
		modification varchar(50),
		last_updated varchar(100),
		[rows]		 bigint,
		rows_sampled bigint,
		[row_sampled_pct]  as (rows_sampled * 100 / [rows]),
		TotalRows	 bigint,
		[mod_pct]	 bigint,
		InsertDate   datetime Not null DEFAULT CURRENT_TIMESTAMP,
		UpdateStatsBegin datetime,
		UpdateStatsEnd datetime,
		Completed bit default 0,
		[IsLocked] bit default 0,
		DenseRank int
	)
end

select @RunID = isnull(max(RunID),0) + 1 from DBA_WORK.dbo.stats_maint_loop_by_table 

--Create Error Handling table
if not exists (select 1 from dba_work.information_schema.tables 
				   where table_schema = 'dbo' 
					   and table_name = 'stats_maint_Error'
					   and table_catalog = 'dba_work')
begin
	create table DBA_WORK.dbo.stats_maint_Error
         (ErrorID        int identity(1, 1),
		  ErrorCommand	 nvarchar(1000),
          UserName       varchar(100),
          ErrorNumber    int,
          ErrorState     int,
          ErrorSeverity  int,
          ErrorLine      int,
          ErrorProcedure varchar(MAX),
          ErrorMessage   varchar(MAX),
          Errordatetime  datetime)
end

/*==================
	Looping database name
====================*/
declare @i int = 0
set @DBCOunt = (select Count(*) from #tempdatabases) 
while ( @i < @DBCOunt ) 
begin
	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '#tempstatistics%') 
	BEGIN
	   DROP TABLE #tempstatistics;
	END;
 
	create table #tempstatistics 
	( 
		DatabaseName varchar(max), 
		TableName    varchar(max), 
		SchemaName   varchar(max),
		StatsName    varchar(max),
		modification bigint,
		last_updated varchar(Max),
		[rows]		 varchar(30),
		rows_sampled varchar(30),
		TotalRows	 bigint,
		[mod_pct]	 as (case when TotalRows > 0 then (([modification]*(100))/[TotalRows]) else 0 end)
	) 

	declare @DBName varchar(max) 

	set @DBName=(select top 1 DatabaseName FROM   #tempdatabases) 
	/*Remove DBA Standard, add ITAD standard
	set @SQLCommand= 'use [' + @DBName + '];     
		select distinct ''' + @DBName+ '''
		, obj.name as TableName
		, b.name as SchemaName
		, stat.name as StatsName
		, sp.modification_counter as modification
		, sp.last_updated
		, sp.rows
		, sp.rows_sampled      
		FROM [' + @DBName+ '].sys.objects AS obj inner join ['+ @DBName + '].sys.schemas b on obj.schema_id=b.schema_id
			INNER JOIN [' + @DBName+ '].sys.stats AS stat ON stat.object_id = obj.object_id    
			CROSS APPLY [' + @DBName+'].sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp 
			WHERE (' + @Condition1 + ');'
	*/
	set @SQLCommand= 'use [' + @DBName + '];     
		select distinct ''' + @DBName+ '''
		, obj.name as TableName
		, b.name as SchemaName
		, stat.name as StatsName
		, sp.modification_counter as modification
		, sp.last_updated
		, sp.rows
		, sp.rows_sampled      
		FROM [' + @DBName+ '].sys.objects AS obj inner join ['+ @DBName + '].sys.schemas b on obj.schema_id=b.schema_id
			INNER JOIN [' + @DBName+ '].sys.stats AS stat ON stat.object_id = obj.object_id    
			CROSS APPLY [' + @DBName+'].sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp 
			WHERE (' + @Condition1 + ');'
	print @SQLCommand

	insert into #tempstatistics (DatabaseName, TableName, SchemaName, StatsName, modification, last_updated, [rows], rows_sampled) 
		EXEC Sp_executesql  @SQLCommand 
	
	--Update Current Table Total RowCount
	update t1
	set t1.TotalRows = t2.[RowCount]
	from #tempstatistics t1 inner join DBA_WORK.dbo.Table_RowCount t2 on t1.DatabaseName=t2.DatabaseName and t1.SchemaName=t2.SchemaName and t1.TableName=t2.TableName

	insert into DBA_WORK.dbo.stats_maint_loop_by_table (RunID, DatabaseName, TableName, SchemaName, StatsName, modification, last_updated, [rows], rows_sampled, TotalRows, [mod_pct]) 
		select @RunID, * from  #tempstatistics 
		--where (TotalRows < 1000000 and [mod_pct] > 10) or (TotalRows > 1000000 and [mod_pct] > 20)

	--Update DenseRank for each table/Stats
	select RunID, DatabaseName, TableName,	SchemaName,	StatsName,
	DENSE_RANK() OVER (ORDER BY DatabaseName, TableName) AS "DenseRank" 
	into #TableRankCount
	from DBA_WORK.[dbo].stats_maint_loop_by_table 
	where RunID = (select max(RunID) from DBA_WORK.[dbo].stats_maint_loop_by_table)

	update t1
	set t1.DenseRank = t2.DenseRank
	from DBA_WORK.[dbo].stats_maint_loop_by_table t1 join #TableRankCount t2
	on t1.RunID=t2.RunID 
		and t1.DatabaseName=t2.DatabaseName 
		and t1.schemaName=t2.SchemaName 
		and t1.TableName=t2.TableName
		and t1.StatsName=t2.StatsName

	set @i=@i + 1 
	delete from #tempdatabases where DatabaseName = @DBName 

	IF OBJECT_ID('tempdb..#TableRankCount') IS NOT NULL
		drop table #TableRankCount
end
 
IF OBJECT_ID('tempdb..#tempstatistics') IS NOT NULL
    DROP TABLE #tempstatistics
IF OBJECT_ID('tempdb..#tempdatabases') IS NOT NULL
    DROP TABLE #tempdatabases

/*
select * from DBA_WORK.dbo.stats_maint_loop_by_table
*/

/*=======================Criteria For ITAD===============================
--Condition 1 in where clause
set @ModCond1 = '0'
set @DayCond1 = 3
set @Condition1 = ' sp.modification_counter > ' + @ModCond1 + ' and ' + 'dateDiff(dd,last_updated,Getdate())>' + cast(@DayCond1 as nvarchar(2))

--Condition 2 in where clause
set @ModCond2 = '500'
set @DayCond2 = 0
set @Condition2 = ' sp.modification_counter > ' + @ModCond2 + ' and ' + 'dateDiff(dd,last_updated,Getdate())>' + cast(@DayCond2 as nvarchar(2))

--Condition 3 in where clause 
set @Condition3 = 'obj.name like ''sys%''or b.name like ''sys%'' 
	or obj.name like ''%_bkp'' or obj.name like ''%_backup'' or obj.name like ''%_temp'' or obj.name like ''%_tmp'' or obj.name like ''%_stg'' or obj.name like ''%_staging''
	or obj.name like ''bkp_%'' or obj.name like ''backup_%'' or obj.name like ''temp_%'' or obj.name like ''tmp_%'' or obj.name like ''stg_%'' or obj.name like ''staging_%''
	or obj.name like ''MSpub%'' or obj.name like ''MSsub%'' or obj.name like ''MSpeer%'' 
	or obj.name like ''MIG_%''
	or obj.name like ''History_%''
	and obj.name NOT in (
		''History_PartsOrders'',
		''History_OrderStatus'',
		''History_Load'',
		''History_Repair'',
		''History_Warehouse'',
		''History_AssetFMVConversion'',
		''History_Comments'',
		''History_Detail_Pallet'',
		''History_CustomerInventoryStatus'',
		''History_JobSchedule'',
		''History_JobStatus'')'

Update the line with this query command:
	set @SQLCommand= 'use [' + @DBName + '];     
		select distinct ''' + @DBName+ '''
		, obj.name as TableName
		, b.name as SchemaName
		, stat.name as StatsName
		, sp.modification_counter as modification
		, sp.last_updated
		, sp.rows
		, sp.rows_sampled      
		FROM [' + @DBName+ '].sys.objects AS obj inner join ['+ @DBName + '].sys.schemas b on obj.schema_id=b.schema_id
			INNER JOIN [' + @DBName+ '].sys.stats AS stat ON stat.object_id = obj.object_id    
			CROSS APPLY [' + @DBName+'].sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp 
			WHERE ((' + @Condition1 + ') or (' + @Condition2 + ')) 
			and NOT (' + @Condition3 + ');'
*/
return
end;

