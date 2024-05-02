LCH = LCH or {}
local LCH = LCH
LCH.Orphic = {
  data = {
    boss_is_light_colored = true,
    mirror_drain_endtime = 0,
    mirror_drain_stacks = 0,
    mirrorNumberIcons = {},
    light_imm_adds = {},
    dark_imm_adds = {},
    num_light_imm_adds = 0,
    num_dark_imm_adds = 0,
    last_jump_at = 0,
    last_flood_at = 0,
  },
}

local data = LCH.Orphic.data

function LCH.Orphic.Reset()
  data.boss_is_light_colored = true
  data.mirror_drain_endtime = 0
  data.mirror_drain_stacks = 0
  data.light_imm_adds = {}
  data.dark_imm_adds = {}
  data.num_light_imm_adds = 0
  data.num_dark_imm_adds = 0
  data.last_jump_at = 0
  data.last_flood_at = 0
  LCH.Orphic.DiscardMirrorNumbers()
end

-- function LCH.Orphic.Sheer()

--   -- CombatAlerts.Alert("", "Meteors incoming", 0x00FF00FF, nil, 1500)
--   -- CombatAlerts.AlertCast( LCH.data.count_ryelaz_sheer, "Meteors", 1500, nil )
-- end


function LCH.Orphic.LightImmunityOnAdd(isGain, unitId)
  if isGain then
    data.light_imm_adds[unitId] = true
  else
    data.light_imm_adds[unitId] = nil
  end
  local n = 0
  for k,v in pairs(data.light_imm_adds) do
    n = n +1
  end
  data.num_light_imm_adds = n
end

function LCH.Orphic.DarkImmunityOnAdd(isGain, unitId)
  if isGain then
    data.dark_imm_adds[unitId] = true
  else
    data.dark_imm_adds[unitId] = nil
  end
  local n = 0
  for k,v in pairs(data.dark_imm_adds) do
    n = n +1
  end
  data.num_dark_imm_adds = n
end


function LCH.Orphic.XorynJump()
  if LCH.savedVariables.showXorynJumpAlert then
    CombatAlerts.Alert("", "Xoryn Jumping", 0x00FF00FF, nil, 1500)
  end
  data.last_jump_at = GetGameTimeSeconds()
end

function LCH.Orphic.XorynFlood()
  CombatAlerts.AlertCast( LCH.data.xoryn_lightning_flood, "Lightning flood", 1500, { 300, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
  data.last_flood_at = GetGameTimeSeconds()
end

function LCH.Orphic.Hindered(result, targetUnitId, hitValue)
  -- EFFECT_GAINED_DURATION 12000
  local isDPS, isHeal, isTank = GetPlayerRoles()
  if isDPS then
    return
  end
  if result == ACTION_RESULT_EFFECT_GAINED_DURATION then
    LCH.AddIconForDuration(
      LCH.GetTagForId(targetUnitId),
      "LucentCitadelHelper/icons/shattered.dds",
      hitValue)
  elseif result == ACTION_RESULT_HEAL_ABSORBED then
    -- TODO: Track how much healing is left.
  elseif result == ACTION_RESULT_EFFECT_FADED then
    LCH.RemoveIcon(LCH.GetTagForId(targetUnitId))
  end
end

function LCH.Orphic.BossColorUpdate(isLight)
  data.boss_is_light_colored = isLight
end

function LCH.Orphic.MirrorDrain(endTime, stack)
  data.mirror_drain_endtime = endTime
  data.mirror_drain_stacks = stack
end


function LCH.Orphic.AddMirrorNumbers()
  if not LCH.hasOSI() or not LCH.savedVariables.showmirrorNumberIcons then
    return
  end
  if LCH.status.mirrorNumberIcons ~= nil and table.getn(LCH.status.mirrorNumberIcons) == 8 then
    -- Already filled.
    return
  end
  for k, v in pairs(LCH.data.orphic_mirror_positions) do
    if v ~= nil and table.getn(v) == 3 then
      -- add icon
      table.insert(data.mirrorNumberIcons,
        OSI.CreatePositionIcon(
          v[1],
          v[2],
          v[3],
          "LucentCitadelHelper/icons/" .. tostring(k) .. ".dds",
          -- OSI.GetIconSize()))
          64))
    end
  end
end

function LCH.Orphic.DiscardMirrorNumbers()
  -- LCH.status.mirrorNumberIcons[1..24] = {}
  LCH.DiscardPositionIconList(data.mirrorNumberIcons)
  data.mirrorNumberIcons = {}
end




function LCH.Orphic.UpdateTick(timeSec)
  local mirrorDrainTime = data.mirror_drain_endtime - timeSec

  local nextJump = 26 - (GetGameTimeSeconds() - data.last_jump_at)
  local nextFlood = 22 - (GetGameTimeSeconds() - data.last_flood_at)

  LCHStatusLabelBossColorValue:SetText(data.boss_is_light_colored and "Light" or "Dark")


  if nextJump > 0 then
    LCHStatusLabelXorynJumpValue:SetText(string.format("%.0fs", nextJump))
  else
    LCHStatusLabelXorynJumpValue:SetText("-")
  end

  if nextFlood > 0 then
    LCHStatusLabelXorynFloodValue:SetText(string.format("%.0fs", nextFlood))
  else
    LCHStatusLabelXorynFloodValue:SetText("-")
  end

  if mirrorDrainTime > 0 then
    LCHStatusLabelMirrorDrainValue:SetText(string.format("%.0fs (%d)", mirrorDrainTime, data.mirror_drain_stacks))
  else
    LCHStatusLabelMirrorDrainValue:SetText("-")
  end

  if data.num_light_imm_adds > 0 then
    LCHStatusLabelLightAddsValue:SetText(tostring(data.num_light_imm_adds))
  else
    LCHStatusLabelLightAddsValue:SetText("-")
  end

  if data.num_dark_imm_adds > 0 then
    LCHStatusLabelDarkAddsValue:SetText(tostring(data.num_dark_imm_adds))
  else
    LCHStatusLabelDarkAddsValue:SetText("-")
  end
  
  -- Display UI elements needed for this boss.
  LCHStatus:SetHidden(false)
  LCHStatusLabelBossColor:SetHidden(not LCH.savedVariables.showBossColor)
  LCHStatusLabelBossColorValue:SetHidden(not LCH.savedVariables.showBossColor)
  LCHStatusLabelMirrorDrain:SetHidden(not LCH.savedVariables.showMirrorDrain)
  LCHStatusLabelMirrorDrainValue:SetHidden(not LCH.savedVariables.showMirrorDrain)

  LCHStatusLabelLightAdds:SetHidden(not LCH.savedVariables.showLightAddsNum)
  LCHStatusLabelLightAddsValue:SetHidden(not LCH.savedVariables.showLightAddsNum)
  LCHStatusLabelDarkAdds:SetHidden(not LCH.savedVariables.showDarkAddsNum)
  LCHStatusLabelDarkAddsValue:SetHidden(not LCH.savedVariables.showDarkAddsNum)
  LCHStatusLabelXorynJump:SetHidden(not LCH.savedVariables.showXorynJumpTimer)
  LCHStatusLabelXorynJumpValue:SetHidden(not LCH.savedVariables.showXorynJumpTimer)
  LCHStatusLabelXorynFlood:SetHidden(not LCH.savedVariables.showXorynFloodTimer)
  LCHStatusLabelXorynFloodValue:SetHidden(not LCH.savedVariables.showXorynFloodTimer)

  -- LCHStatusLabel1:SetHidden(not LCH.savedVariables.showBubbleStacks)
  -- LCHStatusLabel1Value:SetHidden(not LCH.savedVariables.showBubbleStacks)
  -- LCHStatusLabel1Right:SetHidden(not LCH.savedVariables.showBubbleStacks)
  -- LCHStatusLabel1RightValue:SetHidden(not LCH.savedVariables.showBubbleStacks)
  -- LCHStatusLabel4:SetHidden(not LCH.status.isHMBoss)
  -- LCHStatusLabel4Value:SetHidden(not LCH.status.isHMBoss)
  -- LCHStatusLabel4Right:SetHidden(not LCH.status.isHMBoss)
  -- LCHStatusLabel4RightValue:SetHidden(not LCH.status.isHMBoss)
  -- LCHStatusLabel5:SetHidden(not LCH.savedVariables.showHoundsAlive)
  -- LCHStatusLabel5Value:SetHidden(not LCH.savedVariables.showHoundsAlive)
  -- LCHStatusLabel5Right:SetHidden(not LCH.savedVariables.showHoundsAlive)
  -- LCHStatusLabel5RightValue:SetHidden(not LCH.savedVariables.showHoundsAlive)
end

