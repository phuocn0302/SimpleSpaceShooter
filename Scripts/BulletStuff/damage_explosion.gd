extends Node2D

@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var explode_frame: Array[int] = [1,2]

func _ready():
	randomize()
	
	$Dust.one_shot = true
	$Debris.one_shot = true
	
	hitbox_component.deactive()
	self.rotate(deg_to_rad(randi_range(0,180)))
	animated_sprite_2d.play("default")
	GlobalFunction.screen_shake(0.5)

func _process(_delta):
	if animated_sprite_2d.frame in explode_frame:
		hitbox_component.active()
	else:
		hitbox_component.deactive()

func _on_life_time_timeout():
	queue_free()
