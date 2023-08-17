extends Area2D

var HitparticlePath = preload("res://Scenes/hitparticle.tscn")

@export var speed = 600


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	var hit_particle = HitparticlePath.instantiate()
	get_parent().add_child(hit_particle)
	hit_particle.global_position = global_position
	queue_free()
