extends Node2D

@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if active:
			if shoot_timer and shoot_timer.is_stopped(): 
				shoot_timer.start(shoot_interval)
		else:
			if shoot_timer: shoot_timer.stop()
@export var shoot_interval: float = 0.5:
	get:
		return shoot_interval
	set(value):
		shoot_interval = value
		if shoot_timer: shoot_timer.wait_time = shoot_interval
		

@export var number_of_bullet: int = 4

@export_group("Bullet Stats")
@export var bullet_speed: float = 50
@export_subgroup("Accel")
@export var use_accel: bool = false

@export_group("Rotation")
@export var rotate: bool = false:
	get:
		return rotate
	set(value):
		rotate = value
		set_process(value)

@export_range(-180, 180) var rotate_deg: float = 0

@onready var spawn_point = $SpawnPoint
@onready var shoot_timer = $ShootTimer

var BulletScene = preload("res://Scenes/BulletStuff/enemy_bullet.tscn")

var can_shoot: bool = true
var deg: float = 0

func _ready():
	active = active
	rotate = rotate
	

func _process(delta):
	deg = fmod(deg + rotate_deg * delta, 360)

func shoot():
	var step = 2 * PI / number_of_bullet
	for i in number_of_bullet:
		var bullet = GlobalFunction.instantiate_scene(BulletScene, global_position, get_tree().current_scene) as Enemy_Bullet
		var dir = Vector2.LEFT.rotated(step * i).rotated(deg_to_rad(deg))
		bullet.velocity = dir
		bullet.speed = bullet_speed
