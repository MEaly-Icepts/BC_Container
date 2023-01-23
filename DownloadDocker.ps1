<#!
.SYNOPSIS
	This script will download the Docker desktop application. 

.DESCRIPTION
	This script will download the Docker desktop application. 

.FUNCTIONALITY
Script will download Docker desktop application. 

.NOTES
	File Name: DockerDownload.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0

.LINK
	https://github.com/MEaly58

#>
#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force

#Initializing TLS 1.2 to prevent any connection errors
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

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


#Variables
$URL = https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
$OutPath = "C:\temp\docker.exe"
#Arguments being used are a quite install. auto acceot license, & configure backend to use Hyper-V
$Arg = @("quiet","accept-license","backend=hyper-v")

#Download the installer
Invoke-WebRequest -Uri $url -OutFile $outpath

#Install Docker
Start-Process $OutPath install -ArgumentList $Arg

<#
Determine logged in user add to docker group - requires reboot to pick up new group memebership
#>
Write-Output "Adding user to Docker group"
$User = Get-WMIObject -class Win32_ComputerSystem | Select-Object username
Add-LocalGroupMember -Group Docker-users -Member $User

<#
Reboot computer to finish install and allow switching the deamon to a windows container deamon
#>
$seconds_to_wait=900
$pop = New-Object -ComObject WScript.Shell
$pop.Popup('To finish install of Docker your system needs to reboot',$seconds_to_wait,'Reboot Now?',4)
