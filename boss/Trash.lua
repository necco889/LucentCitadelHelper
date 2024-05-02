LCH = LCH or {}
local LCH = LCH
LCH.Trash = {
  data = {
    darknessOnPlayer = false
  }
}

local data = LCH.Trash.data


function LCH.Trash.Reset()
  data.darknessOnPlayer = false
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


function LCH.Trash.CombatEvent(result, abilityId, targetType, targetUnitId, sourceName, hitValue)

  if result == ACTION_RESULT_BEGIN and abilityId == LCH.data.necrotic_rain and LCH.savedVariables.showNecroticRain then
    CombatAlerts.Alert("", "Necrotic rain. BLOCK!", 0x0088FFFF, nil, hitValue)
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
end

