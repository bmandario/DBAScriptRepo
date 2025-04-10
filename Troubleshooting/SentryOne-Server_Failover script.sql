---Run this on SentryOne DB if you need to failover to a different server node
USE SentryOne
select * from ManagementEngine 
--find server name and management engine
--USCHIZWSEN1001 = 1 in corporate

select D.ID,ME.ServerName , D.FullyQualifiedDomainName from device D
Join ManagementEngine ME
ON ME.ID=D.ManagementEngineID
where FullyQualifiedDomainName='USCHWSQL1261D.BPWW.ORG' ---Put server name here to see what node it is currently on and the ID of the server

update device
set ManagementEngineID=2 --What monitoring server it will be updated to
where id=337--Change ID to the server's ID here