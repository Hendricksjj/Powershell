<#
.SYNOPSIS
    Start the Windows remote management service for one or more devices
.DESCRIPTION
    Start the WinRM service for one or more devices
.EXAMPLE
    Set-CBCRemoteAccess.ps1 -computername Server01
    Starts the WinRM service on Server01
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]
    $ComputerName
)

Get-Service -ComputerName $ComputerName -Name winrm | Start-Service