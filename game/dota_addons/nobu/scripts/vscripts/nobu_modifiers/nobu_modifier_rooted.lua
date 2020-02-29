
--[[

dummy:AddNewModifier(dummy,nil,"nobu_modifier_rooted",spell_hint_table)

--]]

if nobu_modifier_rooted == nil then
	nobu_modifier_rooted = class({})
end

function nobu_modifier_rooted:IsHidden()
	return true
end

function nobu_modifier_rooted:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
    return funcs
end

function nobu_modifier_rooted:GetModifierMoveSpeed_Absolute()
	return 1
end

function nobu_modifier_rooted:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function nobu_modifier_rooted:GetTexture()
	return "venomancer_poison_sting"
end

function nobu_modifier_rooted:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

function nobu_modifier_rooted:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

LinkLuaModifier("nobu_modifier_rooted","nobu_modifiers/nobu_modifier_rooted.lua",LUA_MODIFIER_MOTION_NONE)