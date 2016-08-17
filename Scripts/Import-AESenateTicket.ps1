<#
	.Synopsis
		Imports AEC candidate information for the Senate.

	.Parameter Election
		Name to identify the election, to allow data from multiple elections to be loaded.
		
	.Parameter FilePath
		Path to the data file. 
		The file name should be something like 'SenateFirstPrefsByStateByVoteTypeDownload-20499.csv'.
	
	.Parameter ServerInstance
		SQL Server to run the script on. Default is local SQLEXPRESS.

	.Parameter Database
		Name of the database to run the script against. Default is 'ElectoralAnalysis'.

	.Example
	    .\Import-AESenateTicket.ps1 -Election "2016 Federal" `
			-FilePath "..\SampleData\SenateFirstPrefsByStateByVoteTypeDownload-20499.csv"

	.Example
	    .\Import-AESenateTicket.ps1 -Election "2013 Federal" `
			-FilePath "..\SampleData\SenateFirstPrefsByStateByVoteTypeDownload-17496.csv"
		
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
	Write-Verbose "Importing ticket $($row.CandidateDetails) ($($row.PartyName))"
	$query = "INSERT INTO [RawSenateFirstPreferences] (
		Election 	
		,StateAb 
		,Ticket 
		,CandidateID 
		,BallotPosition 
		,CandidateDetails 	
		,PartyName 
		,OrdinaryVotes 
		,AbsentVotes 
		,ProvisionalVotes 
		,PrePollVotes 
		,PostalVotes  
		,TotalVotes 
		)
		VALUES (
		'$($Election -replace "'", "''")'
		,'$($row.StateAb)'
		,'$($row.Ticket)'
		,$($row.CandidateID)
		,$($row.BallotPosition)
		,'$($row.CandidateDetails -replace "'", "''")'
		,'$($row.PartyName -replace "'", "''")'
		,$($row.OrdinaryVotes)
		,$($row.AbsentVotes)
		,$($row.ProvisionalVotes)
		,$($row.PrePollVotes)
		,$($row.PostalVotes)
		,$($row.TotalVotes)
		);"
	Invoke-SqlCmd -ServerInstance $ServerInstance -Database $Database -Query $query
}
