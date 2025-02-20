local shield_size = 75
function OnEquip( keys )
    Timers:CreateTimer(0.1,function()
        local caster = keys.caster
        local ability = keys.ability
        if caster:IsIllusion()then
            return 
        end
        if caster:GetUnitName() ~= "npc_dota_courier2" then
            caster.kisyosennfuyuzuki_shield = ParticleManager:CreateParticle("particles/item_kisyosennfuyuzuki/item_kisyosennfuyuzuki.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 1, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 2, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 4, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 5, Vector(shield_size,0,0))
            ParticleManager:SetParticleControlEnt(caster.kisyosennfuyuzuki_shield, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        end
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_shield", {})
        caster:AddNewModifier(caster, ability, "modifier_kisyosennfuyuzuki_shield", {})
        if caster:FindModifierByName("modifier_kisyosennfuyuzuki_shield") then
            caster:FindModifierByName("modifier_kisyosennfuyuzuki_shield").caster = caster
        end
        if caster.shield_stack == nil then
            caster.shield_stack = 0
        end
        if caster:FindModifierByName("modifier_shield") then
            caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
        end
        ability.shield_broken = false
        if not caster:IsAlive() then
            return 1
        end
    end)
end

function OnUnequip( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster.kisyosennfuyuzuki_shield then
        caster:RemoveModifierByName("modifier_shield")
        caster:RemoveModifierByName("modifier_kisyosennfuyuzuki_shield")
        ParticleManager:DestroyParticle(caster.kisyosennfuyuzuki_shield, false)    
    end
end

function Take_mana_to_shield( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:IsIllusion() then
        return 
    end
    if caster:FindModifierByName("modifier_shield") == nil then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_shield", {})
        caster:AddNewModifier(caster, ability, "modifier_kisyosennfuyuzuki_shield", {})
    end
    if caster.shield_stack == nil then
        caster.shield_stack = 0
    end
    local mana04 = caster:GetMaxMana()*0.5
    if caster:GetMana() > mana04 then
        if caster:GetMana() >= mana04 then
            if ability.shield_broken then
                caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
                if caster.kisyosennfuyuzuki_shield then
                    ParticleManager:DestroyParticle(caster.kisyosennfuyuzuki_shield, false)
                end
                caster.kisyosennfuyuzuki_shield = ParticleManager:CreateParticle("particles/item_kisyosennfuyuzuki/item_kisyosennfuyuzuki.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 1, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 2, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 4, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 5, Vector(shield_size,0,0))
                ParticleManager:SetParticleControlEnt(caster.kisyosennfuyuzuki_shield, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                ability.shield_broken = false
            end
            caster.shield_stack = caster.shield_stack + math.abs(caster:GetMana() - mana04)
            if caster.shield_stack > caster:GetMaxMana() * 0.5 then
                caster.shield_stack = caster:GetMaxMana() * 0.5
            end
            caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack*0.8)
            caster:SetMana(caster:GetMaxMana() * 0.5)
        end
    end
end

function DumpTable( tTable )
	local inspect = require('inspect')
	local iDepth = 2
 	print(inspect(tTable,
 		{depth=iDepth} 
 	))
end
