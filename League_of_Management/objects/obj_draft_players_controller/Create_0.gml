global.player_id_map = {};

init_player_pool()

global.player_team = createTeam(global.team_name)
global.ai_team = createTeam("C9")

with(global.player_team){
	self.side = "Blue"
	show_debug_message("Hey1")
}
with(global.ai_team){
	self.side = "Red"
	show_debug_message("Hey2")
}

create_team_display(global.player_team, global.ai_team)


alarm[0] = 3 * room_speed
alarm[1] = 5 * room_speed
