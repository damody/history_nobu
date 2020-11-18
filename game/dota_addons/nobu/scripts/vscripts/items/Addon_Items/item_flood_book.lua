
function Shock( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local particle = ParticleManager:CreateParticle("particles/item/item_flood_book/item_flood_book_water_base.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle,0,point)
	local SEARCH_RADIUS = 400
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          SEARCH_RADIUS,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_NONE,
          0,
          false)
	for _,target in pairs(direUnits) do
		-- 不能推秋山的石頭跟建築物
		if not target:IsBuilding() and _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			Physics:Unit(target)
			local diff = target:GetAbsOrigin()-point
			diff.z = 0
			local dir = diff:Normalized()
			target:SetVelocity(Vector(0,0,-9.8))
			target:AddPhysicsVelocity(dir*500)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_flood_book", {duration = 2})
		end
	end
	local count = 0
	Timers:CreateTimer(1, function()
		local particle = ParticleManager:CreateParticle("particles/item/item_flood_book/item_flood_book_water_base.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(particle,0,point)
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			point,
			nil,
			SEARCH_RADIUS,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			0,
			false)
		for _,target in pairs(direUnits) do
			-- 不能推秋山的石頭跟建築物
			if not target:IsBuilding() then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_flood_book", {duration = 1})
			end
		end
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			point,
			nil,
			SEARCH_RADIUS,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			0,
			false)
		for _,target in pairs(direUnits) do
			-- 不能推秋山的石頭跟建築物
			if not target:IsBuilding() then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_flood_walk", {duration = 1})
			end
		end
		
		count = count + 1
		if count < 4 then
			return 1
		end
	end)
	
end


function Shock2( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local particle = ParticleManager:CreateParticle("particles/item/item_flood_book.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle,0,point)
	local SEARCH_RADIUS = 400
	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          SEARCH_RADIUS,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
          false)
	for _,target in pairs(direUnits) do
		-- 不能推秋山的石頭跟建築物
		if not target:IsBuilding() and _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			local knockbackProperties =
			{
				center_x = point.x,
				center_y = point.y,
				center_z = point.z,
				duration = 0.3,
				knockback_duration = 0.3,
				knockback_distance = 500,
				knockback_height = 0,
				should_stun = 1
			}
			target:AddNewModifier( caster, nil, "modifier_knockback", knockbackProperties )
			ability:ApplyDataDrivenModifier(caster, target, "modifier_stunned", {duration = 1.8})
			AMHC:Damage(caster,target,500,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end
end



