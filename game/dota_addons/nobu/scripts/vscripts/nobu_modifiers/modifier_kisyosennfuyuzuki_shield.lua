modifier_kisyosennfuyuzuki_shield = class({})

function modifier_kisyosennfuyuzuki_shield:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_kisyosennfuyuzuki_shield:OnCreated( keys )
    if IsServer() then
        self.caster = self:GetParent()
    end
end

function modifier_kisyosennfuyuzuki_shield:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local caster = attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
        local damage_flags = event.damage_flags
        local damage = event.damage
        local ability = self:GetAbility()
        if caster:FindModifierByName("modifier_shield") then
            local lastshield = caster.shield_stack
            caster.shield_stack = caster.shield_stack - damage
            if caster.shield_stack < 0 then
                caster:FindModifierByName("modifier_shield"):SetStackCount(0)
                caster:SetHealth(caster:GetHealth()+lastshield)
                if caster.kisyosennfuyuzuki_shield then
                    ability.shield_broken = true
                    ParticleManager:DestroyParticle(caster.kisyosennfuyuzuki_shield, false)
                end
                caster.shield_stack = 0
            else
                caster:FindModifierByName("modifier_shield"):SetStackCount(caster.shield_stack)
                if damage >= caster:GetHealth() and caster:IsIllusion() then
                    --print("kill iluustion")
                else
                    caster:SetHealth(caster:GetHealth()+damage)
                end
            end
        end
	end
end

function modifier_kisyosennfuyuzuki_shield:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

LinkLuaModifier("modifier_kisyosennfuyuzuki_shield","nobu_modifiers/modifier_kisyosennfuyuzuki_shield.lua",LUA_MODIFIER_MOTION_NONE)