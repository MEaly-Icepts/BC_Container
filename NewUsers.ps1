<#
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