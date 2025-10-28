// --- Hover detection and background highlight ---
var _is_hovering = false;
// Use safe sprite dimensions (handle missing sprite)
var _sprite_w = (sprite_index != -1) ? sprite_get_width(sprite_index) : 0;
var _sprite_h = (sprite_index != -1) ? sprite_get_height(sprite_index) : 0;
if (instance_exists(obj_champion_draft_controller)) {
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
    var _left = x - _sprite_w / 2;
    var _right = x + _sprite_w / 2;
    var _top = y - _sprite_h / 2;
    var _bottom = y + _sprite_h / 2;
    
    if (_mouse_x >= _left && _mouse_x <= _right && _mouse_y >= _top && _mouse_y <= _bottom) {
        _is_hovering = true;
    }
}

// Draw highlight behind the sprite when hovering (so it acts like a border)
if (_is_hovering && instance_exists(obj_champion_draft_controller)) {
    draw_set_alpha(0.5);
    draw_set_colour(c_blue);
    draw_rectangle(x - _sprite_w / 2 - 5, 
                   y - _sprite_h / 2 - 5,
                   x + _sprite_w / 2 + 5,
                   y + _sprite_h / 2 + 5,
                   false);
    // restore colour/alpha partially; full reset at end
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// Now draw the champion sprite (on top of the highlight)
if (sprite_index != -1) {
    draw_self();
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

// Restore common draw state to avoid affecting other draw calls
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
