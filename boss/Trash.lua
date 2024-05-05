LCH = LCH or {}
local LCH = LCH
LCH.Trash = {
  data = {
    darknessOnPlayer = false,
    radiance = {},
  }
}

local data = LCH.Trash.data


function LCH.Trash.Reset()
  data.darknessOnPlayer = false
  data.radiance = {}
  LCHMessage1:SetHidden(true)
  LCHMessage1Label:SetHidden(true)
end

function LCH.Trash.Darkness(active, unitTag)
  if unitTag == "player" then
    data.darknessOnPlayer = active
  elseif active and LCH.savedVariables.showDarknessArrows then
    LCH.AddIcon(unitTag, "LucentCitadelHelper/icons/curse00.dds")
  else
    LCH.RemoveIcon(unitTag)
  end
end

function LCH.Trash.Radiance(isGain, unitId, endTime)
  if isGain then
    data.radiance[unitId] = endTime
  else
    data.radiance[unitId] = nil
  end
end



function LCH.Trash.CombatEvent(result, abilityId, targetType, targetUnitId, sourceName, hitValue)

  if abilityId == LCH.data.necrotic_rain and result == ACTION_RESULT_BEGIN and LCH.savedVariables.showNecroticRain then
    CombatAlerts.Alert("", "Necrotic rain. BLOCK!", 0x0088FFFF, nil, hitValue)
  elseif abilityId == LCH.data.crushing_shards and targetType == COMBAT_UNIT_TYPE_PLAYER and result == ACTION_RESULT_BEGIN then
    CombatAlerts.AlertCast( abilityId, nil, 1500, nil )
  end
  
end

function LCH.Trash.EffectChanged(changeType, abilityId, unitTag, beginTime, endTime)

end



function LCH.Trash.UpdateTick(timeSec)
  if not LCH.status.inCombat then return end
  if data.darknessOnPlayer then
    LCHMessage1Label:SetText("Darkness on you! Cleanse!")
    LCHMessage1:SetHidden(not LCH.savedVariables.showDarknessOnYou)
    LCHMessage1Label:SetHidden(not LCH.savedVariables.showDarknessOnYou)
  else
    LCHMessage1:SetHidden(true)
    LCHMessage1Label:SetHidden(true)
  end

  local n = 0
  local max = 0
  for k,v in pairs(data.radiance) do
    if v < timeSec then
       data.radiance[k] = nil
    else
      if v > max then max = v end
      n = n + 1
    end
  end

  if n > 0 then
    local duration = max - timeSec
    if duration > 0 then
      LCHMessage2Label:SetText(string.format("%d enemy immune %.0f s", n, duration))
      LCHMessage2:SetHidden(not LCH.savedVariables.showRadiance)
      LCHMessage2Label:SetHidden(not LCH.savedVariables.showRadiance)
    else
      LCHMessage2:SetHidden(true)
      LCHMessage2Label:SetHidden(true)
    end
  else
    LCHMessage2:SetHidden(true)
    LCHMessage2Label:SetHidden(true)
  end

end

