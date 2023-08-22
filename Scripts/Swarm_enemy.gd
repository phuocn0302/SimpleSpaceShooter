extends Node2D

var EnemyPath = preload("res://Scenes/enemy.tscn")

var is_spawn = false
var enemy_can_spawn = true
var ct = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var enemy = EnemyPath.instantiate()
	if ct < 6 && enemy_can_spawn:
		add_child(enemy)
		enemy_can_spawn = false
		await get_tree().create_timer(0.4).timeout
		enemy_can_spawn = true
		enemy.swarm_movement()
		ct += 1
	if ct >= 6:
		self.global_position.x -= 10 * delta
	print(ct)
