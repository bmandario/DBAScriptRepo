SELECT
  DISTINCT
         SERVERPROPERTY('ComputerNamePhysicalNetBIOS') as HostName ,a.Name AS DatabaseName , 
        (select sum(size) from (select database_id, type, size * 8.0 / 1024 size 
    from sys.master_files)fs where type = 0 and fs.database_id = a.database_id) DataFileSizeMB, 
    (select sum(size) from (select database_id, type, size * 8.0 / 1024 size 
    from sys.master_files)fs where type = 1 and fs.database_id = a.database_id) LogFileSizeMB, 
    (select sum(size) from (select database_id, type, size * 8.0 / 1024 size 
    from sys.master_files)fs where type = 0 and fs.database_id = a.database_id) + (select sum(size) from (select database_id, type, size * 8.0 / 1024 size 
    from sys.master_files)fs where type = 1 and fs.database_id = a.database_id) TotalDBSizeMB
        --C.FILETYPE, --C.FILENAME,
        
        ,CONVERT(SYSNAME, DATABASEPROPERTYEX(a.name, 'Recovery')) RecoveryModel ,
        COALESCE(( SELECT   CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'D'
                            AND is_copy_only = '0'
                 ), 'No Full') AS 'Full' ,
        COALESCE(( SELECT   CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'I'
                            AND is_copy_only = '0'
                 ), 'No Diff') AS 'Diff' ,
        COALESCE(( SELECT   CONVERT(VARCHAR(20), MAX(backup_finish_date), 120)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'L'
                 ), 'No Log') AS 'LastLog'
                 , backup_location = (select MAX(physical_device_name) from msdb.dbo.backupmediafamily c where c.media_set_id = max(b.media_set_id))
FROM    sys.databases a
        LEFT OUTER JOIN msdb.dbo.backupset b ON b.database_name = a.name
WHERE   a.name <> 'tempdb'
        AND a.state_desc = 'online'
GROUP BY a.Name ,a.database_id, a.compatibility_level
ORDER BY a.name