LCH = LCH or {}
local LCH = LCH
LCH.Xoryn = {
  data = {
    knot_active = false,
    knot_will_drop_at = 0,
    knot_counter = 0,
    knot_dropped = false,
    arcane_conveyance_casted_at = 0,
    arcane_conveyance_on_player = false,
    arcane_conveyance_on_player_at = 0,
    -- boss_is_light_colored = true,
    -- mirror_drain_endtime = 0,
    -- mirror_drain_stacks = 0,
    -- mirrorNumberIcons = {}
  },
}

local data = LCH.Xoryn.data

-- function LCH.Xoryn.Sheer()

--   -- CombatAlerts.Alert("", "Meteors incoming", 0x00FF00FF, nil, 1500)
--   -- CombatAlerts.AlertCast( LCH.data.count_ryelaz_sheer, "Meteors", 1500, nil )
-- end


function LCH.Xoryn.OnCombatStateChange(old, new)
  if old and not new then
    LCH.Xoryn.Reset()
  end
end

function LCH.Xoryn.Reset()
  if LCH.status.inCombat and LCH.status.isKnotActive then
    -- called on combat start. but knot is picked up out of combat already
  else
    data.knot_active = false
    data.knot_will_drop_at = 0
    data.knot_counter = 0
    data.knot_dropped = false
  end

  data.arcane_conveyance_casted_at = 0
  data.arcane_conveyance_on_player_at = 0

end


function LCH.Xoryn.OnKnotPick(endTime)
  data.knot_active = true
  data.knot_will_drop_at = endTime
  data.knot_counter = data.knot_counter + 1
  data.knot_dropped = false
end


function LCH.Xoryn.OnKnotDrop()
  data.knot_will_drop_at = 0
  data.knot_dropped = true
end

function LCH.Xoryn.ArcaneConveyanceCast()
  data.arcane_conveyance_casted_at = GetGameTimeSeconds()
end

function LCH.Xoryn.ArcaneConveyanceDebuff(unitTag, isGain)
  if unitTag == "player" then
    data.arcane_conveyance_on_player = isGain
    data.arcane_conveyance_on_player_at = GetGameTimeSeconds()
  end
end


function LCH.Xoryn.UpdateTick(timeSec)

  if not LCH.status.isArcaneKnot then return end

  local dropsIn = data.knot_will_drop_at - timeSec
  if dropsIn < 0 then dropsIn = 0 end

  LCHStatusLabelKnotTimerValue:SetText(string.format("%.0f s", dropsIn))
  LCHStatusLabelKnotCounterValue:SetText(tostring(data.knot_counter))

  if data.knot_counter > 0 and data.knot_dropped then
    LCHMessage1Label:SetText("Pick up knot!")
    LCHMessage1:SetHidden(not LCH.savedVariables.showPickUpKnotAlert)
    LCHMessage1Label:SetHidden(not LCH.savedVariables.showPickUpKnotAlert)
  else
    LCHMessage1:SetHidden(true)
    LCHMessage1Label:SetHidden(true)
  end


  local arcane_conveyance_in = 7 - (timeSec - data.arcane_conveyance_casted_at)
  if data.arcane_conveyance_on_player then
    local debuffTimer = 10 - (timeSec - data.arcane_conveyance_on_player_at)
    if debuffTimer > 0 then
      LCHMessage2Label:SetText("Arcane Conveyance on you! " .. string.format("%.0f s", debuffTimer))
      LCHMessage2:SetHidden(not LCH.savedVariables.showArcaneConveyanceOnYou)
      LCHMessage2Label:SetHidden(not LCH.savedVariables.showArcaneConveyanceOnYou)
    else
      LCHMessage2:SetHidden(true)
      LCHMessage2Label:SetHidden(true)
    end
  elseif arcane_conveyance_in > 0 and arcane_conveyance_in < 7 then
    LCHMessage2Label:SetText("Arcane Conveyance in " .. string.format("%.0f s", arcane_conveyance_in))
    LCHMessage2:SetHidden(not LCH.savedVariables.showArcaneConveyanceIncoming)
    LCHMessage2Label:SetHidden(not LCH.savedVariables.showArcaneConveyanceIncoming)
  else
    LCHMessage2:SetHidden(true)
    LCHMessage2Label:SetHidden(true)
  end


  -- Display UI elements needed for this boss.
  LCHStatus:SetHidden(false)
  LCHStatusLabelKnotTimer:SetHidden(not LCH.savedVariables.showKnotDropTimer)
  LCHStatusLabelKnotTimerValue:SetHidden(not LCH.savedVariables.showKnotDropTimer)
  LCHStatusLabelKnotCounter:SetHidden(not LCH.savedVariables.showKnotCounter)
  LCHStatusLabelKnotCounterValue:SetHidden(not LCH.savedVariables.showKnotCounter)

end

