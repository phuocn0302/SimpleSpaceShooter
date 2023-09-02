extends Node2D

@export var dash_multipler: float = 2.0

var dash_dur: float = 0.15
var dash_cd: float = 1.0

var can_dash = true
var is_dashing = false
var can_flash = true

@export var player: CharacterBody2D

@onready var GhostPath = preload("res://Scenes/dash_ghost.tscn")

func _ready():
	set_process(false)

func _process(_delta):
	get_input()
	
	if is_dashing:
		spawn_ghost()

func get_input():
	if (Input.is_action_just_pressed("dash") && can_dash):
		dash(player.player_dir, dash_multipler)

func dash(player_dir, speed_multipler):
	var dash_dir = Vector2.RIGHT if player_dir == Vector2.ZERO else player_dir
	player.velocity = dash_dir * player.speed * speed_multipler * get_process_delta_time()
	
	is_dashing = true
	can_dash = false
	player.can_move = false
	player.iframe(dash_dur + player.iframe_dur/2)
	player.flash(dash_dur + player.iframe_dur/2, 0.1)
	
	await get_tree().create_timer(dash_dur).timeout
	is_dashing = false
	player.can_move = true
	await get_tree().create_timer(dash_cd).timeout
	can_dash = true

func spawn_ghost():
	var ghost = GlobalFunction.instantiate_scene(GhostPath, player.global_position, get_tree().current_scene)
	ghost.set_frame(player.get_node("AnimatedSprite2D").get_frame())

func unlock():
	set_process(true)
