<#
	.Synopsis
		Imports AEC House of Representatives first preference votes.

	.Parameter Election
		Name to identify the election, to allow data from multiple elections to be loaded.
	
	.Parameter State
		Which Australian State the data file is for, e.g. 'NT'.
		
	.Parameter FilePath
		Path to the data file. 
		The file name should be something like 'HouseStateFirstPrefsByPollingPlaceDownload-20499-NT.csv'.

	.Parameter Skip
		Skips a number of records at the beginning of the file. 
		Useful when a large import has crashed part way through, to restart at a specific point.
		(Check the database for the last record successfully loaded.)
		
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Import-AERepresentativesVotes.ps1 -Election "2016 Federal" -State "NT" `
			-FilePath "..\SampleData\HouseStateFirstPrefsByPollingPlaceDownload-20499-NT.csv"
		
	.Example
	    .\Import-AERepresentativesVotes.ps1 -Election "2013 Federal" -State "NT" `
			-FilePath "..\SampleData\HouseStateFirstPrefsByPollingPlaceDownload-17496-NT.csv"

#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[Parameter(Mandatory=$true)] [string] $Election,
	[Parameter(Mandatory=$true)] [string] $State,
	[Parameter(Mandatory=$true)] [string] $FilePath,
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

$existing = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawRepresentativesFirstPreferences] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
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
$batchSize = 100
Write-Verbose "Batch size: $batchSize"
$progressActivity = "Importing Reps $Election - $State"
Write-Progress -Activity $progressActivity -PercentComplete ($count * 100 / $total)
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
	,'$($row.PollingPlace -replace "'", "''")'
	,$($row.CandidateID) 
	,'$($row.Surname -replace "'", "''")'
	,'$($row.GivenNm -replace "'", "''")'
	,$($row.BallotPosition) 
	,'$($row.Elected)'
	,'$($row.HistoricElected)'
	,'$($row.PartyAb -replace "'", "''")'
	,'$($partyNm)'
	,$($row.OrdinaryVotes) 
	,$($row.Swing) 
"
	if (($count % $batchSize) -eq 0) {
		$query = "INSERT INTO [RawRepresentativesFirstPreferences] (
		Election 	
		,StateAb
		,DivisionID
		,DivisionNm
		,PollingPlaceID
		,PollingPlace
		,CandidateID
		,Surname
		,GivenNm
		,BallotPosition
		,Elected
		,HistoricElected
		,PartyAb
		,PartyNm
		,OrdinaryVotes
		,Swing
		) " + $batchDataSelect + ";"
		
#Write-Host ">> $query"
#$dummy = Read-Host		
		Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
		$batchDataSelect = ""
		Write-Progress -Activity $progressActivity -PercentComplete ($count * 100 / $total)
	}
}
if ($batchDataSelect) {
	$query = "INSERT INTO [RawRepresentativesFirstPreferences] (
	Election 	
	,StateAb
	,DivisionID
	,DivisionNm
	,PollingPlaceID
	,PollingPlace
	,CandidateID
	,Surname
	,GivenNm
	,BallotPosition
	,Elected
	,HistoricElected
	,PartyAb
	,PartyNm
	,OrdinaryVotes
	,Swing
	) " + $batchDataSelect + ";"

#Write-Host "*> $query"

	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
	$batchDataSelect = ""
	Write-Progress -Activity $progressActivity -PercentComplete ($count * 100 / $total)
}
Write-Progress -Activity $progressActivity -Completed

$result = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawRepresentativesFirstPreferences] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
Write-Verbose "Result total $($result.CountRecords) records"
Write-Verbose "Skipped header lines: $skippedHeader"
Write-Verbose "Skipped records: $skippedRecords"
	
$endTime = [datetimeoffset]::Now
Write-Verbose "Import $State finish $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))"
Write-Verbose "Import $State time taken: $( ($endTime - $startTime).ToString())"


