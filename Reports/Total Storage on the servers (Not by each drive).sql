SELECT DISTINCT C.DataCenter,
C.Env,
A.ComputerName,
SUM(A.SizeInGB) AS [Total_Size In GB]
FROM dbo.v_WinViewAll_EX C JOIN dbo.v_WinViewDisk A ON C.ComputerName = A.ComputerName AND C.DeviceNumber=A.DeviceNumber
WHERE   A.DeviceId not IN ('C:','D:','U:','X:') 
GROUP BY
 C.DataCenter,
C.Env,
A.ComputerName