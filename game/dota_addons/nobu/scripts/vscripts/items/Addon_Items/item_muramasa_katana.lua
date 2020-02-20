
function OnEquip( keys )	
	local caster = keys.caster
	local ability = keys.ability
	ability.attackCount = 0
	if (caster.nobuorb1 == nil) then
		caster.nobuorb1 = "muramasa_katana"
	end
	caster:FindModifierByName("modifier_muramasa_atk"):SetStackCount(caster.kill_count)
end

function OnUnequip( keys )	
	local caster = keys.caster
	if (caster.nobuorb1 == "muramasa_katana") then
		caster.nobuorb1 = nil
	end
	caster:RemoveModifierByName("modifier_muramasa_atk")
end

function KillCount( keys )
	local caster = keys.caster
	if caster:IsAlive() then
		caster:FindModifierByName("modifier_muramasa_atk"):SetStackCount(caster.kill_count)
	end
end

function StealLife(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not caster:FindModifierByName("modifier_muramasa_atk_speed") then ability.attackCount = 0 end
	ability:ApplyDataDrivenModifier(caster , caster, "modifier_muramasa_atk_speed", nil)
	ability.attackCount = ability.attackCount + 1
	if ability.attackCount > 10 then  ability.attackCount = 10 end
	local modifier = caster:FindModifierByName("modifier_muramasa_atk_speed")
	modifier:SetStackCount(ability.attackCount)
	if target.isvoid == nil then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		--if (caster.nobuorb1 == "muramasa_katana" or caster.nobuorb1 == "illusion" or caster.nobuorb1 == nil) and not target:IsBuilding() then
		if not target:IsBuilding() then
			caster.nobuorb1 = "muramasa_katana"
			local damageReduction = 0
			local targetArmor = target:GetPhysicalArmorValue(true)
			if targetArmor > 0 then
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
			else
				targetArmor = -targetArmor
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
				damageReduction = -damageReduction
			end
			if damageReduction < -1 then
				damageReduction = -1
			end
			if damageReduction > 1 then
				damageReduction = 1
			end
			caster:Heal(dmg*ability.attackCount*0.05*(1-damageReduction), ability)
		    ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end


function StealLife2(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if target.isvoid == nil then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		if not target:IsBuilding() then
			local damageReduction = 0
			local targetArmor = target:GetPhysicalArmorValue(true)
			if targetArmor > 0 then
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
			else
				targetArmor = -targetArmor
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
				damageReduction = -damageReduction
			end
			if damageReduction < -1 then
				damageReduction = -1
			end
			if damageReduction > 1 then
				damageReduction = 1
			end
			caster:Heal(dmg*keys.StealPercent*0.01*(1-damageReduction), ability)
		    ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end
