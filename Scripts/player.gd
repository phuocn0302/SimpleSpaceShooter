class_name Player
extends CharacterBody2D

var BulletPath = preload("res://Scenes/bullet.tscn")
var ExplosionPath = preload("res://Scenes/explosion.tscn")

@export var speed: float = 150.0
@export var fire_rate: float = 0.1 # Per second
@export var max_hp: int = 3


var iframe_dur: float = 0.6
var dash_dur: float = 0.15
var dash_cd: float = 1.0

var current_hp: int

var can_shoot = true
var can_take_damage = true
var can_deal_contact_damage = true
var can_dash = true
var is_dashing = false
var can_flash = true

@onready var anim_player = $AnimationPlayer
@onready var normal_shoot_pos = $NormalShootPos/ShootSpot
@onready var dash_ghost = preload("res://Scenes/dash_ghost.tscn")
@onready var camera = get_tree().current_scene.get_node("Camera2D")

func _ready():
	current_hp = max_hp
	anim_player.play("spawn")
	iframe(iframe_dur)

func _process(delta):
	$AnimatedSprite2D.play("default")
	
	if (Input.is_action_pressed("shoot")):
		shoot()
	if (current_hp <=0):
		die()
	
	if is_dashing:
		spawn_ghost()

func _physics_process(delta):
	var dir = Input.get_vector("left","right","up","down").normalized()
	if not is_dashing:
		velocity = dir * speed * delta * 60
	
	if (Input.is_action_just_pressed("dash")):
		if can_dash:
			dash(dir)
	
	move_and_slide()

func shoot():
	if can_shoot:
		var bullet = BulletPath.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = normal_shoot_pos.global_position
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func dash(dir: Vector2):
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	velocity = dir * speed * 60 * 2 * get_process_delta_time()
	is_dashing = true
	can_dash = false
	iframe(dash_dur + iframe_dur)
	await get_tree().create_timer(dash_dur).timeout
	flash(iframe_dur, 0.1)
	is_dashing = false
	await get_tree().create_timer(dash_cd).timeout
	can_dash = true

func spawn_ghost():
	var ghost = dash_ghost.instantiate()
	get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.set_frame($AnimatedSprite2D.get_frame())

func iframe(duration):
	can_take_damage = false
	can_deal_contact_damage = false
	await get_tree().create_timer(duration).timeout
	anim_player.play("RESET")
	can_take_damage = true
	can_deal_contact_damage = true

func take_damage(damage):
	if can_take_damage:
		current_hp -= damage
		anim_player.play("hit")
		camera.shake(0.5,1)
		freeze_frame(0.1, 0.3)
		iframe(iframe_dur)

func flash(flash_dur: float, flash_interval: float):
	can_flash = true
	flashing(flash_interval)
	await get_tree().create_timer(flash_dur).timeout
	can_flash = false

func flashing(interval):
	if can_flash:
		$AnimatedSprite2D.material.set_shader_parameter("active", true)
		await get_tree().create_timer(interval).timeout
		$AnimatedSprite2D.material.set_shader_parameter("active", false)
		await get_tree().create_timer(interval).timeout
		flashing(interval)

func freeze_frame(timescale, duration):
	Engine.time_scale = timescale
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	get_tree().current_scene.get_node("Camera2D").shake(0,1)
	queue_free()
	Engine.time_scale = 1.0

func _on_hitbox_area_entered(area):
	if (can_deal_contact_damage) and (area.is_in_group("Enemy")):
		area.die()
		take_damage(1)


