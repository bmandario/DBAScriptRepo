-- Three Day Range 
DECLARE @STARTTIME INT
DECLARE @ENDTIME INT
DECLARE @TimeStamp DATETIME

SET @TIMESTAMP = DATEADD(Day, 3 * - 1 , GETUTCDATE())
SET @STARTTIME= [dbo].[fnConvertDateTimeToTimestamp](@TimeStamp)
SET @ENDTIME= [dbo].[fnConvertDateTimeToTimestamp](SYSUTCDATETIME())

--AVG_DISK_SEC_PER_WRITE
	Select Distinct HostName, [dbo].[fnConvertTimestampToDateTime](timestamp) timestamp, value * 1000 As Value, CSD.InstanceName
from PerformanceAnalysisDataRollup2 PD
Left Join Device On 
Device.id = PD.DeviceID
	INNER JOIN dbo.PerformanceAnalysisConsoleSessionData CSD
	  ON PD.InstanceName = CSD.InstanceID
	WHERE  CSD.MetricTypeDescriptor = 'DiskStalls'
	  AND PD.PerformanceAnalysisCounterID = 59
	  AND PD.Timestamp >=@STARTTIME
	  AND PD.Timestamp <=@ENDTIME
	  AND value * 1000 > 1
	  AND CSD.InstanceName <> 'Total' 
order by HostName, InstanceName, timestamp 

-- AVG_DISK_SEC_PER_READ
Select Distinct HostName, [dbo].[fnConvertTimestampToDateTime](timestamp) timestamp, value * 1000 As Value, CSD.InstanceName
from PerformanceAnalysisDataRollup2 PD
Left Join Device On 
Device.id = PD.DeviceID
INNER JOIN dbo.PerformanceAnalysisConsoleSessionData CSD
  ON PD.InstanceName = CSD.InstanceID
WHERE  CSD.MetricTypeDescriptor = 'DiskStalls'
  AND PD.PerformanceAnalysisCounterID = 57
  AND PD.Timestamp >=@STARTTIME
  AND PD.Timestamp <=@ENDTIME
  AND value * 1000 > 1
 AND CSD.InstanceName <> 'Total' 
order by HostName, InstanceName, timestamp 
