// Alarm[0] - AI Ban
var draft = global.champion_draft;

if (is_ban_phase_active(draft) && get_current_team_banning(draft) == 2) {
    var ai_banned = ai_ban_champion(draft);
    
    if (ai_banned != noone) {
        show_debug_message("AI banned: " + ai_banned.name);
        
        // Destroy all draft champion displays
        with (obj_champion_display) {
            if (!is_team_display) {
                instance_destroy();
            }
        }
        
        // Update available champions
        if (is_ban_phase_active(draft)) {
            available_champions = get_available_champions_for_ban(draft);
            alarm[2] = 5; // Short delay before showing next champions
        } else if (is_pick_phase_active(draft)) {
            // Ban phase just ended, pick phase started
            show_debug_message("Transitioning to pick phase...");
            available_champions = get_available_champions_for_pick(draft);
            alarm[2] = 30; // Longer delay before first pick
        }
    }
    
    ai_action_pending = false;
}
