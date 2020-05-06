function OnHeroKilled(keys)
    --殺人與助攻金錢
    local kill_bounty = 100
    local extra_bounty = 300
    local bounty = 0
    local killedUnit = keys.target
    local AttackerUnit = keys.attacker
    if AttackerUnit.kill_hero_count == nil then
        AttackerUnit.kill_hero_count = 0
    end
    if AttackerUnit.building_count == nil then
        AttackerUnit.building_count = 0
    end
    if AttackerUnit.continue_kill == nil then
        AttackerUnit.continue_kill = 0
    end
    if AttackerUnit.continue_die == nil then
        AttackerUnit.continue_die = 0
    end
    if killedUnit.continue_kill == nil then
        killedUnit.continue_kill = 0
    end
    if killedUnit.continue_die == nil then
        killedUnit.continue_die = 0
    end
    AttackerUnit.kill_hero_count = AttackerUnit.kill_hero_count + 1
    --拿經驗
    if _G.average_level[AttackerUnit:GetTeamNumber()] < _G.average_level[killedUnit:GetTeamNumber()] then
        AttackerUnit:AddExperience(killedUnit:GetLevel() * 20, 0, false, false)
        local nobu_id = _G.heromap[AttackerUnit:GetName()]
        local nobu_id2 = _G.heromap[killedUnit:GetName()]
        GameRules:SendCustomMessage(
            "<font color='#ffff00'>" ..
                _G.hero_name_zh[nobu_id] ..
                    "擊殺了" .. _G.hero_name_zh[nobu_id2] .. "得到" .. (killedUnit:GetLevel() * 20) .. "的額外經驗</font>",
            DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,
            0
        )
    end
    --額外獎勵
    --連殺不死被殺
    if killedUnit.continue_kill and killedUnit.continue_kill > 2 then
        local nobu_id = _G.heromap[AttackerUnit:GetName()]
        local nobu_id2 = _G.heromap[killedUnit:GetName()]
        bounty = (killedUnit.continue_kill - 2) * 100
        if bounty > 400 then
            bounty = 400
        end
        GameRules:SendCustomMessage(
            "<font color='#ffff00'>" ..
                _G.hero_name_zh[nobu_id] ..
                    "中止了" .. _G.hero_name_zh[nobu_id2] .. "的連殺，得到" .. (killedUnit.continue_kill * 100) .. "獎勵</font>",
            DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,
            0
        )
    elseif killedUnit.continue_die then
        bounty = killedUnit.continue_die * 50 * -1
        if bounty < -200 then
            bounty = -200
        end
    end
    --殺人錢
    AMHC:GivePlayerGold_UnReliable(AttackerUnit:GetPlayerOwnerID(), kill_bounty)
    _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] =
        _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] + kill_bounty
    --額外獎勵
    AMHC:GivePlayerGold_UnReliable(AttackerUnit:GetPlayerOwnerID(), extra_bounty + bounty)
    _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] =
        _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] + extra_bounty + bounty
    --連殺獎勵
    local sk_kill = 1
    if AttackerUnit.sk_kill then
        AttackerUnit.sk_kill = AttackerUnit.sk_kill + 1
        sk_kill = AttackerUnit.sk_kill
    else
        AttackerUnit.sk_kill = 1
    end
    if AttackerUnit.sk_kill > 1 then
        AMHC:GivePlayerGold_UnReliable(AttackerUnit:GetPlayerOwnerID(), AttackerUnit.sk_kill * 50)
        _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] =
            _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] + AttackerUnit.sk_kill * 50
        local nobu_id = _G.heromap[AttackerUnit:GetName()]
        GameRules:SendCustomMessage(
            "<font color='#ffff00'>" ..
                _G.hero_name_zh[nobu_id] ..
                    "達成了" .. AttackerUnit.sk_kill .. "連殺，得到" .. (AttackerUnit.sk_kill * 50) .. "獎勵</font>",
            DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,
            0
        )
    end
    --屯錢獎勵
    if killedUnit:GetGold() > 3000 then
        local level = math.floor((killedUnit:GetGold() - 3000) / 1000)
        AMHC:GivePlayerGold_UnReliable(AttackerUnit:GetPlayerOwnerID(), (2 + level) * 50)
        _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] =
            _G.PlayerEarnedGold[AttackerUnit:GetPlayerOwnerID()] + (2 + level) * 50
        local nobu_id = _G.heromap[AttackerUnit:GetName()]
        local nobu_id2 = _G.heromap[killedUnit:GetName()]
        GameRules:SendCustomMessage(
            "<font color='#ffff00'>" ..
                _G.hero_name_zh[nobu_id] ..
                    "獲得了" .. _G.hero_name_zh[nobu_id2] .. "的賞金，得到" .. ((2 + level) * 50) .. "獎勵</font>",
            DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,
            0
        )
    end
    Timers:CreateTimer(
        15,
        function()
            if AttackerUnit.sk_kill == sk_kill then
                AttackerUnit.sk_kill = nil
            end
        end
    )
    --殺人者連死歸0 連殺 +1
    AttackerUnit.continue_die = 0
    AttackerUnit.continue_kill = AttackerUnit.continue_kill + 1
    --被殺者連殺歸0 連死 +1
    killedUnit.continue_die = killedUnit.continue_die + 1
    killedUnit.continue_kill = 0
end
