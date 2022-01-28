function New-CBCUser {
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    param (
        # Employees first name
        [Parameter(Mandatory)]
        [string]$FirstName,

        # Employees middle initial
        [Parameter(Mandatory)]
        [string]$MiddleName,

        # Employees last name
        [Parameter(Mandatory)]
        [string]$LastName
    )

    try {
        #First attempt to create a new user with firstname.lastname
        $Username = $FirstName + '.' + $LastName.ToLower()
        
        #Using a if/else loop to check if username is taken
        if (Get-AdUser -Filter "samAccountName -eq '$userName'") {
            Write-Warning -Message "The username [$($userName)] already exists. Trying another..."
        
            # If so, test if firstname/middle initial.lastname is available
            $Username = $FirstName + '.' + $MiddleName + '.' + $LastName.ToLower()
            if (Get-AdUser -Filter "samAccountName -eq '$userName'") {
                throw "No acceptable username is available"    
            }
            else {
                Write-Verbose -Message "The username [$($userName)] is available."
            }
        }
        else {
            Write-Verbose -Message "The username [$($userName)] is available." 
        }
        
        # Create a random password
        Add-Type -AssemblyName 'System.Web'
        $password = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 32), 5)
        $secPw = ConvertTo-SecureString -String $password -AsPlainText -Force
        
    }
    catch {
        Write-Error -Message $_.Exception.Message    
    }#try/catch
}#function
