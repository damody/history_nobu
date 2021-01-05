function Sukezans_AttackLanded ( keys )
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    if not caster:IsBuilding() then
        ability:ApplyDataDrivenModifier(caster,target,"modifier_Sukezane",nil)
    end
end

function Sukezans_Damage ( keys )
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local int = caster:GetIntellect()
    if not target:IsBuilding() then
        AMHC:Damage(caster,target,int,AMHC:DamageType("DAMAGE_TYPE_MAGICAL"))
        AMHC:CreateNumberEffect(target,int,2,AMHC.MSG_POISION,{90,0,173},5)
    end
end