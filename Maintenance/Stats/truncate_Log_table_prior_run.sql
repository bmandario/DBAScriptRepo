--keep only 7 Run
declare @RunIDToRetent int=0
select @RunIDToRetent=max(RunID)-7 from [dba_work].[dbo].[stats_maint_Error]

delete from [dba_work].[dbo].[stats_maint_Error] where RunID < @RunIDToRetent