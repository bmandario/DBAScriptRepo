select 
Getdate(),
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
where name NOT IN ('master', 'msdb', 'model', 'tempdb')