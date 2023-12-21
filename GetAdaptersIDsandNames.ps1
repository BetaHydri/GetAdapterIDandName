#region functions
function Get-NetworkAdaptersInfo {
    param(
        [Paramter(Mandatory = $false)]
        [switch]$ShowResults = $false
    )
    # Import the .NET class for network information
    Begin {
        $myAdapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() 
    }

    Process {
        # Select specific properties from the network interfaces and sort them by OperationalStatus
        $myAdapters = $myAdapters | Select-Object NetworkInterfaceType, Name, Description, Id, OperationalStatus | Sort-Object OperationalStatus
    }
    # Format the network interface objects as a table and return the result
    End {
        if ($ShowResults) {
            $myAdapters | Format-Table -AutoSize
        }
        return $myAdapters
    }
}

function Set-MyInterfaceMetric {
    param (
        [Parameter(Mandatory = $true)]
        [System.Array]$Adapters,
        [Parameter(Mandatory = $true)]
        [string]$AdapterName,
        [Parameter(Mandatory = $false)]
        [ValidateSet("IPv4", "IPv6")]
        [string]$AddressFamily = "IPv4",
        [Parameter(Mandatory = $false)]
        [ValidateSet("Ppp", "Ethernet", "Wireless80211", "Tunnel", "Loopback", "Tunnel")]
        [string]$AdapterType = "Ppp",
        [Parameter(Mandatory = $false)]
        [int]$InterfaceMetric = 1
    )
    foreach ($Adapter in $Adapters) {
        if (($($Adapter.NetworkInterfaceType) -eq $AdapterType) -and ($($Adapter.Name) -eq $AdapterName)) {
            $changes = Set-NetIPInterface -InterfaceAlias $Adapter.Name -InterfaceMetric $InterfaceMetric -AddressFamily $AddressFamily -PassThru
            $changedAdapters += $changes
        }
    }
    return $changedAdapters
}
# endregion functions


# Main script

# Set error handling
$ErrorActionPreference = "Stop"
trap {
    Write-Warning "Script failed: $_"
    throw $_
}

# Check if the current user is an administrator
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host -ForegroundColor green "You are running this script as an administrator."
    # Call the function and store the result in a variable
    $myAdapters = Get-NetworkAdaptersInfo
    $changedNICs = Set-MyInterfaceMetric -Adapters $myAdapters -AdapterName "MSFTVPN-Manual" -AdapterType Ppp -AddressFamily IPv4 -InterfaceMetric 1
    # Display changed Adapters as the result
    Write-Information "Changed Adapters:" -InformationAction Continue
    $changedNICs | Format-Table -AutoSize
    # Display all Adapters IDs and Names as the result
    Write-Information "All Adapters ID and other properties:" -InformationAction Continue
    $myAdapters | Select-Object NetworkInterfaceType, Name, Description, Id, OperationalStatus | Sort-Object OperationalStatus | Format-Table -AutoSize
}
else {
    Write-Warning "You are not running this script as an administrator."
}
