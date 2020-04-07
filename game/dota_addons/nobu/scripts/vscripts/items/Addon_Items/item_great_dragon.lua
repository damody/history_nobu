
function Shock( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	
	local start = caster:GetAbsOrigin()
	local vec = point - start
	vec = vec:Normalized()

	Timers:CreateTimer(0.2, function()
		GridNav:DestroyTreesAroundPoint(start, 250, false)
		GridNav:DestroyTreesAroundPoint(start + vec*250, 250, false)
		GridNav:DestroyTreesAroundPoint(start + vec*400, 250, false)
		GridNav:DestroyTreesAroundPoint(start + vec*550, 250, false)
	end)
end


function OnAttackLanded( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = keys.dmg
	if not target:IsBuilding() then
		if caster:GetBaseAttackRange() < 200 then
			ParticleManager:CreateParticle("particles/item_great_dragon/great_dragon_on_attack.vpcf", PATTACH_ABSORIGIN, caster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
			for i,v in pairs(enemies) do
				local distance = (caster:GetAbsOrigin() - v:GetAbsOrigin()):Length()
				local a = v:GetAbsOrigin() - caster:GetAbsOrigin()
				a = a:Normalized()
				b = caster:GetForwardVector()
				local angle = math.acos(dot(a,b) / (a:Length() * b:Length()))
				if dot(a,b) / (a:Length() * b:Length()) > 1 then
					angle = 0
				end
				if math.deg(angle) < 60 and v ~= target then
					AMHC:Damage( caster,v,dmg*0.35,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ))
				end	
			end
		end
	end
end

function Extra_damage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = ability:GetSpecialValueFor("extra_damage")
	if not target:IsBuilding() and not target:IsHero() then
		if caster:IsRangedAttacker() then
			AMHC:Damage(caster, target, dmg/3, AMHC:DamageType("DAMAGE_TYPE_PHYSICAL"))
		else
			AMHC:Damage(caster, target, dmg, AMHC:DamageType("DAMAGE_TYPE_PHYSICAL"))
		end
	end
end

function dot(a,b)
	return (a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end