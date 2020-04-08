local shield_size = 75
function OnEquip( keys )
    local caster = keys.caster
    local ability = keys.ability
    caster.kisyosennfuyuzuki_shield = ParticleManager:CreateParticle("particles/item_kisyosennfuyuzuki/item_kisyosennfuyuzuki.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 5, Vector(shield_size,0,0))
    ParticleManager:SetParticleControlEnt(caster.kisyosennfuyuzuki_shield, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_shield", {})
    if caster.shield_stack == nil then
        caster.shield_stack = 0
    end
    caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
    ability.shield_broken = false
    
end

function OnUnequip( keys )
    local caster = keys.caster
    local ability = keys.ability
    caster:RemoveModifierByName("modifier_shield")
    ParticleManager:DestroyParticle(caster.kisyosennfuyuzuki_shield, false)
end

function Take_mana_to_shield( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetMana() > caster:GetMaxMana()*0.4 then
        caster.shield_stack = caster:FindModifierByName("modifier_shield"):GetStackCount()
        if caster:GetMana() >= caster:GetMaxMana()*0.4 then
            if ability.shield_broken then
                caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
                caster.kisyosennfuyuzuki_shield = ParticleManager:CreateParticle("particles/item_kisyosennfuyuzuki/item_kisyosennfuyuzuki.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 1, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 2, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 4, Vector(shield_size,0,shield_size))
                ParticleManager:SetParticleControl(caster.kisyosennfuyuzuki_shield, 5, Vector(shield_size,0,0))
                ParticleManager:SetParticleControlEnt(caster.kisyosennfuyuzuki_shield, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                ability.shield_broken = false
            end
            caster.shield_stack = caster.shield_stack + caster:GetMana() - caster:GetMaxMana()*0.4
            if caster.shield_stack > caster:GetMaxMana() * 0.6 then
                caster.shield_stack = caster:GetMaxMana() * 0.6
            end
            caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
            caster:SetMana(caster:GetMaxMana() * 0.4)
        end
    end
end

function OnTakeDamage( keys )
    local caster = keys.caster
    local ability = keys.ability
    local attacker = keys.attacker
    local damage = keys.dmg
    caster.shield_stack = caster:FindModifierByName("modifier_shield"):GetStackCount()
    local count = 0
    if caster.shield_stack == 0 then
        return nil
    end
    caster.shield_stack = caster.shield_stack - damage
    if caster.shield_stack < 0 then
        caster:FindModifierByName("modifier_shield"):SetStackCount(0)
        AMHC:Damage( attacker,caster,caster.shield_stack * -1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
        if caster.kisyosennfuyuzuki_shield then
            ability.shield_broken = true
            ParticleManager:DestroyParticle(caster.kisyosennfuyuzuki_shield, false)
        end
        caster.shield_stack = 0
    else
        caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
        caster:Heal(damage,caster)
    end
end