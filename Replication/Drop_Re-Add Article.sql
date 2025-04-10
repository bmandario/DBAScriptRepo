-- Reference RFC263693 | CTASK607155

--Start

--drop subcription that has the article

--  exec sp_dropsubscription @publication  = 'NAProviaPRD_Configuration_Pub', @article = 'lc_f', @subscriber = 'USCHWSQL1262D'



----drop articles

--  exec  sp_droparticle @publication  = 'NAProviaPRD_Configuration_Pub', @article = 'lc_f'



-- verify whether the drop work

select * from syssubscriptions where artid = 44

select * from sysarticles where name = 'lc_f'



--STOP Distribution of NAProviaPRD_MasterData_Pub (in replication monitor)



--Add article:  lc_f

exec sp_addarticle 

        @publication = N'NAProviaPRD_MasterData_Pub', 

        @article = N'lc_f', 

        @source_owner = N'dbo', 

        @source_object = N'lc_f', 

        @type = N'logbased', 

        @description = N'', 

        @creation_script = N'', 

        @pre_creation_cmd = N'drop', 

        @schema_option = 0x00000000484358DF, 

        @identityrangemanagementoption = N'none', 

        @destination_table = N'lc_f', 

        @destination_owner = N'dbo', 

        @status = 24, 

        @vertical_partition = N'false', 

        @ins_cmd = N'CALL [dbo].[sp_MSins_dbolc_f]', 

        @del_cmd = N'CALL [dbo].[sp_MSdel_dbolc_f]',

@upd_cmd = N'SCALL [dbo].[sp_MSupd_dbolc_f]' 

        GO



--subscription:  lc_f

exec sp_addsubscription 

@publication = N'NAProviaPRD_MasterData_Pub', 

@subscriber = N'USCHWSQL1262D', 

@destination_db = N'NAProviaPRD', 

@sync_type = N'replication support only', 

@article = N'lc_f'

go



--START DISTRIBUTION



--======Verify:

select sub.artid, art.name, sub.dest_db, sub.srvname as SubServer, art.pubid, pub.name as pubName, sub.login_name

from syssubscriptions sub with (nolock) inner join sysarticles art with (nolock) on sub.artid = art.artid 

inner join syspublications pub with (nolock) on art.pubid = pub.pubid

where art.name 

in ('lc_f')



select 'lc_f' TableName, 'uschwsql1261d' as servername, count(1) as RowCnt from lc_f with (nolock);

select 'lc_f' TableName, 'uschwsql1262d' as servername, count(1) as RowCnt from [USCHWSQL1262D].[NAProviaPRD].dbo.lc_f with (nolock);