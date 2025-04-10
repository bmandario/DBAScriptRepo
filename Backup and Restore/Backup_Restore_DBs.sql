DECLARE @date CHAR(8)
SET @date = (SELECT CONVERT(char(8), GETDATE(), 112))
DECLARE @ticket VARCHAR(10)
-- Update ticket number here
SET @ticket = 'REQ123456'
DECLARE @path VARCHAR(125)
-- Make sure target path is correct and has enough storage
SET @path = 'D:\Backup\';
WITH
    MoveCmdCTE ( DatabaseName, MoveCmd )
    AS
    (
        SELECT DISTINCT
            DB_NAME(database_id) ,
            STUFF((SELECT ' ' + CHAR(13)+', MOVE ''' + name + ''''
+ CASE Type
WHEN 0 THEN ' TO ''E:\SQLData\'
ELSE ' TO ''F:\SQLLog\'
END
+ REVERSE(LEFT(REVERSE(physical_name),
CHARINDEX('\',
REVERSE(physical_name),
1) - 1)) + ''''
            FROM sys.master_files sm1
            WHERE sm1.database_id = sm2.database_ID
            FOR XML PATH('') ,
TYPE).value('.', 'varchar(max)'), 1, 1, '') AS MoveCmd
        FROM sys.master_files sm2
    )
SELECT
    'BACKUP DATABASE [' + name + '] TO DISK = ''' + @path + '' + name + '_' + @ticket + '_' + @date + '.bak''',
    'RESTORE DATABASE ['+ name + '] FROM DISK = ''' + @path + '' + name + '_' + @ticket + '_' + @date + '.bak'''+' WITH'+ STUFF(movecmdCTE.MoveCmd, CHARINDEX(',', movecmdCTE.MoveCmd), LEN(','), '') + '--, REPLACE'
FROM sys.databases d
    INNER JOIN MoveCMDCTE ON d.name = movecmdcte.databasename
WHERE d.name NOT IN('msdb','model','tempdb','master','distribution')
-- Uncomment below if you need to target specific databases
--AND d.name LIKE '' OR d.name LIKE '' OR d.name LIKE '' OR d.name LIKE ''