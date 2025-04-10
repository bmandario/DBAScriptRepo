select

b.database_name,

a.physical_device_name,

CAST(CAST(b.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS bkSize,

b.backup_start_date,

'BackupType' = case b.type WHEN 'D' THEN 'FULL backup' WHEN 'I' THEN 'DIFF Backup' WHEN 'L' THEN 'LOG Backup' END,

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

order by b.backup_start_date desc--b.backup_size desc--b.backup_start_date desc, b.database_name