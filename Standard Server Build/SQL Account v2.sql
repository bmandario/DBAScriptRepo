--------------------Primary SQL Team SYSADMIN Account
USE [master]
GO

CREATE LOGIN [CORPORATE\NA_IM_SQL_ADM] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\NA_IM_SQL_ADM]
GO

CREATE LOGIN [ECOMMERCE\NA_IM_SQL_ADM] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\NA_IM_SQL_ADM]
GO

CREATE LOGIN [ECOMMERCESTG\NA_IM_SQL_ADM] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\NA_IM_SQL_ADM]
GO

------------------- CMDB Accounts
--  DROP LOGIN [corporate\svc-usaddu01]

if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin

  use master
  CREATE LOGIN [corporate\svc-usaddu01] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  GRANT VIEW SERVER STATE TO [corporate\svc-usaddu01]
  print '[corporate\svc-usaddu01]] created'

end

else if (select  COUNT (*) from master..syslogins where name like 'ecommerce\%') > 0 begin

  use master
  CREATE LOGIN [ecommerce\svc-usaddu02] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  GRANT VIEW SERVER STATE TO [ecommerce\svc-usaddu02]
  print '[ecommerce\usaddu02]] created'

end


------------------- Monitoring accounts
if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin

  use master
  CREATE LOGIN [corporate\svc-uspatu02] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  GRANT VIEW SERVER STATE TO [corporate\svc-uspatu02]
  print '[corporate\svc-uspatu02]] created'

end

else if (select  COUNT (*) from master..syslogins where name like 'ecommerce\%') > 0 begin

  use master
  CREATE LOGIN [ecommerce\svc-uspatu02] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  GRANT VIEW SERVER STATE TO [ecommerce\svc-uspatu02 ]
  print '[ecommerce\svc-uspatu02]] created'

end


/* CMDB Access to BPWW domain */
  use master
  CREATE LOGIN [BPWW\Svc-DiscoveryBPWW] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  GRANT VIEW SERVER STATE TO [BPWW\Svc-DiscoveryBPWW]


----------------------------- PATROL
--CREATE LOGIN [patrol] WITH PASSWORD = 0x01004A2F49A1457D178D70B9805ABBA234DD6EC6B1204DA2FF52 HASHED, SID = 0x825CC85446A0D54DA23E9B9FB32D0261, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
--go

--Patrol doesn't need sysadmin role
--EXEC master..sp_addsrvrolemember @loginame = [patrol], @rolename = N'sysadmin'
--go


----------------------------- CMS
Use master
GO
--drop LOGIN [corporate\SVC_SQLService]

if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin

  CREATE LOGIN [corporate\SVC_SQLService] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  EXEC master..sp_addsrvrolemember @loginame = [corporate\SVC_SQLService], @rolename = N'sysadmin'
  print '[corporate\SVC_SQLService] created'

end

else if (select  COUNT (*) from master..syslogins where name like 'ecommerce\%') > 0 begin

  CREATE LOGIN [ecommerce\SQLService] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  EXEC master..sp_addsrvrolemember @loginame = [ecommerce\SQLService], @rolename = N'sysadmin'
  print '[ecommerce\SQLService]] created'

end

else if (select  COUNT (*) from master..syslogins where name like 'ecommercestg\%') > 0 begin

  CREATE LOGIN [ecommerce\SQLService] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  EXEC master..sp_addsrvrolemember @loginame = [ecommerce\SQLService], @rolename = N'sysadmin'
  print '[ecommercestg\SVC_SQLService]] created'

end
-------------------SAVIYNT Accounts
-- DROP LOGIN [CORPORATE\svc_saviyntadmin]
-- DROP  USER [CORPORATE\svc_saviyntadmin]

--Windows account CORPORATE\svc_saviyntadmin no longer needed
/*if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin

  USE [master]
  CREATE LOGIN [CORPORATE\svc_saviyntadmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  print '[corporate\SVC_SQLService] created'

  USE [model]
  CREATE USER [CORPORATE\svc_saviyntadmin] FOR LOGIN [CORPORATE\svc_saviyntadmin]
  EXEC sp_addrolemember N'db_datareader', N'CORPORATE\svc_saviyntadmin'
  print 'add read access to model DB'

end*/

if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0
BEGIN

--USE [master]
--CREATE LOGIN [SVC_SAVIYNTADMIN] WITH PASSWORD = 0x0200FFE0C4921A2AF0F39FD3DC2704565964FD457A701EEAA0D0F320AFC4C91B0E0C1AE6C694038072577C990426BB5C23111B7B1724893DE2EC9F7B4A40E87402C0E7A12BDE HASHED, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF, DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]

--USE [model]
--CREATE USER [SVC_SAVIYNTADMIN] FOR LOGIN [SVC_SAVIYNTADMIN]
--EXEC sp_addrolemember N'db_datareader', N'SVC_SAVIYNTADMIN'

--END

-- Comvault OS 2012 higher for tape backup directly
--if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin
  --Use master
  --CREATE LOGIN [corporate\Svc-SQLCommvault] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
---DEFAULT_LANGUAGE=[us_english]
  ---EXEC master..sp_addsrvrolemember @loginame = [corporate\Svc-SQLCommvault], @rolename = N'sysadmin'
  --print '[corporate\Svc-SQLCommvault] created for SA access'
---end 


 ------------- SPOTLIGHT
--CREATE LOGIN [Spotlight] WITH PASSWORD = 0x0100DD78CD5CCAE7DEF666C95E94F936300496C6DD6D4437064C HASHED, SID = 0x04944D2DC04860418EBB8E889AF02B0B, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
--GO
--EXEC master..sp_addsrvrolemember @loginame = [Spotlight], @rolename = N'sysadmin'
--go


 -- Secret Server Account
if (select  COUNT (*) from master..syslogins where name like 'corporate\%') > 0 begin

  Use master
  CREATE LOGIN [CORPORATE\Svc-Thycoticadm] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
  EXEC master..sp_addsrvrolemember @loginame = [CORPORATE\Svc-Thycoticadm], @rolename = N'sysadmin'
  print '[CORPORATE\Svc-Thycoticadm] created for SA access'

end

-- Flexera Account
USE [master]
GO
CREATE LOGIN [CORPORATE\svc-rpa-flexera] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GRANT VIEW ANY DATABASE TO [CORPORATE\svc-rpa-flexera]
GRANT VIEW ANY DEFINITION TO [CORPORATE\svc-rpa-flexera]
GRANT VIEW SERVER STATE TO [CORPORATE\svc-rpa-flexera]
GO


------------- RUBRIK
USE [master]
GO
CREATE LOGIN [CORPORATE\Svc-rubrik-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\Svc-rubrik-admin]
GO

/****** Object:  Login [ECOMMERCE\Svc-rubrik-admin]    Script Date: 5/18/2019 2:27:55 PM ******/
CREATE LOGIN [ECOMMERCE\Svc-rubrik-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ECOMMERCE\Svc-rubrik-admin]
GO

CREATE LOGIN [ecommercestg\Svc-rubrik-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ecommercestg\Svc-rubrik-admin]
GO


------------- ACTIFIO
USE [master]
GO
CREATE LOGIN [CORPORATE\Svc-actifio-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\Svc-actifio-admin]
GO

USE [master]
GO
CREATE LOGIN [ecommerce\Svc-actifio-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ecommerce\Svc-actifio-admin]
GO

USE [master]
GO
CREATE LOGIN [ecommercestg\Svc-actifio-admin] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ecommercestg\Svc-actifio-admin]
GO


------------- CIS Tenable 
USE [master]
GO
CREATE LOGIN [CORPORATE\svc-cis-tenable] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORPORATE\svc-cis-tenable]
GO

USE [master]
GO
CREATE LOGIN [ECOMMERCE\svc-cis-tenable] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ECOMMERCE\svc-cis-tenable]
GO

  ------------- IAMSecurity-DBA
USE [master]
GO

IF NOT EXISTS (select * from sys.server_principals where name = 'CORPORATE\IAMSecurity-DBA')
CREATE LOGIN [CORPORATE\IAMSecurity-DBA] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
-- Create server role

IF NOT EXISTS (select * from sys.server_principals where name = 'AppServerSupport_Sec_DB_Op')
CREATE SERVER ROLE [AppServerSupport_Sec_DB_Op] AUTHORIZATION [sa]
GO

GRANT VIEW ANY DATABASE TO [AppServerSupport_Sec_DB_Op]
GO
GRANT VIEW ANY DEFINITION TO [AppServerSupport_Sec_DB_Op]
GO
GRANT CONNECT SQL TO [AppServerSupport_Sec_DB_Op]
GO
ALTER SERVER ROLE [AppServerSupport_Sec_DB_Op] ADD MEMBER [CORPORATE\IAMSecurity-DBA]
GO

-- Create database role AppDBSupport_IMSec_Read

Use master
GO

DECLARE @dbname VARCHAR(50)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name
FROM MASTER.dbo.sysdatabases
WHERE name not in ('master','msdb','tempdb', 'model')

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @dbname  
WHILE @@FETCH_STATUS = 0  
BEGIN  


-- added AppDBSupport_L4, custom role with ALTER permission
SELECT @statement = 'use ['+@dbname +'];'+ 
'IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE NAME = N''AppDBSupport_IMSec_Read'')
CREATE ROLE [AppDBSupport_IMSec_Read] AUTHORIZATION [dbo]
ALTER ROLE [db_datareader] ADD MEMBER [AppDBSupport_IMSec_Read]
GRANT EXECUTE TO [AppDBSupport_IMSec_Read];

IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE NAME = N''CORPORATE\IAMSecurity-DBA'')
CREATE USER [CORPORATE\IAMSecurity-DBA] FOR LOGIN [CORPORATE\IAMSecurity-DBA]
ALTER ROLE [AppDBSupport_IMSec_Read] ADD MEMBER [CORPORATE\IAMSecurity-DBA];'

print @statement
exec sp_executesql @statement

FETCH NEXT FROM db_cursor INTO @dbname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 


