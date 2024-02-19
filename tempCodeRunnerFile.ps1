Write-Host "System Information Report"
Write-Host "-------------------------"
Write-Host "OS Version: $OSVersion"
Write-Host "System Uptime: $FormattedUptime"
Write-Host "Current User: $CurrentUser"
Write-Host "CPU: $CPU"
Write-Host "Memory Usage: $MemUsage"
Write-Host "Disk Space Information"
$DiskInfo | ForEach-Object {Write-Host $_}
Write-Host "Network Adapter Configuration:"
$NetworkInfo | ForEach-Object { Write-Host $_ }