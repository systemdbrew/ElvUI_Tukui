local addonName, NS = ...
local E = unpack(ElvUI)

NS.E = E
NS.name = addonName
NS.version = "0.1.0"

ElvUI_TukuiDB = ElvUI_TukuiDB or {}
NS.DB = ElvUI_TukuiDB

local function Print(msg)
	E:Print("|cff00b3ffElvUI TukUI|r: " .. msg)
end
NS.Print = Print

SLASH_ELVUITUKUI1 = "/tukuiapply"
SlashCmdList.ELVUITUKUI = function(msg)
	msg = (msg or ""):lower():match("^%s*(.-)%s*$")
	local preset = (msg == "laptop" or msg == "1600p") and "laptop" or "desktop"
	if NS.ApplyProfile then
		NS:ApplyProfile(preset)
		Print("Applied " .. (preset == "laptop" and "1600p Laptop" or "4K Desktop") .. " preset. Type /reload to finish.")
	end
end

SLASH_ELVUITUKUIINSTALL1 = "/tukuiinstall"
SlashCmdList.ELVUITUKUIINSTALL = function()
	if NS.QueueInstaller then
		NS:QueueInstaller(true)
	else
		Print("Installer is not ready yet. Try again after login.")
	end
end
