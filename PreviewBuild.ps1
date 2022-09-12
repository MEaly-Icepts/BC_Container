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
# $ErrorActionPreference = 'Stop';

##Variables
$CTName = "Preview"

#Initializing TLS 1.2 to prevent any connection errors
Write-Output "Initializing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

#Check if PowershellGet/NuGet is installed
if(Get-PackageProvider -Name PowershellGet){
	Write-Output "PowershellGet installed"
}
else{
	Install-PackageProvider -Name NuGet -Force
	Install-PackageProvider -Name PowershellGet -Force
	Write-Output "Installing package management software"
}

#Check if BcContainerHelper module is installed & load it. Download & load if not yet installed. 
if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Write-Output "Loading BcContainerHelper"
    Import-Module BcContainerHelper
} 
else {
    Write-Output "BcContainerHelper Missing, intalling now"
    Install-Module -Name BcContainerHelper
    Import-Module BcContainerHelper
}


$CTName = "Preview"
#Get latest verions of BC artifacts & mount container
$artifactUrl = Get-BcArtifactUrl -storageAccount BcPublicPreview -country US
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword