
var _mouse_over = point_in_rectangle(
    mouse_x, 
    mouse_y, 
    bbox_left, 
    bbox_top, 
    bbox_right, 
    bbox_bottom
);

if (_mouse_over) {
    var _entered_team_name = input_instance_id.input_text;
    
    // 3. Use the retrieved text
    if (string_length(_entered_team_name) > 0) {
        // Example: Save the team name to a global variable
        global.team_name = _entered_team_name;
        show_debug_message("Team name set: " + global.team_name);
        
		room_goto(next_room)
    } else {
        // Handle case where no text was entered
        show_debug_message("Please enter a team name before continuing.");
    }
}