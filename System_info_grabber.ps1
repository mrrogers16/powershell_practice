# Output file parameter
param (
    [string]$OutputFile
)

# Get OS Version
try { 
    $OSVersion = (Get-CimInstance Win32_OperatingSystem).Version
}
catch {
    Write-Error "Error retrieving OS Version: $_"
    $OSVersion = "Unavailable"
}


# Get System Uptime
try {
    $Uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
}
catch {
    Write-Error "Error retrieving System Time: $_"
    $Uptime = "Unavailable"
}

$CurrentTime = Get-Date
$UptimeSpan = $CurrentTime - $Uptime
$FormattedUptime = "{0} Days, {1} Hours, {2} Minutes" -f $UptimeSpan.Days, $UptimeSpan.Hours, $UptimeSpan.Minutes

# Get Current User
$CurrentUser = whoami

# CPU Information
try {
    $CPU = (Get-CimInstance Win32_Processor).Name
}
catch {
    Write-Error "Error retrieving CPU Information: $_"
    $CPU = "Unavailable"
}


# Memory Usage
try {
    $TotalMem = (Get-CimInstance Win32_OperatingSystem).TotalPhysicalMemory
}
catch {
    Write-Error "Error retreiving Total Memory: $_"
    $TotalMem = "Unavailable"
}
try {
    $FreeMem = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory
}
catch {
    Write-Error "Error retreiving Free Memory: $_"
    $FreeMem = "Unavailable"
}

$UsedMem = $TotalMem - ($FreeMem * 1024) # Convert KB to Bytes for FreeMem
$MemUsage = "{0:N2} GB Total, {1:N2} GB Used" -f ($TotalMem / 1GB), ($UsedMem / 1GB)

# Disk Space Information
try {
    $Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3"
}
catch {
    Write-Error "Error retreiving disk info: $_"
    $Disks = "Unavailable"
}

if (-not $Disks) {
    Write-Warning "No disk information found."
}

$DiskInfo = $Disks | ForEach-Object {
    $freespace = $_.FreeSpace / 1GB
    $size = $_.Size / 1GB
    $diskOutput = "$($_.DeviceID) - {0:N2} GB Free of {1:N2} GB Total" -f $freespace, $size   
    $diskOutput
}

# Network Adapter Configuration
$NetworkInfo = @()
$NetworkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"
foreach ($adapter in $NetworkAdapters) {
    $description = $adapter.Description 
    $ipAddress = if ($adapter.IPAddress) { $adapter.IPAddress[0] } else { "Not Currently Available" }
    $subnetMask = if ($adapter.IPSubnet) { $adapter.IPSubnet[0] } else { "Not Currently Available" }
    $defaultGateway = if ($adapter.DefaultIPGateway) { $adapter.DefaultIPGateway[0] } else { "Not Currently Available" }
    $netOutput = "Adapter: $description`r`nIP Address: $ipAddress`r`nSubnet Mask: $subnetMask`r`nDefault Gateway: $defaultGateway`r`n"
    $NetworkInfo += $netOutput
}   

# Initialize empty array to hold output
$output = @()

# Append information to the $output array
$output += "System Information Report"
$output += "-------------------------"
$output += "OS Version: $OSVersion"
$output += "System Uptime: $FormattedUptime"
$output += "Current User: $CurrentUser"
$output += "CPU: $CPU"
$output += "Memory Usage: $MemUsage"
$output += "Disk Space Information"
$output += $DiskInfo
$output += "Network Adapter Configuration:"
$output += $NetworkInfo

if ($OutputFile) {
    try {    
        $output | Out-File -FilePath $OutputFile
    }
    catch {
        Write-Error "Failed to write to the output file: $_"
    }
}
else {
    $output | ForEach-Object { Write-Host $_ }
}


# Display Information
# Write-Host "System Information Report"
# Write-Host "-------------------------"
# Write-Host "OS Version: $OSVersion"
# Write-Host "System Uptime: $FormattedUptime"
# Write-Host "Current User: $CurrentUser"
# Write-Host "CPU: $CPU"
# Write-Host "Memory Usage: $MemUsage"
# Write-Host "Disk Space Information"
# $DiskInfo | ForEach-Object {Write-Host $_}
# Write-Host "Network Adapter Configuration:"
# $NetworkInfo | ForEach-Object { Write-Host $_ }