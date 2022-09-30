local SEQ = BGM.getIdToSequenceMap()

local BOSSES = {
    NAME = 'Battle Music',
    SEQUENCES = {
        SEQ.BATTLE,
        SEQ.MINIBOSS,
        SEQ.BOSS,
        SEQ.BOSS_FIRE,
        SEQ.GANONDORF_BATTLE,
        SEQ.GANON_BATTLE,
        SEQ.BOSS_DEFEATED,
    },
    SEQUENCES_CUSTOM = {
        SEQ.MINIBOSS_MONSTER,
        SEQ.DARK_LINK,
        SEQ.GOHMA,
        SEQ.BARINADE,
        SEQ.PHANTOM_GANON,
        SEQ.VOLVAGIA,
        SEQ.MORPHA,
        SEQ.BONGO_BONGO,
        SEQ.TWINROVA,
    },
}

return BOSSES
