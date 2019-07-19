<#
	.Synopsis
		Updates the PartyLookup table with any new values
		
	.Parameter FilePath
		Path to the data file, usually "PartyLookup.csv". 
	
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Update-AEPartyLookup.ps1 -FilePath "..\PartyLookup.csv"

#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[Parameter(Mandatory=$true)] [string] $FilePath,
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

# $scriptRoot = "C:\Work\Australian Electoral Analysis\Scripts"

$dataFile = Join-Path $scriptRoot $FilePath
$data = Get-Content $dataFile | ConvertFrom-Csv
$inserted = 0

# Empty value, for independents
$existing = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountParty FROM [PartyLookup] WHERE PartyName = '';"
if ($existing.CountParty -eq 0) {
	Write-Verbose "Importing empty party, for independents"
	$query = "INSERT INTO [PartyLookup] (
		PartyName 	
		,PartyKey
		,PartyShort
		)
		VALUES (
		''
		,'N/A'
		,'None'
		);"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
	$inserted ++
}

foreach ($row in $data) {
    $escapedPartyName = $row.PartyName -replace "'", "''"
	$existing = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountParty FROM [PartyLookup] WHERE PartyName = '$escapedPartyName';"
	if ($existing.CountParty -eq 0) {
		Write-Verbose "Importing party '$escapedPartyName', '$($row.PartyKey)', '$($row.PartyShort)'"
		$query = "INSERT INTO [PartyLookup] (
			PartyName 	
			,PartyKey
			,PartyShort
			)
			VALUES (
			'$escapedPartyName'
			,'$($row.PartyKey -replace "'", "''")'
			,'$($row.PartyShort -replace "'", "''")'
			);"
		Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
		$inserted ++
	}
}
if ($inserted -eq 0) {
    Write-Warning "No new party lookup records to insert."
} else {
	Write-Verbose "Inserted $inserted party lookup records."
}
