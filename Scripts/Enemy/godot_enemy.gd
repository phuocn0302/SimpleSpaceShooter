extends BaseEnemy
class_name GodotEnemy

@export var stat_resource: BaseEnemyResource

func _ready():
	self.stat = stat_resource

func _process(_delta):
	$AnimationPlayer.play("vibrate")
	straight_move()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()

func _die():
	GlobalFunction.explode_effect(global_position)
	queue_free()
