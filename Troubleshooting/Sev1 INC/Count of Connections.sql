-- Updated with Database Name



SELECT DB_NAME(database_id) as DBName, ec.client_net_address, es.[program_name], es.[host_name], es.login_name, 

COUNT(ec.session_id) AS [connection count],

Count(CASE WHEN es.status = 'runnable' or es.status = 'running' THEN 1 END) AS [Active_Connections],

Count(CASE WHEN es.status = 'sleeping' THEN 1 END) AS [Inactive_Connections]

into #temp_DBA

FROM sys.dm_exec_sessions AS es  

INNER JOIN sys.dm_exec_connections AS ec  

ON es.session_id = ec.session_id   

WHERE program_name = 'IBM Cognos 10'------------------Filter here---------------------------

GROUP BY DB_NAME(database_id), ec.client_net_address, es.[program_name], es.[host_name], es.login_name, es.status  

ORDER BY ec.client_net_address, es.[program_name] DESC;



select * from #temp_DBA

DROP TABLE #temp_DBA

