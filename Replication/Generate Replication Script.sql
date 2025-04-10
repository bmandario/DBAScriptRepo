SET NOCOUNT ON;

Use blueiq
GO

---------------------------------Prepare article that involved
--IF WANT TO BUILD REPLICATION With ONLY TABLES existing in current replication
-- Should be run at the publishing DB

select 'BlueIQ_Pub_27June2020' as Publication, name as ArticleName, name as DestArticleName 
into #temp_articles
from  sysarticles where name in
(
'History_AssetCMSP'
,'History_detail_Commissions'
,'History_Detail_JobInvoice'
,'History_Detail_OnsiteService_Schedule'
,'History_Detail_RepairDetails'
,'History_RepairDuration'
,'History_ServiceOrderItems'
,'History_AssetRecovery'
,'History_Detail_Pallet'
,'Staging_InventoryFileData'
)
order by name

/* IF WANT TO BUILD REPLICATION With ALL TABLES in DBs
Select 'CELL_ADJUSTMENT_Pub' as Publication, name as ArticleName, name as DestArticleName 
into #temp_articles
from sys.tables 
where is_ms_shipped = 0 
order by name
*/

/*
--CREATE SYSTEM TABLE FOR REPLICATION. Run Once
exec sp_replicationdboption 
		@dbname = N'CELL_ADJUSTMENT', 
		@optname = N'publish', 
		@value = N'true'
GO
*/

--------------------------------------------------------Start and hightlight from here to create script for Step 3
--Step 1: Generate sql script the re-add art
-- Adding the transactional publication
DECLARE @sSQL nvarchar(4000)
DECLARE @sPublisherName nvarchar(30)
DECLARE @sDBName nvarchar(30)
DECLARE @sPubName nvarchar(255)
DECLARE @sCurrPubName nvarchar(255)
DECLARE @sArticleName nvarchar(255)
DECLARE @sDestinationTable nvarchar(255)
DECLARE @sDesc nvarchar(255)
DECLARE @sIns_cmd nvarchar(100)
DECLARE @sDel_cmd nvarchar(100)
DECLARE @sUpd_cmd nvarchar(100)
DECLARE @sTemp nvarchar(4000)
DECLARE @i int
DECLARE @sLFCR nchar(1)
DECLARE @sTab nchar(1)
DECLARE @sIdenOpt nvarchar(10)
SET @sPublisherName = @@SERVERNAME
SET @sDBName = N'BlueIQ'
SET @sPubName = N''
SET @sCurrPubName = N''
SET @sArticleName = N''
SET @sDesc = N''
SET @sIns_cmd = N''
SET @sDel_cmd = N''
SET @sUpd_cmd = N''
SET @sSQL = N''
SET @sTemp = N''
SET @i = 0

SET @sLFCR = CHAR(10)
SET @sTab = CHAR(9)

SET @sSQL = N'USE ' + @sDBName + @sLFCR + N'GO' + @sLFCR

DECLARE cur_temp_pub CURSOR FOR 

Select Publication, ArticleName, DestArticleName from #temp_articles

OPEN cur_temp_pub 
FETCH NEXT FROM cur_temp_pub INTO @sPubName, @sArticleName, @sDestinationTable

	WHILE @@fetch_status = 0
	BEGIN
		IF(@sCurrPubName <> @sPubName)
		BEGIN
			SET @sCurrPubName = @sPubName -- reset the current publication
			SET @sDesc = N'Transactional publication of database ''''' + @sDBName + N''''' from Publisher ''''' + @sPublisherName + N'''''.'
			SET @sSQL = @sSQL + N'---- Start of Publication: ''' + @sPubName + N''''   + @sLFCR
						        + N'exec sp_addpublication '                           + @sLFCR
						+ @sTab + N'@publication = N''' + @sPubName + N''', '          + @sLFCR
						+ @sTab + N'@description = N''' + @sDesc + N''', '             + @sLFCR
						+ @sTab + N'@sync_method = N''concurrent'','                   + @sLFCR   
						+ @sTab + N'@retention = 0, '                                  + @sLFCR
						+ @sTab + N'@allow_push = N''true'', '                         + @sLFCR
						+ @sTab + N'@allow_pull = N''true'', '                         + @sLFCR
						+ @sTab + N'@allow_anonymous = N''false'', '                   + @sLFCR
						+ @sTab + N'@enabled_for_internet = N''false'', '              + @sLFCR
						+ @sTab + N'@snapshot_in_defaultfolder = N''true'', '          + @sLFCR
						+ @sTab + N'@compress_snapshot = N''false'', '                 + @sLFCR
						+ @sTab + N'@ftp_port = 21, '                                  + @sLFCR
						+ @sTab + N'@ftp_login = N''anonymous'', '                     + @sLFCR
						+ @sTab + N'@allow_subscription_copy = N''false'', '           + @sLFCR
						+ @sTab + N'@add_to_active_directory = N''false'', '           + @sLFCR
						+ @sTab + N'@repl_freq = N''continuous'', '                    + @sLFCR
						+ @sTab + N'@status = N''active'', '                           + @sLFCR
						+ @sTab + N'@independent_agent = N''true'', '                  + @sLFCR
						+ @sTab + N'@immediate_sync = N''false'', '                    + @sLFCR
						+ @sTab + N'@allow_sync_tran = N''false'', '                   + @sLFCR
						+ @sTab + N'@autogen_sync_procs = N''false'', '                + @sLFCR
						+ @sTab + N'@allow_queued_tran = N''false'', '                 + @sLFCR
						+ @sTab + N'@allow_dts = N''false'', '                         + @sLFCR
						+ @sTab + N'@replicate_ddl = 1, '                              + @sLFCR
						+ @sTab + N'@allow_initialize_from_backup = N''True'', '       + @sLFCR
						+ @sTab + N'@enabled_for_p2p = N''false'', '                   + @sLFCR
						+ @sTab + N'@enabled_for_het_sub = N''false'''                 + @sLFCR
						+ @sTab + N'GO'                                                + @sLFCR
																		               + @sLFCR	
																		               + @sLFCR
						        + N'exec sp_addpublication_snapshot '                  + @sLFCR
						+ @sTab + N'@publication = N''' + @sPubName + N''', '          + @sLFCR
						+ @sTab + N'@frequency_type = 1, '                             + @sLFCR
						+ @sTab + N'@frequency_interval = 0, '                         + @sLFCR
						+ @sTab + N'@frequency_relative_interval = 0, '                + @sLFCR
						+ @sTab + N'@frequency_recurrence_factor = 0, '                + @sLFCR
						+ @sTab + N'@frequency_subday = 0, '                           + @sLFCR
						+ @sTab + N'@frequency_subday_interval = 0, '                  + @sLFCR
						+ @sTab + N'@active_start_time_of_day = 0, '                   + @sLFCR
						+ @sTab + N'@active_end_time_of_day = 235959, '                + @sLFCR
						+ @sTab + N'@active_start_date = 0, '                          + @sLFCR
						+ @sTab + N'@active_end_date = 0, '                            + @sLFCR
						+ @sTab + N'@job_login = null, '                               + @sLFCR
						+ @sTab + N'@job_password = null, '                            + @sLFCR
						+ @sTab + N'@publisher_security_mode = 1'                      + @sLFCR + @sLFCR
						        + N'---- Start of adding articles for publication: ''' + @sPubName + N'''' + @sLFCR + @sLFCR
		END 
			SET @sIns_cmd = N'CALL [sp_MSins_dbo' + @sDestinationTable + N']'
			SET @sDel_cmd = N'CALL [sp_MSdel_dbo' + @sDestinationTable + N']'
			SET @sUpd_cmd = N'SCALL [sp_MSupd_dbo' + @sDestinationTable + N']'

---@@@  @sIdenOpt
		SET @sIdenOpt = 'none'
		IF(OBJECTPROPERTY(OBJECT_ID(@sArticleName), N'TableHasIdentity') = 1)
		BEGIN
			SET @sIdenOpt = 'manual'
		END
			
			SET @sSQL = @sSQL
						+         @sTab + N'---- Start of adding articles: ''' + @sArticleName + N'''' + @sLFCR
						        + @sTab + N'exec sp_addarticle '                                       + @sLFCR
						+ @sTab + @sTab + N'@publication = N''' + @sPubName + N''', '                  + @sLFCR
						+ @sTab + @sTab + N'@article = N''' + @sArticleName + N''', '                  + @sLFCR
						+ @sTab + @sTab + N'@source_owner = N''dbo'', '                                + @sLFCR
						+ @sTab + @sTab + N'@source_object = N''' + @sArticleName + N''', '            + @sLFCR
						+ @sTab + @sTab + N'@type = N''logbased'', '                                   + @sLFCR
						+ @sTab + @sTab + N'@description = N'''', '                                      + @sLFCR
						+ @sTab + @sTab + N'@creation_script = N'''', '                                  + @sLFCR
						+ @sTab + @sTab + N'@pre_creation_cmd = N''drop'', '                           + @sLFCR
--						+ @sTab + @sTab + N'@schema_option = 0x000000000803509F, '                     + @sLFCR
--				        + @sTab + @sTab + N'@schema_option = 0x00000000480350DF, '                     + @sLFCR
						-- filegroup association, perms, nonclustered indexes
						+ @sTab + @sTab + N'@schema_option = 0x00000000484358DF, '                     + @sLFCR 						
						+ @sTab + @sTab + N'@identityrangemanagementoption = N''' + @sIdenOpt + N''', '     + @sLFCR
						+ @sTab + @sTab + N'@destination_table = N''' + @sDestinationTable + N''', '        + @sLFCR
						+ @sTab + @sTab + N'@destination_owner = N''dbo'', '                           + @sLFCR
						+ @sTab + @sTab + N'@status = 24, '                                             + @sLFCR
						+ @sTab + @sTab + N'@vertical_partition = N''false'', '                        + @sLFCR
						+ @sTab + @sTab + N'@ins_cmd = N''' + @sIns_cmd + N''', '                      + @sLFCR
						+ @sTab + @sTab + N'@del_cmd = N''' + @sDel_cmd + N''', '                      + @sLFCR
						+ @sTab + @sTab + N'@upd_cmd = N''' + @sUpd_cmd + N''''                        + @sLFCR
						+ @sTab + @sTab + N'---- End of adding articles: ' + @sArticleName             + @sLFCR
						+ @sTab + @sTab + N'GO'                                                        + @sLFCR + @sLFCR
		SET @i = @i + 1
		PRINT @sSQL
		SET @sSQL = N''
		FETCH NEXT FROM cur_temp_pub INTO @sPubName, @sArticleName, @sDestinationTable
		
		IF(@sCurrPubName <> @sPubName)
		BEGIN
			SET @sSQL = @sSQL + N'---- End of Publication: ' + @sCurrPubName + @sLFCR + @sLFCR
		END
	END 
CLOSE cur_temp_pub 
DEALLOCATE cur_temp_pub
PRINT @sSQL
PRINT '--@@' + convert(varchar, @i)

---------------------------------STOP Step 3
-- Drop table #temp_articles

/*
exec sp_addsubscription 
	@publication        = 'CELL_ADJUSTMENT_Pub', 
	@article            = 'all', 
	@subscriber         = '<Destination Subscriber Server>', 
	@destination_db     = 'CELL_ADJUSTMENT', 
	@sync_type          = 'replication support only'
GO

--@sync_type='automatice', @reserved = 'internal' --SQL2005


exec sp_startpublication_snapshot 'CELL_ADJUSTMENT_BK_Pub' -- run this with above option (NOTE), table created with index, data loaded.
GO
*/

--Step 1:  Generate sql script the drop sub
select 'Exec sp_dropsubscription @publication =  ''BlueIQ_Pub_27June2020'' , @article =  ''' + ArticleName + ''', @subscriber =  ''850155-SQLREPT'';' from #temp_articles

--Step 2: Generate sql script the drop art
select 'Exec sp_droparticle @publication = ''BlueIQ_Pub_27June2020'', @article = ''' + ArticleName + ''';' from #temp_articles 

--Step 4: Generate sql script the re-add sub
select 
'Exec sp_addsubscription 
       @publication = ''BlueIQ_Pub_27June2020'', 
       @subscriber = ''850155-SQLREPT'', 
       @destination_db = ''BlueIQReports'', 
       @article = ''' + articleName + ''',
       @sync_type = ''replication support only''
GO'
from #temp_articles 