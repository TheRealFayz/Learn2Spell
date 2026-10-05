
----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("Learn2Spell")

L:RegisterTranslations("enUS", function() return {
	upgrade = "Upgrading button #%s to %s (Rank %s)",
} end)


------------------------------
--      Are you local?      --
------------------------------

-- AceLibrary("SpecialEvents-LearnSpell-2.0") -- Majick line for InBed
local gratuity = AceLibrary("Gratuity-2.0")


-------------------------------------
--      Namespace Declaration      --
-------------------------------------

Learn2Spell = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0")
Learn2Spell:RegisterDB("Learn2SpellDB")
Learn2Spell:RegisterChatCommand({"/l2s", "/learn2spell"})


---------------------------
--      Ace Methods      --
---------------------------

function Learn2Spell:OnEnable()
	self:RegisterEvent("SpecialEvents_LearnedSpell")
end


function Learn2Spell:SpecialEvents_LearnedSpell(spell, rank)
	for btn=1,120 do
		local n, r = self:ActionIsSpell(btn)
		if n and n == spell and ((r or "") ~= rank) then
			local i = self:GetSpellIndex(spell, rank)
			if not i then return end

			local n, r = GetSpellName(i,BOOKTYPE_SPELL)
			self:Print(L.upgrade, btn, n, r or "??")
			PickupSpell(i, BOOKTYPE_SPELL)
			PlaceAction(btn)

			repeat
				if CursorHasItem() or CursorHasSpell() then PickupSpell(1, BOOKTYPE_SPELL) end
			until not CursorHasItem() and not CursorHasSpell()
		end
	end
end


function Learn2Spell:GetSpellIndex(spell, rank)
	assert(spell, "No spell passed")

	local i, n, r = 1
	repeat
		n, r = GetSpellName(i, BOOKTYPE_SPELL)
		if n and n == spell and r == rank then return i end
		i = i+1
	until not n
end


function Learn2Spell:ActionIsSpell(id)
	if not id or GetActionText(id) then return end

	gratuity:SetAction(id)
	return gratuity:GetLine(1)
end


