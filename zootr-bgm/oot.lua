-- Ocarina of Time memory functions
-- Used to read or write values in the game memory

local BGM = require('zootr-bgm/bgm')
local SEQ = BGM.getIdToSequenceMap()

local OOT = {}

-- Clear flags (converted from binary)
FLAG_OCARINA_GAME_CLEAR = 0x80
FLAG_DARK_LINK_CLEAR = 0x2000
FLAG_NABOORU_CLEAR = 0x2
FLAG_BIG_OCTO_CLEAR = 0x40

-- Explicit known game state values
VALUE_AGE_CHILD = 0x1
VALUE_AGE_ADULT = 0x0
VALUE_MENU_CLOSED = 0x0

-- Exact times (the game uses these for events, versus the BGM start times which are just for music)
TIME_DAY_START = 0x4555
TIME_DAY_END = 0xC000
TIME_NIGHT_START = 0xC001
TIME_NIGHT_END = 0x4554

-- Gets the current sequence ID from memory
function OOT.getCurrentBGM()
    local current_bgm = mainmemory.read_u8(0x124E55)
    return current_bgm
end

-- Overwrites the current sequence ID in memory
function OOT.setCurrentBGM(value)
    mainmemory.write_u8(0x124E55, value)
end

-- Gets the sequence ID associated with the current scene from memory
function OOT.getCurrentSceneBGM()
    local current_scene_bgm = mainmemory.read_u8(0x1C8C44)
    return current_scene_bgm
end

function OOT.setCurrentSceneBGM(value)
    mainmemory.write_u8(0x1C8C44, value)
end

function OOT.getLastFanfare()
    local last_queued_fanfare = mainmemory.read_u8(0x121F0D)
    return last_queued_fanfare
end

-- Overwrites the currently playing sequence ID in memory, muting the current BGM in the process
function OOT.setCurrentlyPlayingBGM(value)
    mainmemory.write_u8(0x128B64, value)
end

-- Checks if the start menu is in any state other than closed
function OOT.isStartMenuOpen()
    local menu_state = mainmemory.read_u8(0x1D8DD5)
    return menu_state > VALUE_MENU_CLOSED
end

-- Gets the current scene number
function OOT.getScene()
    return mainmemory.read_u8(0x1C8545)
end

-- Gets the current room number
function OOT.getRoom()
    return mainmemory.read_u8(0x1DA15C)
end

-- Returns whether or not any enemies are remaining in the current room.
-- May not count some enemies, usually ones like special minibosses (Nabooru, Dark Link, etc.)
function OOT.isGenericMiniBossRoomClear()
    local enemy_count = mainmemory.read_u8(0x1CA0FB)
    return enemy_count == 0
end

-- Returns how many rupees (as in physical gems, not their monetary value) are left in Zora Diving
function OOT.isZoraDivingClear()
    local minigame_rupee_count = mainmemory.read_u8(0x0EAB6E)
    return minigame_rupee_count == 0
end

-- Gets "clear" flags as interpreted in the debug ROM
function getClearFlags(row)
    if (row == 2) then
        return mainmemory.read_u16_be(0x1CA1DC)
    else
        return mainmemory.read_u16_be(0x1CA1DE)
    end
end

-- Gets "temp_clear" flags as interpreted in the debug ROM
function getTempClearFlags(row)
    if (row == 2) then
        return mainmemory.read_u16_be(0x1CA1E0)
    else
        return mainmemory.read_u16_be(0x1CA1E2)
    end
end

-- Gets "item_get_inf" flags as interpreted in the debug ROM
function getItemGetInfFlags(row)
    if (row == 2) then
        return mainmemory.read_u16_be(0x11B4C2)
    else
        return mainmemory.read_u16_be(0x11B4C0)
    end
end

-- Checks if the item was obtained from the Lost Woods ocarina game
function OOT.isOcarinaGameClear()
    local item_get_inf_flags = getItemGetInfFlags(2)
    local ocarina_game_flag_value = UTIL.bitoper(item_get_inf_flags, FLAG_OCARINA_GAME_CLEAR, 'AND')
    return ocarina_game_flag_value ~= 0
end

-- Checks if the Dark Link room has been cleared
function OOT.isDarkLinkRoomClear()
    local clear_flags = getClearFlags()
    local dark_link_flag_value = UTIL.bitoper(clear_flags, FLAG_DARK_LINK_CLEAR, 'AND')
    return dark_link_flag_value ~= 0
end

-- Checks if the Iron Knuckle room before Twinrova has been cleared
function OOT.isNabooruRoomClear()
    local clear_flags = getTempClearFlags()
    local nabooru_flag_value = UTIL.bitoper(clear_flags, FLAG_NABOORU_CLEAR, 'AND')
    return nabooru_flag_value ~= 0
end

-- Checks if the Big Octo room has been cleared
function OOT.isBigOctoRoomClear()
    local clear_flags = getClearFlags()
    local big_octo_flag_value = UTIL.bitoper(clear_flags, FLAG_BIG_OCTO_CLEAR, 'AND')
    return big_octo_flag_value ~= 0
end

-- Check against various events run by the game that force the player to relinquish control.
-- Basically, anything the player has to sit and wait for to play out before they can continue.
function OOT.isGameControllingEvent()
    return
        OOT.isWarpingByFoot()
        or OOT.isWarpingBySong()
        or OOT.isCameraEventActive()
end

-- Check if the game is running the warp transition when walking through an entrance/door.
-- Note: Unconfirmed to be what this section of memory represents. May be purely incidental.
function OOT.isWarpingByFoot()
    local is_walk_warp = mainmemory.read_u8(0x11B993)
    return is_walk_warp == 1
end

-- Check if the game is running the warp transition after playing an Ocarina song.
-- Note: Unconfirmed to be what this section of memory represents. May be purely incidental.
function OOT.isWarpingBySong()
    local is_song_warp = mainmemory.read_u8(0x4011EC)
    return is_song_warp == 1
end

function OOT.isWarpingByPlayerEvent()
    return
        OOT.isWarpingByFoot()
        or OOT.isWarpingBySong()
end

-- Check if the game is running an event that controls the camera (Jabu Ruto cutscene, owl flying, etc.)
-- This gets set to 2 sometimes, usually when the game also has to run the door unlock cutscene in a dungeon
-- immediately in succession following the previous event.
-- Note: Unconfirmed to be what this section of memory represents. May be purely incidental.
function OOT.isCameraEventActive()
    local is_song_warp = mainmemory.read_u8(0x1C8C41)
    return is_song_warp > 0
end

-- Checks if the current amount of the fade transition played is less than its final amount
-- Only works for the fade to black/white transition (not the circle or desert transition)
function OOT.isFadeTransitionActive()
    local current_fade_amount = OOT.getCurrentFadeTransitionAmount()
    local max_fade_amount = OOT.getMaxFadeTransitionAmount()
    return
        current_fade_amount > 0
        and current_fade_amount < max_fade_amount
end

function OOT.getCurrentFadeTransitionAmount()
    return mainmemory.read_u8(0x1DA671)
end

function OOT.getMaxFadeTransitionAmount()
    return mainmemory.read_u8(0x11B9E8)
end

function OOT.isFadeTransitionStarting()
    local current_fade_amount = OOT.getCurrentFadeTransitionAmount()
    return current_fade_amount == 0
end

function OOT.isFadeTransitionEnding()
    local current_fade_amount = OOT.getCurrentFadeTransitionAmount()
    local max_fade_amount = OOT.getMaxFadeTransitionAmount()
    return current_fade_amount == max_fade_amount
end

-- Gets the time of day in-game
function OOT.getTime()
    return mainmemory.read_u16_be(0x11A5DC)
end

-- Checks if it's currently daytime as seen by the game's day/night cycle (rooster crowing onwards)
function OOT.isDayTime()
    local time_of_day = OOT.getTime()

    local is_day =
        time_of_day >= TIME_DAY_START
        and time_of_day <= TIME_DAY_END
    return is_day
end

-- Checks if it's currently nighttime as seen by the game's day/night cycle (wolf howling onwards)
function OOT.isNightTime()
    local time_of_day = OOT.getTime()

    local is_night =
        time_of_day >= TIME_NIGHT_START
        or time_of_day <= TIME_NIGHT_END
    return is_night
end

-- Gets the current fanfare sequence ID from memory
function OOT.getCurrentFanfare()
    return mainmemory.read_u8(0x121F0D)
end

-- Gets the player's current health
function OOT.getCurrentPlayerHealth()
    return mainmemory.read_u16_be(0x11A600)
end

-- Checks if the game is in a game over state
function OOT.isGameOver()
    local health = OOT.getCurrentPlayerHealth()
    local fanfare = OOT.getCurrentFanfare()
    local sequence = OOT.getCurrentBGM()

    return
        health == 0
        and UTIL.valueToHexString(fanfare) == SEQ.GAME_OVER
        and UTIL.valueToHexString(sequence) == SEQ.FADE_OUT
end

-- Checks if the game is currently in the escape sequence scenes
function OOT.isEscapeSequence()
    local currentScene = OOT.getScene()

    return
        currentScene == SCENE.TOWER_COLLAPSE.ID
        or currentScene == SCENE.TOWER_EXTERIOR.ID
        or currentScene == SCENE.CASTLE_COLLAPSE.ID
end

-- Gets Link's current age
function OOT.getCurrentPlayerAge()
    return mainmemory.read_u32_be(0x11A5D4)
end

-- Checks if the player is currently young Link
function OOT.isChild()
    return OOT.getCurrentPlayerAge() == VALUE_AGE_CHILD
end

-- Checks if the player is currently adult Link
function OOT.isAdult()
    return OOT.getCurrentPlayerAge() == VALUE_AGE_ADULT
end

return OOT
