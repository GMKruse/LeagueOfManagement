
instance_create_depth(room_width*0.5, room_height*0.45, 0, obj_background)

var input_x_pos = room_width*0.5-250
var input_y_pos = room_height*0.55
team_name_input = instance_create_depth(input_x_pos, input_y_pos, -1, obj_input_field)

var botton_x_pos = room_width*0.5
var botton_y_pos = room_height*0.75
botton = instance_create_depth(botton_x_pos, botton_y_pos, -1, obj_botton)
with(botton){
	self.image_xscale = 0.2
	self.image_yscale = 0.2
	self.text = "Create Team"
}