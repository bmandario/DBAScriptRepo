------***** SCRIPT TO RESTORE MULTIPLE Databases*****-----

---CREATE A Stored Procedure first to get logical file names 
---Creating a temporary SP so that it lasts only for the session
USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE #sp_restore
  @backup_path NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    RESTORE FILELISTONLY FROM DISK = @backup_path;
END
GO

----- *****In another Query Editor run this script***** -----
-----Make sure to change folder paths---------

DECLARE @name NVARCHAR(256) -- database name 
DECLARE @backuppath NVARCHAR(256) -- path for backup files 
DECLARE @datapath NVARCHAR(256)--path for data files 
DECLARE @logpath NVARCHAR(256) --path for log files 
DECLARE @backupfileName NVARCHAR(256) -- filename for backup 
DECLARE @datafileName NVARCHAR(256)-- filename for database
DECLARE @logfileName NVARCHAR(256) -- filename for logfile
DECLARE @LogicalNameData AS NVARCHAR(255) --Db data logical name
DECLARE @LogicalNameLog AS NVARCHAR(255) --Db log logical name

DECLARE @cleanname AS NVARCHAR(255)
DECLARE @files TABLE (fname varchar(200),depth int, file_ int)

SET @backuppath = 'D:\Test\TestBackup\'  --Specify path of the folder where your backups from source are done.
SET @datapath = 'D:\Test\TestSQLDATA\'  
SET @logpath = 'D:\Test\TestSQLLOG\'

------ *****Table to hold each backup file name ***** ---------
INSERT @files
EXECUTE master.dbo.xp_dirtree @backuppath, 1, 1 --List off all the db;  example.BAK

-------- *****Cursor to iterate over the databases***** ------------
DECLARE files CURSOR FOR
SELECT fname FROM @files 

OPEN files
FETCH NEXT FROM files INTO @name   
WHILE @@FETCH_STATUS = 0  

BEGIN  
SET @backupfileName = @backuppath + @name

        ------ *****Finding logical names of db***** -------
DROP TABLE IF EXISTS #LogicalNames
CREATE TABLE #LogicalNames(LogicalName varchar(128),[PhysicalName] varchar(128), [Type] varchar, [FileGroupName] varchar(128), [Size] varchar(128), [MaxSize] varchar(128), [FileId]varchar(128), [CreateLSN]varchar(128), [DropLSN]varchar(128), [UniqueId]varchar(128), [ReadOnlyLSN]varchar(128), [ReadWriteLSN]varchar(128), [BackupSizeInBytes]varchar(128), [SourceBlockSize]varchar(128), [FileGroupId]varchar(128), [LogGroupGUID]varchar(128), [DifferentialBaseLSN]varchar(128), [DifferentialBaseGUID]varchar(128), [IsReadOnly]varchar(128), IsPresent]varchar(128), [TDEThumbprint]varchar(128), SnapshotURL varchar(128) )
INSERT #LogicalNames EXEC #sp_restore @backup_path=@backupfileName
SET @cleanname  = REPLACE(@name, '.BAK','')

SET @LogicalNameData=(SELECT LogicalName FROM #LogicalNames WHERE Type='D')
SET @LogicalNameLog=(SELECT LogicalName FROM #LogicalNames WHERE Type='L')
         
SET @datafileName = @datapath + @LogicalNameData   + '.MDF'
SET @logfileName = @logpath + @LogicalNameLog  + '.LDF'

RESTORE DATABASE @cleanname FROM DISK = @backupfileName WITH 
MOVE @LogicalNameData  TO @datafileName,
MOVE @LogicalNameLog TO @logfileName,
                STATS=5

FETCH NEXT FROM files INTO @name  
END  
CLOSE files  
DEALLOCATE files


