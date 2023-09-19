extends Node2D

var MissileScene = preload("res://Scenes/BulletStuff/homing_missile.tscn")

var can_shoot: bool = true

var function = GlobalFunction as Global_Function

func _ready():
	randomize()

func _process(_delta):
	shoot()

func shoot():
	if can_shoot:
		spawn()
		can_shoot = false
		await get_tree().create_timer(1).timeout
		can_shoot = true

func spawn():
	var missile = function.instantiate_scene(MissileScene, global_position, get_tree().current_scene) as Enemy_Missile
	missile.launch_velocity = Vector2.RIGHT.rotated(deg_to_rad(randi_range(-45,45)))
