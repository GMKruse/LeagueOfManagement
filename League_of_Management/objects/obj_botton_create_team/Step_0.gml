// Step Event

var _mouse_over = point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom);
var _target_modifier;
var _text_font

if (_mouse_over) {
    // Target the shrinking modifier
    _target_modifier = hover_modifier;
} else {
    // Target the normal modifier
    _target_modifier = normal_modifier;
}

// Smoothly move the current_modifier towards the target
current_modifier = lerp(current_modifier, _target_modifier, scale_speed);
