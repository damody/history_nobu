
LinkLuaModifier( "B16W_old_critical", "scripts/vscripts/heroes/B_Unified/B16_Mochidsuki_Chiyome.lua",LUA_MODIFIER_MOTION_NONE )

function B16W_Unlock( keys )
	-- 解鎖[忍法．飛襲令]
	keys.caster:FindAbilityByName("B16W"):SetActivated(true)
end

function B16W_Lock( keys )
	-- 鎖住[忍法．飛襲令]
	keys.caster:FindAbilityByName("B16W"):SetActivated(false)
end

function B16W( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local moonMoon = caster.moonMoon
	if moonMoon then
		-- 安裝修改器
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_B16W",nil)
		ability:ApplyDataDrivenModifier(caster,moonMoon,"modifier_B16W",nil)

		-- MoonMoon Jump !
		-------------------------------------------------------------------------------------------------
		-- 解除即將命中月月的投射物
		ProjectileManager:ProjectileDodge(moonMoon)

		-- 強制移動月月到目標旁邊
		local oldPos = moonMoon:GetAbsOrigin()
		local targetPos = target:GetAbsOrigin()
		local dir = (targetPos-oldPos):Normalized()
		moonMoon:SetForwardVector(dir)
		FindClearSpaceForUnit(moonMoon,targetPos-dir*100,false)
		
		-- 特效
		local newPos = moonMoon:GetAbsOrigin()

		-- 特效 月月傳送通道
		local pStart2 = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6_shock_halo.vpcf", PATTACH_ABSORIGIN, moonMoon)	
		ParticleManager:SetParticleControl(pStart2, 0, oldPos)
		ParticleManager:SetParticleControl(pStart2, 1, oldPos)
		ParticleManager:SetParticleControlForward(pStart2,1,dir)
		local pEnd2 = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6_shock_ring.vpcf", PATTACH_ABSORIGIN, moonMoon)
		ParticleManager:SetParticleControl(pEnd2, 0, newPos)
		ParticleManager:SetParticleControl(pEnd2, 1, newPos-dir*200)
		ParticleManager:SetParticleControlForward(pEnd2,1,dir)

		moonMoon:EmitSound("DOTA_Item.BlinkDagger.Activate")

		-- 命令月月攻擊目標
		local order = {
			UnitIndex = moonMoon:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex()
		}
		ExecuteOrderFromTable(order)
	end
end

function B16W_M_Created( keys )
	local target = keys.target
	-- 特效 旋轉光環
	-- 需要手動刪除
	local B16W_M_P = ParticleManager:CreateParticle("particles/b16/b16w_buff.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	target.B16W_M_P = B16W_M_P
end

function B16W_M_Destroy( keys )
	local target = keys.target
	ParticleManager:DestroyParticle(target.B16W_M_P, false)
end

function B16R_M_OnCreated( keys )
	local target = keys.target
	-- 特效 閃電光環
	-- 需要手動刪除
	local B16R_M_P = ParticleManager:CreateParticle("particles/b16/b16r.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	-- 根據技能等級調整旋轉速度
	local abilityLv = keys.ability:GetLevel()
	ParticleManager:SetParticleControl(B16R_M_P,1,Vector(abilityLv*0.01,0,0))
	target.B16R_M_P = B16R_M_P
end

function B16R_OnUpgrade( keys )
	local target = keys.caster
	local abilityLv = keys.ability:GetLevel()
	if target.B16R_M_P ~= nil then
		ParticleManager:SetParticleControl(target.B16R_M_P,1,Vector(abilityLv*0.01,0,0))
	end
end

function B16R_M_OnDestroy( keys )
	local target = keys.target
	ParticleManager:DestroyParticle(target.B16R_M_P, false)
end

function B16D_SpawnMoonMoon( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- 刪除舊的月月實體
	if IsValidEntity(caster.moonMoon) then
		caster.moonMoon:Destroy()
	end

	-- 在英雄前方產生月月
	local spawnPosition = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
	caster.moonMoon = CreateUnitByName("B16D_SUMMEND_UNIT",spawnPosition,true,caster,caster,caster:GetTeam())
	caster.moonMoon:SetForwardVector(caster:GetForwardVector())

	-- *重要* 設定月月的控制權
	caster.moonMoon:SetControllableByPlayer(caster:GetPlayerID(),true)

	-- 裝上修改器
	ability:ApplyDataDrivenModifier(caster,caster.moonMoon,"modifier_B16D_MoonMoon",nil)

	-- 記住主人
	caster.moonMoon.master = caster
end

function B16D_InitMoonMoon( keys )
	local caster = keys.caster
	local moonMoon = keys.target

	-- ***如果月月不存在就什麼都不做***
	if not IsValidEntity(moonMoon) then
		return
	end

	-- 安裝技能
	local B16MMD = moonMoon:AddAbility("B16MMD")
	local B16MMT = moonMoon:AddAbility("B16MMT")
	local B16MMR = moonMoon:AddAbility("B16R")
	local B16MMF = moonMoon:AddAbility("B16MMF")

	-- 呼叫能力調整函式
	B16_AbilityAdjust(keys)
end

function B16_AbilityAdjust( keys )
	local caster = keys.caster
	local moonMoon = caster.moonMoon

	-- ***如果沒有此單位就什麼都不做***
	if (not IsValidEntity(caster)) or (not caster:IsRealHero()) then
		return
	end

	local B16R = caster:FindAbilityByName("B16R")
	local B16W = caster:FindAbilityByName("B16W")
	local B16F = caster:FindAbilityByName("B16MMD")
	if B16F == nil then
		B16F = caster:FindAbilityByName("B16F")
	end

	-- 利用[忍法．飛襲令]的等級判斷是否學會技能
	if B16W ~= nil then
		-- 設定望月[相移]
		if B16F ~= nil and B16W:GetLevel() >= 3 then
			B16F:SetLevel(1)
			B16F.target = moonMoon
		end
	end

	if IsValidEntity(moonMoon) then

		local B16MMD = moonMoon:FindAbilityByName("B16MMD")
		local B16MMT = moonMoon:FindAbilityByName("B16MMT")
		local B16MMR = moonMoon:FindAbilityByName("B16R")
		local B16MMF = moonMoon:FindAbilityByName("B16MMF")

		-- 設定[忍法．迅雷]等級
		if B16MMR ~= nil and B16R ~= nil then
			B16MMR:SetLevel(B16R:GetLevel())
		end
		
		-- 利用[忍法．飛襲令]的等級判斷是否學會技能
		if B16W ~= nil then
			-- 設定月月[掃擊]
			if B16MMT ~= nil and B16W:GetLevel() >= 2 then
				B16MMT:SetLevel(1)
			end
			-- 設定月月[相移]
			if B16MMD ~= nil and B16W:GetLevel() >= 3 then
				B16MMD:SetLevel(1)
				B16MMD.target = caster
			end
			-- 設定月月[隱形]
			if B16MMF ~= nil and B16W:GetLevel() >= 4 then
				B16MMF:SetLevel(1)
			end
		end

		-- Todo: 調整月月能力
		local caster_level = caster:GetLevel()
		moonMoon:FindModifierByName("modifier_B16D_MoonMoon"):SetStackCount(caster_level)
		local hp = caster:GetMaxHealth()+caster:GetLevel()*100
		if hp > 2200 then
			hp =  2200
		end
		moonMoon:SetBaseMaxHealth(hp)
	end
end

function B16T( keys )
	local ability = keys.ability
	local caster = keys.caster
	local moonMoon = caster.moonMoon

	-- 幫望月與月月裝上修改器
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_B16T",nil)
	if IsValidEntity(moonMoon) and moonMoon:IsAlive() then
		ability:ApplyDataDrivenModifier(caster,moonMoon,"modifier_B16T",nil)
	end
end

function B16T_M_Created( keys )
	local caster = keys.caster
	local target = keys.target

	-- 需要手動刪除
	--local B16T_M_P = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	--local level = 3
	--ParticleManager:SetParticleControl(B16T_M_P, 1, Vector(level,0,0))

	local B16T_M_P = ParticleManager:CreateParticle("particles/b16/b16t.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	target.B16T_M_P = B16T_M_P
end

function B16T_M_Destory( keys )
	local target = keys.target
	ParticleManager:DestroyParticle(target.B16T_M_P, false)
end

-- 月月技能組
function B16MMD( keys )
	local caster = keys.caster
	local target = keys.ability.target -- 需要手動添加
	local posA = caster:GetAbsOrigin()
	local posB = target:GetAbsOrigin()

	-- 解除即將命中自己的投射物
	ProjectileManager:ProjectileDodge(target)
	ProjectileManager:ProjectileDodge(caster)

	-- 交換位置
	FindClearSpaceForUnit(target,posA,true)
	FindClearSpaceForUnit(caster,posB,true)

	-- 特效
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
	target:EmitSound("DOTA_Item.BlinkDagger.Activate")

	-- 當英雄施放時移除月月的隱身
	if caster:IsRealHero() then
		keys.target = target
		SetMoonMoonVisable( keys )
	end
end

function B16MMD_M_OnCreated( keys )
	keys.ability:SetActivated(false)
end

function B16MMD_M_Think( keys )
	local caster = keys.caster
	local target = keys.ability.target
	local ability = keys.ability

	-- 判斷雙方距離決定是否開啟此技能
	if IsValidEntity(target) and target:IsAlive() and CalcDistanceBetweenEntityOBB(caster,target) <= 1600 then
		ability:SetActivated(true)
	else
		ability:SetActivated(false)
	end
end

function SetMoonMoonVisable( keys )
	local moonMoon = keys.target
	moonMoon:RemoveModifierByName("modifier_B16MMF")
end

function TestPrint( event )
	local caster = event.caster 
    local target = event.target
    local unit = event.unit
    local attacker = event.attacker
    local ability = event.ability

    -- Tables
    local target_points = event.target_points
    local target_entities = event.target_entities

    -- Extra parameter
    local EventName = event.EventName
    local Damage = event.Damage

    if EventName then print("**"..EventName.."**") end
    print("~~~")
    if caster then print("CASTER: "..caster:GetUnitName()) end
    if target then print("TARGET: "..target:GetUnitName()) end
    if unit then print("UNIT: "..unit:GetUnitName()) end
    if attacker then print("ATTACKER: "..attacker:GetUnitName()) end
    if Damage then print("DAMAGE: "..Damage) end
    if ability then print("ABILITY: "..ability:GetAbilityName()) end

    if target_points then
        for k,v in pairs(target_points) do
            print("POINT",k,v)
        end
    end

    -- Multiple Targets
    if target_entities then
        for k,v in pairs(target_entities) do
            print("TARGET "..k..": "..v:GetUnitName())
        end
    end

    --DeepPrintTable(event)
    print("~~~")
end

-- 舊版 11.2B
-----------------------------------------------------------------------------------------------------------------------------
-- 更新月月身上的各種能力
-- caster必須是望月
function MoonMoonAdjust_old( keys )
	local caster = keys.caster
	local moonMoon = caster.moonMoon

	if IsValidEntity(moonMoon) then

		local B16W_old = caster:FindAbilityByName("B16W_old") -- [忍法．召喚忍犬]
		local B16R_old = caster:FindAbilityByName("B16R_old") -- [忍法．迅雷]

		local B16MMW_old = moonMoon:FindAbilityByName("B16MMW_old") -- [一擊斬]
		local B16MME_old = moonMoon:FindAbilityByName("B16MME_old") -- [撕裂攻擊]
		--local B16MMR_old = moonMoon:FindAbilityByName("B16MMR_old") -- [忍法．迅雷]
		local B16MMT_old = moonMoon:FindAbilityByName("B16MMT_old") -- [永久隱形]

		B16MMW_old:SetLevel(1)
		if B16W_old:GetLevel() >= 2 then B16MMT_old:SetLevel(1) end
		if B16W_old:GetLevel() >= 4 then B16MME_old:SetLevel(1) end

		-- Todo: 調整月月能力
		local caster_level = caster:GetLevel()
		if (caster_level > 20) then
			caster_level = caster_level * 1.5
		elseif (caster_level > 15) then
			caster_level = caster_level * 1.5
		elseif (caster_level > 10) then
			caster_level = caster_level * 1.5
		elseif (caster_level > 5) then
			caster_level = caster_level * 1.5
		end
		moonMoon:FindModifierByName("modifier_B16W_old_forMoonMoon"):SetStackCount(caster_level)
	end
end

function B16W_old_SpawnMoonMoon( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- 刪除舊的月月實體
	if IsValidEntity(caster.moonMoon) then
		caster.moonMoon:Destroy()
	end

	-- 在英雄前方產生月月
	local spawnPosition = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
	local moonMoon = CreateUnitByName("B16W_old_SUMMEND_UNIT",spawnPosition,true,caster,caster,caster:GetTeam())
	moonMoon:SetForwardVector(caster:GetForwardVector())
	
	-- 記住Handle
	caster.moonMoon = moonMoon
	moonMoon.master = caster

	-- *重要* 設定月月的控制權
	moonMoon:SetControllableByPlayer(caster:GetPlayerID(),true)

	-- 安裝修改器
	local duration_MM = ability:GetLevelSpecialValueFor("duration_MM",ability:GetLevel()-1)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_B16W_old_timer",nil)
	ability:ApplyDataDrivenModifier(caster,moonMoon,"modifier_B16W_old_forMoonMoon",nil)
	ability:ApplyDataDrivenModifier(caster,moonMoon,"modifier_B16W_old_buff",nil)
	moonMoon:AddNewModifier(moonMoon,nil,"modifier_kill",{duration=duration_MM})

	-- 安裝技能
	local B16MMW_old = moonMoon:AddAbility("B16MMW_old") -- [一擊斬]
	local B16MME_old = moonMoon:AddAbility("B16MME_old") -- [撕裂攻擊]
	--local B16MMR_old = moonMoon:AddAbility("B16MMR_old") -- [忍法．迅雷]
	local B16MMT_old = moonMoon:AddAbility("B16MMT_old") -- [永久隱形]

	local baseHP = ability:GetLevelSpecialValueFor("baseHP",ability:GetLevel()-1)
	local hp = baseHP + caster:GetLevel()*100
	if hp > 2200 then
		hp =  2200
	end
	moonMoon:SetBaseMaxHealth(hp)
end

function B16R_old_M_OnCreated( keys )
	local target = keys.target
	-- 特效 閃電光環
	-- 需要手動刪除
	local B16R_M_P = ParticleManager:CreateParticle("particles/b16/b16r_old.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	-- 根據技能等級調整旋轉速度
	local abilityLv = keys.ability:GetLevel()
	ParticleManager:SetParticleControl(B16R_M_P,1,Vector(abilityLv*0.01,0,0))
	target.B16R_M_P = B16R_M_P
end

function B16R_old_OnUpgrade( keys )
	local target = keys.caster
	local abilityLv = keys.ability:GetLevel()
	if target.B16R_M_P ~= nil then
		ParticleManager:SetParticleControl(target.B16R_M_P,1,Vector(abilityLv*0.01,0,0))
	end
end

function B16R_old_M_OnDestroy( keys )
	local target = keys.target
	ParticleManager:DestroyParticle(target.B16R_M_P, false)
end

function B16T_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:SetTimeUntilRespawn(0)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_B16T_old",{duration=10})
end

B16W_old_critical = class({})

function B16W_old_critical:IsHidden()
	return true
end

function B16W_old_critical:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function B16W_old_critical:GetModifierPreAttack_CriticalStrike()
	return 200
end

function B16W_old_critical:CheckState()
	local state = {
	}
	return state
end

function B16W_old( keys )
	local caster = keys.caster
	local skill = keys.ability
	local ran =  RandomInt(0, 100)
	caster:RemoveModifierByName("B16W_old_critical")
	if (caster.B16W_old_noncrit_count == nil) then
		caster.B16W_old_noncrit_count = 0
	end
	if not keys.target:IsUnselectable() or keys.target:IsUnselectable() then
		if (ran > 25) then
			caster.B16W_old_noncrit_count = caster.B16W_old_noncrit_count + 1
		end
		if (caster.B16W_old_noncrit_count > 4 or ran <= 25) then
			caster.B16W_old_noncrit_count = 0
			StartSoundEvent( "Hero_SkeletonKing.CriticalStrike", keys.target )
			local rate = caster:GetAttackSpeed()
			caster:AddNewModifier(caster, skill, "B16W_old_critical", { duration = rate+0.1 } )
			--SE
			-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur_impact.vpcf", PATTACH_POINT, keys.target)
			-- ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
			--動作
			local rate = caster:GetAttackSpeed()
			--print(tostring(rate))

			--播放動畫
		    --caster:StartGesture( ACT_SLAM_TRIPMINE_ATTACH )
			if rate < 1 then
			    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
			else
			    caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
			end
		end
	end
end

function B16W_old_attack(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local dmg = keys.dmg
	--print("B01R "..dmg)
	local per_atk = 0
	local targetArmor = target:GetPhysicalArmorValue()

	if target:IsHero() then 
		per_atk = ability:GetLevelSpecialValueFor("atk_hero",level)
		local particle = ParticleManager:CreateParticle("particles/b01r/b01r.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin()+Vector(0, 0, 100))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle,false)
		end)
	elseif  target:IsBuilding() then
		per_atk = ability:GetLevelSpecialValueFor("atk_building",level)
	else
		per_atk = ability:GetLevelSpecialValueFor("atk_unit",level)
		local particle = ParticleManager:CreateParticle("particles/b01r/b01r.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin()+Vector(0, 0, 100))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle,false)
		end)
		AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
	local dmgori = dmg
	dmg = dmg * per_atk  / 100
	
	--print(dmgori, damageReduction, dmg)
	if caster:HasModifier("modifier_B16W_old_buff2") then
		AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
	end
end

function B16MME_old(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ran =  RandomInt(0, 100)
	if ran <= 20 and not target:IsBuilding() then
		if not target:IsMagicImmune() then
			AMHC:Damage( caster,target,60,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
		if caster:HasModifier("modifier_B16W_old_buff2") then
			ability:ApplyDataDrivenModifier(caster,target,"modifier_B16MME_old_stun",nil)
		end
	end
end

function B16MMT(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ran =  RandomInt(0, 100)
	if ran < 15 and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_B16MMT_stun",nil)
		AMHC:Damage( caster,target,60,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end

function MoonMoon_buff(keys)
	--【Basic】
	local caster = keys.caster
	local ability = keys.ability
	local moonMoon = caster.moonMoon
	if IsValidEntity(moonMoon) then
		local dis = (caster:GetAbsOrigin()-moonMoon:GetAbsOrigin()):Length2D()
		if dis < 1000 then
			ability:ApplyDataDrivenModifier(caster, moonMoon,"modifier_B16W_old_buff2", {duration = 0.6})
		end
	end
end