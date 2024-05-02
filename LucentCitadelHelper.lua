LCH = LCH or {}
local LCH = LCH

LCH.name     = "LucentCitadelHelper"
LCH.version  = "0.0.4"
LCH.author   = "@necco889"
LCH.active   = false

LCH.status = {
  testStatus = 0,
  inCombat = false,
  lastCombatState = false,
  
  currentBoss = "",

  isZilyesset = false,
  isCavotAgnan = false,
  isOrphicShard = false,
  isArcaneKnot = false,
  isHMBoss = false,

  isKnotActive = false,

  locked = true,
  
}
-- Default settings.
LCH.settings = {
  -- Ryelaz & Zilyesset
  showSheerAlert = true,
  showBeamOnYou = true,
  showBossHpDiff = true,

  --Cavot Agnan

  --Orphic Shattered Shard
  showmirrorNumberIcons = true,
  showBossColor = true,
  showMirrorDrain = true,
  showLightAddsNum = true,
  showDarkAddsNum = true,
  showXorynJumpTimer = true,
  showXorynJumpAlert = true,
  showXorynFloodTimer = true,

  --Arcane Knot
  showKnotDropTimer = true,
  showPickUpKnotAlert = true,
  showKnotCounter = true,
  showArcaneConveyanceIncoming = true,
  showArcaneConveyanceOnYou = true,

  --Trash
  showDarknessOnYou = true,
  showDarknessArrows = true,
  showNecroticRain = true,

  -- Misc
  uiCustomScale = 1,
  messageFontSize = 72,
}
LCH.units = {}
LCH.unitsTag = {}

function LCH.EffectChanged(eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType )
  LCH.IdentifyUnit(unitTag, unitName, unitId)
  local timeSec = GetGameTimeSeconds()
  local data = LCH.data
  -- EFFECT_RESULT_GAINED = 1
  -- EFFECT_RESULT_FADED = 2
  -- EFFECT_RESULT_UPDATED = 3


  --trash
  if abilityId == data.darkness_inflicted then
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
      LCH.Trash.Darkness(true, unitTag)
    else
      LCH.Trash.Darkness(false, unitTag)
    end

  --zilyesset
  elseif (abilityId == data.bleak_lusterbeam or abilityId == data.brilliant_lusterbeam) and unitTag == "player" and changeType == EFFECT_RESULT_GAINED then
    LCH.Zilyesset.Beam()

  --Orphic Shard
  elseif abilityId == data.mirror_drain and unitTag == "player" then
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
      LCH.Orphic.MirrorDrain(endTime, stackCount)
    else
      LCH.Orphic.MirrorDrain(0, 0)
    end
  elseif abilityId == data.orphic_boss_dark_imm and changeType == EFFECT_RESULT_GAINED then
    LCH.Orphic.BossColorUpdate(false)
  elseif abilityId == data.orphic_boss_light_imm and changeType == EFFECT_RESULT_GAINED then
    LCH.Orphic.BossColorUpdate(true)

  elseif abilityId == data.orphic_adds_light_imm then
    if changeType == EFFECT_RESULT_GAINED then
      LCH.Orphic.LightImmunityOnAdd(true, unitId)
    elseif changeType == EFFECT_RESULT_FADED then
      LCH.Orphic.LightImmunityOnAdd(false, unitId)
    end
  elseif abilityId == data.orphic_adds_dark_imm then
    if changeType == EFFECT_RESULT_GAINED then
      LCH.Orphic.DarkImmunityOnAdd(true, unitId)
    elseif changeType == EFFECT_RESULT_FADED then
      LCH.Orphic.DarkImmunityOnAdd(false, unitId)
    end
    


  --Xoryn
  elseif abilityId == data.arcane_knot_debuff then
    if changeType == EFFECT_RESULT_GAINED then
      LCH.status.isArcaneKnot = true
      LCH.status.isKnotActive = true
      LCH.Xoryn.OnKnotPick(endTime)
    elseif changeType == EFFECT_RESULT_FADED then
      LCH.Xoryn.OnKnotDrop()
    end
  elseif abilityId == data.arcane_conveyance_debuff then
    if changeType == EFFECT_RESULT_GAINED then
      LCH.Xoryn.ArcaneConveyanceDebuff(unitTag, true)
    elseif changeType == EFFECT_RESULT_FADED then
      LCH.Xoryn.ArcaneConveyanceDebuff(unitTag, false)
    end
  end
 
end

function LCH.CombatEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
  -- All Trash combat events are handled separately.
  LCH.Trash.CombatEvent(result, abilityId, targetType, targetUnitId, sourceName, hitValue)

  if abilityId == LCH.data.count_ryelaz_sheer and result == ACTION_RESULT_BEGIN then
    LCH.Zilyesset.Sheer()
  elseif abilityId == LCH.data.xoryn_thunder_thrall and result == ACTION_RESULT_BEGIN then
    LCH.Orphic.XorynJump()
  elseif abilityId == LCH.data.xoryn_lightning_flood and result == ACTION_RESULT_BEGIN then
    LCH.Orphic.XorynFlood()
  elseif abilityId == LCH.data.sentinel_shield_throw_cast and result == ACTION_RESULT_BEGIN then
    LCH.Orphic.XorynFlood()
  elseif abilityId == LCH.data.arcane_conveyance_cast and result == ACTION_RESULT_BEGIN then
    LCH.Xoryn.ArcaneConveyanceCast()
  end

  if LCH.status.isOrphicShard then
    if zo_strformat(SI_UNIT_NAME, sourceName) == "Xoryn" then
      if abilityName == "Heavy Shock" then
        df("%d %s %d %d %s", result, abilityName, hitValue, abilityId, targetName)
      end
    end
  end



end

function LCH.UpdateSlowTick(gameTimeMs)
  -- if IsUnitInCombat("player") then
  --   return
  -- end

  -- if LCH.Trash.ShouldDisplayLevers() then
  --   LCH.Trash.RenderLevers()
  -- else
  --   -- TODO: Check how to NOT clear the icons on every iteration just on change.
  --   LCH.Trash.ResetLeversState()
  --   if not LCH.status.stacksUIEnabled and LCH.status.locked then
  --     LCHStatus:SetHidden(true)
  --   end
  -- end
end

function LCH.UpdateTick(gameTimeMs)
  local timeSec = GetGameTimeSeconds()
  -- d(timeSec)

  LCH.Trash.UpdateTick(timeSec)
  LCH.Xoryn.UpdateTick(timeSec)
--  90 60 40 10
  
  -- if IsUnitInCombat("boss1") then
  --   if not LCH.status.inCombat then
  --     -- If it switched from non-combat to combat, re-check boss names.
  --   end
  --   LCH.status.inCombat = true
  -- end
  
  if LCH.status.inCombat then
    if LCH.status.isZilyesset then
      LCH.Zilyesset.UpdateTick(timeSec)
    elseif LCH.status.isCavotAgnan then
      -- LCH.Orphic.UpdateTick(timeSec)
    elseif LCH.status.isOrphicShard then
      LCH.Orphic.UpdateTick(timeSec)
    elseif LCH.status.isXoryn or LCH.status.isKnotActive then
      LCH.Xoryn.UpdateTick(timeSec)
    end
  end

end

function LCH.DeathState(event, unitTag, isDead)
  -- if unitTag == "player" and not isDead and not IsUnitInCombat("boss1") then
  --   -- I just resurrected, and it was a wipe or we killed the boss.
  --   -- Remove all UI
  --   LCH.ClearUIOutOfCombat()
  -- end
  -- TODO: Remove from the list of "players in portal" in boss 1 and boss 2.
end

function LCH.onCombatEnter()
  LCH.status.inCombat = true
  LCH.ResetStatus()
end

function LCH.onCombatLeave()
  LCH.status.inCombat = false
  LCH.status.isKnotActive = false
  LCH.status.isArcaneKnot = false
  LCH.ClearUIOutOfCombat()
end

function LCH.CombatState(eventCode, inCombat)
  -- local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss1", POWERTYPE_HEALTH)
  -- Do not change combat state if you are dead, or the boss is not full.
  -- if
  -- if currentTargetHP < 0.99*maxTargetHP or IsUnitDead("player") then
    -- return
  -- end

  -- -- Do not do anything outside of boss fights.
  -- if maxTargetHP == 0 or maxTargetHP == nil then
  --   LCH.ClearUIOutOfCombat()
  --   return
  -- end
  if inCombat then
    LCH.onCombatEnter()
  else
    LCH.onCombatLeave()
  end
  
  LCH.Xoryn.OnCombatStateChange(LCH.status.lastCombatState, inCombat)
  LCH.status.lastCombatState = inCombat
end

function LCH.ResetStatus()

  LCH.Zilyesset.Reset()
  LCH.Orphic.Reset()
  LCH.Xoryn.Reset()

end

function LCH.GetBossName()
  -- 1 to 6 so far
  for i = 1,MAX_BOSSES do
    local name = string.lower(GetUnitName("boss" .. tostring(i)))
    if name ~= nil and name ~= "" then
      return name
    end
  end
  return ""
end

function LCH.BossesChanged()
  LCH.HandleBossesChanged(LCH.GetBossName())
end

function LCH.HandleBossesChanged(bossName)
	--local bossName = string.lower(GetUnitName("boss1"))
  -- local bossName = LCH.GetBossName()
  local lastBossName = LCH.status.currentBoss
  if bossName == nil then return end

  -- if lastBossName ~= bossName thenwwwwwww
  --   d("boss " .. bossName)
  -- end
  LCH.status.currentBoss = bossName

  LCH.status.isZilyesset = false
  LCH.status.isCavotAgnan = false
  LCH.status.isOrphicShard = false
  LCH.status.isXoryn = false
  LCH.status.isHMBoss = false


  -- LCH.Lylanar.RemoveLylanarPhase3StackIcons()

  -- LCH.Taleria.RemovePivotIcon()
  -- LCH.Taleria.RemoveOppositePivotIcon()
  -- LCH.Taleria.RemoveSlaughterFishIcons()
  -- LCH.Taleria.RemoveStaticPortalStackIcons()
  -- LCH.Taleria.DiscardTaleriaClock()

  local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss1", POWERTYPE_HEALTH)
  local hardmodeHealth = {
    [LCH.data.zilyesset] = 29000000, -- vet both 28M, HM ??M
    [LCH.data.count_ryelaz] = 29000000, -- vet both 28M, HM ??M
    [LCH.data.cavot_agnan] = 42000000,  -- vet 41M, HM ??M
    [LCH.data.orphic_shattered_shard] = 67000000, -- vet 65M HM ??M
    [LCH.data.xoryn] = 60000000, -- vet: 58M HM ??M
  }

  if bossName ~= nil and maxTargetHP ~= nil and hardmodeHealth[bossName] ~= nil then
    if maxTargetHP > hardmodeHealth[bossName] then
      LCH.status.isHMBoss = true
    else
      LCH.status.isHMBoss = false
    end
  end

  if string.match(bossName, LCH.data.zilyesset) or string.match(bossName, LCH.data.count_ryelaz) then
    LCH.status.isZilyesset = true
  elseif string.match(bossName, LCH.data.cavot_agnan) then
    LCH.status.isCavotAgnan = true
  elseif string.match(bossName, LCH.data.orphic_shattered_shard) then
    LCH.status.isOrphicShard = true
    LCH.Orphic.AddMirrorNumbers()
  elseif string.match(bossName, LCH.data.xoryn) then
    LCH.status.isXoryn = true
  else
    -- 
  end

end

function LCH.PlayerActivated()
  -- Disable all visible UI elements at startup.
  --LCH.HideAllUI(true)
  LCH.UnlockUI(false)

  if GetZoneId(GetUnitZoneIndex("player")) ~= LCH.data.lucentCitadelId then
    return
  else
    LCH.units = {}
    LCH.unitsTag = {}
  end
  LCH.LoadSavedMessageFontSize()

  -- Fix for stacks when PTEing with stacks
  -- LCH.status.volatileResidueStacks = 0
  -- LCH.status.buildingStaticStacks = 0

  if not LCH.active and not LCH.savedVariables.hideWelcome then
    d("|cFF6200[LCH] Thanks for using Lucent Citadel Helper " .. LCH.version)
  end
  LCH.active = true
  LCHStatusLabelAddonName:SetText("Lucent Citadel Helper " .. LCH.version)

  EVENT_MANAGER:UnregisterForEvent(LCH.name .. "CombatEvent", EVENT_COMBAT_EVENT )
  EVENT_MANAGER:RegisterForEvent(LCH.name .. "CombatEvent", EVENT_COMBAT_EVENT, LCH.CombatEvent)
  
  -- Bufs/debuffs
  EVENT_MANAGER:UnregisterForEvent(LCH.name .. "Buffs", EVENT_EFFECT_CHANGED )
  EVENT_MANAGER:RegisterForEvent(LCH.name .. "Buffs", EVENT_EFFECT_CHANGED, LCH.EffectChanged)
  
  -- Boss change
  EVENT_MANAGER:UnregisterForEvent(LCH.name .. "BossChange", EVENT_BOSSES_CHANGED, LCH.BossesChanged)
  EVENT_MANAGER:RegisterForEvent(LCH.name .. "BossChange", EVENT_BOSSES_CHANGED, LCH.BossesChanged)
  
  -- Combat state
  EVENT_MANAGER:UnregisterForEvent(LCH.name .. "CombatState", EVENT_PLAYER_COMBAT_STATE , LCH.CombatState)
  EVENT_MANAGER:RegisterForEvent(LCH.name .. "CombatState", EVENT_PLAYER_COMBAT_STATE , LCH.CombatState)
  
  -- Death state
  EVENT_MANAGER:UnregisterForEvent(LCH.name .. "DeathState", EVENT_UNIT_DEATH_STATE_CHANGED , LCH.DeathState)
  EVENT_MANAGER:RegisterForEvent(LCH.name .. "DeathState", EVENT_UNIT_DEATH_STATE_CHANGED , LCH.DeathState)
  
  -- Ticks
  EVENT_MANAGER:RegisterForUpdate(LCH.name.."UpdateTick", 
    1000/10, function(gameTimeMs) LCH.UpdateTick(gameTimeMs) end)
  EVENT_MANAGER:RegisterForUpdate(LCH.name.."UpdateSlowTick", 
    1000, function(gameTimeMs) LCH.UpdateSlowTick(gameTimeMs) end)
end

function LCH.OnAddonLoaded(event, addonName)
	if addonName ~= LCH.name then
		return
	end

  LCH.savedVariables = ZO_SavedVars:NewAccountWide("LucentCitadelHelperSavedVariables", 2, nil, LCH.settings)
  LCH.RestorePosition()
  LCH.Menu.AddonMenu()
  SLASH_COMMANDS["/LCH"] = LCH.CommandLine
  
	EVENT_MANAGER:UnregisterForEvent(LCH.name, EVENT_ADD_ON_LOADED )
	EVENT_MANAGER:RegisterForEvent(LCH.name .. "PlayerActive", EVENT_PLAYER_ACTIVATED,
    LCH.PlayerActivated)
end

EVENT_MANAGER:RegisterForEvent( LCH.name, EVENT_ADD_ON_LOADED, LCH.OnAddonLoaded )
