function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	caster:SetAbsOrigin(target:GetAbsOrigin())
	caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
	Timers:CreateTimer(0.2, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"MassTeleportTarget",caster)
		local particle = ParticleManager:CreateParticle("particles/a04e/a04e_f.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin()+Vector(0, 0, 100))
		local particle2 = ParticleManager:CreateParticle("particles/a04e/a04e_f.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin()+Vector(0, 0, 100))
		Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(particle,false)
				ParticleManager:DestroyParticle(particle2,false)
			end)
		end)
end

function Shock0( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:GetUnitName() == "npc_dota_courier2" then
		caster:Stop()
		return 
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"MassTeleportTarget",caster)
	local count = 0
	Timers:CreateTimer(1, function()
		local particle = ParticleManager:CreateParticle("particles/a04e/a04e_f.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin()+Vector(0, 0, 100))
		local particle2 = ParticleManager:CreateParticle("particles/a04e/a04e_f.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin()+Vector(0, 0, 100))
		Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle,false)
					ParticleManager:DestroyParticle(particle2,false)
				end)
		count = count + 1
		if count < 3 then
			return 1
		end
	end)
end