-- Interface to work with Beefweb Remote Control for foobar2000

local PLAYER = {}

local socket = require('socket')
local http = require('socket.http')
local ltn12 = require('ltn12')
local JSON = require('zootr-bgm/json')

local PORT = 8880

local DEFAULT_PAYLOAD = [[ "" ]]

-- We communicate with foobar2000 via POST requests to the interface Beefweb Remote Control already
-- has set up for communicating with its corresponding UI. While more direct access to foobar2000
-- would be preferred that requires messing with the SDK and creating a new component for it.
function sendRequest(pathname, payload)
    local request_pathname = pathname or ''
    local request_payload = payload or DEFAULT_PAYLOAD

    local path = 'http://localhost:' .. PORT .. '/api/player' .. request_pathname
    local source_string = '{ "payload": ' .. request_payload .. ' }'
    local response_body = {}
    
    local res, code, response_headers, status = http.request {
        url = path,
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
            ['Content-Length'] = string.len(request_payload),
        },
        source = ltn12.source.string(request_payload),
        sink = ltn12.sink.table(response_body)
    }
end

function getRequest(pathname)
    local request_pathname = pathname or ''
    local path = 'http://localhost:' .. PORT .. '/api/player' .. request_pathname
    local res, code, response_headers, status = http.request(path)

    return res
end

function PLAYER.changeTrack(value)
    local pathname = '/play/'
    local playlist = 'p1'
    local bgm_hex = UTIL.valueToHexString(value)
    local bgm_index = BGM.getTrackIndex(bgm_hex)
    local request = pathname .. playlist .. '/' .. bgm_index
    local track_number = bgm_index + 1
    local track_name = BGM.getName(bgm_hex)

    sendRequest(request)
    FORM.printOutput('Changing track to: ' .. track_number .. ' - ' .. track_name .. ' (' .. bgm_hex .. ')')

    PLAYER.getCurrentTrackData()
end

function PLAYER.stopTrack()
    local request = '/stop'
    sendRequest(request)
    FORM.printOutput('Stopping track')
end

function PLAYER.togglePauseTrack()
    local request = '/pause/toggle'
    sendRequest(request)

    if (STATE.getIsPaused()) then
        FORM.printOutput('Pausing current track')
    else
        FORM.printOutput('Unpausing current track')
    end
end

function PLAYER.setVolume(value)
    local json = '{ "volume": ' .. value .. ' }'
    sendRequest('', json)
end

function PLAYER.goToPosition(value)
    local volumeLimit = STATE.getVolumeLimits()
    PLAYER.setVolume(volumeLimit.min)
    STATE.setVolume(volumeLimit.min)
    
    local json = '{ "position": ' .. value .. ' }'
    sendRequest('', json)
end

-- Visiting /api/player will get JSON data regarding the player's status
function getPlayerData()
    local response = getRequest()
    local data = JSON.parse(response)
    return data.player
end

function PLAYER.getCurrentTrackData()
    local player = getPlayerData()
    return player.activeItem
end

return PLAYER