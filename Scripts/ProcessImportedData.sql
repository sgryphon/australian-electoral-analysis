/*
SELECT TOP 100 * FROM RawSenateFirstPreferences
SELECT TOP 100 * FROM RawSenateFormalPreferences

UPDATE RawSenateFirstPreferences SET Processed = 0;
UPDATE RawSenateFormalPreferences SET Processed = 0;
*/

/*
SELECT * FROM PartyLookup;
*/

IF NOT EXISTS (SELECT * FROM PartyLookup) BEGIN
	-- Older data	
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('', 'N/A', 'None');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('A.F.N.P.P.', 'FNPP', 'FirstNat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Animal Justice Party', 'AJP', 'AnimJust');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australia First Party', 'FST', 'AusFirst');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Christians', 'AUC', 'AuChrist');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Democrats', 'DEM', 'Democrat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Fishing and Lifestyle Party', 'AFLP', 'FishLife');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Greens', 'GRN', 'Greens');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Independents', 'AIN', 'AuIndeps');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Labor Party', 'ALP', 'Labor');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Labor Party (Northern Territory) Branch', 'ALP', 'Labor');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Motoring Enthusiast Party', 'AMEP', 'Motoring');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Protectionist Party', 'APP', 'Protect');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Sex Party', 'ASXP', 'Sex');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Sports Party', 'SPRT', 'Sports');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Voice', 'VCE', 'Voice');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Voice Party', 'VCE', 'Voice');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Bank Reform Party', 'BRP', 'BankRef');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Building Australia', 'BAP', 'BuildAus');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Building Australia Party', 'BAP', 'BuildAus');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Bullet Train For Australia', 'BTA', 'BulletTr');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Carers', 'CA', 'Carers');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Carers Alliance', 'CA', 'Carers');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Christian Democratic Party', 'CDP', 'ChrisDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Christian Democratic Party (Fred Nile Group)', 'CDP', 'ChrisDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Citizens Electoral Council', 'CEC', 'CitElect');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Citizens Electoral Council of Australia', 'CEC', 'CitElect');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Climate Change Coalition', 'CCC', 'ClimChg');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Communist', 'CAL', 'Communis');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Conservatives for Climate and Environment', 'CCE', 'ConsClim');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Country Alliance', 'CYA', 'CntryAll');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Country Liberals (NT)', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('D.L.P. - Democratic Labor Party', 'DLP', 'DemLab');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Democratic Labor Party (DLP) of Australia', 'DLP', 'DemLab');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Democratic Labour Party (DLP)', 'DLP', 'DemLab');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Democrats', 'DEM', 'Democrat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('DLP Democratic Labour', 'DLP', 'DemLab');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Drug Law Reform', 'DRF', 'DrugRef');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Family First', 'FFP', 'FamFirst');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Family First Party', 'FFP', 'FamFirst');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Future Party', 'SCI', 'Science');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Hear Our Voice', 'HOV', 'HearVoic');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Help End Marijuana Prohibition (HEMP) Party', 'HMP', 'HEMP');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Independent', 'IND', 'IND');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Katter''s Australian Party', 'KAP', 'Katter');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Labor', 'ALP', 'Labor');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('LDP', 'LDP', 'LibDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal & Nationals', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal Democrats', 'LDP', 'LibDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal Democrats (LDP)', 'LDP', 'LibDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal National Party of Queensland', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal/Nationals', 'LNP', '');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal/The Nationals', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('National Party', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Nationals', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Nick Xenophon Group', 'XEN', 'Xenophon');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('No Carbon Tax Climate Sceptics', 'TCS', 'NoCarbTx');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Non-Custodial Parents Party (Equal Parenting)', 'NCP', 'EqParent');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Northern Territory Country Liberal Party', 'LNP', 'Lib-Nat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Nuclear Disarmament Party of Australia', 'NDP', 'NucDis');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('One Nation', 'ON', 'OneNat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('One Nation WA', 'ON', 'OneNat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Palmer United Party', 'PUP', 'Palmer');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Pauline', 'ON', 'OneNat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Pirate Party', 'PIR', 'Pirate');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Rise Up Australia Party', 'RUA', 'RiseUp');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Secular Party of Australia', 'SPA', 'Secular');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Senator On-Line', 'SOL', 'SenOnLin');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Senator Online (Internet Voting Bills/Issues)', 'SOL', 'SenOnLin');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Sex Party', 'ASXP', 'Sex');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Shooters and Fishers', 'ASP', 'Shooters');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Smokers Rights', 'SMK', 'Smokers');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Socialist Alliance', 'SAL', 'SocAll');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Socialist Equality Party', 'SEP', 'SocEq');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Stable Population Party', 'SPP', 'StablPop');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Stop CSG', 'SCSG', 'StopCSG');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Stop The Greens', 'ODR', 'StopGrns');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Australian Republicans', 'RPA', 'Repub');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Australian Shooters Party', 'ASP', 'Shooters');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Australian Shooters Party/Australian Fishing and Lifestyle Party', 'SFP', 'Shooters');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Climate Sceptics', 'TCS', 'ClimScep');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Fishing Party', 'FPY', 'Fishing');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Greens', 'GRN', 'Greens');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Greens (WA)', 'GRN', 'Greens');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Nationals', 'NAT', 'National');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Wikileaks Party', 'WKP', 'Wiki');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Uniting Australia Party', 'UNP', 'UniteAus');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Voluntary Euthanasia Party', 'VEP', 'VolEuth');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('What Women Want (Australia)', 'WWW', 'Women');

	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Antipaedophile Party', 'APP', 'AntiPed');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Antipaedophile Party', 'APP', 'AnitPed');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Country Party', 'CTY', 'Country');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Cyclists Party', 'CYC', 'Cyclists');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Liberty Alliance', 'ALA', 'AuLibAll');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Progressives', 'PRO', 'Progress');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Recreational Fishers Party', 'RFP', 'RecFish');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Australian Sex Party/Marijuana (HEMP) Party', 'ASXP', 'SEX');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('CountryMinded', 'CTMN', 'CtryMind');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Derryn Hinch''s Justice Party', 'JP', 'Justice');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Glenn Lazarus Team', 'LAZ', 'Lazarus');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Health Australia Party', 'HAP', 'Health');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Jacqui Lambie Network', 'JLN', 'Lambie');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Liberal Democratic Party', 'LDP', 'LibDem');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Marijuana (HEMP) Party', 'HMP', 'HEMP');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Marijuana (HEMP) Party/Australian Sex Party', 'HMP', 'HEMP');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Marriage Equality', 'ME', 'MarrEq');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Mature Australia', 'MAT', 'Mature');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('MFP', 'MFP', 'Manufac');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Nick Xenophon Team', 'XEN', 'Xenophon');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Online Direct Democracy - (Empowering the People!)', 'SOL', 'SenOnLin');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Pauline Hanson''s One Nation', 'ON', 'OneNat');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Pirate Party Australia', 'PIR', 'Pirate');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Renewable Energy Party', 'REP', 'RenewEn');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Science Party', 'SCI', 'Science');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Science Party / Cyclists Party', 'SCI', 'Science');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Science Party/Cyclists Party', 'SCI', 'Science');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Seniors United Party of Australia', 'SUPA', 'Seniors');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Shooters, Fishers and Farmers', 'ASP', 'Shooters');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Sustainable Australia', 'SUS', 'SustAus');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Arts Party', 'ART', 'Arts');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('Veterans Party', 'VET', 'Veterans');
	INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('VOTEFLUX.ORG | Upgrade Democracy!', 'VFL', 'Voteflux');
END

/*
-- Check for missing parties
SELECT 'INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES (''' + PartyName + ''', '''', '''');' AS SQL
FROM (SELECT DISTINCT PartyName 
	FROM RawSenateFirstPreferences
	WHERE PartyName NOT IN (SELECT PartyName FROM PartyLookup)) p;
*/

/*
SELECT * FROM ElectionDimension
*/

IF NOT EXISTS (SELECT * FROM ElectionDimension WHERE Election = 'None') BEGIN
	INSERT INTO [ElectionDimension] (
		Election,
		House,
		Electorate,
		Year,
		Date,
		Type
	) VALUES (
		'None',
		'None',
		'None',
		0,
		'19000101',
		'None'
	);
END

INSERT INTO [ElectionDimension] (
		Election,
		House,
		Electorate,
		Year,
		Date,
		Type
	) 
SELECT DISTINCT r.Election, 
	'Senate' AS House, 
	r.StateAb AS Electorate,
	0 AS [Year],
	'19000101' AS [Date],
	'' AS [Type]
FROM RawSenateFirstPreferences r
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election
			AND e.House = 'Senate'
			AND e.Electorate = r.StateAb
WHERE Processed = 0 AND e.ElectionId IS NULL;

UPDATE ElectionDimension
SET [Year] = 2016, [Date] = '20160702', [Type] = 'Double Dissolution'
WHERE [Type] = '' AND Election = '2016 Federal';
GO

/*
SELECT * FROM TicketDimension
*/

INSERT INTO TicketDimension (
	ElectionId,
	Ticket,
	BallotPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	PreferencePosition
)
SELECT DISTINCT
	e.ElectionId,
	'NA' AS Ticket,
	0 AS BallotPosition,
	'*None' AS CandidateDetails,
	'' AS PartyName,
	'*NA' AS PartyKey,
	'*None' AS PartyShort,
	0 AS PreferencePosition
FROM ElectionDimension e
	LEFT JOIN TicketDimension t ON t.ElectionId = e.ElectionId
WHERE t.ElectionId IS NULL;

INSERT INTO TicketDimension (
	ElectionId,
	Ticket,
	BallotPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	PreferencePosition
)
SELECT ElectionId, 
	Ticket, 
	BallotPosition, 
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
		AS PreferencePosition
FROM RawSenateFirstPreferences r
	LEFT JOIN PartyLookup l ON r.PartyName = l.PartyName
	LEFT JOIN ElectionDimension e 
		ON e.Election = r.Election AND e.House = 'Senate' AND e.Electorate = r.StateAb
WHERE BallotPosition < 9000 AND Processed = 0;

/*
SELECT * FROM [VoteStaging]
*/

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
	FROM RawSenateFormalPreferences 
	WHERE Processed = 0
	GROUP BY Election, StateAb, Preferences, ElectorateNm, VoteCollectionPointNm;
GO

UPDATE [VoteStaging]
	SET ElectionId = e.ElectionId
	FROM [VoteStaging] s
	JOIN ElectionDimension e 
		ON e.Election = s.Election AND e.House = 'Senate' AND e.Electorate = s.StateAb
	WHERE s.Processed = 0;
 
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
	WHERE Processed = 0) x;
GO

UPDATE [VoteStaging]
	SET PreferenceId = p.PreferenceId
	FROM [VoteStaging] s
		JOIN PreferenceDimension p 
		ON s.ElectionId = p.ElectionId
			AND s.Preferences = p.Preferences
	WHERE Processed = 0;

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
			WHEN PreferenceValue = '*' THEN -1
			WHEN PreferenceValue = '/' THEN -2
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
			ON t.ElectionId = y.ElectionId AND t.PreferencePosition = y.PreferencePosition
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
SET @max = (SELECT MAX(PreferencePosition) FROM TicketDimension);
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
				WHERE Processed = 0 AND t.BallotPosition > 0
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
SET @max = (SELECT MAX(PreferencePosition) FROM TicketDimension);
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
				WHERE Processed = 0 AND t.BallotPosition = 0
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
	AND t.BallotPosition > 0
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
	AND t.BallotPosition = 0
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
	WHERE s.Processed = 0
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
	CONVERT(float, VoteCount) / TotalLocationVotes * 100 * 100 AS LocationBasisPoints
FROM VoteStaging
WHERE Processed = 0;
GO


-- Mark processed

UPDATE RawSenateFirstPreferences 
SET Processed = 1
WHERE Processed = 0;

UPDATE RawSenateFormalPreferences 
SET Processed = 1
WHERE Processed = 0;

UPDATE VoteStaging 
SET Processed = 1
WHERE Processed = 0;

UPDATE NumberingStaging 
SET Processed = 1
WHERE Processed = 0;
