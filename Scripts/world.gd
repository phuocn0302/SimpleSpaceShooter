extends Node2D

var PlayerPath = preload("res://Scenes/player.tscn")
var EnemyPath = preload("res://Scenes/enemy.tscn")

@export var enemy_spawn_rate = 1.0 # Per second

var enemy_can_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = PlayerPath.instantiate()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy_can_spawn:
		spawn_enemy()

func spawn_enemy():
	var enemy = EnemyPath.instantiate()
	
	var enemy_container = $EnemyContainer
	enemy_container.add_child(enemy)
	
	var spawn_node = $EnemySpawnPos.get_children()
	var random_spawn = spawn_node[randi()% spawn_node.size()] 
	#get_children() returns an array with a reference to each child as elements of the array.
	#my_array.size() returns the number of elements in the array.
	#randi()% integer_number returns a random integer number between 0 and integer_number -1. 
	
	enemy.global_position = random_spawn.global_position 
	
	enemy_can_spawn = false
	await get_tree().create_timer(enemy_spawn_rate).timeout
	enemy_can_spawn = true

