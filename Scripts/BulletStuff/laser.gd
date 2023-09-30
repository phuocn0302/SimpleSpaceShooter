extends Node2D
class_name Laser

@export var laser_stat = LaserResource

var laser_texture
var velocity
var distance
var laser_width
var laser_cast_time 
var laser_decay_time
var laser_dur

@onready var collision = $HitboxComponent/CollisionPolygon2D
@onready var beam_effect = $Line2D/BeamEffect
@onready var line = $Line2D

var end_point: Vector2:
	get:
		return end_point
	set(point):
		end_point = point
		line.points = [Vector2.ZERO, point]

var camera = Global.camera

func _ready():
	set_process(false)
	apply_stat()
	if laser_texture:
		line.texture = laser_texture
		laser_width = laser_texture.get_height()
	
	line.width = 0
	line.points = [Vector2.ZERO, end_point]
	
	self.rotation = velocity.angle()
	set_particle()
	generate_hitbox()
	shoot()

func apply_stat():
	laser_texture = laser_stat.laser_texture
	velocity = laser_stat.velocity
	distance = laser_stat.distance
	laser_width = laser_stat.laser_width
	laser_cast_time = laser_stat.laser_cast_time
	laser_decay_time = laser_stat.laser_decay_time
	laser_dur = laser_stat.laser_dur

## Overwrite global shake function, prevent shake cancel out by player or another object
func _process(_delta):
	if camera:
		camera.offset = Vector2(randi_range(-1,1), randi_range(-1,1))

func shoot():
	set_process(true)
	cast()
	await get_tree().create_timer(laser_dur).timeout
	decay()

func cast():
	beam_effect.set_deferred("emitting", true)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "end_point", Vector2(distance, 0), laser_cast_time)
	tween.tween_property(line, "width", laser_width, laser_cast_time)

func decay():
	set_process(false)
	$HitboxComponent.deactivated()
	
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 0, laser_decay_time)
	
	beam_effect.set_deferred("emitting", false)
	await get_tree().create_timer(beam_effect.lifetime).timeout
	queue_free()

func set_particle():
	beam_effect.position.x = distance * 0.5
	beam_effect.set_deferred("amount", distance)
	beam_effect.process_material.emission_box_extents = Vector3(distance * 0.5, laser_width * 0.5, 0)


func generate_hitbox():
	var point: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
	point[0] = Vector2(0, -laser_width/2)
	point[1] = Vector2(distance, -laser_width/2)
	point[2] = Vector2(distance, laser_width/2)
	point[3] = Vector2(0, laser_width/2)
	
	collision.polygon = point

