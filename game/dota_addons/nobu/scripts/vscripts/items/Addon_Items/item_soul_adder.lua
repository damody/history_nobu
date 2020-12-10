--御魂

function Shock( keys )
	local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    local targetTeam = target:GetTeamNumber()
    if target:GetTeamNumber() ~= caster:GetTeamNumber() then
        AMHC:Damage(caster,keys.target, 1,AMHC:DamageType( "DAMAGE_TYPE_PURE" ) )
        if target:IsMagicImmune() then
            -- ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder",{duration = 3})
        else
            ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder",{duration = 3})
        end
    elseif target == caster then
        if target:IsMagicImmune() then
            ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder",{duration = 3})
        else
            ability:ApplyDataDrivenModifier(caster,target,"modifier_soul_adder",{duration = 3})
        end
    else
        ability:RefundManaCost()
        ability:EndCooldown()
        return false
    end
    target:EmitSound("SleepBirth1")
end

function Shock_phase ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if target == caster then
        if caster:HasModifier("modifier_wantgohome") then
            caster:RemoveModifierByName("modifier_wantgohome")
            caster:RemoveModifierByName("modifier_gohomelua")
        end
        ability:ApplyDataDrivenModifier(caster,target,"modifier_cast_self",{duration = 1})
    end
    if target:GetTeamNumber() == caster:GetTeamNumber() and target ~= caster then
        caster:Stop()
    end
end

function over( keys )
    local caster = keys.caster
    local target = keys.target
    local attacker = keys.attacker
    local unit = keys.unit
    if target then
        target:RemoveModifierByName("modifier_soul_adderx")
    end
    if unit then
        unit:RemoveModifierByName("modifier_soul_adderx")
    end
    if attacker then
        attacker:RemoveModifierByName("modifier_soul_adderx")
    end
end

function sound( keys )
    local caster = keys.caster
    local unit = keys.unit
    local target = keys.target
    local tpoint = keys.target_points
    if tpoint then
        tpoint = tpoint[1]
    end
    if keys.time then
        Timers:CreateTimer(keys.time,function()
            if unit then
                unit:StopSound(keys.sound)
            end
            if target then
                target:StopSound(keys.sound)
            end
            if caster then
                caster:StopSound(keys.sound)
            end
            end)
    end
    if unit then
        unit:EmitSound(keys.sound)
    else
        caster:EmitSound(keys.sound)
    end
    if target then
       target:EmitSound(keys.sound) 
    end
    if keys.all then
        local allHeroes = HeroList:GetAllHeroes()
        for k, v in pairs( allHeroes ) do
            v:EmitSound(keys.sound) 
        end
    end
    if tpoint then
        local dummy = CreateUnitByName("npc_dummy_unit",tpoint,false,nil,nil,caster:GetTeamNumber())
        dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=3})
        dummy:SetOwner(caster)
        dummy:AddAbility("majia"):SetLevel(1)
        dummy:EmitSound(keys.sound)
    end
end

function Heal_target(keys)
    local caster = keys.caster
    local attacker = keys.attacker
    attacker:Heal(30, attacker)
    attacker:SetMana((attacker:GetMana() + 5))
end

function OnCreated( keys )
    local target = keys.target
    if target:IsHero() and IsValidEntity(target) then
        target.magical_resistance = target.magical_resistance - 20
    end

end

function OnDestroy( keys )
    local target = keys.target
    if target:IsHero() and IsValidEntity(target) then
        target.magical_resistance = target.magical_resistance + 20
    end
end