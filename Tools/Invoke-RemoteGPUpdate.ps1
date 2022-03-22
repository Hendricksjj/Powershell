<#
.SYNOPSIS
    Remotely initiate group policy update on one or more devices
.DESCRIPTION
    Remotely force a group policy update on one or more devices
.EXAMPLE
    C:\scripts\Invoke-RemoteGPUpdate.ps1 -ComputerName Server01
    The remote device Server01 group policy is updated
.EXAMPLE
    C:\scripts\Invoke-RemoteGPUpdate.ps1 -ComputerName (Get-Content c:\computers.txt)
    The remote devices in the computers.txt file group policy is updated one by one
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]
    $ComputerName
)
try {
    $ErrorActionPreference = 'Stop'

    foreach ($Computer in $ComputerName) {       
        #Updating Group Policy
        gpupdate.exe /force
    }#foreach
    
}#try
catch {
    Write-Host $_.exception.message
    
}#try/catch
