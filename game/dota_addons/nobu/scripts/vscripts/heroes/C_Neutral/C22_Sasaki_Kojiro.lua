	bj_PI                            = 3.14159
	bj_RADTODEG                      = 180.0/bj_PI
	bj_DEGTORAD                      = bj_PI/180.0
--ednglobal

LinkLuaModifier( "C22R_critical", "scripts/vscripts/heroes/C_Neutral/C22_Sasaki_Kojiro.lua",LUA_MODIFIER_MOTION_NONE )

function C22W_Damage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetAbilityDamage()
	local D = caster:FindAbilityByName("C22D")
	local remaining = D:GetCooldownTimeRemaining()
	if remaining > 2 then
		D:EndCooldown()
		D:StartCooldown(remaining - 2)
	else
		D:EndCooldown()
	end
	-- Finds all the enemies in a radius around the target and then deals damage to each of them
    --獲取攻擊範圍
    local group = {}
	local radius = 435
	local time = ability:GetSpecialValueFor("duration")
	-- local dummy = CreateUnitByName("npc_dummy_unit_Ver2",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	local dummy = CreateUnitByName("npc_dummy_unit",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	dummy:FindAbilityByName("majia"):SetLevel(1)
	ability:ApplyDataDrivenModifier(dummy,dummy,"modifier_C22W_EFFECT",{duration=4})
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=time})
	caster.dummy = dummy
	
    --獲取周圍的單位
    group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)

	for _,v in ipairs(group) do
		----print(v:GetUnitName())
		if caster:HasModifier("modifier_C22D") then
			
		end
		if not v:IsMagicImmune() then --是否魔免(如果是加深傷害)
			AMHC:Damage( caster,v,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end
end

function C22W_Stop( keys )
	local caster = keys.caster
	local dummy = caster.dummy
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=0})
	caster:RemoveModifierByName("modifier_C22W")
end


function C22R_SE( keys )
	local caster = keys.caster
	local target = keys.target

	--AMHC:CreateParticle(particleName,PATTACH_CUSTOMORIGIN,false,caster,3,nil)
	local particle = ParticleManager:CreateParticle("particles/c20r2/c20r2.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "attach_sword", Vector(0,0,0), true)
	--ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_sword", caster:GetAbsOrigin()+Vector(1000,1000), true)
end

function C22R__ATTACK_SE( keys )
	local caster = keys.caster
	local rate = caster:GetAttackSpeed()
	--print(tostring(rate))

	--播放動畫
    --caster:StartGesture( ACT_DOTA_ECHO_SLAM )
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
end

C22R_critical = class({})

function C22R_critical:IsHidden()
	return true
end

function C22R_critical:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function C22R_critical:GetModifierPreAttack_CriticalStrike()
	--print("C22R_level ".. self.C22R_level)
	return self.C22R_level*50 + 100
end

function C22R_critical:CheckState()
	local state = {
	}
	return state
end


function C22R_Levelup( keys )
	local caster = keys.caster
	caster.C22R_noncrit_count = 0
	caster.C22R_level = keys.ability:GetLevel()
end

function C22R( keys )
	local caster = keys.caster
	local skill = keys.ability
	local target = keys.target
	local id  = caster:GetPlayerID()
	local ran =  RandomInt(0, 100)
	local crit_percent = 25
	local attack_time = 100/crit_percent + 1
	caster:RemoveModifierByName("C22R_critical")
	if  caster.C22R_noncrit_count ~= nil then
		if not keys.target:IsUnselectable() or keys.target:IsUnselectable() then
			if (ran > crit_percent) then
				caster.C22R_noncrit_count  = caster.C22R_noncrit_count + 1
			end
			if (caster.C22R_noncrit_count > attack_time or ran <= crit_percent) then
				caster.C22R_noncrit_count = 0
				EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
				local rate = caster:GetAttackSpeed()
				caster:AddNewModifier(caster, skill, "C22R_critical", { duration = rate+0.1 } )
				local hModifier = caster:FindModifierByNameAndCaster("C22R_critical", caster)
				if (hModifier ~= nil) then
					hModifier.C22R_level = caster.C22R_level
					-- if caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * ((hModifier.C22R_level*50 +100) / 100) then
					-- 	caster.maximum_critical_damage = caster:GetAverageTrueAttackDamage(target) * ((hModifier.C22R_level*50 +100) / 100)
					-- end
				end
			end
		end
	end
end

function C22D_GetAbility( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("C22R")
	if ability:GetLevel() >0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_C22R", {duration = 4.0})
	end


	direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
		                          caster:GetAbsOrigin(),
		                          nil,
		                          3000,
		                          DOTA_UNIT_TARGET_TEAM_ENEMY,
		                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		                          DOTA_UNIT_TARGET_FLAG_NONE,
		                          FIND_ANY_ORDER,
		                          false)

	for _,it in pairs(direUnits) do
		if it:FindModifierByName("modifier_C22E") ~= nil then
			local target = it
			point = caster:GetAbsOrigin()
			local  x = point.x
			local  y = point.y
			point2 = target:GetAbsOrigin()
			local  x2 	  = point2.x
			local  y2     = point2.y
			local  a      = caster:GetAngles().y --bj_RADTODEG *math.atan2(y2-y,x2-x) 

			local projTable = {
		        EffectName = "particles/c22/c22ed.vpcf",
		        Ability = ability,
		        vSpawnOrigin = target:GetAbsOrigin(),
		        Target = caster,
		        Source = target,
		        iMoveSpeed = 10000,
		        iVisionRadius = 225,
				iVisionTeamNumber = caster:GetTeamNumber(),
		        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			 }
			ProjectileManager:CreateTrackingProjectile( projTable )



			point3 = Vector(x+100*math.cos(a*bj_DEGTORAD) ,  y+100*math.sin(a*bj_DEGTORAD), point.z)--需要Z軸 要不然會低於地圖
			target:SetOrigin(point3)
			target:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})
			--命令攻击被攻击的目标
			local order = {UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = target:entindex()}

			ExecuteOrderFromTable(order)
			break
		end
	end

	--SE
	if caster.c20D_SE == nil then
		caster.c20D_SE = ParticleManager:CreateParticle("particles/c20d3/c20d3.vpcf", PATTACH_POINT_FOLLOW, caster)
		local particle = caster.c20D_SE
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hand", Vector(0,0,0), true)
	end
	--播放動畫
    caster:StartGesture( ACT_DOTA_ATTACK )
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,2.5)
end

function C22D_SE_END( keys )
	local caster = keys.caster
	ParticleManager:DestroyParticle(caster.c20D_SE,false)
	caster.c20D_SE = nil
	if caster:HasModifier("C22R_critical") then
		caster:RemoveModifierByName("C22R_critical")
	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Hide caster's model.
]]
function HideCaster( event )
	event.caster:AddNoDraw()
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Show caster's model.
]]
function ShowCaster( event )
	event.caster:RemoveNoDraw()
end

--[[
	Author: Ractidous
	Date: 13.02.2015.
	Stop a sound on the target unit.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.target )
end

function C22T_Damage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ult_damage = keys.ult_damage/100
	local addition_damage = ability:GetSpecialValueFor("addition_damage")
	local abilitylevel = ability:GetLevel()
	

	-- Finds all the enemies in a radius around the target and then deals damage to each of them
    --獲取攻擊範圍
    local group = {}
    local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1)

    --獲取周圍的單位
    group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)

	for _,v in ipairs(group) do
		if IsValidEntity(v) then
			if v:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, v)
			end
			local damage = ult_damage*v:GetMaxHealth()
			ability:ApplyDataDrivenModifier(caster,v,"modifier_C22T",nil)
			AMHC:Damage( caster,v,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			AMHC:Damage( caster,v,addition_damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end


	local dummy = CreateUnitByName("npc_dummy_unit",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
	dummy:FindAbilityByName("majia"):SetLevel(1)
	caster.dummy = dummy

	local particle = ParticleManager:CreateParticle("particles/c22/c22t.vpcf",PATTACH_ABSORIGIN,dummy)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(radius,0,0))
	ParticleManager:ReleaseParticleIndex(particle)
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=1})
end

-- 佐佐木小次郎 11.2B
---------------------------------------------------------------

function C22E_old_pull_back( keys )
	local caster = keys.caster
	local target = keys.target
	local dis = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
	if IsValidEntity(target) and target:IsAlive() and target:HasModifier("modifier_C22E_old_stun") and dis < 2000 then
		-- 將目標拉回自己面前
		local new_pos = caster:GetAbsOrigin()+caster:GetForwardVector()*100
		FindClearSpaceForUnit(target,new_pos,true)

		-- 命令攻擊目標
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),
			Queue = false
		})
	end
end

function C22R_old_on_attack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local heal = ability:GetSpecialValueFor("heal")
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance",ability:GetLevel()-1)
	if keys.target:IsBuilding() then return end
	if caster.C22R_old == nil then caster.C22R_old = 0 end
	caster.C22R_old = caster.C22R_old + 1
	if RandomInt(1,100) <= crit_chance or caster.C22R_old > (100/crit_chance) then
		caster.C22R_old = 0
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_C22R_old_critical_strike_crit",nil)
		caster:Heal(heal,ability)
	end
end

function C22R_old_play_crit_animation( keys )
	local caster = keys.caster
	local play_back_rate = caster:GetAttackSpeed()
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,play_back_rate)
end

function C22T_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	local aoe_radius = ability:GetLevelSpecialValueFor("aoe_radius",level)
	local start_delay = ability:GetLevelSpecialValueFor("start_delay",level)
	local target_team = ability:GetAbilityTargetTeam()
	local target_type = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local damage_type = ability:GetAbilityDamageType()
	local ability_damage = ability:GetAbilityDamage()
	local center = caster:GetAbsOrigin()+caster:GetForwardVector()*100

	local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf",PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(ifx,0,center) -- 起點
	ParticleManager:SetParticleControl(ifx,1,center) -- 終點
	ParticleManager:SetParticleControl(ifx,3,Vector(0,1,0)) -- 延遲
	ParticleManager:ReleaseParticleIndex(ifx)

	Timers:CreateTimer(start_delay, function()
		-- 砍樹
		GridNav:DestroyTreesAroundPoint(center, aoe_radius, false)
		-- 搜尋
		local units = FindUnitsInRadius(caster:GetTeamNumber(),	-- 關係
                              center,				-- 搜尋的中心點
                              nil, 					-- 好像是優化用的參數不懂怎麼用
                              aoe_radius,			-- 搜尋半徑
                              target_team,			-- 目標隊伍
                              target_type,			-- 目標類型
                              target_flags,			-- 額外選擇或排除特定目標
                              FIND_ANY_ORDER,		-- 結果的排列方式
                              false) 				-- 好像是優化用的參數不懂怎麼用
		-- 處理搜尋結果
		for _,unit in ipairs(units) do
			-- 製造傷害
			local damage_table = {}
			damage_table.victim = unit
  			damage_table.attacker = caster
 			damage_table.damage_type = damage_type
			damage_table.damage = ability_damage
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_C22T_old_apply_dot_damage",nil)
			ApplyDamage(damage_table)			
		end

		-- 特效
		local ifx = ParticleManager:CreateParticle("particles/c22/c22t_old.vpcf",PATTACH_ABSORIGIN,caster)
		local scale = ability:GetLevelSpecialValueFor("aoe_radius",level)
		ParticleManager:SetParticleControl(ifx,0,center)
		ParticleManager:SetParticleControl(ifx,1,Vector(scale,scale,scale))
		ParticleManager:SetParticleControl(ifx,2,Vector(scale,scale,scale))
		ParticleManager:ReleaseParticleIndex(ifx)
	end)
end


function C22T_upgrade( keys )
	keys.caster:FindAbilityByName("C22D"):SetLevel(keys.ability:GetLevel()+1)
end
