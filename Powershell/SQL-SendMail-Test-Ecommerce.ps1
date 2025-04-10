# 
# SQL Mail Validation - Export list of SQL VMs into different reports by domain/stage
# 1. Connect to remote server and send test email
# 2. Log into SQLJobEmailSendMail table
#
$Query = @"
USE msdb

DECLARE @CustomSubject nvarchar(MAX)
, @CustomBody nvarchar(MAX)
SET @CustomSubject = 'SQL SendMail Email Test from ' + @@SERVERNAME
SET @CustomBody = 'This is the body of the test message from ' + @@SERVERNAME + '.
Congrats! Database mail received by you successfully.'

EXEC sp_send_dbmail @profile_name='DBA_Notifications',
@recipients='vincent.tran@ingrammicro.com',
@subject=@CustomSubject,
@body=@CustomBody
"@
$ErrorLog = 'D:\Scripts\PS\SQL Job Email Validation\senderror.txt'
$Output = 'D:\Scripts\PS\SQL Job Email Validation\output.txt'

$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server=USCHWSQL1383;database=DBA_WORK;trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandTimeout = 0

try {
    $Command.CommandText = 'SELECT DISTINCT [ConnectionString] FROM [USCHWSQL1316\MAPS].[DISCOVERY].[dbo].[v_SQLInstance_Ports] WHERE [FQDN] LIKE ''%ecommerce%'' AND [Env] = ''Prod'' ORDER BY [ConnectionString]'
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $Command
    $DataSet = New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet)
    $Result = $DataSet.Tables[0]
}
catch {
    "$(Get-Date) - Error connecting to USCHWSQL1316 for data. Exiting." | Out-File $ErrorLog -Append
    exit
}

"--Script runtime: $(Get-Date)" | Out-File $Output -Append

foreach ($Row in $Result) { 
    Write-Host $Row.ConnectionString
    try {
        $Connection2 = New-Object System.Data.SQLClient.SQLConnection
        $Connection2.ConnectionString = "server=$($Row.ConnectionString);Initial Catalog=master;trusted_connection=true;"
        $Connection2.Open()
        $Command2 = New-Object System.Data.SQLClient.SQLCommand
        $Command2.Connection = $Connection2
        $Command2.CommandTimeout = 0
        $Command2.CommandText = $Query
        $Command2.ExecuteNonQuery()
        $Connection2.Close()
    }
    catch {
        "$(Get-Date) - Error with connecting to $($Row.ConnectionString)." | Out-File $ErrorLog -Append 
    }
    try {
        $Command.CommandText = "INSERT INTO [DBA_WORK].[dbo].[SQLJobEmailSendMail]([ConnectionString],[EmailSent],[EmailReceived],[Timestamp])VALUES('$($Row.ConnectionString)',1,0,GETDATE())"
        $Command.ExecuteNonQuery()  
    }
    catch {
        "$(Get-Date) - Could not INSERT new row for $($Row.ConnectionString)." | Out-File $ErrorLog -Append 
    }

    "UPDATE [DBA_WORK].[dbo].[SQLJobEmailSendMail] SET [EmailReceived] = 1 WHERE [ConnectionString] = '$($Row.ConnectionString)'" | Out-File $Output -Append

    Start-Sleep -s 10
}
$Connection.Close()
