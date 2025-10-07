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
	250,
	300,
	350,
	400
	]	
#endregion


function create_team_display(_blue_team, _red_team){
	if(array_length(global.playerXPositions) == array_length(global.playerYPositions)){
		for(var  i = 0; i < array_length(global.playerXPositions); i++){
			if(i < 5){		
				var player = get_player_id(_blue_team.players[i].name)
				
				with(player){
					self.x = global.playerXPositions[i]
					self.y = global.playerYPositions[i]
				}
				show_debug_message("I was here")
			}
		}
	}
}