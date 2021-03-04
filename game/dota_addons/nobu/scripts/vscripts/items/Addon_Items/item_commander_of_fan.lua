
function Shock( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          400,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
          false)
	
	local flame = ParticleManager:CreateParticle("particles/item/item_commander_of_fantop.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(flame,4,point+Vector(0, 0, 20))
	Timers:CreateTimer(0.5, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
	
	for _,target in pairs(direUnits) do
		AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			if not (target:IsMagicImmune()) then
				if target:IsHero() then
					ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan2",{})
					if target:IsIllusion() then
						AMHC:Damage(caster,target,2000,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
					end
				else
					ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan3",{})
					if target:GetName() == "npc_dota_creature" then
						AMHC:Damage(caster,target,2000,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
					end
				end
			end

			

		

			
			-- if target:IsMagicImmune() then
			-- ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",nil)
			-- end
		end
	end
end


function Shock2( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          400,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
          false)
	
	local flame = ParticleManager:CreateParticle("particles/item/item_commander_of_fantop.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(flame,4,point+Vector(0, 0, 20))
	Timers:CreateTimer(0.5, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
	
	for _,target in pairs(direUnits) do
		AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			if (target:IsMagicImmune()) then
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",nil)
			elseif (target:IsHero()) then
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan2",nil)
			else
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan3",nil)
			end
		end
	end
end


function Shock3( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          600,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
          false)
	
	local flame = ParticleManager:CreateParticle("particles/item/item_soul_addertop.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(flame,4,point+Vector(0, 0, 20))
	Timers:CreateTimer(0.5, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
	
	for _,target in pairs(direUnits) do
		AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder2",{})
		end
	end
end

function OnProjectileHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local range = ability:GetSpecialValueFor("range")
	local push_time = ability:GetSpecialValueFor("push_time")
	local maximum_push_distance = ability:GetSpecialValueFor("maximum_push_distance")
	local silence_duration = ability:GetSpecialValueFor("silence_duration")
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
	local pushVec = (target:GetAbsOrigin() - caster:GetAbsOrigin())
	print(debuff_duration)
	print(silence_duration)
	AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
	Physics:Unit(target)
	Physics:Unit(caster)
	target:SetPhysicsVelocity(pushVec:Normalized()*(maximum_push_distance - (pushVec:Length() * maximum_push_distance / range)) / push_time)
	target:StartPhysicsSimulation()
	Timers:CreateTimer(push_time, function()
		target:StopPhysicsSimulation()
	end)
	if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
		if not (target:IsMagicImmune()) then
			if target:IsHero() then
				ability:ApplyDataDrivenModifier(caster,target,"modifier_decrease_HR",{duration=debuff_duration})
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",{duration=silence_duration})
				if target:IsIllusion() then
					AMHC:Damage(caster,target,2000,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
			else
				ability:ApplyDataDrivenModifier(caster,target,"modifier_decrease_HR",{duration=debuff_duration})
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",{duration=silence_duration})
				if target:GetName() == "npc_dota_creature" then
					AMHC:Damage(caster,target,2000,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
			end
		end
	end
end

function Sound( keys )
	local caster = keys.caster
	local ability = keys.ability
	EmitSoundOn( "Hero_MonkeyKing.Spring.Target" , caster )
end

function OnCreated( keys )
	local target = keys.target
	local ability = keys.ability
	if target.states_resistance_decrease == nil then
		target.states_resistance_decrease = 0
	end
	target.states_resistance_decrease = target.states_resistance_decrease - ability:GetSpecialValueFor("state_decrease")
end

function OnDestroy( keys )
	local target = keys.target
	local ability = keys.ability
	if target.states_resistance_decrease == nil then
		target.states_resistance_decrease = 0
	end
	target.states_resistance_decrease = target.states_resistance_decrease + ability:GetSpecialValueFor("state_decrease")
end
