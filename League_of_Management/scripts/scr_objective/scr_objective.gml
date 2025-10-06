#region // Destruction Functions
function destroy_tower(tower_inst) {
    // Remove from main tower array
    for (var i = 0; i < array_length(global.towerArray); i++) {
        if (global.towerArray[i] == tower_inst) {
            array_delete(global.towerArray, i, 1);
            break;
        }
    }
    
    // Remove from attackable array
    for (var i = 0; i < array_length(global.attackableTowers); i++) {
        if (global.attackableTowers[i] == tower_inst) {
            array_delete(global.attackableTowers, i, 1);
            break;
        }
    }
    
    // Update progression
    update_tower_progression(tower_inst.team, tower_inst.lane, tower_inst.tower_type);
    
    // Destroy instance
    instance_destroy(tower_inst);
}

function destroy_inhibitor(inhib_inst) {
    // Remove from inhibitor array
    for (var i = 0; i < array_length(global.inhibitorArray); i++) {
        if (global.inhibitorArray[i] == inhib_inst) {
            array_delete(global.inhibitorArray, i, 1);
            break;
        }
    }
    
    // Update progression
    update_inhibitor_progression(inhib_inst.team, inhib_inst.lane);
    
    // Destroy instance
    instance_destroy(inhib_inst);
}

function destroy_nexus(nexus_inst) {
    show_debug_message("GAME OVER! Team " + string(nexus_inst.team) + " nexus destroyed!");
    // Add your game over logic here
    instance_destroy(nexus_inst);
}
#endregion

#region // Progression System
function update_tower_progression(tower_team, tower_lane, tower_type) {
    var prog = (tower_team == TEAM.BLUE) ? global.towerProgression.blue : global.towerProgression.red;
    
    switch (tower_type) {
        case TOWER_TYPE.OUTER:
            // Outer destroyed -> unlock inner
            switch (tower_lane) {
                case LANE.TOP: prog.top_inner = true; break;
                case LANE.MID: prog.mid_inner = true; break;
                case LANE.BOT: prog.bot_inner = true; break;
            }
            break;
            
        case TOWER_TYPE.INNER:
            // Inner destroyed -> unlock inhibitor tower
            switch (tower_lane) {
                case LANE.TOP: prog.top_inhib_tower = true; break;
                case LANE.MID: prog.mid_inhib_tower = true; break;
                case LANE.BOT: prog.bot_inhib_tower = true; break;
            }
            break;
            
        case TOWER_TYPE.INHIBITOR_TOWER:
            // Inhibitor tower destroyed -> unlock inhibitor
            var inhib_prog = (tower_team == TEAM.BLUE) ? global.inhibitorProgression.blue : global.inhibitorProgression.red;
            switch (tower_lane) {
                case LANE.TOP: inhib_prog.top = true; break;
                case LANE.MID: inhib_prog.mid = true; break;
                case LANE.BOT: inhib_prog.bot = true; break;
            }
            refresh_inhibitor_attackable(tower_team);
            break;
            
        case TOWER_TYPE.NEXUS_TOWER:
            // Check if both nexus towers are down
            var nexus_count = 0;
            for (var i = 0; i < array_length(global.towerArray); i++) {
                if (global.towerArray[i].team == tower_team && global.towerArray[i].tower_type == TOWER_TYPE.NEXUS_TOWER) {
                    nexus_count++;
                }
            }
            
            // If no nexus towers remain, unlock nexus
            if (nexus_count == 0) {
                prog.nexus = true;
                refresh_nexus_attackable(tower_team);
            }
            break;
    }
    
    // Refresh which towers are now attackable
    refresh_tower_attackable(tower_team);
}

function update_inhibitor_progression(inhib_team, inhib_lane) {
    var prog = (inhib_team == TEAM.BLUE) ? global.inhibitorProgression.blue : global.inhibitorProgression.red;
    var tower_prog = (inhib_team == TEAM.BLUE) ? global.towerProgression.blue : global.towerProgression.red;
    
    // Any inhibitor down unlocks nexus towers
    prog.any_down = true;
    tower_prog.nexus_towers = true;
    
    refresh_tower_attackable(inhib_team);
}

function refresh_tower_attackable(team) {
    var prog = (team == TEAM.BLUE) ? global.towerProgression.blue : global.towerProgression.red;
    
    for (var i = 0; i < array_length(global.towerArray); i++) {
        var tower = global.towerArray[i];
        if (tower.team != team) continue;
        
        var was_attackable = tower.is_attackable;
        tower.is_attackable = false;
        
        switch (tower.tower_type) {
            case TOWER_TYPE.OUTER:
                tower.is_attackable = true;  // Always attackable
                break;
                
            case TOWER_TYPE.INNER:
                switch (tower.lane) {
                    case LANE.TOP: tower.is_attackable = prog.top_inner; break;
                    case LANE.MID: tower.is_attackable = prog.mid_inner; break;
                    case LANE.BOT: tower.is_attackable = prog.bot_inner; break;
                }
                break;
                
            case TOWER_TYPE.INHIBITOR_TOWER:
                switch (tower.lane) {
                    case LANE.TOP: tower.is_attackable = prog.top_inhib_tower; break;
                    case LANE.MID: tower.is_attackable = prog.mid_inhib_tower; break;
                    case LANE.BOT: tower.is_attackable = prog.bot_inhib_tower; break;
                }
                break;
                
            case TOWER_TYPE.NEXUS_TOWER:
                tower.is_attackable = prog.nexus_towers;
                break;
        }
        
        // Add/remove from attackable array
        if (tower.is_attackable && !was_attackable) {
            array_push(global.attackableTowers, tower);
        } else if (!tower.is_attackable && was_attackable) {
            for (var j = 0; j < array_length(global.attackableTowers); j++) {
                if (global.attackableTowers[j] == tower) {
                    array_delete(global.attackableTowers, j, 1);
                    break;
                }
            }
        }
    }
}

function refresh_inhibitor_attackable(team) {
    var prog = (team == TEAM.BLUE) ? global.inhibitorProgression.blue : global.inhibitorProgression.red;
    
    for (var i = 0; i < array_length(global.inhibitorArray); i++) {
        var inhib = global.inhibitorArray[i];
        if (inhib.team != team) continue;
        
        switch (inhib.lane) {
            case LANE.TOP: inhib.is_attackable = prog.top; break;
            case LANE.MID: inhib.is_attackable = prog.mid; break;
            case LANE.BOT: inhib.is_attackable = prog.bot; break;
        }
    }
}

function refresh_nexus_attackable(team) {
    var prog = (team == TEAM.BLUE) ? global.towerProgression.blue : global.towerProgression.red;
    
    for (var i = 0; i < array_length(global.nexusArray); i++) {
        var nexus = global.nexusArray[i];
        if (nexus.team == team) {
            nexus.is_attackable = prog.nexus;
        }
    }
}
#endregion

#region // Utility Functions
function can_attack_structure(structure_inst) {
    return structure_inst.is_attackable;
}

function get_attackable_towers_for_team(team) {
    var result = [];
    for (var i = 0; i < array_length(global.attackableTowers); i++) {
        if (global.attackableTowers[i].team == team) {
            array_push(result, global.attackableTowers[i]);
        }
    }
    return result;
}
#endregion