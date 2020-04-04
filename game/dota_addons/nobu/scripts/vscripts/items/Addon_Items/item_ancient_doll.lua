--久棄邪物

LinkLuaModifier( "modifier_zimbabwe", "items/Addon_Items/item_ancient_doll.lua",LUA_MODIFIER_MOTION_NONE )
modifier_zimbabwe = class({})

--------------------------------------------------------------------------------

function modifier_zimbabwe:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_zimbabwe:OnCreated( event )
	self:StartIntervalThink(0.1)
end

function modifier_zimbabwe:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
	end
end

function modifier_zimbabwe:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
		local ability = self:GetAbility()
		local caster = self.caster
	    if (caster ~= nil) and IsValidEntity(caster) then
		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster and not event.attacker:IsBuilding() then
		        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
	            	if (IsValidEntity(caster) and caster:IsAlive()) then
		            	local damageTable = {
							victim = victim, 
							attacker = caster,
							damage = event.original_damage,
							damage_type = damage_type,
							damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
						}
						if _G.EXCLUDE_TARGET_NAME[victim:GetUnitName()] == nil then
							ApplyDamage(damageTable)
						end
					end
		        end 
		    end
		end
	end
end

function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_ancient_doll", nil)
end

function OnUnequip( keys )
	local caster = keys.caster
	if caster:HasModifier("modifier_ancient_doll") then
		caster:RemoveModifierByName("modifier_ancient_doll")
	end
	if caster:HasModifier("modifier_dark_yellow_teeth_and_zimbabwe") then
		caster:RemoveModifierByName("modifier_dark_yellow_teeth_and_zimbabwe")
	end
end

function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	caster:AddNewModifier(caster, ability, "modifier_zimbabwe", {duration = 4.5})
	local hModifier = caster:FindModifierByName("modifier_zimbabwe")
	hModifier.caster = caster
	local shield_size = 1000
	zimbabwe = ParticleManager:CreateParticle("particles/item/zimbabwe.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(zimbabwe, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(zimbabwe, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(zimbabwe, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(zimbabwe, 5, Vector(shield_size,0,0))
	-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
	ParticleManager:SetParticleControlEnt(zimbabwe, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(4.5, function()
		ParticleManager:DestroyParticle(zimbabwe,false)
	end)
end

function AbilityExecuted(keys)
	local caster = keys.caster
	local id  = caster:GetPlayerID()
	local skill = keys.ability
	local level = keys.ability:GetLevel()
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" then return end
	if keys.event_ability:GetName() == "item_tpscroll" then return end

	if caster:HasModifier("modifier_ancient_doll") == false then
		skill:ApplyDataDrivenModifier(caster,caster,"modifier_ancient_doll",nil)
		local hModifier = caster:FindModifierByNameAndCaster("modifier_ancient_doll", hCaster)
		hModifier:SetStackCount(1)
	else
		local hModifier = caster:FindModifierByNameAndCaster("modifier_ancient_doll", hCaster)
		local scount = hModifier:GetStackCount()
		scount = scount + 1
		if (scount <= 8) then
			hModifier:SetStackCount(scount)
		end
	end
end

function Shock2( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local hModifier = caster:FindModifierByNameAndCaster("modifier_dark_yellow_teeth_and_zimbabwe", hCaster)
	local scount = hModifier:GetStackCount()
	hModifier:SetStackCount(0)
	AMHC:Damage(caster,target,scount*90,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	caster:Heal(scount*45, caster)
	local flame = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_model.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(flame,0,target:GetAbsOrigin()+Vector(0, 0, 100))
	Timers:CreateTimer(0.5, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
end


function AbilityExecuted2(keys)
	local caster = keys.caster
	local id  = caster:GetPlayerID()
	local skill = keys.ability
	local level = keys.ability:GetLevel()
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" then return end
	if keys.event_ability:GetName() == "item_tpscroll" then return end
	
	if caster:HasModifier("modifier_dark_yellow_teeth_and_zimbabwe") == false then
		skill:ApplyDataDrivenModifier(caster,caster,"modifier_dark_yellow_teeth_and_zimbabwe",nil)
		local hModifier = caster:FindModifierByNameAndCaster("modifier_dark_yellow_teeth_and_zimbabwe", hCaster)
		hModifier:SetStackCount(1)
	else
		local hModifier = caster:FindModifierByNameAndCaster("modifier_dark_yellow_teeth_and_zimbabwe", hCaster)
		local scount = hModifier:GetStackCount()
		scount = scount + 1
		if (scount <= 8) then
			hModifier:SetStackCount(scount)
		end
	end
end
