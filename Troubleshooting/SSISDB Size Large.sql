--Check DB space
sp_spaceused
go
--Check retention
select property_name, property_value from ssisdb.internal.catalog_properties
--EXECUTE THE BELOW bring log retention down to 1 week.
EXECUTE catalog.configure_catalog RETENTION_WINDOW, 7
--Run again to check retention (should be 7 days)
select property_name, property_value from ssisdb.internal.catalog_properties
--Run These SP in SSISDB
EXE [internal].[cleanup_Server_project_version]
EXE [internal].[cleanup_server_retention_window]
--Note:  IF there is no SQL job schedule for these 2 SP, create job to run these 2 sp every week.
--Once SP finished, run sp_spaceused again.
--We will see the unlocated space increase.
--Then shrink DB if needed.
