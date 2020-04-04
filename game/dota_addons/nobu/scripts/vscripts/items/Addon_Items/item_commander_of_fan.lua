
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
			if (target:IsMagicImmune()) then
				-- ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",nil)
			elseif (target:IsHero()) then
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan2",nil)
			else
				ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan3",nil)
			end
			if not (target:IsMagicImmune()) then
				local am = target:FindAllModifiers()
				for _,v in pairs(am) do
					if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil and v:GetDuration() > 0.5 then
						local ab = v:GetAbility()
						local abname = ab:GetName()
						local len = string.len(abname)
						local big_skill = false
						if len == 4 and string.sub(abname, 4, 4) == "T" then
							big_skill = true
						end
						if big_skill==false and (v:GetParent():GetTeamNumber() == target:GetTeamNumber()
							or v:GetCaster():GetTeamNumber() == target:GetTeamNumber()) then
							target:RemoveModifierByName(v:GetName())
						end
					end
				end
			end
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
			if (target:IsMagicImmune()) then
				-- ability:ApplyDataDrivenModifier(caster,target,"modifier_commander_of_fan1",nil)
			elseif (target:IsHero()) then
				ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder2",nil)
			else
				ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder2",nil)
			end
		end
	end
end
