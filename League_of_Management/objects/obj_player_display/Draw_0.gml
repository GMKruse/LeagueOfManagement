// --- 1. Draw the Player Sprite ---

// Check if player instance still exists
if (!instance_exists(player)) {
	return; // Exit early if player doesn't exist
}

// Set sprite_index from player FIRST before any calculations
sprite_index = player.sprite_index

// Check if sprite_index is valid
if (sprite_index == -1 || sprite_index == noone) {
	return; // Exit if no valid sprite
}

// Check if mouse is hovering over sprite and if we're in draft mode
var _is_hovering = false;
if (instance_exists(obj_draft_players_controller)) {
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
    var _left = x - sprite_get_width(sprite_index) / 2;
    var _right = x + sprite_get_width(sprite_index) / 2;
    var _top = y - sprite_get_height(sprite_index) / 2;
    var _bottom = y + sprite_get_height(sprite_index) / 2;
    
    if (_mouse_x >= _left && _mouse_x <= _right && _mouse_y >= _top && _mouse_y <= _bottom) {
        _is_hovering = true;
    }
}

// Draw highlight if hovering and it's player's turn
if (_is_hovering && instance_exists(obj_draft_players_controller)) {
    var draft = global.player_draft;
    if (draft.active && get_current_team_player_draft(draft) == 1) {
        // Draw yellow highlight around the sprite
        draw_set_alpha(0.5);
        draw_set_colour(c_yellow);
        draw_rectangle(x - sprite_get_width(sprite_index) / 2 - 5, 
                      y - sprite_get_height(sprite_index) / 2 - 5,
                      x + sprite_get_width(sprite_index) / 2 + 5,
                      y + sprite_get_height(sprite_index) / 2 + 5,
                      false);
        draw_set_alpha(1);
        draw_set_colour(c_white);
    }
}

// MUST be called, otherwise the default sprite_index will not be drawn.
draw_self();

// --- 2. Set up Text Drawing ---
// Choose a font (assuming you have a default or custom font resource)
draw_set_font(-1); 

// Set the color for the text (e.g., White)
draw_set_colour(c_white);

// Center the text vertically relative to the y position
draw_set_valign(fa_middle); 

// Align the text to the left so it starts immediately after the offset
draw_set_halign(fa_left); 

if (player != undefined && player.team != undefined && player.team != -4){
	if(player.team.side != -4){
		var _name_x = -100;
		var _champion_x = -100;

		if (player.team.side == "Blue") {
		    _name_x = x + sprite_get_width(sprite_index) / 2 + 10;
		    _champion_x = x + sprite_get_width(sprite_index) / 2 + 10;
		} else if (player.team.side == "Red") {
		    _name_x = x - sprite_get_width(sprite_index) / 2 - 10;
		    _champion_x = x - sprite_get_width(sprite_index) / 2 - 10;    
		}

		var _name_y = y - 10;
		var _champion_y = y + 10;

		// Adjust the text position so the end of the string aligns with _name_x
		var _name_width = string_width(player.name);


		if (player.team.side == "Blue") {
		    draw_text(_name_x, _name_y, player.name); // Text starts at _name_x
		} else if (player.team.side == "Red") {
		    draw_text(_name_x - _name_width, _name_y, player.name); // Adjust to align the end of the text
		}
		
		if(player.champion != noone){
			draw_text(_champion_x, _champion_y, player.team.name)
		}
	} else {
		show_debug_message("Hmmm idk")
	}
}




// --- 4. Hover Tooltip ---
// Check if mouse is hovering over this player sprite
var _mouse_x = mouse_x;
var _mouse_y = mouse_y;

// Get the sprite's bounding box
var _left = x - sprite_get_width(sprite_index) / 2;
var _right = x + sprite_get_width(sprite_index) / 2;
var _top = y - sprite_get_height(sprite_index) / 2;
var _bottom = y + sprite_get_height(sprite_index) / 2;

// Check if mouse is within the sprite bounds
if (_mouse_x >= _left && _mouse_x <= _right && _mouse_y >= _top && _mouse_y <= _bottom) {
    // Draw tooltip background
    var _tooltip_width = 180;
    var _tooltip_height = 80;
    var _tooltip_x = _mouse_x + 15;
    var _tooltip_y = _mouse_y + 15;
    
    // Make sure tooltip stays on screen
    if (_tooltip_x + _tooltip_width > room_width) {
        _tooltip_x = _mouse_x - _tooltip_width - 15;
    }
    if (_tooltip_y + _tooltip_height > room_height) {
        _tooltip_y = _mouse_y - _tooltip_height - 15;
    }
    
    // Draw background box
    draw_set_alpha(0.9);
    draw_set_colour(c_black);
    draw_rectangle(_tooltip_x, _tooltip_y, _tooltip_x + _tooltip_width, _tooltip_y + _tooltip_height, false);
    
    // Draw border
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_rectangle(_tooltip_x, _tooltip_y, _tooltip_x + _tooltip_width, _tooltip_y + _tooltip_height, true);
    
    // Draw player stats text
    draw_set_font(-1);
    draw_set_colour(c_white);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    
    var _text_x = _tooltip_x + 10;
    var _text_y = _tooltip_y + 10;
    var _line_height = 18;
    
    draw_text(_text_x, _text_y, "Mechanics: " + string(player.mechanics));
    draw_text(_text_x, _text_y + _line_height, "Teamwork: " + string(player.teamwork));
    draw_text(_text_x, _text_y + _line_height * 2, "Knowledge: " + string(player.knowledge));
}

// --- 5. Reset Drawing Settings ---
// Always a good practice to reset settings after custom drawing
draw_set_alpha(1);
draw_set_font(-1);
draw_set_colour(c_white);
draw_set_valign(fa_top);
draw_set_halign(fa_left);