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
		#ct = 6 for circle
		#ct = 8 for square
	if ct < 8 && enemy_can_spawn:
		add_child(enemy)
		enemy_can_spawn = false
		#0.484 for square swarm
		#0.53 for circle swarm
		await get_tree().create_timer(0.484).timeout
		enemy_can_spawn = true
		enemy.swarm_movement()
		enemy.swarm_dis()
		ct += 1
	if ct >= 8:
		self.global_position.x -= 100 * delta
	print(ct)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
