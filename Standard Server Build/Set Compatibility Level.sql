/* This is for SQL Server 2019 version. Change the @Complevel if you want to set lower than 2019 */



DECLARE @SQL VARCHAR(max)  = '',

@CompLevel int = 150



SELECT @SQL += 'ALTER DATABASE ' + quotename(NAME) + ' SET COMPATIBILITY_LEVEL = ' + cast(@CompLevel as char (3)) + ';' + CHAR(10) + CHAR(13)

FROM sys.databases

WHERE database_id > 4

AND COMPATIBILITY_LEVEL <> @CompLevel



PRINT @SQL

EXEC (@SQL)