<#!
.SYNOPSIS
	Build a docker container for Dyanmics BC
.DESCRIPTION
	This script will load BcContainerHelper Module, and pull down and start the newest container of Business Central 
.NOTES
	File Name: Build.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>

##Variables
$CTName = "Sandbox"

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

#Get latest verions of Bc artifacts & mount container
$artifactUrl = Get-BcArtifactUrl -type sandbox -country us -select Latest
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword ` -updatHosts