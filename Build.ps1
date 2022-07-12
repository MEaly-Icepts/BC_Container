<#!
.SYNOPSIS
	Build a docker container for Dyanmics BC
.DESCRIPTION
	This script will pull down a container of Business Central 
.NOTES
	File Name: Build.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>

##Variables
$CTName = "Sandbox"

if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Import-Module BcContainerHelper
} 
else {
    Get-Module BcContainerHelper
}

$artifactUrl = Get-BcArtifactUrl -type sandbox -country us -select Latest
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword ` -updatHosts