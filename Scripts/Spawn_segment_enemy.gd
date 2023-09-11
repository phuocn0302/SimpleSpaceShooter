extends Node2D

var curpos = self.position
var length = 15              
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
	var postspawnsegment: Segment_enemy = null
	for i in range(0,length):
		await get_tree().create_timer(spawn_time).timeout
		var enemy = EnemyPath.instantiate()
		if prespawnsegment != null:
			prespawnsegment.behind = enemy
		enemy.front = prespawnsegment
		enemy.behind = postspawnsegment
		prespawnsegment = enemy
		add_child(enemy)
		if(enemy.front == null):
			var angle = randf_range(-PI,PI)
			enemy.sprite.rotate(angle)
			enemy.get_node("Node2D").rotate(angle)
			enemy.get_node("CollisionPolygon2D").rotate(angle)
