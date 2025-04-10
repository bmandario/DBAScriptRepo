--This is in relation to CTASK4402783
--We were asked to create a New Event Session
--After Creating the Event Session
--Go to Management >> Extended Events >> Sessions >> Right-Click Newly Created Session >> Click Start Session
--Validation Scripts are shown below
--NOTE: You can also View Live Data by right-clicking the newly created Session

SELECT ES.name, 
       CASE 
           WHEN RS.name IS NULL THEN 'Stopped' 
           ELSE 'Running' 
       END AS state
FROM sys.server_event_sessions ES
LEFT JOIN sys.dm_xe_sessions RS ON ES.name = RS.name
WHERE ES.name = 'Your_Session_Name';

SELECT * FROM sys.dm_xe_sessions WHERE name = 'Your_Session_Name';
