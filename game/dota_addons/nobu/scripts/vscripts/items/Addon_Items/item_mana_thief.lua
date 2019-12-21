function OnEquip( keys )
	local caster = keys.caster
	if (caster.nobuorb1 == nil) then
		caster.nobuorb1 = "item_mana_thief"
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	if (caster.nobuorb1 == "item_mana_thief") then
		caster.nobuorb1 = nil
	end
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			if (string.match(itemName,"item_mana_thief")) then
				caster.nobuorb1 = "item_mana_thief"
				break
			end
		end
	end
end

function mana_burn_function( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 350
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana,  burn_amount)
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = mana_to_burn,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	
	-- Show VFX
	if mana_to_burn ~= 0 then
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
	    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
		
		-- Create timer to properly destroy particles
		Timers:CreateTimer( life_time, function()
				ParticleManager:DestroyParticle( numberIndex, false )
				ParticleManager:DestroyParticle( burnIndex, false)
				return nil
			end
		)
	end
end

function mana_burn_function2( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 450
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana,  burn_amount)
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = mana_to_burn,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	
	-- Show VFX
	if mana_to_burn ~= 0 then
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
	    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
		
		-- Create timer to properly destroy particles
		Timers:CreateTimer( life_time, function()
				ParticleManager:DestroyParticle( numberIndex, false )
				ParticleManager:DestroyParticle( burnIndex, false)
				return nil
			end
		)
	end
end


function mana_burn_function3( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 550
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	
	-- Calculation
	local mana_to_burn = math.min( current_mana,  burn_amount)
	local life_time = 2.0
	local digits = string.len( math.floor( mana_to_burn ) ) + 1
	
	-- Fail check
	if target:IsMagicImmune() then
		mana_to_burn = 0
	end
	
	-- Apply effect of ability
	target:ReduceMana( mana_to_burn )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = mana_to_burn,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	
	-- Show VFX
	if mana_to_burn ~= 0 then
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
	    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
		
		-- Create timer to properly destroy particles
		Timers:CreateTimer( life_time, function()
				ParticleManager:DestroyParticle( numberIndex, false )
				ParticleManager:DestroyParticle( burnIndex, false)
				return nil
			end
		)
	end
end

function Shock( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 20 + caster:GetLevel()*5
	if burn_amount > 120 then
		burn_amount = 120
	end
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	if (keys.target.mana_thief == nil) and (caster.nobuorb1 == "item_mana_thief" or caster.nobuorb1 == nil) then
		caster.nobuorb1 = "item_mana_thief"
		keys.target.mana_thief = 1
		-- Calculation
		local mana_to_burn = math.min( current_mana,  burn_amount)
		local life_time = 2.0
		local digits = string.len( math.floor( mana_to_burn ) ) + 1
		
		-- Apply effect of ability
		target:ReduceMana( mana_to_burn )
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = mana_to_burn,
			damage_type = damageType
		}
		Timers:CreateTimer(0.1, function() 
							keys.target.mana_thief = nil
				end)
		ApplyDamage( damageTable )
		
		-- Show VFX
		if mana_to_burn ~= 0 then
			local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
		    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
			local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
			
			-- Create timer to properly destroy particles
			Timers:CreateTimer( life_time, function()
					ParticleManager:DestroyParticle( numberIndex, false )
					ParticleManager:DestroyParticle( burnIndex, false)
					return nil
				end
			)
		end
	end
end

function Shock2( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 70
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	if (keys.target.mana_thief == nil) and (caster.nobuorb1 == "item_mana_thief" or caster.nobuorb1 == nil) then
		caster.nobuorb1 = "item_mana_thief"
		keys.target.mana_thief = 1
		-- Calculation
		local mana_to_burn = math.min( current_mana,  burn_amount)
		local life_time = 2.0
		local digits = string.len( math.floor( mana_to_burn ) ) + 1
		
		-- Fail check
		if target:IsMagicImmune() then
			mana_to_burn = mana_to_burn * 0.5
		end
		
		-- Apply effect of ability
		Timers:CreateTimer(0.1, function() 
					keys.target.mana_thief = nil
				end)
		target:ReduceMana( mana_to_burn )
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = mana_to_burn,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
		
		-- Show VFX
		if mana_to_burn ~= 0 then
			local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
		    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
			local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
			
			-- Create timer to properly destroy particles
			Timers:CreateTimer( life_time, function()
					ParticleManager:DestroyParticle( numberIndex, false )
					ParticleManager:DestroyParticle( burnIndex, false)
					return nil
				end
			)
		end
	end
end


function Shock3( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local current_mana = target:GetMana()
	local burn_amount = 100
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	if (keys.target.mana_thief == nil) and (caster.nobuorb1 == "item_mana_thief" or caster.nobuorb1 == nil) then
		caster.nobuorb1 = "item_mana_thief"
		keys.target.mana_thief = 1
		-- Calculation
		local mana_to_burn = math.min( current_mana,  burn_amount)
		local life_time = 2.0
		local digits = string.len( math.floor( mana_to_burn ) ) + 1
		
		-- Fail check
		if target:IsMagicImmune() then
			mana_to_burn = mana_to_burn * 0.5
		end
		
		-- Apply effect of ability
		Timers:CreateTimer(0.1, function() 
					keys.target.mana_thief = nil
				end)
		target:ReduceMana( mana_to_burn )
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = mana_to_burn,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
		
		-- Show VFX
		if mana_to_burn ~= 0 then
			local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
		    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
			local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
			
			-- Create timer to properly destroy particles
			Timers:CreateTimer( life_time, function()
					ParticleManager:DestroyParticle( numberIndex, false )
					ParticleManager:DestroyParticle( burnIndex, false)
					return nil
				end
			)
		end
	end
end