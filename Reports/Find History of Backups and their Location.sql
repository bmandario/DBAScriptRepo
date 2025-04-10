select 
b.database_name, 
a.physical_device_name, 
CAST(CAST(b.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS bkSize, 
b.backup_start_date, 
'BackupType' = case b.type WHEN 'D' THEN 'FULL backup' WHEN 'I' THEN 'DIFF Backup' WHEN 'L' THEN 'LOG Backup' END,
--b.backup_size/1024/1024 as sizeMB,
datename(dw, b.backup_start_date) as Start_DayOfWeek, 
b.backup_finish_date,
datename(dw, b.backup_finish_date) as Finish_DayOfWeek, 
datediff(ss,b.backup_start_date, b.backup_finish_date) as Duration
from msdb..backupmediafamily a, msdb..backupset b
where a.media_set_id = b.media_set_id 
AND (b.type ='D'
or b.type = 'I')
--and b.type <> 'L'
and b.database_name not in ('tempdb', 'LiteSpeedLocal')
--and b.database_name = 'QNXT_PLANDATA_WA'
--and b.database_name = 'MOSS_Content_Molina_Common'
--and b.backup_start_date > convert(varchar(12),getdate()-3,111) and b.backup_start_date < convert(varchar(12),getdate(),111)
--*** For COMMONSQL
--and (b.database_name like '%ODS%' or b.database_name like '%ENCOUNTER%')
--*** DRWORF
--and (b.database_name like '%CAE%')
--*** For DC01Q48RPTDBP01
--and (b.database_name like '%DETAILS' or b.database_name in ('MOLINADB_MI_STAFF','PLANTEMP','QNXT_PLANEVENT','QNXT_PLANINTEGRATION','QNXT_QCSIDB'))
order by b.backup_start_date desc--b.backup_size desc--b.backup_start_date desc, b.database_name
 
/*
select * from msdb..backupset where database_name='TEST_D'
select * from sysdatabases 
where 
name not in ('tempdb', 'LiteSpeedLocal')
--COMMONSQL
--and name like '%ODS%'or name like '%ENCOUNTER%'
--DRWORF
--and name like '%CAE%'
--*** For DC01Q48RPTDBP01
and (name like '%DETAILS' or name in ('MOLINADB_MI_STAFF','PLANTEMP','QNXT_PLANEVENT','QNXT_PLANINTEGRATION','QNXT_QCSIDB'))
 
++++++++++++++++++
SELECT TOP 5 b.type, b.first_lsn, b.last_lsn, b.checkpoint_lsn, b.database_backup_lsn, b.backup_start_date
FROM msdb..restorehistory a
INNER JOIN msdb..backupset b ON a.backup_set_id = b.backup_set_id
WHERE a.destination_database_name = 'Northwind'
ORDER BY restore_date DESC 
 
GO 
 
+++++++++++++++++
select
s1.type,
s1.backup_start_date,
s1.backup_finish_date,
s1.first_lsn,
s1.last_lsn,s1.checkpoint_lsn,
s1.database_backup_lsn,
s2.physical_device_name,
s1.backup_size,
datediff(second, s1.backup_start_date, s1.backup_finish_date)
from msdb..backupset s1 inner join msdb..backupmediafamily s2
on s1.media_set_id = s2.media_set_id
where s1.database_name ='Northwind' 
 and s1.type in('D','L','I')  -- sl.type in ('D','L') means full or Transaction Log backups  (if 'I', Differential backups)
and s1.backup_start_date >= (select max(backup_start_date) from msdb..backupset where database_name ='Northwind' and type ='D')   
 order by s1.backup_start_date 
 */
