extends Node2D
class_name HealthComponent

@export var max_hp: float

var function = GlobalFunction as Global_Function
var current_hp: float

signal taking_damage
signal zero_hp

func _ready():
	current_hp = max_hp

func take_damage(damage):
	if get_parent():
		function.flash(get_parent())
	taking_damage.emit()
	current_hp -= damage
	if current_hp <= 0:
		zero_hp.emit()
