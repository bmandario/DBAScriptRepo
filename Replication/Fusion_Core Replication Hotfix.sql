use Fusion_Core
go
select art.pubid, pub.name as pubName, substring(art.ins_cmd,16,3) as source_schema_3letter, 
sub.artid, art.name, art.dest_owner as dest_schema, sub.dest_db, sub.srvname as SubServer,  
case pub.repl_freq when 0 then 'Transactional' when 1 then 'snapshot' end ReplType
--sub.login_name
from syssubscriptions sub with (nolock) inner join sysarticles art with (nolock) 
on sub.artid = art.artid inner join syspublications pub with (nolock) on art.pubid = pub.pubid
where art.name 
in (
'FusionProgramUsers','WaterTestCodeMap' ,'ShippingCompletedPOs','LTwoRepairDetail','LTwoRepair'
);


Exec sp_dropsubscription @publication =  'FUSION_CORE_PUB' , @article =  'FusionProgramUsers', @subscriber =  'USPLPDWSQL1117';
go
Exec sp_droparticle @publication = 'FUSION_CORE_PUB', @article = 'FusionProgramUsers';
go

Exec sp_dropsubscription @publication =  'FUSION_CORE_PUB' , @article =  'WaterTestCodeMap', @subscriber =  'USPLPDWSQL1117';
go
Exec sp_droparticle @publication = 'FUSION_CORE_PUB', @article = 'WaterTestCodeMap';
go

Exec sp_dropsubscription @publication =  'FUSION_CORE_PUB' , @article =  'ShippingCompletedPOs', @subscriber =  'USPLPDWSQL1117';
go
Exec sp_droparticle @publication = 'FUSION_CORE_PUB', @article = 'ShippingCompletedPOs';
go

Exec sp_dropsubscription @publication =  'FUSION_CORE_PUB' , @article =  'LTwoRepairDetail', @subscriber =  'USPLPDWSQL1117';
go
Exec sp_droparticle @publication = 'FUSION_CORE_PUB', @article = 'LTwoRepairDetail';
go

Exec sp_dropsubscription @publication =  'FUSION_CORE_PUB' , @article =  'LTwoRepair', @subscriber =  'USPLPDWSQL1117';
go
Exec sp_droparticle @publication = 'FUSION_CORE_PUB', @article = 'LTwoRepair';
go


-- Verify the drop
select * from syssubscriptions where artid in (183, 223,224,363,469)
select * from sysarticles where name in ('FusionProgramUsers', 'WaterTestCodeMap' ,'ShippingCompletedPOs','LTwoRepairDetail','LTwoRepair')

-- Add the tables back
exec sp_addarticle 
 @publication = N'FUSION_CORE_PUB', 
 @article = N'FusionProgramUsers', 
 @source_owner = N'dbo', 
 @source_object = N'FusionProgramUsers', 
 @type = N'logbased', 
 @description = N'', 
 @creation_script = N'', 
 @pre_creation_cmd = N'drop', 
 @schema_option = 0x00000000484358DF, 
 @identityrangemanagementoption = N'manual', 
 @destination_table = N'FusionProgramUsers', 
 @destination_owner = N'dbo', 
 @status = 24, 
 @vertical_partition = N'false', 
 @ins_cmd = N'CALL [sp_MSins_dboFusionProgramUsers]', 
 @del_cmd = N'CALL [sp_MSdel_dboFusionProgramUsers]', 
 @upd_cmd = N'SCALL [sp_MSupd_dboFusionProgramUsers]'
GO

exec sp_addarticle 
 @publication = N'FUSION_CORE_PUB', 
 @article = N'WaterTestCodeMap', 
 @source_owner = N'static', 
 @source_object = N'WaterTestCodeMap', 
 @type = N'logbased', 
 @description = N'', 
 @creation_script = N'', 
 @pre_creation_cmd = N'drop', 
 @schema_option = 0x00000000484358DF, 
 @identityrangemanagementoption = N'manual', 
 @destination_table = N'WaterTestCodeMap', 
 @destination_owner = N'static', 
 @status = 24, 
 @vertical_partition = N'false', 
 @ins_cmd = N'CALL [sp_MSins_staticWaterTestCodeMap]', 
 @del_cmd = N'CALL [sp_MSdel_staticWaterTestCodeMap]', 
 @upd_cmd = N'SCALL [sp_MSupd_staticWaterTestCodeMap]'
GO

exec sp_addarticle 
 @publication = N'FUSION_CORE_PUB', 
 @article = N'ShippingCompletedPOs', 
 @source_owner = N'dynamic', 
 @source_object = N'ShippingCompletedPOs', 
 @type = N'logbased', 
 @description = N'', 
 @creation_script = N'', 
 @pre_creation_cmd = N'drop', 
 @schema_option = 0x00000000484358DF, 
 @identityrangemanagementoption = N'manual', 
 @destination_table = N'ShippingCompletedPOs', 
 @destination_owner = N'dynamic', 
 @status = 24, 
 @vertical_partition = N'false', 
 @ins_cmd = N'CALL [sp_MSins_dynamicShippingCompletedPOs]', 
 @del_cmd = N'CALL [sp_MSdel_dynamicShippingCompletedPOs]', 
 @upd_cmd = N'SCALL [sp_MSupd_dynamicShippingCompletedPOs]'
GO

exec sp_addarticle 
 @publication = N'FUSION_CORE_PUB', 
 @article = N'LTwoRepairDetail', 
 @source_owner = N'dynamic', 
 @source_object = N'LTwoRepairDetail', 
 @type = N'logbased', 
 @description = N'', 
 @creation_script = N'', 
 @pre_creation_cmd = N'drop', 
 @schema_option = 0x00000000484358DF, 
 @identityrangemanagementoption = N'manual', 
 @destination_table = N'LTwoRepairDetail', 
 @destination_owner = N'dynamic', 
 @status = 24, 
 @vertical_partition = N'false', 
 @ins_cmd = N'CALL [sp_MSins_dynamicLTwoRepairDetail]', 
 @del_cmd = N'CALL [sp_MSdel_dynamicLTwoRepairDetail]', 
 @upd_cmd = N'SCALL [sp_MSupd_dynamicLTwoRepairDetail]'
GO

exec sp_addarticle 
 @publication = N'FUSION_CORE_PUB', 
 @article = N'LTwoRepair', 
 @source_owner = N'dynamic', 
 @source_object = N'LTwoRepair', 
 @type = N'logbased', 
 @description = N'', 
 @creation_script = N'', 
 @pre_creation_cmd = N'drop', 
 @schema_option = 0x00000000484358DF, 
 @identityrangemanagementoption = N'manual', 
 @destination_table = N'LTwoRepair', 
 @destination_owner = N'dynamic', 
 @status = 24, 
 @vertical_partition = N'false', 
 @ins_cmd = N'CALL [sp_MSins_dynamicLTwoRepair]', 
 @del_cmd = N'CALL [sp_MSdel_dynamicLTwoRepair]', 
 @upd_cmd = N'SCALL [sp_MSupd_dynamicLTwoRepair]'
GO


-- Verify
select * from sysarticles where name in ('FusionProgramUsers', 'WaterTestCodeMap' ,'ShippingCompletedPOs','LTwoRepairDetail','LTwoRepair')


--Add subscription
exec sp_addsubscription 
       @publication = 'FUSION_CORE_PUB', 
       @subscriber = 'USPLPDWSQL1117', 
       @destination_db = 'Fusion_Core', 
       @article = 'FusionProgramUsers',
       @sync_type = 'automatic',
    @reserved = 'internal'
GO

exec sp_addsubscription 
       @publication = 'FUSION_CORE_PUB', 
       @subscriber = 'USPLPDWSQL1117', 
       @destination_db = 'Fusion_Core', 
       @article = 'WaterTestCodeMap',
       @sync_type = 'automatic',
    @reserved = 'internal'
GO

exec sp_addsubscription 
       @publication = 'FUSION_CORE_PUB', 
       @subscriber = 'USPLPDWSQL1117', 
       @destination_db = 'Fusion_Core', 
       @article = 'ShippingCompletedPOs',
       @sync_type = 'automatic',
    @reserved = 'internal'
GO

exec sp_addsubscription 
       @publication = 'FUSION_CORE_PUB', 
       @subscriber = 'USPLPDWSQL1117', 
       @destination_db = 'Fusion_Core', 
       @article = 'LTwoRepairDetail',
       @sync_type = 'automatic',
    @reserved = 'internal'
GO

exec sp_addsubscription 
       @publication = 'FUSION_CORE_PUB', 
       @subscriber = 'USPLPDWSQL1117', 
       @destination_db = 'Fusion_Core', 
       @article = 'LTwoRepair',
       @sync_type = 'automatic',
    @reserved = 'internal'
GO



--start snapshot
EXEC sp_startpublication_snapshot @publication = N'FUSION_CORE_PUB'
GO



