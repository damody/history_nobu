LinkLuaModifier( "modifier_unit_armor", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_armor", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_debuff", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_soul", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_B13D", "heroes/modifier_B13D.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_pickup_health_thinker", "scripts/vscripts/library/common/dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_pickup_health_buff", "scripts/vscripts/library/common/dummy.lua", LUA_MODIFIER_MOTION_NONE)
modifier_soul = class({})



--------------------------------------------------------------------------------

modifier_force_draw_minimap = class({})

function modifier_force_draw_minimap:IsHidden()
	return false
end

function modifier_force_draw_minimap:CanParentBeAutoAttacked()
	return false
end

function modifier_force_draw_minimap:IsPurgable()
	return false
end

function modifier_force_draw_minimap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP,
	}
	return funcs
end

function modifier_force_draw_minimap:GetForceDrawOnMinimap( params )
	return 0
end

--------------------------------------------------------------------------------

function modifier_soul:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_soul:OnCreated( event )
  self:StartIntervalThink(0.2)
end

function modifier_soul:OnIntervalThink()
  if (self.caster ~= nil) and IsValidEntity(self.caster) then
    self.hp = self.caster:GetHealth()
  end
end

function modifier_soul:OnTakeDamage(event)
  if IsServer() then
    local attacker = event.unit
    local victim = event.attacker
    local caster = self.caster
    local return_damage = event.original_damage
    local damage_type = event.damage_type
    local damage_flags = event.damage_flags
    local ability = self:GetAbility()

    if (caster ~= nil) and IsValidEntity(caster) then
      if attacker == self.caster then
        if damage_type == DAMAGE_TYPE_PURE and caster:GetHealth() < 15000 then
          caster:Heal(event.damage, caster)
        end
        if damage_type == DAMAGE_TYPE_PHYSICAL and caster:GetHealth() < 5000 then
          if caster.big == nil then
            caster.big = 1
            EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"berserkercaster",caster)
            Timers:CreateTimer(30, function()
              caster.big = nil
            end)
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, 
              DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            for _,it in pairs(enemies) do
              ability:ApplyDataDrivenModifier(caster,it,"modifier_stunned",{duration = 3})
              if it:IsIllusion() then 
                it:ForceKill(true)
              end
            end
          end
          caster:Heal(event.damage, caster)
        end
      end
    end
  end
end


function top_broken( keys )
  local caster = keys.caster
  local team = caster:GetTeamNumber()
  _G.team_broken[team]["top"] = _G.team_broken[team]["top"] + 1
  if team == 2 then
    if _G.team_broken[team]["top"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍上路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["top"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍60秒後於上路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return 0 end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,3,6)
        ShuaGuai_Of_AB(3,3,6)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return 0 end
        counter = counter + 1 
        ShuaGuai_Of_B(1,3,6)
        ShuaGuai_Of_C(2,3,6)
        return 60
      end)
      local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
      for k, ent in pairs(allBuildings) do
        if string.match(ent:GetUnitName(),"com_general_oda") then
          ent:RemoveModifierByName("modifier_intensify")
        end
      end
    end
  elseif team == 3 then
    if _G.team_broken[team]["top"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍上路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["top"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍60秒後於上路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return 0 end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,2,3)
        ShuaGuai_Of_AB(3,2,3)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return 0 end
        counter = counter + 1 
        ShuaGuai_Of_B(1,2,3)
        ShuaGuai_Of_C(2,2,3)
        return 60
      end)
    end
    local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
    for k, ent in pairs(allBuildings) do
      if string.match(ent:GetUnitName(),"com_general_unified") then
        ent:RemoveModifierByName("modifier_intensify")
      end
    end
  end
end

function mid_broken( keys )
  local caster = keys.caster
  local team = caster:GetTeamNumber()
  _G.team_broken[team]["mid"] = _G.team_broken[team]["mid"] + 1
  if team == 2 then
    if _G.team_broken[team]["mid"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍中路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["mid"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍60秒後於中路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,3,5)
        ShuaGuai_Of_AB(3,3,5)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_B(1,3,5)
        ShuaGuai_Of_C(2,3,5)
        return 60
      end)
      local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
      for k, ent in pairs(allBuildings) do
        if string.match(ent:GetUnitName(),"com_general_oda") then
          ent:RemoveModifierByName("modifier_intensify")
        end
      end
    end
  elseif team == 3 then
    if _G.team_broken[team]["mid"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍中路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["mid"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍60秒後於中路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,2,2)
        ShuaGuai_Of_AB(3,2,2)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_B(1,2,2)
        ShuaGuai_Of_C(2,2,2)
        return 60
      end)
      local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
      for k, ent in pairs(allBuildings) do
        if string.match(ent:GetUnitName(),"com_general_unified") then
          ent:RemoveModifierByName("modifier_intensify")
        end
      end
    end
  end
end

function down_broken( keys )
  local caster = keys.caster
  local team = caster:GetTeamNumber()
  _G.team_broken[team]["down"] = _G.team_broken[team]["down"] + 1
  if team == 2 then
    if _G.team_broken[team]["down"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍下路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["down"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">聯合軍60秒後於下路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,3,4)
        ShuaGuai_Of_AB(3,3,4)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_B(1,3,4)
        ShuaGuai_Of_C(2,3,4)
        return 60
      end)
      local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
      for k, ent in pairs(allBuildings) do
        if string.match(ent:GetUnitName(),"com_general_oda") then
          ent:RemoveModifierByName("modifier_intensify")
        end
      end
    end
  elseif team == 3 then
    if _G.team_broken[team]["down"] == 1 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍下路士兵士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    elseif _G.team_broken[team]["down"] == 2 then
      GameRules: SendCustomMessage("<font color=\"#33cc33\">織田軍60秒後於下路集結兵力</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
      local counter = 0
      Timers:CreateTimer(60,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_AA(3,2,1)
        ShuaGuai_Of_AB(3,2,1)
        return 60
      end)
      Timers:CreateTimer(75,function() 
        if counter == 4 then return nil end
        counter = counter + 1 
        ShuaGuai_Of_B(1,2,1)
        ShuaGuai_Of_C(2,2,1)
        return 60
      end)
      local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
      for k, ent in pairs(allBuildings) do
        if string.match(ent:GetUnitName(),"com_general_unified") then
          ent:RemoveModifierByName("modifier_intensify")
        end
      end
    end
  end
end

function nodmg_courier( keys )
  local caster = keys.caster
  local ability = keys.ability
  --print(dummy:GetUnitName())

  local units = FindUnitsInRadius(caster:GetTeamNumber(),  
        caster:GetAbsOrigin(),nil,1400,DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
          DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
          FIND_ANY_ORDER, 
        false)
  for _,it in pairs(units) do
    if it:GetUnitName() == "npc_dota_courier2" or it:GetUnitName() == "npc_dota_courier2" then
      --it:AddNewModifier(it, nil, "modifier_invulnerable", {duration = 5})
    end
  end
end

function for_move300( keys )
  local caster = keys.caster
  local ability = keys.ability
  --print(dummy:GetUnitName())

  local units = FindUnitsInRadius(caster:GetTeamNumber(),  
        caster:GetAbsOrigin(),nil,1400,DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
          DOTA_UNIT_TARGET_HERO,
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
          FIND_ANY_ORDER, 
        false)
  for _,it in pairs(units) do
    ability:ApplyDataDrivenModifier( caster , it , "modifier_for_move300" , { duration = 6 } )
  end
end

function killdummy( keys )
	local dummy = keys.target
	--print(dummy:GetUnitName())
	if dummy ~= nil then
    if IsValidEntity(dummy) then
		  dummy:ForceKill(true)
    end
	end
end

_G.EXCLUDE_TARGET_NAME2 = {
  com_general_oda = true,
  com_general_unified = true,
}
_G.EXCLUDE_TARGET_NAME = {
  --npc_dota_cursed_warrior_souls = true,
  npc_dota_the_king_of_robbers  = true,
  npc_dota_cursed_warrior_souls = true,
  com_general = true,
  com_general2 = true,
  com_general3 = true,
  EARTH_WALL = true,
  com_soldiercamp_Unified = true,
  com_soldiercamp_Oda = true,
  com_general_Unified2 = true,
  com_general_Nobu2 = true,
  com_general_Unified2_1 = true,
  com_general_Nobu2_1 = true,
  com_general_oda = true,
  com_general_unified = true,
  com_general2_oda = true,
  com_general2_unified = true,
  com_general3_oda = true,
  com_general3_unified = true,
  com_general2_unified = true,
  C17R_old_SUMMEND_UNIT_bag_hero = true,
  C17R_old_SUMMEND_UNIT_hero = true,
  B13_MINE_hero = true,
  A26_MINE_hero = true,
  A26_MINE_school_hero = true,
  B17W_deathGuard_hero = true,
  npc_dummy_unit = true,
  npc_dummy_unit_Ver2 = true,
  Dummy_Ver1 = true,
  Dummy_B34E = true,
  B24T_HIDE_hero = true,
  EARTH_WALL_hero = true,
  B33T_UNIT = true,
  B24W_dummy_hero = true,
  C03T_UNIT = true,
  npc_dummy_unit_new = true,
  npc_dummy = true,
  npc_dummy = true,
  hide_unit = true,
  ninja_unit1 = true,
  ninja_unit2 = true,
  a21_weapon = true,
}

_G.EXCLUDE_MODIFIER_NAME = {
  modifier_C04T = true,
  modifier_C04T2 = true,
  modifier_A11E = true,
  modifier_A11E2 = true,
  modifier_C07E = true,
  modifier_C07E2 = true,
  modifier_B28E = true,
  modifier_B28E2 = true,
  modifier_voodoo_lua = true,
  modifier_B36R = true,
  modifier_A28W = true,
  modifier_A09E = true,
  modifier_weakness = true,
  modifier_C08T_bleeding = true,
  modifier_soul_adder = true,
}


function CP_Posistion( keys )
  local caster = keys.caster
  caster.origin_pos = caster:GetAbsOrigin()
  caster:AddNewModifier(caster, ability, "modifier_unit_armor", nil)
	caster:FindModifierByName("modifier_unit_armor").creep = caster
	--donkey:AddAbility("majia_cp"):SetLevel(1)
end

function showTitle( keys )
  local caster = keys.caster
  local pos = caster:GetAbsOrigin()
  keys.title = ""
  if keys.target_points then
    pos = keys.target_points[1]
  end
  if keys.target and keys.target ~= caster then
    pos = keys.target:GetAbsOrigin()
  end
  
  if keys.dummy then
    local dummy = CreateUnitByName("npc_dummy_unit",caster:GetAbsOrigin() ,false,caster,caster,caster:GetTeam())
    dummy:FindAbilityByName("majia"):SetLevel(1)
    dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=5})
    local spike = ParticleManager:CreateParticle(keys.title, PATTACH_ABSORIGIN, dummy)
    ParticleManager:SetParticleControl(spike, 0, pos+Vector(0,0,300))
  else
    local spike = ParticleManager:CreateParticle(keys.title, PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(spike, 0, pos+Vector(0,0,300))
  end
end

function removeAbility( keys )
  local caster = keys.caster
  caster:RemoveAbility(keys.title)
end

local ok_modifier = {
  ["modifier_great_sword_of_hurricane_debuff"] = true,
  ["modifier_debuff_x"] = true,
  ["modifier_A17T"] = true,
  ["modifier_magical_1300_aura"] = true,
  ["modifier_tower_truesight_aura"] = true,
  ["modifier_tower_aura"] = true,
  ["modifier_tower_armor_bonus"] = true,
  ["modifier_great_sword_of_hurricane_debuff"] = true,
  ["modifier_1300"] = true,
  ["Passive_warrior_souls_skill"] = true,
  ["modifier_dead_give_item1"] = true,
  ["modifier_dead_give_item2"] = true,
  ["modifier_invulnerable_souls"] = true,
  ["modifier_soul"] = true,
  ["modifier_magic_immune"] = true,
  ["modifier_stunned"] = true,
  ["modifier_for_magic_immune"] = true,
}

--function debuff_tower1( keys )
--  local caster = keys.caster
--  local ability = keys.ability
--  local am = caster:FindAllModifiers()
--  for _,v in pairs(am) do
--    if ok_modifier[v:GetName()] == nil then
--      caster:RemoveModifierByName(v:GetName())
--    end
--  end
--end

--function debuff_tower2( keys )
--  local caster = keys.caster
--  local ability = keys.ability
--  local am = caster:FindAllModifiers()
--  for _,v in pairs(am) do
--    if ok_modifier[v:GetName()] == nil then
--      caster:RemoveModifierByName(v:GetName())
--    end
--  end
--  caster:AddNewModifier(caster,ability,"modifier_soul",{})
--  local handle = caster:FindModifierByName("modifier_soul")
--  if handle then
--    handle.caster = caster
--  end
--end

--function debuff_tower( keys )
--  local caster = keys.caster
--  local ability = keys.ability
--  local team = caster:GetTeamNumber()
--  local heros = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, 
--          DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
--          0, FIND_ANY_ORDER, false )
--  local count = 0
-- for i,v in pairs(heros) do
--    if not v:IsIllusion() then
--      count = count + 1
--    end
--  end
--  if count > 2 then
--    ability:ApplyDataDrivenModifier(caster,caster,"debuff_tower",{duration = 2})
--    local handle = caster:FindModifierByName("debuff_tower")
--    if handle then
--      handle:SetStackCount(count)
--    end
--  end
--end

local ok_unit = {
  ["B16D_SUMMEND_UNIT"] = true,
  ["B16W_old_SUMMEND_UNIT"] = true,
  ["A04W_SUMMEND_UNIT"] = true,
  ["B07W_old"] = true,
  ["A03T_old"] = true,
  ["A03W_old"] = true,
  ["B23D_ghost"] = true,
}

function debuff_tower( keys )
  local caster = keys.caster
  local ability = keys.ability
  local team = caster:GetTeamNumber()
  local enemys = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, 
          DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
  local enemyCounter = 0
  local heroCounter = 0
  for i,v in pairs(enemys) do
    if not ok_unit[v:GetUnitName()] and not v:IsIllusion() and not v:GetOwner() then
      enemyCounter = enemyCounter + 1
    end
    if v:IsHero() then
      heroCounter = heroCounter + 1
    end
  end
  if enemyCounter > 3 and heroCounter > 0 then
    caster:AddNewModifier(caster, ability, "modifier_tower_debuff", nil)
    -- ability:ApplyDataDrivenModifier(caster, caster, "debuff_tower", {duration = 2})
  else
    caster:RemoveModifierByName("modifier_tower_debuff")
    -- caster:RemoveModifierByName("debuff_tower")
  end
end

function CP_recover( keys )
  local caster = keys.caster
  local ability = keys.ability
  local attacker = keys.attacker
  local recover = ability:GetSpecialValueFor("recover")
  local heal = recover * (1 + attacker:GetHealth()/attacker:GetMaxHealth())
  attacker:SetHealth(attacker:GetHealth() + heal)
end

--modifier_unit_armor
--------------------------------------------
modifier_unit_armor = class{}
function modifier_unit_armor:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }
  return funcs
end

function modifier_unit_armor:GetModifierIncomingDamage_Percentage( keys )
  if string.match(keys.attacker:GetName(), "npc_dota_creep_lane") then 
    return 30
  elseif string.match(keys.attacker:GetUnitName(), "com_general") then
    return 50
  elseif keys.attacker:IsBuilding() then
    if self.creep then
      if keys.attacker:GetUnitName() == "B24W_dummy_hero" then
        return 0
      end
      return -100
    else
      return -75
    end
  end
	return 0
end
--------------------------------------------


function Unit_armor( keys )

end

--modifier_tower_debuff
--------------------------------------------
modifier_tower_debuff = class{}

function modifier_tower_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }
  return funcs
end

function modifier_tower_debuff:GetModifierIncomingDamage_Percentage( keys )
  if keys.attacker:IsHero() then 
    return 40
  else
    return 0
  end
end
--------------------------------------------

--modifier_tower_armor
--------------------------------------------
modifier_tower_armor = class{}
function modifier_tower_armor:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }
  return funcs
end

function modifier_tower_armor:GetModifierIncomingDamage_Percentage( keys )

  if keys.attacker.abilityName == "A19T" then
    local a = keys.attacker:GetAbsOrigin()
    local b = keys.target:GetAbsOrigin()
    local dir = (a-b):Length2D()
    if dir >= 2500 then
      return -50
    else
      if keys.attacker:IsAlive() then
        return 0
      else
        return -50
      end
    end
  end

  if keys.attacker:IsHero() then 
    return 0
  elseif keys.attacker:IsBuilding() then
    return 0
  elseif keys.attacker:GetUnitName() == "B19T_old" then
    return -85
  elseif keys.attacker:GetName() == "npc_dota_creature" then
    return -50
  else
    return -60
  end
  if keys.attacker.name ~= nil then
    return 0
  end
end
--------------------------------------------

function Tower_armor( keys )

end

function Tower_attack( keys )
  local caster = keys.caster
  local target = keys.target
  if caster.max_damage_tmp == nil then
    caster.max_damage_tmp = caster:GetBaseDamageMax()
  end
  if caster.min_damage_tmp == nil then
    caster.min_damage_tmp = caster:GetBaseDamageMin()
  end
  if caster.max_damage_tmp < caster:GetBaseDamageMax() then
    caster.max_damage_tmp = caster:GetBaseDamageMax()
  end
  if caster.min_damage_tmp < caster:GetBaseDamageMax() then
    caster.min_damage_tmp = caster:GetBaseDamageMin()
  end
  if caster.max_damage_tmp > caster:GetBaseDamageMax() then
    caster:SetBaseDamageMax(caster.max_damage_tmp)
  end
  if caster.min_damage_tmp > caster:GetBaseDamageMax() then
    caster:SetBaseDamageMin(caster.min_damage_tmp)
  end
  if target:IsHero() then
  elseif target:IsBuilding() and not caster:IsBuilding() then
    caster:SetBaseDamageMax(caster.max_damage_tmp * 0.25)
    caster:SetBaseDamageMin(caster.min_damage_tmp * 0.25)
  elseif caster:IsBuilding() then
    caster:SetBaseDamageMax(caster.max_damage_tmp * 0.25)
    caster:SetBaseDamageMin(caster.min_damage_tmp * 0.25)
  end
end

function Tower_attack_landed( keys )
  local caster = keys.caster
  if caster.max_damage_tmp == nil then
    caster.max_damage_tmp = caster:GetBaseDamageMax()
  end
  if caster.min_damage_tmp == nil then
    caster.min_damage_tmp = caster:GetBaseDamageMin()
  end
  caster:SetBaseDamageMax(caster.max_damage_tmp)
  caster:SetBaseDamageMin(caster.min_damage_tmp)
end

function magical_resistance( keys )
  local caster = keys.caster
  if caster.magical_resistance == nil then
    caster.magical_resistance = 30
  end
  if caster.magical_resistance > 70 then
    caster:SetBaseMagicalResistanceValue(70)
  else
    caster:SetBaseMagicalResistanceValue(caster.magical_resistance)
  end
end

function hoarding_money( keys )
  local caster = keys.caster
  local ability = keys.ability
  if caster:GetGold() >= 3000 then
    ability:ApplyDataDrivenModifier(caster,caster,"modifier_richman",{duration = 3.5})
  end
end

function rich_man_OnCreated( keys )
  local caster = keys.caster
  local pos = caster:GetAbsOrigin()
  local particle_name = "particles/rich_man/richman.vpcf"
  caster.rich_man_effect = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControl(caster.rich_man_effect , 0, pos + Vector(0,0,200))
end

function rich_man_OnDestroy( keys )
  ParticleManager:DestroyParticle(keys.caster.rich_man_effect,true)
end

function passive_b01w_unit( keys )
  local caster = keys.caster
  local ability = keys.ability
  local teammate = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
  local find = 0
  for i,v in pairs(teammate) do
     if v.name and v.name == "B01" then
      find = 1
      break
     end
  end
  if find ~= 1 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_b01w_unit_weak", {duration = 0.15})
  end
end

function def_home( keys )
  local caster = keys.caster
  local ability = keys.ability
  local teammate = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
  for i,v in pairs(teammate) do
    ability:ApplyDataDrivenModifier(caster,v,"modifier_speed_up",{})
  end
end

function home_aura ( keys )
  local caster = keys.caster
  local ability = keys.ability
  local teammate = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
  local findCourier = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  for i,v in pairs(teammate) do
    ability:ApplyDataDrivenModifier(caster,v,"modifier_home_aura",{})
  end
  for i,v in pairs(findCourier) do 
    if v:GetUnitName() == "npc_dota_courier2" then
      ability:ApplyDataDrivenModifier(v, v, "modifier_phased",{duration = 0.5})
    end
  end
end

function remove_def_home( keys )
  local unit = keys.unit or keys.attacker
  if unit:HasModifier("modifier_speed_up") then
    unit:RemoveModifierByName("modifier_speed_up")
  end
end

function hero_attack_tower( keys )
  local caster = keys.caster
  local target = keys.target
  if caster.attack_tower == nil then
    caster.attack_tower = 1
  end
  -- 力量 0 敏捷1 智力2
  -- if caster:GetPrimaryAttribute() == 2 then
  --   local intellect = caster:GetIntellect()
  --   if target:IsBuilding() then
  --     if caster.attack_tower == 1 then
  --       AMHC:Damage(caster,target,intellect,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ))
  --       caster.attack_tower = 0
  --       Timers:CreateTimer(5,function()
  --         caster.attack_tower = 1 
  --       end)
  --     end
  --   end
	-- end
end

function OnUnitDied( keys )
  local caster = keys.caster
  local group = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
  for i,v in pairs(group) do
    if v:HasModifier("Passive_soul_adder") then
      v:Heal(20,v)
    end
  end
end

function courier_damage_immune_OnCreated( keys )
  local target = keys.target
  local ability = keys.ability
  if target:GetUnitName() == "npc_dota_courier2" then
    ability:ApplyDataDrivenModifier(target,target,"modifier_courier_physical_immune2",{})
  end
end

function courier_damage_immune_OnDestroy( keys )
  local target = keys.target
  local ability = keys.ability
  if target:GetUnitName() == "npc_dota_courier2" then
    target:RemoveModifierByName("modifier_courier_physical_immune2")
  end
end

function Slow ( keys )
  local caster = keys.caster
  local target = keys.target
  local unslow = 0
  if keys.ms_slow == nil then
    keys.ms_slow = 0
  end
  if keys.as_slow == nil then
    keys.as_slow = 0 
  end

  for k,v in pairs(target.ms_unslow) do
    if v > unslow then
      unslow = v
    end
  end

  if caster.illusion_damage ~= nil then
    if target.ms_unslow then
      target.ms_slow[keys.name] = keys.ms_slow  * (1 - unslow/100) * caster.illusion_damage
      if target:FindModifierByName("modifier_C14T") == nil then
        target.as_slow[keys.name] = keys.as_slow  * (1 - unslow/100) * caster.illusion_damage
      end
    else
      target.ms_slow[keys.name] = keys.ms_slow * caster.illusion_damage
      if target:FindModifierByName("modifier_C14T") == nil then
        target.as_slow[keys.name] = keys.as_slow * caster.illusion_damage
      end
    end
  else
    if target.ms_unslow ~= nil then
      target.ms_slow[keys.name] = keys.ms_slow * (1 - unslow/100)
      if target:FindModifierByName("modifier_C14T") == nil then
        target.as_slow[keys.name] = keys.as_slow * (1 - unslow/100)
      end
    else
      target.ms_slow[keys.name] = keys.ms_slow 
      if target:FindModifierByName("modifier_C14T") == nil then
        target.as_slow[keys.name] = keys.as_slow 
      end
    end
  end
end

function ReturnSpeed ( keys )
  local target = keys.target
  target.ms_slow[keys.name] = nil
  target.as_slow[keys.name] = nil
end

function slow_self_passive( keys )
  local caster = keys.caster
  local ability = keys.ability
  -- slow movespeed
  local sum_ms_slow = 0
  if not caster.ms_slow then
    hSpawnedUnit.ms_slow = {}
  end
  if caster.ms_slow then
    for k,v in pairs(caster.ms_slow) do
      v = v * -1
      if sum_ms_slow == 0 then
        sum_ms_slow = 100 * (v/100)
      else
        sum_ms_slow = sum_ms_slow + ((100 - sum_ms_slow) * (v/100))
      end
    end
  end
  if sum_ms_slow > 0 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_slow_down_movespeed", {duration = 0.15}):SetStackCount(sum_ms_slow)
  end
  -- slow attackspeed
  local sum_as_slow = 0
  if not caster.as_slow then
    hSpawnedUnit.as_slow = {}
  end
  if caster.as_slow then
      for k,v in pairs(caster.as_slow) do
          if v < sum_as_slow then
              sum_as_slow = v
          end
      end
  end
  if sum_as_slow < 0 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_slow_down_attackspeed", {duration = 0.15}):SetStackCount(sum_as_slow*-1)
  end
end

function health_regen_passive ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if not caster.HealthRegen then
    hSpawnedUnit.HealthRegen = 0
  end
  if caster.HealthRegen then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_healthregen",{duration = 0.15}):SetStackCount(caster.HealthRegen/0.1)
  end
end

function attack_animationrate_passive ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if caster:GetBaseAttackRange() < 200 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_attack_animationrate" , {duration = 0.15})
  end
end

function mana_regen_passive ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if not caster.ManaRegen then
    hSpawnedUnit.ManaRegen = 0
  end
  if caster.ManaRegen then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_manaregen",{duration = 0.15}):SetStackCount(caster.ManaRegen/0.01)
  end
end

function aspd_passive ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if not caster.Aspd then
    hSpawnedUnit.Aspd = 0
  end
  if caster.Aspd then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_aspd",{duration = 0.15}):SetStackCount(caster.Aspd/0.1)
  end
end


function preRegist ( keys )
  local target = keys.target
  local caster = keys.caster
  local targetVector = target:GetAbsOrigin()
  local casterVector = caster:GetAbsOrigin()
  local forward =  targetVector - casterVector
  forward = forward:Normalized()
  local ifx = ParticleManager:CreateParticle("particles/preregist/phantom_assassin_crit_impact.vpcf",PATTACH_POINT,target)
  ParticleManager:SetParticleControlForward(ifx,0,forward)
  ParticleManager:SetParticleControl(ifx,1,target:GetAbsOrigin())
  ParticleManager:SetParticleControlForward(ifx,1,forward)
  ParticleManager:ReleaseParticleIndex(ifx)
end

function preRegistKill ( keys )
  local target = keys.unit
  local caster = keys.caster
  local targetVector = target:GetAbsOrigin()
  local ifx = ParticleManager:CreateParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_arcana.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)
  -- local ifx = ParticleManager:CreateParticle("particles/a25e4/a25e4_c0.vpcf",PATTACH_POINT,target)
  -- local ifx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_pentagon_jewel.vpcf",PATTACH_POINT,target)
  ParticleManager:ReleaseParticleIndex(ifx)
end


function phased_dummy( keys )
	local caster = keys.caster
	local ability = keys.ability
	local aura_radius = 50
	local point = caster:GetAbsOrigin()
	local group = FindUnitsInRadius(
    caster:GetTeamNumber(),
    point,
    nil,
    aura_radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    0,
    false)
  for i,v in ipairs(group) do
    if not caster:HasModifier("modifier_phased") then
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_phased",{duration = 0.3})
    end
    ability:ApplyDataDrivenModifier(v, v, "modifier_phased",{duration = 0.5})
  end
  -- if not caster:HasModifier("modifier_destroy_phase") and caster:GetUnitName() ~= "B33T_UNIT" then
  --   ability:ApplyDataDrivenModifier(caster,caster,"modifier_destroy_phase",{})
  -- end

end

function phased_dummy_destroy ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if caster:HasAbility(ability:GetName()) then
    Timers:CreateTimer(1, function() 
      caster:RemoveAbility(ability:GetName())
    end)
  end
end

function returnHeal ( keys )
  local caster = keys.caster
  local ability = keys.ability
  if caster.decrease_health then
    caster.decrease_health = 1
  end
end

function ninja_takedamage ( keys )
	local ability = keys.ability
  local caster = keys.caster
  local health = caster:GetHealth()
  caster:SetHealth(health - 1)
end

function barrier_interval ( keys )
  local ability = keys.ability
  local caster = keys.caster
  local modifier = caster:FindAllModifiers()

  for _,v in ipairs(modifier) do
    
    if v:GetName() ~= "modifier_A09T_tentacle" and v:GetName() ~= "modifier_barrier" and v:GetName() ~= "modifier_record" and v:GetName() ~= "modifier_for_magic_immune" and v:GetName() ~= "modifier_kill" then
      caster:RemoveModifierByName(v:GetName())
    end
  end
end

function Add_magical_resistance(keys)
  local caster = keys.caster
  local ability = keys.ability
  local magical_resistance = keys.magical_resistance
  if caster.items == nil then
      caster.items = {}
  end
  if caster.magical_resistance == nil then
      caster.magical_resistance = 30
  end
  if caster.items[ability:GetName()] == nil then
      caster.items[ability:GetName()] = 1
      caster.magical_resistance = caster.magical_resistance + magical_resistance
  else
      caster.items[ability:GetName()] = caster.items[ability:GetName()] + 1 
  end
end

function Return_magical_resistance(keys)
  local caster = keys.caster
  local ability = keys.ability
  local magical_resistance = keys.magical_resistance
  if caster.items == nil then
      caster.items = {}
  end
  if caster.items[ability:GetName()] then
      caster.items[ability:GetName()] = caster.items[ability:GetName()] - 1
      if caster.items[ability:GetName()] == 0 then
          caster.items[ability:GetName()] = nil
          caster.magical_resistance = caster.magical_resistance - magical_resistance
      end
  end
end


function Attack_fail ( keys )
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  if target:HasModifier("modifier_ninja_cloth_untake_damage") then
    target:GiveMana(15)
    AMHC:CreateNumberEffect(target,15,2,AMHC.MSG_MANA_ADD,"blue",3)
    target:RemoveModifierByName("modifier_ninja_cloth_untake_damage")
    if target.ninja_cloth then
      target.ninja_cloth = 0
    end
  end
end

function Attack_Landed ( keys )
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  if target:HasModifier("modifier_ninja_cloth_untake_damage") then
    target:RemoveModifierByName("modifier_ninja_cloth_untake_damage")
    if target.ninja_cloth then
      target.ninja_cloth = 0
    end
  end
end 

function ninja_underground( keys )
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("modifier_ninja_underground") == false then
    ability:ApplyDataDrivenModifier( caster, caster, "modifier_ninja_underground", {} )
    caster:AddNewModifier(caster, ability, "modifier_B13D", nil )
	else
    caster:RemoveModifierByName("modifier_ninja_underground")
    caster:RemoveModifierByName("modifier_B13D")
	end
end

function logging( keys ) 
  print("logging")
end

function aram_minion_death ( keys )
  local ran =  RandomInt(0, 100)
  if ran < 5 then
    local pickup_loc = keys.caster:GetAbsOrigin()
    local pickup_thinker = CreateModifierThinker(nil, nil, "modifier_pickup_health_thinker", {x = pickup_loc.x, y = pickup_loc.y, z = pickup_loc.z + 128}, pickup_loc, DOTA_TEAM_NEUTRALS, false) 
  end
end

modifier_pickup_health_buff = class({})

function modifier_pickup_health_buff:IsDebuff() return false end
function modifier_pickup_health_buff:IsHidden() return false end
function modifier_pickup_health_buff:IsPurgable() return false end
function modifier_pickup_health_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_pickup_health_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
	return funcs
end

function modifier_pickup_health_buff:GetModifierHealthRegenPercentage()
	return 12.5
end

function modifier_pickup_health_buff:GetModifierTotalPercentageManaRegen()
	return 12.5
end

function modifier_pickup_health_buff:GetTexture()
	return "rune_regen"
end

function modifier_pickup_health_buff:GetEffectName()
	return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_pickup_health_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_pickup_health_thinker = class({})

function modifier_pickup_health_thinker:IsDebuff() return false end
function modifier_pickup_health_thinker:IsHidden() return true end
function modifier_pickup_health_thinker:IsPurgable() return false end
function modifier_pickup_health_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_pickup_health_thinker:OnCreated(keys)
  if IsServer() then
		self.pickup_location = Vector(keys.x, keys.y, keys.z)
		self.activated = false

		AddFOWViewer(DOTA_TEAM_GOODGUYS, self.pickup_location, 375, 5, false)
		AddFOWViewer(DOTA_TEAM_BADGUYS, self.pickup_location, 375, 5, false)

		-- EmitSoundOnLocationWithCaster(self.pickup_location, "POG.Chalice.Spawn", Guardians.team_fountain[DOTA_TEAM_GOODGUYS])

		self.pickup_pfx = ParticleManager:CreateParticle("particles/a15w/a15w_disarm_glow.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.pickup_pfx, 0, self.pickup_location)

		self:StartIntervalThink(0.03)
	end
end

function modifier_pickup_health_thinker:OnIntervalThink()
	if IsServer() then
		if not self.activated then
			local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self.pickup_location, nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			if #units > 0 then
				self.activated = true

				-- EmitSoundOnLocationWithCaster(self.pickup_location, "POG.Chalice.Activate", Guardians.team_fountain[DOTA_TEAM_GOODGUYS])

				ParticleManager:DestroyParticle(self.pickup_pfx, false)
				ParticleManager:ReleaseParticleIndex(self.pickup_pfx)

				local ring_pfx = ParticleManager:CreateParticle("particles/pickup_health/pickup_health_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(ring_pfx, 0, self.pickup_location)
				ParticleManager:SetParticleControl(ring_pfx, 1, Vector(3, 375, 0))

				AddFOWViewer(DOTA_TEAM_GOODGUYS, self.pickup_location, 375, 3.0, false)
				AddFOWViewer(DOTA_TEAM_BADGUYS, self.pickup_location, 375, 3.0, false)

				Timers:CreateTimer(3.2, function()
					-- EmitSoundOnLocationWithCaster(self.pickup_location, "POG.Chalice.Heal", Guardians.team_fountain[DOTA_TEAM_GOODGUYS])

					local healed_units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self.pickup_location, nil, 375, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					for _, unit in pairs(healed_units) do

						local heal_pfx = ParticleManager:CreateParticle("particles/a09r/a09rdeath/monkey_king_spring_death_expanding.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
						ParticleManager:SetParticleControl(heal_pfx, 0, unit:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(heal_pfx)

						if unit.GetPlayerID then
							local remaining_duration = 0
							if unit:HasModifier("modifier_pickup_health_buff") then
								remaining_duration = unit:FindModifierByName("modifier_pickup_health_buff"):GetRemainingTime()
							end
						end

						unit:AddNewModifier(unit, nil, "modifier_pickup_health_buff", {duration = 5})
					end

					ParticleManager:DestroyParticle(ring_pfx, true)
					ParticleManager:ReleaseParticleIndex(ring_pfx)
				end)
			end
		end
	end
end 