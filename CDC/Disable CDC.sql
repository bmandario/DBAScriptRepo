---Rollback
---Use to disable all CDC on the DB
USE [NAPOWER];  
GO  
EXECUTE sys.sp_cdc_disable_db;  
GO


---Rollback for specific table(s), can only be used for one table at a time if we know which ---ones need to be stopped. will print out the tsql you need for the specified table

USE [NAPowerTest]; -- Change db name 
DECLARE @Schema AS VARCHAR(300)
DECLARE @Table AS VARCHAR(300) 
DECLARE @capture_instance_Input AS VARCHAR(300)
DECLARE @tsql AS VARCHAR(max)




DECLARE cdc_cursor CURSOR FOR  
SELECT TABLE_SCHEMA, TABLE_NAME  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'AND TABLE_NAME in (
'admin_deniedReasons',
'admin_deniedReasons_mapping',
'PowerCaseDeniedReasonList',
'Admin_reasonCodes__',
'admin_accountProfile',
'PowerCaseCreditLineValidationLog',
'PowerCaseCreditSerialNo',
'PowerUserAction',
'admin_branches',
'PayeeData',
'CarrierCode',
'admin_creditlinecommenttemplateheader',
'PowerCaseMiscDebitLine',
'admin_creditlinecommenttemplatelines',
'admin_miscChargeCodes',
'admin_policylookback',
'admin_policytypes',
'PowerCarrierTracking',
'admin_priority',
'admin_queueAssignmentRule',
'admin_queueAssignmentRuleTypes',
'admin_workflowDetail',
'admin_queues_access',
'admin_quickwinthreshold',
'Admin_reasonCodes',
'admin_regions',
'admin_reworkCodes',
'admin_WorklfowEmailMapping',
'admin_rmaRefNumber_CustomerTemplates',
'admin_rmatrackercustomers',
'admin_rmatrackergroup',
'admin_roles',
'PowerCaseSupportingInfo',
'admin_states',
'admin_vendor_returns_supportingInfo',
'admin_users',
'admin_users_regionsettings',
'admin_validationCodes',
'admin_validationcodes2',
'admin_workflow',
'admin_WorkflowDetailStaging',
'admin_workflowItem',
'admin_workflowTask',
'PowerCaseHistory',
'PowerCaseAttachment',
'PowerCaseAuditLog',
'PowerCaseAuditLogErrorList',
'PowerCaseCreditLine',
'PowerCaseCreditLineNote',
'PowerCaseDebitLine',
'PowerCaseHeader',
'PowerNotificationLog',
'PowerBulkCaseUpload',
'PowerCaseMiscCreditLine',
'PowerCaseNotes',
'PowerCustomerNotes',
'PowerWorkFlowItem',
'PowerWorkflowTask',
'caseRMATrackerGroup',
'admin_returnbranchaddress',
'PowerRMATrackerMonthlySales',
'admin_holidaySchedule',
'PowerExceptionRMATracker',
'admin_workgroup',
'admin_queues',
'admin_personalNoteTemplates',
'POWEREMAILTEMPLATE'
);


OPEN cdc_cursor   
FETCH NEXT FROM cdc_cursor INTO @Schema ,    @Table
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
 SET @capture_instance_Input = @Schema + '_' + @Table
 SET @tsql = 'EXECUTE sys.sp_cdc_disable_table 
									 @source_schema =' + @Schema +'
								   , @source_name ='+ @Table + '
								   , @capture_instance =' + @capture_instance_Input + ''
								   
PRINT  @tsql
FETCH NEXT FROM cdc_cursor INTO @Schema ,    @Table
END   
CLOSE cdc_cursor   
DEALLOCATE cdc_cursor 
