local addonName, NS = ...
local E = NS.E

local function AddGroups(frame, groups)
	local add = frame and (frame.AddMessageGroup or _G.ChatFrame_AddMessageGroup)
	if not add then return end
	for _, group in ipairs(groups) do
		add(frame, group)
	end
end

local function RemoveAllGroups(frame)
	local remove = frame and (frame.RemoveAllMessageGroups or _G.ChatFrame_RemoveAllMessageGroups)
	if remove then remove(frame) end
end

local function RemoveAllChannels(frame)
	local remove = frame and (frame.RemoveAllChannels or _G.ChatFrame_RemoveAllChannels)
	if remove then remove(frame) end
end

local function AddChannel(frame, channel)
	local add = frame and (frame.AddChannel or _G.ChatFrame_AddChannel)
	if add and channel then add(frame, channel) end
end

local function RemoveChannel(frame, channel)
	local remove = frame and (frame.RemoveChannel or _G.ChatFrame_RemoveChannel)
	if remove and channel then remove(frame, channel) end
end

local function PositionChatFrames(rightChat)
	-- Match the way current ElvUI positions its two physical chat panes.
	-- The additional TukUI tabs remain docked into the left pane.
	if ChatFrame1 then
		ChatFrame1:ClearAllPoints()
		if _G.LeftChatToggleButton then
			ChatFrame1:SetPoint("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
		elseif _G.LeftChatDataPanel then
			ChatFrame1:SetPoint("BOTTOMLEFT", _G.LeftChatDataPanel, "TOPLEFT", 1, 3)
		end
		FCF_SavePositionAndDimensions(ChatFrame1)
	end

	if rightChat then
		FCF_UnDockFrame(rightChat)
		rightChat:ClearAllPoints()
		if _G.RightChatDataPanel then
			rightChat:SetPoint("BOTTOMLEFT", _G.RightChatDataPanel, "TOPLEFT", 1, 3)
		elseif _G.RightChatPanel then
			rightChat:SetPoint("BOTTOMLEFT", _G.RightChatPanel, "BOTTOMLEFT", 1, 23)
		end
		FCF_SetTabPosition(rightChat, 0)
		FCF_SavePositionAndDimensions(rightChat)
	end
end

function NS:ApplyChatLayout()
	-- Recreate TukUI's Retail chat organization with current Blizzard chat APIs.
	-- ElvUI remains responsible for styling and runtime chat behavior.
	local firstChannel = EnumerateServerChannels()
	if not firstChannel then
		C_Timer.After(1, function() NS:ApplyChatLayout() end)
		return
	end

	FCF_ResetChatWindows()

	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2, 2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3, 3)

	local rightChat = FCF_OpenNewWindow("Other") or ChatFrame4
	FCF_UnDockFrame(rightChat)

	local npcChat = FCF_OpenNewWindow("All NPCs") or ChatFrame5
	FCF_SetLocked(npcChat, 1)
	FCF_DockFrame(npcChat, 4)

	local generalChat = FCF_OpenNewWindow("General") or ChatFrame6
	FCF_SetLocked(generalChat, 1)
	FCF_DockFrame(generalChat, 5)

	for i = 1, 6 do
		local frame = _G["ChatFrame" .. i]
		if frame then FCF_SetChatWindowFontSize(nil, frame, 12) end
	end

	FCF_SetWindowName(ChatFrame1, "G, S & W")
	FCF_SetWindowName(ChatFrame2, "Log")
	FCF_SetWindowName(ChatFrame3, "Voice")
	FCF_SetWindowName(rightChat, "Other")
	FCF_SetWindowName(npcChat, "All NPCs")
	FCF_SetWindowName(generalChat, "General")

	local channels = { EnumerateServerChannels() }

	for i = 1, 6 do
		if i ~= 2 and i ~= 3 then
			local frame = _G["ChatFrame" .. i]
			RemoveAllGroups(frame)
			RemoveAllChannels(frame)
		end
	end

	AddGroups(ChatFrame1, {
		"SAY", "EMOTE", "YELL", "GUILD", "OFFICER", "GUILD_ACHIEVEMENT",
		"WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER",
		"RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "BG_HORDE",
		"BG_ALLIANCE", "BG_NEUTRAL", "AFK", "DND", "ACHIEVEMENT",
		"BN_WHISPER", "BN_CONVERSATION"
	})

	AddGroups(rightChat, {
		"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT",
		"MONEY", "SYSTEM", "ERRORS", "IGNORED", "SKILL", "CURRENCY"
	})

	AddGroups(npcChat, {
		"MONSTER_SAY", "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER",
		"MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER"
	})

	for _, channel in ipairs(channels) do
		RemoveChannel(ChatFrame1, channel)
		AddChannel(generalChat, channel)
	end

	ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255)
	ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255)
	ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL4", 232 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL5", 0 / 255, 228 / 255, 121 / 255)
	ChangeChatColor("CHANNEL6", 0 / 255, 228 / 255, 0 / 255)

	FCF_SelectDockFrame(ChatFrame1)
	PositionChatFrames(rightChat)

	NS.DB.chatLayoutApplied = true
end
