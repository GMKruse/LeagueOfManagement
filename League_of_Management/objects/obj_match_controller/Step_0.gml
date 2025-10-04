// Step Event for obj_match_controller

// ===================================
// PLAYER DRAFT PHASE
// ===================================
if (player_draft.active) {
    
    var current_team = get_current_team_player_draft(player_draft);
    
    // Team 1 (Player) picks
    if (current_team == 1) {
        
        if (mouse_check_button_pressed(mb_left)) {
            
            var available = get_available_players(player_draft);
            var y_pos = 310;
            
            for (var i = 0; i < array_length(available); i++) {
                var button_x = room_width/2 - 150;
                var button_y = y_pos;
                var button_width = 300;
                var button_height = 30;
                
                if (point_in_rectangle(mouse_x, mouse_y, 
                    button_x, button_y, button_x + button_width, button_y + button_height)) {
                    
                    make_player_pick(player_draft, available[i]);
                    show_debug_message("Blue Team picked player: " + available[i].name);
                    break;
                }
                
                y_pos += 35;
            }
        }
    }
    // Team 2 (AI) picks
    else {
        
        if (!variable_instance_exists(id, "ai_pick_timer")) {
            ai_pick_timer = 0;
        }
        
        ai_pick_timer++;
        
        if (ai_pick_timer >= 60) {
            var ai_choice = ai_pick_player(player_draft);
            
            if (ai_choice != noone) {
                make_player_pick(player_draft, ai_choice);
                show_debug_message("Red Team picked player: " + ai_choice.name);
            }
            
            ai_pick_timer = 0;
        }
    }
    
    // Check if player draft complete
    if (!player_draft.active && !player_draft_complete) {
        player_draft_complete = true;
        champion_draft = create_draft_state();
        show_debug_message("Player draft complete! Starting champion draft...");
    }
}

// ===================================
// CHAMPION DRAFT PHASE
// ===================================
else if (player_draft_complete && champion_draft.active) {
    
    var current_team = get_current_team(champion_draft);
    
    // Team 1 (Player) picks
    if (current_team == 1) {
        
        if (mouse_check_button_pressed(mb_left)) {
            
            var available = get_available_champions(champion_draft);
            var y_pos = 310;
            
            for (var i = 0; i < array_length(available); i++) {
                var button_x = room_width/2 - 100;
                var button_y = y_pos;
                var button_width = 200;
                var button_height = 30;
                
                if (point_in_rectangle(mouse_x, mouse_y, 
                    button_x, button_y, button_x + button_width, button_y + button_height)) {
                    
                    make_pick(champion_draft, available[i]);
                    show_debug_message("Blue Team picked champion: " + available[i].name);
                    break;
                }
                
                y_pos += 35;
            }
        }
    }
    // Team 2 (AI) picks
    else {
        
        if (!variable_instance_exists(id, "ai_pick_timer")) {
            ai_pick_timer = 0;
        }
        
        ai_pick_timer++;
        
        if (ai_pick_timer >= 60) {
            var ai_choice = ai_pick_champion(champion_draft);
            
            if (ai_choice != noone) {
                make_pick(champion_draft, ai_choice);
                show_debug_message("Red Team picked champion: " + ai_choice.name);
            }
            
            ai_pick_timer = 0;
        }
    }
}

// ===================================
// PRE-MATCH PHASE (After both drafts complete)
// ===================================
else if (player_draft_complete && !champion_draft.active && !match_started && !match_simulated) {
    
    // Create teams from drafts (only once)
    if (!teams_created) {
        create_teams_from_drafts(player_draft, champion_draft);
        teams_created = true;
        show_debug_message("Both drafts complete! Teams created.");
    }
    
    // Check for start match button click
    if (mouse_check_button_pressed(mb_left)) {
        
        var button_x1 = room_width/2 - 100;
        var button_y1 = room_height - 100;
        var button_x2 = room_width/2 + 100;
        var button_y2 = room_height - 60;
        
        if (mouse_x >= button_x1 && mouse_x <= button_x2 && 
            mouse_y >= button_y1 && mouse_y <= button_y2) {
            
            // Start real-time match
            match_state = create_match_state(global.team1, global.team2);
            match_started = true;
            show_debug_message("Match started!");
        }
    }
}

// ===================================
// LIVE MATCH PHASE
// ===================================
else if (match_started && !match_simulated) {
    
    // Check for control buttons
    if (mouse_check_button_pressed(mb_left)) {
        
        // Pause/Play button
        var pause_x1 = 50;
        var pause_y1 = room_height - 50;
        var pause_x2 = 150;
        var pause_y2 = room_height - 20;
        
        if (point_in_rectangle(mouse_x, mouse_y, pause_x1, pause_y1, pause_x2, pause_y2)) {
            match_state.paused = !match_state.paused;
        }
        
        // Speed buttons
        var speed_y1 = room_height - 50;
        var speed_y2 = room_height - 20;
        
        if (point_in_rectangle(mouse_x, mouse_y, 170, speed_y1, 220, speed_y2)) {
            match_state.speed = 1.0;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 230, speed_y1, 280, speed_y2)) {
            match_state.speed = 2.0;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 290, speed_y1, 340, speed_y2)) {
            match_state.speed = 5.0;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 350, speed_y1, 450, speed_y2)) {
            match_state.speed = 20.0;
        }
    }
    
    // Update match if not paused
    if (match_state != noone && !match_state.paused && match_state.active) {
        
        // Increment time based on speed (60 fps)
        match_state.real_time_counter += (1.0 / 60.0) * match_state.speed;
        
        // Each real second (adjusted by speed) = 1 game minute
        if (match_state.real_time_counter >= 1.0) {
            match_state.game_time += 1;
            match_state.real_time_counter -= 1.0;
            
            // Check if it's time for a tick (every 2.5 game minutes)
            if (match_state.game_time - match_state.last_tick_time >= match_state.tick_interval) {
                process_match_tick(match_state);
                match_state.last_tick_time = match_state.game_time;
            }
        }
        
        // Check if match ended
        if (!match_state.active) {
            match_simulated = true;
            winner = match_state.winner;
            show_debug_message("Match ended! Winner: " + winner.name);
        }
        
        // Safety: 60 minute limit
        if (match_state.game_time >= 60) {
            match_state.active = false;
            match_simulated = true;
            if (match_state.team1.nexus_hp > match_state.team2.nexus_hp) {
                winner = match_state.team1;
            } else {
                winner = match_state.team2;
            }
        }
    }
}

// ===================================
// RESULTS PHASE (After match complete)
// ===================================
else if (match_simulated) {
    
    // Check for "new match" button
    if (mouse_check_button_pressed(mb_left)) {
        
        var button_x1 = room_width/2 - 100;
        var button_y1 = room_height - 100;
        var button_x2 = room_width/2 + 100;
        var button_y2 = room_height - 60;
        
        if (mouse_x >= button_x1 && mouse_x <= button_x2 && 
            mouse_y >= button_y1 && mouse_y <= button_y2) {
            
            // Reset everything for new draft
            player_draft = create_player_draft_state();
            champion_draft = noone;
            match_simulated = false;
            match_started = false;
            teams_created = false;
            player_draft_complete = false;
            winner = noone;
            ai_pick_timer = 0;
            match_state = noone;
			
			champion_draft = noone;
			
			// Reset player stats in the pools
			var role_names = ["top", "jungle", "mid", "adc", "support"];
			for (var r = 0; r < array_length(role_names); r++) {
			    var role = role_names[r];
			    var players_in_role = global.player_pool[$ role];
			    for (var i = 0; i < array_length(players_in_role); i++) {
			        players_in_role[i].kills = 0;
			        players_in_role[i].deaths = 0;
			        players_in_role[i].assists = 0;
			        players_in_role[i].champion = noone;
			    }
			}
            
            show_debug_message("Starting new player draft!");
        }
    }
}