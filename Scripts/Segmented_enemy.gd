class_name Segment_enemy
extends Area2D



var speed = 5.0

var front
@onready var head = $sprite/SegmentHead
@onready var body = $sprite/SegmentBody
@onready var sprite = $sprite
@onready var velocity = Vector2.ZERO
@onready var marker = $Node2D/Marker2D

var can_move: bool = false
var can_follow: bool = false
var stop = false
var is_rotate: bool = true

func _ready():
	pass
func _physics_process(delta):
	if can_move:
		var dir = get_global_mouse_position() - global_position
		var angle = lerp_angle(0,sprite.transform.x.angle_to(dir),0.8)
		sprite.rotate(sign(angle) * min(delta * 5, abs(angle)))
		$Node2D.rotate(sign(angle) * min(delta * 5, abs(angle)))
		$CollisionPolygon2D.rotate(sign(angle) * min(delta * 5, abs(angle)))
		if dir.length() > 8:
			global_position = lerp(global_position,get_global_mouse_position(),speed * delta)
		print(dir.length())
		
	if can_follow:
		follow_front(delta)
	update_segment()
func update_segment():
	if front == null:
		head.visible = true
		body.visible = false
		can_move = true
	else:
		body.visible = true
		head.visible = false
		can_follow = true

func follow_front(delta):
	if front != null:
		var dir =   front.marker.global_position - global_position 
		var angle = lerp_angle(0,sprite.transform.x.angle_to(dir),0.8)
		sprite.rotate(sign(angle) * min(delta * 5, abs(angle)))
		$Node2D.rotate(sign(angle) * min(delta * 5, abs(angle)))
		$CollisionPolygon2D.rotate(sign(angle) * min(delta * 5, abs(angle)))
		if dir.length() > 8:
			global_position = lerp(global_position,front.marker.global_position,speed * 2 * delta)

func die():
	queue_free()


func _on_area_entered(area):
	if front != null && (area == front):
		stop = true
	pass # Replace with function body.


func _on_area_exited(area):
	if front != null && (area == front):
		stop = false
	pass # Replace with function body.

