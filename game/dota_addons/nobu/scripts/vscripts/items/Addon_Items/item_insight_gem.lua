
function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local eff1 = ParticleManager:CreateParticle("particles/b05t3/b05t3_j0.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(eff1, 0, caster:GetAbsOrigin())
	caster:EmitSound("RevealMap")
end


function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lose_gem", {})
end

function Death( keys )
	local caster = keys.caster
	local ability = keys.ability
	for itemSlot=0,8 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			print(item:GetName())
			local itemName = item:GetName()
			if (itemName == "item_insight_gem_s") then
				caster:RemoveModifierByName("modifier_lose_gem")
				item:Destroy()
			end
		end
	end
end

