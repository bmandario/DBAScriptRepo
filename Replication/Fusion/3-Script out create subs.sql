--Edit INSERT INTO @tablenames to include tables to add in replication 
SET NOCOUNT ON

DECLARE @table VARCHAR(50)   
DECLARE @statement NVARCHAR(max)
DECLARE @tablenames TABLE(
    name varchar(100) NOT NULL
);

INSERT INTO @tablenames (name) VALUES
('dynamic.Triage')
,('static.FusionProgram')
,('static.FusionProgramFlashingCodeMap')
,('static.FusionProgramQcCodeMap')
,('static.FusionProgramQLFailCodeMap')

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name from @tablenames

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @table  
WHILE @@FETCH_STATUS = 0  
BEGIN  

SELECT @statement = ''+ 
'USE [Fusion_Core];
EXEC sp_addsubscription @publication = N''FUSION_CORE_PUB''
, @subscriber = N''USPLPDWSQL1117''
, @destination_db = N''Fusion_Core''
, @sync_type = N''automatic''
, @article = N'''+ SUBSTRING(@table,CHARINDEX('.',@table)+1,LEN(@table))  +'''
, @reserved = ''internal''
GO
'

print @statement

FETCH NEXT FROM db_cursor INTO @table  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 