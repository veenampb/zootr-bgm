local BGM = require('zootr-bgm/bgm')

local SEQ = BGM.getIdToSequenceMap()

local WINDMILL = {
    ID = 72,
    ROOMS = {
        DAMPE = 0,
    },
    SEQ_IGNORE_ROOMS = {
        [SEQ.CAVERN] = 6,
    },
}

return WINDMILL
