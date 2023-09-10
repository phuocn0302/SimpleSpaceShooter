extends Area2D

var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")

@export var max_hp: float = 5
@export var speed: float = 100

@onready var player = get_tree().current_scene.get_node("Player")

var current_hp: float
var contact_damage: float = 1
var is_rotate: bool = true
var is_chasing: bool = false

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$AnimationPlayer.play("vibrate")
	global_position.x -= speed * delta
	global_position.y += sin(time * 5)

func silly_movement(delta):
	if not is_chasing:
		global_position.x -= speed * delta
		global_position += ($Node2D/Marker2D.global_position - self.global_position).normalized()
		if is_rotate == true:
			$Node2D.rotate(randf_range(-1.5,1.5))
			is_rotate = false
			await get_tree().create_timer(0.1).timeout
			is_rotate = true

func follow_player(delta):
	if get_tree().current_scene.has_node("Player"):
		global_position += global_position.direction_to(player.global_position) * speed * delta
		is_chasing = true
		global_position += global_position.direction_to(player.global_position) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
