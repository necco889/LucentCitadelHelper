LCH = LCH or {}
local LCH = LCH

LCH.data    = {


  -- lucentCitadelId = 1478,
  lucentCitadelId = 1233, --alpine gallery


  --Trash
  darkness_inflicted = 214338,
  necrotic_rain = 222809,

  --Zilyesset
  count_ryelaz_sheer = 218274,    --meteors
  bleak_lusterbeam = 214254,      --debuff adds on rakkat side
  brilliant_lusterbeam = 214237,  --debuff adds on scorpion side

  -- bounds of light side
  -- up   right 127997 33500 130624
  -- down right 128367 33500 133738
  -- up   left  122049 33500 130710
  -- down left  122234 33500 133954
  light_side_min_x =  122234,
  light_side_max_x =  122234,
  light_side_min_z =  130624,
  light_side_max_z =  133954,

  -- Orphic Shard
  mirror_drain = 214784,
  orphic_boss_light_imm = 219444,
  orphic_boss_dark_imm = 219447,
  orphic_adds_light_imm = 213620,
  orphic_adds_dark_imm = 219424,
  xoryn_thunder_thrall = 214383,
  xoryn_lightning_flood = 214355,
  sentinel_shield_throw_cast = 221945,


  -- last phase
  arcane_conveyance_cast = 223024,
  arcane_conveyance_debuff = 223060,


  orphic_mirror_positions = {
    [1] = {147571, 22870+300, 89693},
    [2] = {146992, 22872+300, 87951},
    [3] = {147653, 22871+300, 86322},
    [4] = {149289, 22874+300, 85795},
    [5] = {150906, 22871+300, 86391},
    [6] = {151599, 22871+300, 87946},
    [7] = {150981, 22866+300, 89521},
    [8] = {149312, 22873+300, 90261},


    --debug alpine gallery
    -- [1] = {165915, 28225+300, 156701+1*150},
    -- [2] = {165915, 28225+300, 156701+2*150},
    -- [3] = {165915, 28225+300, 156701+3*150},
    -- [4] = {165915, 28225+300, 156701+4*150},
    -- [5] = {165915, 28225+300, 156701+5*150},
    -- [6] = {165915, 28225+300, 156701+6*150},
    -- [7] = {165915, 28225+300, 156701+7*150},
    -- [8] = {165915, 28225+300, 156701+8*150},



  },


  -- Xoryn
  arcane_knot_debuff = 213477,

    -- Boss names.
  -- String lower, to make sure changes here keep strings in lowercase.
  zilyesset = string.lower("Zilyesset"),
  count_ryelaz = string.lower("Count Ryelaz"),
  cavot_agnan = string.lower("Cavot Agnan"),
  orphic_shattered_shard = string.lower("Orphic Shattered Shard"),
  xoryn = string.lower("Xoryn"),

  --default_color = { 1, 0.7, 0, 0.5 },
  dodgeDuration = GetAbilityDuration(28549),
  maxDuration = 4000,
  holdBlock = "Hold Block!",
  

  -- Taunt
  innerRage = 42056,
  pierceArmor = 38250,

  -- Testing/debugging values.
  olms_swipe = 95428,
}