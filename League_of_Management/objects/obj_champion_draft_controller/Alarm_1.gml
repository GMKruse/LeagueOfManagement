// Alarm[1] - AI Pick
var draft = global.champion_draft;

if (is_pick_phase_active(draft) && get_current_team_picking(draft) == 2) {
    var ai_picked = ai_pick_champion(draft);
    
    if (ai_picked != noone) {
        show_debug_message("AI picked: " + ai_picked.name);
        
        // Destroy all draft champion displays
        with (obj_champion_display) {
            if (!is_team_display) {
                instance_destroy();
            }
        }
        
        // Update available champions if pick phase still active
        if (is_pick_phase_active(draft)) {
            available_champions = get_available_champions_for_pick(draft);
            alarm[2] = 5; // Short delay before showing next champions
        }
    }
    
    ai_action_pending = false;
}
