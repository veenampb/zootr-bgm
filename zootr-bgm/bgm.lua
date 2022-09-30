--[[
    Ocarina of Time BGM functions

    Sequences and IDs are mapped here. This also contains all major functions used to determine
    which properties each BGM has. These properties are used to determine how a BGM should behave
    when the game calls upon it.

    BGM_TABLE is used to identify and assign properties to each of the game's sequences. Certain
    properties are also used to determine the appearance of a sequence's name in the form and the
    ID it references when saving to or importing from a file.
]]--

local BGM = {}

-- Any sequences that are unused, cannot currently be customized, or should outright not be included in the
-- form will have an isSpecial property assigned to them.
local BGM_TABLE = {
    -- Special BGMs
    ['0x00'] = {
        name = 'NULL',
        id = 'NULL',
        isSpecial = true,
        isSilent = true,
    },
    ['0x01'] = {
        name = '[Silence]',
        id = 'SILENCE',
        isSpecial = true,
        isSilent = true,
    },
    ['0xFF'] = {
        name = '[Fade Out]',
        id = 'FADE_OUT',
        isSpecial = true,
        isFadeOut = true,
    },

    -- Special custom BGM used to ignore track changes in certain situations so that we don't outright stop the
    -- player and can resume the previous track if necessary.
    ['0xFE'] = {
        name = 'Pause BGM',
        id = 'PAUSE',
        isSpecial = true,
        isSkip = true,
    },

    -- Main BGMs
    ['0x1E'] = {
        name = 'Title Theme',
        id = 'TITLE',
        doesNotResume = true,
    },
    ['0x57'] = {
        name = 'File Select',
        id = 'MENU',
    },
    ['0x23'] = {
        name = 'Enter Ganondorf',
        id = 'GANONDORF_APPEAR',
        doesNotResume = true,
    },
    ['0x4B'] = {
        name = 'Deku Tree Theme',
        id = 'DEKU_TREE',
        isSpecial = true,
    },
    ['0x4A'] = {
        name = 'Navi the Fairy / Flying',
        id = 'FLYING',
        isSpecial = true,
    },
    ['0x1F'] = {
        name = 'Inside a House',
        id = 'HOUSE',
    },
    ['0x3C'] = {
        name = 'Kokiri Forest',
        id = 'KOKIRI_FOREST',
    },
    ['0x55'] = {
        name = 'Shop',
        id = 'SHOP',
    },
    ['0x1A'] = {
        name = 'Battle / Fish Hooked',
        id = 'BATTLE',
        doesNotResume = true,
    },
    ['0x1C'] = {
        name = 'Inside the Deku Tree / Grotto',
        id = 'GROTTO',
    },
    ['0x1B'] = {
        name = 'Boss Battle',
        id = 'BOSS',
        isBoss = true,
        doesNotResume = true,
    },
    ['0x21'] = {
        name = 'Boss Defeated',
        id = 'BOSS_DEFEATED',
        doesNotResume = true,
    },
    ['0x02'] = {
        name = 'Hyrule Field / Hyrule Castle / Lake Hylia / Zora\'s River / Zora\'s Fountain / Death Mountain Trail',
        id = 'HYRULE_FIELD',
        multiline = 3,
        isField = true,
        isDayField = true,
    },
    ['0x5A'] = {
        name = 'Kaepora Gaebora Theme',
        id = 'OWL',
        isUrgent = true,
        isSpecial = true,
    },
    ['0x1D'] = {
        name = 'Market',
        id = 'MARKET',
    },
    ['0x4E'] = {
        name = 'Shooting Gallery / Bombchu Bowling Alley',
        id = 'SHOOTING_GALLERY',
    },
    ['0x2D'] = {
        name = 'Castle Courtyard',
        id = 'COURTYARD',
    },
    ['0x29'] = {
        name = 'Zelda Theme',
        id = 'ZELDA',
    },
    ['0x27'] = {
        name = 'Kakariko Village (child)',
        id = 'KAKARIKO_CHILD',
    },
    ['0x30'] = {
        name = 'Goron City',
        id = 'GORON_CITY',
    },
    ['0x3E'] = {
        name = 'Lost Woods',
        id = 'LOST_WOODS',
    },
    ['0x18'] = {
        name = 'Dodongo\'s Cavern / Death Mountain Crater / Royal Family\'s Tomb / Thieves\' Hideout / Gerudo Training Ground',
        id = 'CAVERN',
        multiline = 3,
    },
    ['0x6B'] = {
        name = 'King Dodongo / Volvagia Battle',
        id = 'BOSS_FIRE',
        isBoss = true,
        doesNotResume = true,
    },
    ['0x28'] = {
        name = 'Fairy Fountain',
        id = 'FAIRY',
    },
    ['0x2F'] = {
        name = 'Lon Lon Ranch',
        id = 'LON_LON_RANCH',
    },
    ['0x50'] = {
        name = 'Zora\'s Domain',
        id = 'ZORAS_DOMAIN',
    },
    ['0x6C'] = {
        name = 'Minigame',
        id = 'MINIGAME',
        isEvent = true,
        isMiniGame = true,
        doesNotResume = true,
    },
    ['0x26'] = {
        name = 'Inside Jabu-Jabu\'s Belly',
        id = 'JABU_JABU',
    },
    ['0x38'] = {
        name = 'Miniboss Battle',
        id = 'MINIBOSS',
        isEvent = true,
        isMiniBoss = true,
        doesNotResume = true,
    },
    ['0x3A'] = {
        name = 'Temple of Time',
        id = 'TEMPLE_OF_TIME',
    },
    ['0x59'] = {
        name = 'Door of Time',
        id = 'DOOR_OF_TIME',
        isSpecial = true,
    },
    ['0x53'] = {
        name = 'Master Sword',
        id = 'MASTER_SWORD',
        doesNotResume = true,
    },
    ['0x56'] = {
        name = 'Chamber of the Sages',
        id = 'CHAMBER_OF_SAGES',
        doesNotResume = true,
    },
    ['0x19'] = {
        name = 'Kakariko Village (adult)',
        id = 'KAKARIKO_ADULT',
    },
    ['0x2C'] = {
        name = 'Forest Temple',
        id = 'FOREST_TEMPLE',
    },
    ['0x2A'] = {
        name = 'Fire Temple',
        id = 'FIRE_TEMPLE',
    },
    ['0x58'] = {
        name = 'Ice Cavern',
        id = 'ICE_CAVERN',
    },
    ['0x5C'] = {
        name = 'Water Temple',
        id = 'WATER_TEMPLE',
    },
    ['0x60'] = {
        name = 'Lakeside Laboratory / Potion Shop / Ghost Shop',
        id = 'LABORATORY',
        multiline = 2,
    },
    ['0x4C'] = {
        name = 'Windmill',
        id = 'WINDMILL',
    },
    ['0x5B'] = {
        name = 'Shadow Temple / Bottom of the Well',
        id = 'SHADOW_TEMPLE',
    },
    ['0x40'] = {
        name = 'Epona Race / Horseback Archery',
        id = 'HORSE_RACE',
        doesNotResume = true,
    },
    ['0x41'] = {
        name = 'Epona Race Goal',
        id = 'HORSE_GOAL',
        doesNotResume = true,
    },
    ['0x42'] = {
        name = 'Ingo Theme',
        id = 'INGO',
    },
    ['0x5F'] = {
        name = 'Gerudo Valley / Gerudo Fortress / Haunted Wasteland / Desert Colossus',
        id = 'GERUDO_VALLEY',
        multiline = 2,
        isField = true,
        isDayField = true,
    },
    ['0x3F'] = {
        name = 'Spirit Temple',
        id = 'SPIRIT_TEMPLE',
    },
    ['0x61'] = {
        name = 'Kotake and Koume',
        id = 'KOTAKE_KOUME',
        doesNotResume = true,
    },
    ['0x63'] = {
        name = 'Ganon\'s Castle',
        id = 'GANONS_CASTLE',
    },
    ['0x2E'] = {
        name = 'Ganon\'s Tower',
        id = 'GANONS_TOWER',
        isPriority = true,
    },
    ['0x64'] = {
        name = 'Ganondorf Battle',
        id = 'GANONDORF_BATTLE',
        doesNotResume = true,
    },
    ['0x62'] = {
        name = 'Escape from Ganon\'s Castle',
        id = 'TOWER_ESCAPE',
        isPriority = true,
        doesNotResume = true,
    },
    ['0x65'] = {
        name = 'Ganon Battle',
        id = 'GANON_BATTLE',
        doesNotResume = true,
    },

    -- Credits sequences
    ['0x5E'] = {
        name = 'Six Sages Seal Ganondorf',
        id = 'SAGES_SEAL',
        isSpecial = true,
    },
    ['0x52'] = {
        name = 'Zelda\'s Goodbye',
        id = 'SCENE_ZELDA',
        isIgnored = true,
    },
    ['0x66'] = {
        name = 'Ocarina of Time',
        id = 'SCENE_OCARINA',
        isSpecial = true,
    },
    ['0x67'] = {
        name = 'Credits (Overworld)',
        id = 'CREDITS_OVERWORLD',
        isCredits = true,
        doesNotResume = true,
    },
    ['0x68'] = {
        name = 'Credits (Lon Lon Ranch)',
        id = 'CREDITS_LON_LON',
        isCredits = true,
        doesNotResume = true,
    },
    ['0x69'] = {
        name = 'Credits (Temple of Time)',
        id = 'CREDITS_TEMPLE',
        isCredits = true,
        doesNotResume = true,
    },
    ['0x6A'] = {
        name = 'Credits (Castle Courtyard)',
        id = 'CREDITS_COURTYARD',
        isCredits = true,
        doesNotResume = true,
    },

    -- Fanfares
    ['0x24'] = {
        name = 'Heart Container Get / Fish Caught',
        id = 'HEART_CONTAINER_GET',
        doesNotResume = true,
    },
    ['0x20'] = {
        name = 'Game Over',
        id = 'GAME_OVER',
        doesNotResume = true,
    },

    -- Custom BGMs
    -- Hex values are still used here for compatibility with functions. Values from 0x70 onwards are not used by
    -- sequences or fanfares and should be safe to assign custom BGMs to.
    ['0x70'] = {
        name = 'Hyrule Field (night)',
        id = 'NIGHT_FIELD',
        isCustom = true,
        isNightField = true,
    },
    ['0x71'] = {
        name = 'Miniboss Battle (monster)',
        id = 'MINIBOSS_MONSTER',
        isCustom = true,
    },
    ['0x72'] = {
        name = 'Bongo Bongo Battle',
        id = 'BONGO_BONGO',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x73'] = {
        name = 'Inside the Deku Tree',
        id = 'INSIDE_DEKU_TREE',
        isCustom = true,
    },
    ['0x74'] = {
        name = 'Dodongo\'s Cavern',
        id = 'DODONGOS_CAVERN',
        isCustom = true,
    },
    ['0x75'] = {
        name = 'Bottom of the Well',
        id = 'BOTTOM_OF_THE_WELL',
        isCustom = true,
    },
    ['0x76'] = {
        name = 'Thieves\' Hideout',
        id = 'THIEVES_HIDEOUT',
        isCustom = true,
    },
    ['0x77'] = {
        name = 'Gerudo Training Ground',
        id = 'GERUDO_TRAINING_GROUND',
        isCustom = true,
    },
    ['0x78'] = {
        name = 'Graveyard',
        id = 'GRAVEYARD',
        isCustom = true,
    },
    ['0x79'] = {
        name = 'Dark Link Battle',
        id = 'DARK_LINK',
        isCustom = true,
    },
    ['0x7A'] = {
        name = 'Lake Hylia',
        id = 'LAKE_HYLIA',
        isCustom = true,
        isDayField = true,
    },
    ['0x7B'] = {
        name = 'Fishing Pond',
        id = 'FISHING_POND',
        isCustom = true,
    },
    ['0x7C'] = {
        name = 'Death Mountain Trail',
        id = 'DEATH_MOUNTAIN_TRAIL',
        isCustom = true,
        isDayField = true,
    },
    ['0x7D'] = {
        name = 'Gerudo Valley (night)',
        id = 'NIGHT_VALLEY',
        isCustom = true,
        isNightField = true,
    },
    ['0x7E'] = {
        name = 'Gohma Battle',
        id = 'GOHMA',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x7F'] = {
        name = 'Barinade Battle',
        id = 'BARINADE',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x80'] = {
        name = 'Phantom Ganon Battle',
        id = 'PHANTOM_GANON',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x81'] = {
        name = 'Volvagia Battle',
        id = 'VOLVAGIA',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x82'] = {
        name = 'Morpha Battle',
        id = 'MORPHA',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x83'] = {
        name = 'Twinrova Battle',
        id = 'TWINROVA',
        isCustom = true,
        doesNotResume = true,
    },
    ['0x84'] = {
        name = 'Death Mountain Trail (night)',
        id = 'NIGHT_DEATH_MOUNTAIN_TRAIL',
        isCustom = true,
        isNightField = true,
    },
    ['0x85'] = {
        name = 'Lake Hylia (night)',
        id = 'NIGHT_LAKE_HYLIA',
        isCustom = true,
        isNightField = true,
    },
    ['0x86'] = {
        name = 'Royal Family\'s Tomb',
        id = 'ROYAL_FAMILYS_TOMB',
        isCustom = true,
    },
    ['0x87'] = {
        name = 'Zora\'s Domain (adult)',
        id = 'ZORAS_DOMAIN_ADULT',
        isCustom = true,
    },
    ['0x88'] = {
        name = 'Spirit Temple (child)',
        id = 'SPIRIT_TEMPLE_CHILD',
        isCustom = true,
    },
}

-- Sequence ID to hex value map table (used to quickly obtain sequence hex values in functions)
local SEQ = {}
-- Maps sequence IDs to track indexes in the playlist (used to give track numbers to the player API)
local BGM_PLAYLIST_TRACK_MAP = {}

-- Start and end time of the daytime BGM
local BGM_DAY_START = 0x4AAC
local BGM_DAY_END = 0xB71C
-- Start and end time of the nighttime BGM
local BGM_NIGHT_START = 0xC8E5
local BGM_NIGHT_END = 0x3C71

-- Simply returns BGM_TABLE which was declared at the beginning of this file
function BGM.getTable()
    return BGM_TABLE
end

-- Checks if a BGM has a track index assigned to it
function BGM.exists(hex)
    if (BGM.getTrackIndex(hex)) then
        return true
    else
        return false
    end
end

-- Gets the named prop for the specified sequence ID from BGM_TABLE
function BGM.getProp(prop, hex)
    local bgmData = BGM_TABLE[hex]

    if (bgmData) then
        return bgmData[prop]
    else
        return false
    end
end

-- Gets the 'name' prop
function BGM.getName(hex)
    return BGM.getProp('name', hex)
end

-- Gets the 'id' prop
function BGM.getId(hex)
    return BGM.getProp('id', hex)
end

function BGM.getOrder(hex)
    return BGM.getProp('order', hex)
end

function BGM.getIdToSequenceMap()
    local idMap = {}

    for bgmSequence, bgmData in pairs(BGM_TABLE) do
        local id = bgmData.id
        idMap[id] = bgmSequence
    end

    return idMap
end

function BGM.getTrackIndex(hex)
    local bgm_index = BGM_PLAYLIST_TRACK_MAP[hex]

    if (bgm_index) then
        bgm_index = bgm_index - 1
    else
        bgm_index = false
    end

    return bgm_index
end

-- Special sequences to exclude when considering changing tracks in the media player
function BGM.isSpecial(hex)
    return BGM.getProp('isSpecial', hex)
end

-- Special sequence that tells the script not to do anything
function BGM.isSkip(hex)
    return BGM.getProp('isSkip', hex)
end

-- Sequences that mute the game music and should stop the media player
function BGM.isSilent(hex)
    return BGM.getProp('isSilent', hex)
end

-- Sequences that fade out the currently playing game music and should do the same in the media player
function BGM.isFadeOut(hex)
    return BGM.getProp('isFadeOut', hex)
end

-- Sequences that override the scene BGM (miniboss, minigame, etc.)
function BGM.isEvent(hex)
    return BGM.getProp('isEvent', hex)
end

-- Sequences used in an area with a day/night cycle (for use with the custom night BGM)
function BGM.isField(hex)
    return BGM.getProp('isField', hex)
end

-- Daytime sequence used in an area with a day/night cycle
function BGM.isDayField(hex)
    return BGM.getProp('isDayField', hex)
end

-- Nighttime sequence used in an area with a day/night cycle
function BGM.isNightField(hex)
    return BGM.getProp('isNightField', hex)
end

-- BGMs that need to be faded out faster than usual due to speed of game events
function BGM.isUrgent(hex)
    return BGM.getProp('isUrgent', hex)
end

-- BGMs that should not be interrupted unless the scene BGM itself changes
function BGM.isPriority(hex)
    return BGM.getProp('isPriority', hex)
end

-- Boss battle sequences
function BGM.isBoss(hex)
    return BGM.getProp('isBoss', hex)
end

-- Miniboss sequences
function BGM.isMiniBoss(hex)
    return BGM.getProp('isMiniBoss', hex)
end

-- Minigame sequences
function BGM.isMiniGame(hex)
    return BGM.getProp('isMiniGame', hex)
end

-- Sequences from the credits to explicitly mute before the game can play them
function BGM.isCredits(hex)
    return BGM.getProp('isCredits', hex)
end

-- Sequences to ignore when prompted to change tracks
function BGM.isIgnored(hex)
    return BGM.getProp('isIgnored', hex)
end

-- Sequences that do not resume playback from where they left off when returning from another sequence
function BGM.doesNotResume(hex)
    return BGM.getProp('doesNotResume', hex)
end

-- Checks if the time of day should allow for a night BGM to play
function BGM.isNightTime()
    local time_of_day = OOT.getTime()
    return
        time_of_day >= BGM_NIGHT_START
        or time_of_day <= BGM_NIGHT_END
end

-- Checks if it's currently the time of day that the daytime BGM would play
function BGM.isDayTime()
    local time_of_day = OOT.getTime()
    return
        time_of_day >= BGM_DAY_START
        and time_of_day <= BGM_DAY_END
end

-- Checks if it's currently the time of morning right before the daytime BGM plays
function BGM.isSunrise()
    local time_of_day = OOT.getTime()
    return
        time_of_day > BGM_NIGHT_END
        and time_of_day < BGM_DAY_START
end

-- Checks if we should switch to a night BGM right now
function BGM.canChangeToNight(bgm_hex, bgm_scene_hex, bgm_player)
    if (BGM.isNightTime()) then
        local bgm_night_hex = BGM.getCustomBGMHex(bgm_hex, bgm_scene_hex)

        if (bgm_night_hex and BGM.isNightField(bgm_night_hex)) then
            local bgm_night_index = BGM.getTrackIndex(bgm_night_hex)

            if (bgm_night_index) then
                local isDifferentBGM = bgm_night_index ~= bgm_player

                -- This is primarily to handle raining in Lake Hylia
                if (not isDifferentBGM) then
                    local isPaused = STATE.getIsPaused()
                    return isPaused
                end

                return isDifferentBGM
            end
        end
    end

    return false
end

-- Handling for warps between two scenes that share a sequence but have different playlist tracks.
-- If a custom BGM exists we force a fade out and track change during transitions to/from that area.
function BGM.isNextSceneUsingDifferentTrack(bgm_hex)
    local origin = STATE.getCachedScene()
    local destination = OOT.getScene()

    -- Handlers for each pair of linked areas that share BGMs but support custom day or night BGMs
    -- should be included here.
    return isHyruleFieldAndLakeHyliaTransition(bgm_hex, origin, destination)
end

-- Determines if we should switch between the Hyrule Field and Lake Hylia BGMs during the current scene transition
function isHyruleFieldAndLakeHyliaTransition(bgm_hex, origin, destination)
    local isTravelingToLakeHylia = origin == SCENE.HYRULE_FIELD.ID and destination == SCENE.LAKE_HYLIA.ID
    local isTravelingToHyruleField = origin == SCENE.LAKE_HYLIA.ID and destination == SCENE.HYRULE_FIELD.ID
    local isTravelingToDifferentScene = isTravelingToLakeHylia or isTravelingToHyruleField

    -- We should only transition between BGMs if the Lake Hylia BGM exists
    local hasDifferentDayBGM =
        BGM.isDayTime()
        and BGM.exists(SEQ.LAKE_HYLIA)
        and (BGM.getTrackIndex(SEQ.LAKE_HYLIA) ~= BGM.getTrackIndex(SEQ.HYRULE_FIELD))
    
    -- Likewise, the night BGMs should only be transitioned between if they exist
    local hasDifferentNightBGM =
        BGM.isNightTime()
        and BGM.exists(SEQ.NIGHT_LAKE_HYLIA)
        and (BGM.getTrackIndex(SEQ.NIGHT_LAKE_HYLIA) ~= BGM.getTrackIndex(SEQ.NIGHT_FIELD))

    return
        isTravelingToDifferentScene
        and (
            hasDifferentDayBGM
            or hasDifferentNightBGM
        )
end

-- Get the hex ID of a custom BGM that should play in place of the supplied sequence hex
function BGM.getCustomBGMHex(bgm_hex, bgm_scene_hex)
    if (isNightDeathMountainTrail(bgm_hex, bgm_scene_hex)) then
        return SEQ.NIGHT_DEATH_MOUNTAIN_TRAIL
    elseif (isNightLakeHylia(bgm_hex, bgm_scene_hex)) then
        return SEQ.NIGHT_LAKE_HYLIA
    elseif (isNightHyruleField(bgm_hex, bgm_scene_hex)) then
        return SEQ.NIGHT_FIELD
    elseif (isNightValley(bgm_hex, bgm_scene_hex)) then
        return SEQ.NIGHT_VALLEY
    elseif (isLakeHylia(bgm_hex)) then
        return SEQ.LAKE_HYLIA
    elseif (isFishingPond(bgm_hex)) then
        return SEQ.FISHING_POND
    elseif (isInsideDekuTree(bgm_hex)) then
        return SEQ.INSIDE_DEKU_TREE
    elseif (isDekuTreeBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.GOHMA
    elseif (isGraveyard(bgm_hex, bgm_scene_hex)) then
        return SEQ.GRAVEYARD
    elseif (isDeathMountainTrail(bgm_hex)) then
        return SEQ.DEATH_MOUNTAIN_TRAIL
    elseif (isDodongosCavern(bgm_hex)) then
        return SEQ.DODONGOS_CAVERN
    elseif (isJabuJabuMiniBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.MINIBOSS_MONSTER
    elseif (isJabuJabuBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.BARINADE
    elseif (isRoyalFamilysTomb(bgm_hex, bgm_scene_hex)) then
        return SEQ.ROYAL_FAMILYS_TOMB
    elseif (isForestTemplePoeMiniBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.MINIBOSS_MONSTER
    elseif (isForestTempleBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.PHANTOM_GANON
    elseif (isFireTempleBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.VOLVAGIA
    elseif (isZorasDomainAdult(bgm_hex)) then
        return SEQ.ZORAS_DOMAIN_ADULT
    elseif (isIceCavernMiniBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.MINIBOSS_MONSTER
    elseif (isWaterTempleMiniBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.DARK_LINK
    elseif (isWaterTempleBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.MORPHA
    elseif (isBottomOfTheWell(bgm_hex)) then
        return SEQ.BOTTOM_OF_THE_WELL
    elseif (isShadowTempleMiniBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.MINIBOSS_MONSTER
    elseif (isShadowTempleBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.BONGO_BONGO
    elseif (isThievesHideout(bgm_hex)) then
        return SEQ.THIEVES_HIDEOUT
    elseif (isGerudoTrainingGround(bgm_hex)) then
        return SEQ.GERUDO_TRAINING_GROUND
    elseif (isSpiritTempleChild(bgm_hex)) then
        return SEQ.SPIRIT_TEMPLE_CHILD
    elseif (isSpiritTempleBoss(bgm_hex, bgm_scene_hex)) then
        return SEQ.TWINROVA
    -- Fix for scene entrances where the game plays another BGM briefly before the intended one
    elseif (isIgnoredRoomBGM(bgm_hex)) then
        return SEQ.PAUSE
    end

    return false
end

function isNightHyruleField(bgm_hex, bgm_scene_hex)
    local isHyruleFieldSceneBGM = bgm_scene_hex == SEQ.HYRULE_FIELD
    local isNightTime = BGM.isNightTime()
    local isField = BGM.isField(bgm_scene_hex)
    local isSilent = BGM.isSilent(bgm_hex)

    return
        -- If this BGM doesn't exist return false to fall back on silence BGM
        BGM.exists(SEQ.NIGHT_FIELD)
        and isHyruleFieldSceneBGM
        and isNightTime
        and isField
        and isSilent
end

function isNightValley(bgm_hex, bgm_scene_hex)
    local isGerudoValleySceneBGM = bgm_scene_hex == SEQ.GERUDO_VALLEY
    local isNightTime = BGM.isNightTime()
    local isField = BGM.isField(bgm_scene_hex)
    local isSilent = BGM.isSilent(bgm_hex)

    return
        -- If this BGM doesn't exist return false to fall back on silence BGM
        BGM.exists(SEQ.NIGHT_VALLEY)
        and isGerudoValleySceneBGM
        and isNightTime
        and isField
        and isSilent
end

function isNightDeathMountainTrail(bgm_hex, bgm_scene_hex)
    local currentScene = OOT.getScene()
    local isDeathMountainTrailScene = currentScene == SCENE.DEATH_MOUNTAIN_TRAIL.ID
    local isNightTime = BGM.isNightTime()
    local isField = BGM.isField(bgm_scene_hex)
    local isSilent = BGM.isSilent(bgm_hex)

    -- If this BGM doesn't exist return false to fall back on night Hyrule Field BGM
    return
        BGM.exists(SEQ.NIGHT_DEATH_MOUNTAIN_TRAIL)
        and isDeathMountainTrailScene
        and isNightTime
        and isField
        and isSilent
end

function isNightLakeHylia(bgm_hex, bgm_scene_hex)
    local currentScene = OOT.getScene()
    local isLakeHyliaScene = currentScene == SCENE.LAKE_HYLIA.ID
    local isNightTime = BGM.isNightTime()
    local isField = BGM.isField(bgm_scene_hex)
    local isSilent = BGM.isSilent(bgm_hex)

    -- If this BGM doesn't exist return false to fall back on night Hyrule Field BGM
    return
        BGM.exists(SEQ.NIGHT_LAKE_HYLIA)
        and isLakeHyliaScene
        and isNightTime
        and isField
        and isSilent
end

function isLakeHylia(bgm_hex)
    local currentScene = OOT.getScene()
    local isLakeHyliaBGM = bgm_hex == SEQ.HYRULE_FIELD
    local isLakeHyliaScene = currentScene == SCENE.LAKE_HYLIA.ID
    return
        isLakeHyliaBGM
        and isLakeHyliaScene
end

function isFishingPond(bgm_hex)
    local currentScene = OOT.getScene()
    local isFishingPondBGM =
        bgm_hex == SEQ.KAKARIKO_CHILD
        or bgm_hex == SEQ.KAKARIKO_ADULT
    local isFishingPondScene = currentScene == SCENE.FISHING_POND.ID
    return
        isFishingPondBGM
        and isFishingPondScene
end

function isInsideDekuTree(bgm_hex)
    local currentScene = OOT.getScene()
    local isDekuTreeBGM = bgm_hex == SEQ.GROTTO
    local isDekuTreeScene = currentScene == SCENE.INSIDE_DEKU_TREE.ID
    local isDekuTreeBossScene = currentScene == SCENE.INSIDE_DEKU_TREE.BOSS
    return
        isDekuTreeBGM
        and (
            isDekuTreeScene
            or isDekuTreeBossScene
        )
end

function isDekuTreeBoss(bgm_hex, bgm_scene_hex)
    local isDekuTreeBGM = bgm_scene_hex == SEQ.GROTTO
    return isDekuTreeBGM and BGM.isBoss(bgm_hex)
end

function isGraveyard(bgm_hex, bgm_scene_hex)
    local isSilent = BGM.isSilent(bgm_hex)
    local isGraveyardScene = OOT.getScene() == SCENE.GRAVEYARD.ID
    return isSilent and isGraveyardScene
end

function isDeathMountainTrail(bgm_hex)
    local currentScene = OOT.getScene()
    local isDeathMountainTrailBGM = bgm_hex == SEQ.HYRULE_FIELD
    local isDeathMountainTrailScene = currentScene == SCENE.DEATH_MOUNTAIN_TRAIL.ID
    return
        isDeathMountainTrailBGM
        and isDeathMountainTrailScene
end

function isDodongosCavern(bgm_hex)
    local currentScene = OOT.getScene()
    local isDodongosCavernBGM = bgm_hex == SEQ.CAVERN
    local isDodongosCavernScene = currentScene == SCENE.DODONGOS_CAVERN.ID
    local isDodongosCavernBossScene = currentScene == SCENE.DODONGOS_CAVERN.BOSS
    return
        isDodongosCavernBGM
        and (
            isDodongosCavernScene
            or isDodongosCavernBossScene
        )
end

function isJabuJabuMiniBoss(bgm_hex, bgm_scene_hex)
    local isJabuJabuBGM = bgm_scene_hex == SEQ.JABU_JABU
    return isJabuJabuBGM and BGM.isMiniBoss(bgm_hex)
end

function isJabuJabuBoss(bgm_hex, bgm_scene_hex)
    local isJabuJabuBGM = bgm_scene_hex == SEQ.JABU_JABU
    return isJabuJabuBGM and BGM.isBoss(bgm_hex)
end

function isRoyalFamilysTomb(bgm_hex)
    local currentScene = OOT.getScene()
    local isRoyalFamilysTombBGM = bgm_hex == SEQ.CAVERN
    local isRoyalFamilysTombScene = currentScene == SCENE.ROYAL_FAMILYS_TOMB.ID
    local isShieldGraveScene = currentScene == SCENE.SHIELD_GRAVE.ID
    local isSunSongGraveScene = currentScene == SCENE.SUNS_SONG_GRAVE.ID
    local isDampeRaceScene = (currentScene == SCENE.WINDMILL.ID) and (OOT.getRoom() == SCENE.WINDMILL.ROOMS.DAMPE)
    return
        isRoyalFamilysTombBGM
        and (
            isRoyalFamilysTombScene
            or isShieldGraveScene
            or isSunSongGraveScene
            or isDampeRaceScene
        )
end

function isForestTemplePoeMiniBoss(bgm_hex, bgm_scene_hex)
    local isForestTempleSceneBGM = bgm_scene_hex == SEQ.FOREST_TEMPLE
    local isForestTempleScene = OOT.getScene() == SCENE.FOREST_TEMPLE.ID
    local isForestTempleMainRoom = OOT.getRoom() == SCENE.FOREST_TEMPLE.ROOMS.MAIN
    local isMiniBossBGM = BGM.isMiniBoss(bgm_hex)
    return
        isForestTempleSceneBGM
        and isForestTempleScene
        and isForestTempleMainRoom
        and isMiniBossBGM
end

function isForestTempleBoss(bgm_hex, bgm_scene_hex)
    local isForestTempleBGM = bgm_scene_hex == SEQ.FOREST_TEMPLE
    return isForestTempleBGM and BGM.isBoss(bgm_hex)
end

function isFireTempleBoss(bgm_hex, bgm_scene_hex)
    local isFireTempleBGM = bgm_scene_hex == SEQ.FIRE_TEMPLE
    return isFireTempleBGM and BGM.isBoss(bgm_hex)
end

function isZorasDomainAdult(bgm_hex)
    local isZorasDomainBGM = bgm_hex == SEQ.ZORAS_DOMAIN
    local isAdult = OOT.isAdult()
    return isZorasDomainBGM and isAdult
end

function isIceCavernMiniBoss(bgm_hex, bgm_scene_hex)
    local isIceCavernBGM = bgm_scene_hex == SEQ.ICE_CAVERN
    return isIceCavernBGM and BGM.isMiniBoss(bgm_hex)
end

function isWaterTempleMiniBoss(bgm_hex, bgm_scene_hex)
    local isWaterTempleBGM = bgm_scene_hex == SEQ.WATER_TEMPLE
    return isWaterTempleBGM and BGM.isMiniBoss(bgm_hex)
end

function isWaterTempleBoss(bgm_hex, bgm_scene_hex)
    local isWaterTempleBGM = bgm_scene_hex == SEQ.WATER_TEMPLE
    return isWaterTempleBGM and BGM.isBoss(bgm_hex)
end

function isBottomOfTheWell(bgm_hex)
    local isBottomOfTheWellBGM = bgm_hex == SEQ.SHADOW_TEMPLE
    local isBottomOfTheWellScene = OOT.getScene() == SCENE.BOTTOM_OF_THE_WELL.ID
    return isBottomOfTheWellBGM and isBottomOfTheWellScene
end

function isShadowTempleMiniBoss(bgm_hex, bgm_scene_hex)
    local isShadowTempleBGM = bgm_scene_hex == SEQ.SHADOW_TEMPLE
    return isShadowTempleBGM and BGM.isMiniBoss(bgm_hex)
end

function isShadowTempleBoss(bgm_hex, bgm_scene_hex)
    local isShadowTempleBGM = bgm_scene_hex == SEQ.SHADOW_TEMPLE
    return isShadowTempleBGM and BGM.isBoss(bgm_hex)
end

function isThievesHideout(bgm_hex)
    local isThievesHideoutBGM = bgm_hex == SEQ.CAVERN
    local isThievesHideoutScene = OOT.getScene() == SCENE.THIEVES_HIDEOUT.ID
    return isThievesHideoutBGM and isThievesHideoutScene
end

function isGerudoTrainingGround(bgm_hex)
    local isGerudoTrainingGroundBGM = bgm_hex == SEQ.CAVERN
    local isGerudoTrainingGroundScene = OOT.getScene() == SCENE.GERUDO_TRAINING_GROUND.ID
    return isGerudoTrainingGroundBGM and isGerudoTrainingGroundScene
end

function isSpiritTempleChild(bgm_hex)
    local isSpiritTempleBGM = bgm_hex == SEQ.SPIRIT_TEMPLE
    local isChild = OOT.isChild()
    return isSpiritTempleBGM and isChild
end

function isSpiritTempleBoss(bgm_hex, bgm_scene_hex)
    local isSpiritTempleBGM = bgm_scene_hex == SEQ.SPIRIT_TEMPLE
    return isSpiritTempleBGM and BGM.isBoss(bgm_hex)
end

-- Stops the first BGM from playing when entering a specific scene from a specified room.
-- Used for areas like Windmill and Fishing Hole where another BGM briefly plays before
-- the intended one.
function isIgnoredRoomBGM(bgm_hex)
    local currentScene = OOT.getScene()
    local currentRoom = OOT.getRoom()

    for key in pairs(SCENE) do
        local sceneData = SCENE[key]
        local ignoredBgmRooms = sceneData.SEQ_IGNORE_ROOMS
        
        if (currentScene == sceneData.ID) then
            if (ignoredBgmRooms and ignoredBgmRooms[bgm_hex] == currentRoom) then
                return true
            end

            return false
        end
    end

    return false
end

-- Determines if a temporary event that changes the current BGM is complete
function BGM.isFinishedWithEvent(bgm_hex, bgm_scene_hex)
    if (isZoraDiving(bgm_hex, bgm_scene_hex)) then
        return OOT.isZoraDivingClear()
    elseif (isBigOctoFight(bgm_hex, bgm_scene_hex)) then
        return OOT.isBigOctoRoomClear()
    elseif (isDarkLinkFight(bgm_hex, bgm_scene_hex)) then
        return OOT.isDarkLinkRoomClear()
    elseif (isNabooruFight(bgm_hex, bgm_scene_hex)) then
        return OOT.isNabooruRoomClear()
    elseif (BGM.isMiniBoss(bgm_hex)) then
        return OOT.isGenericMiniBossRoomClear()
    end

    return false
end

function isZoraDiving(bgm_hex, bgm_scene_hex)
    local isZorasDomain = bgm_scene_hex == SEQ.ZORAS_DOMAIN
    return BGM.isMiniGame(bgm_hex) and isZorasDomain
end

function isBigOctoFight(bgm_hex, bgm_scene_hex)
    local isJabuJabu = bgm_scene_hex == SEQ.JABU_JABU
    return BGM.isMiniBoss(bgm_hex) and isJabuJabu
end

function isDarkLinkFight(bgm_hex, bgm_scene_hex)
    local isWaterTemple = bgm_scene_hex == SEQ.WATER_TEMPLE
    return BGM.isMiniBoss(bgm_hex) and isWaterTemple
end

function isNabooruFight(bgm_hex, bgm_scene_hex)
    local isSpiritTemple = bgm_scene_hex == SEQ.SPIRIT_TEMPLE
    local isSpiritTempleBossRoom = OOT.getScene() == SCENE.SPIRIT_TEMPLE.BOSS

    return
        BGM.isMiniBoss(bgm_hex)
        and isSpiritTemple
        and isSpiritTempleBossRoom
end

-- Determines if we should ignore event sequences in certain areas (usually miniboss)
function BGM.isUninterruptableByEvent(bgm_hex)
    return
        BGM.isPriority(bgm_hex)
        or OOT.isEscapeSequence()
end

-- Determines whether or not to change to the next sequence during credits
function BGM.doesNextCreditsBGMExist(bgm_hex)
    -- If the Overworld credits BGM doesn't exist we should ignore the rest
    if (not BGM.exists(SEQ.CREDITS_OVERWORLD)) then
        return false
    end

    if (bgm_hex == SEQ.CREDITS_OVERWORLD) then
        return BGM.exists(SEQ.CREDITS_LON_LON)
    elseif (bgm_hex == SEQ.CREDITS_LON_LON) then
        return BGM.exists(SEQ.CREDITS_TEMPLE)
    elseif (bgm_hex == SEQ.CREDITS_TEMPLE) then
        return BGM.exists(SEQ.CREDITS_COURTYARD)
    end

    return true
end

-- Checks if the currently playing sequence should be forcibly silenced.
-- Mostly for use with the credits.
function BGM.isGameSequenceDisabled(bgm_hex)
    if (BGM.isCredits(bgm_hex)) then
        -- Credits BGMs should only be disabled if the Overworld credits BGM exists
        return BGM.exists(SEQ.CREDITS_OVERWORLD)
    elseif (BGM.isIgnored(bgm_hex)) then
        -- All other ignored BGMs should mute their game counterparts indiscriminately
        return BGM.exists(bgm_hex)
    end

    return false
end

-- Obtains the correct sequence to play in certain situations where the BGM the game played is incorrect.
function BGM.getCorrectSequence(bgm_hex, bgm_scene_hex)
    if (bgm_scene_hex == SEQ.GERUDO_VALLEY) then
        return getCorrectGerudoValleySequence(bgm_hex)
    end

    return false
end

-- In OoT 1.0 playing Sun's Song in Haunted Wasteland doesn't force a sequence change,
-- causing the current BGM to remain the same when traveling between Gerudo overworld
-- scenes since the game doesn't check if the BGM is correct between them.
function getCorrectGerudoValleySequence(bgm_hex)
    local isWrongDayBGM = BGM.isDayTime() and bgm_hex == SEQ.SILENCE
    local isWrongNightBGM = BGM.isNightTime() and bgm_hex == SEQ.GERUDO_VALLEY
    
    if (isWrongDayBGM) then
        return SEQ.GERUDO_VALLEY
    elseif (isWrongNightBGM) then
        return SEQ.SILENCE
    end

    return false
end

-- Checks if the provided playlist item is assigned to a field BGM. Used to prevent
-- field BGMs from resuming in certain situations.
function BGM.isTrackIndexDayFieldBGM(track_index)
    local propsToMatch = { 'isDayField' }
    local daySequences = UTIL.filterTableByMatchingProps(propsToMatch, BGM_TABLE)
    local isMatch = false

    for sequenceId in pairs(daySequences) do
        if (BGM.getTrackIndex(sequenceId) == track_index) then
            isMatch = true
        end
    end

    return isMatch
end

-- Assigns the sequence IDs to playlist track indexes.
function BGM.assignPlaylistData(bgmTable)
    FORM.printOutput('Resetting playlist track map...')

    -- Clear existing track map
    BGM_PLAYLIST_TRACK_MAP = {}

    for key in pairs(SEQ) do
        local hex = SEQ[key]

        if (hex and not BGM.isSpecial(hex)) then
            local trackIndex = tonumber(bgmTable[key]) or nil

            if (trackIndex) then
                BGM_PLAYLIST_TRACK_MAP[hex] = trackIndex
                -- FORM.printOutput('Added: ' .. bgmTable[key] .. ' (' .. hex .. ') ' .. key)
            end
        end
    end
end

SEQ = BGM.getIdToSequenceMap()

return BGM
