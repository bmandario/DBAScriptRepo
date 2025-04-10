SQL Server Installation:

Version: MS SQL Server 2014/2016 STD Edition

A project must justify the use of the enterprise edition.

ALWAYS INSTALL THE LATEST SERVICE PACK UNLESS THE APPLICATION DOES NOT SUPPORT IT.

Components:SQL Server engine, SQL Server agent, replication and SSIS on ALL database servers.Security:

WindowsGrant sysadmin access to the correct service account and the AD group: <DOMAIN>\NA_IM_SQL_ADMSA PasswordStandard

Sys AdminGrant sysadmin access to the service account and AD group: CORPORATE\NA_IM_SQL_ADM

ProductionSQLPRDService\SQLPRDAgent

StageSQLSTGService\SQLSTGAgent

DevelopmentSQLDEVService\SQLDEVAgent

CMDB AccessCorporate\svc-usaddu01Grant view server state to this user

Ecommerce\svc-usaddu02Grant view server state to this user



ScriptExecute SQL Accounts.sql on ALL servers



Services:

Make sure the SQL Server service and SQL Server Agent service is set to automatic and is running.

*SQL Service = sqlprdservice\sqldevservice\sqlstgservice

*SQL Agent = sqlprdagent\sqldevagent\sqlstgagent



Configuration:

Configure Database mail: Execute the script.

ScriptExecute script Server Build DBMail CorporateV2.sql or Server Build DBMail EcommerceV2.sql based on the domain.



Maintenance Plan:$$IM Database Maintenance

Create steps for rebuild, DBCC and update statistics:

$$IM Database Maintenance.DBCC  Schedule to run weekly on Saturday morning

$$IM Database Maintenance.IndexSchedule to run weekly on Sunday morning

$$IM Database Maintenance.StatsSchedule to run Mon thru Saturday mornning



DrivesPurposeComments

C:OS

D:ApplicationsLitespeed, trace files, etc

E:Data FilesE:\SQLDATA

F:Log FilesF:\SQLLOG

U:BackupPRODUCTION SERVERS ONLY, EXCEPT DORNACH**

**Unless stated but currently we are now using Rubrik** 