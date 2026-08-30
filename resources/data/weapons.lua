-- I made this before finding out the `combatv2_mainhand_style` varp exists
-- I plan to migrate to combatv2_mainhand_style at some point, as Jagex
-- may decide to add more weapon types in the future -- ie. 2H Necromancy! ;)

local weapons = {
    [id.Category.WEAPON_STAFF]      = "magic",
    [id.Category.WEAPON_ELEMENTAL]  = "magic",
    [id.Category.WEAPON_WAND]       = "magic",

    [id.Category.WEAPON_THROWN]     = "ranged",
    [id.Category.WEAPON_ARTILLERY]  = "ranged",
    [id.Category.WEAPON_CHARGEBOW]  = "ranged",
    [id.Category.WEAPON_GRENADE]    = "ranged",
    [id.Category.WEAPON_JAVELIN]    = "ranged",
    [id.Category.WEAPON_XBOW]       = "ranged",
    [id.Category.WEAPON_BOW]        = "ranged",
    [id.Category.WEAPON_2HXBOW]     = "ranged",
    [id.Category.WEAPON_THROWNDART] = "ranged",
    [id.Category.WEAPON_THROWNAXE]  = "ranged",
    [id.Category.WEAPON_THROWNKNIFE] = "ranged",
    [id.Category.WEAPON_BLOWPIPE]   = "ranged",

    [id.Category.WEAPON_HACKSWORD]  = "melee",
    [id.Category.WEAPON_STABSWORD]  = "melee",
    [id.Category.WEAPON_BLUNT]      = "melee",
    [id.Category.WEAPON_AXE]        = "melee",
    [id.Category.WEAPON_SPEAR]      = "melee",
    [id.Category.WEAPON_SPIKED]     = "melee",
    [id.Category.WEAPON_BANNER]     = "melee",
    [id.Category.WEAPON_FUN]        = "melee",
    [id.Category.WEAPON_HEAVYSWORD] = "melee",
    [id.Category.WEAPON_CLAW]       = "melee",
    [id.Category.WEAPON_POLEARM]    = "melee",
    [id.Category.WEAPON_PICK]       = "melee",
    [id.Category.WEAPON_WHIP]       = "melee",
    [id.Category.WEAPON_SHORTSWORD] = "melee",
    [id.Category.WEAPON_LONGSWORD]  = "melee",
    [id.Category.WEAPON_WARHAMMER]  = "melee",
    [id.Category.WEAPON_BATTLEAXE]  = "melee",
    [id.Category.WEAPON_DAGGER]     = "melee",
    [id.Category.WEAPON_SCIMITAR]   = "melee",
    [id.Category.WEAPON_MACE]       = "melee",
    [id.Category.WEAPON_2HSWORD]    = "melee",
    [id.Category.WEAPON_MAUL]       = "melee",
    [id.Category.WEAPON_CLAWS]      = "melee",
    [id.Category.WEAPON_2H_SWORD]   = "melee",
    [id.Category.WEAPON_PICKAXE]    = "melee",
    [id.Category.WEAPON_HALBERD]    = "melee",
    [id.Category.WEAPON_MATTOCK]    = "melee",

    [id.Category.WEAPON_ARMGUARD]   = "necromancy",
}

return weapons