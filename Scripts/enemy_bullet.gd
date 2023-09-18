extends Node2D
class_name Enemy_Bullet

@export var speed: float = 50
@export var velocity = Vector2.LEFT

@export_group("Accel")
@export var use_accel: bool = false
@export var final_speed: float = 150
@export var init_speed: float = 0
@export var speed_change: float = 10
var accel_speed: float

func _ready():
	accel_speed = init_speed

func _process(delta):
	if use_accel:
		move_with_accel(delta)
	else:
		move(delta)

func move(delta):
	global_position += velocity.normalized() * speed * delta

func move_with_accel(delta):
	accel_speed = move_toward(accel_speed, final_speed, speed_change * delta * 60)
	global_position += velocity.normalized() * accel_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

