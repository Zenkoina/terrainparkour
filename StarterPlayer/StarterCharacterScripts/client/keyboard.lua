--!strict

-- keyboard.client.luaclient
-- client keyboard shortcuts

local annotater = require(game.ReplicatedStorage.util.annotater)
local _annotate = annotater.getAnnotater(script)

local module = {}
local textHighlighting = require(game.ReplicatedStorage.gui.textHighlighting)
local tt = require(game.ReplicatedStorage.types.gametypes)

local remotes = require(game.ReplicatedStorage.util.remotes)
local settings = require(game.ReplicatedStorage.settings)
local settingEnums = require(game.ReplicatedStorage.UserSettings.settingEnums)

local warper = require(game.StarterPlayer.StarterPlayerScripts.warper)
local mt = require(game.ReplicatedStorage.avatarEventTypes)

local avatarEventFiring = require(game.StarterPlayer.StarterPlayerScripts.avatarEventFiring)
local fireEvent = avatarEventFiring.FireEvent

local PlayersService = game:GetService("Players")
local localPlayer = PlayersService.LocalPlayer
local AvatarEventBindableEvent: BindableEvent = remotes.getBindableEvent("AvatarEventBindableEvent")
local keyboardShortcutButton = require(game.StarterPlayer.StarterPlayerScripts.buttons.keyboardShortcutGui)
local particleExplanationGui = require(game.StarterPlayer.StarterPlayerScripts.buttons.particleExplanationGui)

local UserInputService = game:GetService("UserInputService")

---------------- GLOBALS ---------------------
------------------------- live-monitor this setting value. -------------
local userWantsHighlightingWhenWarpingWithKeyboard = false
local ignoreChatWhenHittingX = false
local showLB: boolean = true

--------------- "remember" the last runs they've worked on for '1'
local lastRunStart = nil
local lastRunEnd = nil

local function ToggleChat(intendedState: boolean)
	local ChatMain =
		require(game.Players.LocalPlayer.PlayerScripts:FindFirstChild("ChatScript"):WaitForChild("ChatMain"))
	ChatMain:SetVisible(intendedState)
end

local function ToggleLB(intendedState: boolean)
	local items = { localPlayer:WaitForChild("PlayerGui"):FindFirstChild("LeaderboardScreenGui") }
	if not items then
		_annotate("no leaderboard screen gui found.")
		return
	end
	for _, el in ipairs(items) do
		if el == nil then
			_annotate("bad item.")
			continue
		end
		el.Enabled = intendedState
	end
end

local function KillPopups()
	for _, el in ipairs(localPlayer:WaitForChild("PlayerGui"):GetChildren()) do
		if string.sub(el.Name, 0, 14) == "RaceResultSgui" then
			el:Destroy()
		end
		if string.sub(el.Name, 0, 14) == "SignProfileSgui" then
			el:Destroy()
		end

		if el.Name == "EphemeralNotificationSgui" then
			el:Destroy()
		end
		if el.Name == "ToolTipGui" then
			el:Destroy()
		end
		if el.Name == "NewFindSgui" then
			el:Destroy()
		end
		if el.Name == "EphemeralTooltip" then
			el:Destroy()
		end
	end
	if not ignoreChatWhenHittingX then
		ToggleChat(false)
	end
end

-------------- all the shortcuts are here. ----------------
local function onInputBegin(inputObject, gameProcessedEvent)
	if not inputObject.KeyCode then
		return
	end

	if gameProcessedEvent then
		return
	end

	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		if inputObject.KeyCode == Enum.KeyCode.One then
			local useLastRunEnd = nil
			if userWantsHighlightingWhenWarpingWithKeyboard then
				useLastRunEnd = lastRunEnd
			end
			if lastRunStart ~= nil and lastRunEnd ~= nil then
				warper.WarpToSignId(lastRunStart, useLastRunEnd)
			end
		elseif inputObject.KeyCode == Enum.KeyCode.H then
			textHighlighting.KillAllExistingHighlights()
			-- print("kill all highlights.")
		elseif inputObject.KeyCode == Enum.KeyCode.Tab then
			showLB = not showLB
			ToggleLB(showLB)
		elseif inputObject.KeyCode == Enum.KeyCode.X then
			KillPopups()
		elseif inputObject.KeyCode == Enum.KeyCode.Z then
			-- strangely, this key used to do a lot, even when you weren't running.
			-- because basically it kills the movementHistory store in movement, which can have effects on the player
			-- even when not running!
			fireEvent(mt.avatarEventTypes.RUN_CANCEL, { reason = "hit z on keyboard" })
		elseif inputObject.KeyCode == Enum.KeyCode.K then
			keyboardShortcutButton.CreateShortcutGui()
			-- elseif inputObject.KeyCode == Enum.KeyCode.P then
			-- 	particleExplanationGui.CreateParticleGui()
		end
	end
end

local function handleUserSettingChanged(item: tt.userSettingValue): any
	if item.name == settingEnums.settingNames.HIGHLIGHT_ON_KEYBOARD_1_TO_WARP then
		userWantsHighlightingWhenWarpingWithKeyboard = item.value
	elseif item.name == settingEnums.settingNames.X_BUTTON_IGNORES_CHAT then
		ignoreChatWhenHittingX = item.value
	end
end

-- we track the last run start so that they can warp back there.
local debHandleAvatarEvent = false
local function handleAvatarEvent(ev: mt.avatarEvent)
	while debHandleAvatarEvent do
		_annotate("was locked while trying to set keyboard.")
		_annotate(avatarEventFiring.DescribeEvent(ev.eventType, ev.details))
		return
	end
	debHandleAvatarEvent = true
	if ev.eventType == mt.avatarEventTypes.RUN_START then
		_annotate(string.format("run start, setting lastRunStart to %d", ev.details.relatedSignId))
		lastRunStart = ev.details.relatedSignId
	elseif ev.eventType == mt.avatarEventTypes.RUN_COMPLETE then
		_annotate(string.format("run complete, setting lastRunEnd to %d", ev.details.relatedSignId))
		lastRunEnd = ev.details.relatedSignId
	end
	debHandleAvatarEvent = false
end

module.Init = function()
	debHandleAvatarEvent = false
	AvatarEventBindableEvent.Event:Connect(handleAvatarEvent)
	UserInputService.InputBegan:Connect(onInputBegin)

	settings.RegisterFunctionToListenForSettingName(
		handleUserSettingChanged,
		settingEnums.settingNames.HIGHLIGHT_ON_KEYBOARD_1_TO_WARP
	)

	settings.RegisterFunctionToListenForSettingName(
		handleUserSettingChanged,
		settingEnums.settingNames.X_BUTTON_IGNORES_CHAT
	)

	handleUserSettingChanged(settings.getSettingByName(settingEnums.settingNames.HIGHLIGHT_ON_KEYBOARD_1_TO_WARP))
	handleUserSettingChanged(settings.getSettingByName(settingEnums.settingNames.X_BUTTON_IGNORES_CHAT))
end

_annotate("end")
return module
