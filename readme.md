# GetAdaptersIDsandNames.ps1

This PowerShell script retrieves network adapter information and sets the interface metric for a specific adapter. E.g. this could be useful to find the PPP VPN adapter after the successful RASClient connect event 20224 and change afterwards the metric of this PPP Interface. For further information how routes are been priorized and calculated read: [Metric (microsoft-windows-tcpip-interfaces-interface-ipv4settings-metric)](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-tcpip-interfaces-interface-ipv4settings-metric)

## Usage

The script must be run with administrator privileges.<br> <li>It calls the `Get-NetworkAdaptersInfo` function to retrieve network adapter informations like NetworkInterfaceType, GUID, Name etc. and stores the result in a variable.</li><li>It then calls the `Set-MyInterfaceMetric` function to set the interface metric for a specific adapter.</li>

The script displays the results of the changed network interface cards (NICs) and the retrieved network adapter information.

```powershell
$myAdapters = Get-NetworkAdaptersInfo
$changedNICs = Set-MyInterfaceMetric -Adapters $myAdapters -AdapterName "My-VPNUserTunnel" -AdapterType Ppp -AddressFamily IPv4 -InterfaceMetric 1 
$changedNICs | Format-Table -AutoSize
$myAdapters | Format-Table -AutoSize
```
## Parameters
```powershell
Set-MyInterfaceMetric -Adapters $myAdapters -AdapterName "VPN-UserTunnel" -AdapterType Ppp -AddressFamily IPv4 -InterfaceMetric 1
```
<b>Adapters:</b> This is a mandatory parameter that expects an array. It's used to pass a list of network adapters for the script to process.

<b>AdapterName:</b> This is a mandatory parameter that expects a string. This is the name of a specific network adapter that the script will focus on.

<b>AddressFamily:</b> This is an optional parameter valueset with a default value of "IPv4". It's used to specify the address family for the network adapter. It can only be "IPv4" or "IPv6".

<b>AdapterType:</b> This is an optional parameter valueset with a default value of "Ppp". It's used to specify the type of the network adapter. The possible values are "Ppp", "Ethernet", "Wireless80211", "Tunnel", and "Loopback".

<b>InterfaceMetric:</b> This is an optional parameter with a default value of 1. It's an integer that's used to specify the priority of the network adapter in the routing table. The lower the metric, the higher the priority.

## Error Handling
The script has a trap block that catches any errors and stops the script execution. It writes a warning message with the error details.

```powershell
$ErrorActionPreference = "Stop"
trap {
    Write-Warning "Script failed: $_"
    throw $_
}
```
## Requirements
The script requires the current user to have administrator privileges. If the script is run without administrator privileges, it will display a warning message.
```powershell
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # script execution
}
else {
    Write-Warning "You are not running this script as an administrator."
}
```
