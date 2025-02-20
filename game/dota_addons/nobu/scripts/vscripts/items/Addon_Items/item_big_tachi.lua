LinkLuaModifier( "big_tachi", "items/Addon_Items/item_big_tachi.lua",LUA_MODIFIER_MOTION_NONE )
--野太刀


big_tachi = class({})

function big_tachi:IsHidden()
	return true
end

function big_tachi:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function big_tachi:GetModifierPreAttack_CriticalStrike()
	return 185
end

function big_tachi:CheckState()
	local state = {
	}
	return state
end



function Shock( keys )
    local caster = keys.caster
    local skill = keys.ability
    local target = keys.target
    local rate = caster:GetAttackSpeed()
    local ran =  RandomInt(0, 100)

    if (caster.big_tachi_count == nil) then
        caster.big_tachi_count = 0
    end
    if (ran > 20) then
        caster.big_tachi_count = caster.big_tachi_count + 1
    end
    caster:RemoveModifierByName("item_big_tachi_critical_strike_crit")
    if (caster.big_tachi_count >= 5 or ran <= 20) then
        caster.big_tachi_count = 0
        -- if rate < 1 then
        --     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
        -- else
        --     caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
        -- end
        if caster.maximum_critical_damage < caster:GetAverageTrueAttackDamage(target) * 1.85 then
            caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * 1.85
        end
        skill:ApplyDataDrivenModifier(caster, caster, "item_big_tachi_critical_strike_crit", {} )
    end
end

