LCH = LCH or {}
local LCH = LCH
LCH.Zilyesset = {

  data = {
    sheerCastAt = 0,
  }

}

local data = LCH.data



function LCH.Zilyesset.Reset()
  data.sheerCastAt = 0
end

function LCH.Zilyesset.Sheer()
  if LCH.savedVariables.showSheerAlert and 
    LCH.IsPlayerInBox(LCH.data.light_side_min_x, LCH.data.light_side_max_x,
                      LCH.data.light_side_min_z, LCH.data.light_side_max_z) then

    CombatAlerts.Alert("", "Meteors incoming", 0x00FF00FF, nil, 1500)

    -- first hit: 4s after cast
    -- second hit: 8 sec after cast

    zo_callLater(function() 
        CombatAlerts.AlertCast( LCH.data.count_ryelaz_sheer, "Meteors", 1500, { 300, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
      end, 4000-2000)

    zo_callLater(function() 
        CombatAlerts.AlertCast( LCH.data.count_ryelaz_sheer, "Meteors", 1500, { 300, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
      end, 8000-2000)
  end
end

function LCH.Zilyesset.Beam()
  if LCH.savedVariables.showBeamOnYou then
    CombatAlerts.Alert("", "Beam: debuff adds", 0xFFFFFFFF, nil, 2000)
  end
end

function LCH.Zilyesset.UpdateTick(timeSec)
  local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss1", POWERTYPE_HEALTH)
  local boss1HpPercent = 0
  if currentTargetHP and maxTargetHP then
    boss1HpPercent = 100 * currentTargetHP / maxTargetHP
  end
  
  currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss2", POWERTYPE_HEALTH)
  local boss2HpPercent = 0
  if currentTargetHP and maxTargetHP then
    boss2HpPercent = 100 * currentTargetHP / maxTargetHP
  end

  local diff = boss1HpPercent - boss2HpPercent
  if diff ~= diff then
    diff = 0
  end
  LCHStatusLabelBossHpDiffValue:SetText(string.format("%.0f pp", diff))


  -- Display UI elements needed for this boss.
  LCHStatus:SetHidden(false)
  LCHStatusLabelBossHpDiff:SetHidden(not LCH.savedVariables.showBossHpDiff)
  LCHStatusLabelBossHpDiffValue:SetHidden(not LCH.savedVariables.showBossHpDiff)


end

