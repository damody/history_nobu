function new_C15E( keys )
	--【Basic】
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	local point2 = ability:GetCursorPosition()
	local level = ability:GetLevel() - 1
	local vec = (point2-point):Normalized()

	--【Varible】
	--local duration = ability:GetLevelSpecialValueFor("duration",level)
	--local radius = ability:GetLevelSpecialValueFor("radius",level)

	--【Varible Of Tem】
	local point_tem = point + Vector(100*vec.x,100*vec.y) 
	local deg = 0 
	local distance = 100

	--【Timer】
	local num = 0
	Timers:CreateTimer(0.03,function()
		if num == 25 then
			return nil
		else
			point_tem = Vector(point_tem.x+distance*vec.x ,  point_tem.y+distance*vec.y , point_tem.z)
			local z = GetGroundHeight(point_tem, nil)
			point_tem.z = z
			local dummy = CreateUnitByName("npc_dummy_unit",point_tem ,false,caster,caster,caster:GetTeam())	
			dummy:SetOwner(caster)
			dummy:FindAbilityByName("majia"):SetLevel(1)
			ability:ApplyDataDrivenModifier(dummy,dummy,"modifier_C15E_2",nil)
			dummy:SetAbsOrigin(point_tem)
			AddFOWViewer ( caster:GetTeam(), point_tem, 200, 12, true)
			num = num + 1
			Timers:CreateTimer(15, function()
				if IsValidEntity(dummy) then
					dummy:ForceKill(true)
				end
				end)
			return 0.03
		end
	end)	

	--【DEBUG】
	--print(level)

end

function new_C15T( keys )
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local player = caster:GetPlayerID()
	local point = caster:GetAbsOrigin()
	local point2 = target:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	local vec = caster:GetForwardVector():Normalized()

	--【Varible】
	--local duration = ability:GetLevelSpecialValueFor("duration",level)
	--local radius = ability:GetLevelSpecialValueFor("radius",level)

	--【Varible Of Tem】
	local point_tem = nil
	local deg = 0 
	local distance = 300

	ability:ApplyDataDrivenModifier(caster,target,"modifier_C15T_2",nil)
	--【For】
	for i=1,10 do
		deg = deg + 36
		point_tem = point2 + Vector(distance*math.cos(nobu_degtorad(deg))  , distance*math.sin(nobu_degtorad(deg))  ,point2.z ) 
		--【Dummy Kv】
		local dummy = CreateUnitByName("C15T_dummy",point_tem ,false,caster,caster,caster:GetTeam())
		dummy:AddAbility("majia_vison"):SetLevel(1)		
		dummy:SetForwardVector(vec)
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_C15T",nil)

		local order =
		{
			UnitIndex = dummy:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),
			Queue = true
		}

		ExecuteOrderFromTable(order)				
	end

	--【Particle】
	local particle = ParticleManager:CreateParticle("particles/c15t5/c15t5.vpcf",PATTACH_POINT,caster)
	ParticleManager:SetParticleControl(particle,0, point)
	ParticleManager:SetParticleControl(particle,1, point)

	--【Order】	
	local order =
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex(),
		Queue = true
	}

	ExecuteOrderFromTable(order)		
end


function C15T_OnAttackLanded( keys )
    local caster=keys.caster
	local ability=caster:FindAbilityByName("C15T")
	local target=keys.target
	if (caster.C15T == nil) then
		caster.C15T = 0
	end
	caster.C15T = caster.C15T + 1
	if (caster.C15T >= 8) then
		caster.C15T = 0
		if ability:GetLevel() > 0 then
			local dummy = CreateUnitByName("C15T_dummy",target:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
			dummy:AddAbility("majia_vison"):SetLevel(1)		
			dummy:SetForwardVector(caster:GetForwardVector())
			ability:ApplyDataDrivenModifier(caster,dummy,"modifier_C15T",nil)
			local order =
			{
				UnitIndex = dummy:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex(),
				Queue = true
			}

			ExecuteOrderFromTable(order)
		end
	end
end

function new_C15T_attack( keys )
	local target = keys.attacker
	--【Particle】
	local particle = ParticleManager:CreateParticle("particles/base_attacks/ranged_tower_good_explosion.vpcf",PATTACH_POINT,target)
	ParticleManager:SetParticleControl(particle,0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle,3, target:GetAbsOrigin()+Vector(0,0,150))
end


function new_C15T_end( keys )
	local target = keys.target
	--print(target:GetUnitName())
	target:ForceKill(true)
	target:Destroy()
end
-- 11.2B
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

function C15W_old( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1

	local projectile_max = 3
	local projectile_delay = 0.1

	for i=0,projectile_max-1 do
		Timers:CreateTimer(projectile_delay*i,function()
			-- 產生投射物
			local info = {
				Target = target,
				Source = caster,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_mirana/mirana_base_attack.vpcf",
				bDodgeable = true,
				bProvidesVision = true,
				iMoveSpeed = 1500,
			    iVisionRadius = 0,
			    iVisionTeamNumber = caster:GetTeamNumber(), -- Vision still belongs to the one that casted the ability
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}
			ProjectileManager:CreateTrackingProjectile( info )
		end)	
	end
end

function C15E_old_orb_fire( keys )
	--【Basic】
	local caster = keys.caster
	local ability = keys.ability
	local mana_per_attack = ability:GetLevelSpecialValueFor("mana_per_attack", ability:GetLevel()-1)

	-- 判斷魔力是否足夠，不夠就關掉技能
	if caster:GetMana() < mana_per_attack then
		caster:CastAbilityToggle(ability,-1)		
	else
		caster:SpendMana(mana_per_attack,ability)
	end
end

function C15E_old_orb_apply_damage( keys )
	--【Basic】
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local dmg = ability:GetLevelSpecialValueFor("damage_bonus", ability:GetLevel()-1)
	if target:IsBuilding() then
		AMHC:Damage( caster,target,dmg*0.2,AMHC:DamageType("DAMAGE_TYPE_MAGICAL") )
	else
		AMHC:Damage( caster,target,dmg,AMHC:DamageType("DAMAGE_TYPE_MAGICAL") )
	end
	if not target:IsHero() and not target:IsBuilding() then
		AMHC:Damage( caster,target,dmg,AMHC:DamageType("DAMAGE_TYPE_MAGICAL") )
		AMHC:Damage( caster,target,dmg,AMHC:DamageType("DAMAGE_TYPE_MAGICAL") )
	end

end