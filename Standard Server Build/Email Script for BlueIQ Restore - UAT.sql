/*

806718-uatdb1 - 10.195.20.25

*/



disable trigger [Trg_CustomerOrderStatus] on Detail_sellorder

go

disable trigger [Trg_OrderStatusHistory] on Detail_sellorder

go

disable trigger [VoidSellOrder] on Detail_sellorder

go



Update Detail_SellOrder SET vShipToEmail = 'siva.ganji@valuelabs.com',vBillingContactEmail = 'siva.ganji@valuelabs.com', vRequestorEmail = 'siva.ganji@valuelabs.com'



go

enable trigger [Trg_CustomerOrderStatus] on Detail_sellorder

go

enable trigger [Trg_OrderStatusHistory] on Detail_sellorder

go

enable trigger [VoidSellOrder] on Detail_sellorder

go



--Select * from Detail_Employee



update Detail_Employee set vEmail = 'siva.ganji@valuelabs.com', vAlternateContactEmail = 'siva.ganji@valuelabs.com'

where (vEmail not like 'Sudhirkumar.Pradhani@ingrammicro%' or vEmail <> 'Pravin.Kamane@ingrammicro.com' or vEmail <> 'michael.cleveland@ingrammicro.com') 



--Update aspnet_Membership SET Email = 'siva.ganji@valuelabs.com'



update aspnet_membership set Email = 'siva.ganji@valuelabs.com', LoweredEmail = 'siva.ganji@valuelabs.com'

where (LoweredEmail not like 'Sudhirkumar.Pradhani@ingrammicro%' or LoweredEmail <> 'Pravin.Kamane@ingrammicro.com' or LoweredEmail <> 'michael.cleveland@ingrammicro.com')





Update Detail_Source SET vSourceEmail = 'siva.ganji@valuelabs.com',vSourceBillToEmail = 'siva.ganji@valuelabs.com', vSourceBilltoEmail2='siva.ganji@valuelabs.com'

Update Ref_Partners SET vPartnerEmail = 'siva.ganji@valuelabs.com',vPartnerBillToEmail = 'siva.ganji@valuelabs.com'

Update ref_Vendormaster SET vVendorContactEmail = 'siva.ganji@valuelabs.com',vBillingContactEmail1 = 'siva.ganji@valuelabs.com' ,vBillingContactEmail2 = 'siva.ganji@valuelabs.com'



go

disable trigger [Trg_Detail_SourceLocation_AddLocationstoUser] on Detail_SourceLocations

go

update Detail_SourceLocations set vSourceLocBilltoEmail1='siva.ganji@valuelabs.com'

go



enable trigger [Trg_Detail_SourceLocation_AddLocationstoUser] on Detail_SourceLocations

go





Update Detail_Customer set vOrderNotificationemails = 'siva.ganji@valuelabs.com',  

vCustShipEmail = 'siva.ganji@valuelabs.com',vCustBillEmail = 'siva.ganji@valuelabs.com'



update Detail_DisposalRequest_Contact set vEmail='siva.ganji@valuelabs.com'



update Detail_JobContact set vJobContactEmail='siva.ganji@valuelabs.com'





update Detail_Alerts set  vEmailAddress='siva.ganji@valuelabs.com'



Update Detail_Carrier set vemail = 'siva.ganji@valuelabs.com'

update Detail_Donations set vemail='siva.ganji@valuelabs.com'

Update Detail_JobTracking set Vemail='siva.ganji@valuelabs.com'

Update Detail_paymentInvoicedetails set vEmailID = 'siva.ganji@valuelabs.com'

Update Detail_ReturnConfiguration set vReturnContactEmail = 'siva.ganji@valuelabs.com'

--Update History_Detail_Job set vBillingEmail = 'siva.ganji@valuelabs.com',vPickupEmail='siva.ganji@valuelabs.com'

Update Staging_Depot_OrderImport set vShipEmail='siva.ganji@valuelabs.com'

Update Staging_OrderImport set vShipToEmail='siva.ganji@valuelabs.com',vBillToEmail='siva.ganji@valuelabs.com'

--Update Stg_History_Detail_Job set vBillingEmail='siva.ganji@valuelabs.com'

Update Detail_TradeInQuote set vEmail='siva.ganji@valuelabs.com'



update Detail_VendorUserInvites SET vemail='siva.ganji@valuelabs.com' where isNull(vemail,'')<>''





Update Build_SourceVendor set vbillingContactEmail ='siva.ganji@valuelabs.com' where vbillingContactEmail<>'NA'

Update Detail_VendorCarrier set vCarrierEmail ='siva.ganji@valuelabs.com'

update Detail_ReclaimFacilityContact set vContactEmail = 'siva.ganji@valuelabs.com'



go

disable trigger [Trg_History_Facilities] on Ref_Facilities

go

update Ref_Facilities SET vOTVEmail='siva.ganji@valuelabs.com' where isNull(vOTVEmail,'')<>''

go

enable trigger [Trg_History_Facilities] on Ref_Facilities

go





go

disable trigger [History_Trg_Detail_AssetReclaim] on detail_assetreclaim

go

disable trigger [Trg_Detail_AssetReclaim] on detail_assetreclaim

go

update detail_assetreclaim set vReturnEmail = 'siva.ganji@valuelabs.com'

go



enable trigger [History_Trg_Detail_AssetReclaim] on detail_assetreclaim

go

enable trigger [Trg_Detail_AssetReclaim] on detail_assetreclaim

go



GO



--Activate Mumbai L1 Support team

Update detail_employee  set cEmployeestatus='A', dDeactivatedDate=NULL, iDeactivatedby=NULL

where iEmployeeID=32671



--For L3 support team

Update detail_employee  set cEmployeestatus='A', dDeactivatedDate=NULL, iDeactivatedby=NULL

where iEmployeeID=32722



GO



disable trigger [History_Trg_Detail_Job] on Detail_Job

go

disable trigger [OnUpdateScheuleDetails] on Detail_Job

go

disable trigger [Trg_Detail_Job_ARCalcMethod] on Detail_Job

go

disable trigger [Trg_Detail_Job_SiteAdjustmentCommissions] on Detail_Job

go

disable trigger [Trg_JobStatusHistory] on Detail_Job

go



update Detail_Job set vBillingEmail='siva.ganji@valuelabs.com'

GO



enable trigger [History_Trg_Detail_Job] on Detail_Job

go

enable trigger [OnUpdateScheuleDetails] on Detail_Job

go

enable trigger [Trg_Detail_Job_ARCalcMethod] on Detail_Job

go

enable trigger [Trg_Detail_Job_SiteAdjustmentCommissions] on Detail_Job

go

enable trigger [Trg_JobStatusHistory] on Detail_Job

go



--select * from ref_systemconfig where vconfig_value like '%@%'



update ref_systemconfig set vconfig_value ='siva.ganji@valuelabs.com'

where vconfig_key like '%@%' --in ('RepairApprovalGroup', 'JobRequestEmail', 'AmazonManifestUploadEmail', 'TradeinFMVEmail', 'EquipmentTypes_Notification_ToAddress', 'DecommisionSupportEmail', 'UserDeactivatedNotification')





--https://blueiq.cloudblue.com/HTML2PDF/Converter.aspx

--Select * from ref_systemconfig





update ref_systemconfig set vconfig_value = 'http://blueiquat.cloudblue.com/BlueIQ2.0/'

where systemconfigid = 24



update ref_systemconfig set vconfig_value = 'http://blueiquat.cloudblue.com/HTML2PDF/Converter.aspx'

where systemconfigid = 166



Update ref_systemconfig set vConfig_Value='\\806717-uatweb1\BIQContentStore\'

where systemconfigID= 194



Update ref_systemconfig set vConfig_Value='http://192.168.100.14/CS/'

where systemconfigID= 195







update ref_systemconfig set vconfig_value = 'http://806718-uatdb1/BlueIQ/Pages/Report.aspx?ItemPath=%2fDevelopment%2fMBA+Report+Consolidated'

where systemconfigid = 203



--For Brian Lineback, remove Repair role & Add Repair Manager

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'General Manager',@UserNames=N'blineback',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Repair Manager',@UserNames=N'blineback',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_RemoveUsersFromRoles @ApplicationName=N'/',@RoleNames=N'Repair',@UserNames=N'blineback'





exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'spradhani',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'mumbaiL3',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'mumbaiba',@CurrentTimeUtc='2012-05-09 22:24:41.063'



update ref_websitesettings set vURL ='https://blueiquat.cloudblue.com/ClientportalTFP/CP_Login.aspx'

where iWebSiteId=1



update ref_websitesettings

set vURL = 'https://uat.cloudblue.com/CP_Login.aspx'

where iWebSiteId = 7



update ref_websitesettings

set vURL = 'https://uat.cloudblue.com/UHG/CP_Login.aspx'

where iWebSiteId = 13

UPDATE ref_SystemConfig SET vconfig_value= 'Sumeet.Kadam@ingrammicro.com' WHERE vConfig_key= 'APIFailureErrorCodesTo'

 

UPDATE ref_SystemConfig SET vconfig_value= 'Sumeet.Kadam@ingrammicro.com' WHERE vConfig_key= 'APIFailureErrorCodesCc'