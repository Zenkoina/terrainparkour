--!strict

-- marathonStatic. 2024 Not sure why this is organized this way.
local annotater = require(game.ReplicatedStorage.util.annotater)
local _annotate = annotater.getAnnotater(script)

local module = {}

local colors = require(game.ReplicatedStorage.util.colors)
local mt = require(game.StarterPlayer.StarterPlayerScripts.marathonTypes)
local guiUtil = require(game.ReplicatedStorage.gui.guiUtil)

-------NAMES----------
module.GetMarathonKindFrameName = function(desc: mt.marathonDescriptor): string
	local targetName = "MarathonFrame_" .. desc.highLevelType .. "_" .. desc.sequenceNumber
	return targetName
end

--for a given component (chip in the attainment list for a marathon), get a name.
--this is so creators and later finders can genericize.
module.getMarathonComponentName = function(desc: mt.marathonDescriptor, componentKey: string): string
	local targetName = "Chip_" .. desc.kind .. "_" .. componentKey
	return targetName
end

module.getTimeTileName = function(desc: mt.marathonDescriptor)
	local targetName = "xx-TimeTile" .. desc.kind
	return targetName
end

-----------LOOKUPS-------------
module.alphaKeys = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
}

module.alphaKeysReverse = {
	"z",
	"y",
	"x",
	"w",
	"v",
	"u",
	"t",
	"s",
	"r",
	"q",
	"p",
	"o",
	"n",
	"m",
	"l",
	"k",
	"j",
	"i",
	"h",
	"g",
	"f",
	"e",
	"d",
	"c",
	"b",
	"a",
}

--its important to use the module naming method to get the name because
--that will be used later to find the way to toggle it on again.
--e.g. make chips for marathon subcomponent achievements
module.makeTileForSubcomponent = function(
	desc: mt.marathonDescriptor,
	key: string,
	xscale: number,
	zindex: number
): TextLabel
	local name = module.getMarathonComponentName(desc, key)
	local fakeParent = Instance.new("Frame")
	local usePadding = desc.chipPadding
	if usePadding == nil then
		usePadding = 0
	end
	local tl = guiUtil.getTl(name, UDim2.new(0, xscale, 1, 0), usePadding, fakeParent, colors.defaultGrey, 1, 0)
	-- tl.Parent.BorderMode = Enum.BorderMode.Outline

	--TODO fix this - override hack because keys are 2digit numbers and for display in this case we want to fix.
	if desc.highLevelType == "signsOfEveryLength" then
		key = tostring(tonumber(key))
		tl.TextScaled = true
	end
	if desc.highLevelType == "findSet" then
		tl.TextScaled = true
	end
	tl.Text = key
	tl.ZIndex = zindex
	return tl.Parent
end

--TODO make X button to just close a marathon from the UI entirely.
module.getMarathonResetTile = function(desc: mt.marathonDescriptor): TextButton
	local resetRes = 30
	local resetTile = Instance.new("TextButton")
	resetTile.Name = "zz-resetTile" .. desc.kind
	resetTile.Text = "R"
	resetTile.TextScaled = true
	resetTile.BackgroundColor3 = colors.redStop
	resetTile.Size = UDim2.new(0, resetRes, 1, 0)
	return resetTile
end

type marathonTileSize = { timeRes: number, resetRes: number, nameRes: number }

--tile pixel sizes.
--very annoying this is not all-in-one combined with marathon descriptor.
--TODO make it so
--TODO also fix badges (if any) to be part of descs.
local alphabeticalSize: marathonTileSize = { timeRes = 35, resetRes = 30, nameRes = 90 }
local findNSizes: marathonTileSize = { timeRes = 35, resetRes = 30, nameRes = 95 }
local randomRaceSizes: marathonTileSize = { timeRes = 35, resetRes = 30, nameRes = 145 }
local signsOfEveryLengthSizes: marathonTileSize = { timeRes = 35, resetRes = 30, nameRes = 95 }
local findSetSizes: marathonTileSize = { timeRes = 35, resetRes = 25, nameRes = 56 }

local marathonSizesByHighlevelType: { [string]: marathonTileSize } = {
	alphabetical = alphabeticalSize,
	findn = findNSizes,
	findnletters = findNSizes,
	randomrace = randomRaceSizes,
	signsOfEveryLength = signsOfEveryLengthSizes,
	findSet = findSetSizes,
}

-- in place, modify current offsetsX to reinterpret them as a proportion of the total width available.
-- in the end, unecessary
local function reconsiderOffsetXInTilesAsScale(tiles: table)
	local totalXOffsetwidth = 0
	for _, tl in ipairs(tiles) do
		if tl.ClassName == "TextLabel" then
			totalXOffsetwidth += tl.Size.X.Offset
		end
	end
	for _, tl in ipairs(tiles) do
		if tl.ClassName == "TextLabel" then
			local scaleProportionXWidth = (tl.Size.X.Offset / totalXOffsetwidth)
			--TODO very strange we need this 0.7 here.
			tl.Size = UDim2.new(scaleProportionXWidth, 0, 1, 0)
		end
	end
	return
end

module.marathonSizesByType = marathonSizesByHighlevelType
--get the toggleable marathon tiles
module.getComponentTilesForKind = function(desc: mt.marathonDescriptor, tiles: { TextLabel }, lbFrameSize: Vector2)
	local sz = module.marathonSizesByType[desc.highLevelType]

	local areaForChips = (lbFrameSize.X - sz.nameRes - sz.timeRes - sz.resetRes)
	if desc.highLevelType == "randomrace" then
		local tls = module.makeTileForSubcomponent(desc, desc.orderedTargets[1], areaForChips / 2, 3)
		table.insert(tiles, tls)

		local tle = module.makeTileForSubcomponent(desc, desc.orderedTargets[2], areaForChips / 2, 4)
		table.insert(tiles, tle)
		error("this is disabled actoually.")
	end

	--types for which we should make a chip for every item in targets or orderedTargets
	if
		desc.highLevelType == "alphabetical"
		or desc.highLevelType == "signsOfEveryLength"
		or desc.highLevelType == "findSet"
	then
		local remainingLetterWidth = areaForChips
		local effectiveTargets = desc.targets
		if #effectiveTargets == 0 then
			effectiveTargets = desc.orderedTargets
		end
		if #effectiveTargets == 0 then
			warn("error in marathon setup.")
			return
		end
		for ii, k in ipairs(effectiveTargets) do
			--if effectiveTargets has nothing?
			local thisWidth = math.ceil(remainingLetterWidth / (#effectiveTargets - ii + 1))
			remainingLetterWidth -= thisWidth
			local tl = module.makeTileForSubcomponent(desc, k, thisWidth, ii + 5)
			table.insert(tiles, tl)
		end
	elseif desc.highLevelType == "findn" or desc.highLevelType == "findnletters" then
		local tl = module.makeTileForSubcomponent(desc, desc.humanName, areaForChips, 6)
		tl.Text = desc.humanName
		tl.Size = UDim2.new(0, areaForChips, 1, 0)
		table.insert(tiles, tl)
	else
		warn("Missed kind in setting up tiles. this will definitely fail.")
	end

	--moved this to inside here.
	local timeTile = Instance.new("TextLabel")
	timeTile.Name = module.getTimeTileName(desc)
	timeTile.Text = ""
	timeTile.AutomaticSize = Enum.AutomaticSize.X
	timeTile.BackgroundColor3 = colors.meColor
	timeTile.TextScaled = true
	timeTile.Size = UDim2.new(0, sz.timeRes, 1, 0)
	timeTile.Font = Enum.Font.Gotham
	desc.timeTile = timeTile

	table.insert(tiles, timeTile)
	-- reconsiderOffsetXInTilesAsScale(tiles)
end

------------END STATIC

_annotate("end")
return module
