<#!
.SYNOPSIS
	Build a docker container for Dyanmics BC by downloading the preview artifacts. 
.DESCRIPTION
	This script will load BcContainerHelper Module, and pull down and start the preview container of Business Central 
.NOTES
	File Name: PreviewBuild.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>


##Variables
$CTName = "Preview"

#Initializing TLS 1.2 to prevent any connection errors
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

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

#Download Container
$CTName = "Preview"
#Get latest verions of BC artifacts & mount container
$artifactUrl = Get-BcArtifactUrl -storageAccount BcPublicPreview -country US
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword