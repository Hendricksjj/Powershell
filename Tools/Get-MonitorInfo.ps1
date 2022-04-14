<#
.DESCRIPTION
    Query WMI to get Make, Model, and Serial number and print to the screen.
.EXAMPLE
    c:\scripts\Get-CBCMonitorInfo.ps1 -ComputerName server01
    Prints the monitor information to the shell for server01
.EXAMPLE
    c:\scripts\Get-CBCMonitorInfo.ps1  -ComputerName (Get-Content c:\computerNames.txt)
    Prints the monitor information to the shell for each PC in the computerName.txt file
#>

[CmdletBinding()]
param (
    # Computer name of remote PC
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]$ComputerName
)
try {
    $ErrorActionPreference = 'Stop'    

    foreach ($Computer in $ComputerName) { 
        Write-Verbose "Checking monitor info for $Computer"      
        #Start WinRM on remote PC
        Get-Service -ComputerName $ComputerName -Name winrm | Start-Service
        #Start PSsession
        Write-Verbose "Starting new session with $Computer"
        $session = New-PSSession -ComputerName $Computer
        
        #Use session to run Check Monitor info
        Invoke-Command -Session $session -ScriptBlock {
    #Define Function
    function Decode {
        If ($args[0] -is [System.Array]) {
            [System.Text.Encoding]::ASCII.GetString($args[0])
        }
        Else {
            "Not Found"
        }
    }#Function Decode
            #Set variable for monitor info
            $Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi
            #Collect info for each monitor
            ForEach ($Monitor in $Monitors) {  
                $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
                $Name = Decode $Monitor.UserFriendlyName -notmatch 0
                $Serial = Decode $Monitor.SerialNumberID -notmatch 0
                $PC = $Monitor.PSComputerName
                   
                Write-Output "$Manufacturer, $Name, $Serial, $PC"
                Set-ExecutionPolicy -ExecutionPolicy Restricted 
            }#ForEach Monitor

        }#invoke Scriptblock      
        #Remove Session
        Remove-PSSession -computername $Computer             
    }#ForEach Computer    
}#try
catch {
    Remove-PSSession -ComputerName $Computer
    Write-Host $_.exception.message
    Write-Host $_.invocationinfo.positionmessage
    
}#try/catch
