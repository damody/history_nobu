
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
    if reason == DOTA_ModifyGold_Building then      
      if gold ~= 150 and gold ~= 750 and gold ~= 50 then return false end
      if gold == 750 then filterTable["gold"] = 300 end
      print("tower")
      return true
    end
    -- Disable all hero kill gold
    if reason == DOTA_ModifyGold_HeroKill then
      return false
    end
    return true
end

courier_modifier_ban ={
  "name_const: modifier_courier_morph_effect",
  "modifier_courier_flying",
  "modifier_courier_passive_bonus",
  "modifier_fountain_aura_buff",
}


function DumpTable( tTable )
	local inspect = require('inspect')
	local iDepth = 3
 	print(inspect(tTable,
 		{depth=iDepth} 
 	))
end

function Nobu:HealFilter(keys)
	--[[
	entindex_healer_const: 329
	entindex_inflictor_const: 600
	entindex_target_const: 329
	heal: 60
  ]]
	local target = EntIndexToHScript(keys.entindex_target_const)
	local heal = keys.heal
	local healer = keys.entindex_inflictor_const and EntIndexToHScript(keys.entindex_inflictor_const) or nil
  if healer then
    if healer.HasModifier and healer:HasModifier("Passive_item_glass_mitsutomo") ~= nil then
      if healer ~= target then
        keys.heal = keys.heal * 1.2
      end
    end
  end

	return true
end

function Nobu:ModifierGainedFilter( filterTable )
  if filterTable.entindex_caster_const == nil then
    return true
  end
  if filterTable.entindex_parent_const == nil then
    return true
  end
  local caster = EntIndexToHScript( filterTable.entindex_caster_const )
  local target = EntIndexToHScript( filterTable.entindex_parent_const )
  local modifier_name = filterTable.name_const
  local duration = filterTable.duration
  if target:IsHero() and target.states_resistance ~= nil and caster:GetTeamNumber() ~= target:GetTeamNumber() then
    if modifier_name == "modifier_truesight" then
      return true
    end
    filterTable.duration = filterTable.duration * (1 - target.states_resistance*0.01)
  end
  --強王
  if target:GetUnitName() == "npc_dota_the_king_of_robbers" then
    if caster ~= target then
      filterTable.duration = filterTable.duration * 0.5
      return true
    end
  end
  --亡靈
  if target:GetUnitName() == "npc_dota_cursed_warrior_souls" then
    if caster ~= target then
      return false
    end
  end
  --南蠻 啟動
  if target:HasModifier("modifier_nannbann_purge") then
    if caster:GetTeamNumber() ~= target:GetTeamNumber() then
      return false
    end
  end
  --ban 掉馬飛行 及 增加血量
  for _,v in pairs(courier_modifier_ban) do
    if target:GetName() == "npc_dota_courier" and modifier_name == v then
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
  -- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(Nobu, "ModifyGoldFilter"), Nobu)
  GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(Nobu, "AbilityTuningValueFilter"), Nobu)
  GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(Nobu, "SetItemAddedToInventoryFilter"), Nobu)  --用来控制物品被放入物品栏时的行为
  GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(Nobu, "SetModifyExperienceFilter"), Nobu)  --經驗值
  GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(Nobu, "SetTrackingProjectileFilter"), Nobu)  --投射物
  GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( Nobu, "FilterGold" ), Nobu ) --金錢事件 不知道為什麼會跳兩次
  GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( Nobu, "ModifierGainedFilter" ), Nobu ) --modifier事件 不知道為什麼會跳兩次
  GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap(Nobu, "HealFilter"), self)

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
