--!strict

--enums for usersetting domain and setting names.  gradually expand this.
-- this is the shareable replicateStorage version. client's cant directly require the actual server module userSettings.

local annotater = require(game.ReplicatedStorage.util.annotater)
local _annotate = annotater.getAnnotater(script)

local module = {}

-- leaderboard settings: portrait, username, awards, tix, finds, rank, cwrs, cwrtop10s, wrs, top10s, races, runs, badges

local settingNames: { [string]: string } = {
	ROTATE_PLAYER_ON_WARP_WHEN_DESTINATION = "when you're warping with an implied destination, rotate your avatar and camera to face the direction",
	ENABLE_DYNAMIC_RUNNING = "enable dynamic running",
	HIDE_LEADERBOARD = "hide leaderboard",
	SHORTEN_CONTEST_DIGIT_DISPLAY = "shorten contest digit display",
	X_BUTTON_IGNORES_CHAT = "x button ignores chat",
	HIGHLIGHT_ON_RUN_COMPLETE_WARP = "do sign highlight when you click warp on a complete run",
	HIGHLIGHT_ON_KEYBOARD_1_TO_WARP = "do sign highlight when you hit 1 to warp to the completed run",
	HIGHLIGHT_AT_ALL = "do any sign highlighting at all, for example when warping to a server event run",
	LEADERBOARD_ENABLE_PORTRAIT = "show portrait",
	LEADERBOARD_ENABLE_USERNAME = "show username",
	LEADERBOARD_ENABLE_AWARDS = "show awards",
	LEADERBOARD_ENABLE_TIX = "show tix",
	LEADERBOARD_ENABLE_FINDS = "show finds",
	LEADERBOARD_ENABLE_FINDRANK = "show find rank",
	LEADERBOARD_ENABLE_WRRANK = "show wr rank",
	LEADERBOARD_ENABLE_CWRS = "show cwrs",
	LEADERBOARD_ENABLE_WRS = "show wrs",
	LEADERBOARD_ENABLE_CWRTOP10S = "show cwrtop10s",
	LEADERBOARD_ENABLE_TOP10S = "show top10s",
	LEADERBOARD_ENABLE_RACES = "show races",
	LEADERBOARD_ENABLE_RUNS = "show runs",
	LEADERBOARD_ENABLE_BADGES = "show badges",
	SHOW_PARTICLES = "show particles",
}

module.settingNames = settingNames

local settingDomains: { [string]: string } = {
	SURVEYS = "Surveys",
	MARATHONS = "Marathons",
	USERSETTINGS = "UserSettings",
	LEADERBOARD = "Leaderboard",
}

module.settingDomains = settingDomains

--this system fails when i add one here but don't create the userSetting in the db.
-- I should have a way to automatically at least do a getOrCreate there, like I do with signs.

export type settingRequest = { domain: string?, settingName: string?, includeDistributions: boolean }

_annotate("end")
return module
