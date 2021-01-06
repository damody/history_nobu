
function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if caster:GetBaseAttackRange() < 200 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_dragonfly", {} )
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	caster:RemoveModifierByName("modifier_dragonfly")
end

function Shock( keys )
	local caster = keys.caster
	local dmg = 150
	if not caster:IsIllusion() then
		local target = keys.target
		local skill = keys.ability
		local ran =  RandomInt(0, 100)
		if (caster.great_spear_of_dragonfly_count == nil) then
			caster.great_spear_of_dragonfly_count = 0
		end
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] then
			return
		end
		caster.great_spear_of_dragonfly_count = caster.great_spear_of_dragonfly_count + 1
		local trigger = 4
		if caster:GetBaseAttackRange() < 200 and caster.name ~= "B04" then
			trigger = 3
		end
		if (caster.great_spear_of_dragonfly_count >= trigger) then
			caster.great_spear_of_dragonfly_count = 0
			if (caster.great_spear_of_dragonfly == nil) then
				caster.great_spear_of_dragonfly = 1
				Timers:CreateTimer(0.1, function() 
						caster.great_spear_of_dragonfly = nil
					end)
				EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
				local direUnits = FindUnitsInRadius(caster:GetTeamNumber(),
		                              target:GetAbsOrigin(),
		                              nil,
		                              250,
		                              DOTA_UNIT_TARGET_TEAM_ENEMY,
		                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		                              DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		                              FIND_ANY_ORDER,
		                              false)

				--effect:傷害+暈眩
				if caster.orb then
					dmg = dmg * caster.orb 
				end
				for _,it in pairs(direUnits) do
					if (not(it:IsBuilding())) then
						local flame = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_flames.vpcf", PATTACH_OVERHEAD_FOLLOW, it)
						Timers:CreateTimer(0.3, function ()
							ParticleManager:DestroyParticle(flame, false)
						end)
						AMHC:Damage(caster,it,dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
					end
				end
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
end


