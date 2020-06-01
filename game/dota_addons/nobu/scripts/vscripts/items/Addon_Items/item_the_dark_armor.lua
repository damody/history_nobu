function Shock (keys)
    local caster = keys.caster
    local target = FindUnitsInRadius(
    caster:GetTeamNumber()
    ,caster:GetAbsOrigin()
    ,nil
    ,700
    ,DOTA_UNIT_TARGET_TEAM_FRIENDLY
    ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    ,DOTA_UNIT_TARGET_FLAG_NONE
    ,0
    ,false)
    local ability = keys.ability

    for i,v in pairs(target) do
        print(v.magical_resistance)
        if v.magical_resistance then
            v.magical_resistance = v.magical_resistance + 10
        end
        Timers:CreateTimer(6, function ()
            v.magical_resistance = v.magical_resistance - 10
            end)
    end
end