
---This table represents currently loaded data.  This tracks the game's state, and gets saved to the datastore. 
---Game data is scoped to a current loaded game, or one loaded save slot. This includes things like player stats, checkpoint, etc.
---Global data is saved globally, independent of save slot.  This will include settings data or global unlocks (extras, etc). 
DATA = {
    GAME = {
        Checkpoint = CHECKPOINT.START,
        Name = "Jordan",
        Version = 1,
        HasWeaponSelector = false,
        HasLaser = false,
        HasMine = false,
        HasMissile = false,
        HasEmp = false,
        HasShield = false,
        HasExtendedEnergyRegen  = false,
        HasHealthRegen = false,
        HasDoubleBullets = false,
        HasExtraDodges = false
    },
    GLOBAL = {
        Version = 1
    }
}

-- This is the player's selected save slot, which can only be changed from the main menu.
SAVE_SLOT = 1

--[[
    This is used just in case in the future we need to check some sorta compatibility thing.
    It might not ever get used but it should be bumped up each time more fields are added to the game data. 
]]
DATA_VERSION = 1