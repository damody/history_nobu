
function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local eff1 = ParticleManager:CreateParticle("particles/b05t3/b05t3_j0.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(eff1, 0, caster:GetAbsOrigin())
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"RevealMap",caster)
end


function OnEquipHero( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lose_gem", {})
end

-- function OnEquipHeroNinja( keys )
-- 	local caster = keys.caster
-- 	local ability = keys.ability
-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lose_gem_ninja", {})
-- end


function Death( keys )
	local caster = keys.caster
	local ability = keys.ability
	for itemSlot=0,8 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			print(item:GetName())
			local itemName = item:GetName()
			if (itemName == "item_insight_gem_hero") then
				caster:RemoveModifierByName("modifier_lose_gem")
				item:Destroy()
			elseif (itemName == "item_insight_gem_ninja") then
				caster:RemoveModifierByName("modifier_lose_gem")
				item:Destroy()
			elseif (itemName == "item_insight_gem_Shard") then
				caster:RemoveModifierByName("modifier_lose_gem")
				item:Destroy()
			end
		end
	end
end

