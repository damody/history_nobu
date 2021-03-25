function C25W(keys)
	local ability = keys.ability
	local caster = keys.caster
	local duration = ability:GetSpecialValueFor("duration")
	local dir = caster:GetForwardVector()
	local fake_center = caster:GetAbsOrigin() - dir
	local distance = ability:GetSpecialValueFor("distance")
	local speed = 2500
	local kDuration = distance/speed
	local knockbackProperties = {
	    center_x = fake_center.x,
	    center_y = fake_center.y,
	    center_z = fake_center.z,
	    duration = kDuration,
	    knockback_duration = kDuration,
	    knockback_distance = distance,
	    knockback_height = 0,
	    should_stun = 0,
	}
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_knockback",knockbackProperties)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_C25W", {duration=duration})
end

function C25E_OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	ability:ApplyDataDrivenModifier(caster,target,"modifier_C25E_view",{duration=duration})
	if target:HasModifier("modifier_C25E_dot") then
		local stack = target:FindModifierByName("modifier_C25E_dot"):IncrementStackCount()
		target:FindModifierByName("modifier_C25E_dot"):SetDuration(duration, true)
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_C25E_dot",{duration=duration}):IncrementStackCount()
	end
	if caster.C25T and RandomInt(0, 100) < caster.C25T then
		local group = FindUnitsInRadius(caster:GetTeamNumber(),
							target:GetAbsOrigin(),
							nil,
							caster.C25T_radius,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
							FIND_ANY_ORDER,
							false)
		for _,it in pairs(group) do
			if it ~= target then
				if it:HasModifier("modifier_C25E_dot") then
					local stack = it:FindModifierByName("modifier_C25E_dot"):IncrementStackCount()
					it:FindModifierByName("modifier_C25E_dot"):SetDuration(duration, true)
				else
					ability:ApplyDataDrivenModifier(caster,it,"modifier_C25E_dot",{duration=duration}):IncrementStackCount()
				end
			end
		end
	end
end

function C25E_dot(keys) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dot = ability:GetSpecialValueFor("dot")
	local dmg = dot * target:FindModifierByName("modifier_C25E_dot"):GetStackCount()
	AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
end

function C25E_view(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 100, 0.11, false)
	ParticleManager:SetParticleControl( target.C25E_Effect, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( target.C25E_Effect, 2, target:GetAbsOrigin()+ Vector(0,0,255) )
	ParticleManager:SetParticleControl( target.C25E_Effect, 3, target:GetAbsOrigin() )
end

function C25E_OnCreated(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	target.C25E_Effect = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
end

function C25E_OnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	ParticleManager:DestroyParticle(target.C25E_Effect,true)
end

function C25R(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local dmg = ability:GetSpecialValueFor("dmg")
	AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt_explosion.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	ParticleManager:SetParticleControl(ifx, 3, target:GetAbsOrigin() + Vector(0, 0, 100))
	ability:ApplyDataDrivenModifier(caster, target, "modifier_C25R", {duration=duration})
	local abilities = {}
	for i=0, 2 do
		local tAbility = target:GetAbilityByIndex(i)
		if tAbility and tAbility:GetLevel() > 0 and tAbility:IsCooldownReady() and tAbility:IsPassive() == false and tAbility:IsToggle() == false then
			table.insert(abilities, tAbility)
		end
	end
	local rand = RandomInt(1, #abilities)
	if abilities[rand] then
		abilities[rand]:StartCooldown(abilities[rand]:GetCooldown(abilities[rand]:GetLevel()))
	end
end

function C25T_OnUpgrade(keys) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	caster.C25T = ability:GetSpecialValueFor("splash_chance")
	caster.C25T_radius = ability:GetSpecialValueFor("radius")
end

function C25T_OnAbilityPhaseStart(keys) 
	local caster = keys.caster
	local ability = keys.ability
	local castRange = ability:GetCastRange(nil, nil)
	local count = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			castRange,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
			FIND_ANY_ORDER,
			false)
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_C25E_dot") then
			count = count + 1
		end
	end
	if count == 0 then
		caster:Stop()
	end
end

function C25T(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local castRange = ability:GetCastRange(nil, nil)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			castRange,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
			FIND_ANY_ORDER,
			false)
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_C25E_dot") then
			local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf",PATTACH_WORLDORIGIN,enemy)
			ParticleManager:SetParticleControl( ifx, 0, enemy:GetAbsOrigin() )
			ParticleManager:SetParticleControl( ifx, 1, enemy:GetAbsOrigin() )
			ParticleManager:SetParticleControl( ifx, 2, enemy:GetAbsOrigin() )
			local stack = enemy:FindModifierByName("modifier_C25E_dot"):GetStackCount()
			local dmg = ability:GetSpecialValueFor("dmg") * stack
			enemy:RemoveModifierByName("modifier_C25E_dot")
			EmitSoundOnLocationWithCaster( enemy:GetAbsOrigin(),"Hero_Pudge.Dismember", target)	
			local group = FindUnitsInRadius(caster:GetTeamNumber(),
					enemy:GetAbsOrigin(),
					nil,
					radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
					FIND_ANY_ORDER,
			false)
			for _, it in pairs(group) do
				AMHC:Damage( caster,it,dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ))
			end
		end
	end
end

function C25D_Action1_old( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level  = keys.ability:GetLevel()
	caster:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})--添加0.1秒的相位状态避免卡位
	caster:SetAbsOrigin(target:GetAbsOrigin())
	if not target:IsMagicImmune() then
		local dmg = keys.ability:GetLevelSpecialValueFor("C25D_Damage", keys.ability:GetLevel() - 1 )
		AMHC:Damage( caster,target, dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end

function C25W_OnSpellStart_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particle = ParticleManager:CreateParticle("particles/econ/items/bristleback/bristle_spikey_spray/bristle_spikey_quill_spray_sparks.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	-- 搜尋
	local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係參考
		caster:GetAbsOrigin(),			-- 搜尋的中心點
		nil,
		ability:GetCastRange(),			-- 搜尋半徑
		ability:GetAbilityTargetTeam(),	-- 目標隊伍
		ability:GetAbilityTargetType(),	-- 目標類型
		ability:GetAbilityTargetFlags(),-- 額外選擇或排除特定目標
		FIND_ANY_ORDER,					-- 結果的排列方式
		false)

	-- 處理搜尋結果
	for _,unit in ipairs(units) do
		local dir = (caster:GetAbsOrigin()-unit:GetAbsOrigin()):Normalized()
		local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_base_attack_explosion_b.vpcf",PATTACH_POINT,unit)
		ParticleManager:SetParticleControlEnt(ifx,3,unit,PATTACH_POINT,"attach_hitloc",unit:GetAbsOrigin()+Vector(0,0,200),true)
		ParticleManager:SetParticleControlForward(ifx,3,dir)
		ParticleManager:ReleaseParticleIndex(ifx)
		--基礎傷害
		ApplyDamage({
			victim = unit,
			attacker = caster,
			ability = ability,
			damage = ability:GetAbilityDamage(),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		})
	end
end

function C25R_OnSpellStart_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local mana = ability:GetSpecialValueFor("mana")
	local rnd = RandomInt(1,100)
	if rnd <= 25 then
		target:ReduceMana(mana)
	end
end

function C25E_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local point   = caster:GetAbsOrigin()
	local point2  = target:GetAbsOrigin()
	local vec = nobu_atan2( point2,point )
	local distance = 35

	local temp_point = nobu_move( point, point2 , distance )

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxe.vpcf",PATTACH_POINT,target)
	ParticleManager:SetParticleControl(particle,0,point)
	ParticleManager:SetParticleControl(particle,2,Vector(0,0,10))

	Timers:CreateTimer(function()
		point2  = target:GetAbsOrigin()
        temp_point = nobu_move( temp_point, point2 , distance )
        --temp_point = nobu_move_ver2( temp_point , distance ,RandomFloat(0,-30))
        --print(nobu_radtodeg(math.atan2(point2.y-point.y,point2.x-point.x)))
		if nobu_distance( temp_point,point2 ) < 50  or not target:IsAlive()  then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_C25E",nil)
			ParticleManager:DestroyParticle(particle,false)

			--print("Stop")
			return nil
		else
			ParticleManager:SetParticleControl(particle,0,temp_point)
			return 0.01
		end
	end)
end


function C25T_OnSpellStart_old( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	EmitSoundOnLocationWithCaster( target:GetAbsOrigin(),"Hero_NyxAssassin.Vendetta.Crit", target)
	ability:ApplyDataDrivenModifier(caster,target,"modifier_C25T_bleeding",{duration = 12})
	--ability:ApplyDataDrivenModifier(caster,target,"modifier_C25T_slience",{})
	local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )		
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,0.6)
	local tsum = 0.1
	Timers:CreateTimer(0.1, function()
		if IsValidEntity(target) and not target:HasModifier("modifier_C25T_bleeding") then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_C25T_bleeding",{duration = 12-tsum})
		end
		tsum = tsum + 0.1
		if tsum < 12 then
			return 0.1
		end
		end)
end


function modifier_C25T_bleeding_OnIntervalThink_old( keys )

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local abilityDamage = ability:GetSpecialValueFor("damage")
	local abilityDamageType = ability:GetAbilityDamageType()
	local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )	
	EmitSoundOnLocationWithCaster( target:GetAbsOrigin(),"Hero_NyxAssassin.Vendetta.Crit", target)	
	if(not target:IsMagicImmune()) then
		if IsValidEntity(caster) and caster:IsAlive() then
			AMHC:Damage( caster,target,abilityDamage,ability:GetAbilityDamageType() )
		else
			AMHC:Damage( caster.donkey,target,abilityDamage,ability:GetAbilityDamageType() )
		end
		--ExecuteOrderFromTable({UnitIndex = target:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_STOP, Queue = false}) 
		target:Stop()
	end
	ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration = ability:GetSpecialValueFor("stun_time")})
	AddFOWViewer(caster:GetTeamNumber(),target:GetAbsOrigin(),600,3.0,false)
	
end