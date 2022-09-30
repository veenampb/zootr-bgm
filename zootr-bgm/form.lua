--[[
    Form functions

    Handles everything to do with the script form, from saving/loading playlist data
    to calling upon functions that restart the script with imported settings.
]]--

local FORM = {}

local MENU_FANFARE = require('zootr-bgm/form/menu_fanfare')
local THEMES = require('zootr-bgm/form/themes')
local HOUSES = require('zootr-bgm/form/houses')
local TOWNS = require('zootr-bgm/form/towns')
local OVERWORLD = require('zootr-bgm/form/overworld')
local DUNGEONS = require('zootr-bgm/form/dungeons')
local BOSSES = require('zootr-bgm/form/bosses')
local CREDITS = require('zootr-bgm/form/credits')

-- Window margins
local WINDOW_MARGIN_SM = 10
local WINDOW_MARGIN_MD = WINDOW_MARGIN_SM * 2
local WINDOW_MARGIN_LG = WINDOW_MARGIN_SM * 3

-- Window dimensions
local WINDOW_WIDTH = 650
local WINDOW_HEIGHT = 430
local INNER_WIDTH = WINDOW_WIDTH - (WINDOW_MARGIN_SM * 2)
local INNER_HEIGHT = WINDOW_HEIGHT - (WINDOW_MARGIN_SM * 2)

-- Sub window dimensions
local SUB_WINDOW_WIDTH = 500
local SUB_WINDOW_HEIGHT = 500
local SUB_INNER_WIDTH = SUB_WINDOW_WIDTH - (WINDOW_MARGIN_SM * 2)
local SUB_INNER_HEIGHT = SUB_WINDOW_HEIGHT - (WINDOW_MARGIN_SM * 2)

-- Component dimensions
local INPUT_HEIGHT = 20
local BUTTON_HEIGHT = INPUT_HEIGHT + 2
local BUTTON_HEIGHT_LG = BUTTON_HEIGHT * 2
local SCROLLBAR_WIDTH = 17

-- BGM field column dimensions
local FIELD_COLUMN_WIDTH = 250
local FIELD_COLUMN_HEIGHT = 500
local FIELD_INPUT_HEIGHT = INPUT_HEIGHT
local FIELD_INPUT_WIDTH = INPUT_HEIGHT
local FIELD_LABEL_WIDTH = FIELD_COLUMN_WIDTH - FIELD_INPUT_WIDTH
local FIELD_LABEL_HEIGHT = INPUT_HEIGHT - 5

-- Row vertical positions
local ROW_1 = 30
local ROW_2 = 60
local ROW_3 = 180
local ROW_4 = ROW_3 + INPUT_HEIGHT
local ROW_5 = 230
local ROW_6 = ROW_5 + FIELD_INPUT_HEIGHT - 5
local ROW_7 = 250

-- Columns
local BUTTONS_COLUMN_WIDTH = 200
local BUTTONS_COLUMN_1 = WINDOW_MARGIN_SM
local BUTTONS_COLUMN_2 = WINDOW_MARGIN_SM + BUTTONS_COLUMN_WIDTH
local BUTTONS_COLUMN_3 = WINDOW_MARGIN_SM + (BUTTONS_COLUMN_WIDTH * 2)
local BUTTONS_ROW_HEIGHT = BUTTON_HEIGHT_LG
local BUTTONS_ROW_1 = ROW_7
local BUTTONS_ROW_2 = ROW_7 + BUTTON_HEIGHT_LG
local BUTTONS_ROW_3 = ROW_7 + (BUTTON_HEIGHT_LG * 2)

-- Form field handles
local mainForm = nil
local playlistLabel = nil
local browseButton = nil
local log = nil
local saveButton = nil
local applyButton = nil
local bgmLabel = nil
local bgmCustomLabel = nil
-- Sub-form buttons
local menuFanfareButton = nil
local themesButton = nil
local housesButton = nil
local townsButton = nil
local overworldButton = nil
local dungeonsButton = nil
local bossesButton = nil
local creditsButton = nil

-- Sub-form field handles
local subForm = nil

-- Each item in the settings contains the input object and label object for that field
local settings = {}
-- <field ID> = <playlist track number> (stored in memory so subforms can operate independently until saved)
local savedSettings = {}
-- Keeps track of which fields are in the current subform
local subFormFields = {}

-- Contains the structures we compare against for validating imported settings
local settingsStructures = {
    MENU_FANFARE,
    THEMES,
    HOUSES,
    TOWNS,
    OVERWORLD,
    DUNGEONS,
    BOSSES,
    CREDITS,
}

-- BGM table import
local BGM_TABLE = BGM.getTable()

-- Cached playlist path
local CACHE_FILE = 'zootr-bgm/saved/settings.txt'


function FORM.init()
    -- Assignments
    mainForm = generateForm()
    playlistLabel = generatePlaylistLabel(mainForm)
    playlistInput = generatePlaylistInput(mainForm)
    browseButton = generateBrowseButton(mainForm)
    saveButton = generateSaveButton(mainForm)
    log = generateLogTextbox(mainForm)
    applyButton = generateApplyButton(mainForm)

    menuFanfareButton = generateMenuFanfareButton(mainForm)
    themesButton = generateThemesButton(mainForm)
    housesButton = generateHousesButton(mainForm)
    townsButton = generateTownsButton(mainForm)
    overworldButton = generateOverworldButton(mainForm)
    dungeonsButton = generateDungeonsButton(mainForm)
    bossesButton = generateBossesButton(mainForm)
    creditsButton = generateCreditsButton(mainForm)

    generateVolumeFields(mainForm)

    -- Properties
    forms.setproperty(playlistInput, 'ReadOnly', true)
    forms.setproperty(log, 'ReadOnly', true)

    importCachedPlaylist()
end

function generateForm()
    return forms.newform(WINDOW_WIDTH, WINDOW_HEIGHT, 'Media Player Controller for OoTR')
end

function generatePlaylistLabel(form)
    local x = WINDOW_MARGIN_SM
    local y = WINDOW_MARGIN_SM
    local width = INNER_WIDTH
    local height = INPUT_HEIGHT

    return forms.label(form, 'Import Playlist:', x, y, width, height, false)
end

function generatePlaylistInput(form)
    local width = INNER_WIDTH - 300
    local height = INPUT_HEIGHT
    local x = WINDOW_MARGIN_SM
    local y = ROW_1

    return forms.textbox(form, '', width, height, nil, x, y, false, true, nil)
end

function generateBrowseButton(form)
    local width = 150 - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT
    local x = INNER_WIDTH - WINDOW_MARGIN_MD - (width * 2)
    local y = ROW_1 - 1
    
    return forms.button(form, 'Browse', onBrowseButtonClick, x, y, width, height)
end

function generateSaveButton(form)
    local width = 150 - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT
    local x = INNER_WIDTH - WINDOW_MARGIN_SM - width
    local y = WINDOW_MARGIN_SM + WINDOW_MARGIN_MD - 1
    
    return forms.button(form, 'Save settings to this file', onSaveButtonClick, x, y, width, height)
end

function generateApplyButton(form)
    local width = 200 - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = INNER_WIDTH - WINDOW_MARGIN_SM - width
    local y = ROW_3
    
    return forms.button(form, 'Apply Changes and Play Music', onApplyButtonClick, x, y, width, height)
end

function generateLogTextbox(form)
    local width = INNER_WIDTH - SCROLLBAR_WIDTH
    local height = 100
    local x = WINDOW_MARGIN_SM
    local y = ROW_2

    return forms.textbox(form, '', width, height, nil, x, y, true, true, 'Vertical')
end

function generateVolumeFields(form)
    local x = WINDOW_MARGIN_SM

    local labelY = ROW_3
    local labelWidth = FIELD_LABEL_WIDTH
    local labelHeight = INPUT_HEIGHT

    local inputY = ROW_4
    local inputWidth = FIELD_LABEL_WIDTH / 2
    local inputHeight = INPUT_HEIGHT

    settings.VOLUME = {
        input = forms.textbox(form, '', inputWidth, inputHeight, nil, x, inputY, false, true, nil),
        label = forms.label(form, 'Volume dB reduction (0 - 50):', x, labelY, labelWidth, labelHeight, false),
    }
end

function FORM.printOutput(str) 
    local text = forms.gettext(log)
    local pos = #text
    forms.setproperty(log, "SelectionStart", pos)

    str = string.gsub (str, "\n", "\r\n")
    str = "[" .. os.date("%H:%M:%S", os.time()) .. "] " .. str

    if pos > 0 then
        str = "\r\n" .. str
    end

    forms.setproperty(log, "SelectedText", str)
end

function onBrowseButtonClick()
    local file = forms.openfile()
    importPlaylistFromFile(file)
end

function importPlaylistFromFile(file, isCachedImport)
    if (FILE.isTxt(file)) then
        forms.settext(playlistInput, file)
        local fileSettingsTable = FILE.generateTableFromFileContents(file)

        if (fileSettingsTable) then
            local validSettingsTable = getValidSettings()
            local filteredSettingsTable = UTIL.filterTableByMatchingKeys(validSettingsTable, fileSettingsTable)

            if (UTIL.getTableSize(filteredSettingsTable) > 0) then
                isCachedImport = isCachedImport or false
                importFileSettingsFromTable(filteredSettingsTable, isCachedImport)
                return true
            else
                FORM.printOutput('[Error] Playlist import failed. No valid settings found in the specified file.')
            end
        end
    else
        FORM.printOutput('[Error] Playlist import failed. File must be .txt extension.')
    end

    return false
end

function getValidSettings()
    local validSettings = {
        -- Volume is an independent setting
        VOLUME = 1,
    }

    for key, STRUCTURE in pairs(settingsStructures) do
        if (STRUCTURE.SEQUENCES) then
            for sequenceKey, sequenceId in pairs(STRUCTURE.SEQUENCES) do
                local sequenceData = BGM_TABLE[sequenceId]
                validSettings[sequenceData.id] = 1
            end
        end

        if (STRUCTURE.SEQUENCES_CUSTOM) then
            for sequenceKey, sequenceId in pairs(STRUCTURE.SEQUENCES_CUSTOM) do
                local sequenceData = BGM_TABLE[sequenceId]
                validSettings[sequenceData.id] = 1
            end
        end
    end

    return validSettings
end

function importFileSettingsFromTable(fileSettingsTable, isCachedImport)
    resetAllFields()
    assignValuesToFields(fileSettingsTable)

    -- Overwrite saved settings table
    savedSettings = fileSettingsTable

    if (isCachedImport) then
        FORM.printOutput('Saved playlist import successful!')
    else
        FORM.printOutput('Playlist import complete! Click on the "Apply Changes and Play Music" button to start playing music with these settings!')
    end
end

function assignValuesToFields(fieldValueMap)
    for key, value in pairs(fieldValueMap) do
        FORM.setFieldText(key, value)
    end
end

function resetAllFields()
    for key in pairs(settings) do
        FORM.setFieldText(key, '')
    end
end

function FORM.setFieldText(fieldId, fieldValue)
    if (settings[fieldId]) then
        forms.settext(settings[fieldId].input, fieldValue)
    end
end

function onSaveButtonClick()
    local filePath = forms.gettext(playlistInput)
    savePlaylistToFile(filePath)
end

function savePlaylistToFile(filePath)
    if (FILE.isTxt(filePath)) then
        local settingsTable = generateSettingsTableFromFields()
        
        if (UTIL.getTableSize(settingsTable) > 0) then
            FILE.writeSettingsTableToFile(filePath, settingsTable)
            FORM.printOutput('Settings saved to file: ' .. filePath)
        else
            FORM.printOutput('[Error] No valid settings to save.')
        end
    else
        FORM.printOutput('[Error] Could not save playlist to file .. (' .. filePath .. '). File must be .txt extension.')
    end
end

function generateSettingsTableFromFields()
    local settingsTable = {}

    for id, setting in pairs(savedSettings) do
        -- local value = forms.gettext(setting.input)
        local value = savedSettings[id]

        -- Only numbers are valid settings
        if (tonumber(value)) then
            settingsTable[id] = value
        end
    end

    settingsTable.VOLUME = forms.gettext(settings.VOLUME.input)

    return settingsTable
end

function onApplyButtonClick()
    applySavedPlaylistData()

    -- Cache this playlist
    savePlaylistToFile(CACHE_FILE)
end

function importCachedPlaylist()
    FORM.printOutput('Attempting to import most recent playlist...')

    local isSuccessfulImport = importPlaylistFromFile(CACHE_FILE, true)

    if (isSuccessfulImport) then
        applySavedPlaylistData()
    end
end

function applySavedPlaylistData()
    local settingsTable = generateSettingsTableFromFields()
    BGM.assignPlaylistData(settingsTable)

    if (settingsTable.VOLUME) then
        local finalVolume = tonumber(settingsTable.VOLUME)

        if (finalVolume > 0) then
            finalVolume = finalVolume * -1
        end

        FORM.printOutput('Setting max volume to: ' .. tostring(finalVolume) .. 'dB')
        STATE.setMaxVolume(finalVolume)
    end

    STATE.reset()
end

function FORM.onExit()
    forms.destroy(mainForm)
end

function generateMenuFanfareButton(form)
    local STRUCTURE = MENU_FANFARE

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_1
    local y = BUTTONS_ROW_1
    
    return forms.button(form, STRUCTURE.NAME, onMenuFanfareButtonClick, x, y, width, height)
end

function generateThemesButton(form)
    local STRUCTURE = THEMES

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_1
    local y = BUTTONS_ROW_2
    
    return forms.button(form, STRUCTURE.NAME, onThemesButtonClick, x, y, width, height)
end

function generateHousesButton(form)
    local STRUCTURE = HOUSES

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_3
    local y = BUTTONS_ROW_2
    
    return forms.button(form, STRUCTURE.NAME, onHousesButtonClick, x, y, width, height)
end

function generateTownsButton(form)
    local STRUCTURE = TOWNS

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_3
    local y = BUTTONS_ROW_1
    
    return forms.button(form, STRUCTURE.NAME, onTownsButtonClick, x, y, width, height)
end

function generateOverworldButton(form)
    local STRUCTURE = OVERWORLD

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_2
    local y = BUTTONS_ROW_1
    
    return forms.button(form, STRUCTURE.NAME, onOverworldButtonClick, x, y, width, height)
end

function generateDungeonsButton(form)
    local STRUCTURE = DUNGEONS

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_2
    local y = BUTTONS_ROW_2
    
    return forms.button(form, STRUCTURE.NAME, onDungeonsButtonClick, x, y, width, height)
end

function generateBossesButton(form)
    local STRUCTURE = BOSSES

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_2
    local y = BUTTONS_ROW_3
    
    return forms.button(form, STRUCTURE.NAME, onBossesButtonClick, x, y, width, height)
end

function generateCreditsButton(form)
    local STRUCTURE = CREDITS

    local width = BUTTONS_COLUMN_WIDTH - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = BUTTONS_COLUMN_1
    local y = BUTTONS_ROW_3
    
    return forms.button(form, STRUCTURE.NAME, onCreditsButtonClick, x, y, width, height)
end

function onMenuFanfareButtonClick()
    subFormInit(MENU_FANFARE)
end

function onThemesButtonClick()
    subFormInit(THEMES)
end

function onHousesButtonClick()
    subFormInit(HOUSES)
end

function onTownsButtonClick()
    subFormInit(TOWNS)
end

function onOverworldButtonClick()
    subFormInit(OVERWORLD)
end

function onDungeonsButtonClick()
    subFormInit(DUNGEONS)
end

function onBossesButtonClick()
    subFormInit(BOSSES)
end

function onCreditsButtonClick()
    subFormInit(CREDITS)
end

function subFormInit(subFormData)
    local STRUCTURE = subFormData

    subForm = generateSubForm(STRUCTURE.NAME .. ' - Playlist Track Number Assignment')
    generateSubFormTrackNumberFields(subForm, STRUCTURE)
    forms.setproperty(mainForm, 'Enabled', false)

    local description = STRUCTURE.DESCRIPTION

    if (not(STRUCTURE.DESCRIPTION) and STRUCTURE.SEQUENCES_CUSTOM) then
        description = [[
The BGMs listed on the right are shared between multiple locations or events in-game.
Specifying a track for these will override the default BGM for just the listed location/event.
Custom BGMs can also be added for locations or events that normally contain no BGM.
        ]]
    end

    local subFormDescriptionLabel = generateSubFormDescriptionLabel(subForm, description)
    local subFormCancelButton = generateSubFormCancelButton(subForm)
    local subFormSaveButton = generateSubFormSaveButton(subForm)
end

function generateSubForm(name)
    return forms.newform(SUB_WINDOW_WIDTH, SUB_WINDOW_HEIGHT, name)
end

function generateSubFormDescriptionLabel(form, description)
    if (description) then
        local width = SUB_INNER_WIDTH - WINDOW_MARGIN_SM
        local height = FIELD_LABEL_HEIGHT * 3
        local x = WINDOW_MARGIN_SM
        local y = SUB_INNER_HEIGHT - (BUTTON_HEIGHT_LG * 3)

        return forms.label(form, description, x, y, width, height, false)
    end
end

function generateSubFormCancelButton(form)
    local width = 200 - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = WINDOW_MARGIN_SM
    local y = SUB_INNER_HEIGHT - BUTTON_HEIGHT_LG - WINDOW_MARGIN_LG
    
    return forms.button(form, 'Cancel', onSubFormCancelButtonClick, x, y, width, height)
end

function onSubFormCancelButtonClick()
    forms.destroy(subForm)
    forms.setproperty(mainForm, 'Enabled', true)
end

function generateSubFormSaveButton(form)
    local width = 200 - WINDOW_MARGIN_MD
    local height = BUTTON_HEIGHT_LG
    local x = SUB_INNER_WIDTH - width - WINDOW_MARGIN_SM
    local y = SUB_INNER_HEIGHT - BUTTON_HEIGHT_LG - WINDOW_MARGIN_LG
    
    return forms.button(form, 'Save', onSubFormSaveButtonClick, x, y, width, height)
end

function onSubFormSaveButtonClick()
    saveLoadedFields()

    forms.destroy(subForm)
    forms.setproperty(mainForm, 'Enabled', true)
end

function saveLoadedFields()
    for id in pairs(subFormFields) do
        local setting = settings[id]
        local value = forms.gettext(setting.input)

        -- Only numbers are valid settings
        if (tonumber(value)) then
            savedSettings[id] = value
        else
            savedSettings[id] = ''
        end
    end
end

function generateSubFormTrackNumberFields(form, subFormData, isCustom)
    local STRUCTURE = subFormData
    local SEQUENCES = nil
    
    local mainY = ROW_1
    local x = WINDOW_MARGIN_SM
    local y = mainY
    local count = 0

    if (isCustom) then
        x = x + FIELD_COLUMN_WIDTH
        SEQUENCES = STRUCTURE.SEQUENCES_CUSTOM
        bgmCustomLabel = forms.label(form, 'Override BGM for location or event:', x, WINDOW_MARGIN_SM, FIELD_LABEL_WIDTH, FIELD_LABEL_HEIGHT, false)
    else
        -- Clear out subFormFields to save this form's field IDs
        subFormFields = {}
        SEQUENCES = STRUCTURE.SEQUENCES
        bgmLabel = forms.label(form, 'Default BGMs:', x, WINDOW_MARGIN_SM, FIELD_LABEL_WIDTH, FIELD_LABEL_HEIGHT, false)
    end
    
    for bgmOrder, bgmSeq in pairs(SEQUENCES) do
        count = count + 1

        local fieldData = BGM_TABLE[bgmSeq]
        local fieldValue = savedSettings[fieldData.id]

        local labelX = x + FIELD_INPUT_WIDTH
        local labelY = y + 3

        local fieldHeightMultiplier = 1

        -- The multiline property in BGM_TABLE determines how many lines of height the field should take up
        if (fieldData.multiline) then
            fieldHeightMultiplier = fieldData.multiline
        end

        settings[fieldData.id] = {
            input = forms.textbox(form, fieldValue, FIELD_INPUT_WIDTH, FIELD_INPUT_HEIGHT, nil, x, y, false, true, nil),
            label = forms.label(form, fieldData.name, labelX, labelY, FIELD_LABEL_WIDTH, FIELD_LABEL_HEIGHT * fieldHeightMultiplier, false),
        }

        subFormFields[fieldData.id] = 1;

        if (fieldHeightMultiplier > 1) then
            y = y + ((FIELD_INPUT_HEIGHT * 0.75) * fieldHeightMultiplier)
        else
            y = y + FIELD_INPUT_HEIGHT + 1;
        end
    end

    if (STRUCTURE.SEQUENCES_CUSTOM and not(isCustom)) then
        generateSubFormTrackNumberFields(form, subFormData, true)
    end
end

return FORM
