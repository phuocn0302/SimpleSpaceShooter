class_name Enemy
extends Area2D

var ExplosionPath = preload("res://Scenes/explosion.tscn")

var contact_damage: int = 1

@export var hp:int = 5
@export var speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$AnimationPlayer.play("vibrate")
	global_position.x -= speed * delta
	
	if (hp <= 0):
		die()

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()

func take_damage(damage):
	hp -= damage

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
