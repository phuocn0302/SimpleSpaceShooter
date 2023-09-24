extends Node2D
class_name Laser

@export var velocity: Vector2 = Vector2(-1,0)
@export var distance: float = 300
@export var laser_decay: float = 1

func _ready():
	shoot()

func shoot():
	appear()
	await get_tree().create_timer(laser_decay).timeout
	disappear()

func appear():
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "scale", velocity * distance + Vector2(1,1), 0.1)

func disappear():
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "scale", Vector2.ZERO, 0.2)
	await tween.finished
	queue_free()

