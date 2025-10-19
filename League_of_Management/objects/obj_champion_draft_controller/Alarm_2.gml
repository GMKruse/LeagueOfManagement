// Alarm[2] - Refresh champion displays
// This is triggered after a ban/pick to show the next set of available champions

show_debug_message("Alarm[2] fired - Creating champion displays");
show_debug_message("Available champions count: " + string(array_length(available_champions)));

if (array_length(available_champions) > 0) {
    var _columns = 5;
    var _cell_width = 100;
    var _cell_height = 100;
    var _start_x = 500;
    var _start_y = 200;
    
    for (var i = 0; i < array_length(available_champions); i++) {
        var _champion = available_champions[i];
        
        // Validate that champion is not noone and has a name
        if (_champion != noone && instance_exists(_champion)) {
            var _col = i mod _columns;
            var _row = i div _columns;
            
            var _x = _start_x + _col * _cell_width;
            var _y = _start_y + _row * _cell_height;
            
            // Create champion display
            create_champion_display(_champion, _x, _y);
        } else {
            show_debug_message("WARNING: Invalid champion at index " + string(i));
        }
    }
}
