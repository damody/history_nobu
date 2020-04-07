--閃避

function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not caster:HasModifier("modifier_ninja_cloth") then
		caster.use_equip_ninja_cloth = 1
		ability:ApplyDataDrivenModifier(caster, caster,"modifier_ninja_cloth",nil)
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	local ability = keys.ability
	if caster.use_equip_ninja_cloth == 1 then
		caster.use_equip_ninja_cloth = nil
		caster:RemoveModifierByName("modifier_ninja_cloth")
	end
end

function OnCreated( keys )
	local caster = keys.caster
	caster.shield_effect = ParticleManager:CreateParticle("particles/item/supressor_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.shield_effect, 1,caster:GetAbsOrigin()+Vector(0, 0, 0))
end

function OnDestroy( keys )
	local caster = keys.caster
	ParticleManager:DestroyParticle(caster.shield_effect, false)
end

function Reckoning( keys )
	local caster = keys.caster
	local target = keys.attacker
	if not target:IsHero() then return nil end
	local ability = keys.ability
	caster:RemoveModifierByName("modifier_reckoning")
	ParticleManager:DestroyParticle(caster.shield_effect, false)
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/a12t2/a12t2.vpcf",
		iMoveSpeed = 2600,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 225                              -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
		local modifiers = caster:FindAllModifiers()
		for i,m in ipairs(modifiers) do
			if m:IsDebuff() then
				print(m:GetName())
				caster:RemoveModifierByName(m:GetName())
			end
		end
end
