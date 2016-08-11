<#
	.Synopsis
		Imports AEC 2013 'SenateStateFirstPrefsByPollingPlaceDownload-17496-QLD' data.


#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[string] $Election = "2013 Federal",
	[string] $State = "NT",
	[string] $FilePath = "..\SampleData\SenateStateFirstPrefsByPollingPlaceDownload-17496-NT.csv",
	[string] $ServerInstance = ".\SQLEXPRESS",
	[string] $Database = "ElectoralAnalysis",
	[int] $Skip = 0
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

$startTime = [datetimeoffset]::Now
Write-Verbose "Import $State start $($startTime.ToString("yyyy-MM-dd HH:mm:ss"))"
# $scriptRoot = "C:\Work\Australian Electoral Analysis\Scripts"

Write-Verbose "Importing: $Election - $State"

$dataFile = Join-Path $scriptRoot $FilePath
Write-Verbose "Importing from: $dataFile"

$escapedElection = $Election -replace "'", "''"
$escapedState = $State -replace "'", "''"

$existing = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawSenateFirstPreferencesLegacy] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
$startRecords = $existing.CountRecords 
Write-Verbose "Existing database has $($startRecords) records for election/state"

$data = Get-Content $dataFile | Select -Skip 1 | ConvertFrom-Csv
$total = $data.Count
Write-Verbose "Importing $total rows from data file"

$skipFlag = $false
if ($Skip) {
	Write-Verbose "Skipping $Skip records"
	$skipFlag = $true
}

$count = 0
$skippedHeader = 0
$skippedRecords = 0
$batchDataSelect = ""
$batchSize = 1000
Write-Verbose "Batch size: $batchSize"
Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
foreach ($row in $data) {
    $count++;
	if ($count -le 1) { 
		$skippedHeader++;
		continue; 
	}
	
	if ($count -le ($Skip + 1)) {
		$skippedRecords++;
		continue;
	}
	
	# Funny last line character "SUB"
	if ( ($row.StateAb.Length -eq 1) -and ([int]($row.StateAb[0]) -eq 0x1A) ) {
		continue;
	}
	
	if ($skipFlag) {
		Write-Verbose "Skipped $skippedRecords records, starting processing"
		$skipFlag = $false
	}
	
	if ($batchDataSelect) { 
		$batchDataSelect += " UNION ALL "
	}

	$partyNm = $row.PartyNm  -replace "'", "''"
	# Remove NULL (#0)
	if ( ($partyNm.Length -eq 1) -and ([int]($partyNm[0]) -eq 0) ) {
		$partyNm = ""
	}
	
	$batchDataSelect += "SELECT
	'$($escapedElection)'
	,'$($row.StateAb -replace "'", "''")' 
	,$($row.DivisionID) 
	,'$($row.DivisionNm -replace "'", "''")'
	,$($row.PollingPlaceID) 
	,'$($row.PollingPlaceNm -replace "'", "''")'
	,'$($row.Ticket -replace "'", "''")'
	,$($row.CandidateID) 
	,$($row.BallotPosition) 
	,'$($row.CandidateDetails -replace "'", "''")'
	,'$($partyNm)'
	,$($row.OrdinaryVotes) 
"
	if (($count % $batchSize) -eq 0) {
		Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
		$query = "INSERT INTO [RawSenateFirstPreferencesLegacy] (
		Election 	
		,StateAb 
		,DivisionID
		,DivisionNm
		,PollingPlaceID
		,PollingPlaceNm
		,Ticket
		,CandidateID
		,BallotPosition
		,CandidateDetails
		,PartyNm
		,OrdinaryVotes
		) " + $batchDataSelect + ";"
		
#Write-Host ">> $query"
#$dummy = Read-Host		
		Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
		$batchDataSelect = ""
		Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
	}
}
if ($batchDataSelect) {
	Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
	$query = "INSERT INTO [RawSenateFirstPreferencesLegacy] (
	Election 	
	,StateAb 
	,DivisionID
	,DivisionNm
	,PollingPlaceID
	,PollingPlaceNm
	,Ticket
	,CandidateID
	,BallotPosition
	,CandidateDetails
	,PartyNm
	,OrdinaryVotes
	) " + $batchDataSelect + ";"

#Write-Host "*> $query"

	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
	$batchDataSelect = ""
	Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
}

$result = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawSenateFirstPreferencesLegacy] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
Write-Verbose "Result total $($result.CountRecords) records"
Write-Verbose "Skipped header lines: $skippedHeader"
Write-Verbose "Skipped records: $skippedRecords"
	
$endTime = [datetimeoffset]::Now
Write-Verbose "Import $State finish $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))"
Write-Verbose "Import $State time taken: $( ($endTime - $startTime).ToString())"


