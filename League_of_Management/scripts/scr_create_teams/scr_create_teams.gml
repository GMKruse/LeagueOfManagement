#region
global.playerXPositions = [
	60,
	60,
	60,
	60,
	60
	]
	
global.playerYPositions = [
	200,
	300,
	400,
	500,
	600
	]	
#endregion


function create_team_display(_blue_team, _red_team){
	show_debug_message(array_length(_blue_team.players))
	if(array_length(global.playerXPositions) == array_length(global.playerYPositions)){
		for(var  i = 0; i < array_length(global.playerXPositions); i++){
			if(i <= 4){		
				var player = get_player_id(_blue_team.players[i].name)
				
				with(player){
					self.x = global.playerXPositions[i]
					self.y = global.playerYPositions[i]
				}
				show_debug_message("Created: " + (_blue_team.players[i].name))
			}
		}
	}
}