param(
  [string] $SourceServerName
  , [string] $TargetServerName
)
Import-Module 'D:\PS\Server Validation\SQL-Server-Validation-Queries.psm1' -Force

$CurrentUser = "$env:UserDomain\$env:UserName"

$SqlConnection = New-Object System.Data.SQLClient.SQLConnection
$SqlConnection.ConnectionString = "server='$(Get-SQLSVServer)';database='$(Get-SQLSVDatabase)';trusted_connection=true;"
$SqlConnection.Open()
$SqlCmd = New-Object System.Data.SQLClient.SQLCommand
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandTimeout = 0

# SQL Query to execute step 1
try {
  $SqlCmd.CommandText = @"
    EXEC [dbo].[usp_Validation_Step1] '$SourceServerName','$TargetServerName','$CurrentUser'
"@
  $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
  $SqlAdapter.SelectCommand = $SqlCmd
  $DataSet = New-Object System.Data.DataSet
  $SqlAdapter.Fill($DataSet)
}
catch {
  Write-Host $error
}
$ValidationID = $Dataset.Tables[0].Rows[0].ItemArray[0]


# Start Validation step 2
Get-SourceServerInformation $SourceServerName $ValidationID
Get-DestinationServerInformation $TargetServerName $ValidationID


# SQL Query to execute step 3
try {
  $SqlCmd.CommandText = @"
  EXEC [dbo].[usp_Validation_Step3] '$SourceServerName','$TargetServerName',$ValidationID
"@
  $SqlCmd.ExecuteNonQuery()
}
catch {
  Write-Host $error
}
$SqlConnection.Close()