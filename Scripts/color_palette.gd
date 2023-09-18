extends ColorRect

# Bright/Dark
var color_arr = [["ffffff","000000"], 
			["e8e6e1","121216"], 
			["f0f6f0","222323"], 
			["f2fbeb","171219"], 
			["ebb5b5","100101"], 
			["c6baac","1e1c32"], 
			["ffeaf9","004c3d"], 
			["8bc8fe", "051b2c"], 
			["cfab4a", "292b30"],
			["83b07e", "000000"],
			["b0b0b0", "2e253d"]]

var color_index: int = 0:
	set(value):
		color_index = wrapi(value, 0, color_arr.size())
		change_palette(color_arr[color_index][0], color_arr[color_index][1])

func _ready():
	change_palette(color_arr[0][0], color_arr[0][1])

func _input(event):
	if event.is_action_pressed("ui_right"):
		color_index += 1
	elif  event.is_action_pressed("ui_left"):
		color_index += -1

func change_palette(color1, color2):
	self.material.set_shader_parameter("bright_color", Color.html(color1)) 
	self.material.set_shader_parameter("dark_color", Color.html(color2)) 
