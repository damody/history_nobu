
function Nobu:LevelUP( keys )
  -- DeepPrintTable(keys)
  -- [   VScript   ]:    player                            = 1 (number)
  -- [   VScript   ]:    level                             = 24 (number)
  -- [   VScript   ]:    splitscreenplayer                 = -1 (number)
end

function Nobu:Learn_Ability( keys )
  -- DeepPrintTable(keys)
  -- [   VScript          ]:    player                           = 1 (number)
  -- [   VScript          ]:    abilityname                      = "A06W" (string)
  -- [   VScript          ]:    splitscreenplayer                = -1 (number)
end

function Nobu:Connect_Full( keys )
  -- DeepPrintTable(keys)
  -- [   VScript              ]:    PlayerID                         = 0 (number)
  -- [   VScript              ]:    index                            = 0 (number)
  -- [   VScript              ]:    userid                           = 1 (number)
  -- [   VScript              ]:    splitscreenplayer                = -1 (number)
end

function Nobu:OnDisconnect( keys ) --代測試

end

function Nobu:OnItemPurchased( keys )
  -- DeepPrintTable(keys)
  -- [   VScript              ]:    itemcost                         = 50 (number)
  -- [   VScript              ]:    itemname                         = "item_tpscroll" (string)
  -- [   VScript              ]:    PlayerID                         = 0 (number)
  -- [   VScript              ]:    splitscreenplayer                = -1 (number)
end

function Nobu:OnItemPickedUp( keys )
  -- DeepPrintTable(keys)
  -- O 購買物品不會觸發
  -- [   VScript              ]:    itemname                         = "item_invis_sword" (string)
  -- [   VScript              ]:    PlayerID                         = 0 (number)
  -- [   VScript              ]:    splitscreenplayer                = -1 (number)
  -- [   VScript              ]:    ItemEntityIndex                  = 2529 (number)
  -- [   VScript              ]:    HeroEntityIndex                  = 2548 (number)
end

function Nobu:OnEntityHurt( keys )
  -- DeepPrintTable(keys)
  -- O為甚麼要filter外 還有這個傷害事件
  -- [   VScript              ]:    damagebits                       = 0 (number)
  -- [   VScript              ]:    entindex_killed                  = 2548 (number)
  -- [   VScript              ]:    damage                           = 41.65344619751 (number)
  -- [   VScript              ]:    entindex_attacker                = 306 (number)
  -- [   VScript              ]:    splitscreenplayer                = -1 (number)
end

function Nobu:PlayerConnect( keys )
  --print("Nobu PlayerConnect")
  --DeepPrintTable(keys)
  -- [   VScript              ]:    address                          = "none" (string)
  -- [   VScript              ]:    bot                              = 1 (number)
  -- [   VScript              ]:    userid                           = 2 (number)
  -- [   VScript              ]:    index                            = 1 (number)
  -- [   VScript              ]:    xuid                             = 0 (userdata)
  -- [   VScript              ]:    networkid                        = "BOT" (string)
  -- [   VScript              ]:    name                             = "Louie Bot" (string)
  -- [   VScript              ]:    splitscreenplayer                = -1 (number)
end

function Nobu:PlayerSay( keys ) --代測試

--DeepPrintTable(keys)
end

function Nobu:Item_Changed( keys ) --代測試

--DeepPrintTable(keys)
end

function Nobu:ModifyGoldFilter(filterTable)
  -- DeepPrintTable(filterTable)
  -- [   VScript              ]:    reason_const                     = 13 (number)
  -- [   VScript              ]:    reliable                         = 0 (number)
  -- [   VScript              ]:    player_id_const                  = 0 (number)
  -- [   VScript              ]:    gold                             = 61 (number)

  -- Disable gold gain from hero kills
  -- if filterTable["reason_const"] == DOTA_ModifyGold_HeroKill then
  --     filterTable["gold"] = 0
  --     return false
  -- end

  return true
end

function Nobu:AbilityTuningValueFilter(filterTable)
  --DeepPrintTable(filterTable)
  -- [   VScript              ]:    value                            = 6 (number)
  -- [   VScript              ]:    entindex_ability_const           = 799 (number)
  -- [   VScript              ]:    value_name_const                 = "A06W_Duration" (string)
  -- [   VScript              ]:    entindex_caster_const            = 798 (number)

  -- [   VScript              ]:    value                            = 5 (number)
  -- [   VScript              ]:    entindex_ability_const           = 786 (number)
  -- [   VScript              ]:    value_name_const                 = "A06R_SPEED" (string)
  -- [   VScript              ]:    entindex_caster_const            = 798 (number)
  --print("Nobu:AbilityTuningValueFilter")
  return true
end

function Nobu:SetItemAddedToInventoryFilter(filterTable)
  --DeepPrintTable(filterTable)
  -- [   VScript ]:    item_entindex_const               = 830 (number)
  -- [   VScript ]:    inventory_parent_entindex_const   = 798 (number)
  -- [   VScript ]:    suggested_slot                    = -1 (number)
  -- [   VScript ]:    item_parent_entindex_const        = -1 (number)
  --print("SetItemAddedToInventoryFilter")
  return true
end

function Nobu:SetModifyExperienceFilter(filterTable)
  -- DeepPrintTable(filterTable)
  -- [   VScript              ]:    reason_const                     = 2 (number)
  -- [   VScript              ]:    experience                       = 120 (number)
  -- [   VScript              ]:    player_id_const                  = 0 (number)

  return true
end

function Nobu:SetTrackingProjectileFilter(filterTable)
  --DeepPrintTable(filterTable)
  -- [   VScript          ]:    is_attack                        = 0 (number)
  -- [   VScript          ]:    entindex_ability_const           = 330 (number)
  -- [   VScript          ]:    max_impact_time                  = 0 (number)
  -- [   VScript          ]:    entindex_target_const            = 495 (number)
  -- [   VScript          ]:    move_speed                       = 1100 (number)
  -- [   VScript          ]:    entindex_source_const            = 328 (number)
  -- [   VScript          ]:    dodgeable                        = 1 (number)
  -- [   VScript          ]:    expire_time                      = 0 (number)

  return true
end


function Nobu:Attachment_UpdateUnit(args)
  --DebugPrint('Attachment_UpdateUnit')
  --DebugPrintTable(args)

  local unit = EntIndexToHScript(args.index)
  -- if not unit then
  --   --Notify(args.PlayerID, "Invalid Unit.")
  --   return
  -- end

  -- local cosmetics = {}
  -- for i,child in ipairs(unit:GetChildren()) do
  --   if child:GetClassname() == "dota_item_wearable" and child:GetModelName() ~= "" then
  --     table.insert(cosmetics, child:GetModelName())
  --   end
  -- end

  -- --DebugPrintTable(cosmetics)
  -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID), "attachment_cosmetic_list", cosmetics )
end

function give_money_for_together_hero(caster, gold, radius)
  local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
  local illu = 0
  for _,hero in ipairs(group) do
    if hero:IsIllusion() then
      illu = illu + 1
    end
  end
  local sum = #group - illu
  if sum == 1 then
    gold = gold
  elseif sum > 2 then
    gold = gold * sum * 0.5
  end
  local give = {}
  for _,hero in ipairs(group) do
    if not hero:IsIllusion() and hero ~= caster then
      AMHC:GivePlayerGold_UnReliable(hero:GetPlayerOwnerID(), gold)
    end
  end
end

_G.assist = {}
_G.assist_timer = false
_G.not_assist = -1

function Nobu:FilterGold( filterTable )
    local gold = filterTable["gold"]
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]
    filterTable["reliable"] = 0
    -- Disable all hero kill gold
    if reason == DOTA_ModifyGold_HeroKill then
      if gold == 150 or gold == 300 or gold == 450 then
        _G.not_assist = playerID
        return true
      else
        local player = PlayerResource:GetPlayer(playerID)
        if player then
          local hero = player:GetAssignedHero()
          if hero then
            table.insert(_G.assist, playerID)
            if not _G.assist_timer then
              _G.assist_timer = true
              Timers:CreateTimer( 0.1, function()
                local total = #_G.assist - 1
                if total > 0 then
                  local moneyb = 0
                  if prestige[hero:GetTeamNumber()] > 100 then
                    moneyb = math.floor(prestige[hero:GetTeamNumber()]/100)*20
                  end
                  local money = (150+moneyb)/total
                  for _,v in pairs(_G.assist) do
                    if v ~= _G.not_assist then
                      AMHC:GivePlayerGold_UnReliable(v, money)
                    end
                  end
                end
                _G.assist = {}
                _G.assist_timer = false
                _G.not_assist = -1
                end)
            end
          end
        end
        return false
      end
    end

    return true
end

function Nobu:Init_Event_and_Filter_GameMode()
  local self =  _G.Nobu


  --【Filter】
  GameRules:GetGameModeEntity():SetExecuteOrderFilter( Nobu.eventfororder, self )
  GameRules:GetGameModeEntity():SetDamageFilter( Nobu.DamageFilterEvent, self )
  GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(Nobu, "ModifyGoldFilter"), Nobu)
  GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(Nobu, "AbilityTuningValueFilter"), Nobu)
  GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(Nobu, "SetItemAddedToInventoryFilter"), Nobu)  --用来控制物品被放入物品栏时的行为
  GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(Nobu, "SetModifyExperienceFilter"), Nobu)  --經驗值
  GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(Nobu, "SetTrackingProjectileFilter"), Nobu)  --投射物
  GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( Nobu, "FilterGold" ), self )
  
  --【Evnet】
  Nobu.Event ={
  ListenToGameEvent('dota_player_gained_level', Nobu.LevelUP, self),
  ListenToGameEvent("dota_player_pick_hero",Nobu.PickHero, self),
  ListenToGameEvent('npc_spawned', Nobu.OnHeroIngame, self)  ,
  ListenToGameEvent('dota_player_used_ability', Nobu.CountUsedAbility, self)  ,
  ListenToGameEvent("entity_killed", Nobu.OnUnitKill, self ),
  ListenToGameEvent("player_chat",Nobu.Chat,self), --玩家對話事件
  --ListenToGameEvent( "item_purchased", test, self ) --false
  --ListenToGameEvent( "dota_item_used", test, self ) --false
  --ListenToGameEvent("dota_inventory_item_changed", Nobu.Item_Changed, self ), --false
  ListenToGameEvent("game_rules_state_change", Nobu.OnGameRulesStateChange , self),  --監聽遊戲進度
  ListenToGameEvent("dota_player_gained_level", Nobu.LevelUP, self),   --升等事件
  ListenToGameEvent('dota_player_learned_ability', Nobu.Learn_Ability, self),  --學習技能
  ListenToGameEvent('player_connect_full', Nobu.Connect_Full, self) , --連結完成(遊戲內大廳)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(Nobu, 'OnDisconnect'), self)  ,
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(Nobu, 'OnItemPurchased'), self) , --購買物品事件
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(Nobu, 'OnItemPickedUp'), self) ,
  ListenToGameEvent('player_changename', Dynamic_Wrap(Nobu, 'OnPlayerChangedName'), self), --?
  ListenToGameEvent('player_connect', Dynamic_Wrap(Nobu, 'PlayerConnect'), self), --?
  --ListenToGameEvent('player_say', Dynamic_Wrap(Nobu, 'PlayerSay'), self), --?
  --ListenToGameEvent('dota_pause_event', Dynamic_Wrap(Nobu, 'Pause'), self), --無效

  ListenToGameEvent('entity_hurt', Dynamic_Wrap(Nobu, 'OnEntityHurt'), self) --傷害事件
  }

  --【Js Evnet】
  -- CustomGameEventManager:RegisterListener("Attachment_UpdateUnit", Dynamic_Wrap(Nobu, "Attachment_UpdateUnit"))

end
