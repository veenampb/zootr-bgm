--[[
    == foobar2000 script for Ocarina of Time Randomizer ==

    This script will read certain addresses in the RAM while running Ocarina of Time and use the
    values it finds to determine the current status of the game. Certain combinations of these values
    will be used to decide which track number to play in the currently loaded playlist in foobar2000,
    though in most cases it will rely on a single address in memory that always reflects either the
    current sequence ID or that the music is currently fading out (usually during a scene transition).
    
    Interactivity with foobar2000 is achieved using the beefweb plugin to allow the media player to
    act as a web server and listen for any incoming XMLHttpRequests.

    Requires the following to be installed:
    https://www.foobar2000.org
    https://github.com/hyperblast/beefweb
]]--

STATE = require('zootr-bgm/state')
BGM = require('zootr-bgm/bgm')
OOT = require('zootr-bgm/oot')
SCENE = require('zootr-bgm/scene')
PLAYER = require('zootr-bgm/player')
FORM = require('zootr-bgm/form')
UTIL = require('zootr-bgm/util')
FILE = require('zootr-bgm/file')

local SEQ = BGM.getIdToSequenceMap()

-- Silent BGM index used for overwriting saved player BGM
local STOPPED_BGM_INDEX = -1

-- Audio buffer frames for resuming tracks we switch back to
local RESUME_BUFFER_FRAMES = 9

-- Player wrapper functions
function changeTrack(value)
    -- Get the last saved scene BGM
    local bgm_scene = STATE.getSceneBGM()

    -- Get hex strings of all BGM IDs passed into script for comparisons
    local bgm_hex = UTIL.valueToHexString(value)
    local bgm_scene_hex = UTIL.valueToHexString(bgm_scene)
    local bgm_custom_hex = BGM.getCustomBGMHex(bgm_hex, bgm_scene_hex)

    -- Don't do anything if this is our special skip BGM
    if (BGM.isSkip(bgm_custom_hex)) then
        return false
    end

    -- Get the playlist track index the BGM is assigned to
    local bgm_index = BGM.getTrackIndex(bgm_hex)
    local bgm_custom_index = BGM.getTrackIndex(bgm_custom_hex)

    -- A BGM that doesn't have a track number assigned to it is
    -- considered invalid
    local isInvalidBGM = not(bgm_index) and not(bgm_custom_index) and not(BGM.isSilent(bgm_hex))
    -- Custom BGMs don't count as silent as they may replace the silence
    -- in areas that don't usually have BGMs
    local isSilentBGM = BGM.isSilent(bgm_hex) and not(bgm_custom_index)
    -- BGMs considered special shouldn't be reported in the output
    local isSpecialBGM = BGM.isSpecial(bgm_hex)

    -- Report regular BGMs as missing in the output
    if (isInvalidBGM and not(isSpecialBGM)) then
        local track_name = BGM.getName(bgm_hex)

        if (track_name) then
            FORM.printOutput('BGM not found: ' .. track_name .. ' (' .. bgm_hex .. ')')
        end
    end

    -- Kill off any existing fade out flags when changing tracks
    setIsFadingOut(false)

    -- Get information from the media player about the track we're changing from
    local trackData = PLAYER.getCurrentTrackData()
    local track_position = trackData.position
    local track_duration = trackData.duration
    local track_position_previous = STATE.getPreviousTrackPosition()
    -- Save our position in this track in case we need to resume it later
    local trackPositionToSave = track_position
    -- For looping BGMs we can only jump as far as the media player considers the track duration to be,
    -- so we need to force the track back to the beginning if we've exceeded its duration.
    if (track_position >= track_duration) then
        trackPositionToSave = 0
    end

    local saved_bgm_player = 0 + STATE.getCurrentBGM()
    local bgm_previous = 0 + STATE.getPreviousBGM()

    if (isSilentBGM or isInvalidBGM) then
        -- Stop the media player if the next BGM is silent or invalid
        STATE.setPreviousTrackPosition(trackPositionToSave)
        STATE.setPreviousBGM(saved_bgm_player)
        savePlayerBGM(STOPPED_BGM_INDEX)
        stopTrack()
    else
        -- Handle the next track if the next track is new
        local next_track = value
        local next_index = bgm_index

        if (bgm_custom_index) then
            next_track = tonumber(bgm_custom_hex)
            next_index = bgm_custom_index
        end

        local isSameBGM = next_index == STATE.getCurrentBGM()

        if (isSameBGM and STATE.getIsPaused()) then
            -- Resume a paused BGM (for void out, Farore's Wind, or shared BGM)
            togglePauseTrack()
        elseif (not isSameBGM) then
            -- Get the volume limits of this playlist
            local volumeLimit = STATE.getVolumeLimits()

            -- Send track and volume change requests to the media player
            STATE.setIsPaused(false)
            PLAYER.changeTrack(next_track)
            setVolume(volumeLimit.max)

            -- Determine if we're returning to a previous area and need to resume the BGM
            local isResumingBGM = not BGM.doesNotResume(bgm_hex)
            local isPreviousBGM = next_index == bgm_previous
            local isPreviousPositionNotStart = track_position_previous > 0

            if (isPreviousBGM and isResumingBGM and isPreviousPositionNotStart) then
                -- Change the track position if applicable
                STATE.setResumeTrackPosition(track_position_previous)
                -- We need to add a delay before the position change since it doesn't play well with changeTrack
                STATE.setAudioBufferFrames(RESUME_BUFFER_FRAMES)
            end

            -- Save the previous BGM's data, then update our stored value to the new one
            STATE.setPreviousTrackPosition(trackPositionToSave)
            STATE.setPreviousBGM(saved_bgm_player)
            savePlayerBGM(next_index)
        end
    end
end

function stopTrack()
    STATE.setIsPaused(true)
    PLAYER.stopTrack()
end

function togglePauseTrack()
    if (not STATE.getIsPaused()) then
        STATE.setIsPaused(true)
    else
        STATE.setIsPaused(false)
    end

    PLAYER.togglePauseTrack()
end

function setVolume(value)
    STATE.setVolume(value)
    PLAYER.setVolume(value)
end

-- State save functions
function saveSceneBGM(bgm_id)
    STATE.setSceneBGM(bgm_id)
end

function savePlayerBGM(bgm_id)
    STATE.setCurrentBGM(tonumber(bgm_id))
end

function saveRealTimeBGM(bgm_id)
    STATE.setRealTimeBGM(tonumber(bgm_id))
end

function getCachedSceneId()
    return STATE.getCachedScene()
end

function setCachedSceneId(scene_id)
    STATE.setCachedScene(scene_id)
end

function isFadingOut()
    return STATE.getIsFadingOut()
end

function setIsFadingOut(value)
    STATE.setIsFadingOut(value)
end

function toggleIsCreditsState(bgm_hex)
    local isCreditsActive = STATE.getIsCredits()
    local isCreditsBGM = BGM.isCredits(bgm_hex)
    local isContinuousBGM = not BGM.doesNextCreditsBGMExist(bgm_hex)
    local isResetBGM = bgm_hex == SEQ.NULL

    if (isCreditsBGM and isContinuousBGM) then
        -- If we can't find the next credits BGM keep playing the previous one
        if (not isCreditsActive) then
            STATE.setIsCredits(true)
        end
    elseif ((isCreditsBGM and not(isContinuousBGM)) or isResetBGM) then
        -- Play the next credits BGM if it exists, or reset this state when resetting the game
        if (isCreditsActive) then
            STATE.setIsCredits(false)
        end
    end

    return STATE.getIsCredits()
end

-- Main logic
function executeGameLogic()
    -- Saved BGM values
    local saved_bgm_scene = STATE.getSceneBGM()
    local saved_bgm_player = STATE.getCurrentBGM()
    local saved_bgm_memory_real_time = STATE.getRealTimeBGM()
    local saved_bgm_scene_hex = UTIL.valueToHexString(saved_bgm_scene)
    local saved_bgm_memory_hex = UTIL.valueToHexString(saved_bgm_memory_real_time)
    -- BGM values in memory at currently rendered frame
    local bgm_current = OOT.getCurrentBGM()
    local bgm_scene_current = OOT.getCurrentSceneBGM()
    local bgm_hex = UTIL.valueToHexString(bgm_current)
    -- Track control conditions
    local isDifferentBGM = bgm_current ~= saved_bgm_memory_real_time
    local isDifferentSceneBGM = bgm_scene_current ~= saved_bgm_scene
    -- Volume control conditions
    local volume = STATE.getVolume()
    local audio_buffer_frames = STATE.getAudioBufferFrames()
    local limit = STATE.getVolumeLimits()
    local changeSpeed = STATE.getVolumeChangeSpeeds()
    local isMuted = volume == limit.min
    local isMenuOpen = OOT.isStartMenuOpen()
    local isPaused = STATE.getIsPaused()
    local scene_id = OOT.getScene()
    local isDifferentSceneId = scene_id ~= getCachedSceneId()
    -- Special BGM identification
    local bgm_correct_hex = BGM.getCorrectSequence(bgm_hex, saved_bgm_scene_hex)
    local isIncorrectBGM = bgm_correct_hex
    local isEventBGM = BGM.isEvent(bgm_hex)
    local isSilentBGM = BGM.isSilent(bgm_hex)
    local isFadeOutBGM = BGM.isFadeOut(bgm_hex)
    local isEndingNightBGM = false
    local isCreditsActive = STATE.getIsCredits()
    local isDisabledCreditsBGM = BGM.isGameSequenceDisabled(bgm_hex)
    local isGameOverBGM = OOT.isGameOver()

    -- Save actual BGM value for use in determining if we've changed BGMs in the next frame
    saveRealTimeBGM(bgm_current)

    -- Save the scene BGM when entering a new scene
    if (isDifferentSceneBGM) then
        saveSceneBGM(bgm_scene_current)
    end

    -- Update the BGM position if necessary (for resuming a track we're returning to)
    if (STATE.getResumeTrackPosition() and audio_buffer_frames == 0) then
        PLAYER.goToPosition(STATE.getResumeTrackPosition())
        STATE.setResumeTrackPosition(false)
    end

    -- Ignore track changes if credits are considered active
    if (isCreditsActive) then
        isDifferentBGM = false
        isFadeOutBGM = false
    end

    -- Handling for credits, disabling in-game music and maintaining BGMs through multiple sequences
    toggleIsCreditsState(bgm_hex)

    -- Forced retroactive disabling of certain credits BGMs
    if (isDisabledCreditsBGM) then
        OOT.setCurrentlyPlayingBGM(tonumber(SEQ.SILENCE))
    end

    -- Gerudo Valley BGM bug handling
    if (isIncorrectBGM) then
        -- Change the track to silence on this frame to prevent the next BGM from resuming
        changeTrack(tonumber(SEQ.NULL))
        OOT.setCurrentBGM(tonumber(bgm_correct_hex))
    end

    -- Handling for certain temporary BGMs that take over the scene BGM and don't revert back
    -- (minigame, miniboss, etc.)
    if (isEventBGM) then
        if (BGM.isUninterruptableByEvent(saved_bgm_memory_hex)) then
            isDifferentBGM = false
        elseif (BGM.isFinishedWithEvent(bgm_hex, saved_bgm_scene_hex)) then
            OOT.setCurrentBGM(saved_bgm_scene)
        end
    end

    -- Ocarina minigame handling
    if (isSilentBGM) then
        local isOcarinaGame =
            OOT.getScene() == SCENE.LOST_WOODS.ID
            and OOT.getRoom() == SCENE.LOST_WOODS.ROOMS.MINIGAME
            and saved_bgm_scene_hex == SEQ.LOST_WOODS

        if (isOcarinaGame and OOT.isOcarinaGameClear()) then
            OOT.setCurrentBGM(saved_bgm_scene)
        end
    end

    -- Forced fade out handling for travling between linked scenes that share a vanilla game sequence but can contain
    -- two separate playlist tracks in this script (ex: Hyrule Field <-> Lake Hylia)
    if (isDifferentSceneId) then
        if (BGM.isNextSceneUsingDifferentTrack(bgm_hex)) then
            if (isPaused) then
                if (isFadingOut()) then
                    -- Add audio buffer timer to prevent volume jumping before the track has changed
                    local buffer_amount = math.abs(limit.max - limit.min)
                    STATE.setAudioBufferFrames(buffer_amount)
                    setIsFadingOut(false)
                elseif (audio_buffer_frames == 0) then
                    -- Track is paused, so it's time to switch to the next track
                    setCachedSceneId(scene_id)
                    isDifferentBGM = true
                end
            elseif (not(isFadingOut())) then
                -- Track isn't paused, so we need to manually fade out
                setIsFadingOut(true)
            end
        else
            setCachedSceneId(scene_id)
        end
    end


    -- Night BGM start handling
    if (BGM.canChangeToNight(bgm_hex, saved_bgm_scene_hex, saved_bgm_player) and not(isDifferentSceneId)) then
        isDifferentBGM = true
    end

    -- Game Over handling
    if (isGameOverBGM) then
        isFadeOutBGM = false
        bgm_current = OOT.getCurrentFanfare()
    end

    -- Change track when necessary if nothing has forbidden it by this point
    if (isDifferentBGM and not(isFadeOutBGM)) then
        changeTrack(bgm_current)
    end

    -- Night BGM fade out to morning handling
    if (isSilentBGM and BGM.isField(saved_bgm_scene_hex) and BGM.isSunrise()) then
        isFadeOutBGM = true

        -- Enable flag to force a track change to ensure daytime BGM does not resume from saved position
        local bgm_player_previous = STATE.getPreviousBGM()
        if (BGM.isTrackIndexDayFieldBGM(bgm_player_previous)) then
            isEndingNightBGM = true
        end
    end

    if (isFadeOutBGM or isFadingOut()) then
        -- Fade current BGM out by lowering volume until reaching the minimum
        if (volume > limit.min) then
            local fadeOutVolumeChangeAmount = changeSpeed.normal

            if (BGM.isField(saved_bgm_scene_hex)) then
                if (BGM.isUrgent(bgm_hex) or OOT.isCameraEventActive()) then
                    -- Fade out the field BGM faster if switching to a BGM marked as urgent or travling to a new scene
                    fadeOutVolumeChangeAmount = changeSpeed.fast
                elseif (not OOT.isGameControllingEvent()) then
                    -- Fade out the field BGM slower if we're not warping between areas (for day/night)
                    fadeOutVolumeChangeAmount = changeSpeed.slow
                end
            end

            setVolume(volume - fadeOutVolumeChangeAmount)
        elseif (isEndingNightBGM) then
            -- Stop the media player once minimum volume has been reached if we're fading out a night BGM
            changeTrack(SEQ.SILENCE)
        elseif (not isPaused) then
            -- Pause the media player once minimum volume has been reached when fading out a BGM
            togglePauseTrack()
        end
    
    else
        -- Otherwise, keep the volume within expected ranges based on what we're doing
        if (isMenuOpen and not(isGameOverBGM)) then
            -- Lower the volume when the menu is open
            if (volume > limit.pause) then
                setVolume(volume - changeSpeed.normal)
            end
        elseif (not(isPaused) and volume < limit.max) then
            -- Turn the volume up if it's meant to be up
            setVolume(volume + changeSpeed.normal)
        elseif (volume < limit.min) then
            -- Ensure the volume bottoms out at the minimum
            volume = limit.min
        elseif (volume > limit.max) then
            -- Ensure the volume caps at the maximum
            volume = limit.max
        end
    end
end

FORM.init()

while true do
    -- Buffer used for delaying audio changes
    local audio_buffer_frames = STATE.getAudioBufferFrames()

    -- Decrement any existing buffer
    if (audio_buffer_frames > 0) then
        STATE.setAudioBufferFrames(audio_buffer_frames - 1)
    end

    executeGameLogic()
    emu.frameadvance()
end

event.onexit(function ()
    PLAYER.stopTrack()
    FORM.onExit()
end)