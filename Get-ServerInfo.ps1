$serversOUpath = @('OU=EMCBC Servers,DC=emcbc,DC=doe,DC=gov', 'OU=Domain Controllers,DC=emcbc,DC=doe,DC=gov')
$servers = $serversOUpath | foreach {Get-ADcomputer -Searchbase $_ -Filter * | Select-Object -ExpandProperty name}
foreach ($server in $servers) {
    $output = @{
        'ServerName'                = $null
        'Model'                     = $null
		'Manufacturer'				= $null
        'OperatingSystem'           = $null
		'Number of CPUs'			= $null
    }
    $getCinInstParams = @{
        Cimsession = New-CimSession -ComputerName $server
    }
    $output.ServerName = $server
    $output.'OperatingSystem' = (Get-CimInstance @getCinInstParams -ClassName Win32_OperatingSystem).Caption
    $output.'Model' = (Get-CimInstance @getCinInstParams -ClassName Win32_computersystem).Model
	$output.'Manufacturer' = (Get-CimInstance @getCinInstParams -ClassName Win32_computersystem).Manufacturer
	$output.'Number of CPUs' = (Get-CimInstance @getCinInstParams -ClassName Win32_processor).name.length
    [PSCustomObject]$output
}