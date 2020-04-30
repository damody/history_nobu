--[[ ============================================================================================================
	Author: Rook, with help from some of Pizzalol's SpellLibrary code
	Date: January 25, 2015
	Called when Blink Dagger is cast.  Blinks the caster in the targeted direction.
	Additional parameters: keys.MaxBlinkRange and keys.BlinkRangeClamp
================================================================================================================= ]]
function A31E(keys)
	ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
	
	local caster = keys.caster
	local dummy = CreateUnitByName("npc_dummy_unit",caster:GetAbsOrigin(),false,nil,nil,caster:GetTeamNumber())
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=5})
	local ifx = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, dummy)
	ParticleManager:ReleaseParticleIndex(ifx)
	EmitSoundOn("DOTA_Item.BlinkDagger.Activate", dummy)
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.MaxBlinkRange
	end
	keys.caster:AddNewModifier(keys.caster,keys.ability,"modifier_phased",{duration=0.1})
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
	local lv = caster:FindAbilityByName("A31T"):GetLevel()
	if lv > 0 then
		keys.ability:ApplyDataDrivenModifier(caster, caster,"modifier_A31E", {duration = 7})
		local handle = caster:FindModifierByName("modifier_A31E")
		if handle then
			handle:SetStackCount(lv)
		end
	end
end

function OB(keys)
	local target_point = keys.target_points[1]
	FindClearSpaceForUnit(keys.caster, target_point, false)
end

function A31W( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.target_points[1]
	local radius =  ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	local duration =  ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local abilityDamage = ability:GetLevelSpecialValueFor( "abilityDamage", ( ability:GetLevel() - 1 ) )
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local damageType = ability:GetAbilityDamageType()
	local second = 0
	local count = 0;
	Timers:CreateTimer( 0, function()
		A31W_2(keys)
		count = count + 1
		if (count < duration*10) then
			return 0.1
		else
			return nil
		end
		end )
	
	caster:StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )

	Timers:CreateTimer( 1, 
		function()
			second = second + 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
	                              casterLocation,
	                              nil,
	                              radius,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)
			for _, it in pairs( units ) do
				if (not(it:IsBuilding())) then
					local stack = 0
					if it:HasModifier("modifier_A31W") then
						stack = it:FindModifierByName("modifier_A31W"):GetStackCount()
					end
					ability:ApplyDataDrivenModifier(caster,it,"modifier_A31W",{duration = 1.1}):SetStackCount(stack + 1)
					AMHC:Damage(caster, it, abilityDamage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
			end
			caster:EmitSound("starstorm_impact01")
			if (second < 5) then
				return 1
			else
				return nil
			end
		end)
end


function A31W_20( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.target_points[1]
	local radius =  ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	local duration =  ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local abilityDamage = ability:GetLevelSpecialValueFor( "abilityDamage", ( ability:GetLevel() - 1 ) )
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local damageType = ability:GetAbilityDamageType()
	local second = 0
	local count = 0;
	Timers:CreateTimer( 0, function()
		A31W_2(keys)
		count = count + 1
		if (count < duration*10) then
			return 0.1
		else
			return nil
		end
		end )
	
	caster:StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	keys.ability:ApplyDataDrivenModifier(caster, caster,"modifier_A31W", {duration = 10})

	Timers:CreateTimer( 1, 
		function()
			second = second + 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
	                              casterLocation,
	                              nil,
	                              radius,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)
			for _, it in pairs( units ) do
				if (not(it:IsBuilding())) then
					AMHC:Damage(caster, it, abilityDamage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
			end
			if (second <= 10) then
				return 1
			else
				return nil
			end
		end)
end

function A31W_2( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.target_points[1]
	local radius =  ability:GetSpecialValueFor("radius")
	local directionConstraint = keys.section
	local modifierName = "modifier_freezing_field_debuff_datadriven"
	local refModifierName = "modifier_freezing_field_ref_point_datadriven"
	local particleName = "particles/a31/a31w.vpcf"
	
	-- Get random point
	local castDistance = RandomInt( 0, radius )
	local angle = RandomInt( 0, 90 )
	local vec = RandomVector(castDistance)
	local dy = vec.y
	local dx = vec.x
	local attackPoint = Vector( 0, 0, 0 )
	
	if directionConstraint == 0 then			-- NW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 1 then		-- NE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 2 then		-- SE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y - dy, casterLocation.z )
	else										-- SW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y - dy, casterLocation.z )
	end
	
	
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )
	
end

--[[Author: Pizzalol
	Date: 04.03.2015.
	Creates additional attack projectiles for units within the specified radius around the caster]]
function SplitShotLaunch( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	-- Targeting variables
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()
	local attack_target = caster:GetAttackTarget()

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("range", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("arrow_count", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local split_shot_projectile = keys.split_shot_projectile

	local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags, FIND_CLOSEST, false)

	-- Create projectiles for units that are not the casters current attack target
	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target and caster:CanEntityBeSeenByMyTeam(v) and not v:HasModifier("modifier_invisible") then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		-- If we reached the maximum amount of targets then break the loop
		if max_targets == 0 then break end
	end
end

-- Apply the auto attack damage to the hit unit
function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = caster:GetAverageTrueAttackDamage(target) * 0.9
	if _G.EXCLUDE_TARGET_NAME2[target:GetUnitName()] then
		damage_table.damage = damage_table.damage * 0.5
	end
	ApplyDamage(damage_table)
end

function A31T_Levelup( keys )
	keys.caster:ModifyAgility( 10 )
	keys.caster:CalculateStatBonus()
end

-- Apply the auto attack damage to the hit unit
function A31T_SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_modifier = ability:GetSpecialValueFor("damage_modifier")

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = caster:GetAverageTrueAttackDamage(target) * 0.9
	if _G.EXCLUDE_TARGET_NAME2[target:GetUnitName()] then
		damage_table.damage = damage_table.damage * 0.5
	end
	ApplyDamage(damage_table)
end

function A31T( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local attakc_time = ability:GetSpecialValueFor("attack_time")
	local split_shot_projectile = keys.split_shot_projectile
	local dummy = CreateUnitByName("npc_dummy_unit",point,false,nil,nil,caster:GetTeamNumber())
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=6})
	dummy:SetOwner(caster)
	dummy:AddAbility("majia"):SetLevel(1)
	local spell_hint_table = {
		duration   = duration,		-- 持續時間
		radius     = radius,		-- 半徑
	}
	dummy:AddNewModifier(dummy,nil,"nobu_modifier_spell_hint",spell_hint_table)
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=duration})
	local particle = ParticleManager:CreateParticle( "particles/a31t/a31t.vpcf", PATTACH_POINT, dummy )
		-- ParticleManager:SetParticleControl(particle,0,point+Vector(0,0,height*i))
		-- ParticleManager:SetParticleControl(particle,1,point+Vector(0,0,height*i))
		-- ParticleManager:SetParticleControl(particle,2,point+Vector(0,0,height*i))
	ParticleManager:SetParticleControlEnt(particle,0, dummy, PATTACH_POINT_FOLLOW,"attach_hitloc",point, true)
	ParticleManager:SetParticleControlEnt(particle,1, dummy, PATTACH_POINT_FOLLOW,"attach_hitloc",point, true)
	ParticleManager:SetParticleControlEnt(particle,2, dummy, PATTACH_POINT_FOLLOW,"attach_hitloc",point, true)
	caster:RemoveModifierByName("modifier_split_shot_datadriven")
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_A31T",nil)
	local counter = 0
	Timers:CreateTimer(0,function()
		counter = counter + attakc_time
		if not ability:IsChanneling() then
			dummy:RemoveModifierByName("modifier_kill")
			dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=0})
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_split_shot_datadriven",nil)
			caster:RemoveModifierByName("modifier_A31T")
			ParticleManager:DestroyParticle(particle, true)
			return nil 
		end
		if counter > duration then
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_split_shot_datadriven",nil)
			caster:RemoveModifierByName("modifier_A31T")
			ParticleManager:DestroyParticle(particle, true)
			return nil 
		end
		units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )
		local n = RandomInt(1,#units)
		for i,unit in ipairs(units) do	
			if not(unit:GetTeamNumber() == caster:GetTeamNumber()) then
				--PerformAttack(handle hTarget, bool bUseCastAttackOrb, bool bProcessProcs, bool bSkipCooldown, bool bIgnoreInvis, bool bUseProjectile, bool bFakeAttack, bool bNeverMiss)
				caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)
				local projectile_info = 
				{
					EffectName = "particles/items2_fx/necronomicon_archer_projectile.vpcf",
					Ability = ability,
					vSpawnOrigin = caster:GetAbsOrigin(),
					Target = unit,
					Source = caster,
					bHasFrontalCone = false,
					iMoveSpeed = 1500,
					bReplaceExisting = false,
					bProvidesVision = false
				}
				if n == i then
					caster:PerformAttack(unit, true, true, true, true, true, false, true)
				else
					ProjectileManager:CreateTrackingProjectile(projectile_info)
				end
			end
		end
		return attakc_time
	end)
end
-- 11.2B
---------------------------------------------------------------------------------------------------------------------

function A31W_old( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.target_points[1]
	local radius =  ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	local duration =  ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local abilityDamage = ability:GetLevelSpecialValueFor( "abilityDamage", ( ability:GetLevel() - 1 ) )
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local damageType = ability:GetAbilityDamageType()
	local second = 0
	local count = 0;
	Timers:CreateTimer( 0, function()
		A31W_2(keys)
		count = count + 1
		if (count < duration*10) then
			return 0.1
		else
			return nil
		end
		end )
	
	caster:StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	Timers:CreateTimer( 1, 
		function()
			second = second + 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
	                              casterLocation,
	                              nil,
	                              radius,
	                              targetTeam,
	                              targetType,
	                              targetFlag,
	                              FIND_ANY_ORDER,
	                              false)
			for _, it in pairs( units ) do
				AMHC:Damage(caster, it, abilityDamage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			end
			if (second <= 10) then
				return 1
			else
				return nil
			end
		end)
end

function A31T_old_split_shot( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Targeting variables
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()
	local attack_target = caster:GetAttackTarget()

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("range", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("arrow_count", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local split_shot_projectile = keys.split_shot_projectile

	local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags, FIND_CLOSEST, false)

	-- Create projectiles for units that are not the casters current attack target
	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target and caster:CanEntityBeSeenByMyTeam(v) and not v:HasModifier("modifier_invisible") then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		-- If we reached the maximum amount of targets then break the loop
		if max_targets == 0 then break end
	end
end


function A31T_20_OnAttack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	if not caster:HasModifier("modifier_a31t_20") then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_a31t_20",nil)
		local handle = caster:FindModifierByName("modifier_a31t_20")
		if handle then
			handle:SetStackCount(1)
		end
	else
		local handle = caster:FindModifierByName("modifier_a31t_20")
		if handle then
			local c = handle:GetStackCount()
			c = c + 1
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_a31t_20",nil)
			handle:SetStackCount(c)
		end
	end
end

function A31D_20_OnSpellStart( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	Timers:CreateTimer(0.1,function( )
		if caster:HasModifier("modifier_A31D_20") then
			AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 1000, 1, false)
			return 0.5
		end
		end)
end
