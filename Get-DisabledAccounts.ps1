<#
.SYNOPSIS
Looks for all Active Directory accounts that are currently lockedout and enabled.
.DESCRIPTION
Searches for all locked out Active Directory accounts
.EXAMPLE
#>
Import-module -Name ActiveDirectory
Search-ADAccount -lockedout | Where-Object {$_.enabled -eq $true}