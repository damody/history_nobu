function Shock (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = ability:GetSpecialValueFor("damage")
    AMHC:Damage(caster,target,400,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
    caster:PerformAttack(target,true,true,false,true,false,false,true)
end