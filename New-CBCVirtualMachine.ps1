function New-CBCVirtualMachine {
    [CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess)]
    param (
        # Name of Virtual Machine to be Created
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [Alias('VMName')]
        [String]$Name,

        # Virtual Machine Generation Type (1 or 2)
        [Parameter(Mandatory = $False)]
        [ValidateSet(1, 2)]
        [Int16]$Generation = 2,

        # Path of the New VHDX to be Created
        [Parameter(Mandatory = $False)]
        [String]$VHDPath = "D:\Hyper-V\Virtual Hard Disks\$Name.vhdx",

        # Path of the VM 
        [Parameter(Mandatory = $False)]
        [String]$Path = 'D:\Hyper-V\Virtual Machines',

        # Size of the VHDX in Bytes
        [Parameter(Mandatory = $false)]
        [UInt64]$VHDSize = 1GB
    )
    
    begin {
        
    }#BEGIN
    
    process {
        try {
            foreach ($VM in $Name) {
                # Test if VM exist
                if (((Get-VM -Name $VM -ErrorAction SilentlyContinue).Name)) {
                    Write-Warning "A Virtual Machine $VM already exists!"
                }
                # Create the new VM
                else {
                    Write-Verbose "Creating Virtual Machine $VM"
                    New-VM -Name $Name -Generation $Generation -NewVHDPath $VHDPath -Path $Path -NewVHDSizeBytes $VHDSize
                }#if/else
            }#foreach
        }
        catch {
            Write-Error -Message $_.Exception.Message
        }#try/catch
    }#PROCESS
    
    end {
        
    }#END
    }#Function New-CBCVirtualMachine