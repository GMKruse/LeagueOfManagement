
function createTeam(_name, _players = []){
	var team = instance_create_depth(0, 0, 0, obj_team)
	with(team){
		self.name = _name
		self.players = _players
		}
}

function add_palyer_to_team(_team_in, _player_id){
	with(_team_id){
		array_push(self.players, _player_id)
		}
}