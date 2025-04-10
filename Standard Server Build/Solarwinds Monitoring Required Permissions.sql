/* 

As per IOC Monitoring Tech Team 

The following are the required permissions as documented for SolarWinds:

- Member of the db_datareader role in the msdb database

- VIEW SERVER STATE permissions

- View any definition

- Connect permission to all databases, including Master and msdb (grant view any database)

So that Solarwinds can monitor our servers.

*/



USE [msdb]

GO

CREATE USER [corporate\svc-uspatu01] FOR LOGIN [corporate\svc-uspatu01]

GO



USE [msdb]

GO

ALTER ROLE [db_datareader] ADD MEMBER [corporate\svc-uspatu01]

GO



USE Master

GO

GRANT VIEW SERVER STATE TO [corporate\svc-uspatu01]

GO



USE Master

GO

GRANT VIEW ANY DATABASE TO [corporate\svc-uspatu01]

GO



USE Master

GO

GRANT VIEW ANY DEFINITION TO [corporate\svc-uspatu01]

GO