<#
	.Synopsis
		Imports AEC candidate information for the House of Representatives.

	.Parameter Election
		Name to identify the election, to allow data from multiple elections to be loaded.
		
	.Parameter FilePath
		Path to the data file. 
		The file name should be something like 'HouseCandidatesDownload-20499.csv'.
	
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Import-AERepresentativesTicket.ps1 -Election "2016 Federal" `
			-FilePath "..\SampleData\HouseCandidatesDownload-20499.csv"

	.Example
	    .\Import-AERepresentativesTicket.ps1 -Election "2013 Federal" `
			-FilePath "..\SampleData\HouseCandidatesDownload-17496.csv"

#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[Parameter(Mandatory=$true)] [string] $Election,
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

<#
$query = "BULK INSERT [RawSenateFirstPreferences] FROM '$dataFile' WITH ( FIELDTERMINATOR = ',', FIRSTROW = 3 );"
Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
#>

$data = Get-Content $dataFile | Select -Skip 1 | ConvertFrom-Csv

foreach ($row in $data) {
	Write-Verbose "Importing ticket $($row.Surname), $($row.GivenNm) ($($row.PartyNm))"
	$query = "INSERT INTO [RawRepresentativesCandidates] (
		Election 	
		,StateAb 
		,[DivisionID] 
		,[DivisionNm]
		,[PartyAb] 
		,[PartyNm] 	
		,[CandidateID] 
		,[Surname] 
		,[GivenNm] 
		,[Elected] 
		,[HistoricElected] 
		)
		VALUES (
		'$($Election -replace "'", "''")'
		,'$($row.StateAb)'
		,$($row.DivisionID)
		,'$($row.DivisionNm -replace "'", "''")'
		,'$($row.PartyAb -replace "'", "''")'
		,'$($row.PartyNm -replace "'", "''")'
		,$($row.CandidateID)
		,'$($row.Surname -replace "'", "''")'
		,'$($row.GivenNm -replace "'", "''")'
		,'$($row.Elected)'
		,'$($row.HistoricElected)'
		);"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
}
