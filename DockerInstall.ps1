#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop';


<#
Initilize TLS1.2
#>
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

<#
Test if Choclatey is installed and if not install it. 
#>
$testchoco = powershell choco -v
if(-not($testchoco)){
    Write-Output "Seems Chocolatey is not installed, installing now"
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else{
    Write-Output "Chocolatey Version $testchoco is already installed"
}

<#
Install Docker desktop application using chocolaty
#>
if(-not(docker --version)){
Write-Output "Installing Docker Desktop"
choco install docker-desktop -y
}
else{
    Write-Output "Docker installed"
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