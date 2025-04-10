--Generate list of individual who have access in this server that can read, modify, delete SCHEDULED JOBS in SGDCWSQL1508L1 and CNSHWSQL1502
--should include domain users and service accounts. this is needed for self testing of security policy C03
--REQ3259928

SET NOCOUNT ON

SET ANSI_WARNINGS OFF

SET NOCOUNT ON

IF OBJECT_ID('TmpUsers') IS NOT NULL

DROP TABLE TmpUsers

/*

CREATE TABLE TmpUsers (

id INT IDENTITY(1,1),

DbName VARCHAR(256),

loginname VARCHAR(256),

UserName VARCHAR(256),

RoleName VARCHAR(256)

)

*/

CREATE Table TmpUsers (

[Server] VARCHAR(256),

[Login] VARCHAR(256),

[User] VARCHAR(256),

[Role] VARCHAR(256),

SSID VARCHAR(256),

[Login Type] VARCHAR(256),

[Database Name] VARCHAR(256),

[Create Date] datetime,

[Last Modify] DATETIME

)

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'sysadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

--INTO TmpUsers

FROM MASTER..syslogins l1

WHERE l1.sysadmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'securityadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE l1.securityadmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'serveradmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE l1.serveradmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'setupadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE setupadmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'processadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE processadmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'diskadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE diskadmin = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'dbcreator' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE dbcreator = 1

INSERT TmpUsers ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT

@@SERVERNAME [Server],

NAME [Login],

NULL [User],

'bulkadmin' [Role],

'' as [SSID],

CASE

WHEN isntuser = 1 THEN 'Windows User'

WHEN isntgroup = 1 THEN 'Windows Group'

ELSE 'SQL User'

END AS [Login Type],

'Server Level' as [Database Name],

createdate AS [Create Date],

updatedate AS [Last Modify]

FROM MASTER..syslogins l1

WHERE bulkadmin = 1

DECLARE @databaselist TABLE

(id INT IDENTITY(1,1) , dbname sysname)

INSERT INTO @databaselist (dbname)

SELECT NAME

FROM MASTER..sysdatabases

DECLARE @dbname sysname

Declare @N int

Declare @MaxN int

Set @N=(Select min(id) from @databaselist)

Set @MaxN = (Select max(id) from @databaselist)

Declare @var varchar(256)

Declare @int int

DECLARE @strSQL VARCHAR(8000)

While @N<=@MaxN

Begin

If Exists(Select id from @databaselist where id=@N)

Begin

Set @dbname=(Select dbname from @databaselist where id=@N)

If (SELECT DATABASEPROPERTYEX(@dbname, 'STATUS'))='ONLINE'

BEGIN

SET @strSQL = '

IF OBJECT_ID(''tempdb..#RoleList'') IS NOT NULL

DROP TABLE #RoleList

CREATE TABLE #RoleList (

RoleName sysname,

UserName sysname,

LoginSid VARBINARY(85)

)

INSERT INTO #RoleList

EXEC ' + '['+@dbname+']' + '.dbo.sp_helprolemember

INSERT INTO [TmpUsers] ([Server], [Login], [User], [Role], SSID, [Login Type], [Database Name],[Create Date],[Last Modify])

SELECT @@SERVERNAME,

loginname,

UserName,

RoleName,

'''',

CASE

WHEN sysusers.isntuser = 1 THEN ''Windows User''

WHEN sysusers.isntgroup = 1 THEN ''Windows Group''

ELSE ''SQL User''

END AS [Login Type],

''' + @dbname + ''' DBName,

sysusers.createdate AS [Create Date],

sysusers.updatedate AS [Last Modify]

FROM #RoleList

JOIN ' + '['+@dbname+']' + '..sysusers sysusers ON [#RoleList].LoginSid = sysusers.sid AND hasdbaccess = 1

LEFT OUTER JOIN [master]..syslogins syslogins ON [#RoleList].LoginSid = syslogins.sid

'

exec (@strSQL)

End

END

Set @N=@N+1

END

SELECT * FROM TmpUsers
