function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 1500
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_notarget_moonfall.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()

	local mana_to_burn = math.min( current_mana,  burn_amount)
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1

	if target:IsMagicImmune() then
		mana_to_burn = 0
	end

	target:ReduceMana(mana_to_burn)
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = mana_to_burn*0.5,
		damage_type = damageType
	}

	if mana_to_burn ~= 0 then
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
	    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local flame = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_notarget_moonfall.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(flame,0,target:GetAbsOrigin()+Vector(0, 0, 100))
		ParticleManager:SetParticleControl(flame,1,target:GetAbsOrigin()+Vector(0, 0, 100))
		ParticleManager:SetParticleControl(flame,2,target:GetAbsOrigin()+Vector(0, 0, 100))
		ParticleManager:SetParticleControl(flame,5,target:GetAbsOrigin()+Vector(0, 0, 100))
		Timers:CreateTimer(0.5, function ()
			ParticleManager:DestroyParticle(flame, false)
		end)
		
		-- Create timer to properly destroy particles
		Timers:CreateTimer( life_time, function()
				ParticleManager:DestroyParticle( numberIndex, false )
				return nil
			end)
	end
	ApplyDamage( damageTable )
end

function Shock3( keys )
	local caster = keys.caster
	local ability = keys.ability
end

function Shock2( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster.magic_damage = 1.4
	Timers:CreateTimer(5, function()
				if caster:HasModifier("Passive_sword_of_xnew_moon_x") then
					caster.magic_damage = 1.2
				else
					caster.magic_damage = nil
				end
			end)
end

function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	-- 力量 0 敏捷1 智力2
	if caster:GetPrimaryAttribute() == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_add_strength", nil)
	elseif caster:GetPrimaryAttribute() == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_add_agility", nil)
	elseif caster:GetPrimaryAttribute() == 2 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_add_intellect", nil)
	end
end

function OnUnEquip( keys )
	local caster = keys.caster
	-- 力量 0 敏捷1 智力2
	if caster:GetPrimaryAttribute() == 0 then
		caster:RemoveModifierByName("modifier_add_strength")
	elseif caster:GetPrimaryAttribute() == 1 then
		caster:RemoveModifierByName("modifier_add_agility")
	elseif caster:GetPrimaryAttribute() == 2 then
		caster:RemoveModifierByName("modifier_add_intellect")
	end
end

function Shock_new ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targets = ability:GetSpecialValueFor("targets")
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local group = FindUnitsInRadius(caster:GetTeamNumber(),
    target:GetAbsOrigin(),
    nil,
    500,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
    FIND_CLOSEST,
	false)
	local n = 0
	local current_mana = 0
	local mana_to_burn = 0

	for i,unit in ipairs(group) do 
		if n < targets then
			if IsValidEntity(unit) and unit:IsHero() then
				local life_time = 2.0
				local fow_left_time = 0
				Timers:CreateTimer(0.5,function()
					if fow_left_time < 10 then
						AddFOWViewer(caster:GetTeamNumber(),unit:GetAbsOrigin(),700,0.5,false)
						fow_left_time = fow_left_time + 0.5
						return 0.5
					else
						return nil
					end
				end)
				
				ability:ApplyDataDrivenModifier(caster,unit,"modifier_reduce_resistance",nil)
				local a = 0
				Timers:CreateTimer(0.3, function()
					if a < 3 then
						current_mana = unit:GetMana()
						mana_to_burn = math.min( current_mana , 250)
						unit:ReduceMana(mana_to_burn)
						AMHC:Damage( caster,unit,mana_to_burn,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
						if mana_to_burn ~= 0 then
							local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, unit )
							ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
							ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
							local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, unit )
							
							-- Create timer to properly destroy particles
							Timers:CreateTimer( life_time, function()
									ParticleManager:DestroyParticle( numberIndex, false )
									ParticleManager:DestroyParticle( burnIndex, false)
									return nil
								end
							)
						end
						a = a + 1
						return 0.3
					else
						return nil
					end
				end)
				n = n + 1
			end
		end
	end
end
