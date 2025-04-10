--drop table #dblist

Create table #dblist
(Database_name nvarchar (max),
[type] nvarchar(10),
logical_name nvarchar (max),
physical_name nvarchar(max),
filesize decimal(10,2),
usedspace decimal(10,2),
freespace decimal(10,2),
freespace_percent decimal(10,2)
)

EXEC sp_msforeachdb

'

use [?]

insert into #dblist

SELECT
db_name(),
    [TYPE] = A.TYPE_DESC
    ,[FILE_Name] = A.name
    --,[FILEGROUP_NAME] = fg.name
    ,[File_Location] = A.PHYSICAL_NAME
    ,[FILESIZE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0)
    ,[USEDSPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - ((SIZE/128.0) - CAST(FILEPROPERTY(A.NAME, ''SPACEUSED'') AS INT)/128.0))
    ,[FREESPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, ''SPACEUSED'') AS INT)/128.0)
    ,[FREESPACE_%] = CONVERT(DECIMAL(10,2),((A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, ''SPACEUSED'') AS INT)/128.0)/(A.SIZE/128.0))*100)
   
FROM sys.database_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id
order by A.TYPE desc, A.NAME;

'
Select * from #dblist

DROP TABLE #dblist