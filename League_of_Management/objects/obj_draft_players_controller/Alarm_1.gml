// Alarm[1] - AI Pick
// This alarm is triggered when it's the AI's turn

if (global.player_draft.active && get_current_team_player_draft(global.player_draft) == 2) {
    // Get available players for current role
    var ai_pick = ai_pick_player(global.player_draft);
    
    if (ai_pick != noone) {
        show_debug_message("AI picked: " + ai_pick.name + " for role " + get_current_role_player_draft(global.player_draft));
        
        // Add player to AI team
        add_player_to_team(global.ai_team, ai_pick, true);
        
        // Update draft state
        array_push(global.player_draft.picked_players, ai_pick);
        global.player_draft.current_pick++;
        
        if (global.player_draft.current_pick % 2 == 0) {
            global.player_draft.current_role_index++;
        }
        
        if (global.player_draft.current_pick >= 10) {
            global.player_draft.active = false;
            show_debug_message("Draft complete!");
            // Could transition to next room here
        } else {
            // Destroy all current player displays
            with (obj_player_display) {
                if (object_index == obj_player_display) {
                    instance_destroy();
                }
            }
            
            // Show next available players
            alarm[0] = 10;
        }
    }
}
