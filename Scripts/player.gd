extends CharacterBody2D

var BulletPath = preload("res://Scenes/bullet.tscn")

@export var speed = 300.0
@export var fire_rate = 0.1 # Per second

var can_shoot = true

@onready var shootTimer = $ShootInterval

func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
		shoot()
	

func _physics_process(delta):
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	velocity = dir * speed
	move_and_slide()

func shoot():
	if can_shoot:
		var bullet = BulletPath.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = $ShootSpot.global_position
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func _on_hitbox_area_entered(area):
	queue_free()
