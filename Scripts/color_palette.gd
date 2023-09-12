extends ColorRect

# Bright/Dark
var color_arr = [["ffffff","000000"], 
			["ffeaf9","004c3d"], 
			["8bc8fe", "051b2c"], 
			["cfab4a", "292b30"],
			["83b07e", "000000"],
			["b0b0b0", "2e253d"]]

var color_index: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		if color_index < color_arr.size():
			change_palette(color_arr[color_index][0], color_arr[color_index][1])
			color_index += 1
		else: 
			change_palette(color_arr[0][0], color_arr[0][1])
			color_index = 1

func change_palette(color1, color2):
	self.material.set_shader_parameter("bright_color", Color.html(color1)) 
	self.material.set_shader_parameter("dark_color", Color.html(color2)) 
