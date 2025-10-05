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

// Create a pro player struct (without champion assigned yet)
function create_pro_player(_name, _role, _mechanics, _teamwork, _knowledge) {
    return {
        name: _name,
        role: _role,
        mechanics: _mechanics,      // 1-100
        teamwork: _teamwork,        // 1-100
        knowledge: _knowledge,      // 1-100
        champion: noone,            // Assigned during champion draft
        kills: 0,
        deaths: 0,
        assists: 0
    };
}

// Assign champion to player (used after champion draft)
function assign_champion_to_player(_player, _champion) {
    _player.champion = _champion;
}

// Create a player struct (legacy - for when we already have champion)
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
        phase_results: [], // Track which phases were won
        nexus_hp: 100 // Nexus health
    };
}

// ===================================
// GOLD GENERATION
// ===================================

function generate_tick_gold(_team1, _team2, _phase, _tick_winner) {
    
    var loser = (_tick_winner == _team1) ? _team2 : _team1;
    
    // Base gold per tick
    var base_gold = 0;
    switch(_phase) {
        case "early": base_gold = 2000; break;  // 2k gold per ~2.5 min
        case "mid": base_gold = 3000; break;    // 3k gold per tick
        case "late": base_gold = 4000; break;   // 4k gold per tick
    }
    
    // Winner gets more gold
    var winner_gold = base_gold * random_range(1.1, 1.3);
    var loser_gold = base_gold * random_range(0.8, 1.0);
    
    _tick_winner.gold += winner_gold;
    loser.gold += loser_gold;
}

// ===================================
// OBJECTIVES GENERATION (PER TICK)
// ===================================

function generate_tick_objectives(_team1, _team2, _phase, _tick_winner) {
    
    var loser = (_tick_winner == _team1) ? _team2 : _team1;
    
    switch(_phase) {
        case "early":
            // 40% chance for a dragon
            if (random(1) < 0.4) {
                _tick_winner.dragons += 1;
            }
            
            // Towers (1-2 for winner, 0-1 for loser)
            _tick_winner.towers += irandom_range(1, 2);
            if (random(1) < 0.3) {
                loser.towers += 1;
            }
            break;
            
        case "mid":
            // 50% chance for dragon
            if (random(1) < 0.5) {
                _tick_winner.dragons += 1;
            }
            if (random(1) < 0.3) {
                loser.dragons += 1;
            }
            
            // 20% chance for baron
            if (random(1) < 0.2) {
                _tick_winner.barons += 1;
            }
            
            // Towers
            _tick_winner.towers += irandom_range(1, 3);
            loser.towers += irandom_range(0, 1);
            break;
            
        case "late":
            // Dragons
            if (random(1) < 0.4) {
                _tick_winner.dragons += 1;
            }
            
            // Baron is crucial (50% chance for winner)
            if (random(1) < 0.5) {
                _tick_winner.barons += 1;
            }
            if (random(1) < 0.15) {
                loser.barons += 1;
            }
            
            // Towers
            _tick_winner.towers += irandom_range(2, 4);
            loser.towers += irandom_range(0, 2);
            break;
    }
}

// ===================================
// NEXUS DAMAGE CALCULATION
// ===================================

function calculate_nexus_damage(_team1, _team2, _phase, _phase_winner, _score_ratio) {
    
    var loser = (_phase_winner == _team1) ? _team2 : _team1;
    
    // Base damage for winning a tick
    var base_damage = 0;
    switch(_phase) {
        case "early": base_damage = 15; break;  // Early ticks do moderate damage
        case "mid": base_damage = 20; break;    // Mid game ramps up
        case "late": base_damage = 25; break;   // Late game is decisive
    }
    
    // Modify damage based on how hard they won (score ratio)
    // Close game (1.0-1.2 ratio) = 0.8x damage
    // Normal win (1.2-1.5 ratio) = 1.0x damage  
    // Dominant (1.5+ ratio) = 1.3x damage
    var dominance_multiplier = 1.0;
    if (_score_ratio < 1.2) {
        dominance_multiplier = 0.8;
    } else if (_score_ratio > 1.5) {
        dominance_multiplier = 1.3;
    }
    
    // Calculate gold advantage multiplier
    var gold_multiplier = 1.0;
    var gold_diff = abs(_phase_winner.gold - loser.gold);
    if (gold_diff > 5000) {
        gold_multiplier = 1.2;
    } else if (gold_diff > 10000) {
        gold_multiplier = 1.4;
    }
    
    // Objective bonuses
    var objective_bonus = 0;
    objective_bonus += (_phase_winner.dragons - loser.dragons) * 2;  // Each dragon = 2 damage
    objective_bonus += (_phase_winner.barons - loser.barons) * 8;    // Each baron = 8 damage
    objective_bonus += (_phase_winner.towers - loser.towers) * 1.5;  // Each tower = 1.5 damage
    
    // Calculate total damage
    var total_damage = (base_damage * dominance_multiplier * gold_multiplier) + objective_bonus;
    
    // Add some randomness (±10%)
    total_damage *= random_range(0.9, 1.1);
    
    // Comeback mechanic: If team is very behind, reduce damage taken slightly
    if (loser.nexus_hp < 25 && _phase_winner.nexus_hp > 75) {
        total_damage *= 0.9;  // 10% damage reduction for underdog (reduced from 15%)
        show_debug_message("Comeback mechanic activated! Damage reduced.");
    }
    
    // Deal damage
    loser.nexus_hp -= total_damage;
    loser.nexus_hp = max(0, loser.nexus_hp);  // Can't go below 0
    
    show_debug_message("Nexus damage: " + string(total_damage) + " | " + 
        _team1.name + ": " + string(_team1.nexus_hp) + " HP | " + 
        _team2.name + ": " + string(_team2.nexus_hp) + " HP");
}

// ===================================
// REAL-TIME MATCH SYSTEM
// ===================================

function create_match_state(_team1, _team2) {
    return {
        team1: _team1,
        team2: _team2,
        active: true,
        paused: false,
        game_time: 0,
        real_time_counter: 0,
        speed: 1.0,
        events: [],
        last_tick_time: 0,
        tick_interval: 2.5,
        winner: noone
    };
}

function add_match_event(_match_state, _message) {
    var event = {
        time: _match_state.game_time,
        message: _message
    };
    array_push(_match_state.events, event);
}

function get_match_phase(_match_state) {
    var avg_gold = (_match_state.team1.gold + _match_state.team2.gold) / 2;
    
    if (avg_gold < 5000) {
        return "Early Game";
    } else if (avg_gold < 15000) {
        return "Mid Game";
    } else {
        return "Late Game";
    }
}

function get_team_kills(_team) {
    var total = 0;
    for (var i = 0; i < array_length(_team.players); i++) {
        total += _team.players[i].kills;
    }
    return total;
}

function process_match_tick(_match_state) {
    
    var avg_gold = (_match_state.team1.gold + _match_state.team2.gold) / 2;
    var phase = "";
    
    if (avg_gold < 5000) {
        phase = "early";
    } else if (avg_gold < 15000) {
        phase = "mid";
    } else {
        phase = "late";
    }
    
    var t1_score = 0;
    var t2_score = 0;
    
    switch(phase) {
        case "early":
            t1_score = calculate_early_score(_match_state.team1);
            t2_score = calculate_early_score(_match_state.team2);
            break;
        case "mid":
            t1_score = calculate_mid_score(_match_state.team1);
            t2_score = calculate_mid_score(_match_state.team2);
            break;
        case "late":
            t1_score = calculate_late_score(_match_state.team1);
            t2_score = calculate_late_score(_match_state.team2);
            break;
    }
    
    t1_score *= random_range(0.85, 1.15);
    t2_score *= random_range(0.85, 1.15);
    
    var tick_winner = (t1_score > t2_score) ? _match_state.team1 : _match_state.team2;
    var tick_loser = (t1_score > t2_score) ? _match_state.team2 : _match_state.team1;
    var score_ratio = max(t1_score, t2_score) / min(t1_score, t2_score);
    
    tick_winner.phase_wins++;
    
    // Generate gold
    var base_gold = 0;
    switch(phase) {
        case "early": base_gold = 2000; break;
        case "mid": base_gold = 3000; break;
        case "late": base_gold = 4000; break;
    }
    
    var winner_gold = base_gold * random_range(1.1, 1.3);
    var loser_gold = base_gold * random_range(0.8, 1.0);
    
    tick_winner.gold += winner_gold;
    tick_loser.gold += loser_gold;
    
    // Generate objectives
    process_tick_objectives(_match_state, tick_winner, tick_loser, phase);
    
    // Generate kills
    var kills = irandom_range(2, 5);
    for (var i = 0; i < kills; i++) {
        var killer_index = irandom(4);
        var victim_index = irandom(4);
        
        tick_winner.players[killer_index].kills++;
        tick_loser.players[victim_index].deaths++;
        
        if (random(1) < 0.7) {
            var assister = irandom(4);
            if (assister != killer_index) {
                tick_winner.players[assister].assists++;
            }
        }
    }
    
    // Calculate nexus damage
    var base_damage = 0;
    switch(phase) {
        case "early": base_damage = 15; break;
        case "mid": base_damage = 20; break;
        case "late": base_damage = 25; break;
    }
    
    var dominance_mult = (score_ratio < 1.2) ? 0.8 : ((score_ratio > 1.5) ? 1.3 : 1.0);
    var gold_diff = abs(tick_winner.gold - tick_loser.gold);
    var gold_mult = (gold_diff > 10000) ? 1.4 : ((gold_diff > 5000) ? 1.2 : 1.0);
    
    var obj_bonus = 0;
    obj_bonus += (tick_winner.dragons - tick_loser.dragons) * 2;
    obj_bonus += (tick_winner.barons - tick_loser.barons) * 8;
    obj_bonus += (tick_winner.towers - tick_loser.towers) * 1.5;
    
    var total_damage = (base_damage * dominance_mult * gold_mult) + obj_bonus;
    total_damage *= random_range(0.9, 1.1);
    
    if (tick_loser.nexus_hp < 25 && tick_winner.nexus_hp > 75) {
        total_damage *= 0.9;
    }
    
    tick_loser.nexus_hp -= total_damage;
    tick_loser.nexus_hp = max(0, tick_loser.nexus_hp);
    
    if (tick_loser.nexus_hp <= 0) {
        _match_state.active = false;
        _match_state.winner = tick_winner;
        add_match_event(_match_state, tick_winner.name + " has destroyed the enemy Nexus! Victory!");
    }
}

function process_tick_objectives(_match_state, _winner, _loser, _phase) {
    
    switch(_phase) {
        case "early":
            if (random(1) < 0.4) {
                _winner.dragons += 1;
                add_match_event(_match_state, _winner.name + " secured a Dragon!");
            }
            
            var towers = irandom_range(1, 2);
            _winner.towers += towers;
            if (towers > 0) {
                add_match_event(_match_state, _winner.name + " destroyed " + string(towers) + " tower(s)");
            }
            break;
            
        case "mid":
            if (random(1) < 0.5) {
                _winner.dragons += 1;
                add_match_event(_match_state, _winner.name + " secured a Dragon!");
            }
            
            if (random(1) < 0.2) {
                _winner.barons += 1;
                add_match_event(_match_state, _winner.name + " slayed Baron Nashor!");
            }
            
            var towers = irandom_range(1, 3);
            _winner.towers += towers;
            if (towers > 0) {
                add_match_event(_match_state, _winner.name + " destroyed " + string(towers) + " tower(s)");
            }
            break;
            
        case "late":
            if (random(1) < 0.4) {
                _winner.dragons += 1;
                add_match_event(_match_state, _winner.name + " secured a Dragon!");
            }
            
            if (random(1) < 0.5) {
                _winner.barons += 1;
                add_match_event(_match_state, _winner.name + " slayed Baron Nashor!");
            }
            
            var towers = irandom_range(2, 4);
            _winner.towers += towers;
            if (towers > 0) {
                add_match_event(_match_state, _winner.name + " destroyed " + string(towers) + " tower(s)");
            }
            break;
    }
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
    _team1.nexus_hp = 100;
    _team2.nexus_hp = 100;
    
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
    
    // Track game time and total gold
    var game_minutes = 0;
    var tick_count = 0;
    
    // Simulate game in "ticks" until a nexus is destroyed
    while (_team1.nexus_hp > 0 && _team2.nexus_hp > 0 && game_minutes < 60) {
        
        // Determine current phase based on average team gold
        var avg_gold = (_team1.gold + _team2.gold) / 2;
        var current_phase = "";
        
        if (avg_gold < 5000) {
            current_phase = "early";
        } else if (avg_gold < 15000) {
            current_phase = "mid";
        } else {
            current_phase = "late";
        }
        
        // Simulate this tick (represents ~2-3 minutes of game time)
        simulate_game_tick(_team1, _team2, current_phase);
        
        tick_count++;
        game_minutes = tick_count * 2.5; // Each tick = 2.5 minutes
        
        // Safety: Stop after 60 minutes
        if (game_minutes >= 60) {
            show_debug_message("Game reached 60 minutes! Forcing end.");
            break;
        }
    }
    
    global.match_duration = round(game_minutes);
    
    // Determine winner - team with nexus still standing
    var winner;
    if (_team1.nexus_hp <= 0) {
        winner = _team2;
    } else if (_team2.nexus_hp <= 0) {
        winner = _team1;
    } else {
        // If both nexuses survive (time limit reached)
        winner = (_team1.nexus_hp > _team2.nexus_hp) ? _team1 : _team2;
    }
    
    return winner;
}

function simulate_game_tick(_team1, _team2, _phase) {
    
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
    
    // Determine tick winner
    var tick_winner;
    var score_diff = abs(t1_match_score - t2_match_score);
    var score_ratio = max(t1_match_score, t2_match_score) / min(t1_match_score, t2_match_score);
    
    if (t1_match_score > t2_match_score) {
        _team1.phase_wins++;
        tick_winner = _team1;
        array_push(_team1.phase_results, _phase + " WIN");
        array_push(_team2.phase_results, _phase + " LOSS");
    } else {
        _team2.phase_wins++;
        tick_winner = _team2;
        array_push(_team1.phase_results, _phase + " LOSS");
        array_push(_team2.phase_results, _phase + " WIN");
    }
    
    // Generate gold for this tick
    generate_tick_gold(_team1, _team2, _phase, tick_winner);
    
    // Generate objectives for this tick
    generate_tick_objectives(_team1, _team2, _phase, tick_winner);
    
    // Calculate nexus damage
    calculate_nexus_damage(_team1, _team2, _phase, tick_winner, score_ratio);
    
    // Generate player stats for this tick
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
	        create_champion("Rumble", "Top", 1.0, 1.0, 1.2, 1.0, 1.2, 1.1),
	        // Duelist, high mechanics scaling
	        create_champion("Fiora", "Top", 1.5, 0.8, 1.0, 1.2, 1.1, 1.3),
			// Simple mechanics, teamwork engage
	        create_champion("Malphite", "Top", 0.8, 1.2, 1.0, 1.0, 1.1, 1.0), 
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
			create_champion("Akali", "Mid", 1.5, 0.8, 1.1, 1.1, 1.2, 1.2)
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

// ===================================
// PLAYER POOL
// ===================================

function init_player_pool() {
    global.player_pool = {
        top: [
            create_pro_player("Zeus", "Top", 92, 85, 88),
            create_pro_player("Kingen", "Top", 85, 88, 82),
            create_pro_player("TheShy", "Top", 95, 70, 75),
            create_pro_player("Bin", "Top", 88, 80, 83)
        ],
        jungle: [
            create_pro_player("Canyon", "Jungle", 90, 92, 94),
            create_pro_player("Oner", "Jungle", 88, 90, 87),
            create_pro_player("Peanut", "Jungle", 85, 82, 90),
            create_pro_player("Jiejie", "Jungle", 82, 88, 85)
        ],
        mid: [
            create_pro_player("Faker", "Mid", 85, 90, 98),
            create_pro_player("Chovy", "Mid", 95, 82, 92),
            create_pro_player("Showmaker", "Mid", 92, 88, 90),
            create_pro_player("Knight", "Mid", 90, 85, 88)
        ],
        adc: [
            create_pro_player("Gumayusi", "ADC", 93, 88, 85),
            create_pro_player("Viper", "ADC", 90, 90, 88),
            create_pro_player("Ruler", "ADC", 88, 92, 90),
            create_pro_player("Elk", "ADC", 85, 85, 82)
        ],
        support: [
            create_pro_player("Keria", "Support", 85, 95, 92),
            create_pro_player("Meiko", "Support", 80, 92, 88),
            create_pro_player("Lehends", "Support", 88, 88, 85),
            create_pro_player("Missing", "Support", 82, 90, 80)
        ]
    };
}

// ===================================
// CHAMPION BAN SYSTEM
// ===================================

function create_ban_state() {
    return {
        active: true,
        current_ban: 0,
        team1_bans: [],
        team2_bans: [],
        all_bans: [],
        // Ban order: Team1, Team2, Team2, Team1, Team1, Team2
        ban_order: [1, 2, 2, 1, 1, 2]
    };
}

function get_current_team_banning(ban_state) {
    return ban_state.ban_order[ban_state.current_ban];
}

function get_available_champions_for_ban(ban_state) {
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
        
        for (var j = 0; j < array_length(ban_state.all_bans); j++) {
            if (ban_state.all_bans[j].name == champ.name) {
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


function make_ban(ban_state, champion) {
    var current_team = get_current_team_banning(ban_state);
    
    if (current_team == 1) {
        array_push(ban_state.team1_bans, champion);
    } else {
        array_push(ban_state.team2_bans, champion);
    }
    
    array_push(ban_state.all_bans, champion);
    ban_state.current_ban++;
    
    if (ban_state.current_ban >= 6) {
        ban_state.active = false;
    }
    
    return ban_state.active;
}

function ai_ban_champion(ban_state) {
    var available = get_available_champions_for_ban(ban_state);
    
    if (array_length(available) > 0) {
        // AI bans randomly for now (could be smarter later)
        var random_index = irandom(array_length(available) - 1);
        return available[random_index];
    }
    
    return noone;
}

// ===================================
// PLAYER DRAFT SYSTEM
// ===================================

function create_player_draft_state() {
    return {
        active: true,
        current_pick: 0,
        team1_picks: [],
        team2_picks: [],
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
        array_push(draft.team1_picks, player);
    } else {
        array_push(draft.team2_picks, player);
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
        return available[random_index];
    }
    
    return noone;
}

// ===================================
// CHAMPION DRAFT SYSTEM
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
		var is_banned = false; 
        
        for (var j = 0; j < array_length(draft.picked_champions); j++) {
            if (draft.picked_champions[j].name == champ.name) {
                is_picked = true;
                break;
            }
        }
        
		// Check if banned
        for (var j = 0; j < array_length(global.banned_champions); j++) {
            if (global.banned_champions[j].name == champ.name) {
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

// Create teams from drafts (both player and champion)
function create_teams_from_drafts(player_draft, champion_draft) {
    // Team 1 - Assign champions to drafted players
    for (var i = 0; i < 5; i++) {
        assign_champion_to_player(player_draft.team1_picks[i], champion_draft.team1_picks[i]);
    }
    global.team1 = create_team("Blue Team", player_draft.team1_picks);
    
    // Team 2
    for (var i = 0; i < 5; i++) {
        assign_champion_to_player(player_draft.team2_picks[i], champion_draft.team2_picks[i]);
    }
    global.team2 = create_team("Red Team", player_draft.team2_picks);
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
// PLAYER STATS GENERATION (Not used in real-time, kept for compatibility)
// ===================================

function generate_phase_stats(_team1, _team2, _phase, _team1_won) {
    // This function is no longer used in real-time matches
    // Stats are generated in process_match_tick instead
}

function distribute_kills(_team, _total_kills, _enemy_team) {
    // This function is no longer used in real-time matches
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
// MAP VISUAL SYSTEM
// ===================================

// Create map state for visual representation
function create_map_state() {
    return {
        // Tower states (true = standing, false = destroyed)
        team1_towers: {
            top: [true, true, true],      // Outer, Inner, Inhibitor
            mid: [true, true, true],
            bot: [true, true, true],
            nexus: [true, true]            // Nexus towers
        },
        team2_towers: {
            top: [true, true, true],
            mid: [true, true, true],
            bot: [true, true, true],
            nexus: [true, true]
        },
        
        // Active event animations
        active_events: [],
        
        // Gold lead for bar chart
        gold_lead: 0  // Positive = team1 ahead, negative = team2 ahead
    };
}

// Add an event animation
function add_map_event(_map_state, _type, _data) {
    var event = {
        type: _type,  // "tower_destroyed", "dragon_taken", "baron_taken", "kill"
        data: _data,
        timer: 0,
        duration: 60  // Frames to show animation
    };
    array_push(_map_state.active_events, event);
}

// Update map state based on match state
function update_map_visuals(_map_state, _match_state) {
    
    // Update gold lead
    _map_state.gold_lead = _match_state.team1.gold - _match_state.team2.gold;
    
    // Update tower states based on tower count
    // This is approximate - we don't track individual towers, just counts
    var t1_towers_destroyed = 11 - _match_state.team1.towers;
    var t2_towers_destroyed = 11 - _match_state.team2.towers;
    
    // Simplified: Mark towers as destroyed from outer to inner
    // Team 1 towers (top to bottom, outer to inner)
    var destroyed_count = 0;
    for (var lane = 0; lane < 3; lane++) {
        var lane_name = (lane == 0) ? "top" : ((lane == 1) ? "mid" : "bot");
        for (var tower = 0; tower < 3; tower++) {
            if (destroyed_count < t2_towers_destroyed) {
                _map_state.team2_towers[$ lane_name][tower] = false;
                destroyed_count++;
            }
        }
    }
    
    // Nexus towers
    if (destroyed_count < t2_towers_destroyed) {
        _map_state.team2_towers.nexus[0] = false;
        destroyed_count++;
    }
    if (destroyed_count < t2_towers_destroyed) {
        _map_state.team2_towers.nexus[1] = false;
    }
    
    // Same for team 1
    destroyed_count = 0;
    for (var lane = 0; lane < 3; lane++) {
        var lane_name = (lane == 0) ? "top" : ((lane == 1) ? "mid" : "bot");
        for (var tower = 0; tower < 3; tower++) {
            if (destroyed_count < t1_towers_destroyed) {
                _map_state.team1_towers[$ lane_name][tower] = false;
                destroyed_count++;
            }
        }
    }
    
    if (destroyed_count < t1_towers_destroyed) {
        _map_state.team1_towers.nexus[0] = false;
        destroyed_count++;
    }
    if (destroyed_count < t1_towers_destroyed) {
        _map_state.team1_towers.nexus[1] = false;
    }
    
    // Update event animations
    for (var i = array_length(_map_state.active_events) - 1; i >= 0; i--) {
        _map_state.active_events[i].timer++;
        
        // Remove expired events
        if (_map_state.active_events[i].timer >= _map_state.active_events[i].duration) {
            array_delete(_map_state.active_events, i, 1);
        }
    }
}

// Draw the simplified Summoner's Rift
function draw_summoners_rift(_map_state, _x, _y, _width, _height) {
    
    // Map background
    draw_set_color(c_dkgray);
    draw_rectangle(_x, _y, _x + _width, _y + _height, false);
    
    // Draw lanes (diagonal lines)
    draw_set_color(c_gray);
    
    // Top lane
    draw_line_width(_x + 20, _y + 20, _x + _width - 20, _y + _height/3, 3);
    
    // Mid lane
    draw_line_width(_x + 20, _y + 20, _x + _width - 20, _y + _height - 20, 3);
    
    // Bot lane
    draw_line_width(_x + _width/3, _y + _height - 20, _x + _width - 20, _y + _height - 20, 3);
    
    // Draw base areas
    draw_set_color(c_aqua);
    draw_rectangle(_x + 10, _y + 10, _x + 60, _y + 60, false);  // Team 1 base
    
    draw_set_color(c_red);
    draw_rectangle(_x + _width - 60, _y + _height - 60, _x + _width - 10, _y + _height - 10, false);  // Team 2 base
    
    // Draw towers
    draw_towers(_map_state, _x, _y, _width, _height);
    
    // Draw objective areas
    draw_set_color(c_purple);
    draw_circle(_x + _width * 0.3, _y + _height * 0.7, 15, false);  // Dragon pit
    draw_set_color(c_white);
    draw_text(_x + _width * 0.3 - 10, _y + _height * 0.7 - 5, "D");
    
    draw_set_color(c_purple);
    draw_circle(_x + _width * 0.7, _y + _height * 0.3, 15, false);  // Baron pit
    draw_set_color(c_white);
    draw_text(_x + _width * 0.7 - 10, _y + _height * 0.3 - 5, "B");
}

// Draw towers on the map
function draw_towers(_map_state, _x, _y, _width, _height) {
    
    var tower_size = 8;
    
    // Team 1 towers (blue side - bottom left)
    // Top lane
    draw_tower(_map_state.team1_towers.top[0], _x + 80, _y + 40, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.top[1], _x + 140, _y + 70, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.top[2], _x + 200, _y + 100, tower_size, c_aqua);
    
    // Mid lane
    draw_tower(_map_state.team1_towers.mid[0], _x + 80, _y + 80, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.mid[1], _x + 140, _y + 140, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.mid[2], _x + 200, _y + 200, tower_size, c_aqua);
    
    // Bot lane
    draw_tower(_map_state.team1_towers.bot[0], _x + 140, _y + _height - 40, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.bot[1], _x + 100, _y + _height - 70, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.bot[2], _x + 70, _y + _height - 100, tower_size, c_aqua);
    
    // Nexus towers
    draw_tower(_map_state.team1_towers.nexus[0], _x + 30, _y + 70, tower_size, c_aqua);
    draw_tower(_map_state.team1_towers.nexus[1], _x + 70, _y + 30, tower_size, c_aqua);
    
    // Team 2 towers (red side - top right)
    // Top lane
    draw_tower(_map_state.team2_towers.top[0], _x + _width - 140, _y + 40, tower_size, c_red);
    draw_tower(_map_state.team2_towers.top[1], _x + _width - 100, _y + 70, tower_size, c_red);
    draw_tower(_map_state.team2_towers.top[2], _x + _width - 70, _y + 100, tower_size, c_red);
    
    // Mid lane
    draw_tower(_map_state.team2_towers.mid[0], _x + _width - 80, _y + _height - 80, tower_size, c_red);
    draw_tower(_map_state.team2_towers.mid[1], _x + _width - 140, _y + _height - 140, tower_size, c_red);
    draw_tower(_map_state.team2_towers.mid[2], _x + _width - 200, _y + _height - 200, tower_size, c_red);
    
    // Bot lane
    draw_tower(_map_state.team2_towers.bot[0], _x + _width - 40, _y + _height - 140, tower_size, c_red);
    draw_tower(_map_state.team2_towers.bot[1], _x + _width - 70, _y + _height - 100, tower_size, c_red);
    draw_tower(_map_state.team2_towers.bot[2], _x + _width - 100, _y + _height - 70, tower_size, c_red);
    
    // Nexus towers
    draw_tower(_map_state.team2_towers.nexus[0], _x + _width - 30, _y + _height - 70, tower_size, c_red);
    draw_tower(_map_state.team2_towers.nexus[1], _x + _width - 70, _y + _height - 30, tower_size, c_red);
}

// Draw individual tower
function draw_tower(_standing, _x, _y, _size, _team_color) {
    if (_standing) {
        draw_set_color(_team_color);
        draw_rectangle(_x - _size, _y - _size, _x + _size, _y + _size, false);
    } else {
        draw_set_color(c_black);
        draw_rectangle(_x - _size, _y - _size, _x + _size, _y + _size, false);
        draw_set_color(c_dkgray);
        draw_rectangle(_x - _size + 2, _y - _size + 2, _x + _size - 2, _y + _size - 2, false);
    }
}

// Draw gold lead bar
function draw_gold_lead(_gold_diff, _x, _y, _width) {
    
    // Background
    draw_set_color(c_dkgray);
    draw_rectangle(_x, _y, _x + _width, _y + 20, false);
    
    // Center line
    draw_set_color(c_white);
    draw_line(_x + _width/2, _y, _x + _width/2, _y + 20);
    
    // Gold lead bar
    var max_gold_display = 15000;  // Max gold difference to show
    var lead_ratio = clamp(_gold_diff / max_gold_display, -1, 1);
    var bar_width = abs(lead_ratio) * (_width/2);
    
    if (_gold_diff > 0) {
        // Team 1 ahead
        draw_set_color(c_aqua);
        draw_rectangle(_x + _width/2, _y + 2, _x + _width/2 + bar_width, _y + 18, false);
    } else if (_gold_diff < 0) {
        // Team 2 ahead
        draw_set_color(c_red);
        draw_rectangle(_x + _width/2 - bar_width, _y + 2, _x + _width/2, _y + 18, false);
    }
    
    // Gold difference text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_x + _width/2, _y + 25, "Gold: " + string(abs(round(_gold_diff))));
    draw_set_halign(fa_left);
}