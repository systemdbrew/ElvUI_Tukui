local addonName, NS = ...
local E = NS.E

local ApplyProfile = NS.ApplyProfile

function NS:ApplyProfile(preset)
	ApplyProfile(self, preset)

	local units = E.db and E.db.unitframe and E.db.unitframe.units
	if not units then return end

	if units.player and units.player.name then
		units.player.name.text_format = "[level] [name:long]"
	end

	if units.target and units.target.name then
		units.target.name.text_format = "[level] [name:long]"
	end

	if units.targettarget and units.targettarget.name then
		units.targettarget.name.text_format = "[name:long]"
	end
end
