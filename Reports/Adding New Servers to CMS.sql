select * from MSDB.DBO.sysmanagement_shared_server_groups_internal --210 is the ID of the group

select * from MSDB.DBO.sysmanagement_shared_server_groups_internal --Find the servers
--Create/import a table to USCHWSQL1321 SELECT * FROM DBA_WORK.dbo.[SOX NEW SERVERS TO ADD]
declare 
    @sql nvarchar(max),
    @db nvarchar(max)

declare db_cursor cursor local fast_forward for
SELECT * FROM DBA_WORK.dbo.[SOX NEW SERVERS TO ADD]

open db_cursor;

fetch next from db_cursor into @db;

while @@fetch_status = 0
begin


    set @sql = 'INSERT INTO msdb.dbo.sysmanagement_shared_registered_servers_internal VALUES(''210'','''+@db+''','+''''+@db+''','''','''')'
    exec sp_executesql @sql;
	--print @sql
    fetch next from db_cursor into @db;        
end;

close db_cursor;
deallocate db_cursor;

--DROP table when done
--DROP TABLE DBA_WORK.dbo.[SOX NEW SERVERS TO ADD]
