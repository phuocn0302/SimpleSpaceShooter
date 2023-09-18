extends Area2D
class_name HitboxComponent

@export var health: HealthComponent
@export var destroy_effect: Resource
@export var damage: float = 1
@export var destroy_on_impact: bool = false

func active():
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)

func deactive(can_deal_damage: bool = false):
	self.set_deferred("monitoring", can_deal_damage)
	self.set_deferred("monitorable", false)

func damaged(value):
	if health:
		health.take_damage(value)

func _on_area_entered(area):
	if area.has_method("damaged"):
		area.damaged(damage)
	if destroy_effect != null:
		GlobalFunction.instantiate_scene(destroy_effect, global_position, get_tree().current_scene)
	if destroy_on_impact:
		get_parent().queue_free()
