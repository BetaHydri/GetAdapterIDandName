# Get-NetworkAdaptersInfo PowerShell Script

This script retrieves information about all network interfaces on the current machine.

## Functionality

The script defines a function `Get-NetworkAdaptersInfo` that:

- Retrieves all network interfaces on the machine using the .NET class `System.Net.NetworkInformation.NetworkInterface`.
- Selects specific properties from the network interfaces (`NetworkInterfaceType`, `Name`, `Description`, `Id`, `OperationalStatus`) and sorts them by `OperationalStatus`.
- Returns the network interface objects.

The script then calls this function and formats the returned objects as a table with columns automatically sized to fit the content.

## Usage

Run the script in a PowerShell environment. The script will output a table of network interfaces.

```powershell
PS> .\GetAdaptersIDsandNames.ps1