extends Node2D
class_name HealthComponent

@export var max_hp: float = 5

var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var current_hp: float

signal taking_damage
signal zero_hp

func _ready():
	current_hp = max_hp

func take_damage(damage):
	taking_damage.emit()
	current_hp -= damage
	if current_hp <= 0:
		zero_hp.emit()
