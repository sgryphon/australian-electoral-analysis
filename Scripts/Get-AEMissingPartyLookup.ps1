<#
	.Synopsis
		Gets party name values from the ticket import tables that do not exist in PartyLookup
		
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Get-AEMissingPartyLookup.ps1 -Database "ElectoralAnalysisTest"

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

# $scriptRoot = "C:\Work\Australian Electoral Analysis\Scripts"

$query = "SELECT PartyName, 
		(SELECT TOP 1 PartyAb FROM RawRepresentativesCandidates WHERE PartyNm = PartyName) AS PartyKey, 
		'' AS PartyShort
	FROM (SELECT PartyName FROM RawSenateFirstPreferences
		UNION SELECT PartyNm AS PartyName FROM RawRepresentativesCandidates) p
	WHERE PartyName NOT IN (SELECT PartyName FROM PartyLookup);"
$result = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query

if (-not $result) {
    Write-Verbose "No missing party lookup records."
}
Write-Output $result
