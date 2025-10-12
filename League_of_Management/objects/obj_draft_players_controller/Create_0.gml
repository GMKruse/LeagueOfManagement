global.player_id_map = {};

init_player_pool()

global.player_team = createTeam(global.team_name)
global.ai_team = createTeam("C9")

//add_player_to_team(global.player_team, global.player_pool.top[0])
//add_player_to_team(global.player_team, global.player_pool.jungle[0])
//add_player_to_team(global.player_team, global.player_pool.adc[1])
//add_player_to_team(global.player_team, global.player_pool.support[1])

create_team_display(global.player_team, global.ai_team)

for(var i = 0; i < array_length(global.player_team.players); i ++){
	show_debug_message("create event display: " + string(global.player_team.players[i].display_id))
}

alarm[0] = 3 * room_speed;
