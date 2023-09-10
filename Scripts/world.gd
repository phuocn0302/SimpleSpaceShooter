extends Node2D

var PlayerPath = preload("res://Scenes/Player/player.tscn")
var EnemyPath = preload("res://Scenes/enemy.tscn")

@export var enemy_spawn_rate = 1.0 # Per second
@export var enemy_can_spawn = false
@onready var enemy_container = $EnemyContainer


func _ready():
	GlobalFunction.instantiate_scene(PlayerPath, $PlayerSpawn.global_position, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if enemy_can_spawn:
		spawn_enemy_random()
	if Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func spawn_enemy():
	var spawn_node = $EnemySpawnPos.get_children()
	var spawn_pos = [0,2,4]

	for i in spawn_pos:
		GlobalFunction.instantiate_scene(EnemyPath, spawn_node[i].global_position,enemy_container)
	enemy_can_spawn = false

func spawn_enemy_random():
	var spawn_node = $EnemySpawnPos.get_children()
	var random_spawn = spawn_node[randi()% spawn_node.size()] 

	GlobalFunction.instantiate_scene(EnemyPath, random_spawn.global_position, enemy_container)

	enemy_can_spawn = false
	await get_tree().create_timer(enemy_spawn_rate).timeout
	enemy_can_spawn = true
