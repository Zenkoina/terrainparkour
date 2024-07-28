--!strict

--excluded from source control

local annotater = require(game.ReplicatedStorage.util.annotater)
local _annotate = annotater.getAnnotater(script)

local module = {}

local tt = require(game.ReplicatedStorage.types.gametypes)

local badges: { [string]: tt.badgeDescriptor } = {

	RaceRunner10 = { name = "Race Runner 10", assetId = 2125857719, badgeClass = "race runner", order = 10 },
	RaceRunner40 = { name = "Race Runner 40", assetId = 2125857721, badgeClass = "race runner", order = 40 },
	RaceRunner100 = { name = "Race Runner 100", assetId = 2126074526, badgeClass = "race runner", order = 100 },
	RaceRunner200 = { name = "Race Runner 200", assetId = 2126074528, badgeClass = "race runner", order = 200 },
	RaceRunner500 = { name = "Race Runner 500", assetId = 2126074529, badgeClass = "race runner", order = 500 },
	RaceRunner1000 = { name = "Race Runner 1000", assetId = 2126074530, badgeClass = "race runner", order = 1000 },
	RaceRunner2000 = { name = "Race Runner 2000", assetId = 2126074531, badgeClass = "race runner", order = 2000 },

	RaceRuns10 = { name = "Race Runs 10", assetId = 2126075950, badgeClass = "race runs", order = 10 },
	RaceRuns40 = { name = "Race Runs 40", assetId = 2125857724, badgeClass = "race runs", order = 40 },
	RaceRuns100 = { name = "Race Runs 100", assetId = 2126075994, badgeClass = "race runs", order = 100 },
	RaceRuns200 = { name = "Race Runs 200", assetId = 2126075990, badgeClass = "race runs", order = 200 },
	RaceRuns500 = { name = "Race Runs 500", assetId = 2126075996, badgeClass = "race runs", order = 500 },
	RaceRuns1000 = { name = "Race Runs 1000", assetId = 2126158368, badgeClass = "race runs", order = 1000 },
	RaceRuns2000 = { name = "Race Runs 2000", assetId = 2126158369, badgeClass = "race runs", order = 2000 },

	--hard to do cause they happen on client
	-- UsedTabBadge = { name = "Used Tab", assetId = 2126801968, badgeClass = "onboarding" },
	-- UsedXBadge = { name = "Used X", assetId = 2126801969, badgeClass = "onboarding" },

	DethroneCreator = { name = "Dethrone Creator", assetId = 2126338119, badgeClass = "play" },

	PushDownCreator = { name = "Push Down Creator", assetId = 2126338122, badgeClass = "play" },
	KnockedOutCreator = { name = "Knocked Out Creator", assetId = 2126338123, badgeClass = "play" },
	KnockedSomeoneOut = { name = "Knocked Someone Out", assetId = 2126338125, badgeClass = "play" },

	RepeatRun = { name = "Pete and Repeat", assetId = 2125501802, badgeClass = "grinding" },
	SpecializeRun = { name = "Specializing Runner", assetId = 2125501804, badgeClass = "grinding" },
	GrindRun = { name = "Grinder", assetId = 2125501805, badgeClass = "grinding" },
	GuruRun = { name = "Run Guru", assetId = 2125647283, badgeClass = "grinding", hint = "Be like Henry Sugar." },
	FocusRun = { name = "Focus Run", assetId = 2125501815, badgeClass = "grinding" },
	CrazyRun = { name = "Crazy Runner", assetId = 2125501810, badgeClass = "grinding" },
	IronMan = {
		name = "Iron Man Runner",
		assetId = 2125470138,
		badgeClass = "grinding",
		hint = "Only a mad lad would run this long, so many times",
	},
	Triathlon = {
		name = "Triathlon",
		assetId = 2125647287,
		badgeClass = "grinding",
	},
	Poggod = {
		name = "Found POGGOD!",
		assetId = 2124935169,
		badgeClass = "weird",
		hint = "You always knew you were special",
	},
	Chomik = { name = "Chomik", assetId = 2125445524, badgeClass = "weird", hint = "Find me: /chomik" },
	Hurdle = { name = "Run the hurdles!", assetId = 2142445246, badgeClass = "weird" },
	TerrainObby = {
		name = "Terrain Obby",
		assetId = 2125786190,
		badgeClass = "weird",
		hint = "Find the Obbys",
	},
	FirstEmpire = {
		name = "First Empire",
		assetId = 2126158377,
		badgeClass = "weird",
		hint = "He crowned himself",
	},
	TrainParkour = {
		name = "TrainParkour",
		assetId = 2126162027,
		badgeClass = "weird",
		hint = "Terrain Parklore",
	},
	CrowdedHouse = {
		name = "Crowded House",
		assetId = 2126471608,
		badgeClass = "server",
		hint = "You can't do it alone",
	},
	AncientHouse = {
		name = "Ancient House",
		assetId = 2126639210,
		badgeClass = "server",
		hint = "time",
	},
	ThisOldHouse = {
		name = "This Old House",
		assetId = 2126491241,
		badgeClass = "server",
		hint = "time",
	},
	MegaHouse = {
		name = "Mega House",
		assetId = 2126491228,
		badgeClass = "server",
		hint = "You really can't do it alone",
	},
	GoldContest = {
		name = "Gold Contest Winner",
		assetId = 2126471605,
		badgeClass = "special contest",
		hint = "Won a special contest! Congratulations to you. This is also worth 1111 tix.",
		order = 2,
	},
	SilverContest = {
		name = "Silver Contest Winner",
		assetId = 2126471601,
		badgeClass = "special contest",
		hint = "got 2nd prize in one of the weekly contests. Also worth 555 tix.",
		order = 1,
	},
	SignOriginLoreResearcher = {
		name = "Sign Origin Lore Researcher",
		assetId = 2129066972,
		badgeClass = "special",
		hint = "Delving into sign lore",
	},
	BronzeContest = {
		name = "Bronze Contest Winner",
		assetId = 2126471599,
		badgeClass = "special contest",
		hint = "got 3rd prize in one of the weekly contests. Also worth 333 tix.",
		order = 0,
	},
	FirstContestParticipation = {
		name = "First Contest Participation",
		assetId = 2126471603,
		badgeClass = "special contest",
		hint = "Participated in the first contest, May 21 2022. Worth 111 tix.",
		order = 5,
	},
	SecondContestParticipation = {
		name = "Second Contest Participation",
		assetId = 2126713768,
		badgeClass = "special contest",
		hint = "Participated in the Second contest, June 11 2022. Worth 111 tix.",
		order = 6,
	},

	--participated in any contest by completing all runs
	ContestParticipation = {
		name = "Contest Participation",
		assetId = 2126491230,
		badgeClass = "special contest",
		hint = "Participated in an contest. Worth 111 tix.",
		order = 7,
	},

	--be in the "best" slot for a contest
	LeadContest = {
		name = "Has led a running contest",
		assetId = 2126491237,
		badgeClass = "special contest",
		hint = "Participated in an contest. Worth 111 tix.",
		order = 9,
	},
	Hieroglyph = {
		name = "Hieroglyph",
		assetId = 2126491233,
		badgeClass = "weird",
	},
	ScottishNoah = {
		name = "Scottish Noah",
		assetId = 2125857717,
		badgeClass = "weird",
	},
	LandscapeAcrobatics = {
		name = "Landscape Acrobatics",
		assetId = 2126801968,
		badgeClass = "weird",
	},
	Royalty = {
		name = "Royalty",
		assetId = 2126743612,
		badgeClass = "weird",
	},
	Orthography = {
		name = "Orthography",
		assetId = 2126338129,
		badgeClass = "weird",
		hint = "Run between any two SPECIAL signs.",
	},
	RobloxStudio = {
		name = "Roblox Studio",
		assetId = 2126338127,
		badgeClass = "weird",
	},
	Unicode = {
		name = "Unicode",
		assetId = 2126158374,
		badgeClass = "weird",
		hint = "Run between the first two unicode signs.",
	},
	MaxFind = {
		name = "Max Finds",
		assetId = 2125786178,
		badgeClass = "finds",
		hint = "Have found all signs.",
	},
	HalfFind = {
		name = "Half Find",
		assetId = 2125786184,
		badgeClass = "finds",
		hint = "have found half of all available signs.",
	},
	UnoFind = {
		name = "UnoFind",
		assetId = 2125786187,
		badgeClass = "finds",
		hint = "have found all but one signs.",
	},
	FindLeader = {
		name = "Find Leader",
		assetId = 2125786189,
		badgeClass = "finds",
		hint = "have the most finds of anybody.",
	},
	PiDayRun = {
		name = "Pie Run",
		assetId = 2142445256,
		badgeClass = "time",
		hint = "Loops",
	},
	SuperLow = {
		name = "Super Low",
		assetId = 2142445252,
		badgeClass = "special sign",
	},
	YearRun = {
		name = "Year Run",
		assetId = 2125812044,
		badgeClass = "time",
		hint = "How long is a year?",
	},

	YearRunMilliseconds = {
		name = "Year Milliseconds Run",
		assetId = 2142445262,
		badgeClass = "time",
		hint = "How long is a year in milliseconds?",
	},
	LunaFecha = {
		name = "Luna Fecha",
		assetId = 2126239398,
		badgeClass = "time",
		hint = "Concordance of day and month",
	},
	TripleContemporaneous = {
		name = "Triple Contemporaneous",
		assetId = 2129122989,
		badgeClass = "time",
		hint = "Ternary Identity",
	},
	Midnight = {
		name = "Midnight",
		assetId = 2125812045,
		badgeClass = "time",
		hint = "Dangerous to be alone at midnight",
	},

	FiftyNine = {
		name = "Fifty Nine",
		assetId = 2126239392,
		badgeClass = "time",
	},
	SpecialTime = {
		name = "Run at a Special Time",
		assetId = 2126239389,
		badgeClass = "time",
		hint = "Some things make you do a double take",
	},
	Minute = {
		name = "Minute",
		assetId = 2126239384,
		badgeClass = "time",
	},
	TimeAndSpace = {
		name = "Time and Space",
		assetId = 2125579606,
		badgeClass = "time",
		hint = "Matter, distance, time, energy - all forms of the same thing.",
	},
	TimeAndSpaceLargeScale = {
		name = "Time and Space Large Scale Equality",
		assetId = 2125579605,
		badgeClass = "time",
		hint = "And everybody was finally equal.",
	},
	SciFiRun = {
		name = "Science Fiction Run!",
		assetId = 2125445664,
		badgeClass = "weird",
		hint = "This mission is too important for me to allow you to jeopardize it.",
	},
	SuperSlowRun = { name = "Super Slow Run!", assetId = 2125445673, badgeClass = "weird" },
	LongFall = { name = "Long Fall!", assetId = 2125445695, badgeClass = "long run", order = 10 },
	LongClimb = { name = "Long Climb!", assetId = 2125445694, badgeClass = "long run", order = 20 },
	LongRun = { name = "Long Run!", assetId = 2125445527, badgeClass = "long run", order = 30 },
	VeryLongRun = { name = "Very Long Run!", assetId = 2125445674, badgeClass = "long run", order = 40 },
	HyperLongRun = {
		name = "Hyper Long Run!",
		assetId = 2125445676,
		badgeClass = "long run",
		hint = "definitely unpossible",
		order = 50,
	},
	MegaLongRun = {
		name = "Mega Long Run!",
		assetId = 2125445690,
		badgeClass = "long run",
		hint = "possible-ish",
		order = 80,
	},
	ExtremeLongRun = {
		name = "Extreme Long Run!",
		assetId = 2125445691,
		badgeClass = "long run",
		hint = "Not possible, never possible",
		order = 100,
	},
	CompetitiveLongRun = {
		name = "Run Competitive Long Run!",
		assetId = 2125445668,
		badgeClass = "long run",
		order = 105,
	},
	WinCompetitiveLongRun = {
		name = "Win Competitive Long Run!",
		assetId = 2125445670,
		badgeClass = "long run",
		order = 110,
	},
	Run333 = {
		name = "Do a .333 run!",
		assetId = 2125647289,
		badgeClass = "time",
		hint = "because you asked",
		order = 10,
	},
	Run555 = { name = "Do a .555 run!", assetId = 2124922253, badgeClass = "time", order = 20 },
	Run777 = { name = "Do a .777 run!", assetId = 2124922252, badgeClass = "time", order = 30 },
	Run999 = { name = "Do a .999 run!", assetId = 2125445692, badgeClass = "time", order = 40 },
	CountVonCount = { name = "Count Von Count", assetId = 2126075995, badgeClass = "time", hint = "Ah-Ah-Ah!" },

	RoundRun = { name = "Do a round run!", assetId = 2124922251, badgeClass = "weird" },
	LoseBy001 = { name = "Lose by 0.001s!", assetId = 2124935509, badgeClass = "weird" },
	WinBy001 = { name = "Win by 0.001s!", assetId = 2124922216, badgeClass = "weird" },
	TieForFirst = { name = "Tie For First! Sorry!", assetId = 2124922217, badgeClass = "weird" },
	WinstonSmith = { name = "Winston S####", assetId = 2126158371, badgeClass = "weird" },

	CmdLine = { name = "Used Cmd Line!", assetId = 872955307, badgeClass = "meta", hint = "true power." },
	Secret = { name = "Secret!", assetId = 872952358, badgeClass = "meta", hint = "can you command the secret?" },
	UndocumentedCommand = {
		name = "Undocumented Command",
		assetId = 2126239401,
		badgeClass = "meta",
		hint = "Hacker!",
	},
	MetCreator = { name = "Met the Creator", assetId = 872951054, badgeClass = "meta" },
	BadgeFor100Badges = { name = "Got 100 Badges", assetId = 2126075986, badgeClass = "meta" },
	BumpedCreator = {
		name = "Bumped into the Creator!",
		assetId = 872962949,
		badgeClass = "meta",
		hint = "not working. hmm.",
	},

	EliteRun = {
		name = "Elite Run!",
		assetId = 2125445666,
		badgeClass = "elite",
		hint = "are you 1337 enough?",
		order = 10,
	},
	DoubleEliteRun = { name = "Double Elite Run!", assetId = 2129122990, badgeClass = "elite", order = 20 },
	WinEliteRun = { name = "Win Elite Run!", assetId = 2125445675, badgeClass = "elite", order = 30 },

	WinCompetitiveRun = {
		name = "Win Competitive Run!",
		assetId = 2125445672,
		badgeClass = "cwrs",
		hint = "A sign which has at least 10 runners.",
		order = 20,
	},

	ThreeHundredTix = { name = "Earned 300 Tix!", assetId = 2125246193, badgeClass = "tix", baseNumber = 300 },
	ThousandTix = { name = "Earned 1000 Tix!", assetId = 2124922226, badgeClass = "tix", baseNumber = 1000 },
	ThreeThousandTix = { name = "Earned 3000 Tix!", assetId = 2125246197, badgeClass = "tix", baseNumber = 3000 },
	SevenThousandTix = { name = "Earned 7000 Tix!", assetId = 2125246199, badgeClass = "tix", baseNumber = 7000 },
	Tix14k = { name = "Earned 14000 Tix!", assetId = 2125812043, badgeClass = "tix", baseNumber = 14000 },
	Tix25k = { name = "Earned 25000 Tix!", assetId = 2125812049, badgeClass = "tix", baseNumber = 25000 },
	Tix49k = { name = "Earned 49000 Tix!", assetId = 2125812050, badgeClass = "tix", baseNumber = 49000 },
	Tix99k = { name = "Earned 99999 Tix!", assetId = 2129122995, badgeClass = "tix", baseNumber = 99999 },

	NewRace = { name = "Found Race!", assetId = 872951314, badgeClass = "play" },
	LeadSign = { name = "Lead a sign!", assetId = 2124940185, badgeClass = "play" },
	LeadCompetitiveSign = { name = "Lead a competitive sign!", assetId = 2124940186, badgeClass = "play" },

	LeadCompetitiveRace = {
		name = "Lead a competitive race!",
		assetId = 2128372871,
		badgeClass = "cwrs",
		baseNumber = 1,
	},
	Lead10CompetitiveRace = {
		name = "Lead 10 competitive races!",
		assetId = 2128372874,
		badgeClass = "cwrs",
		baseNumber = 10,
	},
	Lead50CompetitiveRace = {
		name = "Lead 50 competitive races!",
		assetId = 2128372867,
		badgeClass = "cwrs",
		baseNumber = 50,
	},
	Lead250CompetitiveRace = {
		name = "Lead 250 competitive races!",
		assetId = 2128372866,
		badgeClass = "cwrs",
		baseNumber = 250,
	},
	Lead1000CompetitiveRace = {
		name = "Lead 1000 competitive races!",
		assetId = 2126743610,
		badgeClass = "cwrs",
		baseNumber = 1000,
	},

	SignWrs5 = { name = "5 sign WRs!", assetId = 2124940187, badgeClass = "sign wrs", order = 1 },
	SignWrs10 = { name = "10 sign WRs!", assetId = 2124940188, badgeClass = "sign wrs", order = 20 },
	SignWrs20 = { name = "20 sign WRs!", assetId = 2124940189, badgeClass = "sign wrs", order = 30 },
	SignWrs50 = { name = "50 sign WRs!", assetId = 2124940190, badgeClass = "sign wrs", order = 40 },
	SignWrs100 = { name = "100 sign WRs!", assetId = 2124940191, badgeClass = "sign wrs", order = 50 },
	SignWrs200 = { name = "200 sign WRs!", assetId = 2124940192, badgeClass = "sign wrs", order = 60 },
	SignWrs300 = { name = "300 sign WRs!", assetId = 2124940193, badgeClass = "sign wrs", order = 70 },
	SignWrs500 = { name = "500 sign WRs!", assetId = 2124940194, badgeClass = "sign wrs", order = 80 },
	SignWrsFeo = { name = "Feo sign WRs!", assetId = 2124940497, badgeClass = "sign wrs", order = 90 },
	SignWrs800 = { name = "800 sign WRs!", assetId = 2125857715, badgeClass = "sign wrs", order = 100 },
	SignWrs900 = { name = "900 sign WRs!", assetId = 2129066975, badgeClass = "sign wrs", order = 110 },
	SignWrs1000 = { name = "1000 sign WRs! Hyper memorial", assetId = 2129037605, badgeClass = "sign wrs", order = 120 },
	SignWrs1200 = { name = "1200 sign WRs!", assetId = 2129066971, badgeClass = "sign wrs", order = 130 },
	SignWrs1500 = { name = "1500 sign WRs!", assetId = 2129066970, badgeClass = "sign wrs", order = 140 },
	Olympics = { name = "Olympics!", assetId = 2128933898, badgeClass = "weird" },

	MarathonCompletionAlphaLetters = {
		name = "Complete Alpha all letter Marathon!",
		assetId = 2125027162,
		badgeClass = "marathon",
	},
	MarathonCompletionAlphaReverse = {
		name = "Complete Alpha reverse Marathon!",
		assetId = 2125027166,
		badgeClass = "marathon",
	},
	MarathonCompletionAlphaOrdered = {
		name = "Complete Alpha fixed Marathon!",
		assetId = 2125027171,
		badgeClass = "marathon",
	},
	MarathonCompletionAlphaFree = {
		name = "Complete Alpha free order Marathon!",
		assetId = 2125027175,
		badgeClass = "marathon",
	},
	MarathonCompletionFindEveryLength = {
		name = "Complete Find signs by length Marathon!",
		assetId = 2125501806,
		badgeClass = "marathon",
	},
	MarathonCompletionEvolution = {
		name = "Complete Evolution Marathon!",
		assetId = 2125579602,
		badgeClass = "marathon",
	},
	MarathonCompletionLegacy = {
		name = "Complete Legacy Marathon!",
		assetId = 2125647286,
		badgeClass = "marathon",
	},
	MarathonCompletionCave = {
		name = "Complete Cave Marathon!",
		assetId = 2125579603,
		badgeClass = "marathon",
	},
	MarathonCompletionThreeLetter = {
		name = "Complete Three Letter Marathon!",
		assetId = 2129133096,
		badgeClass = "marathon",
	},
	MarathonCompletionAOfB = {
		name = "Complete AOfB Marathon!",
		assetId = 2125579604,
		badgeClass = "marathon",
	},
	MarathonCompletionSingleLetter = {
		name = "Complete Single Letter Marathon!",
		assetId = 2125647282,
		badgeClass = "marathon",
	},
	MarathonCompletionFind10 = {
		name = "Complete Find 10 sign Marathon!",
		assetId = 2125027207,
		badgeClass = "marathon",
		order = 10,
	},
	MarathonCompletionFind20 = {
		name = "Complete Find 20 sign Marathon!",
		assetId = 2125027201,
		badgeClass = "marathon",
		order = 20,
	},
	MarathonCompletionFind40 = {
		name = "Complete Find 40 sign Marathon!",
		assetId = 2125027198,
		badgeClass = "marathon",
		order = 40,
	},
	MarathonCompletionFind100 = {
		name = "Complete Find 100 sign Marathon!",
		assetId = 2125027190,
		badgeClass = "marathon",
		order = 100,
	},
	MarathonCompletionFind200 = {
		name = "Complete Find 200 sign Marathon!",
		assetId = 2125027186,
		badgeClass = "marathon",
		order = 200,
	},
	MarathonCompletionFind300 = {
		name = "Complete Find 300 sign Marathon!",
		assetId = 2125501812,
		badgeClass = "marathon",
		order = 300,
	},
	MarathonCompletionFind380 = {
		name = "Complete Find 380 sign Marathon!",
		assetId = 2125501813,
		badgeClass = "marathon",
		order = 380,
	},
	MarathonCompletionFind500 = {
		name = "Complete Find 500 sign Marathon!",
		assetId = 2129122996,
		badgeClass = "marathon",
		order = 500,
	},
	MarathonCompletionFind10T = {
		name = "Complete Find 10 T* Marathon!",
		assetId = 2125027178,
		badgeClass = "marathon",
		order = 1000,
	},
	MarathonCompletionFind10S = {
		name = "Complete Find 10 S* Marathon!",
		assetId = 2125027183,
		badgeClass = "marathon",
		order = 1010,
	},
	MarathonCompletionExactly40 = {
		name = "Complete Exactly 40 Marathon!",
		assetId = 2125579608,
		badgeClass = "marathon",
		order = 1040,
	},
	MarathonCompletionExactly100 = {
		name = "Complete Exactly 100 Marathon!",
		assetId = 2125579610,
		badgeClass = "marathon",
		order = 1100,
	},
	MarathonCompletionExactly200 = {
		name = "Complete Exactly 200 Marathon!",
		assetId = 2125579611,
		badgeClass = "marathon",
		order = 1100,
	},
	MarathonCompletionExactly500 = {
		name = "Complete Exactly 500 Marathon!",
		assetId = 2125579613,
		badgeClass = "marathon",
		order = 1500,
	},
	MarathonCompletionExactly1000 = {
		name = "Complete Exactly 1000 Marathon!",
		assetId = 2125579614,
		badgeClass = "marathon",
		order = 2000,
	},

	FoundThree = { name = "Found Three Signs!", assetId = 872955550, badgeClass = "finds", baseNumber = 3 },
	FoundNine = { name = "Found Nine Signs!", assetId = 872955722, badgeClass = "finds", baseNumber = 9 },
	FoundEighteen = { name = "Found Eighteen Signs!", assetId = 872961733, badgeClass = "finds", baseNumber = 18 },
	FoundTwentySeven = { name = "Found Twenty-seven!", assetId = 872955855, badgeClass = "finds", baseNumber = 27 },
	FoundThirtySix = { name = "Found Thirty-six Signs!", assetId = 872956177, badgeClass = "finds", baseNumber = 36 },
	FoundFifty = { name = "Found Fifty Signs!", assetId = 872962526, badgeClass = "finds", baseNumber = 50 },
	FoundSeventy = { name = "Found Seventy Signs!", assetId = 872956331, badgeClass = "finds", baseNumber = 70 },
	FoundNinetyNine = { name = "Found 99 Signs!", assetId = 872956479, badgeClass = "finds", baseNumber = 99 },
	FoundHundredTwenty = { name = "Found 120 Signs!", assetId = 1516513278, badgeClass = "finds", baseNumber = 120 },
	FoundHundredForty = { name = "Found 140 Signs!", assetId = 1516513910, badgeClass = "finds", baseNumber = 140 },
	FoundTwoHundred = { name = "Found 200 Signs!", assetId = 2124922227, badgeClass = "finds", baseNumber = 200 },
	FoundThreeHundred = { name = "Found 300 Signs!", assetId = 2124922228, badgeClass = "finds", baseNumber = 300 },
	FoundFourHundred = {
		name = "Found 400 Signs!",
		assetId = 2125246190,
		badgeClass = "finds",
		baseNumber = 400,
		hint = "Take time to deliberate, but when the time for action has arrived, stop thinking and go in.",
	},
	FoundFourHundredFifty = {
		name = "Found 450 Signs!",
		assetId = 2126713767,
		badgeClass = "finds",
		baseNumber = 450,
		hint = "",
	},
	FoundFiveHundred = {
		name = "Found 500 Signs!",
		assetId = 2126713764,
		badgeClass = "finds",
		baseNumber = 500,
		hint = "",
	},
	FoundFiveHundredFifty = {
		name = "Found 550 Signs!",
		assetId = 2126713765,
		badgeClass = "finds",
		baseNumber = 550,
		hint = "",
	},

	--WorldRecord={name="World Record!", assetId=745087242},

	TenTop10s = {
		name = "You Got Ten Top Ten Finishes!",
		assetId = 872953049,
		badgeClass = "top10s",
		baseNumber = 10,
	},
	HundredTop10s = {
		name = "You Got 100 Top Ten Finishes!",
		assetId = 872953669,
		badgeClass = "top10s",
		baseNumber = 100,
	},
	ThousandTop10s = {
		name = "You Got 1000 Top Ten Finishes!",
		assetId = 2124922231,
		badgeClass = "top10s",
		baseNumber = 1000,
	},
	TenkTop10s = {
		name = "You Got 10k Top Ten Finishes!",
		assetId = 2129122994,
		badgeClass = "top10s",
		baseNumber = 10000,
	},

	FirstFinderOfSign = { name = "First Finder of Sign", assetId = 2126075987, badgeClass = "finds", order = 1000 },
	FifthFinderOfSign = { name = "Fifth Finder of Sign", assetId = 2126083209, badgeClass = "finds", order = 1100 },
	HundredthFinderOfSign = {
		name = "Hundredth Finder of Sign",
		assetId = 2126639209,
		badgeClass = "finds",
		order = 1200,
	},

	FiveWrs = { name = "Five World Records!", assetId = 872951844, badgeClass = "wrs", baseNumber = 5 },
	TwentyFiveWrs = { name = "Twenty Five World Records!", assetId = 872952726, badgeClass = "wrs", baseNumber = 25 },
	FiftyWrs = { name = "Fifty World Records!", assetId = 872954197, badgeClass = "wrs", baseNumber = 50 },
	NinetyNineWrs = { name = "99 World Records!", assetId = 872954653, badgeClass = "wrs", baseNumber = 99 },
	TwoHundredFiftyWrs = {
		name = "Two Hundred and Fifty World Records!",
		assetId = 872954976,
		badgeClass = "wrs",
		baseNumber = 250,
		hint = "The first virtue in a soldier is endurance of fatigue; courage is only the second virtue.",
	},
	FiveHundredWrs = {
		name = "Five Hundred World Records!",
		assetId = 2124922229,
		badgeClass = "wrs",
		baseNumber = 500,
		hint = "There is only one step from the sublime to the ridiculous.",
	},
	ThousandWrs = {
		name = "A thousand World Records!",
		assetId = 2124922230,
		badgeClass = "wrs",
		baseNumber = 1000,
		hint = "Impossible is a word to be found only in the dictionary of fools.",
	},
	TwokWrs = {
		name = "2k World Records!",
		assetId = 2125445445,
		badgeClass = "wrs",
		baseNumber = 2000,
		hint = "The human race is governed by its imagination.",
	},
	FourkWrs = {
		name = "4k World Records!",
		assetId = 2125445446,
		badgeClass = "wrs",
		baseNumber = 4000,
		hint = "Ability has nothing to do with opportunity.",
	},
	EightkWrs = {
		name = "8k World Records!",
		assetId = 2125445450,
		badgeClass = "wrs",
		baseNumber = 8000,
		hint = "Death is nothing, but to live defeated and inglorious is to die daily.",
	},
	SixteenkWrs = {
		name = "16k World Records!",
		assetId = 2125445477,
		badgeClass = "wrs",
		baseNumber = 16000,
		hint = "A soldier will fight long and hard for a bit of colored ribbon.",
	},
	ThirtyTwokWrs = {
		name = "32k World Records!",
		assetId = 2125445479,
		badgeClass = "wrs",
		baseNumber = 32000,
		hint = "Thou shalt not make a machine in the likeness of a man's mind",
	},

	TotalRaceCount1 = { name = "Total Races Found: 3", assetId = 1502433607, badgeClass = "races", baseNumber = 3 },
	TotalRaceCount2 = { name = "Total Races Found: 13", assetId = 1502481555, badgeClass = "races", baseNumber = 13 },
	TotalRaceCount3 = { name = "Total Races Found: 31", assetId = 1502481796, badgeClass = "races", baseNumber = 31 },
	TotalRaceCount4 = {
		name = "Total Races Found: 113",
		assetId = 1502482584,
		badgeClass = "races",
		baseNumber = 113,
	},
	TotalRaceCount5 = {
		name = "Total Races Found: 311",
		assetId = 1502482832,
		badgeClass = "races",
		baseNumber = 311,
	},
	TotalRaceCount6 = {
		name = "Total Races Found: 1331",
		assetId = 1502483091,
		badgeClass = "races",
		baseNumber = 1331,
	},
	TotalRaceCount7 = {
		name = "Total Races Found: 3113",
		assetId = 1502483375,
		badgeClass = "races",
		baseNumber = 3113,
	},
	TotalRaceCount8 = {
		name = "Total Races Found: 13131",
		assetId = 1502483632,
		badgeClass = "races",
		baseNumber = 13131,
	},
	TotalRaceCount9 = {
		name = "Total Races Found: 33333",
		assetId = 1502483910,
		badgeClass = "races",
		baseNumber = 33333,
	},
	TotalRaceCount10 = {
		name = "Total Races Found: 131313",
		assetId = 2125445482,
		badgeClass = "races",
		baseNumber = 131313,
	},

	TotalRunCount1 = { name = "Total Run Count: 2", assetId = 1502414005, badgeClass = "runs", baseNumber = 2 },
	TotalRunCount2 = { name = "Total Run Count: 6", assetId = 1502414485, badgeClass = "runs", baseNumber = 6 },
	TotalRunCount3 = { name = "Total Run Count: 26", assetId = 1502415066, badgeClass = "runs", baseNumber = 26 },
	TotalRunCount4 = { name = "Total Run Count: 62", assetId = 1502415483, badgeClass = "runs", baseNumber = 62 },
	TotalRunCount5 = { name = "Total Run Count: 226", assetId = 1502415976, badgeClass = "runs", baseNumber = 226 },
	TotalRunCount6 = { name = "Total Run Count: 622", assetId = 1502416881, badgeClass = "runs", baseNumber = 622 },
	TotalRunCount7 = { name = "Total Run Count: 2226", assetId = 1502417194, badgeClass = "runs", baseNumber = 2226 },
	TotalRunCount8 = {
		name = "Total Run Count: 6222",
		assetId = 1502417840,
		badgeClass = "runs",
		baseNumber = 6222,
		hint = "Victory belongs to the most persevering.",
	},
	TotalRunCount9 = {
		name = "Total Run Count: 22666",
		assetId = 1502418992,
		badgeClass = "runs",
		baseNumber = 22666,
		hint = "History is a set of lies agreed upon.",
	},
	TotalRunCount10 = {
		name = "Total Run Count: 66222",
		assetId = 2125246373,
		badgeClass = "runs",
		baseNumber = 66222,
		hint = "Glory is fleeting, but obscurity is forever.",
	},
	TotalRunCount11 = {
		name = "Total Run Count: 222666",
		assetId = 2125445441,
		badgeClass = "runs",
		baseNumber = 222666,
		hint = "If you want a thing done well, do it yourself.",
	},
	PlacedInServerEvent = {
		name = "Placed In Server Event",
		assetId = 2126801969,
		badgeClass = "server events",
		order = 10,
	},
	PrizeInServerEvent = {
		name = "Prize In Server Event",
		assetId = 2126801967,
		badgeClass = "server events",
		order = 20,
	},
	BigPrizeInServerEvent = {
		name = "Big Prize In Server Event",
		assetId = 2126801966,
		badgeClass = "server events",
		order = 30,
	},
	HugePrizeInServerEvent = {
		name = "Huge Prize In Server Event",
		assetId = 2126801965,
		badgeClass = "server events",
		order = 40,
	},
	MegaPrizeInServerEvent = {
		name = "Mega Prize In Server Event",
		assetId = 2126743614,
		badgeClass = "server events",
		order = 50,
	},
	ExceptionalPrizeInServerEvent = {
		name = "Exceptional Prize In Server Event",
		assetId = 2142445237,
		badgeClass = "server events",
		order = 100,
	},

	CompeteInCompetitiveServerEvent = {
		name = "Compete In Competitive Server Event",
		assetId = 2126743613,
		badgeClass = "server events",
		order = 150,
	},
	CompeteInLongCompetitiveServerEvent = {
		name = "Compete In Long Competitive Server Event",
		assetId = 2126639211,
		badgeClass = "server events",
		order = 160,
	},
	WinCompetitiveServerEvent = {
		name = "Win Competitive Server Event",
		assetId = 2126743611,
		badgeClass = "server events",
		order = 170,
	},
	WinLongCompetitiveServerEvent = {
		name = "Win Long Competitive Server Event",
		assetId = 2126639215,
		badgeClass = "server events",
		order = 180,
	},
	Heinlein = {
		name = "Robert H",
		assetId = 2128983603,
		badgeClass = "weird",
		hint = "Starship T",
	},
	MetricSystem = {
		name = "Metric System",
		assetId = 2128933909,
		badgeClass = "weird",
		hint = "unification",
	},
	Multiple = {
		name = "Multiple",
		assetId = 2129020813,
		badgeClass = "weird",
		order = 10,
		hint = "special sign",
	},
	LeadFromTriple = {
		name = "Lead From Triple",
		assetId = 2129020814,
		badgeClass = "special sign",
		order = 20,
	},
	LeadFromQuadruple = {
		name = "Lead From Quadruple",
		assetId = 2129020815,
		badgeClass = "special sign",
		order = 30,
	},
	LeadFromHypergravity = {
		name = "Lead From Hypergravity",
		assetId = 2128983641,
		badgeClass = "special sign",
		order = 40,
	},
	LeadFromKeepOffTheGrass = {
		name = "Lead From Keep Off the Grass",
		assetId = 2128932827,
		badgeClass = "special sign",
		hint = "Touchdown avoiding the grass",
		order = 50,
	},

	LeadCwrFromTriple = {
		name = "Lead CWR From Triple",
		assetId = 2129133095,
		badgeClass = "special sign",
		order = 20,
	},
	LeadCwrFromQuadruple = {
		name = "Lead CWR From Quadruple",
		assetId = 2129133094,
		badgeClass = "special sign",
		order = 30,
	},
	LeadCwrFromHypergravity = {
		name = "Lead CWR From Hypergravity",
		assetId = 2129133093,
		badgeClass = "special sign",
		order = 40,
	},
	LeadCwrFromKeepOffTheGrass = {
		name = "Lead CWR From Keep Off the Grass",
		assetId = 2129133089,
		badgeClass = "special sign",
		hint = "Touchdown avoiding the grass",
		order = 50,
	},

	FloorExplorer = {
		name = "Floor Explorer",
		assetId = 2129020809,
		badgeClass = "weird",
		order = 50,
	},
	MegaFloorExplorer = {
		name = "Mega Floor Explorer",
		assetId = 2128983661,
		badgeClass = "weird",
		order = 60,
	},
	MegaFloorExplorerWinner = {
		name = "Mega Floor Explorer Winner",
		assetId = 2128932825,
		badgeClass = "weird",
		order = 80,
	},

	TakeSurvey = {
		name = "Take Survey",
		assetId = 2128983659,
		badgeClass = "weird",
		hint = "We're up in a balloon\nwith so many beliefs to be shattered\nour voices quaver",
	},
	SurveyKing = {
		name = "Survey King",
		assetId = 2128983652,
		badgeClass = "weird",
	},
	Beckoner = {
		name = "Beckoner",
		assetId = 2128372864,
		badgeClass = "special",
		hint = "Something like a drifting swarm of bees.",
	},
	HideSeek = {
		name = "Olly olly oxen free",
		assetId = 2129037622,
		badgeClass = "weird",
		hint = "",
	},
	FirstBadgeWinner = {
		name = "First badge winner badge",
		assetId = 2129037608,
		badgeClass = "weird",
		hint = "",
	},
	NorthernVillages = {
		name = "Northern Villages",
		assetId = 2129037607,
		badgeClass = "weird",
		hint = "",
	},
}

module.badges = badges

_annotate("end")
return module
