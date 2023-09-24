extends Node2D

func _ready():
	$GPUParticles2D.one_shot = true

func _on_timer_timeout():
	queue_free()
