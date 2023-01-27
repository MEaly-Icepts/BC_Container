<#!
.SYNOPSIS
	Build a docker container for Dyanmics BC by downloading the newest release artifacts. 

.DESCRIPTION
	This script will load BcContainerHelper Module, and pull down and start the newest container of Business Central 

.FUNCTIONALITY
Script will download & load the BCContainerHelper module and use it to download the latest version of Dynamics BC container for use in Docker. 

.NOTES
	File Name: ContainerBuild.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0

.LINK
	https://github.com/MEaly58

#>
#$ErrorActionPreference = SilentlyContinue;

##Variables
$CTName = "Sandbox"

#Initializing TLS 1.2 to prevent any connection errors
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

<#Powershellget is not needed in this version of the script

#Check if PowershellGet is installed
Write-Host "Checking that PowershellGet is installed..."
$psGetModule = Get-InstalledModule PowershellGet | Sort-Object Version | Select-Object -last 1
if ($psGetModule)
{
  Write-Host "Updating PowershellGet..."
  Update-Module PowershellGet
  Write-Host "Getting PowershellGet module version..."
  $psGetModule = Get-InstalledModule PowershellGet | Sort-Object Version | Select-Object -last 1
}
else
{
  Write-Host "Installing PowershellGet..."
  Install-Module PowershellGet -Force
  Write-Host "Getting PowershellGet module version..."
  $psGetModule = Get-InstalledModule PowershellGet | Sort-Object Version | Select-Object -last 1
}
Write-Host "PowershellGet module version: $($psGetModule.Version)"

#>

#Check if BcContainerHelper module is installed & load it. Download & load if not yet installed. 
Write-Host "Checking that BcContainerHelper is installed..."
$psBCCHModule = Get-InstalledModule BcContainerHelper | Sort-Object Version | Select-Object -last 1
if ($psBCCHModule)
{
  Write-Host "Updating BcContainerHelper..."
  Update-Module BcContainerHelper
  Write-Host "Getting BcContainerHelper module version..."
  $psBCCHModule = Get-InstalledModule BcContainerHelper | Sort-Object Version | Select-Object -last 1
}
else
{
  Write-Host "Installing BcContainerHelper..."
  Install-Module BcContainerHelper -Force
  Write-Host "Getting BcContainerHelper module version..."
  $psBCCHModule = Get-InstalledModule BcContainerHelper | Sort-Object Version | Select-Object -last 1
}
Write-Host "BcContainerHelper module version: $($psBCCHModule.Version)"

#Get latest verions of BC artifacts & mount container
$artifactUrl = Get-BcArtifactUrl -type sandbox -country us -select Latest
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword  -updatHosts