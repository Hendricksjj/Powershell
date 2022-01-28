function Set-CBCUserDisabled {
    [CmdletBinding(ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [String[]]$UserName
    )
    BEGIN {}#BEGIN
    PROCESS {
        foreach ($User in $UserName) {
            if ((Get-ADUser $User).Enabled) {
                #Setting user account to disabled
                Write-Verbose "Disabling $User"
                Set-ADUser $User -Enabled:$false                
            }
            else {
                Write-Error "User account $User is already set to disabled"
            }#if/else
        }#foreach
    }#PROCESS
    END {}#END
}#function Set-CBCUserDisabled