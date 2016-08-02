

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
ORDER BY VoteCount DESC;
	 

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
ORDER BY VoteCount DESC;

-- Preferences to LDP
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

