<#
.SYNOPSIS
Looks for all Active Directory accounts that are currently locked out and enabled.
.DESCRIPTION
Searches for all locked out Active Directory accounts
.EXAMPLE
#>
function Get-DisabledAccounts {
    BEGIN{
        Import-module -Name ActiveDirectory

    }#BEGIN
    PROCESS{
        try {
            Search-ADAccount -lockedout | Where-Object {$_.enabled -eq $true}
        }
        catch {
            
        }#try/catch

    }#PROCESS
    END{
        Uninstall-Module -Name ActiveDirectory

    }#END

    
}#Function Get-DisabledAccounts