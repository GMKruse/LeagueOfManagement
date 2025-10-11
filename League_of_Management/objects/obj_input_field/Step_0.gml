/// @description Handle Input and Focus Logic

// Handle Clicks/Focus Change
if (mouse_check_button_pressed(mb_left)) {
    // Check if the click was within the bounding box of the input field (defined in Create Event)
    if (point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2)) {
        is_focused = true;
        keyboard_string = input_text;
    } else {
        is_focused = false;
        input_text = keyboard_string;
        keyboard_string = "";
    }
}

// Handle Text Input
if (is_focused) {
    
    // Check for Ctrl + Backspace (Reset String)
    if (keyboard_check(vk_control) && keyboard_check_pressed(vk_backspace)) {
        input_text = "";
        keyboard_string = ""; // Reset GML's input buffer too
        
    } else {
        input_text = keyboard_string;

        if (string_length(input_text) > max_length) {
            input_text = string_copy(input_text, 1, max_length);
            keyboard_string = input_text; 
        }
    }
   
}
