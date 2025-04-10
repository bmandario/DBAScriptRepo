alter procedure usp_Stats_Maint_Failed_Alert as
/*
Description:  to alert any failure from multi-threaded statistics update
History:
1-  2021-06-12:  VN - Created
*/
begin

declare @servername nvarchar(200) = @@servername 
declare @subj varchar(max)
declare @tablehtml  nvarchar(max) ;  
  
if exists (select top 1 * from [dba_work].[dbo].[stats_maint_Error]
               where RunID = (select max(RunID) from [dba_work].[dbo].[stats_maint_loop_by_table])
			)
begin
	set @tablehtml =  
		N'<H3>List of statistics that update was failed in the lat stats maintenance</H3>' +
		N'<H5>Please review and fix the below update-stats errors:</H5>' + 
		N'<table border="1">' +  
		N'<tr><th>Server Name</th><th>Run ID</th><th>Err Command</th><th>Err Procedure</th><th>Err Message/th>' +  
		cast ( ( select td = @servername,       '',  
						td = [RunID], '',
						td = [ErrorCommand], '',
						td = [ErrorProcedure], '',
						td = [ErrorMessage], '',  '' 
						from [dba_work].[dbo].[stats_maint_Error]
						where RunID = (select max(RunID) from [dba_work].[dbo].[stats_maint_loop_by_table])
				  for xml path('tr'), type   
		) as nvarchar(max) ) +  
		N'</table>' ;

	set @subj = '[Stats Maint] - ' + @servername + ' - Multi-threaded statistics failed'
	exec msdb.dbo.sp_send_dbmail @recipients='sqldba2@ingrammicro.com',  
		@subject = @subj,  
		@body = @tablehtml,  
		@body_format = 'HTML' ;
end
end;
