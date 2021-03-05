function chance_cannot_miss( keys )
    local ability = keys.ability
    local caster = keys.caster
    local random = RandomInt(1,100)
    if random <= 65 then
        local rate = 1/caster:GetAttacksPerSecond()
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_chance_cannot_miss",{duration = rate})
    end
end

