--[[
    Ocarina of Time state functions

    State functions are used to keep values in memory. This file is used to define state variables
    separately from the script.
]]--

local STATE = {}

local OOT = require('zootr-bgm/oot')

-- foobar2000 volume control parameters
local VOLUME_MAX = -6
local VOLUME_MIN = VOLUME_MAX - 50
local VOLUME_GAME_PAUSE = VOLUME_MAX - 15
local VOLUME_CHANGE_AMOUNT = 1
local VOLUME_CHANGE_AMOUNT_SLOW = VOLUME_CHANGE_AMOUNT / 6
local VOLUME_CHANGE_AMOUNT_FAST = VOLUME_CHANGE_AMOUNT * 2

-- Stores the most recent scene BGM
local bgm_scene = 0

-- Stores the current track number of the player, or -1 if stopped
local bgm_player = -1

-- Stores the last frame's BGM ID from memory for comparisons
local bgm_memory_real_time = 0

-- Current media player volume
local volume = VOLUME_MAX

-- Determines if the media player is paused
local is_paused = false

-- Used to compare against for delaying certain audio actions
local audio_buffer_frames = 0

-- Stores the most recent scene ID for comparisons
local scene_cached = OOT.getScene()

-- Determines if we're manually fading out the audio
local is_fading_out = false

-- Determines if we're currently playing a credits sequence
local is_credits = false

-- Previous track position
local track_position_previous = 0

-- Previously playing BGM
local bgm_previous = 0

-- Determines if we should update the track position, and to where
local track_position_resume = false

function STATE.reset()
    STATE.setSceneBGM(0)
    STATE.setCurrentBGM(-1)
    STATE.setRealTimeBGM(0)
    STATE.setIsPaused(false)
    STATE.setAudioBufferFrames(0)
    STATE.setIsFadingOut(false)
    STATE.setIsCredits(false)
    STATE.setPreviousTrackPosition(0)
    STATE.setPreviousBGM(0)
    STATE.setResumeTrackPosition(false)
end

function STATE.getCurrentBGM()
    return bgm_player
end

function STATE.setCurrentBGM(value)
    bgm_player = value
end

function STATE.getIsPaused(value)
    return is_paused
end

function STATE.setIsPaused(value)
    is_paused = value
end

function STATE.getVolume(value)
    return volume
end

function STATE.setVolume(value)
    volume = value
end

function STATE.getMaxVolume(value)
    return VOLUME_MAX
end

function STATE.setMaxVolume(value)
    VOLUME_MAX = value
    VOLUME_MIN = VOLUME_MAX - 50
    VOLUME_GAME_PAUSE = VOLUME_MAX - 15
end

function STATE.getVolumeLimits()
    return {
        max = VOLUME_MAX,
        min = VOLUME_MIN,
        pause = VOLUME_GAME_PAUSE,
    }
end

function STATE.getVolumeChangeSpeeds()
    return {
        normal = VOLUME_CHANGE_AMOUNT,
        fast = VOLUME_CHANGE_AMOUNT_FAST,
        slow = VOLUME_CHANGE_AMOUNT_SLOW,
    }
end

function STATE.getSceneBGM()
    return bgm_scene
end

function STATE.setSceneBGM(value)
    bgm_scene = value
end

function STATE.getRealTimeBGM()
    return bgm_memory_real_time
end

function STATE.setRealTimeBGM(value)
    bgm_memory_real_time = value
end

function STATE.getCachedScene()
    return scene_cached
end

function STATE.setCachedScene(value)
    scene_cached = value
end

function STATE.getIsFadingOut()
    return is_fading_out
end

function STATE.setIsFadingOut(value)
    is_fading_out = value
end

function STATE.getAudioBufferFrames()
    return audio_buffer_frames
end

function STATE.setAudioBufferFrames(value)
    audio_buffer_frames = value
end

function STATE.getIsCredits()
    return is_credits
end

function STATE.setIsCredits(value)
    is_credits = value
end

function STATE.getPreviousTrackPosition()
    return track_position_previous
end

function STATE.setPreviousTrackPosition(value)
    track_position_previous = value
end

function STATE.getPreviousBGM()
    return bgm_previous
end

function STATE.setPreviousBGM(value)
    bgm_previous = value
end

function STATE.getResumeTrackPosition()
    return track_position_resume
end

function STATE.setResumeTrackPosition(value)
    track_position_resume = value
end

return STATE