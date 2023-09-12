extends Node2D

var BulletScene = preload("res://Scenes/enemy_bullet.tscn")

@export var speed: float = 60
@export var bullet_speed: float = 100

@onready var top_gun = $TopGun/Muzzle
@onready var bot_gun = $BotGun/Muzzle
@onready var wall_detector_up = $WallDetectorUp
@onready var wall_detector_down = $WallDetectorDown
@onready var animation_player = $AnimationPlayer
@onready var health = $HealthComponent


var ShootTimer: float = 0.5
var can_shoot: bool = true
var dir = Vector2.UP
var shoot_thres = 10
var shoot_counter = 0
var time = 0
var player 

var current_state
enum State {
	PHASE1,
	PHASE2
}


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_state = State.PHASE1
	global_position = Vector2(270, 90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match current_state:
		State.PHASE1:
			move(delta)
			shoot(ShootTimer, shoot_thres)
		State.PHASE2:
			animation_player.play("PHASE2_RESET")
			follow_player(delta)
			bullet_speed = 200
			shoot(ShootTimer/2, INF)


func move(delta):
	global_position += dir * speed * delta 
	if wall_detector_up.is_colliding():
		$ChangerDir.start()
		dir = Vector2.DOWN
	if wall_detector_down.is_colliding():
		$ChangerDir.start()
		dir = Vector2.UP

func follow_player(delta):
	time += 0.05
	time = 0 if time > 2 * PI else time
	global_position.x += cos(time)
	global_position.y += cos(2 * time) * 1.3
	
	player = Global.player
	if player != null:
		global_position.y = lerp(global_position.y, player.global_position.y, delta)

func shoot(shoot_interval, threshold):
	if shoot_counter >= threshold:
		await get_tree().create_timer(2).timeout
		shoot_counter = 0
	elif can_shoot:
		shoot_counter +=1
		
		spawn_bullet(top_gun.global_position)
		spawn_bullet(bot_gun.global_position)
		
		can_shoot = false
		await get_tree().create_timer(shoot_interval).timeout
		can_shoot = true

func spawn_bullet(pos):
	var bullet = GlobalFunction.instantiate_scene(BulletScene, pos, get_tree().current_scene)
	bullet.vel_mode()
	bullet.speed = bullet_speed
	

func _on_health_component_taking_damage():
	if health.current_hp <= health.max_hp/2 and animation_player.current_animation != "PHASE2_RESET":
		animation_player.play("change_gun_pos")
		await animation_player.animation_finished
		current_state = State.PHASE2


func _on_changer_dir_timeout():
	var random_dir = [Vector2.UP, Vector2.DOWN].pick_random()
	dir *= random_dir


