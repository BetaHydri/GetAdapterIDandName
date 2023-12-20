function Get-NetworkAdaptersInfo {
    # Import the .NET class for network information
    $myAdapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() 

    # Select specific properties from the network interfaces and sort them by OperationalStatus
    $myAdapters = $myAdapters | Select-Object NetworkInterfaceType, Name, Description, Id, OperationalStatus | Sort-Object OperationalStatus

    # Format the network interface objects as a table and return the result
    return $myAdapters
}

# Call the function and store the result in a variable
$myAdapters = Get-NetworkAdaptersInfo
$myAdapters | Format-Table -AutoSize