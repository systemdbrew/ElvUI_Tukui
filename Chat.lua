local addonName, NS = ...
local E = NS.E

local function AddGroups(frame, groups)
	for _, group in ipairs(groups) do
		ChatFrame_AddMessageGroup(frame, group)
	end
end

function NS:ApplyChatLayout()
	-- Recreate TukUI's Retail chat organization using Blizzard/ElvUI chat
	-- frames. ElvUI still owns styling and chat functionality afterward.
	local firstChannel = EnumerateServerChannels()
	if not firstChannel then
		C_Timer.After(1, function() NS:ApplyChatLayout() end)
		return
	end

	FCF_ResetChatWindows()

	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)

	FCF_OpenNewWindow(OTHER)
	FCF_UnDockFrame(ChatFrame4)
	FCF_OpenNewWindow(NPC_NAMES_DROPDOWN_ALL)
	FCF_SetLocked(ChatFrame5, 1)
	FCF_DockFrame(ChatFrame5)
	FCF_OpenNewWindow(COMMUNITIES_DEFAULT_CHANNEL_NAME)
	FCF_SetLocked(ChatFrame6, 1)
	FCF_DockFrame(ChatFrame6)

	for i = 1, 6 do
		FCF_SetChatWindowFontSize(nil, _G["ChatFrame" .. i], 12)
	end
	FCF_SetWindowName(ChatFrame1, "G, S & W")
	FCF_SetWindowName(ChatFrame2, "Log")

	local channels = { EnumerateServerChannels() }

	for i = 1, 6 do
		if i ~= 2 and i ~= 3 then
			local frame = _G["ChatFrame" .. i]
			ChatFrame_RemoveAllMessageGroups(frame)
			ChatFrame_RemoveAllChannels(frame)
		end
	end

	AddGroups(ChatFrame1, {
		"SAY", "EMOTE", "YELL", "GUILD", "OFFICER", "GUILD_ACHIEVEMENT",
		"WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER",
		"RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "BG_HORDE",
		"BG_ALLIANCE", "BG_NEUTRAL", "AFK", "DND", "ACHIEVEMENT",
		"BN_WHISPER", "BN_CONVERSATION"
	})

	AddGroups(ChatFrame4, {
		"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT",
		"MONEY", "SYSTEM", "ERRORS", "IGNORED", "SKILL", "CURRENCY"
	})

	AddGroups(ChatFrame5, {
		"MONSTER_SAY", "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER",
		"MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER"
	})

	for _, channel in ipairs(channels) do
		ChatFrame_RemoveChannel(ChatFrame1, channel)
		ChatFrame_AddChannel(ChatFrame6, channel)
	end

	ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255)
	ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255)
	ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL4", 232 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL5", 0 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL6", 0 / 255, 228 / 255, 0 / 255)

	FCF_SelectDockFrame(ChatFrame1)
	FCF_SetTabPosition(ChatFrame4, 0)
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SavePositionAndDimensions(ChatFrame4)

	NS.DB.chatLayoutApplied = true
end
