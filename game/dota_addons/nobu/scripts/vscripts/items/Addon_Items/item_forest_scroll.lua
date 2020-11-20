--林之卷
LinkLuaModifier( "forest_crit", "items/Addon_Items/item_forest_scroll.lua",LUA_MODIFIER_MOTION_NONE )
--野太刀


forest_crit = class({})

function forest_crit:IsHidden()
	return true
end

function forest_crit:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
end

function forest_crit:GetModifierPreAttack_CriticalStrike()
	return 150
end

function forest_crit:CheckState()
	local state = {
	}
	return state
end



function forest_crit_Shock( keys )
	local caster = keys.caster
	local skill = keys.ability
	local ran =  RandomInt(0, 100)
	caster:RemoveModifierByName("forest_crit")
	if (caster.forest_crit_count == nil) then
		caster.forest_crit_count = 0
	end
	print("forest_crit_Shock")
	if (ran > 50) then
		caster.forest_crit_count = caster.forest_crit_count + 1
	end
	if (caster.forest_crit_count > 1 or ran <= 50) then
		caster.forest_crit_count = 0
		StartSoundEvent( "Hero_SkeletonKing.CriticalStrike", keys.target )
		local rate = caster:GetAttackSpeed()
		caster:AddNewModifier(caster, skill, "forest_crit", { duration = rate+0.1 } )
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


function dispear( keys )
	local caster = keys.caster
	if caster.nodispear == nil then
		caster:AddNewModifier(caster,ability,"modifier_invisible",{duration=2})
		caster:AddNewModifier(caster,ability,"modifier_soldier_E_collision",{duration=2})
	end
end

function dispear2( keys )
	local caster = keys.caster
	caster:AddNewModifier(caster,ability,"modifier_invisible",{})
	caster:AddNewModifier(caster,ability,"modifier_soldier_E_collision",{})
end

function nodispear( keys )
	local caster = keys.caster
	if caster.nodispear == nil then
		Timers:CreateTimer(0.5, function()
			caster.nodispear = caster.nodispear - 1
			if caster.nodispear < 0 then
				caster.nodispear = nil
				return nil
			end
			return 0.5
		end)
	end
	caster.nodispear = 2
end

function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetOrigin()
	local duration = ability:GetSpecialValueFor("duration")
	--particles
	particle = ParticleManager:CreateParticle("particles/d04/d04.vpcf",PATTACH_POINT,caster)
	ParticleManager:SetParticleControl(particle,0, point+Vector(0,0,100))
	ParticleManager:SetParticleControl(particle,3, point)

	local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          400,
          DOTA_UNIT_TARGET_TEAM_FRIENDLY,
          DOTA_UNIT_TARGET_HERO,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
		  false)
	for _,target in pairs(direUnits) do
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			if target:IsHero() then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_invisible", {duration = duration})
			end
		end
	end
	for itemSlot = 0,8 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil and ((item:GetName() == "item_forest_scroll") or
				(item:GetName() == "item_the_art_of_war_forest_chapter") or 
				(item:GetName() == "item_the_lost_art_of_war_1") or 
				(item:GetName() == "item_recipe_the_art_of_war"))then
			item:StartCooldown(ability:GetCooldown(-1))
		end
	end
end

function Shock_new ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local team = caster:GetTeamNumber()
	local point = caster:GetAbsOrigin()
	local A_count = _G.A_count
	local unit_name = nil
	local duration = ability:GetSpecialValueFor("unitduration")
	local randomkey = RandomInt(1,8)
	local infantry = ability:GetSpecialValueFor("infantry")
	local archer = ability:GetSpecialValueFor("archer")
	if team == 2 then
		infantry_name = "oda_infantry_forest"
		archer_name = "oda_archer_forest"
	else
		infantry_name = "unified_infantry_forest"
		archer_name = "unified_archer_forest"
	end
	for i = 1 , infantry do 
		local unit = CreateUnitByName(infantry_name, point , true, caster, caster, team)
		unit:SetMaximumGoldBounty(5)
		unit:SetMinimumGoldBounty(5)
		unit:SetBaseMoveSpeed(375)
		unit:SetDeathXP(0)
		unit:AddAbility("set_level_1"):SetLevel(1)
		local hp = (unit:GetMaxHealth() + 150)
		if caster.great_sword_of_disease then
			hp = hp * 1.5
		end
		unit:SetBaseMaxHealth(hp * 2 + A_count * 8)
		local dmgmax = unit:GetBaseDamageMax()
		local dmgmin = unit:GetBaseDamageMin()
		unit:SetBaseDamageMax(dmgmax + 30 + A_count*1)
		unit:SetBaseDamageMin(dmgmin + 30 + A_count*1)
		local armor = unit:GetPhysicalArmorBaseValue()
		unit:SetPhysicalArmorBaseValue(armor+_G.armor_bonus)
		unit:SetOwner(caster)
		unit:SetControllableByPlayer(caster:GetPlayerID(),true)
		unit:AddNewModifier(unit,nil,"modifier_kill",{duration=duration})
		caster:AddNewModifier(caster,nil,"modifier_phased",{duration=0.3})
		unit:AddNewModifier(unit,nil,"modifier_phased",{duration=0.3})
	end

	if archer then
		for i = 1 , archer do
			local unit = CreateUnitByName(archer_name, point , true, caster, caster, team)
			unit:SetMaximumGoldBounty(5)
			unit:SetMinimumGoldBounty(5)
			unit:SetDeathXP(0)
			unit:AddAbility("set_level_1"):SetLevel(1)
			unit:AddAbility("forest_truesight"):SetLevel(1)
			local hp = unit:GetMaxHealth()
			if caster.great_sword_of_disease then
				hp = hp *1.5
			end
			unit:SetBaseMaxHealth(hp * 2 + A_count * 8)
			local dmgmax = unit:GetBaseDamageMax()
			local dmgmin = unit:GetBaseDamageMin()
			unit:SetBaseDamageMin(dmgmax + 30 + A_count*2)
			unit:SetBaseDamageMin(dmgmin + 30 + A_count*2)
			local armor = unit:GetPhysicalArmorBaseValue()
			unit:SetPhysicalArmorBaseValue(armor+ _G.armor_bonus)
			unit:SetOwner(caster)
			unit:SetControllableByPlayer(caster:GetPlayerID(),true)
			unit:AddNewModifier(unit,nil,"modifier_kill",{duration=duration})
			caster:AddNewModifier(caster,nil,"modifier_phased",{duration=0.3})
			unit:AddNewModifier(unit,nil,"modifier_phased",{duration=0.3})
		end
	end

end

function Shock_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local monster1 = CreateUnitByName("forest_soldier1",caster:GetAbsOrigin()+caster:GetForwardVector()*100 ,false,caster,caster,caster:GetTeamNumber())
	monster1:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
	monster1:AddNewModifier(monster1,ability,"modifier_phased",{duration=0.1})
	monster1:FindAbilityByName("forest_soldier_W"):SetLevel(1)
	ability:ApplyDataDrivenModifier(monster1, monster1,"modifier_kill", {duration=15})
	caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
	
	local monster2 = CreateUnitByName("forest_xcaster1",caster:GetAbsOrigin()+caster:GetForwardVector()*100 ,false,caster,caster,caster:GetTeamNumber())
	monster2:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
	monster2:FindAbilityByName("forest_caster_W"):SetLevel(1)
	monster2:AddNewModifier(monster2,ability,"modifier_phased",{duration=0.1})
	ability:ApplyDataDrivenModifier(monster2, monster2,"modifier_kill", {duration=15})
end

function Shock2( keys )
	local caster = keys.caster
	local ability = keys.ability
	for i=1,2 do
		local monster1 = CreateUnitByName("forest_soldier2",caster:GetAbsOrigin()+caster:GetForwardVector()*100 ,false,caster,caster,caster:GetTeamNumber())
		monster1:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
		monster1:AddNewModifier(monster1,ability,"modifier_phased",{duration=0.1})
		monster1:FindAbilityByName("forest_soldier_W"):SetLevel(2)
		ability:ApplyDataDrivenModifier(monster1, monster1,"modifier_kill", {duration=15})
		caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
	end
	local monster2 = CreateUnitByName("forest_xcaster2",caster:GetAbsOrigin()+caster:GetForwardVector()*100 ,false,caster,caster,caster:GetTeamNumber())
	monster2:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
	monster2:FindAbilityByName("forest_caster_W"):SetLevel(2)
	monster2:FindAbilityByName("forest_caster_E"):SetLevel(2)
	monster2:FindAbilityByName("forest_caster_R"):SetLevel(1)
	monster2:AddNewModifier(monster2,ability,"modifier_phased",{duration=0.1})
	ability:ApplyDataDrivenModifier(monster2, monster2,"modifier_kill", {duration=15})
end


function Shock3( keys )
	local caster = keys.caster
	local ability = keys.ability
	for i=1,3 do
		local monster1 = CreateUnitByName("forest_soldier3",caster:GetAbsOrigin()+caster:GetForwardVector()*200 ,false,caster,caster,caster:GetTeamNumber())
		monster1:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
		monster1:AddNewModifier(monster1,ability,"modifier_phased",{duration=0.1})
		monster1:FindAbilityByName("forest_soldier_W"):SetLevel(3)
		monster1:FindAbilityByName("forest_soldier_E"):SetLevel(1)
		monster1:FindAbilityByName("forest_soldier_R"):SetLevel(1)
		ability:ApplyDataDrivenModifier(monster1, monster1,"modifier_kill", {duration=18})
		caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
	end
	local monster2 = CreateUnitByName("forest_xcaster3",caster:GetAbsOrigin()+caster:GetForwardVector()*200 ,false,caster,caster,caster:GetTeamNumber())
	monster2:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
	monster2:FindAbilityByName("forest_caster_W"):SetLevel(3)
	monster2:FindAbilityByName("forest_caster_E"):SetLevel(3)
	monster2:FindAbilityByName("forest_caster_R"):SetLevel(2)
	monster2:AddNewModifier(monster2,ability,"modifier_phased",{duration=0.1})
	ability:ApplyDataDrivenModifier(monster2, monster2,"modifier_kill", {duration=18})
end

function Shock4( keys )
	local caster = keys.caster
	local ability = keys.ability
	for i=1,1 do
		local monster1 = CreateUnitByName("forest_soldier4",caster:GetAbsOrigin()+caster:GetForwardVector()*300 ,false,caster,caster,caster:GetTeamNumber())
		monster1:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
		monster1:AddNewModifier(monster1,ability,"modifier_phased",{duration=0.1})
		monster1:FindAbilityByName("forest_soldier_W2"):SetLevel(1)
		monster1:FindAbilityByName("forest_soldier_E"):SetLevel(1)
		monster1:FindAbilityByName("forest_soldier_R"):SetLevel(1)
		ability:ApplyDataDrivenModifier(monster1, monster1,"modifier_kill", {duration=30})
		caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
	end
	local monster2 = CreateUnitByName("forest_xcaster4",caster:GetAbsOrigin()+caster:GetForwardVector()*300 ,false,caster,caster,caster:GetTeamNumber())
	monster2:SetControllableByPlayer(caster:GetPlayerOwnerID(),false)
	monster2:FindAbilityByName("forest_caster_W"):SetLevel(4)
	monster2:FindAbilityByName("forest_caster_E"):SetLevel(4)
	monster2:FindAbilityByName("forest_caster_R"):SetLevel(3)
	monster2:FindAbilityByName("forest_caster_T"):SetLevel(1)
	monster2:AddNewModifier(monster2,ability,"modifier_phased",{duration=0.1})
	ability:ApplyDataDrivenModifier(monster2, monster2,"modifier_kill", {duration=30})
end

function soldier1(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	--local player = caster:GetPlayerID()
	local point = caster:GetAbsOrigin()
	local point2 = target:GetAbsOrigin()
	--local point2 = ability:GetCursorPosition()
	--local vec = caster:GetForwardVector():Normalized()

	--【Varible】
	local time = ability:GetSpecialValueFor("time")
	--local radius = ability:GetLevelSpecialValueFor("radius",level)
	if target:IsMagicImmune() then
		time = time * 0.5
	end
	print("time", time)
	ability:ApplyDataDrivenModifier( caster, target, "modifier_soldier_W", {duration = time} )
	AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )

	for i=0,3 do
		local particle2 = ParticleManager:CreateParticle("particles/b02r3/b02r3.vpcf",PATTACH_POINT,target)
		ParticleManager:SetParticleControl(particle2,0, point2+Vector(0,0,i*40))
		ParticleManager:SetParticleControl(particle2,1, Vector(1,1,1))	
		ParticleManager:SetParticleControl(particle2,3, point2)	
		Timers:CreateTimer(time,function ()
			ParticleManager:DestroyParticle(particle2,true)
		end	)
	end
end


function soldier1x(keys)
	--【Basic】
	local caster = keys.caster
	local ability = keys.ability
	--local player = caster:GetPlayerID()
	local point = keys.target_points[1]

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
          point,
          nil,
          500,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          0,
          false)

	local time = ability:GetSpecialValueFor("time")

	for i,target in pairs(units) do
		if target:IsMagicImmune() then
			ability:ApplyDataDrivenModifier( caster, target, "modifier_soldier_W", {duration = time*0.5} )
		else
			ability:ApplyDataDrivenModifier( caster, target, "modifier_soldier_W", {duration = (time)} )
		end
		AMHC:Damage(caster,target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
		local particle2 = ParticleManager:CreateParticle("particles/b02r3/b02r3.vpcf",PATTACH_POINT,target)
		ParticleManager:SetParticleControl(particle2,0, target:GetAbsOrigin()+Vector(0,0,i*40))
		ParticleManager:SetParticleControl(particle2,1, Vector(1,1,1))	
		ParticleManager:SetParticleControl(particle2,3, target:GetAbsOrigin())	
		Timers:CreateTimer(time,function ()
			ParticleManager:DestroyParticle(particle2,true)
		end	)
	end

end

function Death(keys)
    keys.caster:ForceKill(false)
end
