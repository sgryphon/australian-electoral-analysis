Australian Electoral Analysis
=============================

Design
------

The database uses a star schema, common in data warehouse / reporting applications.

This has a separate fact table, linked to multiple denormalised dimension tables. The denormalised structure is optimised for querying. 

(This is a very different design that a normalised relational database that is used for operational processing.)

Future work can be done to build an analysis cube (SQL Analysis Services) on top of the star schema.

Note: Vote data includes both the raw number of votes, as well as converting to basis points at the state, division, and vote collection point level.

A basis point is 1/100th of a percent, i.e. 100 BPS = 1%.

This allows better comparison across states and different locations, e.g. getting 500 BPS (5%) of a vote collection point can be compared to get 4% in one state and 6% in another state (rather than comparing the raw number of votes).

Requirements / setup
--------------------

* SQL Server Management Tools
* SQL Server Express, or access to other version of SQL Server
* Scripts use a combination of PowerShell and SQL

Note that with SQL Server Express there is a maximum database size of 10 GB,
so some of the larger states may need to be loaded into a separate database.

Getting Started
---------------

* Sample files for NT, from 2013, 2016, and 2019 are in the SampleData folder

* The script ```Test-AESampleData.ps1``` will import the test data.

It does the following steps:

Set the database to use, create the database (script ```ElectoralAnalysisSchema.sql```), and add the party name lookup data (from '''PartyLookup.csv''').

```
$Database = "ElectoralAnalysisTest"
.\Initialize-AEDatabase.ps1 -Database $Database -DeleteExisting -Confirm:$false
.\Update-AEPartyLookup.ps1 -Database $Database -FilePath ".\PartyLookup.csv"
```

Import the House of Representatives ticket data, and vote data, to the raw data tables.

```
.\Import-AERepresentativesTicket.ps1 -Database $Database -Election "2013 Federal" -FilePath "..\SampleData\2013\HouseCandidatesDownload-17496.csv"
.\Import-AERepresentativesVotes.ps1 -Database $Database -Election "2013 Federal" -State "NT" -FilePath "..\SampleData\2013\HouseStateFirstPrefsByPollingPlaceDownload-17496-NT.csv"
```

Process the raw data, using ```ProcessImportedData.sql```, which copies them into staging tables, then calculates the needed values in a series of steps (e.g. lookup the location, then the candidate, etc).

Once the staging data is built, it is copied into a star schema / data warehouse format with Dimension and Fact tables.

This step can be rerun for each block of data, and marks raw data as processed when complete.

It also sets a few other values, such as known election details (date and type).

```
.\Invoke-AETransformData.ps1 -Database $Database
```

A similar process is followed for the Senate data, loading the raw data, then the processing script that builds the staging tables and copies to the data warehouse tables.

```
.\Import-AESenateTicket.ps1 -Database $Database -Election "2013 Federal" -FilePath "..\SampleData\2013\SenateFirstPrefsByStateByVoteTypeDownload-17496.csv"
.\Import-AESenateVotes2013.ps1 -Database $Database -Election "2013 Federal" -State "NT" -FilePath "..\SampleData\2013\SenateStateFirstPrefsByPollingPlaceDownload-17496-NT.csv"
.\Invoke-AETransformData.ps1 -Database $Database
```

Similar steps are done for 2016, and then 2019, with the data mostly the same format. The main difference is the Senate vote data, which has different formats each year, and uses a different script.

Note that the ticket data is for the entire election, not just a single state, so doesn't need importing again.

There is also a script that, once the tickets are loaded, will check if there are any party names missing from the party lookup table.

```
.\Get-AEMissingPartyLookup -Database $Database
```

For 2013-2019 this should return no missing data, but is useful for future elections.

* Once data is loaded, there are some sample queries in AnalysisQueries.sql that can be used to extract out various tables of data.

  - The result, e.g. "Senate ATL preference distribution by first preference and party", can then be loaded into something like Excel, and further analysed in a pivot table by various dimensions, or graphed, etc.
  - Currently these only do high level analysis, e.g. of preference flows.
  - The data has enough detail to analyse down to individual vote collection point (polling place).

Note: One of the sample analysis scripts does a pivot, but the support is limited in SQL Server.

Generally I will just use the query to extract the data with the columns I want (for multiple tables), e.g. "Senate ATL preference distribution by first preference and party", and then put that into Excel. 

The pivot table support in Excel is much better, and you can then pivot on different ways to get various tables. Often I will cut and paste the resulting table into another tab, so that I can compare different slices, e.g. compare preference flows to total votes and calculate a percent (as you can't do both in one pivot).
  

Running for different states
----------------------------

* Download data from the AEC website (http://aec.gov.au/) and put in a Data folder

* The sample data already includes the full ticket list, so load them first (if you haven't already): 
	- House of Reps ticket: HouseCandidatesDownload-24310.csv
	- Senate ticket: SenateFirstPrefsByStateByVoteTypeDownload-24310.csv

* You will then need the state vote data:
	- House of Reps votes: HouseStateFirstPrefsByPollingPlaceDownload-24310-[STATE].csv
	- Senate votes: aec-senate-formalpreferences-20499-[STATE].csv

* The Senate votes download is a ZIP file, that needs to be expanded.
	
  - SenateFirstPrefsByStateByVoteTypeDownload-20499.csv (contains all parties and candidates, in ticket order)
  - aec-senate-formalpreferences-20499-[STATE].csv (contains Senate voting data for each state)

* The Senate data file is quite large, and for most states it will need to be split into files for processing.

You can use the Git Bash tool 'head' to get the first line, then 'split' to split the file up, e.g.

```
head -1 aec-senate-formalpreferences-24310-QLD.csv > first-senate-24310-QLD.csv
split aec-senate-formalpreferences-24310-QLD.csv split-senate-24310-QLD -l 200000 -a 3 -d --additional-suffix=.csv
```

You then need to combine the header with each file (except the first), so it can be loaded as a CSV.

```
cat first-senate-24310-QLD.csv split-senate-24310-QLD001.csv > data-senate-24301-QLD001.csv
cat first-senate-24310-QLD.csv split-senate-24310-QLD0012csv > data-senate-24301-QLD002.csv
...
```

* Use ```Import-AESenateVotesYYYY``` to import all of the data files before running ```Invoke-AETransformData```, as the processing sums up the total number of each type of vote.

* Warning, some of the scripts for the larger states will take a long time to run, 10's of minutes, or even longer.

* If the ```Invoke-AETransformData``` script times out, then you can load the script in SQL Analyser and run it manually. Generally you can clear out the Staging tables if you need to restart. Rows marked Processed (Raw and Staging) are ignored.
    
To do / roadmap
---------------


