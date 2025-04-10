SELECT TOP (1000) 
      sql.[ComputerName]
      ,[SqlInstance]
	  ,win.CurrentOperatingSystem
	  ,CASE [VersionMajor]
	  WHEN 15 then 'SQL 2019'
	  WHEN 14 then 'SQL 2017'
	  WHEN 13 then 'SQL 2016'
	  WHEN 12 then 'SQL 2014'
	  WHEN 11 then 'SQL 2012'
	  WHEN 10 then 'SQL 2008 R2'
	  END "SQL Version"
	        ,[Edition]
      ,[Processors]
	  ,([PhysicalMemory] / 1024) + 1 "RAM GB"
	  ,(SELECT sum(round(SizeInGB,-1))
  FROM [DISCOVERY].[dbo].[v_WinViewDisk]
  where ComputerName = sql.[ComputerName]) SizeInGB
  FROM [DISCOVERY].[dbo].[v_InstanceProperties] sql
  LEFT JOIN [DISCOVERY].[dbo].[v_WinViewALL] win on sql.FQDN = win.ComputerName
  where sql.SqlInstance in (
  'uschezldoc1001'
,'USCHEZWBIC1003')