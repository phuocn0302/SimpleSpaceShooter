extends Node2D

@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if active:
			if shoot_timer.is_stopped(): shoot_timer.start(shoot_interval)
		else:
			if shoot_timer: shoot_timer.stop()
		
@export var direction: Vector2 = Vector2.LEFT

@export var shoot_interval: float = 5:
	get:
		return shoot_interval
	set(value):
		shoot_interval = value
		if shoot_timer: shoot_timer.wait_time = shoot_interval
		
@onready var shoot_timer = $ShootTimer

var MissileScene = preload("res://Scenes/BulletStuff/homing_missile.tscn")

var can_shoot: bool = true

var function = GlobalFunction as Global_Function

func _ready():
	shoot_timer.wait_time = shoot_interval
	active = active
	randomize()

func shoot():
	var missile = function.instantiate_scene(MissileScene, global_position, get_tree().current_scene) as Enemy_Missile
	var launch_vel = direction.rotated(deg_to_rad(randi_range(-45,0)))
	missile.launch_velocity = launch_vel
	
	$LaunchEffect.rotation_degrees = rad_to_deg(launch_vel.angle())
	$LaunchEffect.set_deferred("emitting", true)
