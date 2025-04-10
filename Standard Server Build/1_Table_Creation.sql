USE [DBA_WORK]
GO

/****** Object:  Table [dbo].[Login_Audit]    Script Date: 1/7/2025 9:04:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Login_Audit](
	[DOMAIN] [nvarchar](500) NULL,
	[SERVER] [nvarchar](500) NULL,
	[DATABASES] [nvarchar](200) NULL,
	[LOGIN_ID] [nvarchar](200) NULL,
	[GROUP_ID] [nvarchar](200) NULL,
	[LOGON_ID_TYPE] [nvarchar](200) NULL,
	[Logon_ID_Account_status] [nvarchar](300) NULL,
	[Privilege_Type] [nvarchar](300) NULL,
	[Privilege] [nvarchar](300) NULL,
	[Owner] [nvarchar](300) NULL,
	[Approval] [nvarchar](300) NULL,
	[Date_Executed] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [SERVER]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [DATABASES]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [LOGIN_ID]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [GROUP_ID]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('Disabled') FOR [Logon_ID_Account_status]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('Database Role') FOR [Privilege_Type]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [Owner]
GO

ALTER TABLE [dbo].[Login_Audit] ADD  DEFAULT ('') FOR [Approval]
GO


