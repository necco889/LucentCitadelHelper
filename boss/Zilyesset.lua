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
  if LCH.savedVariables.showSheerAlert then
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

end

