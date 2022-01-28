function Set-CBCVMRam {
    [CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess)]
    param (
        # Name of Virtual Machine
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [Alias('VMName')]
        [String]$Name,

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [Int64]$MinimumBytes = 2048MB,

        # Parameter help description
        [Parameter(AttributeValues)]
        [Int64]$MaximumBytes = 8192MB

    )
    Begin{

    }#BEGIN
    Process{
        try {
            Set-VMMemory -VMName $Name -DynamicMemoryEnabled $true -MinimumBytes $MinimumBytes -MaximumBytes $MaximumBytes -StartupBytes $MinimumBytes
        }
        catch {
            Write-Error -Message $_.Exception.Message            
        }#Try/Catch

    }#PROCESS
    End{

    }#END
    
}#Function Set-CBCVMRam