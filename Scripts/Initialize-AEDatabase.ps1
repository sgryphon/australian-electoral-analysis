<#
	.Synopsis
		Sets up an empty database for analysis of Australian electoral data

	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'. 
		If the database already exists, and you do not pass the swith to delete it, 
		then the script will report an error.

	.Parameter DeleteExisting
		If set, the script will first delete any existing database (wiping the data).

	.Description
		Creates the specified database and then runs the 
		script 'ElectoralAnalysisSchema.sql' against it.

	.Example
		.\Initialize-AEDatabase.ps1 -Database "ElectoralAnalysisTest" -DeleteExisting

#>
[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
param
(
	[string] $ServerInstance = ".\SQLEXPRESS",
	[string] $Database = "ElectoralAnalysis",
	[switch] $DeleteExisting
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

$exists = Invoke-SqlCmd -ServerInstance $ServerInstance -Query "SELECT * FROM sys.databases WHERE name = '$Database';"
$dropped = $false
if ($exists) {
	if ($DeleteExisting) {
		if ( $PSCmdlet.ShouldProcess("Drop database '$Database'") ) {
			Write-Verbose "Drop database '$Database'"
			Invoke-SqlCmd -ServerInstance $ServerInstance -Query "DROP DATABASE [$Database];"
			$dropped = $true
		} else {
			exit
		}
	} else {
		Write-Error "Database '$Database' already exists. Use -DeleteExisting to overwrite."
		exit
	}
}
if ((-not $exists) -or $dropped) {
	Write-Verbose "Creating database '$Database'"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Query "CREATE DATABASE [$Database];"
}

$schemaFile = Join-Path $scriptRoot "ElectoralAnalysisSchema.sql"
Write-Verbose "Executing schema script '$schemaFile'"
Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -InputFile $schemaFile
