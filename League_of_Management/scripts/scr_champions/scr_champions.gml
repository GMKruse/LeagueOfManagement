#region Champion pool
function init_champion_pool() {
    global.champion_pool = { 
	    top: [
	        // Shen - Tank/Teamwork focused, global ultimate
	        create_champion("Shen", "Top", 0.9, 1.3, 1.1, 0.9, 1.1, 1.0),
	        // Aatrox - Mechanics heavy, early game bully
	        create_champion("Aatrox", "Top", 1.3, 0.9, 0.9, 1.2, 1.0, 0.9, spr_aatrox),
	        // Rumble - Knowledge/positioning, teamfight monster
	        create_champion("Rumble", "Top", 1.0, 1.0, 1.2, 1.0, 1.2, 1.1, spr_rumble),
	        // Duelist, high mechanics scaling
	        create_champion("Fiora", "Top", 1.5, 0.8, 1.0, 1.2, 1.1, 1.3, spr_fiora),
			// Simple mechanics, teamwork engage
	        create_champion("Malphite", "Top", 0.8, 1.2, 1.0, 1.0, 1.1, 1.0, spr_malphite), 
			 // Weak early, insane late scaling
	        create_champion("Kayle", "Top", 1.0, 0.9, 1.2, 0.7, 0.9, 1.4),
			// Precision duelist with strong mid-game
			create_champion("Camille", "Top", 1.4, 1.0, 1.1, 1.1, 1.2, 1.1),
			// Late scaling tank with team utility
			create_champion("Ornn", "Top", 0.9, 1.4, 1.0, 0.8, 1.1, 1.2)
	    ],
	    jungle: [
	        // Lee Sin - High mechanics, early game aggro
	        create_champion("Lee Sin", "Jungle", 1.4, 0.8, 1.0, 1.3, 1.0, 0.8),
	        // Shyvana - Farming jungler, scales into late
	        create_champion("Shyvana", "Jungle", 0.9, 0.9, 1.0, 0.8, 1.0, 1.3),
	        // Kindred - Mechanics + knowledge, scaling marksman
	        create_champion("Kindred", "Jungle", 1.2, 0.9, 1.2, 0.9, 1.1, 1.2),
	        // Early gank pressure, mechanics heavy
	        create_champion("Elise", "Jungle", 1.3, 0.9, 1.1, 1.3, 1.1, 0.8),
			 // Teamfight tank, CC synergy
	        create_champion("Sejuani", "Jungle", 0.9, 1.3, 1.0, 0.9, 1.1, 1.1),
			// Isolated duelist, mechanics focused
	        create_champion("Kha'Zix", "Jungle", 1.4, 0.8, 1.1, 1.2, 1.2, 1.0),
			// Skillshot-based, mechanics high
			create_champion("Nidalee", "Jungle", 1.5, 0.8, 1.1, 1.2, 1.1, 1.0),
			// Teamfight CC and sustain tank
			create_champion("Zac", "Jungle", 0.9, 1.4, 1.0, 0.9, 1.2, 1.2)
	    ],
	    mid: [
	        // Yasuo - Extremely mechanics heavy, high risk/reward
	        create_champion("Yasuo", "Mid", 1.5, 0.8, 0.8, 1.0, 1.1, 1.2),
	        // Galio - Teamwork focused, roaming, engage
	        create_champion("Galio", "Mid", 0.8, 1.4, 1.1, 0.9, 1.2, 1.0),
	        // Anivia - Knowledge/positioning, control mage
	        create_champion("Anivia", "Mid", 0.9, 1.0, 1.4, 0.8, 1.0, 1.3),
	        // Assassin, mechanics intensive
	        create_champion("Zed", "Mid", 1.5, 0.8, 1.0, 1.2, 1.2, 0.9),
			// Knowledge/positioning mage
	        create_champion("Orianna", "Mid", 1.0, 1.2, 1.3, 0.9, 1.2, 1.2),
			// Adaptive scaling, mechanics heavy
	        create_champion("Sylas", "Mid", 1.3, 1.0, 1.2, 1.0, 1.2, 1.1),
			// Infinite scaling mage
			create_champion("Veigar", "Mid", 0.9, 1.0, 1.3, 0.8, 1.0, 1.4),
			// Burst assassin, high mechanics
			create_champion("Akali", "Mid", 1.5, 0.8, 1.1, 1.1, 1.2, 1.2, spr_akali)
	    ],
	    adc: [
	        // Vayne - Mechanics heavy, late game hyper carry
	        create_champion("Vayne", "ADC", 1.4, 0.8, 0.9, 0.7, 0.9, 1.4),
	        // Ashe - Utility/teamwork, consistent throughout
	        create_champion("Ashe", "ADC", 0.9, 1.2, 1.1, 1.0, 1.1, 1.1),
	        // Jhin - Mechanics + knowledge, positioning crucial
	        create_champion("Jhin", "ADC", 1.3, 0.9, 1.2, 1.1, 1.2, 1.0),
	        // Snowball early, mechanics heavy
	        create_champion("Draven", "ADC", 1.5, 0.8, 1.0, 1.3, 1.1, 0.9),
			// Flexible scaling, hybrid damage
	        create_champion("Kai'Sa", "ADC", 1.3, 1.0, 1.1, 0.9, 1.1, 1.3),
			// Lane bully, knowledge positioning
	        create_champion("Caitlyn", "ADC", 1.1, 1.0, 1.2, 1.2, 1.1, 1.0),
			// Safe poke ADC, mechanics + knowledge
			create_champion("Ezreal", "ADC", 1.4, 0.9, 1.2, 1.0, 1.2, 1.2),
			// Combo-based, high mechanical ceiling
			create_champion("Samira", "ADC", 1.5, 0.9, 1.0, 1.2, 1.2, 1.1)
	    ],
	    support: [
	        // Janna - Teamwork/peel, protective enchanter
	        create_champion("Janna", "Support", 0.8, 1.4, 1.0, 0.9, 1.0, 1.1),
	        // Bard - Knowledge heavy, roaming support
	        create_champion("Bard", "Support", 1.0, 1.1, 1.4, 1.1, 1.2, 1.0),
	        // Thresh - Mechanics + teamwork, playmaking
	        create_champion("Thresh", "Support", 1.3, 1.2, 0.9, 1.1, 1.1, 0.9),
	        // Engage tank support
	        create_champion("Leona", "Support", 1.0, 1.3, 1.0, 1.2, 1.2, 1.0),
			// Knowledge + teamwork enchanter
	        create_champion("Nami", "Support", 0.9, 1.3, 1.2, 1.0, 1.1, 1.2),
			// Assassin support, mechanics reliant
	        create_champion("Pyke", "Support", 1.4, 1.0, 1.0, 1.2, 1.1, 1.0),
			// Buff/utility enchanter
			create_champion("Lulu", "Support", 0.9, 1.4, 1.2, 1.0, 1.1, 1.2),
			// Engage/disengage hybrid
			create_champion("Rakan", "Support", 1.2, 1.3, 1.1, 1.1, 1.2, 1.1)
	    ]
	};
}

#endregion

function create_champion(_name, _role, _mech_scale, _team_scale, _know_scale, _early_power, _mid_power, _late_power, _sprite = spr_question_mark) {
    var champion = instance_create_depth(-100, -100, -1, obj_champion)
	with(champion) {
        self.name = _name
        self.role = _role
		self.sprite_index = _sprite
		
        self.mechanics_scaling = _mech_scale     // Multiplier for mechanics stat
        self.teamwork_scaling = _team_scale      // Multiplier for teamwork stat
        self.knowledge_scaling = _know_scale     // Multiplier for knowledge stat
        self.early_power = _early_power          // 0.7 - 1.3 (power spike timing)
        self.mid_power = _mid_power
        self.late_power = _late_power
    }
    
    return champion; // Return the created champion instance
}

#region Champion display creation and management

function create_champion_display(_champion, _x, _y, _is_team_display = false) {
    show_debug_message("Creating champion display: " + _champion.name);
    
    var display = instance_create_depth(_x, _y, -1, obj_champion_display);
    
    with(display) {
        self.champion = _champion;
        self.is_team_display = _is_team_display;
        
        // Set sprite based on champion's sprite (champion is an instance)
        if (instance_exists(_champion) && _champion.sprite_index != -1) {
            sprite_index = _champion.sprite_index;
        } else {
            sprite_index = spr_question_mark; // Default sprite
        }
    }
    
    return display;
}

function destroy_champion_display(_display_id) {
    if (_display_id != -1) {
        if (instance_exists(_display_id)) {
            show_debug_message("Destroying champion display_id: " + string(_display_id));
            instance_destroy(_display_id);
        }
    }
}

#endregion

#region Champion Draft State

function create_champion_draft_state() {
    return {
        // Ban phase
        ban_phase_active: true,
        current_ban: 0,
        team1_bans: [],
        team2_bans: [],
        all_bans: [],
        ban_order: [1, 2, 2, 1, 1, 2], // 6 total bans
        
        // Pick phase
        pick_phase_active: false,
        current_pick: 0,
        team1_picks: [],
        team2_picks: [],
        picked_champions: [],
        current_role_index: 0,
        pick_order: [1, 2, 2, 1, 1, 2, 2, 1, 1, 2] // Snake draft
    };
}

function is_ban_phase_active(draft) {
    return draft.ban_phase_active;
}

function is_pick_phase_active(draft) {
    return draft.pick_phase_active;
}

function is_draft_complete(draft) {
    return !draft.ban_phase_active && !draft.pick_phase_active;
}

#endregion

#region Ban Phase Functions

function get_current_team_banning(draft) {
    if (draft.current_ban < array_length(draft.ban_order)) {
        return draft.ban_order[draft.current_ban];
    }
    return -1;
}

function get_available_champions_for_ban(draft) {
    var all_champions = [];
    
    // Collect all champions from all roles
    var role_names = ["top", "jungle", "mid", "adc", "support"];
    for (var r = 0; r < array_length(role_names); r++) {
        var role = role_names[r];
        var champs_in_role = global.champion_pool[$ role];
        for (var i = 0; i < array_length(champs_in_role); i++) {
            array_push(all_champions, champs_in_role[i]);
        }
    }
    
    // Filter out already banned champions
    var available = [];
    for (var i = 0; i < array_length(all_champions); i++) {
        var champ = all_champions[i];
        var is_banned = false;
        
        for (var j = 0; j < array_length(draft.all_bans); j++) {
            if (draft.all_bans[j].name == champ.name) {
                is_banned = true;
                break;
            }
        }
        
        if (!is_banned) {
            array_push(available, champ);
        }
    }
    
    return available;
}

function make_champion_ban(draft, champion) {
    var current_team = get_current_team_banning(draft);
    
    if (current_team == 1) {
        array_push(draft.team1_bans, champion);
    } else {
        array_push(draft.team2_bans, champion);
    }
    
    array_push(draft.all_bans, champion);
    draft.current_ban++;
    
    // Check if ban phase is complete
    if (draft.current_ban >= array_length(draft.ban_order)) {
        draft.ban_phase_active = false;
        draft.pick_phase_active = true; // Start pick phase
        show_debug_message("Ban phase complete! Starting pick phase...");
    }
    
    return draft.ban_phase_active;
}

function ai_ban_champion(draft) {
    var available = get_available_champions_for_ban(draft);
    
    if (array_length(available) > 0) {
        var random_index = irandom(array_length(available) - 1);
        make_champion_ban(draft, available[random_index]);
        return available[random_index];
    }
    
    return noone;
}

#endregion

#region Pick Phase Functions

function get_current_team_picking(draft) {
    if (draft.current_pick < array_length(draft.pick_order)) {
        return draft.pick_order[draft.current_pick];
    }
    return -1;
}

function get_current_role_champion_draft(draft) {
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    if (draft.current_role_index >= array_length(roles)) {
        return "Complete";
    }
    return roles[draft.current_role_index];
}

function get_available_champions_for_pick(draft) {
    var role = get_current_role_champion_draft(draft);
    
    if (role == "Complete") {
        return [];
    }
    
    var role_key = "";
    switch(role) {
        case "Top": role_key = "top"; break;
        case "Jungle": role_key = "jungle"; break;
        case "Mid": role_key = "mid"; break;
        case "ADC": role_key = "adc"; break;
        case "Support": role_key = "support"; break;
    }
    
    var all_champs = global.champion_pool[$ role_key];
    var available = [];
    
    // Filter out already picked and banned champions
    for (var i = 0; i < array_length(all_champs); i++) {
        var champ = all_champs[i];
        var is_picked = false;
        var is_banned = false;
        
        // Check if picked
        for (var j = 0; j < array_length(draft.picked_champions); j++) {
            if (draft.picked_champions[j].name == champ.name) {
                is_picked = true;
                break;
            }
        }
        
        // Check if banned
        for (var j = 0; j < array_length(draft.all_bans); j++) {
            if (draft.all_bans[j].name == champ.name) {
                is_banned = true;
                break;
            }
        }
        
        if (!is_picked && !is_banned) {
            array_push(available, champ);
        }
    }
    
    return available;
}

function make_champion_pick(draft, champion) {
    var current_team = get_current_team_picking(draft);
    
    // Add to appropriate team
    if (current_team == 1) {
        array_push(draft.team1_picks, champion);
    } else {
        array_push(draft.team2_picks, champion);
    }
    
    // Track picked champion
    array_push(draft.picked_champions, champion);
    
    // Move to next pick
    draft.current_pick++;
    
    // Check if we need to move to next role (every 2 picks)
    if (draft.current_pick % 2 == 0) {
        draft.current_role_index++;
    }
    
    // Check if draft is complete
    if (draft.current_pick >= array_length(draft.pick_order)) {
        draft.pick_phase_active = false;
        show_debug_message("Champion draft complete!");
        
        // Assign champions to players
        assign_champions_to_teams(draft);
    }
    
    return draft.pick_phase_active;
}

function ai_pick_champion(draft) {
    var available = get_available_champions_for_pick(draft);
    
    if (array_length(available) > 0) {
        var random_index = irandom(array_length(available) - 1);
        make_champion_pick(draft, available[random_index]);
        return available[random_index];
    }
    
    return noone;
}

function assign_champions_to_teams(draft) {
    // Assign champions to players in team 1 (player's team)
    for (var i = 0; i < array_length(draft.team1_picks); i++) {
        if (i < array_length(global.player_team.players)) {
            var player = global.player_team.players[i];
            var champion = draft.team1_picks[i];
            
            with(player) {
                self.champion = champion;
                show_debug_message("Assigned " + champion.name + " to player " + self.name);
            }
        }
    }
    
    // Assign champions to players in team 2 (AI team)
    for (var i = 0; i < array_length(draft.team2_picks); i++) {
        if (i < array_length(global.ai_team.players)) {
            var player = global.ai_team.players[i];
            var champion = draft.team2_picks[i];
            
            with(player) {
                self.champion = champion;
                show_debug_message("Assigned " + champion.name + " to player " + self.name);
            }
        }
    }
}

#endregion

