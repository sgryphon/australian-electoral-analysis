<#
	.Synopsis
		Imports AEC full preference data (2016 on) for the Senate.


	.Description
		The Senate voting system changed at the Australian 2016 Federal election.
		This script supports the new Senate data format, used from 2016 onwards.
		
	.Parameter Election
		Name to identify the election, to allow data from multiple elections to be loaded.
	
	.Parameter State
		Which Australian State the data file is for, e.g. 'NT'.
		
	.Parameter FilePath
		Path to the data file. 
		The file name should be something like 'aec-senate-formalpreferences-20499-NT.csv'.
	
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Import-AESenateVotes.ps1 -Election "2016 Federal" -State "NT" `
			-FilePath "..\SampleData\aec-senate-formalpreferences-20499-NT.csv"
		
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

<#
$query = "BULK INSERT [RawSenateFormalPreferences] FROM '$dataFile' WITH ( FIELDTERMINATOR = ',', FIRSTROW = 3 );"
Write-Host $query
Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
#>

$escapedElection = $Election -replace "'", "''"
$escapedState = $State -replace "'", "''"

$existing = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawSenateFormalPreferences] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
$startRecords = $existing.CountRecords 
Write-Verbose "Existing database has $($startRecords) records for election/state"

$data = Import-Csv $dataFile
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
$progressActivity = "Importing Senate $Election - $State"
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
	
	if ($skipFlag) {
		Write-Verbose "Skipped $skippedRecords records, starting processing"
		$skipFlag = $false
	}
	
	if ($batchDataSelect) { 
		$batchDataSelect += " UNION ALL "
	}
	$batchDataSelect += "SELECT
	'$($escapedElection)'
	,'$($escapedState)'
	,'$($row.ElectorateNm -replace "'", "''")'
	,'$($row.VoteCollectionPointNm -replace "'", "''")'
	,$($row.VoteCollectionPointId) 
	,$($row.BatchNo) 
	,$($row.PaperNo) 
	,'$($row.Preferences -replace "'", "''")'
"
	
	if (($count % $batchSize) -eq 0) {
		$query = "INSERT INTO [RawSenateFormalPreferences] (
		Election 	
		,StateAb 
		,ElectorateNm 
		,VoteCollectionPointNm 
		,VoteCollectionPointId 
		,BatchNo 
		,PaperNo 
		,Preferences
		) " + $batchDataSelect + ";"
		Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
		$batchDataSelect = ""
		Write-Progress -Activity $progressActivity -PercentComplete ($count * 100 / $total)
	}
}
if ($batchDataSelect) {
	$query = "INSERT INTO [RawSenateFormalPreferences] (
	Election 	
	,StateAb 
	,ElectorateNm 
	,VoteCollectionPointNm 
	,VoteCollectionPointId 
	,BatchNo 
	,PaperNo 
	,Preferences
	) " + $batchDataSelect + ";"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
	$batchDataSelect = ""
	Write-Progress -Activity $progressActivity -PercentComplete ($count * 100 / $total)
}
Write-Progress -Activity $progressActivity -Completed

$result = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawSenateFormalPreferences] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
Write-Verbose "Result total $($result.CountRecords) records"
Write-Verbose "Skipped header lines: $skippedHeader"
Write-Verbose "Skipped records: $skippedRecords"
	
$endTime = [datetimeoffset]::Now
Write-Verbose "Import $State finish $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))"
Write-Verbose "Import $State time taken: $( ($endTime - $startTime).ToString())"


