USE msdb 
GO

WITH  MaintenanceSchedule AS
(select 
 sysjobs.job_id
,sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.freq_recurrence_factor
,case
 when freq_type = 4 then 'Daily'
end frequency
,
'every ' + cast (freq_interval as varchar(3)) + ' day(s)'  Days
,
case
 when freq_subday_type = 2 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' seconds' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 4 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' minutes' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 8 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' hours'   + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 else ' starting at ' 
 +stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
end time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
--where freq_type = 4

union

-- jobs with a weekly schedule
select
 sysjobs.job_id
,sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.freq_recurrence_factor
,case
 when freq_type = 8 then 'Weekly'
end frequency
,
replace
(
 CASE WHEN freq_interval&1 = 1 THEN 'Sunday, ' ELSE '' END
+CASE WHEN freq_interval&2 = 2 THEN 'Monday, ' ELSE '' END
+CASE WHEN freq_interval&4 = 4 THEN 'Tuesday, ' ELSE '' END
+CASE WHEN freq_interval&8 = 8 THEN 'Wednesday, ' ELSE '' END
+CASE WHEN freq_interval&16 = 16 THEN 'Thursday, ' ELSE '' END
+CASE WHEN freq_interval&32 = 32 THEN 'Friday, ' ELSE '' END
+CASE WHEN freq_interval&64 = 64 THEN 'Saturday, ' ELSE '' END
,', '
,''
) Days
,
case
 when freq_subday_type = 2 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' seconds' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 
 when freq_subday_type = 4 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' minutes' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 8 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' hours'   + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 else ' starting at ' 
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
end time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
--where freq_type = 8

)


,maxjobrun AS(
SELECT
job_id as job_id, 
max (cast (stuff(stuff(right('00000' + cast(run_duration as varchar),6),3,0,':'),6,0,':') as time)) AS  max_duration,
min (cast (stuff(stuff(right('00000' + cast(run_duration as varchar),6),3,0,':'),6,0,':') as time)) AS  min_duration
--avg (cast (stuff(stuff(right('00000' + cast(run_duration as varchar),6),3,0,':'),6,0,':') as time)) AS avg_duration
FROM sysjobhistory where cast (cast(run_date as nvarchar) as date) > getdate()-30 and run_status = 1
GROUP BY job_id
)

SELECT ServerProperty('MachineName') as Server, @@servername as Instance_Name, 
a.job_name, a.frequency, a.days, time, b.max_duration, b.min_duration--, b.avg_duration
FROM MaintenanceSchedule a  left join maxjobrun b on a.job_id = b.job_id
WHERE a.job_name like '$$%' and a.job_enabled = 1 and frequency is not null