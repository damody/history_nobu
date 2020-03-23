
function Shock( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
end

function OnAttackLanded( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = keys.dmg
	if not target:IsHero() and not target:IsBuilding() then
		if caster:GetBaseAttackRange() < 200 then
			AMHC:Damage( caster,target,60,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ))
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
		else
			AMHC:Damage( caster,target,20,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ))
		end
	end
end

function dot(a,b)
	return (a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end