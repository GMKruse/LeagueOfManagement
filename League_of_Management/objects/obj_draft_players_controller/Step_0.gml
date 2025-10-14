
//available_players = get_available_players(global.player_draft)

// Check if it's AI's turn to pick (team 2)
if (global.player_draft.active && get_current_team_player_draft(global.player_draft) == 2) {
    // Use alarm to add delay before AI picks
    if (alarm[1] == -1) {
        alarm[1] = 2 * room_speed; // AI picks after 2 seconds
    }
}

// Check if draft is complete and player wants to continue
if (!global.player_draft.active && keyboard_check_pressed(vk_space)) {
    show_debug_message("Moving to next room...");
    // Transition to game simulation or next screen
    room_goto(room_game_simulation);
}
