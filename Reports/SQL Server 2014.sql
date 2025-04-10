--To Generate the list of 2014 SQL Servers
--Run on USCHWSQL1498.discovery

select * from discovery.dbo.[sccm_SQL_Global_Pull]
where Release = '2014'
order by SErvername
