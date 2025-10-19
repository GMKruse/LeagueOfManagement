var draft = global.champion_draft;

// Draw header with phase information
draw_set_font(-1);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _header_y = 50;

if (is_ban_phase_active(draft)) {
    // BAN PHASE UI
    var current_team = get_current_team_banning(draft);
    var ban_number = draft.current_ban + 1;
    
    draw_text(room_width / 2, _header_y, "BAN PHASE");
    draw_text(room_width / 2, _header_y + 30, "Ban " + string(ban_number) + " of 6");
    
    var turn_text = "";
    var turn_color = c_white;
    
    if (current_team == 1) {
        turn_text = global.player_team.name + "'s Ban";
        turn_color = c_aqua;
    } else {
        turn_text = global.ai_team.name + "'s Ban";
        turn_color = c_red;
    }
    
    draw_set_colour(turn_color);
    draw_text(room_width / 2, _header_y + 60, turn_text);
    draw_set_colour(c_white);
    
    // Show banned champions
    draw_set_halign(fa_left);
    draw_text(100, _header_y, "Team 1 Bans:");
    for (var i = 0; i < array_length(draft.team1_bans); i++) {
        draw_text(120, _header_y + 130 + (i * 20), "- " + draft.team1_bans[i].name);
    }
    
    draw_set_halign(fa_right);
    draw_text(room_width - 100, _header_y, "Team 2 Bans:");
    for (var i = 0; i < array_length(draft.team2_bans); i++) {
        draw_text(room_width - 120, _header_y + 130 + (i * 20), "- " + draft.team2_bans[i].name);
    }
    
} else if (is_pick_phase_active(draft)) {
    // PICK PHASE UI
    var current_team = get_current_team_picking(draft);
    var current_role = get_current_role_champion_draft(draft);
    var pick_number = draft.current_pick + 1;
    
    draw_set_halign(fa_center);
    draw_text(room_width / 2, _header_y, "CHAMPION DRAFT");
    draw_text(room_width / 2, _header_y + 30, "Pick " + string(pick_number) + " of 10 - Role: " + current_role);
    
    var turn_text = "";
    var turn_color = c_white;
    
    if (current_team == 1) {
        turn_text = global.player_team.name + "'s Pick";
        turn_color = c_aqua;
    } else {
        turn_text = global.ai_team.name + "'s Pick";
        turn_color = c_red;
    }
    
    draw_set_colour(turn_color);
    draw_text(room_width / 2, _header_y + 60, turn_text);
    draw_set_colour(c_white);
    
} else {
    // DRAFT COMPLETE
    draw_text(room_width / 2, _header_y, "Champion Draft Complete!");
    draw_text(room_width / 2, _header_y + 30, "Press SPACE to start the game");
}

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Note: Champion displays are created in Alarm[2], not in Draw event
// The Draw event only renders the UI, not the champion cards themselves
