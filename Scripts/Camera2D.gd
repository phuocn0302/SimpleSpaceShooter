extends Camera2D

var shake_amount = 0
var default_offset = offset

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalFunction.camera = self
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	offset = Vector2(randi_range(-1,1) * shake_amount, randi_range(-1,1) * shake_amount)

func shake(shake_time, amount):
	shake_amount = amount
	set_process(true)
	await get_tree().create_timer(shake_time).timeout
	offset = default_offset
	set_process(false)
