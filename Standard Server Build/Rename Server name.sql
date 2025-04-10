--Please change <old_name> to the old servername and the <new_name> to the new server name

--Reboot the sql server engine

sp_dropserver <old_name>;
GO

sp_addserver <new_name>, local;
GO 