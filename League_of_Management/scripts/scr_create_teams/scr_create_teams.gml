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
				var player = _blue_team.players[i]
				create_player_display(player, i)
			}
		}
	}
}


function create_player_display(_player, index){
	var display = instance_create_depth(500, 500, -1, obj_player_display)
				
	with(_player){
		self.display_id = display.id
		show_debug_message("I set the Display")
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