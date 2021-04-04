--[[
    Usage

    copy these code into `scripts\vscripts\equilibrium_constant.lua`
    add `require 'equilibrium_constant'` inside your addon_game_mode.lua
]]

-- 
local HP_PER_STR = 25
local HP_REGEN_PER_STR = 0.2
local MANA_PER_INT = 18
local MANA_REGEN_PER_INT = 0.15
local ARMOR_PER_AGI = 0.2
local ATKSPD_PER_AGI = 1.5
local MAX_MS = 700
local movespeed = 0


-- default value from dota
local DEFAULT_HP_PER_STR = 20
local DEFAULT_HP_REGEN_PER_STR = 0.1
local DEFAULT_MANA_PER_INT = 12
local DEFAULT_MANA_REGEN_PER_INT = 0.05
local DEFAULT_ARMOR_PER_AGI = 0.14
local DEFAULT_ATKSPD_PER_AGI = 1

local HP_PER_STR_DIFF = HP_PER_STR - DEFAULT_HP_PER_STR
local HP_REGEN_PER_STR_DIFF = HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
local MANA_PER_INT_DIFF = MANA_PER_INT - DEFAULT_MANA_PER_INT
local MANA_REGEN_PER_INT_DIFF = MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
local ARMOR_PER_AGI_DIFF = ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
local ATKSPD_PER_AGI_DIFF = ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI

if equilibrium_constant == nil then
    equilibrium_constant = class({})
end




function equilibrium_constant:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MIN,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }
    return funcs
end

function equilibrium_constant:GetModifierHealthBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsHero() then
            local str = owner:GetStrength()
            local HealthBonus = HP_PER_STR_DIFF * str
            return HealthBonus
        end
        return 0
    end
end

function equilibrium_constant:GetModifierIgnoreMovespeedLimit( params )
    return MAX_MS
end

function equilibrium_constant:GetModifierManaBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsHero() then
            local int = owner:GetIntellect()
            local ManaBonus = MANA_PER_INT_DIFF * int
            return ManaBonus
        end
        return 0
    end
end

function equilibrium_constant:GetModifierAttackSpeedBonus_Constant( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsHero() then
            local agi = owner:GetAgility()
            local AtkSpeedBonus = ATKSPD_PER_AGI_DIFF * agi
            owner.Aspd = AtkSpeedBonus
            AtkSpeedBonus = 0
            return AtkSpeedBonus
        end
        return 0
    end
end

function equilibrium_constant:GetModifierPhysicalArmorBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsHero() then
            local agi = owner:GetAgility()
            local ArmorBonus = ARMOR_PER_AGI_DIFF * agi
            owner.ArmorBonus = ArmorBonus
            return ArmorBonus
        end
        return 0
    end
end

function equilibrium_constant:GetModifierConstantManaRegen( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsHero() then
            local int = owner:GetIntellect()
            local ManaRegenBonus = MANA_REGEN_PER_INT_DIFF * int
            owner.ManaRegen = ManaRegenBonus
            ManaRegenBonus = 0
            return ManaRegenBonus
        end
        return 0
    end
end

function equilibrium_constant:GetModifierConstantHealthRegen( params )
    if IsServer() then
        local owner = self:GetParent()
        if owner:IsAlive() and owner:IsHero() then
            local str = owner:GetStrength()
            local HealthRegenBonus = HP_REGEN_PER_STR_DIFF * str
            -- if owner:GetBaseAttackRange() < 200 then
            --     HealthRegenBonus = HealthRegenBonus + str * HP_REGEN_PER_STR_DIFF
            -- end
            owner.HealthRegen = HealthRegenBonus
            HealthRegenBonus = 0
            return HealthRegenBonus
        end
        return 0
    end
end

function equilibrium_constant:IsHidden()
    return true
end

function equilibrium_constant:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function equilibrium_constant:GetModifierMoveSpeed_Min( params )
    return 0
end

function equilibrium_constant:GetModifierMoveSpeed_Max( params )
    return MAX_MS
end

function equilibrium_constant:GetModifierMoveSpeed_Limit( params )
    return MAX_MS
end

function equilibrium_constant:x_Start()
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( equilibrium_constant, "x_OnNPCSpawned" ), self )
end

function equilibrium_constant:x_OnNPCSpawned(keys)
    local hSpawnedUnit = EntIndexToHScript( keys.entindex )
    if IsValidEntity(hSpawnedUnit) then
        hSpawnedUnit.ms_slow = {}
        hSpawnedUnit.as_slow = {}
        hSpawnedUnit.ms_unslow = {}
        hSpawnedUnit.states_res = {}
        hSpawnedUnit.HealthRegen = 0
        hSpawnedUnit.ManaRegen = 0
        hSpawnedUnit.Aspd = 0
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("slow_self") then
        hSpawnedUnit:FindAbilityByName("slow_self"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("HealthRegen_self") then
        hSpawnedUnit:FindAbilityByName("HealthRegen_self"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("ManaRegen_self") then
        hSpawnedUnit:FindAbilityByName("ManaRegen_self"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("AtkSpeedBonus_self") then
        hSpawnedUnit:FindAbilityByName("AtkSpeedBonus_self"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("Attack_fail") then
        hSpawnedUnit:FindAbilityByName("Attack_fail"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("for_cp_position") then
        hSpawnedUnit:FindAbilityByName("for_cp_position"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("hold_position") then
        hSpawnedUnit:FindAbilityByName("hold_position"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("cp_recover") then
        hSpawnedUnit:FindAbilityByName("cp_recover"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("robbers_skill") then
        hSpawnedUnit:FindAbilityByName("robbers_skill"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit.FindAbilityByName and hSpawnedUnit:FindAbilityByName("warrior_souls_skill") then
        hSpawnedUnit:FindAbilityByName("warrior_souls_skill"):SetLevel(1)
    end
    if IsValidEntity(hSpawnedUnit)
        and hSpawnedUnit.GetAgility and hSpawnedUnit.GetIntellect and hSpawnedUnit.GetStrength
        and not hSpawnedUnit:HasModifier("equilibrium_constant")
        then
        if hSpawnedUnit.AddNewModifier ~= nil then
            hSpawnedUnit:AddNewModifier(hSpawnedUnit,nil,"equilibrium_constant",{})
        end
    end
    if IsValidEntity(hSpawnedUnit) and hSpawnedUnit:IsHero() then
        self.owner = hSpawnedUnit
    end
end

LinkLuaModifier("equilibrium_constant","equilibrium_constant.lua",LUA_MODIFIER_MOTION_NONE)
equilibrium_constant():x_Start()