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
	local general = Ensure(db, "general")
	general.font = "Expressway"; general.fontSize = 12; general.fontStyle = "OUTLINE"
	general.backdropcolor = { r=.11,g=.11,b=.11,a=1 }; general.backdropfadecolor = { r=.06,g=.06,b=.06,a=.8 }; general.bordercolor = { r=0,g=0,b=0,a=1 }
	general.bottomPanel = false

	local minimap = Ensure(general, "minimap")
	minimap.size = 160; minimap.circle = false; minimap.locationText = "MOUSEOVER"
	minimap.locationFont = "Expressway"; minimap.locationFontSize = 12; minimap.locationFontOutline = "OUTLINE"
	minimap.timeFont = "Expressway"; minimap.timeFontSize = 12; minimap.timeFontOutline = "OUTLINE"
	local icons = Ensure(minimap, "icons")
	local tracking = Ensure(icons, "tracking"); tracking.position = "BOTTOMLEFT"; tracking.xOffset = 3; tracking.yOffset = 3
	local calendar = Ensure(icons, "calendar"); calendar.hide = true
	local mail = Ensure(icons, "mail"); mail.position = "TOPRIGHT"; mail.xOffset = 3; mail.yOffset = 4
	local battlefield = Ensure(icons, "battlefield"); battlefield.position = "BOTTOMRIGHT"

	local chat = Ensure(db, "chat")
	chat.panelWidth = 450; chat.panelHeight = 204; chat.panelWidthRight = 450; chat.panelHeightRight = 204; chat.separateSizes = false
	chat.panelBackdrop = "SHOWBOTH"; chat.panelTabBackdrop = true; chat.panelTabTransparency = true
	chat.font = "Expressway"; chat.fontSize = 12; chat.fontOutline = "OUTLINE"; chat.fade = false; chat.scrollDownInterval = 3
	chat.hideChatToggles = false; chat.LeftChatDataPanelAnchor = "BELOW_CHAT"; chat.RightChatDataPanelAnchor = "BELOW_CHAT"
	chat.tabFont = "Expressway"; chat.tabFontSize = 11; chat.tabFontOutline = "OUTLINE"
	chat.tabSelector = "BOX"; chat.tabSelectorColor = { r=.09,g=.52,b=.82,a=1 }

	local dt = Ensure(db, "datatexts")
	dt.font = "Expressway"; dt.fontSize = 11; dt.fontOutline = "OUTLINE"
	local panels = Ensure(dt, "panels")
	local left = Ensure(panels, "LeftChatDataPanel")
	left.enable = true; left[1] = "Guild"; left[2] = "Durability"; left[3] = "Friends"
	left.backdrop = true; left.panelTransparency = true; left.border = true
	local right = Ensure(panels, "RightChatDataPanel")
	right.enable = true; right[1] = "System"; right[2] = "Time"; right[3] = "Gold"
	right.backdrop = true; right.panelTransparency = true; right.border = true

	local databars = Ensure(db, "databars")
	local experience = Ensure(databars, "experience")
	experience.enable = true; experience.width = 448; experience.height = 6; experience.orientation = "HORIZONTAL"; experience.textFormat = "NONE"; experience.showBubbles = false; experience.showLevel = false; experience.mouseover = false
	local honor = Ensure(databars, "honor")
	honor.enable = true; honor.width = 448; honor.height = 6; honor.orientation = "HORIZONTAL"; honor.textFormat = "NONE"; honor.showBubbles = false; honor.mouseover = false
	Ensure(databars, "reputation").enable = false; Ensure(databars, "azerite").enable = false; Ensure(databars, "threat").enable = false

	local ab = Ensure(db, "actionbar")
	ab.font = "Expressway"; ab.fontOutline = "OUTLINE"; ab.hotkeyText = false; ab.macroText = false; ab.transparent = false
	for i=1,3 do
		local bar=Ensure(ab,"bar"..i); bar.enabled=true; bar.buttons=12; bar.buttonsPerRow=6; bar.buttonSize=32; bar.buttonSpacing=2; bar.backdrop=false; bar.backdropSpacing=2; bar.visibility="[petbattle] hide; show"; bar.alpha=1
	end
	for i=4,6 do Ensure(ab,"bar"..i).enabled=false end
	local stance=Ensure(ab,"stanceBar"); stance.enabled=true; stance.buttonSize=24; stance.buttonSpacing=2; stance.style="darkenInactive"
	local petbar=Ensure(ab,"barPet"); petbar.enabled=true; petbar.buttonSize=24; petbar.buttonSpacing=2; petbar.buttonsPerRow=10

	local uf=Ensure(db,"unitframe"); uf.font="Expressway"; uf.fontOutline="OUTLINE"; uf.smoothbars=false
	local colors=Ensure(uf,"colors"); colors.healthclass=false; colors.health={r=.12,g=.12,b=.12}; colors.health_backdrop={r=.05,g=.05,b=.05}; colors.powerclass=true
	local units=Ensure(uf,"units")
	for _,unit in ipairs({"player","target"}) do
		local f=Ensure(units,unit); f.enable=true; f.width=250; f.height=57; f.orientation="LEFT"; f.smartAuraPosition="DISABLED"
		local info=Ensure(f,"infoPanel"); info.enable=true; info.height=21; info.transparent=false
		local health=Ensure(f,"health"); health.position="RIGHT"; health.xOffset=-4; health.yOffset=0; health.text_format="[health:current:shortvalue]"; health.attachTextTo="InfoPanel"; health.frequentUpdates=true
		local power=Ensure(f,"power"); power.enable=true; power.height=6; power.position="LEFT"; power.xOffset=4; power.yOffset=0; power.text_format=""; power.attachTextTo="InfoPanel"; power.detachFromFrame=false
		local name=Ensure(f,"name"); name.position="LEFT"; name.xOffset=4; name.yOffset=0; name.attachTextTo="InfoPanel"; name.text_format="[level] [name:medium]"
		Ensure(f,"portrait").enable=false
		local cast=Ensure(f,"castbar"); cast.enable=true; cast.width=250; cast.height=21; cast.icon=true; cast.iconAttached=false; cast.timeToHold=0
		local raid=Ensure(f,"raidicon"); raid.attachTo="TOP"; raid.attachToObject="Health"; raid.xOffset=0; raid.yOffset=2
	end
	local player=units.player; local classbar=Ensure(player,"classbar"); classbar.enable=true; classbar.height=6; classbar.detachFromFrame=false; classbar.autoHide=true
	local pbuffs=Ensure(player,"buffs"); pbuffs.enable=true; pbuffs.perrow=8; pbuffs.numrows=1; pbuffs.sizeOverride=22; pbuffs.attachTo="FRAME"; pbuffs.anchorPoint="TOPLEFT"; pbuffs.growthX="RIGHT"; pbuffs.growthY="UP"
	local pdebuffs=Ensure(player,"debuffs"); pdebuffs.enable=true; pdebuffs.perrow=8; pdebuffs.numrows=1; pdebuffs.sizeOverride=22
	local target=units.target
	local tbuffs=Ensure(target,"buffs"); tbuffs.enable=true; tbuffs.perrow=8; tbuffs.numrows=1; tbuffs.sizeOverride=22
	local tdebuffs=Ensure(target,"debuffs"); tdebuffs.enable=true; tdebuffs.perrow=8; tdebuffs.numrows=1; tdebuffs.sizeOverride=22; tdebuffs.priority="Blacklist,Personal,RaidDebuffs"
	local tot=Ensure(units,"targettarget"); tot.enable=true; tot.width=116; tot.height=30; Ensure(tot,"portrait").enable=false
	local pet=Ensure(units,"pet"); pet.enable=true; pet.width=130; pet.height=36; Ensure(pet,"portrait").enable=false
	local focus=Ensure(units,"focus"); focus.enable=true; focus.width=164; focus.height=20; Ensure(focus,"portrait").enable=false
	local focusTarget=Ensure(units,"focustarget"); focusTarget.enable=true; focusTarget.width=164; focusTarget.height=20; Ensure(focusTarget,"portrait").enable=false

	local np=Ensure(db,"nameplates"); np.statusbar="ElvUI Norm"; np.font="Expressway"; np.fontSize=12; np.fontOutline="OUTLINE"; np.clampToScreen=true
	local npcUnits=Ensure(np,"units")
	for _,key in ipairs({"FRIENDLY_NPC","ENEMY_NPC"}) do
		local n=Ensure(npcUnits,key); n.width=128; n.height=14
		local hp=Ensure(n,"health"); hp.enable=true; hp.height=14
		local name=Ensure(n,"name"); name.enable=true; name.font="Expressway"; name.fontSize=12; name.fontOutline="OUTLINE"
	end
	local enemy=Ensure(npcUnits,"ENEMY_NPC"); local cb=Ensure(enemy,"castbar"); cb.enable=true; cb.height=10; cb.iconPosition="RIGHT"
end

local layouts={
	desktop={uiScale=.70,player="BOTTOM,ElvUIParent,BOTTOM,-205,106",target="BOTTOM,ElvUIParent,BOTTOM,205,106",targettarget="BOTTOM,ElvUIParent,BOTTOM,0,106",pet="BOTTOM,ElvUIParent,BOTTOM,0,174",focus="BOTTOM,ElvUIParent,BOTTOM,-255,300",focustarget="BOTTOM,ElvUIParent,BOTTOM,-255,325",bar1="BOTTOM,ElvUIParent,BOTTOM,0,14",bar2="BOTTOM,ElvUIParent,BOTTOM,-220,14",bar3="BOTTOM,ElvUIParent,BOTTOM,220,14",minimap="TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-10",experience="BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,5,235",honor="BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-5,235"},
	laptop={uiScale=.64,player="BOTTOM,ElvUIParent,BOTTOM,-220,92",target="BOTTOM,ElvUIParent,BOTTOM,220,92",targettarget="BOTTOM,ElvUIParent,BOTTOM,0,92",pet="BOTTOM,ElvUIParent,BOTTOM,0,160",focus="BOTTOM,ElvUIParent,BOTTOM,-255,285",focustarget="BOTTOM,ElvUIParent,BOTTOM,-255,308",bar1="BOTTOM,ElvUIParent,BOTTOM,0,10",bar2="BOTTOM,ElvUIParent,BOTTOM,-235,10",bar3="BOTTOM,ElvUIParent,BOTTOM,235,10",minimap="TOPRIGHT,ElvUIParent,TOPRIGHT,-8,-8",experience="BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,5,235",honor="BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-5,235"}
}

function NS:ApplyProfile(preset)
	preset=layouts[preset] and preset or "desktop"; ApplyCommon(); local l=layouts[preset]; E.db.general.uiScale=l.uiScale
	SetMover("ElvUF_PlayerMover",l.player); SetMover("ElvUF_TargetMover",l.target); SetMover("ElvUF_TargetTargetMover",l.targettarget); SetMover("ElvUF_PetMover",l.pet); SetMover("ElvUF_FocusMover",l.focus); SetMover("ElvUF_FocusTargetMover",l.focustarget)
	SetMover("ElvAB_1",l.bar1); SetMover("ElvAB_2",l.bar2); SetMover("ElvAB_3",l.bar3); SetMover("MinimapMover",l.minimap)
	SetMover("LeftChatMover","BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4"); SetMover("RightChatMover","BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4"); SetMover("ExperienceBarMover",l.experience); SetMover("HonorBarMover",l.honor)
	if NS.ApplyChatLayout then NS:ApplyChatLayout() end
	ElvUI_TukuiDB.preset=preset; ElvUI_TukuiDB.version=NS.version
end
