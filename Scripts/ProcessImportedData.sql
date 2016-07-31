/*
-- Election inserts
SELECT * FROM ElectionDimension;

INSERT INTO [ElectionDimension] (
	Election,
	Year,
	Date,
	Type
) VALUES (
	'2016 Federal',
	2016,
	'20160702',
	'Double Dissolution'
);

*/

/*
-- Initial party inserts
SELECT * FROM PartyLookup;

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
INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES ('The Nationals', 'LNP', 'Lib-Nat');
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

-- Check for missing parties
SELECT 'INSERT INTO [PartyLookup] (PartyName, PartyKey, PartyShort) VALUES (''' + PartyName + ''', '''', '''');' AS SQL
FROM (SELECT DISTINCT PartyName 
	FROM RawSenateFirstPreferences
	WHERE PartyName NOT IN (SELECT PartyName FROM PartyLookup)) p;

*/

/*
SELECT * FROM TicketDimension
*/

INSERT INTO TicketDimension (
	Election,
	House,
	Electorate,
	Ticket,
	BallotPosition,
	CandidateDetails,
	PartyName,
	PartyKey,
	PartyShort,
	PreferencePosition
)
SELECT Election, 
	'Senate' AS House, 
	StateAb AS Electorate, 
	Ticket, 
	BallotPosition, 
	CandidateDetails, 
	r.PartyName,
	l.PartyKey AS PartyKey,
	l.PartyShort AS PartyShort,
	(SELECT p.Position FROM 
		(SELECT Id, 
			ROW_NUMBER() OVER(ORDER BY 
			CASE WHEN BallotPosition = 0 THEN 0 ELSE 1 END, 
			RIGHT('_'+Ticket,2), 
			BallotPosition) AS Position 
		FROM RawSenateFirstPreferences
		WHERE StateAb = r.StateAb AND Election= r.Election AND BallotPosition < 9000) p 
	WHERE p.Id = r.Id) AS PreferencePosition
FROM RawSenateFirstPreferences r
	LEFT JOIN PartyLookup l ON r.PartyName = l.PartyName
WHERE BallotPosition < 9000 AND Processed = 0;
 


