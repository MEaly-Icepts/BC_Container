<#!
.SYNOPSIS
	Load extensions for BC containers
.DESCRIPTION
	This script will load extensions into container(s) of Dynamics BC
.NOTES
	File Name: Extension.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>

#Variables
$ContainerName = "Sandbox"
$TenantName="Default"
$ExtVersion="Version No"
$ExtName="Extension Name"
$ExtensionPath= C:\Path + $ExtName + "_" + $ExtVersion + "_Runtime.app"

#Actions (Need to find a better way to do this later)
$PublishExt=1
$InstallExt=1
#SyncExt must be a 1 to fire the SyncExtClean command. 
$SyncExt=1
$SyncExtClean=1


#Check if BcContainerHelper module is installed
if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Write-Output "Loading BcContainerHelper"
    Import-Module BcContainerHelper
} 
else {
    Write-Output "BcContainerHelper Missing, intalling now"
    Install-Module -Name BcContainerHelper
    Import-Module BcContainerHelper
}

#Publish Extension
if ($PublishExt -eq 1) {
	Publish-BcContainerApp -containerName $ContainerName -appFile $ExtensionPath -skipVerification -scope Tenant
}

#Sync Application
if ($SyncExt -eq 1) {
	if ($SyncExtClean -eq 1) {
    	Sync-BcContainerApp -containerName $ContainerName -appName $ExtName -appVersion $Version -mode Clean
  	} else {
    	Sync-BcContainerApp -containerName $ContainerName -appName $ExtName -appVersion $Version
  	}
}

#Install Extension
if ($InstallExt -eq 1) {
	Install-BcContainerApp -containerName $ContainerName -appName $ExtName -tenant $TenantName
  }