SELECT  st.text AS batch_text,
    SUBSTRING(st.TEXT, (qs.statement_start_offset / 2) + 1, ((CASE qs.statement_end_offset WHEN - 1 THEN DATALENGTH(st.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1) AS statement_text,
    (qs.total_worker_time / 1000) / qs.execution_count AS avg_cpu_time_ms,
    (qs.total_elapsed_time / 1000) / qs.execution_count AS avg_elapsed_time_ms,
    qs.total_logical_reads / qs.execution_count AS avg_logical_reads,
    (qs.total_worker_time / 1000) AS cumulative_cpu_time_all_executions_ms,
    (qs.total_elapsed_time / 1000) AS cumulative_elapsed_time_all_executions_ms,
	qs.creation_time, qs.last_execution_time
	--st.*
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
WHERE qs.creation_time between '2022-09-14 05:00:00' and '2022-09-14 21:00:00'--insert date
ORDER BY(qs.total_worker_time / qs.execution_count) DESC