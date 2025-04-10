# 
# SQL Mail Validation - Export list of SQL VMs into different reports by domain/stage
# 1. Check mail configuration
# 2. Log results
#
$ErrorLog = 'D:\PS\SQL Job Email Validation\error.txt'

$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server=USCHWSQL1316\MAPS;database=DISCOVERY;trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandTimeout = 0

try {
  $Command.CommandText = 'SELECT DISTINCT [ConnectionString] FROM [DISCOVERY].[dbo].[v_SQLInstance_Ports] WHERE [FQDN] NOT LIKE ''%ecommerce%'' AND [Env] = ''Prod'' ORDER BY [ConnectionString]'
  $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
  $SqlAdapter.SelectCommand = $Command
  $DataSet = New-Object System.Data.DataSet
  $SqlAdapter.Fill($DataSet)
  $Connection.Close()
  $Result = $DataSet.Tables[0]
}
catch {
  "$(Get-Date) - Error connecting to USCHWSQL1316 for data. Exiting." | Out-File $ErrorLog -Append
  exit
}
$Query = Get-Content 'D:\SQL Scripts\Maintenance_Job_Info_Script.txt'

foreach ($Row in $Result) {
  Write-Host $Row.ConnectionString
  try {
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server=$($Row.ConnectionString);Initial Catalog=master;trusted_connection=true;"
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandTimeout = 0
    $Command.CommandText = $Query
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $Command
    $DataSet2 = New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet2)
    $Connection.Close()

    if ($DataSet2.Tables[0].Rows.Count -gt 0) {
      $SqlBulkCopy = New-Object ('Data.SqlClient.SqlBulkCopy') "Server=USCHWSQL1316\MAPS;Database=DBA_Work;Trusted_Connection=True"
      $SqlBulkCopy.DestinationTableName = '[dbo].[SQLJobEmail]'
      $SqlBulkCopy.BatchSize = 5000
      $SqlBulkCopy.BulkCopyTimeout = 0
      $SqlBulkCopy.WriteToServer($DataSet2.Tables[0])
      $SqlBulkCopy.Close()   
    }
    else {
      "$(Get-Date) - No jobs found on $($Row.ConnectionString)." | Out-File $ErrorLog -Append
    }
  }
  catch {
    "$(Get-Date) - Error with connecting to $($Row.ConnectionString)." | Out-File $ErrorLog -Append
  }
}