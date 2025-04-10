use [dbname];
Select SRVR=@@SERVERNAME, DB=db_name(a.database_id)
,sname=s.name, p.name
,plancached=cast(a.cached_time as date)
,PerM=a.execution_count/datediff(n,a.cached_time,Getdate())
,a.execution_count
,a.last_elapsed_time ,a.max_elapsed_time 
,AvgElapsedTime=(a.total_elapsed_time / a.execution_count)
,p.create_date, p.modify_date 
From sys.dm_exec_procedure_stats a with(nolock)
Inner join sys.procedures p with(nolock) on a.object_id = p.object_id 
Inner join sys.schemas s with(nolock) on p.schema_id=s.schema_id
WHERE a.database_id=DB_ID() --     current DB    
--and p.name in ('xxxx')
Order by p.name,a.last_elapsed_time-(a.total_elapsed_time / a.execution_count )   