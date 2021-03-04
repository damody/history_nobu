
LinkLuaModifier( "modifier_A07W", "scripts/vscripts/heroes/A_Oda/A07_Honda_Tadakatsu.lua",LUA_MODIFIER_MOTION_NONE )
modifier_A07W = class({})

--------------------------------------------------------------------------------

function modifier_A07W:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_A07W:OnCreated( event )
	self:StartIntervalThink(0.1)
end

function modifier_A07W:OnIntervalThink()
	if self.caster ~= nil then
		self.hp = self.caster:GetHealth()
	end
end

function modifier_A07W:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()
	    if (self.caster ~= nil) and IsValidEntity(self.caster) then
	    	if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
	    		if (damage_type ~= DAMAGE_TYPE_PHYSICAL) then
					self.caster:SetHealth(self.hp + event.original_damage * 0.3)
					self.hp = self.hp + event.original_damage * 0.3
				else
					self.caster:SetHealth(self.hp)
				end
			end
		end
	end
end


LinkLuaModifier( "A07R_critical", "scripts/vscripts/heroes/A_Oda/A07_Honda_Tadakatsu.lua",LUA_MODIFIER_MOTION_NONE )


--RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

A07R_critical = class({})

function A07R_critical:IsHidden()
	return true
end

function A07R_critical:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function A07R_critical:GetModifierPreAttack_CriticalStrike()
	return self.A07R_level
end

function A07R_critical:CheckState()
	local state = {
	}
	return state
end


function A07R_Levelup( keys )
	local caster = keys.caster
	caster.A07R_noncrit_count = 0
	
end

function A07R_old( keys )
	local caster = keys.caster
	local target = keys.target
	local skill = keys.ability
	local ability = keys.ability
	local ran =  RandomInt(0, 100)
	caster.A07R_noncrit_count = 0 or caster.A07R_noncrit_count
	caster:RemoveModifierByName("A07R_critical")
	if not keys.target:IsUnselectable() or keys.target:IsUnselectable() then
		if (ran > 30) then
			caster.A07R_noncrit_count = caster.A07R_noncrit_count + 1
		end
		if (caster.A07R_noncrit_count > 4 or ran <= 30) then
			caster.A07R_noncrit_count = 0
			EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
			local rate = caster:GetAttackSpeed()
			caster:AddNewModifier(caster, skill, "A07R_critical", { duration = rate+0.1 } )
			local hModifier = caster:FindModifierByNameAndCaster("A07R_critical", caster)
			--SE
			-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur_impact.vpcf", PATTACH_POINT, keys.target)
			-- ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
			--動作
			local rate = caster:GetAttackSpeed()

			--播放動畫
		    --caster:StartGesture( ACT_SLAM_TRIPMINE_ATTACH )
			if rate < 1 then
			    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
			else
			    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
			end

			if (hModifier ~= nil) then
				hModifier.A07R_level = ability:GetLevelSpecialValueFor("crit_persent",ability:GetLevel() - 1) 
				if caster.maximum_critical_damage < caster:GetAverageTrueAttackDamage(target) * (hModifier.A07R_level / 100) then 
					caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * (hModifier.A07R_level / 100)
				end
			end
		end
	end
end

function A07W_SE( event )
	-- Variables
	local target = event.caster
	local caster = event.caster
	local ability = event.ability
	local shield_size = 30 -- could be adjusted to model scale

	ability:ApplyDataDrivenModifier(caster,caster,"modifier_A07W",{duration=event.Time})
	caster:FindModifierByName("modifier_A07W").caster = caster
	caster:FindModifierByName("modifier_A07W").hp = caster:GetHealth()
	-- -- Strong Dispel 刪除負面效果
	-- local RemovePositiveBuffs = false
	-- local RemoveDebuffs = true
	-- local BuffsCreatedThisFrameOnly = false
	-- local RemoveStuns = true
	-- local RemoveExceptions = false
	-- target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		target.ShieldParticle = ParticleManager:CreateParticle("particles/a07w5/a07w5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)--attach_attack1
	end)
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function A07W_EndShieldParticle( event )
	local target = event.caster
	if target.ShieldParticle ~= nil then
		ParticleManager:DestroyParticle(target.ShieldParticle,false)
		target.ShieldParticle = nil
	end
	target:RemoveModifierByName("modifier_A07W")
end


function A07W_BorrowedTimeHeal( event )
	--[[
		【邏輯概念】:假如傷害大於0 就代表不是物理傷害
	]]

	-- -- Variables
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	
	if damage > 0 then
		caster:Heal(damage, caster)
	end
	
end

function A07W_BorrowedTimePurge( event )
	local caster = event.caster

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)--驅散負面效果
end


----------------------------------------------------------------------------<<A07E>>------------------------------------------------------------------------------
function A07E_SE( keys )
	local caster = keys.caster
	if (keys.target ~= nil) then
		caster = keys.target
		AMHC:CreateParticle("particles/a07e/a07e.vpcf",PATTACH_ABSORIGIN,false,caster,2.0,nil)
	else
		AMHC:CreateParticle("particles/a07e/a07e.vpcf",PATTACH_ABSORIGIN,false,caster,2.0,nil)
	end
end

function A07E_Unslow( keys )
	local caster = keys.caster
	caster.as_slow = {}
	caster.ms_slow = {}
end

--[[Author: LinWeiHan
	Date: 03.05.2016.
	It Heal HP and attack's speed]]
function A07D_HealHP( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	-- local hModifier = caster:FindModifierByNameAndCaster("modifier_A07T", caster)--獲取modifier
	local float_healhp

	-- if hModifier ~= nil then
	-- 	float_healhp = ((caster:GetHealth()) + (0.06 * caster:GetMaxHealth()))
	-- 	caster:SetHealth(float_healhp)
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_A07D", {duration = duration})
	-- else
	float_healhp = ((caster:GetHealth()) + (0.03 * caster:GetMaxHealth()))
	caster:SetHealth(float_healhp)	
	-- end
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function A07R_Learn_Skill( keys )
	local caster = keys.caster
	local skill = keys.ability
	local level = keys.ability:GetLevel()

	local ability = caster:FindAbilityByName("A07D")
	if ability ~= nil then
		ability:SetLevel(level+1)
		ability:SetActivated(true)
	end
	local ability2 = caster:FindAbilityByName("A07D2")
	if ability2 ~= nil then
		ability2:SetLevel(level+1)
		ability2:SetActivated(true)
	end
end

--[[Author: LinWeiHan
	Date: 03.05.2016.]]

function A07T_Transform( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()

	local duration = ability:GetLevelSpecialValueFor("duration",level - 1)
	local am = caster:FindAllModifiers()
	local A07W_ability = caster:FindAbilityByName("A07W")
	local A07W_cooldown = A07W_ability:GetCooldownTime()
	local A07E_ability = caster:FindAbilityByName("A07E")
	local A07E_cooldown = A07E_ability:GetCooldownTime()
	A07W_ability:EndCooldown()
	A07E_ability:EndCooldown()
	caster:CastAbilityImmediately(A07W_ability, 0)
	caster:SetMana(caster:GetMana() + A07W_ability:GetManaCost(A07W_ability:GetLevel()))
	caster:CastAbilityImmediately(A07E_ability, 0)
	caster:SetMana(caster:GetMana() + A07E_ability:GetManaCost(A07E_ability:GetLevel()))
	A07W_ability:EndCooldown()
	A07W_ability:StartCooldown(A07W_cooldown)
	A07E_ability:EndCooldown()
	A07E_ability:StartCooldown(A07E_cooldown)
	local A07D_ability = caster:FindAbilityByName("A07D")
	local A07D_level = A07D_ability:GetLevel()
	local A07D_cooldown = A07D_ability:GetCooldownTime()
	caster:RemoveAbility("A07D")
	caster:AddAbility("A07D2")
	caster:FindAbilityByName("A07D2"):SetLevel(A07D_level)
	caster:FindAbilityByName("A07D2"):StartCooldown(A07D_cooldown)
	for _,v in pairs(am) do
		if v:GetParent():GetTeamNumber() ~= caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber() then
			if v:IsStunDebuff() then
				caster:RemoveModifierByName(v:GetName())
			end
		end
	end
	local particle1 = ParticleManager:CreateParticle("particles/a07/a07t2.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle1, 1, caster, PATTACH_POINT_FOLLOW, "attach_reye", caster:GetAbsOrigin(), true)
	local particle2 = ParticleManager:CreateParticle("particles/a07/a07t3.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle2, 1, caster, PATTACH_POINT_FOLLOW, "attach_leye", caster:GetAbsOrigin(), true)
	Timers:CreateTimer( duration, function()
		ParticleManager:DestroyParticle(particle1,true)
		ParticleManager:DestroyParticle(particle2,true)
		end)
	-- Deciding the transformation level
	local modifier = keys.modifier_one

	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = duration})

	Timers:CreateTimer(0.3,function()
		if IsValidEntity(caster) and caster:IsMagicImmune() then
			AMHC:AddModelScale(caster, 1.3, duration-0.3)
		end
	end)
	
end

function A07T_OnDestory (keys)
	local caster = keys.caster
	local ability = keys.ability
	local A07D2_ability = caster:FindAbilityByName("A07D2")
	local A07D2_level = A07D2_ability:GetLevel()
	local A07D2_cooldown = A07D2_ability:GetCooldownTime()
	caster:RemoveAbility("A07D2")
	caster:AddAbility("A07D")
	caster:FindAbilityByName("A07D"):SetLevel(A07D2_level)
	caster:FindAbilityByName("A07D"):StartCooldown(A07D2_cooldown)
end

function A07T_SE( keys )
	local caster = keys.caster
	local target = keys.target
	AMHC:CreateParticle("particles/a07e/a07e.vpcf",PATTACH_ABSORIGIN,false,target,0.5,nil)
end

function A07D_20( keys )
	local caster = keys.caster
	local target = keys.target
	print("A07D_20")
	caster.currentD = caster.currentD or "E"
	if caster.currentD == "E" then
		caster:SwapAbilities("A07E_20","A07F_20",false,true)
		caster.currentD = "F"
	else
		caster:SwapAbilities("A07F_20","A07E_20",false,true)
		caster.currentD = "E"
	end
end

function A07E_20_OnUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local A07F_20 = caster:FindAbilityByName("A07F_20")
	if IsValidEntity(A07F_20) and A07F_20:GetLevel() < ability:GetLevel() then
		A07F_20:SetLevel(ability:GetLevel())
	end
end

function A07F_20_OnUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local A07E_20 = caster:FindAbilityByName("A07E_20")
	if IsValidEntity(A07E_20) and A07E_20:GetLevel() < ability:GetLevel() then
		A07E_20:SetLevel(ability:GetLevel())
	end
end

function A07E_20CD( keys )
	local caster = keys.caster
	local ability = keys.ability
	local A07F_20 = caster:FindAbilityByName("A07F_20")
	if IsValidEntity(A07F_20) then
		A07F_20:StartCooldown(ability:GetCooldown(-1))
	end
end

function A07F_20CD( keys )
	local caster = keys.caster
	local ability = keys.ability
	local A07E_20 = caster:FindAbilityByName("A07E_20")
	if IsValidEntity(A07E_20) then
		A07E_20:StartCooldown(ability:GetCooldown(-1))
	end
end