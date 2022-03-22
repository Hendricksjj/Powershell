<#
.SYNOPSIS
    Unblock Files
.DESCRIPTION
    Allows to recursively unblock files in a specific directory
.EXAMPLE
    Set-FileUnblock -Path C:\File\Software
    Unblocks all files in the Software directory
#>
function Set-FileUnblock {
    [CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess)]
    param (
        # Path of the directory of files
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [String]$Path
    )
    
    Get-childitem -path $Path -recurse | Unblock-File
}