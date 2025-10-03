// ===================================
// CHAMPION AND PLAYER CREATION
// ===================================

// Create a champion struct
function create_champion(_name, _role, _mech_scale, _team_scale, _know_scale, _early_power, _mid_power, _late_power) {
    return {
        name: _name,
        role: _role,
        mechanics_scaling: _mech_scale,     // Multiplier for mechanics stat
        teamwork_scaling: _team_scale,      // Multiplier for teamwork stat
        knowledge_scaling: _know_scale,     // Multiplier for knowledge stat
        early_power: _early_power,          // 0.7 - 1.3 (power spike timing)
        mid_power: _mid_power,
        late_power: _late_power
    };
}

// Create a player struct
function create_player(_name, _role, _mechanics, _teamwork, _knowledge, _champion) {
    return {
        name: _name,
        role: _role,
        mechanics: _mechanics,      // 1-100
        teamwork: _teamwork,        // 1-100
        knowledge: _knowledge,      // 1-100
        champion: _champion,        // Champion struct
        kills: 0,
        deaths: 0,
        assists: 0
    };
}

// Create a team struct
function create_team(_name, _players) {
    return {
        name: _name,
        players: _players,
        phase_wins: 0,
        gold: 0,
        dragons: 0,
        barons: 0,
        towers: 0,
        phase_results: [] // Track which phases were won
    };
}

// ===================================
// MATCH SIMULATION
// ===================================

function simulate_match(_team1, _team2) {
    
    // IMPORTANT: Randomize seed at the start of each match
    randomize();
    
    // Reset phase wins and stats
    _team1.phase_wins = 0;
    _team2.phase_wins = 0;
    _team1.gold = 0;
    _team2.gold = 0;
    _team1.dragons = 0;
    _team2.dragons = 0;
    _team1.barons = 0;
    _team2.barons = 0;
    _team1.towers = 0;
    _team2.towers = 0;
    _team1.phase_results = [];
    _team2.phase_results = [];
    
    // Reset player stats
    for (var i = 0; i < array_length(_team1.players); i++) {
        _team1.players[i].kills = 0;
        _team1.players[i].deaths = 0;
        _team1.players[i].assists = 0;
    }
    for (var i = 0; i < array_length(_team2.players); i++) {
        _team2.players[i].kills = 0;
        _team2.players[i].deaths = 0;
        _team2.players[i].assists = 0;
    }
    
    // Simulate three phases
    simulate_phase(_team1, _team2, "early");
    simulate_phase(_team1, _team2, "mid");
    simulate_phase(_team1, _team2, "late");
    
    // Calculate match duration based on how dominant the winner was
    var phase_diff = abs(_team1.phase_wins - _team2.phase_wins);
    var base_time = 0;
    if (phase_diff == 3) base_time = irandom_range(20, 25); // Stomp
    else if (phase_diff == 1) base_time = irandom_range(25, 35); // Close game
    else base_time = irandom_range(35, 45); // Very close
    
    global.match_duration = base_time;
    
    // Determine winner
    var winner = (_team1.phase_wins > _team2.phase_wins) ? _team1 : _team2;
    
    return winner;
}

function simulate_phase(_team1, _team2, _phase) {
    
    var t1_match_score = 0;
    var t2_match_score = 0;
    
    // Calculate team scores based on phase
    switch(_phase) {
        case "early":
            t1_match_score = calculate_early_score(_team1);
            t2_match_score = calculate_early_score(_team2);
            break;
        case "mid":
            t1_match_score = calculate_mid_score(_team1);
            t2_match_score = calculate_mid_score(_team2);
            break;
        case "late":
            t1_match_score = calculate_late_score(_team1);
            t2_match_score = calculate_late_score(_team2);
            break;
    }
    
    // Add randomness (±15%)
    t1_match_score *= random_range(0.85, 1.15);
    t2_match_score *= random_range(0.85, 1.15);
    
    // Determine phase winner
    var phase_winner;
    if (t1_match_score > t2_match_score) {
        _team1.phase_wins++;
        phase_winner = _team1;
        array_push(_team1.phase_results, _phase + " WIN");
        array_push(_team2.phase_results, _phase + " LOSS");
        show_debug_message("Team " + _team1.name + " wins " + _phase + " game! (" + string(t1_match_score) + " vs " + string(t2_match_score) + ")");
    } else {
        _team2.phase_wins++;
        phase_winner = _team2;
        array_push(_team1.phase_results, _phase + " LOSS");
        array_push(_team2.phase_results, _phase + " WIN");
        show_debug_message("Team " + _team2.name + " wins " + _phase + " game! (" + string(t1_match_score) + " vs " + string(t2_match_score) + ")");
    }
    
    // Generate objectives for this phase
    generate_phase_objectives(_team1, _team2, _phase, phase_winner);
    
    // Generate player stats for this phase
    generate_phase_stats(_team1, _team2, _phase, t1_match_score > t2_match_score);
}

// ===================================
// CHAMPION POOL
// ===================================

function init_champion_pool() {
    global.champion_pool = {
        top: [
            // Shen - Tank/Teamwork focused, global ultimate
            create_champion("Shen", "Top", 0.9, 1.3, 1.1, 0.9, 1.1, 1.0),
            // Aatrox - Mechanics heavy, early game bully
            create_champion("Aatrox", "Top", 1.3, 0.9, 0.9, 1.2, 1.0, 0.9),
            // Rumble - Knowledge/positioning, teamfight monster
            create_champion("Rumble", "Top", 1.0, 1.0, 1.2, 1.0, 1.2, 1.1)
        ],
        jungle: [
            // Lee Sin - High mechanics, early game aggro
            create_champion("Lee Sin", "Jungle", 1.4, 0.8, 1.0, 1.3, 1.0, 0.8),
            // Shyvana - Farming jungler, scales into late
            create_champion("Shyvana", "Jungle", 0.9, 0.9, 1.0, 0.8, 1.0, 1.3),
            // Kindred - Mechanics + knowledge, scaling marksman
            create_champion("Kindred", "Jungle", 1.2, 0.9, 1.2, 0.9, 1.1, 1.2)
        ],
        mid: [
            // Yasuo - Extremely mechanics heavy, high risk/reward
            create_champion("Yasuo", "Mid", 1.5, 0.8, 0.8, 1.0, 1.1, 1.2),
            // Galio - Teamwork focused, roaming, engage
            create_champion("Galio", "Mid", 0.8, 1.4, 1.1, 0.9, 1.2, 1.0),
            // Anivia - Knowledge/positioning, control mage
            create_champion("Anivia", "Mid", 0.9, 1.0, 1.4, 0.8, 1.0, 1.3)
        ],
        adc: [
            // Vayne - Mechanics heavy, late game hyper carry
            create_champion("Vayne", "ADC", 1.4, 0.8, 0.9, 0.7, 0.9, 1.4),
            // Ashe - Utility/teamwork, consistent throughout
            create_champion("Ashe", "ADC", 0.9, 1.2, 1.1, 1.0, 1.1, 1.1),
            // Jhin - Mechanics + knowledge, positioning crucial
            create_champion("Jhin", "ADC", 1.3, 0.9, 1.2, 1.1, 1.2, 1.0)
        ],
        support: [
            // Janna - Teamwork/peel, protective enchanter
            create_champion("Janna", "Support", 0.8, 1.4, 1.0, 0.9, 1.0, 1.1),
            // Bard - Knowledge heavy, roaming support
            create_champion("Bard", "Support", 1.0, 1.1, 1.4, 1.1, 1.2, 1.0),
            // Thresh - Mechanics + teamwork, playmaking
            create_champion("Thresh", "Support", 1.3, 1.2, 0.9, 1.1, 1.1, 0.9)
        ]
    };
}

// ===================================
// PHASE SCORE CALCULATIONS
// ===================================

function calculate_early_score(_team) {
    var match_score = 0;
    var role_weights = [1.2, 1.5, 1.2, 0.8, 0.9]; // Top, Jungle, Mid, ADC, Support
    
    for (var i = 0; i < array_length(_team.players); i++) {
        var p = _team.players[i];
        var c = p.champion;
        
        // Calculate base player score with champion scaling
        var mech_score = p.mechanics * c.mechanics_scaling;
        var team_score = p.teamwork * c.teamwork_scaling;
        var know_score = p.knowledge * c.knowledge_scaling;
        
        // Early game: 70% mechanics, 20% teamwork, 10% knowledge
        var player_score = (mech_score * 0.7) + (team_score * 0.2) + (know_score * 0.1);
        
        // Apply champion's early game power spike
        player_score *= c.early_power;
        
        match_score += player_score * role_weights[i];
    }
    
    return match_score;
}

function calculate_mid_score(_team) {
    var match_score = 0;
    var role_weights = [1.0, 1.3, 1.1, 1.0, 1.1]; // Top, Jungle, Mid, ADC, Support
    
    for (var i = 0; i < array_length(_team.players); i++) {
        var p = _team.players[i];
        var c = p.champion;
        
        // Calculate base player score with champion scaling
        var mech_score = p.mechanics * c.mechanics_scaling;
        var team_score = p.teamwork * c.teamwork_scaling;
        var know_score = p.knowledge * c.knowledge_scaling;
        
        // Mid game: 40% mechanics, 40% teamwork, 20% knowledge
        var player_score = (mech_score * 0.4) + (team_score * 0.4) + (know_score * 0.2);
        
        // Apply champion's mid game power spike
        player_score *= c.mid_power;
        
        match_score += player_score * role_weights[i];
    }
    
    return match_score;
}

function calculate_late_score(_team) {
    var match_score = 0;
    var role_weights = [0.9, 1.1, 0.9, 1.4, 1.0]; // Top, Jungle, Mid, ADC, Support
    
    for (var i = 0; i < array_length(_team.players); i++) {
        var p = _team.players[i];
        var c = p.champion;
        
        // Calculate base player score with champion scaling
        var mech_score = p.mechanics * c.mechanics_scaling;
        var team_score = p.teamwork * c.teamwork_scaling;
        var know_score = p.knowledge * c.knowledge_scaling;
        
        // Late game: 30% mechanics, 35% teamwork, 35% knowledge
        var player_score = (mech_score * 0.3) + (team_score * 0.35) + (know_score * 0.35);
        
        // Apply champion's late game power spike
        player_score *= c.late_power;
        
        match_score += player_score * role_weights[i];
    }
    
    return match_score;
}

// ===================================
// OBJECTIVES GENERATION
// ===================================

function generate_phase_objectives(_team1, _team2, _phase, _phase_winner) {
    
    var loser = (_phase_winner == _team1) ? _team2 : _team1;
    
    switch(_phase) {
        case "early":
            // Early game: Mostly gold and maybe 1-2 dragons, some towers
            var gold_diff = irandom_range(1000, 2500);
            _phase_winner.gold += gold_diff + irandom_range(3000, 5000);
            loser.gold += irandom_range(3000, 5000);
            
            // 60% chance for a dragon
            if (random(1) < 0.6) {
                _phase_winner.dragons += 1;
            }
            
            // Towers (1-3 for winner, 0-1 for loser)
            _phase_winner.towers += irandom_range(1, 3);
            if (random(1) < 0.3) {
                loser.towers += 1;
            }
            break;
            
        case "mid":
            // Mid game: More objectives, higher gold
            var gold_diff = irandom_range(2000, 4000);
            _phase_winner.gold += gold_diff + irandom_range(5000, 8000);
            loser.gold += irandom_range(5000, 8000);
            
            // 1-2 dragons
            _phase_winner.dragons += irandom_range(1, 2);
            if (random(1) < 0.4) {
                loser.dragons += 1;
            }
            
            // Possible baron (30% chance)
            if (random(1) < 0.3) {
                _phase_winner.barons += 1;
            }
            
            // More towers
            _phase_winner.towers += irandom_range(2, 4);
            loser.towers += irandom_range(0, 2);
            break;
            
        case "late":
            // Late game: High stakes, barons matter
            var gold_diff = irandom_range(1500, 3500);
            _phase_winner.gold += gold_diff + irandom_range(6000, 10000);
            loser.gold += irandom_range(6000, 10000);
            
            // Dragons
            _phase_winner.dragons += irandom_range(0, 2);
            if (random(1) < 0.5) {
                loser.dragons += irandom_range(0, 1);
            }
            
            // Baron is crucial (70% chance for winner)
            if (random(1) < 0.7) {
                _phase_winner.barons += irandom_range(1, 2);
            }
            if (random(1) < 0.2) {
                loser.barons += 1;
            }
            
            // Final towers
            _phase_winner.towers += irandom_range(2, 5);
            loser.towers += irandom_range(1, 3);
            break;
    }
}

// ===================================
// PLAYER STATS GENERATION
// ===================================

function generate_phase_stats(_team1, _team2, _phase, _team1_won) {
    
    var base_kills = 0;
    
    // Different phases have different kill counts
    switch(_phase) {
        case "early": base_kills = irandom_range(2, 5); break;
        case "mid": base_kills = irandom_range(4, 8); break;
        case "late": base_kills = irandom_range(3, 7); break;
    }
    
    var winning_team = _team1_won ? _team1 : _team2;
    var losing_team = _team1_won ? _team2 : _team1;
    
    // Winners get more kills
    var winner_kills = base_kills + irandom_range(2, 5);
    var loser_kills = base_kills - irandom_range(1, 3);
    loser_kills = max(loser_kills, 1);
    
    // Distribute kills among players
    distribute_kills(winning_team, winner_kills, losing_team);
    distribute_kills(losing_team, loser_kills, winning_team);
}

function distribute_kills(_team, _total_kills, _enemy_team) {
    
    for (var i = 0; i < _total_kills; i++) {
        // Random player gets a kill
        var player_index = irandom(array_length(_team.players) - 1);
        _team.players[player_index].kills++;
        
        // Random enemy player gets a death
        var enemy_index = irandom(array_length(_enemy_team.players) - 1);
        _enemy_team.players[enemy_index].deaths++;
        
        // 70% chance for assists (1-3 players)
        if (random(1) < 0.7) {
            var assist_count = irandom_range(1, 3);
            for (var j = 0; j < assist_count; j++) {
                var assist_index = irandom(array_length(_team.players) - 1);
                if (assist_index != player_index) {
                    _team.players[assist_index].assists++;
                }
            }
        }
    }
}

// ===================================
// EXAMPLE USAGE
// ===================================

// Initialize champion pool
init_champion_pool();

// Create Team 1 - Picks champions from pool
var team1_players = [
    create_player("PlayerA", "Top", 75, 70, 65, global.champion_pool.top[0]),      // Shen
    create_player("PlayerB", "Jungle", 80, 75, 70, global.champion_pool.jungle[0]), // Lee Sin
    create_player("PlayerC", "Mid", 85, 65, 75, global.champion_pool.mid[0]),      // Yasuo
    create_player("PlayerD", "ADC", 70, 80, 60, global.champion_pool.adc[0]),      // Vayne
    create_player("PlayerE", "Support", 60, 85, 70, global.champion_pool.support[0]) // Janna
];
var team1 = create_team("Blue Team", team1_players);

// Create Team 2 - Different champion picks
var team2_players = [
    create_player("PlayerF", "Top", 70, 75, 70, global.champion_pool.top[1]),      // Aatrox
    create_player("PlayerG", "Jungle", 75, 70, 75, global.champion_pool.jungle[1]), // Shyvana
    create_player("PlayerH", "Mid", 80, 70, 80, global.champion_pool.mid[1]),      // Galio
    create_player("PlayerI", "ADC", 75, 75, 65, global.champion_pool.adc[1]),      // Ashe
    create_player("PlayerJ", "Support", 65, 80, 75, global.champion_pool.support[1]) // Bard
];
var team2 = create_team("Red Team", team2_players);

// Simulate match
var winner = simulate_match(team1, team2);

// Display results
show_debug_message("=================================");
show_debug_message("MATCH RESULT: " + winner.name + " WINS!");
show_debug_message("=================================");

// Show stats for both teams
show_debug_message("\n" + team1.name + " Stats:");
for (var i = 0; i < array_length(team1.players); i++) {
    var p = team1.players[i];
    show_debug_message(p.name + " (" + p.role + "): " + string(p.kills) + "/" + string(p.deaths) + "/" + string(p.assists));
}

show_debug_message("\n" + team2.name + " Stats:");
for (var i = 0; i < array_length(team2.players); i++) {
    var p = team2.players[i];
    show_debug_message(p.name + " (" + p.role + "): " + string(p.kills) + "/" + string(p.deaths) + "/" + string(p.assists));
}



// ===================================
// DRAFT SYSTEM
// ===================================

// Draft state struct
function create_draft_state() {
    return {
        active: true,
        current_pick: 0,  // 0-9 for 10 picks total
        team1_picks: [],  // Array of picked champions
        team2_picks: [],
        picked_champions: [], // Track all picked champions to prevent duplicates
        current_role_index: 0, // 0=Top, 1=Jungle, 2=Mid, 3=ADC, 4=Support
        // Draft order: Team1, Team2, Team2, Team1, Team1, Team2, Team2, Team1, Team1, Team2
        pick_order: [1, 2, 2, 1, 1, 2, 2, 1, 1, 2]
    };
}

// Get which team is currently picking
function get_current_team(draft) {
    return draft.pick_order[draft.current_pick];
}

// Get current role being picked
function get_current_role(draft) {
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    return roles[draft.current_role_index];
}

// Get available champions for current role
function get_available_champions(draft) {
    var role = get_current_role(draft);
    var role_key = "";
    
    // Convert role to champion pool key
    switch(role) {
        case "Top": role_key = "top"; break;
        case "Jungle": role_key = "jungle"; break;
        case "Mid": role_key = "mid"; break;
        case "ADC": role_key = "adc"; break;
        case "Support": role_key = "support"; break;
    }
    
    var all_champs = global.champion_pool[$ role_key];
    var available = [];
    
    // Filter out already picked champions
    for (var i = 0; i < array_length(all_champs); i++) {
        var champ = all_champs[i];
        var is_picked = false;
        
        for (var j = 0; j < array_length(draft.picked_champions); j++) {
            if (draft.picked_champions[j].name == champ.name) {
                is_picked = true;
                break;
            }
        }
        
        if (!is_picked) {
            array_push(available, champ);
        }
    }
    
    return available;
}

// Make a pick
function make_pick(draft, champion) {
    var current_team = get_current_team(draft);
    
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
    
    // Check if we need to move to next role
    // Roles change every 2 picks
    if (draft.current_pick % 2 == 0) {
        draft.current_role_index++;
    }
    
    // Check if draft is complete
    if (draft.current_pick >= 10) {
        draft.active = false;
    }
    
    return draft.active; // Return true if draft continues
}

// AI pick for computer team (picks randomly for now)
function ai_pick_champion(draft) {
    var available = get_available_champions(draft);
    
    if (array_length(available) > 0) {
        var random_index = irandom(array_length(available) - 1);
        return available[random_index];
    }
    
    return noone;
}

// Create teams from draft picks
function create_teams_from_draft(draft) {
    // Team 1
    var team1_players = [
        create_player("PlayerA", "Top", 75, 70, 65, draft.team1_picks[0]),
        create_player("PlayerB", "Jungle", 80, 75, 70, draft.team1_picks[1]),
        create_player("PlayerC", "Mid", 85, 65, 75, draft.team1_picks[2]),
        create_player("PlayerD", "ADC", 70, 80, 60, draft.team1_picks[3]),
        create_player("PlayerE", "Support", 60, 85, 70, draft.team1_picks[4])
    ];
    global.team1 = create_team("Blue Team", team1_players);
    
    // Team 2
    var team2_players = [
        create_player("PlayerF", "Top", 70, 75, 70, draft.team2_picks[0]),
        create_player("PlayerG", "Jungle", 75, 70, 75, draft.team2_picks[1]),
        create_player("PlayerH", "Mid", 80, 70, 80, draft.team2_picks[2]),
        create_player("PlayerI", "ADC", 75, 75, 65, draft.team2_picks[3]),
        create_player("PlayerJ", "Support", 65, 80, 75, draft.team2_picks[4])
    ];
    global.team2 = create_team("Red Team", team2_players);
}