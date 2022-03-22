<#
.SYNOPSIS
    Start the Windows remote management service for one or more devices
.DESCRIPTION
    Start the WinRM service for one or more devices
.EXAMPLE
    Set-RemoteAccess.ps1 -computername Server01
    Starts the WinRM service on Server01
#>
function Set-RemoteAccess {
    [CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]$ComputerName
)
BEGIN{

}#BEGIN
PROCESS{
    Get-Service -ComputerName $ComputerName -Name winrm | Start-Service

}#PROCESS
END{

}#END
    
}#Function Set-RemoteAccess

