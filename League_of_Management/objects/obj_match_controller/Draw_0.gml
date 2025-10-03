// Draw Event for obj_match_controller

// Set up drawing
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Check if match has been simulated
if (!variable_instance_exists(id, "match_simulated")) {
    match_simulated = false;
}

// Check if teams have been created
if (!variable_instance_exists(id, "teams_created")) {
    teams_created = false;
}

// ===================================
// DRAFT PHASE
// ===================================
if (draft.active) {
    
    // Title
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "CHAMPION DRAFT");
    draw_set_halign(fa_left);
    
    // Current pick info
    var current_team = get_current_team(draft);
    var current_role = get_current_role(draft);
    var team_color = (current_team == 1) ? c_aqua : c_red;
    var team_name = (current_team == 1) ? "Blue Team" : "Red Team";
    
    draw_set_color(team_color);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 50, team_name + " picks " + current_role);
    draw_set_color(c_white);
    draw_text(room_width/2, 75, "Pick " + string(draft.current_pick + 1) + " of 10");
    draw_set_halign(fa_left);
    
    // Team 1 picks (Left side)
    draw_set_color(c_aqua);
    draw_text(50, 110, "Blue Team Draft:");
    draw_set_color(c_white);
    
    var y_pos = 140;
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = roles[i] + ": ";
        if (i < array_length(draft.team1_picks)) {
            pick_text += draft.team1_picks[i].name;
        } else {
            pick_text += "???";
        }
        draw_text(50, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Team 2 picks (Right side)
    draw_set_color(c_red);
    draw_text(room_width - 250, 110, "Red Team Draft:");
    draw_set_color(c_white);
    
    y_pos = 140;
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = roles[i] + ": ";
        if (i < array_length(draft.team2_picks)) {
            pick_text += draft.team2_picks[i].name;
        } else {
            pick_text += "???";
        }
        draw_text(room_width - 250, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Available champions (Center)
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 280, "Available Champions:");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    var available = get_available_champions(draft);
    y_pos = 310;
    
    // Only show champion selection if it's Team 1's turn (player controlled)
    if (current_team == 1) {
        for (var i = 0; i < array_length(available); i++) {
            var champ = available[i];
            
            // Draw champion button
            var button_x = room_width/2 - 100;
            var button_y = y_pos;
            var button_width = 200;
            var button_height = 30;
            
            // Check if mouse is hovering
            var is_hovering = point_in_rectangle(mouse_x, mouse_y, 
                button_x, button_y, button_x + button_width, button_y + button_height);
            
            if (is_hovering) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_dkgray);
            }
            
            draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
            
            draw_set_color(c_black);
            draw_text(button_x + 10, button_y + 8, champ.name);
            
            // Show champion stats on hover
            if (is_hovering) {
                draw_set_color(c_white);
                var info_x = button_x + button_width + 10;
                draw_text(info_x, button_y, "Mech:" + string(champ.mechanics_scaling) + 
                    " Team:" + string(champ.teamwork_scaling) + 
                    " Know:" + string(champ.knowledge_scaling));
            }
            
            draw_set_color(c_white);
            y_pos += 35;
        }
        
        draw_set_halign(fa_center);
        draw_text(room_width/2, y_pos + 20, "Click a champion to pick!");
        draw_set_halign(fa_left);
    } else {
        // AI is picking
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 340, "Red Team is thinking...");
        draw_set_halign(fa_left);
    }
}

// ===================================
// PRE-MATCH SCREEN (After draft, before simulation)
// ===================================
else if (!draft.active && !match_simulated && teams_created) {
    
    // Title
    draw_set_color(c_white);
    draw_text(room_width/2 - 100, 20, "LEAGUE OF LEGENDS MATCH");
    
    // Team 1 (Left side)
    draw_set_color(c_aqua);
    draw_text(50, 60, global.team1.name);
    draw_set_color(c_white);
    
    // Title
    draw_set_color(c_white);
    draw_text(room_width/2 - 100, 20, "LEAGUE OF LEGENDS MATCH");
    
    // Team 1 (Left side)
    draw_set_color(c_aqua);
    draw_text(50, 60, global.team1.name);
    draw_set_color(c_white);
    
    var y_pos = 90;
    for (var i = 0; i < array_length(global.team1.players); i++) {
        var p = global.team1.players[i];
        var stats_text = p.name + " - " + p.champion.name + " (" + p.role + ")";
        stats_text += " | Mech:" + string(p.mechanics);
        stats_text += " Team:" + string(p.teamwork);
        stats_text += " Know:" + string(p.knowledge);
        draw_text(50, y_pos, stats_text);
        y_pos += 25;
    }
    
    // VS in the middle
    draw_set_color(c_yellow);
    draw_text(room_width/2 - 20, room_height/2 - 30, "VS");
    
    // Team 2 (Right side)
    draw_set_color(c_red);
    draw_text(room_width - 400, 60, global.team2.name);
    draw_set_color(c_white);
    
    y_pos = 90;
    for (var i = 0; i < array_length(global.team2.players); i++) {
        var p = global.team2.players[i];
        var stats_text = p.name + " - " + p.champion.name + " (" + p.role + ")";
        stats_text += " | Mech:" + string(p.mechanics);
        stats_text += " Team:" + string(p.teamwork);
        stats_text += " Know:" + string(p.knowledge);
        draw_text(room_width - 400, y_pos, stats_text);
        y_pos += 25;
    }
    
    // Simulate button
    draw_set_color(c_lime);
    draw_rectangle(room_width/2 - 100, room_height - 100, room_width/2 + 100, room_height - 60, false);
    draw_set_color(c_black);
    draw_text(room_width/2 - 80, room_height - 90, "SIMULATE MATCH");
    
    // Button instructions
    draw_set_color(c_white);
    draw_text(room_width/2 - 100, room_height - 50, "Click the button to simulate!");
}

// ===================================
// POST-MATCH RESULTS SCREEN
// ===================================
else if (match_simulated && winner != noone) {
    
    // Winner announcement
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "MATCH RESULT");
    draw_set_color(c_lime);
    draw_text(room_width/2, 45, winner.name + " WINS!");
    
    // Match duration
    draw_set_color(c_white);
    draw_text(room_width/2, 70, "Match Duration: " + string(global.match_duration) + " minutes");
    draw_set_halign(fa_left);
    
    // Team 1 results (Left side)
    draw_set_color(c_aqua);
    draw_text(50, 110, global.team1.name);
    draw_set_color(c_white);
    
    var y_pos = 140;
    
    // Phase results
    draw_set_color(c_yellow);
    draw_text(50, y_pos, "Phase Results:");
    y_pos += 20;
    draw_set_color(c_white);
    for (var i = 0; i < array_length(global.team1.phase_results); i++) {
        var result_color = (string_pos("WIN", global.team1.phase_results[i]) > 0) ? c_lime : c_red;
        draw_set_color(result_color);
        draw_text(50, y_pos, global.team1.phase_results[i]);
        y_pos += 20;
    }
    
    // Objectives
    y_pos += 10;
    draw_set_color(c_yellow);
    draw_text(50, y_pos, "Objectives:");
    y_pos += 20;
    draw_set_color(c_white);
    draw_text(50, y_pos, "Gold: " + string(global.team1.gold));
    y_pos += 20;
    draw_text(50, y_pos, "Dragons: " + string(global.team1.dragons));
    y_pos += 20;
    draw_text(50, y_pos, "Barons: " + string(global.team1.barons));
    y_pos += 20;
    draw_text(50, y_pos, "Towers: " + string(global.team1.towers));
    y_pos += 30;
    
    // Player stats
    draw_set_color(c_yellow);
    draw_text(50, y_pos, "Player Stats (K/D/A):");
    y_pos += 20;
    draw_set_color(c_white);
    
    for (var i = 0; i < array_length(global.team1.players); i++) {
        var p = global.team1.players[i];
        var kda_text = p.name + " (" + p.champion.name + ") - ";
        kda_text += string(p.kills) + "/" + string(p.deaths) + "/" + string(p.assists);
        draw_text(50, y_pos, kda_text);
        y_pos += 20;
    }
    
    // Team 2 results (Right side)
    draw_set_color(c_red);
    draw_text(room_width - 400, 110, global.team2.name);
    draw_set_color(c_white);
    
    y_pos = 140;
    
    // Phase results
    draw_set_color(c_yellow);
    draw_text(room_width - 400, y_pos, "Phase Results:");
    y_pos += 20;
    draw_set_color(c_white);
    for (var i = 0; i < array_length(global.team2.phase_results); i++) {
        var result_color = (string_pos("WIN", global.team2.phase_results[i]) > 0) ? c_lime : c_red;
        draw_set_color(result_color);
        draw_text(room_width - 400, y_pos, global.team2.phase_results[i]);
        y_pos += 20;
    }
    
    // Objectives
    y_pos += 10;
    draw_set_color(c_yellow);
    draw_text(room_width - 400, y_pos, "Objectives:");
    y_pos += 20;
    draw_set_color(c_white);
    draw_text(room_width - 400, y_pos, "Gold: " + string(global.team2.gold));
    y_pos += 20;
    draw_text(room_width - 400, y_pos, "Dragons: " + string(global.team2.dragons));
    y_pos += 20;
    draw_text(room_width - 400, y_pos, "Barons: " + string(global.team2.barons));
    y_pos += 20;
    draw_text(room_width - 400, y_pos, "Towers: " + string(global.team2.towers));
    y_pos += 30;
    
    // Player stats
    draw_set_color(c_yellow);
    draw_text(room_width - 400, y_pos, "Player Stats (K/D/A):");
    y_pos += 20;
    draw_set_color(c_white);
    
    for (var i = 0; i < array_length(global.team2.players); i++) {
        var p = global.team2.players[i];
        var kda_text = p.name + " (" + p.champion.name + ") - ";
        kda_text += string(p.kills) + "/" + string(p.deaths) + "/" + string(p.assists);
        draw_text(room_width - 400, y_pos, kda_text);
        y_pos += 20;
    }
    
    // Simulate again button
    draw_set_color(c_lime);
    draw_rectangle(room_width/2 - 100, room_height - 100, room_width/2 + 100, room_height - 60, false);
    draw_set_color(c_black);
    draw_text(room_width/2 - 70, room_height - 90, "SIMULATE AGAIN");
    
    draw_set_color(c_white);
    draw_text(room_width/2 - 100, room_height - 50, "Click to run another match!");
}

// ===================================
// LOADING / TRANSITION SCREEN
// ===================================
else {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, room_height/2, "Creating teams...");
    draw_set_halign(fa_left);
}