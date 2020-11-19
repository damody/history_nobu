function OnAttackLanded( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local casterabs = caster:GetAbsOrigin()
    local targetabs = target:GetAbsOrigin()
    local angle = VectorToAngles(targetabs-casterabs).y
	local dx = math.cos(angle*(3.14/180))
	local dy = math.sin(angle*(3.14/180))
    local dir = Vector(dx,dy,0)
    if not target:IsBuilding() then

        if(caster.satsumaShot == nil) then
            caster.satsumaShot = true
        end

        if (caster.satsuma == nil) then
            caster.satsuma = 0
        end
        caster.satsuma = caster.satsuma + 1
        local trigger = 5
        if caster:GetBaseAttackRange() < 200 then
            trigger = 4
        end
        if caster.satsuma >= trigger then
            
            projectile_table = {
                Ability				= ability,
                EffectName			= "particles/a17w/a17w.vpcf",
                vSpawnOrigin		= casterabs+Vector(0,0,100),
                fDistance			= 1200,
                fStartRadius		= 100,
                fEndRadius			= 100,
                Source				= caster,
                bHasFrontalCone		= true,
                bReplaceExisting	= false,
                iUnitTargetTeam		= ability:GetAbilityTargetTeam(),
                iUnitTargetFlags	= ability:GetAbilityTargetFlags(),
                iUnitTargetType		= ability:GetAbilityTargetType(),
                fExpireTime			= GameRules:GetGameTime() + 5,
                bDeleteOnHit		= false,
                vVelocity			= 0,
                bProvidesVision		= false,
                iVisionRadius		= 0,
                iVisionTeamNumber	= caster:GetTeamNumber(),
            }
            projectile_table.vVelocity = dir*2000
            caster:EmitSound( "Hero_Sniper.Attack" )
            if caster.satsumaShot == true then
                caster.satsuma = 0
                ProjectileManager:CreateLinearProjectile(projectile_table)
                caster.satsumaShot = false
            end
            Timers:CreateTimer(1 , function ()
                caster.satsumaShot = true
            end)
            
        end
        ability:ApplyDataDrivenModifier(caster,target,"modifier_satsuma_gun_DH",{})
    end

end

function OnProjectileHit ( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = caster:GetAverageTrueAttackDamage(target)
    if not target:IsMagicImmune() then
        if caster:GetBaseAttackRange() < 200 then
            AMHC:Damage(caster,target,damage,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
            caster:PerformAttack(target,true,true,true,false,false,true,true)
        else
            caster:PerformAttack(target,true,true,true,false,false,true,true)
        end

    end
end

