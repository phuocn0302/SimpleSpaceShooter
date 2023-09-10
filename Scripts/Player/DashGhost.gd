extends AnimatedSprite2D

var ghost_duration: float = 0.1
func _ready():
	$Timer.wait_time = ghost_duration
	$Timer.start()

func _on_timer_timeout():
	queue_free()
