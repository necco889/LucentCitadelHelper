LCH = LCH or {}
local LCH = LCH
LCH.Menu = {}

function LCH.Menu.AddonMenu()
  local menuOptions = {
    type         = "panel",
    name         = "Lucent Citadel Helper",
    displayName  = "Lucent Citadel Helper",
    author       = LCH.author,
    version      = LCH.version,
    registerForRefresh  = true,
    registerForDefaults = true,
  }
  local requiresOSI = "Requires Ody Support Icons."
  local dataTable = {
    {
      type = "description",
      text = "Trial timers, alerts and indicators for Lucent Citadel.",
    },
    {
      type = "divider",
    },
    {
      type = "description",
      text = "For mechanics arrows on players for Target, install |cff0000OdySupportIcons|r (optional dependency)",
    },
    {
      type = "divider",
    },
    {
      type    = "checkbox",
      name    = "Unlock UI (you need to be in the trial)",
      default = false,
      getFunc = function() return not LCH.status.locked end,
      setFunc = function( newValue ) LCH.UnlockUI(newValue) end,
    },
    {
      type = "description",
      text = "You can also do /LCH lock and /LCH unlock to reposition the UI.",
    },
    {
      type    = "button",
      name    = "Reset to default position",
      func = function() LCH.DefaultPosition()  end,
      warning = "Requires /reloadui for the position to reset",
    },
    {
      type    = "checkbox",
      name    = "Hide welcome text on chat",
      default = false,
      getFunc = function() return LCH.savedVariables.hideWelcome end,
      setFunc = function( newValue ) LCH.savedVariables.hideWelcome = newValue end,
    },
    {
      type = "divider",
    },
    {
      type = "header",
      name = "Ryelaz & Zilyesset",
      reference = "ZilyessetHeader"
    },
    {
      type    = "checkbox",
      name    = "Alert: Meteors",
      default = true,
      getFunc = function() return LCH.savedVariables.showSheerAlert end,
      setFunc = function(newValue) LCH.savedVariables.showSheerAlert = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Beam on you (debuff adds)",
      default = true,
      getFunc = function() return LCH.savedVariables.showBeamOnYou end,
      setFunc = function(newValue) LCH.savedVariables.showBeamOnYou = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Show HP difference",
      default = true,
      getFunc = function() return LCH.savedVariables.showBossHpDiff end,
      setFunc = function(newValue) LCH.savedVariables.showBossHpDiff = newValue end,
    },
    
    -- {
    --   type = "divider",
    -- },
    -- {
    --   type = "header",
    --   name = "Cavot Agnan",
    --   reference = "CavotAgnanHeader"
    -- },
    {
      type = "divider",
    },
    {
      type = "header",
      name = "Orphic Shattered Shard",
      reference = "OrphicHeader"
    },
    {
      type    = "checkbox",
      name    = "Panel: Show mirror numbers",
      default = true,
      getFunc = function() return LCH.savedVariables.showmirrorNumberIcons end,
      setFunc = function(newValue) LCH.savedVariables.showmirrorNumberIcons = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Show boss color",
      default = true,
      getFunc = function() return LCH.savedVariables.showBossColor end,
      setFunc = function(newValue) LCH.savedVariables.showBossColor = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Mirror drain tracker",
      default = true,
      getFunc = function() return LCH.savedVariables.showMirrorDrain end,
      setFunc = function(newValue) LCH.savedVariables.showMirrorDrain = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Show light adds counter",
      default = true,
      getFunc = function() return LCH.savedVariables.showLightAddsNum end,
      setFunc = function(newValue) LCH.savedVariables.showLightAddsNum = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Show dark adds counter",
      default = true,
      getFunc = function() return LCH.savedVariables.showDarkAddsNum end,
      setFunc = function(newValue) LCH.savedVariables.showDarkAddsNum = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Xoryn jump tracker",
      default = true,
      getFunc = function() return LCH.savedVariables.showXorynJumpTimer end,
      setFunc = function(newValue) LCH.savedVariables.showXorynJumpTimer = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Xoryn jumping",
      default = true,
      getFunc = function() return LCH.savedVariables.showXorynJumpAlert end,
      setFunc = function(newValue) LCH.savedVariables.showXorynJumpAlert = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Xoryn flood tracker",
      default = true,
      getFunc = function() return LCH.savedVariables.showXorynFloodTimer end,
      setFunc = function(newValue) LCH.savedVariables.showXorynFloodTimer = newValue end,
    },
    {
      type    = "checkbox",
      name    = "(healer only) Icon on tank: Hindered",
      default = true,
      getFunc = function() return LCH.savedVariables.showHinderedIcon end,
      setFunc = function(newValue) LCH.savedVariables.showHinderedIcon = newValue end,
      warning = requiresOSI
    },
    
    {
      type = "divider",
    },
    {
      type = "header",
      name = "Arcane Knot",
      reference = "ArcaneKnotHeader"
    },
    {
      type    = "checkbox",
      name    = "Panel: Knot drop timer",
      default = true,
      getFunc = function() return LCH.savedVariables.showKnotDropTimer end,
      setFunc = function(newValue) LCH.savedVariables.showKnotDropTimer = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Pick up knot",
      default = true,
      getFunc = function() return LCH.savedVariables.showPickUpKnotAlert end,
      setFunc = function(newValue) LCH.savedVariables.showPickUpKnotAlert = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Knot dropping in",
      default = true,
      getFunc = function() return LCH.savedVariables.showKnotDroppingIn end,
      setFunc = function(newValue) LCH.savedVariables.showKnotDroppingIn = newValue end,
    },
    {
      type = "slider",
      name = "Knot dropping in... alert length",
      min = 0,
      max = 10,
      step = 1,
      default = 3,
      getFunc = function() return LCH.savedVariables.showKnotDroppingInLen end,
      setFunc = function(newValue) LCH.savedVariables.showKnotDroppingInLen = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Knot counter",
      default = true,
      getFunc = function() return LCH.savedVariables.showKnotCounter end,
      setFunc = function(newValue) LCH.savedVariables.showKnotCounter = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Arcane conveyance incoming",
      default = true,
      getFunc = function() return LCH.savedVariables.showArcaneConveyanceIncoming end,
      setFunc = function(newValue) LCH.savedVariables.showArcaneConveyanceIncoming = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Arcane conveyance on you",
      default = true,
      getFunc = function() return LCH.savedVariables.showArcaneConveyanceOnYou end,
      setFunc = function(newValue) LCH.savedVariables.showArcaneConveyanceOnYou = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Alert: Arcane conveyance on (targets)",
      default = true,
      getFunc = function() return LCH.savedVariables.showArcaneConveyanceOnTargets end,
      setFunc = function(newValue) LCH.savedVariables.showArcaneConveyanceOnTargets = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Weakening charge tracker",
      default = true,
      getFunc = function() return LCH.savedVariables.showWeakeningCharge end,
      setFunc = function(newValue) LCH.savedVariables.showWeakeningCharge = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Panel: Accelerating charge cast tracker",
      default = true,
      getFunc = function() return LCH.savedVariables.showAcceleratingCharge end,
      setFunc = function(newValue) LCH.savedVariables.showAcceleratingCharge = newValue end,
    },

    {
      type = "divider",
    },
    {
      type = "header",
      name = "Trash",
      reference = "LucentCitadelTrashHeader"
    },
    {
      type    = "checkbox",
      name    = "Darkness notification on you",
      default = true,
      getFunc = function() return LCH.savedVariables.showDarknessOnYou end,
      setFunc = function(newValue) LCH.savedVariables.showDarknessOnYou = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Darkness arrows on others",
      default = true,
      getFunc = function() return LCH.savedVariables.showDarknessArrows end,
      setFunc = function(newValue) LCH.savedVariables.showDarknessArrows = newValue end,
      warning = requiresOSI
    },
    {
      type    = "checkbox",
      name    = "Necrotic rain alert",
      default = true,
      getFunc = function() return LCH.savedVariables.showNecroticRain end,
      setFunc = function(newValue) LCH.savedVariables.showNecroticRain = newValue end,
    },
    {
      type    = "checkbox",
      name    = "Radiance (immune to damage)",
      default = true,
      getFunc = function() return LCH.savedVariables.showRadiance end,
      setFunc = function(newValue) LCH.savedVariables.showRadiance = newValue end,
    },
    {
      type = "divider",
    },
    {
      type = "header",
      name = "Misc",
      reference = "LucentCitadelMiscMenu"
    },
    {
      type = "description",
      text = "NOT recommended to change. Unlock UI first to be able to change scale.",
    },
    {
      type    = "slider",
      name    = "Scale",
      min = 0.2,
      max = 2.5,
      step = 0.1,
      decimals = 1,
      tooltip = "0.5 is tiny, 2 is huge",
      default = LCH.savedVariables.uiCustomScale,
      disabled = function() return LCH.status.locked end,
      getFunc = function() return LCH.savedVariables.uiCustomScale end,
      setFunc = function(newValue) LCH.SetScale(newValue) end,
      warning = "Only for extreme resolutions. Addon optimized for scale=1."
    },
    {
      type    = "slider",
      name    = "Notification font size",
      min = 28,
      max = 144,
      step = 2,
      decimals = 0,
      default = LCH.savedVariables.messageFontSize,
      getFunc = function() return LCH.savedVariables.messageFontSize end,
      setFunc = function(newValue) LCH.SetMessageFontSize(newValue) end,
    },
  }

  LAM = LibAddonMenu2
  LAM:RegisterAddonPanel(LCH.name .. "Options", menuOptions)
  LAM:RegisterOptionControls(LCH.name .. "Options", dataTable)
end