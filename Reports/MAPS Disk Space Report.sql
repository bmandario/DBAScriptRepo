USE [MAPS_REPORTING]

SELECT DISTINCT C.DataCenter,
C.Env,
A.ComputerName,
A.DeviceId,
A.SizeInGB,
A.FreeSpaceInGB ,
(A.SizeInGB - A.FreeSpaceInGB) As UsedSpace,
A.FreeSpacePct,

CASE 
WHEN A.FreeSpacePct < 30 THEN 1
ELSE 0 
END AS IsLess30PCT,

CAST(CONVERT(NVARCHAR(20),B.CREATEDATETIME,101) AS DATETIME) AS CREATEDATETIME ,

CASE 
WHEN A.FreeSpacePct < 30 THEN  ((A.SizeInGB*30)-(A.FreeSpaceInGB*100))/70 
ELSE 0
END AS SpaceToBeAddedInGB,

CASE
WHEN ((((A.SizeInGB*30)-(A.FreeSpaceInGB*100))/70)%10 )!= 0 
THEN  (((A.SizeInGB*30)-(A.FreeSpaceInGB*100))/70) + (10 - (((((A.SizeInGB*30)-(A.FreeSpaceInGB*100))/70)%10 )))
ELSE ((A.SizeInGB*30)-(A.FreeSpaceInGB*100))/70 
END AS RoundedSTBAInGB


FROM dbo.v_WinViewAll_EX C JOIN dbo.v_WinViewDisk A ON C.ComputerName = A.ComputerName JOIN [dbo].[LogicalDisks] B ON A.DeviceId = B.DeviceId
WHERE A.FreeSpacePct < 30 
AND A.DeviceId not IN ('C:','Z:','X:')
ORDER BY C.DataCenter,C.Env