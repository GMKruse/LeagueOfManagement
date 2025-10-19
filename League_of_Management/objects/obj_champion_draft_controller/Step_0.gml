var draft = global.champion_draft;

// Update available champions based on current phase
if (is_ban_phase_active(draft)) {
    available_champions = get_available_champions_for_ban(draft);
    
    // Check if it's AI's turn to ban
    if (get_current_team_banning(draft) == 2 && !ai_action_pending) {
        ai_action_pending = true;
        alarm[0] = 1 * room_speed; // AI bans after 2 seconds
    }
} else if (is_pick_phase_active(draft)) {
    available_champions = get_available_champions_for_pick(draft);
    
    // Check if it's AI's turn to pick
    if (get_current_team_picking(draft) == 2 && !ai_action_pending) {
        ai_action_pending = true;
        alarm[1] = 1 * room_speed; // AI picks after 2 seconds
    }
}

// Check if draft is complete and player wants to continue
if (is_draft_complete(draft) && keyboard_check_pressed(vk_space)) {
    show_debug_message("Champion draft complete! Moving to game simulation...");
    room_goto(room_game_simulation);
}
