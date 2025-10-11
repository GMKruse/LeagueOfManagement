// Draw Event

// Calculate the final scale for drawing
var _botton_scale = image_xscale * current_modifier;
var _text_xscale = current_modifier


draw_sprite_ext(
    sprite_index,   
    image_index,    
    x,              
    y,              
    _botton_scale,
    _botton_scale,
    image_angle,    
    image_blend,    
    image_alpha     
);

// Set the font and color defined in the Create Event
draw_set_font(text_font);
draw_set_colour(text_color);

// Center the text horizontally and vertically
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw the text exactly at the instance's center (x, y)
draw_text_transformed(
    x, y, 
    text, 
    _text_xscale,
    _text_xscale,
    0
);

// *ALWAYS* reset alignment after drawing text to avoid affecting other drawing
draw_set_halign(fa_left); 
draw_set_valign(fa_top);