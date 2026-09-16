-- A map of `CONFIGNAME` to short, abbreviated Display Names.
-- These names show on the equipped ammo component of the
-- Ranged gauge. Any name not mapped is truncated to the
-- first 3 characters. A complete map of all ammo is planned
-- eventually, but for now the most meta ammo were tracked down.

local ammoNames = {
    ["DINARROW_JAS_DRAGONBANE"]      = "JAS<br>Dragon",
    ["DINARROW_JAS_DEMONBANE"]      = "JAS<br>Demon",
    ["DINARROW_WEN"]                 = "WEN",
    ["DINARROW_BIK"]                 = "BIK",
    ["DINARROW_FUL"]                 = "FUL",
    ["DUNGEON_ULTHVEN_ARROW"]        = "BSA",
    ["WILD_ARROW"]                   = "WILD",
    ["DARK_ARROW"]                   = "DARK",
    ["STALKER_ARROW"]                = "Stalker",
    ["EGWD_BIK_CRITICAL_ARROW"]      = "Death<br>Spore",
    ["SNIPER_BOLTS_O"]               = "Onyx",
    ["SNIPER_BOLTS_O_E"]             = "Onyx<br>(e)",
    ["SNIPER_BOLTS_H"]               = "Hydrix",
    ["SNIPER_BOLTS_H_E"]             = "Hydrix<br>(e)",
    ["TRAIL_GUTHIX_ARROW"]           = "G. Arr",
    ["TRAIL_ZAMORAK_ARROW"]          = "Z. Arr",
    ["TRAIL_SARADOMIN_ARROW"]        = "S. Arr",
    ["NATURE_BOSS_BOLT"]             = "Blight<br>Bolt",
    ["ASC_CRYSTAL_BOLT"]             = "Asc.<br>Bolt",
    ["BSLAY_HYDRIX_BOLT"]            = "Asc.<br>Hydrix",
    ["ICE_ARROW"]                    = "Ice",
    ["BRONZE_ARROW"]                 = "Bronze<br>Arr",
    ["IRON_ARROW"]                   = "Iron<br>Arr",
    ["STEEL_ARROW"]                  = "Steel<br>Arr",
    ["MITHRIL_ARROW"]                = "Mith<br>Arr",
    ["ADAMANT_ARROW"]                = "Addy<br>Arr",
    ["RUNE_ARROW"]                   = "Rune<br>Arr",
    ["DRAGON_ARROW"]                 = "Dragon<br>Arr",
    ["PRIMAL_ARROW"]                 = "Primal<br>Arr",

    ["XBOWS_CROSSBOW_BOLTS_IRON"]                                   = "Iron<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_STEEL"]                                  = "Steel<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_MITHRIL"]                                = "Mith<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_ADAMANTITE"]                             = "Addy<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_RUNITE"]                                 = "Rune<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_PRIMAL"]                                 = "Primal<br>Bolt",
    ["XBOWS_CROSSBOW_BOLTS_ADAMANTITE_TIPPED_RUBY_ENCHANTED"]       = "Ruby<br>(e)",
    ["XBOWS_CROSSBOW_BOLTS_ADAMANTITE_TIPPED_DIAMOND_ENCHANTED"]    = "Dia<br>(e)",
    ["XBOWS_CROSSBOW_BOLTS_RUNITE_TIPPED_DRAGONSTONE_ENCHANTED"]    = "Dstone<br>(e)",
    ["XBOWS_CROSSBOW_BOLTS_RUNITE_TIPPED_ONYX_ENCHANTED"]           = "Onyx<br>(e)",

}

return ammoNames