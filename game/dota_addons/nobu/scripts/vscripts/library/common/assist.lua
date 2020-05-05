function OnOwnerDied(keys)
    print("die")
    --殺人與助攻金錢
    local kill_bounty = 100
    local extra_bounty = 300
    local bounty = 0
    local killedUnit = keys.caster
    --額外獎勵
    --連殺不死被殺
    if killedUnit.continue_kill and killedUnit.continue_kill > 2 then
        bounty = (killedUnit.continue_kill - 2) * 100
        if bounty > 400 then
            bounty = 400
        end
    elseif killedUnit.continue_die then
        bounty = killedUnit.continue_die * 50 * -1
        if bounty < -200 then
            bounty = -200
        end
    end
    --發錢
    Timers:CreateTimer(
        0.1,
        function()
            for i = 0, 9 do
                local player = PlayerResource:GetPlayer(i)
                if player then
                    local hero = player:GetAssignedHero()
                    --助攻的人拿額外獎勵
                    if hero.assist_count < hero:GetAssists() then
                        AMHC:GivePlayerGold_UnReliable(hero:GetPlayerOwnerID(), extra_bounty + bounty)
                        _G.PlayerEarnedGold[i] = _G.PlayerEarnedGold[i] + extra_bounty + bounty
                        hero.assist_count = hero.assist_count+1
                    end
                end
            end
        end
    )
end
