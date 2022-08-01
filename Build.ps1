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

Write-Output "Inistilizing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if(Get-PackageProvider -Name PowershellGet){
	Write-Output "PowershellGet installed"
}
else{
	Install-PackageProvider -Name NuGet -Force
	Install-PackageProvider -Name PowershellGet -Force
	Write-Output "Installing Package managment software"
}


if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Import-Module BcContainerHelper
} 
else {
    Install-Module -Name BcContainerHelper
}

$artifactUrl = Get-BcArtifactUrl -type sandbox -country us -select Latest
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword ` -updatHosts