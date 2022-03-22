<#
.SYNOPSIS
    Remove all group memeberships
.DESCRIPTION
    Remove all group memberships from one of more Users
.PARAMETER USERNAME
    The username or names that you wish to remove groups memeberships from. Username does except value form pipline
.EXAMPLE
    Remove-Groups -Username user1
    Removes all groups from user1
.EXAMPLE
    Get-Content -Path 'C:\users.txt' | Remove-CBCGroups
    Finds all users in the file and pipes them to Remove-Groups. Removing all memeberships from each user.
#>
function Remove-Groups {
    [CmdletBinding(ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [String[]]$UserName

    )
    BEGIN {
        Import-Module -Name ActiveDirectory
    }#BEGIN
    
    PROCESS {
        try {
            foreach ($User in $UserName) {
                Write-Verbose "Finding group memberships of $User"
                # Find group memberships
                $ADgroups = Get-ADPrincipalGroupMembership -Identity $User | Where-Object { $_.Name -ne "Domain Users" }
                # Check if user is a member of any groups
                Write-Verbose "Verifing $User is a member of at least 1 group"
                if ($null -eq $ADgroups) {
                    Write-Error "$user is not a member of any groups"                    
                }
                else {
                    Write-Verbose "Removing group memberships from $User"
                    Write-Warning "The following groups will be removed from $User : $($ADgroups.name)"
                    # Remove all group memberships from user account
                    $MembershipParams = @{'Identity' = $User
                        'MemberOf'                   = $ADgroups
                    }
                    Remove-ADPrincipalGroupMembership @MembershipParams
                    
                }#if/else               
                
            }#foreach
        }
        catch {
            Write-Error -Message $_.Exception.Message            
        }#try/catch

    }#PROCESS

    END {
        Uninstall-Module -Name ActiveDirectory
    }#END
  
}#function Remove-Groups