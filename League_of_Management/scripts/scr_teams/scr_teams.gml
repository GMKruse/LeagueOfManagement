
function createTeam(_name){
	var team = instance_create_depth(0, 0, 0, obj_team)
	with(team){
		self.name = _name
		for(var i = 0; i <= 4; i++){
			var base_name = "tmp_player" + string(i)
			self.players[i] = create_player(base_name, "tmp", -1, -1, -1)
			with(self.players[i]){
				self.team = team
			}
		}
	}
	return team
}

function add_player_to_team(_team_struct, _new_player_struct, _create_display = false) {

    // Determine the index to be replaced
    var _index_to_replace = -1;
    switch (string(_new_player_struct.role)) {
        case "Top":     _index_to_replace = 0; break;
        case "Jungle":  _index_to_replace = 1; break;
        case "Mid":     _index_to_replace = 2; break;
        case "ADC":     _index_to_replace = 3; break;
        case "Support": _index_to_replace = 4; break;
    }

    if (_index_to_replace != -1) {
        // Replace the player in the team array
        var _old_player_instance = _team_struct.players[_index_to_replace];
		show_debug_message("Deleting here: " + string(_old_player_instance.display_id))
		
		destroy_player_display(_old_player_instance.display_id)
		
        var _new_instance_id = get_player_id(_new_player_struct.name);
        _team_struct.players[_index_to_replace] = _new_instance_id;
		
		with(_new_instance_id){
			self.team = _team_struct
			show_debug_message("Player: " + string(_new_player_struct.name) + " to " + string(self.team) )
		}

        show_debug_message("Added player " + _new_player_struct.name + " to team " + _team_struct.name)
		
		if(_create_display){
			if(_team_struct.side == "Red"){
				create_player_display(_new_instance_id, _index_to_replace + 5)
			}else{
			create_player_display(_new_instance_id, _index_to_replace)
			}
		}
    }
}