
disable trigger [Trg_CustomerOrderStatus] on Detail_sellorder

go

disable trigger [Trg_OrderStatusHistory] on Detail_sellorder

go

disable trigger [VoidSellOrder] on Detail_sellorder

go



Update Detail_SellOrder SET vShipToEmail = 'kamal.marimuthu@ingrammicro.com',vBillingContactEmail = 'kamal.marimuthu@ingrammicro.com', vRequestorEmail = 'kamal.marimuthu@ingrammicro.com'



go

enable trigger [Trg_CustomerOrderStatus] on Detail_sellorder

go

enable trigger [Trg_OrderStatusHistory] on Detail_sellorder

go

enable trigger [VoidSellOrder] on Detail_sellorder

go



--Select * from Detail_Employee



--Select * from Detail_Employee

--Select * from ref_systemconfig



update Detail_Employee set vEmployeePhone='111-111-1111', vEmployeeMobile='', vEmployeeFax='', vEmail = 'kamal.marimuthu@ingrammicro.com', vAlternateContactEmail = 'kamal.marimuthu@ingrammicro.com'

where (vEmail not like 'Sudhirkumar.Pradhani@ingrammicro%' or vEmail <> 'Raj.Shrestha@ingrammicro.com' or vEmail <> 'michael.cleveland@ingrammicro.com') 



--Update aspnet_Membership SET Email = 'kamal.marimuthu@ingrammicro.com'



update aspnet_membership set Email = 'kamal.marimuthu@ingrammicro.com', LoweredEmail = 'kamal.marimuthu@ingrammicro.com'

where (LoweredEmail not like 'Sudhirkumar.Pradhani@ingrammicro%' or LoweredEmail <> 'Raj.Shrestha@ingrammicro.com' or LoweredEmail <> 'michael.cleveland@ingrammicro.com')





Update Detail_Source SET vSourceEmail = 'kamal.marimuthu@ingrammicro.com',vSourceBillToEmail = 'kamal.marimuthu@ingrammicro.com', vSourceBilltoEmail2='kamal.marimuthu@ingrammicro.com'

Update Ref_Partners SET vPartnerEmail = 'kamal.marimuthu@ingrammicro.com',vPartnerBillToEmail = 'kamal.marimuthu@ingrammicro.com'

Update ref_Vendormaster SET vVendorContactEmail = 'kamal.marimuthu@ingrammicro.com',vBillingContactEmail1 = 'kamal.marimuthu@ingrammicro.com' ,vBillingContactEmail2 = 'kamal.marimuthu@ingrammicro.com'



go

disable trigger [Trg_Detail_SourceLocation_AddLocationstoUser] on Detail_SourceLocations

go

update Detail_SourceLocations set vSourceLocBilltoEmail1='kamal.marimuthu@ingrammicro.com'

go



enable trigger [Trg_Detail_SourceLocation_AddLocationstoUser] on Detail_SourceLocations

go





Update Detail_Customer set vOrderNotificationemails = 'kamal.marimuthu@ingrammicro.com',  

vCustShipEmail = 'kamal.marimuthu@ingrammicro.com',vCustBillEmail = 'kamal.marimuthu@ingrammicro.com'



update Detail_DisposalRequest_Contact set vEmail='kamal.marimuthu@ingrammicro.com'



update Detail_JobContact set vJobContactEmail='kamal.marimuthu@ingrammicro.com', vJobContactPhone='111-111-1111'

update Detail_JobContact set vJobContactMobile='111-111-1111'

where isnull(vJobContactMobile, '') <> ''



update Detail_Alerts set  vEmailAddress='kamal.marimuthu@ingrammicro.com'



Update Detail_Carrier set vemail = 'kamal.marimuthu@ingrammicro.com'

update Detail_Donations set vemail='kamal.marimuthu@ingrammicro.com'

Update Detail_JobTracking set Vemail='kamal.marimuthu@ingrammicro.com'

Update Detail_paymentInvoicedetails set vEmailID = 'kamal.marimuthu@ingrammicro.com'

Update Detail_ReturnConfiguration set vReturnContactEmail = 'kamal.marimuthu@ingrammicro.com'

--Update History_Detail_Job set vBillingEmail = 'kamal.marimuthu@ingrammicro.com',vPickupEmail='kamal.marimuthu@ingrammicro.com'

Update Staging_Depot_OrderImport set vShipEmail='kamal.marimuthu@ingrammicro.com'

Update Staging_OrderImport set vShipToEmail='kamal.marimuthu@ingrammicro.com',vBillToEmail='kamal.marimuthu@ingrammicro.com'

--Update Stg_History_Detail_Job set vBillingEmail='kamal.marimuthu@ingrammicro.com'

Update Detail_TradeInQuote set vEmail='kamal.marimuthu@ingrammicro.com'



update Detail_VendorUserInvites SET vemail='kamal.marimuthu@ingrammicro.com' where isNull(vemail,'')<>''





Update Build_SourceVendor set vbillingContactEmail ='kamal.marimuthu@ingrammicro.com' where vbillingContactEmail<>'NA'

Update Detail_VendorCarrier set vCarrierEmail ='kamal.marimuthu@ingrammicro.com'

update Detail_ReclaimFacilityContact set vContactEmail = 'kamal.marimuthu@ingrammicro.com'



go

disable trigger [Trg_History_Facilities] on Ref_Facilities

go

update Ref_Facilities SET vOTVEmail='kamal.marimuthu@ingrammicro.com' where isNull(vOTVEmail,'')<>''

go

enable trigger [Trg_History_Facilities] on Ref_Facilities

go





go

disable trigger [History_Trg_Detail_AssetReclaim] on detail_assetreclaim

go

disable trigger [Trg_Detail_AssetReclaim] on detail_assetreclaim

go

update detail_assetreclaim set vReturnEmail = 'kamal.marimuthu@ingrammicro.com'

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



update Detail_Job set vBillingEmail='kamal.marimuthu@ingrammicro.com'

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



update ref_systemconfig set vconfig_value ='kamal.marimuthu@ingrammicro.com'

where vconfig_value like '%@shi.com'



update ref_systemconfig set vconfig_value ='kamal.marimuthu@ingrammicro.com'

where vconfig_value like '%@ingrammicro.com' --in ('RepairApprovalGroup', 'JobRequestEmail', 'AmazonManifestUploadEmail', 'TradeinFMVEmail', 'EquipmentTypes_Notification_ToAddress', 'DecommisionSupportEmail', 'UserDeactivatedNotification')





update ref_systemconfig set vconfig_value = 'https://blueiquat.cloudblue.com/BlueIQ2.0/'

where systemconfigid = 24



update ref_systemconfig set vconfig_value = 'https://blueiquat.cloudblue.com/HTML2PDF/Converter.aspx'

where systemconfigid = 166



Update ref_systemconfig set vConfig_Value='\\806717-uatweb1\BIQContentStore\'

where systemconfigID= 194



Update ref_systemconfig set vConfig_Value='http://10.195.20.14/CS/'

where systemconfigID= 195



Select * from ref_systemconfig where systemconfigID=195



update ref_systemconfig set vconfig_value = 'http://806718-uatdb1/BlueIQ/Pages/Report.aspx?ItemPath=%2fDevelopment%2fMBA+Report+Consolidated'

where systemconfigid = 203



--For Brian Lineback, remove Repair role & Add Repair Manager

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'General Manager',@UserNames=N'blineback',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Repair Manager',@UserNames=N'blineback',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_RemoveUsersFromRoles @ApplicationName=N'/',@RoleNames=N'Repair',@UserNames=N'blineback'





exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'spradhani',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'mumbaiL3',@CurrentTimeUtc='2012-05-09 22:24:41.063'

exec dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName=N'/',@RoleNames=N'Admin',@UserNames=N'mumbaiba',@CurrentTimeUtc='2012-05-09 22:24:41.063'



--Select * from ref_websitesettings



update ref_websitesettings set vURL ='http://blueiquat.cloudblue.com/ClientportalTFP/CP_Login.aspx', vRedirectToURL ='https://blueiquat.cloudblue.com/ClientportalTFP/CP_Login.aspx'

where iWebSiteId=1



update ref_websitesettings

set vURL = 'http://uat.cloudblue.com/CP_Login.aspx', vRedirectToURL = 'https://uat.cloudblue.com/CP_Login.aspx'

where iWebSiteId = 7



update ref_websitesettings

set vURL = 'http://uat.cloudblue.com/UHG/CP_Login.aspx', vRedirectToURL = 'https://uat.cloudblue.com/UHG/CP_Login.aspx'

where iWebSiteId = 13



UPDATE ref_SystemConfig SET vconfig_value= ' Kamal.Marimuthu@ingrammicro.com' WHERE vConfig_key= 'APIFailureErrorCodesTo'



UPDATE ref_SystemConfig SET vconfig_value= ' Kamal.Marimuthu@ingrammicro.com' WHERE vConfig_key= 'APIFailureErrorCodesCc'



