# GetAdaptersIDsandNames.ps1

This PowerShell script retrieves network adapter information and sets the interface metric for a specific adapter. E.g. this could be useful to find the PPP VPN adapter after the successful RASClient connect event 20224 and change afterwards the metric of this PPP Interface. For further information how routes are been priorized and calculated read: [Metric (microsoft-windows-tcpip-interfaces-interface-ipv4settings-metric)](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-tcpip-interfaces-interface-ipv4settings-metric)

## Usage

The script must be run with administrator privileges. It calls the `Get-NetworkAdaptersInfo` function to retrieve network adapter information and stores the result in a variable. It then calls the `Set-MyInterfaceMetric` function to set the interface metric for a specific adapter.

The script displays the results of the changed network interface cards (NICs) and the retrieved network adapter information.

```powershell
$myAdapters = Get-NetworkAdaptersInfo
$changedNICs = Set-MyInterfaceMetric -Adapters $myAdapters -AdapterName "My-VPNUserTunnel" -AdapterType Ppp -AddressFamily IPv4 -InterfaceMetric 1 
$changedNICs | Format-Table -AutoSize
$myAdapters | Format-Table -AutoSize
```

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
