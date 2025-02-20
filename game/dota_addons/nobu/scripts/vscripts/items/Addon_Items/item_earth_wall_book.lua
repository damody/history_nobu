-- 忍法．土盾之書
-- item_earth_wall_book
function Shock( keys )
	local caster = keys.caster
	local center = caster:GetCursorPosition()
	local ability = keys.ability
	local aoe_radius = ability:GetLevelSpecialValueFor("aoe_radius",0)
	local duration = ability:GetLevelSpecialValueFor("duration",0)
	-- 搜尋參數
	local iTeam = caster:GetTeamNumber()
	local target_team = DOTA_UNIT_TARGET_TEAM_BOTH
	local target_type = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetAbilityDamage()
	local charges = ability:GetCurrentCharges()
	print(charges)
	-- 搜尋
	if charges > 1 then
		caster.earthwall_cooldown = 40
		ability:SetCurrentCharges(charges - 1)
		ability:EndCooldown()
	elseif charges == 1 then
		ability:SetCurrentCharges(0)
		ability:EndCooldown()
		ability:StartCooldown(caster.earthwall_cooldown)
	end

	local units = FindUnitsInRadius(iTeam,	-- 關係
                             center,			-- 搜尋的中心點
                             nil, 				-- 好像是優化用的參數不懂怎麼用
                             aoe_radius*2,		-- 搜尋半徑
                             target_team,		-- 目標隊伍
                             target_type,		-- 目標類型
                             target_flags,		-- 額外選擇或排除特定目標
                             FIND_ANY_ORDER,	-- 結果的排列方式
                             false) 			-- 好像是優化用的參數不懂怎麼用

	-- 處理搜尋結果
	for _,unit in ipairs(units) do

		-- 避免卡住
		if _G.EXCLUDE_TARGET_NAME[unit:GetUnitName()] == nil then
			unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.01})
		end
	end
	units = FindUnitsInRadius(iTeam,	-- 關係
                             center,			-- 搜尋的中心點
                             nil, 				-- 好像是優化用的參數不懂怎麼用
                             aoe_radius,		-- 搜尋半徑
                             target_team,		-- 目標隊伍
                             target_type,		-- 目標類型
                             target_flags,		-- 額外選擇或排除特定目標
                             FIND_ANY_ORDER,	-- 結果的排列方式
                             false) 			-- 好像是優化用的參數不懂怎麼用

	-- 處理搜尋結果
	for _,unit in ipairs(units) do
		-- 製造傷害
		if unit:GetTeamNumber() ~= iTeam then
			local damage_table = {}
			damage_table.victim = unit
 				damage_table.attacker = caster					
				damage_table.damage_type = damage_type
				damage_table.damage = damage
			ApplyDamage(damage_table)
		end

	end

	local wall_angle = VectorToAngles(center-caster:GetAbsOrigin()).y + 90
	print(wall_angle)
	-- local wall_angle = VectorToAngles(caster:GetForwardVector())
	local dx = math.cos(wall_angle*(3.14/180))
	local dy = math.sin(wall_angle*(3.14/180))
	local wall_offset = Vector(dx,dy,0) * (aoe_radius)
	print(wall_offset)
	
	-- 產生石牆單位
	local rock_counter = 0
	local origin = center
	Timers:CreateTimer(0,function()
		rock_counter = rock_counter + 1
		if rock_counter > 3 then return nil end
		local rock_center = origin
		if rock_counter == 2 then
			rock_center = origin + wall_offset * -1
		elseif rock_counter == 3 then
			rock_center = origin + wall_offset * 1
		end
		local wall = CreateUnitByName("EARTH_WALL_hero",rock_center,false,nil,nil,caster:GetTeam())
		wall:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})
		-- wall:RemoveModifierByName("modifier_invulnerable")
		local units = FindUnitsInRadius(iTeam,	-- 關係
						 rock_center,-- 搜尋的中心點
                            nil, 				-- 好像是優化用的參數不懂怎麼用
                            200,		-- 搜尋半徑
                            target_team,		-- 目標隊伍
                            target_type,		-- 目標類型
                            target_flags,		-- 額外選擇或排除特定目標
                            FIND_ANY_ORDER,	-- 結果的排列方式
							false) 			-- 好像是優化用的參數不懂怎麼用
		StartSoundEvent("Hero_ElderTitan.EarthSplitter.Cast",caster)
		-- 處理搜尋結果
		for _,unit in ipairs(units) do
			-- 避免卡住
			unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.01})
		end		
		return 0.01
	end)
end

function charges ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local charges = ability:GetCurrentCharges()
	if charges < 2 then
		if caster.earthwall_cooldown > 0 then
			caster.earthwall_cooldown = caster.earthwall_cooldown -1
			caster:FindModifierByName("modifier_wallcharges"):SetStackCount(caster.earthwall_cooldown)
		else 
			caster.earthwall_cooldown = 40
			caster:FindModifierByName("modifier_wallcharges"):SetStackCount(0)
			ability:SetCurrentCharges(charges + 1)
		end
	else 
		caster.earthwall_cooldown = 0
		caster:FindModifierByName("modifier_wallcharges"):SetStackCount(0)
	end
end

function Shock2( keys )
	local caster = keys.caster
	local center = keys.target_points[1]
	local ability = keys.ability
	local aoe_radius = ability:GetLevelSpecialValueFor("aoe_radius",0)
	local duration = ability:GetLevelSpecialValueFor("duration",0)

	-- 搜尋參數
	local iTeam = caster:GetTeamNumber()
	local target_team = DOTA_UNIT_TARGET_TEAM_BOTH
	local target_type = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetAbilityDamage()

	local units = FindUnitsInRadius(iTeam,	-- 關係
                             center,			-- 搜尋的中心點
                             nil, 				-- 好像是優化用的參數不懂怎麼用
                             aoe_radius*3,		-- 搜尋半徑
                             target_team,		-- 目標隊伍
                             target_type,		-- 目標類型
                             target_flags,		-- 額外選擇或排除特定目標
                             FIND_ANY_ORDER,	-- 結果的排列方式
                             false) 			-- 好像是優化用的參數不懂怎麼用

	-- 處理搜尋結果
	for _,unit in ipairs(units) do

		-- 避免卡住
		if _G.EXCLUDE_TARGET_NAME[unit:GetUnitName()] == nil then
			unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.01})
		end
	end
	-- 搜尋
	units = FindUnitsInRadius(iTeam,	-- 關係
                             center,			-- 搜尋的中心點
                             nil, 				-- 好像是優化用的參數不懂怎麼用
                             aoe_radius,		-- 搜尋半徑
                             target_team,		-- 目標隊伍
                             target_type,		-- 目標類型
                             target_flags,		-- 額外選擇或排除特定目標
                             FIND_ANY_ORDER,	-- 結果的排列方式
                             false) 			-- 好像是優化用的參數不懂怎麼用

	-- 處理搜尋結果
	for _,unit in ipairs(units) do

		-- 避免卡住
		if _G.EXCLUDE_TARGET_NAME[unit:GetUnitName()] == nil then
			unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.01})
		end

		-- 製造傷害
		if unit:GetTeamNumber() ~= iTeam then
			local damage_table = {}
			damage_table.victim = unit
			damage_table.attacker = caster					
			damage_table.damage_type = damage_type
			damage_table.damage = damage
			ApplyDamage(damage_table)
		end

	end

	local wall_angle = VectorToAngles(center-caster:GetAbsOrigin()).y
	local dx = math.cos(wall_angle*(3.14/180))
	local dy = math.sin(wall_angle*(3.14/180))
	local wall_offset = Vector(dx,dy,0) * (aoe_radius)
	local wall_offset2 = Vector(dx,dy,0) * (aoe_radius+200)
	
	-- 產生兩個石牆單位
	local wall1 = CreateUnitByName("EARTH_WALL_hero",center+wall_offset,false,nil,nil,caster:GetTeam())
	wall1:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})
	local wall2 = CreateUnitByName("EARTH_WALL_hero",center-wall_offset,false,nil,nil,caster:GetTeam())
	wall2:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})
	local wall3 = CreateUnitByName("EARTH_WALL_hero",center,false,nil,nil,caster:GetTeam())
	wall3:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})

	local wall4 = CreateUnitByName("EARTH_WALL_hero",center-wall_offset2,false,nil,nil,caster:GetTeam())
	wall4:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})
	local wall5 = CreateUnitByName("EARTH_WALL_hero",center+wall_offset2,false,nil,nil,caster:GetTeam())
	wall5:AddNewModifier(caster,nil,"modifier_kill",{duration=duration})
	wall1:RemoveModifierByName("modifier_invulnerable")
	wall2:RemoveModifierByName("modifier_invulnerable")
	wall3:RemoveModifierByName("modifier_invulnerable")
	wall4:RemoveModifierByName("modifier_invulnerable")
	wall5:RemoveModifierByName("modifier_invulnerable")
end

-- 充能
function Charge( keys )
	local caster = keys.caster
	local ability = keys.ability
	local max_charge = ability:GetLevelSpecialValueFor("max_charge",0)
	local next_stack_count = ability:GetCurrentCharges() + 1
	if next_stack_count <= max_charge then
		ability:SetCurrentCharges(next_stack_count)
	end
end