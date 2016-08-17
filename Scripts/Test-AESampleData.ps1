<#
	.Synopsis
		Runs through a full test of the scripts against the AEC sample data for NT.
		Data is loaded into the database 'ElectoralAnalysisTest'.

	.Example
	    .\Test-AESampleData.ps1
		
#>
[CmdletBinding(SupportsShouldProcess=$false)]
param
(
	[string] $Database = "ElectoralAnalysisTest"
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

Write-Host "`nRunning all scripts to load data for NT into '$Database'. This may take a while.`n"

.\Initialize-AEDatabase.ps1 -Database $Database -DeleteExisting -Confirm:$false

# NT 2016

.\Import-AESenateTicket.ps1 -Database $Database -Election "2016 Federal" -FilePath "..\SampleData\SenateFirstPrefsByStateByVoteTypeDownload-20499.csv"

.\Import-AESenateVotes.ps1 -Database $Database -Election "2016 Federal" -State "NT" -FilePath "..\SampleData\aec-senate-formalpreferences-20499-NT.csv"

.\Invoke-AETransformData.ps1 -Database $Database

.\Import-AERepresentativesTicket.ps1 -Database $Database -Election "2016 Federal" -FilePath "..\SampleData\HouseCandidatesDownload-20499.csv"

.\Import-AERepresentativesVotes.ps1 -Database $Database -Election "2016 Federal" -State "NT" -FilePath "..\SampleData\HouseStateFirstPrefsByPollingPlaceDownload-20499-NT.csv"

.\Invoke-AETransformData.ps1 -Database $Database

# NT 2013

.\Import-AESenateTicket.ps1 -Database $Database -Election "2013 Federal" -FilePath "..\SampleData\SenateFirstPrefsByStateByVoteTypeDownload-17496.csv"

.\Import-AESenateVotesLegacy.ps1 -Database $Database -Election "2013 Federal" -State "NT" -FilePath "..\SampleData\SenateStateFirstPrefsByPollingPlaceDownload-17496-NT.csv"

.\Import-AERepresentativesTicket.ps1 -Database $Database -Election "2013 Federal" -FilePath "..\SampleData\HouseCandidatesDownload-17496.csv"

.\Import-AERepresentativesVotes.ps1 -Database $Database -Election "2013 Federal" -State "NT" -FilePath "..\SampleData\HouseStateFirstPrefsByPollingPlaceDownload-17496-NT.csv"

.\Invoke-AETransformData.ps1 -Database $Database




