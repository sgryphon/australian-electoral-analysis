Australian Electoral Analysis
=============================

Design
------

The database uses a star schema, common in data warehouse / reportingn applications.

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

Instructions
------------

* Download data, if needed, from the AEC website (http://aec.gov.au/)
 
* You will need:
  - SenateFirstPrefsByStateByVoteTypeDownload-20499.csv (contains all parties and candidates, in ticket order)
  -aec-senate-formalpreferences-20499-<STATE>.csv (contains Senate voting data for each state)  
 
* Create a database, e.g. 'ElectoralAnalysis' in SQL Server

* Edit the parameters and run: Initialize-AEDatabase.ps1
  - This will create a database 'ElectoralAnalysis'
  - Then will run ElectoralAnalysisSchema.sql to create the needed tables

* Edit the parameters and run: Import-AESenateTicket.ps1
  - This will load the raw ticket information
  
* Edit the parameters and run: Import-AESenateVotes.ps1
  - Run for each data file you want to import
  - This will load the raw ticket information

* In SQL Management Studio, run: ProcessImportedData.sql
  - Run one query at a time, to check for any issues
  - You may need to load additional party names; there is a commented out bit of SQL that will generate some basic code that you need to then fill in with the key & short name.
  - Warning: some of the queries may take 5=10 minutes+ to run.

  - The Raw and Staging tables have a 'Processed' flag. You can load multiple sets of data, and re-run the scripts, which will only process new items.
  - At the end of the processing, it sets to the Processed flag.
  
* Once data is loaded, there are some sample queries in AnalysisQueries.sql that can be used to extract out various tables of data.

  - The result, e.g. "Senate ATL preference distribution by first preference and party", can then be loaded into something like Excel, and further analysed in a pivot table by various dimensions, or graphed, etc.
  - Currently these only do high level analysis, e.g. of preference flows.
  - The data has enough detail to analyse down to individual vote collection point (polling place).
  
  