

//add_player_to_team(global.player_team, global.player_pool.mid[0], true)
//add_player_to_team(global.player_team, global.player_pool.top[0], true)
//add_player_to_team(global.player_team, global.player_pool.jungle[0], true)
//add_player_to_team(global.player_team, global.player_pool.adc[1], true)
//add_player_to_team(global.player_team, global.player_pool.support[1], true)

//add_player_to_team(global.ai_team, global.player_pool.mid[1], true)
//add_player_to_team(global.ai_team, global.player_pool.top[1], true)
//add_player_to_team(global.ai_team, global.player_pool.jungle[1], true)
//add_player_to_team(global.ai_team, global.player_pool.adc[2], true)
//add_player_to_team(global.ai_team, global.player_pool.support[0], true)

available_players = get_available_players(global.player_draft)

show_debug_message("Available players: " + string(array_length(available_players)))

// Destroy old draft displays (y > 150 means they're in the draft area, not team display)
with (obj_player_display) {
    if (y > 150) {
        instance_destroy();
    }
}
