-- 山之捲
function Shock( keys )
    local caster = keys.caster
    local ability = keys.ability
	for itemSlot = 0,8 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil and ((item:GetName() == "item_mountain_scroll") or
				(item:GetName() == "item_the_art_of_war_mountain_chapter") or 
				(item:GetName() == "item_the_lost_art_of_war_2") or 
				(item:GetName() == "item_recipe_the_art_of_war"))then
			item:StartCooldown(ability:GetCooldown(-1))
		end
	end
	if not caster:HasModifier("modifier_item_mountain_scroll_resistance") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_mountain_scroll", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_art_of_war_mountain_chapter", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_mountain_scroll_resistance", {})
	end
end

function Shock2( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if not target:HasModifier("modifier_item_mountain_scroll_resistance") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_art_of_war_mountain_chapter", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_item_mountain_scroll_resistance", {})
	end
end