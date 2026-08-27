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

	-- TukUI visual language: dark panels, black borders, Expressway-style text.
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
		bar.buttonSpacing = 4
		bar.backdrop = true
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
		f.height = 56
		f.orientation = "LEFT"
		f.smartAuraPosition = "DISABLED"

		local health = Ensure(f, "health")
		health.position = "TOP"
		health.xOffset = 0
		health.yOffset = 0
		health.text_format = "[health:current:shortvalue]"
		health.attachTextTo = "Health"
		health.frequentUpdates = true

		local power = Ensure(f, "power")
		power.enable = true
		power.height = 6
		power.position = "BOTTOM"
		power.xOffset = 0
		power.yOffset = 0
		power.text_format = ""

		local name = Ensure(f, "name")
		name.position = "CENTER"
		name.text_format = "[name:medium]"

		local portrait = Ensure(f, "portrait")
		portrait.enable = false

		local castbar = Ensure(f, "castbar")
		castbar.enable = true
		castbar.width = 250
		castbar.height = 21
		castbar.icon = true
		castbar.iconAttached = false

		-- ElvUI expects attachTo to be a region point (TOP, CENTER, etc.) and
		-- attachToObject to name the unit-frame object. Keep these explicit so
		-- an older profile value cannot turn "Health" into a SetPoint region.
		local raidicon = Ensure(f, "raidicon")
		raidicon.attachTo = "TOP"
		raidicon.attachToObject = "Health"
		raidicon.xOffset = 0
		raidicon.yOffset = 2
	end

	local player = units.player
	local classbar = Ensure(player, "classbar")
	classbar.enable = true
	classbar.height = 8
	classbar.detachFromFrame = false

	local tot = Ensure(units, "targettarget")
	tot.enable = true
	tot.width = 120
	tot.height = 28

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
		player = "BOTTOM,ElvUIParent,BOTTOM,-260,175",
		target = "BOTTOM,ElvUIParent,BOTTOM,260,175",
		targettarget = "BOTTOM,ElvUIParent,BOTTOM,0,165",
		bar1 = "BOTTOM,ElvUIParent,BOTTOM,0,38",
		bar2 = "BOTTOM,ElvUIParent,BOTTOM,0,110",
		bar3 = "BOTTOM,ElvUIParent,BOTTOM,0,182",
		minimap = "TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-10",
	},
	laptop = {
		uiScale = 0.64,
		player = "BOTTOM,ElvUIParent,BOTTOM,-230,155",
		target = "BOTTOM,ElvUIParent,BOTTOM,230,155",
		targettarget = "BOTTOM,ElvUIParent,BOTTOM,0,145",
		bar1 = "BOTTOM,ElvUIParent,BOTTOM,0,34",
		bar2 = "BOTTOM,ElvUIParent,BOTTOM,0,100",
		bar3 = "BOTTOM,ElvUIParent,BOTTOM,0,166",
		minimap = "TOPRIGHT,ElvUIParent,TOPRIGHT,-8,-8",
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
	SetMover("ElvAB_1", layout.bar1)
	SetMover("ElvAB_2", layout.bar2)
	SetMover("ElvAB_3", layout.bar3)
	SetMover("MinimapMover", layout.minimap)
	SetMover("LeftChatMover", "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4")
	SetMover("RightChatMover", "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4")

	ElvUI_TukuiDB.preset = preset
	ElvUI_TukuiDB.version = NS.version
end
