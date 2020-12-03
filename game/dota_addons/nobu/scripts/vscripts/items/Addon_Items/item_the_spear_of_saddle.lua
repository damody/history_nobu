
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
	local ability = keys.ability
	local target = keys.target
	local armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	local armor_reduction_percentage = ability:GetSpecialValueFor("armor_reduction_percentage")
	local armor = target:GetPhysicalArmorValue(false)
	if target:HasModifier("modifier_spear_of_saddle2") then
		armor = armor/(1 - armor_reduction_percentage * 0.01)
	end
	if not target:IsBuilding() then
		if armor*armor_reduction_percentage*0.01 < math.abs(armor_reduction) then
			ability:ApplyDataDrivenModifier(caster, keys.target,"modifier_spear_of_saddle",{ duration = 1.5 })
		else
			ability:ApplyDataDrivenModifier(caster, keys.target,"modifier_spear_of_saddle2",{ duration = 1.5 })
			local modifier = target:FindModifierByName("modifier_spear_of_saddle2")
			if modifier ~= nil then
				if armor > 0 then 
					modifier:SetStackCount(armor*armor_reduction_percentage*0.01)
				else
					target:RemoveModifierByName("modifier_spear_of_saddle2")
				end
			end
		end
	end
end

function Shock1 ( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	if target:IsMagicImmune() then
		AMHC:Damage(caster,target,400,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
		caster:PerformAttack(target,true,true,false,true,false,false,true)
	end

end
