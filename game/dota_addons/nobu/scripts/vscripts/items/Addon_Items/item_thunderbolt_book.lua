
function ShowEffect( keys )
	local caster = keys.caster
	local ability = keys.ability

	local flame = ParticleManager:CreateParticle("particles/a07t2/a07t2.vpcf", PATTACH_ABSORIGIN, caster)
	
	Timers:CreateTimer(0.5, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
end

function Shock1( keys )

	-- 開關型技能不能用
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" then return end
	if keys.event_ability:GetName() == "item_tpscroll" then return end
	if keys.event_ability:GetName() == "C07T2" then return end
	local caster = keys.caster
	local ability = keys.ability
	if (caster:GetMana() >= 45) then
		caster:SpendMana(45, ability)
		local SEARCH_RADIUS = 600
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                              SEARCH_RADIUS,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)

		--effect:傷害+暈眩
		for _,it in pairs(direUnits) do
			if (not(it:IsBuilding())) then
				local flame = ParticleManager:CreateParticle("particles/a07t2/a07t2.vpcf", PATTACH_ABSORIGIN, it)
				AMHC:Damage(caster,it, 100,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				Timers:CreateTimer(0.5, function ()
					ParticleManager:DestroyParticle(flame, false)
				end)
			end
		end
	end
end



function Shock2( keys )

	-- 開關型技能不能用
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" then return end
	if keys.event_ability:GetName() == "item_tpscroll" then return end
	if keys.event_ability:GetName() == "C07T2" then return end
	if keys.event_ability:GetName() == "" then return end
	if keys.event_ability:GetName() == "item_money" then return end
	local caster = keys.caster
	local ability = keys.ability
	if (caster:GetMana() >= 45) then
		caster:SpendMana(45, ability)
		local SEARCH_RADIUS = 600
		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                              SEARCH_RADIUS,
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)

		--effect:傷害+暈眩
		for _,it in pairs(direUnits) do
			if (not(it:IsBuilding())) then
				local pp = it:GetAbsOrigin()
				local particle = ParticleManager:CreateParticle("particles/b05e/b05e.vpcf", PATTACH_ABSORIGIN, it)
				-- Raise 1000 if you increase the camera height above 1000
				ParticleManager:SetParticleControl(particle, 0, Vector(pp.x,pp.y,1000 ))
				ParticleManager:SetParticleControl(particle, 1, Vector(pp.x,pp.y,pp.z + 10 ))
				ParticleManager:SetParticleControl(particle, 2, Vector(pp.x,pp.y,pp.z + 10 ))
				AMHC:Damage(caster,it, 100,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				
				local ran1 =  RandomInt(0, 100)
				local ran2 =  RandomInt(0, 100)
				local ran3 =  RandomInt(0, 100)

				if ran1 <= 75 then
					AMHC:Damage(caster,it, 50,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
				if ran2 <= 50 then
					AMHC:Damage(caster,it, 75,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
				if ran3 <= 25 then
					AMHC:Damage(caster,it, 175,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				end
			end
		end
	end
end

