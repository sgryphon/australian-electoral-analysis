/*
DROP TABLE [dbo].[NumberingStaging];
DROP TABLE [dbo].[VoteStaging];

DROP TABLE [dbo].[NumberingFact];
DROP TABLE [dbo].[VoteFact];

DROP TABLE [dbo].[LocationDimension];
DROP TABLE [dbo].[PreferenceDimension];
DROP TABLE [dbo].[TicketDimension];

DROP TABLE [dbo].[ElectionDimension];
*/
/*
DROP TABLE [dbo].[PartyLookup]
*/

/*
TODO:
 House, Electorate should be in ElectionDimension (remove from TicketFact, NumberingFact)

 Add TicketFact table to record relationship between TicketId & ElectionId
 Add NumberingFact table to record relationship between PreferenceId & ElectionId

*/

CREATE TABLE [dbo].[RawSenateFirstPreferences] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_RawSenateFirstPreferences] PRIMARY KEY CLUSTERED ([Id]),
	[Election] [nvarchar](50) NULL,
	[StateAb] [nvarchar](3) NULL,
	[Ticket] [nvarchar](2) NULL,
	[CandidateID] [int] NULL,
	[BallotPosition] [smallint] NULL,
	[CandidateDetails] [nvarchar](200) NULL,
	[PartyName] [nvarchar](200) NULL,
	[OrdinaryVotes] [int] NULL,
	[AbsentVotes] [int] NULL,
	[ProvisionalVotes] [int] NULL,
	[PrePollVotes] [int] NULL,
	[PostalVotes] [int] NULL,
	[TotalVotes] [int] NULL,
	[Processed] [bit] NOT NULL DEFAULT(0)
);
GO

CREATE TABLE [dbo].[RawSenateFormalPreferences] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_RawSenateFormalPreferences] PRIMARY KEY CLUSTERED ([Id]),
	[Election] [nvarchar](50) NULL,
	[StateAb] [nvarchar](3) NULL,
	[ElectorateNm] [nvarchar](100) NULL,
	[VoteCollectionPointNm] [nvarchar](200) NULL,
	[VoteCollectionPointId] [int] NULL,
	[BatchNo] [int] NULL,
	[PaperNo] [int] NULL,
	[Preferences] [nvarchar](1000) NULL,
	[Processed] [bit] NOT NULL DEFAULT(0)
);
GO

CREATE TABLE [dbo].[RawSenateFirstPreferencesLegacy] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_RawSenateFirstPreferencesLegacy] PRIMARY KEY CLUSTERED ([Id]),
	[Election] [nvarchar](50) NULL,
	[StateAb] [nvarchar](3) NULL,
	[DivisionID] [int] NULL,
	[DivisionNm] [nvarchar](100) NULL,
	[PollingPlaceID] [int] NULL,
	[PollingPlaceNm] [nvarchar](200) NULL,
	[Ticket] [nvarchar](2) NULL,
	[CandidateID] [int] NULL,
	[BallotPosition] [smallint] NULL,
	[CandidateDetails] [nvarchar](200) NULL,
	[PartyNm] [nvarchar](200) NULL,
	[OrdinaryVotes] [int] NULL,
	[Processed] [bit] NOT NULL DEFAULT(0)
);
GO

CREATE TABLE [dbo].[PartyLookup] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_PartyLookup] PRIMARY KEY CLUSTERED ([Id]),
	[PartyName] [nvarchar](200) NOT NULL,
	[PartyKey] [nchar](4) NOT NULL,
	[PartyShort] [nvarchar](8) NOT NULL
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UQ_PartyLookup_PartyName ON dbo.PartyLookup
	(
	PartyName
	);
GO

CREATE TABLE [dbo].[NumberingStaging](
	[ElectionId] [int] NOT NULL,
	[PreferenceId] [int] NOT NULL,
	[PreferenceValue] [nvarchar](8) NOT NULL,
	[PreferenceNumber] [smallint] NOT NULL,
	[PreferencePosition] [int] NOT NULL,
	[TicketId] [int] NULL,
	[Processed] [bit] NOT NULL DEFAULT(0)
);
GO

CREATE TABLE [dbo].[VoteStaging] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_VoteStaging] PRIMARY KEY CLUSTERED ([Id]),
	[Election] [nvarchar](50) NULL,
	[StateAb] [nvarchar](3) NULL,
	[ElectorateNm] [nvarchar](100) NULL,
	[VoteCollectionPointNm] [nvarchar](200) NULL,
	[Preferences] [nvarchar](1000) NULL,
	[VoteCount] [int] NOT NULL,
	[ElectionId] [int] NULL,
	[LocationId] [int] NULL,
	[PreferenceId] [int] NULL,
	[FirstPreferenceTicketId] [int] NULL,
	[TotalStateVotes] [int] NULL,
	[TotalDivisionVotes] [int] NULL,
	[TotalLocationVotes] [int] NULL,
	[Processed] [bit] NOT NULL DEFAULT(0)
);
GO

-- Dimensions

CREATE TABLE [dbo].[ElectionDimension] (
	[ElectionId] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_ElectionDimension] PRIMARY KEY CLUSTERED ([ElectionId]),
	[Election] [nvarchar](50) NOT NULL,
	[House] [nvarchar](20) NOT NULL,
	[Electorate] [nvarchar](100) NOT NULL,
	[Year] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Type] [nvarchar](50) NOT NULL
);
GO

CREATE TABLE [dbo].[LocationDimension] (
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_LocationDimension] PRIMARY KEY CLUSTERED ([LocationId]),
	[State] [nvarchar](3) NOT NULL,
	[Division] [nvarchar](100) NOT NULL,
	[VoteCollectionPoint] [nvarchar](200) NOT NULL,
	[LocationType] [nvarchar](20) NOT NULL,
	[LocationSubtype] [nvarchar](20) NOT NULL
);
GO

CREATE TABLE [dbo].[TicketDimension] (
	[TicketId] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_TicketDimension] PRIMARY KEY CLUSTERED ([TicketId]),
	[ElectionId] [int] NOT NULL,
		CONSTRAINT [FK_TicketDimension_ElectionDimension] FOREIGN KEY([ElectionId])
			REFERENCES [dbo].[ElectionDimension] ([ElectionId]),
	[Ticket] [nvarchar](2) NOT NULL,
	[BallotPosition] [smallint] NOT NULL,
	[CandidateDetails] [nvarchar](200) NOT NULL,
	[PartyName] [nvarchar](200) NOT NULL,
	[PartyKey] [nchar](4) NOT NULL,
	[PartyShort] [nvarchar](8) NOT NULL,
	[PreferencePosition] [smallint] NOT NULL
);
GO

CREATE TABLE [dbo].[PreferenceDimension] (
	[PreferenceId] [int] IDENTITY(1,1) NOT NULL,
		CONSTRAINT [PK_PreferenceDimension] PRIMARY KEY CLUSTERED ([PreferenceId]),
	[ElectionId] [int] NOT NULL,
		CONSTRAINT [FK_PreferenceDimension_ElectionDimension] FOREIGN KEY([ElectionId])
			REFERENCES [dbo].[ElectionDimension] ([ElectionId]),
	[Preferences] [nvarchar](1000) NOT NULL,
	[PreferenceType] [nvarchar](10) NOT NULL, -- BTL, ATL, Invalid
	[HighestAtlPreference] [int] NULL,
	[HighestBtlPreference] [int] NULL,
	[PreferenceList] [nvarchar](1000) NOT NULL,
	[HowToVote] [nvarchar](3) NOT NULL,
);
GO

CREATE TABLE [dbo].[NumberingFact](
	[PreferenceId] [int] NOT NULL,
		CONSTRAINT [FK_NumberingFact_PreferenceDimension] FOREIGN KEY([PreferenceId])
			REFERENCES [dbo].[PreferenceDimension] ([PreferenceId]),
	[PreferenceNumber] [smallint] NOT NULL,
		CONSTRAINT [PK_NumberingFact] PRIMARY KEY CLUSTERED ([PreferenceId], PreferenceNumber),
	[TicketId] [int] NOT NULL,
		CONSTRAINT [FK_NumberingFact_TicketDimension] FOREIGN KEY([TicketId])
			REFERENCES [dbo].[TicketDimension] ([TicketId]),
	[ElectionId] [int] NOT NULL,
		CONSTRAINT [FK_NumberingFact_ElectionDimension] FOREIGN KEY([ElectionId])
			REFERENCES [dbo].[ElectionDimension] ([ElectionId])
);
GO

CREATE TABLE [dbo].[VoteFact](
	[PreferenceId] [int] NOT NULL,
		CONSTRAINT [FK_VoteFact_PreferenceDimension] FOREIGN KEY([PreferenceId])
			REFERENCES [dbo].[PreferenceDimension] ([PreferenceId]),
	[LocationId] [int] NOT NULL,
		CONSTRAINT [FK_VoteFact_LocationDimension] FOREIGN KEY([LocationId])
			REFERENCES [dbo].[LocationDimension] ([LocationId]),
		CONSTRAINT [PK_VoteFact] PRIMARY KEY CLUSTERED ([PreferenceId], [LocationId]),
	[ElectionId] [int] NOT NULL,
		CONSTRAINT [FK_VoteFact_ElectionDimension] FOREIGN KEY([ElectionId])
			REFERENCES [dbo].[ElectionDimension] ([ElectionId]),
	[FirstPreferenceTicketId] [int] NOT NULL,
		CONSTRAINT [FK_VoteFact_TicketDimension] FOREIGN KEY([FirstPreferenceTicketId])
			REFERENCES [dbo].[TicketDimension] ([TicketId]),
	[VoteCount] [int] NOT NULL,
	[LocationBasisPoints] [float] NOT NULL,
	[DivisionBasisPoints] [float] NOT NULL,
	[StateBasisPoints] [float] NOT NULL
);
GO

