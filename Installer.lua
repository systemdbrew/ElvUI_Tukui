local addonName, NS = ...
local E = NS.E
local PI = E:GetModule("PluginInstaller")

local queued = false

local function SetupText(subtitle, d1, d2, d3)
	local f = _G.PluginInstallFrame
	if not f then return end
	f.SubTitle:SetText(subtitle or "")
	f.Desc1:SetText(d1 or "")
	f.Desc2:SetText(d2 or "")
	f.Desc3:SetText(d3 or "")
end

local function Welcome()
	SetupText(
		"TukUI HUD for ElvUI",
		"This plugin keeps ElvUI as the maintained UI engine and applies a TukUI-style gameplay HUD.",
		"It changes chat panels, action bars, player/target frames, minimap, nameplates, fonts and mover positions.",
		"Blizzard windows and ElvUI skins remain completely ElvUI-owned."
	)
end

local function Resolution()
	SetupText(
		"Choose a layout",
		"Pick the screen you are configuring now. You can rerun this installer or use /tukuiapply later.",
		"4K Desktop targets 3840x2160. 1600p Laptop targets the Zephyrus-style 2560x1600 layout.",
		"Both presets use the same TukUI proportions; only scale and mover positions differ."
	)
	local f = _G.PluginInstallFrame
	f.Option1:Show()
	f.Option1:SetText("4K Desktop")
	f.Option1:SetScript("OnClick", function()
		NS:ApplyProfile("desktop")
		NS.Print("4K Desktop preset applied.")
	end)
	f.Option2:Show()
	f.Option2:SetText("1600p Laptop")
	f.Option2:SetScript("OnClick", function()
		NS:ApplyProfile("laptop")
		NS.Print("1600p Laptop preset applied.")
	end)
end

local function Finish()
	SetupText(
		"Ready to test",
		"The profile has been written into ElvUI's normal profile database. ElvUI still owns every frame.",
		"After reloading, compare the bottom HUD with TukUI. We can tune the profile values without maintaining a second UI framework.",
		"Use /tukuiapply for 4K, /tukuiapply laptop for 1600p, or /tukuiinstall to reopen this installer."
	)
	local f = _G.PluginInstallFrame
	f.Option1:Show()
	f.Option1:SetText("Reload UI")
	f.Option1:SetScript("OnClick", ReloadUI)
end

local installer = {
	Title = "ElvUI TukUI Setup",
	Name = "ElvUI_Tukui",
	Pages = { Welcome, Resolution, Finish },
	StepTitles = { "Welcome", "Resolution", "Finish" },
	StepTitleWidth = 120,
	StepTitleButtonWidth = 110,
}

function NS:QueueInstaller(forceShow)
	if not queued then
		PI:Queue(installer)
		queued = true
	end
	if forceShow and _G.PluginInstallFrame then
		_G.PluginInstallFrame:Show()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	NS:QueueInstaller(false)
end)
