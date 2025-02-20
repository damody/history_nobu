
function Shock( keys )
	local caster = keys.caster
	if not caster:IsIllusion() then
		local target = keys.target
		local ability = keys.ability
		local ran =  RandomInt(0, 100)
		if ability.IsTrigger == nil then
			ability.IsTrigger = false
		end
		if (caster.great_sword_of_tiger_count == nil) then
			caster.great_sword_of_tiger_count = 0
		end
		if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] then
			return
		end
		caster.great_sword_of_tiger_count = caster.great_sword_of_tiger_count + 1
		local trigger = 5
		if caster:GetBaseAttackRange() < 200 and caster.name ~= "B04" then
			trigger = 4
		end
		if (caster.great_sword_of_tiger_count >= 4) and not ability.IsTrigger then
			caster.great_sword_of_tiger_count = 0
			EmitSoundOnLocationWithCaster( keys.target:GetAbsOrigin(),"Hero_SkeletonKing.CriticalStrike", keys.target)
			if (not(target:IsBuilding())) then
				if (caster.great_sword_of_tiger == nil) then					
					if IsValidEntity(target) then
						ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration = 0.4})
					end
					if not target:IsMagicImmune() then
						AMHC:Damage(caster,target,200,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
					end
				end
			end
			
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


