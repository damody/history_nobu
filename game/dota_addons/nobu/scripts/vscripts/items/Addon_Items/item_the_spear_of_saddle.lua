
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
	--if not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, keys.target,"modifier_spear_of_saddle",{ duration = 1.5 })
	--end
end

