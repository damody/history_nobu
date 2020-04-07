
function Shock( keys )
	-- 開關型技能不能用
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" or keys.event_ability:GetName() == "item_tpscroll" then return end

	local caster = keys.caster
	local ability = keys.ability
	if not caster:HasModifier("modifier_bizennosafunekanemitsu") then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_bizennosafunekanemitsu",nil)
		local handle = caster:FindModifierByName("modifier_bizennosafunekanemitsu")
		if handle then
			handle:SetStackCount(1)
			caster.bizennosafunekanemitsu = 1
		end
	else
		local handle = caster:FindModifierByName("modifier_bizennosafunekanemitsu")
		if handle then
			local c = handle:GetStackCount()
			c = c + 1
			if c > 4 then
				c = 4
			end
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_bizennosafunekanemitsu",nil)
			handle:SetStackCount(c)
			caster.bizennosafunekanemitsu = c
		end
	end

end

function Slow_enemy( keys )
	print("slow")
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetOrigin(), nil, 300,
									DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,v in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster,v,"modifier_slow_move_speed",{duration = 4})
	end									
end

function OnDestroy( keys )
	-- 開關型技能不能用
	local caster = keys.caster
	local ability = keys.ability
	caster.bizennosafunekanemitsu = caster.bizennosafunekanemitsu - 1
	if caster.bizennosafunekanemitsu > 0 then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_bizennosafunekanemitsu",nil)
		local handle = caster:FindModifierByName("modifier_bizennosafunekanemitsu")
		if handle then
			handle:SetStackCount(caster.bizennosafunekanemitsu)
		end
	end
end
	