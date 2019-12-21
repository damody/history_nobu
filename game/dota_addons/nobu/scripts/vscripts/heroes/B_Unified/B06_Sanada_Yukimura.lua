
LinkLuaModifier( "modifier_item_blade_mail_rework_damage_return", "scripts/vscripts/heroes/B_Unified/B06_Sanada_Yukimura.lua",LUA_MODIFIER_MOTION_NONE )
modifier_item_blade_mail_rework_damage_return = class({})

--------------------------------------------------------------------------------

function modifier_item_blade_mail_rework_damage_return:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_blade_mail_rework_damage_return:OnCreated( event )
	self:StartIntervalThink(0.2)
end

function modifier_item_blade_mail_rework_damage_return:OnIntervalThink()
	if (self.caster ~= nil) and IsValidEntity(self.caster) then
		self.hp = self.caster:GetHealth()
	end
end
--------------------------------------------------------------------------------

function modifier_item_blade_mail_rework_damage_return:OnTakeDamage(event)
    local attacker = event.unit
    local victim = event.attacker
    local return_damage = event.original_damage
    local damage_type = event.damage_type
    local damage_flags = event.damage_flags
    local ability = self:GetAbility()

    if victim:GetTeam() ~= attacker:GetTeam() then
        if damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
            if damage_type == DAMAGE_TYPE_MAGICAL and self.caster.B06R_Buff == true then
            	if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
	            	self.caster.B06R_Buff = false
	            	self.caster:SetHealth(self.hp)
	            	self.caster:FindAbilityByName("B06R"):ApplyDataDrivenModifier(self.caster, self.caster, "modifier_B06R", {duration = 3.0})
	            	AmpDamageParticle = ParticleManager:CreateParticle("particles/a07w4/a07w4_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
					
					local count = 0
					local part = ParticleManager:CreateParticle("particles/b06r3/b06r4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
					Timers:CreateTimer(3, function() 
						ParticleManager:DestroyParticle(part, true)
					end)
				end
            end 
        end 
    end 
end 

--哇塞 lua也太方便了吧 X.y後面就可以設定一個變數
--還可以是table
--可以在KV那邊傳導設定 keys的子級

--<<global>>

--<<global>>


function b06e_Shot( keys )
	local ability = keys.ability
	local target = keys.target

	--debug
  	-- local caster   = keys.caster --获取该玩家的英雄
  	-- DeepPrintTable(keys)    --详细打印传递进来的表

	local id	 = keys.caster:GetPlayerOwnerID() --獲取玩家ID
	local p        = PlayerResource:GetPlayer(id)--可以用索引轉換玩家方式，來捕捉玩家
  	local caster   = ability:GetCaster()
  	local point  = target:GetAbsOrigin()

  	--次數紀錄
  	caster.b06ecountofattacked = caster.b06ecountofattacked - 1

	--範圍尋找對象
	local radius = 500

    --獲取攻擊範圍
    local group = {}
    local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO     --+DOTA_UNIT_TARGET_BUILDING


    --獲取周圍的單位
    group = FindUnitsInRadius(caster:GetTeamNumber(),point,nil,radius,teams,types,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_ANY_ORDER,true)

    --如果元素大於0個單位才隨機抓取
    if #group > 1  and caster.b06ecountofattacked > 0 then

    	local newgroup = {}
    	for i,unit in ipairs(group) do
			if unit ~= target then
				table.insert(newgroup,unit)
			end
		end

    	local new_target = newgroup[RandomInt(1,#newgroup)]

		local projectile_info = 
			{
				EffectName = "particles/b06e2/b06e2.vpcf",
				Ability = ability,
				vSpawnOrigin = target:GetAbsOrigin(),
				Target = new_target,
				Source = target,
				bHasFrontalCone = false,
				iMoveSpeed = 900,
				bReplaceExisting = false,
				bProvidesVision = true
			}
		ProjectileManager:CreateTrackingProjectile(projectile_info)
    end

end

function b06e_start( keys )
	local caster = keys.caster
	local target = caster

	--保存次數:彈跳次數
	caster.b06ecountofattacked = 5

	local particleName = "particles/b06t/b06t.vpcf"
	Timers:CreateTimer(0.01, function() 
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
		--ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	end)

	Timers:CreateTimer(0.7, function() 
		ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
	end)

end

--要注意魔法免疫
--ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags() 超好用

function B06R_Learn_Ability( keys )
	local ability = keys.ability
	local caster = keys.caster
	if caster.b06r == nil then
		keys.caster.B06R_Buff = true
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_item_blade_mail_rework_damage_return", {duration = 10000} )
		caster:FindModifierByName("modifier_item_blade_mail_rework_damage_return").caster = caster
		caster.b06r = 1
		Timers:CreateTimer(1, function ()
			if (not caster:HasModifier("modifier_item_blade_mail_rework_damage_return")) and caster:IsAlive() then
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_item_blade_mail_rework_damage_return", {duration = 10000} )
				caster:FindModifierByName("modifier_item_blade_mail_rework_damage_return").caster = caster
				caster.b06r = 1
				keys.caster.B06R_Buff = true
			end
			return 1
		end)
	end
end


function B06R_TimeUP( keys )
	local level  = keys.ability:GetLevel()--獲取技能等級
	local Float_Timer = keys.ability:GetLevelSpecialValueFor("Float_Timer",level-1)
	Timers:CreateTimer(Float_Timer, function() 
		keys.caster.B06R_Buff = true
		end)
end

function B06T_SE( keys )
	local caster = keys.caster
	local target = keys.target
	AMHC:CreateParticle("particles/b06e4/b06e4_b.vpcf",PATTACH_ABSORIGIN,false,target,0.5,nil)
	if target:IsRealHero() then 
		ParticleManager:CreateParticle("particles/shake1.vpcf", PATTACH_ABSORIGIN, target)
	end
end


function B06T_effect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local During = ability:GetSpecialValueFor("During")
	--local particle1 = ParticleManager:CreateParticle("particles/b06t/b06t.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)

	Timers:CreateTimer(10.1, function()
		if caster:HasModifier("modifier_B06T") then
			--ParticleManager:CreateParticle("particles/b06t/b06t.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			return 10
		end
	end)

end