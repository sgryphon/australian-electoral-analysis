/*
SELECT TOP 100 * FROM RawSenateFirstPreferences
SELECT TOP 100 * FROM RawSenateFormalPreferences
SELECT TOP 100 * FROM RawSenateFirstPreferencesLegacy

UPDATE RawSenateFirstPreferences SET Processed = 0;
UPDATE RawSenateFormalPreferences SET Processed = 0;
*/

/*
SELECT * FROM PartyLookup;
*/

/*
SELECT * FROM ElectionDimension
*/

IF NOT EXISTS (SELECT * FROM ElectionDimension WHERE Election = 'None') BEGIN
	INSERT INTO [ElectionDimension] (
		[Election],
		[House],
		[State],
		[Electorate],
		[Year],
		[Date],
		[Type]
	) VALUES (
		'None',
		'None',
		'None',
		'None',
		0,
		'19000101',
		'None'
	);
END

INSERT INTO [ElectionDimension] (
		[Election],
		[House],
		[State],
		[Electorate],
		[Year],
		[Date],
		[Type]
	) 
SELECT DISTINCT r.Election, 
	'Senate' AS [House], 
	r.StateAb AS [State],
	r.StateAb AS [Electorate],
	0 AS [Year],
	'19000101' AS [Date],
	'' AS [Type]
FROM RawSenateFirstPreferences r
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election
			AND e.House = 'Senate'
			AND e.Electorate = r.StateAb
WHERE Processed = 0 AND e.ElectionId IS NULL;

INSERT INTO [ElectionDimension] (
		[Election],
		[House],
		[State],
		[Electorate],
		[Year],
		[Date],
		[Type]
	) 
SELECT DISTINCT r.Election, 
	'Reps' AS House, 
	r.StateAb AS [State],
	r.DivisionNm AS Electorate,
	0 AS [Year],
	'19000101' AS [Date],
	'' AS [Type]
FROM RawRepresentativesCandidates r
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election
			AND e.House = 'Reps'
			AND e.Electorate = r.DivisionNm
WHERE Processed = 0 AND e.ElectionId IS NULL;

UPDATE ElectionDimension
SET [Year] = 2013, [Date] = '20130907', [Type] = 'Regular'
WHERE [Type] = '' AND Election = '2013 Federal';
GO

UPDATE ElectionDimension
SET [Year] = 2016, [Date] = '20160702', [Type] = 'Double Dissolution'
WHERE [Type] = '' AND Election = '2016 Federal';
GO

UPDATE ElectionDimension
SET [Year] = 2019, [Date] = '20190518', [Type] = 'Regular'
WHERE [Type] = '' AND Election = '2019 Federal';
GO

/*
SELECT * FROM TicketDimension
*/

INSERT INTO TicketDimension (
	ElectionId,
	Ticket,
	TicketPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	BallotPosition
)
SELECT DISTINCT
	e.ElectionId,
	'NA' AS Ticket,
	0 AS TicketPosition,
	'*None' AS CandidateDetails,
	'' AS PartyName,
	'*NA' AS PartyKey,
	'*None' AS PartyShort,
	0 AS BallotPosition
FROM ElectionDimension e
	LEFT JOIN TicketDimension t ON t.ElectionId = e.ElectionId
WHERE t.ElectionId IS NULL;

INSERT INTO TicketDimension (
	ElectionId,
	Ticket,
	TicketPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	BallotPosition
)
SELECT ElectionId, 
	Ticket, 
	BallotPosition as TicketPosition, 
	CandidateDetails, 
	r.PartyName,
	l.PartyKey AS PartyKey,
	l.PartyShort AS PartyShort,
	ROW_NUMBER() OVER(
		PARTITION BY ElectionId
		ORDER BY 
			CASE WHEN BallotPosition = 0 THEN 0 ELSE 1 END, 
			RIGHT('_'+Ticket,2), 
			BallotPosition) 
		AS BallotPosition
FROM RawSenateFirstPreferences r
	LEFT JOIN PartyLookup l ON r.PartyName = l.PartyName
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election AND e.House = 'Senate' AND e.Electorate = r.StateAb
WHERE BallotPosition < 9000 AND Processed = 0;

INSERT INTO TicketDimension (
	ElectionId,
	Ticket,
	TicketPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	BallotPosition
)
SELECT ElectionId, 
	'' AS Ticket, 
	-1 AS TicketPosition, 
	r.Surname + ', ' + r.GivenNm AS CandidateDetails, 
	r.PartyNm,
	l.PartyKey AS PartyKey,
	l.PartyShort AS PartyShort,
	-1 AS BallotPosition
FROM RawRepresentativesCandidates r
	LEFT JOIN PartyLookup l ON r.PartyNm = l.PartyName
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election AND e.House = 'Reps' AND e.Electorate = r.DivisionNm
WHERE Processed = 0;

UPDATE TicketDimension
SET TicketPosition = 0, BallotPosition = r.BallotPosition
--SELECT * 
FROM TicketDimension t
	JOIN ElectionDimension e ON e.ElectionId = t.ElectionId
	JOIN (SELECT DISTINCT Election, DivisionNm, Surname, GivenNm, BallotPosition
				FROM RawRepresentativesFirstPreferences 
				WHERE Processed = 0) r
		ON r.Election = e.Election AND r.DivisionNm = e.Electorate AND r.Surname + ', ' + r.GivenNm = t.CandidateDetails
	WHERE e.House = 'Reps' AND t.BallotPosition = -1;
GO

/*
SELECT * FROM [VoteStaging]
*/

INSERT INTO [VoteStaging] (
	Election, 
	StateAb, 
	ElectorateNm, 
	VoteCollectionPointNm, 
	FirstPreferenceTicketId, 
	VoteCount
)
SELECT 
	r.Election, 
	StateAb, 
	DivisionNm AS ElectorateNm, 
	PollingPlaceNm AS VoteCollectionPointNm, 
	t.TicketId AS FirstPreferenceTicketId, 
	OrdinaryVotes AS VoteCount
	FROM RawSenatePollingPlaceFirstPreferences2013 r
	JOIN ElectionDimension e 
		ON e.Election = r.Election 
		AND e.House = 'Senate' 
		AND e.Electorate = r.StateAb 
	JOIN TicketDimension t 
		ON t.ElectionId = e.ElectionId 
		AND t.Ticket = r.Ticket 
		AND t.TicketPosition = r.BallotPosition
	WHERE Processed = 0
GO

INSERT INTO [VoteStaging] (
	Election, 
	StateAb, 
	ElectorateNm, 
	VoteCollectionPointNm, 
	Preferences, 
	VoteCount
)
SELECT 
	Election, 
	StateAb, 
	ElectorateNm, 
	VoteCollectionPointNm, 
	Preferences, 
	COUNT(*) AS VoteCount
	FROM RawSenateFormalPreferences2016 
	WHERE Processed = 0
	GROUP BY Election, StateAb, Preferences, ElectorateNm, VoteCollectionPointNm;
GO

INSERT INTO [VoteStaging] (
	Election, 
	StateAb, 
	ElectorateNm, 
	VoteCollectionPointNm, 
	Preferences, 
	VoteCount
)
SELECT 
	Election, 
	StateAb, 
	Division AS ElectorateNm, 
	VoteCollectionPointName AS VoteCollectionPointNm, 
	Preferences, 
	COUNT(*) AS VoteCount
	FROM RawSenateFormalPreferences2019 
	WHERE Processed = 0
	GROUP BY Election, StateAb, Preferences, Division, VoteCollectionPointName;
GO

UPDATE [VoteStaging]
	SET ElectionId = e.ElectionId
	FROM [VoteStaging] s
	JOIN ElectionDimension e 
		ON e.Election = s.Election AND e.House = 'Senate' AND e.Electorate = s.StateAb
	WHERE s.Processed = 0;

-- Reps
INSERT INTO [VoteStaging] (
	Election, 
	StateAb, 
	ElectorateNm, 
	VoteCollectionPointNm, 
	VoteCount,
	ElectionId,
	FirstPreferenceTicketId
)
SELECT 
	r.Election, 
	StateAb, 
	DivisionNm AS ElectorateNm, 
	PollingPlace AS VoteCollectionPointNm, 
	OrdinaryVotes AS VoteCount,
	e.ElectionId,
	t.TicketId AS FirstPreferenceTicketId
	FROM RawRepresentativesFirstPreferences r
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election 
		AND e.House = 'Reps' 
		AND e.Electorate = r.DivisionNm 
	LEFT JOIN TicketDimension t 
		ON t.ElectionId = e.ElectionId 
		AND (t.BallotPosition = r.BallotPosition OR (t.BallotPosition = 0 AND r.BallotPosition = 999))
	WHERE Processed = 0;
GO
 
/*
SELECT * FROM LocationDimension
*/

IF NOT EXISTS (SELECT * FROM LocationDimension WHERE [State] = '*NA') BEGIN
	INSERT INTO LocationDimension (
		[State], 
		Division, 
		VoteCollectionPoint,
		LocationType,
		LocationSubtype
	)
	VALUES (
		'*NA',
		'*None',
		'*None',
		'',
		''
	)
END

INSERT INTO LocationDimension (
	[State], 
	Division, 
	VoteCollectionPoint,
	LocationType,
	LocationSubtype
)
SELECT 
	c.[State], 
	c.Division, 
	c.VoteCollectionPoint,
	CASE 
		WHEN c.VoteCollectionPoint LIKE 'ABSENT %' THEN 'Absent'
		WHEN c.VoteCollectionPoint LIKE 'POSTAL %' THEN 'Postal'
		WHEN c.VoteCollectionPoint LIKE 'PRE_POLL %' THEN 'PrePoll'
		WHEN c.VoteCollectionPoint LIKE 'PROVISIONAL %' THEN 'Provisional'
		ELSE 'Ordinary'
	END AS LocationType,
	CASE 
		WHEN c.VoteCollectionPoint LIKE 'Special Hospital Team %' THEN 'Special'
		WHEN c.VoteCollectionPoint LIKE 'Remote Mobile Team %' THEN 'Remote'
		WHEN c.VoteCollectionPoint LIKE '%PPVC%' THEN 'PPVC'
		WHEN c.VoteCollectionPoint LIKE '%(PREPOLL)%' THEN 'PREPOLL'
		ELSE ''
	END AS LocationSubtype
FROM (SELECT DISTINCT 
		StateAb AS [State], 
		ElectorateNm AS Division, 
		VoteCollectionPointNm AS VoteCollectionPoint
	FROM [VoteStaging]
	WHERE Processed = 0) c
LEFT JOIN LocationDimension l 
	ON c.[State] = l.[State] 
		AND c.Division = l.Division
		AND c.VoteCollectionPoint = l.VoteCollectionPoint
WHERE l.LocationId IS NULL;

UPDATE [VoteStaging]
	SET LocationId = l.LocationId
	FROM [VoteStaging] s
		JOIN LocationDimension l 
		ON s.[StateAb] = l.[State] 
			AND s.ElectorateNm = l.Division
			AND s.VoteCollectionPointNm = l.VoteCollectionPoint
	WHERE s.Processed = 0;


/*
SELECT * FROM PreferenceDimension
*/

INSERT INTO PreferenceDimension (
	ElectionId,
	Preferences,
	PreferenceType,
	PreferenceList,
	HowToVote
)
SELECT DISTINCT
	e.ElectionId,
	'' AS Preferences,
	'*NA' AS PreferenceType,
	'' AS PreferenceList,
	'' AS HowToVote
FROM ElectionDimension e
	LEFT JOIN PreferenceDimension p ON p.ElectionId = e.ElectionId AND p.PreferenceType = '*NA'
WHERE p.ElectionId IS NULL;

INSERT INTO PreferenceDimension (
	ElectionId,
	Preferences,
	PreferenceType,
	PreferenceList,
	HowToVote
)
SELECT 
	ElectionId,
	Preferences,
	'' AS PreferenceType,
	'' AS PreferenceList,
	'' AS HowToVote
FROM (SELECT DISTINCT 
		ElectionId,
		Preferences
	FROM [VoteStaging]
	WHERE Preferences IS NOT NULL
		AND Processed = 0) x;
GO

UPDATE [VoteStaging]
	SET PreferenceId = p.PreferenceId
	FROM [VoteStaging] s
		JOIN PreferenceDimension p 
		ON s.ElectionId = p.ElectionId
			AND s.Preferences = p.Preferences
	WHERE s.Preferences IS NOT NULL 
		AND Processed = 0;

UPDATE [VoteStaging]
	SET PreferenceId = p.PreferenceId
	-- SELECT *
	FROM [VoteStaging] s
		JOIN PreferenceDimension p 
		ON s.ElectionId = p.ElectionId
			AND p.PreferenceType = '*NA'
	WHERE s.Preferences IS NULL 
		AND Processed = 0;

/*
SELECT * FROM NumberingStaging
SELECT COUNT(*) FROM NumberingStaging
*/

-- Split preferences at commas, match to ticket based on index, take individual numbers
-- (TAS ~ 1 min, WA ~ 7 min)
-- Batch into 10,000
DECLARE @counter INT;
DECLARE @max INT;
DECLARE @updatedRows INT;
SET @counter = 0;
SET @updatedRows = -1;
SET @max = (SELECT COUNT(*)	FROM PreferenceDimension WHERE PreferenceId NOT IN (SELECT PreferenceId FROM NumberingStaging) AND PreferenceType = '') / 10000;
PRINT 'Max loops: ' + CONVERT(nvarchar(5), @max);
WHILE ( (@counter <= @max + 1) AND (@updatedRows <> 0) ) BEGIN
	PRINT 'Processing ' + CONVERT(varchar(5), @counter);

	INSERT INTO NumberingStaging (
		ElectionId,
		PreferenceId,
		PreferenceValue,
		PreferenceNumber,
		PreferencePosition,
		TicketId
	)
	SELECT 
		y.ElectionId,
		PreferenceId, 
		PreferenceValue,
		CASE 
			WHEN PreferenceValue = '*' THEN 1
			WHEN PreferenceValue = '/' THEN 1
			WHEN PreferenceValue = '' THEN -3
			ELSE CONVERT(smallint, PreferenceValue)
		END AS PreferenceNumber, 
		y.PreferencePosition,
		TicketId
	FROM (SELECT
			ElectionId,
			PreferenceId, 
			ROW_NUMBER() OVER (PARTITION BY PreferenceId ORDER BY LEN(PreferenceRight) DESC) AS PreferencePosition,
			LEFT(PreferenceRight, CHARINDEX(',', PreferenceRight + ',') - 1) AS PreferenceValue,
			PreferenceRight
		FROM
			(SELECT ElectionId, PreferenceId, LTRIM(SUBSTRING(p.Preferences, n.Number, 1000)) AS PreferenceRight
				FROM 
					(SELECT TOP 10000 ElectionId, PreferenceId, Preferences 
						FROM PreferenceDimension
						WHERE PreferenceId NOT IN (SELECT PreferenceId FROM NumberingStaging)
							AND PreferenceType = '') p
				LEFT OUTER JOIN
					(SELECT DISTINCT number FROM master.dbo.spt_values WHERE number BETWEEN 1 AND 1000) n
						ON n.Number <= LEN(',' + p.Preferences) AND SUBSTRING(',' + p.Preferences, n.Number, 1) = ',') x
		) y
		LEFT JOIN TicketDimension t
			ON t.ElectionId = y.ElectionId AND t.BallotPosition = y.PreferencePosition
	WHERE PreferenceValue <> '';

	SET @updatedRows = (SELECT @@ROWCOUNT);

	SET @counter = @counter + 1;
END
GO

-- Check highest BTL sequence
-- (TAS ~ 3 min, WA ~ 5 min)

UPDATE PreferenceDimension
SET HighestBtlPreference = 0
WHERE PreferenceType = '';
GO

DECLARE @counter INT;
DECLARE @max INT;
DECLARE @updatedRows INT;
SET @counter = 1;
SET @updatedRows = -1;
SET @max = (SELECT MAX(BallotPosition) FROM TicketDimension);
PRINT 'Max preferences: ' + CONVERT(nvarchar(5), @max);
WHILE ( (@counter <= @max + 1) AND (@updatedRows <> 0) ) BEGIN
	PRINT 'Processing ' + CONVERT(varchar(5), @counter);

	UPDATE PreferenceDimension
	SET HighestBtlPreference = HighestBtlPreference + 1
	FROM PreferenceDimension p
	JOIN (
		-- Find exactly one BTL (ballot position > 0) numbering that is one greater than current highest 
		SELECT p1.PreferenceId, COUNT(TicketId) AS HowMany
		FROM PreferenceDimension p1
		JOIN (SELECT PreferenceId, PreferenceNumber, s.TicketId 
				FROM NumberingStaging s
				JOIN TicketDimension t ON s.TicketId = t.TicketId
				WHERE Processed = 0 AND t.TicketPosition > 0
			) x ON p1.PreferenceId = x.PreferenceId
		WHERE x.PreferenceNumber = (p1.HighestBtlPreference + 1)
		GROUP BY p1.PreferenceId
		HAVING COUNT(TicketId) = 1
	) y ON p.PreferenceId = y.PreferenceId;

	SET @updatedRows = (SELECT @@ROWCOUNT);

	SET @counter = @counter + 1;
END
GO

-- Check highest ATL sequence

UPDATE PreferenceDimension
SET HighestAtlPreference = 0
WHERE PreferenceType = '';
GO

DECLARE @counter INT;
DECLARE @max INT;
DECLARE @updatedRows INT;
SET @counter = 1;
SET @updatedRows = -1;
SET @max = (SELECT MAX(BallotPosition) FROM TicketDimension);
PRINT 'Max preferences: ' + CONVERT(nvarchar(5), @max);
WHILE ( (@counter <= @max + 1) AND (@updatedRows <> 0) ) BEGIN
	PRINT 'Processing ' + CONVERT(varchar(5), @counter);

	UPDATE PreferenceDimension
	SET HighestAtlPreference = HighestAtlPreference + 1
	FROM PreferenceDimension p
	JOIN (
		-- Find exactly one ATL (ballot position = 0) numbering that is one greater than current highest 
		SELECT p1.PreferenceId, COUNT(TicketId) AS HowMany
		FROM PreferenceDimension p1
		JOIN (SELECT PreferenceId, PreferenceNumber, s.TicketId 
				FROM NumberingStaging s
				JOIN TicketDimension t ON s.TicketId = t.TicketId
				WHERE Processed = 0 AND t.TicketPosition = 0
			) x ON p1.PreferenceId = x.PreferenceId
		WHERE x.PreferenceNumber = (p1.HighestAtlPreference + 1)
		GROUP BY p1.PreferenceId
		HAVING COUNT(TicketId) = 1
	) y ON p.PreferenceId = y.PreferenceId;

	SET @updatedRows = (SELECT @@ROWCOUNT);

	SET @counter = @counter + 1;
END
GO

-- Set preference type

UPDATE PreferenceDimension
SET PreferenceType = CASE
		WHEN HighestBtlPreference >= 6 THEN 'BTL'
		WHEN HighestAtlPreference >= 1 THEN 'ATL'
		ELSE 'Informal'
	END
WHERE PreferenceType = '';
GO

/*
SELECT * FROM NumberingFact
*/

-- Transfer BTL

INSERT INTO NumberingFact
	(ElectionId, PreferenceId, TicketId, PreferenceNumber)
SELECT s.ElectionId, s.PreferenceId, s.TicketId, PreferenceNumber
FROM NumberingStaging s
JOIN PreferenceDimension p ON s.PreferenceId = p.PreferenceId
JOIN TicketDimension t ON s.TicketId = t.TicketId
WHERE Processed = 0
	AND p.PreferenceType = 'BTL' 
	AND t.TicketPosition > 0
	AND PreferenceNumber > 0
	AND PreferenceNumber <= HighestBtlPreference;
GO

-- Transfer ATL

INSERT INTO NumberingFact
	(ElectionId, PreferenceId, TicketId, PreferenceNumber)
SELECT s.ElectionId, s.PreferenceId, s.TicketId, PreferenceNumber
FROM NumberingStaging s
JOIN PreferenceDimension p ON s.PreferenceId = p.PreferenceId
JOIN TicketDimension t ON s.TicketId = t.TicketId
WHERE Processed = 0
	AND p.PreferenceType = 'ATL' 
	AND t.TicketPosition = 0
	AND PreferenceNumber > 0
	AND PreferenceNumber <= HighestAtlPreference;
GO

-- Set staging first preference

UPDATE VoteStaging
SET FirstPreferenceTicketId = COALESCE( n.TicketId, tna.TicketId )
FROM
-- SELECT * FROM 
	VoteStaging s
	JOIN TicketDimension tna ON tna.ElectionId = s.ElectionId AND tna.Ticket = 'NA'
	LEFT JOIN NumberingFact n ON n.PreferenceId = s.PreferenceId AND n.PreferenceNumber = 1
	WHERE s.FirstPreferenceTicketId IS NULL 
		AND s.Processed = 0
GO

-- Location totals

UPDATE VoteStaging
	SET TotalStateVotes = Total
FROM VoteStaging s
	JOIN ElectionDimension e ON e.ElectionId = s.ElectionId
	JOIN LocationDimension l ON l.LocationId = s.LocationId
	JOIN (SELECT e.Election, e.House, 
			l.[State], 
			SUM(VoteCount) AS Total
		FROM VoteStaging s1
			JOIN ElectionDimension e ON e.ElectionId = s1.ElectionId
			JOIN LocationDimension l ON l.LocationId = s1.LocationId
		WHERE Processed = 0
		GROUP BY e.Election, e.House, l.[State]
		) x ON x.Election = e.Election 
			AND x.House = e.House
			AND x.[State] = l.[State]
	WHERE Processed = 0;
GO

UPDATE VoteStaging
	SET TotalDivisionVotes = Total
FROM VoteStaging s
	JOIN ElectionDimension e ON e.ElectionId = s.ElectionId
	JOIN LocationDimension l ON l.LocationId = s.LocationId
	JOIN (SELECT e.Election, e.House, 
			l.[State], l.Division, 
			SUM(VoteCount) AS Total
		FROM VoteStaging s1
			JOIN ElectionDimension e ON e.ElectionId = s1.ElectionId
			JOIN LocationDimension l ON l.LocationId = s1.LocationId
		WHERE Processed = 0
		GROUP BY e.Election, e.House, l.[State], l.Division
		) x ON x.Election = e.Election 
			AND x.House = e.House
			AND x.[State] = l.[State]
			AND x.Division = l.Division
	WHERE Processed = 0;
GO

UPDATE VoteStaging
	SET TotalLocationVotes = Total
FROM VoteStaging s
	JOIN ElectionDimension e ON e.ElectionId = s.ElectionId
	JOIN LocationDimension l ON l.LocationId = s.LocationId
	JOIN (SELECT e.Election, e.House, 
			l.[State], l.Division, l.VoteCollectionPoint,
			SUM(VoteCount) AS Total
		FROM VoteStaging s1
			JOIN ElectionDimension e ON e.ElectionId = s1.ElectionId
			JOIN LocationDimension l ON l.LocationId = s1.LocationId
		WHERE Processed = 0
		GROUP BY e.Election, e.House, l.[State], l.Division, l.VoteCollectionPoint
		) x ON x.Election = e.Election 
			AND x.House = e.House
			AND x.[State] = l.[State]
			AND x.Division = l.Division
			AND x.VoteCollectionPoint = l.VoteCollectionPoint
	WHERE Processed = 0;
GO


/*
SELECT * FROM VoteFact
*/

-- Transfer

INSERT INTO VoteFact (
	ElectionId,
	LocationId,
	PreferenceId,
	FirstPreferenceTicketId,
	VoteCount,
	StateBasisPoints,
	DivisionBasisPoints,
	LocationBasisPoints
)
SELECT 
	ElectionId,
	LocationId,
	PreferenceId,
	FirstPreferenceTicketId,
	VoteCount,
	CONVERT(float, VoteCount) / TotalStateVotes * 100 * 100 AS StateBasisPoints,
	CONVERT(float, VoteCount) / TotalDivisionVotes * 100 * 100 AS DivisionBasisPoints,
	CASE 
		WHEN TotalLocationVotes = 0 THEN 0
		ELSE CONVERT(float, VoteCount) / TotalLocationVotes * 100 * 100 
	END AS LocationBasisPoints
FROM VoteStaging
WHERE Processed = 0;
GO


-- Mark processed

UPDATE RawSenateFirstPreferences 
SET Processed = 1
WHERE Processed = 0;

UPDATE RawSenatePollingPlaceFirstPreferences2013 
SET Processed = 1
WHERE Processed = 0;

UPDATE RawSenateFormalPreferences2016 
SET Processed = 1
WHERE Processed = 0;

UPDATE RawRepresentativesCandidates 
SET Processed = 1
WHERE Processed = 0;

UPDATE RawRepresentativesFirstPreferences 
SET Processed = 1
WHERE Processed = 0;

UPDATE VoteStaging 
SET Processed = 1
WHERE Processed = 0;

UPDATE NumberingStaging 
SET Processed = 1
WHERE Processed = 0;
