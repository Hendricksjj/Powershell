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