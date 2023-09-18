extends Node2D

@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if value == true:
			set_process(true)
		else:
			set_process(false)


@export var number_of_bullet: int = 4

@export_group("Bullet Stats")
@export var fire_rate: float = 0.5
@export var bullet_speed: float = 50
@export_subgroup("Accel")
@export var use_accel: bool = false

@export_group("Rotation")
@export var rotate: bool = false
@export_range(-180, 180) var rotate_deg: float = 0

@onready var spawn_point = $SpawnPoint

var BulletScene = preload("res://Scenes/enemy_bullet.tscn")

var can_shoot: bool = true
var deg: float = 0

func _ready():
	active = active

func _process(delta):
	if rotate == true: deg = fmod(deg + rotate_deg * delta, 360)
	shoot()

func shoot():
	if can_shoot:
		spawn_bullet()
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func spawn_bullet():
	var step = 2 * PI / number_of_bullet
	for i in number_of_bullet:
		var bullet = GlobalFunction.instantiate_scene(BulletScene, global_position, get_tree().current_scene) as Enemy_Bullet
		var dir = Vector2.LEFT.rotated(step * i).rotated(deg_to_rad(deg))
		bullet.velocity = dir
		bullet.speed = bullet_speed
