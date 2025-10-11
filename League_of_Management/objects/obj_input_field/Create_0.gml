input_text = "";         
max_length = 15;           
is_focused = true;        

// Define the size and position for drawing the background box
x1 = x;
y1 = y;
// We now dynamically get the bounding box size from the assigned sprite!
x2 = x + sprite_get_width(sprite_index);
y2 = y + sprite_get_height(sprite_index);

// Visual properties (These are used for the text/cursor, not the sprite itself)
box_color = c_gray; // Not used now, but kept for reference
focus_color = c_lime;
text_color = c_black;
padding = 70;