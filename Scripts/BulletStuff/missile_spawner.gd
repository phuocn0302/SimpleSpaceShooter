extends Node2D

@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if active:
			activated()
		else:
			deactivated()

@export var direction: Vector2 = Vector2.LEFT
@export var shoot_interval: float = 1

var MissileScene = preload("res://Scenes/BulletStuff/homing_missile.tscn")

var can_shoot: bool = true

var function = GlobalFunction as Global_Function

func _ready():
	active = active
	randomize()

func _process(_delta):
	shoot()

func activated():
	set_process(true)

func deactivated():
	set_process(false)

func shoot():
	if can_shoot:
		spawn()
		can_shoot = false
		await get_tree().create_timer(shoot_interval).timeout
		can_shoot = true

func spawn():
	var missile = function.instantiate_scene(MissileScene, global_position, get_tree().current_scene) as Enemy_Missile
	var launch_vel = direction.rotated(deg_to_rad(randi_range(-45,0)))
	missile.launch_velocity = launch_vel
	
	$LaunchEffect.rotation_degrees = rad_to_deg(launch_vel.angle())
	$LaunchEffect.set_deferred("emitting", true)
