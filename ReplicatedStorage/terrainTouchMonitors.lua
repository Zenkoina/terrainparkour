--!strict

--------------- RACING MODULE calls this, it's a singleton per user which is fed all floor changes.
local annotater = require(game.ReplicatedStorage.util.annotater)
local _annotate = annotater.getAnnotater(script)

local movementEnums = require(game.StarterPlayer.StarterPlayerScripts.movementEnums)
local runProgressSgui = require(game.ReplicatedStorage.gui.runProgressSgui)
local textUtil = require(game.ReplicatedStorage.util.textUtil)
local enums = require(game.ReplicatedStorage.util.enums)

local PlayersService = game:GetService("Players")
local localPlayer = PlayersService.LocalPlayer

local avatarEventFiring = require(game.StarterPlayer.StarterPlayerScripts.avatarEventFiring)
local fireEvent = avatarEventFiring.FireEvent
local mt = require(game.ReplicatedStorage.avatarEventTypes)
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid

local module = {}

-------------TRACKING-------------

--boolean if they have touched the floor type at all.
local seenTerrainFloorTypes: { [string]: boolean } = {}

--how many times someone has ever switched TO a floor type
local timesSeenTerrainFloorTypeCounts: { [Enum.Material]: number } = {}
local seenFloorCount = 0
local currentRunSignName = ""
local lastSeenTerrain = nil

--list of the types they've seen.
local allOrderedSeenFloorTypeSet: { [number]: Enum.Material } = {}

local ResetFloorCounts = function()
	seenTerrainFloorTypes = {}
	timesSeenTerrainFloorTypeCounts = {}
	seenFloorCount = 0
	currentRunSignName = ""
	allOrderedSeenFloorTypeSet = {}
	lastSeenTerrain = nil
	runProgressSgui.UpdateOverallDescription("")
	runProgressSgui.UpdateMovementDetails("")
	runProgressSgui.UpdateStartTime(0)
end

module.initTracking = function(signName: string)
	ResetFloorCounts()
	currentRunSignName = signName
	if signName == nil then
		_annotate("make it empty string.")
	end
end

module.GetSeenTerrainTypesThisRun = function(): number
	return seenFloorCount
end

module.CountNewFloorMaterial = function(fm: Enum.Material?)
	--------- VALIDATION -------------
	if currentRunSignName == "" or not currentRunSignName then
		return
	end
	local signOverallTextDescription = enums.SpecialSignDescriptions[currentRunSignName]
	runProgressSgui.UpdateOverallDescription(signOverallTextDescription)
	if fm == nil then
		error("nil touch.")
	end
	if movementEnums.nonMaterialEnumTypes[fm] then
		return
	end
	if not movementEnums.EnumIsTerrain(fm) then
		return
	end

	if fm == lastSeenTerrain then
		return
	end

	--------- COUNTING IT ---------------
	lastSeenTerrain = fm
	_annotate(string.format("Saw Terrain: %s", fm.Name))
	--track raw counts of seeing this terrain floor type
	if not timesSeenTerrainFloorTypeCounts[fm] then
		timesSeenTerrainFloorTypeCounts[fm] = 1
	else
		timesSeenTerrainFloorTypeCounts[fm] = timesSeenTerrainFloorTypeCounts[fm] + 1
	end
	if not seenTerrainFloorTypes[fm.Name] then
		seenTerrainFloorTypes[fm.Name] = true
		seenFloorCount += 1
		table.insert(allOrderedSeenFloorTypeSet, fm)
	end

	------regenerating running race sgui
	if currentRunSignName == "Triple" or currentRunSignName == "Quadruple" then
		local t = {}

		for terrain, n in pairs(seenTerrainFloorTypes) do
			if n then
				table.insert(t, terrain)
			end
		end

		local details = textUtil.stringJoin(", ", t)

		runProgressSgui.UpdateMovementDetails(details)
	elseif currentRunSignName == "cOld mOld on a sLate pLate" then
		local t: { string } = {}
		for a, b in pairs(movementEnums.AllTerrainNames) do
			if seenTerrainFloorTypes[b] then
				continue
			end
			table.insert(t, b)
		end
		local remainingTouchables = textUtil.stringJoin(", ", t)
		local details = string.format("You can still touch: %s", remainingTouchables)
		runProgressSgui.UpdateMovementDetails(details)
	end

	-------- KILLING RUN IF NECESSARY--------------
	if currentRunSignName == "cOld mOld on a sLate pLate" then
		for k, num in pairs(timesSeenTerrainFloorTypeCounts) do
			if num > 1 then
				fireEvent(mt.avatarEventTypes.RUN_KILL, { reason = "cold violation" })
				break
			end
		end
	elseif currentRunSignName == "Keep Off the Grass" then
		if fm == Enum.Material.LeafyGrass or fm == Enum.Material.Grass then
			fireEvent(mt.avatarEventTypes.RUN_KILL, { reason = "Keep off the grass terrainTouch" })
		end
	elseif currentRunSignName == "Triple" then
		if seenFloorCount > 3 then
			fireEvent(mt.avatarEventTypes.RUN_KILL, { reason = "triple terrainTouch" })
		end
	elseif currentRunSignName == "Quadruple" then
		if seenFloorCount > 4 then
			fireEvent(mt.avatarEventTypes.RUN_KILL, { reason = "quadruple terrainTouch" })
		end
	end
end

_annotate("end")
return module
