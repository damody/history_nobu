LinkLuaModifier( "great_sword_of_precision", "items/Addon_Items/item_the_great_sword_of_precision.lua",LUA_MODIFIER_MOTION_NONE )
--長船


great_sword_of_precision = class({})

function great_sword_of_precision:IsHidden()
	return true
end

function great_sword_of_precision:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function great_sword_of_precision:GetModifierPreAttack_CriticalStrike()
	return 300
end

function great_sword_of_precision:CheckState()
	local state = {
	}
	return state
end



function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local skill = keys.ability
	local ran =  RandomInt(0, 100)
	--caster:RemoveModifierByName("great_sword_of_precision")
	if (caster.great_sword_of_precision_count == nil) then
		caster.great_sword_of_precision_count = 0
	end
	if (ran > 25) then
		caster.great_sword_of_precision_count = caster.great_sword_of_precision_count + 1
	end
	caster:RemoveModifierByName("item_the_great_sword_of_precision_critical_strike_crit")
	if (caster.great_sword_of_precision_count >= 4 or ran <= 25) then
		caster.great_sword_of_precision_count = 0
		-- EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
		-- local rate = caster:GetAttackSpeed()
		if caster.maximum_critical_damage < caster:GetAverageTrueAttackDamage(target) * 3 then
			caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * 3
		end
		skill:ApplyDataDrivenModifier(caster, caster, "item_the_great_sword_of_precision_critical_strike_crit", { } )
		--SE
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur_impact.vpcf", PATTACH_POINT, keys.target)
		-- ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
		--動作
		-- local rate = caster:GetAttackSpeed()
		--print(tostring(rate))

		--播放動畫
	    --caster:StartGesture( ACT_SLAM_TRIPMINE_ATTACH )
		-- if rate < 1 then
		--     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
		-- else
		--     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
		-- end

	end

end


