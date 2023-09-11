extends Node2D

var end = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		laser_release()
	print($RayCast2D/Line2D.points[0])
	$RayCast2D/Line2D.points[0] = end

func laser_release():
	$CPUParticles2D.emitting = true
	create_tween().tween_property($RayCast2D,"target_position",Vector2(0,-51),2).set_trans(Tween.TRANS_LINEAR)
	create_tween().tween_property(self,"end",Vector2(0,-51),2).set_trans(Tween.TRANS_LINEAR)
	create_tween().tween_property($RayCast2D/Line2D,"width",2,2).set_trans(Tween.TRANS_LINEAR)
