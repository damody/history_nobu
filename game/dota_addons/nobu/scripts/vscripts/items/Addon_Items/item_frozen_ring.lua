
--凍牙輪

function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
						caster:GetAbsOrigin(),
						nil,
						375,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_ANY_ORDER,
						false)
	for _,it in pairs(direUnits) do
		if not it:IsHero() and it:FindAbilityByName("for_cp_position") then
			AMHC:Damage(caster,it,275*0.7,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		else
		AMHC:Damage(caster,it,275,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
		ability:ApplyDataDrivenModifier(caster, it,"modifier_frozen_ring",{duration=3.5})
	end
	local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer(2, function ()
		ParticleManager:DestroyParticle(particle, true)
		end)
end

--雪走

function Shock2( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
						target:GetAbsOrigin(),
						nil,
						400,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_ANY_ORDER,
						false)
	AMHC:Damage(caster,target,300,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	for _,it in pairs(direUnits) do
		ability:ApplyDataDrivenModifier(caster, it,"modifier_frozen_ring",{duration=7})
		if it ~= target then
		AMHC:Damage(caster,it,200,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end
	local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, target)
	Timers:CreateTimer(7, function ()
		ParticleManager:DestroyParticle(particle, true)
		end)
end

--凍雲

function OnEquip( keys )
end

function OnUnequip( keys )
end

function item_kokumo( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if not target:IsBuilding() then
		local ran =  RandomInt(0, 100)
		if (caster.kokumo == nil) then
			caster.kokumo = 0
		end
		caster.kokumo = caster.kokumo + 1
		local trigger = 5
		if caster:GetBaseAttackRange() < 200 then
			trigger = 4
		end
		if caster.kokumo >= trigger then
			caster.kokumo = 0
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
							target:GetAbsOrigin(),
							nil,
							225,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
							FIND_ANY_ORDER,
							false)
		local dmg = 200
		if not target:IsMagicImmune() then
			AMHC:Damage(caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
		for _,it in pairs(direUnits) do
			ability:ApplyDataDrivenModifier(caster, it,"modifier_frozen_ring",{duration=3})
			if it ~= target and not it:IsMagicImmune() then
				AMHC:Damage(caster,it,100,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			end
		end
		local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, target)
		Timers:CreateTimer(3, function ()
			ParticleManager:DestroyParticle(particle, true)
			end)
		end
	end
end


function Shock4( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if (caster.nobuorb1 == "item_kokumo" or caster.nobuorb1 == nil) and not target:IsBuilding() and caster.gokokumo == nil then
		caster.nobuorb1 = "item_kokumo"
		local ran =  RandomInt(0, 100)
		if (caster.kokumo == nil) then
			caster.kokumo = 0
		end
		if (ran > 18) then
			caster.kokumo = caster.kokumo + 1
		end
		if (caster.kokumo > (100/18) or ran <= 18) then
			caster.kokumo = 0
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
							target:GetAbsOrigin(),
							nil,
							325,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
							FIND_ANY_ORDER,
							false)
		if not target:IsMagicImmune() then
			AMHC:Damage(caster,target,400,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
		for _,it in pairs(direUnits) do
			ability:ApplyDataDrivenModifier(caster, it,"modifier_frozen_ring",{duration=3})
			if it ~= target and not it:IsMagicImmune() then
				AMHC:Damage(caster,it,100,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			end
		end
		local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, target)
		Timers:CreateTimer(3, function ()
			ParticleManager:DestroyParticle(particle, true)
			end)
		end
	end
end


function Shock5( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if (caster.nobuorb1 == "item_kokumo" or caster.nobuorb1 == nil) and not target:IsBuilding() and caster.gokokumo == nil then
		caster.nobuorb1 = "item_kokumo"
		local ran =  RandomInt(0, 100)
		if (caster.kokumo == nil) then
			caster.kokumo = 0
		end
		if (ran > 20) then
			caster.kokumo = caster.kokumo + 1
		end
		if (caster.kokumo > (100/20) or ran <= 20) then
			caster.kokumo = 0
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
							target:GetAbsOrigin(),
							nil,
							425,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
							FIND_ANY_ORDER,
							false)
		if not target:IsMagicImmune() then
			AMHC:Damage(caster,target,500,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
		for _,it in pairs(direUnits) do
			ability:ApplyDataDrivenModifier(caster, it,"modifier_frozen_ring",{duration=4})
			if it ~= target then
				AMHC:Damage(caster,it,100,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			end
		end
		local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, target)
		Timers:CreateTimer(4, function ()
			ParticleManager:DestroyParticle(particle, true)
			end)
		end
	end
end


function Shock_book( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
						caster:GetAbsOrigin(),
						nil,
						450,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_ANY_ORDER,
						false)
	for _,it in pairs(direUnits) do
		ability:ApplyDataDrivenModifier(caster, it,"modifier_frost_bite_root_datadriven",{duration=1})
		AMHC:Damage(caster,it,400,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		local am = it:FindAllModifiers()
		for _,v in pairs(am) do
			if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil and v:GetDuration() > 0.5 then
				local ab = v:GetAbility()
				if ab then
					local abname = ab:GetName()
					local len = string.len(abname)
					local big_skill = false
					if len == 4 and string.sub(abname, 4, 4) == "T" then
						big_skill = true
					end
					if big_skill==false and (v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber()) then
						it:RemoveModifierByName(v:GetName())
						print(v:GetName(), v:GetCaster():GetTeamNumber(), caster:GetTeamNumber())
					end
				end
			end
		end
	end
	local pointx = point.x
	local pointy = point.y
	local pointz = point.z
	local pointx2
	local pointy2
	local a	
	local maxrock = 10
	for i=1,maxrock do
		a	=	(	(360.0/maxrock)	*	i	)* bj_DEGTORAD
		pointx2 	=  	pointx 	+ 	250 	* 	math.cos(a)
		pointy2 	=  	pointy 	+ 	250 	*	math.sin(a)
		point = Vector(pointx2 ,pointy2 , pointz)

		local dummy = CreateUnitByName("npc_dummy_unit_Ver2",point,false,nil,nil,caster:GetTeam())
		dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=2})
		dummy:FindAbilityByName("majia"):SetLevel(1)
		local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, dummy)
		Timers:CreateTimer(2, function ()
			ParticleManager:DestroyParticle(particle, true)
			end)
	end
end

function storm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = caster:GetForwardVector()*100 + casterLoc
	local dir = caster:GetForwardVector()
	caster:SetForwardVector(dir:Normalized())
	local duration = ability:GetSpecialValueFor( "duration")
	local distance = ability:GetSpecialValueFor( "distance")
	local radius =  ability:GetSpecialValueFor( "radius")
	local collision_radius = ability:GetSpecialValueFor( "collision_radius")
	local projectile_speed = ability:GetSpecialValueFor( "speed")
	local right = caster:GetRightVector()
	local dummy = CreateUnitByName("npc_dummy_unit_Ver2",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	dummy:FindAbilityByName("majia"):SetLevel(1)
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=12})
	ability:ApplyDataDrivenModifier(dummy, dummy,"modifier_invulnerable",{duration=12})
	caster.dummy = dummy

	casterLoc = targetLoc - dir:Normalized() * 400
	
	-- Find forward vector
	local forwardVec = targetLoc - casterLoc
	forwardVec = forwardVec:Normalized()
	
	-- Find backward vector
	local backwardVec = casterLoc - targetLoc
	backwardVec = backwardVec:Normalized()
	
	-- Find middle point of the spawning line
	local middlePoint = casterLoc + ( radius * backwardVec )
	
	-- Find perpendicular vector
	local v = middlePoint - casterLoc
	local dx = -v.y
	local dy = v.x
	local perpendicularVec = Vector( dx, dy, v.z )
	perpendicularVec = perpendicularVec:Normalized()

	local sumtime = 0
	-- Create timer to spawn projectile
	Timers:CreateTimer( function()
			-- Get random location for projectile
			for c = 1,4 do
				local random_distance = RandomInt( -radius, radius )
				local spawn_location = middlePoint + perpendicularVec * random_distance
				
				local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
				
				-- Spawn projectiles
				local projectileTable = {
					Ability = ability,
					EffectName = "particles/item/wind.vpcf",
					vSpawnOrigin = spawn_location,
					fDistance = distance,
					fStartRadius = collision_radius,
					fEndRadius = collision_radius,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					bProvidesVision = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					vVelocity = velocityVec * projectile_speed
				}
				ProjectileManager:CreateLinearProjectile( projectileTable )
			end
			-- Check if the number of machines have been reached
			if sumtime >= duration then
				return nil
			else
				sumtime = sumtime + 0.125
				return 0.125
			end
		end)
end

function storm_break( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local dmg = ability:GetSpecialValueFor("damage")
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              target:GetAbsOrigin(),
	                              nil,
	                              ability:GetLevelSpecialValueFor( "splash_radius", ability:GetLevel() - 1 ),
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	                              DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                              FIND_ANY_ORDER,
	                              false)
	for _,it in pairs(direUnits) do
		if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
			if IsValidEntity(caster) and caster:IsAlive() then
				AMHC:Damage(caster, it, dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			else
				AMHC:Damage(caster.dummy, it, dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				caster.takedamage = caster.takedamage + dmg
				
				if (it:IsRealHero()) then
					caster.herodamage = caster.herodamage + dmg
				end
			end
		end
	end
end



function Shock_book2( keys )
	storm(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
						caster:GetAbsOrigin(),
						nil,
						450,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
						FIND_ANY_ORDER,
						false)
	for _,it in pairs(direUnits) do
		ability:ApplyDataDrivenModifier(caster, it,"modifier_frost_bite_root_datadriven",{duration=1.5})
		AMHC:Damage(caster,it,400,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		local am = it:FindAllModifiers()
		for _,v in pairs(am) do
			if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil and v:GetDuration() > 0.5 then
				local ab = v:GetAbility()
				if ab then
					local abname = ab:GetName()
					local len = string.len(abname)
					local big_skill = false
					if len == 4 and string.sub(abname, 4, 4) == "T" then
						big_skill = true
					end
					if big_skill==false and (v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber()) then
						it:RemoveModifierByName(v:GetName())
						print(v:GetName(), v:GetCaster():GetTeamNumber(), caster:GetTeamNumber())
					end
				end
			end
		end
	end
	local pointx = point.x
	local pointy = point.y
	local pointz = point.z
	local pointx2
	local pointy2
	local a	
	local maxrock = 10
	for i=1,maxrock do
		a	=	(	(360.0/maxrock)	*	i	)* bj_DEGTORAD
		pointx2 	=  	pointx 	+ 	250 	* 	math.cos(a)
		pointy2 	=  	pointy 	+ 	250 	*	math.sin(a)
		point = Vector(pointx2 ,pointy2 , pointz)

		local dummy = CreateUnitByName("npc_dummy_unit_Ver2",point,false,nil,nil,caster:GetTeam())
		dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=2})
		dummy:FindAbilityByName("majia"):SetLevel(1)
		local particle = ParticleManager:CreateParticle("particles/a34e2/a34e2.vpcf", PATTACH_ABSORIGIN, dummy)
		Timers:CreateTimer(2, function ()
			ParticleManager:DestroyParticle(particle, true)
			end)
	end
end