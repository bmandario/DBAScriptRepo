declare @SQLcmd nvarchar(max) 
set @SQLcmd =N'USE [?];
BEGIN
DECLARE @UserName nvarchar(1000);
DECLARE orphanuser_cur cursor for
SELECT UserName = name
FROM sysusers
WHERE issqluser = 1 and (sid is not null and sid <> 0x0) and suser_sname(sid) is null
ORDER BY name
OPEN orphanuser_cur
FETCH NEXT FROM orphanuser_cur INTO @UserName
WHILE (@@fetch_status = 0)
BEGIN
PRINT @UserName + '' user name being resynced''
EXEC sp_change_users_login ''Update_one'', @UserName, @UserName
FETCH NEXT FROM orphanuser_cur INTO @UserName
END
CLOSE orphanuser_cur
DEALLOCATE orphanuser_cur
END;' 
--PRINT @SQLcmd
EXEC sys.sp_MSforeachdb  @command1 = @SQLcmd