-- 天變之書
-- item_thunderstorms
function Shock( keys )

	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	
	local aoe_damage = ability:GetLevelSpecialValueFor("aoe_damage",0)
	local start_damage = ability:GetLevelSpecialValueFor("start_damage",0)
	local aoe_radius = ability:GetLevelSpecialValueFor("aoe_radius",0)
	local aoe_delay  = ability:GetLevelSpecialValueFor("aoe_delay" ,0)
	local duration   = ability:GetLevelSpecialValueFor("duration"  ,0)

	local target_team = ability:GetAbilityTargetTeam()
	local target_type = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local damage_type = ability:GetAbilityDamageType()
	
	AddFOWViewer(caster:GetTeamNumber(),target_point,aoe_radius,3,false)
	AddFOWViewer(DOTA_TEAM_GOODGUYS,caster:GetAbsOrigin(), 300, 1, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS,caster:GetAbsOrigin(), 300, 1, false)

	-- 需要手動刪除
	local ifx_cloud = ParticleManager:CreateParticle("particles/item/item_thunderstorms_cloud2.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(ifx_cloud,0,target_point)
	Timers:CreateTimer(duration, function()
		if ifx_cloud ~= nil then
			ParticleManager:DestroyParticle(ifx_cloud,false)
		end
	end)
	--spell hint
	local dummy = CreateUnitByName("hide_unit", target_point , true, nil, caster, caster:GetTeamNumber()) 
	local spell_hint_table = {
		duration   = duration,		-- 持續時間
		radius     = aoe_radius,		-- 半徑
	}
	dummy:AddNewModifier(dummy,nil,"nobu_modifier_spell_hint",spell_hint_table)
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=duration})
	-- 初始傷害
	local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係
                              target_point,		-- 搜尋的中心點
                              nil, 				-- 好像是優化用的參數不懂怎麼用
                              aoe_radius,		-- 搜尋半徑
                              target_team,		-- 目標隊伍
                              target_type,		-- 目標類型
                              target_flags,		-- 額外選擇或排除特定目標
                              FIND_ANY_ORDER,	-- 結果的排列方式
                              false) 			-- 好像是優化用的參數不懂怎麼用
	local count = 0
	-- 處理搜尋結果
	for _,unit in ipairs(units) do
		if caster:CanEntityBeSeenByMyTeam(unit) then
			count = count + 1
			-- 製造傷害
			local damage_table = {}
			damage_table.victim = unit
			damage_table.attacker = caster					
			damage_table.damage_type = damage_type
			damage_table.damage = start_damage
			ApplyDamage(damage_table)
			if IsValidEntity(unit) then
				-- 特效
				local ifx = ParticleManager:CreateParticle("particles/item/item_thunderstorms.vpcf",PATTACH_CUSTOMORIGIN,unit)
				ParticleManager:SetParticleControl(ifx,0,unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(ifx,1,unit:GetAbsOrigin())
				if count < 3 then
					EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(),"lightningbolt",unit)
				end
			end
		end
	end
	--channel timer
	local time = 0
	Timers:CreateTimer(0, function()
		time = time + 1
		AddFOWViewer(DOTA_TEAM_GOODGUYS,caster:GetAbsOrigin(), 300, 1, false)
		AddFOWViewer(DOTA_TEAM_BADGUYS,caster:GetAbsOrigin(), 300, 1, false)

		-- 搜尋
		local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係
                              target_point,		-- 搜尋的中心點
                              nil, 				-- 好像是優化用的參數不懂怎麼用
                              aoe_radius,		-- 搜尋半徑
                              target_team,		-- 目標隊伍
                              target_type,		-- 目標類型
                              target_flags,		-- 額外選擇或排除特定目標
                              FIND_ANY_ORDER,	-- 結果的排列方式
                              false) 			-- 好像是優化用的參數不懂怎麼用
		local count = 0
		-- 處理搜尋結果
		for _,unit in ipairs(units) do
			if caster:CanEntityBeSeenByMyTeam(unit) then
				count = count + 1
				-- 製造傷害
				local damage_table = {}
				damage_table.victim = unit
	  			damage_table.attacker = caster					
	 			damage_table.damage_type = damage_type
	 			damage_table.damage = aoe_damage
				ApplyDamage(damage_table)
				if IsValidEntity(unit) then
					-- 特效
					local ifx = ParticleManager:CreateParticle("particles/item/item_thunderstorms.vpcf",PATTACH_CUSTOMORIGIN,unit)
					ParticleManager:SetParticleControl(ifx,0,unit:GetAbsOrigin())
					ParticleManager:SetParticleControl(ifx,1,unit:GetAbsOrigin())
					if count < 3 then
						EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(),"lightningbolt",unit)
					end
				end
			end
		end

		-- 判斷是否繼續
		if time <= duration then
			return aoe_delay
		else
			ParticleManager:DestroyParticle(ifx_cloud,false)
			ifx_cloud = nil
			dummy:ForceKill(true)
			return nil
		end
	end)
end