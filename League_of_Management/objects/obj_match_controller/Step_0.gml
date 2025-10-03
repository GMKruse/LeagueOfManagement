// Step Event for obj_match_controller

// ===================================
// DRAFT PHASE
// ===================================
if (draft.active) {
    
    var current_team = get_current_team(draft);
    
    // Team 1 (Player) picks
    if (current_team == 1) {
        
        // Check for mouse click
        if (mouse_check_button_pressed(mb_left)) {
            
            var available = get_available_champions(draft);
            var y_pos = 310;
            
            for (var i = 0; i < array_length(available); i++) {
                var button_x = room_width/2 - 100;
                var button_y = y_pos;
                var button_width = 200;
                var button_height = 30;
                
                // Check if clicked on this champion
                if (point_in_rectangle(mouse_x, mouse_y, 
                    button_x, button_y, button_x + button_width, button_y + button_height)) {
                    
                    // Make the pick
                    make_pick(draft, available[i]);
                    show_debug_message("Blue Team picked: " + available[i].name);
                    break;
                }
                
                y_pos += 35;
            }
        }
    }
    // Team 2 (AI) picks
    else {
        
        // Add a small delay so it's not instant
        if (!variable_instance_exists(id, "ai_pick_timer")) {
            ai_pick_timer = 0;
        }
        
        ai_pick_timer++;
        
        // Pick after 60 frames (1 second at 60fps)
        if (ai_pick_timer >= 60) {
            var ai_choice = ai_pick_champion(draft);
            
            if (ai_choice != noone) {
                make_pick(draft, ai_choice);
                show_debug_message("Red Team picked: " + ai_choice.name);
            }
            
            ai_pick_timer = 0;
        }
    }
}

// ===================================
// MATCH PHASE (After draft complete)
// ===================================
else if (!draft.active && !match_simulated) {

	show_debug_message("teams_created: " + string(teams_created));

    // Create teams from draft (only once)
    if (!teams_created) {
		show_debug_message("I was here!")
        create_teams_from_draft(draft);
        teams_created = true;
        show_debug_message("Draft complete! Teams created.");
    }
    
    // Check for simulate button click
    if (mouse_check_button_pressed(mb_left)) {
        
        show_debug_message("Mouse clicked at: " + string(mouse_x) + ", " + string(mouse_y));
        
        // Check if clicking on the button
        var button_x1 = room_width/2 - 100;
        var button_y1 = room_height - 100;
        var button_x2 = room_width/2 + 100;
        var button_y2 = room_height - 60;
        
        if (mouse_x >= button_x1 && mouse_x <= button_x2 && 
            mouse_y >= button_y1 && mouse_y <= button_y2) {
            
            show_debug_message("Button clicked!");
            
            // Simulate the match
            winner = simulate_match(global.team1, global.team2);
            match_simulated = true;
            
            show_debug_message("=================================");
            show_debug_message("MATCH RESULT: " + winner.name + " WINS!");
            show_debug_message("=================================");
        }
    }
	
}

// ===================================
// RESULTS PHASE (After match simulated)
// ===================================
else if (match_simulated) {
    
    // Check for "simulate again" button
    if (mouse_check_button_pressed(mb_left)) {
        
        var button_x1 = room_width/2 - 100;
        var button_y1 = room_height - 100;
        var button_x2 = room_width/2 + 100;
        var button_y2 = room_height - 60;
        
        if (mouse_x >= button_x1 && mouse_x <= button_x2 && 
            mouse_y >= button_y1 && mouse_y <= button_y2) {
            
            // Reset for new draft
            draft = create_draft_state();
            match_simulated = false;
            teams_created = false;
            winner = noone;
            ai_pick_timer = 0;
            
            show_debug_message("Starting new draft!");
        }
    }
}