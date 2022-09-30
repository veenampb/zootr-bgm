-- Collection of scene IDs and room IDs for use in identifying which track to play.
-- Also determines special rules for BGMs in certain rooms.

-- Thanks to Practice ROM for the debug patch, allowing easy access to scene and room info
-- https://www.practicerom.com

local SCENE = {}

SCENE.BOTTOM_OF_THE_WELL = require('./zootr-bgm/scene/bottom_of_the_well')
SCENE.CASTLE_COLLAPSE = require('./zootr-bgm/scene/castle_collapse')
SCENE.DEATH_MOUNTAIN_TRAIL = require('./zootr-bgm/scene/death_mountain_trail')
SCENE.DODONGOS_CAVERN = require('./zootr-bgm/scene/dodongos_cavern')
SCENE.FIRE_TEMPLE = require('./zootr-bgm/scene/fire_temple')
SCENE.FISHING_POND = require('./zootr-bgm/scene/fishing_pond')
SCENE.FOREST_TEMPLE = require('./zootr-bgm/scene/forest_temple')
SCENE.GERUDO_TRAINING_GROUND = require('./zootr-bgm/scene/gerudo_training_ground')
SCENE.GRAVEYARD = require('./zootr-bgm/scene/graveyard')
SCENE.HYRULE_FIELD = require('./zootr-bgm/scene/hyrule_field')
SCENE.INSIDE_DEKU_TREE = require('./zootr-bgm/scene/inside_deku_tree')
SCENE.JABU_JABU = require('./zootr-bgm/scene/jabu_jabu')
SCENE.LAKE_HYLIA = require('./zootr-bgm/scene/lake_hylia')
SCENE.LOST_WOODS = require('./zootr-bgm/scene/lost_woods')
SCENE.ROYAL_FAMILYS_TOMB = require('./zootr-bgm/scene/royal_familys_tomb')
SCENE.SHADOW_TEMPLE = require('./zootr-bgm/scene/shadow_temple')
SCENE.SHIELD_GRAVE = require('./zootr-bgm/scene/shield_grave')
SCENE.SPIRIT_TEMPLE = require('./zootr-bgm/scene/spirit_temple')
SCENE.SUNS_SONG_GRAVE = require('./zootr-bgm/scene/suns_song_grave')
SCENE.THIEVES_HIDEOUT = require('./zootr-bgm/scene/thieves_hideout')
SCENE.TOWER_COLLAPSE = require('./zootr-bgm/scene/tower_collapse')
SCENE.TOWER_EXTERIOR = require('./zootr-bgm/scene/tower_exterior')
SCENE.WATER_TEMPLE = require('./zootr-bgm/scene/water_temple')
SCENE.WINDMILL = require('./zootr-bgm/scene/windmill')

return SCENE
