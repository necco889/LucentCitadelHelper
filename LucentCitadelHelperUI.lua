LCH = LCH or {}
local LCH = LCH

function LCH.OnLCHMessage1Move()
  LCH.savedVariables.message1Left = LCHMessage1:GetLeft()
  LCH.savedVariables.message1Top = LCHMessage1:GetTop()
end

function LCH.OnLCHMessage2Move()
  LCH.savedVariables.message2Left = LCHMessage2:GetLeft()
  LCH.savedVariables.message2Top = LCHMessage2:GetTop()
end

function LCH.OnLCHMessage3Move()
  LCH.savedVariables.message3Left = LCHMessage3:GetLeft()
  LCH.savedVariables.message3Top = LCHMessage3:GetTop()
end

function LCH.OnLCHStatusMove()
  LCH.savedVariables.statusLeft = LCHStatus:GetLeft()
  LCH.savedVariables.statusTop = LCHStatus:GetTop()
end

function LCH.DefaultPosition()
  LCH.savedVariables.message1Left = nil
  LCH.savedVariables.message1Top = nil
  LCH.savedVariables.message2Left = nil
  LCH.savedVariables.message2Top = nil
  LCH.savedVariables.message3Left = nil
  LCH.savedVariables.message3Top = nil
  LCH.savedVariables.statusLeft = nil
  LCH.savedVariables.statusTop = nil
end

function LCH.RestorePosition()
  if LCH.savedVariables.message1Left ~= nil then
    LCHMessage1:ClearAnchors()
    LCHMessage1:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,
        LCH.savedVariables.message1Left,
        LCH.savedVariables.message1Top)
  end
  
  if LCH.savedVariables.message2Left ~= nil then
    LCHMessage2:ClearAnchors()
    LCHMessage2:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,
        LCH.savedVariables.message2Left,
        LCH.savedVariables.message2Top)
  end

  if LCH.savedVariables.message3Left ~= nil then
    LCHMessage3:ClearAnchors()
    LCHMessage3:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,
        LCH.savedVariables.message3Left,
        LCH.savedVariables.message3Top)
  end


  if LCH.savedVariables.statusLeft ~= nil then
    LCHStatus:ClearAnchors()
    LCHStatus:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,
        LCH.savedVariables.statusLeft,
        LCH.savedVariables.statusTop)
  end

  
end


function LCH.UnlockUI(unlock)
  LCH.status.locked = not unlock
  LCH.HideAllUI(not unlock)
  LCHMessage1:SetMouseEnabled(unlock)
  LCHMessage2:SetMouseEnabled(unlock)
  LCHMessage3:SetMouseEnabled(unlock)
  LCHStatus:SetMouseEnabled(unlock)
  
  LCHMessage1:SetMovable(unlock)
  LCHMessage2:SetMovable(unlock)
  LCHMessage3:SetMovable(unlock)
  LCHStatus:SetMovable(unlock)
end

function LCH.ClearUIOutOfCombat()

  -- Calls here Hide icons, if needed.

  LCH.ResetStatus()
  LCH.ResetAllPlayerIcons()
  LCH.HideAllUI(true)
  LCH.LoadSavedScale()
  LCH.LoadSavedMessageFontSize()
  LCH.Trash.Reset()
  LCH.Orphic.Reset()
  LCH.Zilyesset.Reset()
  LCH.Xoryn.Reset()
end

function LCH.HideAllUI(hide)
  LCHMessage1:SetHidden(hide)
  LCHMessage2:SetHidden(hide)
  LCHMessage3:SetHidden(hide)
  LCHStatus:SetHidden(hide)
  LCHScreenBorder:SetHidden(true) -- do NOT want to display it on unlock.
  
  -- Generic
  LCHStatusLabelTop:SetHidden(hide)


  -- Zilyesset
  LCHStatusLabelBossHpDiff:SetHidden(hide)
  LCHStatusLabelBossHpDiffValue:SetHidden(hide)


  -- Orphic
  LCHStatusLabelBossColor:SetHidden(hide)
  LCHStatusLabelBossColorValue:SetHidden(hide)
  LCHStatusLabelMirrorDrain:SetHidden(hide)
  LCHStatusLabelMirrorDrainValue:SetHidden(hide)

  LCHStatusLabelLightAdds:SetHidden(hide)
  LCHStatusLabelLightAddsValue:SetHidden(hide)
  LCHStatusLabelDarkAdds:SetHidden(hide)
  LCHStatusLabelDarkAddsValue:SetHidden(hide)
  LCHStatusLabelXorynJump:SetHidden(hide)
  LCHStatusLabelXorynJumpValue:SetHidden(hide)
  LCHStatusLabelXorynFlood:SetHidden(hide)
  LCHStatusLabelXorynFloodValue:SetHidden(hide)



  -- Arcane Knot
  LCHStatusLabelKnotTimer:SetHidden(hide)
  LCHStatusLabelKnotTimerValue:SetHidden(hide)
  LCHStatusLabelKnotCounter:SetHidden(hide)
  LCHStatusLabelKnotCounterValue:SetHidden(hide)

  -- Xoryn
  LCHStatusLabelWeakeningCharge:SetHidden(hide)
  LCHStatusLabelWeakeningChargeValue:SetHidden(hide)
  LCHStatusLabelAcceleratingCharge:SetHidden(hide)
  LCHStatusLabelAcceleratingChargeValue:SetHidden(hide)

end


function LCH.CommandLine(param)
  local help = "[LCH] Usage: /LCH {lock,unlock}"
  if param == nil or param == "" then
    d(help)
  elseif param == "lock" then
    LCH.Lock()
  elseif param == "unlock" then
    LCH.Unlock()
  else
    d(help)
  end
end

function LCH.Lock()
  LCH.UnlockUI(false)
end

function LCH.Unlock()
  LCH.UnlockUI(true)
end

function LCH.LoadSavedScale()
  LCH.SetScale(LCH.savedVariables.uiCustomScale)
end

-- Caled when sliding the menu slider.
function LCH.SetScale(scale)
  LCH.savedVariables.uiCustomScale = scale

  -- Updating top controls scales all children.
  LCHStatus:SetScale(LCH.savedVariables.uiCustomScale)
  LCHMessage1:SetScale(LCH.savedVariables.uiCustomScale)
  LCHMessage2:SetScale(LCH.savedVariables.uiCustomScale)
  LCHMessage3:SetScale(LCH.savedVariables.uiCustomScale)
  end

function LCH.LoadSavedMessageFontSize()
  LCH.SetMessageFontSize(LCH.savedVariables.messageFontSize)
end

-- Caled when sliding the font size slider.
function LCH.SetMessageFontSize(size)
  LCH.savedVariables.messageFontSize = size
  local font = "$(BOLD_FONT)|" .. tostring(size) .. "|soft-shadow-thick"

  LCHMessage1Label:SetFont(font)
  LCHMessage2Label:SetFont(font)
  LCHMessage3Label:SetFont(font)

end