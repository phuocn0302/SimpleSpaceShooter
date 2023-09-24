extends Node
class_name Global_Function

var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var FlashShader = preload("res://Shaders/flash.gdshader")

func freeze_frame(timescale, duration):
	Engine.time_scale = timescale
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0

func instantiate_scene(node_path, pos, add_to):
	var node = node_path.instantiate()
	node.global_position = pos
	add_to.call_deferred("add_child", node)
	return node

func check_player():
	return get_tree().current_scene.get_node_or_null("Player")

func screen_shake(shake_time, intensity: int = 1):
	var cam = Global.camera
	cam.shake(shake_time, intensity)

func explode_effect(position):
	instantiate_scene(ExplosionPath, position, get_tree().current_scene)

func flash(node):
	node.material = ShaderMaterial.new()
	node.material.shader = FlashShader
	
	node.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.05).timeout
	
	if node != null:
		node.material.set_shader_parameter("active", false)
		node.material.shader = null
		

func wait_for(caller: Node2D, time):
	await caller.get_tree().create_timer(time).timeout
