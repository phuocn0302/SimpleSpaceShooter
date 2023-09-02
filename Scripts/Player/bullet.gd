extends Area2D

var HitparticlePath = preload("res://Scenes/Particles/hitparticle.tscn")

@export var speed: float = 500
@export var damage: int = 1


func _process(delta):
	global_position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("Enemy"): 
		GlobalFunction.instantiate_scene(HitparticlePath, global_position, get_parent())
		area.take_damage(damage)
		queue_free()
