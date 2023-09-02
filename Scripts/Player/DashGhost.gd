extends AnimatedSprite2D

var ghost_duration: float = 0.5

func _ready():
	var tween:Tween = get_tree().create_tween() #Creates a Tween, as far as I know Tween as a node has been removed

	#Sets transition and ease for all following tweens
	tween.set_trans(Tween.TRANS_QUART) 
	tween.set_ease(Tween.EASE_OUT)

	#Tween to execute, 
	tween.tween_property(self, "modulate:a", 0.0, ghost_duration)

