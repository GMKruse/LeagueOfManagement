
// Draw draft information header
draw_set_font(-1);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _header_y = 50;

// Show draft progress
if (global.player_draft.active) {
    var current_team = get_current_team_player_draft(global.player_draft);
    var current_role = get_current_role_player_draft(global.player_draft);
    var pick_number = global.player_draft.current_pick + 1;
    
    // Draw pick number
    draw_text(room_width / 2, _header_y, "Pick " + string(pick_number) + " of 10");
    
    // Draw current role
    draw_text(room_width / 2, _header_y + 30, "Role: " + current_role);
    
    // Draw whose turn it is
    var turn_text = "";
    var turn_color = c_white;
    
    if (current_team == 1) {
        turn_text = global.player_team.name + "'s Turn";
        turn_color = c_aqua; // Blue team color
    } else {
        turn_text = global.ai_team.name + "'s Turn";
        turn_color = c_red; // Red team color
    }
    
    draw_set_colour(turn_color);
    draw_text(room_width / 2, _header_y + 60, turn_text);
    draw_set_colour(c_white);
} else {
    draw_text(room_width / 2, _header_y, "Draft Complete!");
    draw_text(room_width / 2, _header_y + 30, "Press SPACE to continue");
}

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw available players
if(available_players != []){
	var _columns = 5; // Number of columns per row
	var _cell_width = 100; // Width of each cell
	var _cell_height = 100; // Height of each cell
	var _start_x = 500; // Starting x position
	var _start_y = 200; // Starting y position

	for (var i = 0; i < array_length(available_players); i++) {
	    var _player = available_players[i];

	    // Calculate column and row
	    var _col = i mod _columns;
	    var _row = i div _columns;

	    // Calculate position
	    var _x = _start_x + _col * _cell_width;
	    var _y = _start_y + _row * _cell_height;

	    // Draw the player (name or sprite)
		create_player_display(_player, _x, _y)
	}
}