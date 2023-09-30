extends Camera2D

var shake_amount = 0
var default_offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	offset = default_offset
	Global.camera = self
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	offset = Vector2(randi_range(-1,1) * shake_amount, randi_range(-1,1) * shake_amount)

func shake(shake_time, intensity):
	shake_amount = intensity
	set_process(true)
	await get_tree().create_timer(shake_time).timeout
	offset = default_offset
	set_process(false)
