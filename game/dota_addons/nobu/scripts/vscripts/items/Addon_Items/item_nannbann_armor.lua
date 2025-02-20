--南蠻胴具足
LinkLuaModifier( "modifier_nannbann_armor", "items/Addon_Items/item_nannbann_armor.lua",LUA_MODIFIER_MOTION_NONE )
modifier_nannbann_armor = class({})


LinkLuaModifier( "modifier_nannbann_armor2", "items/Addon_Items/item_nannbann_armor.lua",LUA_MODIFIER_MOTION_NONE )
modifier_nannbann_armor2 = class({})
--------------------------------------------------------------------------------

function modifier_nannbann_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_nannbann_armor:OnCreated( event )
	self:StartIntervalThink(0.2) 
end

function modifier_nannbann_armor:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
		self.mp = self.caster:GetMana()
	end
end

function modifier_nannbann_armor:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()
	    if (self.caster ~= nil) and IsValidEntity(self.caster) and false then

		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
		        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
					if (damage_type ~= DAMAGE_TYPE_PHYSICAL) then
		            	Timers:CreateTimer(0.01, function() 
		            		if IsValidEntity(self.caster) then
			            		self.caster:Purge( false, true, true, true, true)
			            		event.caster = self.caster
			            		if IsValidEntity(ability) then
					            	event.ability = self:GetAbility()
					            	ShockTarget(event, self.caster)
					            end
				            	local am = self.caster:FindAllModifiers()
								for _,v in pairs(am) do
									if IsValidEntity(v:GetParent()) and IsValidEntity(self.caster) and IsValidEntity(v:GetCaster()) then
										if v:GetParent():GetTeamNumber() ~= self.caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= self.caster:GetTeamNumber() then
											if _G.EXCLUDE_MODIFIER_NAME[v:GetName()] == nil then
												self.caster:RemoveModifierByName(v:GetName())
											end
											if v:GetElapsedTime() < 0.1 and _G.EXCLUDE_MODIFIER_NAME[v:GetName()] == true then
												self.caster:RemoveModifierByName(v:GetName())
											end
										end
									end
								end
								if IsValidEntity(self.caster) then
									self.caster:RemoveModifierByName("modifier_nannbann_armor")
								end
							end
		            		end)
		            	ParticleManager:DestroyParticle(self.caster.nannbann_armor_effect,false)
		            	if (IsValidEntity(self.caster) and self.caster:IsAlive()) then
			            	self.caster:SetHealth(self.hp)
			            	self.caster:SetMana(self.mp)
			            	-- Strong Dispel 刪除負面效果
							self.caster:Purge( false, true, true, true, true)
							print("use")
							local count = 0
							AmpDamageParticle = ParticleManager:CreateParticle("particles/a07w4/a07w4_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
							Timers:CreateTimer(1.0, function() 
								ParticleManager:DestroyParticle(AmpDamageParticle, false)
							end)
							for itemSlot=0,5 do
								local item = self.caster:GetItemInSlot(itemSlot)
								if item ~= nil and item:GetName() == "item_nannbann_armor" then
									hasitem = true
									item:StartCooldown(60)
								end
							end
							Timers:CreateTimer(60, function() 
								if IsValidEntity(self.caster) then
									self.caster.nannbann_armor = true
								end
							end)
						end
		            end 
		        end 
		    end
		end
	end
end


function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	if IsValidEntity(caster) then
		caster.has_item_nannbann_armor = true
	end
	Timers:CreateTimer(1, function() 
		if not IsValidEntity(caster) then
			return nil
		end
		if IsValidEntity(caster) and caster:IsAlive() then
			if not caster:HasModifier("modifier_nannbann_armor") and IsValidEntity(ability) and ability:IsCooldownReady() and caster:IsRealHero() then
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_nannbann_armor", {} )
				local handle = caster:FindModifierByName("modifier_nannbann_armor")
				handle.caster = caster
				handle.hp = caster:GetHealth()
				handle.mp = caster:GetMana()

				local shield_size = 1000
				if caster.nannbann_armor_effect then
					ParticleManager:DestroyParticle(caster.nannbann_armor_effect,false)
				end
				caster.nannbann_armor_effect = ParticleManager:CreateParticle("particles/item/protection.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.nannbann_armor_effect, 1, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.nannbann_armor_effect, 2, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.nannbann_armor_effect, 4, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.nannbann_armor_effect, 5, Vector(shield_size,0,0))
				-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
				ParticleManager:SetParticleControlEnt(caster.nannbann_armor_effect, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			end
			if caster.has_item_nannbann_armor == true then
				return 0.5
			else
				caster:RemoveModifierByName("modifier_nannbann_armor")
				return nil
			end
		end
		return 1
		end)
end

function OnUnequip( keys )
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_nannbann_armor")
	if IsValidEntity(caster) then
		caster.has_item_nannbann_armor = nil
		if caster.nannbann_armor_effect and caster:IsRealHero() then
			ParticleManager:DestroyParticle(caster.nannbann_armor_effect,false)
			caster.nannbann_armor_effect = nil
		end
	end
end

function OnCreated( keys )
	local target = keys.caster
	target.nannbann_shield = ParticleManager:CreateParticle("particles/item/nannbann_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(target.nannbann_shield, 1, target:GetAbsOrigin()+Vector(0, 0, 0))
							
end

function OnDestroy( keys )
	local target = keys.caster
	ParticleManager:DestroyParticle(target.nannbann_shield, false)
end

--------------------------------------------------------------------------------

function modifier_nannbann_armor2:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_nannbann_armor2:OnCreated( event )
	self:StartIntervalThink(0.2) 
end

function modifier_nannbann_armor2:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
	end
end

function modifier_nannbann_armor2:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()

	    if (self.caster ~= nil) and IsValidEntity(self.caster) then
		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
		        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
		            if (damage_type == DAMAGE_TYPE_MAGICAL) then
		            	if self.magic_shield > 0 then
		            		if self.magic_shield > return_damage then
		            			self.magic_shield = self.magic_shield - return_damage
		            			self.caster:SetHealth(self.hp)
		            		else
		            			ParticleManager:DestroyParticle(self.shield_effect, false)
		            			local nhp = self.hp-(return_damage-self.magic_shield)*((100-self.caster:GetMagicalArmorValue())*0.01)
		            			if nhp > 0 then
		            				self.caster:SetHealth(nhp)
		            			end
		            			self.magic_shield = 0
		            		end
		            	end
		            end 
		        end
		    end
		end
	end
end


function ShockTarget( keys, target )
	local caster = keys.caster
	local ability = keys.ability
	local havetime = 5
	local shield
	ability:ApplyDataDrivenModifier( caster, target, "modifier_nannbann_armor2", {duration = havetime} )
	if target:FindModifierByName("modifier_nannbann_armor2") then
		target:FindModifierByName("modifier_nannbann_armor2").caster = target
		target:FindModifierByName("modifier_nannbann_armor2").hp = target:GetHealth()
		target:FindModifierByName("modifier_nannbann_armor2").magic_shield = 500
		shield = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		target:FindModifierByName("modifier_nannbann_armor2").shield_effect = shield
	end
	local sumtime = 0
	local isend = false
	Timers:CreateTimer(havetime, function() 
			isend = true
		end)
	Timers:CreateTimer(0, function() 
			if IsValidEntity(target) then
				ParticleManager:SetParticleControl(shield,1,target:GetAbsOrigin()+Vector(0, 0, 0))
			else
				isend = true
			end
			if not isend then
				return 0.2
			else
				ParticleManager:DestroyParticle(shield, false)
				return nil
			end
		end)
end


