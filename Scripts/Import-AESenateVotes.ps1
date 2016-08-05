<#
	.Synopsis
		Sets up an empty database for analysis of Australian electoral data


#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[string] $Election = "2016 Federal",
	[string] $State = "NT",
	[string] $FilePath = "..\SampleData\aec-senate-formalpreferences-20499-NT.csv",
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
Write-Verbose "Importing $total votes from data file"

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
		Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
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
		Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
	}
}
if ($batchDataSelect) {
	Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
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
	Write-Progress -Activity "Importing $State" -PercentComplete ($count * 100 / $total)
}

$result = Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT COUNT(*) AS CountRecords FROM [RawSenateFormalPreferences] WHERE Election = '$escapedElection' AND StateAb = '$escapedState';"
Write-Verbose "Result total $($result.CountRecords) records"
Write-Verbsoe "Skipped header lines: $skippedHeader"
Write-Verbsoe "Skipped records: $skippedRecords"
	
$endTime = [datetimeoffset]::Now
Write-Verbose "Import $State finish $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))"
Write-Verbose "Import $State time taken: $( ($endTime - $startTime).ToString())"


