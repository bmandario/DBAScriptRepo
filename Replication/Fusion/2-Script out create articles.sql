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
EXEC sp_addarticle @publication = N''FUSION_CORE_PUB''
, @article = N'''+ SUBSTRING(@table,CHARINDEX('.',@table)+1,LEN(@table))  +'''
, @source_owner = N'''+ SUBSTRING (@table,0,CHARINDEX('.',@table)) +'''
, @source_object = N'''+ SUBSTRING(@table,CHARINDEX('.',@table)+1,LEN(@table)) +'''
, @type = N''logbased''
, @description = N''''
, @creation_script = N''''
, @pre_creation_cmd = N''drop''
, @schema_option = 0x00000000484358DF
, @identityrangemanagementoption = N''manual''
, @destination_table = N'''+ SUBSTRING(@table,CHARINDEX('.',@table)+1,LEN(@table)) +'''
, @destination_owner = N'''+ SUBSTRING (@table,0,CHARINDEX('.',@table)) +'''
, @status = 24
, @vertical_partition = N''false''
, @ins_cmd = N''CALL [sp_MSins_'+ REPLACE(@table, '.', '') +']''
, @del_cmd = N''CALL [sp_MSdel_'+ REPLACE(@table, '.', '') +']''
, @upd_cmd = N''SCALL [sp_MSupd_'+ REPLACE(@table, '.', '') +']''
GO
'

print @statement

FETCH NEXT FROM db_cursor INTO @table  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 