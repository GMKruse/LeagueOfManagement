// --- 1. Draw the Player Sprite ---
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


// --- 3. Draw the Player's Name ---
// Calculate the position: 
// x + sprite_width/2 + 10 (moves it past the center of the sprite plus a 10-pixel buffer)
var _text_x = x + sprite_get_width(sprite_index) / 2 + 10;
var _text_y = y; // Keep the same vertical position

draw_text(_text_x, _text_y, name);

// --- 4. Reset Drawing Settings ---
// Always a good practice to reset settings after custom drawing
draw_set_font(-1);
draw_set_colour(c_white);
draw_set_valign(fa_top);
draw_set_halign(fa_left);