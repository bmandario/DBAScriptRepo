SELECT 
  ServerProperty('MachineName') as MachineName
, ServerProperty('ServerName') as ServerName
, ServerProperty('LicenseType') as LicenseType
, ServerProperty('NumLicenses') as NumLicences
, ServerProperty('InstanceName') as InstanceName
, ServerProperty('ProductVersion') as ProductVersion
, ServerProperty('Edition') as Edition
, ServerProperty('ProductLevel') as ServicePack
, ServerProperty('EngineEdition') as EngineEdition