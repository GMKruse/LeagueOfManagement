// Mouse Left Button Click Event
// Handle banning or picking a champion

if (!instance_exists(obj_champion_draft_controller)) {
    exit;
}

var draft = global.champion_draft;

// BAN PHASE
if (is_ban_phase_active(draft) && get_current_team_banning(draft) == 1) {
    var available = get_available_champions_for_ban(draft);
    var is_available = false;
    
    // Check if this champion is available
    for (var i = 0; i < array_length(available); i++) {
        if (available[i] == champion || available[i].name == champion.name) {
            is_available = true;
            break;
        }
    }
    
    if (is_available) {
        show_debug_message("Player banned: " + champion.name);
        make_champion_ban(draft, champion);
        
        // Destroy all draft displays
        with (obj_champion_display) {
            if (!is_team_display) {
                instance_destroy();
            }
        }
        
        // Update controller
        with (obj_champion_draft_controller) {
            if (is_ban_phase_active(global.champion_draft)) {
                available_champions = get_available_champions_for_ban(global.champion_draft);
                alarm[2] = 5;
            } else if (is_pick_phase_active(global.champion_draft)) {
                // Transitioned to pick phase
                available_champions = get_available_champions_for_pick(global.champion_draft);
                alarm[2] = 30; // Longer delay before picks start
            }
        }
    }
}

// PICK PHASE
else if (is_pick_phase_active(draft) && get_current_team_picking(draft) == 1) {
    var available = get_available_champions_for_pick(draft);
    var is_available = false;
    
    // Check if this champion is available
    for (var i = 0; i < array_length(available); i++) {
        if (available[i] == champion || available[i].name == champion.name) {
            is_available = true;
            break;
        }
    }
    
    if (is_available) {
        show_debug_message("Player picked: " + champion.name + " for role " + get_current_role_champion_draft(draft));
        make_champion_pick(draft, champion);
        
        // Destroy all draft displays
        with (obj_champion_display) {
            if (!is_team_display) {
                instance_destroy();
            }
        }
        
        // Update controller
        with (obj_champion_draft_controller) {
            if (is_pick_phase_active(global.champion_draft)) {
                available_champions = get_available_champions_for_pick(global.champion_draft);
                alarm[2] = 5;
            }
        }
    }
}
