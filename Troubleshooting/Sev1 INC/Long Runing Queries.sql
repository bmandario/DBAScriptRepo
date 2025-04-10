CREATE TABLE #sp_who2 (SPID INT,Status VARCHAR(255), 

      Login  VARCHAR(255),HostName  VARCHAR(255), 

      BlkBy  VARCHAR(255),DBName  VARCHAR(255), 

      sCommand VARCHAR(255),CPUTime INT, 

      DiskIO INT,LastBatch VARCHAR(255), 

      ProgramName VARCHAR(255),SPID2 INT, 

      REQUESTID INT) 

INSERT INTO #sp_who2 EXEC sp_who2 



SELECT 

DATEDIFF(s, r.start_time, getdate()) as sec_duration,

r.start_time [Start Time],

--r.percent_complete,

--r.estimated_completion_time,

 session_id [SPID],

 r.cpu_time,

 r.blocking_session_id,

 Db_name(database_id) [Database],

 s.Login, s.ProgramName,

 s.hostname,

 Substring(t.text, ( r.statement_start_offset / 2 ) + 1, CASE

 WHEN

 statement_end_offset=-1

or statement_end_offset=0 THEN (

 Datalength(t.text)-

 r.statement_start_offset / 2 ) + 1

 ELSE (

 r.statement_end_offset-r.statement_start_offset)/2+1

 END) [Executing SQL],

 r.status,

 command,

 wait_type,

 wait_time,

 wait_resource,

 last_wait_type

FROM sys.dm_exec_requests r

 OUTER apply sys.Dm_exec_sql_text(sql_handle) t

 inner join #sp_who2 s on r.session_id=s.SPID

WHERE session_id != @@SPID -- don't show this query

AND session_id > 50-- don't show system queries



ORDER BY r.start_time 



  

DROP TABLE #sp_who2 