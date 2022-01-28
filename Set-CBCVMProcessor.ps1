function Set-CBCVMProcessor {
    [CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess)]
    param (
        # Name of Virtual Machine
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [Alias('VMName')]
        [String]$Name,

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [Int64]$Count = 2
    )
    Begin{

    }#BEGIN
    Process{
        try {
            Set-VMProcessor -VMName $Name -Count $CPUnum
        }
        catch {
            Write-Error -Message $_.Exception.Message
            
        }#Try/Catch

    }#PROCESS
    End{

    }#END
}#Function Set-CBCVMProcessor