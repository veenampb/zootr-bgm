local SEQ = BGM.getIdToSequenceMap()

local OVERWORLD = {
    NAME = 'Fields / Overworld',
    SEQUENCES = {
        SEQ.HYRULE_FIELD,
        SEQ.CAVERN,
        SEQ.LOST_WOODS,
        SEQ.GERUDO_VALLEY,
        SEQ.GROTTO,
    },
    SEQUENCES_CUSTOM = {
        SEQ.NIGHT_FIELD,
        SEQ.NIGHT_VALLEY,
        SEQ.LAKE_HYLIA,
        SEQ.NIGHT_LAKE_HYLIA,
        SEQ.DEATH_MOUNTAIN_TRAIL,
        SEQ.NIGHT_DEATH_MOUNTAIN_TRAIL,
        SEQ.ZORAS_FOUNTAIN_CHILD,
        SEQ.ZORAS_FOUNTAIN_ADULT,
        SEQ.GRAVEYARD,
        SEQ.ROYAL_FAMILYS_TOMB,
    },
}

return OVERWORLD
