<#
.SYNOPSIS
    Fix the 'hole in the boot' aka BootHole Vulnerablity, CVE-2020-10713, on affected devices remotely.
.DESCRIPTION
    The files are copied to the remote device from the local directory. The new DBX content is split and applied to the secure boot database and the device is restarted.
.EXAMPLE
    c:\scripts\Set-BootholeFix.ps1 -ComputerName Server01
    Files are copied from the local host's C:\DBX directory to a the remote device Server01 and the fix is applied.
.EXAMPLE
    c:\scripts\Set-BootholeFix.ps1 -ComputerName (Get-Content c:\computers.txt)
    Files are copied from the local host's C:\DBX directory to a the remote devices in the computers.txt file and the fix is applied to each remote device.
.EXAMPLE
    c:\scripts\Set-BootholeFix.ps1 -ComputerName Server02 -Path 'D:\BootholeFiles'
    Files are copied from the local host's D:\BootholeFiles directory to Server02 and the fix is applied.
#>

[CmdletBinding()]
param (
    # Computer name of remote PC
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]$ComputerName,

    # Path to the UEFI files
    [Parameter(Mandatory = $false)]
    [String]$Path = 'C:\DBX'
)
try {
    $ErrorActionPreference = 'Stop'

    foreach ($Computer in $ComputerName) {
        Write-Verbose "Checking if any users are logged into $Computer"
        if ((Get-WmiObject -Class win32_computersystem -ComputerName $Computer).username -or (quser /SERVER:$Computer)) {
            Write-Warning "User is currently signed into PC $Computer"
            "$Computer" | Out-File -FilePath C:\ErrorPCs.txt -Append        
        }
        else {
            #Start WinRM on remote PC
            Get-Service -ComputerName $ComputerName -Name winrm | Start-Service
            #Start PSsession
            Write-Verbose "Starting new session with $Computer"
            $session = New-PSSession -ComputerName $Computer
        
            #Copy needed files from Shared drive to remote PC
            Write-Verbose "Copying files to $Computer"
            Copy-Item $Path -Destination "C:\DBX" -ToSession $Session -Recurse
            #Use session to run Boothole fix
            Invoke-Command -Session $session -ScriptBlock {
                #Set Execution Policy
                Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
                #Change directory
                Set-Location -Path C:\DBX
                #Install NuGet Provider
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                #Install SplitDbxContent from PS gallery
                Install-Script -Name SplitDbxContent -Force
                #Split the .bin file
                SplitDbxContent.ps1 "c:\DBX\dbxupdate_x64.bin"
                #Update DBX CA
                Write-Verbose "Updating DBX on $Computer"
                Set-SecureBootUefi -Name dbx -ContentFilePath .\content.bin -SignedFilePath .\signature.p7 -Time 2010-03-06T19:17:21Z -AppendWrite
    
            }#invoke Boothole fix
            #restart PC
            Restart-Computer -ComputerName $Computer -Wait -For Wmi
            Write-Verbose "$Computer successfully booted into OS"       
            #Remove Session
            Remove-PSSession -computername $Computer
            #Turn on WinRM
            Get-Service -ComputerName $Computer -Name winrm | Start-Service
            #Restart new PSSession
            $session = New-PSSession -ComputerName $Computer

            #Set execution policy
            Write-Verbose "Removing files on $Computer"
            Invoke-Command -Session $session -ScriptBlock {
                Uninstall-Script -Name SplitDbxContent -Force
                Remove-Item -Path "C:\DBX" -Recurse 
                Set-ExecutionPolicy -ExecutionPolicy Restricted              
            }#invoke cleanup session
            #Restart PC
            Restart-Computer -ComputerName $Computer -Wait -For Wmi
            Write-Verbose "$Computer successfully booted into OS"
            #Remove session
            Remove-PSSession -computername $Computer
            Write-Verbose "Boothole DBX has successfully been updated on $Computer"
        }#if/else
    }#foreach
    
}#try
catch {
    Remove-PSSession -ComputerName $Computer
    Write-Host $_.exception.message
    Write-Host $_.invocationinfo.positionmessage
    
}#try/catch
