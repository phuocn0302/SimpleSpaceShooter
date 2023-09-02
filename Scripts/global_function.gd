extends Node

var camera = null

func freeze_frame(timescale, duration):
	Engine.time_scale = timescale
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0

func instantiate_scene(node_path, pos, add_to):
	var node = node_path.instantiate()
	node.global_position = pos
	add_to.add_child(node)
	return node
