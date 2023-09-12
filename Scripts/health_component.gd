extends Node2D
class_name HealthComponent

@export var max_hp: float = 5

var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var current_hp: float
signal taking_damage

func _ready():
	current_hp = max_hp

func take_damage(damage):
	taking_damage.emit()
	current_hp -= damage
	if current_hp <= 0:
		die()

func die():
	GlobalFunction.instantiate_scene(ExplosionPath, get_parent().global_position, get_tree().current_scene)
	get_parent().queue_free()
