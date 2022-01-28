<#
.SYNOPSIS
VMReplication retrieves the replication status of all virtual machines from the primary hosts
.DESCRIPTION
Retrieves virtual machine name, replication health, status, and last replication time
.PARAMETER computername
The computer name, or names, to query. Default: GJEMVSREP1, ETECVSREP1, EMNVVSREP1, SPRUVSREP1, WVDPVSREP1
.EXAMPLE
VMReplication -computername Server1
#>
[CmdletBinding()]
param(
[Parameter(Mandatory=$False)]
[Alias('hostname')]
[string[]]$computername = @('gjemvsrep1','etecvsrep1','emnvvsrep1','spruvsrep1','wvdpvsrep1')
)
Invoke-command -ComputerName $computername -ScriptBlock {Measure-VMReplication} | Select-Object -Property VMName, ReplicationHealth, State, LastREplicationTime | Sort-Object VMName
