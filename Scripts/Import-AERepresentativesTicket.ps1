<#
	.Synopsis
		Imports AEC candidate information for the House of Representatives.

#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[string] $Election = "2016 Federal",
	[string] $FilePath = "..\SampleData\HouseCandidatesDownload-20499.csv",
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
