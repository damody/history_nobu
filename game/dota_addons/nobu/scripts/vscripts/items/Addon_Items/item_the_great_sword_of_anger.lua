-- 鬼徹
function Shock( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	

	local chaos_effect = ParticleManager:CreateParticle("particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare_explosion.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(chaos_effect, 3, point)
	Timers:CreateTimer(0.1, function ()
		chaos_effect = ParticleManager:CreateParticle("particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare_explosion.vpcf", PATTACH_ABSORIGIN, keys.caster)
		ParticleManager:SetParticleControl(chaos_effect, 3, point)
	end)

	Timers:CreateTimer(0.2, function ()
		chaos_effect = ParticleManager:CreateParticle("particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare_explosion.vpcf", PATTACH_ABSORIGIN, keys.caster)
		ParticleManager:SetParticleControl(chaos_effect, 3, point)
	end)

	local SEARCH_RADIUS = 350
	GridNav:DestroyTreesAroundPoint(point, SEARCH_RADIUS, false)
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              point,
	                              nil,
	                              SEARCH_RADIUS,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                              FIND_ANY_ORDER,
	                              false)

	--effect:傷害+暈眩
	for _,it in pairs(direUnits) do
		if (not(it:IsBuilding())) then
			AMHC:Damage(caster,it, 800,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			ability:ApplyDataDrivenModifier(caster, it,"modifier_great_sword_of_anger",nil)
		end
	end
end


