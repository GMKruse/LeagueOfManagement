if (champion != noone) {
    // Draw champion sprite or placeholder
    draw_self();
    
    // Draw champion name
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(x + sprite_width/2, y + sprite_height + 5, champion.name);
    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
