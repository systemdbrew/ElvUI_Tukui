local addonName, NS = ...
local E = NS.E

local function Ensure(parent, key)
	if type(parent[key]) ~= "table" then parent[key] = {} end
	return parent[key]
end

local function SetMover(name, point)
	E.db.movers = E.db.movers or {}
	E.db.movers[name] = point
end

local function ApplyCommon()
	local db = E.db

	-- Keep ElvUI as the maintained engine, while reproducing TukUI's HUD.
	local general = Ensure(db, "general")
	general.font = "Expressway"
	general.fontSize = 12
	general.fontStyle = "OUTLINE"
	general.backdropcolor = { r = 0.11, g = 0.11, b = 0.11, a = 1 }
	general.backdropfadecolor = { r = 0.06, g = 0.06, b = 0.06, a = 0.8 }
	general.bordercolor = { r = 0, g = 0, b = 0, a = 1 }
	general.bottomPanel = false

	local minimap = Ensure(general, "minimap")
	minimap.size = 160
	minimap.circle = false
	minimap.locationText = "MOUSEOVER"

	-- TukUI defaults: 450x204 chat panels anchored in the bottom corners.
	local chat = Ensure(db, "chat")
	chat.panelWidth = 450
	chat.panelHeight = 204
	chat.panelBackdrop = "SHOWBOTH"
	chat.panelTabBackdrop = true
	chat.panelTabTransparency = true
	chat.font = "Expressway"
	chat.fontSize = 12
	chat.fontOutline = "OUTLINE"
	chat.fade = false
	chat.scrollDownInterval = 3

	-- TukUI has two thin configurable status bars above the chat panels.
	-- Use ElvUI's maintained XP/Honor databars for those two slots and turn
	-- off the extra default databars that otherwise appear in the center HUD.
	local databars = Ensure(db, "databars")
	local experience = Ensure(databars, "experience")
	experience.enable = true
	experience.width = 448
	experience.height = 6
	experience.orientation = "HORIZONTAL"
	experience.textFormat = "NONE"
	experience.showBubbles = false
	experience.showLevel = false
	experience.mouseover = false

	local honor = Ensure(databars, "honor")
	honor.enable = true
	honor.width = 448
	honor.height = 6
	honor.orientation = "HORIZONTAL"
	honor.textFormat = "NONE"
	honor.showBubbles = false
	honor.mouseover = false

	Ensure(databars, "reputation").enable = false
	Ensure(databars, "azerite").enable = false
	Ensure(databars, "threat").enable = false

	-- TukUI's three compact 6x2 button blocks.
	local ab = Ensure(db, "actionbar")
	ab.font = "Expressway"
	ab.fontOutline = "OUTLINE"
	ab.hotkeyText = false
	ab.macroText = false
	ab.transparent = false
	for i = 1, 3 do
		local bar = Ensure(ab, "bar" .. i)
		bar.enabled = true
		bar.buttons = 12
		bar.buttonsPerRow = 6
		bar.buttonSize = 32
		bar.buttonSpacing = 2
		bar.backdrop = true
		bar.backdropSpacing = 2
		bar.visibility = "[petbattle] hide; show"
	end
	for i = 4, 6 do
		local bar = Ensure(ab, "bar" .. i)
		bar.enabled = false
	end

	local uf = Ensure(db, "unitframe")
	uf.font = "Expressway"
	uf.fontOutline = "OUTLINE"
	uf.smoothbars = false
	local units = Ensure(uf, "units")

	for _, unit in ipairs({ "player", "target" }) do
		local f = Ensure(units, unit)
		f.enable = true
		f.width = 250
		f.height = 57
		f.orientation = "LEFT"
		f.smartAuraPosition = "DISABLED"

		local infoPanel = Ensure(f, "infoPanel")
		infoPanel.enable = true
		infoPanel.height = 21
		infoPanel.transparent = false

		local health = Ensure(f, "health")
		health.position = "RIGHT"
		health.xOffset = -4
		health.yOffset = 0
		health.text_format = "[health:current:shortvalue]"
		health.attachTextTo = "InfoPanel"
		health.frequentUpdates = true

		local power = Ensure(f, "power")
		power.enable = true
		power.height = 6
		power.position = "LEFT"
		power.xOffset = 4
		power.yOffset = 0
		power.text_format = ""
		power.attachTextTo = "InfoPanel"
		power.detachFromFrame = false

		local name = Ensure(f, "name")
		name.position = "LEFT"
		name.xOffset = 4
		name.yOffset = 0
		name.attachTextTo = "InfoPanel"
		name.text_format = "[level] [name:medium]"

		local portrait = Ensure(f, "portrait")
		portrait.enable = false

		local castbar = Ensure(f, "castbar")
		castbar.enable = true
		castbar.width = 250
		castbar.height = 21
		castbar.icon = true
		castbar.iconAttached = false

		local raidicon = Ensure(f, "raidicon")
		raidicon.attachTo = "TOP"
		raidicon.attachToObject = "Health"
		raidicon.xOffset = 0
		raidicon.yOffset = 2
	end

	local player = units.player
	local classbar = Ensure(player, "classbar")
	classbar.enable = true
	classbar.height = 6
	classbar.detachFromFrame = false
	classbar.autoHide = true

	local tot = Ensure(units, "targettarget")
	tot.enable = true
	tot.width = 130
	tot.height = 36
	Ensure(tot, "portrait").enable = false

	local pet = Ensure(units, "pet")
	pet.enable = true
	pet.width = 130
	pet.height = 36
	Ensure(pet, "portrait").enable = false

	local focus = Ensure(units, "focus")
	focus.enable = true
	focus.width = 164
	focus.height = 20
	Ensure(focus, "portrait").enable = false

	local focusTarget = Ensure(units, "focustarget")
	focusTarget.enable = true
	focusTarget.width = 164
	focusTarget.height = 20

	local np = Ensure(db, "nameplates")
	np.statusbar = "ElvUI Norm"
	np.font = "Expressway"
	np.fontSize = 12
	np.fontOutline = "OUTLINE"
	local npcUnits = Ensure(np, "units")
	for _, key in ipairs({ "FRIENDLY_NPC", "ENEMY_NPC" }) do
		local n = Ensure(npcUnits, key)
		n.width = 128
		n.height = 14
	end
end

local layouts = {
	desktop = {
		uiScale = 0.70,
		player = "BOTTOM,ElvUIParent,BOTTOM,-235,102",
		target = "BOTTOM,ElvUIParent,BOTTOM,235,102",
		targettarget = "BOTTOM,ElvUIParent,BOTTOM,0,102",
		pet = "BOTTOM,ElvUIParent,BOTTOM,0,176",
		focus = "BOTTOM,ElvUIParent,BOTTOM,-279,316",
		focustarget = "BOTTOM,ElvUIParent,BOTTOM,-279,341",
		bar1 = "BOTTOM,ElvUIParent,BOTTOM,0,12",
		bar2 = "BOTTOM,ElvUIParent,BOTTOM,-251,12",
		bar3 = "BOTTOM,ElvUIParent,BOTTOM,251,12",
		minimap = "TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-10",
		experience = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,5,218",
		honor = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-5,218",
	},
	laptop = {
		uiScale = 0.64,
		player = "BOTTOM,ElvUIParent,BOTTOM,-220,92",
		target = "BOTTOM,ElvUIParent,BOTTOM,220,92",
		targettarget = "BOTTOM,ElvUIParent,BOTTOM,0,92",
		pet = "BOTTOM,ElvUIParent,BOTTOM,0,160",
		focus = "BOTTOM,ElvUIParent,BOTTOM,-255,285",
		focustarget = "BOTTOM,ElvUIParent,BOTTOM,-255,308",
		bar1 = "BOTTOM,ElvUIParent,BOTTOM,0,10",
		bar2 = "BOTTOM,ElvUIParent,BOTTOM,-235,10",
		bar3 = "BOTTOM,ElvUIParent,BOTTOM,235,10",
		minimap = "TOPRIGHT,ElvUIParent,TOPRIGHT,-8,-8",
		experience = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,5,218",
		honor = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-5,218",
	},
}

function NS:ApplyProfile(preset)
	preset = layouts[preset] and preset or "desktop"
	ApplyCommon()

	local layout = layouts[preset]
	E.db.general.uiScale = layout.uiScale

	SetMover("ElvUF_PlayerMover", layout.player)
	SetMover("ElvUF_TargetMover", layout.target)
	SetMover("ElvUF_TargetTargetMover", layout.targettarget)
	SetMover("ElvUF_PetMover", layout.pet)
	SetMover("ElvUF_FocusMover", layout.focus)
	SetMover("ElvUF_FocusTargetMover", layout.focustarget)
	SetMover("ElvAB_1", layout.bar1)
	SetMover("ElvAB_2", layout.bar2)
	SetMover("ElvAB_3", layout.bar3)
	SetMover("MinimapMover", layout.minimap)
	SetMover("LeftChatMover", "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4")
	SetMover("RightChatMover", "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4")
	SetMover("ExperienceBarMover", layout.experience)
	SetMover("HonorBarMover", layout.honor)

	if NS.ApplyChatLayout then
		NS:ApplyChatLayout()
	end

	ElvUI_TukuiDB.preset = preset
	ElvUI_TukuiDB.version = NS.version
end
