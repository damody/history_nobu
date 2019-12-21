function AON_Cleave_B32x(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local dmg = keys.dmg
	local per_atk = 0
	local targetArmor = target:GetPhysicalArmorValue()
	local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
	--local dmg = dmg / (1 - damageReduction)

	AMHC:Damage( caster,target,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )

end

function AON_Cleave_A28T(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  600 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				AMHC:Damage( caster,it,keys.dmg*0.5,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			end
		end
	end
end

function AON_Cleave_B32(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  300 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			end
		end
	end
end

function AON_Cleave_A07E(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local CleavePercent = ability:GetSpecialValueFor("CleavePercent")*0.01
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  ability:GetLevelSpecialValueFor("radius",level) , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	 
		for _, it in pairs(group) do
			if caster:HasModifier("modifier_A07T") and it:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
			end
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it ~= target then
					AMHC:Damage( caster,it,keys.dmg*CleavePercent,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				end
			end
		end
	end
end

function AON_Cleave_A07T(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  365 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	 
		for _, it in pairs(group) do
			if caster:HasModifier("modifier_A07T") and it:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
			end
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it ~= target then
					AMHC:Damage( caster,it,keys.dmg*0.4,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				else
					AMHC:Damage( caster,it,keys.dmg*0.2,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				end
			end
		end
	end
end


function AON_Cleave_A07_20(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  ability:GetLevelSpecialValueFor("radius",level) , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	 
		for _, it in pairs(group) do
			if caster:HasModifier("modifier_A07T") and it:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
			end
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then

				if it ~= target then
					if caster:HasModifier("modifier_A07T") then
						AMHC:Damage( caster,it,keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
					else
						AMHC:Damage( caster,it,keys.dmg*0.5,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
					end
				end
			end
		end
	end
end

function AON_Cleave_A07_old(keys)
	--【Basic】
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local dmgp = ability:GetSpecialValueFor("damage")*0.01
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg * dmgp
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil, 400 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if it:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
			end
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it ~= target then
					AMHC:Damage( caster,it,dmg*1.35,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				else
					AMHC:Damage( caster,it,dmg*0.35,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
				end
			end
		end
	end
end

function AON_Cleave_A06(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local dmgp = ability:GetSpecialValueFor("CleavePercent")
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)
		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  ability:GetLevelSpecialValueFor("CleaveRadius",level) , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		dmg = dmg * ability:GetLevelSpecialValueFor("CleavePercent",level) / 100


		for _, it in pairs(group) do
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it:IsMagicImmune() then
					AMHC:Damage( caster,it,keys.dmg*dmgp*0.5,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				else
					AMHC:Damage( caster,it,keys.dmg*dmgp,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				end
			end
		end
	end
end


function AON_Cleave(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)
		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  ability:GetLevelSpecialValueFor("CleaveRadius",level) , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		dmg = dmg * ability:GetLevelSpecialValueFor("CleavePercent",level) / 100


		for _, it in pairs(group) do
			if it ~= target then
				AMHC:Damage( caster,it,keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			end
			--看防的擴散
			--[[
			if it ~= target and it:IsHero() then
				local targetArmor = it:GetPhysicalArmorValue()
				local damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
				print(keys.dmg.." damageReduction "..damageReduction)
				
			elseif it ~= target then
				local targetArmor = it:GetPhysicalArmorValue()
				local damageReduction = ((0.5 * targetArmor) / (1 + 0.5* targetArmor))
				print(keys.dmg.." damageReduction "..damageReduction)
				AMHC:Damage( caster,it,keys.dmg*(1-damageReduction),AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			end
			]]
		end
	end
end

function AON_Cleave_C14(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(),
			nil, 300 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it ~= target then
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				else
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				end
			end
		end
	else
		--AMHC:Damage( caster,target,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end
function AON_Cleave_C20(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(),
			nil, 300 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				if it ~= target then
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				else
					AMHC:Damage( caster,it,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				end
			end
		end
	else
		--AMHC:Damage( caster,target,keys.dmg*0.20,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end


function AON_Cleave_robbers_skill(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	if not target:IsBuilding() then
		local ability = keys.ability
		local dmg = keys.dmg
		local per_atk = 0
		local targetArmor = target:GetPhysicalArmorValue()
		local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
		--local dmg = dmg / (1 - damageReduction)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil, 400 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			if it:IsHero() then
				ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
			end
			AMHC:Damage( caster,it,keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
		end
	end
end


function AON_Cleave_A08(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = keys.dmg
	local per_atk = 0
	local targetArmor = target:GetPhysicalArmorValue()
	local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
	--local dmg = dmg / (1 - damageReduction)

	local group = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(),
		nil, 400 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, it in pairs(group) do
		if _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
			if it ~= target then
				AMHC:Damage( caster,it,keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			end
		end
	end
end


function AON_Cleave_A03(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = keys.dmg
	local per_atk = 0
	local targetArmor = target:GetPhysicalArmorValue()
	local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
	--local dmg = dmg / (1 - damageReduction)

	local group = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(),
		nil, 400 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, it in pairs(group) do
		if it:IsHero() then
			ParticleManager:CreateParticle("particles/shake3.vpcf", PATTACH_ABSORIGIN, it)
		end
		AMHC:Damage( caster,it,keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
	end
end
