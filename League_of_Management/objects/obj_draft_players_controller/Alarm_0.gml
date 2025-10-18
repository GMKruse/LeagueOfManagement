
available_players = get_available_players(global.player_draft)

show_debug_message("Available players: " + string(array_length(available_players)))

// Destroy old draft displays (y > 150 means they're in the draft area, not team display)
with (obj_player_display) {
    if (y > 150) {
        instance_destroy();
    }
}
