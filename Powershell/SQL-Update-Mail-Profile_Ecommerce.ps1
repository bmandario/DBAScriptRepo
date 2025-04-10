# 
# SQL Mail Update - Updates mail profile
# 1. Read in server list
# 2. Update mail profile SMTP server
#
$Query = Get-Content 'D:\Scripts\SQL\Maintenance_Job_Update_Script.txt'
$InstanceList = Get-Content 'D:\Scripts\PS\SQL Job Email Validation\Update-MaintenanceJob-Server_InstanceList.txt'
$ErrorLog = 'D:\Scripts\PS\SQL Job Email Validation\sqlmaintenancejobfix_error.txt'

foreach ($Instance in $InstanceList) {
    Write-Host $Instance
    try {
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        $Connection.ConnectionString = "server=$Instance;database=master;trusted_connection=true;"
        $Connection.Open()
        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $Command.CommandTimeout = 0
        $Command.CommandText = $Query
        $Command.ExecuteNonQuery()
    }
    catch {
        "$(Get-Date) - Error connecting to $Instance to update mail settings. Exiting." | Out-File $ErrorLog -Append
    }
}