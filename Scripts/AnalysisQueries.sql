-- Summary first preferences type
SELECT 
	e.Election,
	e.House, 
	e.Electorate, 
	p.PreferenceType,
	SUM(v.VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(v.StateBasisPoints)) AS BasisPoints
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
GROUP BY 
	e.Election, 
	e.House,
	e.Electorate, 
	p.PreferenceType
ORDER BY Election, House, Electorate, PreferenceType;

-- Senate ATL first preferences
SELECT 
	e.Election, 
	e.Electorate, 
	t1.Ticket,
	t1.PartyKey, 
	SUM(v.VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(v.StateBasisPoints)) AS BasisPoints
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
WHERE (p.PreferenceType = 'ATL' OR p.PreferenceType = '*NA') AND e.House = 'Senate'
GROUP BY 
	e.Election, 
	e.Electorate, 
	t1.Ticket,
	t1.PartyKey
ORDER BY Election, Electorate, Votes DESC;

-- Senate first preferences by candidate
SELECT 
	e.Election, 
	e.Electorate, 
	t1.Ticket,
	t1.PartyKey, 
	t1.BallotPosition,
	t1.CandidateDetails,
	SUM(v.VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(v.StateBasisPoints)) AS BasisPoints
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
WHERE e.House = 'Senate'
GROUP BY 
	e.Election, 
	e.Electorate, 
	t1.Ticket,
	t1.PartyKey, 
	t1.BallotPosition,
	t1.CandidateDetails
	 
-- Senate first preferences by candidate by location type
SELECT 
	Election,
	Electorate,
	Ticket, 
	PartyKey,
	BallotPosition,
	CandidateDetails,
	MAX([Ordinary]) AS Ordinary, 
	MAX([OrdinaryBPS]) AS OrdinaryBPS, 
	MAX([Absent]) AS [Absent], 
	MAX([AbsentBPS]) AS AbsentBPS, 
	MAX([Provisional]) AS Provisional, 
	MAX([ProvisionalBPS]) AS ProvisionalBPS, 
	MAX([PrePoll]) AS PrePoll, 
	MAX([PrePollBPS]) AS PrePollBPS, 
	MAX([Postal]) AS Postal,
	MAX([PostalBPS]) AS PostalBPS
FROM 
	(SELECT 
		e.Election, 
		e.Electorate, 
		t1.Ticket,
		t1.PartyKey, 
		t1.BallotPosition,
		t1.CandidateDetails,
		l.LocationType,
		l.LocationType + 'BPS' AS LocationType2,
		SUM(v.VoteCount) AS Votes,
		CONVERT([decimal](18,0), SUM(v.StateBasisPoints)) AS BasisPoints
	FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN LocationDimension l ON l.LocationId = v.LocationId
	JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
	WHERE e.House = 'Senate'
	GROUP BY 
		e.Election, 
		e.Electorate, 
		t1.Ticket,
		t1.PartyKey, 
		t1.BallotPosition,
		t1.CandidateDetails,
		l.LocationType
	) y
PIVOT (
	SUM(Votes) 
		FOR LocationType IN ([Ordinary], [Absent], [Provisional], [PrePoll], [Postal])
) AS x
PIVOT (
	SUM(BasisPoints)
		FOR LocationType2 IN ([OrdinaryBPS], [AbsentBPS], [ProvisionalBPS], [PrePollBPS], [PostalBPS])
) AS x2
GROUP BY 
	Election, 
	Electorate, 
	Ticket,
	PartyKey, 
	BallotPosition,
	CandidateDetails
ORDER BY Election, Electorate, Ticket, BallotPosition;
GO

-- Senate ATL preference distribution by party
SELECT 
	e.Election,
	e.Electorate,
	n.PreferenceNumber,
	t.PartyKey,
	SUM(VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS BasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN NumberingFact n ON n.PreferenceId = p.PreferenceId
	JOIN TicketDimension t ON t.TicketId = n.TicketId
WHERE p.PreferenceType = 'ATL' AND e.House = 'Senate'
GROUP BY e.Election, e.Electorate, n.PreferenceNumber, t.PartyKey
ORDER BY Election, Electorate, PreferenceNumber, PartyKey;

-- Senate ATL preference distribution by first preference and party
SELECT 
	e.Election,
	e.Electorate,
	t1.PartyKey AS FirstPreferencePartyKey,
	n.PreferenceNumber,
	t.PartyKey,
	SUM(VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS BasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
	JOIN NumberingFact n ON n.PreferenceId = p.PreferenceId
	JOIN TicketDimension t ON t.TicketId = n.TicketId
WHERE p.PreferenceType = 'ATL' AND e.House = 'Senate'
GROUP BY e.Election, e.Electorate, t1.PartyKey, n.PreferenceNumber, t.PartyKey
ORDER BY Election, Electorate, FirstPreferencePartyKey, PreferenceNumber, PartyKey;

-- Senate ATL preference sequence (first three)
SELECT
	Election,
	Electorate,
	FirstPreference,
	CONVERT([decimal](18,0), SUM(StateBasisPoints) 
		OVER(PARTITION BY Election, Electorate, FirstPreference)) AS FirstBasisPoints,
	SecondPreference,
	CONVERT([decimal](18,0), SUM(StateBasisPoints) 
		OVER(PARTITION BY Election, Electorate, FirstPreference, SecondPreference)) AS SecondBasisPoints,
	(SUM(StateBasisPoints) OVER(PARTITION BY Election, Electorate, FirstPreference, SecondPreference) /
		SUM(StateBasisPoints) OVER(PARTITION BY Election, Electorate, FirstPreference)) AS SecondFraction,
	ThirdPreference,
	CONVERT([decimal](18,0), StateBasisPoints) AS ThirdBasisPoints,
	(StateBasisPoints / SUM(StateBasisPoints) OVER(PARTITION BY Election, Electorate, FirstPreference)) AS ThirdFraction
FROM( 
SELECT 
	e.Election, 
	e.Electorate, 
	t1.PartyKey AS FirstPreference, 
	t2.PartyKey AS SecondPreference,
	t3.PartyKey AS ThirdPreference,
	SUM(v.StateBasisPoints) AS StateBasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
	JOIN (SELECT PreferenceId,
			(SELECT TicketId FROM NumberingFact WHERE PreferenceId = p.PreferenceId AND PreferenceNumber = 2) AS TicketId2,
			(SELECT TicketId FROM NumberingFact WHERE PreferenceId = p.PreferenceId AND PreferenceNumber = 3) AS TicketId3
		FROM PreferenceDimension p
		WHERE PreferenceType='ATL') x ON x.PreferenceId = v.PreferenceId
	LEFT JOIN TicketDimension t2 ON t2.TicketId = x.TicketId2
	LEFT JOIN TicketDimension t3 ON t3.TicketId = x.TicketId3
WHERE e.House = 'Senate'
GROUP BY
	e.Election, 
	e.Electorate, 
	t1.PartyKey,
	t2.PartyKey,
	t3.PartyKey
) y
ORDER BY Election, Electorate, FirstPreference, SecondPreference, ThirdPreference;


-- Distribution of Senate highest preference, by State
SELECT 
	e.Election,
	p.PreferenceType,
	e.Electorate,
	CASE
		WHEN p.PreferenceType = 'BTL' THEN p.HighestBtlPreference
		ELSE p.HighestAtlPreference
	END AS HighestPreference,
	SUM(VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS BasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
WHERE e.House = 'Senate'
GROUP BY 
	e.Election, 
	p.PreferenceType, 
	e.Electorate, 
	CASE
		WHEN p.PreferenceType = 'BTL' THEN p.HighestBtlPreference
		ELSE p.HighestAtlPreference
	END
ORDER BY Election, PreferenceType, Electorate, HighestPreference;

--
SELECT 
	Election,
	Electorate,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS BasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
WHERE p.PreferenceType = 'ATL' AND e.House = 'Senate'
	AND p.PreferenceId IN ( SELECT PreferenceId 
			FROM NumberingFact n
			JOIN TicketDimension t ON t.TicketId = n.TicketId
			WHERE t.PartyKey IN ('LNP', 'ALP', 'GRN')
			AND n.PreferenceNumber <= 6)
GROUP BY Election, Electorate
ORDER BY Election, Electorate;

-- QLD Senate ATL preference distribution by party and location
SELECT 
	e.Election,
	e.Electorate,
	l.Division,
	l.LocationType,
	l.VoteCollectionPoint,
	n.PreferenceNumber,
	t.PartyKey,
	SUM(VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS StateBasisPoints,
	CONVERT([decimal](18,0), SUM(DivisionBasisPoints)) AS DivisionBasisPoints,
	CONVERT([decimal](18,0), SUM(LocationBasisPoints)) AS LocationBasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN LocationDimension l ON l.LocationId = v.LocationId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN NumberingFact n ON n.PreferenceId = p.PreferenceId
	JOIN TicketDimension t ON t.TicketId = n.TicketId
WHERE p.PreferenceType = 'ATL' 
	AND e.House = 'Senate' 
	AND e.Electorate = 'QLD'
	AND n.PreferenceNumber <= 8
GROUP BY 
	e.Election, e.Electorate, 
	l.Division, l.LocationType, l.VoteCollectionPoint, 
	n.PreferenceNumber, 
	t.PartyKey;

-- Ryan (QLD) Senate ATL preference distribution by first preference, by party and location
SELECT 
	e.Election,
	e.Electorate,
	l.Division,
	l.LocationType,
	l.VoteCollectionPoint,
	t1.PartyKey AS FirstPreferencePartyKey,
	n.PreferenceNumber,
	t.PartyKey,
	SUM(VoteCount) AS Votes,
	CONVERT([decimal](18,0), SUM(StateBasisPoints)) AS StateBasisPoints,
	CONVERT([decimal](18,0), SUM(DivisionBasisPoints)) AS DivisionBasisPoints,
	CONVERT([decimal](18,0), SUM(LocationBasisPoints)) AS LocationBasisPoints
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN LocationDimension l ON l.LocationId = v.LocationId
	JOIN TicketDimension t1 ON t1.TicketId = v.FirstPreferenceTicketId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN NumberingFact n ON n.PreferenceId = p.PreferenceId
	JOIN TicketDimension t ON t.TicketId = n.TicketId
WHERE p.PreferenceType = 'ATL' 
	AND e.House = 'Senate' 
	AND e.Electorate = 'QLD'
	and l.Division = 'Ryan'
	AND n.PreferenceNumber <= 8
GROUP BY 
	e.Election, e.Electorate, 
	l.Division, l.LocationType, l.VoteCollectionPoint,
	t1.PartyKey, 
	n.PreferenceNumber, 
	t.PartyKey;
