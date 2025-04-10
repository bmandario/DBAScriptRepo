-- Run from maps db
with SQLServers as 
(SELECT substring(computername, 1, patindex('%.%', ComputerName)-1) as ServerName, DataCenter FROM v_WinViewAll_EX)

SELECT 
M.DataCenter
,S.TimeStamp

,S.EntityCaption

,S.Name


FROM [USCHWSQL1544D\SAM].[SolarwindsOrion].[dbo].[AlertHistoryView] S 
join SQLServers M on S.EntityCaption=M.Servername

WHERE S.ObjectType = 'Node' and S.EventTypeWord = 'Triggered'