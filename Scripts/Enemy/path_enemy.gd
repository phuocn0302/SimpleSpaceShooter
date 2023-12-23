extends BaseEnemy
class_name PathEnemy

@export var stat_resouces: BaseEnemyResource
@export var path: Curve2D

var path_node: Path2D
var path_follow: PathFollow2D

func _ready():
	create_path_node()
	self.stat = stat_resouces
	if path:
		path_follow.progress_ratio = 0

func _process(delta):
	path_follow.progress += stat.speed * delta
	self.global_position = path_follow.global_position

func create_path_node():
	path_node = Path2D.new()
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	
	get_tree().current_scene.add_child.call_deferred(path_node)
	path_node.add_child(path_follow)
	
	path_node.set_deferred("curve", path)
	

func _die():
	GlobalFunction.explode_effect(global_position)
	path_node.queue_free()
	queue_free()
