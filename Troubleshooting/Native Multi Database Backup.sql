--******* Script to back up multiple databases *********--
DECLARE @dbname VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
 
-- specify database backup directory
SET @path = 'E:\TestBackup\'  
 
DECLARE db_cursor CURSOR READ_ONLY FOR 
SELECT name
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases OR Do WHERE name IN (rYour dbs to back up)
 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @dbname   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @fileName = @path + @dbname +'.BAK'  
   BACKUP DATABASE @dbname TO DISK = @fileName  
 
   FETCH NEXT FROM db_cursor INTO @dbname   
END  
CLOSE db_cursor   
DEALLOCATE db_cursor