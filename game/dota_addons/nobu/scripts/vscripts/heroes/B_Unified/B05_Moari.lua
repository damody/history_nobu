	bj_PI                            = 3.14159
	bj_RADTODEG                      = 180.0/bj_PI
	bj_DEGTORAD                      = bj_PI/180.0
--ednglobal


--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Finds the next unit to jump to and deals the damage]]
function LightningJump(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local jump_delay = ability:GetLevelSpecialValueFor("jump_delay", (ability:GetLevel() -1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	
	
	-- Removes the hidden modifier
	target:RemoveModifierByName("modifier_arc_lightning_datadriven")
	local pos = target:GetAbsOrigin()
	-- Waits on the jump delay
	Timers:CreateTimer(jump_delay,
    function()
		-- Finds the current instance of the ability by ensuring both current targets are the same
		local current
		for i=0,ability.instance do
			if ability.target[i] ~= nil then
				if ability.target[i] == target then
					current = i
				end
			end
		end
	
		-- Adds a global array to the target, so we can check later if it has already been hit in this instance
		if IsValidEntity(target) then
			pos = target:GetAbsOrigin()
			if target.hit == nil then
				target.hit = {}
			end
			-- Sets it to true for this instance
			target.hit[current] = true
		end
	
		-- Decrements our jump count for this instance
		ability.jump_count[current] = ability.jump_count[current] - 1
	
		-- Checks if there are jumps left
		if ability.jump_count[current] > 0 then
			-- Finds units in the radius to jump to
			local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, ability:GetAbilityTargetTeam(), 
				ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
			local closest = radius
			local new_target
			for i,unit in ipairs(units) do
				-- Positioning and distance variables
				local unit_location = unit:GetAbsOrigin()
				local vector_distance = pos - unit_location
				local distance = (vector_distance):Length2D()
				-- Checks if the unit is closer than the closest checked so far
				if distance < closest then
					-- If the unit has not been hit yet, we set its distance as the new closest distance and it as the new target
					if unit.hit == nil then
						new_target = unit
						closest = distance
					elseif unit.hit[current] == nil then
						new_target = unit
						closest = distance
					end
				end
			end
			-- Checks if there is a new target
			if new_target ~= nil then
				-- Creates the particle between the new target and the last target
				local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
				-- Sets the new target as the current target for this instance
				ability.target[current] = new_target
				-- Applies the modifer to the new target, which runs this function on it
				ability:ApplyDataDrivenModifier(caster, new_target, "modifier_arc_lightning_datadriven", {})
			else
				-- If there are no new targets, we set the current target to nil to indicate this instance is over
				ability.target[current] = nil
			end
		else
			-- If there are no more jumps, we set the current target to nil to indicate this instance is over
			ability.target[current] = nil
		end
		-- Applies damage to the current target
	
	end)
	if target:HasModifier("modifier_thundergods_wrath_datadriven") then
		ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()*1.25, damage_type = ability:GetAbilityDamageType()})
	else
		ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
	end
end

--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Keeps track of all instances of the spell (since more than one can be active at once)]]
function NewInstance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	-- Keeps track of the total number of instances of the ability (increments on cast)
	if ability.instance == nil then
		ability.instance = 0
		ability.jump_count = {}
		ability.target = {}
	else
		ability.instance = ability.instance + 1
	end

	local angel = caster:GetAngles().y
	local point = Vector(caster:GetAbsOrigin().x+75*math.cos(angel*bj_DEGTORAD) ,  caster:GetAbsOrigin().y+75*math.sin(angel*bj_DEGTORAD), caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z)
	
	-- Sets the total number of jumps for this instance (to be decremented later)
	ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
	-- Sets the first target as the current target for this instance
	ability.target[ability.instance] = target
	
	-- Creates the particle between the caster and the first target
	local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_POINT, caster)
	-- ParticleManager:SetParticleControlEnt(lightningBolt, 0, caster, PATTACH_POINT, "attach_attack", Vector(0,0,0), true)
	-- ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 
    ParticleManager:SetParticleControl(lightningBolt,0,point)   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
end


--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Applies the damage to the target and gives the caster's team vision around it]]
function ThundergodsWrath(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sight_radius = ability:GetLevelSpecialValueFor("sight_radius", (ability:GetLevel() -1))
	local sight_duration = ability:GetLevelSpecialValueFor("sight_duration", (ability:GetLevel() -1))
	
	
	-- Gives the caster's team vision around the target
	--AddFOWViewer(caster:GetTeam(), target:GetAbsOrigin(), sight_radius, sight_duration, false)
	-- Renders the particle on the target
	local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN , target)
	-- Raise 1000 if you increase the camera height above 1000
	ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
	ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	-- Plays the sound on the target
	EmitSoundOn(keys.sound, target)
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 100.0, 2.0, false)
	-- If the target is not invisible, we deal damage to it
	if not target:IsMagicImmune() then
		ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
	end
end

--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Applies the damage to the necessary unit (if there is one) and gives the caster's team vision in the aoe]]
function SearchArea(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("spread_aoe", (ability:GetLevel() -1))
	local sight_radius = ability:GetLevelSpecialValueFor("sight_radius", (ability:GetLevel() -1))
	local sight_duration = ability:GetLevelSpecialValueFor("sight_duration", (ability:GetLevel() -1))
	local duration = ability:GetSpecialValueFor("stunned")
	
	-- Gives vision to the caster's team in the radius
	AddFOWViewer(caster:GetTeam(), point, sight_radius, sight_duration, false)
	
	-- Checks if the target has been set yet
	if target ~= nil then
		-- Applies the ministun and the damage to the target
		
		if target:HasModifier("modifier_thundergods_wrath_datadriven") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_stunned", {duration = duration})
		end
		-- Renders the particle on the target
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
		-- Raise 1000 value if you increase the camera height above 1000
		ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
		ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
		ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
		ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage()+caster:GetIntellect()*2, damage_type = ability:GetAbilityDamageType()})
	else
		-- Renders the particle on the ground target
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
		-- Raise 1000 value if you increase the camera height above 1000
		ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,point.z))
		ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,1000))
		ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z))
	end
end


-----------------------------------------------------------
--T
-----------------------------------------------------------

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Deal damage to the egg.
]]
function OnAttackedEgg( event )
	local egg			= event.target
	local attacker		= event.attacker
	local maxAttacks	= event.max_hero_attacks

	-- Only real heroes can deal damage to the egg.
	if not attacker:IsRealHero() then
		return
	end

	local numAttacked = egg.supernova_numAttacked or 0
	numAttacked = numAttacked + 1
	egg.supernova_numAttacked = numAttacked

	local health = 100 * ( maxAttacks - numAttacked ) / maxAttacks
	egg:SetHealth( health )

	if numAttacked >= maxAttacks then
		-- Now the egg has been killed.
		egg.supernova_lastAttacker = attacker
		event.caster:RemoveModifierByName( "modifier_supernova_sun_form_caster_datadriven" )
		egg:RemoveModifierByName( "modifier_supernova_sun_form_egg_datadriven" )
	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Kill the bird if the egg has been killed; Refresh him and stun around enemies otherwise.
]]
function OnDestroyEgg( event )
	local caster		= event.caster
	local ability	= event.ability
	local point = ability:GetCursorPosition()
	-- if isDead then

	-- 	hero:Kill( ability, egg.supernova_lastAttacker )

	-- else

	-- 	hero:SetHealth( hero:GetMaxHealth() )
	-- 	hero:SetMana( hero:GetMaxMana() )

	-- 	-- Strong despel
	-- 	local RemovePositiveBuffs = true
	-- 	local RemoveDebuffs = true
	-- 	local BuffsCreatedThisFrameOnly = false
	-- 	local RemoveStuns = true
	-- 	local RemoveExceptions = true
	-- 	hero:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions )

	-- 	-- Stun nearby enemies
	-- 	ability:ApplyDataDrivenModifier( hero, egg, "modifier_supernova_egg_explode_datadriven", {} )
	-- 	hero:RemoveModifierByName( "modifier_supernova_egg_explode_datadriven" )

	-- end

	-- -- Play sound effect
	-- local soundName = "Hero_Phoenix.SuperNova." .. ( isDead and "Death" or "Explode" )
	-- StartSoundEvent( soundName, hero )
	local dummy = CreateUnitByName("hide_unit", point , true, nil, caster, caster:GetTeamNumber()) 
   --添加馬甲技能
	dummy:AddAbility("majia"):SetLevel(1)
	--刪除馬甲
   	Timers:CreateTimer( 10.0, function()
		dummy:ForceKill( true )
		return nil
	end )

	--SE1
	-- Checks if the target has been set yet
	-- local particle = ParticleManager:CreateParticle(event.particle, PATTACH_ABSORIGIN , dummy)
	-- -- Raise 1000 if you increase the camera height above 1000
	-- ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,1000 ))
	-- ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,point.z ))
	-- ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z ))

	-- Plays the sound on the target
	--EmitSoundOn(event.sound, dummy)
  	dummy:EmitSoundParams(event.sound,1000,1000.0,5.0)
	-- dummy:EmitSoundParams("event.sound",100,100.0,5.0)

								-- local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
								-- ParticleManager:SetParticleControl(particle2,0,point)
								-- ParticleManager:SetParticleControl(particle2,1,Vector(5,5,5))
								-- ParticleManager:SetParticleControl(particle2,3,point)
									local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
									ParticleManager:SetParticleControl(particle2,0,point)
									ParticleManager:SetParticleControl(particle2,1,Vector(50,50,50))
									ParticleManager:SetParticleControl(particle2,3,point)

									for i=1,5 do
									local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
									ParticleManager:SetParticleControl(particle2,0,point)
									ParticleManager:SetParticleControl(particle2,1,Vector(50,50,50))
									ParticleManager:SetParticleControl(particle2,3,point)
									end

									local pfxName = "particles/b05t/b05t.vpcf"
									local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, dummy )
	-- local time  = 0
	-- Timers:CreateTimer(0.2,	function()
	-- 							-- local particle = ParticleManager:CreateParticle(event.particle, PATTACH_ABSORIGIN , target)
	-- 							-- -- Raise 1000 if you increase the camera height above 1000
	-- 							-- ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,1000 ))
	-- 							-- ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,point.z ))
	-- 							-- ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z ))
	-- 							-- -- Plays the sound on the target
	-- 							-- --EmitSoundOn(event.sound, dummy)
	-- 							-- --local pfxName = "particles/b05t/b05t.vpcf" --"particles/units/heroes/hero_phoenix/phoenix_supernova_" .. ( isDead and "death" or "reborn" ) .. ".vpcf"
	-- 							-- local pfxName = "particles/b05t/b05t.vpcf"
	-- 							-- local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, dummy )


	-- 							local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
	-- 							ParticleManager:SetParticleControl(particle2,0,point)
	-- 							ParticleManager:SetParticleControl(particle2,1,Vector(5,5,5))
	-- 							ParticleManager:SetParticleControl(particle2,3,point)

	-- 							if time == 5 then
	-- 								return nil
	-- 							else
	-- 								time = time + 1
	-- 								return 0.2
	-- 							end
	-- 						end)	
end
--[[
	Author: Ractidous
	Date: 29.01.2015.
	Hide caster's model.
]]
function HideCaster( event )
	event.caster:AddNoDraw()
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Show caster's model.
]]
function ShowCaster( event )
	event.caster:RemoveNoDraw()
end


---------TEST-------------------------
---------TEST-------------------------
---------TEST-------------------------
---------TEST-------------------------
---------TEST-------------------------
function B05T( event )
	local caster		= event.caster
	local ability	= event.ability
	local point = ability:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage")
	AddFOWViewer(caster:GetTeamNumber(), point, 1500.0, 3.0, false)
	
	--外圍
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              point,
	                              nil,
	                              radius,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
	                              FIND_ANY_ORDER,
	                              false)

	--effect:傷害+暈眩
	for _,it in pairs(direUnits) do
		if it:IsBuilding() then
			ApplyDamage({victim = it, attacker = caster, damage = damage*0.3, damage_type = ability:GetAbilityDamageType()})
		else
			ParticleManager:CreateParticle("particles/shake2.vpcf", PATTACH_ABSORIGIN, it)
			ability:ApplyDataDrivenModifier(caster, it, "modifier_B05T_stunned1", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, it, "modifier_B05T_blind", {duration = ability:GetSpecialValueFor("blind_duration")})
			ApplyDamage({victim = it, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
		end
		--ability:ApplyDataDrivenModifier(caster, it,"modifier_B05T",nil)
	end
	--中心
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              point,
	                              nil,
	                              radius*0.4,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
	                              FIND_ANY_ORDER,
	                              false)

	--effect:傷害+暈眩
	for _,it in pairs(direUnits) do
		if it:IsHero() then
			ability:ApplyDataDrivenModifier(caster, it, "modifier_B05T_stunned2", {duration = duration + 1})
		elseif it:IsBuilding() then
		else
			ability:ApplyDataDrivenModifier(caster, it, "modifier_B05T_stunned2", {duration = duration + 1})
		end
		--ability:ApplyDataDrivenModifier(caster, it,"modifier_B05T",nil)
	end

	local dummy = CreateUnitByName("hide_unit", point , true, nil, caster, caster:GetTeamNumber()) 
   --添加馬甲技能
	dummy:AddAbility("majia"):SetLevel(1)
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=1})

	--SE1
	-- Checks if the target has been set yet
	-- local particle = ParticleManager:CreateParticle(event.particle, PATTACH_ABSORIGIN , dummy)
	-- -- Raise 1000 if you increase the camera height above 1000
	-- ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,1000 ))
	-- ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,point.z ))
	-- ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z ))

	-- Plays the sound on the target
	--EmitSoundOn(event.sound, dummy)
  	dummy:EmitSoundParams(event.sound,1,1,5.0)
	-- dummy:EmitSoundParams("event.sound",100,100.0,5.0)

								-- local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
								-- ParticleManager:SetParticleControl(particle2,0,point)
								-- ParticleManager:SetParticleControl(particle2,1,Vector(5,5,5))
								-- ParticleManager:SetParticleControl(particle2,3,point)

								
								
								Timers:CreateTimer(0.2,function()
									for i=1,2 do
									local particle2=ParticleManager:CreateParticle("particles/b05t4_test1/b05t4_test1.vpcf",PATTACH_WORLDORIGIN,nil)
									ParticleManager:SetParticleControl(particle2,0,point)
									ParticleManager:SetParticleControl(particle2,1,Vector(50,50,50))
									ParticleManager:SetParticleControl(particle2,3,point)
									end

									for i=1,2 do
									local particle2=ParticleManager:CreateParticle("particles/b05t4_test1/b05t4_test1.vpcf",PATTACH_WORLDORIGIN,nil)
									ParticleManager:SetParticleControl(particle2,0,point+Vector(0,0,250))
									ParticleManager:SetParticleControl(particle2,1,Vector(50,50,50))
									ParticleManager:SetParticleControl(particle2,3,point)
									end

									for i=1,2 do
									local particle2=ParticleManager:CreateParticle("particles/b05t4_test1/b05t4_test1.vpcf",PATTACH_WORLDORIGIN,nil)
									ParticleManager:SetParticleControl(particle2,0,point+Vector(0,0,500))
									ParticleManager:SetParticleControl(particle2,1,Vector(50,50,50))
									ParticleManager:SetParticleControl(particle2,3,point)
									end									
								end)

								-- local pfxName = "particles/b05t_test/b05t_test.vpcf"
								-- local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, dummy )

								local particle = ParticleManager:CreateParticle("particles/b05t2/b05t2.vpcf", PATTACH_ABSORIGIN , dummy)
								-- Raise 1000 if you increase the camera height above 1000
								ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,1000 ))
								ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,point.z ))
								ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z ))
	-- local time  = 0
	-- Timers:CreateTimer(0.2,	function()
	-- 							-- local particle = ParticleManager:CreateParticle(event.particle, PATTACH_ABSORIGIN , target)
	-- 							-- -- Raise 1000 if you increase the camera height above 1000
	-- 							-- ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,1000 ))
	-- 							-- ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,point.z ))
	-- 							-- ParticleManager:SetParticleControl(particle, 2, Vector(point.x,point.y,point.z ))
	-- 							-- -- Plays the sound on the target
	-- 							-- --EmitSoundOn(event.sound, dummy)
	-- 							-- --local pfxName = "particles/b05t/b05t.vpcf" --"particles/units/heroes/hero_phoenix/phoenix_supernova_" .. ( isDead and "death" or "reborn" ) .. ".vpcf"
	-- 							-- local pfxName = "particles/b05t/b05t.vpcf"
	-- 							-- local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, dummy )


	-- 							local particle2=ParticleManager:CreateParticle("particles/b05t4/b05t4.vpcf",PATTACH_WORLDORIGIN,dummy)
	-- 							ParticleManager:SetParticleControl(particle2,0,point)
	-- 							ParticleManager:SetParticleControl(particle2,1,Vector(5,5,5))
	-- 							ParticleManager:SetParticleControl(particle2,3,point)

	-- 							if time == 5 then
	-- 								return nil
	-- 							else
	-- 								time = time + 1
	-- 								return 0.2
	-- 							end
	-- 						end)	
end
function B05T_Prepare( keys )
	local caster = keys.caster
	local ability = keys.ability
	local thinkness = keys.thinkness or 10
	local point = ability:GetCursorPosition()
	local teamonly 	= keys.teamonly
	local ignore_fog 	= keys.ignore_fog
	local dummy = CreateUnitByName("hide_unit", point , true, nil, caster, caster:GetTeamNumber())
	local aura_radius = ability:GetSpecialValueFor("radius")
	local spell_hint_table = {
		duration   = 1.5,		-- 持續時間
		radius     = aura_radius,		-- 半徑
	}
	dummy:AddNewModifier(dummy,nil,"nobu_modifier_spell_hint",spell_hint_table)
	local particle2=ParticleManager:CreateParticle("particles/b05t5_test/b05t5_test.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particle2,0,point)
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=1})

	local dummy2 = CreateUnitByName("hide_unit", point , true, nil, caster, caster:GetTeamNumber()) 
	local aura_radius = ability:GetSpecialValueFor("radius")
	local spell_hint_table = {
		duration   = 1.5,		-- 持續時間
		radius     = aura_radius*0.4,		-- 半徑
	}
	dummy2:AddNewModifier(dummy2,nil,"nobu_modifier_spell_hint",spell_hint_table)
	dummy2:AddNewModifier(nil,nil,"modifier_kill",{duration=1})
end