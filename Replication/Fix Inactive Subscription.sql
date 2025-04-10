use distribution

go



select  * from MSpublications where publication = 'BOM_PUB'  -- publisher_id=9



select * from MSsubscriptions where 

subscriber_db = 'Master_BOM' and publisher_id = 9 and status <> 2





select top 10 * from master.dbo.sysservers where  srvname = 'usplpdwsql1117' --srvid = 3

--find subscriber name and ID: KCSRVOMEGA



select  * --into DBA_WORK.dbo.MSsubscriptions_BOM_PUB_1111_BOM_to_1117_MASTER_BOM

from MSsubscriptions 

where

    status <> 2 

and publication_id = 73

and publisher_id  = 9 

and subscriber_id = 3

and subscriber_db = 'MASTER_BOM'

-- 21 rows

/*

begin tran

update MSsubscriptions

set status =2 

where status <> 2 

and publication_id = 73

and publisher_id  = 9 

and subscriber_id = 3

and subscriber_db = 'MASTER_BOM'

-- commit

*/