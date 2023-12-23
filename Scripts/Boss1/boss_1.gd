extends Node2D

var BulletScene = preload("res://Scenes/BulletStuff/enemy_bullet.tscn")
var BulletSharpScene = preload("res://Scenes/BulletStuff/enemy_bullet_sharp.tscn")

@export var init_state: State = State.PHASE1
@export var speed: float = 60

@onready var top_gun = $TopGun/Muzzle
@onready var bot_gun = $BotGun/Muzzle
@onready var animation_player = $AnimationPlayer
@onready var health = $HealthComponent
@onready var bullet_spawner = $BulletSpawner
@onready var hitbox_component = $HitboxComponent as HitboxComponent

var dir: Vector2 = Vector2.UP

var bullet_speed: float = 100
var shoot_timer: float = 1.5
var shoot_thres: int = 10
var shoot_counter: int = 0
var spread_deg: float = 10

var time: float = 0
var can_shoot: bool = true
var random_bullet_spread: bool = false
var shoot_at_player: bool = false

var function = GlobalFunction as Global_Function
var player

var drone1_died: bool = false
var drone2_died: bool = false

var current_state

enum State {
	PHASE1,
	PHASE2
}


func _ready():
	randomize()
	current_state = init_state
	global_position = Vector2(270, 90)


func _process(delta):

	player = Global.player
	match current_state:
		State.PHASE1:
			inf_movement(delta)
			check_drone()
			hitbox_component.deactivated(true)
			shoot(shoot_timer, shoot_thres)
			shoot_at_player = true
		State.PHASE2:
			animation_player.play("PHASE2_RESET")
			hitbox_component.activated()
			follow_player(delta)
			shoot_at_player = false
			bullet_speed = 200
			shoot(0.3, INF)
			bullet_spawner.active = true

func check_drone():
	if drone1_died and drone2_died:
		await animation_player.animation_finished
		change_phase()

func follow_player(delta):
	time = fposmod(time + 0.05, 2 * PI)
	global_position.x += cos(time)
	global_position.y += cos(2 * time) * 1.3
	
	if player != null:
		global_position.y = lerp(global_position.y, player.global_position.y, delta)

func inf_movement(delta):
	time = fposmod(time + delta, 2 * PI)
	global_position.x += cos(time) * 0.25
	global_position.y += cos(2 * time) * 0.25

func shoot(shoot_interval, threshold):
	if shoot_counter >= threshold:
		await get_tree().create_timer(2).timeout
		shoot_counter = 0
	elif can_shoot:
		shoot_counter +=1
		
		spawn_bullet(top_gun.global_position, BulletSharpScene)
		spawn_bullet(bot_gun.global_position, BulletSharpScene)
		
		can_shoot = false
		await get_tree().create_timer(shoot_interval).timeout
		can_shoot = true

func spawn_bullet(pos, type):
	
	var bullet = (function.instantiate_scene(type, pos, get_tree().current_scene)
	as Enemy_Bullet)
	
	bullet.speed = bullet_speed
	if random_bullet_spread:
		bullet.velocity = Vector2.LEFT.rotated(deg_to_rad(randf_range(-spread_deg, spread_deg)))
	if shoot_at_player:
		bullet.velocity = get_vector_player(pos)


func get_vector_player(pos):
	if player != null:
		return (player.global_position - pos).normalized()
	else:
		return Vector2.LEFT

func change_phase():
	animation_player.play("change_gun_pos")
	
	var length = animation_player.current_animation_length
	function.screen_shake(length, 1)
	function.freeze_frame(0.7, length - 0.1)
	
	set_process(false)
	await animation_player.animation_finished
	set_process(true)
	
	current_state = State.PHASE2
	random_bullet_spread = false

func _on_health_component_taking_damage():
#	function.flash(self)
	function.flash($Drone)
	function.flash($Drone2)



func _die():
	function.explode_effect(global_position)
	function.freeze_frame(0.5, 1)
	queue_free()

func _on_drone_drone_die():
	animation_player.play("drone1_died")
	drone1_died = true

func _on_drone_2_drone_die():
	animation_player.play("drone2_died")
	drone2_died = true


