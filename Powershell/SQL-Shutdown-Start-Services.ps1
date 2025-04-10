# Turn off SQL services via PS (Run in Admin mode)

# Run this to make sure the returned services are correct
(Get-CimInstance -ComputerName 'USCHWSQL4516' -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')}).Name

# Print PS commands for a remote server (controlled method)
$Start = ''
foreach ($ServiceName in ((Get-CimInstance -ComputerName 'USCHWSQL4516' -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')}).Name)) {
   
    # Shutdown and disable service
    Write-Host "Set-Service -Name $ServiceName -Status Stopped -StartupType Manual"

    # Turn on and enable service
    $Start += "Set-Service -Name $ServiceName -Status Running -StartupType Automatic `n"
}
Write-Host "`n"
Write-Host $Start

# Print PS commands for the current server (controlled method)
$Start = ''
foreach ($ServiceName in ((Get-CimInstance -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')}).Name)) {
    
    # Shutdown and disable service
    Write-Host "Set-Service -Name $ServiceName -Status Stopped -StartupType Manual"

    # Turn on and enable service
    $Start += "Set-Service -Name $ServiceName -Status Running -StartupType Automatic `n"
}
Write-Host "`n"
Write-Host $Start


# Example of returned result
Get-Service -Name MsDtsServer150 | Stop-Service -Force
Get-Service -Name MsDtsServer150 | Start-Service
Get-Service -Name MSSQLFDLauncher | Stop-Service -Force
Get-Service -Name MSSQLFDLauncher | Start-Service
Get-Service -Name MSSQLLaunchpad | Stop-Service -Force
Get-Service -Name MSSQLLaunchpad | Start-Service
Get-Service -Name MSSQLSERVER | Stop-Service -Force
Get-Service -Name MSSQLSERVER | Start-Service
Get-Service -Name SQLBrowser | Stop-Service -Force
Get-Service -Name SQLBrowser | Start-Service
Get-Service -Name SQLSERVERAGENT | Stop-Service -Force
Get-Service -Name SQLSERVERAGENT | Start-Service

# Directly turn off services
(Get-CimInstance -ComputerName 'USCHWSQL4516' -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')}).Name | Stop-Service -Force

(Get-CimInstance -ComputerName 'USCHWSQL4516' -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')}).Name | Start-Service


# # Query SQL server services w/o RDP. This is great for validating all SQL services after boot.
Get-CimInstance -ComputerName 'USCHWSQL4516' -Class Win32_Service | where-object { $_.name -like 'mssql*' -or $_.name -like 'MsDts*' -or $_.name -like 'SQL*' -and ($_.name -notlike '*tele*' -and $_.name -notlike '*writer*')} | Format-Table -AutoSize
