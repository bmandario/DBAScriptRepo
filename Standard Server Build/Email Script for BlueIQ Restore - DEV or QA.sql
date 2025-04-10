/*

806692-devdb1 - 10.195.20.30

806719-qadb1 - 10.195.20.26

*/

Update Detail_Employee SET vEmail = 'siva.ganji@valuelabs.com',vAlternateContactEmail = 'siva.ganji@valuelabs.com'

Update aspnet_Membership SET Email = 'siva.ganji@valuelabs.com'

Update Detail_Source SET vSourceEmail = 'siva.ganji@valuelabs.com',vSourceBillToEmail = 'siva.ganji@valuelabs.com'

Update Ref_Partners SET vPartnerEmail = 'siva.ganji@valuelabs.com',vPartnerBillToEmail = 'siva.ganji@valuelabs.com'

Update Detail_Customer set vCustShipEmail = 'siva.ganji@valuelabs.com',vCustBillEmail = 'siva.ganji@valuelabs.com', vOrderNotificationEmails = 'siva.ganji@valuelabs.com'

Update Ref_SystemConfig SET vconfig_value = 'siva.ganji@valuelabs.com' WHERE CHARINDEX('@',vConfig_Value) > 0

UPDATE Detail_JobContact SET vJobContactFAX='siva.ganji@valuelabs.com',vJobContactEmail='siva.ganji@valuelabs.com'

UPDATE Detail_DisposalRequest_Contact SET vEmail='siva.ganji@valuelabs.com'

UPDATE Detail_SourceContacts_eMailSubscription SET vEmail='siva.ganji@valuelabs.com'

update ref_websitesettings set vdefaultemailGroup='siva.ganji@valuelabs.com', vinternalEmailGroup='siva.ganji@valuelabs.com',vMailTo='siva.ganji@valuelabs.com'

Update Build_SourceVendor set vbillingContactEmail ='siva.ganji@valuelabs.com' where vbillingContactEmail<>'NA'

Update Detail_VendorCarrier set vCarrierEmail ='siva.ganji@valuelabs.com'

update Detail_ReclaimFacilityContact set vContactEmail = 'siva.ganji@valuelabs.com'

update ref_facilities set vOTVEmail = 'siva.ganji@valuelabs.com'

Update Stg_History_Detail_Job set vBillingEmail='siva.ganji@valuelabs.com'

Update History_Detail_Job set vBillingEmail='siva.ganji@valuelabs.com',vJobBilltoEmail1='siva.ganji@valuelabs.com',vJobBilltoEmail2='siva.ganji@valuelabs.com',vPickupEmail='siva.ganji@valuelabs.com'

Update Staging_Depot_OrderImport set vShipEmail='siva.ganji@valuelabs.com'

Update Staging_OrderImport set vShipToEmail='siva.ganji@valuelabs.com',vBillToEmail='siva.ganji@valuelabs.com'

update Detail_Alerts set  vEmailAddress='siva.ganji@valuelabs.com'

Update Detail_Carrier set vemail = 'siva.ganji@valuelabs.com'

update Detail_Donations set vemail='siva.ganji@valuelabs.com'

Update Detail_JobTracking set Vemail='siva.ganji@valuelabs.com'

Update Detail_paymentInvoicedetails set vEmailID = 'siva.ganji@valuelabs.com'

Update Detail_ReturnConfiguration set vReturnContactEmail = 'siva.ganji@valuelabs.com'

Update Detail_TradeInQuote set vEmail='siva.ganji@valuelabs.com'

update Detail_SourceLocations set vSourceLocBilltoEmail1='siva.ganji@valuelabs.com'

Update Detail_Source set vSourceBilltoEmail2='siva.ganji@valuelabs.com'

GO

DISABLE TRIGGER history_Trg_Detail_job ON Detail_Job

GO

DISABLE TRIGGER trg_jobstatushistory ON detail_job

GO

Update Detail_Job set vBillingEmail='siva.ganji@valuelabs.com',vJobBilltoEmail1='siva.ganji@valuelabs.com',vJobBilltoEmail2='siva.ganji@valuelabs.com',vPickupEmail='siva.ganji@valuelabs.com'

GO

ENABLE TRIGGER history_Trg_Detail_job ON Detail_Job

GO

ENABLE TRIGGER trg_jobstatushistory ON detail_job

GO



DISABLE TRIGGER history_Trg_Detail_AssetReclaim ON detail_assetreclaim

GO

DISABLE TRIGGER trg_detail_assetreclaim ON detail_assetreclaim

GO



Update detail_assetreclaim SET vReturnEmail = 'siva.ganji@valuelabs.com'



GO

ENABLE TRIGGER history_Trg_Detail_AssetReclaim ON detail_assetreclaim

GO

ENABLE TRIGGER trg_detail_assetreclaim ON detail_assetreclaim

GO



DISABLE TRIGGER Trg_CustomerOrderStatus ON Detail_SellOrder

GO

DISABLE TRIGGER Trg_OrderStatusHistory ON Detail_SellOrder

GO



Update Detail_SellOrder SET vShipToEmail = 'siva.ganji@valuelabs.com',vBillingContactEmail = 'siva.ganji@valuelabs.com' 



GO

ENABLE TRIGGER Trg_CustomerOrderStatus ON Detail_SellOrder

GO

ENABLE TRIGGER Trg_OrderStatusHistory ON Detail_SellOrder

GO