-- 稻葉一鐵
LinkLuaModifier( "modifier_A18R2", "scripts/vscripts/heroes/A_Oda/A18.lua",LUA_MODIFIER_MOTION_NONE )
modifier_A18R2 = class({})

--------------------------------------------------------------------------------

function modifier_A18R2:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_A18R2:OnCreated( event )
	self:StartIntervalThink(0.2) 
end

function modifier_A18R2:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
	end
end

function modifier_A18R2:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()

		if (self.caster ~= nil) and IsValidEntity(self.caster) then
		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
		        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
					if (damage_type == DAMAGE_TYPE_MAGICAL) then
		            	if self.magic_shield > 0 then
		            		if self.magic_shield > return_damage then
		            			self.magic_shield = self.magic_shield - return_damage
		            			self.caster:SetHealth(self.hp)
		            		else
		            			ParticleManager:DestroyParticle(self.shield_effect, false)
		            			local nhp = self.hp-(return_damage-self.magic_shield)*((100-self.caster:GetMagicalArmorValue())*0.01)
		            			if nhp > 0 then
		            				self.caster:SetHealth(nhp)
		            			end
		            			self.magic_shield = 0
		            			self.caster:RemoveModifierByName("modifier_A18R2")
		            		end
		            	end
		            end 
		        end
		    end
		end
	end
end


function A18W_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local damage = ability:GetSpecialValueFor("dmg")
	local radius = ability:GetSpecialValueFor("radius")
	local regen = ability:GetSpecialValueFor("regen")

	local units = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, 
		ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _,unit in ipairs(units) do
		local ifx = ParticleManager:CreateParticle("particles/a18/a18w.vpcf",PATTACH_POINT_FOLLOW,unit)
			ParticleManager:SetParticleControlEnt(ifx,0,unit,PATTACH_POINT_FOLLOW,"attach_hitloc",unit:GetAbsOrigin(),true)
			ParticleManager:SetParticleControlEnt(ifx,1,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetAbsOrigin(),true)
			ParticleManager:ReleaseParticleIndex(ifx)
		local damageTable = {
			victim = unit,
			attacker = caster,
			ability = ability,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		caster:Heal(regen,ability)
		ApplyDamage(damageTable)
	end
end

function DumpTable( tTable )
	local inspect = require('inspect')
	local iDepth = 2
 	print(inspect(tTable,
 		{depth=iDepth} 
 	))
end

function A18R_OnAttackStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local unit = keys.attacker
	local crit_chance = ability:GetSpecialValueFor("crit_chance")
	unit:RemoveModifierByName("modifier_A18R_critical_strike")
	if unit.C21Rcount == nil then unit.C21Rcount = 0 end
	unit.C21Rcount = unit.C21Rcount + 1
	if RandomInt(1,100)<=crit_chance or unit.C21Rcount > (100/crit_chance) then
		unit.C21Rcount = 0
		local rate = unit:GetAttackSpeed()+0.1
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_A18R_critical_strike",{duration=rate})
		if rate < 1 then
		    unit:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
		else
		    unit:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
		end
		if caster.maximum_critical_damage < caster:GetAverageTrueAttackDamage(target) * (200 / 100) then
			caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * (200 / 100)
		end
	end
end

function A18R_Levelup( keys ) 
	local caster = keys.caster
	local ability = keys.ability
	if caster:FindModifierByName("modifier_A18R_passive") then
		caster:RemoveModifierByName("modifier_A18R_passive")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_A18R_passive", {})
	end
end

function A18R_OnIntervalThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local handle = caster:FindModifierByName("modifier_A18R2")
	if handle then
		ParticleManager:DestroyParticle(handle.shield_effect, false)
	end
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_A18R2", {} )
	caster:FindModifierByName("modifier_A18R2").hp = caster:GetHealth()
	caster:FindModifierByName("modifier_A18R2").caster = caster
	caster:FindModifierByName("modifier_A18R2").magic_shield = 400
	local shield = ParticleManager:CreateParticle("particles/item/supressor_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	caster:FindModifierByName("modifier_A18R2").shield_effect = shield
	Timers:CreateTimer(0, function() 
			if IsValidEntity(caster) then
				ParticleManager:SetParticleControl(shield,1,caster:GetAbsOrigin()+Vector(0, 0, 0))
			else
				isend = true
			end
			if not isend then
				return 0.2
			else
				ParticleManager:DestroyParticle(shield, false)
				return nil
			end
		end)
end


function A18T_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_stunned",{duration = 1.75})
	local Stun_Time = ability:GetSpecialValueFor("Stun_Time")
	-- 搜尋
	local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係參考
		caster:GetAbsOrigin(),			-- 搜尋的中心點
		nil,
		ability:GetCastRange(),			-- 搜尋半徑
		ability:GetAbilityTargetTeam(),	-- 目標隊伍
		ability:GetAbilityTargetType(),	-- 目標類型
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,-- 額外選擇或排除特定目標
		FIND_ANY_ORDER,					-- 結果的排列方式
		false)

	-- 處理搜尋結果
	for _,unit in ipairs(units) do
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_stunned",{duration = Stun_Time})
		ApplyDamage({
			victim = unit,
			attacker = caster,
			ability = ability,
			damage = ability:GetAbilityDamage(),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		})
	end
	local ifx = ParticleManager:CreateParticle("particles/a18/a18t.vpcf",PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(ifx,0,caster:GetAbsOrigin()) -- 起點
	ParticleManager:SetParticleControl(ifx,1,caster:GetAbsOrigin()-caster:GetForwardVector()*200) -- 終點
	ParticleManager:SetParticleControl(ifx,3,Vector(0,0.5,0)) -- 延遲
	ParticleManager:ReleaseParticleIndex(ifx)
end

function A18T_old_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local Stun_Time = ability:GetSpecialValueFor("Stun_Time")
	local dmg = ability:GetSpecialValueFor("dmg")
	-- 處理搜尋結果
	AMHC:Damage( caster,caster,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_stunned",{duration = Stun_Time})
	ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration = Stun_Time})
	ApplyDamage({
		victim = target,
		attacker = caster,
		ability = ability,
		damage = ability:GetAbilityDamage(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	})
	local ifx = ParticleManager:CreateParticle("particles/a18/a18t.vpcf",PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(ifx,0,target:GetAbsOrigin()) -- 起點
	ParticleManager:SetParticleControl(ifx,1,caster:GetAbsOrigin()) -- 終點
	ParticleManager:SetParticleControl(ifx,3,Vector(0,0.5,0)) -- 延遲
	ParticleManager:ReleaseParticleIndex(ifx)
end

function A18W_old_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_A18W_old",{duration=6})
	local handle = caster:FindModifierByName("modifier_A18W_old")
	if handle then
		if caster:GetHealthPercent() <= 20 then
			handle:SetStackCount(3)
		elseif caster:GetHealthPercent() <= 50 then
			handle:SetStackCount(2)
		end
	end
end
