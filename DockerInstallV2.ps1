#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop';


<#
Initilize TLS1.2
#>
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

<#
Install Docker 
#>
if(-not(docker --version)){
Write-Output "Installing Docker Desktop"
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1
.\install-docker-ce.ps1
}
else{
    Write-Output "Docker Installed"
}

<#
Determine logged in user add to docker group - requires reboot to pick up new group memebership
#>
Write-Output "Adding user to Docker group"
$User = Get-WMIObject -class Win32_ComputerSystem | Select-Object username
Add-LocalGroupMember -Group Docker-users -Member $User -Confirm

<#
Test if Hyper-V is enabled. Enable if not ** requires a restart if enabling Hyper-V
#>
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online
if($hyperv.State -eq "Enabled"){
    Write-Output "Hyper-V enabled"
}
else{
    Write-Output "Enabling Hyper-V"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}