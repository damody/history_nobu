LinkLuaModifier( "kousetsusamonnji", "items/Addon_Items/item_kousetsusamonnji.lua",LUA_MODIFIER_MOTION_NONE )
--長船


kousetsusamonnji = class({})

function kousetsusamonnji:IsHidden()
	return true
end

function kousetsusamonnji:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function kousetsusamonnji:GetModifierPreAttack_CriticalStrike()
	return 220
end

function kousetsusamonnji:CheckState()
	local state = {
	}
	return state
end



function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local skill = keys.ability
	local ran =  RandomInt(0, 100)
	--caster:RemoveModifierByName("kousetsusamonnji")
	if (caster.kousetsusamonnji_count == nil) then
		caster.kousetsusamonnji_count = 0
	end
	if (ran > 25) then
		caster.kousetsusamonnji_count = caster.kousetsusamonnji_count + 1
	end
	caster:RemoveModifierByName("item_kousetsusamonnji_critical_strike_crit")
	if (caster.kousetsusamonnji_count >= 4 or ran <= 25) then
		caster.kousetsusamonnji_count = 0
		-- EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
		-- local rate = caster:GetAttackSpeed()
		if caster.maximum_critical_damage then
			if caster.maximum_critical_damage < caster:GetAverageTrueAttackDamage(target) * 2.2 then
				caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * 2.2
			end
		end
		
		skill:ApplyDataDrivenModifier(caster, caster, "item_kousetsusamonnji_critical_strike_crit", {} )
		--SE
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur_impact.vpcf", PATTACH_POINT, keys.target)
		-- ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
		--動作
		-- local rate = caster:GetAttackSpeed()
		
		-- --播放動畫
		-- if rate < 1 then
		--     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
		-- else
		--     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
		-- end

	end

end


