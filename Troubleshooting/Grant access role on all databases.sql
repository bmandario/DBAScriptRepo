Use master
GO

DECLARE @dbname VARCHAR(50)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name
FROM MASTER.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb','LiteSpeedLocal')  
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @dbname  
WHILE @@FETCH_STATUS = 0  
BEGIN  

SELECT @statement = 'use '+@dbname +';'+ 'CREATE USER [BIUser] 
FOR LOGIN [BIUser]; EXEC sp_addrolemember N''db_datareader'', 
[BIUser];'


exec sp_executesql @statement

FETCH NEXT FROM db_cursor INTO @dbname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 