## function to retrieve the license key of a SQL Server.
##regPath for SQL2008/2008 R2 = "SOFTWARE\Microsoft\Microsoft SQL Server\100\Tools\Setup"
##regPath for SQL2012 = "SOFTWARE\Microsoft\Microsoft SQL Server\110\Tools\Setup"
##regPath for SQL2014 = "SOFTWARE\Microsoft\Microsoft SQL Server\120\DTS\Setup"
##regPath for SQL2016 = "SOFTWARE\Microsoft\Microsoft SQL Server\130\DTS\Setup"
##regPath for SQL2017 = "SOFTWARE\Microsoft\Microsoft SQL Server\140\DTS\Setup"
##regPath for SQL2019 = "SOFTWARE\Microsoft\Microsoft SQL Server\150\DTS\Setup"
##Need to change RegPath value according to your SQL server version 



function Get-SQLserverKey {
## function to retrieve the license key of a SQL Server.

param ($targets = ".")
$hklm = 2147483650
$regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\130\DTS\Setup"
$regValue1 = "DigitalProductId"
$regValue2 = "PatchLevel"
$regValue3 = "Edition"
Foreach ($target in $targets) {
$productKey = $null
$win32os = $null
$wmi = [WMIClass]"\\$target\root\default:stdRegProv"
$data = $wmi.GetBinaryValue($hklm,$regPath,$regValue1)
[string]$SQLver = $wmi.GetstringValue($hklm,$regPath,$regValue2).svalue
[string]$SQLedition = $wmi.GetstringValue($hklm,$regPath,$regValue3).svalue
$binArray = ($data.uValue)[0..16]
$charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"
## decrypt base24 encoded binary data
For ($i = 24; $i -ge 0; $i--) {
$k = 0
For ($j = 14; $j -ge 0; $j--) {
$k = $k * 256 -bxor $binArray[$j]
$binArray[$j] = [math]::truncate($k / 24)
$k = $k % 24
}
$productKey = $charsArray[$k] + $productKey
If (($i % 5 -eq 0) -and ($i -ne 0)) {
$productKey = "-" + $productKey
}
}
$win32os = Get-CimInstance Win32_OperatingSystem -ComputerName $target
$obj = New-Object Object
$obj | Add-Member Noteproperty Computer -value $target
$obj | Add-Member Noteproperty OSCaption -value $win32os.Caption
$obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
$obj | Add-Member Noteproperty SQLver -value $SQLver
$obj | Add-Member Noteproperty SQLedition -value $SQLedition
$obj | Add-Member Noteproperty ProductKey -value $productkey
$obj
}
} 
Get-SQLserverKey