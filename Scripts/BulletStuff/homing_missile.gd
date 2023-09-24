extends Node2D
class_name Enemy_Missile

@export var explode_on_impact: bool = true
@export var launch_speed: float = 200
@export var chase_speed: float = 50
@export var speed_change: float = 4
@export var rotate_speed_frame: float = 25

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var ExplosionScene = preload("res://Scenes/BulletStuff/damage_explosion.tscn")

var speed: float:
	get:
		return speed
	set(value):
		speed = clampf(value, chase_speed, launch_speed)

var launch_velocity: Vector2:
	get:
		return launch_velocity
	set(vector):
		launch_velocity = vector
		velocity = launch_velocity
		
var velocity: Vector2

var player = null
var function = GlobalFunction as Global_Function

func _ready():
	velocity = launch_velocity
	speed = launch_speed
	look_at(global_position + velocity)

func _process(delta):
	player = Global.player as Player
	
	animated_sprite_2d.play("default")
	animation_player.play("vibrate")
	
	look_at(global_position + velocity)
	move(delta)

func move(delta):
	var velocity_to_player = Vector2.LEFT
	if player != null:
		velocity_to_player = global_position.direction_to(player.global_position)

	var deg = velocity.angle_to(velocity_to_player)
	velocity = velocity.rotated((deg * delta * 60)/ rotate_speed_frame)
	
	global_position += velocity.normalized() * speed * delta
	speed -= speed_change

func explode():
		function.instantiate_scene(ExplosionScene, global_position, get_tree().current_scene)

func _on_life_time_timeout():
	explode()
	queue_free()
#
#
func _on_health_component_zero_hp():
	if not $LifeTime.time_left <= 0.5:
		explode()
		queue_free()
