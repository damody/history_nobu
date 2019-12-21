--御守
LinkLuaModifier( "modifier_protection_amulet", "items/Addon_Items/item_protection_amulet.lua",LUA_MODIFIER_MOTION_NONE )
modifier_protection_amulet = class({})

--------------------------------------------------------------------------------

function modifier_protection_amulet:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_protection_amulet:OnCreated( event )
	self:StartIntervalThink(0.2)
	
end

function modifier_protection_amulet:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
		self.mp = self.caster:GetMana()
	end
end

function modifier_protection_amulet:OnTakeDamage(event)
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
									self.caster:RemoveModifierByName("modifier_protection_amulet")
								end
							end
		            		end)
		            	
		            	if (IsValidEntity(self.caster) and self.caster:IsAlive()) then
			            	self.caster:SetHealth(self.hp)
			            	self.caster:SetMana(self.mp)
			            	-- Strong Dispel 刪除負面效果
			            	self.caster:Purge( false, true, true, true, true)
							local count = 0
							AmpDamageParticle = ParticleManager:CreateParticle("particles/econ/items/puck/puck_merry_wanderer/puck_illusory_orb_explode_merry_wanderer.vpcf", PATTACH_POINT_FOLLOW, self.caster)
							ParticleManager:SetParticleControlEnt(AmpDamageParticle,3,self.caster,PATTACH_POINT_FOLLOW,"attach_hitloc",self.caster:GetAbsOrigin(),true)
							ParticleManager:ReleaseParticleIndex(AmpDamageParticle)
							EmitSoundOn("DOTA_Item.VeilofDiscord.Activate",self.caster)
							for itemSlot=0,5 do
								local item = self.caster:GetItemInSlot(itemSlot)
								if item ~= nil and (item:GetName() == "item_protection_amulet" or item:GetName() == "item_protection_amulet_new") then
									hasitem = true
									item:StartCooldown(30)
								end
							end
						end
						ParticleManager:DestroyParticle(self.caster.protection_amulet_effect,false)
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
		caster.has_item_protection_amulet = true
	end
	Timers:CreateTimer(1, function() 
		if not IsValidEntity(caster) then
			return nil
		end
		if IsValidEntity(caster) and caster:IsAlive() then
			if not caster:HasModifier("modifier_protection_amulet") and IsValidEntity(ability) and ability:IsCooldownReady() and caster:IsRealHero() then
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_protection_amulet", {} )
				local handle = caster:FindModifierByName("modifier_protection_amulet")
				handle.caster = caster
				handle.hp = caster:GetHealth()
				handle.mp = caster:GetMana()

				local shield_size = 1000
				if caster.protection_amulet_effect then
					ParticleManager:DestroyParticle(caster.protection_amulet_effect,false)
				end
				caster.protection_amulet_effect = ParticleManager:CreateParticle("particles/item/protection.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.protection_amulet_effect, 1, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.protection_amulet_effect, 2, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.protection_amulet_effect, 4, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(caster.protection_amulet_effect, 5, Vector(shield_size,0,0))
				-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
				ParticleManager:SetParticleControlEnt(caster.protection_amulet_effect, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			end
			if caster.has_item_protection_amulet == true then
				return 0.5
			else
				caster:RemoveModifierByName("modifier_protection_amulet")
				return nil
			end
		end
		return 1
		end)
end

function OnUnequip( keys )
	if IsValidEntity(keys.caster) then
		local caster = keys.caster
		caster.has_item_protection_amulet = nil
		if caster.protection_amulet_effect and caster:IsRealHero() then
			ParticleManager:DestroyParticle(caster.protection_amulet_effect,false)
			caster.protection_amulet_effect = nil
		end
	end
end
