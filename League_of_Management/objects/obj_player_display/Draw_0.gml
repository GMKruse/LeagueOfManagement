// --- 1. Draw the Player Sprite ---
// MUST be called, otherwise the default sprite_index will not be drawn.
draw_self(); 

sprite_index = player.sprite_index

// --- 2. Set up Text Drawing ---
// Choose a font (assuming you have a default or custom font resource)
draw_set_font(-1); 

// Set the color for the text (e.g., White)
draw_set_colour(c_white);

// Center the text vertically relative to the y position
draw_set_valign(fa_middle); 

// Align the text to the left so it starts immediately after the offset
draw_set_halign(fa_left); 


if (player != undefined && player.team != undefined){
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
	}
}




// --- 4. Reset Drawing Settings ---
// Always a good practice to reset settings after custom drawing
draw_set_font(-1);
draw_set_colour(c_white);
draw_set_valign(fa_top);
draw_set_halign(fa_left);