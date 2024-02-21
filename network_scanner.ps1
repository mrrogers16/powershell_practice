
function Discover-Hosts {
    param(
        [string]$startIP = "192.168.1.1"
        [string]$endIP = "192.168.1.255"
    )
}


# Convert IP addresses to integer for easy loop
$ipRangeStart = [System.Net.IPAddress]::Parse($startIP).GetAddressBytes()
[Array]::Reverse($ipRangeStart)
$ipStart = [System.BitConverter]::ToUInt32($ipRangeStart, 0)

$ipRangeEnd = [System.Net.IPAddress]::Parse($endIP).GetAddressBytes()
[Array]::Reverse($ipRangeEnd)
$ipEnd = [System.BitConverter]::ToUInt32($ipRangeEnd, 0)

# Loop through range
for ($ip = $ipStart; $ip -le $ipEnd; $ip++) {
    $currentIPBytes = [System.BitConverter]::GetBytes($ip)
    [Array]::Reverse($currentIPBytes)
    $currentIP = [System.Net.IPAddress]::new($currentIPBytes).ToString()

        # Ping the current IP
        $ping = New-Object System.Net.NetworkInformation.Ping
        $result = $ping.Send($currentIP, 100) # 100 ms timeout for each ping
        if ($result.Status -eq "Success") {
            Write-Output "Host alive: $currentIP"
        }
    }