LinkLuaModifier( "brave_ring", "items/Addon_Items/item_brave_ring.lua",LUA_MODIFIER_MOTION_NONE )
--長船


brave_ring = class({})

function brave_ring:IsHidden()
	return true
end

function brave_ring:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function brave_ring:GetModifierPreAttack_CriticalStrike()
	return 200
end

function brave_ring:CheckState()
	local state = {
	}
	return state
end



function Shock( keys )
	local caster = keys.caster
	local skill = keys.ability
	local ran =  RandomInt(0, 100)
	caster:RemoveModifierByName("brave_ring")
	if (caster.brave_ring_count == nil) then
		caster.brave_ring_count = 0
	end
	if (ran > 15) then
		caster.brave_ring_count = caster.brave_ring_count + 1
	end
	if (caster.brave_ring_count > 7 or ran <= 15) then
		caster.brave_ring_count = 0
		StartSoundEvent( "Hero_SkeletonKing.CriticalStrike", keys.target )
		local rate = caster:GetAttackSpeed()
		caster:AddNewModifier(caster, skill, "brave_ring", { duration = rate+0.1 } )
		--SE
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur_impact.vpcf", PATTACH_POINT, keys.target)
		-- ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
		--動作
		local rate = caster:GetAttackSpeed()
		--print(tostring(rate))

		--播放動畫
	    --caster:StartGesture( ACT_SLAM_TRIPMINE_ATTACH )
		if rate < 1 then
		    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
		else
		    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
		end

	end

end


