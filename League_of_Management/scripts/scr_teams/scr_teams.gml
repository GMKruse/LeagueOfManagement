
function createTeam(_name, _players = []){
	var team = instance_create_depth(0, 0, 0, obj_team)
	with(team){
		self.name = _name
		self.players = _players
		}
	return team
}

function add_player_to_team(_team_struct, _player_id) {
		array_push(_team_struct.players, _player_id);
		show_debug_message("Added player " + _player_id.name + " to team " + _team_struct.name);
}