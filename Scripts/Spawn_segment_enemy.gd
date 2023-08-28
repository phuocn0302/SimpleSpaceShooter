extends Node2D

var curpos = self.position
var length = 8
var spawn_time = 0.1
var EnemyPath = preload("res://Scenes/Segmented_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	var prespawnsegment: Segment_enemy = null
	for i in range(0,length):
		await get_tree().create_timer(spawn_time).timeout
		var enemy = EnemyPath.instantiate()
		enemy.front = prespawnsegment
		prespawnsegment = enemy
		add_child(enemy)
