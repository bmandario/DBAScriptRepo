IF OBJECT_ID('tempdb.dbo.##enterprise_features') IS NOT NULL
  DROP TABLE ##enterprise_features
 
CREATE TABLE ##enterprise_features
  (
     dbname       SYSNAME,
     feature_name VARCHAR(100),
     feature_id   INT
  )
 
EXEC sp_msforeachdb
N' USE [?] 
IF (SELECT COUNT(*) FROM sys.dm_db_persisted_sku_features) >0 
BEGIN 
   INSERT INTO ##enterprise_features 
    SELECT dbname=DB_NAME(),feature_name,feature_id 
    FROM sys.dm_db_persisted_sku_features 
END '
SELECT *
FROM   ##enterprise_features 