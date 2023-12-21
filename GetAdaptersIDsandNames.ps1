#begin region functions
function Get-NetworkAdaptersInfo {
    # Import the .NET class for network information
    $myAdapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() 

    # Select specific properties from the network interfaces and sort them by OperationalStatus
    $myAdapters = $myAdapters | Select-Object NetworkInterfaceType, Name, Description, Id, OperationalStatus | Sort-Object OperationalStatus

    # Format the network interface objects as a table and return the result
    return $myAdapters
}

function Set-MyInterfaceMetric {
    param (
        [Parameter(Mandatory = $true)]
        [System.Array]$Adapters,
        [Parameter(Mandatory = $true)]
        [string]$AdapterName,
        [Parameter(Mandatory = $false)]
        [ValidateSet("IPv4", "IPv6")]
        [string]$AdapterType = "IPv4",
        [Parameter(Mandatory = $false)]
        [ValidateSet("PPP", "Ethernet", "Wireless80211", "Tunnel", "Loopback", "Tunnel")]
        [string]$AdapterType = "PPP",
        [Parameter(Mandatory = $false)]
        [int]$InterfaceMetric = 1
    )
    foreach ($Adapter in $Adapters) {
        if ($Adapter.NetworkInterfaceType -eq $Adapterype -and $Adapter.Name -eq $AdapterName) {
            $changes = Set-NetIPInterface -InterfaceAlias $Adapter.Name -InterfaceMetric $InterfaceMetric -AddressFamily IPv4 -PassThru
            $changedAdapters += $changes
        }
    }
    return $changedAdapters
}

# end region functions


# Main script

# Call the function and store the result in a variable
$myAdapters = Get-NetworkAdaptersInfo
$changedNICs = Set-MyInterfaceMetric -Adapters $myAdapters -AdapterName "MSFTVPN-Manual" -AdapterType "PPP" -InterfaceMetric 1
$changedNICs | Format-Table -AutoSize
$myAdapters | Select-Object NetworkInterfaceType, Name, Description, Id, OperationalStatus | Sort-Object OperationalStatus | Format-Table -AutoSize