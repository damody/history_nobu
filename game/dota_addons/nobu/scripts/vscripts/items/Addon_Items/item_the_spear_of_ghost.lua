function OnEquip( keys )
	local caster = keys.caster
end

function OnUnequip( keys )
	local caster = keys.caster
end

function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local skill = keys.ability
	local name = skill:GetAbilityName()
	local dmg_precentage = keys.dmg
	if name == "item_the_spear_of_ghost" then
		if not target:IsBuilding() then
			local ran =  RandomInt(0, 100)
			if (caster.spear_of_ghost == nil) then
				caster.spear_of_ghost = 0
			end
			caster.spear_of_ghost = caster.spear_of_ghost + 1
			local trigger = 3
			if caster:GetBaseAttackRange() < 200 and caster.name ~= "B04" then
				trigger = 3
				dmg_precentage = 5
			end
			if caster.spear_of_ghost >= trigger then
	
				caster.spear_of_ghost = 0
				EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
	
				local dmg = keys.target:GetMaxHealth() * dmg_precentage * 0.01
				if not target:IsHero() then
					if skill:GetName() == "item_the_scream_of_spiders"then 
						if dmg > 350 then
							dmg = 350
						end
					else
						if dmg > 220 then
							dmg = 220
						end
					end
				end
				if caster.orb then
					dmg = dmg * caster.orb
				end
				AMHC:Damage(caster,keys.target, dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				AMHC:CreateNumberEffect(keys.target,dmg,1,AMHC.MSG_DAMAGE,'blue')
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
	if name == "item_the_scream_of_spiders" then
		if not target:IsBuilding() then
			local ran =  RandomInt(0, 100)
			if (caster.scream_of_spiders == nil) then
				caster.scream_of_spiders = 0
			end
			caster.scream_of_spiders = caster.scream_of_spiders + 1
			local trigger = 4
			if caster:GetBaseAttackRange() < 200 then
				trigger = 3
			end
			if caster.scream_of_spiders >= trigger then
	
				caster.scream_of_spiders = 0
				EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
	
				local dmg = keys.target:GetMaxHealth() * keys.dmg * 0.01
				if not target:IsHero() then
					if skill:GetName() == "item_the_scream_of_spiders"then 
						if dmg > 350 then
							dmg = 350
						end
					else
						if dmg > 220 then
							dmg = 220
						end
					end
				end
				AMHC:Damage(caster,keys.target, dmg,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
				AMHC:CreateNumberEffect(keys.target,dmg,1,AMHC.MSG_DAMAGE,'blue')
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


function Shock2( keys )
	local caster = keys.caster
	local skill = keys.ability
	local target = keys.target
	
	if not target:IsBuilding() then
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
			local hp = target:GetMaxHealth()
			AMHC:Damage(caster,target,hp*0.01*keys.dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			AMHC:CreateNumberEffect(target,hp*0.01*keys.dmg,1,AMHC.MSG_DAMAGE,{255,100,100})
		end
	end
end

