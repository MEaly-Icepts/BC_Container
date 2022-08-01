<#
Initilize TLS1.2
#>
Write-Output "Inistilizing TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

<#
Test if Choclatey is installed and if not install it. 
#>
$testchoco = powershell choco -v
if(-not($testchoco)){
    Write-Output "Seems Chocolatey is not installed, installing now"
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else{
    Write-Output "Chocolatey Version $testchoco is already installed"
}

<#
Test if Hyper-V is enabled. Enable if not
#>
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online
if($hyperv.State -eq "Enabled"){
    Write-Output "Hyper-V enabled"
}
else{
    Write-Output "Enabling Hyper-V"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}

<#
Install Docker desktop application using chocolaty & add user to the docker group
#>
Write-Output "Installing Docker Desktop"
choco install docker-desktop

<#
Determine logged in user add to docker group
#>
Write-Output "Adding user to Docker group"
$User = $env:UserName
Add-LocalGroupMember -Group Docker-users -Member $User -Confirm