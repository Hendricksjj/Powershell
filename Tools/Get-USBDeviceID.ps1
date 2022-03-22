<#
.DESCRIPTION
    Use WMI to get the DeviceID of the USB mass storage device plugged into the PC
.EXAMPLE
    PS C:\> Get-USBDeviceID
    Prints the DeviceID of the mass storage device to the console
.EXAMPLE
    PS C:\> Get-USBDeviceID | Set-Clipboard
    Sets the DeviceID of the mass storage device to the clipboard
#>

$devID = (Get-WmiObject Win32_USBControllerDevice | ForEach-Object {[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')}).DeviceID
@($devID | ForEach-Object {$_.Split('\')[2]})