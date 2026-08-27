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
	local fonts = Ensure(general, "fonts")
	local cooldown = Ensure(fonts, "cooldown")
	cooldown.enable = true; cooldown.font = "Expressway"; cooldown.size = 12; cooldown.outline = "OUTLINE"

	local cooldowns = Ensure(db, "cooldown")
	cooldowns.enable = true
	for _, module in ipairs({ "global", "actionbar", "auras", "unitframe", "nameplates", "targetaura" }) do
		local cd = cooldowns[module]
		if type(cd) == "table" then cd.font = "Expressway"; cd.fontSize = 12; cd.fontOutline = "OUTLINE" end
	end

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

	local dt = Ensure(db, "datatexts"); dt.font = "Expressway"; dt.fontSize = 11; dt.fontOutline = "OUTLINE"
	local panels = Ensure(dt, "panels")
	local left = Ensure(panels, "LeftChatDataPanel"); left.enable = true; left[1] = "Guild"; left[2] = "Durability"; left[3] = "Friends"; left.backdrop = true; left.panelTransparency = true; left.border = true
	local right = Ensure(panels, "RightChatDataPanel"); right.enable = true; right[1] = "System"; right[2] = "Time"; right[3] = "Gold"; right.backdrop = true; right.panelTransparency = true; right.border = true

	local databars = Ensure(db, "databars")
	local experience = Ensure(databars, "experience"); experience.enable = true; experience.width = 448; experience.height = 6; experience.orientation = "HORIZONTAL"; experience.textFormat = "NONE"; experience.showBubbles = false; experience.showLevel = false; experience.mouseover = false
	local honor = Ensure(databars, "honor"); honor.enable = true; honor.width = 448; honor.height = 6; honor.orientation = "HORIZONTAL"; honor.textFormat = "NONE"; honor.showBubbles = false; honor.mouseover = false
	Ensure(databars, "reputation").enable = false; Ensure(databars, "azerite").enable = false; Ensure(databars, "threat").enable = false

	local ab = Ensure(db, "actionbar"); ab.font = "Expressway"; ab.fontOutline = "OUTLINE"; ab.hotkeyText = false; ab.macroText = false; ab.transparent = false
	for i=1,3 do local bar=Ensure(ab,"bar"..i); bar.enabled=true; bar.buttons=12; bar.buttonsPerRow=6; bar.buttonSize=32; bar.buttonSpacing=2; bar.backdrop=false; bar.backdropSpacing=2; bar.visibility="[petbattle] hide; show"; bar.alpha=1 end
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
		local cast=Ensure(f,"castbar"); cast.enable=true; cast.width=250; cast.height=18; cast.icon=true; cast.iconAttached=true; cast.iconSize=18; cast.format="CURRENTMAX"; cast.timeToHold=0; cast.spark=true
		local raid=Ensure(f,"raidicon"); raid.attachTo="TOP"; raid.attachToObject="Health"; raid.xOffset=0; raid.yOffset=2
	end
	local player=units.player; local classbar=Ensure(player,"classbar"); classbar.enable=true; classbar.height=6; classbar.detachFromFrame=false; classbar.autoHide=true
	local pbuffs=Ensure(player,"buffs"); pbuffs.enable=true; pbuffs.perrow=8; pbuffs.numrows=1; pbuffs.sizeOverride=28; pbuffs.attachTo="FRAME"; pbuffs.anchorPoint="TOPRIGHT"; pbuffs.growthX="LEFT"; pbuffs.growthY="UP"; pbuffs.yOffset=2; pbuffs.priority="PlayerBuffs,TurtleBuffs"
	local pdebuffs=Ensure(player,"debuffs"); pdebuffs.enable=true; pdebuffs.perrow=8; pdebuffs.numrows=1; pdebuffs.sizeOverride=28; pdebuffs.attachTo="FRAME"; pdebuffs.anchorPoint="TOPLEFT"; pdebuffs.growthX="RIGHT"; pdebuffs.growthY="UP"; pdebuffs.yOffset=26
	local target=units.target
	local tbuffs=Ensure(target,"buffs"); tbuffs.enable=true; tbuffs.perrow=8; tbuffs.numrows=1; tbuffs.sizeOverride=28; tbuffs.attachTo="FRAME"; tbuffs.anchorPoint="TOPRIGHT"; tbuffs.growthX="LEFT"; tbuffs.growthY="UP"; tbuffs.yOffset=26
	local tdebuffs=Ensure(target,"debuffs"); tdebuffs.enable=true; tdebuffs.perrow=8; tdebuffs.numrows=1; tdebuffs.sizeOverride=28; tdebuffs.attachTo="FRAME"; tdebuffs.anchorPoint="TOPLEFT"; tdebuffs.growthX="RIGHT"; tdebuffs.growthY="UP"; tdebuffs.yOffset=2; tdebuffs.priority="Blacklist,Personal,RaidDebuffs"
	local tot=Ensure(units,"targettarget"); tot.enable=true; tot.width=116; tot.height=24; Ensure(tot,"portrait").enable=false
	local totInfo=Ensure(tot,"infoPanel"); totInfo.enable=false
	local totHealth=Ensure(tot,"health"); totHealth.text_format=""; totHealth.frequentUpdates=true
	local totPower=Ensure(tot,"power"); totPower.enable=false
	local totName=Ensure(tot,"name"); totName.position="CENTER"; totName.xOffset=0; totName.yOffset=0; totName.text_format="[name:short]"
	local totCast=Ensure(tot,"castbar"); totCast.enable=false
	local totBuffs=Ensure(tot,"buffs"); totBuffs.enable=false
	local totDebuffs=Ensure(tot,"debuffs"); totDebuffs.enable=false
	local pet=Ensure(units,"pet"); pet.enable=true; pet.width=130; pet.height=36; Ensure(pet,"portrait").enable=false
	local focus=Ensure(units,"focus"); focus.enable=true; focus.width=164; focus.height=20; Ensure(focus,"portrait").enable=false
	local focusTarget=Ensure(units,"focustarget"); focusTarget.enable=true; focusTarget.width=164; focusTarget.height=20; Ensure(focusTarget,"portrait").enable=false

	-- TukUI-style nameplates: compact health bar, name above, level at the edge,
	-- castbar directly below, and only useful player-applied debuffs displayed.
	local np=Ensure(db,"nameplates")
	np.statusbar="ElvUI Norm"; np.font="Expressway"; np.fontSize=11; np.fontOutline="OUTLINE"
	np.clampToScreen=true; np.fadeIn=true; np.highlight=true; np.thinBorders=true
	np.overlapH=.8; np.overlapV=1.1; np.lowHealthThreshold=.4
	local threat=Ensure(np,"threat"); threat.enable=true; threat.useThreatColor=true; threat.useThreatClassification=true; threat.beingTankedByPet=true; threat.beingTankedByTank=true; threat.goodScale=1; threat.badScale=1
	local click=Ensure(np,"clickSize"); click.width=128; click.height=30; click.enemyWidth=128; click.enemyHeight=30; click.friendlyWidth=128; click.friendlyHeight=30
	local npcUnits=Ensure(np,"units")
	for _,key in ipairs({"FRIENDLY_NPC","ENEMY_NPC"}) do
		local n=Ensure(npcUnits,key); n.enable=true; n.width=128; n.height=14
		local hp=Ensure(n,"health"); hp.enable=true; hp.height=14; hp.text_format=""; hp.position="CENTER"
		local name=Ensure(n,"name"); name.enable=true; name.font="Expressway"; name.fontSize=11; name.fontOutline="OUTLINE"; name.position="TOPLEFT"; name.xOffset=0; name.yOffset=3; name.format="[name:medium]"
		local level=Ensure(n,"level"); level.enable=true; level.font="Expressway"; level.fontSize=10; level.fontOutline="OUTLINE"; level.position="TOPRIGHT"; level.xOffset=0; level.yOffset=3; level.format="[difficultycolor][level]"
		local raid=Ensure(n,"raidTargetIndicator"); raid.enable=true; raid.size=18; raid.position="TOP"; raid.xOffset=0; raid.yOffset=14
	end
	local enemy=Ensure(npcUnits,"ENEMY_NPC")
	local cb=Ensure(enemy,"castbar"); cb.enable=true; cb.width=128; cb.height=8; cb.font="Expressway"; cb.fontSize=10; cb.fontOutline="OUTLINE"; cb.textPosition="BELOW"; cb.iconPosition="RIGHT"; cb.iconSize=20; cb.showIcon=true; cb.yOffset=-8; cb.castTimeFormat="CURRENT"; cb.channelTimeFormat="CURRENT"; cb.timeToHold=0; cb.smoothbars=false
	local debuffs=Ensure(enemy,"debuffs"); debuffs.enable=true; debuffs.numAuras=5; debuffs.numRows=1; debuffs.size=22; debuffs.font="Expressway"; debuffs.fontSize=10; debuffs.fontOutline="OUTLINE"; debuffs.anchorPoint="BOTTOMLEFT"; debuffs.growthX="RIGHT"; debuffs.growthY="UP"; debuffs.xOffset=0; debuffs.yOffset=4; debuffs.priority="Blacklist,Personal"
	local buffs=Ensure(enemy,"buffs"); buffs.enable=false
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
