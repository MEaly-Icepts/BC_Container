#Requires -RunAsAdministrator

<#
Install Docker 
#>

Write-Output "Installing Docker Desktop"
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1
.\install-docker-ce.ps1

<#
Write-Output "Adding user to Docker group"
$User = Get-WMIObject -class Win32_ComputerSystem | Select-Object username
Add-LocalGroupMember -Group Docker-users -Member $User -Confirm

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online
if($hyperv.State -eq "Enabled"){
    Write-Output "Hyper-V enabled"
}
else{
    Write-Output "Enabling Hyper-V"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}

Commented out as it is part of the MS script being called earlier. 
#>