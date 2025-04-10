USE [DBA_WORK]
GO

/****** Object:  StoredProcedure [dbo].[UAR_Table_Check]    Script Date: 1/7/2025 9:53:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UAR_Table_Check]

AS
BEGIN

--if exists (select * from DBA_WORK.sys.all_objects where name LIKE '%Login_Audit%') 
if exists (select * from DBA_WORK.sys.all_objects where create_date <= DATEADD(MONTH, -13, CAST(GETDATE() AS DATE)) and name = 'Login_Audit') 
	BEGIN
		drop table Login_Audit 
		create table Login_Audit 
		(DOMAIN nvarchar (500),SERVER nvarchar (500)default (''),DATABASES nvarchar (200)default (''), LOGIN_ID nvarchar (200)default (''), GROUP_ID nvarchar (200)default (''),LOGON_ID_TYPE nvarchar(200),Logon_ID_Account_status nvarchar(300) default ('Disabled'), Privilege_Type nvarchar(300) default ('Database Role'), Privilege nvarchar(300), Owner nvarchar(300)default(''),Approval nvarchar(300)default(''),Date_Executed DATETIME)
		EXEC Login_Audit_Insert
	END

ELSE
	BEGIN
		EXEC Login_Audit_Insert
	END


	SET NOCOUNT ON;

    -- Insert statements for procedure here
END
GO


