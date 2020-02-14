function Shock( keys )
    local caster = keys.caster
	local target = keys.caster
	local ability = keys.ability
	if not caster:FindAbilityByName("war_magic_gohome") then
		caster:AddAbility("war_magic_gohome"):SetLevel(1)
	end
	local skill = caster:FindAbilityByName("war_magic_gohome")
	skill:ApplyDataDrivenModifier(caster, caster, "modifier_wantgohome", {duration = 10})
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍即將發動召集戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍即將發動召集戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	target:AddNewModifier(target,ability,"modifier_gohomelua",{duration=8})
	target:FindModifierByName("modifier_gohomelua").caster = target
	Timers:CreateTimer(8, function()
		if target:HasModifier("modifier_wantgohome") then
			if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
				GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動召集戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			else
				GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動召集戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
			end
			target:SetTimeUntilRespawn(0)
			target:AddNewModifier(target,ability,"modifier_phased",{duration=0.1})
			Timers:CreateTimer(1, function()
				target:RemoveModifierByName("modifier_wantgohome")
				target:RemoveModifierByName("modifier_gohomelua")
			end)
		end
	end)
end