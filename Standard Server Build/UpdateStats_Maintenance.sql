USE [DBA_Work]
GO

CREATE PROCEDURE [dbo].[uspIM_Database_Update_Stats] 
AS
BEGIN

DECLARE @dbname VARCHAR(max)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name
FROM sys.databases
WHERE name NOT IN ('master','model','msdb','tempdb','distribution','litespeedlocal','DBA_WORK','LocalListeSpeed80','SSISDB') AND state_desc = 'ONLINE'
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @dbname  
WHILE @@FETCH_STATUS = 0  
BEGIN  

 SET @statement = 'USE ['+ @dbname +']' + ' EXEC sp_updatestats'

EXEC sp_executesql @statement
--PRINT @statement
FETCH NEXT FROM db_cursor INTO @dbname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor
END
GO

EXEC uspIM_Database_Update_Stats