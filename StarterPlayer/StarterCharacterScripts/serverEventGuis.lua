--!strict
--eval 9.25.22

--drawers for serverEvent rows of LB

local PlayersService = game:GetService("Players")
local localPlayer = PlayersService.LocalPlayer
local enums = require(game.ReplicatedStorage.util.enums)
local tt = require(game.ReplicatedStorage.types.gametypes)
local tpUtil = require(game.ReplicatedStorage.util.tpUtil)
local colors = require(game.ReplicatedStorage.util.colors)
local guiUtil = require(game.ReplicatedStorage.gui.guiUtil)
local thumbnails = require(game.ReplicatedStorage.thumbnails)
local toolTip = require(game.ReplicatedStorage.gui.toolTip)
local serverEventEnums = require(game.ReplicatedStorage.enums.serverEventEnums)
local remotes = require(game.ReplicatedStorage.util.remotes)

local serverEventRowHeight = 60
local doAnnotation = false
doAnnotation = false
local annotationStart = tick()
local function annotate(s: string)
	if doAnnotation then
		print("serverEvents.gui." .. string.format("%.7f", tick() - annotationStart) .. " : " .. s)
	end
end

local module = {}

module.replRun = function(run: tt.runningServerEventUserBest): string
	return tostring(run.userId) .. " - " .. tostring(run.timeMs)
end

module.replServerEvent = function(serverEvent: tt.runningServerEvent): string
	local from = tpUtil.signId2signName(serverEvent.startSignId)
	local to = tpUtil.signId2signName(serverEvent.endSignId)
	return from .. " - " .. to .. " wiht " .. tostring(#serverEvent.userBests) .. " runners"
end

--just re-get the outer lbframe by name.
local function getLbFrame(): Frame
	wait(1) --TODO remove and fix.
	local pl = localPlayer:WaitForChild("PlayerGui")
	local ret = pl:FindFirstChild("LeaderboardFrame", true)
	if ret == nil then
		warn("no lb")
	end
	return ret
end

local function makeTile(el: tt.runningServerEventUserBest, ii: number, isMe: boolean, width: number): Frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(width, 1)
	frame.Name = "02-name-place-tile" .. tostring(ii)
	frame.BorderMode = Enum.BorderMode.Inset
	local hh = Instance.new("UIListLayout")
	hh.Parent = frame
	hh.FillDirection = Enum.FillDirection.Horizontal
	local im = Instance.new("ImageLabel")
	-- im.BorderMode = Enum.BorderMode.Inset
	im.Parent = frame
	im.Size = UDim2.new(0, serverEventRowHeight / 2, 1, 0)
	im.Name = "00-serverEvent-position"

	local content2 = thumbnails.getThumbnailContent(el.userId, Enum.ThumbnailType.HeadShot)
	local useColor = isMe and colors.yellow or colors.defaultGrey

	im.Image = content2
	im.BackgroundColor3 = useColor

	local tl = guiUtil.getTl(
		"01-serverEvent-result-tile" .. tostring(ii),
		UDim2.new(1, -1 * serverEventRowHeight / 2, 1, 0),
		1,
		frame,
		useColor,
		1
	)
	local extra = ""
	if el.runCount > 1 then
		extra = " (" .. tostring(el.runCount) .. " times)"
	end
	if isMe then
		tl.Text = string.format("%0.3fs", el.timeMs / 1000)
	else
		tl.Text = string.format("%0.0fs", el.timeMs / 1000)
	end

	local ttText = string.format("%s %0.3fs %s%s", el.username, el.timeMs / 1000, tpUtil.getCardinal(ii), extra)
	toolTip.setupToolTip(localPlayer, frame, ttText, UDim2.new(0, #el.username * 13, 0, 30), false)
	return frame
end

local function determineServerEventRowName(serverEvent: tt.runningServerEvent): string
	return string.format("b-%04d-%s-serverEvent", serverEvent.serverEventNumber, serverEvent.name)
end

local function makeNewServerEventRow(serverEvent: tt.runningServerEvent, userId: number): Frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, serverEventRowHeight)
	frame.Name = determineServerEventRowName(serverEvent)
	frame.BackgroundTransparency = 1

	local row1frame = Instance.new("Frame")
	row1frame.Name = "serverEvent-row1"
	row1frame.Size = UDim2.new(1, 0, 0.5, 0)
	local row2frame = Instance.new("Frame")
	row2frame.Name = "serverEvent-row2"
	row2frame.Size = UDim2.new(1, 0, 0.5, 0)
	row2frame.BackgroundTransparency = 1
	local hh = Instance.new("UIListLayout")
	hh.Parent = row1frame
	hh.FillDirection = Enum.FillDirection.Horizontal
	local hh2 = Instance.new("UIListLayout")
	hh2.Parent = row2frame
	hh2.FillDirection = Enum.FillDirection.Horizontal
	row1frame.Parent = frame
	row2frame.Parent = frame
	row2frame.Position = UDim2.new(0, 0, 0.5, 0)

	local nameWidth = 0.45
	local prizeWidth = 0.25
	local remainingTimeWidth = 0.10
	local warpWidth = 0.20

	--strip prefixing "xxx" which is used for global ordering.
	local cleanName = string.sub(serverEvent.name, 4, -1)

	local combined = string.format("%s", cleanName)
	local raceToolTip = string.format("(%0.0fd)", serverEvent.distance)
	local nameTl =
		guiUtil.getTl("01-serverEvent-name", UDim2.fromScale(nameWidth, 1), 4, row1frame, colors.defaultGrey, 1)

	nameTl.Text = combined
	toolTip.setupToolTip(localPlayer, nameTl, raceToolTip, UDim2.new(0, 70, 0, 30), false)

	--prize tile
	local prizeTl =
		guiUtil.getTl("02-serverEvent-prize", UDim2.fromScale(prizeWidth, 1), 4, row1frame, colors.defaultGrey, 1)
	prizeTl.Text = string.format("%d tix", serverEvent.tixValue)
	-- prizeTl.Text = "-"
	local allocation = serverEventEnums.getTixAllocation(serverEvent)
	local awardMouseoverText = "Prizes as of now:"
	local lines = 1
	for _, item in pairs(allocation) do
		awardMouseoverText = awardMouseoverText .. "\n" .. item.username .. " " .. tostring(item.tixallocation) .. "tix"
		lines += 1
	end

	-- awardMouseoverText = "No prizes during testing"
	toolTip.setupToolTip(localPlayer, prizeTl, awardMouseoverText, UDim2.new(0, 100, 0, lines * 24), false, Enum.TextXAlignment.Left)

	--remaining tile
	local remainingTl = guiUtil.getTl(
		"03-serverEvent-timeRemaining",
		UDim2.fromScale(remainingTimeWidth, 1),
		4,
		row1frame,
		colors.defaultGrey,
		1
	)

	spawn(function()
		local loopEndTick = tick() + serverEvent.remainingTick
		while true do
			if remainingTl == nil then
				break
			end
			local remaining = loopEndTick - tick()
			remainingTl.Text = string.format("%0.0fs", remaining)
			wait(1)
		end
	end)

	--warp tile
	local warper = require(game.ReplicatedStorage.warper)
	local warpTile =
		guiUtil.getTb("04-serverEvent-warptile", UDim2.fromScale(warpWidth, 1), 1, row1frame, colors.lightBlue, 1)
	warpTile.Text = "Warp"
	warpTile.Activated:Connect(function()
		warper.requestWarpToSign(serverEvent.startSignId)
	end)

	local sortedUserBests = serverEventEnums.getSortedUserBests(serverEvent)

	local summaryWidth = 0.02

	local summaryTile = guiUtil.getTl(
		"01-serverEvent-summaryWidth",
		UDim2.fromScale(summaryWidth, 1),
		0,
		row2frame,
		colors.defaultGrey,
		0
	)
	local sp = summaryTile.Parent :: TextLabel
	sp.BackgroundTransparency = 1
	summaryTile.BackgroundTransparency = 1

	summaryTile.Text = "    "
	local ii = 1
	local count = #sortedUserBests
	local useCount = math.min(count, 8)
	if useCount == 0 then
		--shrink place row.

		-- local emptyPlaceholderTile = guiUtil.getTl(
		-- 	"02-serverEvent-emptyPlaceholderTile",
		-- 	UDim2.fromScale(1 - summaryWidth, 1),
		-- 	0,
		-- 	row2frame,
		-- 	colors.defaultGrey,
		-- 	1
		-- )
		-- emptyPlaceholderTile.Text = " <top runs appear here>"
		row1frame.Size = UDim2.fromScale(1, 1)
		row2frame:Destroy()
		frame.Size = UDim2.new(1, 0, 0, serverEventRowHeight / 2)
	else
		while ii <= 8 do
			local el = sortedUserBests[ii]
			if not el then
				break
			end
			local isMe = el.userId == userId
			--cap width used by top placers.
			local useWidth = math.min(0.3, (1 - summaryWidth) / useCount)
			local tile = makeTile(el, ii, isMe, useWidth)
			tile.Parent = row2frame
			ii += 1
		end
	end

	return frame
end

module.updateEventVisually = function(serverEvent: tt.runningServerEvent, userId: number)
	annotate("update" .. module.replServerEvent(serverEvent))
	local lb = getLbFrame()
	local lbServerEventRowName = determineServerEventRowName(serverEvent)
	local exi: Frame = lb:FindFirstChild(lbServerEventRowName, true)
	if exi then
		exi:Destroy()
	end

	exi = makeNewServerEventRow(serverEvent, userId)
	exi.Parent = lb
end

module.endEventVisually = function(serverEvent: tt.runningServerEvent)
	annotate("ending" .. module.replServerEvent(serverEvent))
	local lb = getLbFrame()
	local lbServerEventRowName = determineServerEventRowName(serverEvent)
	local exi = lb:FindFirstChild(lbServerEventRowName)
	if exi then
		exi:Destroy()
	else
		warn("no serverEvent to descroy. hmm.")
	end
end


remotes.registerBindableEvent("ServerEventLocalClientWarpBindableEvent")

return module
