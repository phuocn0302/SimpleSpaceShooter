extends Node2D
class_name Laser

@export var laser_texture: Texture2D
@export var velocity: Vector2 = Vector2.LEFT
@export var distance: float = 300
@export var laser_width: float = 10
@export var laser_cast_time: float = 0.1
@export var laser_decay_time: float = 0.2
@export var laser_dur: float = 1

@onready var collision = $HitboxComponent/CollisionPolygon2D
@onready var beam_effect = $BeamEffect
@onready var launch_effect = $LaunchEffect

@onready var line = $Line2D

var end_point: Vector2:
	get:
		return end_point
	set(point):
		end_point = point
		line.points = [Vector2.ZERO, point]

func _ready():
	if laser_texture:
		line.texture = laser_texture
		laser_width = laser_texture.get_height()
	
	line.width = 0
	line.points = [Vector2.ZERO, end_point]
	
	self.rotation = velocity.angle()
	set_particle()
	generate_hitbox()
	shoot()

func shoot():
	cast()
	await get_tree().create_timer(laser_dur).timeout
	decay()

func cast():
	launch_effect.set_deferred("emitting", true)
	beam_effect.set_deferred("emitting", true)
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "end_point", Vector2(distance, 0), laser_cast_time)
	tween.tween_property(line, "width", laser_width, laser_cast_time)


func decay():
	beam_effect.set_deferred("emitting", false)
	
	$HitboxComponent.deactivated()
	
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 0, laser_decay_time)
	
	await get_tree().create_timer(beam_effect.lifetime).timeout
	queue_free()

func set_particle():
	beam_effect.position.x = distance * 0.5
	beam_effect.set_deferred("amount", distance * 0.25)
	beam_effect.process_material.emission_box_extents = Vector3(distance * 0.5, laser_width, 0)

func generate_hitbox():
	var point: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
	point[0] = Vector2(0, -laser_width/2)
	point[1] = Vector2(distance, -laser_width/2)
	point[2] = Vector2(distance, laser_width/2)
	point[3] = Vector2(0, laser_width/2)
	
	collision.polygon = point

