
--鬼丸國剛

function Channeling( keys )
	local ability = keys.ability
	local caster = keys.caster
	ability.IsFinish = false
	ability.channel_timer = 0
	local count = 0
	
	local spell_hint_table = {
		duration   = 1,		-- 持續時間
		radius     = 600,-- 半徑
		show = true,
	}
	caster:AddNewModifier(caster,nil,"nobu_modifier_spell_hint_self",spell_hint_table)
	Timers:CreateTimer(1, function()
		if not caster:IsAlive() then
			return nil
		end
		Shock(keys)
		count = count + 1
		if count > 2 then
			return nil
		end
		Timers:CreateTimer(0.5, function()
			caster:AddNewModifier(caster,nil,"nobu_modifier_spell_hint_self",spell_hint_table)
			end)
		return 1.5
	end)
end

function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	Timers:CreateTimer(0, function()
		local point = caster:GetAbsOrigin()
		local pointx = point.x
		local pointy = point.y
		local pointz = point.z
		local pointx2
		local pointy2
		local maxrock = 6
		for radius=50,600,150 do
			maxrock = maxrock + 8
			local maxspike = maxrock
			Timers:CreateTimer(radius*0.0003, function() 
				for i=1,maxspike do
					a	=	(	(360.0/maxspike)	*	i	)* bj_DEGTORAD
					pointx2 	=  	pointx 	+ 	radius 	* 	math.cos(a)
					pointy2 	=  	pointy 	+ 	radius 	*	math.sin(a)
					point = Vector(pointx2 ,pointy2 , pointz)
					local spike = ParticleManager:CreateParticle("particles/item/item_the_great_sword_of_spike.vpcf", PATTACH_ABSORIGIN, keys.caster)
					ParticleManager:SetParticleControl(spike, 0, point)
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(spike,true)
					end)
				end
			end)
		end

		local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
								caster:GetAbsOrigin(),
								nil,
								600,
								DOTA_UNIT_TARGET_TEAM_ENEMY,
								DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_NONE,
								FIND_ANY_ORDER,
								false)
		--effect:傷害+暈眩
		for _,it in pairs(direUnits) do
			if not(it:IsBuilding()) and _G.EXCLUDE_TARGET_NAME[it:GetUnitName()] == nil then
				AMHC:Damage(caster, it, 50, AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
				if IsValidEntity(it) and not it:HasModifier("great_sword_of_spike") then
					Physics:Unit(it)
					keys.ability:ApplyDataDrivenModifier(caster,it,"modifier_stunned",{duration = 1})
					-- keys.ability:ApplyDataDrivenModifier(caster,it,"great_sword_of_spike",{duration = 2.7})
					-- keys.ability:ApplyDataDrivenModifier(caster,it,"modifier_invulnerable",{duration = 1})
					it:SetPhysicsVelocity(Vector(0,0,800))
				end
			end
		end
		Timers:CreateTimer(0.5, function()
			for _,it in pairs(direUnits) do
				if not(it:IsBuilding()) then
					if IsValidEntity(it) then
						it:SetPhysicsVelocity(Vector(0,0,-800))
					end
				end
			end
		end)
	end)
end


