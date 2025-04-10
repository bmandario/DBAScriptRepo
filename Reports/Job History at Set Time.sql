select 
 j.name as 'JobName',
 run_date,
 run_time,
 msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime'
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobhistory h 
 ON j.job_id = h.job_id 
where j.enabled = 1 AND msdb.dbo.agent_datetime(run_date, run_time) >= '2020-10-28 08:00:00.000' AND msdb.dbo.agent_datetime(run_date, run_time) <= '2020-10-28 16:00:00.000'--Only Enabled Jobs
order by JobName, RunDateTime desc