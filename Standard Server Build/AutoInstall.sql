--AutoInstall
--Insert your request into request table, specify any details needed.  We can specify and change any values for the insert.  Please refer to table [USCHWSQL1321].[AutoInstall].[dbo].[Request]. 
insert into Request (DestSrv, DestIP, Core, Memory, InstanceName, SQLVersion, Edition, Env) 
values ('defrizwsql4301', '10.23.149.59', 4, 16, 'MSSQLSERVER', '2019', 'DEV', 'DEV') 

--Double check if your submitted request is complete and correct.
Select * from Request where ReqID = n
  
--In USCHWSQL1321.AutoInstall – 
Execute usp_AutoInstall @ReqIDEnter= n

**Note: n = your reqid
