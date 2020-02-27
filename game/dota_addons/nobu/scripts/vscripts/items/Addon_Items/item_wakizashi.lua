function Shock (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = ability:GetSpecialValueFor("damage")
    AMHC:Damage(caster.donkey,target,damage,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
    caster:PerformAttack(target,true,true,false,true,false,false,true)
end