// Mouse Left Button Click Event
// Only allow clicking if we're in the draft phase and it's the player's turn

show_debug_message("Mouse clicked on player display!");

if (instance_exists(obj_draft_players_controller)) {
    var draft = global.player_draft;
    
    show_debug_message("Draft active: " + string(draft.active));
    show_debug_message("Current team: " + string(get_current_team_player_draft(draft)));
    
    // Check if draft is active and it's the player's turn (team 1)
    if (draft.active && get_current_team_player_draft(draft) == 1) {
        show_debug_message("It's player's turn!");
        
        // Check if this player is available for picking
        var available = get_available_players(draft);
        var is_available = false;
        
        show_debug_message("Checking if player " + player.name + " is available...");
        show_debug_message("Available players count: " + string(array_length(available)));
        
        for (var i = 0; i < array_length(available); i++) {
            show_debug_message("Comparing with: " + available[i].name);
            if (available[i] == player || available[i].name == player.name) {
                is_available = true;
                show_debug_message("Player is available!");
                break;
            }
        }
        
        if (is_available) {
            // Make the pick
            show_debug_message("Player picked: " + player.name + " for role " + get_current_role_player_draft(draft));
            
            // Add player to the team with display update
            add_player_to_team(global.player_team, player, true);
            
            // Update draft state
            array_push(draft.picked_players, player);
            draft.current_pick++;
            
            if (draft.current_pick % 2 == 0) {
                draft.current_role_index++;
            }
            
            if (draft.current_pick >= 10) {
                draft.active = false;
                show_debug_message("Draft complete!");
            }
            
            // Destroy all current player displays in the draft area
            with (obj_player_display) {
                // Only destroy displays that aren't part of team displays
                if (y > 150) { // Draft area displays are below y=150
                    instance_destroy();
                }
            }
            
            // Update available players list immediately
            with (obj_draft_players_controller) {
                available_players = get_available_players(global.player_draft);
                alarm[0] = 5; // Very short delay before showing next players
            }
        } else {
            show_debug_message("Player not available for current role");
        }
    } else {
        show_debug_message("Not player's turn or draft not active");
    }
} else {
    show_debug_message("Draft controller not found!");
}
