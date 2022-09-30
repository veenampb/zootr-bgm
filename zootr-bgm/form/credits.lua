local SEQ = BGM.getIdToSequenceMap()

local CREDITS = {
    NAME = 'Credits',
    DESCRIPTION = 'If a credits BGM is not specified the last credits BGM that was specified prior to it will continue playing in its place upon switching scenes. Overworld credits must be specified in order for any subsequent credits BGMs to function. Leave these blank to use the default credits BGMs.',
    SEQUENCES = {
        SEQ.CREDITS_OVERWORLD,
        SEQ.CREDITS_LON_LON,
        SEQ.CREDITS_TEMPLE,
        SEQ.CREDITS_COURTYARD,
    },
}

return CREDITS
