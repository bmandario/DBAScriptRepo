USE msdb
GO
SELECT DISTINCT SJ.Name AS JobName, SJ.description AS JobDescription,
SJH.run_date AS LastRunDate, 
CASE SJH.run_status 
WHEN 0 THEN 'Failed' 
WHEN 1 THEN 'Successful' 
WHEN 3 THEN 'Cancelled' 
WHEN 4 THEN 'In Progress' 
END AS LastRunStatus
FROM sysjobhistory SJH, sysjobs SJ
WHERE SJH.job_id = SJ.job_id and SJH.run_date = 
(SELECT MAX(SJH1.run_date) FROM sysjobhistory SJH1 WHERE SJH.job_id = SJH1.job_id)
and SJH.run_status = 0 and SJ.Name like '$$%'
ORDER BY SJH.run_date desc