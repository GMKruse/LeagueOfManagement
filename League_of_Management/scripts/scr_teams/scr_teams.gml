
function createTeam(_name){
	var team = instance_create_depth(0, 0, 0, obj_team)
	with(team){
		self.name = _name
		for(var i = 0; i <= 4; i++){
			var base_name = "tmp_player" + string(i)
			self.players[i] = create_player(base_name, "tmp", -1, -1, -1)
		}
	}
	return team
}

function add_player_to_team(_team_struct, _new_player_struct) {
	show_debug_message("team id: " + string(_team_struct.id))
	show_debug_message("Player 0: " + string(_team_struct.players[0]))
	show_debug_message("Player 1: " + string(_team_struct.players[1]))
	show_debug_message("Player 2: " + string(_team_struct.players[2]))
	show_debug_message("Player 3: " + string(_team_struct.players[3]))
	show_debug_message("Player 4: " + string(_team_struct.players[4]))

	show_debug_message("new player roel: " + _new_player_struct.role)
	
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
		show_debug_message("Indext to replace: " + string(_index_to_replace))
		show_debug_message("Player to delete: " + string(_team_struct.players[_index_to_replace]))
		
		
        var _old_player_instance = _team_struct.players[_index_to_replace];
		show_debug_message("Deleting here: " + string(_old_player_instance.display_id))
		destroy_player_display(_old_player_instance.display_id)
        var _new_instance_id = get_player_id(_new_player_struct.name);
        _team_struct.players[_index_to_replace] = _new_instance_id;

        show_debug_message("Added player " + _new_player_struct.name + " to team " + _team_struct.name);
    }
}