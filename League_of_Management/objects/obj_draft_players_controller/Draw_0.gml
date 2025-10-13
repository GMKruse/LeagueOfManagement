
show_debug_message("I was here")

if(available_players != []){
	var _columns = 5; // Number of columns per row
	var _cell_width = 100; // Width of each cell
	var _cell_height = 100; // Height of each cell
	var _start_x = 50; // Starting x position
	var _start_y = 50; // Starting y position

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
	    //draw_text(_x, _y, available_players.);
		show_debug_message("I was here 2")
	}
}