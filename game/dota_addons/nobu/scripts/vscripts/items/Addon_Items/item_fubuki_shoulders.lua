--吹雪護肩

LinkLuaModifier( "modifier_fubuki_shoulders", "items/Addon_Items/item_fubuki_shoulders.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fubuki_shoulders2", "items/Addon_Items/item_fubuki_shoulders.lua",LUA_MODIFIER_MOTION_NONE )
modifier_fubuki_shoulders = class({})

--------------------------------------------------------------------------------

function modifier_fubuki_shoulders:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_fubuki_shoulders:OnCreated( event )
	self:StartIntervalThink(0.1)
end

function modifier_fubuki_shoulders:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
	end
end

function modifier_fubuki_shoulders:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()
	    if (self.caster ~= nil) and IsValidEntity(self.caster) then

		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster and self.hp ~= nil and damage_type == DAMAGE_TYPE_PHYSICAL then
				if victim:IsBuilding() or victim:IsMagicImmune() then
				else
					ability:ApplyDataDrivenModifier(self.caster, victim, "modifier_slow_move_speed", {})
					ability:ApplyDataDrivenModifier(self.caster, victim, "modifier_slow_attack_speed", {})
				end
		    end
		end
	end
end

modifier_fubuki_shoulders2 = class({})

--------------------------------------------------------------------------------

function modifier_fubuki_shoulders2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_fubuki_shoulders2:GetModifierIncomingDamage_Percentage(event)
	local current_mana = self.caster:GetMana()
	local max_mana = self.caster:GetMaxMana()
	if current_mana/max_mana > 0.5 then
		self.caster:SetMana(current_mana - event.damage*0.15)
		return -15
	else
		return 0
	end
end

function OnEquip(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:AddNewModifier(caster,ability,"modifier_fubuki_shoulders2",{})
	caster:FindModifierByName("modifier_fubuki_shoulders2").caster = caster
end

function OnUnequip(keys)
	keys.caster:RemoveModifierByName("modifier_fubuki_shoulders2")
end

function Start( keys )
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_A04R_Boom",nil)
	caster:AddNewModifier(caster,ability,"modifier_fubuki_shoulders",{duration=15})
	caster:FindModifierByName("modifier_fubuki_shoulders").caster = caster
	caster:FindModifierByName("modifier_fubuki_shoulders").hp = caster:GetHealth()
	local particle = ParticleManager:CreateParticle("particles/a04r3/a04r3.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	local shield_size = 50
	ParticleManager:SetParticleControl(particle, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(15, function ()
		ParticleManager:DestroyParticle(particle, true)
		end)
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		800,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		0,
		false)
	AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 800, 4, false)		
	for _,target in pairs(direUnits) do
		ability:ApplyDataDrivenModifier( caster, target, "modifier_slow_move_speed2", {duration = 4} )
	end
end

function Start2( keys )
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	caster:AddNewModifier(caster,ability,"modifier_fubuki_shoulders",{duration=14})
	caster:FindModifierByName("modifier_fubuki_shoulders").caster = caster
	local particle = ParticleManager:CreateParticle("particles/a04r3/a04r3.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	local shield_size = 50
	ParticleManager:SetParticleControl(particle, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(14, function ()
		ParticleManager:DestroyParticle(particle, true)
		end)
end

