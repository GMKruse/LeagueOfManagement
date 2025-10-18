
show_debug_message("Clicked: Team: " + string(player.team))
if(global.player_draft.active && player.team == noone){
	show_debug_message("I was here LOL")
	make_player_pick(global.player_draft, player)
}