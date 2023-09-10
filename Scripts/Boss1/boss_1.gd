extends Node2D

var BulletScene = preload("res://Scenes/enemy_bullet.tscn")

@export var speed: float = 60

@onready var top_gun = $TopGun/Muzzle
@onready var bot_gun = $BotGun/Muzzle
@onready var wall_detector_up = $WallDetectorUp
@onready var wall_detector_down = $WallDetectorDown
@onready var animation_player = $AnimationPlayer

var ShootTimer: float = 0.5
var can_shoot: bool = true
var dir = Vector2.UP
var shoot_thres = INF
var shoot_counter = 0
var time = 0

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	move(delta)
	follow_player(delta)
	shoot()
	

func move(delta):
	global_position += dir * speed * delta
	if wall_detector_up.is_colliding():
		dir = Vector2.DOWN
	if wall_detector_down.is_colliding():
		dir = Vector2.UP

func follow_player(delta):
	player = GlobalFunction.check_player()
	if player != null:
		global_position.y = lerp(global_position.y, player.global_position.y, delta)

func shoot():
	if shoot_counter >= shoot_thres:
		await get_tree().create_timer(2).timeout
		shoot_counter = 0
	elif can_shoot:
		shoot_counter +=1
		
		spawn_bullet(top_gun.global_position)
		spawn_bullet(bot_gun.global_position)
		
		can_shoot = false
		await get_tree().create_timer(ShootTimer).timeout
		can_shoot = true

func spawn_bullet(pos):
	var bullet = GlobalFunction.instantiate_scene(BulletScene, pos, get_tree().current_scene)
	bullet.vel_mode()
	

