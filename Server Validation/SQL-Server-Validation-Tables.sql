/*********************************************
 * Server Validation Table Creation Queries
 *********************************************/
USE [ServerValidation]
GO

-- Schemas
CREATE SCHEMA [src] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [des] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [res] AUTHORIZATION [dbo]
GO

/****** Object:  Table [dbo].[History]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[History](
	[ValidationID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](130) NULL,
	[UserSID] [varbinary](120) NULL,
	[StartTimestamp] [datetime] NULL,
	[EndTimestamp] [datetime] NULL,
	[CompareName] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[ValidationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Settings]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Settings](
	[Name] [nvarchar](256) NULL,
	[Value] [nvarchar](256) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[AdvancedSQLServerConfiguration]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[AdvancedSQLServerConfiguration](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NOT NULL,
	[Name] [nvarchar](35) NULL,
	[Value] [bigint] NULL,
	[MinValue] [bigint] NULL,
	[MaxValue] [bigint] NULL,
	[ValueInUse] [sql_variant] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[DatabaseSecurity]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[DatabaseSecurity](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[InstanceName] [nvarchar](256) NULL,
	[DBName] [sysname] NOT NULL,
	[Name] [sysname] NOT NULL,
	[GroupName] [sysname] NULL,
	[LoginName] [sysname] NULL,
	[default_database_name] [sysname] NULL,
	[default_schema_name] [varchar](256) NULL,
	[Principal_id] [int] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[InstalledSoftware]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[InstalledSoftware](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[ProductName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [des].[Job]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[Job](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[job_name] [sysname] NOT NULL,
	[job_enabled] [varchar](3) NULL,
	[owner] [nvarchar](256) NULL,
	[sched_enabled] [varchar](3) NOT NULL,
	[scheduleName] [sysname] NOT NULL,
	[frequency] [nvarchar](max) NOT NULL,
	[subFrequency] [varchar](24) NOT NULL,
	[start_time] [char](8) NOT NULL,
	[end_time] [char](8) NOT NULL,
	[Next_Run_Date] [varchar](10) NOT NULL,
	[Next_Run_Time] [char](8) NOT NULL,
	[Max_Duration] [char](8) NOT NULL,
	[Min_Duration] [char](8) NOT NULL,
	[Avg_Duration] [char](8) NOT NULL,
	[Fail_Notify_Name] [nvarchar](138) NOT NULL,
	[Fail_Notify_Email] [nvarchar](100) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [des].[LinkedServer]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[LinkedServer](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[SRV_NAME] [nvarchar](128) NOT NULL,
	[SRV_PROVIDERNAME] [nvarchar](128) NOT NULL,
	[SRV_PRODUCT] [nvarchar](128) NOT NULL,
	[SRV_DATASOURCE] [nvarchar](4000) NULL,
	[SRV_PROVIDERSTRING] [nvarchar](4000) NULL,
	[SRV_LOCATION] [nvarchar](4000) NULL,
	[SRV_CAT] [nvarchar](128) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[Login]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[Login](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[type] [char](1) NOT NULL,
	[type_desc] [nvarchar](60) NULL,
	[is_disabled] [bit] NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[default_database_name] [sysname] NULL,
	[default_language_name] [sysname] NULL,
	[credential_id] [int] NULL,
	[owning_principal_id] [int] NULL,
	[is_fixed_role] [bit] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[LogShipping]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[LogShipping](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[status] [bit] NULL,
	[is_primary] [bit] NULL,
	[server] [sysname] NOT NULL,
	[database_name] [sysname] NOT NULL,
	[time_since_last_backup] [int] NULL,
	[last_backup_file] [nvarchar](50) NULL,
	[backup_threshold] [int] NULL,
	[is_backup_alert_enabled] [bit] NULL,
	[time_since_last_copy] [int] NULL,
	[last_copied_file] [nvarchar](50) NULL,
	[time_since_last_restore] [int] NULL,
	[last_restored_file] [nvarchar](50) NULL,
	[last_restored_latency] [int] NULL,
	[restore_threshold] [int] NULL,
	[is_restore_alert_enabled] [bit] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[Mail]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[Mail](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[principal_id] [varchar](4) NULL,
	[principal_name] [varchar](35) NULL,
	[profile_id] [varchar](4) NULL,
	[profile_name] [varchar](35) NULL,
	[is_default] [varchar](4) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[MailStatus]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[MailStatus](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Status] [varchar](7) NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[ServerAdminUser]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[ServerAdminUser](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Role] [nvarchar](20) NULL,
	[Login\Member Name] [nvarchar](50) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[ServerBuild]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[ServerBuild](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[CurrentOperatingSystem] [nvarchar](128) NULL,
	[IPAddress] [nvarchar](max) NULL,
	[Domain/Workgroup] [nvarchar](256) NULL,
	[NumberOfCores] [nvarchar](max) NULL,
	[SystemMemTotal] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [des].[ServerStorage]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[ServerStorage](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[DriveLetter] [nvarchar](255) NULL,
	[SizeInGB] [int] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[SQLDatabase]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[SQLDatabase](
	[ValidationID] [int] NULL,
	[FQDN] [nvarchar](128) NOT NULL,
	[instancename] [varchar](max) NULL,
	[name] [nvarchar](128) NOT NULL,
	[compatibility_level] [int] NULL,
	[collation_name] [varchar](500) NULL,
	[is_read_committed_snapshot_on] [bit] NULL,
	[is_published] [bit] NULL,
	[is_subscribed] [bit] NULL,
	[DB_Owner] [nvarchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [des].[SQLInstance]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[SQLInstance](
	[ValidationID] [int] NULL,
	[FQDN] [nvarchar](255) NULL,
	[Port] [nvarchar](5) NULL,
	[InstanceName] [nvarchar](255) NULL,
	[Edition] [nvarchar](255) NULL,
	[VersionMajor] [nvarchar](10) NULL,
	[ProductLevel] [nvarchar](20) NULL,
	[Collation] [nvarchar](128) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[SSIS]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[SSIS](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[PackageName] [sysname] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[FolderName] [sysname] NULL,
	[PackageTye] [varchar](16) NOT NULL,
	[OwnerName] [sysname] NULL,
	[CreateDate] [datetime] NOT NULL,
	[Version] [varchar](32) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[SysAdminUser]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[SysAdminUser](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Role] [varchar](8) NOT NULL,
	[Login\Member Name] [nvarchar](50) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [des].[Timezone]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[Timezone](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[TimeZoneKeyName] [nvarchar](100) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [res].[DBCompatibility]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [res].[DBCompatibility](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[UserDBName] [nvarchar](128) NOT NULL,
	[UserDBCompatibilityLevel] [tinyint] NULL,
	[ModelDBCompatabilityLevel] [tinyint] NULL,
	[CompareResult] [bit] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [res].[Server]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [res].[Server](
	[ValidationID] [int] NULL,
	[CheckName] [nvarchar](150) NULL,
	[SourceServerName] [nvarchar](256) NULL,
	[SourceResult] [nvarchar](256) NULL,
	[DestinationServerName] [nvarchar](256) NULL,
	[DestinationResult] [nvarchar](256) NULL,
	[CompareResult] [bit] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[AdvancedSQLServerConfiguration]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[AdvancedSQLServerConfiguration](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NOT NULL,
	[Name] [nvarchar](35) NULL,
	[Value] [bigint] NULL,
	[MinValue] [bigint] NULL,
	[MaxValue] [bigint] NULL,
	[ValueInUse] [sql_variant] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[DatabaseSecurity]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[DatabaseSecurity](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[InstanceName] [nvarchar](256) NULL,
	[DBName] [sysname] NOT NULL,
	[Name] [sysname] NOT NULL,
	[GroupName] [sysname] NULL,
	[LoginName] [sysname] NULL,
	[default_database_name] [sysname] NULL,
	[default_schema_name] [varchar](256) NULL,
	[Principal_id] [int] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[InstalledSoftware]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[InstalledSoftware](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[ProductName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [src].[Job]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[Job](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[job_name] [sysname] NOT NULL,
	[job_enabled] [varchar](3) NULL,
	[owner] [nvarchar](256) NULL,
	[sched_enabled] [varchar](3) NOT NULL,
	[scheduleName] [sysname] NOT NULL,
	[frequency] [nvarchar](max) NOT NULL,
	[subFrequency] [varchar](24) NOT NULL,
	[start_time] [char](8) NOT NULL,
	[end_time] [char](8) NOT NULL,
	[Next_Run_Date] [varchar](10) NOT NULL,
	[Next_Run_Time] [char](8) NOT NULL,
	[Max_Duration] [char](8) NOT NULL,
	[Min_Duration] [char](8) NOT NULL,
	[Avg_Duration] [char](8) NOT NULL,
	[Fail_Notify_Name] [nvarchar](138) NOT NULL,
	[Fail_Notify_Email] [nvarchar](100) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [src].[LinkedServer]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[LinkedServer](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[SRV_NAME] [nvarchar](128) NOT NULL,
	[SRV_PROVIDERNAME] [nvarchar](128) NOT NULL,
	[SRV_PRODUCT] [nvarchar](128) NOT NULL,
	[SRV_DATASOURCE] [nvarchar](4000) NULL,
	[SRV_PROVIDERSTRING] [nvarchar](4000) NULL,
	[SRV_LOCATION] [nvarchar](4000) NULL,
	[SRV_CAT] [nvarchar](128) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[Login]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[Login](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[type] [char](1) NOT NULL,
	[type_desc] [nvarchar](60) NULL,
	[is_disabled] [bit] NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[default_database_name] [sysname] NULL,
	[default_language_name] [sysname] NULL,
	[credential_id] [int] NULL,
	[owning_principal_id] [int] NULL,
	[is_fixed_role] [bit] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[LogShipping]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[LogShipping](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[status] [bit] NULL,
	[is_primary] [bit] NULL,
	[server] [sysname] NOT NULL,
	[database_name] [sysname] NOT NULL,
	[time_since_last_backup] [int] NULL,
	[last_backup_file] [nvarchar](50) NULL,
	[backup_threshold] [int] NULL,
	[is_backup_alert_enabled] [bit] NULL,
	[time_since_last_copy] [int] NULL,
	[last_copied_file] [nvarchar](50) NULL,
	[time_since_last_restore] [int] NULL,
	[last_restored_file] [nvarchar](50) NULL,
	[last_restored_latency] [int] NULL,
	[restore_threshold] [int] NULL,
	[is_restore_alert_enabled] [bit] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[Mail]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[Mail](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[principal_id] [varchar](4) NULL,
	[principal_name] [varchar](35) NULL,
	[profile_id] [varchar](4) NULL,
	[profile_name] [varchar](35) NULL,
	[is_default] [varchar](4) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[MailStatus]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[MailStatus](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Status] [varchar](7) NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[ServerAdminUser]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[ServerAdminUser](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Role] [nvarchar](20) NULL,
	[Login\Member Name] [nvarchar](50) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[ServerBuild]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[ServerBuild](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[CurrentOperatingSystem] [nvarchar](128) NULL,
	[IPAddress] [nvarchar](max) NULL,
	[Domain/Workgroup] [nvarchar](256) NULL,
	[NumberOfCores] [nvarchar](max) NULL,
	[SystemMemTotal] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [src].[ServerStorage]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[ServerStorage](
	[ValidationID] [int] NULL,
	[ComputerName] [nvarchar](256) NULL,
	[DriveLetter] [nvarchar](255) NULL,
	[SizeInGB] [int] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[SQLDatabase]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[SQLDatabase](
	[ValidationID] [int] NULL,
	[FQDN] [nvarchar](128) NOT NULL,
	[instancename] [varchar](max) NULL,
	[name] [nvarchar](128) NOT NULL,
	[compatibility_level] [int] NULL,
	[collation_name] [varchar](500) NULL,
	[is_read_committed_snapshot_on] [bit] NULL,
	[is_published] [bit] NULL,
	[is_subscribed] [bit] NULL,
	[DB_Owner] [nvarchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [src].[SQLInstance]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[SQLInstance](
	[ValidationID] [int] NULL,
	[FQDN] [nvarchar](255) NULL,
	[Port] [nvarchar](5) NULL,
	[InstanceName] [nvarchar](255) NULL,
	[Edition] [nvarchar](255) NULL,
	[VersionMajor] [nvarchar](10) NULL,
	[ProductLevel] [nvarchar](20) NULL,
	[Collation] [nvarchar](128) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[SSIS]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[SSIS](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[PackageName] [sysname] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[FolderName] [sysname] NULL,
	[PackageTye] [varchar](16) NOT NULL,
	[OwnerName] [sysname] NULL,
	[CreateDate] [datetime] NOT NULL,
	[Version] [varchar](32) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[SysAdminUser]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[SysAdminUser](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Role] [varchar](8) NOT NULL,
	[Login\Member Name] [nvarchar](50) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [src].[Timezone]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[Timezone](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[TimeZoneKeyName] [nvarchar](100) NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[History] ADD  DEFAULT (suser_sname()) FOR [UserName]
GO

ALTER TABLE [dbo].[History] ADD  DEFAULT (suser_sid()) FOR [UserSID]
GO

ALTER TABLE [dbo].[History] ADD  DEFAULT (getdate()) FOR [StartTimestamp]
GO

ALTER TABLE [des].[AdvancedSQLServerConfiguration]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[DatabaseSecurity]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[InstalledSoftware]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[Job]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[LinkedServer]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[Login]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[LogShipping]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[Mail]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[MailStatus]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[ServerAdminUser]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[ServerBuild]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[ServerStorage]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[SQLDatabase]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[SQLInstance]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[SSIS]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[SysAdminUser]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [des].[Timezone]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [res].[DBCompatibility]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [res].[Server]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[AdvancedSQLServerConfiguration]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[DatabaseSecurity]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[InstalledSoftware]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[Job]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[LinkedServer]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[Login]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[LogShipping]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[Mail]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[MailStatus]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[ServerAdminUser]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[ServerBuild]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[ServerStorage]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[SQLDatabase]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[SQLInstance]  WITH CHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[SSIS]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[SysAdminUser]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

ALTER TABLE [src].[Timezone]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

INSERT INTO [dbo].[Settings] ([Name],[Value])
VALUES ('SQL Version', '15'),
('OS Version','Microsoft Windows Server 2019 Standard'),
('DBOwner local','sa'),
('DBOwner CORP PROD','corporate\sqlprdservice'),
('DBOwner CORP DEV','corporate\sqldevservice'),
('DBOwner ECOM','ecommerce\sqlprdservice'),
('DBOwner ECOMSTG DEV','ecommercestg\sqldevservice'),
('DBOwner ECOMSTG STG','ecommercestg\sqlstgservice')
GO

CREATE TABLE [src].[Providers](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Name] [nvarchar](50) NULL,
	[guid] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL
) ON [PRIMARY]
GO

ALTER TABLE [src].[Providers]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

CREATE TABLE [des].[Providers](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[Name] [nvarchar](50) NULL,
	[guid] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL
) ON [PRIMARY]
GO

ALTER TABLE [des].[Providers]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO


/****** Object:  Table [src].[WindowsService]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [src].[WindowsService](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](200) NULL,
	[ServiceName] [nvarchar](100) NULL,
	[StartMode] [nvarchar](10) NULL,
	[StartName] [nvarchar](50) NULL,
	[State] [nvarchar](10) NULL,
	[Status] [nvarchar](10) NULL
) ON [PRIMARY]

GO

ALTER TABLE [src].[WindowsService]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO

/****** Object:  Table [des].[WindowsService]    Script Date: 4/6/2021 3:21:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [des].[WindowsService](
	[ValidationID] [int] NULL,
	[ServerName] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](200) NULL,
	[ServiceName] [nvarchar](100) NULL,
	[StartMode] [nvarchar](10) NULL,
	[StartName] [nvarchar](50) NULL,
	[State] [nvarchar](10) NULL,
	[Status] [nvarchar](10) NULL
) ON [PRIMARY]

GO

ALTER TABLE [des].[WindowsService]  WITH NOCHECK ADD FOREIGN KEY([ValidationID])
REFERENCES [dbo].[History] ([ValidationID])
GO