extends Area2D

@export var speed: float = 50
@export var damage: int = 1

var can_chase: bool = false

@onready var player = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if get_tree().current_scene.has_node("Player") and can_chase:
#		global_position += global_position.direction_to(player.global_position) * speed * delta
#	else:
	global_position += -transform.y * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func chase():
	can_chase = true

func _on_body_entered(body):
	if body is Player:
		body.take_damage(1)
		queue_free()


func _on_player_detector_body_entered(body):
	if body is Player:
		chase()
