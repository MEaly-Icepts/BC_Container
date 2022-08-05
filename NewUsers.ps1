<#!
.SYNOPSIS
	Add users to Dynamics BC container.
.DESCRIPTION
	This script will import new users into Dynamics BC container
.NOTES
	File Name: NewUsers.ps1
	Author: Mathew Ealy
	Requires Powershell 5.0
.LINK
	https://github.com/MEaly58
#>

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

#Variables
$users = Import-CSV -path "C:\Folder\User.csv"
$Container = "ContainerName"

#Actions
foreach ($user in $users)
{
   $credential = $user.'Credential'
   $PermissionSet = $User.'PermissionSet'
  
New-BcContainerBcUser -containerName $Container -Credential $credential -assignPremiumPlan -PermissonsetId $PermissionSet
}