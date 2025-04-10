# 
# SQL Mail Validation - Export list of SQL VMs into different reports by domain/stage
# 1. Read in server list
# 2. Update mail profile SMTP server
# 3. Validate results
#
$UpdateQuery = @"
EXECUTE msdb.dbo.sysmail_update_account_sp
    @account_name = 'SQLDBA'
    ,@mailserver_name = 'uschizrelay.corporate.ingrammicro.com'
"@
$ValidationQuery = 'EXECUTE msdb.dbo.sysmail_help_account_sp'
$InstanceList = Get-Content 'D:\Scripts\SQL\Update-SMTP-Server_InstanceList.txt'
$ErrorLog = 'D:\Scripts\PS\SQL Job Email Validation\sqlmailprofile_error.txt'

$Connection = New-Object System.Data.SQLClient.SQLConnection
foreach ($Instance in $InstanceList) {
    try {
        $Connection.ConnectionString = "server=$Instance;database=master;trusted_connection=true;"
        $Connection.Open()
        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $Command.CommandTimeout = 0
        $Command.CommandText = $UpdateQuery
        $Command.ExecuteNonQuery()
    }
    catch {
        "$(Get-Date) - Error connecting to $Instance to update mail settings. Exiting." | Out-File $ErrorLog -Append
        exit
    }
    try {
        $Command.CommandText = $ValidationQuery
        $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $SqlAdapter.SelectCommand = $Command
        $DataSet = New-Object System.Data.DataSet
        $SqlAdapter.Fill($DataSet)
        $Connection.Close()
    }
    catch {
        "$(Get-Date) - Error connecting to $Instance for validation mail settings. Exiting." | Out-File $ErrorLog -Append
        exit
    }
    try {
        if ($DataSet.Tables[0].Rows.Count -gt 0) {

            $ServerNameCol = New-Object Data.DataColumn
            $ServerNameCol.ColumnName = 'connectionstring'
            $DataSet.Tables[0].Columns.Add($ServerNameCol)
            $ServerNameCol.SetOrdinal(0);
            $DataSet.Tables[0] | ForEach-Object { $_.connectionstring = $Instance }
            

            $SqlBulkCopy = New-Object ('Data.SqlClient.SqlBulkCopy') "Server=USCHWSQL1316;Database=DBA_WORK;Trusted_Connection=True"
            $SqlBulkCopy.DestinationTableName = '[dbo].[SQLMailProfile]'
            $SqlBulkCopy.BatchSize = 5000
            $SqlBulkCopy.BulkCopyTimeout = 0
            $SqlBulkCopy.WriteToServer($DataSet.Tables[0])
            $SqlBulkCopy.Close()   
        }
        else {
            "$(Get-Date) - No SQL mail profile data from for $Instance." | Out-File $ErrorLog -Append
        }
    }
    catch {
        "$(Get-Date) - Could not BulkCopy data into USCHWSQL1316 for $Instance." | Out-File $ErrorLog -Append
        exit
    }
}