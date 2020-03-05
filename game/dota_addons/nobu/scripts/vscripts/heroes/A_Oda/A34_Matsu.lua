
--[[
	Author: kritth
	Date: 7.1.2015.
	Refresh cooldown
]]
--紀錄技能
abilities = {"A34W","A34E","A34R"}

function A34W_OnUpgrade(keys)
	local ability = keys.ability
	print(ability:GetCooldownTime())
end

function A34E_OnUpgrade(keys)
end

function A34R_OnUpgrade(keys)
end

function A34T_OnCreated( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local cd_recover = ability:GetSpecialValueFor("cd_recover")
	local particle = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf", PATTACH_POINT, caster )
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 2, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 3, caster:GetAbsOrigin() )
	caster.cd_recover = cd_recover * 0.01
end

function A34T_OnDestroy( keys )
	local caster = keys.caster
	caster.cd_recover = 0
end

function A34T_OnIntervalThink( keys )
	local caster = keys.caster
	for i = 1,3 do
		if caster:FindAbilityByName(abilities[i]) then
			local ability = caster:FindAbilityByName(abilities[i])
			local cooldown = ability:GetCooldown(-1)
			local current_cooldown = ability:GetCooldownTime()
			if current_cooldown > cooldown * (1 - caster.cd_recover) then
				ability:EndCooldown()
				ability:StartCooldown(cooldown * (1 - caster.cd_recover))
			end
		end
	end
end

function rearm_refresh_cooldown( keys )
	local caster = keys.caster
	local particle = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf", PATTACH_POINT, caster )
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 2, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 3, caster:GetAbsOrigin() )
	-- Timers:CreateTimer( 0.5, function()
	-- 		ParticleManager:DestroyParticle(particle,false)
	-- 	end)
	
	-- Reset cooldown for abilities that is not rearm
	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability ~= keys.ability then
			ability:EndCooldown()
		end
	end
	
	-- Put item exemption in here
	local exempt_table = {}
	
	-- Reset cooldown for items
	local ability = keys.ability
	local CDR = ability:GetLevelSpecialValueFor("cd_recover" , ability:GetLevel() - 1)
	for i = 0, 5 do
		local item = caster:GetItemInSlot( i )
		if item and not exempt_table[ item:GetAbilityName() ] then
			local CD_remain = item:GetCooldownTimeRemaining()
			if CD_remain > 0 then
				item:EndCooldown()
				item:StartCooldown(CD_remain - CDR)
			end
		end
	end
end

function A34D_20_OnAbilityExecuted( keys )
	-- 開關型技能不能用
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "attribute_bonusx" then return end
	local caster = keys.caster
	local ability = keys.ability
	local skill = "WERT"
	for si=1,#skill do
      local handle = caster:FindAbilityByName("A34"..skill:sub(si,si).."_20")
      if handle then
			if not handle:IsCooldownReady() then
				local t = handle:GetCooldownTimeRemaining()
				handle:EndCooldown()
				handle:StartCooldown(t-1)
			end
		end
    end
end


function A34W_20_OnProjectileHitUnit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local duration = ability:GetSpecialValueFor("duration")
	if not target:IsHero() then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_frost_bite_root_datadriven", {duration = duration+1.5} )
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_frost_bite_root_datadriven", {duration = duration} )
	end
end