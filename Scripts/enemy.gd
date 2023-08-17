extends Area2D

@onready var ExplosionPath = preload("res://Scenes/explosion.tscn")

var hp = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$AnimationPlayer.play("vibrate")
	global_position.x -= 100 * delta
	
	if (hp <= 0):
		die()

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()

func _on_area_entered(area):
	hp -= 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
