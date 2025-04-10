SELECT @@SERVERNAME

EXECUTE master.dbo.xp_servicecontrol N'START', N'SQLServerAGENT';
EXECUTE master.dbo.xp_servicecontrol N'START', N'SQLBrowser'

WAITFOR DELAY '00:01';
       
EXECUTE master.dbo.xp_servicecontrol 'QUERYSTATE', 'MSSQLServer'
EXECUTE master.dbo.xp_servicecontrol 'QUERYSTATE', 'SQLServerAgent'

select 
a.name,
--a.state_desc,
case 
When a.state = 0 then 'ONLINE'
when a.state = 1 then 'RESTORING'
when a.state = 2 then 'RECOVERING'
when a.state = 3 then 'RECOVERY_PENDING'
when a.state = 4 then 'SUSPECT'
when a.state = 5 then 'EMERGENCY'
when a.state = 6 then 'OFFLINE'
when a.state = 7 then 'COPYING - SQL AZURE'
when a.state = 10 then 'OFLINE_SECONDARY - SQL AZURE'
end AS Status
from sys.databases a

DBCC SQLPERF(LOGSPACE);

EXECUTE master..xp_fixeddrives
