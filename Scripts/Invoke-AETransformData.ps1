<#
	.Synopsis
		Transforms imported Australian electoral data from the raw structure into the reporting star schema.

	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Description
		Runs the script 'ProcessImportedData.sql' against the specified database.
		
		This script currently has party and election information for the '2013 Federal' 
		and '2016 Federal' elections. It may need updating for other elections.

	.Example
	    .\Invoke-AETransformData.ps1 -Database "ElectoralAnalysisTest" `
#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[string] $ServerInstance = ".\SQLEXPRESS",
	[string] $Database = "ElectoralAnalysis"
)
Set-StrictMode -Version Latest
$scriptRoot = $MyInvocation.MyCommand.Path | Split-Path
if ($PSCmdlet.MyInvocation.BoundParameters["ErrorAction"] -eq $null) {
  $ErrorActionPreference = 'Stop' # use default Stop, instead of Continue
}
if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"] -eq $null) {
  $VerbosePreference = 'Continue' # use default Continue, instead of SilentlyContinue
}
$commonParameters = @{
	"Verbose" = ($PSCmdlet.MyInvocation.BoundParameters["Verbose"] -eq $true);
	"Debug" = ($PSCmdlet.MyInvocation.BoundParameters["Debug"] -eq $true)
}

if (-not (Get-Command Invoke-SqlCmd -ErrorAction Ignore)) {
	throw "Cannot access SQL Server Management Tools (Invoke-SqlCmd), needed to run scripts"
}

$schemaFile = Join-Path $scriptRoot "ProcessImportedData.sql"
Write-Verbose "Executing transform script '$schemaFile'"
Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -InputFile $schemaFile

