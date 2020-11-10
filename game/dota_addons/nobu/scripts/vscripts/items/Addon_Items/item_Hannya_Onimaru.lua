
-- modifier_Hannya_Onimaru = class({})




-- function modifier_Hannya_Onimaru:DeclareFunctions()
--   local funcs = {
--   MODIFIER_EVENT_ON_UNIT_MOVED
--   }
--   return funcs
-- end

-- function modifier_Hannya_Onimaru:OnUnitMoved( params )
--   if IsServer() then
--     local caster = keys.caster
--     print("123")
--     print(caster.GetAbsOrigin())
--     return caster.GetAbsOrigin()
--   end
--   return 0
-- end


function Moved ( keys )
  local caster = keys.caster
  local ability = keys.ability
  local modifier = caster:FindModifierByName("modifier_Hannya_Onimaru")
  if enemy == nil then
    local enemy = {}
  end
  if caster:GetTeamNumber() == 2 then
    enemy = FindUnitsInRadius(
    DOTA_TEAM_GOODGUYS
    ,caster:GetAbsOrigin()
    ,nil
    ,700
    ,DOTA_UNIT_TARGET_TEAM_ENEMY
    ,DOTA_UNIT_TARGET_HERO 
    ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    ,0
  ,false)
 -- PrintTable(enemy)
  else
    enemy = FindUnitsInRadius(
    DOTA_TEAM_BADGUYS
    ,caster:GetAbsOrigin()
    ,nil
    ,700
    ,DOTA_UNIT_TARGET_TEAM_ENEMY
    ,DOTA_UNIT_TARGET_HERO 
    ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    ,0
    ,false)
    -- PrintTable(enemy)
  end

  for i,v in pairs(enemy) do
    local a = v:GetAbsOrigin() - caster:GetAbsOrigin() 
    a = a:Normalized()
    b = caster:GetForwardVector()
    local dot = a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
    local angle = math.acos(dot / (a:Length() * b:Length()))
    if math.deg(angle) < 90 then
      print("find enemy") 
      if modifier == nil then
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_Hannya_Onimaru",{})
        modifier = caster:FindModifierByName("modifier_Hannya_Onimaru")
        modifier:SetStackCount(1)
        caster.Hannya_Onimaru = 1
      end
    else
      print("not find")
    end
  end
end

function speedup (keys)
  local caster = keys.caster
  local ability = keys.ability
  local modifier = caster:FindModifierByName("modifier_Hannya_Onimaru")
  local count = modifier:GetStackCount()

  if enemy == nil then
    local enemy = {}
  end
  if caster:GetTeamNumber() == 2 then
    enemy = FindUnitsInRadius(
    DOTA_TEAM_GOODGUYS
    ,caster:GetAbsOrigin()
    ,nil
    ,700
    ,DOTA_UNIT_TARGET_TEAM_ENEMY
    ,DOTA_UNIT_TARGET_HERO 
    ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    ,0
  ,false)
  else
    enemy = FindUnitsInRadius(
    DOTA_TEAM_BADGUYS
    ,caster:GetAbsOrigin()
    ,nil
    ,700
    ,DOTA_UNIT_TARGET_TEAM_ENEMY
    ,DOTA_UNIT_TARGET_HERO 
    ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    ,0
    ,false)
  end

  local leng = #enemy
  if leng < 1 then
    caster.Hannya_Onimaru = nil
  end

  for i,v in pairs(enemy) do
    local a = v:GetAbsOrigin() - caster:GetAbsOrigin() 
    a = a:Normalized()
    b = caster:GetForwardVector()
    local dot = a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
    local angle = math.acos(dot / (a:Length() * b:Length()))
    if math.deg(angle) > 90 then
      modifier:SetStackCount(0)
      caster.Hannya_Onimaru = nil
    else
      caster.SPDUP = 1
      if not caster.Hannya_Onimaru then
      modifier:SetStackCount(1)
      caster.Hannya_Onimaru = 1
    end
    end
  end

  if caster.Hannya_Onimaru then
    if caster.Hannya_Onimaru < 4 then
      if count < 4 then
        count = count +1
      end
      modifier:SetStackCount(count)
      caster.Hannya_Onimaru = count 
      ability:ApplyDataDrivenModifier(caster,caster,"modifier_Hannya_Onimaru",{})
    end
    if caster.Hannya_Onimaru == 4 then
      modifier:SetStackCount(count)
      caster.Hannya_Onimaru = count 
      ability:ApplyDataDrivenModifier(caster,caster,"modifier_Hannya_Onimaru",{})
    end
  else
    modifier:SetStackCount(0)
  end
end