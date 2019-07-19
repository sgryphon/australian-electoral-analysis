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

Instructions
------------

* Sample files for NT, from 2013 and 2016, are in the SampleData folder

* Download data from the AEC website (http://aec.gov.au/) and put in a Data folder
 
* You will need:
  - SenateFirstPrefsByStateByVoteTypeDownload-20499.csv (contains all parties and candidates, in ticket order)
  - aec-senate-formalpreferences-20499-[STATE].csv (contains Senate voting data for each state)

* Create a database, e.g. 'ElectoralAnalysis' in SQL Server

* The script ```Test-AESampleData.ps1``` will import the test data.

* It does the following steps:

```
$Database = "ElectoralAnalysisTest"

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
```

Note that the 2013 Senate data requires the script Import-AESenateVotesLegacy.ps1 to import.

The Invoke-AETransformData.ps1 script runs the ProcessImportedData.sql SQL procedure, to process any outstanding data; it can be run multiple times.


The scripts
-----------

* Initialize-AEDatabase.ps1
  - This will create a database 'ElectoralAnalysis'
  - Then will run ElectoralAnalysisSchema.sql to create the needed tables

* Import-AESenateTicket.ps1
  - This will load the raw ticket information
  
* Import-AESenateVotes.ps1
  - Run for each data file you want to import
  - This will load the raw ticket information

For a large data file, you may need to split into smaller input files for loading.

You can use the Git Bash tool 'split' for this, e.g.

```$ split aec-senate-formalpreferences-24310-QLD.csv split-senate-24310-QLD -l 1000000 -a 3 -d --additional-suffix=.csv```

You then need to copy the header row, with column names, to each file (so it can be loaded as csv)
  
* Invoke-AETransformData
  - Will run: ProcessImportedData.sql
  - Can also run one query at a time in SQL Management Studio, to check for any issues
  - You will need to load additional party names; there is a commented out bit of SQL that will generate some basic code that you need to then fill in with the key & short name.
  - Warning: some of the queries may take 5=10 minutes+ to run.

  - The Raw and Staging tables have a 'Processed' flag. You can load multiple sets of data, and re-run the scripts, which will only process new items.
  - At the end of the processing, it sets to the Processed flag.
  
* Once data is loaded, there are some sample queries in AnalysisQueries.sql that can be used to extract out various tables of data.

  - The result, e.g. "Senate ATL preference distribution by first preference and party", can then be loaded into something like Excel, and further analysed in a pivot table by various dimensions, or graphed, etc.
  - Currently these only do high level analysis, e.g. of preference flows.
  - The data has enough detail to analyse down to individual vote collection point (polling place).

Note: One of the sample analysis scripts does a pivot, but the support is limited
in SQL Server.

Generally I will just use the query to extract the data with the columns I want (for multiple tables), e.g. "Senate ATL preference distribution by first preference and party", and then put that into Excel. 

The pivot table support in Excel is much better, and you can then pivot on different ways to get various tables. Often I will cut and paste the resulting table into another tab, so that I can compare different slices, e.g. compare preference flows to total votes and calculate a percent (as you can't do both in one pivot).
  
  
To do / roadmap
---------------


