#region // Tower Type Enum
enum TOWER_TYPE {
    OUTER,
    INNER,
    INHIBITOR_TOWER,
    NEXUS_TOWER
}

enum LANE {
    TOP,
    MID,
    BOT,
    NONE
}

enum TEAM {
    BLUE,
    RED
}
#endregion

#region // Position Arrays
global.towerXPositions = [
    440,  // 0  - blueNexusTowerTop
    455,  // 1  - blueNexusTowerBot
    410,  // 2  - blueInhibitorTowerTop
    535,  // 3  - blueInhibitorTowerMid
    575,  // 4  - blueInhibitorTowerBot
    410,  // 5  - blueInnerTowerTop
    590,  // 6  - blueInnerTowerMid
    690,  // 7  - blueInnerTowerBot
    410,  // 8  - blueOuterTowerTop
    665,  // 9  - blueOuterTowerMid
    860,  // 10 - blueOuterTowerBot
    
    955,  // 11 - redNexusTowerTop
    980,  // 12 - redNexusTowerBot
    835,  // 13 - redInhibitorTowerTop
    880,  // 14 - redInhibitorTowerMid
    1005, // 15 - redInhibitorTowerBot
    700,  // 16 - redInnerTowerTop
    830,  // 17 - redInnerTowerMid
    1005, // 18 - redInnerTowerBot
    520,  // 19 - redOuterTowerTop
    750,  // 20 - redOuterTowerMid
    1005  // 21 - redOuterTowerBot
]

global.towerYPositions = [
    540,  // 0
    560,  // 1
    450,  // 2
    490,  // 3
    600,  // 4
    370,  // 5
    450,  // 6
    600,  // 7
    215,  // 8
    370,  // 9
    600,  // 10
    
    110,  // 11
    135,  // 12
    80,   // 13
    195,  // 14
    230,  // 15
    80,   // 16
    240,  // 17
    330,  // 18
    80,   // 19
    310,  // 20
    460   // 21
]

// Tower metadata: [type, lane, team]
global.towerMetadata = [
    [TOWER_TYPE.NEXUS_TOWER, LANE.TOP, TEAM.BLUE],      // 0
    [TOWER_TYPE.NEXUS_TOWER, LANE.BOT, TEAM.BLUE],      // 1
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.TOP, TEAM.BLUE],  // 2
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.MID, TEAM.BLUE],  // 3
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.BOT, TEAM.BLUE],  // 4
    [TOWER_TYPE.INNER, LANE.TOP, TEAM.BLUE],            // 5
    [TOWER_TYPE.INNER, LANE.MID, TEAM.BLUE],            // 6
    [TOWER_TYPE.INNER, LANE.BOT, TEAM.BLUE],            // 7
    [TOWER_TYPE.OUTER, LANE.TOP, TEAM.BLUE],            // 8
    [TOWER_TYPE.OUTER, LANE.MID, TEAM.BLUE],            // 9
    [TOWER_TYPE.OUTER, LANE.BOT, TEAM.BLUE],            // 10
    
    [TOWER_TYPE.NEXUS_TOWER, LANE.TOP, TEAM.RED],       // 11
    [TOWER_TYPE.NEXUS_TOWER, LANE.BOT, TEAM.RED],       // 12
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.TOP, TEAM.RED],   // 13
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.MID, TEAM.RED],   // 14
    [TOWER_TYPE.INHIBITOR_TOWER, LANE.BOT, TEAM.RED],   // 15
    [TOWER_TYPE.INNER, LANE.TOP, TEAM.RED],             // 16
    [TOWER_TYPE.INNER, LANE.MID, TEAM.RED],             // 17
    [TOWER_TYPE.INNER, LANE.BOT, TEAM.RED],             // 18
    [TOWER_TYPE.OUTER, LANE.TOP, TEAM.RED],             // 19
    [TOWER_TYPE.OUTER, LANE.MID, TEAM.RED],             // 20
    [TOWER_TYPE.OUTER, LANE.BOT, TEAM.RED]              // 21
]

global.inhibitorXPositions = [
    410,  // 0 - blueTop
    507,  // 1 - blueMid
    540,  // 2 - blueBot
    
    870,  // 3 - redTop
    915,  // 4 - redMid
    1005  // 5 - redBot
]

global.inhibitorYPositions = [
    490,  // 0
    513,  // 1
    600,  // 2
    80,   // 3
    170,  // 4
    190   // 5
]

// Inhibitor metadata: [lane, team]
global.inhibitorMetadata = [
    [LANE.TOP, TEAM.BLUE],  // 0
    [LANE.MID, TEAM.BLUE],  // 1
    [LANE.BOT, TEAM.BLUE],  // 2
    [LANE.TOP, TEAM.RED],   // 3
    [LANE.MID, TEAM.RED],   // 4
    [LANE.BOT, TEAM.RED]    // 5
]

global.nexusXPositions = [420, 995]  // blue, red
global.nexusYPositions = [585, 90]
#endregion

#region // Game State Arrays
global.towerArray = []
global.attackableTowers = []
global.inhibitorArray = []
global.nexusArray = []

// Progression tracking
global.towerProgression = {
    blue: {
        top_outer: true,
        top_inner: false,
        top_inhib_tower: false,
        
        mid_outer: true,
        mid_inner: false,
        mid_inhib_tower: false,
        
        bot_outer: true,
        bot_inner: false,
        bot_inhib_tower: false,
        
        nexus_towers: false,
        nexus: false
    },
    red: {
        top_outer: true,
        top_inner: false,
        top_inhib_tower: false,
        
        mid_outer: true,
        mid_inner: false,
        mid_inhib_tower: false,
        
        bot_outer: true,
        bot_inner: false,
        bot_inhib_tower: false,
        
        nexus_towers: false,
        nexus: false
    }
}

global.inhibitorProgression = {
    blue: {
        top: false,
        mid: false,
        bot: false,
        any_down: false
    },
    red: {
        top: false,
        mid: false,
        bot: false,
        any_down: false
    }
}
#endregion

#region // Creation Functions
function createTowers() {
    if (array_length(global.towerXPositions) != array_length(global.towerYPositions)) {
        show_debug_message("ERROR: Tower position arrays don't match!");
        return;
    }
    
    for (var i = 0; i < array_length(global.towerXPositions); i++) {
        var tower = instance_create_depth(global.towerXPositions[i], global.towerYPositions[i], -1, obj_tower);
        
        with (tower) {
            self.given_id = i;
            self.image_xscale = 0.04;
            self.image_yscale = 0.04;
            
            // Set tower properties from metadata
            var meta = global.towerMetadata[i];
            self.tower_type = meta[0];
            self.lane = meta[1];
            self.team = meta[2];
            
            // Only outer towers start as attackable
            self.is_attackable = (tower_type == TOWER_TYPE.OUTER);
        }
        
        array_push(global.towerArray, tower);
        
        // Add outer towers to attackable array
        if (tower.tower_type == TOWER_TYPE.OUTER) {
            array_push(global.attackableTowers, tower);
        }
    }
}

function createInhibitors() {
    if (array_length(global.inhibitorXPositions) != array_length(global.inhibitorYPositions)) {
        show_debug_message("ERROR: Inhibitor position arrays don't match!");
        return;
    }
    
    for (var i = 0; i < array_length(global.inhibitorXPositions); i++) {
        var inhibitor = instance_create_depth(global.inhibitorXPositions[i], global.inhibitorYPositions[i], -1, obj_inhibitor);
        
        with (inhibitor) {
            self.given_id = i;
            self.image_xscale = 0.04;
            self.image_yscale = 0.04;
            
            // Set inhibitor properties
            var meta = global.inhibitorMetadata[i];
            self.lane = meta[0];
            self.team = meta[1];
            self.is_attackable = false;  // Inhibitors start locked
        }
        
        array_push(global.inhibitorArray, inhibitor);
    }
}

function createNexus() {
    if (array_length(global.nexusXPositions) != array_length(global.nexusYPositions)) {
        show_debug_message("ERROR: Nexus position arrays don't match!");
        return;
    }
    
    for (var i = 0; i < array_length(global.nexusXPositions); i++) {
        var nexus = instance_create_depth(global.nexusXPositions[i], global.nexusYPositions[i], -1, obj_nexus);
        
        with (nexus) {
            self.image_xscale = 0.06;
            self.image_yscale = 0.06;
            self.team = (i == 0) ? TEAM.BLUE : TEAM.RED;
            self.is_attackable = false;  // Nexus starts locked
        }
        
        array_push(global.nexusArray, nexus);
    }
}

function createDragon() {
    var dragon = instance_create_depth(832, 468, -1, obj_dragon);
    with (dragon) {
        self.image_xscale = 0.1;
        self.image_yscale = 0.1;
    }
}

function createBaron() {
    var baron = instance_create_depth(590, 215, -1, obj_baron);
    with (baron) {
        self.image_xscale = 0.1;
        self.image_yscale = 0.1;
    }
}
#endregion