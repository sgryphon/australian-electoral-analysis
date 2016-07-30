CREATE TABLE [SenateFormalPreferencesRaw] (
    Id int identity(1,1)
	,Election nvarchar(50)
	,StateAb nvarchar(3)
	,ElectorateNm nvarchar(100)
	,VoteCollectionPointNm nvarchar(200)
	,VoteCollectionPointId int
	,BatchNo int
	,PaperNo int
	,Preferences nvarchar(1000)
);

CREATE TABLE [TicketRaw] (
    Id int identity(1,1)
	,Election nvarchar(50)
	,StateAb nvarchar(3)
	,Ticket nvarchar(2)
	,CandidateID int
	,BallotPosition smallint
	,CandidateDetails nvarchar(200)
	,PartyName nvarchar(200)
	,OrdinaryVotes int
	,AbsentVotes int
	,ProvisionalVotes int
	,PrePollVotes int
	,PostalVotes int 
	,TotalVotes int
	,PreferencePosition smallint
);


CREATE TABLE [ElectionDimension] (
    ElectionId int identity(1,1)
	,Election nvarchar(50)
	,[Year] int
	,[Date] date
	,[Type] nvarchar(50)
)

CREATE TABLE [TicketDimension] (
    TicketId int identity(1,1)
	,Election nvarchar(50)
	,[State] nvarchar(3)
	,Ticket nvarchar(2)
	,CandidateID int
	,BallotPosition smallint
	,CandidateDetails nvarchar(200)
	,Party nvarchar(3) null
	,PartyName nvarchar(200)
	,OrdinaryVotes int
	,AbsentVotes int
	,ProvisionalVotes int
	,PrePollVotes int
	,PostalVotes int 
	,TotalVotes int
	,PreferencePosition smallint
);

CREATE TABLE [LocationDimension] (
    LocationId int identity(1,1)
	,[State] nvarchar(3)
	,Electorate nvarchar(100)
	,VoteCollectionPoint nvarchar(200)
);

CREATE TABLE [PreferenceDimension] (
    PreferenceId int identity(1,1)
	,Election nvarchar(50)
	,[State] nvarchar(3)
	,Preferences nvarchar(1000)
	,PreferenceList nvarchar(1000)
	,HowToVote nvarchar(3) null
);

CREATE TABLE [VoteFact] (
    ElectionId int,
	LocationId int,
	PreferenceId int,
	FirstPreferenceTicketId int,
	VoteCount int 
)

CREATE TABLE [PreferenceFact] (
    ElectionId int,
	PreferenceId int,
	PreferenceNumber smallint,
	TicketId int,
	[Count] int DEFAULT (1)
)
