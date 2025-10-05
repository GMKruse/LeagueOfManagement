// Draw Event for obj_match_controller

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
// PLAYER DRAFT PHASE
// ===================================
if (player_draft.active) {
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "PLAYER DRAFT");
    draw_set_halign(fa_left);
    
    var current_team = get_current_team_player_draft(player_draft);
    var current_role = get_current_role_player_draft(player_draft);
    var team_color = (current_team == 1) ? c_aqua : c_red;
    var team_name = (current_team == 1) ? "Blue Team" : "Red Team";
    
    draw_set_color(team_color);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 50, team_name + " picks " + current_role);
    draw_set_color(c_white);
    draw_text(room_width/2, 75, "Pick " + string(player_draft.current_pick + 1) + " of 10");
    draw_set_halign(fa_left);
    
    // Team 1 picks
    draw_set_color(c_aqua);
    draw_text(50, 110, "Blue Team Players:");
    draw_set_color(c_white);
    
    var y_pos = 140;
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = roles[i] + ": ";
        if (i < array_length(player_draft.team1_picks)) {
            var p = player_draft.team1_picks[i];
            pick_text += p.name + " (M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge) + ")";
        } else {
            pick_text += "???";
        }
        draw_text(50, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Team 2 picks
    draw_set_color(c_red);
    draw_text(room_width - 450, 110, "Red Team Players:");
    draw_set_color(c_white);
    
    y_pos = 140;
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = roles[i] + ": ";
        if (i < array_length(player_draft.team2_picks)) {
            var p = player_draft.team2_picks[i];
            pick_text += p.name + " (M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge) + ")";
        } else {
            pick_text += "???";
        }
        draw_text(room_width - 450, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Available players
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 280, "Available Players:");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    var available = get_available_players(player_draft);
    y_pos = 310;
    
    if (current_team == 1) {
        for (var i = 0; i < array_length(available); i++) {
            var player = available[i];
            
            var button_x = room_width/2 - 150;
            var button_y = y_pos;
            var button_width = 300;
            var button_height = 30;
            
            var is_hovering = point_in_rectangle(mouse_x, mouse_y, 
                button_x, button_y, button_x + button_width, button_y + button_height);
            
            if (is_hovering) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_dkgray);
            }
            
            draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
            
            draw_set_color(c_black);
            draw_text(button_x + 10, button_y + 8, player.name + " - Mech:" + string(player.mechanics) + 
                " Team:" + string(player.teamwork) + " Know:" + string(player.knowledge));
            
            draw_set_color(c_white);
            y_pos += 35;
        }
        
        draw_set_halign(fa_center);
        draw_text(room_width/2, y_pos + 20, "Click a player to pick!");
        draw_set_halign(fa_left);
    } else {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 340, "Red Team is thinking...");
        draw_set_halign(fa_left);
    }
}

// ===================================
// BAN PHASE
// ===================================
else if (player_draft_complete && champion_ban.active) {
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "CHAMPION BAN PHASE");
    draw_set_halign(fa_left);
    
    var current_team = get_current_team_banning(champion_ban);
    var team_color = (current_team == 1) ? c_aqua : c_red;
    var team_name = (current_team == 1) ? "Blue Team" : "Red Team";
    
    draw_set_color(team_color);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 50, team_name + " is banning...");
    draw_set_color(c_white);
    draw_text(room_width/2, 75, "Ban " + string(champion_ban.current_ban + 1) + " of 6");
    draw_set_halign(fa_left);
    
    // Team 1 bans (top left)
    draw_set_color(c_aqua);
    draw_text(50, 110, "Blue Team Bans:");
    draw_set_color(c_white);
    
    var y_pos = 140;
    for (var i = 0; i < 3; i++) {
        var ban_text = "Ban " + string(i + 1) + ": ";
        if (i < array_length(champion_ban.team1_bans)) {
            ban_text += champion_ban.team1_bans[i].name;
        } else {
            ban_text += "???";
        }
        draw_text(50, y_pos, ban_text);
        y_pos += 25;
    }
    
    // Team 2 bans (top right)
    draw_set_color(c_red);
    draw_text(room_width - 250, 110, "Red Team Bans:");
    draw_set_color(c_white);
    
    y_pos = 140;
    for (var i = 0; i < 3; i++) {
        var ban_text = "Ban " + string(i + 1) + ": ";
        if (i < array_length(champion_ban.team2_bans)) {
            ban_text += champion_ban.team2_bans[i].name;
        } else {
            ban_text += "???";
        }
        draw_text(room_width - 250, y_pos, ban_text);
        y_pos += 25;
    }
    
    // Show selected players in bottom corners
    // Team 1 players (bottom left)
    draw_set_color(c_aqua);
    draw_text(20, room_height - 200, "Blue Team Players:");
    draw_set_color(c_white);
    y_pos = room_height - 175;
    for (var i = 0; i < array_length(player_draft.team1_picks); i++) {
        var p = player_draft.team1_picks[i];
        draw_text(20, y_pos, p.name + " - " + p.role);
        draw_text(25, y_pos + 12, "M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge));
        y_pos += 30;
    }
    
    // Team 2 players (bottom right)
    draw_set_color(c_red);
    draw_text(room_width - 280, room_height - 200, "Red Team Players:");
    draw_set_color(c_white);
    y_pos = room_height - 175;
    for (var i = 0; i < array_length(player_draft.team2_picks); i++) {
        var p = player_draft.team2_picks[i];
        draw_text(room_width - 280, y_pos, p.name + " - " + p.role);
        draw_text(room_width - 275, y_pos + 12, "M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge));
        y_pos += 30;
    }
    
    // Champion stats on hover (center, above available champions)
    var hovered_champ = noone;
    if (current_team == 1) {
        var available = get_available_champions_for_ban(champion_ban);
        var max_per_col = 15;
        var col_width = 220;
        
        for (var i = 0; i < array_length(available); i++) {
            var col = floor(i / max_per_col);
            var row_in_col = i % max_per_col;
            
            var button_x = room_width/2 - 330 + (col * col_width);
            var button_y = 250 + (row_in_col * 28);
            var button_width = 200;
            var button_height = 25;
            
            if (point_in_rectangle(mouse_x, mouse_y, 
                button_x, button_y, button_x + button_width, button_y + button_height)) {
                hovered_champ = available[i];
                break;
            }
        }
    }
    
    // Draw hovered champion stats
    if (hovered_champ != noone) {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 180, hovered_champ.name + " (" + hovered_champ.role + ")");
        draw_set_color(c_white);
        draw_text(room_width/2, 200, "Mechanics: " + string(hovered_champ.mechanics_scaling) + 
            "  Teamwork: " + string(hovered_champ.teamwork_scaling) + 
            "  Knowledge: " + string(hovered_champ.knowledge_scaling));
        draw_set_halign(fa_left);
    }
    
    // Available champions to ban
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 220, "Available Champions:");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    if (current_team == 1) {
        var available = get_available_champions_for_ban(champion_ban);
        
        var max_per_col = 15;
        var col_width = 220;
        
        for (var i = 0; i < array_length(available); i++) {
            var champ = available[i];
            
            var col = floor(i / max_per_col);
            var row_in_col = i % max_per_col;
            
            var button_x = room_width/2 - 330 + (col * col_width);
            var button_y = 250 + (row_in_col * 28);
            var button_width = 200;
            var button_height = 25;
            
            var is_hovering = point_in_rectangle(mouse_x, mouse_y, 
                button_x, button_y, button_x + button_width, button_y + button_height);
            
            if (is_hovering) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_dkgray);
            }
            
            draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
            
            draw_set_color(c_black);
            draw_text(button_x + 5, button_y + 5, champ.name + " (" + champ.role + ")");
            
            draw_set_color(c_white);
        }
        
    } else {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 340, "Red Team is thinking...");
        draw_set_halign(fa_left);
    }
}


// ===================================
// CHAMPION DRAFT PHASE
// ===================================
else if (player_draft_complete && champion_draft.active) {
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "CHAMPION DRAFT");
    draw_set_halign(fa_left);
    
    var current_team = get_current_team(champion_draft);
    var current_role = get_current_role(champion_draft);
    var team_color = (current_team == 1) ? c_aqua : c_red;
    var team_name = (current_team == 1) ? "Blue Team" : "Red Team";
    
    // Show banned champions (center top, below pick count)
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 95, "BANNED:");
    draw_set_color(c_white);
    
    var ban_text = "";
    for (var i = 0; i < array_length(global.banned_champions); i++) {
        ban_text += global.banned_champions[i].name;
        if (i < array_length(global.banned_champions) - 1) {
            ban_text += ", ";
        }
    }
    draw_text(room_width/2, 115, ban_text);
    draw_set_halign(fa_left);
    
    // Adjust the team picks to start lower
    // Team 1 picks (top left)
    draw_set_color(c_aqua);
    draw_text(50, 110, "Blue Team:");
    draw_set_color(c_white);
    
    var y_pos = 140;
    var roles = ["Top", "Jungle", "Mid", "ADC", "Support"];
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = "";
        if (i < array_length(player_draft.team1_picks)) {
            pick_text += player_draft.team1_picks[i].name + " - ";
        }
        pick_text += roles[i] + ": ";
        if (i < array_length(champion_draft.team1_picks)) {
            pick_text += champion_draft.team1_picks[i].name;
        } else {
            pick_text += "???";
        }
        draw_text(50, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Team 2 picks (top right)
    draw_set_color(c_red);
    draw_text(room_width - 350, 110, "Red Team:");
    draw_set_color(c_white);
    
    y_pos = 140;
    for (var i = 0; i < array_length(roles); i++) {
        var pick_text = "";
        if (i < array_length(player_draft.team2_picks)) {
            pick_text += player_draft.team2_picks[i].name + " - ";
        }
        pick_text += roles[i] + ": ";
        if (i < array_length(champion_draft.team2_picks)) {
            pick_text += champion_draft.team2_picks[i].name;
        } else {
            pick_text += "???";
        }
        draw_text(room_width - 350, y_pos, pick_text);
        y_pos += 25;
    }
    
    // Show selected players with stats in bottom corners
    // Team 1 players (bottom left)
    draw_set_color(c_aqua);
    draw_text(20, room_height - 200, "Blue Team Players:");
    draw_set_color(c_white);
    y_pos = room_height - 175;
    for (var i = 0; i < array_length(player_draft.team1_picks); i++) {
        var p = player_draft.team1_picks[i];
        draw_text(20, y_pos, p.name + " - " + p.role);
        draw_text(25, y_pos + 12, "M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge));
        y_pos += 30;
    }
    
    // Team 2 players (bottom right)
    draw_set_color(c_red);
    draw_text(room_width - 280, room_height - 200, "Red Team Players:");
    draw_set_color(c_white);
    y_pos = room_height - 175;
    for (var i = 0; i < array_length(player_draft.team2_picks); i++) {
        var p = player_draft.team2_picks[i];
        draw_text(room_width - 280, y_pos, p.name + " - " + p.role);
        draw_text(room_width - 275, y_pos + 12, "M:" + string(p.mechanics) + " T:" + string(p.teamwork) + " K:" + string(p.knowledge));
        y_pos += 30;
    }
    
    // Champion stats on hover
    var hovered_champ = noone;
    if (current_team == 1) {
        var available = get_available_champions(champion_draft);
        var y_check = 310;
        
        for (var i = 0; i < array_length(available); i++) {
            var button_x = room_width/2 - 100;
            var button_y = y_check;
            var button_width = 200;
            var button_height = 30;
            
            if (point_in_rectangle(mouse_x, mouse_y, 
                button_x, button_y, button_x + button_width, button_y + button_height)) {
                hovered_champ = available[i];
                break;
            }
            
            y_check += 35;
        }
    }
    
    // Draw hovered champion stats
    if (hovered_champ != noone) {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 240, hovered_champ.name);
        draw_set_color(c_white);
        draw_text(room_width/2, 260, "Mech: " + string(hovered_champ.mechanics_scaling) + 
            "  Team: " + string(hovered_champ.teamwork_scaling) + 
            "  Know: " + string(hovered_champ.knowledge_scaling));
        draw_set_halign(fa_left);
    }
    
    // Available champions
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 280, "Available Champions:");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    var available = get_available_champions(champion_draft);
    y_pos = 310;
    
    if (current_team == 1) {
        for (var i = 0; i < array_length(available); i++) {
            var champ = available[i];
            
            var button_x = room_width/2 - 100;
            var button_y = y_pos;
            var button_width = 200;
            var button_height = 30;
            
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
            
            draw_set_color(c_white);
            y_pos += 35;
        }
        
        draw_set_halign(fa_center);
        draw_text(room_width/2, room_height - 240, "Click a champion to pick!");
        draw_set_halign(fa_left);
    } else {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 340, "Red Team is thinking...");
        draw_set_halign(fa_left);
    }
}

// ===================================
// PRE-MATCH SCREEN (After both drafts)
// ===================================
else if (player_draft_complete && !champion_draft.active && !match_started && !match_simulated && teams_created) {
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, 20, "MATCH READY!");
    draw_set_halign(fa_left);
    
    // Team 1
    draw_set_color(c_aqua);
    draw_text(50, 60, global.team1.name);
    draw_set_color(c_white);
    
    var y_pos = 90;
    for (var i = 0; i < array_length(global.team1.players); i++) {
        var p = global.team1.players[i];
        var stats_text = p.name + " - " + p.champion.name + " (" + p.role + ")";
        draw_text(50, y_pos, stats_text);
        y_pos += 25;
    }
    
    // Team 2
    draw_set_color(c_red);
    draw_text(room_width - 400, 60, global.team2.name);
    draw_set_color(c_white);
    
    y_pos = 90;
    for (var i = 0; i < array_length(global.team2.players); i++) {
        var p = global.team2.players[i];
        var stats_text = p.name + " - " + p.champion.name + " (" + p.role + ")";
        draw_text(room_width - 400, y_pos, stats_text);
        y_pos += 25;
    }
    
    // Start button
    draw_set_color(c_lime);
    draw_rectangle(room_width/2 - 100, room_height - 100, room_width/2 + 100, room_height - 60, false);
    draw_set_color(c_black);
    draw_text(room_width/2 - 80, room_height - 90, "START MATCH");
    
    draw_set_color(c_white);
    draw_text(room_width/2 - 100, room_height - 50, "Click to start live match!");
}

// ===================================
// LIVE MATCH PHASE
// ===================================
else if (match_started && !match_simulated) {
    
    // Top bar - Timer and phase
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    var time_string = string(floor(match_state.game_time)) + ":00";
    draw_text(room_width/2, 10, "LIVE MATCH - " + time_string + " - " + get_match_phase(match_state));
    
    var speed_text = "Speed: " + string(match_state.speed) + "x";
    if (match_state.paused) speed_text = "PAUSED";
    draw_set_color(c_yellow);
    draw_text(room_width/2, 30, speed_text);
    draw_set_halign(fa_left);
    
    // Draw the map in center
    var map_x = room_width/2 - 200;
    var map_y = 60;
    var map_width = 400;
    var map_height = 400;
    
    draw_summoners_rift(map_state, map_x, map_y, map_width, map_height);
    
    // Draw gold lead bar above map
    draw_gold_lead(map_state.gold_lead, map_x, map_y - 35, map_width);
    
    // Compact team stats on left
    draw_set_color(c_aqua);
    draw_text(20, 60, match_state.team1.name);
    draw_set_color(c_white);
    var y_pos = 80;
    draw_text(20, y_pos, "Nexus: " + string(round(match_state.team1.nexus_hp)) + " HP");
    y_pos += 18;
    draw_text(20, y_pos, "Gold: " + string(round(match_state.team1.gold)));
    y_pos += 18;
    draw_text(20, y_pos, "Kills: " + string(get_team_kills(match_state.team1)));
    y_pos += 18;
    draw_text(20, y_pos, "D:" + string(match_state.team1.dragons) + " B:" + string(match_state.team1.barons) + " T:" + string(match_state.team1.towers));
    
    // Compact team stats on right
    draw_set_color(c_red);
    draw_text(room_width - 180, 60, match_state.team2.name);
    draw_set_color(c_white);
    y_pos = 80;
    draw_text(room_width - 180, y_pos, "Nexus: " + string(round(match_state.team2.nexus_hp)) + " HP");
    y_pos += 18;
    draw_text(room_width - 180, y_pos, "Gold: " + string(round(match_state.team2.gold)));
    y_pos += 18;
    draw_text(room_width - 180, y_pos, "Kills: " + string(get_team_kills(match_state.team2)));
    y_pos += 18;
    draw_text(room_width - 180, y_pos, "D:" + string(match_state.team2.dragons) + " B:" + string(match_state.team2.barons) + " T:" + string(match_state.team2.towers));
    
    // Event feed below map
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(room_width/2, map_y + map_height + 10, "--- Recent Events ---");
    draw_set_color(c_white);
    
    var event_start = max(0, array_length(match_state.events) - 5);
    y_pos = map_y + map_height + 30;
    for (var i = event_start; i < array_length(match_state.events); i++) {
        var event = match_state.events[i];
        draw_text(room_width/2, y_pos, string(floor(event.time)) + " min - " + event.message);
        y_pos += 16;
    }
    draw_set_halign(fa_left);
    
    // Control buttons at bottom
    draw_set_color(c_white);
    y_pos = room_height - 60;
    draw_text(50, y_pos - 20, "Controls:");
    
    var pause_color = match_state.paused ? c_lime : c_dkgray;
    draw_set_color(pause_color);
    draw_rectangle(50, room_height - 50, 150, room_height - 20, false);
    draw_set_color(c_black);
    var pause_text = match_state.paused ? "PLAY" : "PAUSE";
    draw_text(75, room_height - 45, pause_text);
    
    draw_set_color(match_state.speed == 1.0 ? c_yellow : c_dkgray);
    draw_rectangle(170, room_height - 50, 220, room_height - 20, false);
    draw_set_color(c_black);
    draw_text(185, room_height - 45, "1x");
    
    draw_set_color(match_state.speed == 2.0 ? c_yellow : c_dkgray);
    draw_rectangle(230, room_height - 50, 280, room_height - 20, false);
    draw_set_color(c_black);
    draw_text(245, room_height - 45, "2x");
    
    draw_set_color(match_state.speed == 5.0 ? c_yellow : c_dkgray);
    draw_rectangle(290, room_height - 50, 340, room_height - 20, false);
    draw_set_color(c_black);
    draw_text(305, room_height - 45, "5x");
    
    draw_set_color(match_state.speed == 20.0 ? c_yellow : c_dkgray);
    draw_rectangle(350, room_height - 50, 450, room_height - 20, false);
    draw_set_color(c_black);
    draw_text(365, room_height - 45, "Fast Forward");
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
    
    // Nexus HP bar
    draw_set_color(c_dkgray);
    draw_rectangle(50, 135, 250, 155, false);
    var hp1_width = (global.team1.nexus_hp / 100) * 200;
    var hp1_color = global.team1.nexus_hp > 50 ? c_lime : (global.team1.nexus_hp > 25 ? c_yellow : c_red);
    draw_set_color(hp1_color);
    draw_rectangle(50, 135, 50 + hp1_width, 155, false);
    draw_set_color(c_white);
    draw_text(55, 138, "Nexus: " + string(round(global.team1.nexus_hp)) + " HP");
    
    draw_set_color(c_white);
    
    var y_pos = 170;
    
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
    
    // Nexus HP bar
    draw_set_color(c_dkgray);
    draw_rectangle(room_width - 400, 135, room_width - 200, 155, false);
    var hp2_width = (global.team2.nexus_hp / 100) * 200;
    var hp2_color = global.team2.nexus_hp > 50 ? c_lime : (global.team2.nexus_hp > 25 ? c_yellow : c_red);
    draw_set_color(hp2_color);
    draw_rectangle(room_width - 400, 135, room_width - 400 + hp2_width, 155, false);
    draw_set_color(c_white);
    draw_text(room_width - 395, 138, "Nexus: " + string(round(global.team2.nexus_hp)) + " HP");
    
    draw_set_color(c_white);
    
    y_pos = 170;
    
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