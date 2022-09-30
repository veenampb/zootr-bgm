local BGM = require('zootr-bgm/bgm')

local SEQ = BGM.getIdToSequenceMap()

local FISHING_POND = {
    ID = 73,
    SEQ_IGNORE_ROOMS = {
        [SEQ.SHOOTING_GALLERY] = 0,
    },
}

return FISHING_POND
