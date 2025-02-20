-- 伊達政宗

function B04W_Start( keys )
	ProjectileManager:ProjectileDodge(keys.caster)
	local caster = keys.caster
	local center = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local ability = keys.ability
	local speed = ability:GetSpecialValueFor("speed")
	local dir = (point-center):Normalized()
	-- 防呆
	if dir == Vector(0,0,0) then 
		dir = caster:GetForwardVector() 
		point = center + dir
	end
	local fake_center = center - dir
	local distance = (point-center):Length()
	local duration = distance/speed
	-- 把自己踢過去
	local knockbackProperties = {
	    center_x = fake_center.x,
	    center_y = fake_center.y,
	    center_z = fake_center.z,
	    duration = duration,
	    knockback_duration = duration,
	    knockback_distance = distance,
	    knockback_height = 0,
	    should_stun = 0,
	}
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_knockback",knockbackProperties)
	--ability:ApplyDataDrivenModifier(caster,caster,"modifier_B04W2",{duration = duration})
	caster:RemoveGesture(ACT_DOTA_FLAIL)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_B04W_aura",{duration=duration})
	caster:StartGesture(ACT_DOTA_VERSUS)

	local speed = distance/duration

	local ifx = ParticleManager:CreateParticle("particles/b04/b04w_path.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(ifx,0,center)
	ParticleManager:SetParticleControl(ifx,1,speed*dir)
	Timers:CreateTimer(duration, function()
		if IsValidEntity(caster) then
			caster:RemoveGesture(ACT_DOTA_VERSUS)
			--caster:Stop()
		end
		ParticleManager:DestroyParticle(ifx,false)
	end)

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"Hero_Clinkz.WindWalk",caster)
end

function B04W_OnTrigger( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local speed = ability:GetSpecialValueFor("speed")

	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
		bDodgeable = true,
		bProvidesVision = false,
		iMoveSpeed = speed*0.5,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	})
end

function B04W_OnProjectileHitUnit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(),"Hero_Clinkz.SearingArrows",target)
	ApplyDamage({
		victim = target,
		attacker = caster,
		ability = ability,
		damage = ability:GetAbilityDamage(),
		damage_type = ability:GetAbilityDamageType(),
		--damage_flags = DOTA_DAMAGE_FLAG_NONE
	})
	
end

function B04E_OnSpellStart( keys )
	local caster = keys.caster
	local point = keys.target_points[1]
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local stun_time = ability:GetSpecialValueFor("stun_time")
	
	-- 搜尋
	local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係參考
		point,							-- 搜尋的中心點
		nil,
		radius,							-- 搜尋半徑
		ability:GetAbilityTargetTeam(),	-- 目標隊伍
		ability:GetAbilityTargetType(),	-- 目標類型
		ability:GetAbilityTargetFlags(),-- 額外選擇或排除特定目標
		FIND_ANY_ORDER,					-- 結果的排列方式
		false)

	-- 傷害資訊
	local damage_table = {
		--victim = target,
		attacker = caster,
		ability = ability,
		damage = ability:GetAbilityDamage(),
		damage_type = ability:GetAbilityDamageType(),
		--damage_flags = DOTA_DAMAGE_FLAG_NONE
	}

	-- 處理搜尋結果
	for _,unit in ipairs(units) do
		damage_table.victim = unit
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_stunned", {duration=stun_time})
		local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/emberspirit_flame_shield_aoe_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,unit)
		ParticleManager:SetParticleControl(ifx,1,point)
		ParticleManager:ReleaseParticleIndex(ifx)
		ApplyDamage(damage_table)
	end

	local ifx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(ifx,0,point)
	ParticleManager:SetParticleControl(ifx,1,Vector(radius,radius,radius))
	ParticleManager:SetParticleControl(ifx,2,Vector(radius,0,0))
	ParticleManager:SetParticleControl(ifx,3,Vector(radius,0,0))
	ParticleManager:ReleaseParticleIndex(ifx)

	-- EmitSoundOnLocationWithCaster(point,"Hero_OgreMagi.Fireblast.Target",caster)
	EmitSoundOnLocationWithCaster(point,"Hero_Clinkz.Strafe",caster)

	-- 砍樹
	GridNav:DestroyTreesAroundPoint(point, radius, false)
end

function B04T_OnCreated( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	target:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

function B04T_OnDestroy( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end


function B04T_OnAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_time = ability:GetSpecialValueFor("stun_time")
	local stun_chance = ability:GetSpecialValueFor("stun_chance")
	local casterabs = caster:GetAbsOrigin()
    local targetabs = target:GetAbsOrigin()
    local angle = VectorToAngles(targetabs-casterabs).y
	local dx = math.cos(angle*(3.14/180))
	local dy = math.sin(angle*(3.14/180))
	local dir = Vector(dx,dy,0)
	local ran = RandomInt(0 , 100)
	local ran1 = RandomInt(0 , 100)
	if stun_chance >= RandomInt(1,100) then
		if target:IsHero() or target:IsCreep() then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration=stun_time})
		end
	end
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(),"Hero_Clinkz.SearingArrows.Impact",target)
	projectile_table = {
		Ability				= ability,
		EffectName			= "particles/a17w/a17w.vpcf",
		vSpawnOrigin		= casterabs+Vector(0,0,100),
		fDistance			= 1200,
		fStartRadius		= 100,
		fEndRadius			= 100,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= GameRules:GetGameTime() + 5,
		bDeleteOnHit		= false,
		vVelocity			= 0,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}
	projectile_table.vVelocity = dir*2000
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"Hero_Sniper.Attack",caster)
	ProjectileManager:CreateLinearProjectile(projectile_table)
	if ran <= 25 then
		Timers:CreateTimer(0.05 , function()
			ProjectileManager:CreateLinearProjectile(projectile_table)
		end)
		
	end
	if ran1 <= 25 then
		Timers:CreateTimer(0.1 , function()
			ProjectileManager:CreateLinearProjectile(projectile_table)
		end)
		
	end
end

function B04T_OnHit ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = ability:GetSpecialValueFor("damage")
	if not target:IsMagicImmune() then
		AMHC:Damage(caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end

-- 伊達政宗 11.2B

function B04W_old_OnUpgrade( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("B04E_old")
	local level = keys.ability:GetLevel()
	
	if ability ~= nil then
		ability:SetLevel(level)
	end
end

function B04W_old_OnSpellStart( keys )
	local caster = keys.caster
	local center = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local ability = keys.ability
	local speed = ability:GetSpecialValueFor("speed")
	local dir = (point-center):Normalized()
	-- 防呆
	if dir == Vector(0,0,0) then 
		dir = caster:GetForwardVector() 
		point = center + dir
	end
	local fake_center = center - dir
	local distance = (point-center):Length()
	local duration = distance/speed
	-- 把自己踢過去
	local knockbackProperties = {
	    center_x = fake_center.x,
	    center_y = fake_center.y,
	    center_z = fake_center.z,
	    duration = duration,
	    knockback_duration = duration,
	    knockback_distance = distance,
	    knockback_height = 0,
	    should_stun = 0,
	}
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_knockback",knockbackProperties)
	caster:RemoveGesture(ACT_DOTA_FLAIL)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_B04W_old_aura",{duration=duration})
	caster:StartGesture(ACT_DOTA_VERSUS)
	Timers:CreateTimer(duration, function()
		if IsValidEntity(caster) then
			caster:RemoveGesture(ACT_DOTA_VERSUS)
		end
	end)
end

function B04T_old_OnAttackStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_chance = ability:GetSpecialValueFor("stun_chance")
	local stun_time = ability:GetSpecialValueFor("stun_time")
	
	if target:IsHero() or target:IsCreep() then
		if not target:IsMagicImmune() and stun_chance >= RandomInt(1,100) then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration=stun_time})
		end
	end
end