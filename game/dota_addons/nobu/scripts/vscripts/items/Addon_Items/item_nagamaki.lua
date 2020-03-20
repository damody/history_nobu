function Shock ( keys )
    local caster = keys.caster
    local ability = keys.ability
    local max_hp = caster:GetMaxHealth()
    local hp = caster:GetHealth()
    if hp - max_hp * 0.1 < 0 then
        ability:EndCooldown()
        return 
    end
    caster:SetHealth(hp - max_hp * 0.1)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_nagamaki", {duration = 10})
end