function OnEquip( keys )
    local caster = keys.caster
    local ability = keys.ability
    local states_resistance = ability:GetSpecialValueFor("states_resistance")
    local states_resistance1 = 0
    local ms_unslow = keys.ms_unslow
    local name = keys.name

    caster.states_res[name] = states_resistance
    if caster.states_res ~= nil then
        for k,v in pairs(caster.states_res) do
            if v > states_resistance1 then
                states_resistance1 = v
            end
        end
    caster.states_resistance = states_resistance1
    end

    if caster.ms_unslow  then
        caster.ms_unslow[name] = ms_unslow
    end


end
function OnUnequip( keys )
    local caster = keys.caster
    local ability = keys.ability
    local name = keys.name
    local states_resistance1 = 0
    local states_resistance = ability:GetSpecialValueFor("states_resistance")
    local ms_unslow = ability:GetSpecialValueFor("ms_unslow")

    
    caster.ms_unslow[name] = nil
    caster.states_res[name] = nil
    if caster.states_res ~= nil then
        for k,v in pairs(caster.states_res) do
            if v > states_resistance1 then
                states_resistance1 = v
            end
        end
        caster.states_resistance = states_resistance1
    else
        caster.states_resistance = 0
    end


end