SELECT 

[rs].[restore_date], 

[bs].[backup_start_date], 

[bs].[backup_finish_date], 

[bs].[database_name] as [source_database_name], 

[rs].[destination_database_name], 

bs.server_name as source_servername,

@@servername as destination_servername,

[bmf].[physical_device_name] as [backup_file_used_for_restore]

FROM msdb..restorehistory rs

INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]

INNER JOIN msdb..backupmediafamily bmf 

ON [bs].[media_set_id] = [bmf].[media_set_id] 

--restore operations in the past day

WHERE rs.restore_date > GETDATE()-1

ORDER BY [rs].[restore_date] DESC

