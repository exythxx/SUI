local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		-- HIDE RAIDFRAMERESIZE
		local n, w, h = "CompactUnitFrameProfilesGeneralOptionsFrame"
		h, w = _G[n .. "HeightSlider"], _G[n .. "WidthSlider"]
		h:SetMinMaxValues(1, 200)
		w:SetMinMaxValues(1, 200)

		local function updateTextures(self)
			if self:IsForbidden() then return end
			local name = self:GetName()
			if name and name:match("^Compact") then
				if db.texture ~= [[Interface\Default]] then
						self.healthBar:SetStatusBarTexture(db.texture)
						self.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
						self.powerBar:SetStatusBarTexture(db.texture)
						self.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
				end
			end
		end

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
			updateTextures(self)
		end)

		--RAID BUFFS
		if (db.partybuffs) == true then
			for i = 1, 4 do
				local f = _G["PartyMemberFrame" .. i]
				f:UnregisterEvent("UNIT_AURA")
				local g = CreateFrame("Frame")
				g:RegisterEvent("UNIT_AURA")
				g:SetScript(
					"OnEvent",
					function(self, event, a1)
						if a1 == f.unit then
							RefreshDebuffs(f, a1, 20, nil, 1)
						else
							if a1 == f.unit .. "pet" then
								PartyMemberFrame_RefreshPetDebuffs(f)
							end
						end
					end
				)
				local b = _G[f:GetName() .. "Debuff1"]
				b:ClearAllPoints()
				b:SetPoint("LEFT", f, "RIGHT", -7, 5)
				for j = 5, 20 do
					local l = f:GetName() .. "Debuff"
					local n = l .. j
					local c = CreateFrame("Frame", n, f, "PartyDebuffFrameTemplate")
					c:SetPoint("LEFT", _G[l .. (j - 1)], "RIGHT")
				end
			end
			for i = 1, 4 do
				local f = _G["PartyMemberFrame" .. i]
				f:UnregisterEvent("UNIT_AURA")
				local g = CreateFrame("Frame")
				g:RegisterEvent("UNIT_AURA")
				g:SetScript(
					"OnEvent",
					function(self, event, a1)
						if a1 == f.unit then
							RefreshBuffs(f, a1, 20, nil, 1)
						end
					end
				)
				for j = 1, 20 do
					local l = f:GetName() .. "Buff"
					local n = l .. j
					local c = CreateFrame("Frame", n, f, "TargetBuffFrameTemplate")
					c:EnableMouse(false)
					if j == 1 then
						c:SetPoint("TOPLEFT", 48, -32)
					else
						c:SetPoint("LEFT", _G[l .. (j - 1)], "RIGHT", 1, 0)
					end
				end
			end
		end
	end
end