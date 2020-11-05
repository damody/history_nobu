require("equilibrium_constant")
LinkLuaModifier( "modifier_record", "items/Addon_Items/record.lua",LUA_MODIFIER_MOTION_NONE )
--單位創建也會運行

heromap = _G.heromap 
ability_index = {
  "w","e","r","","d","t",
}
function Nobu:OnHeroIngame( keys )
  local hero = EntIndexToHScript( keys.entindex )
  if hero ~= nil and IsValidEntity(hero) then
    if hero:HasModifier("modifier_record") then
      hero:RemoveModifierByName("modifier_record")
    end
    hero:AddNewModifier(hero, nil,"modifier_record",{})
    hero:FindModifierByName("modifier_record").caster = hero
  end
  if hero ~= nil and IsValidEntity(hero) and hero:IsHero() then
    local caster = hero
    Timers:CreateTimer(0.1,function()
      hero.spawn_location = hero:GetAbsOrigin()
    end)
    caster.name = heromap[caster:GetUnitName()]
    caster.version = "16"
    -- caster:FindAbilityByName("attribute_bonusx"):SetLevel(1)
    
	-- 拿掉天賦樹的技能
    for i = 0, caster:GetAbilityCount() - 1 do
        local ability = caster:GetAbilityByIndex(i)
        if ability and string.match(ability:GetName(),"special") then
          caster:RemoveAbility(ability:GetName())
        end
    end

    local name = caster:GetUnitName()

    Timers:CreateTimer ( 0.2, function ()
      if hero ~= nil and IsValidEntity(hero) and not hero:IsIllusion() and caster:GetTeamNumber() < 4 then
        if hero.init1 == nil then
          hero.init1 = true
          hero.assist_count = 0
          hero.kill_count = 0
          hero.building_count = 0
          hero.damage_to_hero = 0
          hero.physical_damage_to_hero = 0
          hero.magical_damage_to_hero = 0
          hero.true_damage_to_hero = 0
          hero.damage = 0
          hero.physical_damage = 0
          hero.magical_damage = 0
          hero.true_damage = 0
          hero.maximum_critical_damage = 0
          hero.damage_to_tower = 0
          hero.damage_to_unit = 0
          hero.heal = 0
          hero.damage_taken = 0
          hero.physical_damage_taken = 0
          hero.magical_damage_taken = 0
          hero.true_damage_taken = 0
          hero.damage_reduce = 0
          hero.largest_killing_spree = 0
          hero.largest_multi_kill = 0
          hero.first_blood = false
          hero.on_multikill = 0
          hero.multikill_count = 0
          hero.ability_order = {}
          hero.ability_map = {}
          hero.afk_time = 0
          for i=0,5 do 
            hero.ability_map[hero:GetAbilityByIndex(i):GetName()] = ability_index[i+1]
          end
          hero:AddNewModifier(caster,ability,"modifier_record",{})
          hero:AddAbility("hero_kill"):SetLevel(1)
          hero:AddAbility("hero_die"):SetLevel(1)
          hero:AddAbility("slow_self"):SetLevel(1)
          hero:AddAbility("HealthRegen_self"):SetLevel(1)
          hero:AddAbility("ManaRegen_self"):SetLevel(1)
          hero:AddAbility("AtkSpeedBonus_self"):SetLevel(1)
          hero:FindModifierByName("modifier_record").caster = caster
          hero:AddItem(CreateItem("item_S01", hero, hero))
          hero:AddItem(CreateItem("item_logging", hero, hero))
          --松姬 奇襲 開場要有30秒CD
          if hero.name == "C19" then
            hero:FindAbilityByName("C19D"):StartCooldown(30)
          end
          --把砍樹移動到neutral item slot
          for i = 0, 15 do
            local item = caster:GetItemInSlot( i )
            if item then
              if item:GetName() == "item_logging" then
                hero:SwapItems(i, 16)
              end
            end
          end
          local allCouriers = Entities:FindAllByClassname('npc_dota_courier2')
          for k, ent in pairs(allCouriers) do
            if ent:GetOwner():GetAssignedHero() == hero then
              ent:ForceKill(true)
              ent:GetOwner():GetAssignedHero().courier = 1
            end
          end
        else
          -- 裝備重放
          for i = 0, 6 do
            local item = caster:GetItemInSlot( i )
            if item then
              local item_name = item:GetName()
              if item ~= nil then
              item:SetBuybackGoldLimitTime(0)
              item:SetPurchaseTime(0)
              end
              if not item:IsStackable() then
                item:Destroy()
                local new_item = hero:AddItem(CreateItem(item_name, hero, hero))
                hero:SwapItems(new_item:GetItemSlot(), i)
              end
            end
          end
        end
      end
    end)
  end
end

-- 統計英雄使用情況
function Nobu:CountUsedAbility( keys )
  local keyid = keys.PlayerID
  if (_G.CountUsedAbility_Table[keyid] == nil) then
    _G.CountUsedAbility_Table[keyid]  = {}
  end
  if (_G.CountUsedAbility_Table[keyid][keys.abilityname] == nil) then
    _G.CountUsedAbility_Table[keyid][keys.abilityname] = 1
  else
    _G.CountUsedAbility_Table[keyid][keys.abilityname] =
      _G.CountUsedAbility_Table[keyid][keys.abilityname] + 1
  end
  --DeepPrintTable(_G.CountUsedAbility_Table)
end


function SendHTTPRequest(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://172.104.107.13/"..path )
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		callback(result.Body)
	end)
end
