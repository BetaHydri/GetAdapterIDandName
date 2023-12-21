# GetAdaptersIDsandNames.ps1

This PowerShell script retrieves network adapter information and sets the interface metric for a specified adapter.

## Usage

Run the script in a PowerShell session with administrative privileges. The script checks if the current user is an administrator before proceeding.

```powershell
.\GetAdaptersIDsandNames.ps1
```

## Functions
Get-NetworkAdaptersInfo: This function retrieves information about all network adapters on the system.

Set-MyInterfaceMetric: This function sets the interface metric for a specified adapter.

## Output
The script outputs two tables:

A table of adapters whose interface metric was changed. The table includes the adapter's name, description, ID, and operational status.

A table of all network adapters, sorted by operational status. The table includes the adapter's type, name, description, ID, and operational status.

## Error Handling
The script stops execution and throws an error if any command fails.

## Requirements
The script must be run with administrative privileges.
The script is designed to work on Windows systems with PowerShell installed.
