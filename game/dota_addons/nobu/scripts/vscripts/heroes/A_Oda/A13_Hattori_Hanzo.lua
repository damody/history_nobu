
LinkLuaModifier( "a13e_modifier", "scripts/vscripts/heroes/A_Oda/A13_Hattori_Hanzo.lua",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "a13e_followthrough", "scripts/vscripts/heroes/A_Oda/A13_Hattori_Hanzo.lua",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "a13e_hook_back", "scripts/vscripts/heroes/A_Oda/A13_Hattori_Hanzo.lua",LUA_MODIFIER_MOTION_NONE )


function A13D_OnAttackLanded(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	
	--【DMG】
		--【Varible】
	local dmg = ability:GetLevelSpecialValueFor("bonus_damage",level)
	AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )	
end

function A13W_Levelup( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("A13D")
	local level = keys.ability:GetLevel()
	
	if (ability~= nil and ability:GetLevel() < level+1) then
		ability:SetLevel(level+1)
	end
end

function A13E_Levelup( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("A13D")
	local level = keys.ability:GetLevel()
	
	if (ability~= nil and ability:GetLevel() < level+1) then
		ability:SetLevel(level+1)
	end
end

function A13R_Levelup( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("A13D")
	local level = keys.ability:GetLevel()
	
	if (ability~= nil and ability:GetLevel() < level+1) then
		ability:SetLevel(level+1)
	end
end

function A13D( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:AddNewModifier(caster,ability,"modifier_invisible",{duration=20})
end

function A13D_End( keys )
	if not keys.target:IsUnselectable() or keys.target:IsUnselectable() then		-- This is to fail check if it is item. If it is item, error is expected
		-- Variables
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local abilityDamage = ability:GetLevelSpecialValueFor( "A13D_Damage", ability:GetLevel() - 1 )
		local abilityDamageType = ability:GetAbilityDamageType()
		if (not target:IsBuilding()) then
			-- Deal damage and show VFX
			local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )
			
			StartSoundEvent( "Hero_NyxAssassin.Vendetta.Crit", target )
			PopupCriticalDamage(target, abilityDamage)
			AMHC:Damage( caster,target,abilityDamage,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
		end	
		keys.caster:RemoveModifierByName( "modifier_A13D" )
		keys.caster:RemoveModifierByName( "modifier_invisible" )
	end
end

function A13W( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "A13W_Duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "A13W_attack", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )

	local people = ability:GetLevel() + 1
	local eachAngle = 6.28 / people
	local illusion = {}
	local target_pos = {}
	local radius = 900
	local origin_go_index = RandomInt(1, people)
	local random_angle = RandomInt(-20, 20) * 0.1
	local origin_pos = caster:GetOrigin()

	local am = caster:FindAllModifiers()

	for _,v in pairs(am) do
		if v:GetParent():GetTeamNumber() ~= caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber() then
			caster:RemoveModifierByName(v:GetName())
		end
	end
	
	if IsValidEntity(caster) and caster:IsAlive() then
		for i=1,people do
			if (i ~= origin_go_index) then
				-- handle_UnitOwner needs to be nil, else it will crash the game.
				illusion[i] = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
				illusion[i]:SetPlayerID(caster:GetPlayerID())
				illusion[i]:SetControllableByPlayer(player, true)
				
				-- Level Up the unit to the casters level
				local casterLevel = caster:GetLevel()
				for j=1,casterLevel-1 do
					illusion[i]:HeroLevelUp(false)
				end

				-- Set the skill points to 0 and learn the skills of the caster
				illusion[i]:SetAbilityPoints(0)
				for abilitySlot=0,15 do
					local ability = caster:GetAbilityByIndex(abilitySlot)
					if ability ~= nil then 
						local abilityLevel = ability:GetLevel()
						local abilityName = ability:GetAbilityName()
						local illusionAbility = illusion[i]:FindAbilityByName(abilityName)
						if (illusionAbility ~= nil) then
							illusionAbility:SetLevel(abilityLevel)
						end
					end
				end

				-- Recreate the items of the caster
				for itemSlot=0,5 do
					local item = caster:GetItemInSlot(itemSlot)
					if item ~= nil then
						local itemName = item:GetName()
						local newItem = CreateItem(itemName, illusion[i], illusion[i])
						illusion[i]:AddItem(newItem)
					end
				end

				-- Set the unit as an illusion
				-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
				illusion[i]:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = -1000, incoming_damage = incomingDamage })
				-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
				illusion[i]:MakeIllusion()

				illusion[i]:SetHealth(caster:GetHealth())
				illusion[i].illusion_damage = 0.1
				--分身不能用法球
				--illusion[i].nobuorb1 = "illusion"
				--illusion[i]:SetRenderColor(255,0,255)
				if caster:HasModifier("modifier_perceive_wine") then
					ability:ApplyDataDrivenModifier(illusion[i],illusion[i],"modifier_perceive_wine",nil)
				end
			end
		end
		
		Timers:CreateTimer( 0.1, function()
				if IsValidEntity(caster) and caster:IsAlive() then
					for i=1,people do
						target_pos[i] = Vector(math.sin(eachAngle*i+random_angle), math.cos(eachAngle*i+random_angle), 0) * radius
						if (i ~= origin_go_index) then
							if IsValidEntity(illusion[i]) then
								ProjectileManager:ProjectileDodge(illusion[i])
								ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, illusion[i])
								illusion[i]:SetAbsOrigin(origin_pos+target_pos[i])
								ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, illusion[i])
								illusion[i]:SetForwardVector(target_pos[i]:Normalized())
								illusion[i]:AddNewModifier(illusion[i],ability,"modifier_phased",{duration=0.1})
							end
						else
							ProjectileManager:ProjectileDodge(caster)
							ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
							caster:SetAbsOrigin(origin_pos+target_pos[i])
							ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
							caster:SetForwardVector(target_pos[i]:Normalized())
							caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
						end
					end
				end
				return nil
			end )
	end
	Timers:CreateTimer(0.25, function()
		AMHC:SetCamera(caster:GetPlayerOwnerID(), caster)
		end)
end


function A13R_old( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "A13W_Duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "A13W_attack", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )

	local people = ability:GetLevel() + 1
	local eachAngle = 6.28 / people
	local illusion = {}
	local target_pos = {}
	local radius = 100
	local origin_go_index = RandomInt(1, people)
	local random_angle = RandomInt(-20, 20) * 0.1
	local origin_pos = caster:GetOrigin()

	local am = caster:FindAllModifiers()
	for _,v in pairs(am) do
		if v:GetParent():GetTeamNumber() ~= caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber() then
			caster:RemoveModifierByName(v:GetName())
		end
	end

	if IsValidEntity(caster) and caster:IsAlive() then
		for i=1,people do
			if (i ~= origin_go_index) then
				-- handle_UnitOwner needs to be nil, else it will crash the game.
				illusion[i] = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
				illusion[i]:SetPlayerID(caster:GetPlayerID())
				illusion[i]:SetControllableByPlayer(player, true)
				
				-- Level Up the unit to the casters level
				local casterLevel = caster:GetLevel()
				for j=1,casterLevel-1 do
					illusion[i]:HeroLevelUp(false)
				end

				-- Set the skill points to 0 and learn the skills of the caster
				illusion[i]:SetAbilityPoints(0)
				for abilitySlot=0,15 do
					local ability = caster:GetAbilityByIndex(abilitySlot)
					if ability ~= nil then 
						local abilityLevel = ability:GetLevel()
						local abilityName = ability:GetAbilityName()
						local illusionAbility = illusion[i]:FindAbilityByName(abilityName)
						if (illusionAbility ~= nil) then
							illusionAbility:SetLevel(abilityLevel)
						end
					end
				end

				-- Recreate the items of the caster
				for itemSlot=0,5 do
					local item = caster:GetItemInSlot(itemSlot)
					if item ~= nil then
						local itemName = item:GetName()
						local newItem = CreateItem(itemName, illusion[i], illusion[i])
						illusion[i]:AddItem(newItem)
					end
				end

				-- Set the unit as an illusion
				-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
				illusion[i]:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = -70, incoming_damage = incomingDamage })
				-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
				illusion[i]:MakeIllusion()

				illusion[i]:SetHealth(caster:GetHealth())
				illusion[i].illusion_damage = outgoingDamage*0.01
				--分身不能用法球
				--illusion[i].nobuorb1 = "illusion"
				--illusion[i]:SetRenderColor(255,0,255)
			end
		end
		
		Timers:CreateTimer( 0.1, function()
				if IsValidEntity(caster) and caster:IsAlive() then
					for i=1,people do
						target_pos[i] = Vector(math.sin(eachAngle*i+random_angle), math.cos(eachAngle*i+random_angle), 0) * radius
						if (i ~= origin_go_index) then
							if IsValidEntity(illusion[i]) then
								ProjectileManager:ProjectileDodge(illusion[i])
								ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, illusion[i])
								illusion[i]:SetAbsOrigin(origin_pos+target_pos[i])
								ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, illusion[i])
								illusion[i]:SetForwardVector(target_pos[i]:Normalized())
								illusion[i]:AddNewModifier(illusion[i],ability,"modifier_phased",{duration=0.1})
							end
						else
							ProjectileManager:ProjectileDodge(caster)
							ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
							caster:SetAbsOrigin(origin_pos+target_pos[i])
							ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
							caster:SetForwardVector(target_pos[i]:Normalized())
							caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
						end
					end
				end
				return nil
			end )
	end
end


A13E = class ({})

function A13E:OnSpellStart()
	local caster = self:GetCaster()
	local debuff_duraiton = self:GetSpecialValueFor("flux_duration")
	local dir = self:GetCursorPosition() - caster:GetOrigin()
	caster:SetForwardVector(dir:Normalized())
	caster:AddNewModifier(caster, self, "a13e_modifier", { duration = 2}) 
	caster:AddNewModifier(caster, self, "a13e_followthrough", { duration = 0.3 } )
	caster:EmitSound("hook_throw")
	Timers:CreateTimer(1,function()
                caster:StopSound("hook_throw")
            end)
end

function A13E:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
	return true
end

--------------------------------------------------------------------------------

function A13E:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_1 )
end

function A13E:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_1 )
end

function A13E:OnUpgrade()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("A13D")
	local level = self:GetLevel()
	
	if (ability ~= nil and ability:GetLevel()+1 < level) then
		ability:SetLevel(level+1)
	end
end

A13E_old = A13E


--------------------------------------------------------------------------------
a13e_followthrough = class({})

function a13e_followthrough:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function a13e_followthrough:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end


a13e_hook_back = class({})

--------------------------------------------------------------------------------

function a13e_hook_back:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function a13e_hook_back:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end
function a13e_hook_back:OnIntervalThink()
	if (self.path ~= nil) then
		local target = self:GetParent()
		if IsValidEntity(self:GetParent()) then
			if (self.interval_Count > 1) then
				target:SetOrigin(self.path[self.interval_Count])
				self.interval_Count = self.interval_Count - 1
			else
				target:AddNewModifier(target,self:GetAbility(),"modifier_phased",{duration=0.1})
				target:RemoveModifierByName("a13e_hook_back")
			end
		end
	end
end
function a13e_hook_back:IsHidden()
	return true
end

function a13e_hook_back:IsDebuff()
	return true
end

function a13e_hook_back:OnCreated( event )
	self:StartIntervalThink(0.07) 
end


a13e_modifier = class ({})

function a13e_modifier:OnCreated( event )
	if IsServer() then
		local ability = self:GetAbility()
		self.hook_width = ability:GetSpecialValueFor("hook_width")
		self.hook_distance = ability:GetSpecialValueFor("hook_distance")
		self.hook_damage = ability:GetSpecialValueFor("hook_damage")
		if IsServer() then
			self.damage_type = ability:GetAbilityDamageType()
		end
		self.distance_sum = 0
		self.interval_Count = 0
		self.path = {}
		self.particle = {}
		if IsValidEntity(self:GetParent()) then
			self.oriangle = self:GetParent():GetAnglesAsVector().y
			self.hook_pos = self:GetParent():GetOrigin()
			self.oripos = self:GetParent():GetOrigin()
			self:StartIntervalThink(0.05)
		end
	end
end

function a13e_modifier:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		self.interval_Count = self.interval_Count + 1
		
		local angle = math.abs(caster:GetAnglesAsVector().y - self.oriangle)
		--print("angle: "..(angle))
		if (angle > 45) then
			if (angle > 80) then
				angle = angle * 4
			else
				angle = angle * 2
			end
		end
		local vDirection =  caster:GetForwardVector()
		self.path[self.interval_Count] = self.hook_pos
		local length = (20+angle*0.2) * self.interval_Count
		local next_hook_pos = self.hook_pos + vDirection:Normalized() * length + (self:GetParent():GetOrigin() - self.oripos)
		self.oripos = self:GetParent():GetOrigin()
		length = (next_hook_pos - self.hook_pos):Length()
		hook_pts = { self.hook_pos }
		if (length > 100) then
			local pts = length / 100 + 1
			for i=1,pts do
				hook_pts[i] = self.hook_pos + vDirection:Normalized() * 100 * i
				--print("pts: ".. hook_pts[i].x.." "..hook_pts[i].y.." "..hook_pts[i].z)
			end
		end

		local next_hook_pos = self.hook_pos + vDirection:Normalized() * length
		self.distance_sum = self.distance_sum + 20 * self.interval_Count
		
		local particle = ParticleManager:CreateParticle("particles/a11/_2pudge_meathook_whale2.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl(particle,0, next_hook_pos)
		ParticleManager:SetParticleControl(particle,1,Vector(1.11 - self.interval_Count*0.1,0,0))
		ParticleManager:SetParticleControl(particle,4,Vector(1,0,0))
		ParticleManager:SetParticleControl(particle,5,Vector(1,0,0))
		ParticleManager:SetParticleControl(particle,3,self.hook_pos)
		ParticleManager:ReleaseParticleIndex(particle)
		self.particle[self.interval_Count] = particle
		if self.interval_Count > 3 then
			
			for _,hookpoint in pairs(hook_pts) do
				-- 拉到敵人
				local SEARCH_RADIUS = self.hook_width
				local z = GetGroundHeight(hookpoint, nil)
				hookpoint.z = z
				local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
		                              hookpoint,
		                              nil,
		                              SEARCH_RADIUS,
		                              DOTA_UNIT_TARGET_TEAM_ENEMY,
		                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		                              FIND_ANY_ORDER,
		                              false)
				local hashook = false
				for _,it in pairs(direUnits) do
					if not string.match(it:GetUnitName(), "npc_dota_courier2") and _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil and not it:HasAbility("majia") then
						local tbl = { victim = it, attacker = self:GetCaster(), damage = self.hook_damage, 
							damage_type = self.damage_type, ability = self:GetAbility()}
						if it:IsMagicImmune() then
							tbl.damage = tbl.damage*0.5
						end
						ApplyDamage(tbl)
						hashook = true
						if (it:HasModifier("modifier_invisible")) then
							it:RemoveModifierByName("modifier_invisible")
						end
						if string.match(it:GetUnitName(), "C17R_old_SUMMEND_UNIT") then
							it:ForceKill(true)
						end
						it:AddNewModifier(it, self:GetCaster(), "a13e_hook_back", { duration = 2}) 
						local hModifier = it:FindModifierByNameAndCaster("a13e_hook_back", it)
						if (hModifier ~= nil) then
							hModifier.path = self.path
							hModifier.interval_Count = self.interval_Count
							hModifier.particle = self.particle
							break
						end
					end
				end
				if (hashook == true) then
					self:StartIntervalThink( -1 )
					return
				end

				-- 拉到友軍
				direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			                          hookpoint,
			                          nil,
			                          SEARCH_RADIUS,
			                          DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			                          FIND_ANY_ORDER,
			                          false)

				for _,it in pairs(direUnits) do
					if it ~= caster and _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil and not it:HasAbility("majia") then
						hashook = true
						it:AddNewModifier(it, self:GetCaster(), "a13e_hook_back", { duration = 2}) 
						local hModifier = it:FindModifierByNameAndCaster("a13e_hook_back", it)
						if (hModifier ~= nil) then
							hModifier.path = self.path
							hModifier.interval_Count = self.interval_Count
							hModifier.particle = self.particle
							break
						end
						break
					end
				end
				-- 拉到或距離到上限了
				if (self.distance_sum > self.hook_distance or hashook == true) then
					self:StartIntervalThink( -1 )
					return
				end
			end
		end
		self.hook_pos = next_hook_pos
	end
end

function a13e_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_disruptor_kinetic_fieldslow.vpcf"
end

function a13e_modifier:IsHidden()
	return true
end

function a13e_modifier:IsDebuff()
	return false
end

function a13e_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function A13T( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local dir = caster:GetCursorPosition() - caster:GetOrigin()
	caster:SetForwardVector(dir:Normalized())
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius =  ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local collision_radius = ability:GetLevelSpecialValueFor( "collision_radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local right = caster:GetRightVector()
	local dummy = CreateUnitByName("npc_dummy_unit_Ver2",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	dummy:FindAbilityByName("majia"):SetLevel(1)
	Timers:CreateTimer( 5, function()
		if IsValidEntity(dummy) then
			dummy:ForceKill(true)
		end
	end)
	caster.dummy = dummy

	casterLoc = keys.target_points[1] - right:Normalized() * 300
	Timers:CreateTimer( 0.3, function()
		caster:AddNoDraw()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_A13T", {duration = 3.7} )
	end)
	
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
					EffectName = "particles/a11t/a11t.vpcf",
					vSpawnOrigin = spawn_location,
					fDistance = distance,
					fStartRadius = collision_radius,
					fEndRadius = collision_radius,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					bProvidesVision = true,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					vVelocity = velocityVec * projectile_speed
				}
				ProjectileManager:CreateLinearProjectile( projectileTable )
			end
			-- Check if the number of machines have been reached
			if sumtime >= 4 then
				return nil
			else
				sumtime = sumtime + 0.125
				return 0.125
			end
		end)
	caster:EmitSound( "C01W.sound"..RandomInt(1, 3) )
end


function A13T_old( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local dir = caster:GetCursorPosition() - caster:GetOrigin()
	caster:SetForwardVector(dir:Normalized())
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius =  ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local collision_radius = ability:GetLevelSpecialValueFor( "collision_radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local right = caster:GetRightVector()
	local dummy = CreateUnitByName("npc_dummy_unit_Ver2",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	dummy:FindAbilityByName("majia"):SetLevel(1)
	Timers:CreateTimer( 5, function()
		if IsValidEntity(dummy) then
			dummy:ForceKill(true)
		end
	end)
	caster.dummy = dummy

	casterLoc = keys.target_points[1] - right:Normalized() * 300
	Timers:CreateTimer( 0.8, function()
		caster:AddNoDraw()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_A13T", {duration = 3.4} )
	end)
	
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
					EffectName = "particles/a11t/a11t.vpcf",
					vSpawnOrigin = spawn_location,
					fDistance = distance,
					fStartRadius = collision_radius,
					fEndRadius = collision_radius,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					bProvidesVision = true,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					vVelocity = velocityVec * projectile_speed
				}
				ProjectileManager:CreateLinearProjectile( projectileTable )
			end
			-- Check if the number of machines have been reached
			if sumtime >= 4 then
				return nil
			else
				sumtime = sumtime + 0.125
				return 0.125
			end
		end)
	caster:EmitSound( "C01W.sound"..RandomInt(1, 3) )
end


function A13T_End( keys )
	local caster = keys.caster
	caster:RemoveNoDraw()
end

function A13T_break( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local dmg = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              target:GetAbsOrigin(),
	                              nil,
	                              ability:GetLevelSpecialValueFor( "splash_radius", ability:GetLevel() - 1 ),
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	                              DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                              FIND_ANY_ORDER,
	                              false)
	local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_dagger.vpcf",PATTACH_POINT,target)
				ParticleManager:SetParticleControlForward(ifx,0,target:GetForwardVector())
				ParticleManager:SetParticleControl(ifx,1,target:GetAbsOrigin())
				ParticleManager:SetParticleControlForward(ifx,1,target:GetForwardVector())
				ParticleManager:ReleaseParticleIndex(ifx)
	for _,it in pairs(direUnits) do
		if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
			if IsValidEntity(caster) and caster:IsAlive() then
				if it:IsMagicImmune() then
					AMHC:Damage(caster, it, dmg*0.5,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				else
					AMHC:Damage(caster, it, dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				end
			else
				if it:IsMagicImmune() then
					AMHC:Damage(caster.dummy, it, dmg*0.5,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
					caster.takedamage = caster.takedamage + dmg*0.5
				else
					AMHC:Damage(caster.dummy, it, dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
					caster.takedamage = caster.takedamage + dmg
				end
				
				if (it:IsRealHero()) then
					caster.herodamage = caster.herodamage + dmg
				end
			end
		end
	end
end
