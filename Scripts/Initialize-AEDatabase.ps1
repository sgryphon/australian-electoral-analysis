<#
	.Synopsis
		Sets up an empty database for analysis of Australian electoral data

	.Parameter ConnectionString
		Default is local SQLEXPRESS

	.Example
	    .\Apply-ExpressCertificate.ps1 -Subject "localhost" -Issuer "Dev Issuer" `

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

if (-not (Invoke-SqlCmd -ServerInstance $ServerInstance -Query "SELECT * FROM sys.databases WHERE name = '$Database';")) {
	Write-Verbose "Creating database"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Query "CREATE DATABASE [$Database];"
}

$schemaFile = Join-Path $scriptRoot "ElectoralAnalysisSchema.sql"
Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -InputFile $schemaFile

