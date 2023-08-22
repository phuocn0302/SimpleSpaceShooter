class_name Enemy
extends Area2D

var ExplosionPath = preload("res://Scenes/explosion.tscn")

var contact_damage: int = 1
var is_rotate : bool = true

@export var hp:int = 5
@export var speed: float = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$AnimationPlayer.play("vibrate")
	global_position.x -= speed * delta
	#goofy af movement
	global_position += ($Node2D/Marker2D.global_position - self.global_position).normalized()
	if is_rotate :
		$Node2D.rotate(randf_range(-1.5,1.5))
		is_rotate = false
		await get_tree().create_timer(0.1).timeout
		is_rotate = true
	
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
