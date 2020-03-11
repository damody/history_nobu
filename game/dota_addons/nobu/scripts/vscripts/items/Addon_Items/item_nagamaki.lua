function Shock ( keys )
    local caster = keys.caster
    local ability = keys.ability
    local hp = caster:GetHealth()
    caster:SetHealth(hp * 0.9)
end