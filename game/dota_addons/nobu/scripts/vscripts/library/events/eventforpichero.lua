
 heromap = _G.heromap 

function Nobu:PickHero( keys )
  local id       = keys.player
  local p        = PlayerResource:GetPlayer(id-1)
  local caster     = EntIndexToHScript(keys.heroindex)
  local point    = caster:GetAbsOrigin()
  local owner = caster:GetPlayerOwner()
  
  Timers:CreateTimer(1, function ()
    if caster ~= nil and IsValidEntity(caster) and not caster:IsIllusion() then
      caster.version = "nan"
      local name = caster:GetUnitName()
      Timers:CreateTimer(1, function ()
        if caster.donkey and IsValidEntity(caster.donkey) then
          for _,m in ipairs(caster.donkey:FindAllModifiers()) do
            if m:GetName() ~= "modifier_for_magic_immune" and m:GetName() ~= "modifier_courier_transfer_items" and
             m:GetName() ~= "modifier_for_move500" and m:GetName() ~= "for_no_collision" and m:GetName() ~= "phased_dummy"  and m:GetName() ~= "modifier_courier_mute"
             then
            --  if not (string.match(m:GetName(), "Passive_") or string.match(m:GetName(), "courier_burst") or m:GetName() == "modifier_invulnerable") then
                caster.donkey:RemoveModifierByName(m:GetName())
             -- end
            end
          end
          if caster.donkey:HasModifier("Passive_insight_gem") then
            caster.donkey:RemoveModifierByName("Passive_insight_gem")
          end
          if IsValidEntity(caster) then
            -- for itemSlot=0,5 do
            --   local item = caster:GetItemInSlot(itemSlot)
            --   if item ~= nil then
            --     -- item:SetPurchaseTime(100000)
            --   end
            -- end
          end
          return 1
        end
        end)
      caster:RemoveAbility("Ability_capture")
      local nobu_id = _G.heromap[caster:GetName()]
      -- 預設切換加入切換版本技能
      --[[
      
        for i = 0, caster:GetAbilityCount() - 1 do
          local ability = caster:GetAbilityByIndex( i )
          if ability  then
            caster:RemoveAbility(ability:GetName())
          end
        end
        ]]
      if caster:GetTeamNumber() < 4 then
        -- 給魔抗
        caster:FindAbilityByName("magical_resistance"):SetLevel(1)
        -- rich_man 
        --caster:AddAbility("hoarding_gold"):SetLevel(1)
        caster:AddAbility("hero_attack_tower"):SetLevel(1)
        -- 要自動學習的技能
        local askill = _G.heromap_autoskill[nobu_id]["16"]
        for si=1,#askill do
          caster:FindAbilityByName(nobu_id..askill:sub(si,si)):SetLevel(1)
        end
        --[[
        if _G.heromap_version[nobu_id] and _G.heromap_version[nobu_id]["11"] and _G.heromap_version[nobu_id]["11"] == true then
          caster:AddAbility("choose_11"):SetLevel(1)
        end
        if _G.heromap_version[nobu_id] and _G.heromap_version[nobu_id]["16"] and _G.heromap_version[nobu_id]["16"] == true then
          caster:AddAbility("choose_16"):SetLevel(1)
        end
        if _G.heromap_version[nobu_id] and _G.heromap_version[nobu_id]["20"] and _G.heromap_version[nobu_id]["20"] == true and _G.has20 == true then
          caster:AddAbility("choose_20"):SetLevel(1)
        end
        ]]
        if _G.CountUsedAbility_Table == nil then
          _G.CountUsedAbility_Table = {}
        end
        if _G.CountUsedAbility_Table[id] == nil then
          _G.CountUsedAbility_Table[id] = {}
        end
      end
      if caster:GetTeamNumber() > 3 then
        -- caster:AddAbility("OBW"):SetLevel(1)
        -- caster:AddAbility("majia"):SetLevel(1)
        -- caster:AddAbility("for_no_damage"):SetLevel(1)
        caster:AddAbility("when_cp_first_spawn"):SetLevel(1)
        caster:AddNoDraw()
        caster:SetAbsOrigin(Vector(3749.84, -3950.23, 128))
        Timers:CreateTimer(0,function()
          caster:SetAbilityPoints(0)
          return 1
        end)
      end
      --【英雄名稱判別】
      if _G.mo then
        Timers:CreateTimer(1, function()
          if caster.score == nil then caster.score = 0 end
          if caster.lastscore == nil then caster.lastscore = 0 end
          if caster.score ~= caster.lastscore then
            caster.lastscore = caster.score
            GameRules: SendCustomMessage("<font color='#aaaaff'>".._G.hero_name_zh[nobu_id].."得到 "..caster.score.." 分</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
          end
          if caster.score >= 3 then
            local nobu_id = _G.heromap[caster:GetName()]
            GameRules:SetCustomVictoryMessage(_G.hero_name_zh[nobu_id].." 贏得勝利")
            GameRules:SetGameWinner(caster:GetTeamNumber())
            return nil
          end
          return 1
          end)
      end
      -- 某些等級沒有技能點
      local lvneed = {
            [17]=true,
            [19]=true,
            [20]=true,
            [21]=true,
            [22]=true,
            [23]=true,
            [24]=true}
            local lvcaster = caster
        Timers:CreateTimer(10, function ()
          if IsValidEntity(lvcaster) then
            if (lvneed[lvcaster:GetLevel()]) then
              lvneed[lvcaster:GetLevel()] = false
              lvcaster:SetAbilityPoints(lvcaster:GetAbilityPoints()+1)
            end
          end
          return 0.3
        end)

      caster.name = heromap[name]

      if nobu_id == "A04" then -- 竹中重治
        Timers:CreateTimer(1, function()
          if caster:GetLevel() >= 18 then
            if caster:FindAbilityByName("A04D_old") then
              caster:FindAbilityByName("A04D_old"):SetLevel(1)
            end
            return nil
          end
          return 1
        end)
      elseif nobu_id == "B19" then -- 宇佐美定滿
        Timers:CreateTimer(1, function ()
          if (caster:GetLevel() >= 18) then
            if caster:FindAbilityByName("B19D_old") then
              caster:FindAbilityByName("B19D_old"):SetLevel(1)
            end
            return nil
          end
          return 1
        end)
      elseif nobu_id == "B08" then -- 淺井長政
        Timers:CreateTimer(1, function ()
          if (caster:GetLevel() >= 16) then
            if caster:FindAbilityByName("B08D") then
              caster:FindAbilityByName("B08D"):SetLevel(1)
            end
            return nil
          end
          return 1
        end)
      elseif nobu_id == "B15" then -- 今川義元
        Timers:CreateTimer(1, function ()
          if (caster:GetLevel() >= 8) then
            if caster:FindAbilityByName("B15D") then
              caster:FindAbilityByName("B15D"):SetLevel(1)
            end
            return nil
          end
          return 1
        end)
      -- elseif nobu_id == "C10" then -- 香宗我部元親
      --   Timers:CreateTimer(1, function ()
      --     print(caster:FindAbilityByName("C10T"):GetLevel())
      --       if caster:FindAbilityByName("C10T"):GetLevel() >= 1 then
      --         caster:FindAbilityByName("C10D"):SetLevel(1)
      --         return nil
      --       end
      --     return 1
      --   end)
      elseif string.match(name, "silencer") then --立花道雪
        -- 這隻角色天生會帶一個modifier我們需要砍掉他
        Timers:CreateTimer(1, function ()
          if (caster:HasModifier("modifier_silencer_int_steal")) then
            caster:RemoveModifierByName("modifier_silencer_int_steal")
          end
          return 1
        end)
      end

    end -- if caster ~= nil and IsValidEntity(caster) and not caster:IsIllusion() then
  end)
  --【英雄名稱判別】

  --【英雄系統】
    --<<事件:任一單位施放技能>>
    --caster:AddAbility("EventForUnitSpellAbility"):SetLevel(1)
    --<<事件:命令事件>>
    --caster:AddAbility("EventForOrder"):SetLevel(1)
    --<<全能力點數>>
    --caster:AddAbility("attribute_bonusx")

  --【英雄系統】

  --【test】
    --物品
  -- item = CreateItem("item_blink_datadriven",nil,nil)
  -- CreateItemOnPositionSync(point, item)
  --
  -- item = CreateItem("item_invis_sword",nil,nil)
  -- CreateItemOnPositionSync(point, item)
  --
  -- CreateItemOnPositionSync(point, CreateItem("item_D09",nil,nil))
  -- CreateItemOnPositionSync(point, CreateItem("item_D0"..2,nil,nil))
  -- CreateItemOnPositionSync(point, CreateItem("item_S01",nil,nil))


  --print(bj_CELLWIDTH)



 -- CreateItemOnPositionSync(point, CreateItem("item_test",nil,nil))
  -- item = CreateItem("item_sphere",nil,nil)
  -- CreateItemOnPositionSync(point, item)

  -- item = CreateItem("item_manta_datadriven",nil,nil)
  -- CreateItemOnPositionSync(point, item)

  --debug
  --GameRules: SendCustomMessage("Hello World",DOTA_TEAM_GOODGUYS,0)

end
