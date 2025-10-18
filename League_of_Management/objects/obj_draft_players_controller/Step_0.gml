
//available_players = get_available_players(global.player_draft)

// Check if it's AI's turn to pick (team 2)
if (global.player_draft.active && get_current_team_player_draft(global.player_draft) == 2) {
    // Use alarm to add delay before AI picks
	show_debug_message("Ai to pick")
	ai_pick_player(global.player_draft)
}

// Check if draft is complete and player wants to continue
if (!global.player_draft.active && keyboard_check_pressed(vk_space)) {
    show_debug_message("Moving to next room...");
    // Transition to game simulation or next screen
    room_goto(room_game_simulation);
}
