extends Node2D

@onready var rc = $RayCast2D
var end = Vector2.ZERO
var front = Vector2.ZERO
var is_charging: bool = true
var warning = Vector2.ZERO
@onready var player = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if is_charging:
		$Sprite2D.look_at(player.global_position)
		$RayCast2D/Line2D2.visible = false
		rc.target_position = player.global_position * 50
		warning = rc.target_position
		$RayCast2D/Line2D2.points[1] = warning
		await get_tree().create_timer(0.5).timeout
		$RayCast2D/Line2D2.visible = false
		is_charging = false
		await get_tree().create_timer(0.1).timeout
		laser_release()
	
	$RayCast2D/Line2D.points[1] = front
	$RayCast2D/Line2D.points[0] = end
	
func laser_release():
	var temp = rc.target_position
	$CPUParticles2D.emitting = true
	create_tween().tween_property($RayCast2D/Line2D,"width",15,0.1).set_trans(Tween.TRANS_LINEAR)
	create_tween().tween_property(self,"front",temp,0.1).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(0.5).timeout
	#create_tween().tween_property(self,"end",front,0.5).set_trans(Tween.TRANS_LINEAR)
	create_tween().tween_property($RayCast2D/Line2D,"width",0,0.1).set_trans(Tween.TRANS_LINEAR)
	$CPUParticles2D.emitting = false	
	await get_tree().create_timer(0.5).timeout
	end = Vector2.ZERO
	front = Vector2.ZERO
	is_charging = true
