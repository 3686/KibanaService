﻿[CmdletBinding()]
param(
	[string] $environmentConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "deployment_configuration.json" ),
	[string] $productConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "configuration.xml" )
)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Import-Module $scriptPath\PowershellModules\CommonDeploy.psm1 -Force

$rootPath = Split-Path -parent $scriptPath

$e = $environmentConfiguration = Read-ConfigurationTokens $environmentConfigurationFilePath

# Setup the configuration
$updateConfiguration = Join-Path $scriptPath "UpdateConfiguration.ps1"
if(Test-Path $updateConfiguration) {
	&$updateConfiguration $environmentConfigurationFilePath $productConfigurationFilePath
}

Install-All `
	-rootPath $rootPath `
	-environmentConfigurationFilePath $environmentConfigurationFilePath `
	-productConfigurationFilePath $productConfigurationFilePath

# Run post install configuration
$updateConfigurationPostInstall = Join-Path $scriptPath "UpdateConfigurationPostInstall.ps1"
if(Test-Path $updateConfigurationPostInstall) {
    &$updateConfigurationPostInstall $environmentConfigurationFilePath $productConfigurationFilePath
}    