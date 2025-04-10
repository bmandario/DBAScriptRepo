--Step 1, backup all tables that will need to be adjusted.
--PowerCaseHeader
SELECT * INTO [cdc].[dbo_PowerCaseHeader_CT_temp] FROM [cdc].[dbo_PowerCaseHeader_CT]

--PowerCaseDebitLine
SELECT * INTO [cdc].[dbo_PowerCaseDebitLine_CT_temp] FROM [cdc].[dbo_PowerCaseDebitLine_CT]

--Admin_reasonCodes
SELECT * INTO [cdc].[dbo_Admin_reasonCodes_CT_temp] FROM [cdc].[dbo_Admin_reasonCodes_CT]

--Step 2, Makes the changes here on the Temp tables
--PowerCaseHeader
ALTER TABLE [cdc].[dbo_PowerCaseHeader_CT_temp] ADD orderStatusDesc varchar (300)
ALTER TABLE [cdc].[dbo_PowerCaseHeader_CT_temp] ADD orderHoldDesc varchar (300)


--Step 3, Disable CDC on the existing tables in question
--NOTE: THIS WILL WIPE ALL EXISTING CDC TABLES FOR THE ASSOCIATED TABLES,
--PLEASE DOUBLE CHECK THE TEMP TABLES WERE CREATED
--Disable powercaseheader
BEGIN TRY  
DECLARE @source_name varchar(400);  
declare @sql varchar(1000)  
declare @dbname varchar(100)
Declare @enable bit

SET @dbname = ''---db name here
SET @enable = '0'---1 for on 0 for disable

DECLARE the_cursor CURSOR FAST_FORWARD FOR  
SELECT table_name  
FROM INFORMATION_SCHEMA.TABLES where TABLE_CATALOG=@dbname and table_schema='dbo' and table_name != 'systranschemas' 
--AND TABLE_NAME IN() ---Filter here
OPEN the_cursor  
FETCH NEXT FROM the_cursor INTO @source_name  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
if @enable = 1  
  
set @sql =' Use '+ @dbname+ ';EXEC sys.sp_cdc_enable_table  
            @source_schema = N''dbo'',@source_name = '+@source_name+'  
          , @role_name = N'''+'dbo'+''''  
            
else  
set @sql =' Use '+ @dbname+ ';EXEC sys.sp_cdc_disable_table  
            @source_schema = N''dbo'',@source_name = '+@source_name+',  @capture_instance =''all'''  
exec(@sql)  
  
  
  FETCH NEXT FROM the_cursor INTO @source_name  
  
END  
  
CLOSE the_cursor  
DEALLOCATE the_cursor  
  
      
SELECT 'Successful'  
END TRY  
BEGIN CATCH  
CLOSE the_cursor  
DEALLOCATE the_cursor  
  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH

----------Step 4, turn on CDC with the new columns-----------
---Re-run script above but with the the correct enable

-----------Step 5, copy existing data to new data-------------
--Disable powercaseheader
INSERT INTO cdc.dbo_PowerCaseHeader_CT SELECT * FROM cdc.dbo_PowerCaseHeader_CT_temp

--PowerCaseDebitLine
INSERT INTO cdc.dbo_PowerCaseDebitLine_CT SELECT * FROM cdc.dbo_PowerCaseDebitLine_CT_temp

--Admin_reasonCodes
INSERT INTO cdc.dbo_Admin_reasonCodes_CT SELECT * FROM cdc.dbo_Admin_reasonCodes_CT_temp

-----------Step 6, update lsns-----------------------------------------
--powercaseheader
UPDATE cdc.change_tables
SET start_lsn = (SELECT MIN(__$start_lsn) FROM cdc.dbo_PowerCaseHeader_CT_temp)
WHERE capture_instance = 'dbo_PowerCaseHeader';

--PowerCaseDebitLine
UPDATE cdc.change_tables
SET start_lsn = (SELECT MIN(__$start_lsn) FROM cdc.dbo_PowerCaseDebitLine_CT_temp)
WHERE capture_instance = 'dbo_PowerCaseDebitLine';

--Admin_reasonCodes
UPDATE cdc.change_tables
SET start_lsn = (SELECT MIN(__$start_lsn) FROM cdc.dbo_Admin_reasonCodes_CT_temp)
WHERE capture_instance = 'dbo_Admin_reasonCodes';

--Drop temp tables
DROP TABLE cdc.dbo_PowerCaseHeader_CT_temp
DROP TABLE cdc.dbo_PowerCaseDebitLine_CT_temp
DROP TABLE cdc.dbo_Admin_reasonCodes_CT_temp

--Check if CDC is working
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_PowerCaseHeader(sys.fn_cdc_get_min_lsn('dbo_PowerCaseHeader'), sys.fn_cdc_get_max_lsn(), 'all update old') ch
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_PowerCaseHeader(sys.fn_cdc_get_min_lsn('dbo_PowerCaseDebitLine'), sys.fn_cdc_get_max_lsn(), 'all update old') ch
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_PowerCaseHeader(sys.fn_cdc_get_min_lsn('dbo_Admin_reasonCodes'), sys.fn_cdc_get_max_lsn(), 'all update old') ch