USE DBA_WORK
go
create or alter procedure usp_TotalRowCount_Collect
as
/*
Description:  Collect total RowCount of tables.
History:  
	1- VN:  2021-03-18 - Created

Sample Call:  EXEC usp_TotalRowCount_Collect
*/
begin
SET NOCOUNT ON;

declare @WorkDB nvarchar(50), @WorkSchema nvarchar(10), @WorkTable nvarchar(100), @WorkTableFN nvarchar(1000),
		@TruncateTotalRowCountCMD nvarchar(max),
		@TotalTableRowCountCMD nvarchar(max),
		@DBname nvarchar(300);


set @WorkDB = N'DBA_WORK'
set @WorkSchema = N'dbo'
set @WorkTable = N'Table_RowCount'
set @WorkTableFN = N'[' + @WorkDB + '].[' + @WorkSchema + '].[' + @WorkTable + ']'

--select *  FROM DBA_WORK.INFORMATION_SCHEMA.TABLES 
if not exists (select 1 from dba_work.information_schema.tables 
				   where table_schema = @WorkSchema 
				   and table_name = @WorkTable
				   and table_catalog = @WorkDB)
begin
	CREATE TABLE [dbo].[Table_RowCount](
		[DatabaseName] [nvarchar](128) NULL,
		[SchemaName] [nvarchar](128) NULL,
		[TableName] [sysname] NOT NULL,
		[RowCount] [bigint] NULL,
		[InsDate] as current_timestamp
		)
end
else
begin
	set @TruncateTotalRowCountCMD = N'truncate table ' + @WorkTableFN
	EXEC sp_executesql @TruncateTotalRowCountCMD;
end

/* Sample script to collect total Rowcount
--insert into  DBA_WORK.dbo.Table_RowCount
SELECT      DB_Name() as DatabaseName, SCHEMA_NAME(sysobj.schema_id) as SchemaName, sysobj.Name as TableName, SUM(syspar.rows) AS 'RowCount'
	FROM        NAProviaPRD.sys.objects sysobj with (nolock)  
	INNER JOIN  NAProviaPRD.sys.partitions syspar with (nolock)   ON sysobj.object_id = syspar.object_id
	WHERE       sysobj.type = 'U'
	GROUP BY    sysobj.schema_id, sysobj.Name
*/


declare db_cursor cursor for 
select name from sys.databases where database_id > 4 
and is_read_only = 0
and state = 0

open db_cursor  
fetch next from db_cursor into @DBname  
while @@fetch_status = 0  
begin

	--Get The Total RowCount of each table
	set @TotalTableRowCountCMD = N'use [' + @DBname + '];
		insert into ' + @WorkTableFN +  '   
		SELECT      DB_Name() as DatabaseName, SCHEMA_NAME(sysobj.schema_id) as SchemaName, sysobj.Name as TableName, SUM(syspar.rows) AS ''RowCount''
			FROM        ' + @DBname + '.sys.objects sysobj with (nolock)  
			INNER JOIN  ' + @DBname + '.sys.partitions syspar with (nolock)   ON sysobj.object_id = syspar.object_id
			WHERE       sysobj.type = ''U''
			GROUP BY    sysobj.schema_id, sysobj.Name'


	print @TotalTableRowCountCMD
	EXEC sp_executesql @TotalTableRowCountCMD;

	fetch next from db_cursor into @DBname 
end 

close db_cursor  
deallocate db_cursor 

return

end;
GO
--========================================================================================