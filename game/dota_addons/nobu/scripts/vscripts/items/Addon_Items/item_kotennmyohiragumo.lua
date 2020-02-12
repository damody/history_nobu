--平蜘蛛釜
-- LinkLuaModifier( "modifier_kotennmyohiragumo", "items/Addon_Items/item_kotennmyohiragumo.lua",LUA_MODIFIER_MOTION_NONE )
-- modifier_kotennmyohiragumo = class({})

--------------------------------------------------------------------------------
function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local Time = keys.Time
	local am = target:FindAllModifiers()
	for _,v in pairs(am) do
		if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil then
			if v:GetParent():GetTeamNumber() ~= target:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
				target:RemoveModifierByName(v:GetName())
			end
		end
	end
	ability:ApplyDataDrivenModifier(caster, target,"modifier_perceive_wine",{duration=Time})
	-- Strong Dispel 刪除負面效果
	target:Purge( false, true, true, true, true)
	local sumt = 0
	Timers:CreateTimer(0.1, function()
		sumt = sumt + 0.1
		if sumt < Time then
			if (not target:HasModifier("modifier_perceive_wine")) and target.nomagic == nil then
				local tt = Time-sumt
				if IsValidEntity(target) and IsValidEntity(ability) then
					ability:ApplyDataDrivenModifier(caster, target,"modifier_perceive_wine",{duration=tt})
				end
			end
			return 0.1
		end
		end)
end

-- function modifier_kotennmyohiragumo:DeclareFunctions()
--     local funcs = {
--         MODIFIER_EVENT_ON_TAKEDAMAGE
--     }

--     return funcs
-- end

--------------------------------------------------------------------------------

-- function modifier_kotennmyohiragumo:OnCreated( event )
-- 	self:StartIntervalThink(0.1) 
-- end

-- function modifier_kotennmyohiragumo:OnIntervalThink()
-- 	if (self.caster ~= nil) and IsValidEntity(self.caster) then
-- 		self.hp = self.caster:GetHealth()
-- 	end
-- end

-- function modifier_kotennmyohiragumo:OnTakeDamage(event)
-- 	if IsServer() then
-- 	    local attacker = event.unit
-- 	    local victim = event.attacker
-- 	    local return_damage = event.original_damage
-- 	    local damage_type = event.damage_type
-- 	    local damage_flags = event.damage_flags
-- 	    local ability = self:GetAbility()

-- 	    if (self.caster ~= nil) and IsValidEntity(self.caster) then
-- 		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
-- 		        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
-- 		            if (damage_type == DAMAGE_TYPE_MAGICAL) then
-- 		            	self.caster:Heal(return_damage*1.5, self.caster)
-- 		            end 
-- 		        end
-- 		    end
-- 		end
-- 	end
-- end


-- function Shock( keys )
-- 	local caster = keys.caster
-- 	local ability = keys.ability
-- 	ShockTarget(keys, keys.target)
-- end

-- function ShockTarget( keys, target )
-- 	local caster = keys.caster
-- 	local ability = keys.ability
-- 	local havetime = tonumber(keys.Time)
-- 	ability:ApplyDataDrivenModifier( caster, target, "modifier_kotennmyohiragumo", {duration = havetime} )
-- 	target:FindModifierByName("modifier_kotennmyohiragumo").caster = target
-- 	target:FindModifierByName("modifier_kotennmyohiragumo").hp = caster:GetHealth()
-- 	local shield = ParticleManager:CreateParticle("particles/item/kotennmyohiragumo.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
-- 	target:FindModifierByName("modifier_kotennmyohiragumo").shield_effect = shield
-- 	local sumtime = 0
-- 	local isend = false
-- 	Timers:CreateTimer(havetime, function() 
-- 			isend = true
-- 		end)
-- 	Timers:CreateTimer(0, function() 
-- 			ParticleManager:SetParticleControl(shield,3,target:GetAbsOrigin()+Vector(0, 0, 0))
-- 			if not isend then
-- 				return 0.2
-- 			else
-- 				ParticleManager:DestroyParticle(shield, false)
-- 				return nil
-- 			end
-- 		end)
-- end
