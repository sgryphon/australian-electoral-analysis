

-- ATL first preferences
SELECT 
	e.Election, 
	t.Electorate, 
	t.Ticket,
	t.PartyKey, 
	SUM(v.VoteCount) AS VoteCount
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
JOIN LocationDimension l ON l.LocationId = v.LocationId
JOIN TicketDimension t ON t.TicketId = v.FirstPreferenceTicketId
WHERE p.PreferenceType = 'ATL'
GROUP BY 
	e.Election, 
	t.Electorate, 
	t.Ticket,
	t.PartyKey
ORDER BY Electorate, VoteCount DESC;
	 

SELECT * FROM RawSenateFirstPreferences WHERE StateAb = 'TAS';

-- First preferences by location type
SELECT 
	e.Election, 
	t.Electorate, 
	t.Ticket,
	t.PartyKey, 
	t.BallotPosition,
	t.CandidateDetails,
	l.LocationType,
	SUM(v.VoteCount) AS VoteCount
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
JOIN LocationDimension l ON l.LocationId = v.LocationId
JOIN TicketDimension t ON t.TicketId = v.FirstPreferenceTicketId
GROUP BY 
	e.Election, 
	t.Electorate, 
	t.Ticket,
	t.PartyKey, 
	t.BallotPosition,
	t.CandidateDetails,
	l.LocationType

-- LDP Preferences
SELECT 
	e.Election, 
	f.Electorate, 
	f.PartyKey AS FirstPreference, 
	s.PartyKey AS SecondPreference, 
	SUM(v.VoteCount) AS VoteCount
FROM VoteFact v
JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
JOIN LocationDimension l ON l.LocationId = v.LocationId
JOIN TicketDimension f ON f.TicketId = v.FirstPreferenceTicketId
LEFT JOIN PreferenceFact sp ON sp.PreferenceId = v.PreferenceId AND sp.PreferenceNumber = 2
LEFT JOIN TicketDimension s ON s.TicketId = sp.TicketId 
WHERE p.PreferenceType = 'ATL'
AND f.PartyKey = 'LDP'
GROUP BY 
	e.Election, 
	f.Electorate, 
	f.PartyKey,
	s.PartyKey
ORDER BY f.Electorate, VoteCount DESC;

-- Preferences 2
SELECT 
	e.Election, 
	p.Electorate, 
	f.PartyKey AS FirstPreference, 
	SUM(v.VoteCount) AS TotalVotes,
	s.PartyKey AS SecondPreference,
	(SELECT SUM(v.VoteCount) 
		FROM VoteFact v 
			LEFT JOIN PreferenceFact pf ON pf.PreferenceId = v.PreferenceId AND pf.PreferenceNumber = 2
		WHERE v.FirstPreferenceTicketId = f.TicketId
		AND pf.TicketId = s.TicketId) AS SecondPreferenceVotes
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN PreferenceDimension p ON p.PreferenceId = v.PreferenceId
	JOIN TicketDimension f ON f.TicketId = v.FirstPreferenceTicketId
	LEFT JOIN TicketDimension s ON f.Election = s.Election AND f.Electorate = s.Electorate
WHERE f.BallotPosition = 0 AND s.BallotPosition = 0
GROUP BY 
	e.Election, 
	p.Electorate, 
	f.TicketId,
	f.PartyKey,
	s.PartyKey,
	s.TicketId
ORDER BY Election, Electorate, FirstPreference, SecondPreference;

-- Preferences 3
SELECT 
	e.Election, 
	f.Electorate, 
	f.PartyKey AS FirstPreference, 
	t2.PartyKey AS SecondPreference,
	t3.PartyKey AS ThirdPreference,
	SUM(v.VoteCount) AS TotalVotes
FROM VoteFact v
	JOIN ElectionDimension e ON e.ElectionId = v.ElectionId
	JOIN TicketDimension f ON f.TicketId = v.FirstPreferenceTicketId
	JOIN (SELECT PreferenceId,
			(SELECT TicketId FROM PreferenceFact WHERE PreferenceId = p.PreferenceId AND PreferenceNumber = 2) AS TicketId2,
			(SELECT TicketId FROM PreferenceFact WHERE PreferenceId = p.PreferenceId AND PreferenceNumber = 3) AS TicketId3
		FROM PreferenceDimension p
		WHERE PreferenceType='ATL') x ON x.PreferenceId = v.PreferenceId
	LEFT JOIN TicketDimension t2 ON t2.TicketId = x.TicketId2
	LEFT JOIN TicketDimension t3 ON t3.TicketId = x.TicketId3
GROUP BY
	e.Election, 
	f.Electorate, 
	f.PartyKey,
	t2.PartyKey,
	t3.PartyKey
ORDER BY Election, Electorate, FirstPreference, SecondPreference, ThirdPreference;

-- Preference distribution for LDP:

SELECT 
	t.Electorate,
	t.PartyKey,
	n.PreferenceNumber,
	SUM(VoteCount) AS VoteCount
FROM TicketDimension t
	JOIN PreferenceFact n ON n.TicketId = t.TicketId
	JOIN PreferenceDimension p ON p.PreferenceId = n.PreferenceId
	JOIN VoteFact v ON v.PreferenceId = n.PreferenceId
	WHERE PreferenceType = 'ATL'
GROUP BY t.Electorate, t.PartyKey, n.PreferenceNumber
ORDER BY Electorate, PartyKey, PreferenceNumber;


