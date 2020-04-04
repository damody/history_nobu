
function Shock( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local flame = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/ta_focal_base_attack_explosion.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(flame,3,target:GetAbsOrigin()+Vector(0, 0, 100))
	Timers:CreateTimer(1, function ()
		ParticleManager:DestroyParticle(flame, false)
	end)
	AMHC:Damage( caster,target,500,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	caster:Heal(500,caster)
	local am = target:FindAllModifiers()
	for _,v in pairs(am) do
		if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil and v:GetDuration() > 0.5 then
			local ab = v:GetAbility()
			local abname = ab:GetName()
			local len = string.len(abname)
			local big_skill = false
			if len == 4 and string.sub(abname, 4, 4) == "T" then
				big_skill = true
			end
			if big_skill==false and (v:GetParent():GetTeamNumber() == target:GetTeamNumber()
				or v:GetCaster():GetTeamNumber() == target:GetTeamNumber()) then
				target:RemoveModifierByName(v:GetName())
			end
		end
	end
	ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
end
