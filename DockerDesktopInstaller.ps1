<#!
.SYNOPSIS
	Install & Configure Dockerdesktop client for MS windows systems
.DESCRIPTION
	install the latest version of Dockerdesktop, configure hyper-v, and add user to the Docker user group. 
.NOTES
	File Name: DockerDesktopinstaller.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>
#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force

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
$service = Get-Service -Name docker -ErrorAction SilentlyContinue
if($service.Length -gt 0){
    Write-Output "Docker installed"
}
else{
    Write-Output "Installing Docker Desktop"
    choco install docker-desktop -y -SwitchDaemon
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