#region
global.playerXPositions = [
	60,
	60,
	60,
	60,
	60,
	
	1300,
	1300,
	1300,
	1300,
	1300
	]
	
global.playerYPositions = [
	200,
	300,
	400,
	500,
	600,
	
	200,
	300,
	400,
	500,
	600
	]	
#endregion


function create_team_display(_blue_team, _red_team){
	if(array_length(global.playerXPositions) == array_length(global.playerYPositions)){
		for(var  i = 0; i < array_length(global.playerXPositions); i++){
			if (i < 5) {
			    var blue_player = _blue_team.players[i];
			    show_debug_message("Blue Team Player Index: " + string(i));
			    create_player_display(blue_player, i);
			} else if (i - 5 < 5) {
			    var red_player = _red_team.players[i - 5];
			    show_debug_message("Red Team Player Index: " + string(i - 5));
			    create_player_display(red_player, i);
			}
		}
	}
}


function create_player_display(_player, index){
	show_debug_message("Player Team: " + string(_player.team))

	var display = instance_create_depth(500, 500, -1, obj_player_display)
				
	with(_player){
		self.display_id = display.id
	}
				
	with(display){
		self.player = _player
		self.x = global.playerXPositions[index]
		self.y = global.playerYPositions[index]
	}
	show_debug_message("Created: " + (_player.name) + " at " + string(global.playerXPositions[index]) + ", " + string(global.playerYPositions[index]))
}


function destroy_player_display(_display_id){
	if(_display_id != -1){
	    if (instance_exists(_display_id)) {
	        show_debug_message("Destroying display_id: " + string(_display_id));
	        instance_destroy(_display_id);
	    } else {
	        show_debug_message("Warning: display_id does not exist");
	    }
	}else{
		show_debug_message("Nothing to delete " + string(_display_id))
	}
}