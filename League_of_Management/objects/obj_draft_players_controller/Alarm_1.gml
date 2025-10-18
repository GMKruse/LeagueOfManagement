// Alarm[1] - AI Pick
// This alarm is triggered when it's the AI's turn

if (global.player_draft.active && get_current_team_player_draft(global.player_draft) == 2) {
    // Get available players for current role
    var ai_pick = ai_pick_player(global.player_draft);
    
    if (ai_pick != noone) {
        show_debug_message("AI picked: " + ai_pick.name);
        
        // Destroy all draft player displays (but not team displays)
        with (obj_player_display) {
            if (!is_team_display) {
                instance_destroy();
            }
        }
        
        // Update available players list only if draft is still active
        if (global.player_draft.active) {
            available_players = get_available_players(global.player_draft);
            // Show next available players after a short delay
            alarm[0] = 5;
        }
    }
    
    // Reset the flag so AI can pick again if needed
    ai_pick_pending = false;
}
