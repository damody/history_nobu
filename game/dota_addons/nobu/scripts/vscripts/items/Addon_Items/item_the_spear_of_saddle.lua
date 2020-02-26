
function OnEquip( keys )
	local caster = keys.caster
	if (caster.nobuorb1 == nil) then
		caster.nobuorb1 = "spear_of_saddle"
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	if (caster.nobuorb1 == "spear_of_saddle") then
		caster.nobuorb1 = nil
	end
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			if (string.match(itemName,"spear_of_saddle")) then
				caster.nobuorb1 = "spear_of_saddle"
				break
			end
		end
	end
end

function Shock( keys )
	local caster = keys.caster
	local skill = keys.ability
	local target = keys.target
	local armor_reduce_percentage = skill:GetSpecialValueFor("ARMOR_REDUCE_PERCENTAGE")
	local armor = target:GetPhysicalArmorValue(false)
	print(armor)
	if target:HasModifier("modifier_spear_of_saddle") then
		armor = armor/(1 - armor_reduce_percentage * 0.01)
	end
	if not target:IsBuilding() then
		skill:ApplyDataDrivenModifier(caster, keys.target,"modifier_spear_of_saddle",{ duration = 1 })
		local modifier = target:FindModifierByName("modifier_spear_of_saddle")
		if modifier ~= nil then
			if armor > 0 then 
				modifier:SetStackCount(armor*armor_reduce_percentage*0.01)
			else
				target:RemoveModifierByName("modifier_spear_of_saddle")
			end
		end
	end
end

