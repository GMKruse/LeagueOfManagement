draw_self();

// --- Calculations based on Center-Left Origin ---

// Get half the sprite's height, as the instance's y is the center point
var _half_height = sprite_get_height(sprite_index) / 2;

// 2. Setup text drawing parameters
var _text_x = x + padding; 

// The text is already vertically centered at y because the origin is Center-Left
// and we are using fa_middle alignment.
var _text_y = y; 
var _text_valign = fa_middle;

// Set text properties
draw_set_halign(fa_left);
draw_set_valign(_text_valign);
draw_set_colour(c_white); // Use white for the text color
global.font_ui_medium = font_add("Arial", 20, false, false, 32, 127);
draw_set_font(global.font_ui_medium); // Use default font
 

// 3. Draw the input text
draw_text(_text_x, _text_y, input_text);


// 4. Draw the blinking cursor if focused
if (is_focused) {
    // Check for blinking (current_time mod 600 < 300 makes it visible half the time)
    if (current_time mod 600 < 300) {
        
        // Calculate the position of the cursor (at the end of the drawn text)
        var _text_width = string_width(input_text);
        var _cursor_x = _text_x + _text_width + 2; // Position after the text + a small gap
        
        // Define the cursor line boundaries, measured relative to the center 'y':
        var _cursor_y_top = y - _half_height + padding;
        var _cursor_y_bottom = y + _half_height - padding;
        
        // Draw the cursor
        draw_set_colour(c_white); // Set color to lime for the cursor
        draw_line_width(_cursor_x, _cursor_y_top, _cursor_x, _cursor_y_bottom, 2);
    }
}

// 5. CRUCIAL RESET: Reset drawing settings back to default.
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
