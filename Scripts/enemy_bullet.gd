extends Area2D

@export var speed: float = 50
@export var damage: int = 1
@export var use_transform: bool = false
@export var use_vel: bool = false

@onready var player = get_tree().current_scene.get_node("Player") if get_tree().current_scene.has_node("Player") else null

var can_chase: bool = false
var velocity = Vector2.LEFT


func _process(delta):
	if use_transform:
		global_position += -transform.y * speed * delta
	if use_vel:
		global_position += velocity * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func vel_mode():
	use_vel = true

func transform_mode():
	use_transform = true

func chase():
	can_chase = true
