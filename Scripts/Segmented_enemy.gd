class_name Segment_enemy
extends Area2D

var BulletPath = preload("res://Scenes/enemy_bullet.tscn")
var ExplosionPath = preload("res://Scenes/explosion.tscn")

var speed = 80.0
var hp = 10
var angle = 0
var front
var behind
var temp

@onready var head = $sprite/SegmentHead
@onready var body = $sprite/SegmentBody
@onready var tail = $sprite/SegmentTail
@onready var sprite = $sprite
@onready var velocity = Vector2.ZERO
@onready var marker = $Node2D/Marker2D
@onready var player = get_parent().get_parent().get_node("Player")
@onready var tail_hitbox = $Tail_hitbox
@onready var head_hitbox = $Head_hitbox
@onready var body_hitbox = $Body_hitbox

var can_move: bool = false
var can_follow: bool = false
var on_screen = false
var can_shoot: bool = false
var change_dir: bool = true

func _ready():
	await  get_tree().create_timer(4).timeout
	can_shoot = true
func _physics_process(delta):
	
	if can_move:
		if !on_screen && get_parent().get_parent().has_node("Player"):
			var dir =   player.global_position - global_position 
			var angle = lerp_angle(0,sprite.transform.x.angle_to(dir),0.8)
			sprite.rotate(sign(angle) * min(delta * 4, abs(angle)))
			$Node2D.rotate(sign(angle) * min(delta * 4, abs(angle)))
			head_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
			global_position += global_position.direction_to(player.global_position) * speed * delta
		else:
			global_position += global_position.direction_to(get_node("Node2D/RayCast2D").global_position) * speed * delta		
#			if change_dir:
#				var a = [1,2,3,4,5,6]
#				temp = a.pick_random()
#				change_dir = false
#				await get_tree().create_timer(0.5).timeout
#				change_dir = true
#			if temp == 1:
#				var a = [0.2,0.5,0.7,0.1]
#				var a_num = a.pick_random()
#				var angle =  lerp_angle(0,0.5,a_num)
#				sprite.rotate(sign(angle) * min(delta * 4, abs(angle)))
#				$Node2D.rotate(sign(angle) * min(delta * 4, abs(angle)))
#				head_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
#			if temp == 4:
#				var a = [0.2,0.5,0.7,0.1]
#				var a_num = a.pick_random()
#				var angle =  lerp_angle(0,-0.5,a_num)
#				sprite.rotate(sign(angle) * min(delta * 4, abs(angle)))
#				$Node2D.rotate(sign(angle) * min(delta * 4, abs(angle)))
#				head_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
				
				
				
			
	if can_follow:
		follow_front(delta)
	update_segment()
	
func _process(delta):
	if (hp <= 0):
		die()
func update_segment():
	head.visible = false
	body.visible = false
	tail.visible = false
	if front == null:
		head.visible = true
		head_hitbox.disabled = false
		can_move = true
	elif front != null && behind != null:
		body.visible = true
		body_hitbox.disabled = false
		head_hitbox.disabled = true
		tail_hitbox.disabled = true
		can_follow = true
	else :
		tail.visible = true
		tail_hitbox.disabled = false
		body_hitbox.disabled = true
		head_hitbox.disabled = true
		can_follow = true
func follow_front(delta):
	if front != null:
		var dir =   front.marker.global_position - global_position 
		var angle = lerp_angle(0,sprite.transform.x.angle_to(dir),0.8)
		sprite.rotate(sign(angle) * min(delta * 5, abs(angle)))
		$Node2D.rotate(sign(angle) * min(delta * 5, abs(angle)))
		body_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
		tail_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
		head_hitbox.rotate(sign(angle) * min(delta * 5, abs(angle)))
		if dir.length() > 8:
			global_position = lerp(global_position,front.marker.global_position,6 * delta)
#		shoot()
func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()


func _on_area_entered(area):
	pass # Replace with function body.


func _on_area_exited(area):
	pass # Replace with function body.

func take_damage(damage):
	hp -= damage


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false
	speed = 120


func _on_visible_on_screen_notifier_2d_screen_entered():
	await get_tree().create_timer(randf_range(0.3,0.8)).timeout
	on_screen = true
	speed = 80
	
#func spawn_bullet(bullet_path, marker):
#	var bullet = bullet_path.instantiate()
#	get_parent().add_child(bullet)
#	bullet.global_position = marker.global_position
#	bullet.global_rotation = marker.global_rotation
	
#func shoot():
#	if can_shoot:
#		spawn_bullet(BulletPath,$"Node2D/Gun 1/Shoot pos")
#		spawn_bullet(BulletPath,$"Node2D/Gun 2/Shoot pos")	
#		can_shoot = false
#		await get_tree().create_timer(3).timeout
#		can_shoot = true