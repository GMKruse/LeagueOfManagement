if (champion != noone) {
    // Draw champion sprite or placeholder
    draw_self();
    
    // Draw champion name
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
	var text = champion.name;
	var text_x = x + sprite_width / 2 - string_width(text) / 2;
	var text_y = y + sprite_height + 5

	draw_text(text_x, text_y, text);

    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

#region Hovering
var _is_hovering = false;
if (instance_exists(obj_champion_draft_controller)) {
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
if (_is_hovering && instance_exists(obj_champion_draft_controller)) {
    draw_set_alpha(0.5);
    draw_set_colour(c_blue);
    draw_rectangle(x - sprite_get_width(sprite_index) / 2 - 5, 
                    y - sprite_get_height(sprite_index) / 2 - 5,
                    x + sprite_get_width(sprite_index) / 2 + 5,
                    y + sprite_get_height(sprite_index) / 2 + 5,
                    false);
    draw_set_alpha(0.5);
    draw_set_colour(c_white);
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
    
    var _text_x = _tooltip_x + 2.5;
    var _text_y = _tooltip_y + 2.5;
    var _line_height = 18;
    
	draw_text(_text_x, _text_y, string(champion.name))
    draw_text(_text_x, _text_y + _line_height, "Mechanics: " + string(champion.mechanics_scaling));
    draw_text(_text_x, _text_y + _line_height * 2, "Teamwork: " + string(champion.teamwork_scaling));
    draw_text(_text_x, _text_y + _line_height * 3, "Knowledge: " + string(champion.knowledge_scaling));
}


#endregion
