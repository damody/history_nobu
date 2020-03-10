nobu_modifier_magical_shield = class({})

function nobu_modifier_magical_shield:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function nobu_modifier_magical_shield:OnCreated( keys )
    if IsServer() then
        self.caster = self:GetParent()
        self.magical_shield = keys.magical_shield or 500
        self.counter = 0
        self.shield_effect = ParticleManager:CreateParticle("particles/item/supressor_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(self.shield_effect, 1, self.caster:GetAbsOrigin()+Vector(0, 0, 0))
        self:StartIntervalThink(0.1) 
    end
end

function nobu_modifier_magical_shield:GetModifierIncomingDamage_Percentage( keys )
    local damage_type = keys.damage_type
    --if damage type is magical
    if damage_type == 2 then
        self.magical_shield = self.magical_shield - keys.damage
        print(self.magical_shield)
        if self.magical_shield > 0 then
            return -100
        else
            return (self.magical_shield / keys.damage)*100
        end
    end
end


function nobu_modifier_magical_shield:OnIntervalThink()
    self.counter = self.counter + 1
    if self.counter >= 50 or self.magical_shield < 0 then
        ParticleManager:DestroyParticle(self.shield_effect, false)
    end
end

LinkLuaModifier("nobu_modifier_magical_shield","nobu_modifiers/nobu_modifier_magical_shield.lua",LUA_MODIFIER_MOTION_NONE)