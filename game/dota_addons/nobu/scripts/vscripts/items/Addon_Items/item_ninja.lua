function Shock(keys)
    local caster = keys.caster
    if caster.olderNinja == nil then caster.olderNinja = 1 end
    local donkey = CreateUnitByName("ninja_unit1", caster:GetAbsOrigin() + Vector(50, 100, 0), true, caster, caster, caster:GetTeamNumber())
    donkey:SetOwner(caster)
    donkey.owner = caster
    donkey:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	donkey:AddNewModifier(donkey,ability,"modifier_phased",{duration=0.1})
    donkey:AddNewModifier(donkey,nil,"modifier_kill",{duration=180})
    -- 紀錄忍者替換
    if (caster.ninja1 == nil) and (caster.ninja2 == nil) then
        caster.ninja1 = donkey
        donkey.number = 1
        caster.olderNinja = 1
    elseif (caster.ninja1 ~= nil) and (caster.ninja2 ~= nil) then
        if caster.olderNinja == 1 then    
            caster.ninja1:RemoveModifierByName("modifier_kill")
            --caster.ninja1:AddNewModifier(donkey,nil,"modifier_kill",{duration=0})
            caster.ninja1 = donkey
            donkey.number = 1
            caster.olderNinja = 2
        elseif caster.olderNinja == 2 then
            caster.ninja2:RemoveModifierByName("modifier_kill")
            --caster.ninja2:AddNewModifier(donkey,nil,"modifier_kill",{duration=0})
            caster.ninja2 = donkey
            caster.olderNinja = 1
            donkey.number = 2
        end
    elseif caster.ninja1 == nil then
        caster.ninja1 = donkey
        donkey.number = 1
        caster.olderNinja = 2
    elseif caster.ninja2 == nil then
        caster.ninja2 = donkey
        donkey.number = 2
        caster.olderNinja = 1
    end
end