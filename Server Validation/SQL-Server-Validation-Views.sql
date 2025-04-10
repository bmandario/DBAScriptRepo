/*********************************************
 * Server Validation View Queries
 *********************************************/
USE [ServerValidation]
GO

/****** Object:  View [res].[GetLatestCompareServer]    Script Date: 3/19/2020 3:57:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [res].[GetLatestCompareServer]

AS

  SELECT dh.[UserName], s.[CheckName], s.[SourceServerName], s.[SourceResult], s.[DestinationServerName], s.[DestinationResult], s.[CompareResult]
  FROM [res].[Server] s
    INNER JOIN (SELECT TOP 1
      *
    FROM [dbo].[History] h
    WHERE [UserName] LIKE '%' + SYSTEM_USER + '%'
    ORDER BY h.[ValidationID] DESC) dh on s.[ValidationID] = dh.[ValidationID]

GO

/************ Compatibility ************/
USE [ServerValidation]
GO

/****** Object:  View [res].[GetLatestCompareCompatibility]    Script Date: 3/20/2020 2:32:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [res].[GetLatestCompareCompatibility]

AS

  SELECT dh.[UserName], c.[ServerName], c.[UserDBName], c.[UserDBCompatibilityLevel], c.[ModelDBCompatabilityLevel], c.[CompareResult]
  FROM [res].[DBCompatibility] c
    INNER JOIN (SELECT TOP 1
      *
    FROM [dbo].[History] h
    WHERE h.[UserName] LIKE '%' + SYSTEM_USER + '%' AND h.[CompareName] = 'Compatibility'
    ORDER BY h.[ValidationID] DESC) dh on c.[ValidationID] = dh.[ValidationID]

GO
