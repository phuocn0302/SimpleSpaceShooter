extends Node2D

@export var number_of_bullet: int = 4
@export var fire_rate: float = 0.5
@export var rotatate: bool = true
@export var rotate_deg: float = 1

@onready var spawn_point = $SpawnPoint

var BulletScene = preload("res://Scenes/enemy_bullet.tscn")

var can_shoot: bool = true
var deg: float = 0

func _process(delta):
	if rotatate:
		deg = fmod(deg + rotate_deg, 360)
	shoot()
	pass


func shoot():
	if can_shoot:
		spawn_bullet()
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func spawn_bullet():
	var step = 2 * PI / number_of_bullet
	for i in number_of_bullet:
		var bullet = GlobalFunction.instantiate_scene(BulletScene, global_position, get_tree().current_scene)
		bullet.velocity = Vector2.LEFT.rotated(step * i).rotated(deg_to_rad(deg))

func _on_timer_timeout():
	number_of_bullet += 5
	rotatate = true 

