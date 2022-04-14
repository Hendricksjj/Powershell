<#
.DESCRIPTION
    Sets each account to a shared mailbox, disallows any outside mail to be delivered to the inbox and hides the account from the GAL(global address list).
.EXAMPLE
    Set-UserShared.ps1 -Identity john.smith@domain.com
    Sets user account john.smith to a shared mailbox, disallows any outside mail to be delievered and hides the account from the GAL
.EXAMPLE
    Set-UserShared.ps1 -Identity (Get-Content usersEmails.txt)
    Sets each user account in the userEmails.txt file to a shared mailbox, disallows any outside mail to be delievered and hides the account from the GAL
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
    [String[]]$Identity
)
try {
    $ErrorActionPreference = 'Stop'

    foreach ($ID in $Identity) {       
        #Set Accounts to Shared & remove from the GAL
        Write-Verbose "Setting account: $ID to Shared"
        Set-RemoteMailbox -Identity $ID -Type Shared -AcceptMessagesOnlyFrom $ID -HiddenFromAddressListsEnabled $true
    }#foreach
    
}#try
catch {
    Write-Host $_.exception.message
    
}#try/catch