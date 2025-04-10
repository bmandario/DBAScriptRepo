-- Modified UAR for RBAC. This will pick up ALL permissions.
if exists (select * from tempdb.sys.all_objects where name LIKE '%#Login_Audit%') 
drop table #Login_Audit 
create table #Login_Audit 
(DOMAIN nvarchar (500),SERVER nvarchar (500)default (''),DATABASES nvarchar (200)default (''), LOGIN_ID nvarchar (200)default (''), GROUP_ID nvarchar (200)default (''),LOGON_ID_TYPE nvarchar(200),Logon_ID_Account_status nvarchar(300) default ('Disabled'), Privilege_Type nvarchar(300) default ('Database Role'), Privilege nvarchar(300), Owner nvarchar(300)default(''),Approval nvarchar(300)default(''))
go 

---------Add Domain and Server-------
--insert into #Login_Audit  (DOMAIN, SERVER) 
--SELECT DEFAULT_DOMAIN(), @@SERVERNAME
--GO

------SYSTEM/SA--------
insert into #Login_Audit (DOMAIN, SERVER,LOGIN_ID,LOGON_ID_TYPE,Privilege) 
SELECT DEFAULT_DOMAIN(), @@SERVERNAME, a.name as logins ,a.type_desc,  c.name
FROM sys.server_principals a  
  INNER JOIN sys.server_role_members b ON a.principal_id = b.member_principal_id 
  INNER JOIN sys.server_principals c ON c.principal_id = b.role_principal_id
where a.is_disabled  = 0
ORDER BY c.name

---DB User Permissions---
insert into #Login_Audit  (DOMAIN, SERVER,DATABASES,Privilege,LOGIN_ID,LOGON_ID_TYPE) 
exec master.dbo.sp_MSforeachdb 'use [?] 
SELECT DEFAULT_DOMAIN(), @@SERVERNAME, db_name(), c.name,a.name, a.type_desc
FROM sys.database_principals a  
  INNER JOIN sys.database_role_members b ON a.principal_id = b.member_principal_id 
  INNER JOIN sys.database_principals c ON c.principal_id = b.role_principal_id 
WHERE a.name <> ''dbo'' AND db_name() <> ''msdb''
  AND c.owning_principal_id IS NOT NULL
  AND db_name() NOT IN (SELECT name from sys.databases where is_read_only = 1)
ORDER BY 1, 2, 3, 4' 
go

---Adjust formatting and Updating Rows Accordingly---
UPDATE #Login_Audit SET GROUP_ID = LOGIN_ID WHERE LOGON_ID_TYPE = 'WINDOWS_GROUP'
UPDATE #Login_Audit SET LOGIN_ID = '' WHERE LOGON_ID_TYPE = 'WINDOWS_GROUP'
UPDATE #Login_Audit SET LOGON_ID_TYPE = 'Domain Account' WHERE LOGON_ID_TYPE LIKE ('WINDOWS%')
UPDATE #Login_Audit SET LOGON_ID_TYPE = 'Local' WHERE LOGON_ID_TYPE = 'SQL_USER' OR LOGON_ID_TYPE = 'SQL_LOGIN'
UPDATE #Login_Audit SET Privilege_Type = 'Server Role' WHERE Privilege IN (SELECT name FROM SYS.server_principals WHERE type_desc = 'SERVER_ROLE')
UPDATE #Login_Audit SET Logon_ID_Account_status = 'Active' WHERE LOGIN_ID IN (SELECT a.name
FROM sys.server_principals a  
where a.is_disabled  = 0) 
OR 
GROUP_ID IN (SELECT a.name
FROM sys.server_principals a  
where a.is_disabled  = 0)
OR LOGON_ID_TYPE = 'DATABASE_ROLE'


--Update temp table with SQLDBA team fields
UPDATE #Login_Audit SET Owner ='SQL DBA Team', Approval = 'Y' WHERE 
LOGIN_ID = 'CORPORATE\NA_IM_SQL_ADM' OR GROUP_ID = 'CORPORATE\NA_IM_SQL_ADM'
OR LOGIN_ID = 'CORPORATE\sqlprdservice' OR GROUP_ID = 'CORPORATE\sqlprdservice'
OR LOGIN_ID = 'CORPORATE\sqlprdagent' OR GROUP_ID = 'CORPORATE\sqlprdagent'
OR LOGIN_ID = 'BPWW\NA_IMM_SQL_ADM' OR GROUP_ID = 'BPWW\NA_IMM_SQL_ADM'
OR LOGIN_ID = 'spotlight' OR GROUP_ID = 'spotlight'
OR LOGIN_ID = 'corporate\SVC_SQLService' OR GROUP_ID = 'corporate\SVC_SQLService'
OR LOGIN_ID = 'CORPORATE\sqlService' OR GROUP_ID = 'CORPORATE\sqlService'
OR LOGIN_ID = 'sqlrepl' or GROUP_ID = 'sqlrepl'
OR LOGIN_ID = 'BRIGHTPOINT\sql-repl'
OR LOGIN_ID = 'BRIGHTPOINT\SQL-SVC-INS1'
OR LOGIN_ID = 'BRIGHTPOINT\SQL-SVC-INS2'
OR LOGIN_ID = 'BRIGHTPOINT\SQL-SVC-INS3'
OR LOGIN_ID = 'SpotlightADM'
OR LOGIN_ID = 'distributor_admin'
OR LOGIN_ID = 'SQLSWAT'
OR LOGIN_ID = 'BRIGHTPOINT\sqlpdc01'
OR LOGIN_ID = 'BRIGHTPOINT\backupexec'
OR LOGIN_ID = 'test_linked'
OR LOGIN_ID = 'CORPORATE\na_sql_prd_service' OR GROUP_ID = 'CORPORATE\na_sql_prd_service'

--Update temp table with System accounts
UPDATE #Login_Audit SET Owner ='SQL DBA Team', Approval = 'Y' WHERE 
LOGIN_ID LIKE ('NT%')
OR LOGIN_ID LIKE ('sa')
OR LOGIN_ID = 'RSExecRole' OR GROUP_ID = 'RSExecRole'

--Update temp table with external monitoring
UPDATE #Login_Audit SET Owner ='IOC/ITSM', Approval = 'Y' WHERE 
LOGIN_ID = 'Patrol' OR GROUP_ID = 'Patrol'
OR LOGIN_ID = 'corporate\svc-uspatu01' or GROUP_ID = 'corporate\svc-uspatu01'

--Update temp table with Backup Team's accounts
UPDATE #Login_Audit SET Owner ='Backup Team', Approval = 'Y' WHERE 
LOGIN_ID = 'CORPORATE\Svc-rubrik-admin' OR GROUP_ID = 'CORPORATE\Svc-rubrik-admin'
OR LOGIN_ID = 'BRIGHTPOINT\Svc-rubrik-admin' OR GROUP_ID = 'BRIGHTPOINT\Svc-rubrik-admin'
OR LOGIN_ID = 'corporate\Svc-SQLCommvault' OR GROUP_ID = 'corporate\Svc-SQLCommvault'
OR LOGIN_ID = 'CORPORATE\SVC-ACTIFIO-ADMIN' OR GROUP_ID = 'BRIGHTPOINT\SVC-ACTIFIO-ADMIN'

--Update temp table with Security Team's accounts
UPDATE #Login_Audit SET Owner ='Security Team', Approval = 'Y' WHERE 
LOGIN_ID = 'CORPORATE\Svc-Thycoticadm' OR GROUP_ID = 'CORPORATE\Svc-Thycoticadm'
OR LOGIN_ID = 'svc_saviyntadmin' OR GROUP_ID = 'svc_saviyntadmin'
OR LOGIN_ID = 'CORPORATE\NA-InfoSec-Automation' OR GROUP_ID = 'CORPORATE\NA-InfoSec-Automation'

--Update temp table with Omniflow accounts
UPDATE #Login_Audit SET Owner ='Edgar Cosio', Approval = '' WHERE 
LOGIN_ID = 'CORPORATE\GSS ReadWrite' OR GROUP_ID = 'CORPORATE\GSS ReadWrite'
OR LOGIN_ID = 'prodAP' OR GROUP_ID = 'prodAP'
OR LOGIN_ID = 'CORPORATE\SVC_GSSADMIN_PROD' OR GROUP_ID = 'CORPORATE\SVC_GSSADMIN_PROD'

--Update temp table with IFS accounts
UPDATE #Login_Audit SET Owner ='Jitendra Patil', Approval = '' WHERE 
LOGIN_ID = 'ccuser' OR GROUP_ID = 'ccuser'
OR LOGIN_ID = 'ccuser%' OR GROUP_ID = 'ccuser%'
OR LOGIN_ID = 'dashboard_reader' OR GROUP_ID = 'dashboard_reader'
OR LOGIN_ID = 'IMD_User' OR GROUP_ID = 'IMD_User'
OR LOGIN_ID = 'NPI_User' OR GROUP_ID = 'NPI_User'
OR LOGIN_ID = 'IMDRIVEN' OR GROUP_ID = 'IMDRIVEN'
OR LOGIN_ID = 'NPI' OR GROUP_ID = 'NPI'
OR LOGIN_ID = 'imweb' OR GROUP_ID = 'imweb'
OR LOGIN_ID = 'SQLDCWriter' OR GROUP_ID = 'SQLDCWriter'
OR LOGIN_ID = 'CORPORATE\NA_IM_SCE_ADMIN' OR GROUP_ID = 'CORPORATE\NA_IM_SCE_ADMIN'
OR LOGIN_ID = 'imaware' OR GROUP_ID = 'imaware'
OR LOGIN_ID = 'IMFBOPAUDITUSER' OR GROUP_ID = 'IMFBOPAUDITUSER'
OR LOGIN_ID = 'webi' OR GROUP_ID = 'webi'
OR LOGIN_ID = 'tibco' OR GROUP_ID = 'tibco'
OR LOGIN_ID = 'bods' OR GROUP_ID = 'bods'
OR LOGIN_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_ADM' OR GROUP_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_ADM'
OR LOGIN_ID = 'CORPORATE\usjaig01' OR GROUP_ID = 'CORPORATE\usjaig01'
OR LOGIN_ID = 'db2' OR GROUP_ID = 'db2'
OR LOGIN_ID = 'seeburger' OR GROUP_ID = 'seeburger'
OR LOGIN_ID = 'xpp' OR GROUP_ID = 'xpp'
OR LOGIN_ID = 'CycleCount' OR GROUP_ID = 'CycleCount'
OR LOGIN_ID = 'snscreen' OR GROUP_ID = 'snscreen'
OR LOGIN_ID = 'IMFBODREPOUSER' OR GROUP_ID = 'IMFBODREPOUSER'
OR LOGIN_ID = 'ESMS' OR GROUP_ID = 'ESMS'
OR LOGIN_ID = 'ESMSSync' OR GROUP_ID = 'ESMSSync'
OR LOGIN_ID = 'ESMSSyncProd' OR GROUP_ID = 'ESMSSyncProd'
OR LOGIN_ID = 'CORPORATE\BG-EUSD-Level2-AdminAccounts' OR GROUP_ID = 'CORPORATE\BG-EUSD-Level2-AdminAccounts'
OR LOGIN_ID = 'CORPORATE\EU-EMEA-RIS-Application-Governance-ADM' OR GROUP_ID = 'CORPORATE\EU-EMEA-RIS-Application-Governance-ADM'
OR LOGIN_ID = 'reduser' OR GROUP_ID = 'reduser'
OR LOGIN_ID = 'IMFBOPREPO' OR GROUP_ID = 'IMFBOPREPO'
OR LOGIN_ID = 'WebAdmin' OR GROUP_ID = 'WebAdmin'
OR LOGIN_ID = 'ME\Milesadm' OR GROUP_ID = 'ME\Milesadm'
OR LOGIN_ID = 'ME\RaheelAdm' OR GROUP_ID = 'ME\RaheelAdm'
OR LOGIN_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_ADM' OR GROUP_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_ADM'
OR LOGIN_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_APP_ADM' OR GROUP_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_APP_ADM'
OR LOGIN_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_READ' OR GROUP_ID = 'CORPORATE\IM_MNL_SCE_SUPPORT_READ'
OR LOGIN_ID = 'CORPORATE\NA_IM_IWM_DEV' OR GROUP_ID = 'CORPORATE\NA_IM_IWM_DEV'
OR LOGIN_ID = 'CORPORATE\NA_IM_SCE_READ' OR GROUP_ID = 'CORPORATE\NA_IM_SCE_READ'
OR LOGIN_ID = 'iwmreader' OR GROUP_ID = 'iwmreader'
OR LOGIN_ID = 'readIWM' OR GROUP_ID = 'readIWM'

--Update temp table with IT2 accounts
UPDATE #Login_Audit SET Owner ='Scott Pauly/Shawn Khoda', Approval = '' WHERE 
LOGIN_ID = 'CORPORATE\svc_IT2APP_prd' OR GROUP_ID = 'CORPORATE\svc_IT2APP_prd'
OR LOGIN_ID = 'IT2APP' OR GROUP_ID = 'IT2APP'
OR LOGIN_ID = 'IT2\TFSAdmin' OR GROUP_ID = 'IT2\TFSAdmin'
OR LOGIN_ID = 'it2_admin' OR GROUP_ID = 'it2_admin'

--Update temp table with Control-M accounts
UPDATE #Login_Audit SET Owner ='Andrew Small', Approval = '' WHERE 
LOGIN_ID = 'ctmdb_user' OR GROUP_ID = 'ctmdb_user'
OR LOGIN_ID = 'ctmuser' OR GROUP_ID = 'ctmuser'
OR LOGIN_ID = 'emuser' OR GROUP_ID = 'emuser'
OR LOGIN_ID = 'ctmdbos_user' OR GROUP_ID = 'ctmdbos_user'
OR LOGIN_ID = 'ctmosuser' OR GROUP_ID = 'ctmosuser'
OR LOGIN_ID = 'emdb_admin' OR GROUP_ID = 'emdb_admin'

--Update temp table with MAS500/Sage accounts
UPDATE #Login_Audit SET Owner ='Elijah Law', Approval = '' WHERE 
LOGIN_ID = 'BRIGHTPOINT\gcrum' OR GROUP_ID = 'BRIGHTPOINT\gcrum'
OR LOGIN_ID = 'BRIGHTPOINT\US sPTI Assessors' OR GROUP_ID = 'BRIGHTPOINT\US sPTI Assessors'
OR LOGIN_ID = 'siuser' OR GROUP_ID = 'siuser'
OR LOGIN_ID = 'webuser' OR GROUP_ID = 'webuser'
OR LOGIN_ID = 'BRIGHTPOINT\USsMaterialsBOM' OR GROUP_ID = 'BRIGHTPOINT\USsMaterialsBOM'
OR LOGIN_ID = 'BRIGHTPOINT\USsRLPRD_SQL2BOM_ReadWrite' OR GROUP_ID = 'BRIGHTPOINT\USsRLPRD_SQL2BOM_ReadWrite'
OR LOGIN_ID = 'BRIGHTPOINT\TMO sFusion Web' OR GROUP_ID = 'BRIGHTPOINT\TMO sFusion Web'
OR LOGIN_ID = 'fusionuser' OR GROUP_ID = 'fusionuser' 
OR LOGIN_ID = 'IMMETL' OR GROUP_ID = 'IMMETL' 
OR LOGIN_ID = 'BRIGHTPOINT\IMM_FusionSpProcessing' OR GROUP_ID = 'BRIGHTPOINT\IMM_FusionSpProcessing'
OR LOGIN_ID = 'BRIGHTPOINT\USsITTesters' OR GROUP_ID = 'BRIGHTPOINT\USsITTesters'
OR LOGIN_ID = 'TSWLP\gITProgrammers' OR GROUP_ID = 'TSWLP\gITProgrammers' 
OR LOGIN_ID = 'ReportAccount' OR GROUP_ID = 'ReportAccount'

--Update temp table with Frankfurt accounts
UPDATE #Login_Audit SET Owner ='Ivan I. Ivanov/Christophe Hannedouche', Approval = '' WHERE 
LOGIN_ID = 'IMCC_APPS' OR GROUP_ID = 'IMCC_APPS'
OR LOGIN_ID = 'CORPORATE\dradzitzky-adm' OR GROUP_ID = 'CORPORATE\dradzitzky-adm'
OR LOGIN_ID = 'DSS_load' OR GROUP_ID = 'DSS_load' 
OR LOGIN_ID = 'jgreeng' OR GROUP_ID = 'jgreeng' 
OR LOGIN_ID = 'SofiaSupport' OR GROUP_ID = 'SofiaSupport'
OR LOGIN_ID = 'secdb' OR GROUP_ID = 'secdb' 
OR LOGIN_ID = 'CORPORATE\BG-EUSD-Level2-AdminAccounts' OR GROUP_ID = 'CORPORATE\BG-EUSD-Level2-AdminAccounts'
OR LOGIN_ID = 'CORPORATE\DEFR-WWTreasury-DSS-RW' OR GROUP_ID = 'CORPORATE\DEFR-WWTreasury-DSS-RW'

--Update temp table with WMS Accounts
UPDATE #Login_Audit SET Owner ='Patsy Finecy/Ryan Beckley', Approval = '' WHERE 
LOGIN_ID = 'evavi' OR GROUP_ID = 'evavi'
OR LOGIN_ID = 'WMSAdmin' OR GROUP_ID = 'WMSAdmin'

--Update temp table with AWS Accounts
UPDATE #Login_Audit SET Owner ='Manash Ghosh/Umang Gupta/Ronak Parikh/Camille Alvarez', Approval = '' WHERE 
LOGIN_ID = 'CORPORATE\AWS_GDW' OR GROUP_ID = 'CORPORATE\AWS_GDW'



SELECT * FROM #Login_Audit