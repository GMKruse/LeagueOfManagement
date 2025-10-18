#region // Player Pool
function init_player_pool(){
	global.player_pool = {
        top: [
            create_player("Zeus", "Top", 92, 85, 88, spr_Zeus),
            create_player("Kingen", "Top", 85, 88, 82, spr_Kingen),
            create_player("TheShy", "Top", 95, 70, 75, spr_TheShy),
            create_player("Bin", "Top", 88, 80, 83, spr_Bin)
        ],
        jungle: [
            create_player("Canyon", "Jungle", 90, 92, 94, spr_Canyon),
            create_player("Oner", "Jungle", 88, 90, 87),
            create_player("Peanut", "Jungle", 85, 82, 90),
            create_player("Jiejie", "Jungle", 82, 88, 85)
        ],
        mid: [
            create_player("Faker", "Mid", 85, 90, 98, spr_Faker),
            create_player("Chovy", "Mid", 95, 82, 92),
            create_player("Showmaker", "Mid", 92, 88, 90),
            create_player("Knight", "Mid", 90, 85, 88)
        ],
        adc: [
            create_player("Gumayusi", "ADC", 93, 88, 85),
            create_player("Viper", "ADC", 90, 90, 88, spr_Viper),
            create_player("Ruler", "ADC", 88, 92, 90),
            create_player("Elk", "ADC", 85, 85, 82)
        ],
        support: [
            create_player("Keria", "Support", 85, 95, 92),
            create_player("Meiko", "Support", 80, 92, 88),
            create_player("Lehends", "Support", 88, 88, 85),
            create_player("Missing", "Support", 82, 90, 80)
        ]
    };
	return global.player_pool
}

#endregion

#region // Create Player
function create_player(_name, _role, _mechanics, _teamwork, _knowledge, _player_sprite = spr_question_mark) {
    var player = instance_create_depth(-100, -100, -1, obj_player)
	
	with(player){
        self.name = _name
		self.sprite_index = _player_sprite
        self.role = _role
        self.mechanics = _mechanics     // 1-100
        self.teamwork = _teamwork       // 1-100
        self.knowledge = _knowledge     // 1-100
        self.champion = noone           // Assigned during champion draft
        self.kills = 0
        self.deaths = 0
        self.assists = 0
		
    };
	variable_struct_set(global.player_id_map, _name, player);
	
	return player 
}

function get_player_id(_name){
	return variable_struct_get(global.player_id_map, _name);
}

#endregion

function set_champion_for_player(_player_id, _champion_id){
	if(_player_id){
		with(_player_id){
			self.champion = _champion_id
		}
	}
}

#region //Draft player
function create_player_draft_state() {
    return {
        active: true,
        current_pick: 0,
        //team1_picks: [],
        //team2_picks: [],
        picked_players: [],
        current_role_index: 0,
        pick_order: [1, 2, 2, 1, 1, 2, 2, 1, 1, 2]
    };
}

function get_current_team_player_draft(draft) {
    return draft.pick_order[draft.current_pick];
}

function get_current_role_player_draft(draft) {
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    return roles[draft.current_role_index];
}

function get_available_players(draft) {
    var role = get_current_role_player_draft(draft);
    var role_key = "";
    
	switch(role) {
        case "Top": role_key = "top"; break;
        case "Jungle": role_key = "jungle"; break;
        case "Mid": role_key = "mid"; break;
        case "ADC": role_key = "adc"; break;
        case "Support": role_key = "support"; break;
    }
    
    var all_players = global.player_pool[$ role_key];
    var available = [];
    
    for (var i = 0; i < array_length(all_players); i++) {
        var player = all_players[i];
        var is_picked = false;
        
        for (var j = 0; j < array_length(draft.picked_players); j++) {
            if (draft.picked_players[j].name == player.name) {
                is_picked = true;
                break;
            }
        }
        
        if (!is_picked) {
            array_push(available, player);
        }
    }
    
    return available;
}

function make_player_pick(draft, player) {
    var current_team = get_current_team_player_draft(draft);
    
    if (current_team == 1) {
        add_player_to_team(global.player_team, player, true)
    } else {
        add_player_to_team(global.ai_team, player, true)
    }
    
    array_push(draft.picked_players, player);
    draft.current_pick++;
    
    if (draft.current_pick % 2 == 0) {
        draft.current_role_index++;
    }
    
    if (draft.current_pick >= 10) {
        draft.active = false;
    }
    
    return draft.active;
}

function ai_pick_player(draft) {
    var available = get_available_players(draft);
    
    if (array_length(available) > 0) {
        var random_index = irandom(array_length(available) - 1);
		make_player_pick(draft, available[random_index])
        return available[random_index];
    }
    
    return noone;
}

#endregion