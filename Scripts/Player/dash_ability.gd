extends Node2D

var GhostPath = preload("res://Scenes/Player/dash_ghost.tscn")

@export var dash_multipler: float = 2.0
@export var player: CharacterBody2D

var dash_dur: float = 0.15
var dash_cd: float = 1.0

var can_dash = true
var is_dashing: bool = false:
	get: 
		return is_dashing
	set(value):
		is_dashing = value 
		player.can_move = false if value else true
		can_dash = false



func _ready():
	lock()

func _process(_delta):
	if (Input.is_action_just_pressed("dash") && can_dash):
		dash(player.player_dir, dash_multipler)
		
		await get_tree().create_timer(dash_cd + dash_dur).timeout
		can_dash = true
	
	if is_dashing:
		spawn_ghost()

func dash(player_dir, speed_multipler):
	var dash_dir = Vector2.RIGHT if player_dir == Vector2.ZERO else player_dir
	player.velocity = dash_dir * player.speed * speed_multipler * get_physics_process_delta_time()
	
	player.iframe(dash_dur + player.iframe_dur/2)
	
	is_dashing = true
	await get_tree().create_timer(dash_dur).timeout
	is_dashing = false
	
	


func spawn_ghost():
	var ghost = GlobalFunction.instantiate_scene(GhostPath, player.global_position, get_tree().current_scene)
	ghost.set_frame(player.get_node("AnimatedSprite2D").get_frame())

func unlock():
	set_process(true)

func lock():
	set_process(false)
