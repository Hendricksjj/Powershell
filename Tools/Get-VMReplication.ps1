<#
.SYNOPSIS
VMReplication retrieves the replication status of all virtual machines from the primary hosts
.DESCRIPTION
Retrieves virtual machine name, replication health, status, and last replication time
.PARAMETER computername
The computer name, or names, to query.
.EXAMPLE
VMReplication -computername Server1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [Alias('hostname')]
    [string[]]$ComputerName
)
Invoke-command -ComputerName $ComputerName -Credential (Get-Credential) -ScriptBlock { Measure-VMReplication } | 
Select-Object -Property VMName, ReplicationHealth, State, LastREplicationTime | 
Sort-Object VMName