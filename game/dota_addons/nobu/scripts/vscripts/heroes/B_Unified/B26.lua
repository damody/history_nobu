
function B26E_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local center = caster:GetAbsOrigin()
	AMHC:AddModelScale(caster, 1.3, 8)
	local am = caster:FindAllModifiers()
	for _,v in pairs(am) do
		if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil then
			if v:GetParent():GetTeamNumber() ~= caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber() then
				caster:RemoveModifierByName(v:GetName())
			end
		end
	end
end

function B26W( keys )
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	--local point = caster:GetAbsOrigin()
	--local point2 = target:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	caster:FindAbilityByName("B26D"):SetLevel(1)
end

function B26D( keys )
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	--local point2 = target:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("dmg_radius",level)

	if caster:HasModifier("modifier_B26W") then
		caster:RemoveModifierByName("modifier_B26W")
		return
	end
	if caster:FindAbilityByName("B26D"):GetLevel() == 1 then
		StartSoundEvent( "Hero_Brewmaster.ThunderClap", caster )
		caster:FindAbilityByName("B26D"):SetLevel(0)
		local group = FindUnitsInRadius(
	   		caster:GetTeamNumber(), 
	   		caster:GetAbsOrigin(), 
	   		nil, 
	   		500,
	   		DOTA_UNIT_TARGET_TEAM_ENEMY, 
	   		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
	   		DOTA_UNIT_TARGET_FLAG_NONE, 
	   		FIND_ANY_ORDER, 
   			false)
		for _,v in ipairs(group) do
			ability:ApplyDataDrivenModifier(caster,v,"modifier_B26W_2",nil)
		end
		
		local particle = ParticleManager:CreateParticle("particles/b26w2/b26w2.vpcf",PATTACH_POINT,caster)
		ParticleManager:SetParticleControl(particle,0,point)
	end
end

function B26R( keys )
	local caster = keys.caster
	--local target = keys.target
	--local ability = keys.ability
	--local point = caster:GetAbsOrigin()
	--local point2 = target:GetAbsOrigin()
	--local level = ability:GetLevel() - 1
	local dmg = keys.dmg
	if not (dmg > caster:GetHealth()) then
		local hp =  caster:GetHealth() + dmg
		caster:SetHealth(hp)
	end	
end

function B26T( keys )
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	--local point2 = target:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	local particle = ParticleManager:CreateParticle("particles/b26t/b26t.vpcf",PATTACH_POINT,caster)
	ParticleManager:SetParticleControl(particle,0, point)
	ParticleManager:SetParticleControl(particle,1, point+Vector(0,0,299))

	local particle2 = ParticleManager:CreateParticle("particles/b26t4/b26t4.vpcf",PATTACH_POINT,caster)
	ParticleManager:SetParticleControl(particle2,0, point+Vector(0,0,200))
	ParticleManager:SetParticleControl(particle2,1, point+Vector(0,0,299))	
	if caster.wings ~= nil then
		ParticleManager:DestroyParticle(caster.wings,true)
	end
	local wings = ParticleManager:CreateParticle("particles/b26t/b26t_wings.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)
	ParticleManager:SetParticleControl(wings,5, caster:GetAbsOrigin()+Vector(0,0,100))
	caster.wings = wings
	Timers:CreateTimer(0,function()
		if caster:HasModifier("modifier_B26T") then
			ParticleManager:SetParticleControlOrientation(caster.wings,1,caster:GetForwardVector(),caster:GetRightVector(),caster:GetUpVector())
			return 0
		end
		ParticleManager:DestroyParticle(caster.wings,true)
		caster.wings = nil
		return nil		
		end)

	Timers:CreateTimer(0.5,function()
		ParticleManager:DestroyParticle(particle2,false)
	end)	
end